import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class RegisterButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;

  const RegisterButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ShadButton(
      width: double.infinity,
      height: 56,
      onPressed: isLoading ? null : onPressed,
      trailing: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.black,
              ),
            )
          : const Icon(LucideIcons.arrowRight, size: 20),
      child: const Text('Register'),
    );
  }
}
