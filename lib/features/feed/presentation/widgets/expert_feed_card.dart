import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:praktix/features/feed/presentation/blocs/expert_feed_bloc.dart';
import 'package:praktix/features/home/presentation/providers/home_providers.dart';

import '../../domain/entities/expert_entity.dart';

// ── Premium unlock provider for feed ─────────────────────────────────────────
// Tracks which feed expert IDs the user has unlocked (simulated, no payment)
final unlockedFeedProvider = StateProvider<Set<int>>((ref) => {});

// ── ExpertFeedCard ────────────────────────────────────────────────────────────
class ExpertFeedCard extends ConsumerWidget {
  final ExpertEntity expert;

  const ExpertFeedCard({super.key, required this.expert});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isUnlocked = ref.watch(unlockedFeedProvider).contains(expert.id);
    final locked = expert.isPremium && !isUnlocked;

    return Container(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Full-screen video thumbnail
          _VideoBackground(url: expert.videoThumbnail),

          // Dark gradient (always shown)
          _Gradient(),

          // ── Premium lock overlay ──────────────────────────────────────────
          if (locked)
            _PremiumOverlay(
              expert: expert,
              onUnlock: () => _showUnlockSheet(context, ref),
            ),

          // ── Normal content (hidden when locked) ───────────────────────────
          Column(
            children: [
              _TopBar(isPremium: expert.isPremium, isLocked: locked),
              const Spacer(),
              if (!locked) _BottomContent(expert: expert),
            ],
          ),

          // Right-side icon buttons (hidden when locked)
          if (!locked)
            Positioned(
              right: 12,
              bottom: 110,
              child: _RightActions(expert: expert),
            ),
        ],
      ),
    );
  }

  void _showUnlockSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _UnlockSheet(
        expert: expert,
        onUnlock: () {
          ref
              .read(unlockedFeedProvider.notifier)
              .update((s) => {...s, expert.id});
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.lock_open_rounded,
                      color: Color(0xFFFBBF24), size: 16),
                  const SizedBox(width: 8),
                  Text(
                    'Unlocked: ${expert.videoTitle}',
                    style: GoogleFonts.inter(
                        fontSize: 13, fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              behavior: SnackBarBehavior.floating,
              backgroundColor: const Color(0xFF1E1E2E),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              duration: const Duration(seconds: 2),
            ),
          );
        },
      ),
    );
  }
}

// ── Premium Overlay ───────────────────────────────────────────────────────────
class _PremiumOverlay extends StatelessWidget {
  final ExpertEntity expert;
  final VoidCallback onUnlock;

