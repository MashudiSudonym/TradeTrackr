import 'package:flutter/material.dart';
import '../register_colors.dart';

class RegisterTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hintText;
  final Widget? suffixIcon;

  const RegisterTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.hintText,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: RegisterColors.inputFillColor,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: RegisterColors.inputBorderColor),
          ),
          child: TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                color: RegisterColors.textGrey.withValues(alpha: 0.5),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
              suffixIcon: suffixIcon,
            ),
          ),
        ),
      ],
    );
  }
}
