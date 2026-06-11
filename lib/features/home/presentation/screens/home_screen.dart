import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:praktix/core/di/injection_container.dart';

import 'package:praktix/features/auth/presentation/providers/auth_providers.dart';
import 'package:praktix/features/auth/presentation/screens/signup_screen.dart';
import 'package:praktix/features/feed/presentation/blocs/expert_feed_bloc.dart';
import 'package:praktix/features/feed/presentation/pages/expert_feed_page.dart';
import 'package:praktix/features/home/domain/entities/expert_entity.dart';
import 'package:praktix/features/home/domain/entities/job_entity.dart';
import 'package:praktix/features/home/domain/entities/program_entity.dart';
import 'package:praktix/features/home/domain/entities/video_entity.dart';
import 'package:praktix/features/home/domain/entities/workshop_entity.dart';
import 'package:praktix/features/home/presentation/providers/home_providers.dart';
import 'package:webview_flutter/webview_flutter.dart';

// ── Design tokens ─────────────────────────────────────────────────────────────
const _primary              = Color(0xFF0F172A);
const _secondary            = Color(0xFF4b41e1);
const _onSurfaceVariant     = Color(0xFF45464D);
const _surfaceContainerHigh = Color(0xFFEAE7E9);
const _surfaceContainerLow  = Color(0xFFF6F3F5);
const _expertVerify         = Color(0xFF0EA5E9);
const _premiumGold          = Color(0xFFB45309);
const _premiumGoldLight     = Color(0xFFFEF3C7);
const _error                = Color(0xFFBA1A1A);
const _bgSurface            = Color(0xFFFCF8FA);
const _outline              = Color(0xFF76777D);

// ── Responsive helpers ────────────────────────────────────────────────────────
double _expertCardWidth(double screenW)   => screenW < 400 ? screenW * 0.55 : 200;
double _videoCardWidth(double screenW)    => screenW < 400 ? screenW * 0.62 : 220;
double _workshopCardWidth(double screenW) => screenW < 400 ? screenW * 0.70 : 240;

// ── Text styles ───────────────────────────────────────────────────────────────
TextStyle _hanken({
  double size = 14,
  FontWeight weight = FontWeight.w400,
  Color color = _primary,
  double? letterSpacing,
  double height = 1.4,
}) => GoogleFonts.hankenGrotesk(
    fontSize: size,
    fontWeight: weight,
    color: color,
    letterSpacing: letterSpacing,
    height: height);

TextStyle _inter({
  double size = 14,
  FontWeight weight = FontWeight.w400,
  Color color = _onSurfaceVariant,
  double? letterSpacing,
}) => GoogleFonts.inter(
    fontSize: size,
    fontWeight: weight,
    color: color,
    letterSpacing: letterSpacing);

// ── HomeScreen ────────────────────────────────────────────────────────────────
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _navIndex = 0;
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      final q = _searchController.text.trim().toLowerCase();
      if (q != _query) setState(() => _query = q);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
    );
    return Scaffold(
      backgroundColor: _bgSurface,
      extendBody: true,
      body: IndexedStack(
        index: _navIndex,
        children: [
          _HomeTab(query: _query, searchController: _searchController),
          BlocProvider(                      // ← replace with this
            create: (_) => sl<ExpertFeedBloc>(),
            child: const ExpertFeedPage(),
          ),
          const _ProgramsTabPlaceholder(),
          const _JobsTabPlaceholder(),
          const _ProfileTabPlaceholder(),
        ],
      ),
      bottomNavigationBar: _BottomNav(
        currentIndex: _navIndex,
        onTap: (i) => setState(() => _navIndex = i),
      ),
    );
  }
}

