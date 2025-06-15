import 'package:crystal_skin_admin/helpers/json_helper.dart';
import 'package:crystal_skin_admin/models/base.dart';
import 'package:crystal_skin_admin/models/productCategory.dart';

class Product extends BaseModel {
  late String name;
  late String description;
  late String? manufacturer;
  late String? barcode;
  late String? ingredients;
  late double price;
  late bool isEnable;
  late String imageUrl;
  late int stock;
  late int productCategoryId;
  late ProductCategory productCategory;

  Product();

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    manufacturer = json['manufacturer'];
    barcode = json['barcode'];
    ingredients = json['ingredients'];
    price = JsonHelper.toDouble(json['price']);
    isEnable = json['isEnable'];
    imageUrl = json['imageUrl'];
    stock = json['stock'];
    productCategoryId = json['productCategoryId'];
    if (json['productCategory'] != null) {
      productCategory = ProductCategory.fromJson(json['productCategory']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['manufacturer'] = manufacturer;
    data['barcode'] = barcode;
    data['ingredients'] = ingredients;
    data['price'] = price;
    data['isEnable'] = isEnable;
    data['stock'] = stock;
    data['productCategoryId'] = productCategoryId;
    return data;
  }
}
