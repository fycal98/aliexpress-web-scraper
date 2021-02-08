import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import '../../controller/Aliexpresse.dart';
import 'ProductScreen.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  bool scroll = false;

  TextEditingController txtcontroller;
  String text;
  Widget child;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    child = row();
    txtcontroller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double factor = MediaQuery.of(context).size.width / 360;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(8.0 * factor),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset('images/logo.png'),
              AnimatedContainer(
                onEnd: () {
                  setState(() {
                    child = child.runtimeType.toString() == 'Padding'
                        ? row()
                        : Padding(
                            padding:
                                EdgeInsets.symmetric(vertical: 8.0 * factor),
                            child: CircularProgressIndicator(
                              strokeWidth: 2 * factor,
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                              //backgroundColor: Colors.white,
                            ),
                          );
                  });
                },
                duration: Duration(milliseconds: 300),
                width: scroll ? 50 * factor : size.width - 16 * factor,
                // width: 50,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 0,
                        blurRadius: 3,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    color: !scroll ? Colors.white : Color(0xFFFF5722),
                    border: scroll
                        ? null
                        : Border.all(
                            color: Color(0xFFE64A19),
                            width: 3 * factor,
                          ),
                    borderRadius: BorderRadius.all(Radius.circular(50))),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0 * factor),
                  child: child,
                ),
              ),
              SizedBox(
                height: 30 * factor,
              ),
              Image.asset('images/image.png')
            ],
          ),
        ),
      )),
    );
  }

  Row row() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          flex: 4,
          child: TextField(
            onChanged: (value) {
              text = value;
            },
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
            controller: txtcontroller,
          ),
        ),
        Expanded(
            child: FlatButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(50))),
          onPressed: () {
            setState(() {
              txtcontroller.clear();
              scroll = true;
            });
            getUserData(text).then((value) {
              setState(() {
                scroll = false;
              });
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => ProductScreen(value)));
            });
            setState(() {
              scroll = true;
            });
          },
          color: Color(0xFFFF5722),
          child: FittedBox(
            child: Text(
              'بحث',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ))
      ],
    );
  }
}
