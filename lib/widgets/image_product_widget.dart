import 'package:flutter/material.dart';

class ImageProductWidget extends StatelessWidget {
  const ImageProductWidget(
      {Key? key,
      required this.imagePath,
      required this.width,
      required this.height,
      required this.radius})
      : super(key: key);
  final String imagePath;
  final double width;
  final double height;
  final double radius;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          image:
              DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover)),
    );
  }
}
