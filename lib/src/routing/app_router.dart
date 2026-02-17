import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/map/presentation/map_screen.dart';
import '../features/events/presentation/add_event_screen.dart';
import '../features/map/presentation/location_picker_screen.dart';
import '../features/authentication/presentation/login_screen.dart';
import '../features/authentication/presentation/otp_screen.dart';
import '../features/profile/presentation/profile_screen.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const MapScreen(),
        routes: [
          GoRoute(
            path: 'add-event',
            builder: (context, state) => const AddEventScreen(),
            routes: [
              GoRoute(
                path: 'pick-location',
                builder: (context, state) => const LocationPickerScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/otp',
        builder: (context, state) => const OtpScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
  );
});
