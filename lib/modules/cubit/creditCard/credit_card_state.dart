part of 'credit_card_cubit.dart';

enum CreditCardStatus {
  initial,
  success,
  failure,
  loading,
}
enum CreditCardTypeStatus { initial, typing, typed, submitting, submitted }

class CreditCardState extends Equatable {
  const CreditCardState(
      {this.nameOnCard = "",
      this.cardNumber = "",
      this.expireDate = "",
      this.cvv = "",
      this.isDefault = false,
      this.status = CreditCardStatus.initial,
      this.typeStatus = CreditCardTypeStatus.initial,
      this.creditCards = const [],
      this.errMessage = ""});

  final String nameOnCard;
  bool get isNameOnCard => nameOnCard.length > 2;
  final String cardNumber;
  bool get isCardNumber =>
      cardNumber.length == 19 && (cardNumber[0] == "4" || cardNumber[0] == "5");
  final String expireDate;
  bool get isExpireDate =>
      (int.parse(expireDate.substring(3, 5)) > 0 &&
          int.parse(expireDate.substring(3, 5)) < 100) &&
      (int.parse(expireDate.substring(0, 2)) > 0 &&
          int.parse(expireDate.substring(0, 2)) < 13);

  final String cvv;
  bool get isCVV => cvv.length == 3;
  final bool isDefault;

  final CreditCardStatus status;

  final CreditCardTypeStatus typeStatus;

  final List<CreditCard> creditCards;
  final String errMessage;

  CreditCardState copyWith(
      {String? nameOnCard,
      String? cardNumber,
      String? expireDate,
      String? cvv,
      bool? isDefault,
      CreditCardStatus? status,
      CreditCardTypeStatus? typeStatus,
      List<CreditCard>? creditCards,
      String? errMessage}) {
    return CreditCardState(
        status: status ?? this.status,
        typeStatus: typeStatus ?? this.typeStatus,
        cardNumber: cardNumber ?? this.cardNumber,
        nameOnCard: nameOnCard ?? this.nameOnCard,
        creditCards: creditCards ?? this.creditCards,
        expireDate: expireDate ?? this.expireDate,
        isDefault: isDefault ?? this.isDefault,
        cvv: cvv ?? this.cvv,
        errMessage: errMessage ?? this.errMessage);
  }

  @override
  List<Object> get props => [
        status,
        typeStatus,
        cardNumber,
        nameOnCard,
        creditCards,
        cvv,
        expireDate,
        isDefault,
        errMessage
      ];
}
