import 'package:flutter/material.dart';
import 'package:garageradio/pages/home_page.dart';
import 'package:garageradio/pages/loader_page.dart';
import 'package:garageradio/pages/player_page.dart';
import 'package:garageradio/services/radio/radio_station.dart';
import 'package:garageradio/services/routes/route_definitions.dart';
import 'package:garageradio/services/services_loader.dart';
import 'package:page_transition/page_transition.dart';

class RouteManager{
  String? _currentRoute;

  // Singleton
  static final RouteManager _instance = RouteManager._internal();

  factory RouteManager(){
    return _instance;
  }

  RouteManager._internal();

  Route<dynamic> generateRoute(RouteSettings settings) {
    debugPrint('new route, from $_currentRoute to ${settings.name}');
    _currentRoute = settings.name; 

    // Load services if not loaded
    if(!ServicesLoader().isServicesLoaded()){
      debugPrint('Services not loaded, go to loader...');
      _currentRoute = gLoaderRoute;
      return PageTransition(
        type: PageTransitionType.fade,
        child: LoaderPage(route: settings.name!),
      );      
    }

    switch (_currentRoute) {
      case gHomeRoute:
        return _doPageTransition(const HomePage());
      case gPlayerRoute:
        RadioStation station = settings.arguments as RadioStation;
        return _doPageTransition(PlayerPage(initialStation: station));
      default:
        return _doPageTransition(const HomePage());
    }
  }

  Route<dynamic> _doPageTransition(Widget target){
    return PageTransition(
      type: PageTransitionType.fade,
      child: target,
    );
  }

  String getCurrentRoute(){
    return _currentRoute ?? gUnknownRoute;
  }
}