import 'package:bloc_app/model/album.dart';
import 'package:flutter/material.dart';
import 'package:bloc_app/widgets/txt.dart';

class ListRow extends StatelessWidget {
  //
  final Album album;
  final Function onTap;
  ListRow({this.album, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Txt(text: album.title),
          Divider(),
        ],
      ),
    );
  }
}
