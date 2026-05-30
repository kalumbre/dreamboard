import 'package:hive/hive.dart';

part 'dreamtoon_model.g.dart';

@HiveType(typeId: 1)
class DreamToonModel extends HiveObject {
  @HiveField(0) late String id;
  @HiveField(1) late String title;
  @HiveField(2) late String description;
  @HiveField(3) late String artistId;
  @HiveField(4) late String artistName;
  @HiveField(5) String? coverImagePath;
  @HiveField(6) List<String> genres;
  @HiveField(7) List<String> chapterIds;
  @HiveField(8) int likes;
  @HiveField(9) DateTime createdAt;
  @HiveField(10) bool isFeatured;

  DreamToonModel({
    required this.id,
    required this.title,
    required this.description,
    required this.artistId,
    required this.artistName,
    this.coverImagePath,
    List<String>? genres,
    List<String>? chapterIds,
    this.likes = 0,
    DateTime? createdAt,
    this.isFeatured = false,
  })  : genres = genres ?? [],
        chapterIds = chapterIds ?? [],
        createdAt = createdAt ?? DateTime.now();
}