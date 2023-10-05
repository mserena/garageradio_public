import 'package:flutter/material.dart';
import 'package:garageradio/prefabs/ui/buttons/custom_icon_button.dart';

class CustomIconStepsButton extends StatefulWidget {
  final List<CustomIconButton> icons;
  final Function onChangeStep;
  final int initialSelectedButton;

  const CustomIconStepsButton(
    {
      super.key,
      required this.icons,
      required this.onChangeStep,
      this.initialSelectedButton = 0,
    }
  );

  @override
  State<CustomIconStepsButton> createState() => CustomIconStepsButtonState();
}

class CustomIconStepsButtonState extends State<CustomIconStepsButton>{
  int _idxSelectedButton = 0;

  @override
  void initState() {
    _idxSelectedButton = widget.initialSelectedButton;
    widget.onChangeStep(_idxSelectedButton);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        _idxSelectedButton++;
        if(_idxSelectedButton == widget.icons.length){
          _idxSelectedButton = 0;
        }
        widget.onChangeStep(_idxSelectedButton);
        setState(() {});
      },
      child: AbsorbPointer(
        absorbing: true,
        child: widget.icons[_idxSelectedButton],
      ),
    );
  }
}