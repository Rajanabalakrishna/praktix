import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:praktix/core/theme/app_theme.dart';
import 'package:praktix/features/programs/data/mock/programs_mock_data.dart';
import 'package:praktix/features/programs/domain/entities/program_entity.dart';
import 'package:praktix/features/programs/presentation/widgets/featured_program_card.dart';
import 'package:praktix/features/programs/presentation/widgets/program_glass_card.dart';

class ProgramsScreen extends StatelessWidget {
  const ProgramsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;

    final featured = ProgramsMockData.programs
        .where((p) => p.isFeatured)
        .toList();
    final rest = ProgramsMockData.programs
        .where((p) => !p.isFeatured)
        .toList();

    return Scaffold(
      backgroundColor: cs.surface,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── App Bar ──────────────────────────────────────────────
          SliverAppBar(
            floating: true,
            snap: true,
            pinned: false,
            expandedHeight: 0,
            toolbarHeight: 64,
            backgroundColor: cs.surface.withOpacity(0.80),
            surfaceTintColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  color: cs.surface.withOpacity(0.80),
                  border: Border(
                    bottom: BorderSide(
                      color: isDark
                          ? Colors.white.withOpacity(0.06)
                          : cs.outlineVariant.withOpacity(0.40),
                    ),
                  ),
                ),
              ),
            ),
            title: Text(
              'Elite Programs',
              style: isDark
                  ? GoogleFonts.playfairDisplay(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
                color: cs.onSurface,
              )
                  : GoogleFonts.hankenGrotesk(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: cs.onSurface,
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.tune_rounded),
                color: cs.onSurfaceVariant,
                onPressed: () {},
              ),
            ],
          ),

          // ── Content ───────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.pageMargin,
              AppSpacing.lg,
              AppSpacing.pageMargin,
              AppSpacing.xxxl,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Header text
                Text(
                  'Accelerate your trajectory',
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge
                      ?.copyWith(height: 1.2),
                ),
                const SizedBox(height: 6),
                Text(
                  'Immersive courses taught by vetted industry leaders.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.xl),

                // ── Featured programs ────────────────────────────
                if (featured.isNotEmpty) ...[
                  _SectionLabel(label: 'Featured'),
                  const SizedBox(height: AppSpacing.md),
                  ...featured.map(
                        (p) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: FeaturedProgramCard(
                        program: p,
                        onTap: () => _snack(context,
                            'Opening ${p.title}...'),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                ],

                // ── All Programs grid ────────────────────────────
                _SectionLabel(label: 'All Programs'),
                const SizedBox(height: AppSpacing.md),
                _ProgramsGrid(programs: rest),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  void _snack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm)),
      ),
    );
  }
}

// ── Section Label ─────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        Container(
          width: 3,
          height: 18,
          decoration: BoxDecoration(
            color: isDark
                ? Theme.of(context).colorScheme.onSurface
                : Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.hankenGrotesk(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}

// ── Responsive 2-col grid ─────────────────────────────────────────────
class _ProgramsGrid extends StatelessWidget {
  final List<ProgramEntity> programs;
  const _ProgramsGrid({required this.programs});

  @override
  Widget build(BuildContext context) {
    // Build 2-column grid manually to stay sliver-compatible
    final rows = <Widget>[];
    for (int i = 0; i < programs.length; i += 2) {
      rows.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ProgramGlassCard(
                program: programs[i],
                onTap: () {},
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: i + 1 < programs.length
                  ? ProgramGlassCard(
                program: programs[i + 1],
                onTap: () {},
              )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      );
      if (i + 2 < programs.length) {
        rows.add(const SizedBox(height: AppSpacing.md));
      }
    }
    return Column(children: rows);
  }
}