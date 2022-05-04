import 'package:e_commerce_shop_app/config/styles/text_style.dart';
import 'package:e_commerce_shop_app/modules/cubit/product_detail/product_detail_cubit.dart';
import 'package:e_commerce_shop_app/widgets/button_intro.dart';
import 'package:e_commerce_shop_app/widgets/label_tile_list.dart';
import 'package:flutter/material.dart';

import '../modules/models/size_cloth.dart';
import 'button_choose_size.dart';

class PopupChooseSize extends StatelessWidget {
  const PopupChooseSize(
      {Key? key,
      required this.listSize,
      required this.stateSize,
      required this.chooseSize,
      required this.func,
      required this.selectStatus,
      required this.title})
      : super(key: key);
  final List<SizeCloth> listSize;
  final String stateSize;
  final SizeStatus selectStatus;
  final Function(String) chooseSize;
  final VoidCallback func;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 14,
        ),
        Image.asset(
          "assets/images/icons/rectangle.png",
          scale: 3,
        ),
        const SizedBox(
          height: 16,
        ),
        const Text(
          "Select Size",
          style: TextStyle(
              color: Color(0xff222222),
              fontFamily: "Metropolis",
              fontSize: 18,
              fontWeight: FontWeight.w600),
        ),
        selectStatus == SizeStatus.initial ||
                selectStatus == SizeStatus.selected
            ? const SizedBox(
                height: 33,
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Please Choose Size",
                    style: ETextStyle.metropolis(color: Colors.red),
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
        Wrap(
            runSpacing: 20,
            spacing: 20,
            children: listSize
                .map((e) => ButtonChooseSize(
                    isInStock: e.quantity > 0,
                    func: () {
                      chooseSize(e.size);
                    },
                    title: e.size,
                    chooseSize: stateSize))
                .toList()),
        const SizedBox(
          height: 24,
        ),
        LabelTileListWidget(
            title: "Size info", func: () {}, haveBorderTop: true),
        const SizedBox(
          height: 28,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ButtonIntro(func: func, title: title),
        )
      ],
    );
  }
}
