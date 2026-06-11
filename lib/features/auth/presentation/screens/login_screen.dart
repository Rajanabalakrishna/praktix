import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:praktix/features/auth/domain/usecases/sign_in_usecase.dart';
//import 'package:praktix/features/auth/presentation/providers/auth_notifier.dart';
import 'package:praktix/features/auth/presentation/providers/auth_providers.dart';
import 'package:praktix/features/home/presentation/screens/home_screen.dart';
import '../providers/auth_notifiers.dart';
import 'signup_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await ref.read(authNotifierProvider.notifier).signIn(
      SignInParams(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      ),
    );
  }

  void _handleAuthState(AsyncValue<AuthState> next) {
    next.whenData((state) {
      if (state is AuthAuthenticated) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          ref.read(authNotifierProvider.notifier).resetState();
          Navigator.of(context).pushAndRemoveUntil(
            _fadeRoute(const HomeScreen()),
                (_) => false,
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    ref.listen(authNotifierProvider, (_, next) => _handleAuthState(next));

    final isLoading = authState.isLoading;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    const accent = Color(0xFF0F5C63);
    final textMuted = scheme.onSurface.withValues(alpha: 0.72);

    return Scaffold(
      backgroundColor: scheme.surface,
      body: Stack(
        children: [
          const Positioned.fill(child: _LoginBackground()),
          Positioned(top: -80, left: -50,
              child: _AmbientGlow(size: 250, color: accent.withValues(alpha: 0.08))),
          Positioned(bottom: -100, right: -70,
              child: _AmbientGlow(size: 280,
                  color: const Color(0xFFB8C4CC).withValues(alpha: 0.18))),
          Positioned(top: 180, right: -20,
              child: _AmbientGlow(size: 170,
                  color: const Color(0xFF0EA5E9).withValues(alpha: 0.06))),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      _BrandHeader(mutedColor: textMuted),
                      const SizedBox(height: 24),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(28),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(28),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.white.withValues(alpha: 0.68),
                                  Colors.white.withValues(alpha: 0.42),
                                ],
                              ),
                              border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.72), width: 1.1),
                              boxShadow: [
                                BoxShadow(color: Colors.black.withValues(alpha: 0.08),
                                    blurRadius: 36, offset: const Offset(0, 20)),
                                BoxShadow(color: accent.withValues(alpha: 0.07),
                                    blurRadius: 30, offset: const Offset(0, 8)),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _LoginHeader(accent: accent, mutedColor: textMuted),
                                const SizedBox(height: 28),

                                // Error banner
                                if (authState.hasValue && authState.value is AuthError) ...[
                                  _ErrorBanner(
                                    message: (authState.value as AuthError).message,
                                    onDismiss: () =>
                                        ref.read(authNotifierProvider.notifier).resetState(),
                                  ),
                                  const SizedBox(height: 16),
                                ],

                                Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _GlassTextField(
                                        controller: _emailController,
                                        label: 'Email address',
                                        hintText: 'expert@example.com',
                                        prefixIcon: Icons.mail_outline_rounded,
                                        keyboardType: TextInputType.emailAddress,
                                        textInputAction: TextInputAction.next,
                                        validator: (v) {
                                          if (v == null || v.trim().isEmpty) return 'Enter your email address';
                                          if (!RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[a-zA-Z]{2,}$')
                                              .hasMatch(v.trim())) return 'Enter a valid email address';
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 18),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Password',
                                              style: theme.textTheme.labelLarge?.copyWith(
                                                  color: textMuted, fontWeight: FontWeight.w600)),
                                          TextButton(
                                            onPressed: () {},
                                            style: TextButton.styleFrom(
                                              foregroundColor: accent,
                                              padding: EdgeInsets.zero,
                                              minimumSize: Size.zero,
                                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                            ),
                                            child: const Text('Forgot password?'),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      _GlassTextField(
                                        controller: _passwordController,
                                        label: 'Password',
                                        hintText: '••••••••',
                                        prefixIcon: Icons.lock_outline_rounded,
                                        obscureText: _obscurePassword,
                                        textInputAction: TextInputAction.done,
                                        suffixIcon: IconButton(
                                          onPressed: () => setState(
                                                  () => _obscurePassword = !_obscurePassword),
                                          icon: Icon(_obscurePassword
                                              ? Icons.visibility_off_rounded
                                              : Icons.visibility_rounded),
                                        ),
                                        validator: (v) {
                                          if (v == null || v.isEmpty) return 'Enter your password';
                                          if (v.length < 8) return 'Password must be at least 8 characters';
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 26),
                                      SizedBox(
                                        width: double.infinity,
                                        child: FilledButton(
                                          onPressed: isLoading ? null : _submit,
                                          style: FilledButton.styleFrom(
                                            backgroundColor: accent,
                                            foregroundColor: Colors.white,
                                            disabledBackgroundColor: accent.withValues(alpha: 0.45),
                                            padding: const EdgeInsets.symmetric(vertical: 18),
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(18)),
                                            elevation: 0,
                                          ),
                                          child: AnimatedSwitcher(
                                            duration: const Duration(milliseconds: 220),
                                            child: isLoading
                                                ? const SizedBox(
                                                key: ValueKey('loader'),
                                                width: 20, height: 20,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2.2,
                                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                                ))
                                                : const Row(
                                              key: ValueKey('text'),
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text('Sign in'),
                                                SizedBox(width: 10),
                                                Icon(Icons.arrow_forward_rounded, size: 20),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 18),
                                      Center(
                                        child: Wrap(
                                          alignment: WrapAlignment.center,
                                          crossAxisAlignment: WrapCrossAlignment.center,
                                          children: [
                                            Text("Don't have an account?",
                                                style: theme.textTheme.bodyMedium?.copyWith(color: textMuted)),
                                            TextButton(
                                              onPressed: isLoading
                                                  ? null
                                                  : () => Navigator.of(context)
                                                  .pushReplacement(_fadeRoute(const RegistrationScreen())),
                                              style: TextButton.styleFrom(
                                                foregroundColor: accent,
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                              ),
                                              child: const Text('Register'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 20,
                        children: [
                          TextButton(onPressed: () {},
                              style: TextButton.styleFrom(
                                  foregroundColor: scheme.onSurface.withValues(alpha: 0.55)),
                              child: const Text('Privacy Policy')),
                          TextButton(onPressed: () {},
                              style: TextButton.styleFrom(
                                  foregroundColor: scheme.onSurface.withValues(alpha: 0.55)),
                              child: const Text('Terms of Service')),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

PageRoute<T> _fadeRoute<T>(Widget page) => PageRouteBuilder<T>(
  pageBuilder: (_, __, ___) => page,
  transitionsBuilder: (_, anim, __, child) =>
      FadeTransition(opacity: anim, child: child),
  transitionDuration: const Duration(milliseconds: 280),
);

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message, required this.onDismiss});
  final String message;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: scheme.errorContainer,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: scheme.error.withValues(alpha: 0.30)),
        ),
        child: Row(
          children: [
            Icon(Icons.error_outline_rounded, color: scheme.onErrorContainer, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(message,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onErrorContainer, height: 1.4)),
            ),
            const SizedBox(width: 8),
            GestureDetector(
                onTap: onDismiss,
                child: Icon(Icons.close_rounded, color: scheme.onErrorContainer, size: 18)),
          ],
        ),
      ),
    );
  }
}

class _LoginBackground extends StatelessWidget {
  const _LoginBackground();
  @override
  Widget build(BuildContext context) => const DecoratedBox(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFF6F4EF), Color(0xFFF4F1EB), Color(0xFFEEEBE4)],
      ),
    ),
  );
}

