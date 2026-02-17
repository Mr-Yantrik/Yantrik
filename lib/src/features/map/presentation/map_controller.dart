import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../events/domain/event_model.dart'; // Needed for EventType

class MapState {
  final LatLng? currentLocation;
  final bool isLoading;
  final EventType? selectedCategory;
  final bool showVegOnly;
  final double radiusKm;

  MapState({
    this.currentLocation,
    this.isLoading = true,
    this.selectedCategory,
    this.showVegOnly = false,
    this.radiusKm = 5.0,
  });

  MapState copyWith({
    LatLng? currentLocation,
    bool? isLoading,
    EventType? selectedCategory,
    bool? showVegOnly,
    double? radiusKm,
  }) {
    return MapState(
      currentLocation: currentLocation ?? this.currentLocation,
      isLoading: isLoading ?? this.isLoading,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      showVegOnly: showVegOnly ?? this.showVegOnly,
      radiusKm: radiusKm ?? this.radiusKm,
    );
  }
}

class MapController extends Notifier<MapState> {
  @override
  MapState build() {
    return MapState();
  }

  void setCategory(EventType? category) {
    state = state.copyWith(
      selectedCategory: state.selectedCategory == category ? null : category,
    );
  }

  void toggleVegOnly() {
    state = state.copyWith(showVegOnly: !state.showVegOnly);
  }

  void setRadius(double radius) {
    state = state.copyWith(radiusKm: radius);
  }

  Future<void> getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      return;
    } 

    final position = await Geolocator.getCurrentPosition();
    state = MapState(
        currentLocation: LatLng(position.latitude, position.longitude),
        isLoading: false);
  }
}

final mapControllerProvider =
    NotifierProvider<MapController, MapState>(MapController.new);
