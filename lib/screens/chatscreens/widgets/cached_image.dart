import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_us/widgets/custom_loading.dart';
import 'package:flutter/material.dart';

class CachedImage extends StatelessWidget {
  final String imageUrl;
  final bool isRound;
  final double radius;
  final double height;
  final double width;

  final BoxFit fit;

  final String noImageAvailable =
      "https://www.esm.rochester.edu/uploads/NoPhotoAvailable.jpg";

  CachedImage(
    this.imageUrl, {
    this.isRound = false,
    this.radius = 0,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    try {
      return SizedBox(
        height: isRound ? radius : height,
        width: isRound ? radius : width,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(isRound ? radius : 1),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: fit,
              placeholder: (context, url) =>
                  Center(child: CustomCircularLoading()),
              errorWidget: (context, url, error) =>
                  Image.network(noImageAvailable, fit: BoxFit.cover),
            )),
      );
    } catch (e) {
      print(e);
      return Image.network(noImageAvailable, fit: BoxFit.cover);
    }
  }
}
