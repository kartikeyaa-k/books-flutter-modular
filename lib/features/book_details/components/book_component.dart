import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_network/image_network.dart';
import 'package:worldofbooks/core/theme/primary_style.dart';

class BookComponent extends StatelessWidget {
  final String title;
  final String author;
  final String imgURL;
  const BookComponent({
    Key? key,
    required this.title,
    required this.author,
    required this.imgURL,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          kIsWeb
              ? ImageNetwork(
                  image: imgURL,
                  width: 134,
                  height: 172,
                  duration: 1500,
                  curve: Curves.easeIn,
                  onPointer: true,
                  debugPrint: false,
                  fullScreen: false,
                  fitAndroidIos: BoxFit.cover,
                  fitWeb: BoxFitWeb.cover,
                  borderRadius: BorderRadius.circular(8.0),
                  onLoading: const CupertinoActivityIndicator(),
                  onError: const Icon(
                    Icons.error,
                    color: Colors.red,
                  ),
                  onTap: () {
                    debugPrint("©gabriel_patrick_souza");
                  },
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  clipBehavior: Clip.antiAlias,
                  child: DecoratedBox(
                    decoration: const BoxDecoration(boxShadow: [
                      BoxShadow(
                          offset: Offset(2, 5),
                          color: Color.fromRGBO(211, 209, 238, 0.5))
                    ]),
                    child: ExtendedImage.network(
                      imgURL,
                      cache: true,
                      loadStateChanged: (state) {
                        switch (state.extendedImageLoadState) {
                          case LoadState.loading:
                            return const CupertinoActivityIndicator();

                          case LoadState.completed:
                            return null;

                          case LoadState.failed:
                            return GestureDetector(
                              child: Stack(
                                fit: StackFit.expand,
                                children: <Widget>[
                                  Container(
                                    color: primaryAppColor.withOpacity(0.3),
                                  ),
                                  Positioned(
                                    bottom: 10.0,
                                    left: 0.0,
                                    right: 0.0,
                                    child: Column(
                                      children: [
                                        Text(
                                          "Server says \n404\n\nClick to retry",
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall
                                              ?.copyWith(
                                                  fontWeight: FontWeight.w400),
                                        ),
                                        const Icon(
                                          Icons.refresh,
                                          color: secondaryAppColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                state.reLoadImage();
                              },
                            );
                        }
                      },
                      fit: BoxFit.fill,
                      width: 150,
                      height: 162,
                    ),
                  ),
                ),
          const SizedBox(
            height: 8.0,
          ),
          Text(
            title.toUpperCase(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  letterSpacing: 0,
                ),
          ),
          const SizedBox(
            height: 4.0,
          ),
          Text(author.toUpperCase(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: greyShadeMedium,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  )),
        ],
      ),
    );
  }
}
