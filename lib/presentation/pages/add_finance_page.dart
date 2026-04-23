import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

import '../../core/extensions/context_extensions.dart';
import '../../domain/entities/finance_record.dart';
import '../../domain/enums/finance_type.dart';
import '../widgets/responsive/responsive.dart';
import '../providers/auth_provider.dart';
import '../providers/di_providers.dart';

/// Add Finance Record page — form for creating deposit/withdrawal records.
class AddFinancePage extends ConsumerStatefulWidget {
  const AddFinancePage({super.key});

  @override
  ConsumerState<AddFinancePage> createState() => _AddFinancePageState();
}

class _AddFinancePageState extends ConsumerState<AddFinancePage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _statusController = TextEditingController();
  final _paymentGatewayController = TextEditingController();
  final _detailsController = TextEditingController();

  FinanceType _type = FinanceType.deposit;
  DateTime _time = DateTime.now();

  @override
  void dispose() {
    _amountController.dispose();
    _statusController.dispose();
    _paymentGatewayController.dispose();
    _detailsController.dispose();
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
          'Add Finance Record',
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
                // ── Type Toggle ─────────────────────────────────
                _FieldLabel(cs: cs, label: 'TYPE'),
                SizedBox(height: 8 + spacing / 2),
                _buildTypeToggle(cs),
                SizedBox(height: 24 + spacing),

                // ── Time ────────────────────────────────────────
                _FieldLabel(cs: cs, label: 'TIME'),
                SizedBox(height: 8 + spacing / 2),
                _buildDateTimePicker(cs, _time, (dt) => _time = dt),
                SizedBox(height: 20 + spacing),

                // ── Amount ───────────────────────────────────────
                _FieldLabel(cs: cs, label: 'AMOUNT'),
                SizedBox(height: 8 + spacing / 2),
                _FormField(
                  controller: _amountController,
                  hintText: '0.00',
                  cs: cs,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Amount is required';
                    if (double.tryParse(v) == null) return 'Enter a valid number';
                    return null;
                  },
                ),
                SizedBox(height: 20 + spacing),

                // ── Status ──────────────────────────────────────
                _FieldLabel(cs: cs, label: 'STATUS'),
                SizedBox(height: 8 + spacing / 2),
                _FormField(
                  controller: _statusController,
                  hintText: 'Done',
                  cs: cs,
                  validator: (v) => (v == null || v.isEmpty) ? 'Status is required' : null,
                ),
                SizedBox(height: 20 + spacing),

                // ── Payment Gateway ─────────────────────────────
                _FieldLabel(cs: cs, label: 'PAYMENT GATEWAY'),
                SizedBox(height: 8 + spacing / 2),
                _FormField(
                  controller: _paymentGatewayController,
                  hintText: 'Manual, Bank Transfer, etc.',
                  cs: cs,
                  validator: (v) => (v == null || v.isEmpty) ? 'Payment gateway is required' : null,
                ),
                SizedBox(height: 20 + spacing),

                // ── Details (Optional) ──────────────────────────
                _FieldLabel(cs: cs, label: 'DETAILS (OPTIONAL)'),
                SizedBox(height: 8 + spacing / 2),
                _FormField(
                  controller: _detailsController,
                  hintText: 'Additional notes...',
                  cs: cs,
                  maxLines: 3,
                ),
                SizedBox(height: 32 + spacing),

                // ── Save Button ─────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _handleSave,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                      backgroundColor: cs.primary,
                    ),
                    child: Text(
                      'Save Record',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: cs.onPrimary,
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

  Widget _buildTypeToggle(ColorScheme cs) {
    return Row(
      children: [
        _PillToggle(
          label: 'Deposit',
          selected: _type == FinanceType.deposit,
          cs: cs,
          selectedColor: cs.tertiary,
          selectedBgColor: cs.tertiaryContainer.withValues(alpha: 0.3),
          onTap: () => setState(() => _type = FinanceType.deposit),
        ),
        const SizedBox(width: 8),
        _PillToggle(
          label: 'Withdrawal',
          selected: _type == FinanceType.withdrawal,
          cs: cs,
          selectedColor: cs.error,
          selectedBgColor: cs.errorContainer.withValues(alpha: 0.3),
          onTap: () => setState(() => _type = FinanceType.withdrawal),
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
              data: Theme.of(context).copyWith(colorScheme: cs),
              child: child!,
            );
          },
        );
        if (date != null && mounted) {
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

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    final user = ref.read(authStateProvider);
    if (user == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You must be logged in to add records')),
        );
      }
      return;
    }

    try {
      final repo = ref.read(tradeCommandRepositoryProvider);
      final now = DateTime.now();
      final record = FinanceRecord(
        id: const Uuid().v4(),
        userId: user.id,
        type: _type,
        time: _time,
        amount: double.parse(_amountController.text),
        status: _statusController.text,
        paymentGateway: _paymentGatewayController.text,
        details: _detailsController.text.isEmpty ? '' : _detailsController.text,
        createdAt: now,
        updatedAt: now,
        isSynced: false,
      );

      final result = await repo.addFinanceRecord(record);
      if (result.isFailure && mounted) {
        throw Exception(result.error);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${_type.name} record saved'),
            backgroundColor: Theme.of(context).colorScheme.tertiary,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving record: $e'),
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
        letterSpacing: 0.05,
        color: cs.onSurfaceVariant,
      ),
    );
  }
}

class _FormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ColorScheme cs;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final int? maxLines;

  const _FormField({
    required this.controller,
    required this.hintText,
    required this.cs,
    this.keyboardType,
    this.validator,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      maxLines: maxLines,
      style: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: cs.onSurface,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: cs.onSurfaceVariant,
        ),
        filled: true,
        fillColor: cs.surfaceContainerLow,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
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
  final Color selectedColor;
  final Color selectedBgColor;
  final VoidCallback onTap;

  const _PillToggle({
    required this.label,
    required this.selected,
    required this.cs,
    required this.selectedColor,
    required this.selectedBgColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? selectedBgColor : cs.surfaceContainer,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: selected ? selectedColor : cs.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
