import 'package:e_commerce_app/config/styles/text_style.dart';
import 'package:flutter/material.dart';

class CategoryTitleButton extends StatelessWidget {
  const CategoryTitleButton({Key? key, required this.title, required this.func})
      : super(key: key);
  final String title;
  final VoidCallback func;
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: func,
        child: Container(
          width: double.maxFinite,
          padding:
              const EdgeInsets.only(left: 40, bottom: 16, top: 16, right: 0),
          child: Text(
            title,
            style: ETextStyle.metropolis(),
          ),
        ));
  }
}
