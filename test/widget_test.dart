import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:motoh_client/app.dart';
import 'package:motoh_client/providers/auth_provider.dart';
import 'package:motoh_client/providers/drivers_provider.dart';
import 'package:motoh_client/services/api_client.dart';
import 'package:motoh_client/services/auth_service.dart';
import 'package:motoh_client/services/location_service.dart';
import 'package:motoh_client/services/storage_service.dart';

void main() {
  testWidgets('affiche l’écran de démarrage MotoH', (WidgetTester tester) async {
    final storage = StorageService();
    final api = ApiClient(tokenReader: storage.readToken);
    final authService = AuthService(api);
    final authProvider = AuthProvider(
      authService: authService,
      storageService: storage,
    );

    await tester.pumpWidget(
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

    await tester.pump();
    expect(find.text('MotoH'), findsOneWidget);
  });
}
