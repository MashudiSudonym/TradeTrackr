import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:trade_trackr/presentation/provider/register/register_controller.dart';
import 'package:trade_trackr/presentation/provider/router/router_provider.dart';
import 'widgets/register_button.dart';
import 'widgets/register_checkbox.dart';
import 'widgets/register_text_field.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _use24HourFormat = false;
  bool _showErrors = false;

  bool get _isEmailValid {
    final email = _emailController.text.trim();
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool get _isFormValid =>
      _firstNameController.text.trim().isNotEmpty &&
      _lastNameController.text.trim().isNotEmpty &&
      _isEmailValid;

  String? get _firstNameError {
    if (!_showErrors) return null;
    if (_firstNameController.text.trim().isEmpty) {
      return 'First name is required';
    }
    return null;
  }

  String? get _lastNameError {
    if (!_showErrors) return null;
    if (_lastNameController.text.trim().isEmpty) {
      return 'Last name is required';
    }
    return null;
  }

  String? get _emailError {
    if (!_showErrors) return null;
    final email = _emailController.text.trim();
    if (email.isEmpty) return 'Email is required';
    if (!_isEmailValid) return 'Invalid email format';
    return null;
  }

  @override
  void initState() {
    super.initState();
    _firstNameController.addListener(_onTextChanged);
    _lastNameController.addListener(_onTextChanged);
    _emailController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _onRegister() {
    setState(() => _showErrors = true);

    if (!_isFormValid) return;

    ref
        .read(registerControllerProvider.notifier)
        .register(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          email: _emailController.text.trim(),
          is24HourFormat: _use24HourFormat,
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(registerControllerProvider, (previous, next) {
      if (next is AsyncData) {
        ref.read(routerProvider).goNamed('main');
      } else if (next is AsyncError) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.error.toString())));
      }
    });

    final registerState = ref.watch(registerControllerProvider);
    final isLoading = registerState.isLoading;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        ref.read(routerProvider).goNamed('onboarding');
      },
      child: Scaffold(
        backgroundColor: ShadTheme.of(context).colorScheme.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              LucideIcons.arrowLeft,
              color: ShadTheme.of(context).colorScheme.foreground,
            ),
            onPressed: () {
              ref.read(routerProvider).goNamed('onboarding');
            },
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(
                  'Hey',
                  style: ShadTheme.of(context).textTheme.h1.copyWith(
                    color: ShadTheme.of(context).colorScheme.foreground,
                    fontSize: 40,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Nice to meet you',
                  style: ShadTheme.of(
                    context,
                  ).textTheme.muted.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 48),

                // First Name
                RegisterTextField(
                  label: 'First Name',
                  controller: _firstNameController,
                  hintText: 'Jane',
                  errorText: _firstNameError,
                ),

                const SizedBox(height: 24),

                // Last Name
                RegisterTextField(
                  label: 'Last Name',
                  controller: _lastNameController,
                  hintText: 'Doe',
                  errorText: _lastNameError,
                ),

                const SizedBox(height: 24),

                RegisterTextField(
                  label: 'Email',
                  controller: _emailController,
                  hintText: 'jane@example.com',
                  errorText: _emailError,
                  suffixIcon: _isEmailValid
                      ? Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: ShadTheme.of(context).colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            LucideIcons.check,
                            color: ShadTheme.of(
                              context,
                            ).colorScheme.primaryForeground,
                            size: 14,
                          ),
                        )
                      : null,
                ),

                const SizedBox(height: 32),

                // Checkbox option
                RegisterCheckbox(
                  value: _use24HourFormat,
                  onChanged: (value) {
                    setState(() {
                      _use24HourFormat = value;
                    });
                  },
                ),

                const SizedBox(height: 48),

                RegisterButton(
                  isLoading: isLoading,
                  onPressed: isLoading ? null : _onRegister,
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