// ── Bottom Navigation ─────────────────────────────────────────────────────────
class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.currentIndex, required this.onTap});
  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _items = [
    (icon: Icons.home_rounded,        label: 'Home'),
    (icon: Icons.play_circle_rounded, label: 'Feed'),
    (icon: Icons.school_rounded,      label: 'Programs'),
    (icon: Icons.work_rounded,        label: 'Jobs'),
    (icon: Icons.person_rounded,      label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _bgSurface.withValues(alpha: 0.96),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_items.length, (i) {
              final active = i == currentIndex;
              return GestureDetector(
                onTap: () => onTap(i),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: active
                        ? _secondary.withValues(alpha: 0.10)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _items[i].icon,
                        color: active ? _secondary : _outline,
                        size: 24,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _items[i].label,
                        style: _inter(
                          size: 11,
                          weight: active ? FontWeight.w700 : FontWeight.w500,
                          color: active ? _secondary : _outline,
                          letterSpacing: 0.08,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

// ── Home Tab ──────────────────────────────────────────────────────────────────
class _HomeTab extends ConsumerWidget {
  const _HomeTab({
    required this.query,
    required this.searchController,
  });
  final String query;
  final TextEditingController searchController;

  bool _match(String text) =>
      query.isEmpty || text.toLowerCase().contains(query);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenW = MediaQuery.of(context).size.width;

    final allExperts   = ref.watch(expertsProvider);
    final allPrograms  = ref.watch(programsProvider);
    final allVideos    = ref.watch(videosProvider);
    final allWorkshops = ref.watch(workshopsProvider);
    final allJobs      = ref.watch(jobsProvider);

    // ── Live search filter ────────────────────────────────────────────────────
    final experts = allExperts
        .where((e) => _match(e.name) || _match(e.title) ||
        e.tags.any(_match)).toList();
    final programs = allPrograms
        .where((p) => _match(p.title) || _match(p.description)).toList();
    final videos = allVideos
        .where((v) => _match(v.title) || _match(v.topic) ||
        _match(v.expertName)).toList();
    final workshops = allWorkshops
        .where((w) => _match(w.title) || _match(w.host)).toList();
    final jobs = allJobs
        .where((j) => _match(j.title) || _match(j.company) ||
        _match(j.type)).toList();

    return CustomScrollView(
      // ClampingScrollPhysics removes bounce overhead → smoother on Android
      physics: const ClampingScrollPhysics(),
      // Pre-renders 300px below viewport → zero pop-in lag on scroll
      cacheExtent: 300,
      slivers: [
        // ── App Bar ───────────────────────────────────────────────────────────
        SliverAppBar(
          pinned: true,
          floating: true,
          snap: true,
          backgroundColor: _bgSurface.withValues(alpha: 0.96),
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          shadowColor: Colors.black.withValues(alpha: 0.06),
          toolbarHeight: 64,
          title: Row(
            children: [
              const CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(
                    'https://picsum.photos/seed/user1/80/80'),
              ),
              const Spacer(),
              Text(
                'Only Experts',
                style: _hanken(
                    size: 20,
                    weight: FontWeight.w800,
                    letterSpacing: -0.4,
                    color: _primary),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_none_rounded,
                    color: _secondary, size: 26),
              ),
            ],
          ),
        ),

        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Search bar ────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: _surfaceContainerHigh),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2)),
                    ],
                  ),
                  child: TextField(
                    controller: searchController,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (_) => FocusScope.of(context).unfocus(),
                    decoration: InputDecoration(
                      hintText: 'Search experts, programs, videos...',
                      hintStyle: _inter(color: _outline),
                      prefixIcon: const Icon(Icons.search_rounded,
                          color: _outline),
                      // Search button OR clear button
                      suffixIcon: query.isNotEmpty
                          ? IconButton(
                        icon: const Icon(Icons.close_rounded,
                            color: _outline, size: 20),
                        onPressed: () {
                          searchController.clear();
                          FocusScope.of(context).unfocus();
                        },
                      )
                          : IconButton(
                        icon: const Icon(Icons.arrow_forward_rounded,
                            color: _secondary, size: 20),
                        onPressed: () =>
                            FocusScope.of(context).unfocus(),
                        tooltip: 'Search',
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                    ),
                  ),
                ),
              ),

              // ── No results empty state ────────────────────────────────────
              if (query.isNotEmpty &&
                  experts.isEmpty &&
                  programs.isEmpty &&
                  videos.isEmpty &&
                  workshops.isEmpty &&
                  jobs.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 40),
                  child: Center(
                    child: Column(
                      children: [
                        const Icon(Icons.search_off_rounded,
                            size: 52, color: _outline),
                        const SizedBox(height: 12),
                        Text('No results for "$query"',
                            style: _hanken(
                                size: 16,
                                weight: FontWeight.w600,
                                color: _onSurfaceVariant)),
                        const SizedBox(height: 4),
                        Text('Try a different keyword',
                            style: _inter(size: 13, color: _outline)),
                      ],
                    ),
                  ),
                ),

              // ── Featured Experts ──────────────────────────────────────────
              if (experts.isNotEmpty) ...[
                _SectionHeader(title: 'Featured Experts', onSeeAll: () {}),
                SizedBox(
                  height: 290,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    physics: const ClampingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: experts.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 14),
                    itemBuilder: (_, i) => RepaintBoundary(
                      child: _ExpertCard(
                          expert: experts[i],
                          cardWidth: _expertCardWidth(screenW)),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
              ],

              // ── Short Videos ──────────────────────────────────────────────
              if (videos.isNotEmpty) ...[
                _SectionHeader(title: 'Short Videos', onSeeAll: () {}),
                SizedBox(
                  height: 260,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    physics: const ClampingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: videos.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 14),
                    itemBuilder: (_, i) => RepaintBoundary(
                      child: _VideoCard(
                          video: videos[i],
                          cardWidth: _videoCardWidth(screenW)),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
              ],

              // ── AI Programs ───────────────────────────────────────────────
              if (programs.isNotEmpty) ...[
                _SectionHeader(title: 'AI Programs', onSeeAll: () {}),
                ...programs.map((p) => Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                  child: RepaintBoundary(child: _ProgramCard(program: p)),
                )),
                const SizedBox(height: 28),
              ],

              // ── Workshops ─────────────────────────────────────────────────
              if (workshops.isNotEmpty) ...[
                _SectionHeader(title: 'Workshops', onSeeAll: () {}),
                SizedBox(
                  height: 200,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    physics: const ClampingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: workshops.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 14),
                    itemBuilder: (_, i) => RepaintBoundary(
                      child: _WorkshopCard(
                          workshop: workshops[i],
                          cardWidth: _workshopCardWidth(screenW)),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
              ],

              // ── Career Opportunities ──────────────────────────────────────
              if (jobs.isNotEmpty) ...[
                _SectionHeader(title: 'Career Opportunities', onSeeAll: () {}),
                ...jobs.map((j) => Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                  child: RepaintBoundary(child: _JobCard(job: j)),
                )),
              ],

              const SizedBox(height: 100),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Section Header ────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.onSeeAll});
  final String title;
  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: _hanken(
                  size: 18, weight: FontWeight.w700, letterSpacing: -0.2)),
          TextButton(
            onPressed: onSeeAll,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              foregroundColor: _secondary,
            ),
            child: Text('See All',
                style: _inter(
                    size: 12,
                    weight: FontWeight.w600,
                    color: _secondary,
                    letterSpacing: 0.05)),
          ),
        ],
      ),
    );
  }
}

