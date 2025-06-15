import 'package:crystal_skin_admin/models/apiResponse.dart';
import 'package:crystal_skin_admin/models/product.dart';
import 'package:crystal_skin_admin/providers/base_provider.dart';

class ProductProvider extends BaseProvider<Product> {
  ProductProvider() : super('Products');

  List<Product> data = <Product>[];

  @override
  Future<List<Product>> get(Map<String, String>? params) async {
    data = await super.get(params);

    return data;
  }

  @override
  Future<ApiResponse<Product>> getForPagination(Map<String, String>? params) async {
     return await super.getForPagination(params);
  }

  @override
  Product fromJson(data) {
    return Product.fromJson(data);
  }
}