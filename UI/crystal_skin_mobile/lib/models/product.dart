import 'product_category.dart';

class Product {
  int id;
  String name;
  String description;
  double price;
  int stock;
  String imageUrl;
  bool isEnable;
  String? manufacturer;
  String? barcode;
  String? ingredients;
  int productCategoryId;
  ProductCategory? productCategory;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.imageUrl,
    required this.isEnable,
    this.manufacturer,
    this.barcode,
    this.ingredients,
    required this.productCategoryId,
    this.productCategory,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      stock: json['stock'],
      imageUrl: json['imageUrl'],
      isEnable: json['isEnable'],
      manufacturer: json['manufacturer'],
      barcode: json['barcode'],
      ingredients: json['ingredients'],
      productCategoryId: json['productCategoryId'],
      productCategory: json['productCategory'] != null ?  ProductCategory.fromJson(json['productCategory']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'price': price,
    'stock': stock,
    'imageUrl': imageUrl,
    'isEnable': isEnable,
    'manufacturer': manufacturer,
    'barcode': barcode,
    'ingredients': ingredients,
    'productCategoryId': productCategoryId,
    'productCategory': productCategory?.toJson(),
  };
}