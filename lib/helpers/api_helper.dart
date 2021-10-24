import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:psychonauts_app/helpers/constans.dart';
import 'package:psychonauts_app/models/character.dart';
import 'package:psychonauts_app/models/psiPower.dart';
import 'package:psychonauts_app/models/response.dart';

class ApiHelper {
  
  static Future<Response> getCharacters() async {

    var url = Uri.parse('${Constans.apiUrl}/api/characters');
    var response = await http.get(
      url
    );

    var body = response.body;
    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    List<Character> list = [];    
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(Character.fromJson(item));
      }
    }

    return Response(isSuccess: true, result: list);
  }

}