import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityProvider extends ChangeNotifier {
  bool _isOnline = true;
  bool get isOnline => _isOnline;

  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _subscription;

  ConnectivityProvider() {
    _init();
    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      _updateState(results.first);
});
  }

  Future<void> _init() async {
    final results = await _connectivity.checkConnectivity();
    _updateState(results.first);
  }

  void _updateState(ConnectivityResult result) {
    _isOnline = result != ConnectivityResult.none;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
