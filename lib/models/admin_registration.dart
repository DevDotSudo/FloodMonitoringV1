class AdminRegistration {
  final String? id;
  final String username;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String password;

  AdminRegistration({
    this.id,
    required this.username,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.password,
  });
}
