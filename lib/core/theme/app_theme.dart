import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ═════════════════════════════════════════════════════════════════════
// ONLY EXPERTS APP THEME
// - Light theme  -> Expert Profile screen
// - Dark theme   -> Programs screen
// - Includes AppColors ThemeExtension with static access helpers
// ═════════════════════════════════════════════════════════════════════

class AppTheme {
  const AppTheme._();

  static ThemeData light = _buildLightTheme();
  static ThemeData dark = _buildDarkTheme();

  static ThemeData _buildLightTheme() {
    const scheme = ColorScheme(
      brightness: Brightness.light,
      primary: _LightColors.primary,
      onPrimary: _LightColors.onPrimary,
      primaryContainer: _LightColors.primaryContainer,
      onPrimaryContainer: _LightColors.onPrimaryContainer,
      secondary: _LightColors.secondary,
      onSecondary: _LightColors.onSecondary,
      secondaryContainer: _LightColors.secondaryContainer,
      onSecondaryContainer: _LightColors.onSecondaryContainer,
      tertiary: _LightColors.tertiary,
      onTertiary: _LightColors.onTertiary,
      tertiaryContainer: _LightColors.tertiaryContainer,
      onTertiaryContainer: _LightColors.onTertiaryContainer,
      error: _LightColors.error,
      onError: _LightColors.onError,
      errorContainer: _LightColors.errorContainer,
      onErrorContainer: _LightColors.onErrorContainer,
      surface: _LightColors.surface,
      onSurface: _LightColors.onSurface,
      onSurfaceVariant: _LightColors.onSurfaceVariant,
      outline: _LightColors.outline,
      outlineVariant: _LightColors.outlineVariant,
      inverseSurface: _LightColors.inverseSurface,
      onInverseSurface: _LightColors.inverseOnSurface,
      inversePrimary: _LightColors.inversePrimary,
      surfaceTint: _LightColors.surfaceTint,
      shadow: Color(0x1A000000),
      scrim: Color(0xFF000000),
    );

    final textTheme = _AppTextTheme.lightTextTheme;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: scheme,
      scaffoldBackgroundColor: _LightColors.background,
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      fontFamily: GoogleFonts.inter().fontFamily,
      extensions: const <ThemeExtension<dynamic>>[
        AppColors.light,
      ],

      appBarTheme: AppBarTheme(
        backgroundColor: _LightColors.surface.withValues(alpha: 0.70),
        foregroundColor: _LightColors.onSurface,
        elevation: 1,
        shadowColor: const Color(0x14000000),
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        titleTextStyle: GoogleFonts.hankenGrotesk(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: _LightColors.primary,
        ),
        iconTheme: const IconThemeData(
          color: _LightColors.onSurface,
          size: 24,
        ),
        actionsIconTheme: const IconThemeData(
          color: _LightColors.secondary,
          size: 24,
        ),
      ),

      cardTheme: CardThemeData(
        color: _LightColors.surfaceContainerLowest,
        elevation: 1,
        shadowColor: const Color(0x14000000),
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(
            color: _LightColors.surfaceContainerHighest,
            width: 1,
          ),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _LightColors.secondary,
          foregroundColor: _LightColors.onSecondary,
          elevation: 2,
          shadowColor: const Color(0x29000000),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.6,
          ),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: _LightColors.secondary,
          foregroundColor: _LightColors.onSecondary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.6,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _LightColors.secondary,
          side: const BorderSide(color: _LightColors.secondary, width: 1),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.6,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _LightColors.secondary,
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: _LightColors.surfaceContainer,
        selectedColor: _LightColors.secondary.withValues(alpha: 0.12),
        disabledColor: _LightColors.surfaceContainerHighest,
        labelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.6,
          color: _LightColors.onSurfaceVariant,
        ),
        side: const BorderSide(
          color: _LightColors.surfaceContainerHighest,
          width: 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(9999),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _LightColors.surfaceContainerLowest,
        hintStyle: GoogleFonts.inter(
          fontSize: 14,
          color: _LightColors.onSurfaceVariant,
        ),
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          color: _LightColors.onSurfaceVariant,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _LightColors.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _LightColors.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _LightColors.secondary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _LightColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _LightColors.error, width: 2),
        ),
      ),

      dividerTheme: const DividerThemeData(
        color: _LightColors.surfaceContainerHighest,
        thickness: 1,
        space: 1,
      ),

      iconTheme: const IconThemeData(
        color: _LightColors.onSurfaceVariant,
        size: 24,
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: _LightColors.surface,
        selectedItemColor: _LightColors.secondary,
        unselectedItemColor: _LightColors.neutralGrey,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: _LightColors.surface,
        indicatorColor: _LightColors.secondary.withValues(alpha: 0.12),
        elevation: 8,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final isSelected = states.contains(WidgetState.selected);
          return GoogleFonts.inter(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? _LightColors.secondary : _LightColors.neutralGrey,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final isSelected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: isSelected ? _LightColors.secondary : _LightColors.neutralGrey,
            size: 24,
          );
        }),
      ),

      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: _LightColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        showDragHandle: true,
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: _LightColors.surfaceContainerLowest,
        surfaceTintColor: Colors.transparent,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: _LightColors.inverseSurface,
        contentTextStyle: GoogleFonts.inter(
          fontSize: 14,
          color: _LightColors.inverseOnSurface,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _LightColors.secondary,
        foregroundColor: _LightColors.onSecondary,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),

      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: _LightColors.secondary,
        linearTrackColor: _LightColors.surfaceContainerHigh,
      ),

      tabBarTheme: TabBarThemeData(
        labelColor: _LightColors.secondary,
        unselectedLabelColor: _LightColors.onSurfaceVariant,
        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(color: _LightColors.secondary, width: 2),
        ),
        labelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.6,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.6,
        ),
      ),

      listTileTheme: ListTileThemeData(
        iconColor: _LightColors.onSurfaceVariant,
        textColor: _LightColors.onSurface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        titleTextStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: _LightColors.onSurface,
        ),
        subtitleTextStyle: GoogleFonts.inter(
          fontSize: 12,
          color: _LightColors.onSurfaceVariant,
        ),
      ),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return _LightColors.onSecondary;
          }
          return _LightColors.outline;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return _LightColors.secondary;
          }
          return _LightColors.surfaceContainerHighest;
        }),
      ),
    );
  }

  static ThemeData _buildDarkTheme() {
    const scheme = ColorScheme(
      brightness: Brightness.dark,
      primary: _DarkColors.primary,
      onPrimary: _DarkColors.onPrimary,
      primaryContainer: _DarkColors.primaryContainer,
      onPrimaryContainer: _DarkColors.onPrimaryContainer,
      secondary: _DarkColors.secondary,
      onSecondary: _DarkColors.onSecondary,
      secondaryContainer: _DarkColors.secondaryContainer,
      onSecondaryContainer: _DarkColors.onSecondaryContainer,
      tertiary: _DarkColors.tertiary,
      onTertiary: _DarkColors.onTertiary,
      tertiaryContainer: _DarkColors.tertiaryContainer,
      onTertiaryContainer: _DarkColors.onTertiaryContainer,
      error: _DarkColors.error,
      onError: _DarkColors.onError,
      errorContainer: _DarkColors.errorContainer,
      onErrorContainer: _DarkColors.onErrorContainer,
      surface: _DarkColors.surface,
      onSurface: _DarkColors.onSurface,
      onSurfaceVariant: _DarkColors.onSurfaceVariant,
      outline: _DarkColors.outline,
      outlineVariant: _DarkColors.outlineVariant,
      inverseSurface: _DarkColors.inverseSurface,
      onInverseSurface: _DarkColors.inverseOnSurface,
      inversePrimary: _DarkColors.inversePrimary,
      surfaceTint: _DarkColors.surfaceTint,
      shadow: Color(0x33000000),
      scrim: Color(0xFF000000),
    );

    final textTheme = _AppTextTheme.darkTextTheme;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: _DarkColors.background,
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      fontFamily: GoogleFonts.inter().fontFamily,
      extensions: const <ThemeExtension<dynamic>>[
        AppColors.dark,
      ],

      appBarTheme: AppBarTheme(
        backgroundColor: _DarkColors.surfaceDim,
        foregroundColor: _DarkColors.onSurface,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        titleTextStyle: GoogleFonts.playfairDisplay(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 4,
          color: _DarkColors.primary,
        ),
        iconTheme: const IconThemeData(
          color: _DarkColors.onSurfaceVariant,
          size: 24,
        ),
        actionsIconTheme: const IconThemeData(
          color: _DarkColors.onSurfaceVariant,
          size: 24,
        ),
      ),

      cardTheme: CardThemeData(
        color: _DarkColors.surfaceContainerLowest,
        elevation: 0,
        shadowColor: Colors.transparent,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: _DarkColors.outlineVariant.withValues(alpha: 0.30),
            width: 1,
          ),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _DarkColors.primary,
          foregroundColor: _DarkColors.onPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.7,
          ),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: _DarkColors.primary,
          foregroundColor: _DarkColors.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.7,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _DarkColors.primary,
          side: const BorderSide(color: _DarkColors.primary, width: 1),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.7,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _DarkColors.primary,
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: _DarkColors.surfaceVariant,
        selectedColor: _DarkColors.primary.withValues(alpha: 0.10),
        disabledColor: _DarkColors.surfaceContainerHigh,
        labelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.6,
          color: _DarkColors.onSurfaceVariant,
        ),
        side: BorderSide(
          color: _DarkColors.outlineVariant.withValues(alpha: 0.30),
          width: 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _DarkColors.surfaceContainerLow,
        hintStyle: GoogleFonts.inter(
          fontSize: 16,
          color: _DarkColors.onSurfaceVariant,
        ),
        labelStyle: GoogleFonts.inter(
          fontSize: 16,
          color: _DarkColors.onSurfaceVariant,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: _DarkColors.outlineVariant.withValues(alpha: 0.30),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: _DarkColors.outlineVariant.withValues(alpha: 0.30),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _DarkColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _DarkColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _DarkColors.error, width: 1.5),
        ),
      ),

      dividerTheme: DividerThemeData(
        color: _DarkColors.outlineVariant.withValues(alpha: 0.10),
        thickness: 1,
        space: 1,
      ),

      iconTheme: const IconThemeData(
        color: _DarkColors.onSurfaceVariant,
        size: 24,
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: _DarkColors.surfaceContainer,
        selectedItemColor: _DarkColors.primary,
        unselectedItemColor: _DarkColors.onSurfaceVariant,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: _DarkColors.surfaceContainer,
        indicatorColor: _DarkColors.primary.withValues(alpha: 0.10),
        elevation: 0,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final isSelected = states.contains(WidgetState.selected);
          return GoogleFonts.inter(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? _DarkColors.primary : _DarkColors.onSurfaceVariant,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final isSelected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: isSelected ? _DarkColors.primary : _DarkColors.onSurfaceVariant,
            size: 24,
          );
        }),
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: _DarkColors.surfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        showDragHandle: true,
        dragHandleColor: _DarkColors.outlineVariant,
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: _DarkColors.surfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: _DarkColors.inverseSurface,
        contentTextStyle: GoogleFonts.inter(
          fontSize: 14,
          color: _DarkColors.inverseOnSurface,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _DarkColors.primary,
        foregroundColor: _DarkColors.onPrimary,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),

      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: _DarkColors.primary,
        linearTrackColor: _DarkColors.surfaceContainerHigh,
      ),

      tabBarTheme: TabBarThemeData(
        labelColor: _DarkColors.primary,
        unselectedLabelColor: _DarkColors.onSurfaceVariant,
        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(color: _DarkColors.primary, width: 2),
        ),
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.7,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),

      listTileTheme: ListTileThemeData(
        iconColor: _DarkColors.onSurfaceVariant,
        textColor: _DarkColors.onSurface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        titleTextStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: _DarkColors.onSurface,
        ),
        subtitleTextStyle: GoogleFonts.inter(
          fontSize: 12,
          color: _DarkColors.onSurfaceVariant,
        ),
      ),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return _DarkColors.onPrimary;
          }
          return _DarkColors.outline;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return _DarkColors.primary;
          }
          return _DarkColors.surfaceContainerHigh;
        }),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════
