import "dart:async";
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
          _done = true;
        });
        _timer?.cancel();
        widget.onComplete?.call(code == 0);
      }
    } catch (e) {
      // Still pending, do nothing
    }
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

