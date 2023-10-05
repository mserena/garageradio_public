import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:garageradio/defines/globals.dart';
import 'package:garageradio/defines/theme.dart';
import 'package:garageradio/prefabs/background/animated_background.dart';
import 'package:garageradio/prefabs/text/animated_text_fade.dart';
import 'package:garageradio/prefabs/text/animated_texts.dart';
import 'package:garageradio/services/language_manager.dart';
import 'package:garageradio/services/services_loader.dart';
import 'package:garageradio/services/settings/settings_manager.dart';

class LoaderPage extends StatefulWidget {
  final String route;

  const LoaderPage({super.key, required this.route});

  @override
  State<LoaderPage> createState() => LoaderPageState();
}

class LoaderPageState extends State<LoaderPage>{
  @override
  void initState() {
    ServicesLoader().loadServices().then((value){
      if(ServicesLoader().isServicesLoaded()){
        Navigator.pushNamed(context, widget.route);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          const AnimatedBackground(showWaves: true),
          ValueListenableBuilder<bool>(
            valueListenable: SettingsManager().isInitialized(),
            builder: (BuildContext context, bool settingsInitialized, Widget? snapshot) {
              if (settingsInitialized && SettingsManager().appSettings.loadingPhrases.isNotEmpty) {
                return Center(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 50),
                    child: DefaultTextStyle(
                      style: Theme.of(gNavigatorStateKey.currentContext!).textTheme.titleMedium!,
                      child: AnimatedTextKit(
                        animatedTexts: SettingsManager().appSettings.loadingPhrases.map(
                          (text) => FadeAnimatedText(LanguageManager().getText(text))
                        ).toList(),
                      ),
                    ),
                  ),
                );
              } else {
                return const Center( 
                  child: SpinKitWave(
                    color: defTextColor,
                    duration: Duration(seconds: 2),
                    size: 100,
                  )
                );
              }
            }
          ),
        ],
      )
    );
  }
}