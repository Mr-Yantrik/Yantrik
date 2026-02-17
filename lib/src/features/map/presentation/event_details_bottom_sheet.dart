import 'package:flutter/material.dart';
import '../../events/domain/event_model.dart';

class EventDetailsBottomSheet extends StatelessWidget {
  final Event event;

  const EventDetailsBottomSheet({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            event.title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  event.address,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Verified Badge
          if (event.createdBy == 'user1' || event.createdBy == 'verified_ngo') // Mock verification
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.blue),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.verified, size: 14, color: Colors.blue),
                  SizedBox(width: 4),
                  Text('Verified Source', style: TextStyle(color: Colors.blue, fontSize: 12)),
                ],
              ),
            ),
          const SizedBox(height: 8),
          Text(
            event.description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          // Trust Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              OutlinedButton.icon(
                onPressed: () {
                   ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Upvoted! Karma added.')),
                  );
                },
                icon: const Icon(Icons.thumb_up_alt_outlined, size: 18),
                label: const Text('Helpful'),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Report submitted to admins.')),
                  );
                },
                icon: const Icon(Icons.flag_outlined, size: 18, color: Colors.red),
                label: const Text('Report', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Chip(
                label: Text(event.type.name.toUpperCase()),
                backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
              ),
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: Navigate functionality
                },
                icon: const Icon(Icons.directions),
                label: const Text('Navigate'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
