import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../events/domain/event_model.dart';

class EventRepository {
  // Mock data for initial testing
  final List<Event> _mockEvents = [
    Event(
      id: '1',
      title: 'Sai Baba Temple Bhandara',
      description: 'Free lunch for everyone. Rice, Dal, and Sabzi.',
      type: EventType.bhandara,
      location: const GeoPoint(28.6139, 77.2090), // near New Delhi
      address: 'Connaught Place, New Delhi',
      startTime: DateTime.now(),
      endTime: DateTime.now().add(const Duration(hours: 4)),
      status: EventStatus.active,
      createdBy: 'user1',
      foodType: FoodType.veg,
    ),
    Event(
      id: '2',
      title: 'Community Langar',
      description: 'Freshly cooked meal served with love.',
      type: EventType.langar,
      location: const GeoPoint(28.6200, 77.2100),
      address: 'Near Metro Station',
      startTime: DateTime.now(),
      endTime: DateTime.now().add(const Duration(hours: 6)),
      status: EventStatus.active,
      createdBy: 'user2',
      foodType: FoodType.veg,
    ),
  ];

  Future<List<Event>> getActiveEvents() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    return _mockEvents;
  }

  Future<void> addEvent(Event event) async {
    await Future.delayed(const Duration(seconds: 1));
    _mockEvents.add(event);
  }
}

final eventRepositoryProvider = Provider<EventRepository>((ref) {
  return EventRepository();
});

final activeEventsProvider = FutureProvider<List<Event>>((ref) async {
  final repository = ref.watch(eventRepositoryProvider);
  return repository.getActiveEvents();
});
