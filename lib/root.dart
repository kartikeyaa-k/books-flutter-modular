import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:worldofbooks/core/repository/books_repository/books_repository.dart';
import 'package:worldofbooks/core/theme/primary_style.dart';
import 'package:worldofbooks/features/book_details/cubit/book_cubit.dart';
import 'package:worldofbooks/features/splash/splash_screen.dart';
import 'package:worldofbooks/locator.dart';

class Root extends StatelessWidget {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BookCubit>(
          create: (_) => BookCubit(
            repository: locator.get<BooksRepository>(),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: primaryAppTheme,
        home: const SplashScreen(),
      ),
    );
  }
}
