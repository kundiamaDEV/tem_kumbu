import 'package:flutter/material.dart';

import '../features/all_atms/all_atms_screen.dart';
import '../features/atm_details/atm_details_screen.dart';
import '../features/contact/contact_screen.dart';
import '../features/help/help_screen.dart';
import '../features/map_view/atm_map_screen.dart';
import '../features/nearby_atms/nearby_atms_screen.dart';
import '../features/route_view/route_screen.dart';
import '../features/search/search_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/splash/splash_screen.dart';
import '../features/support/support_screen.dart';

class AppRoutes {
  static const splash = '/';
  static const search = '/search';
  static const nearbyAtms = '/nearby-atms';
  static const allAtms = '/all-atms';
  static const atmDetails = '/atm-details';
  static const atmMap = '/atm-map';
  static const routeView = '/route-view';
  static const help = '/help';
  static const support = '/support';
  static const settings = '/settings';
  static const contact = '/contact';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case AppRoutes.search:
        return MaterialPageRoute(builder: (_) => const SearchScreen());

      case AppRoutes.nearbyAtms:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const NearbyAtmsScreen(),
        );

      case AppRoutes.allAtms:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const AllAtmsScreen(),
        );
      
      case AppRoutes.atmDetails:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const AtmDetailsScreen(),
        );

      case AppRoutes.atmMap:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const AtmMapScreen(),
        );
        
      case AppRoutes.routeView:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const RouteScreen(),
        );

      case AppRoutes.help:
        return MaterialPageRoute(builder: (_) => const HelpScreen());

      case AppRoutes.support:
        return MaterialPageRoute(builder: (_) => const SupportScreen());

      case AppRoutes.settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());

      case AppRoutes.contact:
        return MaterialPageRoute(builder: (_) => const ContactScreen());

      default:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
    }
  }
}