// FILE: lib/routes.dart

import 'package:cargo_nomade/layout.dart';
import 'package:cargo_nomade/providers/auth_provider.dart';
import 'package:cargo_nomade/screens/find_trip_screen.dart';
import 'package:cargo_nomade/providers/user_provider.dart';
import 'package:cargo_nomade/screens/home_screen.dart';
import 'package:cargo_nomade/screens/loading_screen.dart';
import 'package:cargo_nomade/screens/propose_trip_screen.dart';
import 'package:cargo_nomade/screens/register_screen.dart';
import 'package:cargo_nomade/screens/welcome_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

// Le router devient une fonction qui construit le GoRouter
GoRouter buildGoRouter(BuildContext context) {
  // On récupère l'instance du UserProvider
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
  return GoRouter(
    // On passe le provider comme Listenable. C'est la clé !
    refreshListenable: userProvider,

    // On commence par /loading puisque UserProvider commence par isLoading = true
    initialLocation: '/',

    routes: [
      ShellRoute(
        builder: (context,state, child){

          if (state.matchedLocation == "/" || state.matchedLocation == "/register") {
            return child;
          }
          return ScaffoldWithBottomNav(content: child);
        },
          routes: [
        GoRoute(
          path: '/loading',
          builder: (context, _) => const LoadingScreenLottie(),
        ),
        GoRoute(path: '/', builder: (context, _) => const WelcomeScreen()),
        GoRoute(
          path: '/register',
          builder: (context, _) => const RegisterScreen(),
        ),
        GoRoute(path: '/home', builder: (context, _) => const HomeScreen()),
        GoRoute(
          path: '/propose-trip',
          builder: (context, _) => const ProposeTripScreen(),
        ),
        GoRoute(
          path: '/find-trip',
          builder: (context, _) => const FindTripScreen(),
        ),
      ]),

    ],


  );
}
