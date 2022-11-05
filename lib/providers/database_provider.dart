import 'package:ahanghaa/db/my_database.dart';
import 'package:ahanghaa/models/music/music_model.dart';
import 'package:ahanghaa/providers/main_provider.dart';
import 'package:ahanghaa/utils/user_infos.dart';
import 'package:flutter/cupertino.dart';

class DataBaseProvider extends ChangeNotifier {
  List<MusicModel> recentlyPlayedList = [];
  insertSearchSuggested(BuildContext context, String search) {
    if (UserInfos.getString(context, 'search') != null) {
      UserInfos.setString(context, 'search',
          (UserInfos.getString(context, 'search') ?? '') + '__' + search);
    } else {
      UserInfos.setString(context, 'search', search);
    }
  }

  List<String> getSearchSuggested(BuildContext context, String pattern) {
      return UserInfos.getString(context, 'search') != null
          ? UserInfos.getString(context, 'search')!
              .split('__')
              .where((element) => element.indexOf(pattern) != -1)
              .toList()
          : [];}

  insertIntoRecentlyPlayed(BuildContext context, MusicModel musicModel) {
    MyDatabase.instance.insertRecentlyPlayed(context, musicModel);
  }

  Future<List<MusicModel>> getRecentlyPlayed(BuildContext context) async {
    recentlyPlayedList = await MyDatabase.instance.readAllRecentlyPlayed();
    notifyListeners();
    return recentlyPlayedList;
  }

  insertIntoDownloadedList(BuildContext context, MusicModel musicModel) {
    MyDatabase.instance.insertDownloadedMusic(context, musicModel);
  }

  Future<List<MusicModel>> getDownloadedList(BuildContext context) async {
    return await MyDatabase.instance.readAllDownloaded();
  }

  Future<MusicModel> getDownloaded(BuildContext context, int id) async =>
      await MyDatabase.instance.readDownloadedMusic(id);

  deleteDownloaded(int id) async =>
      await MyDatabase.instance.deleteDownloaded(id);

  deleteAllRecenltyPlayed() => MyDatabase.instance.deleteAllRecentlyPlayed();

  deleteAllDownloaded() => MyDatabase.instance.deleteAllDownloaded();
}
