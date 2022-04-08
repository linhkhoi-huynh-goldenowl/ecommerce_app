import 'package:e_commerce_app/config/styles/text_style.dart';
import 'package:flutter/material.dart';

class PromoCodeField extends StatelessWidget {
  const PromoCodeField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(2), boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 0.5,
          blurRadius: 10,
          offset: const Offset(0, 0), // changes position of shadow
        ),
      ]),
      child: Stack(
        alignment: Alignment.center,
        children: [
          TextFormField(
            cursorColor: Colors.black,
            decoration: InputDecoration(
                border: _outlineBorderApp(),
                hintText: "Enter your promo code",
                hintStyle: ETextStyle.metropolis(
                    color: const Color(0xff9B9B9B),
                    fontSize: 14,
                    weight: FontWeight.w500),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                focusColor: Colors.white,
                focusedBorder: _outlineBorderApp(),
                enabledBorder: _outlineBorderApp(),
                fillColor: Colors.white,
                filled: true),
          ),
          Positioned(
              right: 0,
              child: SizedBox(
                width: 48,
                child: RawMaterialButton(
                  fillColor: Colors.black,
                  onPressed: () {},
                  elevation: 5,
                  child: const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.all(12),
                  shape: const CircleBorder(),
                ),
              ))
        ],
      ),
    );
  }
}

OutlineInputBorder _outlineBorderApp() {
  return const OutlineInputBorder(
    borderRadius: BorderRadius.only(
        topLeft: Radius.circular(15),
        bottomLeft: Radius.circular(15),
        bottomRight: Radius.circular(30),
        topRight: Radius.circular(30)),
    borderSide: BorderSide(color: Colors.white, width: 0.0),
  );
}
