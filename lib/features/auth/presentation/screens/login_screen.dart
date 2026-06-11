

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:praktix/features/auth/presentation/screens/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    setState(() => _isSubmitting = true);

    await Future.delayed(const Duration(milliseconds: 1200));

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Login successful.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    const accent = Color(0xFF0F5C63);
    final textMuted = theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.72) ??
        scheme.onSurface.withValues(alpha: 0.72);

    return Scaffold(
      backgroundColor: scheme.surface,
      body: Stack(
        children: [
          const Positioned.fill(
            child: _LoginBackground(),
          ),

          Positioned(
            top: -80,
            left: -50,
            child: _AmbientGlow(
              size: 250,
              color: accent.withValues(alpha: 0.08),
            ),
          ),
          Positioned(
            bottom: -100,
            right: -70,
            child: _AmbientGlow(
              size: 280,
              color: const Color(0xFFB8C4CC).withValues(alpha: 0.18),
            ),
          ),
          Positioned(
            top: 180,
            right: -20,
            child: _AmbientGlow(
              size: 170,
              color: const Color(0xFF0EA5E9).withValues(alpha: 0.06),
            ),
          ),

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
                                color: Colors.white.withValues(alpha: 0.72),
                                width: 1.1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 36,
                                  offset: const Offset(0, 20),
                                ),
                                BoxShadow(
                                  color: accent.withValues(alpha: 0.07),
                                  blurRadius: 30,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  top: -14,
                                  left: -10,
                                  right: -10,
                                  child: IgnorePointer(
                                    child: Container(
                                      height: 90,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(24),
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.white.withValues(alpha: 0.58),
                                            Colors.white.withValues(alpha: 0.02),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _LoginHeader(
                                      accent: accent,
                                      mutedColor: textMuted,
                                    ),
                                    const SizedBox(height: 28),
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
                                            validator: (value) {
                                              if (value == null || value.trim().isEmpty) {
                                                return 'Enter your email address';
                                              }
                                              final email = value.trim();
                                              final emailRegex = RegExp(
                                                r'^[\w\.\-]+@([\w\-]+\.)+[a-zA-Z]{2,}$',
                                              );
                                              if (!emailRegex.hasMatch(email)) {
                                                return 'Enter a valid email address';
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(height: 18),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Password',
                                                style: theme.textTheme.labelLarge?.copyWith(
                                                  color: textMuted,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {},
                                                style: TextButton.styleFrom(
                                                  foregroundColor: accent,
                                                  padding: EdgeInsets.zero,
                                                  minimumSize: Size.zero,
                                                  tapTargetSize:
                                                  MaterialTapTargetSize.shrinkWrap,
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
                                            obscureText: _obscurePassword,
                                            prefixIcon: Icons.lock_outline_rounded,
                                            textInputAction: TextInputAction.done,
                                            suffixIcon: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  _obscurePassword = !_obscurePassword;
                                                });
                                              },
                                              icon: Icon(
                                                _obscurePassword
                                                    ? Icons.visibility_off_rounded
                                                    : Icons.visibility_rounded,
                                              ),
                                            ),
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return 'Enter your password';
                                              }
                                              if (value.length < 8) {
                                                return 'Password should be at least 8 characters';
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(height: 26),
                                          SizedBox(
                                            width: double.infinity,
                                            child: FilledButton(
                                              onPressed: _isSubmitting ? null : _submit,
                                              style: FilledButton.styleFrom(
                                                backgroundColor: accent,
                                                foregroundColor: Colors.white,
                                                disabledBackgroundColor:
                                                accent.withValues(alpha: 0.45),
                                                padding: const EdgeInsets.symmetric(vertical: 18),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(18),
                                                ),
                                                elevation: 0,
                                              ),
                                              child: AnimatedSwitcher(
                                                duration: const Duration(milliseconds: 220),
                                                child: _isSubmitting
                                                    ? const SizedBox(
                                                  key: ValueKey('loader'),
                                                  width: 20,
                                                  height: 20,
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 2.2,
                                                    valueColor:
                                                    AlwaysStoppedAnimation<Color>(
                                                      Colors.white,
                                                    ),
                                                  ),
                                                )
                                                    : Row(
                                                  key: const ValueKey('text'),
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  children: const [
                                                    Text('Login'),
                                                    SizedBox(width: 10),
                                                    Icon(
                                                      Icons.arrow_forward_rounded,
                                                      size: 20,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 18),
                                          Center(
                                            child: Wrap(
                                              alignment: WrapAlignment.center,
                                              crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                              children: [
                                                Text(
                                                  "Don't have an account?",
                                                  style: theme.textTheme.bodyMedium?.copyWith(
                                                    color: textMuted,
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () {},
                                                  style: TextButton.styleFrom(
                                                    foregroundColor: accent,
                                                    padding: const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4,
                                                    ),
                                                  ),
                                                  child: TextButton(onPressed: () {
                                                    Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (_) => const RegistrationScreen(),
                                                      ),
                                                    );
                                                  },
                                                  child: const Text('Register')),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
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
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              foregroundColor:
                              theme.colorScheme.onSurface.withValues(alpha: 0.55),
                            ),
                            child: const Text('Privacy Policy'),
                          ),
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              foregroundColor:
                              theme.colorScheme.onSurface.withValues(alpha: 0.55),
                            ),
                            child: const Text('Terms of Service'),
                          ),
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

class _LoginBackground extends StatelessWidget {
  const _LoginBackground();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF6F4EF),
            Color(0xFFF4F1EB),
            Color(0xFFEEEBE4),
          ],
        ),
      ),
      child: CustomPaint(
        painter: _NoiseGridPainter(),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _BrandHeader extends StatelessWidget {
  const _BrandHeader({
    required this.mutedColor,
  });

  final Color mutedColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          'Only Experts',
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.6,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'by Praktix',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: mutedColor,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}

class _LoginHeader extends StatelessWidget {
  const _LoginHeader({
    required this.accent,
    required this.mutedColor,
  });

  final Color accent;
  final Color mutedColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: accent.withValues(alpha: 0.10),
            border: Border.all(
              color: accent.withValues(alpha: 0.18),
            ),
          ),
          child: Icon(
            Icons.lock_person_outlined,
            color: accent,
            size: 26,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Join the Expert Economy',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Sign in to access premium content and professional networks.',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: mutedColor,
            height: 1.55,
          ),
        ),
      ],
    );
  }
}

class _GlassTextField extends StatelessWidget {
  const _GlassTextField({
    required this.controller,
    required this.label,
    required this.hintText,
    required this.prefixIcon,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.suffixIcon,
  });

  final TextEditingController controller;
  final String label;
  final String hintText;
  final IconData prefixIcon;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      style: theme.textTheme.bodyLarge,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: Icon(
          prefixIcon,
          size: 20,
          color: theme.colorScheme.outline,
        ),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.58),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.16),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: Color(0xFF0F5C63),
            width: 1.25,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: theme.colorScheme.error.withValues(alpha: 0.85),
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: theme.colorScheme.error,
            width: 1.25,
          ),
        ),
      ),
    );
  }
}

class _AmbientGlow extends StatelessWidget {
  const _AmbientGlow({
    required this.size,
    required this.color,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color,
              blurRadius: size * 0.55,
              spreadRadius: size * 0.10,
            ),
          ],
        ),
      ),
    );
  }
}

class _NoiseGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF0F172A).withValues(alpha: 0.025)
      ..strokeWidth = 1;

    const spacing = 32.0;

    for (double x = 0; x <= size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (double y = 0; y <= size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}