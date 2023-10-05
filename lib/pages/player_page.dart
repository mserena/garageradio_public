import 'dart:async';
import 'dart:math';
import 'package:after_layout/after_layout.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:garageradio/defines/globals.dart';
import 'package:garageradio/defines/theme.dart';
import 'package:garageradio/prefabs/background/animated_wave.dart';
import 'package:garageradio/prefabs/ui/bubble/bubble.dart';
import 'package:garageradio/prefabs/ui/buttons/custom_icon_button.dart';
import 'package:garageradio/prefabs/ui/buttons/custom_icon_steps_button.dart';
import 'package:garageradio/prefabs/ui/text_scroll.dart';
import 'package:garageradio/prefabs/ui/topbar/top_bar.dart';
import 'package:garageradio/prefabs/ui/topbar/top_bar_element.dart';
import 'package:garageradio/services/radio/radio_manager.dart';
import 'package:garageradio/services/radio/radio_station.dart';
import 'package:garageradio/utils/image_utils.dart';

class PlayerPage extends StatefulWidget {
  final RadioStation initialStation;

  const PlayerPage({super.key, required this.initialStation});

  @override
  State<PlayerPage> createState() => PlayerPageState();
}

class PlayerPageState extends State<PlayerPage> with AfterLayoutMixin<PlayerPage>{
  bool _isLoading = true;
  final ScrollController _scrollController = ScrollController();
  late RadioStation _currentRadioStation;

  @override
  void initState() {
    _currentRadioStation = widget.initialStation;
    super.initState();
  }

  @override
  Future<FutureOr<void>> afterFirstLayout(BuildContext context) async {
    await _loadRadioStation();
  }

  Future<void> _loadRadioStation() async {
    _setLoading(true);
    await RadioManager().setRadioPlayStream(_currentRadioStation);
    _setLoading(false);
  }

