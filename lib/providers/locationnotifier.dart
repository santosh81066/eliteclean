import 'dart:convert';
import 'package:riverpod/riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

import '../models/locationstate.dart';

class LocationNotifier extends StateNotifier<LocationState> {
  LocationNotifier() : super(LocationState(isLoading: true));

  // New method to set current location and fetch the address

  // Function to get address from latitude and longitude using Google Places API
}

final locationProvider =
    StateNotifierProvider<LocationNotifier, LocationState>((ref) {
  return LocationNotifier();
});
