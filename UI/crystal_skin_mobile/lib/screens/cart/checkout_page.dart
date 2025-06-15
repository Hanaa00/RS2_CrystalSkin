import 'package:crystal_skin_mobile/helpers/colors.dart';
import 'package:crystal_skin_mobile/models/order_item.dart';
import 'package:crystal_skin_mobile/models/order.dart';
import 'package:crystal_skin_mobile/providers/cart_provider.dart';
import 'package:crystal_skin_mobile/providers/login_provider.dart';
import 'package:crystal_skin_mobile/providers/order_provider.dart';
import 'package:crystal_skin_mobile/screens/cart/order_confirmation_page.dart';
import 'package:crystal_skin_mobile/utils/authorization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as Stripe;
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class CheckoutPage extends StatefulWidget {
  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: "${LoginProvider.authResponse!.firstName} ${LoginProvider.authResponse!.lastName}");
  final _emailController = TextEditingController(text: LoginProvider.authResponse!.email);
  final _phoneController = TextEditingController(text: LoginProvider.authResponse!.phoneNumber);
  final _addressController = TextEditingController(text: LoginProvider.authResponse!.address);
  final _noteController = TextEditingController();

  String? _paymentMethod = 'pouzece';
  String? _deliveryMethod = 'dostava';
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>> createPaymentIntent(
    double amount,
    String currency,
  ) async {
    try {
      Map<String, dynamic> body = {
        'amount': (amount * 100).toStringAsFixed(0),
        'currency': currency,
        'payment_method_types[]': 'card',
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        body: body,
        headers: {
          'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );

      return jsonDecode(response.body);
    } catch (err) {
      rethrow;
    }
  }

  Future<void> showPaymentSheet(double price) async {
    setState(() {
      _isLoading = true;
    });

    try {
      var paymentIntentData = await createPaymentIntent(price, 'BAM');

      await Stripe.Stripe.instance.initPaymentSheet(
        paymentSheetParameters: Stripe.SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentData['client_secret'],
          merchantDisplayName: 'Crystal Skin Plaćanje',
          appearance: const Stripe.PaymentSheetAppearance(
            primaryButton: Stripe.PaymentSheetPrimaryButtonAppearance(
              colors: Stripe.PaymentSheetPrimaryButtonTheme(
                light: Stripe.PaymentSheetPrimaryButtonThemeColors(
                  background: Colors.cyan,
                ),
              ),
            ),
          ),
        ),
      );

      await Stripe.Stripe.instance.presentPaymentSheet();

      await _placeOrder(context, Provider.of<CartProvider>(context, listen: false), paymentIntentData['id']);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Greška pri plaćanju: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _placeOrder(
    BuildContext context,
    CartProvider cartProvider,
    String? transactionId
  ) async {

    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

    final orderData = Order(
        id: 0,
        patientId: Authorization.id!,
        fullName: _nameController.text,
        phoneNumber: _phoneController.text,
        address:  _addressController.text,
        note: _noteController.text,
        paymentMethod: _paymentMethod,
        deliveryMethod: _deliveryMethod,
        totalAmount: cartProvider.totalPrice,
        transactionId: transactionId,
        date: DateTime.now(),
        items: cartProvider.items.map(
            (item) => OrderItemModel(id: 0,
              orderId: 0,
              productId: item.product.id,
              quantity: item.quantity,
              unitPrice: item.product.price
          )
        ).toList()
    );


    await orderProvider.insert(orderData);

    cartProvider.clearCart();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderConfirmationPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Naplata'), centerTitle: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          autovalidateMode: AutovalidateMode.onUnfocus,
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Podaci za narudžbu',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Ime i prezime',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Molimo unesite ime i prezime';
                  }
                  return null;
                },
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'[a-zA-ZšđčćžŠĐČĆŽ\s]'),
                  ),
                ],
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Molimo unesite email';
                  }
                  if (!value.contains('@')) {
                    return 'Molimo unesite validan email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12),
              TextFormField(
                keyboardType: TextInputType.phone,
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Broj telefona',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Molimo unesite broj telefona';
                  }
                  RegExp phoneNumberRegExp = RegExp(r'^\d{9,15}$');
                  if (!phoneNumberRegExp.hasMatch(value)) {
                    return 'Broj telefona mora imati između 9 i 15 cifara';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Adresa dostave',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Molimo unesite adresu dostave';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _noteController,
                decoration: InputDecoration(
                  labelText: 'Napomena (opcionalno)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 24),
              Text(
                'Način plaćanja',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              RadioListTile<String>(
                activeColor: app_color,
                title: Text('Pouzećem'),
                value: 'pouzece',
                groupValue: _paymentMethod,
                onChanged: (value) {
                  setState(() {
                    _paymentMethod = value;
                  });
                },
              ),
              RadioListTile<String>(
                activeColor: app_color,
                title: Text('Kreditnom karticom'),
                value: 'kartica',
                groupValue: _paymentMethod,
                onChanged: (value) {
                  setState(() {
                    _paymentMethod = value;
                  });
                },
              ),
              SizedBox(height: 24),
              Text(
                'Način dostave',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              RadioListTile<String>(
                activeColor: app_color,
                title: Text('Dostava'),
                value: 'dostava',
                groupValue: _deliveryMethod,
                onChanged: (value) {
                  setState(() {
                    _deliveryMethod = value;
                  });
                },
              ),
              RadioListTile<String>(
                activeColor: app_color,
                title: Text('Osobno preuzimanje'),
                value: 'preuzimanje',
                groupValue: _deliveryMethod,
                onChanged: (value) {
                  setState(() {
                    _deliveryMethod = value;
                  });
                },
              ),
              SizedBox(height: 24),
              Text(
                'Sažetak narudžbe',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Ukupno proizvoda:'),
                          Text('${cartProvider.itemCount}'),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Ukupna cijena:'),
                          Text(
                            '${cartProvider.totalPrice.toStringAsFixed(2)} KM',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _isLoading
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            if (_paymentMethod == 'kartica') {
                              showPaymentSheet(cartProvider.totalPrice);
                            } else {
                              _placeOrder(context, cartProvider, null);
                            }
                          }
                        },
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          _paymentMethod == 'kartica'
                              ? 'PLATI'
                              : 'POTVRDI NARUDŽBU',
                          style: TextStyle(color: app_color),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
