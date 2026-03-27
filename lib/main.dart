import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:turing_registration/core/navigation/config/app_router.dart';
import 'package:turing_registration/core/utils/themes/themes.dart';
import 'package:turing_registration/features/attendees/view_models/attendees_vm.dart';
import 'package:turing_registration/features/home/view_models/ticket_scanner_vm.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final attendeesVM = AttendeesVM();
  await attendeesVM.loadFromPrefs();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AttendeesVM>.value(value: attendeesVM),
        ChangeNotifierProxyProvider<AttendeesVM, TicketScannerVM>(
          create: (context) =>
              TicketScannerVM(http.Client(), context.read<AttendeesVM>()),
          update: (context, vm, previous) =>
              previous ?? TicketScannerVM(http.Client(), vm),
        ),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      routerConfig: AppRouter.router,
    );
  }
}
