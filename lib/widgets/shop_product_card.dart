import 'package:e_commerce_app/config/routes/router.dart';
import 'package:e_commerce_app/config/styles/text_style.dart';
import 'package:e_commerce_app/modules/models/product_item.dart';
import 'package:e_commerce_app/utils/services/navigator_services.dart';
import 'package:e_commerce_app/widgets/chip_label.dart';
import 'package:e_commerce_app/widgets/image_product_widget.dart';
import 'package:e_commerce_app/widgets/price_text.dart';
import 'package:e_commerce_app/widgets/review_star_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../dialogs/bottom_sheet_app.dart';
import '../modules/cubit/favorite/favorite_cubit.dart';
import '../modules/repositories/domain.dart';
import 'button_circle.dart';

class ShopProductCard extends StatelessWidget {
  const ShopProductCard({Key? key, required this.productItem})
      : super(key: key);
  final ProductItem productItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: Stack(
        children: [
          Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(NavigationService.navigatorKey.currentContext ??
                          context)
                      .pushNamed(Routes.productDetailsScreen,
                          arguments: productItem);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      ImageProductWidget(
                          imagePath: productItem.images[0],
                          width: 104,
                          height: 104,
                          radius: 20),
                      const SizedBox(
                        width: 5,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(productItem.title,
                              style: ETextStyle.metropolis(
                                  weight: FontWeight.bold)),
                          const SizedBox(
                            height: 7,
                          ),
                          Text(
                            productItem.brandName,
                            style: ETextStyle.metropolis(
                                fontSize: 11, color: const Color(0xff9B9B9B)),
                          ),
                          const SizedBox(
                            height: 9,
                          ),
                          ReviewStarWidget(
                              reviewStars: productItem.reviewStars,
                              numberReviews: productItem.numberReviews,
                              size: 13),
                          const SizedBox(
                            height: 12,
                          ),
                          PriceText(
                            salePercent: productItem.salePercent,
                            price: productItem.colors[0].sizes[0].price,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
          productItem.salePercent != null
              ? Positioned(
                  top: 5,
                  left: 5,
                  child: ChipLabel(
                      title: '-${productItem.salePercent?.toStringAsFixed(0)}%',
                      backgroundColor: const Color(0xffDB3022)),
                )
              : const SizedBox(),
          (productItem.createdDate.month == DateTime.now().month &&
                  productItem.createdDate.year == DateTime.now().year)
              ? Positioned(
                  top: productItem.salePercent == null ? 5 : 40,
                  left: 5,
                  child: const ChipLabel(
                      title: 'NEW', backgroundColor: Color(0xff222222)),
                )
              : const SizedBox(),
          Positioned(
              bottom: 5,
              right: 0,
              child: BlocBuilder<FavoriteCubit, FavoriteState>(
                  buildWhen: (previous, current) =>
                      previous.status != current.status,
                  builder: (context, state) {
                    return ButtonCircle(
                        func: () => BottomSheetApp.showModalFavorite(
                            context, productItem, productItem.colors[0].sizes),
                        iconPath: "assets/images/icons/heart.png",
                        iconSize: 16,
                        iconColor: const Color(0xffDADADA),
                        fillColor: Domain()
                                .favorite
                                .checkContainTitle(productItem.title)
                            ? const Color(0xffDB3022)
                            : Colors.white,
                        padding: 12);
                  }))
        ],
      ),
    );
  }
}
