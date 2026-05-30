import 'package:hive_flutter/hive_flutter.dart';
import '../models/user_model.dart';
import '../models/dreamtoon_model.dart';
import '../models/chapter_model.dart';
import '../models/board_model.dart';
import '../models/comment_model.dart';
import '../models/image_post_model.dart';

class HiveService {
  static const String usersBox      = 'users';
  static const String dreamtoonsBox = 'dreamtoons';
  static const String chaptersBox   = 'chapters';
  static const String boardsBox     = 'boards';
  static const String settingsBox   = 'settings';
  static const String commentsBox   = 'comments';
  static const String imagePostsBox = 'image_posts';

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(UserModelAdapter());
    Hive.registerAdapter(DreamToonModelAdapter());
    Hive.registerAdapter(ChapterModelAdapter());
    Hive.registerAdapter(BoardModelAdapter());
    Hive.registerAdapter(CommentModelAdapter());
    Hive.registerAdapter(ImagePostModelAdapter());

    await Hive.openBox<UserModel>(usersBox);
    await Hive.openBox<DreamToonModel>(dreamtoonsBox);
    await Hive.openBox<ChapterModel>(chaptersBox);
    await Hive.openBox<BoardModel>(boardsBox);
    await Hive.openBox(settingsBox);
    await Hive.openBox<CommentModel>(commentsBox);
    await Hive.openBox<ImagePostModel>(imagePostsBox);

