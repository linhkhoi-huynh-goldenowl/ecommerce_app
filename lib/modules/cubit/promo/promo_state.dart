part of 'promo_cubit.dart';

enum PromoStatus { initial, loading, success, failure }
enum CodePromoStatus { initial, typing, typed, submitting }
enum PromoSort { percentAsc, percentDesc, endDateAsc, endDateDesc }

class PromoState extends Equatable {
  const PromoState(
      {this.promos = const [],
      this.status = PromoStatus.initial,
      this.codeInput = "",
      this.codeStatus = CodePromoStatus.initial,
      this.errMessage = "",
      this.sort = PromoSort.percentAsc});
  final List<PromoModel> promos;
  final String codeInput;
  final CodePromoStatus codeStatus;
  final String errMessage;
  final PromoSort sort;

  List<PromoModel> get promoListToShow {
    List<PromoModel> promoFilter = List.from(promos);
    switch (sort) {
      case PromoSort.endDateAsc:
        {
          promoFilter
              .sort((a, b) => a.endDate.toDate().compareTo(b.endDate.toDate()));
          break;
        }
      case PromoSort.endDateDesc:
        {
          promoFilter
              .sort((b, a) => a.endDate.toDate().compareTo(b.endDate.toDate()));
          break;
        }
      case PromoSort.percentAsc:
        {
          promoFilter.sort((a, b) => a.salePercent.compareTo(b.salePercent));
          break;
        }
      case PromoSort.percentDesc:
        {
          promoFilter.sort((b, a) => a.salePercent.compareTo(b.salePercent));
          break;
        }
    }

    return promoFilter;
  }

  bool get isValidCodeInput => promos
      .where((element) {
        return element.id == codeInput;
      })
      .toList()
      .isNotEmpty;
  final PromoStatus status;
  PromoState copyWith(
      {List<PromoModel>? promos,
      PromoStatus? status,
      String? codeInput,
      CodePromoStatus? codeStatus,
      String? errMessage,
      PromoSort? sort}) {
    return PromoState(
        promos: promos ?? this.promos,
        status: status ?? this.status,
        codeInput: codeInput ?? this.codeInput,
        codeStatus: codeStatus ?? this.codeStatus,
        errMessage: errMessage ?? this.errMessage,
        sort: sort ?? this.sort);
  }

  @override
  List<Object> get props =>
      [promos, status, codeInput, codeStatus, errMessage, sort];
}
