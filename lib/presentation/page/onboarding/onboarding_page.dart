import 'package:flutter/material.dart';
import 'package:trade_trackr/presentation/page/onboarding/widget/fluid_carousel/fluid_card.dart';
import 'package:trade_trackr/presentation/page/onboarding/widget/fluid_carousel/fluid_carousel.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FluidCarousel(
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
    );
  }
}
