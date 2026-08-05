import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/theme.dart';
import '../../domain/entities/portfolio_data.dart';

class FloatingNavbar extends StatefulWidget {
  final List<Project> projects;
  final VoidCallback? onHomeTap;
  final VoidCallback? onAboutTap;
  final VoidCallback? onSkillsTap;
  final VoidCallback? onProjectsTap;
  final Function(int index)? onProjectSelect;
  final VoidCallback? onExperienceTap;
  final VoidCallback? onContactTap;
  final VoidCallback? onMenuTap;
  final bool isAtBottom;

  const FloatingNavbar({
    super.key,
    required this.projects,
    this.onHomeTap,
    this.onAboutTap,
    this.onSkillsTap,
    this.onProjectsTap,
    this.onProjectSelect,
    this.onExperienceTap,
    this.onContactTap,
    this.onMenuTap,
    this.isAtBottom = false,
  });

  @override
  State<FloatingNavbar> createState() => _FloatingNavbarState();
}

class _FloatingNavbarState extends State<FloatingNavbar> {
  int? _hoveredNavIndex;
  bool _isProjectsHovered = false;
  int? _hoveredProjectIndex;
  Timer? _hideTimer;

  void _onProjectsMouseEnter() {
    _hideTimer?.cancel();
    setState(() {
      _isProjectsHovered = true;
    });
  }

  void _onProjectsMouseExit() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _isProjectsHovered = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 850;

    final navItems = [
      if (isMobile)
        _NavItemData(
          label: "Menu",
          icon: Icons.menu_rounded,
          onTap: widget.onMenuTap,
          isMenu: true,
        ),
      _NavItemData(label: "Home", onTap: widget.onHomeTap),
      _NavItemData(label: "About", onTap: widget.onAboutTap),
      _NavItemData(label: "Skills", onTap: widget.onSkillsTap),
      _NavItemData(
        label: "Projects",
        onTap: widget.onProjectsTap,
        isProjects: true,
      ),
      if (!isMobile)
        _NavItemData(label: "Experience", onTap: widget.onExperienceTap),
      // _NavItemData(label: "Contact", onTap: widget.onContactTap),
    ];

