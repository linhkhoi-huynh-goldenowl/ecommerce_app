import 'package:flutter/material.dart';

class ButtonCircle extends StatelessWidget {
  const ButtonCircle(
      {Key? key,
      required this.func,
      required this.iconPath,
      required this.iconSize,
      required this.iconColor,
      required this.fillColor,
      required this.padding})
      : super(key: key);
  final VoidCallback func;
  final String iconPath;
  final double iconSize;
  final Color iconColor;
  final Color fillColor;
  final double padding;
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: func,
      elevation: 1,
      fillColor: fillColor,
      child: ImageIcon(AssetImage(iconPath), size: iconSize, color: iconColor),
      padding: EdgeInsets.all(padding),
      shape: const CircleBorder(),
    );
  }
}
