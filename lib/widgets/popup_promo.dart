import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_shop_app/config/styles/text_style.dart';
import 'package:e_commerce_shop_app/modules/cubit/cart/cart_cubit.dart';
import 'package:e_commerce_shop_app/modules/cubit/promo/promo_cubit.dart';
import 'package:e_commerce_shop_app/modules/models/promo_model.dart';
import 'package:e_commerce_shop_app/widgets/promo_code_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../utils/helpers/promo_helpers.dart';

class PopupPromo extends StatelessWidget {
  const PopupPromo({Key? key, this.code}) : super(key: key);
  final String? code;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: FractionallySizedBox(
        heightFactor: 0.6,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 14,
            ),
            Center(
              child: Image.asset(
                "assets/images/icons/rectangle.png",
                scale: 3,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            BlocBuilder<PromoCubit, PromoState>(
                buildWhen: (previous, current) =>
                    previous.codeStatus != current.codeStatus,
                builder: (context, state) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        left: 16, top: 16, bottom: 8, right: 16),
                    child: Form(
                      child: PromoCodeField(
                          atCartScreen: false,
                          initValue: code,
                          isValid:
                              state.isValidCodeInput || state.codeInput == "",
                          applyFunc: () {
                            if (state.isValidCodeInput) {
                              context
                                  .read<CartCubit>()
                                  .setPromoToCart(state.codeInput);
                              Navigator.of(context).pop();
                            }
                          },
                          onChange: (value) => context
                              .read<PromoCubit>()
                              .codeInputChanged(value)),
                    ),
                  );
                }),
            Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  "Your Promo Codes",
                  style: ETextStyle.metropolis(weight: FontWeight.w600),
                )),
            Expanded(
              child: BlocBuilder<PromoCubit, PromoState>(
                  buildWhen: (previous, current) =>
                      previous.status != current.status,
                  builder: (context, state) {
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        return _promoItem(state.promos[index], () {
                          context
                              .read<CartCubit>()
                              .setPromoToCart(state.promos[index].id ?? "");
                          Navigator.of(context).pop();
                        });
                      },
                      itemCount: state.promos.length,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}

Widget _promoItem(PromoModel promoModel, VoidCallback func) {
  return Container(
    margin: const EdgeInsets.only(bottom: 16),
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ]),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _showSalePercent(promoModel.backgroundImage, promoModel.salePercent),
        _showTitlePromo(promoModel.name, promoModel.id ?? ""),
        _showApply(
            PromoHelpers.getDaysRemain(promoModel.endDate.toDate()), func)
      ],
    ),
  );
}

Widget _showSalePercent(String backgroundImg, int percent) {
  return Container(
    height: 80,
    width: 80,
    decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
        image: DecorationImage(
            image: CachedNetworkImageProvider(backgroundImg),
            fit: BoxFit.fill)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          percent.toString(),
          style: ETextStyle.metropolis(
              fontSize: 34, weight: FontWeight.w700, color: Colors.white),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "%",
              style: ETextStyle.metropolis(
                  fontSize: 14, weight: FontWeight.w600, color: Colors.white),
            ),
            Text(
              "off",
              style: ETextStyle.metropolis(
                  fontSize: 14, weight: FontWeight.w600, color: Colors.white),
            ),
          ],
        )
      ],
    ),
  );
}

Widget _showTitlePromo(String name, String code) {
  return Expanded(
    child: Padding(
      padding: const EdgeInsets.only(left: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: ETextStyle.metropolis(fontSize: 14, weight: FontWeight.w600),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            code,
            style: ETextStyle.metropolis(fontSize: 11),
          )
        ],
      ),
    ),
  );
}

Widget _showApply(int day, VoidCallback func) {
  return Column(
    children: [
      Text(
        "$day days remaining",
        style:
            ETextStyle.metropolis(color: const Color(0xff9B9B9B), fontSize: 11),
      ),
      _applyButton(func)
    ],
  );
}

Widget _applyButton(VoidCallback func) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 14),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 26),
        primary: const Color(0xffDB3022),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        elevation: 5,
      ),
      onPressed: func,
      child: Text("Apply",
          style: ETextStyle.metropolis(
              fontSize: 11, color: const Color(0xffFFFFFF))),
    ),
  );
}
