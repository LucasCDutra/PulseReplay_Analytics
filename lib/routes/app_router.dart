import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/analytics/analytics_page.dart';
import '../features/artists/top_artists_page.dart';
import '../features/dashboard/dashboard_page.dart';
import '../features/history/history_page.dart';
import '../features/insights/insights_page.dart';
import '../features/settings/settings_page.dart';
import '../features/videos/top_videos_page.dart';
import '../widgets/app_shell.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
              path: '/', builder: (context, state) => const DashboardPage()),
          GoRoute(
              path: '/analytics',
              builder: (context, state) => const AnalyticsPage()),
          GoRoute(
              path: '/artists',
              builder: (context, state) => const TopArtistsPage()),
          GoRoute(
              path: '/videos',
              builder: (context, state) => const TopVideosPage()),
          GoRoute(
              path: '/genres',
              builder: (context, state) => const AnalyticsPage(initialTab: 1)),
          GoRoute(
              path: '/timeline',
              builder: (context, state) => const HistoryPage(grouped: true)),
          GoRoute(
              path: '/insights',
              builder: (context, state) => const InsightsPage()),
          GoRoute(
              path: '/trends',
              builder: (context, state) => const AnalyticsPage(initialTab: 2)),
          GoRoute(
              path: '/compare',
              builder: (context, state) => const AnalyticsPage(initialTab: 3)),
          GoRoute(
              path: '/history',
              builder: (context, state) => const HistoryPage()),
          GoRoute(
              path: '/settings',
              builder: (context, state) => const SettingsPage()),
        ],
      ),
    ],
  );
});
