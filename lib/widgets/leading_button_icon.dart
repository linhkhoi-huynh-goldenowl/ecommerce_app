import 'package:flutter/material.dart';

class LeadingButtonIcon extends StatelessWidget {
  const LeadingButtonIcon({Key? key, required this.icon, required this.func})
      : super(key: key);
  final IconData icon;
  final VoidCallback func;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, color: Colors.black),
      onPressed: func,
    );
  }
}
