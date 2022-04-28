import '../../../models/credit_card.dart';
import '../../x_result.dart';

abstract class CreditCardRepository {
  Future<List<CreditCard>> addCreditCard(CreditCard item);
  Future<List<CreditCard>> editCreditCard(CreditCard item);
  Future<XResult<CreditCard>> setDefaultCard(CreditCard itemNew);
  Future<XResult<CreditCard>> setUnDefaultCard(CreditCard itemOld);
  Future<List<CreditCard>> removeCreditCard(CreditCard item);
  Future<Stream<XResult<List<CreditCard>>>> getCreditCardsStream();
  Future<List<CreditCard>> setCreditCards(List<CreditCard> creditCards);
  Future<List<CreditCard>> getCreditCard();
}
