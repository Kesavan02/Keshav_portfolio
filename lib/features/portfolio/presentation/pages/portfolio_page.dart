import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme.dart';
import '../bloc/portfolio_bloc.dart';
import '../bloc/portfolio_state.dart';
import '../widgets/experience_section.dart';
import '../widgets/hero_section.dart';
import '../widgets/projects_section.dart';
import '../widgets/skills_section.dart';
import '../widgets/contact_section.dart';
import '../widgets/floating_navbar.dart';
import '../../domain/entities/portfolio_data.dart';

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _drawerAnimationController;
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _skillsKey = GlobalKey();
  final GlobalKey _experienceKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  int _selectedDrawerIndex = 0;
  bool _isProjectsExpanded = false;
  bool _showBottomNavbar = false;

  @override
  void initState() {
    super.initState();
    _drawerAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    // Top header height is ~60-70px. The moment scroll offset exceeds 60px, the header has completely disappeared off-screen.
    // Immediately activate the bottom floating navbar!
    final scrolledPastHeader = _scrollController.offset > 60;
    if (scrolledPastHeader != _showBottomNavbar) {
      setState(() {
        _showBottomNavbar = scrolledPastHeader;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _drawerAnimationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleDrawer() {
    if (_drawerAnimationController.isDismissed) {
      _drawerAnimationController.forward();
    } else {
      _drawerAnimationController.reverse();
    }
  }

  void _scrollToKey(GlobalKey key) {
    final targetContext = key.currentContext;
    if (targetContext != null && targetContext.mounted) {
      final renderBox = targetContext.findRenderObject();
      if (renderBox is RenderBox && _scrollController.hasClients) {
        final currentOffset = _scrollController.offset;
        final targetOffset =
            renderBox.localToGlobal(Offset.zero).dy + currentOffset;
        final distance = (targetOffset - currentOffset).abs();

        // Calculate smooth fluid duration based on distance (800ms for short, up to 1400ms for long)
        final durationMs = (800 + (distance * 0.25)).clamp(800.0, 1400.0).toInt();

        _scrollController.animateTo(
          targetOffset.clamp(
            0.0,
            _scrollController.position.maxScrollExtent,
          ),
          duration: Duration(milliseconds: durationMs),
          curve: Curves.easeInOutCubic,
        );
        return;
      }

      Scrollable.ensureVisible(
        targetContext,
        duration: const Duration(milliseconds: 1200),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _scrollToProject(int index, int totalProjects) async {
    if (totalProjects <= 0) return;

    final screenHeight = MediaQuery.of(context).size.height;
    final scrollExtent = screenHeight * totalProjects * 0.8;
    final double targetFraction = totalProjects > 1
        ? (index / (totalProjects - 1))
        : 0.0;
    final double projectOffsetInsideSliver = targetFraction * scrollExtent;

    BuildContext? projectsContext = _projectsKey.currentContext;

    if (projectsContext == null) {
      final estimate = math.min(
        1000.0,
        _scrollController.position.maxScrollExtent,
      );
      _scrollController.jumpTo(estimate);
      await WidgetsBinding.instance.endOfFrame;
      if (!mounted) return;
      projectsContext = _projectsKey.currentContext;
    }

    if (projectsContext != null && projectsContext.mounted) {
      final renderObject = projectsContext.findRenderObject();
      if (renderObject is RenderBox && _scrollController.hasClients) {
        final sliverOffset =
            renderObject.localToGlobal(Offset.zero).dy + _scrollController.offset;
        final double targetScrollOffset =
            sliverOffset + projectOffsetInsideSliver;
        final distance = (targetScrollOffset - _scrollController.offset).abs();
        final durationMs = (800 + (distance * 0.25)).clamp(800.0, 1400.0).toInt();

        _scrollController.animateTo(
          targetScrollOffset.clamp(
            0.0,
            _scrollController.position.maxScrollExtent,
          ),
          duration: Duration(milliseconds: durationMs),
          curve: Curves.easeInOutCubic,
        );
      }
    }
  }

  Widget _buildDrawerMenu(List<Project> projects) {
    return SafeArea(
      child: Container(
        width: 250,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Profile Info Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [AppColors.primaryGlow, AppColors.accentCyan],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryGlow.withValues(alpha: 0.4),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: const CircleAvatar(
                    radius: 26,
                    backgroundColor: AppColors.cardColor,
                    backgroundImage: AssetImage('assets/keshu_avatar.png'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Kesavan K',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          letterSpacing: 0.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Flutter Application Dev',
                        style: TextStyle(
                          color: AppColors.accentCyan.withValues(alpha: 0.9),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 35),
            Divider(color: AppColors.accentCyan.withValues(alpha: 0.2)),
            const SizedBox(height: 15),

            // Navigation Items
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildDrawerMenuItem(
                      icon: Icons.home_rounded,
                      title: 'Home',
                      isSelected: _selectedDrawerIndex == 0,
                      onTap: () {
                        setState(() => _selectedDrawerIndex = 0);
                        _scrollController.animateTo(
                          0,
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeInOut,
                        );
                        _toggleDrawer();
                      },
                    ),
                    _buildDrawerMenuItem(
                      icon: Icons.person_rounded,
                      title: 'About & Skills',
                      isSelected: _selectedDrawerIndex == 1,
                      onTap: () {
                        setState(() => _selectedDrawerIndex = 1);
                        _scrollToKey(_skillsKey);
                        _toggleDrawer();
                      },
                    ),
                    _buildDrawerMenuItem(
                      icon: Icons.rocket_launch_rounded,
                      title: 'Projects',
                      isSelected: _selectedDrawerIndex == 2,
                      trailing: Icon(
                        _isProjectsExpanded
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        color: AppColors.accentCyan,
                        size: 20,
                      ),
                      onTap: () {
                        setState(() {
                          _selectedDrawerIndex = 2;
                          _isProjectsExpanded = !_isProjectsExpanded;
                        });
                        _scrollToKey(_projectsKey);
                      },
                    ),

                    // Expandable list of projects inside drawer
                    if (_isProjectsExpanded && projects.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(left: 32, bottom: 8),
                        child: Column(
                          children: List.generate(projects.length, (idx) {
                            final project = projects[idx];
                            return InkWell(
                              onTap: () {
                                _scrollToProject(idx, projects.length);
                                _toggleDrawer();
                              },
                              borderRadius: BorderRadius.circular(8),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 10,
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.subdirectory_arrow_right_rounded,
                                      color: AppColors.accentCyan,
                                      size: 14,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        project.title,
                                        style: const TextStyle(
                                          color: AppColors.textSecondary,
                                          fontSize: 13,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                      ),

                    _buildDrawerMenuItem(
                      icon: Icons.work_rounded,
                      title: 'Experience',
                      isSelected: _selectedDrawerIndex == 3,
                      onTap: () {
                        setState(() => _selectedDrawerIndex = 3);
                        _scrollToKey(_experienceKey);
                        _toggleDrawer();
                      },
                    ),
                    _buildDrawerMenuItem(
                      icon: Icons.mail_rounded,
                      title: 'Contact',
                      isSelected: _selectedDrawerIndex == 4,
                      onTap: () {
                        setState(() => _selectedDrawerIndex = 4);
                        _scrollToKey(_contactKey);
                        _toggleDrawer();
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerMenuItem({
    required IconData icon,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryGlow.withValues(alpha: 0.25)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.accentCyan.withValues(alpha: 0.5)
                : Colors.transparent,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 4,
              height: 20,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.accentCyan : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            Icon(
              icon,
              color: isSelected
                  ? AppColors.accentCyan
                  : AppColors.textSecondary,
              size: 20,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ),
            ?trailing,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 850;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: BlocBuilder<PortfolioBloc, PortfolioState>(
        builder: (context, state) {
          final isLoaded = state is PortfolioLoaded;
          final isError = state is PortfolioError;
          final List<Project> projects = isLoaded
              ? state.portfolioData.projects
              : const <Project>[];

          return Stack(
            children: [
              // 1. BACKGROUND DRAWER MENU (Visible on Mobile)
              if (isMobile) _buildDrawerMenu(projects),

              // 2. MAIN SCREEN WITH ZOOM & 3D ROTATION TRANSITION
              AnimatedBuilder(
                animation: _drawerAnimationController,
                builder: (context, child) {
                  final double value = _drawerAnimationController.value;
                  final double slide = isMobile ? 220.0 * value : 0.0;
                  final double scale = isMobile ? 1.0 - (value * 0.18) : 1.0;
                  final double rotate = isMobile ? -0.05 * value : 0.0;

                  return Transform(
                    transform: Matrix4.identity()
                      ..translateByDouble(slide, 0.0, 0.0, 1.0)
                      ..scaleByDouble(scale, scale, 1.0, 1.0)
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(rotate),
                    alignment: Alignment.centerLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.backgroundDark,
                        borderRadius: BorderRadius.circular(
                          isMobile ? value * 24.0 : 0.0,
                        ),
                        boxShadow: [
                          if (isMobile && value > 0)
                            BoxShadow(
                              color: Colors.black.withValues(
                                alpha: 0.6 * value,
                              ),
                              blurRadius: 25 * value,
                              spreadRadius: 3 * value,
                              offset: const Offset(-8, 8),
                            ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          isMobile ? value * 24.0 : 0.0,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            if (isMobile &&
                                _drawerAnimationController.value > 0.0) {
                              _toggleDrawer();
                            }
                          },
                          behavior: HitTestBehavior.opaque,
                          child: IgnorePointer(
                            ignoring:
                                isMobile &&
                                _drawerAnimationController.value > 0.0,
                            child: child,
                          ),
                        ),
                      ),
                    ),
                  );
                },
                child: Stack(
                  children: [
                    // Ambient glowing background circles
                    Positioned(
                      top: -200,
                      left: -200,
                      child: Container(
                        width: 600,
                        height: 600,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.secondaryGlow.withValues(
                            alpha: 0.15,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -200,
                      right: -200,
                      child: Container(
                        width: 800,
                        height: 800,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryGlow.withValues(alpha: 0.15),
                        ),
                      ),
                    ),

                    CustomScrollView(
                      controller: _scrollController,
                      slivers: [
                        // ── Hero Section ─────────────────────────────────────
                        SliverToBoxAdapter(
                          child: HeroSection(
                            projects: projects,
                            onMenuTap: _toggleDrawer,
                            onAboutTap: () => _scrollToKey(_skillsKey),
                            onSkillsTap: () => _scrollToKey(_skillsKey),
                            onProjectsTap: () => _scrollToKey(_projectsKey),
                            onProjectSelect: (index) =>
                                _scrollToProject(index, projects.length),
                            onExperienceTap: () => _scrollToKey(_experienceKey),
                            onContactTap: () => _scrollToKey(_contactKey),
                          ),
                        ),

                        // ── Data-driven sections ────────────────────────────
                        if (isLoaded) ...[
                          SliverToBoxAdapter(
                            child: Center(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: 1200,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    KeyedSubtree(
                                      key: _skillsKey,
                                      child: SkillsSection(
                                        skills: state.portfolioData.skills,
                                        certifications:
                                            state.portfolioData.certifications,
                                      ),
                                    ),
                                    KeyedSubtree(
                                      key: _experienceKey,
                                      child: ExperienceSection(
                                        experiences:
                                            state.portfolioData.experiences,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SliverMainAxisGroup(
                            slivers: [
                              SliverToBoxAdapter(
                                child: SizedBox(
                                  key: _projectsKey,
                                  height: 0,
                                ),
                              ),
                              ProjectsSliver(
                                projects: state.portfolioData.projects,
                              ),
                            ],
                          ),
                          SliverToBoxAdapter(
                            child: Center(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: 1200,
                                ),
                                child: KeyedSubtree(
                                  key: _contactKey,
                                  child: const ContactSection(),
                                ),
                              ),
                            ),
                          ),
                        ],

                        // ── Inline error state ────────────────────────────────
                        if (isError)
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.all(40),
                              child: Center(
                                child: Text(
                                  state.message,
                                  style: const TextStyle(
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),

                    // ── Bottom Floating Navbar (Activates when top header disappears) ──
                    if (!isMobile)
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeOutCubic,
                        bottom: _showBottomNavbar ? 24.0 : -100.0,
                        left: 0,
                        right: 0,
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 300),
                          opacity: _showBottomNavbar ? 1.0 : 0.0,
                          child: FloatingNavbar(
                            projects: projects,
                            isAtBottom: true,
                            onMenuTap: _toggleDrawer,
                            onHomeTap: () => _scrollController.animateTo(
                              0,
                              duration: const Duration(milliseconds: 600),
                              curve: Curves.easeInOut,
                            ),
                            onAboutTap: () => _scrollToKey(_skillsKey),
                            onSkillsTap: () => _scrollToKey(_skillsKey),
                            onProjectsTap: () => _scrollToKey(_projectsKey),
                            onProjectSelect: (index) =>
                                _scrollToProject(index, projects.length),
                            onExperienceTap: () => _scrollToKey(_experienceKey),
                            onContactTap: () => _scrollToKey(_contactKey),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
