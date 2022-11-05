import 'dart:async';
import 'dart:io';
import 'package:ahanghaa/models/enums/timer_enum.dart';
import 'package:ahanghaa/services/music/current_listening_service.dart';
import 'package:ahanghaa/utils/user_infos.dart';
import 'package:http/http.dart' as http;
import 'package:ahanghaa/models/music/music_model.dart';
import 'package:ahanghaa/models/music/music_quality_enum.dart';
import 'package:ahanghaa/providers/database_provider.dart';
import 'package:ahanghaa/providers/main_provider.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path_provider/path_provider.dart';
import 'package:social_share/social_share.dart';

class PlayerProvider extends ChangeNotifier {
  AudioPlayer audioPlayer = new AudioPlayer();
  DataBaseProvider dataBaseProvider = new DataBaseProvider();
  String totalDurationStr = '0:00';
  String currentDurationStr = '0:00';
  Duration totalDuration = Duration();
  Duration currentDuration = Duration();
  PlayerState playerState = PlayerState(false, ProcessingState.buffering);
  bool isInit = false;
  bool isLoaded = false;
  int currentMusicIndex = 0;
  TimerEnum timerEnum = TimerEnum.None;
  List<MusicModel> currentList = [];
  MusicQualityEnum musicQualityEnum = MusicQualityEnum.high;
  MainProvider mainProvider = new MainProvider();
  int currentMusicId = 0;
  late Timer _stopPlayerTimer;
  int stopPlayerStart = 0;

  initPlayer(
      BuildContext context, List<MusicModel> musicLists, int index) async {
    if (!isInit) {
      isInit = true;
      currentList = musicLists;
      currentMusicIndex = index;
      logging(context);
      await audioPlayer.setAudioSource(
        ConcatenatingAudioSource(
          children: musicLists.map((e) {
            var tag = MediaItem(
              id: e.id.toString(),
              album: e.artists.singers.first.name_en,
              artist: e.artists.singers.first.name_en,
              title: e.title_en!,
              artUri: Uri.parse(e.imgPath ?? e.cover_photo_url!),
            );
            if (e.filePath != null) {
              return AudioSource.uri(Uri.file(e.filePath!), tag: tag);
            }
            if (musicQualityEnum == MusicQualityEnum.low) {
              if (e.normal_quality_url != null &&
                  e.normal_quality_url!.isNotEmpty)
                return AudioSource.uri(Uri.parse(e.normal_quality_url!),
                    tag: tag);
              else
                return AudioSource.uri(Uri.parse(e.high_quality_url!),
                    tag: tag);
            }
            if (musicQualityEnum == MusicQualityEnum.high) {
              if (e.high_quality_url != null && e.high_quality_url!.isNotEmpty)
                return AudioSource.uri(Uri.parse(e.high_quality_url!),
                    tag: tag);
              else
                return AudioSource.uri(Uri.parse(e.normal_quality_url!),
                    tag: tag);
            }
            if (musicQualityEnum == MusicQualityEnum.master) {
              if (e.master_quality_url != null &&
                  e.master_quality_url!.isNotEmpty)
                return AudioSource.uri(Uri.parse(e.master_quality_url!),
                    tag: tag);
              else
                return AudioSource.uri(Uri.parse(e.high_quality_url!),
                    tag: tag);
            }
            return AudioSource.uri(Uri.parse(e.high_quality_url!), tag: tag);
          }).toList(),
        ),
        initialIndex: index,
      );
      audioPlayer.play();
      audioPlayer.playerStateStream.listen((event) {
        playerState = event;
        notifyListeners();
      });

      audioPlayer.positionStream.listen((event) {
        currentDuration = event;
        if (currentDuration >= Duration(minutes: 10))
          currentDurationStr =
              event.toString().split('.').first.substring(2, 7);
        else
          currentDurationStr =
              event.toString().split('.').first.substring(3, 7);
        notifyListeners();
      });

      audioPlayer.durationStream.listen((event) {
        if (event != null) {
          totalDuration = event;
          if (totalDuration >= Duration(minutes: 10))
            totalDurationStr =
                event.toString().split('.').first.substring(2, 7);
          else
            totalDurationStr =
                event.toString().split('.').first.substring(3, 7);
          notifyListeners();
        }
      });

      audioPlayer.playbackEventStream.listen((evenet) {
        if (audioPlayer.playerState.playing) {
          // dataBaseProvider.insertIntoRecentlyPlayed(
          //     context, currentList[currentMusicIndex]);
          currentMusicIndex = evenet.currentIndex!;
          logging(context);
          switch (musicQualityEnum) {
            case MusicQualityEnum.low:
              if (currentList[currentMusicIndex].normal_quality_url == null ||
                  currentList[currentMusicIndex].normal_quality_url!.isEmpty)
                musicQualityEnum = MusicQualityEnum.high;
              break;
            case MusicQualityEnum.high:
              if (currentList[currentMusicIndex].high_quality_url == null ||
                  currentList[currentMusicIndex].high_quality_url!.isEmpty)
                musicQualityEnum = MusicQualityEnum.low;
              break;
            case MusicQualityEnum.master:
              if (currentList[currentMusicIndex].master_quality_url == null ||
                  currentList[currentMusicIndex].master_quality_url!.isEmpty)
                musicQualityEnum = MusicQualityEnum.high;
              break;
            default:
          }
          notifyListeners();
        }
      });
      isLoaded = true;
      notifyListeners();
    }
  }

