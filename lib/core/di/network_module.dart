import 'package:brave_search/core/di/injection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../network/cubit/network_cubit.dart';
import '../network/network_info.dart';

@module
abstract class NetworkModule {
  @lazySingleton
  Connectivity get connectivity => Connectivity();
  
  @lazySingleton
  InternetConnection get internetChecker => InternetConnection();
  
  @lazySingleton
  NetworkInfo get networkInfo => NetworkInfoImpl(
    connectivity: getIt<Connectivity>(),
    internetChecker: getIt<InternetConnection>(),
  );
  
  @lazySingleton
  NetworkCubit get networkCubit => NetworkCubit(
    networkInfo: getIt<NetworkInfo>(),
  );
}