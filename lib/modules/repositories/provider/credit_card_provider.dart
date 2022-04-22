import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_shop_app/modules/repositories/provider/base_collection.dart';

import '../../models/credit_card.dart';
import '../x_result.dart';

class CreditCardProvider extends BaseCollectionReference<CreditCard> {
  CreditCardProvider()
      : super(FirebaseFirestore.instance
            .collection('creditCards')
            .withConverter<CreditCard>(
                fromFirestore: (snapshot, options) => CreditCard.fromJson(
                    snapshot.data() as Map<String, dynamic>),
                toFirestore: (creditCard, _) => creditCard.toJson()));

  Future<XResult<CreditCard>> addCreditCard(CreditCard creditCard) async {
    return await set(creditCard);
  }

  Future<XResult<String>> removeCreditCard(CreditCard creditCard) async {
    return await remove(creditCard.id ?? "");
  }

  Future<XResult<List<CreditCard>>> getCreditCardByUser(String id) async {
    final XResult<List<CreditCard>> res = await queryWhereId('userId', id);

    return res;
  }
}
