import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:praktix/core/theme/app_theme.dart';
import 'package:praktix/features/programs/domain/entities/program_entity.dart';
import 'program_meta_chip.dart';

class ProgramGlassCard extends StatelessWidget {
  final ProgramEntity program;
  final VoidCallback? onTap;

  const ProgramGlassCard({
    super.key,
    required this.program,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withOpacity(0.35)
                  : cs.secondary.withOpacity(0.07),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withOpacity(0.05)
                    : Colors.white.withOpacity(0.70),
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withOpacity(0.10)
                      : Colors.white.withOpacity(0.80),
                  width: 1,
                ),
                // Subtle shimmer gradient
                gradient: isDark
                    ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.08),
                    Colors.white.withOpacity(0.02),
                  ],
                )
                    : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.90),
                    Colors.white.withOpacity(0.55),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Thumbnail ──────────────────────────────────────
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(AppRadius.lg)),
                    child: SizedBox(
                      height: 130,
                      width: double.infinity,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CachedNetworkImage(
                            imageUrl: program.thumbnailUrl,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => Container(
                              color: isDark
                                  ? const Color(0xFF1A1A2E)
                                  : const Color(0xFFEEF2FF),
                            ),
                            errorWidget: (_, __, ___) => Container(
                              color: isDark
                                  ? const Color(0xFF1A1A2E)
                                  : const Color(0xFFEEF2FF),
                              child: Icon(
                                Icons.school_rounded,
                                size: 40,
                                color: isDark
                                    ? Colors.white12
                                    : cs.secondary.withOpacity(0.2),
                              ),
                            ),
                          ),
                          // Gradient over thumbnail
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.40),
                                ],
                              ),
                            ),
                          ),
                          // Category icon top-left
                          Positioned(
                            top: 10,
                            left: 10,
                            child: _CategoryIcon(
                                category: program.category, colors: colors),
                          ),
                          // Paid badge top-right
                          if (program.isPaid)
                            Positioned(
                              top: 10,
                              right: 10,
                              child: _PaidBadge(colors: colors),
                            ),
                        ],
                      ),
                    ),
                  ),

                  // ── Content ────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          program.title,
                          style: GoogleFonts.hankenGrotesk(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? Colors.white
                                : cs.onSurface,
                            height: 1.25,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),

                        // Instructor
                        Text(
                          program.instructorName,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: isDark
                                ? Colors.white54
                                : cs.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 10),

                        // Meta chips
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: [
                            ProgramMetaChip(
                              icon: Icons.schedule_rounded,
                              label: program.duration,
                            ),
                            if (program.hasCertificate)
                              ProgramMetaChip(
                                icon: Icons.verified_rounded,
                                label: 'Cert',
                                iconColor: colors.expertVerify,
                              ),
                            if (program.rating != null)
                              ProgramMetaChip(
                                icon: Icons.star_rounded,
                                label: program.rating!.toStringAsFixed(1),
                                iconColor: colors.premiumGold,
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Action button
                        SizedBox(
                          width: double.infinity,
                          child: _GlassButton(
                            label: program.isPaid
                                ? 'Unlock Access'
                                : 'View Details',
                            isPrimary: program.isPaid,
                            cs: cs,
                            isDark: isDark,
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
    );
  }
}

// ── Category Icon Pill ────────────────────────────────────────────────
class _CategoryIcon extends StatelessWidget {
  final ProgramCategory category;
  final AppColors colors;

  const _CategoryIcon({required this.category, required this.colors});

  @override
  Widget build(BuildContext context) {
    final (icon, color) = switch (category) {
      ProgramCategory.ai           => (Icons.auto_awesome_rounded, const Color(0xFF4B41E1)),
      ProgramCategory.cybersecurity=> (Icons.shield_rounded, const Color(0xFF0EA5E9)),
      ProgramCategory.mobile       => (Icons.phone_android_rounded, const Color(0xFF22C55E)),
      ProgramCategory.leadership   => (Icons.emoji_events_rounded, const Color(0xFFB45309)),
      ProgramCategory.data         => (Icons.bar_chart_rounded, const Color(0xFFEC4899)),
    };

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.45),
            borderRadius: BorderRadius.circular(AppRadius.sm),
            border: Border.all(
              color: Colors.white.withOpacity(0.15),
            ),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
      ),
    );
  }
}

// ── Paid Badge ────────────────────────────────────────────────────────
class _PaidBadge extends StatelessWidget {
  final AppColors colors;
  const _PaidBadge({required this.colors});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.full),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding:
          const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: colors.premiumGoldSurface.withOpacity(0.88),
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
          child: Text(
            'PREMIUM',
            style: GoogleFonts.inter(
              fontSize: 9,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
              color: colors.premiumGold,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Glass CTA Button ──────────────────────────────────────────────────
class _GlassButton extends StatelessWidget {
  final String label;
  final bool isPrimary;
  final ColorScheme cs;
  final bool isDark;

  const _GlassButton({
    required this.label,
    required this.isPrimary,
    required this.cs,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isPrimary
                ? (isDark
                ? Colors.white.withOpacity(0.14)
                : cs.secondary.withOpacity(0.90))
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.sm),
            border: Border.all(
              color: isPrimary
                  ? (isDark
                  ? Colors.white.withOpacity(0.20)
                  : cs.secondary.withOpacity(0.60))
                  : (isDark
                  ? Colors.white.withOpacity(0.15)
                  : cs.secondary.withOpacity(0.40)),
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isPrimary
                    ? Colors.white
                    : (isDark ? Colors.white70 : cs.secondary),
                letterSpacing: 0.3,
              ),
            ),
          ),
        ),
      ),
    );
  }
}