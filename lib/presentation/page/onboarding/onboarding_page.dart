import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trade_trackr/presentation/page/onboarding/widget/fluid_carousel/fluid_card.dart';
import 'package:trade_trackr/presentation/page/onboarding/widget/fluid_carousel/fluid_carousel.dart';
import 'package:trade_trackr/presentation/page/main_page/main_page.dart';
import 'package:trade_trackr/presentation/provider/onboarding/onboarding_index_provider.dart';

class OnboardingPage extends ConsumerWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(onboardingIndexProvider);

    return Scaffold(
      body: Stack(
        children: [
          FluidCarousel(
            onChange: (index) {
              ref.read(onboardingIndexProvider.notifier).updateIndex(index);
            },
            children: [
              FluidCard(
                color: 'Red',
                altColor: Color(0xFF904E93),
                title: "Plan Your Trades \nLike This Board",
                subtitle:
                    "clear, structured, and calm. Discipline today builds freedom tomorrow.",
              ),
              FluidCard(
                color: 'Yellow',
                altColor: Color(0xFF4259B2),
                title: "Study The Charts\nNot Your Emotions.",
                subtitle: "Data guides you; discipline keeps you winning.",
              ),
              FluidCard(
                color: 'Blue',
                altColor: Color(0xFFFFB138),
                title: "Trade with Patience\nSave with Purpose",
                subtitle: "profits mean nothing without control.",
              ),
            ],
          ),
          if (currentIndex == 2)
            Positioned(
              bottom: 50,
              left: 32,
              right: 32,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 500),
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, 20 * (1 - value)),
                      child: child,
                    ),
                  );
                },
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const MainPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 8,
                    shadowColor: Colors.black26,
                  ),
                  child: const Text(
                    "Get Started",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
