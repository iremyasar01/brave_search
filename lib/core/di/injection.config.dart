// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart'
    as _i161;

import '../../data/datasources/local/local_data_source.dart' as _i851;
import '../../data/datasources/remote/image_search_remote_data_source.dart'
    as _i709;
import '../../data/datasources/remote/news_search_remote_data_source.dart'
    as _i895;
import '../../data/datasources/remote/video_search_remote_data_source.dart'
    as _i805;
import '../../data/datasources/remote/web_search_remote_data_source.dart'
    as _i930;
import '../../data/repositories/image_search_repository_impl.dart' as _i803;
import '../../data/repositories/local_repository_impl.dart' as _i326;
import '../../data/repositories/news_search_repository_impl.dart' as _i294;
import '../../data/repositories/video_search_repository_impl.dart' as _i208;
import '../../data/repositories/web_search_repository_impl.dart' as _i860;
import '../../domain/repositories/image_search_repository.dart' as _i71;
import '../../domain/repositories/local_repository.dart' as _i144;
import '../../domain/repositories/news_search_repository.dart' as _i838;
import '../../domain/repositories/video_search_repository.dart' as _i949;
import '../../domain/repositories/web_search_repository.dart' as _i79;
import '../../domain/usecases/clean_old_history.dart' as _i348;
import '../../domain/usecases/clear_search_history.dart' as _i70;
import '../../domain/usecases/delete_tab_data.dart' as _i385;
import '../../domain/usecases/get_search_history.dart' as _i888;
import '../../domain/usecases/get_tab_data.dart' as _i528;
import '../../domain/usecases/image_search_use_case.dart' as _i967;
import '../../domain/usecases/news_search_use_case.dart' as _i936;
import '../../domain/usecases/save_search_history.dart' as _i83;
import '../../domain/usecases/save_tab_data.dart' as _i998;
import '../../domain/usecases/video_search_use_case.dart' as _i733;
import '../../domain/usecases/web_search_use_case.dart' as _i109;
import '../../presentations/browser/cubit/browser_cubit.dart' as _i594;
import '../../presentations/history/cubit/history_cubit.dart' as _i559;
import '../../presentations/images/cubit/image_search_cubit.dart' as _i43;
import '../../presentations/news/cubit/news_search_cubit.dart' as _i551;
import '../../presentations/videos/cubit/video_search_cubit.dart' as _i605;
import '../../presentations/web/cubit/web_search_cubit.dart' as _i372;
import '../network/cubit/network_cubit.dart' as _i684;
import '../network/network_info.dart' as _i932;
import 'network_module.dart' as _i567;
import 'register_module.dart' as _i291;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt $initGetIt(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  final registerModule = _$RegisterModule();
  final networkModule = _$NetworkModule();
  gh.singleton<_i361.Dio>(() => registerModule.dio);
  gh.lazySingleton<_i895.Connectivity>(() => networkModule.connectivity);
  gh.lazySingleton<_i161.InternetConnection>(
      () => networkModule.internetChecker);
  gh.lazySingleton<_i932.NetworkInfo>(() => networkModule.networkInfo);
  gh.lazySingleton<_i684.NetworkCubit>(() => networkModule.networkCubit);
  gh.lazySingleton<_i930.WebSearchRemoteDataSource>(
      () => _i930.WebSearchRemoteDataSourceImpl(gh<_i361.Dio>()));
  gh.lazySingleton<_i851.LocalDataSource>(() => _i851.LocalDataSourceImpl());
  gh.lazySingleton<_i144.LocalRepository>(
      () => _i326.LocalRepositoryImpl(gh<_i851.LocalDataSource>()));
  gh.lazySingleton<_i805.VideoSearchRemoteDataSource>(
      () => _i805.VideoSearchRemoteDataSourceImpl(gh<_i361.Dio>()));
  gh.lazySingleton<_i709.ImageSearchRemoteDataSource>(
      () => _i709.ImageSearchRemoteDataSourceImpl(gh<_i361.Dio>()));
  gh.lazySingleton<_i895.NewsSearchRemoteDataSource>(
      () => _i895.NewsSearchRemoteDataSourceImpl(gh<_i361.Dio>()));
  gh.lazySingleton<_i79.WebSearchRepository>(() =>
      _i860.WebSearchRepositoryImpl(gh<_i930.WebSearchRemoteDataSource>()));
  gh.factory<_i998.SaveTabData>(
      () => _i998.SaveTabData(gh<_i144.LocalRepository>()));
  gh.factory<_i385.DeleteTabData>(
      () => _i385.DeleteTabData(gh<_i144.LocalRepository>()));
  gh.factory<_i888.GetSearchHistory>(
      () => _i888.GetSearchHistory(gh<_i144.LocalRepository>()));
  gh.factory<_i70.ClearSearchHistory>(
      () => _i70.ClearSearchHistory(gh<_i144.LocalRepository>()));
  gh.factory<_i83.SaveSearchHistory>(
      () => _i83.SaveSearchHistory(gh<_i144.LocalRepository>()));
  gh.factory<_i528.GetTabData>(
      () => _i528.GetTabData(gh<_i144.LocalRepository>()));
  gh.factory<_i348.CleanOldHistory>(
      () => _i348.CleanOldHistory(gh<_i144.LocalRepository>()));
  gh.factory<_i594.BrowserCubit>(() => _i594.BrowserCubit(
        gh<_i998.SaveTabData>(),
        gh<_i528.GetTabData>(),
        gh<_i385.DeleteTabData>(),
        gh<_i83.SaveSearchHistory>(),
      ));
  gh.factory<_i559.HistoryCubit>(() => _i559.HistoryCubit(
        gh<_i888.GetSearchHistory>(),
        gh<_i70.ClearSearchHistory>(),
      ));
  gh.lazySingleton<_i949.VideoSearchRepository>(() =>
      _i208.VideoSearchRepositoryImpl(gh<_i805.VideoSearchRemoteDataSource>()));
  gh.factory<_i109.WebSearchUseCase>(
      () => _i109.WebSearchUseCase(gh<_i79.WebSearchRepository>()));
  gh.lazySingleton<_i71.ImageSearchRepository>(() =>
      _i803.ImageSearchRepositoryImpl(gh<_i709.ImageSearchRemoteDataSource>()));
  gh.lazySingleton<_i838.NewsSearchRepository>(() =>
      _i294.NewsSearchRepositoryImpl(gh<_i895.NewsSearchRemoteDataSource>()));
  gh.factory<_i936.NewsSearchUseCase>(
      () => _i936.NewsSearchUseCase(gh<_i838.NewsSearchRepository>()));
  gh.factory<_i372.WebSearchCubit>(
      () => _i372.WebSearchCubit(gh<_i109.WebSearchUseCase>()));
  gh.factory<_i967.ImageSearchUseCase>(
      () => _i967.ImageSearchUseCase(gh<_i71.ImageSearchRepository>()));
  gh.factory<_i43.ImageSearchCubit>(
      () => _i43.ImageSearchCubit(gh<_i967.ImageSearchUseCase>()));
  gh.factory<_i733.VideoSearchUseCase>(
      () => _i733.VideoSearchUseCase(gh<_i949.VideoSearchRepository>()));
  gh.factory<_i551.NewsSearchCubit>(
      () => _i551.NewsSearchCubit(gh<_i936.NewsSearchUseCase>()));
  gh.factory<_i605.VideoSearchCubit>(
      () => _i605.VideoSearchCubit(gh<_i733.VideoSearchUseCase>()));
  return getIt;
}

class _$RegisterModule extends _i291.RegisterModule {}

class _$NetworkModule extends _i567.NetworkModule {}
