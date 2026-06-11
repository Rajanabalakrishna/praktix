import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:praktix/features/auth/domain/entities/user_entity.dart';
import 'package:praktix/features/auth/domain/usecases/sign_up_usecase.dart';
//import 'package:praktix/features/auth/presentation/providers/auth_notifier.dart';
import 'package:praktix/features/auth/presentation/providers/auth_providers.dart';
import '../providers/auth_notifiers.dart';
import 'login_screen.dart';

class RegistrationScreen extends ConsumerStatefulWidget {
  const RegistrationScreen({super.key});

  @override
  ConsumerState<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends ConsumerState<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _acceptedTerms = false;
  UserRole _selectedRole = UserRole.learner;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (!_acceptedTerms) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: const Text('Please accept the Terms of Service and Privacy Policy.'),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ));
      return;
    }
    await ref.read(authNotifierProvider.notifier).signUp(
      SignUpParams(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        role: _selectedRole,
      ),
    );
  }

  // Listen for success → navigate to LoginScreen
  void _handleAuthState(AsyncValue<AuthState> next) {
    next.whenData((state) {
      if (state is AuthAuthenticated) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          ref.read(authNotifierProvider.notifier).resetState();
          Navigator.of(context).pushReplacement(_fadeRoute(const LoginScreen()));
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
    final isDark = theme.brightness == Brightness.dark;
    final textMuted = scheme.onSurface.withValues(alpha: 0.72);
    final accent = isDark ? const Color(0xFF4F98A3) : const Color(0xFF0F5C63);

    return Scaffold(
      backgroundColor: scheme.surface,
      body: Stack(
        children: [
          // ── Background ──────────────────────────────────────────────────
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? const [Color(0xFF0F1112), Color(0xFF151819), Color(0xFF1B2022)]
                      : const [Color(0xFFF6F4EF), Color(0xFFF4F1EB), Color(0xFFEEEBE4)],
                ),
              ),
            ),
          ),
          Positioned(top: -80, left: -40,
              child: _AmbientGlow(size: 240, color: accent.withValues(alpha: isDark ? 0.12 : 0.08))),
          Positioned(bottom: -100, right: -60,
              child: _AmbientGlow(size: 280,
                  color: const Color(0xFFB8C4CC).withValues(alpha: isDark ? 0.10 : 0.16))),

          // ── Content ─────────────────────────────────────────────────────
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
                                ? [Colors.white.withValues(alpha: 0.10),
                              Colors.white.withValues(alpha: 0.05)]
                                : [Colors.white.withValues(alpha: 0.68),
                              Colors.white.withValues(alpha: 0.42)],
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
                                blurRadius: 36, offset: const Offset(0, 20)),
                            BoxShadow(
                                color: accent.withValues(alpha: 0.08),
                                blurRadius: 30, offset: const Offset(0, 8)),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _HeaderBlock(accent: accent, mutedColor: textMuted),
                            const SizedBox(height: 28),

                            // ── Inline error banner ──────────────────────
                            if (authState.hasValue && authState.value is AuthError) ...[
                              _ErrorBanner(
                                message: (authState.value as AuthError).message,
                                onDismiss: () =>
                                    ref.read(authNotifierProvider.notifier).resetState(),
                              ),
                              const SizedBox(height: 16),
                            ],

                            // ── Form ─────────────────────────────────────
                            Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _GlassTextField(
                                    controller: _nameController,
                                    label: 'Full name',
                                    prefixIcon: Icons.person_outline_rounded,
                                    textInputAction: TextInputAction.next,
                                    validator: (v) {
                                      if (v == null || v.trim().isEmpty) return 'Enter your full name';
                                      if (v.trim().length < 3) return 'Name must be at least 3 characters';
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),
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
                                          .hasMatch(v.trim())) {
                                        return 'Enter a valid email address';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),
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
                                  const SizedBox(height: 22),
                                  Text('Joining as',
                                      style: theme.textTheme.labelLarge?.copyWith(
                                          color: textMuted, fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 10),
                                  _RoleSegmentedControl(
                                    selected: _selectedRole,
                                    onChanged: (v) => setState(() => _selectedRole = v),
                                  ),
                                  const SizedBox(height: 18),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Transform.translate(
                                        offset: const Offset(-6, -6),
                                        child: Checkbox(
                                          value: _acceptedTerms,
                                          onChanged: (v) => setState(
                                                  () => _acceptedTerms = v ?? false),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(6)),
                                          side: BorderSide(
                                              color: scheme.outline.withValues(alpha: 0.55)),
                                          activeColor: accent,
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 2),
                                          child: RichText(
                                            text: TextSpan(
                                              style: theme.textTheme.bodyMedium?.copyWith(
                                                  color: textMuted, height: 1.5),
                                              children: [
                                                const TextSpan(text: 'I agree to the '),
                                                TextSpan(text: 'Terms of Service',
                                                    style: theme.textTheme.bodyMedium?.copyWith(
                                                        color: accent, fontWeight: FontWeight.w700)),
                                                const TextSpan(text: ' and '),
                                                TextSpan(text: 'Privacy Policy',
                                                    style: theme.textTheme.bodyMedium?.copyWith(
                                                        color: accent, fontWeight: FontWeight.w700)),
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
                                        Text('Already have an account?',
                                            style: theme.textTheme.bodyMedium?.copyWith(color: textMuted)),
                                        TextButton(
                                          onPressed: isLoading
                                              ? null
                                              : () => Navigator.of(context)
                                              .push(_fadeRoute(const LoginScreen())),
                                          style: TextButton.styleFrom(
                                            foregroundColor: accent,
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          ),
                                          child: const Text('Sign in'),
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
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Shared helpers (keep at bottom of file) ──────────────────────────────────

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
              child: Icon(Icons.close_rounded, color: scheme.onErrorContainer, size: 18),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderBlock extends StatelessWidget {
  const _HeaderBlock({required this.accent, required this.mutedColor});
  final Color accent;
  final Color mutedColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 52, height: 52,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: accent.withValues(alpha: 0.10),
            border: Border.all(color: accent.withValues(alpha: 0.18)),
          ),
          child: Icon(Icons.verified_outlined, color: accent, size: 26),
        ),
        const SizedBox(height: 20),
        Text('Only Experts',
            style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800, letterSpacing: -0.6)),
        const SizedBox(height: 10),
        Text('Join a refined network of experts, professionals, and serious learners.',
            style: theme.textTheme.bodyLarge?.copyWith(color: mutedColor, height: 1.55)),
      ],
    );
  }
}

