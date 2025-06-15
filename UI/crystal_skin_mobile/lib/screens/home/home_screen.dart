import 'package:crystal_skin_mobile/helpers/colors.dart';
import 'package:crystal_skin_mobile/helpers/image_helper.dart';
import 'package:crystal_skin_mobile/models/product.dart';
import 'package:crystal_skin_mobile/providers/cart_provider.dart';
import 'package:crystal_skin_mobile/providers/login_provider.dart';
import 'package:crystal_skin_mobile/providers/recommender_provider.dart';
import 'package:crystal_skin_mobile/screens/appointment/appointment_list_page.dart';
import 'package:crystal_skin_mobile/screens/appointment/appointment_page.dart';
import 'package:crystal_skin_mobile/screens/cart/cart_page.dart';
import 'package:crystal_skin_mobile/screens/login/login_screen.dart';
import 'package:crystal_skin_mobile/screens/medical-record/medical_record_page.dart';
import 'package:crystal_skin_mobile/screens/notification/notification_list_page.dart';
import 'package:crystal_skin_mobile/screens/order/order_list_page.dart';
import 'package:crystal_skin_mobile/screens/product/product_list_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';

import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static const String routeName = "home";

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  Timer? _timer;
  final PageController _pageController = PageController();
  List<Product> _recommendations = [];
  bool _isRecommendationsLoading = false;

  Future<void> _loadRecommendations() async {
    if (_isRecommendationsLoading) return;

    setState(() => _isRecommendationsLoading = true);

    try {
      final recommendationsProvider = Provider.of<RecommenderProvider>(context, listen: false);
      final results = await recommendationsProvider.getRecommendations();

      if (mounted) {
        setState(() => _recommendations = results);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Greška prilikom učitavanja preporučenih proizvoda: ${e.toString()}")),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isRecommendationsLoading = false);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadRecommendations());
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 6), (timer) {
      if (_pageController.hasClients) {
        final currentPage = _pageController.page?.round() ?? 0;
        final nextPage = currentPage + 1 >= _recommendations.length ? 0 : currentPage + 1;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final theme = Theme.of(context);

    final List<Widget> _pages = [
      MainDashboard(
          recommendations: _recommendations,
          isLoading: _isRecommendationsLoading,
          onRefresh: _loadRecommendations,
          pageController: _pageController
      ),
      AppointmentListPage(),
      OrderListPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Crystal Skin',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onPrimary,
            ),
          ),
        ),
        leading: Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
                icon: Icon(Icons.shopping_cart, color: theme.colorScheme.onPrimary),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CartPage()))),
            if (cartProvider.itemCount > 0)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    cartProvider.itemCount.toString(),
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: theme.colorScheme.onPrimary),
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
        backgroundColor: app_color,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: _buildBottomNavBar(theme),
    );
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Potvrda odjave', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text('Da li ste sigurni da se želite odjaviti?'),
        actions: [
          TextButton(
            child: Text('Odustani'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: Text('Odjavi se', style: TextStyle(color: Colors.red)),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );

    if (confirmed == true) {
      Navigator.popAndPushNamed(context, LoginScreen.routeName);
    }
  }

  BottomNavigationBar _buildBottomNavBar(ThemeData theme) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: app_color,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      elevation: 8,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Početna',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today_outlined),
          activeIcon: Icon(Icons.calendar_today),
          label: 'Termini',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_bag_outlined),
          activeIcon: Icon(Icons.shopping_bag),
          label: 'Narudžbe',
        ),
      ],
      onTap: (index) => setState(() => _currentIndex = index),
    );
  }
}

class MainDashboard extends StatelessWidget {
  final List<Product> recommendations;
  final bool isLoading;
  final VoidCallback onRefresh;
  final PageController pageController;

  const MainDashboard({
    super.key,
    required this.recommendations,
    required this.isLoading,
    required this.onRefresh,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeHeader(context),
            const SizedBox(height: 20),
            _buildQuickLinksGrid(context),
            const SizedBox(height: 20),
            _buildRecommendationsSection(theme),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dobrodošli,',
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey[600],
          ),
        ),
        Text(
          '${LoginProvider.authResponse?.firstName ?? ''}',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: app_color,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickLinksGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _buildQuickLink(
          icon: FontAwesomeIcons.calendarCheck,
          title: 'Zakaži termin',
          color: Colors.blueAccent,
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AppointmentPage())),
        ),
        _buildQuickLink(
            icon: FontAwesomeIcons.shoppingBag,
            title: 'Proizvodi',
            color: Colors.greenAccent,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProductListPage()))),
        _buildQuickLink(
            icon: FontAwesomeIcons.fileMedical,
            title: 'Zdravstveni karton',
            color: Colors.orangeAccent,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MedicalRecordPage()))),
        _buildQuickLink(
          icon: FontAwesomeIcons.bell,
          title: 'Notifikacije',
          color: Colors.purpleAccent,
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationListPage())),
        ),
      ],
    );
  }

  Widget _buildRecommendationsSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Preporučeni proizvodi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: app_color,
              ),
            ),
            IconButton(
              icon: Icon(Icons.refresh, color: app_color),
              onPressed: onRefresh,
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 220,
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : recommendations.isEmpty
              ? Center(
            child: Text(
              'Nema preporučenih proizvoda',
              style: TextStyle(color: Colors.grey),
            ),
          )
              : PageView.builder(
            controller: pageController,
            scrollDirection: Axis.horizontal,
            itemCount: recommendations.length,
            itemBuilder: (context, index) {
              final product = recommendations[index];
              return ProductCard(
                name: product.name,
                price: '${product.price} KM',
                imageUrl: product.imageUrl ?? 'assets/images/logo.png',
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildQuickLink({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color.withOpacity(0.1), color.withOpacity(0.3)],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: FaIcon(icon, size: 24, color: color),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String name;
  final String price;
  final String imageUrl;

  const ProductCard({
    super.key,
    required this.name,
    required this.price,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: ImageHelper.buildImage(
              imageUrl,
              height: 140,
              width: double.infinity,
              //fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  price,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
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