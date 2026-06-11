import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:praktix/features/auth/presentation/providers/auth_providers.dart';
import 'package:praktix/features/auth/presentation/screens/signup_screen.dart';
import 'package:praktix/features/home/domain/entities/expert_entity.dart';
import 'package:praktix/features/home/domain/entities/job_entity.dart';
import 'package:praktix/features/home/domain/entities/program_entity.dart';
import 'package:praktix/features/home/domain/entities/video_entity.dart';
import 'package:praktix/features/home/domain/entities/workshop_entity.dart';
import 'package:praktix/features/home/presentation/providers/home_providers.dart';
import 'package:webview_flutter/webview_flutter.dart';

// ── Design tokens (matches HTML theme) ───────────────────────────────────────
const _primary = Color(0xFF0F172A);       // midnight navy
const _secondary = Color(0xFF4b41e1);     // indigo
const _secondaryContainer = Color(0xFF645efb);
const _onSurfaceVariant = Color(0xFF45464D);
const _surfaceContainerHigh = Color(0xFFEAE7E9);
const _surfaceContainerLow = Color(0xFFF6F3F5);
const _expertVerify = Color(0xFF0EA5E9);
const _premiumGold = Color(0xFFB45309);
const _premiumGoldLight = Color(0xFFFEF3C7);
const _error = Color(0xFFBA1A1A);
const _bgSurface = Color(0xFFFCF8FA);
const _outline = Color(0xFF76777D);

TextStyle _hanken(
    {double size = 14,
      FontWeight weight = FontWeight.w400,
      Color color = _primary,
      double? letterSpacing,
      double height = 1.4}) =>
    GoogleFonts.hankenGrotesk(
        fontSize: size,
        fontWeight: weight,
        color: color,
        letterSpacing: letterSpacing,
        height: height);

