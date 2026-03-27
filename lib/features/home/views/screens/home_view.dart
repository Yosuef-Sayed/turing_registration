import 'package:flutter/material.dart';
import 'package:turing_registration/features/home/views/widgets/home_view_body.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: false,
      body: HomeViewBody(),
    );
  }
}
