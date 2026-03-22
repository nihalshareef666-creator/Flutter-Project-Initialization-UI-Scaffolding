enum UserRole {
  administrator,
  admin,
  staff,
  customer,
}

class User {
  final String name;
  final String email;
  final String phone;
  final String password;
  final String? shopName;
  final String? shopId;
  final UserRole role;

  User({
    required this.name,
    required this.email,
    this.phone = '',
    this.password = 'password123',
    this.shopName,
    this.shopId,
    required this.role,
  });

  User copyWith({
    String? name,
    String? email,
    String? phone,
    String? password,
    String? shopName,
    String? shopId,
    UserRole? role,
  }) {
    return User(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      shopName: shopName ?? this.shopName,
      shopId: shopId ?? this.shopId,
      role: role ?? this.role,
    );
  }
}
