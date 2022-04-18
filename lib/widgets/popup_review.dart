import 'dart:io';

import 'package:e_commerce_app/config/styles/text_style.dart';
import 'package:e_commerce_app/modules/cubit/product_detail/product_detail_cubit.dart';
import 'package:e_commerce_app/utils/services/image_picker_services.dart';
import 'package:e_commerce_app/widgets/button_intro.dart';
import 'package:e_commerce_app/widgets/rate_star.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../modules/cubit/review/review_cubit.dart';

class PopupReview extends StatelessWidget {
  const PopupReview({Key? key, required this.productId}) : super(key: key);
  final String productId;
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
        heightFactor: 0.7,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          bottomNavigationBar: BottomAppBar(
              child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: BlocConsumer<ReviewCubit, ReviewState>(
                listenWhen: (previous, current) =>
                    previous.addStatus != current.addStatus,
                listener: (context, state) {
                  if (state.addStatus == AddReviewStatus.success) {
                    context.read<ProductDetailCubit>().setReviews(
                        state.avgReviews.ceil(), state.reviews.length);
                    Navigator.pop(context);
                  }
                },
                buildWhen: (previous, current) =>
                    previous.addStatus != current.addStatus ||
                    previous.starStatus != current.starStatus ||
                    previous.contentStatus != current.contentStatus,
                builder: (context, state) {
                  switch (state.addStatus) {
                    case AddReviewStatus.loading:
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    case AddReviewStatus.success:
                      return ButtonIntro(
                          func: () {}, title: "SEND SUCCESSFULLY");
                    case AddReviewStatus.initial:
                      return ButtonIntro(
                          func: () {
                            state.starNum < 1
                                ? context.read<ReviewCubit>().setUnselectStar()
                                : state.reviewContent.isEmpty
                                    ? context
                                        .read<ReviewCubit>()
                                        .setUntypedContent()
                                    : context
                                        .read<ReviewCubit>()
                                        .addReview(productId);
                          },
                          title: "SEND REVIEW");
                    case AddReviewStatus.failure:
                      return ButtonIntro(func: () {}, title: "SEND FAIL");
                  }
                }),
          )),
          body: ListView(
            padding: const EdgeInsets.only(bottom: 100),
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
              Center(
                child: Text(
                  "What is your rate?",
                  style: ETextStyle.metropolis(
                      fontSize: 18, weight: FontWeight.w600),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: BlocBuilder<ReviewCubit, ReviewState>(
                    buildWhen: (previous, current) =>
                        previous.starStatus != current.starStatus,
                    builder: (context, state) {
                      return Column(
                        children: [
                          state.starStatus == StarReviewStatus.initial ||
                                  state.starStatus == StarReviewStatus.selected
                              ? const SizedBox()
                              : Text(
                                  "Please Choose Star",
                                  style:
                                      ETextStyle.metropolis(color: Colors.red),
                                ),
                          RateStar(
                              reviewStars: state.starNum,
                              func: context.read<ReviewCubit>().starChange),
                        ],
                      );
                    }),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 38, bottom: 24, left: 60, right: 60),
                child: Text(
                  "Please share your opinion about the product",
                  textAlign: TextAlign.center,
                  style: ETextStyle.metropolis(
                      fontSize: 18, weight: FontWeight.w600),
                ),
              ),
              BlocBuilder<ReviewCubit, ReviewState>(
                  buildWhen: (previous, current) =>
                      previous.reviewContent.length !=
                          current.reviewContent.length ||
                      previous.contentStatus != current.contentStatus,
                  builder: (context, state) {
                    return Column(
                      children: [
                        state.contentStatus == ContentReviewStatus.initial ||
                                state.contentStatus == ContentReviewStatus.typed
                            ? const SizedBox()
                            : Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Please Type Review",
                                    style: ETextStyle.metropolis(
                                        color: Colors.red),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  )
                                ],
                              ),
                        _contentReview(
                            context.read<ReviewCubit>().contentReviewChanged,
                            state.reviewContent),
                      ],
                    );
                  }),
              const SizedBox(
                height: 40,
              ),
              Container(
                padding: const EdgeInsets.only(left: 16),
                height: 104,
                child: BlocBuilder<ReviewCubit, ReviewState>(
                    buildWhen: (previous, current) =>
                        previous.imageStatus != current.imageStatus,
                    builder: (context, state) {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemBuilder: (context, index) {
                          if (index != state.imageLocalPaths.length) {
                            return _imageReview(state.imageLocalPaths[index],
                                context.read<ReviewCubit>().removeImage);
                          } else if (state.imageLocalPaths.length < 5) {
                            return _addImageButton(context, () {
                              context.read<ReviewCubit>().getImageFromGallery();
                              Navigator.of(context, rootNavigator: true)
                                  .pop(showDialog);
                            }, () {
                              context.read<ReviewCubit>().getImageFromCamera();
                              Navigator.of(context, rootNavigator: true)
                                  .pop(showDialog);
                            });
                          } else {
                            return const SizedBox();
                          }
                        },
                        itemCount: state.imageLocalPaths.length + 1,
                      );
                    }),
              )
            ],
          ),
        ));
  }
}

Widget _contentReview(Function(String) func, String initial) {
  return Container(
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
    margin: const EdgeInsets.symmetric(horizontal: 16),
    padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 19),
    child: TextFormField(
      decoration: const InputDecoration(
        constraints: BoxConstraints(minHeight: 100),
        border: InputBorder.none,
      ),
      initialValue: initial,
      onChanged: (value) => func(value),
      keyboardType: TextInputType.multiline,
      maxLines: null,
    ),
  );
}

Widget _addImageButton(
    BuildContext context, VoidCallback funcGallery, VoidCallback funcCamera) {
  return Container(
    color: Colors.white,
    width: 104,
    height: 104,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          width: 48,
          child: RawMaterialButton(
            fillColor: Colors.red,
            onPressed: () {
              ImagePickerService.showDialogCamera(
                  context, funcGallery, funcCamera);
            },
            elevation: 5,
            child: const Icon(
              Icons.camera_alt,
              color: Colors.white,
            ),
            padding: const EdgeInsets.all(12),
            shape: const CircleBorder(),
          ),
        ),
        Text(
          "Add your photo",
          style: ETextStyle.metropolis(fontSize: 11),
        )
      ],
    ),
  );
}

Widget _imageReview(String path, Function(String) removeImage) {
  return Stack(
    children: [
      Container(
        width: 104,
        height: 104,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: FileImage(
              File(path),
            ),
            fit: BoxFit.fill,
          ),
        ),
      ),
      Positioned(
          top: -5,
          right: 7,
          child: IconButton(
            splashRadius: 15,
            onPressed: () {
              removeImage(path);
            },
            icon: const ImageIcon(AssetImage("assets/images/icons/delete.png"),
                color: Colors.black, size: 14),
          )),
    ],
  );
}
