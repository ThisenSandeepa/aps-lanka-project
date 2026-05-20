class UserModel {
  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.token,
  });

  final int id;
  final String name;
  final String email;
  final String token;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final firstName = json['firstName']?.toString();
    final lastName = json['lastName']?.toString();
    final fullName = [
      if (firstName != null && firstName.isNotEmpty) firstName,
      if (lastName != null && lastName.isNotEmpty) lastName,
    ].join(' ');

    return UserModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: (json['name'] ?? fullName).toString().trim().isEmpty
          ? 'APS Lanka User'
          : (json['name'] ?? fullName).toString(),
      email: (json['email'] ?? '').toString(),
      token: (json['token'] ?? json['accessToken'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'token': token,
    };
  }
}
