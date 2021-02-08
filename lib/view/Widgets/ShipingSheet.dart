import 'package:flutter/material.dart';

class ShipingSheet extends StatefulWidget {
  List<dynamic> shipList = [];
  ShipingSheet({this.shipList, this.Index});
  int Index;

  @override
  _ShipingSheetState createState() => _ShipingSheetState();
}

class _ShipingSheetState extends State<ShipingSheet> {
  Function changeIndex(BuildContext context, int i) {
    setState(() {
      widget.Index = i;
    });
    Navigator.of(context).pop(i);
  }

  @override
  Widget build(BuildContext context) {
    int i = 0;
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 25),
        child: Column(
          children: [
            Text(
              'خيارات الشحن',
              style: TextStyle(color: Colors.black87, fontSize: 20),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  ...widget.shipList
                      .map((e) => element(
                            title: e['company'],
                            changeIndex: changeIndex,
                            price: e['freightAmount']['value'],
                            i: i++,
                            Index: widget.Index,
                          ))
                      .toList()
                ],
              ),
            ),
          ],
        ),
      ),
      height: 400,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20))),
    );
  }
}

class element extends StatelessWidget {
  const element({this.title, this.price, this.i, this.changeIndex, this.Index});
  final String title;
  final double price;
  final int i;
  final changeIndex;
  final int Index;

  @override
  Widget build(BuildContext context) {
    return RadioListTile(
      secondary: Text(
        (price * 210).toStringAsFixed(0) + ' دج',
        style: TextStyle(color: Color(0xffFF5252), fontWeight: FontWeight.w900),
      ),
      toggleable: true,
      selected: i == Index ? true : false,
      value: i,
      //subtitle: Text(' 6,64'),
      groupValue: 'shiping',
      onChanged: (i) {
        changeIndex(context, i);
      },
      title: Text(title),
    );
  }
}
