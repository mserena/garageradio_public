import 'package:flutter/material.dart';
import 'package:garageradio/defines/theme.dart';

class CustomIconButton extends StatefulWidget {
  final IconData icon;
  final Color iconColor;
  final Color? iconColor2;
  final BoxDecoration? decoration;
  final double iconSize;
  final double width;
  final double height;
  final Function? onPress;

  const CustomIconButton(
    {
      super.key,
      required this.icon,
      this.iconColor = defTextColor,
      this.iconColor2,
      this.decoration,
      this.iconSize = 25,
      this.width = 60,
      this.height = 60,
      this.onPress,
    }
  );

  @override
  State<CustomIconButton> createState() => CustomIconButtonState();
}

class CustomIconButtonState extends State<CustomIconButton>{
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.onPress != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: (){
          if(widget.onPress != null){
            widget.onPress!();
          }
        },
        child: Container(
          width: widget.width,
          height: widget.height,
          decoration: widget.decoration,
          child: FittedBox(
            fit: BoxFit.scaleDown, 
            child: Align(
              alignment: AlignmentDirectional.center,
              child: widget.iconColor2 != null ? 
              ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (Rect bounds) => RadialGradient(
                  center: Alignment.topCenter,
                  stops: const [.5, 1],
                  colors: [
                    widget.iconColor,
                    widget.iconColor2!,
                  ],
                ).createShader(bounds),
                child: Icon(
                  widget.icon,
                  size: widget.iconSize,
                )
              )
              :
              Icon(
                widget.icon,
                size: widget.iconSize,
                color: widget.iconColor,
              )
            )
          ),
        )
      )
    );
  }
}