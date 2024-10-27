import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
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

  Future<void> getCurrentLocation() async {
    try {
      print("Fetching location...");

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception("Location services are disabled.");
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception("Location permissions are denied.");
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception("Location permissions are permanently denied.");
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      print("Location fetched: ${position.latitude}, ${position.longitude}");

      LatLng currentPosition = LatLng(position.latitude, position.longitude);

      // Fetch the address using the current position
      String address = await _getAddressFromLatLng(currentPosition);

      // Update state with the current position and address
      state = state.copyWith(
        latitude: position.latitude,
        longitude: position.longitude,
        selectedAddress: address,
      );

      print(
          "State updated with location: $currentPosition and address: $address");
    } catch (error) {
      print("Error fetching location: $error");
    }
  }

  Future<void> setCurrentLocation(LatLng newPosition) async {
    try {
      // Fetch the address based on the new position
      String address = await _getAddressFromLatLng(newPosition);

      // Update the state with the new position and address
      state = state.copyWith(
        latitude: newPosition.latitude,
        longitude: newPosition.longitude,
        selectedAddress: address,
      );
      print("setCurrentLocation: ${state.latitude}${state.longitude}");
    } catch (error) {
      print("error $error");
    }
  }

  Future<String> _getAddressFromLatLng(LatLng position) async {
    const String apiKey =
        'AIzaSyD6dWPriVXORUS6TYs8P71Cbp0Yrpxzl_4'; // Replace with your API key
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$apiKey',
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      if (data['status'] == 'OK' && data['results'].isNotEmpty) {
        return data['results'][0]['formatted_address'];
      } else {
        throw Exception("Failed to fetch address");
      }
    } else {
      throw Exception("Failed to fetch address");
    }
  }

  Future<void> clearaddress() async {
    state = state.copyWith(selectedAddress: null);
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
  // Future<void> fetchAddressSuggestions(String input) async {
  //   print("fetchAddressSuggestions triggerd");
  //   if (input.isEmpty) return;
  //
  //   final String baseUrl =
  //       'https://maps.googleapis.com/maps/api/place/autocomplete/json';
  //   final url =
  //       Uri.parse('$baseUrl?input=$input&key=$googleMapsApiKey&types=geocode');
  //
  //   try {
  //     final http.Response response = await http.get(url);
  //     if (response.statusCode == 200) {
  //       final List<dynamic> suggestions =
  //           json.decode(response.body)['predictions'];
  //       state = state.copyWith(suggestions: suggestions);
  //       print("Suggestions:${state.suggestions}");
  //     } else {
  //       throw Exception('Failed to load suggestions');
  //     }
  //   } catch (e) {
  //     print('Error fetching suggestions: $e');
  //   }
  // }

  Future<void> fetchAddressSuggestions(
      String input, double latitude, double longitude) async {
    print("fetchAddressSuggestions triggered");

    if (input.isEmpty) return;

    final String baseUrl =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';

    final String googleMapsApiKey =
        'AIzaSyD6dWPriVXORUS6TYs8P71Cbp0Yrpxzl_4'; // replace with your API key
    final int radius = 5000; // Radius in meters for nearby suggestions (5 km)

    // Add location and radius to get suggestions based on proximity
    final url = Uri.parse(
        '$baseUrl?input=$input&location=$latitude,$longitude&radius=$radius&key=$googleMapsApiKey&types=geocode');

    try {
      final http.Response response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> suggestions =
            json.decode(response.body)['predictions'];

        // Handle suggestions (this would depend on your state management)
        state = state.copyWith(suggestions: suggestions);
        print("Suggestions: ${state.suggestions}");
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

  Future<void> uploadLocationToRealtimeDB(
      String id, double latitude, double longitude, String address) async {
    final DatabaseReference dbRef = FirebaseDatabase.instance.ref();
    User? user = FirebaseAuth.instance.currentUser;
    try {
      // Append location data to the 'locations' list under the given ID
      await dbRef.child('${user!.uid}/address_list').push().set({
        'latitude': latitude,
        'longitude': longitude,
        'address': address,
        'time': DateTime.now().toIso8601String(),
      });
      print("Location added to list in Realtime Database");
    } catch (e) {
      print("Failed to upload location: $e");
    }
  }

  void updateState(
      {String? address, int? selectedIndex, double? lat, double? long}) {
    state = state.copyWith(
        selectedAddress: address,
        selectedIndex: selectedIndex,
        latitude: lat,
        longitude: long);
  }
}

// Riverpod provider for AddressNotifier
final addressProvider =
    StateNotifierProvider<AddressNotifier, AddressState>((ref) {
  return AddressNotifier();
});
