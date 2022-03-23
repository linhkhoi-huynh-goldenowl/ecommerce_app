import 'package:ecommerce_app/config/styles/text_style.dart';
import 'package:flutter/material.dart';

class HomeLabelWidget extends StatelessWidget {
  const HomeLabelWidget(
      {Key? key,
      required this.title,
      required this.subTitle,
      required this.func})
      : super(key: key);
  final String title;
  final String subTitle;
  final VoidCallback func;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: ETextStyle.metropolis(
                    fontSize: 34, weight: FontWeight.w800)),
            const SizedBox(
              height: 4,
            ),
            Text(subTitle,
                style: ETextStyle.metropolis(
                    color: const Color(0xff9B9B9B), fontSize: 11))
          ],
        ),
        const Spacer(),
        TextButton(
            onPressed: func,
            child: Text("View all", style: ETextStyle.metropolis(fontSize: 11)))
      ],
    );
  }
}
