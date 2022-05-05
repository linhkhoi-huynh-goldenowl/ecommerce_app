import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ECachedImage extends StatelessWidget {
  const ECachedImage({Key? key, required this.img}) : super(key: key);
  final String img;
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: img,
      fit: BoxFit.cover,
      placeholder: (context, url) => const Center(
        child: CircularProgressIndicator(),
      ),
      errorWidget: (context, url, error) => Image.asset(
        "assets/images/default-img.jpg",
        fit: BoxFit.fill,
        scale: 9,
      ),
    );
  }
}
