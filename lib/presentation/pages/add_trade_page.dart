import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

import '../../core/extensions/context_extensions.dart';
import '../../domain/entities/closed_position.dart';
import '../../domain/entities/open_position.dart';
import '../../domain/enums/close_reason.dart';
import '../../domain/enums/trade_side.dart';
import '../../app/theme/app_colors.dart';
import '../widgets/responsive/responsive.dart';
import '../providers/auth_provider.dart';
import '../providers/di_providers.dart';

/// Add Trade page — form for creating a new trade position.
///
/// Supports Closed and Open position types with toggle.
/// Form validation on all required fields.
class AddTradePage extends ConsumerStatefulWidget {
  const AddTradePage({super.key});

  @override
  ConsumerState<AddTradePage> createState() => _AddTradePageState();
}

class _AddTradePageState extends ConsumerState<AddTradePage> {
  final _formKey = GlobalKey<FormState>();
  final _symbolController = TextEditingController();
  final _volumeController = TextEditingController();
  final _openPriceController = TextEditingController();
  final _closePriceController = TextEditingController();
  final _stopLossController = TextEditingController();
  final _takeProfitController = TextEditingController();
  final _swapController = TextEditingController();
  final _commissionController = TextEditingController();

  bool _isClosed = true;
  TradeSide _side = TradeSide.buy;
  CloseReason _reason = CloseReason.user;
  DateTime _openTime = DateTime.now();
  DateTime _closeTime = DateTime.now();

