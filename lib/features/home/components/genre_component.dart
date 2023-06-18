import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class GenreComponent extends StatelessWidget {
  final String genreName;
  final String iconPath;
  final VoidCallback onTap;

  const GenreComponent({
    required this.genreName,
    required this.iconPath,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 16.0,
      ),
      borderOnForeground: true,
      shadowColor: const Color.fromRGBO(211, 209, 238, 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
      elevation: 2,
      child: ListTile(
        leading: SvgPicture.asset(
          iconPath,
          fit: BoxFit.contain,
          height: 30.0,
        ),
        title: Text(
          genreName.toUpperCase(),
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: SvgPicture.asset('assets/icons/next.svg'),
        onTap: onTap,
      ),
    );
  }
}
