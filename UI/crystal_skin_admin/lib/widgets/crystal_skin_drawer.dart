import 'package:crystal_skin_admin/screens/appointments/appointment_list_screen.dart';
import 'package:crystal_skin_admin/screens/order/order_list_screen.dart';
import 'package:crystal_skin_admin/screens/patients/patient_list_screen.dart';
import 'package:crystal_skin_admin/screens/reports/report_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/login_provider.dart';
import '../screens/cities/city_list_screen.dart';
import '../screens/countries/country_list_screen.dart';
import '../screens/employees/employee_list_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/login/login_screen.dart';
import '../screens/productCategories/productCategory_list_screen.dart';
import '../screens/products/product_list_screen.dart';

class CrystalSkinDrawer extends StatefulWidget {
  const CrystalSkinDrawer({super.key});

  @override
  _CrystalSkinDrawerState createState() => _CrystalSkinDrawerState();
}

class _CrystalSkinDrawerState extends State<CrystalSkinDrawer> {
  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name;

    return Drawer(
      backgroundColor: Colors.white,
      elevation: 5,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(right: Radius.circular(20))),
      child: Column(
        children: [
          UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Colors.teal[700],
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20),
                ),
              ),
              accountName: null,
              accountEmail: null,
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.medical_services,
                  size: 40,
                  color: Colors.teal,
                ),
              )),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildNavItem(
                  context,
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home_filled,
                  label: "Početna",
                  routeName: HomeScreen.routeName,
                  currentRoute: currentRoute,
                  route: const HomeScreen(),
                ),
                _buildNavItem(
                  context,
                  icon: Icons.people_outline,
                  activeIcon: Icons.people,
                  label: "Pacijenti",
                  routeName: PatientListScreen.routeName,
                  currentRoute: currentRoute,
                  route: const PatientListScreen(),
                ),
                _buildNavItem(
                  context,
                  icon: Icons.badge_outlined,
                  activeIcon: Icons.badge,
                  label: "Uposlenici",
                  routeName: PatientListScreen.routeName,
                  currentRoute: currentRoute,
                  route: const EmployeeListScreen(),
                ),
                _buildNavItem(
                  context,
                  icon: Icons.shopping_bag_outlined,
                  activeIcon: Icons.shopping_bag,
                  label: "Kategorije proizvoda",
                  routeName: ProductListScreen.routeName,
                  currentRoute: currentRoute,
                  route: const ProductCategoryListScreen(),
                ),
                _buildNavItem(
                  context,
                  icon: Icons.shopping_bag_outlined,
                  activeIcon: Icons.shopping_bag,
                  label: "Proizvodi",
                  routeName: ProductListScreen.routeName,
                  currentRoute: currentRoute,
                  route: const ProductListScreen(),
                ),
                _buildNavItem(
                  context,
                  icon: Icons.delivery_dining,
                  activeIcon: Icons.shopping_bag,
                  label: "Narudžbe",
                  routeName: OrderListScreen.routeName,
                  currentRoute: currentRoute,
                  route: const OrderListScreen(),
                ),
                _buildNavItem(
                  context,
                  icon: Icons.calendar_today_outlined,
                  activeIcon: Icons.calendar_today,
                  label: "Termini",
                  routeName: AppointmentListScreen.routeName,
                  currentRoute: currentRoute,
                  route: const AppointmentListScreen(),
                ),
                _buildNavItem(
                  context,
                  icon: Icons.assessment_outlined,
                  activeIcon: Icons.assessment,
                  label: "Izvještaji",
                  routeName: ReportScreen.routeName,
                  currentRoute: currentRoute,
                  route: const ReportScreen(),
                ),
                const Divider(indent: 20, endIndent: 20, height: 30),
                _buildNavItem(
                  context,
                  icon: Icons.public_outlined,
                  activeIcon: Icons.public,
                  label: "Države",
                  routeName: CountryListScreen.routeName,
                  currentRoute: currentRoute,
                  route: const CountryListScreen(),
                ),
                _buildNavItem(
                  context,
                  icon: Icons.location_city_outlined,
                  activeIcon: Icons.location_city,
                  label: "Gradovi",
                  routeName: CityListScreen.routeName,
                  currentRoute: currentRoute,
                  route: const CityListScreen(),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: Text(
                "Odjava",
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
              onTap: () {
                LoginProvider.setResponseFalse();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required String routeName,
    required String? currentRoute,
    required Widget route,
  }) {
    final isSelected = currentRoute == routeName;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? Colors.teal[50] : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(
          isSelected ? activeIcon : icon,
          color: isSelected ? Colors.teal[700] : Colors.grey[700],
        ),
        title: Text(
          label,
          style: GoogleFonts.montserrat(
            fontSize: 15,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? Colors.teal[700] : Colors.grey[700],
          ),
        ),
        onTap: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => route),
          );
        },
      ),
    );
  }
}
