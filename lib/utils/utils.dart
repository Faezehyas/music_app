import 'package:ahanghaa/models/enums/bottom_bar_enum.dart';
import 'package:ahanghaa/models/music/music_details_model.dart';
import 'package:ahanghaa/models/music/music_model.dart';
import 'package:ahanghaa/models/podcast/padcast_model.dart';
import 'package:ahanghaa/providers/main_provider.dart';
import 'package:ahanghaa/providers/player_provider.dart';
import 'package:ahanghaa/utils/user_infos.dart';
import 'package:ahanghaa/views/album/album_detail_list_screen.dart';
import 'package:ahanghaa/views/artist/artist_detail_screen.dart';
import 'package:ahanghaa/views/auth/profile_screen.dart';
import 'package:ahanghaa/views/play_list/play_list_detail_screen.dart';
import 'package:ahanghaa/views/player/player_screen.dart';
import 'package:ahanghaa/views/video/mini_screen_video_player.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/src/provider.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

MusicModel convertPodcastToMusic(PodcastModel podcastModel) {
  MusicModel musicModel = new MusicModel();
  musicModel.fromMap(podcastModel.toMap());
  musicModel.normal_quality_url = podcastModel.full_url;
  musicModel.artists = new MusicDetailsModel();
  musicModel.artists.singers.add(podcastModel.artist);
  musicModel.others = podcastModel.others;
  musicModel.is_favorited = podcastModel.is_favorited;
  musicModel.imgPath = podcastModel.imgPath;
  musicModel.filePath = podcastModel.filePath;
  musicModel.admob_id = podcastModel.admob_id;
  musicModel.isPodcast = true;
  return musicModel;
}

loadFromDeepLink(BuildContext context, Uri uri) {
  if (uri.toString().contains('tracks')) {
    if (int.tryParse(uri.toString().split('/').last) != null) {
      context
          .read<MainProvider>()
          .getMusicById(context, int.parse(uri.toString().split('/').last))
          .then((value) {
        PlayerProvider playerProvider = context.read<PlayerProvider>();
        if (playerProvider.currentList.length == 0 ||
            playerProvider.currentList != [value] ||
            playerProvider.currentList[playerProvider.currentMusicIndex].id !=
                value.id) playerProvider.clearAudio();
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.bottomToTop,
                settings: RouteSettings(name: 'main'),
                duration: Duration(milliseconds: 500),
                child:
                    PlayerScreen(currentList: [value], currentMusicIndex: 0)));
      });
    }
  } else if (uri.toString().contains('podcasts')) {
    if (int.tryParse(uri.toString().split('/').last) != null) {
      context
          .read<MainProvider>()
          .getPodcastById(context, int.parse(uri.toString().split('/').last))
          .then((value) {
        PlayerProvider playerProvider = context.read<PlayerProvider>();
        if (playerProvider.currentList.length == 0 ||
            playerProvider.currentList != [value] ||
            playerProvider.currentList[playerProvider.currentMusicIndex].id !=
                value.id) playerProvider.clearAudio();
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.bottomToTop,
                settings: RouteSettings(name: 'main'),
                duration: Duration(milliseconds: 500),
                child: PlayerScreen(
                    currentList: [convertPodcastToMusic(value)],
                    currentMusicIndex: 0)));
      });
    }
  } else if (uri.toString().contains('playlists')) {
    if (int.tryParse(uri.toString().split('/').last) != null) {
      context
          .read<MainProvider>()
          .getPlayListById(context, int.parse(uri.toString().split('/').last))
          .then((value) {
        Navigator.push(
            context,
            SwipeablePageRoute(
                settings: RouteSettings(name: 'main'),
                builder: (context) => PlayListDetailScreen(value, true)));
      });
    }
  } else if (uri.toString().contains('videos')) {
    if (int.tryParse(uri.toString().split('/').last) != null) {
      context
          .read<MainProvider>()
          .getVideoById(context, int.parse(uri.toString().split('/').last))
          .then((value) {
        context.read<PlayerProvider>().pauseAudio();
        Navigator.push(
            context,
            SwipeablePageRoute(
                builder: (context) => MiniScreenVideoPlayer(
                    [value], 0, 'Video', 'assets/icons/circle_play.png')));
      });
    }
  } else if (uri.toString().contains('albums')) {
    if (int.tryParse(uri.toString().split('/').last) != null) {
      context
          .read<MainProvider>()
          .getAlbumsById(context, int.parse(uri.toString().split('/').last))
          .then((value) {
        Navigator.push(
            context,
            SwipeablePageRoute(
                settings: RouteSettings(name: 'main'),
                builder: (context) => AlbumDetailListScreenScreen(value)));
      });
    }
  } else if (uri.toString().contains('playlist')) {
    if (int.tryParse(uri.toString().split('/').last) != null) {
      context
          .read<MainProvider>()
          .getUserPlayListById(
              context, int.parse(uri.toString().split('/').last))
          .then((value) {
        Navigator.push(
            context,
            SwipeablePageRoute(
                settings: RouteSettings(name: 'main'),
                builder: (context) => PlayListDetailScreen(value, true)));
      });
    }
  } else if (uri.toString().contains('users')) {
    if (int.tryParse(uri.toString().split('/').last) != null) {
      if ((UserInfos.getString(context, 'username') ?? '0') ==
          uri.toString().split('/').last)
        context
            .read<MainProvider>()
            .changeBottomBar(context, BottomBarEnum.Profile);
      else
        Navigator.push(
            context,
            SwipeablePageRoute(
                settings: RouteSettings(name: 'main'),
                builder: (context) =>
                    ProfileScreen(uri.toString().split('/').last, false)));
    }
  } else if (uri.toString().contains('artists')) {
    if (int.tryParse(uri.toString().split('/').last) != null) {
      context
          .read<MainProvider>()
          .getUserPlayListById(
              context, int.parse(uri.toString().split('/').last))
          .then((value) {
        Navigator.push(
            context,
            SwipeablePageRoute(
                settings: RouteSettings(name: 'main'),
                builder: (context) => ArtistDetailScreen(
                    int.parse(uri.toString().split('/').last))));
      });
    }
  }
}

