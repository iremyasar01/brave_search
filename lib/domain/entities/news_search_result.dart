import 'package:equatable/equatable.dart';

class NewsSearchResult extends Equatable {
  final String title;
  final String url;
  final String description;
  final String age;
  final String pageFetched;
  final NewsMetaUrl? metaUrl;
  final NewsThumbnail thumbnail;

  const NewsSearchResult({
    required this.title,
    required this.url,
    required this.description,
    required this.age,
    required this.pageFetched,
    this.metaUrl,
    required this.thumbnail,
  });

  @override
  List<Object?> get props => [
    title,
    url,
    description,
    age,
    pageFetched,
    metaUrl,
    thumbnail,
  ];
}

class NewsMetaUrl extends Equatable {
  final String scheme;
  final String netloc;
  final String hostname;
  final String favicon;
  final String path;

  const NewsMetaUrl({
    required this.scheme,
    required this.netloc,
    required this.hostname,
    required this.favicon,
    required this.path,
  });

  @override
  List<Object?> get props => [scheme, netloc, hostname, favicon, path];
}

class NewsThumbnail extends Equatable {
  final String src;

  const NewsThumbnail({
    required this.src,
  });

  @override
  List<Object?> get props => [src];
}