import "dart:async";
import "dart:io"; // Added for SocketException
import "package:flutter/material.dart";
import "package:mantrachain_dart_sdk/api.dart" as mantra;
import "package:hnotes/infrastructure/constants.dart";

class TxStatusWidget extends StatefulWidget {
  final String txHash;
  final Duration pollInterval;
  final void Function(bool success)? onComplete;
  final Future<String?> Function(String txHash)? onRebroadcastTransaction;

  const TxStatusWidget({
    super.key,
    required this.txHash,
    this.pollInterval = const Duration(seconds: 3),
    this.onComplete,
    this.onRebroadcastTransaction,
  });

  @override
  State<TxStatusWidget> createState() => _TxStatusWidgetState();
}

class _TxStatusWidgetState extends State<TxStatusWidget> {
  late mantra.ServiceApi _serviceApi;
  Timer? _timer;
  String? _status;
  bool _done = false;
  bool _hasError = false;
  String _errorMessage = "";
  int _retryCount = 0;
  static const int _maxRetries = 3;
  String? _txHash;
  bool _isRebroadcasting = false;

  @override
  void initState() {
    super.initState();
    _serviceApi = mantra.ServiceApi(
      mantra.ApiClient(basePath: chainRestUrl),
    );
    _txHash = widget.txHash; // Store the hash so we can track if it changes

    // Add a 3-second delay before starting to poll
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _startPolling();
      }
    });
  }

  void _startPolling() {
    _timer = Timer.periodic(widget.pollInterval, (_) async {
      await _checkTxStatus();
    });
    _checkTxStatus();
  }

  Future<void> _checkTxStatus() async {
    try {
      final resp = await _serviceApi.getTx(_txHash!);
      if (resp?.txResponse != null) {
        final code = resp!.txResponse!.code;
        setState(() {
          _status = code == 0 ? "Success" : "Failed";
          _hasError = false;
          _done = true;
        });
        _timer?.cancel();
        widget.onComplete?.call(code == 0);
      } else {
        // Transaction not found yet, but API responded
        _retryCount = 0; // Reset retry count on successful API call
      }
    } on SocketException catch (_) {
      // Handle network connectivity issues
      _retryCount++;
      if (_retryCount >= _maxRetries) {
        setState(() {
          _hasError = true;
          _errorMessage = "Network connection error: "
              "Unable to reach the server. "
              "Please check your internet connection.";
        });
        _timer?.cancel();
      }
    } on TimeoutException catch (_) {
      // Handle timeout issues
      _retryCount++;
      if (_retryCount >= _maxRetries) {
        setState(() {
          _hasError = true;
          _errorMessage = "Connection timed out. "
              "The server may be experiencing high load.";
        });
        _timer?.cancel();
      }
    } on mantra.ApiException catch (e) {
      // Handle API-specific errors
      _retryCount++;
      if (_retryCount >= _maxRetries) {
        setState(() {
          _hasError = true;
          if (e.code == 404) {
            _errorMessage = "Transaction not found."
                "Click 'Rebroadcast' to try sending it again.";
          } else {
            _errorMessage = "API error (${e.code}): ${e.message}";
          }
        });
        _timer?.cancel();
      }
    } catch (e) {
      // Catch any other unexpected errors
      _retryCount++;
      if (_retryCount >= _maxRetries) {
        setState(() {
          _hasError = true;
          _errorMessage = "Unexpected error: ${e.toString()}";
        });
        _timer?.cancel(); // Stop polling on persistent errors
      }
      // For fewer than max retries, we'll continue polling
    }
  }

  Future<void> _rebroadcastTransaction() async {
    if (widget.onRebroadcastTransaction == null) {
      // If no rebroadcasting function is provided, just retry checking
      _retryCheck();
      return;
    }

    setState(() {
      _isRebroadcasting = true;
      _errorMessage = "Trying to rebroadcast transaction...";
      _hasError = false;
    });

    try {
      // Call the provided callback to rebroadcast the transaction
      final newTxHash = await widget.onRebroadcastTransaction!(_txHash!);

      if (newTxHash != null) {
        setState(() {
          _isRebroadcasting = false;
          _txHash = newTxHash; // Update to the new transaction hash
          _retryCount = 0;
        });

        _startPolling(); // Start polling with the new hash
      } else {
        // Rebroadcasting failed
        setState(() {
          _isRebroadcasting = false;
          _hasError = true;
          _errorMessage = "Failed to rebroadcast transaction. "
              "Please try again or check your connection.";
        });
      }
    } catch (e) {
      setState(() {
        _isRebroadcasting = false;
        _hasError = true;
        _errorMessage = "Error rebroadcasting transaction: ${e.toString()}";
      });
    }
  }

  void _retryCheck() {
    setState(() {
      _hasError = false;
      _retryCount = 0;
    });
    _startPolling();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_done) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
              _status == "Success"
                  ? Icons.check_circle
                  : Icons.error,
              size: 48,
              color: _status == "Success" ? Colors.green : Colors.red
          ),
          SizedBox(height: 16),
          Text(_status ?? "Unknown", style: TextStyle(fontSize: 18)),
        ],
      );
    }

    if (_hasError) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.warning_amber_rounded, size: 48, color: Colors.orange),
          SizedBox(height: 16),
          Text(_errorMessage,
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center),
          SizedBox(height: 16),
          // Show appropriate action buttons based on error type
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _retryCheck,
                child: Text("Rebroadcast"),
              ),
              if (widget.onRebroadcastTransaction != null &&
                  _errorMessage.contains("Transaction not found"))
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: ElevatedButton(
                    onPressed: _isRebroadcasting ? null : _rebroadcastTransaction,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    child: _isRebroadcasting
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text("Rebroadcasting..."),
                          ],
                        )
                      : Text("Rebroadcast"),
                  ),
                ),
            ],
          ),
        ],
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        CircularProgressIndicator(),
        SizedBox(height: 16),
        Text("Waiting for transaction confirmation..."),
      ],
    );
  }
}
