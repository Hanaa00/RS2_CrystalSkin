import 'package:crystal_skin_mobile/models/product.dart';
import 'package:crystal_skin_mobile/providers/base_provider.dart';
import 'package:crystal_skin_mobile/utils/authorization.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RecommenderProvider extends BaseProvider<Product> {
  RecommenderProvider() : super('Recommendations');

  Future<List<Product>> getRecommendations() async {
    try {
      final response = await http.get(
        Uri.parse('${BaseProvider.apiUrl}/Recommendations/${Authorization.id}'),
        headers: Authorization.createHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => fromJson(item)).toList();
      } else {
        throw Exception('Failed to load recommendations');
      }
    } catch (e) {
      throw Exception('Failed to connect to API: $e');
    }
  }

  @override
  Product fromJson(data) {
    return Product.fromJson(data);
  }
}