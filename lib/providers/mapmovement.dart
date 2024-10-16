import 'package:flutter_riverpod/flutter_riverpod.dart';

class MapMovementNotifier extends StateNotifier<bool> {
  MapMovementNotifier() : super(false); // Initialize with `false`

  void setMapIsMooving(bool isMooving) {
    state = isMooving;
  }
}

final mapMovementProvider =
    StateNotifierProvider<MapMovementNotifier, bool>((ref) {
  return MapMovementNotifier();
});
