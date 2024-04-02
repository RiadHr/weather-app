import 'package:http/http.dart' as http;
import 'dart:convert';



class NetworkHelper {
  NetworkHelper({this.url});
  Uri url;

  Future<String> getData() async {
        http.Response response = await http.get(url);

        if (response.statusCode == 200) {
          String res = response.body;
          print('response = ${response.body}');
          return res;
        } else {
          print('status = ${response.statusCode}');
        }
  }
}