import 'package:e_commerce_shop_app/modules/cubit/promo/promo_cubit.dart';
import 'package:e_commerce_shop_app/widgets/buttons/button_leading.dart';
import 'package:e_commerce_shop_app/widgets/appbars/flexible_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/styles/text_style.dart';
import '../../utils/helpers/promo_helpers.dart';
import '../../widgets/e_cached_image.dart';
import '../../widgets/loading_widget.dart';
import '../models/promo_model.dart';

class PromoListScreen extends StatelessWidget {
  const PromoListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PromoCubit>(
      create: (BuildContext context) => PromoCubit(),
      child: Scaffold(
        body: NestedScrollView(
            physics: const BouncingScrollPhysics(),
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                _appBar(),
              ];
            },
            body: _showPromoList()),
      ),
    );
  }

  Widget _showPromoList() {
    return BlocBuilder<PromoCubit, PromoState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return state.status == PromoStatus.loading
              ? const LoadingWidget()
              : state.promos.isEmpty
                  ? const Center(
                      child: Text("No Promo"),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 32),
                      itemBuilder: (context, index) {
                        return _promoItem(state.promos[index]);
                      },
                      itemCount: state.promos.length,
                    );
        });
  }

  Widget _appBar() {
    return const SliverAppBar(
      shadowColor: Colors.white,
      elevation: 5,
      backgroundColor: Color(0xffF9F9F9),
      expandedHeight: 110.0,
      pinned: true,
      stretch: true,
      leading: ButtonLeading(),
      flexibleSpace: FlexibleAppBar(title: "Promo List"),
    );
  }

  Widget _promoItem(PromoModel promoModel) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.only(right: 16),
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
          _showApply(PromoHelpers.getDaysRemain(promoModel.endDate.toDate()))
        ],
      ),
    );
  }

  Widget _showSalePercent(String backgroundImg, int percent) {
    return Stack(
      children: [
        SizedBox(
          height: 80,
          width: 80,
          child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10)),
              child: ECachedImage(img: backgroundImg)),
        ),
        Container(
          height: 80,
          width: 80,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
          ),
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
                        fontSize: 14,
                        weight: FontWeight.w600,
                        color: Colors.white),
                  ),
                  Text(
                    "off",
                    style: ETextStyle.metropolis(
                        fontSize: 14,
                        weight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
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
              style:
                  ETextStyle.metropolis(fontSize: 14, weight: FontWeight.w600),
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

  Widget _showApply(int day) {
    return Text(
      "$day days remaining",
      style:
          ETextStyle.metropolis(color: const Color(0xff9B9B9B), fontSize: 11),
    );
  }
}
