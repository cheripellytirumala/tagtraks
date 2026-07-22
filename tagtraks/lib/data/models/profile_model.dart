import '../../domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.userAccountId,
    required super.userName,
    required super.email,
    required super.contact,
    required super.profileImageUrl,
  });
}
