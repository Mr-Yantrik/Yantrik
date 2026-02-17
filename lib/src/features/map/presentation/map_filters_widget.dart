import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../events/domain/event_model.dart';
import 'map_controller.dart';

class MapFiltersWidget extends ConsumerWidget {
  const MapFiltersWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapState = ref.watch(mapControllerProvider);
    final controller = ref.read(mapControllerProvider.notifier);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Veg Only Filter
          FilterChip(
            label: const Text('Pure Veg'),
            selected: mapState.showVegOnly,
            onSelected: (_) => controller.toggleVegOnly(),
            selectedColor: Colors.green[100],
            avatar: Icon(
              Icons.eco,
              color: mapState.showVegOnly ? Colors.green : Colors.grey,
              size: 18,
            ),
          ),
          const SizedBox(width: 8),

          // Radius Filter (Simple toggle for demo: 1km, 5km, 10km)
          PopupMenuButton<double>(
            initialValue: mapState.radiusKm,
            onSelected: controller.setRadius,
            child: Chip(
              label: Text('${mapState.radiusKm.toInt()} km'),
              avatar: const Icon(Icons.radar, size: 18),
            ),
            itemBuilder: (context) => [
              const PopupMenuItem(value: 1.0, child: Text('1 km')),
              const PopupMenuItem(value: 5.0, child: Text('5 km')),
              const PopupMenuItem(value: 10.0, child: Text('10 km')),
              const PopupMenuItem(value: 50.0, child: Text('50 km')),
            ],
          ),
          const SizedBox(width: 8),

          // Category Filters
          ...EventType.values.map((type) {
            final isSelected = mapState.selectedCategory == type;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(type.name.toUpperCase()),
                selected: isSelected,
                onSelected: (_) => controller.setCategory(type),
                selectedColor: Colors.orange[100],
                labelStyle: TextStyle(
                  color: isSelected ? Colors.deepOrange : Colors.black,
                  fontSize: 12,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
