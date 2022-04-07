import 'package:e_commerce_app/config/styles/text_style.dart';
import 'package:flutter/material.dart';

class ReviewStarWidget extends StatelessWidget {
  const ReviewStarWidget(
      {Key? key,
      required this.reviewStars,
      required this.numberReviews,
      required this.size})
      : super(key: key);
  final int reviewStars;
  final int numberReviews;
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
        const SizedBox(
          width: 3,
        ),
        Text("($numberReviews)",
            style: ETextStyle.metropolis(
                color: const Color(0xff9B9B9B), fontSize: size))
      ],
    );
  }
}
