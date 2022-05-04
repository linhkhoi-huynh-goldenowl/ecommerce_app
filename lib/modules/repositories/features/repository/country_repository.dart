abstract class CountryRepository {
  Future<List<String>> getCountries();

  Future<List<String>> getCountryByName(String searchName);
}
