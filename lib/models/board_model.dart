import 'package:hive/hive.dart';

part 'board_model.g.dart';

@HiveType(typeId: 3)
class BoardModel extends HiveObject {
  @HiveField(0) late String id;
  @HiveField(1) late String userId;
  @HiveField(2) late String name;
  @HiveField(3) String description;
  @HiveField(4) List<String> dreamtoonIds;
  @HiveField(5) String? coverImagePath;
  @HiveField(6) DateTime createdAt;
  @HiveField(7) List<String> imageIds; // IDs de imágenes del feed

  BoardModel({
    required this.id,
    required this.userId,
    required this.name,
    this.description = '',
    List<String>? dreamtoonIds,
    this.coverImagePath,
    DateTime? createdAt,
    List<String>? imageIds,
  })  : dreamtoonIds = dreamtoonIds ?? [],
        imageIds = imageIds ?? [],
        createdAt = createdAt ?? DateTime.now();
}