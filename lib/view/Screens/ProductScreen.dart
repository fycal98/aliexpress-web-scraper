import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/rendering.dart';
import '../../model/Sku.dart';
import '../../model/SkuPrice.dart';
import '../Widgets/SkuWidget.dart';
import '../../model/MyInharitedWidget.dart';
import '../../controller/Aliexpresse.dart';
import '../../controller/Product.dart';
import '../Widgets/ShipingSheet.dart';

class ProductScreen extends StatefulWidget {
  final data;
  ProductScreen(this.data);
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen>
    with SingleTickerProviderStateMixin {
  List selecteditems = [];
  String Price = '0';
  List images;
  String title;
  List skus;
  List<Sku> s;
  List Prices;
  List<SkuPrice> p;
  bool noshiping = false;
  bool shipInfoIsAv = false;
  List<dynamic> shipList = [];
  double shipingPrice = 0;
  int shipingIndex = 0;
  Function getShipngInfo(String country) {
    setState(() {
      shipList = [];
    });
    getShipinginfo(
            widget.data['id'],
            widget.data['url'],
            country,
            widget.data['cookie'],
            widget.data['sellerAdminSeq'],
            widget.data['minPrice'],
            widget.data['maxPrice'])
        .then((value) {
      shipList = value ?? [];
      if (shipList.isNotEmpty) {
        shipingPrice = shipList[shipingIndex]['freightAmount']['value'] * 210;
        noshiping = false;
      }

      if (shipList.isEmpty) {
        noshiping = true;
      }
      setState(() {});
    });
  }

  Function selectitem(int i, String value) {
    setState(() {
      selecteditems[i] = value;
    });
  }

  void changeprice() {
    int i = p
        .indexWhere((element) => listEquals(element.skuPropIds, selecteditems));

    if (i != -1) {
      Price = p[i].formatedAmount.toString();
    }
  }

  @override
  void initState() {
    // TODO: implement initState

    images = widget.data['largeImages'];
    title = widget.data['title'];
    skus = widget.data['skus'];
    s = skus
        .map((e) => Sku(
            skuPropertyName: e['skuPropertyName'],
            skuPropertyValues: e['skuPropertyValues']))
        .toList();
    for (var i in skus) {
      selecteditems.add('');
    }
    Prices = widget.data['priceList'];
    p = Prices.map((e) => SkuPrice(
        formatedAmount: e['skuVal']['skuAmount']['value'],
        skuPropIds: e['skuPropIds'].split((',')))).toList();
    getShipngInfo('CN');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (shipList.isNotEmpty) {
      shipingPrice = shipList[shipingIndex]['freightAmount']['value'] * 210;
    }
    changeprice();
    var size = MediaQuery.of(context).size;

    int i = 0;

    return MyInharitedWidget(
      selecteditems: selecteditems,
      selectitem: selectitem,
      getShipngInfo: getShipngInfo,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Container(
                  child: Stack(children: [
                    SingleChildScrollView(
                      child: Column(
                        //crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          CarouselSlider(
                              items:
                                  images.map((e) => Image.network(e)).toList(),
                              options: CarouselOptions(
                                aspectRatio: 1,
                              )),
                          Text(
                            title,
                            textAlign: TextAlign.center,
                          ),
                          ...s.map((e) => SkuWidget(e, i++)).toList(),

                          FittedBox(
                            child: TextButton.icon(
                              onPressed: () {
                                showModalBottomSheet(
                                    backgroundColor:
                                        Colors.white.withOpacity(0),
                                    context: context,
                                    builder: (context) => ShipingSheet(
                                          shipList: shipList,
                                          Index: shipingIndex,
                                        )).then((value) {
                                  if (value == null) return;
                                  setState(() {
                                    shipingIndex = value;
                                  });
                                });
                              },
                              label: noshiping
                                  ? Text('الشحن غير متوفر')
                                  : shipList.isEmpty
                                      ? Container()
                                      : Text(
                                          shipList[shipingIndex]['company'] +
                                              ' : ' +
                                              (shipList[shipingIndex]
                                                              ['freightAmount']
                                                          ['value'] *
                                                      210)
                                                  .toStringAsFixed(0) +
                                              ' دج',
                                        ),
                              icon: noshiping
                                  ? Container()
                                  : Icon(Icons.keyboard_arrow_down),
                            ),
                          ),
                          SizedBox(
                            height: 100,
                          )

                          // shipList.isNotEmpty
                          //     ? PopupMenuButton(
                          //         itemBuilder: (context) => <PopupMenuEntry>[
                          //               ...shipList
                          //                   .map((e) => PopupMenuItem(
                          //                         child: Text(
                          //                             '${e['company']} : ${e['freightAmount']['value']}'),
                          //                       ))
                          //                   .toList()
                          //             ])
                          //     : Container(),
                        ],
                      ),
                    ),
                    IconButton(
                        icon: Icon(
                          Icons.arrow_back_outlined,
                          color: Colors.black87,
                        ),
                        onPressed: () => Navigator.pop(context)),
                    AnimatedPositioned(
                        duration: Duration(milliseconds: 500),
                        bottom: noshiping
                            ? -100
                            : Price == '0'
                                ? -100
                                : 50,
                        left: size.width / 2 - 50,
                        child: Container(
                          width: 100,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 3,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Center(
                              child: FittedBox(
                                child: Text(
                                  (double.parse(Price) * 210 + shipingPrice)
                                          .toStringAsFixed(0) +
                                      ' دج',
                                  style: TextStyle(
                                      color: Colors.deepOrange,
                                      fontWeight: FontWeight.w900),
                                ),
                              ),
                            ),
                          ),
                        ))
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
