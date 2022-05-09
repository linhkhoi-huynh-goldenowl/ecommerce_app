import 'package:e_commerce_shop_app/modules/cubit/promo/promo_cubit.dart';
import 'package:e_commerce_shop_app/modules/cubit/reviewUser/review_user_cubit.dart';
import 'package:e_commerce_shop_app/utils/services/navigator_services.dart';
import 'package:e_commerce_shop_app/widgets/e_cached_image.dart';
import 'package:e_commerce_shop_app/widgets/flexible_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../config/routes/router.dart';
import '../../config/styles/text_style.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/star_bar.dart';
import '../models/review_model.dart';

class ReviewListSCreen extends StatelessWidget {
  const ReviewListSCreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ReviewUserCubit>(
      create: (BuildContext context) => ReviewUserCubit(),
      child: Scaffold(
        body: NestedScrollView(
            physics: const BouncingScrollPhysics(),
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  shadowColor: Colors.white,
                  elevation: 5,
                  backgroundColor: const Color(0xffF9F9F9),
                  expandedHeight: 110.0,
                  pinned: true,
                  stretch: true,
                  leading: _leadingButton(context),
                  flexibleSpace: const FlexibleAppBar(title: "Review List"),
                ),
              ];
            },
            body: BlocBuilder<ReviewUserCubit, ReviewUserState>(
                buildWhen: (previous, current) =>
                    previous.status != current.status,
                builder: (context, state) {
                  return state.status == PromoStatus.loading
                      ? const LoadingWidget()
                      : state.reviews.isEmpty
                          ? const Center(
                              child: Text("No Reviews"),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 32),
                              itemBuilder: (context, index) {
                                return _reviewComment(state.reviews[index]);
                              },
                              itemCount: state.reviews.length,
                            );
                })),
      ),
    );
  }
}

Widget _reviewComment(ReviewModel reviewModel) {
  return Container(
    margin: const EdgeInsets.only(bottom: 16),
    padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 24),
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ]),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Product ID: ${reviewModel.productId}",
          style: ETextStyle.metropolis(fontSize: 14),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StarBar(reviewStars: reviewModel.star, size: 14),
            Text(
              DateFormat.yMMMMd('en_US')
                  .format(reviewModel.createdDate!.toDate()),
              style: ETextStyle.metropolis(
                  color: const Color(0xff9B9B9B), fontSize: 11),
            )
          ],
        ),
        const SizedBox(
          height: 17,
        ),
        Text(
          reviewModel.comment,
          style: ETextStyle.metropolis(fontSize: 14),
        ),
        const SizedBox(
          height: 16,
        ),
        reviewModel.images.isNotEmpty
            ? SizedBox(
                height: 104,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => Navigator.of(
                              NavigationService.navigatorKey.currentContext ??
                                  context)
                          .pushNamed(Routes.photoViewScreen, arguments: {
                        'paths': reviewModel.images,
                        'index': index
                      }),
                      child: Container(
                        width: 104,
                        height: 104,
                        margin: const EdgeInsets.only(right: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ECachedImage(img: reviewModel.images[index]),
                      ),
                    );
                  },
                  itemCount: reviewModel.images.length,
                ),
              )
            : const SizedBox(),
        const SizedBox(
          height: 16,
        ),
      ],
    ),
  );
}

Widget _leadingButton(BuildContext context) {
  return IconButton(
    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
    onPressed: () {
      Navigator.pop(context);
    },
  );
}
