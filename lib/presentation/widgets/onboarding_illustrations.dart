import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

/// Onboarding illustration 1 — Trading Journal concept.
///
/// Shows a journal book with trading symbols and chart elements.
/// Uses flat design with Crimson Heart accent.
class OnboardingIllustration1 extends StatelessWidget {
  const OnboardingIllustration1({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive sizing based on available width
        final size = constraints.maxWidth < 360 ? 220.0 : 280.0;
        return SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _Onboarding1Painter(),
            size: Size(size, size),
          ),
        );
      },
    );
  }
}

class _Onboarding1Painter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final baseUnit = size.width / 280;

    // Book base - left page
    final bookFill = Paint()
      ..color = AppColors.surfaceContainerLowest
      ..style = PaintingStyle.fill;
    final bookStroke = Paint()
      ..color = AppColors.onSurface
      ..strokeWidth = 2.5 * baseUnit
      ..style = PaintingStyle.stroke;

    // Left page rectangle
    final leftPage = RRect.fromRectAndRadius(
      Rect.fromPoints(
        Offset(45 * baseUnit, 70 * baseUnit),
        Offset(130 * baseUnit, 190 * baseUnit),
      ),
      Radius.circular(4 * baseUnit),
    );
    canvas.drawRRect(leftPage, bookFill);
    canvas.drawRRect(leftPage, bookStroke);

    // Right page rectangle
    final rightPage = RRect.fromRectAndRadius(
      Rect.fromPoints(
        Offset(140 * baseUnit, 70 * baseUnit),
        Offset(225 * baseUnit, 190 * baseUnit),
      ),
      Radius.circular(4 * baseUnit),
    );
    canvas.drawRRect(rightPage, bookFill);
    canvas.drawRRect(rightPage, bookStroke);

    // Center spine (Crimson accent)
    final spinePaint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 5 * baseUnit;
    canvas.drawLine(
      Offset(135 * baseUnit, 65 * baseUnit),
      Offset(135 * baseUnit, 195 * baseUnit),
      spinePaint,
    );

    // Candlestick chart on left page
    _drawCandlestick(
      canvas,
      Offset(75 * baseUnit, 130 * baseUnit),
      25 * baseUnit,
      true, // bullish
      baseUnit,
    );
    _drawCandlestick(
      canvas,
      Offset(105 * baseUnit, 110 * baseUnit),
      35 * baseUnit,
      true, // bullish
      baseUnit,
    );

    // Line chart on right page
    final linePaint = Paint()
      ..color = AppColors.success
      ..strokeWidth = 3 * baseUnit
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final linePath = Path()
      ..moveTo(155 * baseUnit, 160 * baseUnit)
      ..lineTo(175 * baseUnit, 145 * baseUnit)
      ..lineTo(195 * baseUnit, 155 * baseUnit)
      ..lineTo(215 * baseUnit, 120 * baseUnit);
    canvas.drawPath(linePath, linePaint);

    // Area under line
    final areaPath = Path()
      ..moveTo(155 * baseUnit, 160 * baseUnit)
      ..lineTo(175 * baseUnit, 145 * baseUnit)
      ..lineTo(195 * baseUnit, 155 * baseUnit)
      ..lineTo(215 * baseUnit, 120 * baseUnit)
      ..lineTo(215 * baseUnit, 180 * baseUnit)
      ..lineTo(155 * baseUnit, 180 * baseUnit)
      ..close();
    final areaPaint = Paint()
      ..color = AppColors.success.withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;
    canvas.drawPath(areaPath, areaPaint);

    // Trading symbol labels
    _drawLabel(canvas, 'EUR/USD', Offset(70 * baseUnit, 200 * baseUnit), AppColors.onSurfaceVariant, baseUnit);
    _drawLabel(canvas, 'BTC/USD', Offset(165 * baseUnit, 200 * baseUnit), AppColors.primary, baseUnit);

    // Up arrow icon (accent)
    final arrowPaint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 4 * baseUnit
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final arrowPath = Path()
      ..moveTo(230 * baseUnit, 90 * baseUnit)
      ..lineTo(245 * baseUnit, 75 * baseUnit)
      ..moveTo(245 * baseUnit, 75 * baseUnit)
      ..lineTo(235 * baseUnit, 80 * baseUnit);
    canvas.drawPath(arrowPath, arrowPaint);

    // Small decorative dots
    final dotPaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.4)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(55 * baseUnit, 100 * baseUnit), 3 * baseUnit, dotPaint);
    canvas.drawCircle(Offset(215 * baseUnit, 95 * baseUnit), 3 * baseUnit, dotPaint);
  }

  void _drawCandlestick(Canvas canvas, Offset pos, double height, bool isBullish, double baseUnit) {
    final paint = Paint()
      ..color = isBullish ? AppColors.success : AppColors.error
      ..strokeWidth = 2.5 * baseUnit
      ..style = PaintingStyle.stroke;

    // Wick
    canvas.drawLine(
      Offset(pos.dx, pos.dy - height / 2 - 5 * baseUnit),
      Offset(pos.dx, pos.dy + height / 2 + 5 * baseUnit),
      paint,
    );

    // Body
    final body = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: pos,
        width: 12 * baseUnit,
        height: height,
      ),
      Radius.circular(1.5 * baseUnit),
    );
    canvas.drawRRect(body, paint..style = PaintingStyle.fill);
  }

  void _drawLabel(Canvas canvas, String text, Offset pos, Color color, double baseUnit) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: 11 * baseUnit,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, pos);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Onboarding illustration 2 — Analytics Dashboard concept.
