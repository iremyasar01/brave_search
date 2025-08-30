import 'package:equatable/equatable.dart';

class WebSearchResult extends Equatable {
  final String title;
  final String url;
  final String description;
  final String? favicon;
  final String? language;
  final bool familyFriendly;
  final String? pageAge;
  final WebProfile? profile;
  final WebMetaUrl? metaUrl;
  final WebThumbnail? thumbnail;
  final List<WebCluster>? cluster;

  const WebSearchResult({
    required this.title,
    required this.url,
    required this.description,
    this.favicon,
    this.language,
    this.familyFriendly = true,
    this.pageAge,
    this.profile,
    this.metaUrl,
    this.thumbnail,
    this.cluster,
  });

  @override
  List<Object?> get props => [
        title,
        url,
        description,
        favicon,
        language,
        familyFriendly,
        pageAge,
        profile,
        metaUrl,
        thumbnail,
        cluster,
      ];
}

class WebProfile extends Equatable {
  final String name;
  final String url;
  final String longName;
  final String? img;

  const WebProfile({
    required this.name,
    required this.url,
    required this.longName,
    this.img,
  });

  @override
  List<Object?> get props => [name, url, longName, img];
}

class WebMetaUrl extends Equatable {
  final String scheme;
  final String netloc;
  final String hostname;
  final String favicon;
  final String path;

  const WebMetaUrl({
    required this.scheme,
    required this.netloc,
    required this.hostname,
    required this.favicon,
    required this.path,
  });

  @override
  List<Object?> get props => [scheme, netloc, hostname, favicon, path];
}

class WebThumbnail extends Equatable {
  final String src;
  final String original;
  final bool? logo;

  const WebThumbnail({
    required this.src,
    required this.original,
    this.logo,
  });

  @override
  List<Object?> get props => [src, original, logo];
}

class WebCluster extends Equatable {
  final String title;
  final String url;
  final String description;
  final bool familyFriendly;

  const WebCluster({
    required this.title,
    required this.url,
    required this.description,
    required this.familyFriendly,
  });

  @override
  List<Object?> get props => [title, url, description, familyFriendly];
}