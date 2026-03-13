import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'screens/permission_setup_screen.dart';
import 'screens/home_screen.dart';
import 'services/background_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await BackgroundService.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Abdul AI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder<bool>(
        future: _checkPermissions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          final hasPermissions = snapshot.data ?? false;
          return hasPermissions ? const HomeScreen() : const PermissionSetupScreen();
        },
      ),
    );
  }

  Future<bool> _checkPermissions() async {
    final phonePermission = await Permission.phone.status;
    final overlayPermission = await Permission.systemAlertWindow.status;
    final bootPermission = await Permission.ignoreBatteryOptimizations.status;

    return phonePermission.isGranted &&
           overlayPermission.isGranted &&
           bootPermission.isGranted;
  }
}
