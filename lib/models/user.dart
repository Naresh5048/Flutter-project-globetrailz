// lib/models/user.dart
class AppUser {
  String username;
  String email;
  String password;
  String? avatarPath; // local path or base64 in future

  AppUser({
    required this.username,
    required this.email,
    required this.password,
    this.avatarPath,
  });

  Map<String, dynamic> toMap() => {
        'username': username,
        'email': email,
        'password': password,
        'avatarPath': avatarPath,
      };

  factory AppUser.fromMap(Map<String, dynamic> m) => AppUser(
        username: m['username'] ?? '',
        email: m['email'] ?? '',
        password: m['password'] ?? '',
        avatarPath: m['avatarPath'],
      );
}
