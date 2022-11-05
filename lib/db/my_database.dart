import 'dart:convert';
import 'dart:io';
import 'package:ahanghaa/models/artist/artist_model.dart';
import 'package:ahanghaa/models/music/music_details_model.dart';
import 'package:ahanghaa/models/music/music_model.dart';
import 'package:ahanghaa/providers/main_provider.dart';
import 'package:ahanghaa/utils/const.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class MyDatabase {
  final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
  final idTypeWithUnique = 'INTEGER UNIQUE';
  final textType = 'TEXT';
  final boolType = 'BOOLEAN';
  final integerType = 'INTEGER';
  final blobType = 'BLOB NULL';

  static final MyDatabase instance = MyDatabase._init();

  static Database? _database;

  MyDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('ahanghaa.db');

    return _database!;
  }

  removeDatabase() async => await deleteDatabase('ahanghaa.db');

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    // return await openDatabase(path, version: 1, onCreate: _createDB);

    return await openDatabase(path,
        version: 200, onCreate: _createDB, onUpgrade: _updateDB);
  }

  Future _updateDB(Database db, int lasetVersion, int newVersion) async {}

  Future _createDB(Database db, int version) async {
    await db.execute('''
CREATE TABLE ${RecentlyPlayedDbConst.tableName} ( 
  ${RecentlyPlayedDbConst.recentlyPlayedId} $idType, 
  ${RecentlyPlayedDbConst.id} $idTypeWithUnique,
  ${RecentlyPlayedDbConst.title} $textType,
  ${RecentlyPlayedDbConst.artistName} $textType,
  ${RecentlyPlayedDbConst.coverUrl} $textType
  )
''');

    await db.execute('''
CREATE TABLE ${DownloadedMsuicDbConst.tableName} ( 
  ${DownloadedMsuicDbConst.downloadedMsuicId} $idType, 
  ${DownloadedMsuicDbConst.id} $idTypeWithUnique,
  ${DownloadedMsuicDbConst.filePath} $textType,
  ${DownloadedMsuicDbConst.imgPath} $textType,
  ${DownloadedMsuicDbConst.modelMap} $textType
  )
''');
  }

  Future<void> insertDownloadedMusic(
      BuildContext context, MusicModel musicModel) async {
    final db = await instance.database;
    try {
      var id = await db.insert(DownloadedMsuicDbConst.tableName, {
        DownloadedMsuicDbConst.id: musicModel.id,
        DownloadedMsuicDbConst.filePath: musicModel.filePath!.split('/').last,
        DownloadedMsuicDbConst.imgPath: musicModel.imgPath!.split('/').last,
        DownloadedMsuicDbConst.modelMap: jsonEncode(musicModel.toMap())
      });
      print('inserted downloaded $id');
    } catch (e) {
      print(e);
    }
  }

  Future<List<MusicModel>> readAllDownloaded() async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    List<MusicModel> downloadList = [];
    try {
      final db = await instance.database;

      final orderBy = '${DownloadedMsuicDbConst.downloadedMsuicId} DESC';

      final result =
          await db.query(DownloadedMsuicDbConst.tableName, orderBy: orderBy);

      result.forEach((element) {
        MusicModel model = new MusicModel();
        model.fromMap(
            jsonDecode(element[DownloadedMsuicDbConst.modelMap].toString()));
        model.imgPath =
            '$dir/${element[DownloadedMsuicDbConst.imgPath].toString()}';
        model.filePath =
            '$dir/${element[DownloadedMsuicDbConst.filePath].toString()}';
        downloadList.add(model);
      });
    } catch (e) {}
    return downloadList;
  }

  Future<MusicModel> readDownloadedMusic(int id) async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    final db = await instance.database;
    final maps = await db.query(
      DownloadedMsuicDbConst.tableName,
      where: '${DownloadedMsuicDbConst.id} = ?',
      whereArgs: [id],
    );
    MusicModel musicModel = new MusicModel();
    musicModel.fromMap(
        jsonDecode(maps.first[DownloadedMsuicDbConst.modelMap].toString()));
    musicModel.imgPath =
        '$dir/${maps.first[DownloadedMsuicDbConst.imgPath].toString()}';
    musicModel.filePath =
        '$dir/${maps.first[DownloadedMsuicDbConst.filePath].toString()}';
    return musicModel;
  }

  Future<void> deleteDownloaded(int id) async {
    final db = await instance.database;

    readDownloadedMusic(id).then((value) async {
      final dir = Directory(value.filePath!);
      dir.deleteSync(recursive: true);
      final dir1 = Directory(value.imgPath!);
      dir1.deleteSync(recursive: true);
      var deletedId = await db.delete(
        DownloadedMsuicDbConst.tableName,
        where: '${DownloadedMsuicDbConst.id} = ?',
        whereArgs: [id],
      );
      print('deleted downloaded $deletedId');
    });
  }

  Future<void> insertRecentlyPlayed(
      BuildContext context, MusicModel musicModel) async {
    final db = await instance.database;
    try {
      var id = await db.insert(RecentlyPlayedDbConst.tableName, {
        RecentlyPlayedDbConst.id: musicModel.id,
        RecentlyPlayedDbConst.title: musicModel.title_en,
        RecentlyPlayedDbConst.artistName:
            musicModel.artists.singers.first.name_en,
        RecentlyPlayedDbConst.coverUrl: musicModel.cover_photo_url
      });
      if (id > 0) {
        var latastRecently = await readAllRecentlyPlayed();
        if (latastRecently.length > 6)
          deleteRecentlyPlayed(latastRecently.last.id!);
      }
      MainProvider mainProvider = new MainProvider();
      mainProvider.getRecentlyPlayed(context);
      print('inserted $id');
    } catch (e) {}
  }

  Future<List<MusicModel>> readAllRecentlyPlayed() async {
    final db = await instance.database;

    final orderBy = '${RecentlyPlayedDbConst.recentlyPlayedId} DESC';

    final result =
        await db.query(RecentlyPlayedDbConst.tableName, orderBy: orderBy);

    List<MusicModel> downloadedList = [];
    result.forEach((element) {
      MusicModel model = new MusicModel();
      model.fromMap(element);
      model.title_en = element[RecentlyPlayedDbConst.title].toString();
      model.cover_photo_url =
          element[RecentlyPlayedDbConst.coverUrl].toString();
      model.artists = new MusicDetailsModel();
      ArtistModel artistModel = new ArtistModel();
      artistModel.name_en =
          element[RecentlyPlayedDbConst.artistName].toString();
      model.artists.singers.add(artistModel);
      downloadedList.add(model);
    });
    return downloadedList;
  }

  Future<void> deleteRecentlyPlayed(int id) async {
    final db = await instance.database;

    var deletedId = await db.delete(
      RecentlyPlayedDbConst.tableName,
      where: '${RecentlyPlayedDbConst.id} = ?',
      whereArgs: [id],
    );

    print('deleted $deletedId');
  }

  Future<void> deleteAllRecentlyPlayed() async {
    final db = await instance.database;

    await db.delete(
      RecentlyPlayedDbConst.tableName,
    );
  }

  Future<void> deleteAllDownloaded() async {
    final db = await instance.database;

    await db.delete(
      DownloadedMsuicDbConst.tableName,
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
