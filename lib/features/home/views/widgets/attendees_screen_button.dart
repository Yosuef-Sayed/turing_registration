// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:turing_registration/core/navigation/config/app_router.dart';
import 'package:turing_registration/features/attendees/view_models/attendees_vm.dart';

class AttendeesScreenButton extends StatelessWidget {
  const AttendeesScreenButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        context.push(AppRouter.kAttendeesView);
      },
      child: Consumer<AttendeesVM>(
        builder: (context, vm, _) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.12)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.groups_rounded, color: Colors.white),
              const SizedBox(width: 10),
              Text(
                'Attendees checked in: ${vm.attendees.length}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
