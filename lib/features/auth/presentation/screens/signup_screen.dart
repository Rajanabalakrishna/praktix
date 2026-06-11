


import 'dart:ui';
import 'package:flutter/material.dart';

import 'login_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _acceptedTerms = false;
  UserType _selectedUserType = UserType.learner;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    if (!_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept the Terms of Service and Privacy Policy.'),
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    await Future.delayed(const Duration(milliseconds: 1200));

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Account created as ${_selectedUserType.label}.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final surface = scheme.surface;
    final surfaceContainer = theme.cardColor;
    final textMuted = theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.72) ??
        scheme.onSurface.withValues(alpha: 0.72);

    final accent = isDark ? const Color(0xFF4F98A3) : const Color(0xFF0F5C63);
    final accentSoft = accent.withValues(alpha: isDark ? 0.18 : 0.10);

    return Scaffold(
      backgroundColor: scheme.surface,
      body: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? const [
                    Color(0xFF0F1112),
                    Color(0xFF151819),
                    Color(0xFF1B2022),
                  ]
                      : const [
                    Color(0xFFF6F4EF),
                    Color(0xFFF4F1EB),
                    Color(0xFFEEEBE4),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            top: -80,
            left: -40,
            child: _AmbientGlow(
              size: 240,
              color: accent.withValues(alpha: isDark ? 0.12 : 0.08),
            ),
          ),
          Positioned(
            bottom: -100,
            right: -60,
            child: _AmbientGlow(
              size: 280,
              color: const Color(0xFFB8C4CC).withValues(alpha: isDark ? 0.10 : 0.16),
            ),
          ),
          Positioned(
            top: 160,
            right: -30,
            child: _AmbientGlow(
              size: 180,
              color: accentSoft,
            ),
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: ClipRRect(
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
                            colors: isDark
                                ? [
                              Colors.white.withValues(alpha: 0.10),
                              Colors.white.withValues(alpha: 0.05),
                            ]
                                : [
                              Colors.white.withValues(alpha: 0.68),
                              Colors.white.withValues(alpha: 0.42),
                            ],
                          ),
                          border: Border.all(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.14)
                                : Colors.white.withValues(alpha: 0.70),
                            width: 1.1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: isDark ? 0.22 : 0.08),
                              blurRadius: 36,
                              offset: const Offset(0, 20),
                            ),
                            BoxShadow(
                              color: accent.withValues(alpha: 0.08),
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
                                        Colors.white.withValues(alpha: isDark ? 0.12 : 0.55),
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
                                _HeaderBlock(
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
                                        controller: _nameController,
                                        label: 'Full name',
                                        textInputAction: TextInputAction.next,
                                        validator: (value) {
                                          if (value == null || value.trim().isEmpty) {
                                            return 'Enter your full name';
                                          }
                                          if (value.trim().length < 3) {
                                            return 'Name should be at least 3 characters';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 16),
                                      _GlassTextField(
                                        controller: _emailController,
                                        label: 'Email address',
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
                                      const SizedBox(height: 16),
                                      _GlassTextField(
                                        controller: _passwordController,
                                        label: 'Password',
                                        obscureText: _obscurePassword,
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
                                      const SizedBox(height: 22),
                                      Text(
                                        'Joining as',
                                        style: theme.textTheme.labelLarge?.copyWith(
                                          color: textMuted,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.2,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      _RoleSegmentedControl(
                                        selected: _selectedUserType,
                                        onChanged: (value) {
                                          setState(() => _selectedUserType = value);
                                        },
                                      ),
                                      const SizedBox(height: 18),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Transform.translate(
                                            offset: const Offset(-6, -6),
                                            child: Checkbox(
                                              value: _acceptedTerms,
                                              onChanged: (value) {
                                                setState(() {
                                                  _acceptedTerms = value ?? false;
                                                });
                                              },
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                              side: BorderSide(
                                                color: scheme.outline.withValues(alpha: 0.55),
                                              ),
                                              activeColor: accent,
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(top: 2),
                                              child: RichText(
                                                text: TextSpan(
                                                  style: theme.textTheme.bodyMedium?.copyWith(
                                                    color: textMuted,
                                                    height: 1.5,
                                                  ),
                                                  children: [
                                                    const TextSpan(
                                                      text: 'I agree to the ',
                                                    ),
                                                    TextSpan(
                                                      text: 'Terms of Service',
                                                      style: theme.textTheme.bodyMedium?.copyWith(
                                                        color: accent,
                                                        fontWeight: FontWeight.w700,
                                                      ),
                                                    ),
                                                    const TextSpan(text: ' and '),
                                                    TextSpan(
                                                      text: 'Privacy Policy',
                                                      style: theme.textTheme.bodyMedium?.copyWith(
                                                        color: accent,
                                                        fontWeight: FontWeight.w700,
                                                      ),
                                                    ),
                                                    const TextSpan(text: '.'),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
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
                                                Text('Create account'),
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
                                            Text(
                                              'Already have an account?',
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
                                              child:TextButton(
                                                onPressed: ()
                                                {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (_) => const LoginScreen(),
                                                    ),
                                                  );
                                                },
                                                child: Text(
                                                  'Sign in',
                                                  style: theme.textTheme.bodyLarge?.copyWith(
                                                   color: Colors.blue,
                                                    height: 1.55,
                                                  ),
                                                ),
                                              ),
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
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum UserType {
  learner('Learner'),
  professional('Professional'),
  expert('Expert');

  const UserType(this.label);
  final String label;
}

class _HeaderBlock extends StatelessWidget {
  const _HeaderBlock({
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
            Icons.verified_outlined,
            color: accent,
            size: 26,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Only Experts',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.6,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Join a refined network of experts, professionals, and serious learners.',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: mutedColor,
            height: 1.55,
          ),
        ),
      ],
    );
  }
}

class _RoleSegmentedControl extends StatelessWidget {
  const _RoleSegmentedControl({
    required this.selected,
    required this.onChanged,
  });

  final UserType selected;
  final ValueChanged<UserType> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final accent = isDark ? const Color(0xFF4F98A3) : const Color(0xFF0F5C63);

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: theme.colorScheme.onSurface.withValues(alpha: isDark ? 0.06 : 0.045),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.12),
        ),
      ),
      child: Row(
        children: UserType.values.map((type) {
          final active = selected == type;

          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(type),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: active
                      ? (isDark
                      ? Colors.white.withValues(alpha: 0.10)
                      : Colors.white.withValues(alpha: 0.88))
                      : Colors.transparent,
                  border: active
                      ? Border.all(color: accent.withValues(alpha: 0.16))
                      : null,
                  boxShadow: active
                      ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.12 : 0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                      : null,
                ),
                child: Text(
                  type.label,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: active
                        ? accent
                        : theme.colorScheme.onSurface.withValues(alpha: 0.70),
                    fontWeight: active ? FontWeight.w700 : FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _GlassTextField extends StatelessWidget {
  const _GlassTextField({
    required this.controller,
    required this.label,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.suffixIcon,
  });

  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      style: theme.textTheme.bodyLarge,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: isDark
            ? Colors.white.withValues(alpha: 0.06)
            : Colors.white.withValues(alpha: 0.58),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.16),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: (isDark ? const Color(0xFF4F98A3) : const Color(0xFF0F5C63))
                .withValues(alpha: 0.90),
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