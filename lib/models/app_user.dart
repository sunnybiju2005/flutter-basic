class AppUser {
  final String id;
  final String name;
  final String email;
  final String phone;
  final bool isAdmin;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.isAdmin = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'isAdmin': isAdmin,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      isAdmin: map['isAdmin'] ?? false,
    );
  }
}
