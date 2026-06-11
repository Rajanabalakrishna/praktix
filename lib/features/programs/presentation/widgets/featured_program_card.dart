import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:praktix/core/theme/app_theme.dart';
import 'package:praktix/features/programs/domain/entities/program_entity.dart';
import 'program_meta_chip.dart';

class FeaturedProgramCard extends StatelessWidget {
  final ProgramEntity program;
  final VoidCallback? onTap;

  const FeaturedProgramCard({
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
        height: 260,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withOpacity(0.50)
                  : cs.secondary.withOpacity(0.12),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // ── Thumbnail ─────────────────────────────────────────
              CachedNetworkImage(
                imageUrl: program.thumbnailUrl,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                    color: isDark
                        ? const Color(0xFF1A1A2E)
                        : const Color(0xFFEEF2FF)),
                errorWidget: (_, __, ___) => Container(
                  color: isDark
                      ? const Color(0xFF1A1A2E)
                      : const Color(0xFFEEF2FF),
                  child: Icon(Icons.school_rounded,
                      size: 64,
                      color: isDark ? Colors.white12 : cs.secondary.withOpacity(0.2)),
                ),
              ),

              // ── Gradient overlay ───────────────────────────────────
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.30),
                      Colors.black.withOpacity(0.85),
                    ],
                    stops: const [0.0, 0.45, 1.0],
                  ),
                ),
              ),

              // ── Glassmorphism info panel ───────────────────────────
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.black.withOpacity(0.45)
                            : Colors.white.withOpacity(0.20),
                        border: Border(
                          top: BorderSide(
                            color: isDark
                                ? Colors.white.withOpacity(0.10)
                                : Colors.white.withOpacity(0.50),
                            width: 1,
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Type badge
                          _TypeBadge(type: program.type, colors: colors),
                          const SizedBox(height: 8),

                          // Title
                          Text(
                            program.title,
                            style: GoogleFonts.hankenGrotesk(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              height: 1.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),

                          // Instructor
                          Text(
                            '${program.instructorName} · ${program.instructorTitle}',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.white70,
                              fontWeight: FontWeight.w400,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 12),

                          // Meta + CTA row
                          // ✅ AFTER — chips on top row, button below, never overflows
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Chips row — wraps naturally
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
                                      label: 'Certificate',
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
                              const SizedBox(height: 10),

                              // Button full width below chips
                              Align(
                                alignment: Alignment.centerRight,
                                child: _EnrollButton(
                                  isPaid: program.isPaid,
                                  colors: colors,
                                  cs: cs,
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
            ],
          ),
        ),
      ),
    );
  }
}

// ── Type Badge ────────────────────────────────────────────────────────
class _TypeBadge extends StatelessWidget {
  final ProgramType type;
  final AppColors colors;

  const _TypeBadge({required this.type, required this.colors});

  @override
  Widget build(BuildContext context) {
    final (label, icon) = switch (type) {
      ProgramType.masterclass => ('Masterclass', Icons.workspace_premium_rounded),
      ProgramType.bootcamp    => ('Bootcamp', Icons.bolt_rounded),
      ProgramType.internship  => ('Internship · Paid', Icons.work_outline_rounded),
      ProgramType.course      => ('Course', Icons.school_rounded),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: colors.premiumGoldSurface.withOpacity(0.90),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: colors.premiumGold),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
              color: colors.premiumGold,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Enroll Button ─────────────────────────────────────────────────────
class _EnrollButton extends StatelessWidget {
  final bool isPaid;
  final AppColors colors;
  final ColorScheme cs;

  const _EnrollButton({
    required this.isPaid,
    required this.colors,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withOpacity(0.15)
                : cs.secondary.withOpacity(0.80),
            borderRadius: BorderRadius.circular(AppRadius.sm),
            border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.20)
                  : Colors.white.withOpacity(0.40),
              width: 1,
            ),
          ),
          child: Text(
            isPaid ? 'Unlock Access' : 'Enroll Free',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }
}