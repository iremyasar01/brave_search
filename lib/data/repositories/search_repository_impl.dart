/*
import 'package:injectable/injectable.dart';

import '../../domain/entities/search_result.dart';
import '../../domain/repositories/search_repository.dart';
import '../datasources/remote/brave_search_remote_data_source.dart';

@LazySingleton(as: SearchRepository)
class SearchRepositoryImpl implements SearchRepository {
  final BraveSearchRemoteDataSource remoteDataSource;

  SearchRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<SearchResult>> searchWeb(String query, {int page = 1}) {
    return remoteDataSource.searchWeb(query, page: page);
  }

  @override
  Future<List<SearchResult>> searchImages(String query, {int page = 1}) {
    return remoteDataSource.searchImages(query, page: page);
  }

  @override
  Future<List<SearchResult>> searchNews(String query, {int page = 1}) {
    return remoteDataSource.searchNews(query, page: page);
  }

  @override
  Future<List<SearchResult>> searchVideos(String query, {int page = 1}) {
    return remoteDataSource.searchVideos(query, page: page);
  }
}
*/