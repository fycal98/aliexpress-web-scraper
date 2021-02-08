import 'package:flutter/material.dart';
import '../../model/MyInharitedWidget.dart';

class SkuCard extends StatelessWidget {
  final String txt;
  final int propertyValueIdLong;
  final int i;
  final String cn;

  SkuCard({this.txt, this.propertyValueIdLong, this.i, this.cn});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (cn != '') {
          MyInharitedWidget.of(context).getShipngInfo(cn);
        }
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
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(txt),
        ),
      ),
    );
  }
}