  const _PremiumOverlay({required this.expert, required this.onUnlock});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.40),
            Colors.black.withOpacity(0.75),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Lock icon with glow
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withOpacity(0.55),
                border: Border.all(
                    color: const Color(0xFFFBBF24).withOpacity(0.6),
                    width: 2),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFBBF24).withOpacity(0.25),
                    blurRadius: 20,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: const Icon(Icons.lock_rounded,
                  color: Color(0xFFFBBF24), size: 36),
            ),
            const SizedBox(height: 16),

            // PREMIUM badge
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFB45309),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFB45309).withOpacity(0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                'PREMIUM',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                  letterSpacing: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Subtitle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: Text(
                'This content is for premium members only',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: Colors.white60,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 28),

            // Unlock button
            GestureDetector(
              onTap: onUnlock,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 40, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFB45309).withOpacity(0.30),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.lock_open_rounded,
                        color: Color(0xFFB45309), size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'Unlock',
                      style: GoogleFonts.inter(
                        color: const Color(0xFFB45309),
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Unlock Bottom Sheet ───────────────────────────────────────────────────────
class _UnlockSheet extends StatelessWidget {
  final ExpertEntity expert;
  final VoidCallback onUnlock;

  const _UnlockSheet({required this.expert, required this.onUnlock});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFFEF3C7).withOpacity(0.12),
              border: Border.all(
                  color: const Color(0xFFFBBF24).withOpacity(0.4), width: 1.5),
            ),
            child: const Icon(Icons.lock_open_rounded,
                color: Color(0xFFFBBF24), size: 30),
          ),
          const SizedBox(height: 18),

          // Title
          Text(
            'Premium Content',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),

          // Video title
          Text(
            expert.videoTitle,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              color: Colors.white60,
              fontSize: 13,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 6),

          Text(
            'by ${expert.expertName}',
            style: GoogleFonts.inter(
              color: const Color(0xFF00BCD4),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),

          // Divider
          Container(
              height: 1,
              color: Colors.white10,
              margin: const EdgeInsets.symmetric(vertical: 8)),

          // Perks row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _Perk(icon: Icons.hd_rounded, label: 'HD Quality'),
              const SizedBox(width: 20),
              _Perk(icon: Icons.download_rounded, label: 'Offline'),
              const SizedBox(width: 20),
              _Perk(
                  icon: Icons.workspace_premium_rounded,
                  label: 'Certificate'),
            ],
          ),
          const SizedBox(height: 24),

          // Unlock button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onUnlock,
              icon: const Icon(Icons.lock_open_rounded,
                  color: Colors.white, size: 18),
              label: Text(
                'Unlock for Free (Demo)',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB45309),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Dismiss
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Maybe later',
              style: GoogleFonts.inter(
                color: Colors.white38,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

class _Perk extends StatelessWidget {
  final IconData icon;
  final String label;

  const _Perk({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF00BCD4), size: 20),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.inter(
            color: Colors.white54,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// ── Video Background ──────────────────────────────────────────────────────────
class _VideoBackground extends StatelessWidget {
  final String url;
  const _VideoBackground({required this.url});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      placeholder: (_, __) => Container(color: const Color(0xFF0D0D1A)),
      errorWidget: (_, __, ___) => Container(
        color: const Color(0xFF0D0D1A),
        child: const Center(
          child: Icon(Icons.play_circle_outline,
              color: Colors.white24, size: 72),
        ),
      ),
    );
  }
}

// ── Gradient ──────────────────────────────────────────────────────────────────
class _Gradient extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.transparent,
            Color(0x60000000),
            Color(0xCC000000),
            Color(0xF2000000),
          ],
          stops: [0.0, 0.25, 0.5, 0.72, 1.0],
        ),
      ),
    );
  }
}

// ── Top Bar ───────────────────────────────────────────────────────────────────
class _TopBar extends StatelessWidget {
  final bool isPremium;
  final bool isLocked;