  void _setLoading(bool loading){
    setState(() {
      _isLoading = loading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: _buildAudioPlayer(), 
          ),
          _buildWavesAnimation(),
          TopBar(
            elements: [
              TopBarElement(
                id: '',
                element: CustomIconButton(
                  icon: FontAwesomeIcons.arrowLeft,
                  iconColor: defBackgroundColor1End,
                  iconColor2: defBackgroundColor1Begin,
                  iconSize: ImageUtils.getIconSize(ObjectSize.normal, context: context),
                  onPress: _onPressBack
                ),
                position: TopBarPosition.left
              ),
              TopBarElement(
                id: gTopBarLoadingElementId,
                element: SizedBox(
                  width: ImageUtils.getIconSize(ObjectSize.normal, context: context),
                  height: ImageUtils.getIconSize(ObjectSize.normal, context: context),
                  child: const CircularProgressIndicator(
                    color: defTextColor,
                    strokeWidth: 2,
                  ),
                ),
                position: TopBarPosition.right,
                active: _isLoading
              )
            ]
          ),
        ],
      )
    );
  }

  Widget _buildAudioPlayer(){
    double playerWidth = defMaxPlayerWidth;
    if(MediaQuery.of(context).size.width < playerWidth){
      playerWidth = MediaQuery.of(context).size.width;
    }

    return Center(
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, defTopBarHeigth, 10, defTopBarHeigth),
        width: playerWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: playerWidth/1.5,
              height: playerWidth/1.5,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    defBackgroundColor1End,
                    defBackgroundColor1Begin
                  ]
                ),
                shape: BoxShape.circle
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Bubble(
                  imageUrl: _currentRadioStation.iconUrl,
                  build: _buildBubble,
                ),
              )
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: playerWidth/2,
              child: TextScroll(
                _currentRadioStation.name,
                style: Theme.of(gNavigatorStateKey.currentContext!).textTheme.titleMedium!,
              )
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: playerWidth/2,
              child: TextScroll(
                _currentRadioStation.tags,
                style: Theme.of(gNavigatorStateKey.currentContext!).textTheme.bodyMedium!,
              )
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: playerWidth/1.5,
              child: ValueListenableBuilder<RadioStreamState>(
                valueListenable: RadioManager().streamNotifier,
                builder: (_, value, __) {
                  Duration total = value.total != Duration.zero ? value.total : value.current+value.buffered;
                  return ProgressBar(
                    progressBarColor: defBackgroundColor1Begin,
                    bufferedBarColor: defBackgroundColor1Begin.withAlpha(100),
                    thumbColor: defBackgroundColor2Begin,
                    thumbGlowColor: defBackgroundColor2Begin,
                    thumbGlowRadius: 20.0,
                    baseBarColor: Colors.black.withAlpha(100),
                    timeLabelTextStyle: Theme.of(gNavigatorStateKey.currentContext!).textTheme.bodyMedium!,
                    progress: value.current,
                    buffered: value.buffered,
                    total: total,
                    onSeek: (selected) {
                      debugPrint('User selected a new time: $selected');
                      if(selected < total){
                        RadioManager().seek(selected);
                      }
                    },
                  );
                },
              ), 
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomIconStepsButton(
                  icons: [
                    CustomIconButton(
                      icon: Icons.volume_off,
                      iconColor: defBackgroundColor1End,
                      iconColor2: defBackgroundColor1Begin,
                      iconSize: ImageUtils.getIconSize(ObjectSize.big, context: context),
                    ),
                    CustomIconButton(
                      icon: Icons.volume_mute,
                      iconColor: defBackgroundColor1End,
                      iconColor2: defBackgroundColor1Begin,
                      iconSize: ImageUtils.getIconSize(ObjectSize.big, context: context),
                    ),
                    CustomIconButton(
                      icon: Icons.volume_down,
                      iconColor: defBackgroundColor1End,
                      iconColor2: defBackgroundColor1Begin,
                      iconSize: ImageUtils.getIconSize(ObjectSize.big, context: context),
                    ),
                    CustomIconButton(
                      icon: Icons.volume_up,
                      iconColor: defBackgroundColor1End,
                      iconColor2: defBackgroundColor1Begin,
                      iconSize: ImageUtils.getIconSize(ObjectSize.big, context: context),
                    ),
                  ],
                  onChangeStep: _onPressVolume,
                  initialSelectedButton: 3,
                ),
                CustomIconButton(
                  icon: Icons.fast_rewind,
                  iconColor: defBackgroundColor1End,
                  iconColor2: defBackgroundColor1Begin,
                  iconSize: ImageUtils.getIconSize(ObjectSize.big, context: context),
                  onPress: () => _onPressNextStation(-1)
                ),
                CustomIconButton(
                  icon: RadioManager().isPlaying() ? Icons.pause : Icons.play_arrow,
                  iconColor: defTextColor,
                  iconSize: ImageUtils.getIconSize(ObjectSize.big, context: context),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        defBackgroundColor1End,
                        defBackgroundColor1Begin
                      ]
                    ),
                    shape: BoxShape.circle
                  ),
                  onPress: _onPressPlay
                ),
                CustomIconButton(
                  icon: Icons.fast_forward,
                  iconColor: defBackgroundColor1End,
                  iconColor2: defBackgroundColor1Begin,
                  iconSize: ImageUtils.getIconSize(ObjectSize.big, context: context),
                  onPress: () => _onPressNextStation(1)
                ),
                CustomIconStepsButton(
                  icons: [
                    CustomIconButton(
                      icon: Icons.favorite_border,
                      iconColor: defBackgroundColor1End,
                      iconColor2: defBackgroundColor1Begin,
                      iconSize: ImageUtils.getIconSize(ObjectSize.big, context: context),
                    ),
                    CustomIconButton(
                      icon: Icons.favorite,
                      iconColor: defBackgroundColor1End,
                      iconColor2: defBackgroundColor1Begin,
                      iconSize: ImageUtils.getIconSize(ObjectSize.big, context: context),
                    ),
                  ],
                  onChangeStep: _onPressLike
                ),
              ],
            ),
          ],
        )
      ),
    );
  }

  Widget _buildWavesAnimation(){
    return  Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: AnimatedWave(
            height: 60,
            speed: 1.0,
            color: defBackgroundColor1End.withAlpha(100),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: AnimatedWave(
            height: 40,
            speed: 0.9,
            offset: pi,
            color: defBackgroundColor2End.withAlpha(100),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: AnimatedWave(
            height: 90,
            speed: 1.2,
            offset: pi/2,
            color: defBackgroundColor2Begin.withAlpha(100),
          ),
        ),
      ],
    );
  }

  void _onPressBack(){
    RadioManager().stopRadioPlayer();
    Navigator.pop(context);
  }

  void _onPressPlay(){
    if(!_isLoading){
      if(RadioManager().isPlaying()){
        RadioManager().pauseRadioPlayer();
      } else {
        RadioManager().playRadioPlayer();
      }
      setState(() {});
    }
  }

  void _onPressVolume(int level){
    double volume = level*(1/(gVolumeSteps-1));
    RadioManager().setVolumeRadioPlayer(volume);
    debugPrint('Volume level id: $level -> $volume');
  }

  void _onPressLike(int value){
    debugPrint('User press like.');
  }

  void _onPressNextStation(int direction){
    if(!_isLoading){
      _loadRadioStation();
      setState(() {
        _currentRadioStation = RadioManager().getNextRadioStation(direction, _currentRadioStation);
      });
    }
  }

  Widget _buildBubble(BuildContext context, ImageProvider imageProvider){
    return CircleAvatar(
      backgroundColor: Colors.transparent,
      foregroundImage: imageProvider,
    );
  }
}