  @override
  void dispose() {
    _symbolController.dispose();
    _volumeController.dispose();
    _openPriceController.dispose();
    _closePriceController.dispose();
    _stopLossController.dispose();
    _takeProfitController.dispose();
    _swapController.dispose();
    _commissionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final spacing = context.responsiveSpacing();

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.surface,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.close, color: cs.onSurface),
        ),
        title: Text(
          'Add Trade',
          style: GoogleFonts.manrope(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: cs.onSurface,
          ),
        ),
        centerTitle: false,
      ),
      body: ResponsiveCentered(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Position Type Toggle ──────────────────────
                _buildPositionTypeToggle(cs),

                SizedBox(height: 24 + spacing),

                // ── Symbol ───────────────────────────────────
                _FieldLabel(cs: cs, label: 'SYMBOL'),
                SizedBox(height: 8 + spacing / 2),
                _FormField(
                  controller: _symbolController,
                  hintText: 'e.g., BTCUSD, EURUSD',
                  cs: cs,
                  validator: (v) => (v == null || v.isEmpty) ? 'Symbol is required' : null,
                ),
                SizedBox(height: 20 + spacing),

                // ── Side Toggle ──────────────────────────────
                _FieldLabel(cs: cs, label: 'SIDE'),
                SizedBox(height: 8 + spacing / 2),
                _buildSideToggle(cs),
                SizedBox(height: 20 + spacing),

                // ── Volume & Open Price (side by side on tablet/desktop) ───────────
                if (context.isMobile) ...[
                  // Mobile: single column
                  _FieldLabel(cs: cs, label: 'VOLUME (LOTS)'),
                  SizedBox(height: 8 + spacing / 2),
                  _FormField(
                    controller: _volumeController,
                    hintText: '0.0',
                    cs: cs,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Volume is required';
                      if (double.tryParse(v) == null) return 'Enter a valid number';
                      return null;
                    },
                  ),
                  SizedBox(height: 20 + spacing),

                  _FieldLabel(cs: cs, label: 'OPEN PRICE'),
                  SizedBox(height: 8 + spacing / 2),
                  _FormField(
                    controller: _openPriceController,
                    hintText: '0.00',
                    cs: cs,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Open price is required';
                      if (double.tryParse(v) == null) return 'Enter a valid number';
                      return null;
                    },
                  ),
                  SizedBox(height: 20 + spacing),
                ] else ...[
                  // Tablet/Desktop: two columns
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _FieldLabel(cs: cs, label: 'VOLUME (LOTS)'),
                            SizedBox(height: 8 + spacing / 2),
                            _FormField(
                              controller: _volumeController,
                              hintText: '0.0',
                              cs: cs,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              validator: (v) {
                                if (v == null || v.isEmpty) return 'Volume is required';
                                if (double.tryParse(v) == null) return 'Enter a valid number';
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: spacing),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _FieldLabel(cs: cs, label: 'OPEN PRICE'),
                            SizedBox(height: 8 + spacing / 2),
                            _FormField(
                              controller: _openPriceController,
                              hintText: '0.00',
                              cs: cs,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              validator: (v) {
                                if (v == null || v.isEmpty) return 'Open price is required';
                                if (double.tryParse(v) == null) return 'Enter a valid number';
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20 + spacing),
                ],

                // ── Open Time ────────────────────────────────
                _FieldLabel(cs: cs, label: 'OPEN TIME'),
                SizedBox(height: 8 + spacing / 2),
                _buildDateTimePicker(cs, _openTime, (dt) => _openTime = dt),
                SizedBox(height: 20 + spacing),

                // ── Close Price & Time (if closed) ───────────
                if (_isClosed) ...[
                  _FieldLabel(cs: cs, label: 'CLOSE PRICE'),
                  SizedBox(height: 8 + spacing / 2),
                  _FormField(
                    controller: _closePriceController,
                    hintText: '0.00',
                    cs: cs,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    validator: (v) {
                      if (!_isClosed) return null;
                      if (v == null || v.isEmpty) return 'Close price is required';
                      if (double.tryParse(v) == null) return 'Enter a valid number';
                      return null;
                    },
                  ),
                  SizedBox(height: 20 + spacing),

                  _FieldLabel(cs: cs, label: 'CLOSE TIME'),
                  SizedBox(height: 8 + spacing / 2),
                  _buildDateTimePicker(cs, _closeTime, (dt) => _closeTime = dt),
                  SizedBox(height: 20 + spacing),

                  // ── Reason ─────────────────────────────────
                  _FieldLabel(cs: cs, label: 'CLOSE REASON'),
                  SizedBox(height: 8 + spacing / 2),
                  _buildReasonDropdown(cs),
                  SizedBox(height: 20 + spacing),
                ],

                // ── Stop Loss & Take Profit (side by side on tablet/desktop) ─────────
                if (context.isMobile) ...[
                  _FieldLabel(cs: cs, label: 'STOP LOSS (OPTIONAL)'),
                  SizedBox(height: 8 + spacing / 2),
                  _FormField(
                    controller: _stopLossController,
                    hintText: '0.00',
                    cs: cs,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                  SizedBox(height: 20 + spacing),

                  _FieldLabel(cs: cs, label: 'TAKE PROFIT (OPTIONAL)'),
                  SizedBox(height: 8 + spacing / 2),
                  _FormField(
                    controller: _takeProfitController,
                    hintText: '0.00',
                    cs: cs,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                  SizedBox(height: 20 + spacing),
                ] else ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _FieldLabel(cs: cs, label: 'STOP LOSS (OPTIONAL)'),
                            SizedBox(height: 8 + spacing / 2),
                            _FormField(
                              controller: _stopLossController,
                              hintText: '0.00',
                              cs: cs,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: spacing),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _FieldLabel(cs: cs, label: 'TAKE PROFIT (OPTIONAL)'),
                            SizedBox(height: 8 + spacing / 2),
                            _FormField(
                              controller: _takeProfitController,
                              hintText: '0.00',
                              cs: cs,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20 + spacing),
                ],

                // ── Swap & Commission (side by side on tablet/desktop) ────────────
                if (context.isMobile) ...[
                  _FieldLabel(cs: cs, label: 'SWAP'),
                  SizedBox(height: 8 + spacing / 2),
                  _FormField(
                    controller: _swapController,
                    hintText: '0.00',
                    cs: cs,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                  SizedBox(height: 20 + spacing),

                  _FieldLabel(cs: cs, label: 'COMMISSION'),
                  SizedBox(height: 8 + spacing / 2),
                  _FormField(
                    controller: _commissionController,
                    hintText: '0.00',
                    cs: cs,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                  SizedBox(height: 32 + spacing),
                ] else ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _FieldLabel(cs: cs, label: 'SWAP'),
                            SizedBox(height: 8 + spacing / 2),
                            _FormField(
                              controller: _swapController,
                              hintText: '0.00',
                              cs: cs,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: spacing),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _FieldLabel(cs: cs, label: 'COMMISSION'),
                            SizedBox(height: 8 + spacing / 2),
                            _FormField(
                              controller: _commissionController,
                              hintText: '0.00',
                              cs: cs,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 32 + spacing),
                ],

                // ── Save Trade Button ────────────────────────
                GestureDetector(
                  onTap: _handleSave,
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
                        'Save Trade',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: cs.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPositionTypeToggle(ColorScheme cs) {
    return Row(
      children: [
        _PillToggle(
          label: 'Closed',
          selected: _isClosed,
          cs: cs,
          selectedColor: cs.onPrimary,
          selectedBgColor: cs.primary,
          onTap: () => setState(() => _isClosed = true),
        ),
        const SizedBox(width: 8),
        _PillToggle(
          label: 'Open',
          selected: !_isClosed,
          cs: cs,
          selectedColor: cs.onPrimary,
          selectedBgColor: cs.primary,
          onTap: () => setState(() => _isClosed = false),
        ),
      ],
    );
  }

  Widget _buildSideToggle(ColorScheme cs) {
    return Row(
      children: [
        _PillToggle(
          label: 'BUY',
          selected: _side == TradeSide.buy,
          cs: cs,
          selectedColor: cs.tertiary,
          selectedBgColor: cs.tertiaryContainer.withValues(alpha: 0.3),
          onTap: () => setState(() => _side = TradeSide.buy),
        ),
        const SizedBox(width: 8),
        _PillToggle(
          label: 'SELL',
          selected: _side == TradeSide.sell,
          cs: cs,
          selectedColor: cs.error,
          selectedBgColor: cs.errorContainer.withValues(alpha: 0.3),
          onTap: () => setState(() => _side = TradeSide.sell),
        ),
      ],
    );
  }

  Widget _buildDateTimePicker(ColorScheme cs, DateTime current, ValueChanged<DateTime> onChanged) {
    return GestureDetector(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: current,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: cs,
              ),
              child: child!,
            );
          },
        );
        if (date != null) {
          if (!mounted) return;
          final time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(current),
          );
          if (time != null && mounted) {
            onChanged(DateTime(
              date.year, date.month, date.day,
              time.hour, time.minute,
            ));
            setState(() {});
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: cs.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today_outlined, size: 18, color: cs.onSurfaceVariant),
            const SizedBox(width: 12),
            Text(
              '${current.day.toString().padLeft(2, '0')}/${current.month.toString().padLeft(2, '0')}/${current.year} '
              '${current.hour.toString().padLeft(2, '0')}:${current.minute.toString().padLeft(2, '0')}',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: cs.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReasonDropdown(ColorScheme cs) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<CloseReason>(
          value: _reason,
          isExpanded: true,
          icon: Icon(Icons.expand_more, color: cs.onSurfaceVariant),
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: cs.onSurface,
          ),
          items: CloseReason.values.map((reason) {
            return DropdownMenuItem(
              value: reason,
              child: Text(reason.description),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) setState(() => _reason = value);
          },
        ),
      ),
    );
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    // Get current user
    final user = ref.read(authStateProvider);
    if (user == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You must be logged in to add trades')),
        );
      }
      return;
    }

    final userId = user.id;
    const uuid = Uuid();
    final now = DateTime.now();

    try {
      final repo = ref.read(tradeCommandRepositoryProvider);

      if (_isClosed) {
        // Create ClosedPosition
        final position = ClosedPosition(
          id: uuid.v4(),
          userId: userId,
          symbol: _symbolController.text.toUpperCase(),
          openTime: _openTime,
          closeTime: _closeTime,
          volume: double.parse(_volumeController.text),
          side: _side,
          openPrice: double.parse(_openPriceController.text),
          closePrice: double.parse(_closePriceController.text),
          stopLoss: _stopLossController.text.isEmpty
              ? null
              : double.tryParse(_stopLossController.text),
          takeProfit: _takeProfitController.text.isEmpty
              ? null
              : double.tryParse(_takeProfitController.text),
          swap: _swapController.text.isEmpty
              ? 0.0
              : double.parse(_swapController.text),
          commission: _commissionController.text.isEmpty
              ? 0.0
              : double.parse(_commissionController.text),
          profit: _side.calculateProfit(
            double.parse(_openPriceController.text),
            double.parse(_closePriceController.text),
            double.parse(_volumeController.text),
          ),
          reason: _reason,
          createdAt: now,
          updatedAt: now,
          isSynced: false,
        );

        final result = await repo.addClosedPosition(position);
        if (result.isFailure && mounted) {
          throw Exception(result.error);
        }
      } else {
        // Create OpenPosition
        final position = OpenPosition(
          id: uuid.v4(),
          userId: userId,
          symbol: _symbolController.text.toUpperCase(),
          openTime: _openTime,
          volume: double.parse(_volumeController.text),
          side: _side,
          openPrice: double.parse(_openPriceController.text),
          currentPrice: null, // Will be set by market data
          stopLoss: _stopLossController.text.isEmpty
              ? null
              : double.tryParse(_stopLossController.text),
          takeProfit: _takeProfitController.text.isEmpty
              ? null
              : double.tryParse(_takeProfitController.text),
          swap: _swapController.text.isEmpty
              ? 0.0
              : double.parse(_swapController.text),
          commission: _commissionController.text.isEmpty
              ? 0.0
              : double.parse(_commissionController.text),
          profit: 0.0, // No floating P/L at creation
          createdAt: now,
          updatedAt: now,
          isSynced: false,
        );

        final result = await repo.addOpenPosition(position);
        if (result.isFailure && mounted) {
          throw Exception(result.error);
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${_isClosed ? 'Closed' : 'Open'} position saved (${_symbolController.text} ${_side.name})',
            ),
            backgroundColor: Theme.of(context).colorScheme.tertiary,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving position: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }
}

// ───────────────────────────────────────────────────────────────
// Reusable widgets
// ───────────────────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  final ColorScheme cs;
  final String label;

  const _FieldLabel({required this.cs, required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.8,
        color: cs.onSurfaceVariant,
      ),
    );
  }
}

class _FormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ColorScheme cs;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  const _FormField({
    required this.controller,
    required this.hintText,
    required this.cs,
    this.validator,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      style: GoogleFonts.inter(fontSize: 14, color: cs.onSurface),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.inter(fontSize: 14, color: cs.onSurfaceVariant),
        filled: true,
        fillColor: cs.surfaceContainerLow,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cs.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cs.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}

class _PillToggle extends StatelessWidget {
  final String label;
  final bool selected;
  final ColorScheme cs;
  final Color? selectedColor;
  final Color? selectedBgColor;
  final VoidCallback onTap;

  const _PillToggle({
    required this.label,
    required this.selected,
    required this.cs,
    this.selectedColor,
    this.selectedBgColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = selected
        ? (selectedBgColor ?? cs.primaryContainer)
        : cs.surfaceContainerHigh;
    final textColor = selected
        ? (selectedColor ?? cs.onPrimaryContainer)
        : cs.onSurfaceVariant;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(9999),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
