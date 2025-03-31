import 'dart:convert';

import 'package:http/http.dart' as http;

class Networkservice{
  static final Networkservice _instance = Networkservice._internal();
  factory Networkservice() => _instance;
  Networkservice._internal();

  Future getData(String url) async{
    http.Response response = await http.get(Uri.parse(url));

    if(response.statusCode==200){
      return jsonDecode(response.body);
    }
  }

}