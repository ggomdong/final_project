import 'package:final_project/repos/authentication_repo.dart';
import 'package:final_project/views/login_screen.dart';
import 'package:final_project/views/main_navigation_screen.dart';
import 'package:final_project/views/sign_up_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider(
  (ref) {
    return GoRouter(
      initialLocation: "/home",
      redirect: (context, state) {
        final isLoggedIn = ref.read(authRepo).isLoggedIn;
        if (!isLoggedIn) {
          if (state.matchedLocation != SignUpScreen.routeUrl &&
              state.matchedLocation != LoginScreen.routeUrl) {
            return LoginScreen.routeUrl;
          }
        }
        return null;
      },
      routes: [
        GoRoute(
          name: SignUpScreen.routeName,
          path: SignUpScreen.routeUrl,
          builder: (context, state) => const SignUpScreen(),
        ),
        GoRoute(
          name: LoginScreen.routeName,
          path: LoginScreen.routeUrl,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: "/:tab(home|post|calendar)",
          builder: (context, state) {
            final tab = state.pathParameters["tab"] ?? "";
            return MainNavigationScreen(tab: tab);
          },
        ),
      ],
    );
  },
);