// APP COLORS EXTENSION
// Access:
//   final c = AppColors.of(context);
//   c.expertVerify
// ═════════════════════════════════════════════════════════════════════

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

  static const AppColors light = AppColors(
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

  static const AppColors dark = AppColors(
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

  static AppColors of(BuildContext context) =>
      Theme.of(context).extension<AppColors>()!;

  @override
  AppColors copyWith({
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
  AppColors lerp(AppColors? other, double t) {
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

// ═════════════════════════════════════════════════════════════════════
// LIGHT TOKENS
// ═════════════════════════════════════════════════════════════════════

class _LightColors {
  const _LightColors._();

  static const Color background = Color(0xFFFCF8FA);
  static const Color surface = Color(0xFFFCF8FA);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF6F3F5);
  static const Color surfaceContainer = Color(0xFFF0EDEF);
  static const Color surfaceContainerHigh = Color(0xFFEAE7E9);
  static const Color surfaceContainerHighest = Color(0xFFE4E2E4);
  static const Color surfaceDim = Color(0xFFDCD9DB);
  static const Color surfaceVariant = Color(0xFFE4E2E4);
  static const Color surfaceIndigo = Color(0xFFEEF2FF);

  static const Color primary = Color(0xFF000000);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFF131B2E);
  static const Color onPrimaryContainer = Color(0xFF7C839B);
  static const Color primaryFixed = Color(0xFFDAE2FD);
  static const Color primaryFixedDim = Color(0xFFBEC6E0);
  static const Color onPrimaryFixed = Color(0xFF131B2E);
  static const Color onPrimaryFixedVariant = Color(0xFF3F465C);

  static const Color secondary = Color(0xFF4B41E1);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFF645EFB);
  static const Color onSecondaryContainer = Color(0xFFFFFBFF);
  static const Color secondaryFixed = Color(0xFFE2DFFF);
  static const Color secondaryFixedDim = Color(0xFFC3C0FF);
  static const Color onSecondaryFixed = Color(0xFF0F0069);
  static const Color onSecondaryFixedVariant = Color(0xFF3323CC);

  static const Color tertiary = Color(0xFF000000);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFF271901);
  static const Color onTertiaryContainer = Color(0xFF98805D);
  static const Color tertiaryFixed = Color(0xFFFCDEB5);
  static const Color tertiaryFixedDim = Color(0xFFDEC29A);
  static const Color onTertiaryFixed = Color(0xFF271901);
  static const Color onTertiaryFixedVariant = Color(0xFF574425);

  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF93000A);

  static const Color onBackground = Color(0xFF1B1B1D);
  static const Color onSurface = Color(0xFF1B1B1D);
  static const Color onSurfaceVariant = Color(0xFF45464D);
  static const Color outline = Color(0xFF76777D);
  static const Color outlineVariant = Color(0xFFC6C6CD);
  static const Color inverseSurface = Color(0xFF303032);
  static const Color inverseOnSurface = Color(0xFFF3F0F2);
  static const Color inversePrimary = Color(0xFFBEC6E0);
  static const Color surfaceTint = Color(0xFF565E74);

  static const Color expertVerify = Color(0xFF0EA5E9);
  static const Color premiumGold = Color(0xFFB45309);
  static const Color premiumGoldLight = Color(0xFFFEF3C7);
  static const Color neutralGrey = Color(0xFF64748B);
}

