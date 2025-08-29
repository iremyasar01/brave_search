// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../data/datasources/remote/brave_search_remote_data_source.dart'
    as _i912;
import '../../data/repositories/search_repository_impl.dart' as _i278;
import '../../domain/repositories/search_repository.dart' as _i475;
import '../../domain/usecases/search_use_case.dart' as _i130;
import '../../presentations/browser/cubit/browser_cubit.dart' as _i594;
import '../../presentations/web/cubit/web_search_cubit.dart' as _i372;
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
  gh.factory<_i594.BrowserCubit>(() => _i594.BrowserCubit());
  gh.singleton<_i361.Dio>(() => registerModule.dio);
  gh.lazySingleton<_i912.BraveSearchRemoteDataSource>(
      () => _i912.BraveSearchRemoteDataSourceImpl(gh<_i361.Dio>()));
  gh.lazySingleton<_i475.SearchRepository>(() =>
      _i278.SearchRepositoryImpl(gh<_i912.BraveSearchRemoteDataSource>()));
  gh.factory<_i130.SearchUseCase>(
      () => _i130.SearchUseCase(gh<_i475.SearchRepository>()));
  gh.factory<_i372.WebSearchCubit>(
      () => _i372.WebSearchCubit(gh<_i130.SearchUseCase>()));
  return getIt;
}

class _$RegisterModule extends _i291.RegisterModule {}