loadFromNotification(BuildContext context, Map<String, dynamic> data) {
  if (data['music'] != null) {
    if (int.tryParse(data['music']) != null) {
      context
          .read<MainProvider>()
          .getMusicById(context, int.parse(data['music']))
          .then((value) {
        PlayerProvider playerProvider = context.read<PlayerProvider>();
        if (playerProvider.currentList.length == 0 ||
            playerProvider.currentList != [value] ||
            playerProvider.currentList[playerProvider.currentMusicIndex].id !=
                value.id) playerProvider.clearAudio();
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.bottomToTop,
                settings: RouteSettings(name: 'main'),
                duration: Duration(milliseconds: 500),
                child:
                    PlayerScreen(currentList: [value], currentMusicIndex: 0)));
      });
    }
  } else if (data['podcast'] != null) {
    if (int.tryParse(data['podcast']) != null) {
      context
          .read<MainProvider>()
          .getPodcastById(context, int.parse(data['podcast']))
          .then((value) {
        PlayerProvider playerProvider = context.read<PlayerProvider>();
        if (playerProvider.currentList.length == 0 ||
            playerProvider.currentList != [value] ||
            playerProvider.currentList[playerProvider.currentMusicIndex].id !=
                value.id) playerProvider.clearAudio();
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.bottomToTop,
                settings: RouteSettings(name: 'main'),
                duration: Duration(milliseconds: 500),
                child: PlayerScreen(
                    currentList: [convertPodcastToMusic(value)],
                    currentMusicIndex: 0)));
      });
    }
  } else if (data['playList'] != null) {
    if (int.tryParse(data['playList']) != null) {
      context
          .read<MainProvider>()
          .getPlayListById(context, int.parse(data['playList']))
          .then((value) {
        Navigator.push(
            context,
            SwipeablePageRoute(
                settings: RouteSettings(name: 'main'),
                builder: (context) => PlayListDetailScreen(value, true)));
      });
    }
  } else if (data['video'] != null) {
    if (int.tryParse(data['video']) != null) {
      context
          .read<MainProvider>()
          .getVideoById(context, int.parse(data['video']))
          .then((value) {
        context.read<PlayerProvider>().pauseAudio();
        Navigator.push(
            context,
            SwipeablePageRoute(
                settings: RouteSettings(name: 'main'),
                builder: (context) => MiniScreenVideoPlayer(
                    [value], 0, 'Video', 'assets/icons/circle_play.png')));
      });
    }
  } else if (data['album'] != null) {
    if (int.tryParse(data['album']) != null) {
      context
          .read<MainProvider>()
          .getAlbumsById(context, int.parse(data['album']))
          .then((value) {
        context.read<PlayerProvider>().pauseAudio();
        Navigator.push(
            context,
            SwipeablePageRoute(
                settings: RouteSettings(name: 'main'),
                builder: (context) => AlbumDetailListScreenScreen(value)));
      });
    }
  } else if (data['user-playlist'] != null) {
    if (int.tryParse(data['user-playlist']) != null) {
      context
          .read<MainProvider>()
          .getUserPlayListById(context, int.parse(data['user-playlist']))
          .then((value) {
        context.read<PlayerProvider>().pauseAudio();
        Navigator.push(
            context,
            SwipeablePageRoute(
                settings: RouteSettings(name: 'main'),
                builder: (context) => PlayListDetailScreen(value, true)));
      });
    }
  }
}
