import '../../modules/models/credit_card.dart';

class CreditCardHelper {
  static CreditCard? getDefaultCreditCard(List<CreditCard> addresses) {
    var defaultCreditCard =
        addresses.where((element) => element.isDefault == true).toList();
    if (defaultCreditCard.isNotEmpty) {
      return defaultCreditCard[0];
    } else {
      return null;
    }
  }
}
