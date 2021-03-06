import 'package:flutter/material.dart';
import 'package:natureclinic/models/country.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
class CountryProvider with ChangeNotifier {

  CountryProvider() {
    loadCountriesFromJSON();
    searchController.addListener(_search);
  }

  List<Country> _countries = [];
  List<Country> get countries => _countries;
  List<Country> _searchResults = [];
  List<Country> get searchResults => _searchResults;

  set searchResults(List<Country> value) {
    _searchResults = value;
    print('SearchResults ${searchResults.length}');
    notifyListeners();
  }

  Country _selectedCountry = Country();

  Country get selectedCountry => _selectedCountry;

  set selectedCountry(Country value) {
    _selectedCountry = value;
    notifyListeners();
  }

  final TextEditingController _searchController = TextEditingController();

  TextEditingController get searchController => _searchController;

  Future loadCountriesFromJSON() async {
    try {
      if (countries.length <= 0) {
        var _file =
        await rootBundle.loadString('data/country_phone_codes.json');
        var _countriesJson = json.decode(_file);
        List<Country> _listOfCountries = [];
        for (var country in _countriesJson) {
          _listOfCountries.add(Country.fromJson(country));
        }
        _countries = _listOfCountries;
        notifyListeners();
        // Selecting India
        selectedCountry = _listOfCountries[100];
        searchResults = _listOfCountries;
      }
    } catch (err) {
      debugPrint("Unable to load countries data");
      throw err;
    }
  }

  void _search() {
    String query = searchController.text;
    print(query);
    if (query.length == 0 || query.length == 1) {
      searchResults = countries;
    } else {
      List<Country> _results = [];
      countries.forEach(
            (Country c) {
          if (c.toString().toLowerCase().contains(
            query.toLowerCase(),
          )) _results.add(c);
        },
      );
      searchResults = _results;
      print("results length: ${searchResults.length}");
//      print('added few countries based on search ${searchResults.length}');
    }
  }

  void resetSearch() {
    searchResults = countries;
  }
}
