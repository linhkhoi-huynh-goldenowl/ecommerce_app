import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/credit_card.dart';
import '../../provider/credit_card_provider.dart';
import '../../x_result.dart';
import '../repository/credit_card_repository.dart';

class CreditCardRepositoryImpl extends CreditCardRepository {
  List<CreditCard> _listCreditCard = [];
  final CreditCardProvider _creditProvider = CreditCardProvider();
  @override
  Future<XResult<CreditCard>> addCreditCard(CreditCard item) async {
    final pref = await SharedPreferences.getInstance();
    final userId = pref.getString("userId");

    var createdDate = DateTime.now().toIso8601String();
    item.userId = userId;
    item.id = "$userId-$createdDate";

    XResult<CreditCard> result = await _creditProvider.addCreditCard(item);
    if (result.isSuccess) {
      if (item.isDefault == true) {
        //====>change old default
        int indexCreditCardOldDefault =
            _listCreditCard.indexWhere((element) => element.isDefault == true);
        if (indexCreditCardOldDefault > -1) {
          var oldDefault = _listCreditCard[indexCreditCardOldDefault];
          oldDefault.isDefault = false;
          return _creditProvider.addCreditCard(oldDefault);
        } else {
          return result;
        }
        //change done<====
      } else {
        return result;
      }
    } else {
      return result;
    }
  }

  @override
  Future<XResult<String>> removeCreditCard(CreditCard item) async {
    return await _creditProvider.removeCreditCard(item);
  }

  @override
  Future<XResult<CreditCard>> setDefaultCard(CreditCard itemNew) async {
    itemNew.isDefault = true;
    return await _creditProvider.addCreditCard(itemNew);
  }

  @override
  Future<XResult<CreditCard>> setUnDefaultCard(CreditCard itemOld) async {
    itemOld.isDefault = false;
    return await _creditProvider.addCreditCard(itemOld);
  }

  @override
  Future<Stream<XResult<List<CreditCard>>>> getCreditCardsStream() async {
    final pref = await SharedPreferences.getInstance();
    final userId = pref.getString("userId");
    return _creditProvider.snapshotsAllQuery("userId", userId!);
  }

  @override
  Future<List<CreditCard>> setCreditCards(List<CreditCard> creditCards) async {
    _listCreditCard = creditCards;
    return _listCreditCard;
  }
}
