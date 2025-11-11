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
            altColor: Color(0xFF4259B2),
            title: "Start Your Day \nwith Peaceful Mornings",
            subtitle:
                "Wake up refreshed with calming nature-inspired sounds designed to ease you into the day.",
          ),
          FluidCard(
            color: 'Yellow',
            altColor: Color(0xFF904E93),
            title: "Refresh Your Mind \nwith Guided Breathing",
            subtitle:
                "Reduce stress and boost focus with science-backed breathing techniques at your fingertips.",
          ),
          FluidCard(
            color: 'Blue',
            altColor: Color(0xFFFFB138),
            title: "Sleep Soundly \nwith Soothing Stories",
            subtitle:
                "Drift into deep sleep with a collection of relaxing bedtime stories and mindfulness exercises.",
          ),
        ],
      ),
    );
  }
}
