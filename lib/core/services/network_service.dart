import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

/// Service for checking network connectivity
class NetworkService {
  final Connectivity _connectivity;
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  NetworkService({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  /// Check if device has internet connection
  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    return _hasConnection(result);
  }

  /// Stream of connectivity changes
  Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map(_hasConnection);
  }

  /// Check if any connectivity result indicates a connection
  bool _hasConnection(List<ConnectivityResult> results) {
    return results.any((result) =>
        result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi ||
        result == ConnectivityResult.ethernet);
  }

  /// Start listening to connectivity changes
  void startListening(void Function(bool isConnected) onChanged) {
    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      onChanged(_hasConnection(results));
    });
  }

  /// Stop listening to connectivity changes
  void stopListening() {
    _subscription?.cancel();
    _subscription = null;
  }
}
