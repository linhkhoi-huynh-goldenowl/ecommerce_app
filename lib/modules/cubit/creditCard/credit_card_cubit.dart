import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/credit_card.dart';
import '../../repositories/domain.dart';
import '../../repositories/x_result.dart';

part 'credit_card_state.dart';

class CreditCardCubit extends Cubit<CreditCardState> {
  CreditCardCubit() : super(const CreditCardState()) {
    fetchCreditCard();
  }
  StreamSubscription? creditSubscription;
  @override
  Future<void> close() {
    creditSubscription?.cancel();
    return super.close();
  }

  void fetchCreditCard() async {
    try {
      emit(state.copyWith(status: CreditCardStatus.loading));
      final Stream<XResult<List<CreditCard>>> creditStream =
          await Domain().creditCard.getCreditCardsStream();

      creditSubscription = creditStream.listen((event) async {
        emit(state.copyWith(status: CreditCardStatus.loading));
        var listCredit =
            await Domain().creditCard.setCreditCards(event.data ?? []);

        emit(state.copyWith(
            status: CreditCardStatus.success, creditCards: listCredit));
      });
      // var creditCards = await Domain().creditCard.getCreditCard();
      // emit(state.copyWith(
      //     status: CreditCardStatus.success, creditCards: creditCards));
    } catch (_) {
      emit(state.copyWith(status: CreditCardStatus.failure));
    }
  }

  void addCreditCard(CreditCard creditCard) async {
    try {
      emit(state.copyWith(
          status: CreditCardStatus.loading,
          typeStatus: CreditCardTypeStatus.submitting));
      var creditCards = await Domain().creditCard.addCreditCard(creditCard);

      if (creditCard.isDefault == true) {
        var localUser = await Domain().profile.getProfile();
        localUser.creditDefault = creditCard.cardNumber;
        await Domain().profile.saveProfile(localUser);
      }
      emit(state.copyWith(
          status: CreditCardStatus.success,
          creditCards: creditCards,
          typeStatus: CreditCardTypeStatus.submitted));
    } catch (_) {
      emit(state.copyWith(
          status: CreditCardStatus.failure,
          typeStatus: CreditCardTypeStatus.initial));
    }
  }

  void setDefaultCredit(CreditCard creditCard) async {
    try {
      emit(state.copyWith(status: CreditCardStatus.loading));
      var creditCards = await Domain().creditCard.setDefaultCard(creditCard);
      var localUser = await Domain().profile.getProfile();
      localUser.creditDefault = creditCard.cardNumber;
      await Domain().profile.saveProfile(localUser);
      emit(state.copyWith(
          status: CreditCardStatus.success, creditCards: creditCards));
    } catch (_) {
      emit(state.copyWith(status: CreditCardStatus.failure));
    }
  }

  void removeCreditCard(CreditCard creditCard) async {
    try {
      emit(state.copyWith(status: CreditCardStatus.loading));
      var creditCards = await Domain().creditCard.removeCreditCard(creditCard);
      if (creditCard.isDefault == true) {
        var localUser = await Domain().profile.getProfile();
        localUser.creditDefault = null;
        await Domain().profile.saveProfile(localUser);
      }
      emit(state.copyWith(
          status: CreditCardStatus.success, creditCards: creditCards));
    } catch (_) {
      emit(state.copyWith(status: CreditCardStatus.failure));
    }
  }

  void nameOnCardChanged(String nameOnCard) {
    emit(state.copyWith(
        nameOnCard: nameOnCard, typeStatus: CreditCardTypeStatus.typing));

    if (state.isNameOnCard) {
      emit(state.copyWith(typeStatus: CreditCardTypeStatus.typed));
    } else {
      emit(state.copyWith(typeStatus: CreditCardTypeStatus.typing));
    }
  }

  void cardNumberChanged(String cardNumber) {
    emit(state.copyWith(
        cardNumber: cardNumber, typeStatus: CreditCardTypeStatus.typing));

    if (state.isCardNumber) {
      emit(state.copyWith(typeStatus: CreditCardTypeStatus.typed));
    } else {
      emit(state.copyWith(typeStatus: CreditCardTypeStatus.typing));
    }
  }

  void expireDateChanged(String expireDate) {
    emit(state.copyWith(
        expireDate: expireDate, typeStatus: CreditCardTypeStatus.typing));

    if (state.isExpireDate) {
      emit(state.copyWith(typeStatus: CreditCardTypeStatus.typed));
    } else {
      emit(state.copyWith(typeStatus: CreditCardTypeStatus.typing));
    }
  }

  void cvvChanged(String cvv) {
    emit(state.copyWith(cvv: cvv, typeStatus: CreditCardTypeStatus.typing));

    if (state.isCVV) {
      emit(state.copyWith(typeStatus: CreditCardTypeStatus.typed));
    } else {
      emit(state.copyWith(typeStatus: CreditCardTypeStatus.typing));
    }
  }

  void isDefaultChanged() {
    emit(state.copyWith(typeStatus: CreditCardTypeStatus.typing));
    emit(state.copyWith(
        isDefault: !state.isDefault, typeStatus: CreditCardTypeStatus.typed));
  }
}
