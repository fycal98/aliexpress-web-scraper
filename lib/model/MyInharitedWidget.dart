import 'package:flutter/material.dart';

class MyInharitedWidget extends InheritedWidget {
  const MyInharitedWidget(
      {Key key,
      @required Widget child,
      this.selecteditems,
      this.selectitem,
      this.getShipngInfo})
      : assert(child != null),
        super(key: key, child: child);
  final List selecteditems;
  final Function selectitem;

  final Function getShipngInfo;

  static MyInharitedWidget of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MyInharitedWidget>();
  }

  @override
  bool updateShouldNotify(MyInharitedWidget old) {
    return selecteditems != old.selecteditems;
  }
}
