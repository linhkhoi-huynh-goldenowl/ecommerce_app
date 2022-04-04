import 'package:flutter/material.dart';

class SocialButton extends StatelessWidget {
  const SocialButton({Key? key, required this.func, required this.name})
      : super(key: key);
  final VoidCallback func;
  final String name;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: func,
      child: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ], borderRadius: BorderRadius.circular(20), color: Colors.white),
        child: Image.asset("assets/images/$name.png"),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      ),
    );
  }
}
