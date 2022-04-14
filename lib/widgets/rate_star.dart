import 'package:flutter/material.dart';

class RateStar extends StatelessWidget {
  const RateStar({Key? key, required this.reviewStars, required this.func})
      : super(key: key);
  final int reviewStars;
  final Function(int) func;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
            onPressed: () {
              func(1);
            },
            icon: reviewStars > 0
                ? const ImageIcon(
                    AssetImage("assets/images/icons/star_fill.png"),
                    color: Color(0xffFFBA49),
                    size: 40,
                  )
                : const ImageIcon(
                    AssetImage("assets/images/icons/star_fill.png"),
                    color: Color(0xff9B9B9B),
                    size: 40,
                  )),
        IconButton(
            onPressed: () {
              func(2);
            },
            icon: reviewStars > 1
                ? const ImageIcon(
                    AssetImage("assets/images/icons/star_fill.png"),
                    color: Color(0xffFFBA49),
                    size: 40,
                  )
                : const ImageIcon(
                    AssetImage("assets/images/icons/star_fill.png"),
                    color: Color(0xff9B9B9B),
                    size: 40,
                  )),
        IconButton(
            onPressed: () {
              func(3);
            },
            icon: reviewStars > 2
                ? const ImageIcon(
                    AssetImage("assets/images/icons/star_fill.png"),
                    color: Color(0xffFFBA49),
                    size: 40,
                  )
                : const ImageIcon(
                    AssetImage("assets/images/icons/star_fill.png"),
                    color: Color(0xff9B9B9B),
                    size: 40,
                  )),
        IconButton(
            onPressed: () {
              func(4);
            },
            icon: reviewStars > 3
                ? const ImageIcon(
                    AssetImage("assets/images/icons/star_fill.png"),
                    color: Color(0xffFFBA49),
                    size: 40,
                  )
                : const ImageIcon(
                    AssetImage("assets/images/icons/star_fill.png"),
                    color: Color(0xff9B9B9B),
                    size: 40,
                  )),
        IconButton(
            onPressed: () {
              func(5);
            },
            icon: reviewStars > 4
                ? const ImageIcon(
                    AssetImage("assets/images/icons/star_fill.png"),
                    color: Color(0xffFFBA49),
                    size: 40,
                  )
                : const ImageIcon(
                    AssetImage("assets/images/icons/star_fill.png"),
                    color: Color(0xff9B9B9B),
                    size: 40,
                  )),
      ],
    );
  }
}
