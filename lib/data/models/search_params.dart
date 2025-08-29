// data/models/search_params.dart
class SearchParams {
  final String query;
  final int count;
  final int offset;

  SearchParams({
    required this.query,
    this.count = 20,
    this.offset = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'q': query,
      'count': count,
      'offset': offset,
    };
  }
}