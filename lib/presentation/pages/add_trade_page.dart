import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../domain/enums/close_reason.dart';
import '../../domain/enums/trade_side.dart';
import '../../app/theme/app_colors.dart';

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Position Type Toggle ──────────────────────
              _buildPositionTypeToggle(cs),

              const SizedBox(height: 24),

              // ── Symbol ───────────────────────────────────
              _FieldLabel(cs: cs, label: 'SYMBOL'),
              const SizedBox(height: 8),
              _FormField(
                controller: _symbolController,
                hintText: 'e.g., BTCUSD, EURUSD',
                cs: cs,
                validator: (v) => (v == null || v.isEmpty) ? 'Symbol is required' : null,
              ),
              const SizedBox(height: 20),

              // ── Side Toggle ──────────────────────────────
              _FieldLabel(cs: cs, label: 'SIDE'),
              const SizedBox(height: 8),
              _buildSideToggle(cs),
              const SizedBox(height: 20),

              // ── Volume ───────────────────────────────────
              _FieldLabel(cs: cs, label: 'VOLUME (LOTS)'),
              const SizedBox(height: 8),
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
              const SizedBox(height: 20),

              // ── Open Price ───────────────────────────────
              _FieldLabel(cs: cs, label: 'OPEN PRICE'),
              const SizedBox(height: 8),
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
              const SizedBox(height: 20),

              // ── Open Time ────────────────────────────────
              _FieldLabel(cs: cs, label: 'OPEN TIME'),
              const SizedBox(height: 8),
              _buildDateTimePicker(cs, _openTime, (dt) => _openTime = dt),
              const SizedBox(height: 20),

              // ── Close Price & Time (if closed) ───────────
              if (_isClosed) ...[
                _FieldLabel(cs: cs, label: 'CLOSE PRICE'),
                const SizedBox(height: 8),
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
                const SizedBox(height: 20),

                _FieldLabel(cs: cs, label: 'CLOSE TIME'),
                const SizedBox(height: 8),
                _buildDateTimePicker(cs, _closeTime, (dt) => _closeTime = dt),
                const SizedBox(height: 20),

                // ── Reason ─────────────────────────────────
                _FieldLabel(cs: cs, label: 'CLOSE REASON'),
                const SizedBox(height: 8),
                _buildReasonDropdown(cs),
                const SizedBox(height: 20),
              ],

              // ── Stop Loss ────────────────────────────────
              _FieldLabel(cs: cs, label: 'STOP LOSS (OPTIONAL)'),
              const SizedBox(height: 8),
              _FormField(
                controller: _stopLossController,
                hintText: '0.00',
                cs: cs,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 20),

              // ── Take Profit ──────────────────────────────
              _FieldLabel(cs: cs, label: 'TAKE PROFIT (OPTIONAL)'),
              const SizedBox(height: 8),
              _FormField(
                controller: _takeProfitController,
                hintText: '0.00',
                cs: cs,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 20),

              // ── Swap ─────────────────────────────────────
              _FieldLabel(cs: cs, label: 'SWAP'),
              const SizedBox(height: 8),
              _FormField(
                controller: _swapController,
                hintText: '0.00',
                cs: cs,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 20),

              // ── Commission ───────────────────────────────
              _FieldLabel(cs: cs, label: 'COMMISSION'),
              const SizedBox(height: 8),
              _FormField(
                controller: _commissionController,
                hintText: '0.00',
                cs: cs,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 32),

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
    );
  }

  Widget _buildPositionTypeToggle(ColorScheme cs) {
    return Row(
      children: [
        _PillToggle(
          label: 'Closed',
          selected: _isClosed,
          cs: cs,
          onTap: () => setState(() => _isClosed = true),
        ),
        const SizedBox(width: 8),
        _PillToggle(
          label: 'Open',
          selected: !_isClosed,
          cs: cs,
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
          selectedColor: cs.onTertiaryContainer,
          selectedBgColor: cs.tertiaryContainer,
          onTap: () => setState(() => _side = TradeSide.buy),
        ),
        const SizedBox(width: 8),
        _PillToggle(
          label: 'SELL',
          selected: _side == TradeSide.sell,
          cs: cs,
          selectedColor: cs.onErrorContainer,
          selectedBgColor: cs.errorContainer,
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

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement save via trade command repository
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
