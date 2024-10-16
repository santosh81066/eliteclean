import 'package:latlong2/latlong.dart';

class LocationState {
  final LatLng? currentPosition;
  final bool isLoading;
  final String? errorMessage;
  final String? address; // Add the address field

  LocationState({
    this.currentPosition,
    this.isLoading = false,
    this.errorMessage,
    this.address,
  });

  LocationState copyWith({
    LatLng? currentPosition,
    bool? isLoading,
    String? errorMessage,
    String? address, // Add copyWith for address
  }) {
    return LocationState(
      currentPosition: currentPosition ?? this.currentPosition,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      address: address ?? this.address, // Update address if provided
    );
  }
}