///
/// Shows charts and metrics for trading performance analysis.
class OnboardingIllustration2 extends StatelessWidget {
  const OnboardingIllustration2({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.maxWidth < 360 ? 220.0 : 280.0;
        return SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _Onboarding2Painter(),
            size: Size(size, size),
          ),
        );
      },
    );
  }
}

class _Onboarding2Painter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final baseUnit = size.width / 280;

    // Bar chart (left side)
    const barWidth = 18.0;
    final bars = [
      {'x': 55.0, 'h': 35.0, 'color': AppColors.success},
      {'x': 82.0, 'h': 55.0, 'color': AppColors.success},
      {'x': 109.0, 'h': 40.0, 'color': AppColors.error},
      {'x': 136.0, 'h': 70.0, 'color': AppColors.success},
      {'x': 163.0, 'h': 50.0, 'color': AppColors.success},
    ];

    for (var bar in bars) {
      final x = (bar['x'] as double) * baseUnit;
      final h = (bar['h'] as double) * baseUnit;
      final barRect = RRect.fromRectAndRadius(
        Rect.fromPoints(
          Offset(x, 170 * baseUnit),
          Offset(x + barWidth * baseUnit, 170 * baseUnit - h),
        ),
        Radius.circular(3 * baseUnit),
      );
      canvas.drawRRect(barRect, Paint()..color = bar['color'] as Color..style = PaintingStyle.fill);
    }

    // Base line for bars
    final linePaint = Paint()
      ..color = AppColors.onSurfaceVariant
      ..strokeWidth = 2 * baseUnit;
    canvas.drawLine(
      Offset(45 * baseUnit, 170 * baseUnit),
      Offset(190 * baseUnit, 170 * baseUnit),
      linePaint,
    );

    // Line chart (profit curve) - right side
    final curvePaint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 3.5 * baseUnit
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final curvePath = Path()
      ..moveTo(200 * baseUnit, 150 * baseUnit)
      ..cubicTo(
        210 * baseUnit, 140 * baseUnit,
        220 * baseUnit, 120 * baseUnit,
        235 * baseUnit, 110 * baseUnit,
      )
      ..cubicTo(
        250 * baseUnit, 100 * baseUnit,
        255 * baseUnit, 85 * baseUnit,
        265 * baseUnit, 70 * baseUnit,
      );
    canvas.drawPath(curvePath, curvePaint);

    // Data points on curve
    final pointPaint = Paint()
      ..color = AppColors.surfaceContainerLowest
      ..style = PaintingStyle.fill;
    final pointStroke = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 2.5 * baseUnit
      ..style = PaintingStyle.stroke;

    final points = [
      Offset(200 * baseUnit, 150 * baseUnit),
      Offset(235 * baseUnit, 110 * baseUnit),
      Offset(265 * baseUnit, 70 * baseUnit),
    ];

    for (var point in points) {
      canvas.drawCircle(point, 6 * baseUnit, pointPaint);
      canvas.drawCircle(point, 6 * baseUnit, pointStroke);
    }

    // Pie chart (bottom center)
    final pieCenter = Offset(140 * baseUnit, 215 * baseUnit);
    final pieRadius = 30 * baseUnit;

    // Segment 1 - Crimson (45%)
    canvas.drawArc(
      Rect.fromCircle(center: pieCenter, radius: pieRadius),
      0,
      3.14, // 180 degrees
      true,
      Paint()..color = AppColors.primary..style = PaintingStyle.fill,
    );

    // Segment 2 - Green (35%)
    canvas.drawArc(
      Rect.fromCircle(center: pieCenter, radius: pieRadius),
      3.14,
      2.2, // ~126 degrees
      true,
      Paint()..color = AppColors.success..style = PaintingStyle.fill,
    );

    // Segment 3 - Gray (20%)
    canvas.drawArc(
      Rect.fromCircle(center: pieCenter, radius: pieRadius),
      5.34,
      1.0, // ~57 degrees
      true,
      Paint()..color = AppColors.onSurfaceVariant.withValues(alpha: 0.3)..style = PaintingStyle.fill,
    );

    // Inner circle for donut effect
    canvas.drawCircle(
      pieCenter,
      pieRadius * 0.5,
      Paint()..color = AppColors.surfaceContainerLow..style = PaintingStyle.fill,
    );

    // Percentage text (checkmark)
    final checkPaint = Paint()
      ..color = AppColors.success
      ..strokeWidth = 3 * baseUnit
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final checkPath = Path()
      ..moveTo(133 * baseUnit, 215 * baseUnit)
      ..lineTo(138 * baseUnit, 220 * baseUnit)
      ..lineTo(147 * baseUnit, 210 * baseUnit);
    canvas.drawPath(checkPath, checkPaint);

    // Up trend indicator
    final trendPaint = Paint()
      ..color = AppColors.success
      ..strokeWidth = 4 * baseUnit
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(50 * baseUnit, 95 * baseUnit),
      Offset(70 * baseUnit, 75 * baseUnit),
      trendPaint,
    );
    canvas.drawLine(
      Offset(70 * baseUnit, 75 * baseUnit),
      Offset(60 * baseUnit, 80 * baseUnit),
      trendPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Onboarding illustration 3 — Growth & Success concept.
///
/// Shows mountain climbing metaphor with flag at peak.
class OnboardingIllustration3 extends StatelessWidget {
  const OnboardingIllustration3({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.maxWidth < 360 ? 220.0 : 280.0;
        return SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _Onboarding3Painter(),
            size: Size(size, size),
          ),
        );
      },
    );
  }
}

