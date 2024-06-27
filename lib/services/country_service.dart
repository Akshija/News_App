import 'package:news_app/models/country_model.dart';

class CountryService {
  List<CountryModel> countries = [
    CountryModel('India', 'in'),
  ];

  CountryModel getFirstCountry() {
    return countries.first;
  }

  List<CountryModel> getAllCountries() {
    return countries;
  }
}
