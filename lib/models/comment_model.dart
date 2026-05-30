import 'package:hive/hive.dart';

part 'comment_model.g.dart';

@HiveType(typeId: 4)
class CommentModel extends HiveObject {
  @HiveField(0) late String id;
  @HiveField(1) late String chapterId;
  @HiveField(2) late String userId;
  @HiveField(3) late String username;
  @HiveField(4) late String text;
  @HiveField(5) int likes;
  @HiveField(6) DateTime createdAt;

  CommentModel({
    required this.id,
    required this.chapterId,
    required this.userId,
    required this.username,
    required this.text,
    this.likes = 0,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}