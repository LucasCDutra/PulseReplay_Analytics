import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_theme.dart';
import 'global_search.dart';

class AppShell extends StatefulWidget {
  const AppShell({required this.child, super.key});
  final Widget child;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  bool collapsed = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 860;

    return Scaffold(
      drawer: isMobile
          ? Drawer(
              backgroundColor: AppTheme.panel,
              child: _Sidebar(collapsed: false))
          : null,
      body: Stack(
        children: [
          const _AuroraBackground(),
          Row(
            children: [
              if (!isMobile)
                AnimatedContainer(
                  duration: 280.ms,
                  width: collapsed ? 86 : 274,
                  child: _Sidebar(
                    collapsed: collapsed,
                    onToggle: () => setState(() => collapsed = !collapsed),
                  ),
                ),
              Expanded(
                child: Column(
                  children: [
                    _TopBar(isMobile: isMobile),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(
                            isMobile ? 16 : 30, 8, isMobile ? 16 : 30, 30),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1480),
                          child: widget.child
                              .animate()
                              .fadeIn(duration: 360.ms)
                              .slideY(begin: .02, end: 0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.isMobile});
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding:
            EdgeInsets.fromLTRB(isMobile ? 8 : 30, 16, isMobile ? 16 : 30, 10),
        child: Row(
          children: [
            if (isMobile)
              IconButton(
                icon: const Icon(Icons.menu_rounded),
                onPressed: () => Scaffold.of(context).openDrawer(),
                tooltip: 'Menu',
              ),
            const Expanded(child: GlobalSearch()),
            const SizedBox(width: 12),
            IconButton.filledTonal(
                onPressed: () {},
                icon: const Icon(Icons.notifications_none_rounded),
                tooltip: 'Alerts'),
          ],
        ),
      ),
    );
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar({required this.collapsed, this.onToggle});
  final bool collapsed;
  final VoidCallback? onToggle;

  static const items = [
    ('Dashboard', Icons.grid_view_rounded, '/'),
    ('Analytics', Icons.query_stats_rounded, '/analytics'),
    ('Top Artists', Icons.mic_external_on_rounded, '/artists'),
    ('Top Videos', Icons.play_circle_outline_rounded, '/videos'),
    ('Genres', Icons.graphic_eq_rounded, '/genres'),
    ('Timeline', Icons.timeline_rounded, '/timeline'),
    ('Insights', Icons.auto_awesome_rounded, '/insights'),
    ('Trends', Icons.trending_up_rounded, '/trends'),
    ('Compare', Icons.compare_arrows_rounded, '/compare'),
    ('History Explorer', Icons.manage_search_rounded, '/history'),
    ('Settings', Icons.tune_rounded, '/settings'),
  ];

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    return Container(
      margin: const EdgeInsets.all(14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.panel.withOpacity(.72),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(.09)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient:
                      LinearGradient(colors: [AppTheme.violet, AppTheme.cyan]),
                ),
                child: const Icon(Icons.equalizer_rounded),
              ),
              if (!collapsed) ...[
                const SizedBox(width: 12),
                const Expanded(
                  child: Text('Pulse Replay',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
                ),
              ],
              if (onToggle != null)
                IconButton(
                  onPressed: onToggle,
                  icon: Icon(collapsed
                      ? Icons.keyboard_double_arrow_right_rounded
                      : Icons.keyboard_double_arrow_left_rounded),
                  tooltip: 'Collapse',
                ),
            ],
          ),
          const SizedBox(height: 18),
          Expanded(
            child: ListView.separated(
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 4),
              itemBuilder: (context, index) {
                final item = items[index];
                final selected = location == item.$3 ||
                    (item.$3 != '/' && location.startsWith(item.$3));
                return _NavItem(
                  label: item.$1,
                  icon: item.$2,
                  path: item.$3,
                  selected: selected,
                  collapsed: collapsed,
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.06),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                    radius: 18,
                    backgroundColor: AppTheme.violet,
                    child: Text('YT')),
                if (!collapsed) ...[
                  const SizedBox(width: 10),
                  const Expanded(
                      child: Text('Creator Mode',
                          style: TextStyle(fontWeight: FontWeight.w700))),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.label,
    required this.icon,
    required this.path,
    required this.selected,
    required this.collapsed,
  });

  final String label;
  final IconData icon;
  final String path;
  final bool selected;
  final bool collapsed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: collapsed ? label : '',
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => context.go(path),
        child: AnimatedContainer(
          duration: 180.ms,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          decoration: BoxDecoration(
            color:
                selected ? Colors.white.withOpacity(.11) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                color: selected
                    ? AppTheme.violet.withOpacity(.42)
                    : Colors.transparent),
          ),
          child: Row(
            children: [
              Icon(icon,
                  size: 20, color: selected ? AppTheme.cyan : Colors.white70),
              if (!collapsed) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: Text(label,
                      style: TextStyle(
                          color: selected ? Colors.white : Colors.white70,
                          fontWeight:
                              selected ? FontWeight.w700 : FontWeight.w500)),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _AuroraBackground extends StatelessWidget {
  const _AuroraBackground();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(color: AppTheme.background),
      child: Stack(
        children: [
          Positioned(
              top: -160,
              left: 240,
              child: _Glow(color: AppTheme.violet.withOpacity(.28), size: 360)),
          Positioned(
              top: 140,
              right: -120,
              child: _Glow(color: AppTheme.cyan.withOpacity(.20), size: 320)),
          Positioned(
              bottom: -180,
              left: 520,
              child: _Glow(color: AppTheme.pink.withOpacity(.16), size: 420)),
        ],
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({required this.color, required this.size});
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [BoxShadow(color: color, blurRadius: 120, spreadRadius: 80)],
      ),
    ).animate(onPlay: (controller) => controller.repeat(reverse: true)).scale(
        duration: 5200.ms,
        begin: const Offset(.92, .92),
        end: const Offset(1.08, 1.08));
  }
}
