import 'package:equatable/equatable.dart';

class SearchResult extends Equatable {
  final String title;
  final String url;
  final String description;
  final String? favicon;
  final String? type;
  final String? thumbnail;

  const SearchResult({
    required this.title,
    required this.url,
    required this.description,
    this.favicon,
    this.type,
    this.thumbnail,
  });

  @override
  List<Object?> get props => [
        title,
        url,
        description,
        favicon,
        type,
        thumbnail,
      ];
}