class _BrandHeader extends StatelessWidget {
  const _BrandHeader({required this.mutedColor});
  final Color mutedColor;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(children: [
      Text('Only Experts', textAlign: TextAlign.center,
          style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800, letterSpacing: -0.6)),
      const SizedBox(height: 6),
      Text('by Praktix', textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge?.copyWith(color: mutedColor, height: 1.4)),
    ]);
  }
}

class _LoginHeader extends StatelessWidget {
  const _LoginHeader({required this.accent, required this.mutedColor});
  final Color accent;
  final Color mutedColor;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        width: 52, height: 52,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: accent.withValues(alpha: 0.10),
          border: Border.all(color: accent.withValues(alpha: 0.18)),
        ),
        child: Icon(Icons.lock_person_outlined, color: accent, size: 26),
      ),
      const SizedBox(height: 20),
      Text('Welcome back',
          style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700, letterSpacing: -0.4)),
      const SizedBox(height: 10),
      Text('Sign in to access premium content and professional networks.',
          style: theme.textTheme.bodyLarge?.copyWith(color: mutedColor, height: 1.55)),
    ]);
  }
}

class _GlassTextField extends StatelessWidget {
  const _GlassTextField({
    required this.controller, required this.label, required this.prefixIcon,
    this.hintText, this.validator, this.keyboardType, this.textInputAction,
    this.obscureText = false, this.suffixIcon,
  });
  final TextEditingController controller;
  final String label;
  final String? hintText;
  final IconData prefixIcon;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const accent = Color(0xFF0F5C63);
    return TextFormField(
      controller: controller, validator: validator, keyboardType: keyboardType,
      textInputAction: textInputAction, obscureText: obscureText,
      style: theme.textTheme.bodyLarge,
      decoration: InputDecoration(
        labelText: label, hintText: hintText,
        prefixIcon: Icon(prefixIcon, size: 20, color: theme.colorScheme.outline),
        suffixIcon: suffixIcon, filled: true,
        fillColor: Colors.white.withValues(alpha: 0.58),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(color: theme.colorScheme.outline.withValues(alpha: 0.16))),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: accent, width: 1.25)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(color: theme.colorScheme.error.withValues(alpha: 0.85))),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(color: theme.colorScheme.error, width: 1.25)),
      ),
    );
  }
}

class _AmbientGlow extends StatelessWidget {
  const _AmbientGlow({required this.size, required this.color});
  final double size;
  final Color color;
  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: Container(
      width: size, height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(
            color: color, blurRadius: size * 0.55, spreadRadius: size * 0.10)],
      ),
    ),
  );
}