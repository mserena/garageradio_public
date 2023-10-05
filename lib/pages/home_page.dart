import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:garageradio/defines/globals.dart';
import 'package:garageradio/defines/theme.dart';
import 'package:garageradio/prefabs/background/animated_background.dart';
import 'package:garageradio/prefabs/ui/bubble/bubble.dart';
import 'package:garageradio/prefabs/ui/bubble/bubbles_ui.dart';
import 'package:garageradio/prefabs/ui/buttons/custom_icon_button.dart';
import 'package:garageradio/prefabs/ui/topbar/top_bar.dart';
import 'package:garageradio/prefabs/ui/topbar/top_bar_element.dart';
import 'package:garageradio/prefabs/ui/topbar/top_bar_menu_drawer.dart';
import 'package:garageradio/services/device_manager.dart';
import 'package:garageradio/services/language_manager.dart';
import 'package:garageradio/services/radio/radio_manager.dart';
import 'package:garageradio/services/routes/route_definitions.dart';
import 'package:garageradio/utils/image_utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage>{
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;

  void _setLoading(bool loading){
    setState(() {
      _isLoading = loading;
    });
  }

  @override
  void dispose() {
    RadioManager().stopRadioPlayer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double bubbleSize = DeviceManager().getDeviceView(context) == DeviceView.expanded ? defBubbleExtendedSize : defBubbleCompactSize;
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          const AnimatedBackground(showWaves: false),
          BubblesUI(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            size: bubbleSize,
            widgets: RadioManager().getRatioStations().map(
              (radioStation) {
                return MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onLongPress: () async {
                      if(!_isLoading){
                        _setLoading(true);
                        await RadioManager().setRadioPlayStream(radioStation);
                        await RadioManager().setVolumeRadioPlayer(1);
                        RadioManager().playRadioPlayer();
                        debugPrint(radioStation.toString());
                        _setLoading(false);
                      }
                    },
                    onTap: () async {
                      await RadioManager().stopRadioPlayer();
                      if(context.mounted){
                        Navigator.pushNamed(
                          context,
                          gPlayerRoute,
                          arguments: radioStation
                        );
                      }
                    },
                    child: SizedBox(
                      width: bubbleSize,
                      height: bubbleSize,
                      child: Bubble(
                        imageUrl: radioStation.iconUrl,
                        build: _buildBubble,
                      )
                    )
                  )
                );
              }
            ).toList(),
          ),
          TopBar(
            elements: [
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
                position: TopBarPosition.left,
                active: _isLoading
              ),
              TopBarElement(
                id: '',
                element: CustomIconButton(
                  icon: FontAwesomeIcons.bars,
                  onPress: () {
                    _scaffoldKey.currentState!.openEndDrawer();
                  }
                ),
                position: TopBarPosition.right
              ),
            ]
          ),
        ],
      ),
      floatingActionButton: !_isLoading && RadioManager().isPlaying() ? Container(
        margin: const EdgeInsets.fromLTRB(0, 0, 10, 20),
        width: ImageUtils.getIconSize(ObjectSize.big, context: context),
        height: ImageUtils.getIconSize(ObjectSize.big, context: context),
        child: CustomIconButton(
          icon: Icons.stop,
          iconColor: defBackgroundColor1End,
          iconColor2: defBackgroundColor1Begin,
          iconSize: ImageUtils.getIconSize(ObjectSize.big, context: context),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle
          ),
          onPress: _onPressStop
        ),
      ) : Container(),
      endDrawer: MainMenu(
        selectedLanguage: LanguageManager().getCurrentLanguage(),
        onLanguageSelected: _onLanguageSelected
      ),
      onEndDrawerChanged: (isOpened) {
        //End Drawer Closed
      },
    );
  }

  Widget _buildBubble(BuildContext context, ImageProvider imageProvider){
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: imageProvider,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  void _onPressStop(){
    RadioManager().stopRadioPlayer();
    setState(() {});
  }

  void _onLanguageSelected(String language){
    LanguageManager().setCurrentLanguage(language);
    setState(() {});
  }
}