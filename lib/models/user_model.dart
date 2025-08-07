class UserCreate {
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final String? phone;
  final String password;

  UserCreate({
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    this.phone,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'first_name': firstName,
      'last_name': lastName,
      'username': username,
      'email': email,
      'password': password,
    };

    if (phone != null && phone!.isNotEmpty) {
      data['phone_number'] = phone;
    }

    return data;
  }
}

class UserResponse {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String? imageUrl;

  UserResponse({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.imageUrl,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      imageUrl: json['image_url'],
    );
  }
}
