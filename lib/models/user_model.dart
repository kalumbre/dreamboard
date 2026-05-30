import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0) late String id;
  @HiveField(1) late String username;
  @HiveField(2) late String email;
  @HiveField(3) late String password;
  @HiveField(4) late String userType; // 'user' o 'artist'
  @HiveField(5) String? profileImagePath;
  @HiveField(6) String? bannerImagePath;
  @HiveField(7) String bio;
  @HiveField(8) List<String> favoriteIds;
  @HiveField(9) List<String> followingIds;
  @HiveField(10) List<String> boardIds;
  @HiveField(11) DateTime createdAt;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.userType,
    this.profileImagePath,
    this.bannerImagePath,
    this.bio = '',
    List<String>? favoriteIds,
    List<String>? followingIds,
    List<String>? boardIds,
    DateTime? createdAt,
  })  : favoriteIds = favoriteIds ?? [],
        followingIds = followingIds ?? [],
        boardIds = boardIds ?? [],
        createdAt = createdAt ?? DateTime.now();

  bool get isArtist => userType == 'artist';
}