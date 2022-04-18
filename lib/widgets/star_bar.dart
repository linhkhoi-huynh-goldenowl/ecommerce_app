import 'package:flutter/material.dart';

class StarBar extends StatelessWidget {
  const StarBar({Key? key, required this.reviewStars, required this.size})
      : super(key: key);
  final int reviewStars;
  final double size;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        reviewStars > 0
            ? ImageIcon(
                const AssetImage("assets/images/icons/star_fill.png"),
                color: const Color(0xffFFBA49),
                size: size,
              )
            : ImageIcon(
                const AssetImage("assets/images/icons/star_fill.png"),
                color: const Color(0xff9B9B9B),
                size: size,
              ),
        reviewStars > 1
            ? ImageIcon(
                const AssetImage("assets/images/icons/star_fill.png"),
                color: const Color(0xffFFBA49),
                size: size,
              )
            : ImageIcon(
                const AssetImage("assets/images/icons/star_fill.png"),
                color: const Color(0xff9B9B9B),
                size: size,
              ),
        reviewStars > 2
            ? ImageIcon(
                const AssetImage("assets/images/icons/star_fill.png"),
                color: const Color(0xffFFBA49),
                size: size,
              )
            : ImageIcon(
                const AssetImage("assets/images/icons/star_fill.png"),
                color: const Color(0xff9B9B9B),
                size: size,
              ),
        reviewStars > 3
            ? ImageIcon(
                const AssetImage("assets/images/icons/star_fill.png"),
                color: const Color(0xffFFBA49),
                size: size,
              )
            : ImageIcon(
                const AssetImage("assets/images/icons/star_fill.png"),
                color: const Color(0xff9B9B9B),
                size: size,
              ),
        reviewStars > 4
            ? ImageIcon(
                const AssetImage("assets/images/icons/star_fill.png"),
                color: const Color(0xffFFBA49),
                size: size,
              )
            : ImageIcon(
                const AssetImage("assets/images/icons/star_fill.png"),
                color: const Color(0xff9B9B9B),
                size: size,
              ),
      ],
    );
  }
}
