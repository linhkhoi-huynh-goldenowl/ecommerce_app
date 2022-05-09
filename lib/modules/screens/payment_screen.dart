import 'package:e_commerce_shop_app/dialogs/bottom_sheet_app.dart';
import 'package:e_commerce_shop_app/modules/cubit/creditCard/credit_card_cubit.dart';
import 'package:e_commerce_shop_app/utils/helpers/show_snackbar.dart';
import 'package:e_commerce_shop_app/widgets/buttons/button_leading.dart';
import 'package:flutter/material.dart';

import 'package:e_commerce_shop_app/config/styles/text_style.dart';
import 'package:e_commerce_shop_app/modules/models/credit_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../dialogs/system_dialog.dart';
import '../../widgets/loading_widget.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider<CreditCardCubit>(
        create: (BuildContext context) => CreditCardCubit(),
        child: BlocListener<CreditCardCubit, CreditCardState>(
            listenWhen: (previous, current) =>
                previous.status != current.status,
            listener: (context, state) {
              if (state.status == CreditCardStatus.failure) {
                AppSnackBar.showSnackBar(context, state.errMessage);
              }
            },
            child: Scaffold(
              appBar: _appBar(),
              floatingActionButton: _floatButton(),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _titleListCredit(),
                  _showListCreditCard(),
                ],
              ),
            )));
  }

  AppBar _appBar() {
    return AppBar(
        backgroundColor: const Color(0xffF9F9F9),
        centerTitle: true,
        leading: const ButtonLeading(),
        title: Text(
          "Payment methods",
          style: ETextStyle.metropolis(weight: FontWeight.w600, fontSize: 20),
        ));
  }

  Widget _floatButton() {
    return BlocBuilder<CreditCardCubit, CreditCardState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status == CreditCardStatus.loading
            ? const LoadingWidget()
            : _addButton(() {
                BottomSheetApp.showModalCreditCard(context);
              });
      },
    );
  }

  Widget _titleListCredit() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 32, bottom: 16),
      child: Text(
        "Your payment cards",
        style: ETextStyle.metropolis(weight: FontWeight.w700),
      ),
    );
  }

  Widget _showListCreditCard() {
    return Expanded(
        child: BlocBuilder<CreditCardCubit, CreditCardState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status == CreditCardStatus.loading
            ? const LoadingWidget()
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  return BlocBuilder<CreditCardCubit, CreditCardState>(
                      buildWhen: (previous, current) =>
                          previous.defaultStatus != current.defaultStatus,
                      builder: (context, state) {
                        return _creditCard(state.creditCards[index], () {
                          context
                              .read<CreditCardCubit>()
                              .setDefaultCredit(state.creditCards[index]);
                        }, () {
                          SystemDialog.showConfirmDialog(
                              context: context,
                              func: () {
                                context
                                    .read<CreditCardCubit>()
                                    .removeCreditCard(state.creditCards[index]);
                              },
                              title: "Are you sure",
                              content: "Do you want to delete this card?");
                        });
                      });
                },
                itemCount: state.creditCards.length,
              );
      },
    ));
  }

  Widget _creditCard(CreditCard creditCard, VoidCallback setDefault,
      VoidCallback removeCredit) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: double.maxFinite,
                height: 220,
                decoration: BoxDecoration(
                    color: creditCard.cardNumber.substring(0, 1) == "4"
                        ? const Color(0xff9B9B9B)
                        : const Color(0xff222222),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ]),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CustomPaint(
                    painter: BottomPainter(),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 24, right: 24, bottom: 24, top: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: creditCard.cardNumber[0] == "4"
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: [
                              creditCard.cardNumber[0] == "4"
                                  ? Image.asset(
                                      "assets/images/icons/visa.png",
                                      scale: 17,
                                    )
                                  : Image.asset(
                                      "assets/images/icons/chip_card.png",
                                      scale: 2.5,
                                    )
                            ],
                          ),
                          const SizedBox(),
                          Text(
                            "**** **** **** ${creditCard.cardNumber.substring(creditCard.cardNumber.length - 4)}",
                            style: ETextStyle.metropolis(
                                letterSpacing: 4,
                                fontSize: 24,
                                color: Colors.white,
                                weight: FontWeight.w600),
                          ),
                          Row(
                            children: [
                              creditCard.cardNumber[0] == "4"
                                  ? Image.asset(
                                      "assets/images/icons/chip_card.png",
                                      scale: 2.5)
                                  : const SizedBox()
                            ],
                          ),
                          const SizedBox(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Card Holder Name",
                                    style: ETextStyle.metropolis(
                                        fontSize: 10, color: Colors.white),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    creditCard.nameOnCard,
                                    style: ETextStyle.metropolis(
                                        fontSize: 14,
                                        color: Colors.white,
                                        weight: FontWeight.w600),
                                  )
                                ],
                              ),
                              creditCard.cardNumber[0] == "4"
                                  ? const Spacer()
                                  : const SizedBox(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Expire Date",
                                    style: ETextStyle.metropolis(
                                        fontSize: 10, color: Colors.white),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    creditCard.expireDate,
                                    style: ETextStyle.metropolis(
                                        fontSize: 14,
                                        color: Colors.white,
                                        weight: FontWeight.w600),
                                  )
                                ],
                              ),
                              creditCard.cardNumber[0] == "4"
                                  ? const SizedBox()
                                  : Image.asset(
                                      "assets/images/icons/mastercard_white.png",
                                      scale: 3.5,
                                    )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    splashRadius: 15,
                    onPressed: removeCredit,
                    icon: const ImageIcon(
                        AssetImage("assets/images/icons/delete.png"),
                        color: Colors.red,
                        size: 17),
                  )),
            ],
          ),
          const SizedBox(
            height: 18,
          ),
          _checkUseDefault(setDefault, creditCard.isDefault)
        ],
      ),
    );
  }

  Widget _addButton(VoidCallback func) {
    return SizedBox(
      width: 50,
      child: RawMaterialButton(
        fillColor: Colors.black,
        onPressed: func,
        elevation: 5,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        padding: const EdgeInsets.all(10),
        shape: const CircleBorder(),
      ),
    );
  }

  Widget _checkUseDefault(VoidCallback func, bool check) {
    return Row(
      children: [
        Transform.scale(
          scale: 1.4,
          child: SizedBox(
            width: 24,
            child: Checkbox(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3.5)),
              activeColor: Colors.black,
              checkColor: Colors.white,
              value: check,
              onChanged: (_) {
                func();
              },
            ),
          ),
        ),
        const SizedBox(
          width: 14,
        ),
        Text(
          "Use as default payment method",
          style: ETextStyle.metropolis(fontSize: 14),
        )
      ],
    );
  }
}

class BottomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;
    Paint paint = Paint();
    paint.color = Colors.white.withOpacity(0.03);
    var path = Path();
    path.moveTo(0, height * 3 / 5);

    path.quadraticBezierTo(
        width / 6, (height / 2), width / 3, height * 3.2 / 5);
    path.quadraticBezierTo(
        width * 1.3 / 3, height * 3.5 / 5, width * 1.5 / 3, height * 3.4 / 5);
    path.quadraticBezierTo(
        width * 3.1 / 4, height * 2.5 / 4, width * 4 / 5, height);

    path.lineTo(0, height);
    var pathCircle = Path();
    pathCircle.addOval(Rect.fromCircle(
      center: Offset(width - 20, 20),
      radius: 120,
    ));

    canvas.drawPath(path, paint);
    canvas.drawPath(pathCircle, paint);
    path.close();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
