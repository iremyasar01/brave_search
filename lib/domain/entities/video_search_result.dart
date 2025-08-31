import 'package:equatable/equatable.dart';

class VideoSearchResult extends Equatable {
  final String title;
  final String url;
  final String description;
  final String age;
  final String duration;
  final String creator;
  final String publisher;
  final String thumbnailUrl;
  final int views;
  final MetaUrl? metaUrl;

  const VideoSearchResult({
    required this.title,
    required this.url,
    required this.description,
    required this.age,
    required this.duration,
    required this.creator,
    required this.publisher,
    required this.thumbnailUrl,
    this.views = 0,
    this.metaUrl,
  });

  @override
  List<Object?> get props => [
        title,
        url,
        description,
        age,
        duration,
        creator,
        publisher,
        thumbnailUrl,
        views,
        metaUrl,
      ];
}

class MetaUrl extends Equatable {
  final String scheme;
  final String netloc;
  final String hostname;
  final String favicon;
  final String path;

  const MetaUrl({
    required this.scheme,
    required this.netloc,
    required this.hostname,
    required this.favicon,
    required this.path,
  });

  @override
  List<Object?> get props => [scheme, netloc, hostname, favicon, path];
}