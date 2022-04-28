part of 'country_cubit.dart';

enum CountryStatus { initial, success, failure, loading }

class CountryState extends Equatable {
  const CountryState(
      {this.countries = const <String>[],
      this.status = CountryStatus.initial,
      this.searchInput = ""});
  final List<String> countries;
  final CountryStatus status;
  final String searchInput;

  CountryState copyWith(
      {CountryStatus? status, List<String>? countries, String? searchInput}) {
    return CountryState(
        status: status ?? this.status,
        countries: countries ?? this.countries,
        searchInput: searchInput ?? this.searchInput);
  }

  @override
  List<Object> get props => [countries, status, searchInput];
}
