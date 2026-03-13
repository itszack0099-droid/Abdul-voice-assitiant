import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'home_screen.dart';

class PermissionSetupScreen extends StatefulWidget {
  const PermissionSetupScreen({super.key});

  @override
  State<PermissionSetupScreen> createState() => _PermissionSetupScreenState();
}

class _PermissionSetupScreenState extends State<PermissionSetupScreen> {
  bool _phonePermission = false;
  bool _overlayPermission = false;
  bool _bootPermission = false;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    final phone = await Permission.phone.status;
    final overlay = await Permission.systemAlertWindow.status;
    final boot = await Permission.ignoreBatteryOptimizations.status;

    setState(() {
      _phonePermission = phone.isGranted;
      _overlayPermission = overlay.isGranted;
      _bootPermission = boot.isGranted;
    });
  }

  Future<void> _requestPhonePermission() async {
    final status = await Permission.phone.request();
    setState(() {
      _phonePermission = status.isGranted;
    });
  }

  Future<void> _requestOverlayPermission() async {
    final status = await Permission.systemAlertWindow.request();
    setState(() {
      _overlayPermission = status.isGranted;
    });
  }

  Future<void> _requestBootPermission() async {
    final status = await Permission.ignoreBatteryOptimizations.request();
    setState(() {
      _bootPermission = status.isGranted;
    });
  }

  bool get _allPermissionsGranted {
    return _phonePermission && _overlayPermission && _bootPermission;
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setup Permissions'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Abdul AI needs the following permissions to function properly:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            _buildPermissionCard(
              title: 'Phone Permission',
              description: 'To detect incoming calls and provide caller information',
              isGranted: _phonePermission,
              onRequest: _requestPhonePermission,
              icon: Icons.phone,
            ),
            const SizedBox(height: 16),
            _buildPermissionCard(
              title: 'Overlay Permission',
              description: 'To display caller information on top of other apps',
              isGranted: _overlayPermission,
              onRequest: _requestOverlayPermission,
              icon: Icons.layers,
            ),
            const SizedBox(height: 16),
            _buildPermissionCard(
              title: 'Background Service',
              description: 'To run continuously and detect calls',
              isGranted: _bootPermission,
              onRequest: _requestBootPermission,
              icon: Icons.power_settings_new,
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _allPermissionsGranted ? _navigateToHome : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'Continue',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionCard({
    required String title,
    required String description,
    required bool isGranted,
    required VoidCallback onRequest,
    required IconData icon,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 32, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Icon(
                  isGranted ? Icons.check_circle : Icons.cancel,
                  color: isGranted ? Colors.green : Colors.red,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 12),
            if (!isGranted)
              ElevatedButton(
                onPressed: onRequest,
                child: const Text('Grant Permission'),
              ),
          ],
        ),
      ),
    );
  }
}
