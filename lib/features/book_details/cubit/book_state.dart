import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:worldofbooks/core/models/books_response_model.dart';

enum BookStateStatus {
  init,
  loading,
  loaded,
  failed,
  noMore,
  searchLoading,
  searchLoaded,
  searchFailed,
  downloading,
  downloaded,
  downloadedFailed,
}

class BookState extends Equatable {
  final BookStateStatus? status;
  final List<Results>? books;
  final List<Results>? filteredBooks;
  final String? genre;
  final int? nextPage;
  final bool noMoreData;
  final String? searchQuery;
  final bool? isWebBrowserLaunched;
  final String? image;

  const BookState({
    this.status,
    this.books,
    this.filteredBooks,
    this.genre,
    this.nextPage,
    this.noMoreData = false,
    this.searchQuery,
    this.isWebBrowserLaunched,
    this.image,
  });

  @override
  List<Object?> get props => [
        status,
        books,
        filteredBooks,
        genre,
        nextPage,
        noMoreData,
        searchQuery,
        isWebBrowserLaunched,
        image,
      ];

  BookState copyWith({
    BookStateStatus? status,
    List<Results>? books,
    List<Results>? filteredBooks,
    String? genre,
    int? nextPage,
    bool? noMoreData,
    String? searchQuery,
    bool? isWebBrowserLaunched,
    String? image,
  }) {
    return BookState(
        status: status ?? this.status,
        books: books ?? this.books,
        filteredBooks: filteredBooks ?? this.filteredBooks,
        genre: genre ?? this.genre,
        nextPage: nextPage ?? this.nextPage,
        noMoreData: noMoreData ?? this.noMoreData,
        searchQuery: searchQuery ?? this.searchQuery,
        isWebBrowserLaunched: isWebBrowserLaunched ?? isWebBrowserLaunched,
        image: image ?? this.image);
  }
}