    await _seedDemoData();
  }

  static Future<void> _seedDemoData() async {
    final dtBox = Hive.box<DreamToonModel>(dreamtoonsBox);
    final chapBox = Hive.box<ChapterModel>(chaptersBox);
    final imgBox = Hive.box<ImagePostModel>(imagePostsBox);

    if (dtBox.isEmpty) {
      final demos = [
        DreamToonModel(id: 'd1', title: 'Sueños de Colores', description: 'Una historia mágica llena de color y esperanza.', artistId: 'a1', artistName: 'ArtistaDream', genres: ['Fantasía', 'Romance'], likes: 142, isFeatured: true, coverImagePath: 'assets/covers/suenos_de_colores.jpg'),
        DreamToonModel(id: 'd2', title: 'Luna de Cristal', description: 'Aventuras bajo la luna pastel.', artistId: 'a1', artistName: 'ArtistaDream', genres: ['Aventura'], likes: 89, coverImagePath: 'assets/covers/luna_de_cristal.jpg'),
        DreamToonModel(id: 'd3', title: 'Jardín Eterno', description: 'Un jardín donde los sueños florecen.', artistId: 'a2', artistName: 'PastelArt', genres: ['Slice of Life'], likes: 234, isFeatured: true, coverImagePath: 'assets/covers/jardin_eterno.jpg'),
        DreamToonModel(id: 'd4', title: 'Estrellas Perdidas', description: 'Buscando estrellas en el infinito.', artistId: 'a2', artistName: 'PastelArt', genres: ['Ciencia Ficción'], likes: 67, coverImagePath: 'assets/covers/estrellas_perdidas.jpg'),
        DreamToonModel(id: 'd5', title: 'Rosa Salvaje', description: 'Drama y amor entre pétalos.', artistId: 'a3', artistName: 'DreamCreator', genres: ['Drama', 'Romance'], likes: 315, isFeatured: true, coverImagePath: 'assets/covers/rosa_salvaje.jpg'),
        DreamToonModel(id: 'd6', title: 'Nubes de Azúcar', description: 'Dulce historia de amistad.', artistId: 'a3', artistName: 'DreamCreator', genres: ['Comedia'], likes: 198, coverImagePath: 'assets/covers/nubes_de_azucar.jpg'),
      ];
      for (final d in demos) dtBox.put(d.id, d);

      final caps = [
        ChapterModel(id: 'c1', dreamtoonId: 'd1', title: 'Semillas de luz', chapterNumber: 1, demoTexts: ['Era una mañana de primavera cuando todo cambió...', 'La chica con cabello rosa descubrió algo brillando entre las flores.', '— ¿Qué es esto? —susurró mientras tomaba el cristal luminoso.', 'El cristal pulsaba suavemente en su mano, como un corazón latiendo.', 'Desde ese día, su vida nunca volvería a ser igual... ✨']),
        ChapterModel(id: 'c2', dreamtoonId: 'd1', title: 'El despertar', chapterNumber: 2, demoTexts: ['Tres días después del hallazgo...', 'Los poderes comenzaron a manifestarse de formas inesperadas.', '— ¡No puedo controlarlo! —gritó mientras flores brotaban a su alrededor.', 'Su mejor amiga la observaba con ojos llenos de asombro.', '— Eres increíble —dijo finalmente con una sonrisa. 🌸']),
        ChapterModel(id: 'c3', dreamtoonId: 'd3', title: 'El primer día', chapterNumber: 1, demoTexts: ['El jardín siempre había estado ahí, al final de la calle.', 'Pero nadie parecía verlo excepto ella.', '— ¿Por qué yo puedo verlo? —se preguntó la pequeña.', 'Las flores de colores pastel bailaban con el viento.', 'Y entre ellas, una voz suave la llamó por su nombre... 🌺']),
        ChapterModel(id: 'c4', dreamtoonId: 'd5', title: 'Encuentro', chapterNumber: 1, demoTexts: ['La lluvia caía sobre la ciudad de las flores.', 'Dos paraguas chocaron en la esquina del mercado.', '— Lo siento mucho —dijo él con las mejillas sonrojadas.', '— Yo también... —respondió ella sin poder apartar la mirada.', 'Ninguno de los dos supo que ese accidente cambiaría todo. 🌹']),
      ];
      for (final c in caps) chapBox.put(c.id, c);
    }

    if (imgBox.isEmpty) {
      final demoImgs = [
        // Arte
        ImagePostModel(id: 'i1', userId: 'a1', username: 'ArtistaDream', imagePath: 'assets/images/arte1.jpg', title: 'Arte 🎨', category: 'Arte', likes: 156),
        ImagePostModel(id: 'i2', userId: 'a2', username: 'PastelArt', imagePath: 'assets/images/arte2.jpg', title: 'Arte 2 🎨', category: 'Arte', likes: 98),
        // Aesthetic
        ImagePostModel(id: 'i3', userId: 'a1', username: 'ArtistaDream', imagePath: 'assets/images/aesthetic1.jpg', title: 'Aesthetic pastel 💜', category: 'Aesthetic', likes: 89),
        ImagePostModel(id: 'i4', userId: 'a2', username: 'PastelArt', imagePath: 'assets/images/aesthetic2.jpg', title: 'Aesthetic 2 🌸', category: 'Aesthetic', likes: 201),
        // Icons
        ImagePostModel(id: 'i5', userId: 'a3', username: 'DreamCreator', imagePath: 'assets/images/icons1.jpg', title: 'Icon kawaii 🎀', category: 'Icons', likes: 45),
        ImagePostModel(id: 'i6', userId: 'a1', username: 'ArtistaDream', imagePath: 'assets/images/icons2.jpg', title: 'Icon cute 🌟', category: 'Icons', likes: 67),
        ImagePostModel(id: 'i7', userId: 'a2', username: 'PastelArt', imagePath: 'assets/images/icons3.jpg', title: 'Icon pastel ✨', category: 'Icons', likes: 123),
        // Paisajes
        ImagePostModel(id: 'i8', userId: 'a3', username: 'DreamCreator', imagePath: 'assets/images/paisajes1.jpg', title: 'Paisaje soñado 🌙', category: 'Paisajes', likes: 178),
        ImagePostModel(id: 'i9', userId: 'a1', username: 'ArtistaDream', imagePath: 'assets/images/paisajes2.jpg', title: 'Paisaje 2 🌿', category: 'Paisajes', likes: 234),
        ImagePostModel(id: 'i10', userId: 'a2', username: 'PastelArt', imagePath: 'assets/images/paisajes3.jpg', title: 'Paisaje 3 🌸', category: 'Paisajes', likes: 112),
        // Personajes
        ImagePostModel(id: 'i11', userId: 'a3', username: 'DreamCreator', imagePath: 'assets/images/personaje1.jpg', title: 'Personaje OC ✨', category: 'Personajes', likes: 67),
        ImagePostModel(id: 'i12', userId: 'a1', username: 'ArtistaDream', imagePath: 'assets/images/personaje2.jpg', title: 'Personaje 2 🌟', category: 'Personajes', likes: 89),
        ImagePostModel(id: 'i13', userId: 'a2', username: 'PastelArt', imagePath: 'assets/images/personaje3.jpg', title: 'Personaje 3 💫', category: 'Personajes', likes: 134),
        // Referencias
        ImagePostModel(id: 'i14', userId: 'a3', username: 'DreamCreator', imagePath: 'assets/images/referencias1.jpg', title: 'Referencia poses 🌺', category: 'Referencias', likes: 34),
        ImagePostModel(id: 'i15', userId: 'a1', username: 'ArtistaDream', imagePath: 'assets/images/referencias2.jpg', title: 'Referencia 2 📐', category: 'Referencias', likes: 56),
        ImagePostModel(id: 'i16', userId: 'a2', username: 'PastelArt', imagePath: 'assets/images/referencias3.jpg', title: 'Referencia 3 ✏️', category: 'Referencias', likes: 89),
      ];
      for (final img in demoImgs) imgBox.put(img.id, img);
    }
  }

  // USUARIOS
  static Box<UserModel> get users => Hive.box<UserModel>(usersBox);
  static UserModel? getUserByEmail(String email) {
    try { return users.values.firstWhere((u) => u.email == email); }
    catch (_) { return null; }
  }
  static bool emailExists(String email) =>
      users.values.any((u) => u.email == email);
  static void saveUser(UserModel user) => users.put(user.id, user);

  // DREAMTOONS
  static Box<DreamToonModel> get dreamtoons =>
      Hive.box<DreamToonModel>(dreamtoonsBox);
  static List<DreamToonModel> getAllDreamtoons() =>
      dreamtoons.values.toList();
  static List<DreamToonModel> getFeatured() =>
      dreamtoons.values.where((d) => d.isFeatured).toList();
  static List<DreamToonModel> searchDreamtoons(String q) =>
      dreamtoons.values.where((d) =>
          d.title.toLowerCase().contains(q.toLowerCase()) ||
          d.genres.any((g) => g.toLowerCase().contains(q.toLowerCase())))
          .toList();

  // CAPÍTULOS
  static Box<ChapterModel> get chapters => Hive.box<ChapterModel>(chaptersBox);

  // TABLEROS
  static Box<BoardModel> get boards => Hive.box<BoardModel>(boardsBox);
  static List<BoardModel> getUserBoards(String userId) =>
      boards.values.where((b) => b.userId == userId).toList();

  // COMENTARIOS
  static Box<CommentModel> get comments => Hive.box<CommentModel>(commentsBox);
  static List<CommentModel> getChapterComments(String chapterId) =>
      comments.values.where((c) => c.chapterId == chapterId).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  // IMÁGENES PINTEREST
  static Box<ImagePostModel> get imagePosts =>
      Hive.box<ImagePostModel>(imagePostsBox);
  static List<ImagePostModel> getAllImages() =>
      imagePosts.values.toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  static List<ImagePostModel> getImagesByCategory(String cat) =>
      cat == 'Todos'
          ? getAllImages()
          : imagePosts.values.where((i) => i.category == cat).toList();
  static List<ImagePostModel> searchImages(String q) =>
      imagePosts.values.where((i) =>
          i.title.toLowerCase().contains(q.toLowerCase()) ||
          i.category.toLowerCase().contains(q.toLowerCase()) ||
          i.username.toLowerCase().contains(q.toLowerCase()))
          .toList();

  // CONFIGURACIÓN
  static Box get settings => Hive.box(settingsBox);
  static String? getCurrentUserId() => settings.get('currentUserId');
  static void setCurrentUserId(String? id) =>
      settings.put('currentUserId', id);

  // SEGUIR / DEJAR DE SEGUIR
  static bool isFollowing(String currentUserId, String artistId) {
    final user = users.get(currentUserId);
    return user?.followingIds.contains(artistId) ?? false;
  }
  static void toggleFollow(String currentUserId, String artistId) {
    final user = users.get(currentUserId);
    if (user == null) return;
    if (user.followingIds.contains(artistId)) {
      user.followingIds.remove(artistId);
    } else {
      user.followingIds.add(artistId);
    }
    user.save();
  }
  static int getFollowersCount(String artistId) =>
      users.values.where((u) => u.followingIds.contains(artistId)).length;
}