    // ── Projects Dropdown Widget ─────────────────────────────────────────────
    final dropdownWidget = AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: _isProjectsHovered ? 1.0 : 0.0,
      child: IgnorePointer(
        ignoring: !_isProjectsHovered,
        child: MouseRegion(
          onEnter: (_) => _onProjectsMouseEnter(),
          onExit: (_) => _onProjectsMouseExit(),
          child: Container(
            margin: EdgeInsets.only(
              bottom: widget.isAtBottom ? 12 : 0,
              top: widget.isAtBottom ? 0 : 12,
            ),
            constraints: const BoxConstraints(maxWidth: 360),
            decoration: BoxDecoration(
              color: AppColors.cardColor.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.accentCyan.withValues(alpha: 0.5),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryGlow.withValues(alpha: 0.35),
                  blurRadius: 25,
                  offset: const Offset(0, 10),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 15,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Dropdown Header
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.accentCyan.withValues(
                                alpha: 0.15,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.folder_special_rounded,
                              color: AppColors.accentCyan,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            "Projects Directory",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryGlow.withValues(
                                alpha: 0.2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              "${widget.projects.length} Items",
                              style: const TextStyle(
                                color: AppColors.accentCyan,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Divider(
                        color: AppColors.accentCyan.withValues(alpha: 0.2),
                        height: 1,
                      ),
                      const SizedBox(height: 8),

                      // Project Items List
                      if (widget.projects.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Center(
                            child: Text(
                              "No projects available",
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        )
                      else
                        ...List.generate(widget.projects.length, (index) {
                          final project = widget.projects[index];
                          final isHovered = _hoveredProjectIndex == index;

                          return MouseRegion(
                            cursor: SystemMouseCursors.click,
                            onEnter: (_) =>
                                setState(() => _hoveredProjectIndex = index),
                            onExit: (_) =>
                                setState(() => _hoveredProjectIndex = null),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isProjectsHovered = false;
                                });
                                widget.onProjectSelect?.call(index);
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: isHovered
                                      ? AppColors.primaryGlow.withValues(
                                          alpha: 0.25,
                                        )
                                      : AppColors.backgroundDark.withValues(
                                          alpha: 0.4,
                                        ),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isHovered
                                        ? AppColors.accentCyan.withValues(
                                            alpha: 0.6,
                                          )
                                        : Colors.transparent,
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.space_dashboard_rounded,
                                      size: 16,
                                      color: isHovered
                                          ? AppColors.accentCyan
                                          : AppColors.textSecondary,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            project.title,
                                            style: TextStyle(
                                              color: isHovered
                                                  ? Colors.white
                                                  : AppColors.textPrimary,
                                              fontSize: 13,
                                              fontWeight: isHovered
                                                  ? FontWeight.bold
                                                  : FontWeight.w500,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          if (project
                                              .technologies
                                              .isNotEmpty) ...[
                                            const SizedBox(height: 2),
                                            Text(
                                              project.technologies
                                                  .take(3)
                                                  .join(" • "),
                                              style: TextStyle(
                                                color: isHovered
                                                    ? AppColors.accentCyan
                                                          .withValues(
                                                            alpha: 0.9,
                                                          )
                                                    : AppColors.textSecondary
                                                          .withValues(
                                                            alpha: 0.8,
                                                          ),
                                                fontSize: 11,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 12,
                                      color: isHovered
                                          ? AppColors.accentCyan
                                          : AppColors.textSecondary.withValues(
                                              alpha: 0.5,
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    // ── Navigation Link Items List ───────────────────────────────────────────
    final navWidgets = List.generate(navItems.length, (index) {
      final item = navItems[index];
      final isHovered = _hoveredNavIndex == index;

      return MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) {
          setState(() => _hoveredNavIndex = index);
          if (item.isProjects) {
            _onProjectsMouseEnter();
          }
        },
        onExit: (_) {
          setState(() => _hoveredNavIndex = null);
          if (item.isProjects) {
            _onProjectsMouseExit();
          }
        },
        child: GestureDetector(
          onTap: item.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 10 : 16,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: item.isMenu
                  ? AppColors.accentCyan.withValues(alpha: 0.25)
                  : (isHovered
                        ? AppColors.primaryGlow.withValues(alpha: 0.25)
                        : Colors.transparent),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: item.isMenu || isHovered
                    ? AppColors.accentCyan.withValues(alpha: 0.6)
                    : Colors.transparent,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (item.icon != null) ...[
                  Icon(
                    item.icon,
                    size: 16,
                    color: item.isMenu || isHovered
                        ? AppColors.accentCyan
                        : AppColors.textSecondary,
                  ),
                  const SizedBox(width: 6),
                ],
                Text(
                  item.label,
                  style: TextStyle(
                    color: item.isMenu || isHovered
                        ? Colors.white
                        : (widget.isAtBottom
                              ? Colors.white70
                              : AppColors.textSecondary),
                    fontSize: isMobile ? 13 : 14,
                    fontWeight: item.isMenu || isHovered
                        ? FontWeight.bold
                        : FontWeight.w500,
                    letterSpacing: 0.3,
                  ),
                ),
                if (item.isProjects) ...[
                  const SizedBox(width: 4),
                  Icon(
                    _isProjectsHovered
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    size: 16,
                    color: isHovered || _isProjectsHovered
                        ? AppColors.accentCyan
                        : AppColors.textSecondary,
                  ),
                ],
              ],
            ),
          ),
        ),
      );
    });

    // ── Morphing Main Navbar Container ───────────────────────────────────────
    final mainPillWidget = AnimatedContainer(
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeInOutCubic,
      margin: widget.isAtBottom
          ? EdgeInsets.symmetric(horizontal: isMobile ? 12 : 24)
          : EdgeInsets.zero,
      padding: widget.isAtBottom
          ? EdgeInsets.symmetric(horizontal: isMobile ? 8 : 16, vertical: 8)
          : EdgeInsets.symmetric(horizontal: isMobile ? 16 : 40, vertical: 12),
      decoration: BoxDecoration(
        color: widget.isAtBottom
            ? AppColors.cardColor.withValues(alpha: 0.92)
            : AppColors.backgroundDark.withValues(alpha: 0.85),
        borderRadius: widget.isAtBottom
            ? BorderRadius.circular(50)
            : BorderRadius.zero,
        border: widget.isAtBottom
            ? Border.all(
                color: AppColors.primaryGlow.withValues(alpha: 0.4),
                width: 1.5,
              )
            : Border(
                bottom: BorderSide(
                  color: AppColors.accentCyan.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
        boxShadow: widget.isAtBottom
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
                BoxShadow(
                  color: AppColors.primaryGlow.withValues(alpha: 0.25),
                  blurRadius: 20,
                  spreadRadius: -2,
                ),
              ]
            : [],
      ),
      child: ClipRRect(
        borderRadius: widget.isAtBottom
            ? BorderRadius.circular(50)
            : BorderRadius.zero,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: widget.isAtBottom
              // ── Mode 2: Bottom Floating Capsule Navbar (Image 2 Style) ──
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Left Circular Badge (Metallic Eagle Logo)
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.accentCyan.withValues(alpha: 0.6),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.accentCyan.withValues(alpha: 0.35),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/Metallic Eagle.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Center Nav Links
                    ...navWidgets,
                    const SizedBox(width: 8),

                    // Right Pill Button ("Contact Me")
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: widget.onContactTap,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withValues(alpha: 0.3),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: const Text(
                            "Contact Me",
                            style: TextStyle(
                              color: AppColors.backgroundDark,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              // ── Mode 1: Full-Width Top Header Navbar (Image 1 Style) ────
              : Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1250),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Left Logo & Mobile Menu
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isMobile) ...[
                              MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  onTap: widget.onMenuTap,
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    margin: const EdgeInsets.only(right: 12),
                                    decoration: BoxDecoration(
                                      color: AppColors.accentCyan.withValues(
                                        alpha: 0.15,
                                      ),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppColors.accentCyan.withValues(
                                          alpha: 0.5,
                                        ),
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.menu_rounded,
                                      color: AppColors.accentCyan,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.accentCyan.withValues(alpha: 0.8),
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.accentCyan.withValues(
                                      alpha: 0.5,
                                    ),
                                    blurRadius: 12,
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/Metallic Eagle.jpg',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: isMobile ? 19 : 22,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.5,
                                ),
                                children: const [
                                  TextSpan(
                                    text: "Kesavan",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  TextSpan(
                                    text: ".dev",
                                    style: TextStyle(
                                      color: AppColors.accentCyan,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        // Center Nav Links (Desktop & Tablet Only)
                        if (!isMobile)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: navWidgets,
                          ),

                        // Right Pill Button ("Contact Me")
                        if (!isMobile)
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: widget.onContactTap,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      AppColors.primaryGlow,
                                      AppColors.accentCyan,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.accentCyan.withValues(
                                        alpha: 0.35,
                                      ),
                                      blurRadius: 12,
                                    ),
                                  ],
                                ),
                                child: const Text(
                                  "Contact Me",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
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
      ),
    );

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        mainPillWidget,
        Positioned(
          top: widget.isAtBottom ? null : 65,
          bottom: widget.isAtBottom ? 55 : null,
          child: dropdownWidget,
        ),
      ],
    );
  }
}

class _NavItemData {
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool isProjects;
  final bool isMenu;

  _NavItemData({
    required this.label,
    this.icon,
    this.onTap,
    this.isProjects = false,
    this.isMenu = false,
  });
}
