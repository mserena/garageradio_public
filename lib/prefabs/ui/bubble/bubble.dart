import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:garageradio/defines/theme.dart';

class Bubble extends StatefulWidget {
  final String imageUrl;
  final Function build;

  const Bubble({super.key, required this.imageUrl, required this.build});

  @override
  State<Bubble> createState() => BubbleState();
}

class BubbleState extends State<Bubble>{
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: widget.imageUrl,
      imageBuilder: (context, imageProvider) => widget.build(context,imageProvider),
      placeholder: (context, url) => const CircularProgressIndicator(color: defTextColor),
      errorWidget: (context, url, error) {
        return Center(
          child: Image.asset(
            defBubbleImage,
          )
        );
      }
    );
  }
}