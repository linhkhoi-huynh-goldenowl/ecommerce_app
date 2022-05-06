import 'package:e_commerce_shop_app/config/styles/text_style.dart';
import 'package:e_commerce_shop_app/modules/cubit/creditCard/credit_card_cubit.dart';
import 'package:e_commerce_shop_app/modules/models/credit_card.dart';
import 'package:e_commerce_shop_app/utils/services/text_format_credit.dart';
import 'package:e_commerce_shop_app/widgets/buttons/button_intro.dart';
import 'package:e_commerce_shop_app/widgets/textfields/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../loading_widget.dart';

class PopupCredit extends StatelessWidget {
  PopupCredit({Key? key}) : super(key: key);
  final FocusNode focusCardNumber = FocusNode();
  final FocusNode focusExpire = FocusNode();
  final FocusNode focusCVV = FocusNode();
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
        heightFactor: 0.7,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          bottomNavigationBar: BottomAppBar(
              color: const Color(0xffF9F9F9),
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: BlocConsumer<CreditCardCubit, CreditCardState>(
                    listenWhen: (previous, current) =>
                        previous.typeStatus != current.typeStatus,
                    listener: (context, state) {
                      if (state.typeStatus == CreditCardTypeStatus.submitted) {
                        Navigator.of(context).pop();
                      }
                    },
                    buildWhen: (previous, current) =>
                        previous.typeStatus != current.typeStatus,
                    builder: (context, state) {
                      if (state.typeStatus == CreditCardTypeStatus.submitting) {
                        return const LoadingWidget();
                      } else {
                        return ButtonIntro(
                            func: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<CreditCardCubit>().addCreditCard(
                                    CreditCard(
                                        nameOnCard: state.nameOnCard,
                                        cardNumber: state.cardNumber,
                                        expireDate: state.expireDate,
                                        isDefault: state.isDefault));
                              }
                            },
                            title: "ADD CARD");
                      }
                    }),
              )),
          body: Column(
            children: [
              const SizedBox(
                height: 14,
              ),
              Image.asset(
                "assets/images/icons/rectangle.png",
                scale: 3,
              ),
              const SizedBox(
                height: 26,
              ),
              Center(
                child: Text(
                  "Add new card",
                  style: ETextStyle.metropolis(
                      fontSize: 18, weight: FontWeight.w600),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              Expanded(child: _creditForm(context))
            ],
          ),
        ));
  }

  Widget _creditForm(BuildContext context) {
    return BlocBuilder<CreditCardCubit, CreditCardState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              children: [
                BlocBuilder<CreditCardCubit, CreditCardState>(
                    buildWhen: (previous, current) =>
                        previous.nameOnCard != current.nameOnCard,
                    builder: (context, state) {
                      return TextFieldWidget(
                        // onEditComplete: () => FocusScope.of(context)
                        //     .requestFocus(focusCardNumber),
                        labelText: 'Name on card',
                        validatorText: 'Name on card must more than 2',
                        isValid: state.isNameOnCard,
                        func: (value) => context
                            .read<CreditCardCubit>()
                            .nameOnCardChanged(value),
                        isPassword: false,
                      );
                    }),
                const SizedBox(
                  height: 20,
                ),
                _cardNumberTextField(),
                const SizedBox(
                  height: 20,
                ),
                BlocBuilder<CreditCardCubit, CreditCardState>(
                    buildWhen: (previous, current) =>
                        previous.expireDate != current.expireDate,
                    builder: (context, state) {
                      return TextFieldWidget(
                        // focusNode: focusExpire,
                        // onEditComplete: () =>
                        //     FocusScope.of(context).requestFocus(focusCVV),
                        inputFormatters: [
                          MaskedCreditFormatter(mask: "xx/xx", separator: '/')
                        ],
                        inputType: TextInputType.number,
                        labelText: 'Expire Date',
                        validatorText: 'Expire Date invalid',
                        isValid: state.expireDate.length == 5
                            ? state.isExpireDate
                            : false,
                        func: (value) => context
                            .read<CreditCardCubit>()
                            .expireDateChanged(value),
                        isPassword: false,
                      );
                    }),
                const SizedBox(
                  height: 20,
                ),
                BlocBuilder<CreditCardCubit, CreditCardState>(
                    buildWhen: (previous, current) =>
                        previous.cvv != current.cvv,
                    builder: (context, state) {
                      return TextFieldWidget(
                        // focusNode: focusCVV,
                        // onEditComplete: () => FocusScope.of(context).unfocus(),
                        inputFormatters: [
                          MaskedCreditFormatter(mask: "xxx", separator: '')
                        ],
                        inputType: TextInputType.number,
                        labelText: 'CVV',
                        validatorText: 'CVV invalid',
                        isValid: state.isCVV,
                        func: (value) =>
                            context.read<CreditCardCubit>().cvvChanged(value),
                        isPassword: false,
                      );
                    }),
                const SizedBox(
                  height: 20,
                ),
                BlocBuilder<CreditCardCubit, CreditCardState>(
                    buildWhen: (previous, current) =>
                        previous.isDefault != current.isDefault,
                    builder: (context, state) {
                      return _checkUseDefault(() {
                        context.read<CreditCardCubit>().isDefaultChanged();
                      }, state.isDefault);
                    })
              ],
            ),
          );
        });
  }

  Widget _cardNumberTextField() {
    return BlocBuilder<CreditCardCubit, CreditCardState>(
        buildWhen: (previous, current) =>
            previous.cardNumber != current.cardNumber,
        builder: (context, state) {
          return Container(
              padding: const EdgeInsets.only(
                  top: 10, bottom: 10, left: 20, right: 0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ]),
              child: TextFormField(
                // focusNode: focusCardNumber,
                // onEditingComplete: () =>
                //     FocusScope.of(context).requestFocus(focusExpire),
                onChanged: (value) {
                  context.read<CreditCardCubit>().cardNumberChanged(value);
                },
                inputFormatters: [
                  MaskedCreditFormatter(
                      mask: "xxxx xxxx xxxx xxxx", separator: ' ')
                ],
                keyboardType: TextInputType.number,

                // initialValue: state.cardNumber,
                decoration: InputDecoration(
                  suffix: state.cardNumber.isNotEmpty
                      ? (state.cardNumber[0] == "5"
                          ? Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: Image.asset(
                                "assets/images/icons/mastercard_black.png",
                                height: 25,
                              ),
                            )
                          : state.cardNumber[0] == "4"
                              ? Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: Image.asset(
                                    "assets/images/icons/visa_color.png",
                                    scale: 16,
                                  ),
                                )
                              : null)
                      : null,
                  border: InputBorder.none,
                  labelStyle:
                      ETextStyle.metropolis(color: const Color(0xffbcbcbc)),
                  floatingLabelStyle:
                      ETextStyle.metropolis(color: const Color(0xffbcbcbc)),
                  labelText: "Card Number",
                  fillColor: const Color(0xffbcbcbc),
                  hoverColor: const Color(0xffbcbcbc),
                  focusColor: const Color(0xffbcbcbc),
                ),
                validator: (value) => state.isCardNumber
                    ? null
                    : "Card Number should start from '4' or '5' and must valid",
              ));
        });
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
          "Set as default payment method",
          style: ETextStyle.metropolis(fontSize: 14),
        )
      ],
    );
  }
}
