import 'dart:ui';
import 'package:flutter/material.dart';
import '../../domain/entities/portfolio_data.dart';
import '../../../../core/theme.dart';

class ProjectsSliver extends StatelessWidget {
  final List<Project> projects;

  const ProjectsSliver({super.key, required this.projects});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    // Provide a long scrolling extent to smoothly animate all projects
    final scrollExtent = screenHeight * projects.length * 0.8;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _ProjectsSliverDelegate(
        projects: projects,
        minHeight: screenHeight,
        maxHeight: scrollExtent + screenHeight,
      ),
    );
  }
}

class _ProjectsSliverDelegate extends SliverPersistentHeaderDelegate {
  final List<Project> projects;
  final double minHeight;
  final double maxHeight;

  _ProjectsSliverDelegate({
    required this.projects,
    required this.minHeight,
    required this.maxHeight,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final progress = (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0);
    final itemProgress = progress * (projects.length - 1);

    return Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        height: minHeight,
        child: Container(
          color:
              Colors.transparent, // Allow PortfolioPage background glow to show
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isMobile = constraints.maxWidth < 700;
                  final isTablet =
                      constraints.maxWidth >= 700 &&
                      constraints.maxWidth < 1100;

                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 20 : (isTablet ? 40 : 50),
                      vertical: isMobile ? 20 : 50,
                    ),
                    child: isMobile
                        ? _buildMobileLayout(itemProgress)
                        : isTablet
                        ? _buildTabletLayout(itemProgress)
                        : _buildDesktopLayout(itemProgress),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(double itemProgress) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left Side Content
        Expanded(
          flex: 5,
          child: Stack(
            fit: StackFit.passthrough,
            alignment: Alignment.centerLeft,
            children: List.generate(projects.length, (index) {
              final distance = (itemProgress - index);
              // Fade out quickly when moving away
              final opacity = (1.0 - distance.abs() * 2).clamp(0.0, 1.0);
              final translateY = -distance * 50;

              if (opacity == 0) return const SizedBox.shrink();

              return Transform.translate(
                offset: Offset(0, translateY),
                child: Opacity(
                  opacity: opacity,
                  child: _buildIntroContent(projects[index]),
                ),
              );
            }),
          ),
        ),

        // Right Side Cards Stack
        Expanded(
          flex: 6,
          child: Stack(
            alignment: Alignment.centerRight,
            children: List.generate(projects.length, (index) {
              // We render cards in reverse order so index 0 is on top of index 1
              final actualIndex = projects.length - 1 - index;
              return _buildStackedCard(actualIndex, itemProgress);
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildTabletLayout(double itemProgress) {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Stack(
            alignment: Alignment.center,
            children: List.generate(projects.length, (index) {
              final distance = (itemProgress - index);
              final opacity = (1.0 - distance.abs() * 2).clamp(0.0, 1.0);
              final translateY = -distance * 30;

              if (opacity == 0) return const SizedBox.shrink();

              return Transform.translate(
                offset: Offset(0, translateY),
                child: Opacity(
                  opacity: opacity,
                  child: _buildIntroContent(projects[index], isTablet: true),
                ),
              );
            }),
          ),
        ),
        Expanded(
          flex: 4,
          child: Stack(
            alignment: Alignment.topCenter,
            children: List.generate(projects.length, (index) {
              final actualIndex = projects.length - 1 - index;
              return _buildStackedCard(
                actualIndex,
                itemProgress,
                isTablet: true,
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(double itemProgress) {
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: Stack(
            alignment: Alignment.center,
            children: List.generate(projects.length, (index) {
              final distance = (itemProgress - index);
              final opacity = (1.0 - distance.abs() * 2).clamp(0.0, 1.0);
              final translateY = -distance * 30;

              if (opacity == 0) return const SizedBox.shrink();

              return Transform.translate(
                offset: Offset(0, translateY),
                child: Opacity(
                  opacity: opacity,
                  child: _buildIntroContent(projects[index], isMobile: true),
                ),
              );
            }),
          ),
        ),
        Expanded(
          flex: 2,
          child: Stack(
            alignment: Alignment.topCenter,
            children: List.generate(projects.length, (index) {
              final actualIndex = projects.length - 1 - index;
              return _buildStackedCard(
                actualIndex,
                itemProgress,
                isMobile: true,
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildStackedCard(
    int index,
    double itemProgress, {
    bool isMobile = false,
    bool isTablet = false,
  }) {
    final project = projects[index];
    final delta = index - itemProgress;
    // delta = 0 is active card. delta > 0 is behind. delta < 0 is swiped away.

    if (delta < -1.0 || delta > 3.0) {
      return const SizedBox.shrink(); // Optimization
    }

    double scale = 1.0;
    double translateX = 0.0;
    double translateY = 0.0;
    double opacity = 1.0;
    double blur = 0.0;

    if (delta > 0) {
      // Cards waiting behind in the stack
      scale = (1.0 - (delta * 0.08)).clamp(0.0, 1.0);
      translateX = isMobile ? 0 : delta * 50; // Stack to the right on desktop
      translateY = isMobile ? delta * 30 : 0; // Stack downwards on mobile
      blur = delta * 6.0; // Significant blur for back cards
      opacity = (1.0 - (delta * 0.3)).clamp(0.0, 1.0);
    } else {
      // Card swiping away (Move right side, fade out)
      scale = 1.0 + (delta.abs() * 0.05);
      translateX = isMobile
          ? delta.abs() * 100
          : delta.abs() * 400; // Swipe out to the right
      opacity = (1.0 - delta.abs() * 2).clamp(0.0, 1.0);
      blur = 0; // Keep sharp while swiping out
    }

    String imagePath = 'assets/turf_mockup.png';
    if (project.title.contains('ERP')) {
      imagePath = 'assets/erp_mockup.png';
      // ignore: curly_braces_in_flow_control_structures
    } else if (project.title.contains('Expense')) {
      imagePath = 'assets/expense_mockup.png';
    }

    Widget card = Container(
      width: isMobile || isTablet ? double.infinity : 650,
      height: isMobile ? 400 : (isTablet ? 450 : 500),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF09090B), // Very dark almost black
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.8),
            blurRadius: 50,
            spreadRadius: delta > 0 ? 0 : 10,
            offset: const Offset(0, 30),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top Header of Card
          Row(
            children: [
              Text(
                'MOBILE & WEB',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isMobile ? 14 : 18,
                  fontWeight: FontWeight.w400,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white24),
                ),
                child: const Icon(
                  Icons.arrow_forward,
                  color: Colors.white54,
                  size: 14,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Divider(color: Colors.white24, thickness: 1),
              ),
              const SizedBox(width: 16),
              Text(
                'UX & UI',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isMobile ? 14 : 18,
                  fontWeight: FontWeight.w400,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          // Inner Image Container (mockup)
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accentCyan.withValues(alpha: 0.1),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
                border: Border.all(color: Colors.white12, width: 0.5),
              ),
            ),
          ),
        ],
      ),
    );

    if (blur > 0) {
      card = ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: card,
      );
    }

    return Transform.translate(
      offset: Offset(translateX, translateY),
      child: Transform.scale(
        scale: scale,
        child: Opacity(opacity: opacity, child: card),
      ),
    );
  }

  Widget _buildIntroContent(
    Project project, {
    bool isMobile = false,
    bool isTablet = false,
  }) {
    final titleParts = project.title.split(' ');
    final firstPart = titleParts.isNotEmpty ? titleParts.first : '';
    final restPart = titleParts.length > 1
        ? project.title.substring(firstPart.length)
        : '';

    return Column(
      crossAxisAlignment: isMobile || isTablet
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RichText(
          textAlign: isMobile || isTablet ? TextAlign.center : TextAlign.left,
          text: TextSpan(
            style: TextStyle(
              fontSize: isMobile ? 30 : (isTablet ? 48 : 64),
              fontWeight: FontWeight.w300,
              color: AppColors.textPrimary,
              height: 1.1,
              letterSpacing: -1,
            ),
            children: [
              TextSpan(text: '$firstPart '),
              if (restPart.isNotEmpty)
                TextSpan(
                  text: restPart,
                  style: const TextStyle(
                    color: AppColors.accentCyan,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: isMobile || isTablet ? 15 : 30),
        Text(
          project.description,
          style: TextStyle(
            fontSize: isMobile ? 14 : (isTablet ? 16 : 20),
            color: AppColors.textSecondary,
            height: isMobile ? 1.3 : 1.5,
            fontWeight: FontWeight.w300,
          ),
          textAlign: isMobile || isTablet ? TextAlign.center : TextAlign.left,
          maxLines: isMobile || isTablet ? 4 : null,
          overflow: isMobile || isTablet ? TextOverflow.ellipsis : null,
        ),
        SizedBox(height: isMobile || isTablet ? 20 : 40),
        // Decorative vertical line and Tags
        Row(
          mainAxisAlignment: isMobile || isTablet
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (!isMobile && !isTablet)
              Container(
                width: 1,
                height: 40,
                color: Colors.white24,
                margin: const EdgeInsets.only(right: 20),
              ),
            Expanded(
              child: Text(
                project.technologies.join(' / ').toUpperCase(),
                style: TextStyle(
                  fontSize: isMobile ? 10 : 11,
                  color: Colors.white54,
                  letterSpacing: isMobile ? 1 : 2,
                  height: 1.5,
                ),
                textAlign: isMobile ? TextAlign.center : TextAlign.left,
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(covariant _ProjectsSliverDelegate oldDelegate) {
    return oldDelegate.projects != projects ||
        oldDelegate.maxHeight != maxHeight ||
        oldDelegate.minHeight != minHeight;
  }
}
