import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String token;
  final String name;

  const UserEntity({required this.token, required this.name});

  @override
  List<Object?> get props => [token, name];
}
