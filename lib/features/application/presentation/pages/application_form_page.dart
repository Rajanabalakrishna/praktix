import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/theme/app_theme.dart';
import '../bloc/application_bloc.dart';
import '../bloc/application_event.dart';
import '../bloc/application_state.dart';

class ApplicationFormPage extends StatefulWidget {
  final String programTitle;
  const ApplicationFormPage({super.key, required this.programTitle});

  @override
  State<ApplicationFormPage> createState() => _ApplicationFormPageState();
}

class _ApplicationFormPageState extends State<ApplicationFormPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<ApplicationBloc>().add(
        SubmitApplicationEvent(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
          programTitle: widget.programTitle,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor ?? Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: scheme.surface.withOpacity(0.72),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: scheme.outlineVariant.withOpacity(0.5),
              ),
            ),
            child: Icon(
              Icons.arrow_back_ios_new,
              color: scheme.onSurface,
              size: 16,
            ),
          ),
        ),
        title: Text(
          'Apply Now',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ),
      body: BlocConsumer<ApplicationBloc, ApplicationState>(
        listener: (context, state) {
          if (state is ApplicationSuccess) {
            _showSuccessDialog(context, state.message);
          } else if (state is ApplicationFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.error_outline,
                        color: Colors.white, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        state.error,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                backgroundColor: scheme.error,
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ApplicationSubmitting) {
            return _buildSubmittingOverlay();
          }
          return _buildBody();
        },
      ),
    );
  }

  Widget _buildBody() {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final appColors = AppColors.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Stack(
      children: [
        Positioned(
          top: -80,
          right: -60,
          child: Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  scheme.secondary.withOpacity(isDark ? 0.18 : 0.10),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 100,
          left: -80,
          child: Container(
            width: 240,
            height: 240,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  appColors.expertVerify.withOpacity(isDark ? 0.12 : 0.08),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        FadeTransition(
          opacity: _fadeAnimation,
          child: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProgramBadge(),
                    const SizedBox(height: 28),
                    _buildHeader(),
                    const SizedBox(height: 32),
                    _buildGlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('Full Name', Icons.person_outline),
                          const SizedBox(height: 10),
                          _buildTextField(
                            controller: _nameController,
                            hint: 'e.g. Balakrishna Rajana',
                            keyboardType: TextInputType.name,
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? 'Name is required'
                                : null,
                          ),
                          const SizedBox(height: 22),
                          _buildLabel('Email Address', Icons.email_outlined),
                          const SizedBox(height: 10),
                          _buildTextField(
                            controller: _emailController,
                            hint: 'you@example.com',
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'Email is required';
                              }
                              if (!RegExp(r'^[\w.-]+@[\w.-]+\.\w+$')
                                  .hasMatch(v.trim())) {
                                return 'Enter a valid email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 22),
                          _buildLabel('Phone Number', Icons.phone_outlined),
                          const SizedBox(height: 10),
                          _buildTextField(
                            controller: _phoneController,
                            hint: '+91 98765 43210',
                            keyboardType: TextInputType.phone,
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'Phone is required';
                              }
                              if (v.trim().length < 7) {
                                return 'Enter a valid phone number';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    _buildPerksRow(),
                    const SizedBox(height: 32),
                    _buildSubmitButton(),
                    const SizedBox(height: 16),
                    Center(
                      child: Text(
                        'By submitting, you agree to our Terms & Privacy Policy.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant.withOpacity(0.75),
                          fontSize: 11,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgramBadge() {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: scheme.secondary.withOpacity(0.10),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: scheme.secondary.withOpacity(0.30),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.school_outlined,
                color: scheme.secondary,
                size: 15,
              ),
              const SizedBox(width: 7),
              Flexible(
                child: Text(
                  widget.programTitle,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: scheme.secondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.3,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Details',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "Fill in the form below. We'll get back to you within 24 hours.",
          style: theme.textTheme.bodyMedium?.copyWith(
            color: scheme.onSurfaceVariant.withOpacity(0.9),
            fontSize: 13.5,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildGlassCard({required Widget child}) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final appColors = AppColors.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: appColors.surfaceContainerLow.withOpacity(0.82),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: scheme.outlineVariant.withOpacity(0.35),
            ),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildLabel(String text, IconData icon) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Row(
      children: [
        Icon(icon, color: scheme.secondary, size: 15),
        const SizedBox(width: 7),
        Text(
          text,
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.78),
            fontSize: 13,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final appColors = AppColors.of(context);

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: scheme.onSurface,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      cursorColor: scheme.secondary,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: theme.textTheme.bodyMedium?.copyWith(
          color: scheme.onSurfaceVariant.withOpacity(0.65),
          fontSize: 13,
        ),
        filled: true,
        fillColor: appColors.surfaceContainerLowest.withOpacity(0.9),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: scheme.outlineVariant.withOpacity(0.6),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: scheme.secondary,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: scheme.error,
            width: 1.5,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: scheme.error,
            width: 1.5,
          ),
        ),
        errorStyle: theme.textTheme.bodySmall?.copyWith(
          color: scheme.error,
          fontSize: 11.5,
        ),
      ),
    );
  }

  Widget _buildPerksRow() {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final appColors = AppColors.of(context);

    final perks = [
      ('🎓', 'Certificate'),
      ('⚡', 'Fast Review'),
      ('🔒', 'Secure'),
    ];

    return Row(
      children: perks
          .map(
            (p) => Expanded(
          child: Container(
            margin: EdgeInsets.only(right: p == perks.last ? 0 : 10),
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: appColors.surfaceContainerLow.withOpacity(0.75),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: scheme.outlineVariant.withOpacity(0.35),
              ),
            ),
            child: Column(
              children: [
                Text(p.$1, style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 4),
                Text(
                  p.$2,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant.withOpacity(0.9),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      )
          .toList(),
    );
  }

  Widget _buildSubmitButton() {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.secondary,
          foregroundColor: scheme.onSecondary,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Submit Application',
              style: theme.textTheme.titleSmall?.copyWith(
                color: scheme.onSecondary,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.4,
              ),
            ),
            const SizedBox(width: 10),
            Icon(
              Icons.arrow_forward_rounded,
              color: scheme.onSecondary,
              size: 19,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmittingOverlay() {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Stack(
      children: [
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(
            color: theme.scaffoldBackgroundColor.withOpacity(0.92),
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/animations/submitting.json',
                width: 220,
                height: 220,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20),
              Text(
                'Submitting your application...',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: scheme.onSurface.withOpacity(0.9),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Please wait a moment',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant.withOpacity(0.8),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showSuccessDialog(BuildContext context, String message) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final appColors = AppColors.of(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: appColors.surfaceContainerLow.withOpacity(0.92),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: scheme.outlineVariant.withOpacity(0.35),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          scheme.secondary.withOpacity(0.22),
                          scheme.secondary.withOpacity(0.05),
                        ],
                      ),
                      border: Border.all(
                        color: scheme.secondary.withOpacity(0.45),
                        width: 1.5,
                      ),
                    ),
                    child: Icon(
                      Icons.check_rounded,
                      color: scheme.secondary,
                      size: 34,
                    ),
                  ),
                  const SizedBox(height: 22),
                  Text(
                    'Application Sent! 🎉',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant.withOpacity(0.9),
                      fontSize: 13.5,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: scheme.secondary,
                        foregroundColor: scheme.onSecondary,
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        'Done',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: scheme.onSecondary,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}