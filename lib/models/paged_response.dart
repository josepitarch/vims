class PagedResponse<T> {
  int page;
  int limit;
  int? total;
  List<T> results;

  PagedResponse({
    required this.page,
    required this.limit,
    this.total,
    required this.results,
  });

  PagedResponse.origin()
      : page = 1,
        limit = 50,
        total = 0,
        results = [];

  factory PagedResponse.fromMap(Map<String, dynamic> json) => PagedResponse(
        page: json['page'],
        limit: json['limit'],
        total: json['total'],
        results: List<T>.from(json["results"].map((x) => x)),
      );
}
