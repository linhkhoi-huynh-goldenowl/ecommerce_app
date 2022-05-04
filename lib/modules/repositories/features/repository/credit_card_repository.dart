import '../../../models/credit_card.dart';
import '../../x_result.dart';

abstract class CreditCardRepository {
  Future<XResult<CreditCard>> setDefaultCard(CreditCard itemNew);
  Future<XResult<CreditCard>> setUnDefaultCard(CreditCard itemOld);
  Future<XResult<CreditCard>> addCreditCard(CreditCard item);
  Future<XResult<String>> removeCreditCard(CreditCard item);
  Future<Stream<XResult<List<CreditCard>>>> getCreditCardsStream();
  Future<List<CreditCard>> setCreditCards(List<CreditCard> creditCards);
}