// ═════════════════════════════════════════════════════════════════════
// DARK TOKENS
// ═════════════════════════════════════════════════════════════════════

class _DarkColors {
  const _DarkColors._();

  static const Color background = Color(0xFF121414);
  static const Color surface = Color(0xFF121414);
  static const Color surfaceContainerLowest = Color(0xFF0D0E0F);
  static const Color surfaceContainerLow = Color(0xFF1B1C1C);
  static const Color surfaceContainer = Color(0xFF1F2020);
  static const Color surfaceContainerHigh = Color(0xFF292A2A);
  static const Color surfaceContainerHighest = Color(0xFF343535);
  static const Color surfaceDim = Color(0xFF121414);
  static const Color surfaceBright = Color(0xFF383939);
  static const Color surfaceVariant = Color(0xFF343535);

  static const Color primary = Color(0xFFC8C6C5);
  static const Color onPrimary = Color(0xFF313030);
  static const Color primaryContainer = Color(0xFF121212);
  static const Color onPrimaryContainer = Color(0xFF7E7D7D);
  static const Color primaryFixed = Color(0xFFE5E2E1);
  static const Color primaryFixedDim = Color(0xFFC8C6C5);
  static const Color onPrimaryFixed = Color(0xFF1C1B1B);
  static const Color onPrimaryFixedVariant = Color(0xFF474646);

