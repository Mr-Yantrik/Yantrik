import 'package:cloud_firestore/cloud_firestore.dart';

enum EventType { bhandara, langar, ngoCamp, templeMeal, lowCost, shopOpening }
enum EventStatus { active, completed, reported, expired }
enum FoodType { veg, nonVeg, both }

class Event {
  final String id;
  final String title;
  final String description;
  final EventType type;
  final GeoPoint location;
  final String address;
  final DateTime startTime;
  final DateTime endTime;
  final EventStatus status;
  final String createdBy;
  final FoodType foodType;
  final String? imageUrl;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.location,
    required this.address,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.createdBy,
    required this.foodType,
    this.imageUrl,
  });

  factory Event.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Event(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      type: EventType.values.firstWhere((e) => e.name == data['type'], orElse: () => EventType.bhandara),
      location: data['location'] ?? const GeoPoint(0, 0),
      address: data['address'] ?? '',
      startTime: (data['startTime'] as Timestamp).toDate(),
      endTime: (data['endTime'] as Timestamp).toDate(),
      status: EventStatus.values.firstWhere((e) => e.name == data['status'], orElse: () => EventStatus.active),
      createdBy: data['createdBy'] ?? '',
      foodType: FoodType.values.firstWhere((e) => e.name == data['foodType'], orElse: () => FoodType.veg),
      imageUrl: data['imageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'type': type.name,
      'location': location,
      'address': address,
      'startTime': Timestamp.fromDate(startTime),
      'endTime': Timestamp.fromDate(endTime),
      'status': status.name,
      'createdBy': createdBy,
      'foodType': foodType.name,
      'imageUrl': imageUrl,
    };
  }
}
