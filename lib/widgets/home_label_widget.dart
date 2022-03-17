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
            Text(
              title,
              style: const TextStyle(
                  color: Color(0xff222222),
                  fontFamily: "Metropolis",
                  fontWeight: FontWeight.w800,
                  fontSize: 34),
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              subTitle,
              style: const TextStyle(
                  color: Color(0xff9B9B9B),
                  fontFamily: "Metropolis",
                  fontSize: 11),
            )
          ],
        ),
        const Spacer(),
        TextButton(
            onPressed: func,
            child: const Text(
              "View all",
              style: TextStyle(
                  color: Color(0xff222222),
                  fontFamily: "Metropolis",
                  fontSize: 11),
            ))
      ],
    );
  }
}