  static const Color secondary = Color(0xFFC8C6C5);
  static const Color onSecondary = Color(0xFF313030);
  static const Color secondaryContainer = Color(0xFF474746);
  static const Color onSecondaryContainer = Color(0xFFB7B5B4);
  static const Color secondaryFixed = Color(0xFFE5E2E1);
  static const Color secondaryFixedDim = Color(0xFFC8C6C5);
  static const Color onSecondaryFixed = Color(0xFF1B1B1B);
  static const Color onSecondaryFixedVariant = Color(0xFF474746);

  static const Color tertiary = Color(0xFFCAC6C3);
  static const Color onTertiary = Color(0xFF32302F);
  static const Color tertiaryContainer = Color(0xFF131211);
  static const Color onTertiaryContainer = Color(0xFF807D7B);
  static const Color tertiaryFixed = Color(0xFFE6E1DF);
  static const Color tertiaryFixedDim = Color(0xFFCAC6C3);
  static const Color onTertiaryFixed = Color(0xFF1C1B1A);
  static const Color onTertiaryFixedVariant = Color(0xFF484645);

  static const Color error = Color(0xFFFFB4AB);
  static const Color onError = Color(0xFF690005);
  static const Color errorContainer = Color(0xFF93000A);
  static const Color onErrorContainer = Color(0xFFFFDAD6);

