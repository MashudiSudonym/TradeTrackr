import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../app/theme/app_colors.dart';
import '../providers/auth_provider.dart';

/// Register page — full screen, no bottom navigation.
///
/// Centered layout with display name, email, password, confirm password,
/// sign up button, and navigation link to login.
class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _displayNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _displayNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
            padding: const EdgeInsets.symmetric(horizontal: 24),
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

                  // ── Create Account ─────────────────────────
                  Text(
                    'Create Account',
                    style: GoogleFonts.manrope(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: cs.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Start tracking your trading performance',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: cs.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // ── Display Name ───────────────────────────
                  _FieldLabel(cs: cs, label: 'DISPLAY NAME'),
                  const SizedBox(height: 8),
                  _TextFormField(
                    controller: _displayNameController,
                    hintText: 'Alex Rivers',
                    cs: cs,
                    enabled: !_isLoading,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Display name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // ── Email ──────────────────────────────────
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
                  const SizedBox(height: 20),

                  // ── Password ───────────────────────────────
                  _FieldLabel(cs: cs, label: 'PASSWORD'),
                  const SizedBox(height: 8),
                  _TextFormField(
                    controller: _passwordController,
                    hintText: 'Min. 6 characters',
                    cs: cs,
                    enabled: !_isLoading,
                    obscureText: _obscurePassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                    suffixIcon: GestureDetector(
                      onTap: _isLoading ? null : () => setState(() => _obscurePassword = !_obscurePassword),
                      child: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        color: cs.onSurfaceVariant,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Confirm Password ───────────────────────
                  _FieldLabel(cs: cs, label: 'CONFIRM PASSWORD'),
                  const SizedBox(height: 8),
                  _TextFormField(
                    controller: _confirmPasswordController,
                    hintText: 'Re-enter your password',
                    cs: cs,
                    enabled: !_isLoading,
                    obscureText: _obscureConfirm,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Confirm your password';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                    suffixIcon: GestureDetector(
                      onTap: _isLoading ? null : () => setState(() => _obscureConfirm = !_obscureConfirm),
                      child: Icon(
                        _obscureConfirm ? Icons.visibility_off : Icons.visibility,
                        color: cs.onSurfaceVariant,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // ── Sign Up Button ─────────────────────────
                  GestureDetector(
                    onTap: _isLoading ? null : _handleRegister,
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
                                'Sign Up',
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
                        'Already have an account? ',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                      GestureDetector(
                        onTap: _isLoading ? null : () => context.go('/login'),
                        child: Text(
                          'Sign In',
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
    );
  }

  Future<void> _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final displayName = _displayNameController.text.trim();
        final email = _emailController.text.trim();
        final password = _passwordController.text;

        await ref.read(authProvider.notifier).register(displayName, email, password);

        if (mounted) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Registration successful!'),
              backgroundColor: AppColors.success,
              duration: Duration(seconds: 2),
            ),
          );

          // Navigate to dashboard
          context.go('/');
        }
      } catch (e) {
        if (mounted) {
          // Show error message
          final theme = Theme.of(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Registration failed: ${e.toString()}'),
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
  final bool obscureText;
  final bool enabled;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;

  const _TextFormField({
    required this.controller,
    required this.hintText,
    required this.cs,
    this.validator,
    this.obscureText = false,
    this.enabled = true,
    this.keyboardType,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
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
        suffixIcon: suffixIcon,
      ),
    );
  }
}
