import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({required super.token, required super.name});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      token: json['token'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'name': name,
    };
  }
}
