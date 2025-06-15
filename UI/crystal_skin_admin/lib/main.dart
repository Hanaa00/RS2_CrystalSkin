import 'dart:io';
import 'package:crystal_skin_admin/providers/appointment_provider.dart';
import 'package:crystal_skin_admin/providers/orders_provider.dart';
import 'package:crystal_skin_admin/providers/reports_provider.dart';
import 'package:crystal_skin_admin/screens/appointments/appointment_list_screen.dart';
import 'package:crystal_skin_admin/screens/employees/employee_list_screen.dart';
import 'package:crystal_skin_admin/screens/order/order_list_screen.dart';
import 'package:crystal_skin_admin/screens/patients/patient_list_screen.dart';
import 'package:crystal_skin_admin/screens/productCategories/productCategory_list_screen.dart';
import 'package:crystal_skin_admin/screens/products/product_list_screen.dart';
import 'package:crystal_skin_admin/screens/reports/report_screen.dart';
import 'package:flutter/material.dart';
import 'package:crystal_skin_admin/providers/cities_provider.dart';
import 'package:crystal_skin_admin/providers/countries_provider.dart';
import 'package:crystal_skin_admin/screens/cities/city_list_screen.dart';
import 'package:crystal_skin_admin/screens/countries/country_list_screen.dart';
import 'package:crystal_skin_admin/screens/home/home_screen.dart';
import 'package:crystal_skin_admin/screens/login/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'helpers/my_http_overrides.dart';

void main() async {
  await dotenv.load(fileName: "assets/.env");
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => CountryProvider()),
          ChangeNotifierProvider(create: (_) => CityProvider()),
          ChangeNotifierProvider(create: (_) => AppointmentProvider()),
          ChangeNotifierProvider(create: (_) => OrderProvider()),
          ChangeNotifierProvider(create: (_) => ReportsProvider()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: const LoginScreen(),
          onGenerateRoute: (settings) {
            if (settings.name == LoginScreen.routeName) {
              return MaterialPageRoute(
                builder: ((context) => const LoginScreen()),
              );
            }
            if (settings.name == HomeScreen.routeName) {
              return MaterialPageRoute(
                builder: ((context) => const HomeScreen()),
              );
            }
            if (settings.name == PatientListScreen.routeName) {
              return MaterialPageRoute(
                builder: ((context) => const PatientListScreen()),
              );
            }
            if (settings.name == EmployeeListScreen.routeName) {
              return MaterialPageRoute(
                builder: ((context) => const EmployeeListScreen()),
              );
            }
            if (settings.name == ProductListScreen.routeName) {
              return MaterialPageRoute(
                builder: ((context) => const ProductListScreen()),
              );
            }
            if (settings.name == OrderListScreen.routeName) {
              return MaterialPageRoute(
                builder: ((context) => const OrderListScreen()),
              );
            }
            if (settings.name == ProductCategoryListScreen.routeName) {
              return MaterialPageRoute(
                builder: ((context) => const ProductCategoryListScreen()),
              );
            }
            if (settings.name == AppointmentListScreen.routeName) {
              return MaterialPageRoute(
                builder: ((context) => const AppointmentListScreen()),
              );
            }
            if (settings.name == ReportScreen.routeName) {
              return MaterialPageRoute(
                builder: ((context) => const ReportScreen()),
              );
            }
            if (settings.name == CountryListScreen.routeName) {
              return MaterialPageRoute(
                builder: ((context) => const CountryListScreen()),
              );
            }
            if (settings.name == CityListScreen.routeName) {
              return MaterialPageRoute(
                builder: ((context) => const CityListScreen()),
              );
            }
            return MaterialPageRoute(
              builder: ((context) => const UnknownScreen()),
            );
          },
        ));
  }
}

class UnknownScreen extends StatelessWidget {
  const UnknownScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Unknown Screen'),
      ),
      body: const Center(
        child: Text('Unknown Screen'),
      ),
    );
  }
}