class _RoleSegmentedControl extends StatelessWidget {
  const _RoleSegmentedControl({required this.selected, required this.onChanged});
  final UserRole selected;
  final ValueChanged<UserRole> onChanged;

  static const _labels = {
    UserRole.learner: 'Learner',
    UserRole.professional: 'Professional',
    UserRole.expert: 'Expert',
  };

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
        border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.12)),
      ),
      child: Row(
        children: UserRole.values.map((role) {
          final active = selected == role;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(role),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: active
                      ? (isDark ? Colors.white.withValues(alpha: 0.10)
                      : Colors.white.withValues(alpha: 0.88))
                      : Colors.transparent,
                  border: active ? Border.all(color: accent.withValues(alpha: 0.16)) : null,
                  boxShadow: active
                      ? [BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.12 : 0.04),
                      blurRadius: 12, offset: const Offset(0, 4))]
                      : null,
                ),
                child: Text(_labels[role]!,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: active ? accent
                          : theme.colorScheme.onSurface.withValues(alpha: 0.70),
                      fontWeight: active ? FontWeight.w700 : FontWeight.w600,
                    )),
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
    required this.prefixIcon,
    this.hintText,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.suffixIcon,
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
    final isDark = theme.brightness == Brightness.dark;
    final accent = isDark ? const Color(0xFF4F98A3) : const Color(0xFF0F5C63);

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
        prefixIcon: Icon(prefixIcon, size: 20, color: theme.colorScheme.outline),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: isDark
            ? Colors.white.withValues(alpha: 0.06)
            : Colors.white.withValues(alpha: 0.58),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
              color: theme.colorScheme.outline.withValues(alpha: 0.16)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: accent.withValues(alpha: 0.90), width: 1.25),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: theme.colorScheme.error.withValues(alpha: 0.85)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: theme.colorScheme.error, width: 1.25),
        ),
      ),
    );
  }
}

class _AmbientGlow extends StatelessWidget {
  const _AmbientGlow({required this.size, required this.color});
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size, height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(
            color: color,
            blurRadius: size * 0.55,
            spreadRadius: size * 0.10,
          )],
        ),
      ),
    );
  }
}