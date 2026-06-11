import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OnlyExpertsSplashView extends StatefulWidget {
  final Widget nextScreen;
  final Duration minimumDuration;

  const OnlyExpertsSplashView({
    super.key,
    required this.nextScreen,
    this.minimumDuration = const Duration(seconds: 2),
  });

  @override
  State<OnlyExpertsSplashView> createState() => _OnlyExpertsSplashViewState();
}

class _OnlyExpertsSplashViewState extends State<OnlyExpertsSplashView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _progressController;
  Timer? _doneTimer;

  static const _bg = Color(0xFFFFF8F6);
  static const _surfaceDim = Color(0xFFEFD4D0);
  static const _onSurfaceVariant = Color(0xFF5A403C);
  static const _surfaceTrack = Color(0xFFF8DCD8);
  static const _midnightNavy = Color(0xFF0F172A);
  static const _deepCrimson = Color(0xFF8B0000);

  @override
  void initState() {
    super.initState();

    _progressController = AnimationController(
      vsync: this,
      duration: widget.minimumDuration,
    )..forward();

    _doneTimer = Timer(widget.minimumDuration, () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => widget.nextScreen,
        ),
      );
    });
  }

  @override
  void dispose() {
    _doneTimer?.cancel();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width >= 768;

    return Scaffold(
      backgroundColor: _bg,
      body: Stack(
        children: [
          const Positioned.fill(child: _SplashBackground()),
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: RepaintBoundary(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const _LogoBlock(),
                      const SizedBox(height: 32),
                      Text(
                        'Only Experts',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.sourceSerif4(
                          fontSize: isDesktop ? 48 : 32,
                          height: isDesktop ? 1.16 : 1.25,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.4,
                          color: _midnightNavy,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'by',
                            style: GoogleFonts.hankenGrotesk(
                              fontSize: 16,
                              height: 1.5,
                              color: _onSurfaceVariant.withValues(alpha: 0.7),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Praktix',
                            style: GoogleFonts.sourceSerif4(
                              fontSize: 22,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.3,
                              color: _midnightNavy,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 48),
                      _ProgressSection(
                        controller: _progressController,
                        trackColor: _surfaceTrack,
                        fillColor: _deepCrimson,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (isDesktop)
            const Positioned(
              right: 48,
              bottom: 48,
              child: RepaintBoundary(child: _StatusPanel()),
            ),
        ],
      ),
    );
  }
}

class _SplashBackground extends StatelessWidget {
  const _SplashBackground();

  static const _bg = Color(0xFFFFF8F6);
  static const _surfaceDim = Color(0xFFEFD4D0);

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 0.95,
          colors: [_surfaceDim, _bg, _bg],
          stops: [0.0, 0.55, 1.0],
        ),
      ),
    );
  }
}

class _LogoBlock extends StatelessWidget {
  const _LogoBlock();

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width >= 768;
    final logoSize = isDesktop ? 160.0 : 128.0;

    return SizedBox(
      width: logoSize,
      height: logoSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: logoSize * 1.15,
            height: logoSize * 1.15,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF8B0000).withValues(alpha: 0.06),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF8B0000).withValues(alpha: 0.08),
                  blurRadius: 48,
                  spreadRadius: 10,
                ),
              ],
            ),
          ),
          Image.asset(
            'assets/images/logo.jpeg',
            width: logoSize,
            height: logoSize,
            fit: BoxFit.contain,
            filterQuality: FilterQuality.medium,
            cacheWidth: isDesktop ? 320 : 256,
            errorBuilder: (_, __, ___) => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class _ProgressSection extends StatelessWidget {
  final Animation<double> controller;
  final Color trackColor;
  final Color fillColor;

  const _ProgressSection({
    required this.controller,
    required this.trackColor,
    required this.fillColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 128,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: SizedBox(
              height: 3,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ColoredBox(color: trackColor),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: AnimatedBuilder(
                        animation: controller,
                        builder: (context, _) {
                          return FractionallySizedBox(
                            widthFactor: controller.value.clamp(0.0, 1.0),
                            child: ColoredBox(color: fillColor),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'INITIALIZING',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 12,
              height: 1.33,
              letterSpacing: 2,
              fontWeight: FontWeight.w600,
              color: fillColor.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusPanel extends StatelessWidget {
  const _StatusPanel();

  static const _midnightNavy = Color(0xFF0F172A);
  static const _onSurfaceVariant = Color(0xFF5A403C);
  static const _deepCrimson = Color(0xFF8B0000);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 24),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: _onSurfaceVariant.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'PLATFORM STATUS',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 12,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w500,
                  color: _onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Encrypted Connection',
                style: GoogleFonts.hankenGrotesk(
                  fontSize: 16,
                  color: _midnightNavy,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          const Icon(
            Icons.verified_user_rounded,
            color: _deepCrimson,
            size: 22,
          ),
        ],
      ),
    );
  }
}