import 'package:e_commerce_shop_app/widgets/e_cached_image.dart';
import 'package:flutter/material.dart';

class ImageProductWidget extends StatelessWidget {
  const ImageProductWidget(
      {Key? key,
      required this.imagePath,
      required this.width,
      required this.height,
      required this.radius,
      required this.isGrid})
      : super(key: key);
  final String imagePath;
  final double width;
  final double height;
  final double radius;
  final bool isGrid;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(radius),
            bottomLeft: Radius.circular(radius),
            bottomRight: isGrid ? Radius.circular(radius) : Radius.zero,
            topRight: isGrid ? Radius.circular(radius) : Radius.zero,
          ),
          child: ECachedImage(img: imagePath)),
    );
  }
}
