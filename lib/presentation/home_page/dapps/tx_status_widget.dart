import "dart:async";
import "dart:io"; // Added for SocketException
import "package:flutter/material.dart";
import "package:mantrachain_dart_sdk/api.dart" as mantra;
import "package:hnotes/infrastructure/constants.dart";

class TxStatusWidget extends StatefulWidget {
  final String txHash;
  final Duration pollInterval;
  final void Function(bool success)? onComplete;

  const TxStatusWidget({
    super.key,
    required this.txHash,
    this.pollInterval = const Duration(seconds: 3),
    this.onComplete,
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

  @override
  void initState() {
    super.initState();
    _serviceApi = mantra.ServiceApi(
      mantra.ApiClient(basePath: chainRestUrl),
    );
    _startPolling();
  }

  void _startPolling() {
    _timer = Timer.periodic(widget.pollInterval, (_) async {
      await _checkTxStatus();
    });
    _checkTxStatus();
  }

  Future<void> _checkTxStatus() async {
    try {
      final resp = await _serviceApi.getTx(widget.txHash);
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
            _errorMessage = "Transaction not found. "
                "It may still be processing.";
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
          ElevatedButton(
            onPressed: _retryCheck,
            child: Text("Retry"),
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
