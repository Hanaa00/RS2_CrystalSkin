import 'package:crystal_skin_mobile/helpers/constants.dart';
import 'package:crystal_skin_mobile/providers/base_provider.dart';
import 'package:crystal_skin_mobile/screens/home/home_screen.dart';
import 'package:crystal_skin_mobile/screens/registration/registration_screen.dart';
import 'package:crystal_skin_mobile/signalr/notification_handler.dart';
import 'package:crystal_skin_mobile/signalr/signalr_service.dart';
import 'package:crystal_skin_mobile/utils/authorization.dart';
import 'package:flutter/material.dart';
import 'package:crystal_skin_mobile/providers/login_provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../models/auth_request.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const String routeName = "login";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _errorMessage;
  bool _isLoading = false;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        bool result = await LoginProvider.login(AuthRequest(_usernameController.text, _passwordController.text));

        if (result) {
          final plugin = FlutterLocalNotificationsPlugin();
          final handler = NotificationHandler(plugin);
          await handler.initialize();

          final signalRService = SignalRService('${Constants.apiUrl}/hubs/notifications');
          await signalRService.startConnection(Authorization.token!);

          await signalRService.joinGroup('user_${Authorization.id}');

          signalRService.registerNotificationHandler((notification) async {
            await handler.showNotification(notification);
          });

          Navigator.popAndPushNamed(context, HomePage.routeName);
        } else {
          setState(() {
            _errorMessage = "Korisničko ime ili lozinka su pogrešni";
          });
        }
      } catch (e) {
        setState(() {
          _errorMessage = "Došlo je do greške prilikom prijave";
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE0F7FA), Color(0xFFB2EBF2)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              width: 400,
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Image.asset("assets/images/logo.png", height: 80),
                      const SizedBox(height: 16.0),
                      const Text(
                        "Crystal Skin",
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF00695C),
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      if (_errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: "Korisničko ime",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          prefixIcon: const Icon(Icons.person),
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Unesite korisničko ime'
                            : null,
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Lozinka",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          prefixIcon: const Icon(Icons.lock),
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Unesite lozinku'
                            : null,
                      ),
                      const SizedBox(height: 16.0),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00796B),
                            padding: const EdgeInsets.symmetric(vertical: 14.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          onPressed: _isLoading ? null : _login,
                          child: _isLoading
                              ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                              : const Text(
                            'Prijavi se',
                            style: TextStyle(color: Colors.white, fontSize: 16.0),
                          ),
                        ),
                      ),
                      //Align(
                      //  alignment: Alignment.centerRight,
                      //  child: TextButton(
                      //    onPressed: () {
//
                      //    },
                      //    child: const Text(
                      //      'Zaboravili ste lozinku?',
                      //      style: TextStyle(color: Color(0xFF00796B)),
                      //    ),
                      //  ),
                      //),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Nemate račun?"),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, RegistrationScreen.routeName);
                            },
                            child: const Text(
                              'Registrujte se',
                              style: TextStyle(
                                color: Color(0xFF00796B),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}