TextStyle _inter(
    {double size = 14,
      FontWeight weight = FontWeight.w400,
      Color color = _onSurfaceVariant,
      double? letterSpacing}) =>
    GoogleFonts.inter(
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
    ));

    return Scaffold(
      backgroundColor: _bgSurface,
      extendBody: true,
      body: IndexedStack(
        index: _navIndex,
        children: const [
          _HomeTab(),
          _FeedTabPlaceholder(),
          _ProgramsTabPlaceholder(),
          _JobsTabPlaceholder(),
          _ProfileTabPlaceholder(),
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
    (icon: Icons.home_rounded, label: 'Home'),
    (icon: Icons.play_circle_rounded, label: 'Feed'),
    (icon: Icons.school_rounded, label: 'Programs'),
    (icon: Icons.work_rounded, label: 'Jobs'),
    (icon: Icons.person_rounded, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _bgSurface.withValues(alpha: 0.92),
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
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
  const _HomeTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final experts = ref.watch(expertsProvider);
    final programs = ref.watch(programsProvider);
    final videos = ref.watch(videosProvider);
    final workshops = ref.watch(workshopsProvider);
    final jobs = ref.watch(jobsProvider);

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // ── Top App Bar ────────────────────────────────────────────────────
        SliverAppBar(
          pinned: true,
          floating: true,
          backgroundColor: _bgSurface.withValues(alpha: 0.92),
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          shadowColor: Colors.black.withValues(alpha: 0.06),
          toolbarHeight: 64,
          title: Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(
                    'https://picsum.photos/seed/user1/80/80'),
              ),
              const Spacer(),
              Text('Only Experts',
                  style: _hanken(
                      size: 20,
                      weight: FontWeight.w800,
                      letterSpacing: -0.4,
                      color: _primary)),
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
              // ── Search ──────────────────────────────────────────────────
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
                    decoration: InputDecoration(
                      hintText: 'Search experts, programs, videos...',
                      hintStyle: _inter(color: _outline),
                      prefixIcon:
                      const Icon(Icons.search_rounded, color: _outline),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                    ),
                  ),
                ),
              ),

              // ── Featured Experts ─────────────────────────────────────────
              _SectionHeader(title: 'Featured Experts', onSeeAll: () {}),
              SizedBox(
                height: 290,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: experts.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 14),
                  itemBuilder: (_, i) => _ExpertCard(expert: experts[i]),
                ),
              ),

              const SizedBox(height: 28),

              // ── Short Videos ─────────────────────────────────────────────
              _SectionHeader(title: 'Short Videos', onSeeAll: () {}),
              SizedBox(
                height: 240,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: videos.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 14),
                  itemBuilder: (_, i) => _VideoCard(video: videos[i]),
                ),
              ),

              const SizedBox(height: 28),

              // ── AI Programs ──────────────────────────────────────────────
              _SectionHeader(title: 'AI Programs', onSeeAll: () {}),
              ...programs.map((p) => Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: _ProgramCard(program: p),
              )),

              const SizedBox(height: 28),

              // ── Workshops ────────────────────────────────────────────────
              _SectionHeader(title: 'Workshops', onSeeAll: () {}),
              SizedBox(
                height: 200,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: workshops.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 14),
                  itemBuilder: (_, i) =>
                      _WorkshopCard(workshop: workshops[i]),
                ),
              ),

              const SizedBox(height: 28),

              // ── Career Opportunities ─────────────────────────────────────
              _SectionHeader(title: 'Career Opportunities', onSeeAll: () {}),
              ...jobs.map((j) => Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: _JobCard(job: j),
              )),

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
                  size: 18,
                  weight: FontWeight.w700,
                  letterSpacing: -0.2)),
          TextButton(
            onPressed: onSeeAll,
            style: TextButton.styleFrom(
              padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
  const _ExpertCard({required this.expert});
  final ExpertEntity expert;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
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
          // Cover image
          Stack(
            children: [
              Image.network(
                expert.imageUrl,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 120,
                  color: _surfaceContainerHigh,
                  child: const Icon(Icons.person_rounded,
                      size: 40, color: _outline),
                ),
              ),
              // gradient overlay
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
              // rating chip
              Positioned(
                bottom: 8,
                left: 10,
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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
                        size: 14,
                        weight: FontWeight.w700,
                        color: _primary)),
                const SizedBox(height: 2),
                Text(expert.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: _inter(size: 12, color: _onSurfaceVariant)),
                const SizedBox(height: 8),
                // tags
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

class _VideoCard extends ConsumerStatefulWidget {
  const _VideoCard({required this.video});
  final VideoEntity video;

  @override
  ConsumerState<_VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends ConsumerState<_VideoCard> {
  bool _playing = false;
  WebViewController? _controller;

  void _initController() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black)
      ..loadRequest(Uri.parse(
          '${widget.video.videoUrl}?autoplay=1&rel=0&modestbranding=1'));
  }

  void _handleTap() {
    final isUnlocked =
    ref.read(unlockedVideosProvider).contains(widget.video.id);

    if (widget.video.isPremium && !isUnlocked) {
      _showUnlockSheet();
      return;
    }

    if (!_playing) {
      _initController();
    }
    setState(() => _playing = !_playing);
  }

  void _showUnlockSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _UnlockSheet(
        videoTitle: widget.video.title,
        onUnlock: () {
          ref.read(unlockedVideosProvider.notifier).update(
                (s) => {...s, widget.video.id},
          );
          Navigator.pop(context);
          _initController();
          setState(() => _playing = true);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isUnlocked =
    ref.watch(unlockedVideosProvider).contains(widget.video.id);
    final locked = widget.video.isPremium && !isUnlocked;

    return GestureDetector(
      onTap: _handleTap,
      child: Container(
        width: 220,
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
          children: [
            // ── Video / Thumbnail ────────────────────────────────────────
            SizedBox(
              height: 130,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (_playing && _controller != null)
                    WebViewWidget(controller: _controller!)
                  else ...[
                    Image.network(
                      widget.video.thumbnailUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: _primary,
                        child: const Icon(Icons.play_circle_outline_rounded,
                            color: Colors.white54, size: 40),
                      ),
                    ),
                    // play overlay
                    if (!locked)
                      Center(
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.5),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.play_arrow_rounded,
                              color: Colors.white, size: 24),
                        ),
                      ),
                    // duration
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
                        child: Text(widget.video.duration,
                            style: _inter(
                                size: 10,
                                weight: FontWeight.w600,
                                color: Colors.white)),
                      ),
                    ),
                  ],
                  // ── Premium lock overlay ─────────────────────────────
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
                  // ── Topic chip ───────────────────────────────────────
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
                      child: Text(widget.video.topic,
                          style: _inter(
                              size: 10,
                              weight: FontWeight.w600,
                              color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
            // ── Info ─────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.video.title,
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
                        backgroundImage:
                        NetworkImage(widget.video.expertImageUrl),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(widget.video.expertName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: _inter(size: 11, color: _onSurfaceVariant)),
                      ),
                      const Icon(Icons.favorite_border_rounded,
                          size: 14, color: _outline),
                      const SizedBox(width: 3),
                      Text(_formatLikes(widget.video.likes),
                          style: _inter(size: 10, color: _outline)),
                    ],
                  ),
                  if (locked) ...[
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.tonal(
                        onPressed: _showUnlockSheet,
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
  const _UnlockSheet(
      {required this.videoTitle, required this.onUnlock});
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
            decoration: BoxDecoration(
              color: _premiumGoldLight,
              shape: BoxShape.circle,
            ),
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
              style:
              _inter(size: 14, color: _onSurfaceVariant)),
          const SizedBox(height: 4),
          Text(
              'This video is exclusively available to premium members.',
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
                    size: 13,
                    weight: FontWeight.w500,
                    color: _outline)),
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
          // icon block
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
                                  color: Color(0xFF166534),
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
                      Icon(Icons.schedule_rounded,
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
  const _WorkshopCard({required this.workshop});
  final WorkshopEntity workshop;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
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
                    color:
                    workshop.isFree ? const Color(0xFF059669) : _premiumGold,
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
                            color: workshop.spotsLeft <= 5
                                ? _error
                                : _outline,
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
                        size: 15,
                        weight: FontWeight.w700,
                        color: _primary)),
                const SizedBox(height: 2),
                Text('${job.company} · ${job.location}',
                    style: _inter(size: 12, color: _onSurfaceVariant)),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    _Chip(job.type, bgColor: _secondary.withValues(alpha: 0.10), textColor: _secondary),
                    if (job.isRemote)
                      _Chip('Remote',
                          bgColor: const Color(0xFFDCFCE7),
                          textColor: const Color(0xFF166534)),
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
              Text(job.postedAgo,
                  style: _inter(size: 10, color: _outline)),
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
                      size: 12,
                      weight: FontWeight.w600,
                      color: Colors.white),
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
          style: _inter(
              size: 10, weight: FontWeight.w600, color: textColor)),
    );
  }
}

// ── Placeholder tabs ──────────────────────────────────────────────────────────

class _FeedTabPlaceholder extends StatelessWidget {
  const _FeedTabPlaceholder();
  @override
  Widget build(BuildContext context) => const Center(
      child: Text('Video Feed — coming next'));
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