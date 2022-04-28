import 'package:e_commerce_app/config/styles/text_style.dart';
import 'package:flutter/material.dart';

class ProfileInfoButton extends StatelessWidget {
  const ProfileInfoButton(
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
    return InkWell(
        onTap: func,
        child: Container(
            decoration: const BoxDecoration(
                border: Border.symmetric(
                    horizontal:
                        BorderSide(color: Color(0xff9B9B9B), width: 0.1))),
            width: double.maxFinite,
            padding:
                const EdgeInsets.only(left: 16, bottom: 16, top: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: ETextStyle.metropolis(
                          fontSize: 18, weight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      subTitle,
                      style: ETextStyle.metropolis(
                          fontSize: 11, color: const Color(0xff9B9B9B)),
                    ),
                  ],
                ),
                const ImageIcon(
                  AssetImage("assets/images/icons/next_right.png"),
                  size: 12,
                )
              ],
            )));
  }
}
