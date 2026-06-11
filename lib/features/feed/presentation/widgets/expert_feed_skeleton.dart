import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ExpertFeedSkeleton extends StatelessWidget {
  const ExpertFeedSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Shimmer.fromColors(
        baseColor: const Color(0xFF1A1A2E),
        highlightColor: const Color(0xFF2D2D44),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // bg
            Container(color: const Color(0xFF1A1A2E)),
            // bottom content
            Positioned(
              bottom: 24,
              left: 16,
              right: 72,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            height: 14, width: 130, color: Colors.white),
                        const SizedBox(height: 6),
                        Container(height: 11, width: 90, color: Colors.white),
                      ],
                    ),
                  ]),
                  const SizedBox(height: 14),
                  Container(height: 13, color: Colors.white),
                  const SizedBox(height: 5),
                  Container(height: 13, width: 220, color: Colors.white),
                  const SizedBox(height: 18),
                  Row(children: [
                    Expanded(
                        child: Container(
                            height: 42,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ))),
                    const SizedBox(width: 10),
                    Expanded(
                        child: Container(
                            height: 42,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ))),
                  ]),
                ],
              ),
            ),
            // right buttons skeleton
            Positioned(
              right: 12,
              bottom: 110,
              child: Column(
                children: List.generate(
                  3,
                      (_) => Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}