import 'dart:convert';

import 'package:http/http.dart';
import 'package:test_api/model/cidade.dart';

class CidadeService {
  static const _baseUrl = 'http://192.168.2.102:8080/cidades';

  Future<List<Cidade>> findCidades() async {
    final uri = Uri.parse(_baseUrl);
    final Response response = await get(uri);
    if (response.statusCode != 200 || response.body.isEmpty) {
      throw Exception();
    }
    final decodedBody = json.decode(response.body) as List;
    return decodedBody
        .map((e) => Cidade.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}