import 'package:flutter/material.dart';
import '../../../../core/theme.dart';
import 'hero_video.dart';

/// Total scroll buffer that maps to the full video duration.
const double _kScrollBuffer = 2500.0;

class HeroSliver extends StatefulWidget {
  final ScrollController scrollController;
  const HeroSliver({super.key, required this.scrollController});

  @override
  State<HeroSliver> createState() => _HeroSliverState();
}

class _HeroSliverState extends State<HeroSliver> {
  HeroVideoController? _videoController;

  /// True once the video metadata is decoded and the first frame is ready.
  bool _videoReady = false;

  /// Controls the fade-in of the video over the placeholder gradient.
  double _videoOpacity = 0.0;

  /// Which text overlay to show (Part1 = intro, Part2 = passion).
  final ValueNotifier<bool> _showPart1Notifier = ValueNotifier<bool>(true);

  /// The latest scroll-driven progress (0.0 → 1.0).
  double _desiredProgress = 0.0;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
    _initVideoBackground();
  }

  void _initVideoBackground() {
    HeroVideoController? ctrl;
    ctrl = HeroVideoController(
      onReady: () {
        if (!mounted || ctrl == null) return;
        setState(() {
          _videoController = ctrl;
          _videoReady = true;
        });

        // Immediately sync to wherever the user has already scrolled to.
        if (widget.scrollController.hasClients) {
          final offset = widget.scrollController.offset.clamp(0.0, _kScrollBuffer);
          _desiredProgress = offset / _kScrollBuffer;
          ctrl.seekTo(_desiredProgress);
        }

        // Small delay before starting the fade so the first frame paints.
        Future.delayed(const Duration(milliseconds: 80), () {
          if (mounted) {
            setState(() => _videoOpacity = 1.0);
          }
        });
      },
    );
  }

  void _onScroll() {
    if (!widget.scrollController.hasClients) return;

    final offset = widget.scrollController.offset.clamp(0.0, _kScrollBuffer);
    final progress = offset / _kScrollBuffer;

    // Switch overlay at the video midpoint.
    final showPart1 = progress < 0.5;
    if (showPart1 != _showPart1Notifier.value) {
      _showPart1Notifier.value = showPart1;
    }

    if (!_videoReady || _videoController == null) return;

    _desiredProgress = progress;
    _videoController!.seekTo(progress);
  }

  @override
  void dispose() {
    _videoController?.dispose();
    widget.scrollController.removeListener(_onScroll);
    _showPart1Notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;
    return SliverPersistentHeader(
      pinned: true,
      delegate: _HeroSliverDelegate(
        minHeight: screenH,
        maxHeight: screenH + _kScrollBuffer,
        videoController: _videoReady ? _videoController : null,
        videoOpacity: _videoOpacity,
        showPart1Notifier: _showPart1Notifier,
        buildDesktopLayout: _buildDesktopLayout,
        buildMobileLayout: _buildMobileLayout,
      ),
    );
  }

  // ── Layouts ──────────────────────────────────────────────────────────────────

  Widget _buildDesktopLayout(bool showPart1) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left — Part 2 (fades in after midpoint)
        Expanded(
          flex: 10,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            opacity: showPart1 ? 0.0 : 1.0,
            child: AnimatedSlide(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOut,
              offset: showPart1 ? const Offset(-0.2, 0) : Offset.zero,
              child: _buildPart2Content(isMobile: false),
            ),
          ),
        ),
        const Spacer(flex: 2),
        // Right — Part 1 (visible at start)
        Expanded(
          flex: 10,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            opacity: showPart1 ? 1.0 : 0.0,
            child: AnimatedSlide(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOut,
              offset: showPart1 ? Offset.zero : const Offset(0.2, 0),
              child: _buildPart1Content(isMobile: false),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(bool showPart1) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.2),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
          child: showPart1
              ? KeyedSubtree(
                  key: const ValueKey('part1'),
                  child: _buildPart1Content(isMobile: true),
                )
              : KeyedSubtree(
                  key: const ValueKey('part2'),
                  child: _buildPart2Content(isMobile: true),
                ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  // ── Content Blocks ───────────────────────────────────────────────────────────

  Widget _buildPart1Content({required bool isMobile}) {
    return Column(
      crossAxisAlignment: isMobile
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.primaryGlow.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: AppColors.primaryGlow.withValues(alpha: 0.3),
            ),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.waving_hand, color: Colors.amber, size: 20),
              SizedBox(width: 10),
              Text(
                "Hello! I am Kesavan",
                style: TextStyle(
                  color: AppColors.accentCyan,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        Text(
          "Flutter Software Engineer",
          style: TextStyle(
            fontSize: isMobile ? 32 : 48,
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
            height: 1.2,
          ),
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
        ),
        const SizedBox(height: 20),
        RichText(
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
          text: const TextSpan(
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
            children: [
              TextSpan(
                text:
                    "Currently crafting digital experiences as a\nMobile & Web Application Intern at ",
              ),
              TextSpan(
                text: "Brix Networks",
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPart2Content({required bool isMobile}) {
    return Column(
      crossAxisAlignment: isMobile
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          "I'm a Developer who",
          style: TextStyle(
            fontSize: 20,
            color: AppColors.textSecondary,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 10),
        RichText(
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
          text: TextSpan(
            style: TextStyle(
              fontSize: isMobile ? 42 : 70,
              height: 1.1,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
              fontFamily: 'Roboto',
            ),
            children: [
              const TextSpan(text: "Builds apps with\n"),
              TextSpan(
                text: "passion.",
                style: TextStyle(
                  color: AppColors.accentCyan,
                  shadows: [
                    Shadow(
                      color: AppColors.accentCyan.withValues(alpha: 0.6),
                      blurRadius: 30,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          "Because if the code doesn't impress, what else can?",
          style: TextStyle(
            fontSize: 16,
            color: AppColors.textSecondary,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 50),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primaryGlow, AppColors.accentCyan],
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryGlow.withValues(alpha: 0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const Text(
              "Explore My Work",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Delegate ─────────────────────────────────────────────────────────────────
// videoController is null until the video is ready — the placeholder gradient
// is shown until then. shouldRebuild only fires on size / opacity changes.
// ─────────────────────────────────────────────────────────────────────────────
class _HeroSliverDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final HeroVideoController? videoController;
  final double videoOpacity;
  final ValueNotifier<bool> showPart1Notifier;
  final Widget Function(bool showPart1) buildDesktopLayout;
  final Widget Function(bool showPart1) buildMobileLayout;

  _HeroSliverDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.videoController,
    required this.videoOpacity,
    required this.showPart1Notifier,
    required this.buildDesktopLayout,
    required this.buildMobileLayout,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  bool shouldRebuild(covariant _HeroSliverDelegate oldDelegate) {
    return videoController != oldDelegate.videoController ||
        videoOpacity != oldDelegate.videoOpacity ||
        maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight;
  }

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox(
      height: minHeight,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // ── Background layer ────────────────────────────────────────────────
          // The gradient placeholder is always present.
          // The video cross-fades on top of it once ready.
          Positioned.fill(child: _GradientPlaceholder()),

          if (videoController != null)
            Positioned.fill(
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeIn,
                opacity: videoOpacity,
                child: RepaintBoundary(
                  child: HeroVideoView(controller: videoController!),
                ),
              ),
            ),

          // ── Content overlay ─────────────────────────────────────────────────
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 80,
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isDesktop = constraints.maxWidth > 900;
                    return ValueListenableBuilder<bool>(
                      valueListenable: showPart1Notifier,
                      builder: (_, showPart1, _) {
                        return isDesktop
                            ? buildDesktopLayout(showPart1)
                            : buildMobileLayout(showPart1);
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A rich dark-gradient placeholder visible immediately on first paint.
/// Matches the portfolio's dark colour palette so the transition to the video
/// feels seamless rather than jarring.
class _GradientPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 1.2,
          colors: [
            AppColors.secondaryGlow.withValues(alpha: 0.35),
            AppColors.backgroundDark,
          ],
        ),
      ),
    );
  }
}
