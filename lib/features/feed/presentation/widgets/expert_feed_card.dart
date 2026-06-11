import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:praktix/features/feed/presentation/blocs/expert_feed_bloc.dart';

import '../../domain/entities/expert_entity.dart';
//import '../blocs/expert_feed/expert_feed_bloc.dart';

class ExpertFeedCard extends StatelessWidget {
  final ExpertEntity expert;

  const ExpertFeedCard({super.key, required this.expert});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Full-screen video thumbnail
          _VideoBackground(url: expert.videoThumbnail),
          // Dark gradient
          _Gradient(),
          // Layout
          Column(
            children: [
              _TopBar(),
              const Spacer(),
              _BottomContent(expert: expert),
            ],
          ),
          // Right-side icon buttons
          Positioned(
            right: 12,
            bottom: 110,
            child: _RightActions(expert: expert),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
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

// ─────────────────────────────────────────────
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

// ─────────────────────────────────────────────
class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: Row(
          children: [
            _Chip(icon: Icons.live_tv_rounded, label: 'Live Session'),
            const Spacer(),
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
  const _Chip({required this.icon, required this.label});

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
          Icon(icon, color: const Color(0xFF00BCD4), size: 14),
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

// ─────────────────────────────────────────────
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
              const Icon(Icons.star_rounded, color: Color(0xFFFFD700), size: 14),
              const SizedBox(width: 4),
              Text(
                expert.rating.toStringAsFixed(1),
                style: GoogleFonts.inter(
                    fontSize: 12, color: Colors.white70),
              ),
              const SizedBox(width: 14),
              const Icon(Icons.people_alt_outlined,
                  color: Colors.white38, size: 14),
              const SizedBox(width: 4),
              Text(
                '${_fmt(expert.totalStudents)} students',
                style: GoogleFonts.inter(
                    fontSize: 12, color: Colors.white70),
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      duration: const Duration(seconds: 1),
    ));
  }
}

// ─────────────────────────────────────────────
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

// ─────────────────────────────────────────────
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

// ─────────────────────────────────────────────
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
          color: expert.isSaved ? const Color(0xFFFFD700) : Colors.white,
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