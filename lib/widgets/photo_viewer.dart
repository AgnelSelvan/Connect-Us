import 'package:connect_us/utils/universal_variables.dart';
import 'package:connect_us/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PhotoViewer extends StatefulWidget {
  final String imgUrl;
  PhotoViewer({@required this.imgUrl});

  @override
  _PhotoViewerState createState() => _PhotoViewerState();
}

class _PhotoViewerState extends State<PhotoViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context),
      body: PhotoView(
        imageProvider: NetworkImage(widget.imgUrl),
        minScale: PhotoViewComputedScale.contained * 0.8,
        maxScale: PhotoViewComputedScale.covered * 2,
        enableRotation: true,
        backgroundDecoration: BoxDecoration(color: Colors.white),
      ),
    );
  }

  CustomAppBar customAppBar(context) {
    return CustomAppBar(
      actions: [],
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Variables.greenColor,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      centerTitle: false,
      title: Text(
        "Photo",
        style: TextStyle(
          color: Variables.greenColor,
        ),
      ),
    );
  }
}
