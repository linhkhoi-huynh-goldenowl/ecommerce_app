import 'package:e_commerce_shop_app/config/styles/text_style.dart';
import 'package:flutter/material.dart';

class LabelTileListWidget extends StatelessWidget {
  const LabelTileListWidget(
      {Key? key,
      required this.title,
      required this.func,
      required this.haveBorderTop})
      : super(key: key);
  final String title;
  final VoidCallback func;
  final bool haveBorderTop;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: func,
        child: Container(
            decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(
                        color: const Color(0xff9B9B9B),
                        width: 0.4,
                        style: haveBorderTop
                            ? BorderStyle.solid
                            : BorderStyle.none),
                    bottom: const BorderSide(
                      color: Color(0xff9B9B9B),
                      width: 0.4,
                    ))),
            width: double.maxFinite,
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: ETextStyle.metropolis(),
                ),
                const ImageIcon(
                  AssetImage("assets/images/icons/next_right.png"),
                  size: 8,
                )
              ],
            )));
  }
}
