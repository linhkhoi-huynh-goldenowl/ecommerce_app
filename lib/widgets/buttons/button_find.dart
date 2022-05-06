import 'package:flutter/material.dart';

class ButtonFind extends StatelessWidget {
  const ButtonFind({Key? key, required this.func}) : super(key: key);
  final VoidCallback func;
  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: func, icon: Image.asset('assets/images/icons/find.png'));
  }
}
