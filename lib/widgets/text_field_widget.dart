import 'package:e_commerce_shop_app/config/styles/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget(
      {Key? key,
      required this.labelText,
      required this.validatorText,
      required this.isValid,
      required this.func,
      this.initValue,
      required this.isPassword,
      this.focusNode,
      this.onTap,
      this.onEditComplete,
      this.readOnly,
      this.inputType,
      this.inputFormatters})
      : super(key: key);
  final String labelText;
  final String validatorText;
  final bool isValid;
  final Function(String) func;
  final VoidCallback? onEditComplete;
  final bool isPassword;
  final FocusNode? focusNode;
  final String? initValue;
  final VoidCallback? onTap;
  final bool? readOnly;
  final TextInputType? inputType;
  final List<TextInputFormatter>? inputFormatters;
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(2),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ]),
        child: TextFormField(
          readOnly: readOnly ?? false,
          onTap: onTap,
          inputFormatters: inputFormatters,
          keyboardType: inputType,
          onEditingComplete: onEditComplete,
          focusNode: focusNode,
          initialValue: initValue,
          obscureText: isPassword ? true : false,
          decoration: InputDecoration(
            suffix: isValid
                ? const ImageIcon(
                    AssetImage("assets/images/icons/check.png"),
                    color: Color(0xff2AA952),
                    size: 14,
                  )
                : const ImageIcon(
                    AssetImage("assets/images/icons/remove.png"),
                    color: Color(0xffF01F0E),
                    size: 14,
                  ),
            border: InputBorder.none,
            labelStyle: ETextStyle.metropolis(color: const Color(0xffbcbcbc)),
            floatingLabelStyle:
                ETextStyle.metropolis(color: const Color(0xffbcbcbc)),
            labelText: labelText,
            fillColor: const Color(0xffbcbcbc),
            hoverColor: const Color(0xffbcbcbc),
            focusColor: const Color(0xffbcbcbc),
          ),
          onChanged: (value) => func(value),
          validator: (value) => isValid ? null : validatorText,
        ));
  }
}
