import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../app/theme/app_colors.dart';
import '../../core/extensions/context_extensions.dart';
import '../providers/auth_provider.dart';

/// Forgot password page — full screen, no bottom navigation.
///
/// Centered layout with logo, heading, email input,
/// send reset link button, and navigation link to login.
class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: context.horizontalPadding),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                  // ── Logo ───────────────────────────────────
                  Center(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Trade',
                            style: GoogleFonts.manrope(
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              color: cs.onSurface,
                            ),
                          ),
                          TextSpan(
                            text: 'Trackr',
                            style: GoogleFonts.manrope(
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              color: cs.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),

                  // ── Heading ────────────────────────────────
                  Text(
                    'Forgot Password',
                    style: GoogleFonts.manrope(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: cs.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Enter your email to receive a password reset link',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: cs.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // ── Email Field ────────────────────────────
                  _FieldLabel(cs: cs, label: 'EMAIL'),
                  const SizedBox(height: 8),
                  _TextFormField(
                    controller: _emailController,
                    hintText: 'alex@example.com',
                    cs: cs,
                    enabled: !_isLoading,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is required';
                      }
                      if (!value.contains('@')) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),

                  // ── Send Reset Link Button ─────────────────
                  GestureDetector(
                    onTap: _isLoading ? null : _handleResetPassword,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        gradient: _isLoading
                            ? null
                            : const LinearGradient(
                                colors: [AppColors.primary, AppColors.primaryDim],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                stops: [0.0, 1.0],
                                transform: GradientRotation(135 * 3.14159 / 180),
                              ),
                        color: _isLoading ? cs.surfaceContainerLow : null,
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      child: Center(
                        child: _isLoading
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(cs.primary),
                                ),
                              )
                            : Text(
                                'Send Reset Link',
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: cs.onPrimary,
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Login Link ─────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Remember your password? ',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                      GestureDetector(
                        onTap: _isLoading ? null : () => context.go('/login'),
                        child: Text(
                          'Log In',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: _isLoading ? cs.onSurfaceVariant.withValues(alpha: 0.5) : cs.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
                ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleResetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final email = _emailController.text.trim();

        await ref.read(authProvider.notifier).resetPassword(email);

        if (mounted) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Password reset link sent! Check your email.'),
              backgroundColor: AppColors.success,
              duration: Duration(seconds: 2),
            ),
          );

          // Navigate to login
          context.go('/login');
        }
      } catch (e) {
        if (mounted) {
          // Show error message
          final theme = Theme.of(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Reset failed: ${e.toString()}'),
              backgroundColor: theme.colorScheme.error,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }
}

// ───────────────────────────────────────────────────────────────
// Reusable form field helpers
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

class _TextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ColorScheme cs;
  final String? Function(String?)? validator;
  final bool enabled;
  final TextInputType? keyboardType;

  const _TextFormField({
    required this.controller,
    required this.hintText,
    required this.cs,
    this.validator,
    this.enabled = true,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      enabled: enabled,
      validator: validator,
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
