import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'routes/app_router.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const ProviderScope(child: PulseReplayApp()));
}

class PulseReplayApp extends ConsumerWidget {
  const PulseReplayApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Pulse Replay Analytics',
      theme: AppTheme.dark(GoogleFonts.interTextTheme()),
      routerConfig: router,
      builder: (context, child) {
        return ResponsiveBreakpoints.builder(
          child: child!,
          breakpoints: const [
            Breakpoint(start: 0, end: 480, name: MOBILE),
            Breakpoint(start: 481, end: 900, name: TABLET),
            Breakpoint(start: 901, end: 1400, name: DESKTOP),
            Breakpoint(start: 1401, end: double.infinity, name: '4K'),
          ],
        );
      },
    );
  }
}
