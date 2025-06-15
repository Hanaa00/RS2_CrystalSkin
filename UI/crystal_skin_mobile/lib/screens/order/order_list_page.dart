import 'package:crystal_skin_mobile/helpers/colors.dart';
import 'package:crystal_skin_mobile/models/order.dart';
import 'package:crystal_skin_mobile/utils/authorization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crystal_skin_mobile/providers/order_provider.dart';
import 'package:intl/intl.dart';

class OrderListPage extends StatefulWidget {
  const OrderListPage({Key? key}) : super(key: key);

  @override
  _OrderListPageState createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Order> _orders = [];
  String _statusFilter = 'Sve';
  final List<String> _statusOptions = [
    'Sve',
    'Na čekanju',
    'Poslano',
    'Isporučeno',
    'Otkazano'
  ];
  int _currentPage = 1;
  int _pageSize = 10;
  bool _isLoading = false;
  bool _hasMore = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_refreshOrders);
    _scrollController.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadInitialOrders());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset >=
        _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      if (!_isLoading && _hasMore) {
        _loadMoreOrders();
      }
    }
  }

  Future<void> _loadInitialOrders() async {
    setState(() {
      _currentPage = 1;
      _hasMore = true;
    });
    await _fetchOrders(reset: true);
  }

  Future<void> _loadMoreOrders() async {
    if (_isLoading || !_hasMore) return;
    setState(() {
      _currentPage++;
    });
    await _fetchOrders();
  }

  Future<void> _refreshOrders() async {
    setState(() {
      _currentPage = 1;
      _hasMore = true;
    });
    await _fetchOrders(reset: true);
  }

  Future<void> _fetchOrders({bool reset = false}) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      final params = {
        'pageNumber': _currentPage.toString(),
        'pageSize': _pageSize.toString(),
        'userId': Authorization.id.toString()
      };

      if (_statusFilter != 'Sve') {
        params['status'] = (_statusOptions.indexOf(_statusFilter) - 1).toString();
      }

      if (_searchController.text.isNotEmpty) {
        params['searchFilter'] = _searchController.text;
      }

      final response = await orderProvider.getForPagination(params);
      final newOrders = response.items;

      setState(() {
        if (newOrders.length < _pageSize) {
          _hasMore = false;
        }
        if (reset) {
          _orders = newOrders;
        } else {
          _orders.addAll(newOrders);
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading orders: ${e.toString()}'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  String _getStatusText(int? status) {
    switch (status) {
      case 0:
        return 'Na čekanju';
      case 1:
        return 'Prihvaćeno';
      case 2:
        return 'Realizovano';
      case 3:
        return 'Otkazano';
      default:
        return 'N/A';
    }
  }

  Color _getStatusColor(int? status) {
    switch (status) {
      case 0:
        return Colors.orange;
      case 1:
        return Colors.blue;
      case 2:
        return Colors.green;
      case 3:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Future<void> _cancelOrder(Order order) async {
    try {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Otkazivanje narudžbe'),
          content: const Text('Da li ste sigurni da želite otkazati ovu narudžbu?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Ne'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Da', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );

      if (confirmed != true) return;

      setState(() => _isLoading = true);
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      var result = await orderProvider.cancelOrder(order.id!);

      if (result){
        setState(() {
          final index = _orders.indexOf(order);
          _orders[index].status = 3;
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Narudžba je uspješno otkazana.'),
            backgroundColor: Colors.green.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ova narudžba se ne može otkazati.'),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Greška prilikom otkazivanja narudžbe: ${e.toString()}'),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      //appBar: AppBar(
      //  title: const Text('My Orders'),
      //  centerTitle: true,
      //  actions: [
      //    IconButton(
      //      icon: const Icon(Icons.refresh),
      //      onPressed: _refreshOrders,
      //      tooltip: 'Refresh',
      //    ),
      //  ],
      //  elevation: 0,
      //),
      body: Column(
        children: [
          // Search and Filter Section
          Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[900] : Colors.grey[50],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Column(
              children: [
                // Search Field
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Pretraga narudžbi',
                    hintText: '...broj narudžbe, naziv proizvoda...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  ),
                ),
                const SizedBox(height: 12),
                // Filter Row
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: isDarkMode ? Colors.grey[800] : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _statusFilter,
                            isExpanded: true,
                            items: _statusOptions.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _statusFilter = newValue!;
                              });
                              _refreshOrders();
                            },
                            style: theme.textTheme.bodyMedium,
                            dropdownColor: isDarkMode ? Colors.grey[800] : Colors.white,
                            icon: const Icon(Icons.arrow_drop_down),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Order List
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshOrders,
              color: theme.primaryColor,
              child: _orders.isEmpty && !_isLoading
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.receipt_long,
                      size: 64,
                      color: theme.disabledColor,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Nisu pronađene narudžbe',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.disabledColor,
                      ),
                    ),
                    if (_statusFilter != 'Sve')
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'Pokušajte promijeniti filtere',
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                  ],
                ),
              )
                  : ListView.builder(
                controller: _scrollController,
                itemCount: _orders.length + (_hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= _orders.length) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  final order = _orders[index];
                  final dateFormat = DateFormat('MMM dd, yyyy');
                  final timeFormat = DateFormat('hh:mm a');

                  final canCancel = order.status == 0;


                  return Container(
                    margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {

                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Narudžba #${order.id}',
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: _getStatusColor(order.status)
                                          .withOpacity(0.2),
                                      borderRadius:
                                      BorderRadius.circular(16),
                                    ),
                                    child: Text(
                                      _getStatusText(order.status),
                                      style: theme.textTheme.labelSmall
                                          ?.copyWith(
                                        color: _getStatusColor(
                                            order.status),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              // Customer Info
                              Text(
                                order.fullName ?? 'No name',
                                style: theme.textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 12),
                              // Order Summary
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Datum',
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(
                                          color: theme.hintColor,
                                        ),
                                      ),
                                      Text(
                                        dateFormat.format(
                                            order.date?.toLocal() ??
                                                DateTime.now()),
                                        style: theme.textTheme.bodyMedium,
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Proizvoda',
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(
                                          color: theme.hintColor,
                                        ),
                                      ),
                                      Text(
                                        '${order.items.length}',
                                        style: theme.textTheme.bodyMedium,
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        'Ukupno',
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(
                                          color: theme.hintColor,
                                        ),
                                      ),
                                      Text(
                                        '${order.totalAmount.toStringAsFixed(2)} KM',
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              // Expansion Tile
                              Theme(
                                data: theme.copyWith(
                                  dividerColor: Colors.transparent,
                                ),
                                child: ExpansionTile(
                                  tilePadding: EdgeInsets.zero,
                                  childrenPadding: EdgeInsets.zero,
                                  title: Text(
                                    'Pogledaj detalje',
                                    style: theme.textTheme.labelLarge
                                        ?.copyWith(
                                      color: app_color,
                                    ),
                                  ),
                                  trailing: const SizedBox(),
                                  children: [
                                    const Divider(height: 16),
                                    // Order Details
                                    _buildDetailItem(
                                      icon: Icons.payment,
                                      title: 'Plaćanje',
                                      value: order.paymentMethod ?? 'N/A',
                                    ),
                                    _buildDetailItem(
                                      icon: Icons.local_shipping,
                                      title: 'Način isporuke',
                                      value: order.deliveryMethod ?? 'N/A',
                                    ),
                                    _buildDetailItem(
                                      icon: Icons.location_on,
                                      title: 'Adresa',
                                      value: order.address ?? 'N/A',
                                    ),
                                    _buildDetailItem(
                                      icon: Icons.phone,
                                      title: 'Broj telefona',
                                      value: order.phoneNumber ?? 'N/A',
                                    ),
                                    if (order.note != null &&
                                        order.note!.isNotEmpty)
                                      _buildDetailItem(
                                        icon: Icons.note,
                                        title: 'Napomena',
                                        value: order.note!,
                                      ),
                                    const Divider(height: 16),
                                    // Order Items
                                    Text(
                                      'Proizvodi',
                                      style: theme.textTheme.titleSmall
                                          ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    ...order.items.map((item) => Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 8),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 4,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: app_color,
                                              borderRadius:
                                              BorderRadius.circular(
                                                  2),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .start,
                                              children: [
                                                Text(
                                                  '${item.product!.name}',
                                                  style: theme
                                                      .textTheme
                                                      .bodyMedium,
                                                ),
                                                Text(
                                                  '${item.quantity} × ${item.unitPrice.toStringAsFixed(2)} KM',
                                                  style: theme
                                                      .textTheme
                                                      .bodySmall
                                                      ?.copyWith(
                                                    color:
                                                    theme.hintColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            '${item.totalPrice.toStringAsFixed(2)} KM',
                                            style: theme.textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                              fontWeight:
                                              FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                                  ],
                                ),
                              ),
                              if (canCancel) ...[
                                Divider(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    OutlinedButton(
                                      onPressed: () => _cancelOrder(order),
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(color: Colors.red.shade300),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                      ),
                                      child: Text(
                                        'Otkaži',
                                        style: TextStyle(color: Colors.red.shade600),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: theme.hintColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.hintColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}