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
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    final initialState = ref.read(registerControllerProvider);
    _firstNameController = TextEditingController(text: initialState.firstName);
    _lastNameController = TextEditingController(text: initialState.lastName);
    _emailController = TextEditingController(text: initialState.email);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _onRegister() {
    ref.read(registerControllerProvider.notifier).register();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(registerControllerProvider.select((s) => s.registrationStatus), (
      previous,
      next,
    ) {
      if (next is AsyncData && next.value == null && previous is AsyncLoading) {
        ref.read(routerProvider).goNamed('main');
      } else if (next is AsyncError) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.error.toString())));
      }
    });

    final state = ref.watch(registerControllerProvider);
    final isLoading = state.registrationStatus.isLoading;

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
                  errorText: state.firstNameError,
                  onChanged: (val) => ref
                      .read(registerControllerProvider.notifier)
                      .updateFirstName(val),
                ),

                const SizedBox(height: 24),

                // Last Name
                RegisterTextField(
                  label: 'Last Name',
                  controller: _lastNameController,
                  hintText: 'Doe',
                  errorText: state.lastNameError,
                  onChanged: (val) => ref
                      .read(registerControllerProvider.notifier)
                      .updateLastName(val),
                ),

                const SizedBox(height: 24),

                RegisterTextField(
                  label: 'Email',
                  controller: _emailController,
                  hintText: 'jane@example.com',
                  errorText: state.emailError,
                  onChanged: (val) => ref
                      .read(registerControllerProvider.notifier)
                      .updateEmail(val),
                  suffixIcon: state.isEmailValid
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
                  value: state.use24HourFormat,
                  onChanged: (value) {
                    ref
                        .read(registerControllerProvider.notifier)
                        .set24HourFormat(value);
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
