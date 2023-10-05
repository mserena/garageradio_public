import 'package:flutter/material.dart';
import 'package:garageradio/defines/globals.dart';
import 'package:garageradio/defines/theme.dart';
import 'package:garageradio/services/routes/route_definitions.dart';
import 'package:garageradio/services/routes/route_manager.dart';

void main() async{
  //debugPrintGestureArenaDiagnostics = true;
  runApp(const MaterialApp(home: GarageRadio()));
}

class GarageRadio extends StatefulWidget {
  const GarageRadio({super.key});

  @override
  State<GarageRadio> createState() => GarageRadioState();
}

class GarageRadioState extends State<GarageRadio> {
  @override
  Widget build(BuildContext context) {
    MaterialApp app = MaterialApp(
      title: "Garage Radio",
      navigatorKey: gNavigatorStateKey,
      initialRoute: gInitialRoute,
      onGenerateInitialRoutes: (initialRoute) {
        debugPrint('onGenerateInitialRoutes: $initialRoute');
        return [RouteManager().generateRoute(RouteSettings(name:initialRoute))];
      },
      onGenerateRoute: RouteManager().generateRoute,
      theme: garageRadioTheme(context),
    );
    return app;
  }
}