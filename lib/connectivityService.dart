import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ConnectivityService extends ChangeNotifier {
  final Connectivity _connectivity = Connectivity();
  // теперь StreamSubscription<List<ConnectivityResult>>
  late final StreamSubscription<List<ConnectivityResult>> _subscription;

  bool _hasInternet = false;
  bool get hasInternet => _hasInternet;

  ConnectivityService() {
    // при любом изменении списка сетей будем вызывать _updateConnection
    _subscription =
        _connectivity.onConnectivityChanged.listen(_updateConnection);
    // и сразу проверить текущее состояние
    _connectivity.checkConnectivity().then(_updateConnection);
  }

  Future<void> _updateConnection(List<ConnectivityResult> results) async {
    final wasOnline = _hasInternet;

    // если в списке нет ничего, кроме none — сразу офлайн
    if (results.contains(ConnectivityResult.none)) {
      _hasInternet = false;
    } else {
      // проверяем реальный доступ в интернет
      _hasInternet = await InternetConnectionChecker().hasConnection;
    }

    if (wasOnline != _hasInternet) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
