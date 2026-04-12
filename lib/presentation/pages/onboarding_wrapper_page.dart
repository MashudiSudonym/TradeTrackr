import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../app/theme/app_colors.dart';
import '../widgets/onboarding_illustrations.dart';
import '../providers/onboarding_provider.dart';

/// Onboarding wrapper page — manages PageView and navigation state.
///
/// Displays 3 onboarding pages with swipe navigation, dot indicators,
/// and action buttons (Skip/Next/Get Started).
///
/// Responsive design: Constrained max width for desktop screens.
class OnboardingWrapperPage extends ConsumerStatefulWidget {
  const OnboardingWrapperPage({super.key});

  @override
  ConsumerState<OnboardingWrapperPage> createState() => _OnboardingWrapperPageState();
}

class _OnboardingWrapperPageState extends ConsumerState<OnboardingWrapperPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const int _totalPages = 3;
  static const double _maxContentWidth = 480.0;

  final List<_OnboardingPageData> _pages = const [
    _OnboardingPageData(
      illustration: OnboardingIllustration1(),
      title: 'Welcome to TradeTrackr',
      subtitle: 'Your professional trading journal for tracking, analyzing, and improving your market performance',
      quote: 'Every professional trader keeps a journal. Start yours today.',
    ),
    _OnboardingPageData(
      illustration: OnboardingIllustration2(),
      title: 'Track Every Trade',
      subtitle: 'Record your entries, exits, profits, and losses. Analyze patterns in your trading behavior over time',
      quote: 'What gets measured gets managed. What gets managed gets improved.',
    ),
    _OnboardingPageData(
      illustration: OnboardingIllustration3(),
      title: 'Master Your Trading',
      subtitle: 'Join thousands of disciplined traders who track their way to consistent profitability',
      quote: 'The best time to start trading was yesterday. The second best time is now.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _maxContentWidth),
            child: Column(
              children: [
                // ── Skip Button ─────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _handleSkip,
                      child: Text(
                        'Skip',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ),

                // ── PageView ─────────────────────────────────────
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() => _currentPage = index);
                    },
                    itemCount: _totalPages,
                    itemBuilder: (context, index) {
                      final page = _pages[index];
                      return _OnboardingPageContent(
                        illustration: page.illustration,
                        title: page.title,
                        subtitle: page.subtitle,
                        quote: page.quote,
                      );
                    },
                  ),
                ),

                // ── Bottom Area ─────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      // ── Dot Indicators ───────────────────────
                      _DotIndicators(
                        currentIndex: _currentPage,
                        totalPages: _totalPages,
                      ),
                      const SizedBox(height: 24),

                      // ── Action Button ────────────────────────
                      _ActionButton(
                        isLastPage: _currentPage == _totalPages - 1,
                        onPressed: _currentPage == _totalPages - 1
                            ? _handleGetStarted
                            : _handleNext,
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleSkip() async {
    await ref.read(onboardingProvider.notifier).markCompleted();
    if (mounted) {
      context.go('/login');
    }
  }

  void _handleNext() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _handleGetStarted() async {
    await ref.read(onboardingProvider.notifier).markCompleted();
    if (mounted) {
      context.go('/login');
    }
  }
}

// ───────────────────────────────────────────────────────────────
// Data class for onboarding page content
// ───────────────────────────────────────────────────────────────

class _OnboardingPageData {
  final Widget illustration;
  final String title;
  final String subtitle;
  final String quote;

  const _OnboardingPageData({
    required this.illustration,
    required this.title,
    required this.subtitle,
    required this.quote,
  });
}

// ───────────────────────────────────────────────────────────────
// Reusable widgets
// ───────────────────────────────────────────────────────────────

/// Content widget for a single onboarding page.
class _OnboardingPageContent extends StatelessWidget {
  final Widget illustration;
  final String title;
  final String subtitle;
  final String quote;

  const _OnboardingPageContent({
    required this.illustration,
    required this.title,
    required this.subtitle,
    required this.quote,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ── Illustration ─────────────────────────────
            illustration,
            const SizedBox(height: 40),

            // ── Title ───────────────────────────────────
            Text(
              title,
              style: GoogleFonts.manrope(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: cs.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // ── Subtitle ─────────────────────────────────
            Text(
              subtitle,
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: cs.onSurfaceVariant,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // ── Motivational Quote ───────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '"$quote"',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.italic,
                  color: AppColors.onPrimaryContainer,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

/// Dot indicators showing current page position.
class _DotIndicators extends StatelessWidget {
  final int currentIndex;
  final int totalPages;

  const _DotIndicators({
    required this.currentIndex,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalPages, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: currentIndex == index ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: currentIndex == index
                ? AppColors.primary
                : AppColors.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}

/// Action button - shows "Next" or "Get Started" based on page.
class _ActionButton extends StatelessWidget {
  final bool isLastPage;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.isLastPage,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.primaryDim],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 1.0],
            transform: GradientRotation(135 * 3.14159 / 180),
          ),
          borderRadius: BorderRadius.circular(9999),
        ),
        child: Center(
          child: Text(
            isLastPage ? 'Get Started' : 'Next',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.onPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
