import 'package:flutter/material.dart';
import 'package:garageradio/defines/globals.dart';

class TopBarElement{
  final String id;
  final Widget element;
  final TopBarPosition position;
  bool active;

  TopBarElement({required this.id, required this.element, required this.position, this.active = true});
}
