import 'package:hive/hive.dart';

part 'image_post_model.g.dart';

@HiveType(typeId: 5)
class ImagePostModel extends HiveObject {
  @HiveField(0) late String id;
  @HiveField(1) late String userId;
  @HiveField(2) late String username;
  @HiveField(3) late String imagePath;
  @HiveField(4) late String title;
  @HiveField(5) late String description;
  @HiveField(6) late String category;
  @HiveField(7) int likes;
  @HiveField(8) List<String> likedByIds;
  @HiveField(9) DateTime createdAt;

  ImagePostModel({
    required this.id,
    required this.userId,
    required this.username,
    required this.imagePath,
    required this.title,
    this.description = '',
    required this.category,
    this.likes = 0,
    List<String>? likedByIds,
    DateTime? createdAt,
  })  : likedByIds = likedByIds ?? [],
        createdAt = createdAt ?? DateTime.now();
}