import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/user_model.dart';

class AuthRepository {
  UserModel? _currentUser;

  Stream<UserModel?> get authStateChanges async* {
    yield _currentUser;
  }

  UserModel? get currentUser => _currentUser;

  Future<void> signInWithPhone(String phoneNumber) async {
    await Future.delayed(const Duration(seconds: 1)); 
    // In real app, this triggers OTP
  }

  Future<void> verifyOtp(String otp) async {
    await Future.delayed(const Duration(seconds: 1));
    if (otp == '123456') {
      _currentUser = UserModel(
        uid: 'mock_uid_123',
        phoneNumber: '+919876543210',
        role: UserRole.user,
        karmaPoints: 10,
      );
    } else {
      throw Exception('Invalid OTP');
    }
  }

  Future<void> signOut() async {
    await Future.delayed(const Duration(seconds: 1));
    _currentUser = null;
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

final authStateProvider = StreamProvider<UserModel?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});