  static const Color onBackground = Color(0xFFE3E2E2);
  static const Color onSurface = Color(0xFFE3E2E2);
  static const Color onSurfaceVariant = Color(0xFFC4C7C7);
  static const Color outline = Color(0xFF8E9192);
  static const Color outlineVariant = Color(0xFF444748);
  static const Color inverseSurface = Color(0xFFE3E2E2);
  static const Color inverseOnSurface = Color(0xFF2F3031);
  static const Color inversePrimary = Color(0xFF5F5E5E);
  static const Color surfaceTint = Color(0xFFC8C6C5);
}

// ═════════════════════════════════════════════════════════════════════
// TEXT THEMES
// ═════════════════════════════════════════════════════════════════════

class _AppTextTheme {
  const _AppTextTheme._();

  static TextTheme get lightTextTheme => TextTheme(
    displayLarge: GoogleFonts.hankenGrotesk(
      fontSize: 32,
      height: 1.25,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.64,
      color: _LightColors.primary,
    ),
    displayMedium: GoogleFonts.hankenGrotesk(
      fontSize: 24,
      height: 1.33,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.24,
      color: _LightColors.primary,
    ),
    displaySmall: GoogleFonts.hankenGrotesk(
      fontSize: 20,
      height: 1.40,
      fontWeight: FontWeight.w600,
      color: _LightColors.primary,
    ),
    headlineLarge: GoogleFonts.hankenGrotesk(
      fontSize: 24,
      height: 1.33,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.24,
      color: _LightColors.primary,
    ),
    headlineMedium: GoogleFonts.hankenGrotesk(
      fontSize: 20,
      height: 1.40,
      fontWeight: FontWeight.w600,
      color: _LightColors.primary,
    ),
    headlineSmall: GoogleFonts.hankenGrotesk(
      fontSize: 18,
      height: 1.33,
      fontWeight: FontWeight.w600,
      color: _LightColors.primary,
    ),
    titleLarge: GoogleFonts.inter(
      fontSize: 18,
      height: 1.33,
      fontWeight: FontWeight.w600,
      color: _LightColors.onSurface,
    ),
    titleMedium: GoogleFonts.inter(
      fontSize: 16,
      height: 1.5,
      fontWeight: FontWeight.w500,
      color: _LightColors.onSurface,
    ),
    titleSmall: GoogleFonts.inter(
      fontSize: 14,
      height: 1.43,
      fontWeight: FontWeight.w500,
      color: _LightColors.onSurface,
    ),
    bodyLarge: GoogleFonts.inter(
      fontSize: 16,
      height: 1.5,
      fontWeight: FontWeight.w400,
      color: _LightColors.onSurface,
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: 14,
      height: 1.43,
      fontWeight: FontWeight.w400,
      color: _LightColors.onSurfaceVariant,
    ),
    bodySmall: GoogleFonts.inter(
      fontSize: 12,
      height: 1.33,
      fontWeight: FontWeight.w400,
      color: _LightColors.onSurfaceVariant,
    ),
    labelLarge: GoogleFonts.inter(
      fontSize: 12,
      height: 1.33,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.6,
      color: _LightColors.onSurfaceVariant,
    ),
    labelMedium: GoogleFonts.inter(
      fontSize: 11,
      height: 1.27,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.88,
      color: _LightColors.onSurfaceVariant,
    ),
    labelSmall: GoogleFonts.inter(
      fontSize: 10,
      height: 1.3,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.8,
      color: _LightColors.onSurfaceVariant,
    ),
  );

