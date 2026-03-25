import 'package:flutter/material.dart';

import 'models/driver_info.dart';
import 'screens/auth/otp_screen.dart';
import 'screens/auth/phone_screen.dart';
import 'screens/driver_detail/driver_detail_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

class MotohApp extends StatelessWidget {
  const MotohApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MotoH',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName: (_) => const SplashScreen(),
        OnboardingScreen.routeName: (_) => const OnboardingScreen(),
        PhoneScreen.routeName: (_) => const PhoneScreen(),
        OtpScreen.routeName: (context) {
          final args = ModalRoute.of(context)!.settings.arguments;
          final a = args as OtpRouteArgs;
          return OtpScreen(userId: a.userId, phoneDisplay: a.phoneDisplay);
        },
        HomeScreen.routeName: (_) => const HomeScreen(),
        DriverDetailScreen.routeName: (context) {
          final d = ModalRoute.of(context)!.settings.arguments as DriverInfo;
          return DriverDetailScreen(driver: d);
        },
      },
    );
  }
}
