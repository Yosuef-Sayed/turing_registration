import 'package:go_router/go_router.dart';
import 'package:turing_registration/features/attendees/views/screens/attendees_view.dart';
import 'package:turing_registration/features/home/views/screens/home_view.dart';
import 'package:turing_registration/features/splash/views/screens/splash_view.dart';

abstract class AppRouter {
  static const kHomeView = "/homeView";
  static const kAttendeesView = "/attendeesView";

  static final router = GoRouter(
    routes: [
      GoRoute(path: "/", builder: (context, state) => const SplashView()),
      GoRoute(path: kHomeView, builder: (context, state) => const HomeView()),
      GoRoute(
        path: kAttendeesView,
        builder: (context, state) => const AttendeesView(),
      ),
    ],
  );
}