  download(BuildContext context, MusicModel musicModel,
      {bool canSave = true}) async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    var _response = await http.Client()
        .send(http.Request('GET', Uri.parse(musicModel.normal_quality_url!)));
    final List<int> _bytes = [];
    musicModel.maxSize = _response.contentLength ?? 0;
    musicModel.downloading = canSave;
    notifyListeners();
    _response.stream.listen((value) {
      _bytes.addAll(value);
      musicModel.downloadedProgress += value.length;
      notifyListeners();
    }).onDone(() async {
      var _imgResponse = await http.Client()
          .send(http.Request('GET', Uri.parse(musicModel.cover_photo_url!)));
      final List<int> _imgBytes = [];
      notifyListeners();
      _imgResponse.stream.listen((value) {
        _imgBytes.addAll(value);
      }).onDone(() async {
        File imgFile = new File(
            '''$dir/${musicModel.title_en!.replaceAll(' ', '')}_${musicModel.artists.singers.first.name_en.replaceAll(' ', '')}.jpg''');
        await imgFile.writeAsBytes(_imgBytes);
        musicModel.imgPath = imgFile.path;
        musicModel.downloading = false;
        if (canSave) musicModel.downloadedProgress = 0;
        notifyListeners();
        File file = new File(
            '''$dir/${musicModel.title_en!.replaceAll(' ', '')}_${musicModel.artists.singers.first.name_en.replaceAll(' ', '')}.mp3''');
        await file.writeAsBytes(_bytes);
        musicModel.filePath = file.path;
        if (canSave)
          dataBaseProvider.insertIntoDownloadedList(context, musicModel);
      });
    });
  }

  share(MusicModel musicModel) async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    File imgFile = new File('''$dir/${musicModel.title_en}.jpg''');
    var _imgResponse = await http.Client()
        .send(http.Request('GET', Uri.parse(musicModel.cover_photo_url!)));
    final List<int> _imgBytes = [];
    _imgResponse.stream.listen((value) {
      _imgBytes.addAll(value);
    }).onDone(() async {
      await imgFile.writeAsBytes(_imgBytes);
      SocialShare.shareInstagramStory(imgFile.path,
          backgroundTopColor: "#ffffff",
          backgroundBottomColor: "#000000",
          attributionURL:
              "https://www.ahanghaa.com/tracks/" + musicModel.id!.toString());
    });
  }

  setShuffleModel() {
    audioPlayer.setShuffleModeEnabled(!audioPlayer.shuffleModeEnabled);
    audioPlayer.shuffleModeEnabledStream.listen((event) {
      var s = event;
    });
    audioPlayer.shuffleIndicesStream.listen((event) {
      var s = event;
    });
    notifyListeners();
  }

  setRepeatModel() {
    audioPlayer.setLoopMode(
        audioPlayer.loopMode == LoopMode.off ? LoopMode.one : LoopMode.off);
    notifyListeners();
  }

  changeQuality(MusicQualityEnum qualityEnum) async {
    musicQualityEnum = qualityEnum;
    var nowDuration = currentDuration;
    await audioPlayer.setAudioSource(
      ConcatenatingAudioSource(
        children: currentList.map((e) {
          if (musicQualityEnum == MusicQualityEnum.low) {
            if (e.normal_quality_url != null &&
                e.normal_quality_url!.isNotEmpty)
              return AudioSource.uri(Uri.parse(e.normal_quality_url!));
            else
              return AudioSource.uri(Uri.parse(e.high_quality_url!));
          }
          if (musicQualityEnum == MusicQualityEnum.high) {
            if (e.high_quality_url != null && e.high_quality_url!.isNotEmpty)
              return AudioSource.uri(Uri.parse(e.high_quality_url!));
            else
              return AudioSource.uri(Uri.parse(e.normal_quality_url!));
          }
          if (musicQualityEnum == MusicQualityEnum.master) {
            if (e.master_quality_url != null &&
                e.master_quality_url!.isNotEmpty)
              return AudioSource.uri(Uri.parse(e.master_quality_url!));
            else
              return AudioSource.uri(Uri.parse(e.high_quality_url!));
          }
          return AudioSource.uri(Uri.parse(e.high_quality_url!));
        }).toList(),
      ),
      initialIndex: currentMusicIndex,
    );
    audioPlayer.play();
    audioPlayer.seek(nowDuration);
    notifyListeners();
  }

  playAudio() {
    audioPlayer.play();
  }

  pauseAudio() {
    audioPlayer.pause();
  }

  stopAudio() {
    audioPlayer.stop();
  }

  seekAudio(Duration durationToSeek) {
    audioPlayer.seek(durationToSeek);
  }

  clearAudio() {
    audioPlayer.stop();
    totalDurationStr = '0:00';
    currentDurationStr = '0:00';
    totalDuration = Duration();
    currentDuration = Duration();
    playerState = PlayerState(false, ProcessingState.buffering);
    isInit = false;
    isLoaded = false;
    currentMusicIndex = 0;
    notifyListeners();
  }

  nexAudio(BuildContext context) async {
    if (audioPlayer.hasNext) {
      await audioPlayer.seekToNext();
      notifyListeners();
    }
  }

  previousAudio(BuildContext context) async {
    if (audioPlayer.hasPrevious) {
      await audioPlayer.seekToPrevious();
      notifyListeners();
    }
  }

  Future<void> logging(BuildContext context) async {
    if (!currentList[currentMusicIndex].isPodcast &&
        currentList[currentMusicIndex].id! != currentMusicId) {
      currentMusicId = currentList[currentMusicIndex].id!;
      if (await mainProvider.checkInternet(context)) {
        if (UserInfos.getToken(context) != null &&
            UserInfos.getToken(context)!.isNotEmpty)
          CurrentListeningService(context, currentList[currentMusicIndex].id!);
        mainProvider
            .getMusicById(context, currentList[currentMusicIndex].id!)
            .then((value) => currentList[currentMusicIndex] = value);
      }
    }
  }

  void stopPlayerIn(int seconds) {
    cancelStopPlayerTimer();
    stopPlayerStart = seconds;
    notifyListeners();
    const oneSec = const Duration(seconds: 1);
    _stopPlayerTimer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (stopPlayerStart == 0) {
          timer.cancel();
          changeTimerEnum(TimerEnum.None);
          if (audioPlayer.playing) audioPlayer.pause();
          notifyListeners();
        } else {
          stopPlayerStart--;
          notifyListeners();
        }
      },
    );
  }

  void cancelStopPlayerTimer() {
    if (stopPlayerStart > 0 && _stopPlayerTimer.isActive)
      _stopPlayerTimer.cancel();
  }

  void changeTimerEnum(TimerEnum _timerEnum) {
    timerEnum = _timerEnum;
    notifyListeners();
  }
}
