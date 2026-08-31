import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme.dart';
import '../../domain/entities/portfolio_data.dart';
import 'floating_navbar.dart';

class HeroSection extends StatefulWidget {
  final List<Project> projects;
  final VoidCallback? onAboutTap;
  final VoidCallback? onSkillsTap;
  final VoidCallback? onProjectsTap;
  final Function(int index)? onProjectSelect;
  final VoidCallback? onExperienceTap;
  final VoidCallback? onContactTap;
  final VoidCallback? onMenuTap;

  const HeroSection({
    super.key,
    required this.projects,
    this.onAboutTap,
    this.onSkillsTap,
    this.onProjectsTap,
    this.onProjectSelect,
    this.onExperienceTap,
    this.onContactTap,
    this.onMenuTap,
  });

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with TickerProviderStateMixin {
  late AnimationController _entranceController;
  late AnimationController _floatController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // 1. Initial entrance animation for half-body hero avatar
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // 2. Micro floating animation for scattered tech logos
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.84, end: 1.0).animate(
      CurvedAnimation(parent: _entranceController, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entranceController, curve: Curves.easeIn),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _entranceController,
            curve: Curves.easeOutCubic,
          ),
        );

    _entranceController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isDesktop = screenWidth > 950;

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: math.max(680.0, screenHeight * 1)),
      color: AppColors.backgroundDark,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Background ambient glowing mesh Orbs
          Positioned(
            top: -120,
            left: -120,
            child: Container(
              width: 550,
              height: 550,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryGlow.withValues(alpha: 0.18),
              ),
            ),
          ),

          // ── Main Hero Body ───────────────────────────────────────────────
          Column(
            children: [
              const SizedBox(
                height: 120,
              ), // Spacer for top navbar header height
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1250),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isDesktop ? 40 : 20,
                      vertical: isDesktop ? 24 : 12,
                    ),
                    child: isDesktop
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 12,
                                child: _buildLeftHeroContent(isDesktop: true),
                              ),
                              const SizedBox(width: 40),
                              Expanded(
                                flex: 11,
                                child: _buildRightAvatarSection(
                                  isDesktop: true,
                                ),
                              ),
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 10),
                              _buildRightAvatarSection(isDesktop: false),
                              const SizedBox(height: 20),
                              _buildLeftHeroContent(isDesktop: false),
                              const SizedBox(height: 16),
                            ],
                          ),
                  ),
                ),
              ),
            ],
          ),

          // ── Top Navigation Bar Header (Rendered LAST so it sits on top of all hero elements & tech logos) ──
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildNavigationBar(context),
          ),
        ],
      ),
    );
  }

  // ── Navigation Bar Header (Merged in Hero Section) ─────────
  Widget _buildNavigationBar(BuildContext context) {
    return FloatingNavbar(
      projects: widget.projects,
      isAtBottom: false,
      onHomeTap: () {},
      onAboutTap: widget.onAboutTap,
      onSkillsTap: widget.onSkillsTap,
      onProjectsTap: widget.onProjectsTap,
      onProjectSelect: widget.onProjectSelect,
      onExperienceTap: widget.onExperienceTap,
      onContactTap: widget.onContactTap,
      onMenuTap: widget.onMenuTap,
    );
  }

  // ── Left Hero Content Column ──────────────────────────────────────────────
  Widget _buildLeftHeroContent({required bool isDesktop}) {
    return Column(
      crossAxisAlignment: isDesktop
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Greeting Pill
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.accentCyan.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: AppColors.accentCyan.withValues(alpha: 0.4),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.accentCyan.withValues(alpha: 0.15),
                blurRadius: 10,
              ),
            ],
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("👋", style: TextStyle(fontSize: 16)),
              SizedBox(width: 8),
              Text(
                "Hi, I'm Kesavan K",
                style: TextStyle(
                  color: AppColors.accentCyan,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),

        // Main Catchy Headline
        RichText(
          textAlign: isDesktop ? TextAlign.left : TextAlign.center,
          text: TextSpan(
            style: TextStyle(
              fontSize: isDesktop ? 44 : 32,
              height: 1.18,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              fontFamily: 'Roboto',
            ),
            children: [
              const TextSpan(text: "Building "),
              TextSpan(
                text: "Scalable Mobile",
                style: TextStyle(
                  foreground: Paint()
                    ..shader = const LinearGradient(
                      colors: [AppColors.accentCyan, AppColors.accentPurple],
                    ).createShader(const Rect.fromLTWH(0.0, 0.0, 300.0, 70.0)),
                ),
              ),
              const TextSpan(text: " & Web Applications."),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Role Title Subheading
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: isDesktop
              ? MainAxisAlignment.start
              : MainAxisAlignment.center,
          children: [
            Container(width: 12, height: 2, color: AppColors.accentCyan),
            const SizedBox(width: 8),
            const Flexible(
              child: Text(
                "Flutter Software Engineer • Clean Architecture",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Value Proposition Paragraph
        Text(
          "Specialized in crafting high-performance, modular Flutter solutions with robust BLoC state management and delightful UI/UX animations for mobile and web.",
          style: TextStyle(
            fontSize: isDesktop ? 15 : 14,
            color: AppColors.textSecondary.withValues(alpha: 0.9),
            height: 1.65,
          ),
          textAlign: isDesktop ? TextAlign.left : TextAlign.center,
        ),
        const SizedBox(height: 28),

        // Highlights Quick Stats Strip
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.cardColor.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.primaryGlow.withValues(alpha: 0.3),
            ),
          ),
          child: Wrap(
            alignment: isDesktop ? WrapAlignment.start : WrapAlignment.center,
            spacing: 20,
            runSpacing: 12,
            children: [
              _buildStatBadge("⚡ 1+ Yrs", "Experience"),
              _buildStatBadge("📱 7+", "Apps Built"),
              _buildStatBadge("🎯 Clean", "Architecture"),
            ],
          ),
        ),
        const SizedBox(height: 28),

        // Action Buttons & Social Links
        Wrap(
          alignment: isDesktop ? WrapAlignment.start : WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 16,
          runSpacing: 16,
          children: [
            // Primary CTA: Explore Work
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: widget.onProjectsTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.accentCyan, AppColors.primaryGlow],
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accentCyan.withValues(alpha: 0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Explore Projects",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Secondary CTA: Contact Me
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: widget.onContactTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.cardColor.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: AppColors.accentCyan.withValues(alpha: 0.5),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.mail_outline_rounded,
                        color: AppColors.accentCyan,
                        size: 18,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Contact Me",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Social Links
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildSocialLinkIcon(
                  const FaIcon(
                    FontAwesomeIcons.github,
                    color: Colors.white,
                    size: 18,
                  ),
                  'https://github.com/Kesavan02',
                ),
                const SizedBox(width: 10),
                _buildSocialLinkIcon(
                  const FaIcon(
                    FontAwesomeIcons.linkedinIn,
                    color: Colors.white,
                    size: 18,
                  ),
                  'https://www.linkedin.com/in/kesavan-k-224b09253',
                ),
                const SizedBox(width: 10),
                _buildSocialLinkIcon(
                  const Icon(
                    Icons.email_outlined,
                    color: Colors.white,
                    size: 19,
                  ),
                  'mailto:keshavsreenivas@gmail.com',
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatBadge(String title, String subtitle) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 14,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                color: AppColors.textSecondary.withValues(alpha: 0.8),
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialLinkIcon(Widget iconWidget, String url) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          if (url.startsWith('mailto:')) {
            final email = url.replaceFirst('mailto:', '');
            final gmailUrl = Uri.parse(
              'https://mail.google.com/mail/?view=cm&fs=1&to=$email',
            );
            launchUrl(
              gmailUrl,
              mode: LaunchMode.externalApplication,
              webOnlyWindowName: '_blank',
            );
          } else {
            launchUrl(
              Uri.parse(url),
              mode: LaunchMode.externalApplication,
              webOnlyWindowName: '_blank',
            );
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(11),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.06),
            border: Border.all(color: Colors.white24),
          ),
          child: iconWidget,
        ),
      ),
    );
  }

  // ── Theme Color Bottom Fade Avatar & Scattered PNG Logos from assets/logos ───
  Widget _buildRightAvatarSection({required bool isDesktop}) {
    final containerWidth = isDesktop ? 500.0 : 340.0;
    final containerHeight = isDesktop ? 500.0 : 360.0;
    final avatarHeight = isDesktop ? 480.0 : 310.0;

    return AnimatedBuilder(
      animation: Listenable.merge([_entranceController, _floatController]),
      builder: (context, child) {
        final floatOffset = math.sin(_floatController.value * 2 * math.pi) * 6;

        return SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: SizedBox(
                width: containerWidth,
                height: containerHeight,
                child: Stack(
                  alignment: isDesktop
                      ? Alignment.bottomRight
                      : Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    // 1. Ambient Background Core Radial Glow
                    Positioned(
                      bottom: isDesktop ? 40 : 20,
                      right: isDesktop ? 30 : null,
                      child: Container(
                        width: 280,
                        height: 280,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryGlow.withValues(alpha: 0.25),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryGlow.withValues(
                                alpha: 0.4,
                              ),
                              blurRadius: 100,
                              spreadRadius: 25,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // 2. Scattered Tech Stack Logos from assets/logos/

                    // Flutter Logo (Top-Left)
                    Positioned(
                      top: isDesktop ? 30 + floatOffset : 15 + floatOffset,
                      left: isDesktop ? 20 : 10,
                      child: _buildScatteredPngBadge(
                        assetPath: 'assets/logos/flutter.png',
                        label: "Flutter",
                        glowColor: const Color(0xFF02569B),
                        logoSize: isDesktop ? 44 : 34,
                      ),
                    ),

                    // Dart Logo (Top-Right)
                    Positioned(
                      top: isDesktop ? 50 - floatOffset : 25 - floatOffset,
                      right: isDesktop ? 35 : 15,
                      child: _buildScatteredPngBadge(
                        assetPath: 'assets/logos/dart.png',
                        label: "Dart",
                        glowColor: const Color(0xFF00E5FF),
                        logoSize: isDesktop ? 40 : 32,
                      ),
                    ),

                    // GitHub Logo (Middle-Right)
                    Positioned(
                      top: isDesktop ? 190 + floatOffset : 130 + floatOffset,
                      right: isDesktop ? 15 : 5,
                      child: _buildScatteredPngBadge(
                        assetPath: 'assets/logos/github.png',
                        label: "GitHub",
                        glowColor: Colors.white,
                        logoSize: isDesktop ? 44 : 34,
                      ),
                    ),

                    // Java Logo (Middle-Left)
                    Positioned(
                      top: isDesktop ? 180 - floatOffset : 120 - floatOffset,
                      left: isDesktop ? 35 : 10,
                      child: _buildScatteredPngBadge(
                        assetPath: 'assets/logos/java.png',
                        label: "Java",
                        glowColor: Colors.orangeAccent,
                        logoSize: isDesktop ? 42 : 32,
                      ),
                    ),

                    // MongoDB Logo (Bottom-Left)
                    Positioned(
                      bottom: isDesktop ? 100 + floatOffset : 60 + floatOffset,
                      left: isDesktop ? 10 : 5,
                      child: _buildScatteredPngBadge(
                        assetPath: 'assets/logos/mongo-db.png',
                        label: "MongoDB",
                        glowColor: const Color(0xFF47A248),
                        logoSize: isDesktop ? 44 : 34,
                      ),
                    ),

                    // Visual Studio Code Logo (Bottom-Right)
                    Positioned(
                      bottom: isDesktop ? 110 - floatOffset : 70 - floatOffset,
                      right: isDesktop ? 50 : 20,
                      child: _buildScatteredPngBadge(
                        assetPath: 'assets/logos/visual-studio-code.png',
                        label: "VS Code",
                        glowColor: const Color(0xFF007ACC),
                        logoSize: isDesktop ? 40 : 32,
                      ),
                    ),

                    // 3. Half-Body Hero Avatar Character with Clean Bottom Edge Gradient Fade
                    Positioned(
                      bottom: isDesktop ? 0 : 0,
                      right: isDesktop ? 20 : null,
                      child: SizedBox(
                        height: avatarHeight,
                        child: ClipRect(
                          child: Align(
                            alignment: Alignment.topCenter,
                            heightFactor:
                                0.70, // Crystal clear half-body upper torso
                            child: ShaderMask(
                              shaderCallback: (Rect bounds) {
                                return const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.black,
                                    Colors.black,
                                    Colors.black,
                                    Colors.transparent,
                                  ],
                                  stops: [0.0, 0.65, 0.88, 1.0],
                                ).createShader(bounds);
                              },
                              blendMode: BlendMode.dstIn,
                              child: Image.asset(
                                'assets/keshu_avatar.png',
                                fit: BoxFit.contain,
                                alignment: Alignment.topCenter,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Center(
                                    child: Icon(
                                      Icons.person,
                                      size: 130,
                                      color: AppColors.textSecondary,
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
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildScatteredPngBadge({
    required String assetPath,
    required String label,
    required Color glowColor,
    required double logoSize,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.cardColor.withValues(alpha: 0.75),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: glowColor.withValues(alpha: 0.5),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: glowColor.withValues(alpha: 1.5),
              blurRadius: 18,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: SizedBox(
          width: logoSize,
          height: logoSize,
          child: Image.asset(
            assetPath,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.code, color: glowColor, size: logoSize * 0.8);
            },
          ),
        ),
      ),
    );
  }
}