// ── Expert Card ───────────────────────────────────────────────────────────────
class _ExpertCard extends StatelessWidget {
  const _ExpertCard({required this.expert, required this.cardWidth});
  final ExpertEntity expert;
  final double cardWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: cardWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _surfaceContainerHigh),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 4)),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image.network(
                expert.imageUrl,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                cacheWidth: 400,
                errorBuilder: (_, __, ___) => Container(
                  height: 120,
                  color: _surfaceContainerHigh,
                  child: const Icon(Icons.person_rounded,
                      size: 40, color: _outline),
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.55),
                      ],
                    ),
                  ),
                ),
              ),
              if (expert.isVerified)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: _expertVerify,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.verified_rounded,
                        color: Colors.white, size: 12),
                  ),
                ),
              Positioned(
                bottom: 8,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star_rounded,
                          color: Color(0xFFFBBF24), size: 12),
                      const SizedBox(width: 3),
                      Text('${expert.rating}',
                          style: _inter(
                              size: 11,
                              weight: FontWeight.w600,
                              color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(expert.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: _hanken(
                        size: 14, weight: FontWeight.w700, color: _primary)),
                const SizedBox(height: 2),
                Text(expert.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: _inter(size: 12, color: _onSurfaceVariant)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 5,
                  runSpacing: 4,
                  children: expert.tags
                      .take(2)
                      .map((t) => Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: _surfaceContainerLow,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(t,
                        style: _inter(
                            size: 10,
                            weight: FontWeight.w600,
                            color: _onSurfaceVariant)),
                  ))
                      .toList(),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _secondary,
                      side: const BorderSide(color: _secondary),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      textStyle: _inter(
                          size: 12,
                          weight: FontWeight.w600,
                          color: _secondary),
                    ),
                    child: const Text('Book Session'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Video Card ────────────────────────────────────────────────────────────────
class _VideoCard extends ConsumerWidget {
  const _VideoCard({required this.video, required this.cardWidth});
  final VideoEntity video;
  final double cardWidth;

  void _handleTap(BuildContext context, WidgetRef ref) {
    final isUnlocked = ref.read(unlockedVideosProvider).contains(video.id);
    if (video.isPremium && !isUnlocked) {
      _showUnlockSheet(context, ref);
      return;
    }
    _openVideoDialog(context);
  }

  /// Full-screen dialog with embedded YouTube WebView player
  void _openVideoDialog(BuildContext context) {
    // Build an HTML page that embeds YouTube with proper iframe attributes.
    // loadHtmlString() bypasses the autoplay restriction that loadRequest() hits.
    final embedUrl =
        '${video.videoUrl}?autoplay=1&rel=0&modestbranding=1&playsinline=1';

    final html = '''
<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body { background: #000; width: 100vw; height: 100vh; }
    iframe {
      width: 100%;
      height: 100%;
      border: none;
    }
  </style>
</head>
<body>
  <iframe
    src="$embedUrl"
    allow="autoplay; fullscreen; encrypted-media"
    allowfullscreen>
  </iframe>
</body>
</html>
''';

    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black)
      ..loadHtmlString(html);   // ✅ loadHtmlString instead of loadRequest

    showDialog<void>(
      context: context,
      barrierColor: Colors.black87,
      builder: (_) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 60),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                color: const Color(0xFF1A1A2E),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        video.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: _hanken(
                            size: 14,
                            weight: FontWeight.w700,
                            color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close_rounded,
                            color: Colors.white, size: 18),
                      ),
                    ),
                  ],
                ),
              ),
              // 16:9 player
              AspectRatio(
                aspectRatio: 16 / 9,
                child: WebViewWidget(controller: controller),
              ),
              // Footer
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 10),
                color: const Color(0xFF1A1A2E),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundImage: NetworkImage(video.expertImageUrl),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(video.expertName,
                          style: _inter(size: 12, color: Colors.white70)),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: _secondary.withValues(alpha: 0.30),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(video.topic,
                          style: _inter(
                              size: 10,
                              weight: FontWeight.w600,
                              color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showUnlockSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _UnlockSheet(
        videoTitle: video.title,
        onUnlock: () {
          ref.read(unlockedVideosProvider.notifier).update(
                (s) => {...s, video.id},
          );
          Navigator.pop(context);
          _openVideoDialog(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isUnlocked = ref.watch(unlockedVideosProvider).contains(video.id);
    final locked = video.isPremium && !isUnlocked;

    return GestureDetector(
      onTap: () => _handleTap(context, ref),
      child: Container(
        width: cardWidth,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _surfaceContainerHigh),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 12,
                offset: const Offset(0, 4)),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,   // ✅ KEY FIX — don't force max height
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            SizedBox(
              height: 130,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    video.thumbnailUrl,
                    fit: BoxFit.cover,
                    cacheWidth: 440,
                    errorBuilder: (_, __, ___) => Container(
                      color: _primary,
                      child: const Icon(Icons.play_circle_outline_rounded,
                          color: Colors.white54, size: 40),
                    ),
                  ),
                  if (!locked)
                    Center(
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.52),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.play_arrow_rounded,
                            color: Colors.white, size: 26),
                      ),
                    ),
                  Positioned(
                    bottom: 6,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.65),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(video.duration,
                          style: _inter(
                              size: 10,
                              weight: FontWeight.w600,
                              color: Colors.white)),
                    ),
                  ),
                  if (locked)
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.30),
                            Colors.black.withValues(alpha: 0.70),
                          ],
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.lock_rounded,
                              color: Color(0xFFFBBF24), size: 26),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 3),
                            decoration: BoxDecoration(
                              color: _premiumGold,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text('PREMIUM',
                                style: _inter(
                                    size: 10,
                                    weight: FontWeight.w700,
                                    color: Colors.white,
                                    letterSpacing: 0.8)),
                          ),
                        ],
                      ),
                    ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: _secondary.withValues(alpha: 0.88),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(video.topic,
                          style: _inter(
                              size: 10,
                              weight: FontWeight.w600,
                              color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
            // Info
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(video.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: _hanken(
                          size: 12,
                          weight: FontWeight.w700,
                          color: _primary,
                          height: 1.3)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 10,
                        backgroundImage: NetworkImage(video.expertImageUrl),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(video.expertName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: _inter(size: 11, color: _onSurfaceVariant)),
                      ),
                      const Icon(Icons.favorite_border_rounded,
                          size: 14, color: _outline),
                      const SizedBox(width: 3),
                      Text(_formatLikes(video.likes),
                          style: _inter(size: 10, color: _outline)),
                    ],
                  ),
                  if (locked) ...[
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.tonal(
                        onPressed: () => _showUnlockSheet(context, ref),
                        style: FilledButton.styleFrom(
                          backgroundColor: _premiumGoldLight,
                          foregroundColor: _premiumGold,
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          textStyle: _inter(
                              size: 11,
                              weight: FontWeight.w700,
                              color: _premiumGold),
                        ),
                        child: const Text('Unlock'),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatLikes(int n) =>
      n >= 1000 ? '${(n / 1000).toStringAsFixed(1)}k' : '$n';
}

// ── Unlock Sheet ──────────────────────────────────────────────────────────────
class _UnlockSheet extends StatelessWidget {
  const _UnlockSheet({required this.videoTitle, required this.onUnlock});
  final String videoTitle;
  final VoidCallback onUnlock;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
                color: _premiumGoldLight, shape: BoxShape.circle),
            child: const Icon(Icons.lock_open_rounded,
                color: _premiumGold, size: 28),
          ),
          const SizedBox(height: 16),
          Text('Premium Content',
              style: _hanken(
                  size: 20, weight: FontWeight.w800, color: _primary)),
          const SizedBox(height: 8),
          Text(videoTitle,
              textAlign: TextAlign.center,
              style: _inter(size: 14, color: _onSurfaceVariant)),
          const SizedBox(height: 4),
          Text('This video is exclusively available to premium members.',
              textAlign: TextAlign.center,
              style: _inter(size: 13, color: _outline)),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onUnlock,
              style: FilledButton.styleFrom(
                backgroundColor: _premiumGold,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: Text('Unlock for Free (Demo)',
                  style: _inter(
                      size: 14,
                      weight: FontWeight.w700,
                      color: Colors.white)),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Maybe later',
                style: _inter(
                    size: 13, weight: FontWeight.w500, color: _outline)),
          ),
        ],
      ),
    );
  }
}

