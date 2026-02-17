enum UserRole { user, volunteer, admin }

class UserModel {
  final String uid;
  final String phoneNumber;
  final UserRole role;
  final int karmaPoints;

  UserModel({
    required this.uid,
    required this.phoneNumber,
    required this.role,
    required this.karmaPoints,
  });

  factory UserModel.fromMap(Map<String, dynamic> data, String uid) {
    return UserModel(
      uid: uid,
      phoneNumber: data['phoneNumber'] ?? '',
      role: UserRole.values.firstWhere((e) => e.name == data['role'], orElse: () => UserRole.user),
      karmaPoints: data['karmaPoints'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'phoneNumber': phoneNumber,
      'role': role.name,
      'karmaPoints': karmaPoints,
    };
  }
}
