import 'package:crystal_skin_mobile/helpers/colors.dart';
import 'package:crystal_skin_mobile/helpers/image_helper.dart';
import 'package:crystal_skin_mobile/models/list_item.dart';
import 'package:crystal_skin_mobile/models/product.dart';
import 'package:crystal_skin_mobile/providers/cart_provider.dart';
import 'package:crystal_skin_mobile/providers/dropdown_provider.dart';
import 'package:crystal_skin_mobile/providers/product_provider.dart';
import 'package:crystal_skin_mobile/screens/cart/cart_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  ProductProvider? _productProvider;
  final DropdownProvider _dropdownProvider = DropdownProvider();

  List<Product> _products = [];
  List<ListItem> _categories = [];
  int? _selectedCategoryId;
  String _searchQuery = '';

  int _page = 1;
  final int _pageSize = 10;
  bool _isLoading = false;
  bool _hasMore = true;

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  final Map<int, int> _cartItems = {};

  @override
  void initState() {
    super.initState();
    _productProvider = context.read<ProductProvider>();
    _loadData();
    _scrollController.addListener(_scrollListener);
  }

  _loadData() async {
    await _loadCategories();
    await _loadProducts();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      _loadProducts();
    }
  }

  Future<void> _loadCategories() async {
    try {
      final items = await _dropdownProvider.getItems('productCategories');
      setState(() {
        _categories = [ListItem(key: 0, value: 'Svi proizvodi'), ...items];
        _selectedCategoryId = 0;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Greška prilikom učitavanja kategorija: ${e.toString()}',
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  Future<void> _loadProducts() async {
    if (_isLoading || !_hasMore) return;

    setState(() => _isLoading = true);

    try {
      var params = {
        'pageNumber': _page.toString(),
        'pageSize': _pageSize.toString(),
      };

      if (_selectedCategoryId != null && _selectedCategoryId != 0) {
        params['categoryId'] = _selectedCategoryId.toString();
      }

      if (_searchQuery.isNotEmpty) {
        params['searchFilter'] = _searchQuery;
      }

      final response = await _productProvider!.getForPagination(params);

      setState(() {
        _products.addAll(response.items);
        _hasMore = response.items.length >= _pageSize;
        _page++;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Greška prilikom učitavanja proizvoda: ${e.toString()}',
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  void _refreshProducts() {
    setState(() {
      _products.clear();
      _page = 1;
      _hasMore = true;
    });
    _loadProducts();
  }

  void _onCategoryChanged(int? value) {
    setState(() {
      _selectedCategoryId = value;
    });
    _refreshProducts();
  }

  void _onSearch(String query) {
    setState(() {
      _searchQuery = query;
    });
    _refreshProducts();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Proizvodi', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CartPage()),
                  );
                },
              ),
              if (cartProvider.itemCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text(
                      cartProvider.itemCount.toString(),
                      style: TextStyle(color: Colors.white, fontSize: 10),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Search Bar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Pretraži proizvode...',
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 14),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear, size: 20),
                              onPressed: () {
                                _searchController.clear();
                                _onSearch('');
                              },
                            )
                          : null,
                    ),
                    onChanged: _onSearch,
                  ),
                ),
                SizedBox(height: 12),
                // Category Dropdown
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: DropdownButton<int>(
                      value: _selectedCategoryId,
                      items: _categories.map((category) {
                        return DropdownMenuItem<int>(
                          value: category.key,
                          child: Text(
                            category.value,
                            style: TextStyle(fontSize: 14),
                          ),
                        );
                      }).toList(),
                      onChanged: _onCategoryChanged,
                      isExpanded: true,
                      underline: SizedBox(),
                      icon: Icon(Icons.arrow_drop_down),
                      style: TextStyle(color: Colors.black87),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          // Product List
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                _refreshProducts();
                return Future.value();
              },
              child: _products.isEmpty && !_isLoading
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 60,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Nema proizvoda za prikaz',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          if (_searchQuery.isNotEmpty ||
                              _selectedCategoryId != 0)
                            TextButton(
                              onPressed: _refreshProducts,
                              child: Text('Prikaži sve proizvode'),
                            ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      itemCount: _products.length + (_hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index >= _products.length) {
                          return _hasMore
                              ? Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : SizedBox();
                        }
                        final product = _products[index];
                        return _buildProductCard(product);
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    CartItem? cartItem;
    try {
      cartItem = cartProvider.items.firstWhere((item) => item.product.id == product.id);
    } catch (e) {
      cartItem = null;
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Navigate to product details
        },
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[100],
                  child: ImageHelper.buildImage(product.imageUrl),
                ),
              ),
              SizedBox(width: 12),
              // Product Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      product.description,
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    Text(
                      '${product.price.toStringAsFixed(2)} KM',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: app_color,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  if (cartItem != null)
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove, size: 20, color: app_color),
                          onPressed: () => cartProvider.removeItem(product),
                        ),
                        Text(cartItem.quantity.toString(), style: TextStyle(color: app_color)),
                        IconButton(
                          icon: Icon(Icons.add, size: 20, color: app_color),
                          onPressed: () => cartProvider.addItem(product),
                        ),
                      ],
                    )
                  else
                    IconButton(
                      icon: Icon(Icons.add_shopping_cart),
                      color: app_color,
                      onPressed: () {
                        cartProvider.addItem(product);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${product.name} dodan u košaru'),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            action: SnackBarAction(
                              label: 'Pogledaj',
                              textColor: Colors.white,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CartPage(),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
              // Cart controls
            ],
          ),
        ),
      ),
    );
  }
}
