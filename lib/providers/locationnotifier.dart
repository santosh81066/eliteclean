import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:riverpod/riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

import '../models/locationstate.dart';

class LocationNotifier extends StateNotifier<LocationState> {
  LocationNotifier() : super(LocationState(isLoading: true)) {
    getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    try {
      print("Fetching location...");
      state = state.copyWith(isLoading: true);

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
        currentPosition: currentPosition,
        isLoading: false,
        address: address,
      );

      print(
          "State updated with location: $currentPosition and address: $address");
    } catch (error) {
      print("Error fetching location: $error");
      state = state.copyWith(errorMessage: error.toString(), isLoading: false);
    }
  }

  Future<void> clearaddress() async {
    state = state.copyWith(address: null);
  }

  // Method to set current location and fetch the address
  Future<void> setCurrentLocation(LatLng newPosition) async {
    try {
      state = state.copyWith(isLoading: true);

      // Fetch the address based on the new position
      String address = await _getAddressFromLatLng(newPosition);

      // Update the state with the new position and address
      state = state.copyWith(
        currentPosition: newPosition,
        address: address,
        isLoading: false,
      );
      print("setCurrentLocation: ${state.currentPosition}");
    } catch (error) {
      state = state.copyWith(errorMessage: error.toString(), isLoading: false);
    }
  }

  // Future<void> uploadLocationToRealtimeDB(
  //     String id, LatLng position, String address) async {
  //   final DatabaseReference dbRef = FirebaseDatabase.instance.ref();
  //   User? user = FirebaseAuth.instance.currentUser;
  //   try {
  //     // Append location data to the 'locations' list under the given ID
  //     await dbRef.child('${user!.uid}/address_list').push().set({
  //       'latitude': position.latitude,
  //       'longitude': position.longitude,
  //       'address': address,
  //       'time': DateTime.now().toIso8601String(),
  //     });
  //     print("Location added to list in Realtime Database");
  //   } catch (e) {
  //     print("Failed to upload location: $e");
  //   }
  // }

  // Function to get address from latitude and longitude using Google Places API
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
}

final locationProvider =
    StateNotifierProvider<LocationNotifier, LocationState>((ref) {
  return LocationNotifier();
});
