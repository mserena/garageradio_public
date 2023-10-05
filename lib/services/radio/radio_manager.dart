import 'dart:async';
import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:garageradio/defines/globals.dart';
import 'package:garageradio/services/notification_manager.dart';
import 'package:garageradio/services/package_info_manager.dart';
import 'package:garageradio/services/radio/radio_station.dart';
import 'package:garageradio/services/settings/settings_manager.dart';
import 'package:just_audio/just_audio.dart';

class RadioStreamState {
  final Duration current;
  final Duration buffered;
  final Duration total;
  
  RadioStreamState({
    required this.current,
    required this.buffered,
    required this.total,
  });
}

class RadioManager{
  late final AudioPlayer _player; 
  final List<RadioStation> _radioStations = [];
  RadioStation? _currentRadioStation;
  
  final streamNotifier = ValueNotifier<RadioStreamState>(
    RadioStreamState(
      current: Duration.zero,
      buffered: Duration.zero,
      total: Duration.zero,
    ),
  );

  // Singleton
  static final RadioManager _instance = RadioManager._internal();

  factory RadioManager(){
    return _instance;
  }

  RadioManager._internal();

  init() async{
    final Dio dio = Dio(
      BaseOptions(
        baseUrl: SettingsManager().appSettings.radioServerDefault,
        headers: {
          "User-Agent": PackageInfoManager().getAppName(),
        },
      ),
    );
    Map<String, dynamic> queryParameters = {
      "limit" : gMaxRadioStations,
    };
    final response = await dio.get(
      'json/stations/bycountry/spain',
      queryParameters: queryParameters,
    );
    if (response.statusCode == 200 && response.data != null) {
      // Parse radio stations
      for(int idxRadioStation = 0; idxRadioStation < response.data.length; idxRadioStation++){
        String name = response.data[idxRadioStation]['name'];
        String iconUrl = response.data[idxRadioStation]['favicon'];
        String streamUrl = response.data[idxRadioStation]['url'];
        String tags = response.data[idxRadioStation]['tags'];
        RadioStation station = RadioStation(name: name, tags: tags, iconUrl: iconUrl, streamUrl: streamUrl);
        if(_radioStations.firstWhereOrNull((s) => s.name == name) == null && iconUrl.isNotEmpty){
          _radioStations.add(station);
        }
      }
    }
    debugPrint('Found ${_radioStations.length} radio stations.');

    //Create audio player
    _player = AudioPlayer(userAgent: gAudioPlayerId);

    //Register player streams
    _player.positionStream.listen((position) {
      final oldState = streamNotifier.value;
      streamNotifier.value = RadioStreamState(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
    });

    _player.bufferedPositionStream.listen((bufferedPosition) {
      final oldState = streamNotifier.value;
      streamNotifier.value = RadioStreamState(
        current: oldState.current,
        buffered: bufferedPosition,
        total: oldState.total,
      );
    });

    _player.durationStream.listen((totalDuration) {
      final oldState = streamNotifier.value;
      streamNotifier.value = RadioStreamState(
        current: oldState.current,
        buffered: oldState.buffered,
        total: totalDuration ?? Duration.zero,
      );
    });
  }

  void dispose() {
    _player.dispose();
  }

  List<RadioStation> getRatioStations(){
    return _radioStations;
  }

  Future<void> setRadioPlayStream(RadioStation station, {bool play = true}) async{
    if(station != _currentRadioStation){
      _currentRadioStation = station;
      try {
        await _player.stop();
        await _player.setUrl(station.streamUrl);

        //Due to web browser policies it is not possible to play sounds automatically
        if(play && !kIsWeb){
          await _player.play();
        }
      } catch (e) {
        NotificationManager().addNotification(CustomNotificationType.connectionError);
        debugPrint('An error occured when set radio stream: $e');
        return;
      }
    }
  }

  void seek(Duration position) {
    _player.seek(position);
  }

  Future<void> stopRadioPlayer() async{
    await _player.stop();
  }

  Future<void> pauseRadioPlayer() async{
    await _player.pause();
  }

  Future<void> playRadioPlayer() async{
    await _player.play();
  }

  Future<void> setVolumeRadioPlayer(double volume) async{
    await _player.setVolume(volume);
  }

  RadioStation getNextRadioStation(int direction, RadioStation station){
    try{
      int idxStation = _radioStations.indexOf(station);
      idxStation += direction;
      if(idxStation > _radioStations.length){
        idxStation = 0;
      } else if(idxStation < 0){
        idxStation = _radioStations.length-1;
      }
      return _radioStations[idxStation];
    }
    catch(e)
    {
      debugPrint('Error on get next radio station ${e.toString()}');
      return _radioStations.first;
    }
  }

  bool isPlaying(){
    return _player.playing;
  }
}
