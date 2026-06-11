
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class ExpertProfileScreen extends StatelessWidget {
  const ExpertProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = AppColors.of(context);

    const expert = ExpertModel(
      name: 'Dr. Sarah Johnson',
      role: 'Senior Product & Career Mentor',
      bio:
      'Sarah helps early and mid-career professionals build strong product thinking, interview confidence, and practical execution skills. She has mentored founders, developers, and designers across startups and global teams.',
      specialization: [
        'Product Strategy',
        'Career Mentoring',
        'Interview Preparation',
        'Leadership Coaching',
      ],
      experience: '8+ Years Experience',
      profileImage:
      'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=900&q=80',
      rating: 4.9,
      sessions: 1240,
      videos: [
        VideoModel(
          title: 'How to Build a Strong Product Mindset',
          duration: '12 min',
          thumbnail:
          'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?auto=format&fit=crop&w=900&q=80',
        ),
        VideoModel(
          title: 'Mock Interview: Product Case Walkthrough',
          duration: '18 min',
          thumbnail:
          'https://images.unsplash.com/photo-1522202176988-66273c2fd55f?auto=format&fit=crop&w=900&q=80',
        ),
      ],
      programs: [
        ProgramModel(
          title: '1:1 Career Growth Program',
          subtitle: '4 weeks • Personalized roadmap',
          price: '\$149',
        ),
        ProgramModel(
          title: 'Interview Mastery Bootcamp',
          subtitle: '6 sessions • Live practice',
          price: '\$199',
        ),
        ProgramModel(
          title: 'Product Strategy Intensive',
          subtitle: '2 weeks • Real case studies',
          price: '\$129',
        ),
      ],
    );

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    elevation: 0,
                    scrolledUnderElevation: 0.5,
                    backgroundColor: theme.scaffoldBackgroundColor,
                    surfaceTintColor: Colors.transparent,
                    leading: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    ),
                    centerTitle: true,
                    title: Text(
                      'Expert Profile',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    actions: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.favorite_border_rounded),
                      ),
                      const SizedBox(width: 4),
                    ],
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.pageMargin),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _ProfileHeaderCard(expert: expert),
                          const SizedBox(height: AppSpacing.section),
                          _SectionTitle(
                            title: 'Bio',
                            actionText: null,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          _InfoCard(
                            child: Text(
                              expert.bio,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                height: 1.6,
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.section),
                          _SectionTitle(
                            title: 'Specialization',
                            actionText: null,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Wrap(
                            spacing: AppSpacing.sm,
                            runSpacing: AppSpacing.sm,
                            children: expert.specialization
                                .map(
                                  (item) => Chip(
                                label: Text(item),
                                avatar: Icon(
                                  Icons.workspace_premium_rounded,
                                  size: 16,
                                  color: theme.colorScheme.secondary,
                                ),
                              ),
                            )
                                .toList(),
                          ),
                          const SizedBox(height: AppSpacing.section),
                          _SectionTitle(
                            title: 'Experience',
                            actionText: null,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          _InfoCard(
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(AppSpacing.md),
                                  decoration: BoxDecoration(
                                    color: colors.surfaceIndigo ??
                                        theme.colorScheme.secondaryContainer
                                            .withOpacity(0.35),
                                    borderRadius:
                                    BorderRadius.circular(AppRadius.md),
                                  ),
                                  child: Icon(
                                    Icons.timeline_rounded,
                                    color: theme.colorScheme.secondary,
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.lg),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        expert.experience,
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Delivered high-impact mentoring sessions and structured learning programs.',
                                        style:
                                        theme.textTheme.bodyMedium?.copyWith(
                                          color:
                                          theme.colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: AppSpacing.section),
                          _SectionTitle(
                            title: 'Videos',
                            actionText: 'See all',
                          ),
                          const SizedBox(height: AppSpacing.md),
                          SizedBox(
                            height: 220,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: expert.videos.length,
                              separatorBuilder: (_, __) =>
                              const SizedBox(width: AppSpacing.md),
                              itemBuilder: (context, index) {
                                final video = expert.videos[index];
                                return _VideoCard(video: video);
                              },
                            ),
                          ),
                          const SizedBox(height: AppSpacing.section),
                          _SectionTitle(
                            title: 'Programs',
                            actionText: 'View all',
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Column(
                            children: expert.programs
                                .map(
                                  (program) => Padding(
                                padding: const EdgeInsets.only(
                                  bottom: AppSpacing.md,
                                ),
                                child: _ProgramCard(program: program),
                              ),
                            )
                                .toList(),
                          ),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _BottomBookingBar(expertName: expert.name),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeaderCard extends StatelessWidget {
  final ExpertModel expert;

  const _ProfileHeaderCard({required this.expert});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = AppColors.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: colors.surfaceContainerHighest,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              theme.brightness == Brightness.dark ? 0.14 : 0.06,
            ),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 48,
            backgroundImage: NetworkImage(expert.profileImage),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            expert.name,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            expert.role,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: _StatTile(
                  icon: Icons.star_rounded,
                  value: expert.rating.toString(),
                  label: 'Rating',
                  color: colors.premiumGold,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _StatTile(
                  icon: Icons.groups_rounded,
                  value: '${expert.sessions}+',
                  label: 'Sessions',
                  color: theme.colorScheme.secondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatTile({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: theme.dividerColor.withOpacity(0.7),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: AppSpacing.sm),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String? actionText;

  const _SectionTitle({
    required this.title,
    this.actionText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        if (actionText != null)
          TextButton(
            onPressed: () {},
            child: Text(actionText!),
          ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final Widget child;

  const _InfoCard({required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = AppColors.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: colors.surfaceContainerHighest),
      ),
      child: child,
    );
  }
}

class _VideoCard extends StatelessWidget {
  final VideoModel video;

  const _VideoCard({required this.video});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = AppColors.of(context);

    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: colors.surfaceContainerHighest),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppRadius.lg),
                  ),
                  child: Image.network(
                    video.thumbnail,
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned.fill(
                  child: Center(
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.45),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 16,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        video.duration,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgramCard extends StatelessWidget {
  final ProgramModel program;

  const _ProgramCard({required this.program});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = AppColors.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: colors.surfaceContainerHighest),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: theme.colorScheme.secondary.withOpacity(0.10),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(
              Icons.menu_book_rounded,
              color: theme.colorScheme.secondary,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  program.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  program.subtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            program.price,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.secondary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomBookingBar extends StatelessWidget {
  final String expertName;

  const _BottomBookingBar({required this.expertName});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = AppColors.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pageMargin,
        AppSpacing.md,
        AppSpacing.pageMargin,
        AppSpacing.pageMargin,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(color: colors.surfaceContainerHighest),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 54,
          child: FilledButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Booking session with $expertName'),
                ),
              );
            },
            icon: const Icon(Icons.calendar_month_rounded),
            label: const Text('Book Session'),
          ),
        ),
      ),
    );
  }
}

class ExpertModel {
  final String name;
  final String role;
  final String bio;
  final List<String> specialization;
  final String experience;
  final String profileImage;
  final double rating;
  final int sessions;
  final List<VideoModel> videos;
  final List<ProgramModel> programs;

  const ExpertModel({
    required this.name,
    required this.role,
    required this.bio,
    required this.specialization,
    required this.experience,
    required this.profileImage,
    required this.rating,
    required this.sessions,
    required this.videos,
    required this.programs,
  });
}

class VideoModel {
  final String title;
  final String duration;
  final String thumbnail;

  const VideoModel({
    required this.title,
    required this.duration,
    required this.thumbnail,
  });
}

class ProgramModel {
  final String title;
  final String subtitle;
  final String price;

  const ProgramModel({
    required this.title,
    required this.subtitle,
    required this.price,
  });
}

class AppTheme {
  const AppTheme._();

  static ThemeData get light {
    const scheme = ColorScheme(
      brightness: Brightness.light,
      primary: LightColors.primary,
      onPrimary: LightColors.onPrimary,
      secondary: LightColors.secondary,
      onSecondary: LightColors.onSecondary,
      error: LightColors.error,
      onError: LightColors.onError,
      surface: LightColors.surface,
      onSurface: LightColors.onSurface,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: LightColors.background,
      fontFamily: GoogleFonts.inter().fontFamily,
      textTheme: TextTheme(
        headlineSmall: GoogleFonts.hankenGrotesk(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: LightColors.onSurface,
        ),
        titleLarge: GoogleFonts.hankenGrotesk(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: LightColors.onSurface,
        ),
        titleMedium: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: LightColors.onSurface,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: LightColors.onSurface,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: LightColors.onSurfaceVariant,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: LightColors.onSurfaceVariant,
        ),
      ),
      cardColor: LightColors.surfaceContainerLowest,
      dividerColor: LightColors.outlineVariant,
      chipTheme: ChipThemeData(
        backgroundColor: LightColors.surfaceContainer,
        selectedColor: LightColors.secondary.withOpacity(0.12),
        disabledColor: LightColors.surfaceContainerHighest,
        labelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: LightColors.onSurfaceVariant,
        ),
        side: const BorderSide(
          color: LightColors.surfaceContainerHighest,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: LightColors.secondary,
          foregroundColor: LightColors.onSecondary,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: LightColors.secondary,
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      extensions: const <ThemeExtension<dynamic>>[
        AppColors.light,
      ],
    );
  }

  static ThemeData get dark {
    const scheme = ColorScheme(
      brightness: Brightness.dark,
      primary: DarkColors.primary,
      onPrimary: DarkColors.onPrimary,
      secondary: DarkColors.secondary,
      onSecondary: DarkColors.onSecondary,
      error: DarkColors.error,
      onError: DarkColors.onError,
      surface: DarkColors.surface,
      onSurface: DarkColors.onSurface,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: DarkColors.background,
      fontFamily: GoogleFonts.inter().fontFamily,
      textTheme: TextTheme(
        headlineSmall: GoogleFonts.playfairDisplay(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: DarkColors.onSurface,
        ),
        titleLarge: GoogleFonts.playfairDisplay(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: DarkColors.onSurface,
        ),
        titleMedium: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: DarkColors.onSurface,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: DarkColors.onSurface,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: DarkColors.onSurfaceVariant,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: DarkColors.onSurfaceVariant,
        ),
      ),
      cardColor: DarkColors.surfaceContainerLow,
      dividerColor: DarkColors.outlineVariant,
      chipTheme: ChipThemeData(
        backgroundColor: DarkColors.surfaceContainer,
        selectedColor: DarkColors.primary.withOpacity(0.10),
        disabledColor: DarkColors.surfaceContainerHigh,
        labelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: DarkColors.onSurfaceVariant,
        ),
        side: BorderSide(
          color: DarkColors.outlineVariant.withOpacity(0.35),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: DarkColors.primary,
          foregroundColor: DarkColors.onPrimary,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: DarkColors.primary,
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      extensions: const <ThemeExtension<dynamic>>[
        AppColors.dark,
      ],
    );
  }
}

@immutable
class AppColors extends ThemeExtension<AppColors> {
  final Color expertVerify;
  final Color premiumGold;
  final Color premiumGoldSurface;
  final Color neutralGrey;
  final Color surfaceContainerLowest;
  final Color surfaceContainerLow;
  final Color surfaceContainerHigh;
  final Color surfaceContainerHighest;
  final Color? surfaceIndigo;

  const AppColors({
    required this.expertVerify,
    required this.premiumGold,
    required this.premiumGoldSurface,
    required this.neutralGrey,
    required this.surfaceContainerLowest,
    required this.surfaceContainerLow,
    required this.surfaceContainerHigh,
    required this.surfaceContainerHighest,
    this.surfaceIndigo,
  });

  static const light = AppColors(
    expertVerify: Color(0xFF0EA5E9),
    premiumGold: Color(0xFFB45309),
    premiumGoldSurface: Color(0xFFFEF3C7),
    neutralGrey: Color(0xFF64748B),
    surfaceContainerLowest: Color(0xFFFFFFFF),
    surfaceContainerLow: Color(0xFFF6F3F5),
    surfaceContainerHigh: Color(0xFFEAE7E9),
    surfaceContainerHighest: Color(0xFFE4E2E4),
    surfaceIndigo: Color(0xFFEEF2FF),
  );

  static const dark = AppColors(
    expertVerify: Color(0xFF38BDF8),
    premiumGold: Color(0xFFFBBF24),
    premiumGoldSurface: Color(0xFF292118),
    neutralGrey: Color(0xFF94A3B8),
    surfaceContainerLowest: Color(0xFF0D0E0F),
    surfaceContainerLow: Color(0xFF1B1C1C),
    surfaceContainerHigh: Color(0xFF292A2A),
    surfaceContainerHighest: Color(0xFF343535),
    surfaceIndigo: null,
  );

  static AppColors of(BuildContext context) {
    return Theme.of(context).extension<AppColors>() ??
        (Theme.of(context).brightness == Brightness.dark
            ? AppColors.dark
            : AppColors.light);
  }
  @override
  ThemeExtension<AppColors> copyWith({
    Color? expertVerify,
    Color? premiumGold,
    Color? premiumGoldSurface,
    Color? neutralGrey,
    Color? surfaceContainerLowest,
    Color? surfaceContainerLow,
    Color? surfaceContainerHigh,
    Color? surfaceContainerHighest,
    Color? surfaceIndigo,
  }) {
    return AppColors(
      expertVerify: expertVerify ?? this.expertVerify,
      premiumGold: premiumGold ?? this.premiumGold,
      premiumGoldSurface: premiumGoldSurface ?? this.premiumGoldSurface,
      neutralGrey: neutralGrey ?? this.neutralGrey,
      surfaceContainerLowest:
      surfaceContainerLowest ?? this.surfaceContainerLowest,
      surfaceContainerLow: surfaceContainerLow ?? this.surfaceContainerLow,
      surfaceContainerHigh: surfaceContainerHigh ?? this.surfaceContainerHigh,
      surfaceContainerHighest:
      surfaceContainerHighest ?? this.surfaceContainerHighest,
      surfaceIndigo: surfaceIndigo ?? this.surfaceIndigo,
    );
  }

  @override
  ThemeExtension<AppColors> lerp(
      covariant ThemeExtension<AppColors>? other,
      double t,
      ) {
    if (other is! AppColors) return this;
    return AppColors(
      expertVerify: Color.lerp(expertVerify, other.expertVerify, t)!,
      premiumGold: Color.lerp(premiumGold, other.premiumGold, t)!,
      premiumGoldSurface:
      Color.lerp(premiumGoldSurface, other.premiumGoldSurface, t)!,
      neutralGrey: Color.lerp(neutralGrey, other.neutralGrey, t)!,
      surfaceContainerLowest:
      Color.lerp(surfaceContainerLowest, other.surfaceContainerLowest, t)!,
      surfaceContainerLow:
      Color.lerp(surfaceContainerLow, other.surfaceContainerLow, t)!,
      surfaceContainerHigh:
      Color.lerp(surfaceContainerHigh, other.surfaceContainerHigh, t)!,
      surfaceContainerHighest: Color.lerp(
        surfaceContainerHighest,
        other.surfaceContainerHighest,
        t,
      )!,
      surfaceIndigo: Color.lerp(surfaceIndigo, other.surfaceIndigo, t),
    );
  }
}

class LightColors {
  const LightColors._();

  static const background = Color(0xFFFCF8FA);
  static const surface = Color(0xFFFCF8FA);
  static const surfaceContainerLowest = Color(0xFFFFFFFF);
  static const surfaceContainerLow = Color(0xFFF6F3F5);
  static const surfaceContainer = Color(0xFFF0EDEF);
  static const surfaceContainerHigh = Color(0xFFEAE7E9);
  static const surfaceContainerHighest = Color(0xFFE4E2E4);
  static const primary = Color(0xFF000000);
  static const onPrimary = Color(0xFFFFFFFF);
  static const secondary = Color(0xFF4B41E1);
  static const onSecondary = Color(0xFFFFFFFF);
  static const error = Color(0xFFBA1A1A);
  static const onError = Color(0xFFFFFFFF);
  static const onSurface = Color(0xFF1B1B1D);
  static const onSurfaceVariant = Color(0xFF45464D);
  static const outlineVariant = Color(0xFFC6C6CD);
}

class DarkColors {
  const DarkColors._();

  static const background = Color(0xFF121414);
  static const surface = Color(0xFF121414);
  static const surfaceContainerLowest = Color(0xFF0D0E0F);
  static const surfaceContainerLow = Color(0xFF1B1C1C);
  static const surfaceContainer = Color(0xFF1F2020);
  static const surfaceContainerHigh = Color(0xFF292A2A);
  static const primary = Color(0xFFC8C6C5);
  static const onPrimary = Color(0xFF313030);
  static const secondary = Color(0xFFC8C6C5);
  static const onSecondary = Color(0xFF313030);
  static const error = Color(0xFFFFB4AB);
  static const onError = Color(0xFF690005);
  static const onSurface = Color(0xFFE3E2E2);
  static const onSurfaceVariant = Color(0xFFC4C7C7);
  static const outlineVariant = Color(0xFF444748);
}

class AppRadius {
  const AppRadius._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double full = 9999;
}

class AppSpacing {
  const AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;
  static const double section = 24;
  static const double pageMargin = 20;
}