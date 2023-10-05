import 'package:flutter/material.dart';
import 'package:garageradio/defines/globals.dart';
import 'package:garageradio/defines/theme.dart';
import 'package:garageradio/prefabs/ui/flag.dart';
import 'package:garageradio/services/device_manager.dart';
import 'package:garageradio/services/language_manager.dart';
import 'package:garageradio/services/package_info_manager.dart';
import 'package:garageradio/utils/image_utils.dart';

class MainMenu extends StatefulWidget {
  final String selectedLanguage;
  final Function onLanguageSelected;

  const MainMenu({super.key, required this.selectedLanguage, required this.onLanguageSelected});

  @override
  State<MainMenu> createState() => MainMenuState();
}

class MainMenuState extends State<MainMenu>{
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = DeviceManager().getDeviceView(context) == DeviceView.expanded ? MediaQuery.of(context).size.width * 0.3 : MediaQuery.of(context).size.width * 0.75;
    return Theme( 
      data: Theme.of(context).copyWith(
        canvasColor: Colors.transparent,
      ),
      child:Align(
        alignment: Alignment.topRight,
        child: SizedBox(
          width: width,
          height: MediaQuery.of(context).size.height,
          child: Drawer(
            child: Container(
              color: defBackgroundColor,
              child: ListView(
                children: [
                  Container(
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        const SizedBox(height: 60),
                        Container(
                          alignment: Alignment.center,
                          child: Wrap(
                            runAlignment: WrapAlignment.center,
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              for(int idxLanguage = 0; idxLanguage < gDefaultLanguagesList.length; idxLanguage++) ...{
                                Container(
                                  margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                  width: ImageUtils.getFlagSize(ObjectSize.normal,context: context).width,
                                  height: ImageUtils.getFlagSize(ObjectSize.normal,context: context).height,
                                  child: Flag.fromString(
                                    gDefaultLanguagesList[idxLanguage]['isoCode'],
                                    gDefaultLanguagesList[idxLanguage]['flag'],
                                    fit: BoxFit.fill,
                                    borderRadius: 10,
                                    onPress: (isoCode){
                                      widget.onLanguageSelected(isoCode);
                                    },
                                    selected: gDefaultLanguagesList[idxLanguage]['isoCode'] == widget.selectedLanguage,
                                  )
                                ),
                              }
                            ],
                          ),
                        ),
                        const SizedBox(height: 60),
                        Image.asset(
                          defAppIcon,
                          width: 150,
                          height: 88,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '${LanguageManager().getText('Version')} ${PackageInfoManager().getVersion()}',
                          textAlign: TextAlign.center,
                          style: Theme.of(gNavigatorStateKey.currentContext!).textTheme.bodySmall!,
                        ),
                        Text(
                          LanguageManager().getText('Created with pasion for LABHOUSE.'),
                          textAlign: TextAlign.center,
                          style: Theme.of(gNavigatorStateKey.currentContext!).textTheme.bodySmall!,
                        ),
                      ],
                    )
                  )
                ]
              )
            ),
          )
        ),
      )
    );
  }
}