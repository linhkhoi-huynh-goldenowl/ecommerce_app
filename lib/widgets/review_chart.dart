import 'package:e_commerce_shop_app/config/styles/text_style.dart';
import 'package:flutter/material.dart';

class ReviewChart extends StatelessWidget {
  const ReviewChart(
      {Key? key,
      required this.totalReviews,
      required this.avgReviews,
      required this.reviewCount,
      required this.reviewPercent})
      : super(key: key);
  final int totalReviews;
  final double avgReviews;
  final List<int> reviewCount;
  final List<double> reviewPercent;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _reviewInfo(totalReviews, avgReviews),
        _reviewChart(reviewCount, reviewPercent, context),
        _reviewNum(reviewCount)
      ],
    );
  }
}

Widget _reviewInfo(int totalReviews, double avgReviews) {
  return Column(
    children: [
      Text(
        avgReviews.isNaN ? "0" : avgReviews.toStringAsFixed(1),
        style: ETextStyle.metropolis(fontSize: 44, weight: FontWeight.w600),
      ),
      const SizedBox(
        height: 16,
      ),
      Text(
        "$totalReviews ratings",
        style:
            ETextStyle.metropolis(fontSize: 14, color: const Color(0xff9B9B9B)),
      )
    ],
  );
}

Widget _reviewChart(
    List<int> reviewCount, List<double> reviewPercent, BuildContext context) {
  return Row(
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _row5star(),
          _row4star(),
          _row3star(),
          _row2star(),
          _row1star()
        ],
      ),
      const SizedBox(
        width: 11,
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _chartBar(reviewPercent[4], context),
          _chartBar(reviewPercent[3], context),
          _chartBar(reviewPercent[2], context),
          _chartBar(reviewPercent[1], context),
          _chartBar(reviewPercent[0], context)
        ],
      )
    ],
  );
}

Widget _reviewNum(List<int> reviewCount) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Text(
          reviewCount[4].toString(),
          style: ETextStyle.metropolis(
              fontSize: 14, color: const Color(0xff4F4F4F)),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Text(
          reviewCount[3].toString(),
          style: ETextStyle.metropolis(
              fontSize: 14, color: const Color(0xff4F4F4F)),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Text(
          reviewCount[2].toString(),
          style: ETextStyle.metropolis(
              fontSize: 14, color: const Color(0xff4F4F4F)),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Text(
          reviewCount[1].toString(),
          style: ETextStyle.metropolis(
              fontSize: 14, color: const Color(0xff4F4F4F)),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Text(
          reviewCount[0].toString(),
          style: ETextStyle.metropolis(
              fontSize: 14, color: const Color(0xff4F4F4F)),
        ),
      ),
    ],
  );
}

Widget _chartBar(double count, BuildContext context) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 7),
    decoration: BoxDecoration(
        color: const Color(0xffDB3022),
        borderRadius: BorderRadius.circular(20)),
    height: 10,
    width: count > 0
        ? MediaQuery.of(context).size.width * 0.035 * count.toDouble()
        : MediaQuery.of(context).size.width * 0.018,
  );
}

Widget _row5star() {
  return Row(
    children: const [
      Padding(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 1.5),
        child: ImageIcon(
          AssetImage("assets/images/icons/star_fill.png"),
          color: Color(0xffFFBA49),
          size: 16,
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 1.5),
        child: ImageIcon(
          AssetImage("assets/images/icons/star_fill.png"),
          color: Color(0xffFFBA49),
          size: 16,
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 1.5),
        child: ImageIcon(
          AssetImage("assets/images/icons/star_fill.png"),
          color: Color(0xffFFBA49),
          size: 16,
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 1.5),
        child: ImageIcon(
          AssetImage("assets/images/icons/star_fill.png"),
          color: Color(0xffFFBA49),
          size: 16,
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 1.5),
        child: ImageIcon(
          AssetImage("assets/images/icons/star_fill.png"),
          color: Color(0xffFFBA49),
          size: 16,
        ),
      ),
    ],
  );
}

Widget _row4star() {
  return Row(
    children: const [
      Padding(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 1.5),
        child: ImageIcon(
          AssetImage("assets/images/icons/star_fill.png"),
          color: Color(0xffFFBA49),
          size: 16,
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 1.5),
        child: ImageIcon(
          AssetImage("assets/images/icons/star_fill.png"),
          color: Color(0xffFFBA49),
          size: 16,
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 1.5),
        child: ImageIcon(
          AssetImage("assets/images/icons/star_fill.png"),
          color: Color(0xffFFBA49),
          size: 16,
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 1.5),
        child: ImageIcon(
          AssetImage("assets/images/icons/star_fill.png"),
          color: Color(0xffFFBA49),
          size: 16,
        ),
      ),
    ],
  );
}

Widget _row3star() {
  return Row(
    children: const [
      Padding(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 1.5),
        child: ImageIcon(
          AssetImage("assets/images/icons/star_fill.png"),
          color: Color(0xffFFBA49),
          size: 16,
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 1.5),
        child: ImageIcon(
          AssetImage("assets/images/icons/star_fill.png"),
          color: Color(0xffFFBA49),
          size: 16,
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 1.5),
        child: ImageIcon(
          AssetImage("assets/images/icons/star_fill.png"),
          color: Color(0xffFFBA49),
          size: 16,
        ),
      ),
    ],
  );
}

Widget _row2star() {
  return Row(
    children: const [
      Padding(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 1.5),
        child: ImageIcon(
          AssetImage("assets/images/icons/star_fill.png"),
          color: Color(0xffFFBA49),
          size: 16,
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 1.5),
        child: ImageIcon(
          AssetImage("assets/images/icons/star_fill.png"),
          color: Color(0xffFFBA49),
          size: 16,
        ),
      ),
    ],
  );
}

Widget _row1star() {
  return const Padding(
    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 1.5),
    child: ImageIcon(
      AssetImage("assets/images/icons/star_fill.png"),
      color: Color(0xffFFBA49),
      size: 16,
    ),
  );
}
