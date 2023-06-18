/// A collection of endpoints used for authentication purposes.
enum BooksEndpoint {
  refreshToken,
  getBooks,
}

class BooksEndpointClient {
  static const basePath = '/books';
  static const refreshToken = basePath;
  static const getBooks = basePath;
}
