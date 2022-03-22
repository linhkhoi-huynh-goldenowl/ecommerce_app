import 'package:flutter/material.dart';

class CategoryButtonChip extends StatelessWidget {
  const CategoryButtonChip(
      {Key? key,
      required this.func,
      required this.title,
      required this.categoryName})
      : super(key: key);
  final VoidCallback func;
  final String title;
  final String categoryName;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8, bottom: 8, top: 8),
      child: ElevatedButton(
        onPressed: func,
        style: ElevatedButton.styleFrom(
          primary: categoryName == title
              ? const Color(0xffffffff)
              : const Color(0xff222222),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
              fontSize: 14,
              fontFamily: "Metropolis",
              color: categoryName == title ? Colors.black : Colors.white),
        ),
      ),
    );
  }
}
