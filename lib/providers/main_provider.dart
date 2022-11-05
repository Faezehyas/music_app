import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:ahanghaa/main_screen.dart';
import 'package:ahanghaa/models/ads/get_ads_response_model.dart';
import 'package:ahanghaa/models/album/album_model.dart';
import 'package:ahanghaa/models/album/get_latest_album_Response_model.dart';
import 'package:ahanghaa/models/artist/artist_model.dart';
import 'package:ahanghaa/models/artist/get_artist_detail_respone_model.dart';
import 'package:ahanghaa/models/artist/get_favorite_artist_response_model.dart';
import 'package:ahanghaa/models/auth/profile_model.dart';
import 'package:ahanghaa/models/auth/user_model.dart';
import 'package:ahanghaa/models/enums/bottom_bar_enum.dart';
import 'package:ahanghaa/models/email/send_email_request_model.dart';
import 'package:ahanghaa/models/favorite/change_favorite_state_respone_model.dart';
import 'package:ahanghaa/models/favorite/get_favorite_list_response_model.dart';
import 'package:ahanghaa/models/genres&mood/genre_model.dart';
import 'package:ahanghaa/models/genres&mood/get_all_genre_moode_response_model.dart';
import 'package:ahanghaa/models/music/get_music_list_response_model.dart';
import 'package:ahanghaa/models/music/music_model.dart';
import 'package:ahanghaa/models/status_response_model.dart';
import 'package:ahanghaa/models/play_list/create_playlist_request_model.dart';
import 'package:ahanghaa/models/play_list/get_play_list_response_model.dart';
import 'package:ahanghaa/models/play_list/play_list_model.dart';
import 'package:ahanghaa/models/podcast/get_podcast_list_response_model.dart';
import 'package:ahanghaa/models/podcast/padcast_model.dart';
import 'package:ahanghaa/models/enums/profile_screen_state_enum.dart';
import 'package:ahanghaa/models/search/search_all_response_model.dart';
import 'package:ahanghaa/models/slider/get_sliders_response_model.dart';
import 'package:ahanghaa/models/slider/slider_model.dart';
import 'package:ahanghaa/models/video/get_video_list_response_model.dart';
import 'package:ahanghaa/models/video/video_model.dart';
import 'package:ahanghaa/providers/auth_provider.dart';
import 'package:ahanghaa/providers/database_provider.dart';
import 'package:ahanghaa/services/ads/get_ads_service.dart';
import 'package:ahanghaa/services/album/change_album_favorite_state_service.dart';
import 'package:ahanghaa/services/album/get_albums_music_service.dart';
import 'package:ahanghaa/services/album/get_albums_with_paging_service.dart';
import 'package:ahanghaa/services/album/get_featured_albums_service.dart';
import 'package:ahanghaa/services/artist/change_artist_favorite_state_service.dart';
import 'package:ahanghaa/services/artist/get_artist_detail_with_paging_service.dart';
import 'package:ahanghaa/services/artist/get_artist_favorite_list_service.dart';
import 'package:ahanghaa/services/auth/sync_service.dart';
import 'package:ahanghaa/services/email/send_email_service.dart';
import 'package:ahanghaa/services/music/change_favorite_state_service.dart';
import 'package:ahanghaa/services/music/get_favorite_list_service.dart';
import 'package:ahanghaa/services/music/get_featured_music_service.dart';
import 'package:ahanghaa/services/music/get_masters_with_paging_service.dart';
import 'package:ahanghaa/services/music/get_user_recently_music_service.dart';
import 'package:ahanghaa/services/play_list/get_deleted_play_list_service.dart';
import 'package:ahanghaa/services/play_list/restore_deleted_play_list_service.dart';
import 'package:ahanghaa/services/play_list/update_playlist_service.dart';
import 'package:ahanghaa/services/search/get_genres_with_paging_service.dart';
import 'package:ahanghaa/services/music/get_latest_music_with_paging_service.dart';
import 'package:ahanghaa/services/music/get_music_by_id_service.dart';
import 'package:ahanghaa/services/music/get_top_track_music_service.dart';
import 'package:ahanghaa/services/play_list/add_to_playlist_service.dart';
import 'package:ahanghaa/services/play_list/change_playlist_favorite_state_service.dart';
import 'package:ahanghaa/services/play_list/create_playlist_service.dart';
import 'package:ahanghaa/services/play_list/delete_music_from_playlist_service.dart';
import 'package:ahanghaa/services/play_list/delete_playlist_service.dart';
import 'package:ahanghaa/services/play_list/get_featured_play_list_service.dart';
import 'package:ahanghaa/services/play_list/get_latest_play_list_with_paging_service.dart';
import 'package:ahanghaa/services/play_list/get_play_list_by_id_service.dart';
import 'package:ahanghaa/services/play_list/get_user_play_list_by_id_service.dart';
import 'package:ahanghaa/services/play_list/get_user_play_list_service.dart';
import 'package:ahanghaa/services/podcast/change_podcast_favorite_state_service.dart';
import 'package:ahanghaa/services/podcast/get_featured_padcast_music_service.dart';
import 'package:ahanghaa/services/podcast/get_latest_podcast_with_paging_service.dart';
import 'package:ahanghaa/services/podcast/get_podcast_by_id_service.dart';
import 'package:ahanghaa/services/search/get_all_genres_service.dart';
import 'package:ahanghaa/services/search/get_all_moods_service.dart';
import 'package:ahanghaa/services/search/get_moods_with_paging_service.dart';
import 'package:ahanghaa/services/search/seach_all_service.dart';
import 'package:ahanghaa/services/slider/get_sliders_service.dart';
import 'package:ahanghaa/services/video/change_video_favorite_state_service.dart';
import 'package:ahanghaa/services/video/get_featured_video_service.dart';
import 'package:ahanghaa/services/video/get_latest_video_with_paging_service.dart';
import 'package:ahanghaa/services/video/get_video_by_id_service.dart';
import 'package:ahanghaa/utils/user_infos.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainProvider with ChangeNotifier {
  static late SharedPreferences sharedPreferences;
  bool canLoadDeepLink = true;
  bool isDownloadedNull = false;
  bool isInit = false;
  bool hasInternet = true;
  bool showMenu = true;
  late Timer _timer;
  int _start = 5;
  bool isQualityOpen = false;
  int forYouCoverRandom = 0;
  List<SliderModel> slidersList = [];
  List<MusicModel> mustListenList = [];
  List<VideoModel> featuredVideoList = [];
  List<VideoModel> mustWatchList = [];
  List<PodcastModel> topPadcastsList = [];
  List<MusicModel> latestMusicList = [];
  List<AlbumModel> latestAlbumList = [];
  List<AlbumModel> featuredAlbumList = [];
  List<MusicModel> filledDownloadedList = [];
  List<MusicModel> downloadedList = [];
  List<MusicModel> topTracksDayList = [];
  List<MusicModel> topTracksWeekList = [];
  List<MusicModel> topTracksMonthList = [];
  List<MusicModel> topTracksYearList = [];
  List<PodcastModel> favoritePodcastList = [];
  List<PlayListModel> playListList = [];
  List<PlayListModel> userPlayListList = [];
  List<PlayListModel> favoritePlayList = [];
  List<PlayListModel> deletedPlayList = [];
  List<AlbumModel> favoriteAlbumList = [];
  List<VideoModel> favoriteVideoList = [];
  List<GenreAndMoodeModel> genresList = [];
  List<GenreAndMoodeModel> moodsList = [];
  UserModel currentUserModel = new UserModel();
  BottomBarEnum bottomBarEnum = BottomBarEnum.Home;
  DataBaseProvider dataBaseProvider = new DataBaseProvider();
  GetAdsResponseModel adsModel = new GetAdsResponseModel();

  Future<void> init(BuildContext context, AuthProvider authProvider) async {
    if (!isInit) {
      isInit = true;
      canLoadDeepLink = true;
      sharedPreferences = await SharedPreferences.getInstance();
      if (UserInfos.getToken(context) != null &&
          UserInfos.getToken(context)!.isNotEmpty) {
        authProvider.changeProfileScreen(ProfileScreenStateEnum.Profile);
        authProvider.changeLoginState(true);
      }
      Timer.periodic(Duration(seconds: 10), (timer) async {
        if (UserInfos.getToken(context) != null &&
            UserInfos.getToken(context)!.isNotEmpty) {
          syncApp(context);
        }
      });
      if (await checkInternet(context)) {
        getSliders(context);
        getMustListenList(context);
        getTopPadcasts(context);
        getLatestMusicListWithPaging(context, 1, 8);
        getFeaturedVideoList(context);
        getLatestAlbumListWithPaging(context, 1, 20);
        getDownloadedList(context);
        getFeaturedPlayList(context);
        getAds(context);
        getLatestVideoListWithPaging(context, 1, 3);
        if (UserInfos.getToken(context) != null) getFavoriteList(context);
      } else {
        getDownloadedList(context);
        Future.delayed(Duration(seconds: 3)).then((value) =>
            Navigator.pushReplacement(
                context,
                PageTransition(
                    type: PageTransitionType.fade,
                    duration: Duration(milliseconds: 500),
                    settings: RouteSettings(name: 'splash'),
                    child: MainScreen())));
      }
    }
  }

  getAds(BuildContext context) async {
    if ((UserInfos.getString(context, 'username') ?? '').isNotEmpty) {
      AuthProvider authProvider = new AuthProvider();
      ProfileModel profileModel = await authProvider.getUserProfile(
          context, UserInfos.getString(context, 'username')!);
      if (!profileModel.is_premium) {
        adsModel = await GetAdsService(context);
        notifyListeners();
      }
    } else {
      adsModel = await GetAdsService(context);
      notifyListeners();
    }
  }

  changeBottomBar(BuildContext context, BottomBarEnum newBottomBarEnum) {
    Navigator.popUntil(context, (route) {
      if (route.settings.name == null || route.settings.name != 'splash')
        return false;
      else
        return true;
    });
    bottomBarEnum = newBottomBarEnum;
    notifyListeners();
  }

  Future<UserModel> syncApp(BuildContext context) async {
    var res = await SyncService(context);
    currentUserModel = res;
    return res;
  }

  Future<List<MusicModel>> getRecentlyPlayed(BuildContext context) async {
    // Future.value(dataBaseProvider.getRecentlyPlayed(context)).then((value) {
    //   List<MusicModel> recent = [];
    //   Future.forEach(dataBaseProvider.recentlyPlayedList, (element) async {
    //     MusicModel musicModel =
    //         await getMusicById(context, (element as MusicModel).id!);
    //     recent.add(musicModel);
    //   }).then((value) {
    //     recentlyPlayedList = recent;
    //     notifyListeners();
    //   });
    // });
    GetMusicListResponseModel res = await GetUserRecentlyMusicService(context);
    return res.musicList;
  }

  Future<List<SliderModel>> getSliders(BuildContext context) async {
    GetSlidersResponseModel res = await GetAllSlidersService(context);
    if (res.Sliders.isNotEmpty) {
      slidersList = res.Sliders;
      slidersList.forEach((element) async {
        MusicModel musicModel =
            await GetMusicByIdService(context, element.slidable_id);
        element.song_name = musicModel.title_en!;
        if (musicModel.artists.singers.length > 0) {
          element.singer_name = musicModel.artists.singers.first.name_en;
          element.is_verified = musicModel.artists.singers.first.is_verified;
        } else {
          element.singer_name = '';
          element.is_verified = false;
        }
      });
      notifyListeners();
      return slidersList;
    }
    return [];
  }

  Future<MusicModel> getMusicById(BuildContext context, int id) async =>
      await GetMusicByIdService(context, id);

  Future<PodcastModel> getPodcastById(BuildContext context, int id) async =>
      await GetPodcastByIdService(context, id);

  Future<PlayListModel> getPlayListById(BuildContext context, int id) async =>
      await GetPlayListByIdService(context, id);

  Future<VideoModel> getVideoById(BuildContext context, int id) async =>
      await GetVideoByIdService(context, id);

  Future<AlbumModel> getAlbumsById(BuildContext context, int albumId) async =>
      await GetAlbumsMusicService(context, albumId);

  Future<PlayListModel> getUserPlayListById(
          BuildContext context, int id) async =>
      await GetUserPlayListByIdService(context, id);

  Future<List<MusicModel>> getAlbumsMusicList(
      BuildContext context, int albumId) async {
    AlbumModel res = await GetAlbumsMusicService(context, albumId);
    return res.musics;
  }

  Future<List<MusicModel>> getMustListenList(BuildContext context) async {
    GetMusicListResponseModel res = await GetFeaturedMusicListService(context);
    mustListenList = res.musicList;
    if (mustListenList.length > 0)
      forYouCoverRandom = new Random().nextInt(mustListenList.length);
    notifyListeners();
    Navigator.pushReplacement(
        context,
        PageTransition(
            type: PageTransitionType.fade,
            duration: Duration(milliseconds: 500),
            settings: RouteSettings(name: 'splash'),
            child: MainScreen()));
    return mustListenList;
  }

  Future<void> getTopTracksList(BuildContext context) async {
    GetMusicListResponseModel resDay =
        await GetTopTrackMusicService(context, 'day');
    topTracksDayList = resDay.musicList;
    notifyListeners();
    GetMusicListResponseModel resWeek =
        await GetTopTrackMusicService(context, 'week');
    topTracksWeekList = resWeek.musicList;
    notifyListeners();
    GetMusicListResponseModel resMonth =
        await GetTopTrackMusicService(context, 'month');
    topTracksMonthList = resMonth.musicList;
    notifyListeners();
    GetMusicListResponseModel resYear =
        await GetTopTrackMusicService(context, 'year');
    topTracksYearList = resYear.musicList;
    notifyListeners();
  }

  Future<List<PodcastModel>> getTopPadcasts(BuildContext context) async {
    GetPodcastsListResponseModel res =
        await GetFeaturedPadcastMusicListService(context);
    topPadcastsList = res.podcastsList;
    notifyListeners();
    return topPadcastsList;
  }

  Future<List<MusicModel>> getLatestMusicListWithPaging(
      BuildContext context, int page, int limit) async {
    GetMusicListResponseModel res =
        await GetLatestMusicListWithPagingService(context, page, limit);
    if (latestMusicList.length == 0) latestMusicList = res.musicList;
    notifyListeners();
    return res.musicList;
  }

  Future<List<MusicModel>> getGenresMusicListWithPaging(
      BuildContext context, int genreId, int page, int limit) async {
    GetMusicListResponseModel res =
        await GetGenresWithPagingService(context, genreId, page, limit);
    return res.musicList;
  }

  Future<List<MusicModel>> getMoodsMusicListWithPaging(
      BuildContext context, int moodId, int page, int limit) async {
    GetMusicListResponseModel res =
        await GetMoodsWithPagingService(context, moodId, page, limit);
    return res.musicList;
  }

  Future<List<MusicModel>> getMastersMusicListWithPaging(
      BuildContext context, int moodId, int page, int limit) async {
    GetMusicListResponseModel res =
        await GetMastersWithPagingService(context, page, limit);
    return res.musicList;
  }

  Future<List<VideoModel>> getLatestVideoListWithPaging(
      BuildContext context, int page, int limit) async {
    GetVideoListResponseModel res =
        await GetLatestVideoListWithPagingService(context, page, limit);
    if (mustWatchList.length == 0) mustWatchList = res.videoList;
    return res.videoList;
  }

  Future<List<PlayListModel>> getLatestPlayListWithPaging(
      BuildContext context, int page, int limit) async {
    GetPlayListResponseModel res =
        await GetLatestPlayListWithPagingService(context, page, limit);
    notifyListeners();
    return res.playlists;
  }

  Future<GetArtistDetailResponeModel> getArtsitDetailListWithPaging(
      BuildContext context, int artistId, int page, int limit) async {
    GetArtistDetailResponeModel res =
        await GetArtistDetailListWithPagingService(
            context, artistId, page, limit);
    return res;
  }

  Future<List<PodcastModel>> getLatestPodcastListWithPaging(
      BuildContext context, int page, int limit) async {
    GetPodcastsListResponseModel res =
        await GetLatestPodcastListWithPagingService(context, page, limit);
    notifyListeners();
    return res.podcastsList;
  }

  Future<List<AlbumModel>> getLatestAlbumListWithPaging(
      BuildContext context, int page, int limit) async {
    GetLatestAlbumResponseModel res =
        await GetAlbumsWithPagingService(context, page, limit);
    latestAlbumList.addAll(res.albumList);
    notifyListeners();
    return latestAlbumList;
  }

  Future<List<AlbumModel>> getFeaturedAlbumList(BuildContext context) async {
    GetLatestAlbumResponseModel res = await GetFeaturedAlbumsService(context);
    return res.albumList;
  }

  Future<List<VideoModel>> getFeaturedVideoList(BuildContext context) async {
    GetVideoListResponseModel res = await GetFeaturedVideoListService(context);
    featuredVideoList = res.videoList;
    notifyListeners();
    return featuredVideoList;
  }

  Future<List<PlayListModel>> getFeaturedPlayList(BuildContext context) async {
    GetPlayListResponseModel res = await GetFeaturedPlayListService(context);
    playListList = res.playlists;
    notifyListeners();
    return playListList;
  }

  Future<List<PlayListModel>> getDeletedPlayList(BuildContext context) async {
    if (deletedPlayList.length > 0) return deletedPlayList;
    GetPlayListResponseModel res = await GetDeletedPlayListService(context);
    deletedPlayList = res.playlists;
    notifyListeners();
    return deletedPlayList;
  }

  Future<bool> restoreDeletedPlayList(
      BuildContext context, PlayListModel playList) async {
    StatusResponseModel res =
        await RestoreDeletedPlayListService(context, playList.id);
    if (res.success) {
      deletedPlayList.removeWhere((element) => element == playList);
      userPlayListList.add(playList);
      notifyListeners();
    }
    return res.success;
  }

  Future<SearchAllResponseModel> searchAll(
      BuildContext context, String keyword) async {
    SearchAllResponseModel res = await SearchAllService(context, keyword);
    return res;
  }

  Future<bool> changeFavoriteState(BuildContext context, int id) async {
    ChangeFavoriteStateResponseModel res =
        await ChangeFavoriteStateService(context, id);
    return res.is_favorited;
  }

  Future<bool> changePlayListFavoriteState(
      BuildContext context, PlayListModel playListModel) async {
    ChangeFavoriteStateResponseModel res =
        await ChangePlayListFavoriteStateService(context, playListModel.id);
    if (res.is_favorited)
      favoritePlayList.add(playListModel);
    else
      favoritePlayList.remove(playListModel);
    notifyListeners();
    return res.is_favorited;
  }

  Future<bool> changeAlbumFavoriteState(
      BuildContext context, AlbumModel albumModel) async {
    ChangeFavoriteStateResponseModel res =
        await ChangeAlbumFavoriteStateService(context, albumModel.id);
    if (res.is_favorited)
      favoriteAlbumList.add(albumModel);
    else
      favoriteAlbumList.remove(albumModel);
    notifyListeners();
    return res.is_favorited;
  }

  Future<bool> changePodcastFavoriteState(BuildContext context, int id) async {
    ChangeFavoriteStateResponseModel res =
        await ChangePodcastFavoriteStateService(context, id);
    return res.is_favorited;
  }

  Future<bool> changeVideoFavoriteState(BuildContext context, int id) async {
    ChangeFavoriteStateResponseModel res =
        await ChangeVideoFavoriteStateService(context, id);
    return res.is_favorited;
  }

  Future<bool> changeArtistFavoriteState(BuildContext context, int id) async {
    ArtistModel res = await ChangeArtistFavoriteStateService(context, id);
    return res.is_followed;
  }

  Future<List<PlayListModel>> createNewPlayListWithAddMusic(
      BuildContext context,
      int musicId,
      String playListName,
      File? cover) async {
    CreatePlaylistRequestModel requestModel = new CreatePlaylistRequestModel();
    requestModel.name = playListName;
    requestModel.is_visible = true;
    if (cover != null) requestModel.cover = cover;
    PlayListModel playListModel =
        await CreateNewPlayListService(context, requestModel);
    if (playListModel.id > 0) {
      await addToPlayList(context, musicId, playListModel.id);
      notifyListeners();
    }

    return userPlayListList;
  }

  Future<void> createNewPlayList(
      BuildContext context, String playListName, File? cover) async {
    CreatePlaylistRequestModel requestModel = new CreatePlaylistRequestModel();
    requestModel.name = playListName;
    requestModel.is_visible = true;
    if (cover != null) requestModel.cover = cover;
    PlayListModel playListModel =
        await CreateNewPlayListService(context, requestModel);
    if (playListModel.id > 0) {
      userPlayListList.add(playListModel);
      notifyListeners();
    }
  }

  Future<PlayListModel> updatePlayList(BuildContext context,
      CreatePlaylistRequestModel requestModel, int id) async {
    PlayListModel playListModel =
        await UpdatePlayListService(context, requestModel, id);
    if (playListModel.id > 0) {
      userPlayListList.forEach((element) {
        if (element.id == id) {
          element = playListModel;
        }
      });
      notifyListeners();
    }
    return playListModel;
  }

  Future<List<PlayListModel>> addToPlayList(
      BuildContext context, int musicId, int playListId) async {
    await AddToPlayListService(context, playListId, musicId);
    GetPlayListResponseModel res = await GetUserPlayListService(context);
    userPlayListList = res.playlists;
    notifyListeners();
    return userPlayListList;
  }

  Future<List<PlayListModel>> getUserPlayList(BuildContext context) async {
    if (userPlayListList.length > 0) return userPlayListList;
    GetPlayListResponseModel res = await GetUserPlayListService(context);
    userPlayListList = res.playlists;
    notifyListeners();
    return userPlayListList;
  }

  Future<List<GenreAndMoodeModel>> getGenresList(BuildContext context) async {
    if (genresList.length > 0) return genresList;
    GetAllGenreAndMoodeResposenModel res = await GetAllGenresService(context);
    genresList = res.genreAndMoodList
        .where((element) => element.name_en != null)
        .toList();
    notifyListeners();
    return genresList;
  }

  Future<List<GenreAndMoodeModel>> getMoodsList(BuildContext context) async {
    if (moodsList.length > 0) return moodsList;
    GetAllGenreAndMoodeResposenModel res = await GetAllMoodsService(context);
    moodsList = res.genreAndMoodList
        .where((element) => element.name_en != null)
        .toList();
    notifyListeners();
    return moodsList;
  }

  Future<List<ArtistModel>> getFavoriteArtistList(BuildContext context) async {
    GetFavoriteArtistResponseModel res =
        await GetArtistFavoriteListService(context);
    return res.artistList;
  }

  Future<void> deleteMusicFromPlayList(
      BuildContext context, int musicId, int playListId) async {
    await DeleteMusicFromPlayListService(context, playListId, musicId);
  }

  changeUserPlayListMusicCount(int playListId) {
    userPlayListList.forEach((element) {
      element.music_count = element.music_count - 1;
    });
    notifyListeners();
  }

  Future<void> deletePlayList(
      BuildContext context, PlayListModel playList) async {
    StatusResponseModel res = await DeletePlayListService(context, playList.id);
    if (res.success) {
      userPlayListList.removeWhere((element) => element.id == playList.id);
      if (deletedPlayList.length > 0) deletedPlayList.add(playList);
      notifyListeners();
    }
  }

  Future<GetFavoriteListResponseModel> getFavoriteList(
      BuildContext context) async {
    GetFavoriteListResponseModel res = await GetFavoriteListService(context);
    favoriteVideoList = res.videos;
    favoritePodcastList = res.podcasts;
    favoritePlayList = res.playlists;
    favoriteAlbumList = res.albumlists;
    return res;
  }

  changeVideoFavoriteList(bool status, VideoModel model) {
    if (status)
      favoriteVideoList.add(model);
    else
      favoriteVideoList.remove(model);
    notifyListeners();
  }

  Future<List<MusicModel>> getDownloadedList(BuildContext context) async {
    if (downloadedList.length > 0)
      return downloadedList;
    else {
      downloadedList = await dataBaseProvider.getDownloadedList(context);
      if (downloadedList.length == 0) isDownloadedNull = true;
      notifyListeners();
      return downloadedList;
    }
  }

  Future<void> sendEmail(
      BuildContext context, String subject, String message) async {
    SendEmailRequestModel sendEmailRequestModel = new SendEmailRequestModel();
    sendEmailRequestModel.email = UserInfos.getString(context, 'email')!;
    sendEmailRequestModel.name = UserInfos.getString(context, 'name')!;
    sendEmailRequestModel.subject = subject;
    sendEmailRequestModel.message = message;
    await SendEmailService(context, sendEmailRequestModel);
  }

  insertIntoDownloadsList(MusicModel model) {
    if (filledDownloadedList.length > 0 || isDownloadedNull)
      filledDownloadedList.add(model);
    if (downloadedList.length > 0 || isDownloadedNull)
      downloadedList.add(model);
    notifyListeners();
  }

  deleteDownloaded(int id) {
    filledDownloadedList.removeWhere((element) => element.id == id);
    downloadedList.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  void showAndHideMenu() {
    showMenu = true;
    _start = 5;
    notifyListeners();
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          timer.cancel();
          showMenu = false;
          isQualityOpen = false;
          notifyListeners();
        } else {
          _start--;
          notifyListeners();
        }
      },
    );
  }

  Future<bool> checkInternet(BuildContext context) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      hasInternet = false;
      this.notifyListeners();
      return false;
    } else {
      hasInternet = true;
      this.notifyListeners();
      return true;
    }
  }
}
