import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../../events/domain/event_model.dart';
import '../../events/data/event_repository.dart';
import '../../map/presentation/location_picker_screen.dart';
import 'dart:io';

class AddEventScreen extends ConsumerStatefulWidget {
  const AddEventScreen({super.key});

  @override
  ConsumerState<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends ConsumerState<AddEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  
  EventType _selectedType = EventType.bhandara;
  FoodType _selectedFoodType = FoodType.veg;
  DateTime _startTime = DateTime.now();
  DateTime _endTime = DateTime.now().add(const Duration(hours: 4));
  bool _isSubmitting = false;
  File? _imageFile;
  LatLng? _pickedLocation;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickLocation() async {
    final result = await context.push('/add-event/pick-location');
    if (result != null && result is LatLng) {
      setState(() {
        _pickedLocation = result;
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_pickedLocation == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please pick a location on map')),
        );
        return;
      }
      setState(() => _isSubmitting = true);

      final newEvent = Event(
        id: DateTime.now().millisecondsSinceEpoch.toString(), // Mock ID
        title: _titleController.text,
        description: _descriptionController.text,
        type: _selectedType,
        location: GeoPoint(_pickedLocation!.latitude, _pickedLocation!.longitude),
        address: _addressController.text,
        startTime: _startTime,
        endTime: _endTime,
        status: EventStatus.active,
        createdBy: 'currentUser', // Mock user
        foodType: _selectedFoodType,
        imageUrl: _imageFile?.path, // Storing local path for mock
      );

      try {
        await ref.read(eventRepositoryProvider).addEvent(newEvent);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Event added successfully!')),
          );
          context.pop();
          // Ideally refresh the map
          ref.refresh(activeEventsProvider);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error adding event: $e')),
          );
        }
      } finally {
        if (mounted) setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Event')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Event Title'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter a title' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<EventType>(
                value: _selectedType,
                decoration: const InputDecoration(labelText: 'Event Type'),
                items: EventType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type.name.toUpperCase()),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedType = value!),
              ),
               const SizedBox(height: 16),
              DropdownButtonFormField<FoodType>(
                value: _selectedFoodType,
                decoration: const InputDecoration(labelText: 'Food Type'),
                items: FoodType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type.name.toUpperCase()),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedFoodType = value!),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter description' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter address' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                   Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _pickLocation,
                      icon: const Icon(Icons.map),
                      label: Text(_pickedLocation == null ? 'Pick Location' : 'Location Picked'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (_pickedLocation != null)
                     const Icon(Icons.check_circle, color: Colors.green),
                ],
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: _imageFile != null
                      ? Image.file(_imageFile!, fit: BoxFit.cover)
                      : const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt, size: 40, color: Colors.grey),
                            Text('Add Photo'),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('SUBMIT EVENT'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
