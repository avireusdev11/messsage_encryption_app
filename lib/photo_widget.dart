import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';
class Photo_widget extends StatefulWidget {

  Photo_widget({this.photolink});
  final String? photolink;

  @override
  _Photo_widgetState createState() => _Photo_widgetState();
}

class _Photo_widgetState extends State<Photo_widget> {

  @override
  Widget build(BuildContext context) {
    return ExtendedImage.network(
      widget.photolink.toString(),
      fit: BoxFit.cover,
      cache: true,
      enableSlideOutPage: true,
      filterQuality: FilterQuality.high,

      loadStateChanged: (ExtendedImageState state){
        switch (state.extendedImageLoadState){

          case LoadState.loading:
            return Center(child:CircularProgressIndicator());
            break;
          case LoadState.completed:
            return null;
            break;
          case LoadState.failed:
            return GestureDetector(child: Center(child: Text("reload"),),onTap: (){
              state.reLoadImage();
            },);
            break;

        }
        return Text("");
      },
    );
  }
}