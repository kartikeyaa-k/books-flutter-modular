import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:worldofbooks/core/constants/app_constants.dart';
import 'package:worldofbooks/features/book_details/book_details_screen.dart';
import 'package:worldofbooks/features/home/components/genre_component.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: [
                SvgPicture.asset(
                  'assets/icons/pattern.svg',
                  fit: BoxFit.cover,
                  height: 350,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 128.0,
                    left: 16.0,
                    right: 16.0,
                    bottom: 16.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Gutenberg Project',
                        textAlign: TextAlign.start,
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      Text(
                        kAppDescription,
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Column(
              children: List<Hero>.generate(
                categoryList.length,
                (index) => Hero(
                  tag: categoryList[index],
                  child: GenreComponent(
                    iconPath: categoryIcons[index],
                    genreName: categoryList[index],
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return BookDetailsScreen(
                          genre: categoryList[index],
                        );
                      }));
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 32,
            )
          ],
        ),
      ),
    );
  }
}