// ── Program Card ──────────────────────────────────────────────────────────────
class _ProgramCard extends StatelessWidget {
  const _ProgramCard({required this.program});
  final ProgramEntity program;

  Color get _accent => _hexColor(program.accentHex);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _surfaceContainerHigh),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              borderRadius:
              const BorderRadius.horizontal(left: Radius.circular(16)),
              color: _accent.withValues(alpha: 0.08),
            ),
            child: Icon(
              _iconFromName(program.iconName),
              color: _accent.withValues(alpha: 0.70),
              size: 36,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(program.title,
                            style: _hanken(
                                size: 15,
                                weight: FontWeight.w700,
                                color: _primary)),
                      ),
                      if (program.hasCertificate)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCFCE7),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text('Certificate',
                              style: _inter(
                                  size: 9,
                                  weight: FontWeight.w700,
                                  color: const Color(0xFF166534),
                                  letterSpacing: 0.4)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(program.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: _inter(size: 12, color: _onSurfaceVariant)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.schedule_rounded,
                          size: 13, color: _outline),
                      const SizedBox(width: 4),
                      Text(program.duration,
                          style: _inter(
                              size: 11,
                              color: _outline,
                              weight: FontWeight.w500)),
                      const Spacer(),
                      FilledButton(
                        onPressed: () {},
                        style: FilledButton.styleFrom(
                          backgroundColor: _secondary,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 7),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          textStyle: _inter(
                              size: 12,
                              weight: FontWeight.w600,
                              color: Colors.white),
                        ),
                        child: const Text('View'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconFromName(String name) {
    switch (name) {
      case 'health_and_safety':
        return Icons.health_and_safety_rounded;
      case 'terminal':
        return Icons.terminal_rounded;
      case 'military_tech':
        return Icons.military_tech_rounded;
      case 'security':
        return Icons.security_rounded;
      default:
        return Icons.business_center_rounded;
    }
  }
}

// ── Workshop Card ─────────────────────────────────────────────────────────────
class _WorkshopCard extends StatelessWidget {
  const _WorkshopCard({required this.workshop, required this.cardWidth});
  final WorkshopEntity workshop;
  final double cardWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: cardWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _surfaceContainerHigh),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 3)),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image.network(
                workshop.imageUrl,
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
                cacheWidth: 480,
                errorBuilder: (_, __, ___) => Container(
                    height: 100,
                    color: _secondary.withValues(alpha: 0.12)),
              ),
              Positioned(
                top: 8,
                left: 10,
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: workshop.isFree
                        ? const Color(0xFF059669)
                        : _premiumGold,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(workshop.isFree ? 'FREE' : 'PAID',
                      style: _inter(
                          size: 10,
                          weight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.8)),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(workshop.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: _hanken(
                        size: 13,
                        weight: FontWeight.w700,
                        color: _primary,
                        height: 1.3)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_rounded,
                        size: 12, color: _outline),
                    const SizedBox(width: 4),
                    Text('${workshop.date} · ${workshop.time}',
                        style: _inter(size: 10, color: _outline)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.people_rounded,
                        size: 12, color: _outline),
                    const SizedBox(width: 4),
                    Text('${workshop.spotsLeft} spots left',
                        style: _inter(
                            size: 10,
                            color: workshop.spotsLeft <= 5 ? _error : _outline,
                            weight: FontWeight.w600)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Job Card ──────────────────────────────────────────────────────────────────
class _JobCard extends StatelessWidget {
  const _JobCard({required this.job});
  final JobEntity job;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _surfaceContainerHigh),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage(job.logoUrl),
            backgroundColor: _surfaceContainerHigh,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(job.title,
                    style: _hanken(
                        size: 15, weight: FontWeight.w700, color: _primary)),
                const SizedBox(height: 2),
                Text('${job.company} · ${job.location}',
                    style: _inter(size: 12, color: _onSurfaceVariant)),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    _Chip(job.type,
                        bgColor: _secondary.withValues(alpha: 0.10),
                        textColor: _secondary),
                    if (job.isRemote)
                      const _Chip('Remote',
                          bgColor: Color(0xFFDCFCE7),
                          textColor: Color(0xFF166534)),
                    _Chip(job.salary,
                        bgColor: _surfaceContainerLow,
                        textColor: _onSurfaceVariant),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(job.postedAgo, style: _inter(size: 10, color: _outline)),
              const SizedBox(height: 8),
              FilledButton(
                onPressed: () {},
                style: FilledButton.styleFrom(
                  backgroundColor: _secondary,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  textStyle: _inter(
                      size: 12, weight: FontWeight.w600, color: Colors.white),
                ),
                child: const Text('Apply'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip(this.label,
      {required this.bgColor, required this.textColor});
  final String label;
  final Color bgColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(label,
          style: _inter(size: 10, weight: FontWeight.w600, color: textColor)),
    );
  }
}

// ── Placeholder tabs ──────────────────────────────────────────────────────────
class _FeedTabPlaceholder extends StatelessWidget {
  const _FeedTabPlaceholder();
  @override
  Widget build(BuildContext context) =>
      const Center(child: Text('Video Feed — coming next'));
}

class _ProgramsTabPlaceholder extends StatelessWidget {
  const _ProgramsTabPlaceholder();
  @override
  Widget build(BuildContext context) =>
      const Center(child: Text('Programs Screen'));
}

class _JobsTabPlaceholder extends StatelessWidget {
  const _JobsTabPlaceholder();
  @override
  Widget build(BuildContext context) =>
      const Center(child: Text('Jobs Screen'));
}

class _ProfileTabPlaceholder extends ConsumerWidget {
  const _ProfileTabPlaceholder();
  @override
  Widget build(BuildContext context, WidgetRef ref) => Center(
    child: FilledButton.icon(
      onPressed: () async {
        await ref.read(authRepositoryProvider).signOut();
        if (!context.mounted) return;
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (_) => const RegistrationScreen()),
              (_) => false,
        );
      },
      icon: const Icon(Icons.logout_rounded),
      label: const Text('Sign Out'),
      style: FilledButton.styleFrom(backgroundColor: _secondary),
    ),
  );
}

// ── Helpers ───────────────────────────────────────────────────────────────────
Color _hexColor(String hex) {
  final h = hex.replaceAll('#', '');
  return Color(int.parse('FF$h', radix: 16));
}