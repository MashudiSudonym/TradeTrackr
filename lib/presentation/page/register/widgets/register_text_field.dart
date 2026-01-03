import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class RegisterTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hintText;
  final Widget? suffixIcon;
  final String? errorText;

  const RegisterTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.hintText,
    this.suffixIcon,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.p.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        ShadInput(
          controller: controller,
          placeholder: Text(hintText),
          trailing: suffixIcon,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: ShadDecoration(
            border: ShadBorder.all(
              color: errorText != null
                  ? theme.colorScheme.destructive
                  : Colors.white.withValues(alpha: 0.1),
              width: 1,
            ),
            focusedBorder: ShadBorder.all(
              color: errorText != null
                  ? theme.colorScheme.destructive
                  : theme.colorScheme.primary,
              width: 1,
            ),
            color: Colors.white.withValues(alpha: 0.05),
          ),
          style: const TextStyle(color: Colors.white),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 4),
          Text(
            errorText!,
            style: theme.textTheme.muted.copyWith(
              color: theme.colorScheme.destructive,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }
}
