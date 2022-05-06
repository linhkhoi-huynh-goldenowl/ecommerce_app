import 'package:e_commerce_shop_app/widgets/textfields/search_text_field.dart';
import 'package:flutter/material.dart';

import '../../config/styles/text_style.dart';

class FlexibleBarWithSearch extends StatelessWidget {
  const FlexibleBarWithSearch({
    Key? key,
    required this.title,
    required this.isSearch,
    required this.searchInput,
    required this.func,
  }) : super(key: key);
  final String title;
  final bool isSearch;
  final String searchInput;
  final Function func;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      var top = constraints.biggest.height;
      return FlexibleSpaceBar(
        titlePadding: EdgeInsets.only(
            right: 40,
            left: isSearch == false
                ? top < MediaQuery.of(context).size.height * 0.13
                    ? 40
                    : 16
                : 40,
            top: isSearch == false ? 0 : 5,
            bottom: isSearch == false ? 15 : 5),
        centerTitle:
            top < MediaQuery.of(context).size.height * 0.13 ? true : false,
        title: AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: 1,
            child: isSearch == false
                ? Text(
                    title,
                    textAlign: TextAlign.start,
                    style: ETextStyle.metropolis(
                        weight: top < MediaQuery.of(context).size.height * 0.13
                            ? FontWeight.w600
                            : FontWeight.w700,
                        fontSize:
                            top < MediaQuery.of(context).size.height * 0.13
                                ? 22
                                : 25),
                  )
                : SearchTextField(
                    initValue: searchInput,
                    func: func,
                  )),
      );
    });
  }
}
