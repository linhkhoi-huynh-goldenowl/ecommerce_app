import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/credit_card.dart';
import '../../models/e_user.dart';
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
        if (event.isSuccess) {
          var listCredit =
              await Domain().creditCard.setCreditCards(event.data ?? []);

          emit(state.copyWith(
              status: CreditCardStatus.success,
              creditCards: listCredit,
              errMessage: ""));
        } else {
          emit(state.copyWith(
              status: CreditCardStatus.failure, errMessage: event.error));
        }
      });
    } catch (_) {
      emit(state.copyWith(
          status: CreditCardStatus.failure, errMessage: "Something wrong"));
    }
  }

  void addCreditCard(CreditCard creditCard) async {
    try {
      emit(state.copyWith(
          status: CreditCardStatus.loading,
          typeStatus: CreditCardTypeStatus.submitting));
      XResult<CreditCard> creditRes =
          await Domain().creditCard.addCreditCard(creditCard);
      if (creditRes.isSuccess) {
        if (creditCard.isDefault == true) {
          var localUser = await Domain().profile.getProfile();
          localUser.creditDefault = creditCard.cardNumber;
          XResult<EUser> resUser =
              await Domain().profile.saveProfile(localUser);
          if (resUser.isSuccess) {
            emit(state.copyWith(
                status: CreditCardStatus.success,
                typeStatus: CreditCardTypeStatus.submitted,
                errMessage: ""));
          } else {
            emit(state.copyWith(
                status: CreditCardStatus.failure,
                typeStatus: CreditCardTypeStatus.initial,
                errMessage: resUser.error));
          }
        } else {
          emit(state.copyWith(
              status: CreditCardStatus.success,
              typeStatus: CreditCardTypeStatus.submitted,
              errMessage: ""));
        }
      } else {
        emit(state.copyWith(
            status: CreditCardStatus.failure,
            typeStatus: CreditCardTypeStatus.initial,
            errMessage: creditRes.error));
      }
    } catch (_) {
      emit(state.copyWith(
          status: CreditCardStatus.failure,
          typeStatus: CreditCardTypeStatus.initial,
          errMessage: "Something wrong"));
    }
  }

  void setDefaultCredit(CreditCard creditCard) async {
    try {
      emit(state.copyWith(defaultStatus: CardDefaultStatus.loading));
      int indexOldDefault =
          state.creditCards.indexWhere((element) => element.isDefault == true);
      if (indexOldDefault > -1) {
        XResult<CreditCard> resOld = await Domain()
            .creditCard
            .setUnDefaultCard(state.creditCards[indexOldDefault]);
        if (resOld.isSuccess) {
          XResult<CreditCard> resNew =
              await Domain().creditCard.setDefaultCard(creditCard);
          if (resNew.isSuccess) {
            var localUser = await Domain().profile.getProfile();
            localUser.creditDefault = creditCard.cardNumber;
            XResult<EUser> resUser =
                await Domain().profile.saveProfile(localUser);
            if (resUser.isSuccess) {
              emit(state.copyWith(defaultStatus: CardDefaultStatus.success));
            } else {
              emit(state.copyWith(
                  defaultStatus: CardDefaultStatus.failure,
                  errMessage: resUser.error));
            }
          } else {
            emit(state.copyWith(
                defaultStatus: CardDefaultStatus.failure,
                errMessage: resNew.error));
          }
        } else {
          emit(state.copyWith(
              defaultStatus: CardDefaultStatus.failure,
              errMessage: resOld.error));
        }
      } else {
        XResult<CreditCard> resNew =
            await Domain().creditCard.setDefaultCard(creditCard);
        if (resNew.isSuccess) {
          emit(state.copyWith(
              defaultStatus: CardDefaultStatus.success,
              typeStatus: CreditCardTypeStatus.submitted));
        } else {
          emit(state.copyWith(
              defaultStatus: CardDefaultStatus.failure,
              typeStatus: CreditCardTypeStatus.initial));
        }
      }
    } catch (_) {
      emit(state.copyWith(
          defaultStatus: CardDefaultStatus.failure,
          errMessage: "Something wrong"));
    }
  }

  void removeCreditCard(CreditCard creditCard) async {
    try {
      emit(state.copyWith(status: CreditCardStatus.loading));
      XResult<String> creditRes =
          await Domain().creditCard.removeCreditCard(creditCard);
      if (creditRes.isSuccess) {
        if (creditCard.isDefault == true) {
          var localUser = await Domain().profile.getProfile();
          localUser.creditDefault = null;
          XResult<EUser> resUser =
              await Domain().profile.saveProfile(localUser);
          if (resUser.isSuccess) {
            emit(state.copyWith(
                status: CreditCardStatus.success, errMessage: ""));
          } else {
            emit(state.copyWith(
                status: CreditCardStatus.failure, errMessage: resUser.error));
          }
        } else {
          emit(state.copyWith(status: CreditCardStatus.success));
        }
      } else {
        emit(state.copyWith(
            status: CreditCardStatus.failure, errMessage: creditRes.error));
      }
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
