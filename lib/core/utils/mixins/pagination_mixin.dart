mixin PaginationMixin {
  int parseNextPage(String next, int currentPageIndex) {
    final uri = Uri.parse(next);
    final queryParameters = uri.queryParameters;
    var page = int.parse(
        queryParameters['[page]'] ?? (currentPageIndex + 1).toString());

    return page;
  }
}
