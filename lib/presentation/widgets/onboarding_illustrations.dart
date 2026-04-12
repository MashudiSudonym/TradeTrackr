import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

/// Onboarding illustration 1 — Trading Journal concept.
///
/// Shows an open journal with trading symbols and candlestick charts.
/// Uses Crimson Heart as accent color with flat design.
class OnboardingIllustration1 extends StatelessWidget {
  const OnboardingIllustration1({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 280,
      child: CustomPaint(
        painter: _Onboarding1Painter(),
        size: const Size(280, 280),
      ),
    );
  }
}

class _Onboarding1Painter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final baseUnit = size.width / 280;

    // Background circle (subtle)
    final bgPaint = Paint()
      ..color = AppColors.surfaceContainerLow
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 120 * baseUnit, bgPaint);

    // Book/journal base
    final bookPaint = Paint()
      ..color = AppColors.onSurface
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3 * baseUnit;
    final bookFill = Paint()
      ..color = AppColors.surfaceContainerLowest
      ..style = PaintingStyle.fill;

    // Left page
    final leftPage = Path()
      ..moveTo((70 - 20) * baseUnit, 60 * baseUnit)
      ..lineTo((130 - 20) * baseUnit, 60 * baseUnit)
      ..lineTo((130 - 20) * baseUnit, 200 * baseUnit)
      ..lineTo((70 - 20) * baseUnit, 200 * baseUnit)
      ..close();
    canvas.drawPath(leftPage, bookFill);
    canvas.drawPath(leftPage, bookPaint);

    // Right page
    final rightPage = Path()
      ..moveTo((140 - 20) * baseUnit, 60 * baseUnit)
      ..lineTo((200 - 20) * baseUnit, 60 * baseUnit)
      ..lineTo((200 - 20) * baseUnit, 200 * baseUnit)
      ..lineTo((140 - 20) * baseUnit, 200 * baseUnit)
      ..close();
    canvas.drawPath(rightPage, bookFill);
    canvas.drawPath(rightPage, bookPaint);

    // Book spine
    final spinePaint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 4 * baseUnit;
    canvas.drawLine(
      Offset((135 - 20) * baseUnit, 60 * baseUnit),
      Offset((135 - 20) * baseUnit, 200 * baseUnit),
      spinePaint,
    );

    // Candlestick charts on left page
    final candlePaint = Paint()
      ..color = AppColors.success
      ..strokeWidth = 3 * baseUnit;
    final candleRed = Paint()
      ..color = AppColors.error
      ..strokeWidth = 3 * baseUnit;

    // Bullish candle 1
    canvas.drawLine(
      Offset((90 - 20) * baseUnit, 140 * baseUnit),
      Offset((90 - 20) * baseUnit, 170 * baseUnit),
      candlePaint,
    );
    final candleBody1 = RRect.fromRectAndRadius(
      Rect.fromPoints(
        Offset((85 - 20) * baseUnit, 145 * baseUnit),
        Offset((95 - 20) * baseUnit, 165 * baseUnit),
      ),
      Radius.circular(2 * baseUnit),
    );
    canvas.drawRRect(candleBody1, candlePaint..style = PaintingStyle.fill);

    // Bullish candle 2
    canvas.drawLine(
      Offset((110 - 20) * baseUnit, 120 * baseUnit),
      Offset((110 - 20) * baseUnit, 150 * baseUnit),
      candlePaint,
    );
    final candleBody2 = RRect.fromRectAndRadius(
      Rect.fromPoints(
        Offset((105 - 20) * baseUnit, 125 * baseUnit),
        Offset((115 - 20) * baseUnit, 150 * baseUnit),
      ),
      Radius.circular(2 * baseUnit),
    );
    canvas.drawRRect(candleBody2, candlePaint..style = PaintingStyle.fill);

    // Bearish candle
    canvas.drawLine(
      Offset((180 - 20) * baseUnit, 130 * baseUnit),
      Offset((180 - 20) * baseUnit, 160 * baseUnit),
      candleRed,
    );
    final candleBody3 = RRect.fromRectAndRadius(
      Rect.fromPoints(
        Offset((175 - 20) * baseUnit, 135 * baseUnit),
        Offset((185 - 20) * baseUnit, 155 * baseUnit),
      ),
      Radius.circular(2 * baseUnit),
    );
    canvas.drawRRect(candleBody3, candleRed..style = PaintingStyle.fill);

    // EURUSD label
    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'EUR/USD',
        style: TextStyle(
          color: AppColors.onSurfaceVariant,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset((85 - 20) * baseUnit, 85 * baseUnit),
    );

    // BTCUSD label
    textPainter.text = const TextSpan(
      text: 'BTC/USD',
      style: TextStyle(
        color: AppColors.primary,
        fontSize: 10,
        fontWeight: FontWeight.w600,
      ),
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset((155 - 20) * baseUnit, 85 * baseUnit),
    );

    // Up arrow (accent)
    final arrowPaint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 4 * baseUnit
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final arrowPath = Path()
      ..moveTo(220 * baseUnit, 180 * baseUnit)
      ..lineTo(240 * baseUnit, 160 * baseUnit)
      ..lineTo(245 * baseUnit, 165 * baseUnit)
      ..moveTo(240 * baseUnit, 160 * baseUnit)
      ..lineTo(235 * baseUnit, 155 * baseUnit);
    canvas.drawPath(arrowPath, arrowPaint);

    // Pen/pencil icon
    final penPaint = Paint()
      ..color = AppColors.onSurface
      ..strokeWidth = 3 * baseUnit
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(50 * baseUnit, 220 * baseUnit),
      Offset(70 * baseUnit, 240 * baseUnit),
      penPaint,
    );
    final penTip = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(48 * baseUnit, 218 * baseUnit), 4 * baseUnit, penTip);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Onboarding illustration 2 — Analytics Dashboard concept.
