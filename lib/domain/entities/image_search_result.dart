import 'package:equatable/equatable.dart';

class ImageSearchResult extends Equatable {
  final String title;
  final String url;
  final String source;
  final String imageUrl;
  final String thumbnailUrl;
  final int width;
  final int height;
  final String? pageFetched;
  final MetaUrl? metaUrl;

  const ImageSearchResult({
    required this.title,
    required this.url,
    required this.source,
    required this.imageUrl,
    required this.thumbnailUrl,
    required this.width,
    required this.height,
    this.pageFetched,
    this.metaUrl,
  });

  @override
  List<Object?> get props => [
        title,
        url,
        source,
        imageUrl,
        thumbnailUrl,
        width,
        height,
        pageFetched,
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