import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:trade_trackr/presentation/page/dashboard/dashboard_page.dart';
import 'package:trade_trackr/presentation/page/journal/journal_page.dart';
import 'package:trade_trackr/presentation/page/profile/profile_page.dart';
import 'package:trade_trackr/presentation/page/stats/stats_page.dart';
import 'package:trade_trackr/presentation/page/main_page/widgets/main_bottom_nav_bar.dart';
import 'package:trade_trackr/presentation/provider/main_page/main_page_provider.dart';

class MainPage extends ConsumerWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(mainPageControllerProvider);

    final List<Widget> pages = const [
      DashboardPage(),
      JournalPage(),
      StatsPage(),
      ProfilePage(),
    ];

    return Scaffold(
      backgroundColor: ShadTheme.of(context).colorScheme.background,
      body: IndexedStack(index: currentIndex, children: pages),
      bottomNavigationBar: MainBottomNavBar(
        currentIndex: currentIndex,
        onTap: (index) {
          ref.read(mainPageControllerProvider.notifier).setIndex(index);
        },
      ),
    );
  }
}
