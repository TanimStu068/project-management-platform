enum UserRole { admin, buyer, developer }

class User {
  final int id;
  final String email;
  final UserRole role;

  User({required this.id, required this.email, required this.role});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      role: UserRole.values.firstWhere(
        (r) => r.toString() == 'UserRole.' + json['role'],
      ),
    );
  }
}
