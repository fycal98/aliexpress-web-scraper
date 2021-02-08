import 'package:flutter/material.dart';
import '../../model/MyInharitedWidget.dart';

class skuImg extends StatelessWidget {
  final String url;
  final int propertyValueIdLong;
  final int i;

  skuImg({this.url, this.propertyValueIdLong, this.i});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        MyInharitedWidget.of(context)
            .selectitem(i, propertyValueIdLong.toString());
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
            side: BorderSide(
                width: 2,
                color: MyInharitedWidget.of(context).selecteditems[i] ==
                        propertyValueIdLong.toString()
                    ? Colors.deepOrange
                    : Colors.white),
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Container(
          child: Image.network(
            url,
          ),
        ),
      ),
    );
  }
}
