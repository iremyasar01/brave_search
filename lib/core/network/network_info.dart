import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
  Future<List<ConnectivityResult>> get connectivityResult;
  Stream<InternetStatus> get onStatusChange;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;
  final InternetConnection internetChecker;

  NetworkInfoImpl({
    required this.connectivity,
    required this.internetChecker,
  });

  @override
  Future<bool> get isConnected async {
    final results = await connectivity.checkConnectivity();
    if (results.contains(ConnectivityResult.none)) {
      return false;
    }
    return await internetChecker.hasInternetAccess;
  }

  @override
  Future<List<ConnectivityResult>> get connectivityResult async {
    return await connectivity.checkConnectivity();
  }

  @override
  Stream<InternetStatus> get onStatusChange => internetChecker.onStatusChange;
}
