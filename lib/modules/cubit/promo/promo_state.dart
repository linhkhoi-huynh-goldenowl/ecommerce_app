part of 'promo_cubit.dart';

enum PromoStatus { initial, loading, success, failure }
enum CodePromoStatus { initial, typing, typed, submitting }

class PromoState extends Equatable {
  const PromoState(
      {this.promos = const [],
      this.status = PromoStatus.initial,
      this.codeInput = "",
      this.codeStatus = CodePromoStatus.initial});
  final List<PromoModel> promos;
  final String codeInput;
  final CodePromoStatus codeStatus;
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
      CodePromoStatus? codeStatus}) {
    return PromoState(
        promos: promos ?? this.promos,
        status: status ?? this.status,
        codeInput: codeInput ?? this.codeInput,
        codeStatus: codeStatus ?? this.codeStatus);
  }

  @override
  List<Object> get props => [promos, status, codeInput, codeStatus];
}
