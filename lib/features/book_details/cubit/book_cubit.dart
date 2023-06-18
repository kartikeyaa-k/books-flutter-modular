import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:worldofbooks/core/constants/app_constants.dart';
import 'package:worldofbooks/core/models/books_response_model.dart';
import 'package:worldofbooks/core/repository/books_repository/books_repository.dart';
import 'package:worldofbooks/core/utils/mixins/pagination_mixin.dart';
import 'package:worldofbooks/features/book_details/cubit/book_state.dart';

class BookCubit extends Cubit<BookState> with PaginationMixin {
  final BooksRepository repository;
  BookCubit({
    required this.repository,
  }) : super(const BookState());

  List<Results> books = [];
  int currentPageIndex = 1;
  List<Results> filteredBooks = [];

  Future<void> getBooksForGenre({
    required String genre,
    bool loadFromCache = true,
  }) async {
    try {
      currentPageIndex = 1;
      emit(
        state.copyWith(
          status: BookStateStatus.loading,
          books: books,
          genre: genre,
        ),
      );
      if (loadFromCache && books.isNotEmpty) {
        emit(
          state.copyWith(
            status: BookStateStatus.loaded,
            books: books,
          ),
        );
        return;
      }

      Map<String, dynamic> requestData = {
        "mime_type": appMimeType,
        "topic": genre.toLowerCase(),
        "page": currentPageIndex,
      };
      var res = await repository.getBooks(requestData);

      res.fold((success) {
        books.clear();

        /// Get next page from response
        ///
        int nextPage = parseNextPage(success.next, currentPageIndex);
        currentPageIndex = nextPage;
        books.addAll(success.results);
        emit(
          state.copyWith(
            status: BookStateStatus.loaded,
            books: books,
            nextPage: nextPage,
            genre: genre,
          ),
        );
      }, (error) {});
    } catch (e) {
      ///
    }
  }

  Future<void> getMoreBooks() async {
    try {
      Map<String, dynamic> requestData = {
        "mime_type": appMimeType,
        "topic": state.genre?.toLowerCase(),
        "page": state.nextPage,
      };
      var res = await repository.getBooks(requestData);
      res.fold((success) {
        if (success.results.isEmpty) {
          emit(
            state.copyWith(
              status: BookStateStatus.noMore,
              books: books,
              noMoreData: true,
            ),
          );
          return;
        }

        int nextPage = parseNextPage(success.next, currentPageIndex);
        currentPageIndex = nextPage;
        books.addAll(success.results);
        emit(
          state.copyWith(
            status: BookStateStatus.loaded,
            books: books,
            nextPage: nextPage,
          ),
        );
      }, (error) {});
    } catch (e) {
      ///
    }
  }

  Future<void> searchBooks(String searchQuery) async {
    try {
      if (searchQuery == '') {
        resetSearchQuery();
      }

      emit(
        state.copyWith(
          status: BookStateStatus.searchLoading,
          filteredBooks: [],
          searchQuery: searchQuery,
        ),
      );

      Map<String, dynamic> requestData = {
        "mime_type": appMimeType,
        "topic": state.genre?.toLowerCase(),
        "search": searchQuery,
      };

      var res = await repository.getBooks(
        requestData,
      );

      res.fold((success) {
        if (success.results.isNotEmpty) {
          filteredBooks.clear();
          filteredBooks = success.results;
          emit(
            state.copyWith(
              status: BookStateStatus.searchLoaded,
              filteredBooks: filteredBooks,
            ),
          );
        } else {
          emit(
            state.copyWith(
              status: BookStateStatus.searchFailed,
            ),
          );
        }
      }, (error) {});
    } catch (e) {
      ///
    }
  }

  void resetSearchQuery() {
    emit(
      state.copyWith(
        status: BookStateStatus.loaded,
        books: books,
      ),
    );
    return;
  }

  void openBook(Formats formats) async {
    try {
      emit(state.copyWith(
        isWebBrowserLaunched: true,
      ));
      if (formats.textHtml != '') {
        final Uri url = Uri.parse(formats.textHtml);
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else if (formats.textHtmlCharsetIso88591 != '') {
        final Uri url = Uri.parse(formats.textHtmlCharsetIso88591);
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else if (formats.textHtmlCharsetUsAscii != '') {
        final Uri url = Uri.parse(formats.textHtmlCharsetUsAscii);
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else if (formats.textHtmlCharsetUtf8 != '') {
        final Uri url = Uri.parse(formats.textHtmlCharsetUtf8);
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else if (formats.applicationPdf != '') {
        final Uri url = Uri.parse(formats.applicationPdf);
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else if (formats.textPlain != '') {
        final Uri url = Uri.parse(formats.applicationPdf);
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else if (formats.textPlainCharsetIso88591 != '') {
        final Uri url = Uri.parse(formats.textPlainCharsetIso88591);
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else if (formats.textPlainCharsetUsAscii != '') {
        final Uri url = Uri.parse(formats.textPlainCharsetUsAscii);
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else if (formats.applicationZip != '') {
        final Uri url = Uri.parse(formats.applicationZip);
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else if (formats.applicationZip != '') {
        final Uri url = Uri.parse(formats.applicationZip);

        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        emit(state.copyWith(
          isWebBrowserLaunched: false,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isWebBrowserLaunched: false,
      ));
    }
  }
}
