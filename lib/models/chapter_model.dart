import 'package:hive/hive.dart';

part 'chapter_model.g.dart';

@HiveType(typeId: 2)
class ChapterModel extends HiveObject {
  @HiveField(0) late String id;
  @HiveField(1) late String dreamtoonId;
  @HiveField(2) late String title;
  @HiveField(3) late int chapterNumber;
  @HiveField(4) late List<String> imagePaths;
  @HiveField(5) late DateTime createdAt;
  @HiveField(6) late List<String> demoTexts;

  ChapterModel({
    required this.id,
    required this.dreamtoonId,
    required this.title,
    required this.chapterNumber,
    List<String>? imagePaths,
    DateTime? createdAt,
    List<String>? demoTexts,
  })  : imagePaths = imagePaths ?? [],
        demoTexts = demoTexts ?? [],
        createdAt = createdAt ?? DateTime.now();
}