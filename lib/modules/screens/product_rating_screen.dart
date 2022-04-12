import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_app/config/styles/text_style.dart';
import 'package:e_commerce_app/modules/cubit/review/review_cubit.dart';
import 'package:e_commerce_app/modules/models/review_model.dart';
import 'package:e_commerce_app/utils/helpers/review_helpers.dart';
import 'package:e_commerce_app/widgets/review_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../widgets/star_bar.dart';

class ProductRatingScreen extends StatelessWidget {
  const ProductRatingScreen({Key? key, required this.productId})
      : super(key: key);
  final String productId;
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ReviewCubit>(
        create: (BuildContext context) => ReviewCubit(productId: productId),
        child: BlocBuilder<ReviewCubit, ReviewState>(
            buildWhen: (previous, current) => previous.status != current.status,
            builder: (context, state) {
              switch (state.status) {
                case ReviewStatus.loading:
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                case ReviewStatus.success:
                  return Scaffold(
                    appBar: AppBar(
                      elevation: 0,
                      backgroundColor: const Color(0xffF9F9F9),
                      leading: _leadingButton(context),
                    ),
                    body: ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16, top: 34),
                          child: Text(
                            "Rating&Reviews",
                            style: ETextStyle.metropolis(
                                fontSize: 34, weight: FontWeight.w700),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16, right: 32, top: 44),
                          child: ReviewChart(
                              totalReviews: state.totalReviews,
                              avgReviews: state.avgReviews,
                              reviewCount: state.reviewCount,
                              reviewPercent: state.reviewPercent),
                        ),
                        _reviewBar(state.totalReviews, state.withPhoto,
                            context.read<ReviewCubit>().changeWithImageSelect),
                        const SizedBox(
                          height: 20,
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          itemBuilder: (context, index) {
                            bool wasLike = ReviewHelper.checkLike(
                                state.reviews[index].like, state.userId);

                            return _reviewComment(
                              state.reviews[index],
                              wasLike,
                              () => context
                                  .read<ReviewCubit>()
                                  .likeReview(state.reviews[index]),
                            );
                          },
                          itemCount: state.reviews.length,
                        )
                      ],
                    ),
                  );
                case ReviewStatus.failure:
                  return const Scaffold(
                    body: Center(
                      child: Text("Failure"),
                    ),
                  );
                case ReviewStatus.initial:
                  return const Scaffold(
                    body: Center(
                      child: Text("No reviews"),
                    ),
                  );
              }
            }));
  }
}

Widget _leadingButton(BuildContext context) {
  return IconButton(
    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
    onPressed: () {
      Navigator.pop(context);
    },
  );
}

Widget _reviewBar(int numReviews, bool withImage, VoidCallback func) {
  return Padding(
    padding: const EdgeInsets.only(left: 16, right: 16, top: 35),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "$numReviews reviews",
          style: ETextStyle.metropolis(fontSize: 24, weight: FontWeight.w600),
        ),
        Row(
          children: [
            Transform.scale(
              scale: 1.5,
              child: Checkbox(
                checkColor: Colors.white,
                value: withImage,
                onChanged: (_) {
                  func();
                },
              ),
            ),
            Text(
              "With photo",
              style: ETextStyle.metropolis(fontSize: 14),
            )
          ],
        )
      ],
    ),
  );
}

Widget _reviewComment(
    ReviewModel reviewModel, bool wasLike, VoidCallback func) {
  return Container(
    padding: const EdgeInsets.all(16),
    child: Stack(
      children: [
        Container(
          margin: const EdgeInsets.all(16),
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
                reviewModel.accountName ?? "",
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
                          return Container(
                            width: 104,
                            height: 104,
                            margin: const EdgeInsets.only(right: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                    reviewModel.images[index]),
                                fit: BoxFit.fill,
                              ),
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
              _likeButton(wasLike, func)
            ],
          ),
        ),
        Positioned(
          child: reviewModel.accountAvatar != "" ||
                  reviewModel.accountAvatar != null
              ? CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(
                      reviewModel.accountAvatar ?? ""),
                  radius: 20,
                )
              : const CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(
                      "https://cdn1.vectorstock.com/i/thumb-large/62/60/default-avatar-photo-placeholder-profile-image-vector-21666260.jpg"),
                  radius: 20,
                ),
        )
      ],
    ),
  );
}

Widget _likeButton(bool wasLike, VoidCallback func) {
  return InkWell(
    onTap: wasLike ? () {} : func,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Spacer(),
        Text(
          "Helpful",
          style: ETextStyle.metropolis(
              fontSize: 11,
              color: wasLike ? Colors.blue : const Color(0xff9B9B9B)),
        ),
        const SizedBox(
          width: 9,
        ),
        ImageIcon(
          const AssetImage("assets/images/icons/like.png"),
          color: wasLike ? Colors.blue : const Color(0xff9B9B9B),
          size: 14,
        )
      ],
    ),
  );
}