class CountryService {
  static final List<String> countryNames = [
    'India',
    'Bhutan',
    'Nepal',
    'London',
    'America',
    'China',
    'Japan',
    'Russia',
    'Israel',
    'Africa',
  ];

  static List<String> searchCountries(String query) {
    if (query.isEmpty) return countryNames;
    return countryNames
        .where((name) => name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}

