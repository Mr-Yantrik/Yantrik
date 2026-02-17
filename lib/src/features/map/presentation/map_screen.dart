import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../authentication/data/auth_repository.dart';
import '../../events/data/event_repository.dart';
import '../../events/domain/event_model.dart';
import 'map_controller.dart';
import 'map_filters_widget.dart';
import 'event_details_bottom_sheet.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});
  // ... (rest is same)

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  GoogleMapController? _mapController;
  final LatLng _initialPosition = const LatLng(28.6139, 77.2090); // New Delhi

  @override
  void initState() {
    super.initState();
    // Request location permission on start
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(mapControllerProvider.notifier).getUserLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    final mapState = ref.watch(mapControllerProvider);
    final eventsAsyncValue = ref.watch(activeEventsProvider); // Mock provider

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bhandara Locator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.push('/profile'),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(activeEventsProvider);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            padding: const EdgeInsets.only(top: 60, bottom: 100), // Avoid overlaps
            initialCameraPosition: CameraPosition(
              target: _initialPosition,
              zoom: 12,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            onMapCreated: (controller) {
              _mapController = controller;
              if (mapState.currentLocation != null) {
                _mapController!.animateCamera(
                  CameraUpdate.newLatLng(mapState.currentLocation!),
                );
              }
            },
            markers: eventsAsyncValue.when(
              data: (events) {
                final filteredEvents = events.where((event) {
                  if (mapState.showVegOnly && event.foodType != FoodType.veg) {
                    return false;
                  }
                  if (mapState.selectedCategory != null &&
                      event.type != mapState.selectedCategory) {
                    return false;
                  }
                  // Radius filtering would realistically be done in backend or using Geolocator.distanceBetween
                  // For now, we skip radius math on client for mock data simplicity or could add simple check
                  return true;
                }).toList();

                return filteredEvents.map((event) {
                  return Marker(
                    markerId: MarkerId(event.id),
                    position:
                        LatLng(event.location.latitude, event.location.longitude),
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                      _getMarkerHue(event.type),
                    ),
                    infoWindow: InfoWindow(
                    title: event.title,
                    snippet: event.description,
                  ),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) =>
                          EventDetailsBottomSheet(event: event),
                    );
                  },
                );
              }).toSet();
             },
              loading: () => const <Marker>{},
              error: (_, __) => const <Marker>{},
            ),
          ),
          const SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: MapFiltersWidget(),
            ),
          ),
          if (mapState.isLoading)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'add_event',
            onPressed: () {
              final user = ref.read(authRepositoryProvider).currentUser;
              if (user == null) {
                context.push('/login');
              } else {
                context.push('/add-event');
              }
            },
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'my_location',
            onPressed: () {
              final location = ref.read(mapControllerProvider).currentLocation;
              if (location != null && _mapController != null) {
                _mapController!.animateCamera(CameraUpdate.newLatLng(location));
              } else {
                ref.read(mapControllerProvider.notifier).getUserLocation();
              }
            },
            child: const Icon(Icons.my_location),
          ),
        ],
      ),
    );
  }

  double _getMarkerHue(EventType type) {
    switch (type) {
      case EventType.bhandara:
        return BitmapDescriptor.hueOrange;
      case EventType.langar:
        return BitmapDescriptor.hueGreen;
      case EventType.ngoCamp:
        return BitmapDescriptor.hueBlue;
      case EventType.templeMeal:
        return BitmapDescriptor.hueYellow;
      case EventType.lowCost:
        return BitmapDescriptor.hueCyan;
      case EventType.shopOpening:
        return BitmapDescriptor.hueViolet;
    }
  }
}
