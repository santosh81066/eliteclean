import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../models/addressstate.dart';

class AddressNotifier extends StateNotifier<AddressState> {
  AddressNotifier() : super(AddressState());

  final String googleMapsApiKey =
      'AIzaSyD6dWPriVXORUS6TYs8P71Cbp0Yrpxzl_4'; // Replace with your Google API key
  List<dynamic> countries = [];
  List<dynamic> states = [];
  List<dynamic> cities = [];

  // Load JSON data for countries, states, and cities
  Future<void> loadJsonData() async {
    try {
      final String countriesJson =
          await rootBundle.loadString('assets/countries.json');
      final String statesJson =
          await rootBundle.loadString('assets/states.json');
      final String citiesJson =
          await rootBundle.loadString('assets/cities.json');

      countries = json.decode(countriesJson);
      states = json.decode(statesJson);
      cities = json.decode(citiesJson);

      // Sort countries alphabetically
      countries.sort((a, b) => a['name'].compareTo(b['name']));

      state = state.copyWith(countries: countries);
    } catch (e) {
      print('Error loading JSON data: $e');
    }
  }

  // Filter states based on selected country code (India only)
  Future<void> filterStates() async {
    final filteredStates = states
        .where(
            (state) => state['country_code'] == "IN") // Show only Indian states
        .map((state) => state['name'].toString())
        .toList();

    state = state.copyWith(states: filteredStates);
  }

  // Filter cities based on selected state
  Future<void> filterCities(String stateName) async {
    final selectedState =
        states.firstWhere((state) => state['name'] == stateName);
    final filteredCities = cities
        .where((city) => city['state_id'] == selectedState['id'])
        .map((city) => city['name'].toString())
        .toList();

    state = state.copyWith(cities: filteredCities);
  }

  // Fetch suggestions from Google Places API for the address
  Future<void> fetchAddressSuggestions(String input) async {
    if (input.isEmpty) return;

    final String baseUrl =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    final url =
        Uri.parse('$baseUrl?input=$input&key=$googleMapsApiKey&types=geocode');

    try {
      final http.Response response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> suggestions =
            json.decode(response.body)['predictions'];
        state = state.copyWith(suggestions: suggestions);
      } else {
        throw Exception('Failed to load suggestions');
      }
    } catch (e) {
      print('Error fetching suggestions: $e');
    }
  }

  // Clear suggestions when necessary
  void clearSuggestions() {
    state = state.copyWith(suggestions: []);
  }

  // Method to select an address from suggestions and get its details
  Future<void> selectAddress(String placeId) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/details/json?placeid=$placeId&key=$googleMapsApiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final result = json.decode(response.body)['result'];
        final String selectedAddress = result['formatted_address'];
        final double latitude = result['geometry']['location']['lat'];
        final double longitude = result['geometry']['location']['lng'];

        // Update state with the selected address, latitude, and longitude
        state = state.copyWith(
          latitude: latitude,
          longitude: longitude,
          selectedAddress: selectedAddress,
          suggestions: [], // Clear suggestions after selection
        );
      } else {
        throw Exception('Failed to load place details');
      }
    } catch (e) {
      print('Error fetching place details: $e');
    }
  }

  // Fetch states and cities for a selected country (India only in this case)
  void fetchStatesAndCities() {
    filterStates();
    // fetchCities should be triggered when the user selects a state.
  }
}

// Riverpod provider for AddressNotifier
final addressProvider =
    StateNotifierProvider<AddressNotifier, AddressState>((ref) {
  return AddressNotifier();
});
