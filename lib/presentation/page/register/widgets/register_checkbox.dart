import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class RegisterCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const RegisterCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ShadSwitch(
      value: value,
      onChanged: onChanged,
      label: Text(
        'Use 24-hour time format',
        style: ShadTheme.of(context).textTheme.p.copyWith(color: Colors.white),
      ),
    );
  }
}
