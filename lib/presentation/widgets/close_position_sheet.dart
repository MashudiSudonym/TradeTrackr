import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/open_position.dart';
import '../../domain/enums/close_reason.dart';
import 'form_field_label.dart';
import 'primary_button.dart';

/// Bottom sheet form to close an open position.
///
/// Shows close price, close time, and close reason fields with
/// auto-calculated profit display. Follows the "Curated Ledger"
/// design system with tonal layering and no borders/shadows.
class ClosePositionSheet extends StatefulWidget {
  const ClosePositionSheet({
    super.key,
    required this.position,
    this.onConfirm,
  });

  final OpenPosition position;
  final void Function({
    required double closePrice,
    required DateTime closeTime,
    required CloseReason reason,
  })? onConfirm;

  @override
  State<ClosePositionSheet> createState() => _ClosePositionSheetState();
}

class _ClosePositionSheetState extends State<ClosePositionSheet> {
  late TextEditingController _closePriceController;
  late DateTime _closeTime;
  CloseReason _reason = CloseReason.user;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _closePriceController = TextEditingController(
      text: widget.position.currentPrice?.toStringAsFixed(5) ?? '',
    );
    _closeTime = DateTime.now();
  }

  @override
  void dispose() {
    _closePriceController.dispose();
    super.dispose();
  }

  double get _calculatedProfit {
    final closePrice = double.tryParse(_closePriceController.text);
    if (closePrice == null) return 0.0;
    return widget.position.side.calculateProfit(
      widget.position.openPrice,
      closePrice,
      widget.position.volume,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: cs.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Title
            Row(
              children: [
                Text(
                  'Close Position',
                  style: GoogleFonts.manrope(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: cs.primary.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    widget.position.symbol,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: cs.primary,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Close Price
            const FormFieldLabel(label: 'Close Price'),
            TextFormField(
              controller: _closePriceController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Close price is required';
                if (double.tryParse(v) == null) return 'Enter a valid number';
                return null;
              },
              onChanged: (_) => setState(() {}),
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: cs.onSurface,
              ),
              decoration: InputDecoration(
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
                  borderSide: BorderSide(color: cs.primary, width: 2),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: cs.error, width: 1.5),
                ),
                hintText: '0.00000',
                hintStyle: GoogleFonts.inter(
                  fontSize: 14,
                  color: cs.outline,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),

            const SizedBox(height: 16),

            // Close Time
            const FormFieldLabel(label: 'Close Time'),
            GestureDetector(
              onTap: _pickDateTime,
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.access_time, size: 18, color: cs.onSurfaceVariant),
                    const SizedBox(width: 8),
                    Text(
                      DateFormat('dd MMM yyyy, HH:mm').format(_closeTime),
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: cs.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Close Reason
            const FormFieldLabel(label: 'Close Reason'),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: cs.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(9999),
              ),
              child: Row(
                children: CloseReason.values.map((reason) {
                  final isSelected = reason == _reason;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _reason = reason),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? cs.primary : Colors.transparent,
                          borderRadius: BorderRadius.circular(9999),
                        ),
                        child: Center(
                          child: Text(
                            reason.name,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                              color: isSelected
                                  ? cs.onPrimary
                                  : cs.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),

            // Auto-calculated profit
            _buildProfitDisplay(cs),

            const SizedBox(height: 20),

            // Buttons
            PrimaryButton(
              label: 'Confirm Close',
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  widget.onConfirm?.call(
                    closePrice: double.parse(_closePriceController.text),
                    closeTime: _closeTime,
                    reason: _reason,
                  );
                  Navigator.of(context).pop();
                }
              },
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Center(
                child: Text(
                  'Cancel',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfitDisplay(ColorScheme cs) {
    final profit = _calculatedProfit;
    final isProfit = profit >= 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'ESTIMATED PROFIT',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.8,
              color: cs.onSurfaceVariant,
            ),
          ),
          Text(
            '${isProfit ? '+' : ''}${profit.toStringAsFixed(2)}',
            style: GoogleFonts.manrope(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: isProfit ? cs.tertiary : cs.error,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _closeTime,
      firstDate: widget.position.openTime,
      lastDate: DateTime.now(),
    );

    if (date == null) return;

    if (!mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_closeTime),
    );

    if (time == null) return;

    setState(() {
      _closeTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }
}

/// Shows the [ClosePositionSheet] as a modal bottom sheet.
Future<void> showClosePositionSheet(
  BuildContext context, {
  required OpenPosition position,
  void Function({
    required double closePrice,
    required DateTime closeTime,
    required CloseReason reason,
  })? onConfirm,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => ClosePositionSheet(
      position: position,
      onConfirm: onConfirm,
    ),
  );
}
