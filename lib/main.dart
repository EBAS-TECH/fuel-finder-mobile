import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuel_finder/core/injection_container.dart';
import 'package:fuel_finder/core/themes/app_theme.dart';
import 'package:fuel_finder/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fuel_finder/features/map/presentation/bloc/geolocation_bloc.dart';
import 'package:fuel_finder/features/onboarding/onboarding_page.dart';
import 'package:fuel_finder/features/route/presentation/bloc/route_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Permission.locationWhenInUse.request();
  setUpDependencies();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  static final RouteObserver<PageRoute> routeObserver =
      RouteObserver<PageRoute>();
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<AuthBloc>()),
        BlocProvider(create: (_) => sl<GeolocationBloc>()),
        BlocProvider(create: (_) => sl<RouteBloc>()),
      ],
      child: MaterialApp(
        title: 'Fuel Finder',
        theme: AppTheme.lightThemeMode,
        darkTheme: AppTheme.darkThemeMode,
        themeMode: ThemeMode.system,
        home: const OnboardingPage(),
        navigatorObservers: [routeObserver],
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

