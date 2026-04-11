class UserModel {
  final String uid;
  final String name;
  final String email;
  final String age;
  final String role;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.age,
    required this.role,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'],
      name: data['name'],
      email: data['email'],
      age: data['age'],
      role: data['role'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'age': age,
      'role': role,
    };
  }
}