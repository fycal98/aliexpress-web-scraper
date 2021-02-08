import 'package:flutter/material.dart';
import 'SkuImg.dart';
import 'SkuCard.dart';
import '../../model/Sku.dart';

class SkuWidget extends StatelessWidget {
  final Sku sku;
  const SkuWidget(this.sku, this.i);
  final int i;

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> f = sku.skuPropertyValues[0];
    final bool hasimg = f.containsKey('skuPropertyImagePath');
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(sku.skuPropertyName),
          Container(
            height: hasimg ? 70 : 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: hasimg
                  ? sku.skuPropertyValues
                      .map((e) => skuImg(
                            i: i,
                            url: e['skuPropertyImageSummPath'],
                            propertyValueIdLong: e['propertyValueIdLong'],
                          ))
                      .toList()
                  : sku.skuPropertyValues
                      .map((e) => SkuCard(
                            i: i,
                            cn: e['skuPropertySendGoodsCountryCode'] ?? '',
                            txt: e['skuPropertyTips'],
                            propertyValueIdLong: e['propertyValueIdLong'],
                          ))
                      .toList(),
            ),
          )
        ],
      ),
    );
  }
}
