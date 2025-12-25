import 'package:flutter/material.dart';
import '../register_colors.dart';

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
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: value
                    ? RegisterColors.primaryGreen
                    : RegisterColors.textGrey.withValues(alpha: 0.5),
                width: 1.5,
              ),
              color: value
                  ? RegisterColors.primaryGreen.withValues(alpha: 0.1)
                  : Colors.transparent,
            ),
            child: value
                ? Center(
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: RegisterColors.primaryGreen,
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 12),
          const Text(
            'Use 24-hour time format',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
