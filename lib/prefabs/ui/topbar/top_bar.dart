import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:garageradio/defines/globals.dart';
import 'package:garageradio/defines/theme.dart';
import 'package:garageradio/prefabs/ui/topbar/top_bar_element.dart';

class TopBar extends StatefulWidget {
  final List<TopBarElement> elements;

  const TopBar({super.key, required this.elements});

  @override
  State<TopBar> createState() => TopBarState();
}

class TopBarState extends State<TopBar>{
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      width: MediaQuery.of(context).size.width,
      height: defTopBarHeigth,
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildElements(TopBarPosition.left),
          _buildElements(TopBarPosition.center),
          _buildElements(TopBarPosition.right)
        ],
      )
    );
  }

  Widget _buildElements(TopBarPosition position){
    List<TopBarElement> elements = widget.elements.where((element) => element.position == position).toList();
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        for(int idxElement = 0; idxElement < elements.length; idxElement++) ...{
          if(elements[idxElement].active) ...{
            elements[idxElement].element,
          }
        }
      ],
    );
  }

  void setElementActive(String elementId, bool active){
    TopBarElement? element = widget.elements.firstWhereOrNull((element) => element.id == elementId);
    if(element != null){
      element.active = active;
      setState(() {});
    }
  }
}