  static TextTheme get darkTextTheme => TextTheme(
    displayLarge: GoogleFonts.playfairDisplay(
      fontSize: 64,
      height: 1.10,
      fontWeight: FontWeight.w700,
      letterSpacing: -1.28,
      color: _DarkColors.onSurface,
    ),
    displayMedium: GoogleFonts.playfairDisplay(
      fontSize: 40,
      height: 1.20,
      fontWeight: FontWeight.w600,
      color: _DarkColors.onSurface,
    ),
    displaySmall: GoogleFonts.playfairDisplay(
      fontSize: 28,
      height: 1.30,
      fontWeight: FontWeight.w500,
      color: _DarkColors.onSurface,
    ),
    headlineLarge: GoogleFonts.playfairDisplay(
      fontSize: 32,
      height: 1.20,
      fontWeight: FontWeight.w600,
      color: _DarkColors.onSurface,
    ),
    headlineMedium: GoogleFonts.playfairDisplay(
      fontSize: 28,
      height: 1.30,
      fontWeight: FontWeight.w500,
      color: _DarkColors.onSurface,
    ),
    headlineSmall: GoogleFonts.playfairDisplay(
      fontSize: 24,
      height: 1.30,
      fontWeight: FontWeight.w500,
      color: _DarkColors.onSurface,
    ),
    titleLarge: GoogleFonts.inter(
      fontSize: 18,
      height: 1.33,
      fontWeight: FontWeight.w600,
      color: _DarkColors.onSurface,
    ),
    titleMedium: GoogleFonts.inter(
      fontSize: 16,
      height: 1.6,
      fontWeight: FontWeight.w400,
      color: _DarkColors.onSurface,
    ),
    titleSmall: GoogleFonts.inter(
      fontSize: 14,
      height: 1.6,
      fontWeight: FontWeight.w400,
      color: _DarkColors.onSurface,
    ),
    bodyLarge: GoogleFonts.inter(
      fontSize: 18,
      height: 1.6,
      fontWeight: FontWeight.w400,
      color: _DarkColors.onSurface,
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: 16,
      height: 1.6,
      fontWeight: FontWeight.w400,
      color: _DarkColors.onSurfaceVariant,
    ),
    bodySmall: GoogleFonts.inter(
      fontSize: 14,
      height: 1.2,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.7,
      color: _DarkColors.onSurfaceVariant,
    ),
    labelLarge: GoogleFonts.inter(
      fontSize: 14,
      height: 1.2,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.7,
      color: _DarkColors.onSurfaceVariant,
    ),
    labelMedium: GoogleFonts.inter(
      fontSize: 12,
      height: 1.2,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.6,
      color: _DarkColors.onSurfaceVariant,
    ),
    labelSmall: GoogleFonts.inter(
      fontSize: 11,
      height: 1.2,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.55,
      color: _DarkColors.onSurfaceVariant,
    ),
  );
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
  static const double desktopMargin = 64;
}