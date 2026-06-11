

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:praktix/features/feed/presentation/blocs/expert_feed_bloc.dart';

import '../../../../core/di/injection_container.dart';
//import '../blocs/expert_feed/expert_feed_bloc.dart';
import '../widgets/expert_feed_card.dart';
import '../widgets/expert_feed_skeleton.dart';

/// Wrap this page with BlocProvider at your router/home level:
///
/// BlocProvider(
///   create: (_) => sl<ExpertFeedBloc>(),
///   child: const ExpertFeedPage(),
/// )
class ExpertFeedPage extends StatefulWidget {
  const ExpertFeedPage({super.key});

  @override
  State<ExpertFeedPage> createState() => _ExpertFeedPageState();
}

class _ExpertFeedPageState extends State<ExpertFeedPage> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    context.read<ExpertFeedBloc>().add(const LoadExpertsEvent());
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: BlocBuilder<ExpertFeedBloc, ExpertFeedState>(
        builder: (context, state) {
          if (state is ExpertFeedLoading) {
            return const ExpertFeedSkeleton();
          }

          if (state is ExpertFeedError) {
            return _ErrorView(
              message: state.message,
              onRetry: () =>
                  context.read<ExpertFeedBloc>().add(const LoadExpertsEvent()),
            );
          }

          if (state is ExpertFeedLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context
                    .read<ExpertFeedBloc>()
                    .add(const RefreshExpertsEvent());
                await Future.delayed(const Duration(milliseconds: 400));
              },
              color: const Color(0xFF00BCD4),
              backgroundColor: const Color(0xFF1A1A2E),
              child: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification.metrics.pixels >=
                      notification.metrics.maxScrollExtent * 0.8 &&
                      !state.hasReachedMax &&
                      !state.isLoadingMore) {
                    context
                        .read<ExpertFeedBloc>()
                        .add(const LoadMoreExpertsEvent());
                  }
                  return false;
                },
                child: PageView.builder(
                  controller: _pageController,
                  scrollDirection: Axis.vertical,
                  physics: const BouncingScrollPhysics(),
                  itemCount: state.experts.length +
                      (state.isLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == state.experts.length) {
                      return const ExpertFeedSkeleton();
                    }
                    return ExpertFeedCard(
                      expert: state.experts[index],
                    );
                  },
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF00BCD4), Color(0xFF0097A7)],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          'praktix',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 15,
            letterSpacing: 1.5,
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search_rounded, color: Colors.white),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: Colors.white),
          onPressed: () {},
        ),
        const SizedBox(width: 4),
      ],
    );
  }
}

// ─────────────────────────────────────────────
class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off_rounded, color: Colors.white24, size: 72),
            const SizedBox(height: 20),
            Text(
              'Something went wrong',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              message,
              style: GoogleFonts.inter(color: Colors.white54, fontSize: 13),
              textAlign: TextAlign.center,
              maxLines: 3,
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00BCD4),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    horizontal: 28, vertical: 13),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                textStyle: GoogleFonts.inter(
                    fontWeight: FontWeight.w600, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}