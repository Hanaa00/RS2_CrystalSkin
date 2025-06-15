import 'package:crystal_skin_mobile/helpers/colors.dart';
import 'package:crystal_skin_mobile/helpers/image_helper.dart';
import 'package:crystal_skin_mobile/providers/cart_provider.dart';
import 'package:crystal_skin_mobile/screens/cart/checkout_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Košarica'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: cartProvider.items.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 60, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Vaša košarica je prazna',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            )
                : ListView.builder(
              itemCount: cartProvider.items.length,
              itemBuilder: (context, index) {
                final item = cartProvider.items[index];
                return ListTile(
                  leading:
                  //CircleAvatar(
                  //  backgroundColor: Colors.grey[200],
                  //  backgroundImage: item.product.imageUrl.isNotEmpty
                  //      ? ImageHelper.buildImage(item.product.imageUrl)
                  //      : null,
                  //  child: item.product.imageUrl.isEmpty
                  //      ? Icon(Icons.shopping_bag, color: Colors.grey)
                  //      : null,
                  //),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey[100],
                      child: item.product.imageUrl.isNotEmpty ? ImageHelper.buildImage(item.product.imageUrl) : null,
                    ),
                  ),
                  title: Text(item.product.name),
                  subtitle: Text(
                      '${item.product.price.toStringAsFixed(2)} KM × ${item.quantity}'),
                  trailing: Text(
                    '${item.totalPrice.toStringAsFixed(2)} KM',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16, color: app_color),
                  ),
                );
              },
            ),
          ),
          if (cartProvider.items.isNotEmpty)
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Ukupno:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold, color: app_color),
                      ),
                      Text(
                        '${cartProvider.totalPrice.toStringAsFixed(2)} KM',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: app_color),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CheckoutPage()),
                        );
                      },
                      child: Text('NASTAVI NA PLAĆANJE', style: TextStyle(color: app_color)),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}