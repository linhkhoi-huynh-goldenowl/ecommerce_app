import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/credit_card.dart';
import '../../provider/credit_card_provider.dart';
import '../../x_result.dart';
import '../repository/credit_card_repository.dart';

class CreditCardRepositoryImpl extends CreditCardRepository {
  List<CreditCard> _listCreditCard = [];
  final CreditCardProvider _creditProvider = CreditCardProvider();
  @override
  Future<List<CreditCard>> addCreditCard(CreditCard item) async {
    final pref = await SharedPreferences.getInstance();
    final userId = pref.getString("userId");

    var createdDate = DateTime.now().toIso8601String();
    item.userId = userId;
    item.id = "$userId-$createdDate";

    XResult<CreditCard> result = await _creditProvider.addCreditCard(item);

    if (item.isDefault == true) {
      //====>change old default
      int indexCreditCardOldDefault =
          _listCreditCard.indexWhere((element) => element.isDefault == true);
      if (indexCreditCardOldDefault > -1) {
        var oldDefault = _listCreditCard[indexCreditCardOldDefault];
        oldDefault.isDefault = false;
        XResult<CreditCard> resultOld =
            await _creditProvider.addCreditCard(oldDefault);
        _listCreditCard[indexCreditCardOldDefault] = resultOld.data!;
      }

      //change done<====
    }

    _listCreditCard.add(result.data!);

    return _listCreditCard;
  }

  @override
  Future<List<CreditCard>> getCreditCard() async {
    final pref = await SharedPreferences.getInstance();
    final userId = pref.getString("userId");
    XResult<List<CreditCard>> result =
        await _creditProvider.getCreditCardByUser(userId ?? "");
    _listCreditCard = result.data ?? [];
    return _listCreditCard;
  }

  @override
  Future<List<CreditCard>> removeCreditCard(CreditCard item) async {
    await _creditProvider.removeCreditCard(item);
    _listCreditCard.removeWhere(
        (element) => element.id == item.id && element.userId == item.userId);

    return _listCreditCard;
  }

  @override
  Future<List<CreditCard>> editCreditCard(CreditCard item) async {
    final pref = await SharedPreferences.getInstance();
    final userId = pref.getString("userId");
    item.userId = userId;
    XResult<CreditCard> result = await _creditProvider.addCreditCard(item);

    int indexCreditCard =
        _listCreditCard.indexWhere((element) => element.id == result.data!.id);
    _listCreditCard[indexCreditCard] = item;

    return _listCreditCard;
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
