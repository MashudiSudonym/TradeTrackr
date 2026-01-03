import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trade_trackr/presentation/provider/register/register_controller.dart';

import 'package:trade_trackr/presentation/provider/router/router_provider.dart';
import 'register_colors.dart';
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

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _onRegister() {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final email = _emailController.text.trim();

    if (firstName.isEmpty || lastName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in required fields')),
      );
      return;
    }

    ref
        .read(registerControllerProvider.notifier)
        .register(
          firstName: firstName,
          lastName: lastName,
          email: email.isEmpty ? null : email,
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
        backgroundColor: RegisterColors.backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
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
                const Text(
                  'Hey',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Nice to meet you',
                  style: TextStyle(
                    color: RegisterColors.textGrey,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 32),

                // First Name
                RegisterTextField(
                  label: 'First Name',
                  controller: _firstNameController,
                  hintText: 'Jane',
                ),

                const SizedBox(height: 20),

                // Last Name
                RegisterTextField(
                  label: 'Last Name',
                  controller: _lastNameController,
                  hintText: 'Doe',
                ),

                const SizedBox(height: 20),

                // Email
                RegisterTextField(
                  label: 'Email',
                  controller: _emailController,
                  hintText: 'jane@example.com',
                  suffixIcon: Container(
                    margin: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: RegisterColors.primaryGreen,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.black,
                      size: 16,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Checkbox option
                RegisterCheckbox(
                  value: _use24HourFormat,
                  onChanged: (value) {
                    setState(() {
                      _use24HourFormat = value;
                    });
                  },
                ),

                const SizedBox(height: 40),

                // Register Button
                RegisterButton(
                  isLoading: isLoading,
                  onPressed: isLoading ? null : _onRegister,
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
