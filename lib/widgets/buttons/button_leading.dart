import 'package:flutter/material.dart';

class ButtonLeading extends StatelessWidget {
  const ButtonLeading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }
}
