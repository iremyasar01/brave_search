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
    try {
      // Önce connectivity kontrolü
      final results = await connectivity.checkConnectivity();
      
      // Hiç bağlantı yoksa false döndür
      if (results.contains(ConnectivityResult.none) || results.isEmpty) {
        return false;
      }

      // Bağlantı varsa gerçek internet erişimini kontrol et
      final hasInternet = await internetChecker.hasInternetAccess;
      return hasInternet;
    } catch (e) {
      // Hata durumunda false döndür
      return false;
    }
  }

  @override
  Future<List<ConnectivityResult>> get connectivityResult async {
    try {
      return await connectivity.checkConnectivity();
    } catch (e) {
      return [ConnectivityResult.none];
    }
  }

  @override
  Stream<InternetStatus> get onStatusChange => internetChecker.onStatusChange;
}