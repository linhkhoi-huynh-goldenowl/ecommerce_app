import 'package:e_commerce_shop_app/modules/cubit/promo/promo_cubit.dart';
import 'package:e_commerce_shop_app/widgets/buttons/button_leading.dart';
import 'package:e_commerce_shop_app/widgets/appbars/flexible_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/styles/text_style.dart';
import '../../utils/helpers/promo_helpers.dart';
import '../../widgets/e_cached_image.dart';
import '../../widgets/loading_widget.dart';
import '../cubit/cart/cart_cubit.dart';
import '../cubit/navigation/navigation_cubit.dart';
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
                _appBar(context.read<PromoCubit>().changePromoSort),
              ];
            },
            body: _showPromoList()),
      ),
    );
  }

  Widget _showPromoList() {
    return BlocBuilder<PromoCubit, PromoState>(
        buildWhen: (previous, current) =>
            previous.status != current.status ||
            previous.promoListToShow != current.promoListToShow ||
            previous.sort != current.sort,
        builder: (context, state) {
          return state.status == PromoStatus.loading
              ? const LoadingWidget()
              : state.promoListToShow.isEmpty
                  ? const Center(
                      child: Text("No Promo"),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 32),
                      itemBuilder: (context, index) {
                        return _promoItem(state.promoListToShow[index], () {
                          Navigator.of(context).pop();
                          BlocProvider.of<NavigationCubit>(context)
                              .getNavBarItem(NavbarItem.bag);
                          context
                              .read<CartCubit>()
                              .setPromoToCart(state.promos[index]);
                        });
                      },
                      itemCount: state.promoListToShow.length,
                    );
        });
  }

  Widget _appBar(Function sortPromo) {
    return SliverAppBar(
      shadowColor: Colors.white,
      elevation: 5,
      backgroundColor: const Color(0xffF9F9F9),
      expandedHeight: 110.0,
      pinned: true,
      stretch: true,
      leading: const ButtonLeading(),
      actions: [_popupFilter(sortPromo)],
      flexibleSpace: const FlexibleAppBar(title: "Promo List"),
    );
  }

  Widget _popupFilter(Function sortPromo) {
    return BlocBuilder<PromoCubit, PromoState>(
      buildWhen: (previous, current) => previous.sort != current.sort,
      builder: (context, state) {
        return PopupMenuButton<int>(
          offset: const Offset(-40, -30),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          onSelected: (int value) {
            if (value == 1) {
              sortPromo(PromoSort.endDateAsc);
            }
            if (value == 2) {
              sortPromo(PromoSort.endDateDesc);
            }
            if (value == 3) {
              sortPromo(PromoSort.percentAsc);
            }
            if (value == 4) {
              sortPromo(PromoSort.percentDesc);
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  state.sort == PromoSort.endDateAsc
                      ? "Date ▲"
                      : state.sort == PromoSort.endDateDesc
                          ? 'Date ▼'
                          : state.sort == PromoSort.percentAsc
                              ? 'Percent ▲'
                              : 'Percent ▼',
                  style: ETextStyle.metropolis(),
                ),
                const SizedBox(
                  width: 15,
                ),
                const ImageIcon(AssetImage("assets/images/icons/filter.png"),
                    color: Colors.black, size: 18),
              ],
            ),
          ),
          itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
            PopupMenuItem<int>(
              value: 1,
              child: Center(
                child: Text('Sort by end date ascending',
                    style: ETextStyle.metropolis(fontSize: 14)),
              ),
            ),
            const PopupMenuDivider(),
            PopupMenuItem<int>(
              value: 2,
              child: Center(
                child: Text(
                  'Sort by end date descending',
                  style: ETextStyle.metropolis(fontSize: 14),
                ),
              ),
            ),
            const PopupMenuDivider(),
            PopupMenuItem<int>(
              value: 3,
              child: Center(
                child: Text(
                  'Sort by percent ascending',
                  style: ETextStyle.metropolis(fontSize: 14),
                ),
              ),
            ),
            const PopupMenuDivider(),
            PopupMenuItem<int>(
              value: 4,
              child: Center(
                child: Text(
                  'Sort by percent descending',
                  style: ETextStyle.metropolis(fontSize: 14),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _promoItem(PromoModel promoModel, VoidCallback func) {
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
          _showApply(
              PromoHelpers.getDaysRemain(promoModel.endDate.toDate()), func)
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

  Widget _showApply(int day, VoidCallback func) {
    return Column(
      children: [
        Text(
          "$day days remaining",
          style: ETextStyle.metropolis(
              color: const Color(0xff9B9B9B), fontSize: 11),
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
}