///
/// Shows charts and graphs for trading performance analysis.
/// Uses Forest Green for success states with Crimson accents.
class OnboardingIllustration2 extends StatelessWidget {
  const OnboardingIllustration2({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 280,
      child: CustomPaint(
        painter: _Onboarding2Painter(),
        size: const Size(280, 280),
      ),
    );
  }
}

class _Onboarding2Painter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final baseUnit = size.width / 280;

    // Background circle
    final bgPaint = Paint()
      ..color = AppColors.surfaceContainerLow
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 120 * baseUnit, bgPaint);

    // Line chart (profit curve) - going up
    final linePaint = Paint()
      ..color = AppColors.success
      ..strokeWidth = 4 * baseUnit
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final linePath = Path()
      ..moveTo(40 * baseUnit, 180 * baseUnit)
      ..cubicTo(
        80 * baseUnit, 170 * baseUnit,
        100 * baseUnit, 140 * baseUnit,
        140 * baseUnit, 120 * baseUnit,
      )
      ..cubicTo(
        180 * baseUnit, 100 * baseUnit,
        200 * baseUnit, 80 * baseUnit,
        240 * baseUnit, 60 * baseUnit,
      );
    canvas.drawPath(linePath, linePaint);

    // Area under curve
    final areaPath = Path()
      ..moveTo(40 * baseUnit, 180 * baseUnit)
      ..cubicTo(
        80 * baseUnit, 170 * baseUnit,
        100 * baseUnit, 140 * baseUnit,
        140 * baseUnit, 120 * baseUnit,
      )
      ..cubicTo(
        180 * baseUnit, 100 * baseUnit,
        200 * baseUnit, 80 * baseUnit,
        240 * baseUnit, 60 * baseUnit,
      )
      ..lineTo(240 * baseUnit, 200 * baseUnit)
      ..lineTo(40 * baseUnit, 200 * baseUnit)
      ..close();
    final areaPaint = Paint()
      ..color = AppColors.success.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;
    canvas.drawPath(areaPath, areaPaint);

    // Bar chart (win rate)
    final barPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;
    final barGreen = Paint()
      ..color = AppColors.success
      ..style = PaintingStyle.fill;

    // Bars
    final bars = [
      {'x': 60, 'h': 40, 'color': barGreen},
      {'x': 90, 'h': 60, 'color': barGreen},
      {'x': 120, 'h': 45, 'color': barPaint},
      {'x': 150, 'h': 70, 'color': barGreen},
      {'x': 180, 'h': 55, 'color': barGreen},
      {'x': 210, 'h': 80, 'color': barGreen},
    ];

    for (var bar in bars) {
      final rect = RRect.fromRectAndRadius(
        Rect.fromPoints(
          Offset((bar['x'] as double) * baseUnit, 200 * baseUnit),
          Offset(((bar['x'] as double) + 20) * baseUnit,
                (200 - (bar['h'] as double)) * baseUnit),
        ),
        Radius.circular(4 * baseUnit),
      );
      canvas.drawRRect(rect, bar['color'] as Paint);
    }

    // Pie chart (symbol distribution) - simplified as circle with segments
    final center = Offset(220 * baseUnit, 180 * baseUnit);
    final radius = 35 * baseUnit;

    // Segment 1 - Crimson
    final segment1Paint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      0,
      2.0, // ~115 degrees
      true,
      segment1Paint,
    );

    // Segment 2 - Green
    final segment2Paint = Paint()
      ..color = AppColors.success
      ..style = PaintingStyle.fill;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      2.0,
      2.6, // ~150 degrees
      true,
      segment2Paint,
    );

    // Segment 3 - Gray
    final segment3Paint = Paint()
      ..color = AppColors.onSurfaceVariant.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      4.6,
      1.6, // ~95 degrees
      true,
      segment3Paint,
    );

    // Percentage badge
    final badgePaint = Paint()
      ..color = AppColors.surfaceContainerLowest
      ..style = PaintingStyle.fill;
    final badgeStroke = Paint()
      ..color = AppColors.success
      ..strokeWidth = 3 * baseUnit
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius / 2, badgePaint);
    canvas.drawCircle(center, radius / 2, badgeStroke);

    // Percentage text (simplified as a checkmark)
    final checkPaint = Paint()
      ..color = AppColors.success
      ..strokeWidth = 4 * baseUnit
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final checkPath = Path()
      ..moveTo(210 * baseUnit, 180 * baseUnit)
      ..lineTo(217 * baseUnit, 187 * baseUnit)
      ..lineTo(230 * baseUnit, 173 * baseUnit);
    canvas.drawPath(checkPath, checkPaint);

    // Upward trend arrow
    final arrowPaint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 5 * baseUnit
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final arrowPath = Path()
      ..moveTo(30 * baseUnit, 100 * baseUnit)
      ..lineTo(50 * baseUnit, 80 * baseUnit)
      ..moveTo(50 * baseUnit, 80 * baseUnit)
      ..lineTo(40 * baseUnit, 80 * baseUnit);
    canvas.drawPath(arrowPath, arrowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Onboarding illustration 3 — Growth & Success concept.
///
/// Shows mountain climbing metaphor with flag at peak.
/// Celebrates achievement and progress in trading journey.
class OnboardingIllustration3 extends StatelessWidget {
  const OnboardingIllustration3({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 280,
      child: CustomPaint(
        painter: _Onboarding3Painter(),
        size: const Size(280, 280),
      ),
    );
  }
}

class _Onboarding3Painter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final baseUnit = size.width / 280;

    // Background circle
    final bgPaint = Paint()
      ..color = AppColors.surfaceContainerLow
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 120 * baseUnit, bgPaint);

    // Mountain path (upward trajectory)
    final mountainPaint = Paint()
      ..color = AppColors.onSurface
      ..strokeWidth = 4 * baseUnit
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final mountainPath = Path()
      ..moveTo(30 * baseUnit, 220 * baseUnit)
      ..lineTo(80 * baseUnit, 180 * baseUnit)
      ..lineTo(100 * baseUnit, 195 * baseUnit)
      ..lineTo(140 * baseUnit, 140 * baseUnit)
      ..lineTo(160 * baseUnit, 160 * baseUnit)
      ..lineTo(200 * baseUnit, 90 * baseUnit)
      ..lineTo(220 * baseUnit, 110 * baseUnit)
      ..lineTo(250 * baseUnit, 60 * baseUnit);
    canvas.drawPath(mountainPath, mountainPaint);

    // Mountain fill
    final fillPath = Path()
      ..moveTo(30 * baseUnit, 220 * baseUnit)
      ..lineTo(80 * baseUnit, 180 * baseUnit)
      ..lineTo(100 * baseUnit, 195 * baseUnit)
      ..lineTo(140 * baseUnit, 140 * baseUnit)
      ..lineTo(160 * baseUnit, 160 * baseUnit)
      ..lineTo(200 * baseUnit, 90 * baseUnit)
      ..lineTo(220 * baseUnit, 110 * baseUnit)
      ..lineTo(250 * baseUnit, 60 * baseUnit)
      ..lineTo(250 * baseUnit, 250 * baseUnit)
      ..lineTo(30 * baseUnit, 250 * baseUnit)
      ..close();
    final mountainFill = Paint()
      ..color = AppColors.surfaceContainerHighest.withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;
    canvas.drawPath(fillPath, mountainFill);

    // Flag at peak
    final flagPole = Paint()
      ..color = AppColors.onSurface
      ..strokeWidth = 4 * baseUnit
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(250 * baseUnit, 60 * baseUnit),
      Offset(250 * baseUnit, 30 * baseUnit),
      flagPole,
    );

    // Flag
    final flagPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;
    final flagPath = Path()
      ..moveTo(250 * baseUnit, 30 * baseUnit)
      ..lineTo(220 * baseUnit, 40 * baseUnit)
      ..lineTo(220 * baseUnit, 55 * baseUnit)
      ..lineTo(250 * baseUnit, 45 * baseUnit)
      ..close();
    canvas.drawPath(flagPath, flagPaint);

    // Star on flag
    final starPaint = Paint()
      ..color = AppColors.onPrimary
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(235 * baseUnit, 47 * baseUnit), 4 * baseUnit, starPaint);

    // Progress markers (checkpoints)
    final checkpointPaint = Paint()
      ..color = AppColors.success
      ..style = PaintingStyle.fill;

    // Checkpoint 1
    canvas.drawCircle(Offset(80 * baseUnit, 180 * baseUnit), 6 * baseUnit, checkpointPaint);

    // Checkpoint 2
    canvas.drawCircle(Offset(140 * baseUnit, 140 * baseUnit), 6 * baseUnit, checkpointPaint);

    // Checkpoint 3
    canvas.drawCircle(Offset(200 * baseUnit, 90 * baseUnit), 6 * baseUnit, checkpointPaint);

    // Celebratory sparkles
    final sparklePaint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 2 * baseUnit
      ..style = PaintingStyle.stroke;

    // Sparkle 1
    _drawSparkle(canvas, 60 * baseUnit, 100 * baseUnit, sparklePaint, baseUnit);
    // Sparkle 2
    _drawSparkle(canvas, 180 * baseUnit, 60 * baseUnit, sparklePaint, baseUnit);
    // Sparkle 3
    _drawSparkle(canvas, 260 * baseUnit, 140 * baseUnit, sparklePaint, baseUnit);

    // Calendar/dates showing progress
    final calendarPaint = Paint()
      ..color = AppColors.surfaceContainerLowest
      ..style = PaintingStyle.fill;
    final calendarStroke = Paint()
      ..color = AppColors.onSurfaceVariant
      ..strokeWidth = 2 * baseUnit
      ..style = PaintingStyle.stroke;

    // Small calendar icon
    final calendarRect = RRect.fromRectAndRadius(
      Rect.fromPoints(
        const Offset(40, 230),
        Offset(80 * baseUnit, 270 * baseUnit),
      ),
      Radius.circular(6 * baseUnit),
    );
    canvas.drawRRect(calendarRect, calendarPaint);
    canvas.drawRRect(calendarRect, calendarStroke);

    // Calendar lines
    final linePaint = Paint()
      ..color = AppColors.onSurfaceVariant.withValues(alpha: 0.5)
      ..strokeWidth = 2 * baseUnit;
    canvas.drawLine(
      Offset(48 * baseUnit, 250 * baseUnit),
      Offset(72 * baseUnit, 250 * baseUnit),
      linePaint,
    );
    canvas.drawLine(
      Offset(48 * baseUnit, 260 * baseUnit),
      Offset(65 * baseUnit, 260 * baseUnit),
      linePaint,
    );
  }

  void _drawSparkle(Canvas canvas, double x, double y, Paint paint, double baseUnit) {
    final path = Path()
      ..moveTo(x, y - 8 * baseUnit)
      ..lineTo(x, y + 8 * baseUnit)
      ..moveTo(x - 8 * baseUnit, y)
      ..lineTo(x + 8 * baseUnit, y)
      ..moveTo(x - 5 * baseUnit, y - 5 * baseUnit)
      ..lineTo(x + 5 * baseUnit, y + 5 * baseUnit)
      ..moveTo(x + 5 * baseUnit, y - 5 * baseUnit)
      ..lineTo(x - 5 * baseUnit, y + 5 * baseUnit);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
