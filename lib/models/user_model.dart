class UserModel {
  final String id;
  final String name;
  final String email;
  final String avatar;
  final String old;   // Age
  final String phone;
  final String home;  // Address

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
    required this.old,
    required this.phone,
    required this.home,
  });

  // Convert Firestore document to UserModel
  factory UserModel.fromFirestore(Map<String, dynamic> json, String id) {
    return UserModel(
      id: id,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      avatar: json['avatar'] ?? 'https://via.placeholder.com/150',
      old: json['old'] ?? '',
      phone: json['phone'] ?? '',
      home: json['home'] ?? '',
    );
  }

  // Convert UserModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'avatar': avatar,
      'old': old,
      'phone': phone,
      'home': home,
    };
  }
}
