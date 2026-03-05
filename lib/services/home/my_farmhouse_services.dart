import 'dart:convert';
import 'package:farmhouse_vendor/constant/api_constant.dart';
import 'package:farmhouse_vendor/model/farmhouse_model.dart';
import 'package:http/http.dart' as http;

class FarmhouseService {
  FarmhouseService._();
  static final FarmhouseService instance = FarmhouseService._();

  Future<FarmhouseModel> getFarmhouseById({required String farmhouseId}) async {
    final url = Uri.parse('${ApiConstants.baseUrl}/farmhouse/$farmhouseId');

    try {
      final response = await http.get(
        url,
        headers: ApiConstants.headers, // no auth header
      );

            print('llllllllllllllllllllllllllllllllllllllllllllllll $url');


      print('Response status code for fetch farmhouse ${response.statusCode}');
      print('Response bodyyyyyyyyyyy for fetch farmhouse ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return FarmhouseModel.fromJson(json);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to fetch farmhouse');
      }
    } on http.ClientException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      rethrow;
    }
  }
}
