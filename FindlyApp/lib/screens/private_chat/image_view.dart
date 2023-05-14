import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import '../../constants/constants.dart';
//This component is to make users view an image sent in a private chat
class ImageViewScreen extends StatefulWidget {
  const ImageViewScreen({
    Key? key,
    required this.imageUrl,
  }) : super(key: key);
  final String imageUrl;

  @override
  State<ImageViewScreen> createState() => _ImageViewScreenState();
}

class _ImageViewScreenState extends State<ImageViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      body: Center(
        child: PhotoView(
          imageProvider: NetworkImage(
            widget.imageUrl,
          ),
        ),
      ),
    );
  }
}
