import 'package:flutter/material.dart';

class SearchTextField extends StatelessWidget {
  const SearchTextField({Key? key, required this.initValue, required this.func})
      : super(key: key);
  final String initValue;
  final Function func;
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 40,
        margin: const EdgeInsets.only(left: 40, right: 40, top: 40),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ]),
        child: TextFormField(
          initialValue: initValue,
          decoration: const InputDecoration(
            border: InputBorder.none,
          ),
          onChanged: (value) => func(value),
        ));
  }
}
