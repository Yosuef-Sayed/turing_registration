import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:turing_registration/core/navigation/config/app_router.dart';
import 'package:turing_registration/features/splash/views/widgets/splash_view_body.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    homeNavigator();
  }

  @override
  Widget build(BuildContext context) {
    return const SplashViewBody();
  }

  void homeNavigator() {
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      context.pushReplacement(AppRouter.kHomeView);
    });
  }
}
