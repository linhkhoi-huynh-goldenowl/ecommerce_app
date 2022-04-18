import 'package:e_commerce_app/config/styles/text_style.dart';
import 'package:flutter/material.dart';

class PromoCodeField extends StatelessWidget {
  const PromoCodeField(
      {Key? key,
      this.initValue,
      required this.isValid,
      this.readOnly,
      this.onChange,
      this.onTap,
      this.applyFunc,
      this.clearCode,
      required this.atCartScreen})
      : super(key: key);
  final bool isValid;
  final VoidCallback? onTap;
  final VoidCallback? applyFunc;
  final String? initValue;
  final bool? readOnly;
  final Function(String)? onChange;
  final bool atCartScreen;
  final VoidCallback? clearCode;

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
          Column(
            children: [
              TextFormField(
                initialValue: initValue,
                onTap: onTap,
                onChanged: (value) => onChange!(value),
                readOnly: readOnly ?? false,
                validator: (value) => isValid ? null : "Wrong code promo",
                cursorColor: Colors.black,
                decoration: InputDecoration(
                    border: _outlineBorderApp(initValue, atCartScreen),
                    hintText: "Enter your promo code",
                    hintStyle: ETextStyle.metropolis(
                        color: const Color(0xff9B9B9B),
                        fontSize: 14,
                        weight: FontWeight.w500),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 20),
                    focusColor: Colors.white,
                    focusedBorder: _outlineBorderApp(initValue, atCartScreen),
                    enabledBorder: _outlineBorderApp(initValue, atCartScreen),
                    fillColor: Colors.white,
                    filled: true),
              ),
              const SizedBox(
                height: 10,
              ),
              isValid
                  ? const SizedBox()
                  : Text(
                      "Wrong Code Promo",
                      style: ETextStyle.metropolis(
                          color: Colors.red, fontSize: 11),
                    )
            ],
          ),
          atCartScreen
              ? ((initValue != "" && initValue != null)
                  ? Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        splashRadius: 15,
                        onPressed: clearCode,
                        icon: const ImageIcon(
                            AssetImage("assets/images/icons/delete.png"),
                            size: 14),
                      ))
                  : Positioned(
                      top: 0,
                      right: 0,
                      child: SizedBox(
                        width: 48,
                        child: RawMaterialButton(
                          fillColor: Colors.black,
                          onPressed: applyFunc,
                          elevation: 5,
                          child: const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          ),
                          padding: const EdgeInsets.all(12),
                          shape: const CircleBorder(),
                        ),
                      )))
              : Positioned(
                  top: 0,
                  right: 0,
                  child: SizedBox(
                    width: 48,
                    child: RawMaterialButton(
                      fillColor: Colors.black,
                      onPressed: applyFunc,
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

OutlineInputBorder _outlineBorderApp(String? initValue, bool atCartScreen) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.only(
        topLeft: const Radius.circular(15),
        bottomLeft: const Radius.circular(15),
        bottomRight: atCartScreen
            ? (initValue != "" && initValue != null
                ? const Radius.circular(15)
                : const Radius.circular(30))
            : const Radius.circular(30),
        topRight: atCartScreen
            ? (initValue != "" && initValue != null
                ? const Radius.circular(15)
                : const Radius.circular(30))
            : const Radius.circular(30)),
    borderSide: const BorderSide(color: Colors.white, width: 0.0),
  );
}