class _Onboarding3Painter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final baseUnit = size.width / 280;

    // Mountain path (stylized)
    final mountainStroke = Paint()
      ..color = AppColors.onSurface
      ..strokeWidth = 3.5 * baseUnit
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final mountainPath = Path()
      ..moveTo(35 * baseUnit, 200 * baseUnit)
      ..lineTo(85 * baseUnit, 150 * baseUnit)
      ..lineTo(115 * baseUnit, 170 * baseUnit)
      ..lineTo(150 * baseUnit, 110 * baseUnit)
      ..lineTo(180 * baseUnit, 140 * baseUnit)
      ..lineTo(220 * baseUnit, 70 * baseUnit)
      ..lineTo(245 * baseUnit, 100 * baseUnit);
    canvas.drawPath(mountainPath, mountainStroke);

    // Mountain fill
    final fillPath = Path()
      ..moveTo(35 * baseUnit, 200 * baseUnit)
      ..lineTo(85 * baseUnit, 150 * baseUnit)
      ..lineTo(115 * baseUnit, 170 * baseUnit)
      ..lineTo(150 * baseUnit, 110 * baseUnit)
      ..lineTo(180 * baseUnit, 140 * baseUnit)
      ..lineTo(220 * baseUnit, 70 * baseUnit)
      ..lineTo(245 * baseUnit, 100 * baseUnit)
      ..lineTo(245 * baseUnit, 230 * baseUnit)
      ..lineTo(35 * baseUnit, 230 * baseUnit)
      ..close();
    final mountainFill = Paint()
      ..color = AppColors.surfaceContainerHighest.withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;
    canvas.drawPath(fillPath, mountainFill);

    // Progress checkpoints (green circles)
    final checkpointPaint = Paint()
      ..color = AppColors.success
      ..style = PaintingStyle.fill;
    final checkpointStroke = Paint()
      ..color = AppColors.surfaceContainerLowest
      ..strokeWidth = 2 * baseUnit
      ..style = PaintingStyle.stroke;

    final checkpoints = [
      Offset(85 * baseUnit, 150 * baseUnit),
      Offset(150 * baseUnit, 110 * baseUnit),
      Offset(220 * baseUnit, 70 * baseUnit),
    ];

    for (var checkpoint in checkpoints) {
      canvas.drawCircle(checkpoint, 7 * baseUnit, checkpointPaint);
      canvas.drawCircle(checkpoint, 7 * baseUnit, checkpointStroke);
    }

    // Flag at peak
    final peakPos = Offset(220 * baseUnit, 70 * baseUnit);

    // Flag pole
    final polePaint = Paint()
      ..color = AppColors.onSurface
      ..strokeWidth = 3.5 * baseUnit
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      peakPos,
      Offset(peakPos.dx, peakPos.dy - 40 * baseUnit),
      polePaint,
    );

    // Flag
    final flagPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;
    final flagPath = Path()
      ..moveTo(peakPos.dx, peakPos.dy - 40 * baseUnit)
      ..lineTo(peakPos.dx - 30 * baseUnit, peakPos.dy - 30 * baseUnit)
      ..lineTo(peakPos.dx - 30 * baseUnit, peakPos.dy - 15 * baseUnit)
      ..lineTo(peakPos.dx, peakPos.dy - 25 * baseUnit)
      ..close();
    canvas.drawPath(flagPath, flagPaint);

    // Star on flag
    final starPaint = Paint()
      ..color = AppColors.onPrimary
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(peakPos.dx - 15 * baseUnit, peakPos.dy - 27 * baseUnit), 4 * baseUnit, starPaint);

    // Sparkles (celebratory)
    final sparklePaint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 2 * baseUnit
      ..style = PaintingStyle.stroke;

    _drawSparkle(canvas, Offset(60 * baseUnit, 100 * baseUnit), sparklePaint, baseUnit);
    _drawSparkle(canvas, Offset(180 * baseUnit, 60 * baseUnit), sparklePaint, baseUnit);
    _drawSparkle(canvas, Offset(250 * baseUnit, 130 * baseUnit), sparklePaint, baseUnit);

    // Calendar icon (bottom left)
    final calendarRect = RRect.fromRectAndRadius(
      Rect.fromPoints(
        Offset(40 * baseUnit, 205 * baseUnit),
        Offset(75 * baseUnit, 240 * baseUnit),
      ),
      Radius.circular(4 * baseUnit),
    );
    canvas.drawRRect(calendarRect, Paint()..color = AppColors.surfaceContainerLowest..style = PaintingStyle.fill);
    canvas.drawRRect(calendarRect, Paint()..color = AppColors.onSurfaceVariant..strokeWidth = 1.5 * baseUnit..style = PaintingStyle.stroke);

    // Calendar lines
    final linePaint = Paint()
      ..color = AppColors.onSurfaceVariant.withValues(alpha: 0.5)
      ..strokeWidth = 1.5 * baseUnit;
    canvas.drawLine(Offset(47 * baseUnit, 220 * baseUnit), Offset(68 * baseUnit, 220 * baseUnit), linePaint);
    canvas.drawLine(Offset(47 * baseUnit, 228 * baseUnit), Offset(62 * baseUnit, 228 * baseUnit), linePaint);
  }

  void _drawSparkle(Canvas canvas, Offset pos, Paint paint, double baseUnit) {
    final size = 6 * baseUnit;
    final path = Path()
      ..moveTo(pos.dx, pos.dy - size)
      ..lineTo(pos.dx, pos.dy + size)
      ..moveTo(pos.dx - size, pos.dy)
      ..lineTo(pos.dx + size, pos.dy);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
