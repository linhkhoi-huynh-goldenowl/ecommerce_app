import 'package:flutter/material.dart';

import '../config/styles/text_style.dart';

class FlexibleAppBar extends StatelessWidget {
  const FlexibleAppBar({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      var top = constraints.biggest.height;
      return FlexibleSpaceBar(
        titlePadding: EdgeInsets.only(
            left: top < MediaQuery.of(context).size.height * 0.13 ? 0 : 16,
            bottom: top < MediaQuery.of(context).size.height * 0.13 ? 15 : 0),
        centerTitle:
            top < MediaQuery.of(context).size.height * 0.13 ? true : false,
        title: AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: 1,
            child: Text(
              title,
              textAlign: TextAlign.start,
              style: ETextStyle.metropolis(
                  weight: top < MediaQuery.of(context).size.height * 0.13
                      ? FontWeight.w600
                      : FontWeight.w700,
                  fontSize: top < MediaQuery.of(context).size.height * 0.13
                      ? 22
                      : 27),
            )),
      );
    });
  }
}
