import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../repositories/domain.dart';

part 'country_state.dart';

class CountryCubit extends Cubit<CountryState> {
  CountryCubit() : super(const CountryState()) {
    countryLoaded();
  }

  void countryLoaded() async {
    try {
      if (state.status == CountryStatus.initial) {
        emit(state.copyWith(status: CountryStatus.loading));
        final categories = await Domain().country.getCountries();
        emit(state.copyWith(
            status: CountryStatus.success, countries: categories));
      }
    } catch (_) {
      emit(state.copyWith(status: CountryStatus.failure));
    }
  }

  void countrySearch(String searchInput) async {
    try {
      emit(state.copyWith(status: CountryStatus.loading));
      final categories = await Domain().country.getCountryByName(searchInput);
      emit(state.copyWith(
          status: CountryStatus.success,
          countries: categories,
          searchInput: searchInput));
    } catch (_) {
      emit(state.copyWith(status: CountryStatus.failure));
    }
  }
}
