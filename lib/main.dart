import 'package:farmhouse_vendor/provider/auth/login_provider.dart';
import 'package:farmhouse_vendor/provider/farmhouse_provider.dart';
import 'package:farmhouse_vendor/views/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => VendorProvider()),
                ChangeNotifierProvider(create: (_) => FarmhouseProvider())

        ],
      child: MaterialApp(
        title: 'VFARMS VENDOR',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    );
  }
}
