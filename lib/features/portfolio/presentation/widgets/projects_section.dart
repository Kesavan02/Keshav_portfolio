import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../domain/entities/portfolio_data.dart';
import '../../../../core/theme.dart';
import 'project_detail_modal.dart';

class ProjectsSliver extends StatelessWidget {
  final List<Project> projects;

  const ProjectsSliver({super.key, required this.projects});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    // Provide a tight, responsive scrolling extent for all project card transitions
    final scrollExtent = screenHeight * (projects.length - 1) * 0.45;

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
    final currentIndex = itemProgress.round();
    final canGoPrevious = currentIndex > 0;
    final canGoNext = currentIndex < projects.length - 1;

    void scrollToProject(int targetIndex) {
      final scrollable = Scrollable.maybeOf(context);
      if (scrollable == null) return;

      final totalRange = maxExtent - minExtent;
      if (totalRange <= 0) return;

      final currentScrollOffset = scrollable.position.pixels;
      final sliverTopOffset = currentScrollOffset - shrinkOffset;
      final targetProgress = (targetIndex / (projects.length - 1)).clamp(
        0.0,
        1.0,
      );
      final targetScrollOffset =
          sliverTopOffset + (targetProgress * totalRange);

      scrollable.position.animateTo(
        targetScrollOffset,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    }

    return Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        height: minHeight,
        child: Container(
          color: Colors.transparent,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1300),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isMobile = constraints.maxWidth < 700;
                  final isTablet =
                      constraints.maxWidth >= 700 &&
                      constraints.maxWidth < 1100;

                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 12 : (isTablet ? 54 : 64),
                          vertical: isMobile ? 12 : (isTablet ? 16 : 28),
                        ),
                        child: isMobile
                            ? _buildMobileLayout(
                                context,
                                itemProgress,
                                currentIndex,
                                scrollToProject,
                              )
                            : isTablet
                            ? _buildTabletLayout(
                                context,
                                itemProgress,
                                currentIndex,
                              )
                            : _buildDesktopLayout(
                                context,
                                itemProgress,
                                currentIndex,
                              ),
                      ),

                      // Left (Previous) Navigation Arrow Button — Desktop & Tablet
                      if (!isMobile)
                        Positioned(
                          left: isTablet ? 1.5 : 6,
                          child: _NavArrowButton(
                            icon: Icons.arrow_back_ios_new_rounded,
                            isEnabled: canGoPrevious,
                            tooltip: "Previous Project",
                            onTap: () => scrollToProject(currentIndex - 1),
                          ),
                        ),

                      // Right (Next) Navigation Arrow Button — Desktop & Tablet
                      if (!isMobile)
                        Positioned(
                          right: isTablet ? 1.5 : 6,
                          child: _NavArrowButton(
                            icon: Icons.arrow_forward_ios_rounded,
                            isEnabled: canGoNext,
                            tooltip: "Next Project",
                            onTap: () => scrollToProject(currentIndex + 1),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle({
    bool isMobile = false,
    bool isTablet = false,
    bool centered = false,
    int currentIndex = 0,
  }) {
    return Column(
      crossAxisAlignment: centered
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Decorative label tag
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.accentCyan.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.accentCyan.withValues(alpha: 0.45),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accentCyan,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'FEATURED WORK  •  PROJECT ${currentIndex + 1} OF ${projects.length}',
                style: const TextStyle(
                  color: AppColors.accentCyan,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Main heading — "My Projects."
        RichText(
          textAlign: centered ? TextAlign.center : TextAlign.left,
          text: TextSpan(
            children: [
              TextSpan(
                text: 'My ',
                style: TextStyle(
                  fontSize: isMobile ? 30 : (isTablet ? 44 : 52),
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                  letterSpacing: -1.5,
                  height: 1.1,
                ),
              ),
              TextSpan(
                text: 'Projects.',
                style: TextStyle(
                  fontSize: isMobile ? 30 : (isTablet ? 44 : 52),
                  fontWeight: FontWeight.w700,
                  color: AppColors.accentCyan,
                  fontStyle: FontStyle.italic,
                  letterSpacing: -1.5,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // Glowing underline accent bar
        Container(
          width: isMobile ? 60 : 90,
          height: 3,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.accentCyan, AppColors.primaryGlow],
            ),
            borderRadius: BorderRadius.circular(2),
            boxShadow: [
              BoxShadow(
                color: AppColors.accentCyan.withValues(alpha: 0.55),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
      ],
    );
  }

  Widget _buildDesktopLayout(
    BuildContext context,
    double itemProgress,
    int currentIndex,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Static Section Title — above the Row, never animated
        _buildSectionTitle(currentIndex: currentIndex),
        const SizedBox(height: 16),

        // Main content row
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left: animated per-project intro (full height restored)
              Expanded(
                flex: 5,
                child: Stack(
                  fit: StackFit.loose,
                  alignment: Alignment.centerLeft,
                  children: List.generate(projects.length, (index) {
                    final distance = (itemProgress - index);
                    final opacity = (1.0 - distance.abs() * 2).clamp(0.0, 1.0);
                    final translateY = -distance * 50;

                    if (opacity == 0) return const SizedBox.shrink();

                    return Transform.translate(
                      offset: Offset(0, translateY),
                      child: Opacity(
                        opacity: opacity,
                        child: _buildIntroContent(projects[index], context),
                      ),
                    );
                  }),
                ),
              ),

              // Right: stacked project cards
              Expanded(
                flex: 6,
                child: Stack(
                  alignment: Alignment.centerRight,
                  children: List.generate(projects.length, (index) {
                    final actualIndex = projects.length - 1 - index;
                    return _buildStackedCard(actualIndex, itemProgress);
                  }),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabletLayout(
    BuildContext context,
    double itemProgress,
    int currentIndex,
  ) {
    return Column(
      children: [
        // Section Title
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildSectionTitle(
            isTablet: true,
            centered: true,
            currentIndex: currentIndex,
          ),
        ),
        Expanded(
          flex: 5,
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
                  child: _buildIntroContent(
                    projects[index],
                    context,
                    isTablet: true,
                  ),
                ),
              );
            }),
          ),
        ),
        Expanded(
          flex: 6,
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

  Widget _buildMobileLayout(
    BuildContext context,
    double itemProgress,
    int currentIndex,
    void Function(int) scrollToProject,
  ) {
    final canGoPrevious = currentIndex > 0;
    final canGoNext = currentIndex < projects.length - 1;

    return Column(
      children: [
        // Section Title
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: _buildSectionTitle(
            isMobile: true,
            centered: true,
            currentIndex: currentIndex,
          ),
        ),
        Expanded(
          flex: 5,
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
                  child: _buildIntroContent(
                    projects[index],
                    context,
                    isMobile: true,
                  ),
                ),
              );
            }),
          ),
        ),
        Expanded(
          flex: 6,
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
        // Mobile Navigation Bar
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _NavArrowButton(
                icon: Icons.arrow_back_ios_new_rounded,
                isEnabled: canGoPrevious,
                tooltip: "Previous Project",
                size: 38,
                onTap: () => scrollToProject(currentIndex - 1),
              ),
              const SizedBox(width: 14),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF161B22),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.accentCyan.withValues(alpha: 0.35),
                  ),
                ),
                child: Text(
                  '${currentIndex + 1} / ${projects.length}',
                  style: const TextStyle(
                    color: AppColors.accentCyan,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              _NavArrowButton(
                icon: Icons.arrow_forward_ios_rounded,
                isEnabled: canGoNext,
                tooltip: "Next Project",
                size: 38,
                onTap: () => scrollToProject(currentIndex + 1),
              ),
            ],
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

    String imagePath = project.imageUrl ?? 'assets/turf_mockup.png';
    if (project.imageUrl == null) {
      if (project.title.contains('Alert') || project.title.contains('Geo')) {
        imagePath = 'assets/alert_alarmer.jpg';
      } else if (project.title.contains('ERP')) {
        imagePath = 'assets/erp_mockup.png';
      } else if (project.title.contains('Expense')) {
        imagePath = 'assets/expense_mockup.png';
      }
    }

    Widget card = Container(
      width: isMobile || isTablet ? double.infinity : 650,
      height: isMobile ? 360 : (isTablet ? 400 : 500),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: AppColors.primaryGlow.withValues(alpha: 0.25),
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
                (project.category ?? 'FLUTTER & DART').toUpperCase(),
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
              const Flexible(
                child: Divider(color: Colors.white24, thickness: 1),
              ),
              const SizedBox(width: 16),

              // Dynamic Routing Link Button (Replaces UX & UI)
              if (project.githubUrl != null) ...[
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => _launchUrl(project.githubUrl!),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundDark.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.accentCyan.withValues(alpha: 0.6),
                          width: 1,
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FaIcon(
                            FontAwesomeIcons.github,
                            color: Colors.white,
                            size: 13,
                          ),
                          SizedBox(width: 6),
                          Text(
                            "GitHub",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.arrow_outward_rounded,
                            color: AppColors.accentCyan,
                            size: 13,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ] else if (project.playStoreUrl != null) ...[
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => _launchUrl(project.playStoreUrl!),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00E676), Color(0xFF00B0FF)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF00E676,
                            ).withValues(alpha: 0.4),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FaIcon(
                            FontAwesomeIcons.googlePlay,
                            color: Colors.white,
                            size: 12,
                          ),
                          SizedBox(width: 6),
                          Text(
                            "Play Store",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.arrow_outward_rounded,
                            color: Colors.white,
                            size: 13,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ] else ...[
                Text(
                  'FEATURED',
                  style: TextStyle(
                    color: AppColors.accentCyan,
                    fontSize: isMobile ? 12 : 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: isMobile ? 12 : (isTablet ? 14 : 20)),

          // Inner Image Container (mockup)
          Expanded(
            child: MouseRegion(
              cursor:
                  (project.githubUrl != null || project.playStoreUrl != null)
                  ? SystemMouseCursors.click
                  : SystemMouseCursors.basic,
              child: GestureDetector(
                onTap: () {
                  final targetUrl = project.playStoreUrl ?? project.githubUrl;
                  if (targetUrl != null) {
                    _launchUrl(targetUrl);
                  }
                },
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.backgroundDark,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accentCyan.withValues(alpha: 0.1),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                    border: Border.all(color: Colors.white12, width: 0.5),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.contain,
                      alignment: Alignment.center,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppColors.cardColor,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.mobile_friendly_rounded,
                                  size: 44,
                                  color: AppColors.accentCyan,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  project.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
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
    Project project,
    BuildContext context, {
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
      mainAxisSize: MainAxisSize.min,
      children: [
        RichText(
          textAlign: isMobile || isTablet ? TextAlign.center : TextAlign.left,
          text: TextSpan(
            style: TextStyle(
              fontSize: isMobile ? 22 : (isTablet ? 28 : 64),
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
        if (project.tagline != null) ...[
          SizedBox(height: isMobile || isTablet ? 6 : 10),
          Text(
            project.tagline!,
            style: TextStyle(
              fontSize: isMobile ? 12 : (isTablet ? 13 : 16),
              fontWeight: FontWeight.w500,
              color: AppColors.accentCyan.withValues(alpha: 0.9),
              letterSpacing: 0.2,
            ),
            textAlign: isMobile || isTablet ? TextAlign.center : TextAlign.left,
            maxLines: isMobile || isTablet ? 1 : 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        SizedBox(height: isMobile ? 8 : (isTablet ? 8 : 24)),
        Text(
          project.description,
          style: TextStyle(
            fontSize: isMobile ? 13 : (isTablet ? 14 : 20),
            color: AppColors.textSecondary,
            height: isMobile ? 1.25 : 1.5,
            fontWeight: FontWeight.w300,
          ),
          textAlign: isMobile || isTablet ? TextAlign.center : TextAlign.left,
          maxLines: isMobile || isTablet ? 2 : 3,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: isMobile ? 10 : (isTablet ? 10 : 20)),

        // Learn More Button
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => ProjectDetailModal.show(context, project),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(
                horizontal: isMobile || isTablet ? 16 : 22,
                vertical: isMobile || isTablet ? 8 : 10,
              ),
              decoration: BoxDecoration(
                color: AppColors.accentCyan.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: AppColors.accentCyan.withValues(alpha: 0.6),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accentCyan.withValues(alpha: 0.2),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    color: AppColors.accentCyan,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Learn More",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isMobile ? 13 : 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    color: AppColors.accentCyan,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: isMobile || isTablet ? 16 : 24),

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
            Flexible(
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

  Future<void> _launchUrl(String urlString) async {
    final Uri uri = Uri.parse(urlString);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
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

/// Premium Glassmorphic Navigation Arrow Button for manual project switching
class _NavArrowButton extends StatefulWidget {
  final IconData icon;
  final bool isEnabled;
  final VoidCallback onTap;
  final String tooltip;
  final double size;

  const _NavArrowButton({
    required this.icon,
    required this.isEnabled,
    required this.onTap,
    required this.tooltip,
    this.size = 48,
  });

  @override
  State<_NavArrowButton> createState() => _NavArrowButtonState();
}

class _NavArrowButtonState extends State<_NavArrowButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.isEnabled;

    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        cursor: active ? SystemMouseCursors.click : SystemMouseCursors.basic,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: active ? widget.onTap : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: active
                  ? (_isHovered
                        ? AppColors.accentCyan.withValues(alpha: 0.25)
                        : const Color(0xFF161B22).withValues(alpha: 0.85))
                  : Colors.white.withValues(alpha: 0.04),
              border: Border.all(
                color: active
                    ? (_isHovered
                          ? AppColors.accentCyan
                          : AppColors.accentCyan.withValues(alpha: 0.4))
                    : Colors.white10,
                width: 1.5,
              ),
              boxShadow: active && _isHovered
                  ? [
                      BoxShadow(
                        color: AppColors.accentCyan.withValues(alpha: 0.45),
                        blurRadius: 18,
                        spreadRadius: 2,
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.5),
                        blurRadius: 10,
                      ),
                    ],
            ),
            child: Center(
              child: Icon(
                widget.icon,
                size: widget.size * 0.4,
                color: active
                    ? (_isHovered ? Colors.white : AppColors.accentCyan)
                    : Colors.white24,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
