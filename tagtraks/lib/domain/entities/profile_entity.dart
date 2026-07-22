import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final int userAccountId;
  final String userName;
  final String email;
  final String contact;
  final String profileImageUrl;

  const ProfileEntity({
    required this.userAccountId,
    required this.userName,
    required this.email,
    required this.contact,
    required this.profileImageUrl,
  });

  @override
  List<Object?> get props => [
        userAccountId,
        userName,
        email,
        contact,
        profileImageUrl,
      ];
}
