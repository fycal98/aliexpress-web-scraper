import 'package:web_scraper/web_scraper.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> getUserData(String url) async {
  final webScraper = WebScraper('https://fr.aliexpress.com');

  await webScraper
      .loadWebPage(url.split('aliexpress.com')[1])
      .catchError((error) {
    throw error;
  });

  String data = webScraper
      .getPageContent()
      .trim()
      .split('window.runParams = {')[1]
      .split('data: ')[1]
      .split('};')[0]
      .split('};')[0]
      .split('csrfToken')[0]
      .replaceFirst('csrfToken', '')
      .trim();
  data = data.substring(0, data.length - 1);
  var obj = jsonDecode(data);
  return {
    'title': obj['pageModule']['title'],
    'id': obj['commonModule']['productId'],
    'largeImages': obj['imageModule']['imagePathList'],
    'smallImages': obj['imageModule']['summImagePathList'],
    'skus': obj['skuModule']['productSKUPropertyList'],
    'priceList': obj['skuModule']['skuPriceList'],
    'minPrice': obj['priceModule']['minAmount']['value'],
    'maxPrice': obj['priceModule']['maxAmount']['value'],
    'sellerAdminSeq': obj['descriptionModule']['sellerAdminSeq'],
    'url': url,
    'cookie': webScraper.cookie
  };
}

Map<String, String> headers(referer, cookie) {
  return {
    'cookie': cookie,
    'Connection': 'close',
    'Accept': 'application/json, text/plain, */*',
    'User-Agent':
        'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.88 Safari/537.36',
    'Sec-Fetch-Site': 'same-origin',
    'Sec-Fetch-Mode': 'cors',
    'Sec-Fetch-Dest': 'empty',
    'Referer': '${referer}',
    'Accept-Encoding': 'deflate',
    'Accept-Language': 'fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7,ar;q=0.6',
    'Content-Length': '0'
  };
}

Future<List<dynamic>> getShipinginfo(
    id, referer, cn, cookie, sellerAdminSeq, minPrice, maxPrice) async {
  final url =
      'https://fr.aliexpress.com/aeglodetailweb/api/logistics/freight?productId=${id}&sendGoodsCountry=${cn}&country=DZ&currency=EUR&count=1&sellerAdminSeq=${sellerAdminSeq}&minPrice=${minPrice}&maxPrice=${maxPrice}&userScene=PC_DETAIL_SHIPPING_PANEL&displayMultipleFreight=false';
  final responce = await http.get(url, headers: headers(referer, cookie));
  var obj = jsonDecode(responce.body);

  return obj['body']['freightResult'];
}
//
//   getUserData(url).then((data) {
//     getShipinginfo(data['id'], url, 'CN', data['cookie'],
//         data['sellerAdminSeq'], data['minPrice'], data['maxPrice']);
//   });
// }
