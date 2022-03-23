import 'package:ecommerce_app/config/styles/text_style.dart';
import 'package:flutter/material.dart';

class ReviewStarWidget extends StatelessWidget {
  const ReviewStarWidget(
      {Key? key, required this.reviewStars, required this.numberReviews})
      : super(key: key);
  final int reviewStars;
  final int numberReviews;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        reviewStars > 0
            ? const ImageIcon(
                AssetImage("assets/images/icons/star_fill.png"),
                color: Color(0xffFFBA49),
                size: 13,
              )
            : const ImageIcon(
                AssetImage("assets/images/icons/star_fill.png"),
                color: Color(0xff9B9B9B),
                size: 13,
              ),
        reviewStars > 1
            ? const ImageIcon(
                AssetImage("assets/images/icons/star_fill.png"),
                color: Color(0xffFFBA49),
                size: 13,
              )
            : const ImageIcon(
                AssetImage("assets/images/icons/star_fill.png"),
                color: Color(0xff9B9B9B),
                size: 13,
              ),
        reviewStars > 2
            ? const ImageIcon(
                AssetImage("assets/images/icons/star_fill.png"),
                color: Color(0xffFFBA49),
                size: 13,
              )
            : const ImageIcon(
                AssetImage("assets/images/icons/star_fill.png"),
                color: Color(0xff9B9B9B),
                size: 13,
              ),
        reviewStars > 3
            ? const ImageIcon(
                AssetImage("assets/images/icons/star_fill.png"),
                color: Color(0xffFFBA49),
                size: 13,
              )
            : const ImageIcon(
                AssetImage("assets/images/icons/star_fill.png"),
                color: Color(0xff9B9B9B),
                size: 13,
              ),
        reviewStars > 4
            ? const ImageIcon(
                AssetImage("assets/images/icons/star_fill.png"),
                color: Color(0xffFFBA49),
                size: 13,
              )
            : const ImageIcon(
                AssetImage("assets/images/icons/star_fill.png"),
                color: Color(0xff9B9B9B),
                size: 13,
              ),
        const SizedBox(
          height: 30,
        ),
        Text("($numberReviews)",
            style: ETextStyle.metropolis(
                color: const Color(0xff9B9B9B), fontSize: 13))
      ],
    );
  }
}
