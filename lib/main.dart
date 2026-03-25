import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'providers/auth_provider.dart';
import 'providers/drivers_provider.dart';
import 'services/api_client.dart';
import 'services/auth_service.dart';
import 'services/location_service.dart';
import 'services/storage_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = StorageService();
  final api = ApiClient(tokenReader: storage.readToken);
  final authService = AuthService(api);
  final authProvider = AuthProvider(
    authService: authService,
    storageService: storage,
  );

  runApp(
    MultiProvider(
      providers: [
        Provider<StorageService>.value(value: storage),
        Provider<ApiClient>.value(value: api),
        Provider<AuthService>.value(value: authService),
        Provider<LocationService>.value(value: LocationService()),
        ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
        ChangeNotifierProvider<DriversProvider>(create: (_) => DriversProvider()),
      ],
      child: const MotohApp(),
    ),
  );
}
