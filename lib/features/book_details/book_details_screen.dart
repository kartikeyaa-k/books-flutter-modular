import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:worldofbooks/core/models/books_response_model.dart';
import 'package:worldofbooks/core/theme/primary_style.dart';
import 'package:worldofbooks/core/utils/custom_grid/custom_grid_fixed_height.dart';
import 'package:worldofbooks/features/book_details/components/book_component.dart';
import 'package:worldofbooks/features/book_details/cubit/book_cubit.dart';
import 'package:worldofbooks/features/book_details/cubit/book_state.dart';
import 'dart:async';
import 'package:debounce_throttle/debounce_throttle.dart';

class BookDetailsScreen extends StatefulWidget {
  final String genre;
  const BookDetailsScreen({
    super.key,
    required this.genre,
  });

  @override
  State<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen>
    with WidgetsBindingObserver {
  late BookCubit _bookCubit;
  late RefreshController _refreshController;
  late TextEditingController textEditingController;
  late Debouncer debouncer;

  @override
  void initState() {
    debouncer =
        Debouncer<String>(const Duration(milliseconds: 200), initialValue: '');
    _refreshController = RefreshController(initialRefresh: false);
    textEditingController = TextEditingController();
    _bookCubit = BlocProvider.of<BookCubit>(context);
    _bookCubit.getBooksForGenre(genre: widget.genre, loadFromCache: false);

    textEditingController
        .addListener(() => debouncer.value = textEditingController.text);
    debouncer.values.listen((search) {
      if (search.toString() == '') {
        _bookCubit.resetSearchQuery();
      } else {
        _bookCubit.searchBooks(textEditingController.text);
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    debouncer.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _bookCubit.getBooksForGenre(genre: widget.genre, loadFromCache: true);
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          centerTitle: false,
          titleSpacing: 0.0,
          toolbarHeight: width > 600 ? 148 : null,
          title: Transform(
            transform: width > 600
                ? Matrix4.translationValues(width / 4, 48.0, 0.0)
                : Matrix4.translationValues(12.0, 0.0, 0.0),
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Row(
                  children: [
                    InkWell(
                      child: SvgPicture.asset(
                        'assets/icons/back.svg',
                        height: 34,
                        width: 34,
                        fit: BoxFit.scaleDown,
                      ),
                      onTap: () => Navigator.pop(context),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Hero(
                        tag: widget.genre,
                        child: Text(
                          widget.genre,
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium
                              ?.copyWith(letterSpacing: -0.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          elevation: 0.0,
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                color: Colors.white,
                padding: MediaQuery.of(context).size.width > 600
                    ? EdgeInsets.only(
                        left: width / 4,
                        right: width / 4,
                        bottom: 16,
                        top: 16,
                      )
                    : const EdgeInsets.all(16.0),
                child: BlocBuilder<BookCubit, BookState>(
                  builder: (context, state) {
                    return TextField(
                      textAlign: TextAlign.left,
                      textInputAction: TextInputAction.search,
                      controller: textEditingController,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: greyShadeDarkest,
                          ),
                      cursorColor: primaryAppColor,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        hintText: 'Search',
                        hintStyle: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(color: greyShadeMedium, height: 1),
                        border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            borderSide: BorderSide.none),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: primaryAppColor),
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          ),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF0F0F6),
                        focusColor: const Color(0xFFF0F0F6),
                        constraints:
                            BoxConstraints.loose(const Size.fromHeight(40)),
                        prefixIconConstraints:
                            const BoxConstraints.expand(width: 40),
                        prefixIcon: SvgPicture.asset(
                          'assets/icons/search.svg',
                          fit: BoxFit.none,
                        ),
                        suffixIcon: textEditingController.text != ''
                            ? InkWell(
                                child: SvgPicture.asset(
                                  'assets/icons/cancel.svg',
                                  fit: BoxFit.none,
                                ),
                                onTap: () {
                                  textEditingController.clear();
                                  _bookCubit.resetSearchQuery();
                                },
                              )
                            : const SizedBox(),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    var maxHeight = constraints.maxHeight;

                    return BlocConsumer<BookCubit, BookState>(
                        listener: (context, state) {
                      if (state.isWebBrowserLaunched == false) {
                        _showAlertDialog(context);
                      }
                      if (state.status == BookStateStatus.loaded) {
                        _refreshController.refreshCompleted();
                        _refreshController.loadComplete();
                      } else if (state.noMoreData) {
                        _refreshController.loadNoData();
                      }
                    }, builder: (context, state) {
                      if (state.status == BookStateStatus.searchFailed) {
                        return Center(
                            child: Text(
                          'No results found',
                          style: Theme.of(context).textTheme.bodySmall,
                        ));
                      }
                      if (state.status == BookStateStatus.loading) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Center(
                              child: CupertinoActivityIndicator(),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              'Loading',
                              style: Theme.of(context).textTheme.bodySmall,
                            )
                          ],
                        );
                      }
                      if (state.status == BookStateStatus.searchLoading) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Center(
                              child: CupertinoActivityIndicator(),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              'Searching',
                              style: Theme.of(context).textTheme.bodySmall,
                            )
                          ],
                        );
                      }

                      if (state.books != null || state.filteredBooks != null) {
                        return SmartRefresher(
                          enablePullUp: true,
                          controller: _refreshController,
                          header: const WaterDropHeader(
                              waterDropColor: primaryAppColor,
                              idleIcon: Icon(Icons.arrow_downward,
                                  color: secondaryAppColor)),
                          footer: CustomFooter(
                            builder:
                                (BuildContext context, LoadStatus? status) {
                              Widget body;
                              if (status == LoadStatus.idle) {
                                body = Text(
                                  "Pull up load",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(color: greyShadeLight),
                                );
                              } else if (status == LoadStatus.loading) {
                                body = Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Center(
                                      child: CupertinoActivityIndicator(),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      'Loading more books',
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    )
                                  ],
                                );
                              } else if (status == LoadStatus.failed) {
                                body = Text(
                                  "Something went wrong!",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(color: greyShadeLight),
                                );
                              } else if (status == LoadStatus.canLoading) {
                                body = Text(
                                  "Release to load more books",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(color: greyShadeLight),
                                );
                              } else {
                                body = Text(
                                  "You are all caught up ...",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(color: greyShadeLight),
                                );
                              }
                              return SizedBox(
                                height: 60.0,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 16.0),
                                  child: Center(child: body),
                                ),
                              );
                            },
                          ),
                          onLoading: () async {
                            _bookCubit.getMoreBooks();
                          },
                          onRefresh: () async {
                            _bookCubit.getBooksForGenre(
                                genre: widget.genre, loadFromCache: false);
                          },
                          child: GridView.builder(
                            cacheExtent: 500,
                            physics: const BouncingScrollPhysics(),
                            itemCount: state.status ==
                                        BookStateStatus.searchLoaded ||
                                    state.status ==
                                        BookStateStatus.downloading ||
                                    state.status == BookStateStatus.downloaded
                                ? state.filteredBooks?.length
                                : state.books?.length,
                            padding: constraints.maxWidth > 600
                                ? EdgeInsets.only(
                                    left: width / 4,
                                    right: width / 4,
                                    bottom: 16,
                                    top: 16,
                                  )
                                : const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                    vertical: 16.0,
                                  ),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                              crossAxisCount: 3,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 5,
                              height: 240,
                            ),
                            itemBuilder: (context, index) {
                              var book = (state.status ==
                                              BookStateStatus.searchLoaded ||
                                          state.status ==
                                              BookStateStatus.downloading ||
                                          state.status ==
                                              BookStateStatus.downloaded) &&
                                      state.filteredBooks != null
                                  ? state.filteredBooks![index]
                                  : state.books![index];

                              return GestureDetector(
                                child: BookComponent(
                                  title: book.title,
                                  author: book.authors.isNotEmpty
                                      ? book.authors[0].name
                                      : '',
                                  imgURL: book.formats.imageJpeg,
                                ),
                                onTap: () {
                                  Formats formats = book.formats;
                                  _bookCubit.openBook(formats);
                                },
                              );
                            },
                          ),
                        );
                      }

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Center(
                            child: CupertinoActivityIndicator(),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            'Loading',
                            style: Theme.of(context).textTheme.bodySmall,
                          )
                        ],
                      );
                    });
                  },
                ),
              ),
            ],
          ),
        ));
  }

  Future<void> _showAlertDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'No viewable version available',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