  const _TopBar({required this.isPremium, required this.isLocked});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: Row(
          children: [
            _Chip(icon: Icons.live_tv_rounded, label: 'Live Session'),
            const Spacer(),
            // Show PREMIUM chip in top-right if premium (locked or unlocked)
            if (isPremium && isLocked)
              _Chip(
                icon: Icons.workspace_premium_rounded,
                label: 'Premium',
                iconColor: const Color(0xFFFBBF24),
              )
            else
              _Chip(icon: Icons.bolt_rounded, label: 'Trending'),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconColor;

  const _Chip({
    required this.icon,
    required this.label,
    this.iconColor = const Color(0xFF00BCD4),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor, size: 14),
          const SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Bottom Content ────────────────────────────────────────────────────────────
class _BottomContent extends StatelessWidget {
  final ExpertEntity expert;
  const _BottomContent({required this.expert});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 72, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Expert row
          Row(
            children: [
              _ExpertAvatar(imageUrl: expert.expertImage),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      expert.expertName,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      expert.expertTitle,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF00BCD4),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Video title
          Text(
            expert.videoTitle,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              height: 1.35,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),

          // Stats
          Row(
            children: [
              const Icon(Icons.star_rounded,
                  color: Color(0xFFFFD700), size: 14),
              const SizedBox(width: 4),
              Text(
                expert.rating.toStringAsFixed(1),
                style:
                GoogleFonts.inter(fontSize: 12, color: Colors.white70),
              ),
              const SizedBox(width: 14),
              const Icon(Icons.people_alt_outlined,
                  color: Colors.white38, size: 14),
              const SizedBox(width: 4),
              Text(
                '${_fmt(expert.totalStudents)} students',
                style:
                GoogleFonts.inter(fontSize: 12, color: Colors.white70),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: _ActionBtn(
                  label: 'View Profile',
                  icon: Icons.person_outline_rounded,
                  primary: false,
                  onTap: () => _snack(context, 'Opening profile...'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ActionBtn(
                  label: 'Book Session',
                  icon: Icons.calendar_month_outlined,
                  primary: true,
                  onTap: () => _snack(context, 'Booking session...'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _fmt(int n) =>
      n >= 1000 ? '${(n / 1000).toStringAsFixed(1)}k' : n.toString();

  void _snack(BuildContext ctx, String msg) {
    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
      content: Text(msg),
      behavior: SnackBarBehavior.floating,
      backgroundColor: const Color(0xFF1E1E2E),
      shape:
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      duration: const Duration(seconds: 1),
    ));
  }
}

// ── Expert Avatar ─────────────────────────────────────────────────────────────
class _ExpertAvatar extends StatelessWidget {
  final String imageUrl;
  const _ExpertAvatar({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF00BCD4), width: 2.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00BCD4).withOpacity(0.35),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: CircleAvatar(
        radius: 26,
        backgroundColor: const Color(0xFF1A1A2E),
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            width: 52,
            height: 52,
            fit: BoxFit.cover,
            placeholder: (_, __) =>
                Container(color: const Color(0xFF1A1A2E)),
            errorWidget: (_, __, ___) => const Icon(
              Icons.person,
              color: Colors.white38,
              size: 26,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Action Button ─────────────────────────────────────────────────────────────
class _ActionBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool primary;
  final VoidCallback onTap;

  const _ActionBtn({
    required this.label,
    required this.icon,
    required this.primary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: BoxDecoration(
          gradient: primary
              ? const LinearGradient(
            colors: [Color(0xFF00BCD4), Color(0xFF0097A7)],
          )
              : null,
          color: primary ? null : Colors.white12,
          borderRadius: BorderRadius.circular(10),
          border: primary ? null : Border.all(color: Colors.white24),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 14),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Right Actions ─────────────────────────────────────────────────────────────
class _RightActions extends StatelessWidget {
  final ExpertEntity expert;
  const _RightActions({required this.expert});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Like
        _IconBtn(
          icon: expert.isLiked
              ? Icons.favorite_rounded
              : Icons.favorite_border_rounded,
          color: expert.isLiked ? Colors.redAccent : Colors.white,
          label: _fmt(expert.likeCount),
          onTap: () => context
              .read<ExpertFeedBloc>()
              .add(ToggleLikeEvent(expert.id)),
        ),
        const SizedBox(height: 22),
        // Save
        _IconBtn(
          icon: expert.isSaved
              ? Icons.bookmark_rounded
              : Icons.bookmark_border_rounded,
          color:
          expert.isSaved ? const Color(0xFFFFD700) : Colors.white,
          label: expert.isSaved ? 'Saved' : 'Save',
          onTap: () => context
              .read<ExpertFeedBloc>()
              .add(ToggleSaveEvent(expert.id)),
        ),
        const SizedBox(height: 22),
        // Share
        _IconBtn(
          icon: Icons.share_outlined,
          color: Colors.white,
          label: 'Share',
          onTap: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Sharing...'),
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 1),
            ),
          ),
        ),
      ],
    );
  }

  String _fmt(int n) =>
      n >= 1000 ? '${(n / 1000).toStringAsFixed(1)}k' : n.toString();
}

// ── Icon Button ───────────────────────────────────────────────────────────────
class _IconBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;

  const _IconBtn({
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.black45,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              color: Colors.white70,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}