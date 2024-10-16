class AddressState {
  final List<dynamic> suggestions;
  final double? latitude;
  final double? longitude;
  final String? selectedAddress;

  final List<dynamic> countries; // List of countries
  final List<String> states; // List of states based on selected country
  final List<String> cities; // List of cities based on selected state
  final String? selectedCountry; // Selected country
  final String? selectedState; // Selected state
  final String? selectedCity; // Selected city

  AddressState({
    this.suggestions = const [],
    this.latitude,
    this.longitude,
    this.selectedAddress,
    this.countries = const [],
    this.states = const [],
    this.cities = const [],
    this.selectedCountry,
    this.selectedState,
    this.selectedCity,
  });

  AddressState copyWith({
    List<dynamic>? suggestions,
    double? latitude,
    double? longitude,
    String? selectedAddress,
    List<dynamic>? countries,
    List<String>? states,
    List<String>? cities,
    String? selectedCountry,
    String? selectedState,
    String? selectedCity,
  }) {
    return AddressState(
      suggestions: suggestions ?? this.suggestions,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      selectedAddress: selectedAddress ?? this.selectedAddress,
      countries: countries ?? this.countries,
      states: states ?? this.states,
      cities: cities ?? this.cities,
      selectedCountry: selectedCountry ?? this.selectedCountry,
      selectedState: selectedState ?? this.selectedState,
      selectedCity: selectedCity ?? this.selectedCity,
    );
  }
}
