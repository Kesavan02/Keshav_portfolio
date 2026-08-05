import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../domain/entities/portfolio_data.dart';
import '../../../../core/theme.dart';

class SkillsSection extends StatefulWidget {
  final List<Skill> skills;
  final List<Certification> certifications;

  const SkillsSection({
    super.key,
    required this.skills,
    required this.certifications,
  });

  @override
  State<SkillsSection> createState() => _SkillsSectionState();
}

class _SkillsSectionState extends State<SkillsSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 40),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 850;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: isMobile ? 40 : 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Text(
                  "I'm currently looking to join a cross-functional team",
                  style: TextStyle(
                    fontSize: isMobile ? 18 : 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  "that values improving people's lives through accessible design",
                  style: TextStyle(
                    fontSize: isMobile ? 13 : 16,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          SizedBox(height: isMobile ? 40 : 100),

          // Render Mobile Skill Matrix on mobile; Orbital Animation on desktop
          if (isMobile)
            _buildMobileSkillsLayout()
          else
            _buildDesktopOrbitalLayout(),
        ],
      ),
    );
  }

  Widget _buildDesktopOrbitalLayout() {
    const double r1 = 140.0;
    const double r2 = 220.0;
    const double r3 = 300.0;

    return SizedBox(
      height: 450,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 1. Futuristic Holographic Center Badge
          _buildHolographicCentralCore(isMobile: false),

          // 2. Dynamic Orbit Rings
          _buildOrbitRing(r1 * 2, 0.08),
          _buildOrbitRing(r2 * 2, 0.05),
          _buildOrbitRing(r3 * 2, 0.03),

          // 3. Orbiting Icons - Outer Ring (r3)
          OrbitingIcon(
            radius: r3,
            initialAngle: 0,
            iconWidget: Image.asset(
              'assets/logos/java.png',
              width: 26,
              height: 26,
            ),
            label: 'Java',
            glowColor: Colors.orangeAccent,
            speedMultiplier: 1.0,
            controller: _controller,
          ),
          OrbitingIcon(
            radius: r3,
            initialAngle: math.pi / 2,
            iconWidget: const FaIcon(
              FontAwesomeIcons.js,
              color: Colors.yellow,
              size: 22,
            ),
            label: 'JavaScript',
            glowColor: Colors.yellow,
            speedMultiplier: 1.0,
            controller: _controller,
          ),
          OrbitingIcon(
            radius: r3,
            initialAngle: math.pi,
            iconWidget: const FaIcon(
              FontAwesomeIcons.fire,
              color: Colors.amber,
              size: 22,
            ),
            label: 'Firebase',
            glowColor: Colors.amber,
            speedMultiplier: 1.0,
            controller: _controller,
          ),
          OrbitingIcon(
            radius: r3,
            initialAngle: 3 * math.pi / 2,
            iconWidget: Image.asset(
              'assets/logos/mongo-db.png',
              width: 28,
              height: 28,
            ),
            label: 'MongoDB',
            glowColor: const Color(0xFF47A248),
            speedMultiplier: 1.0,
            controller: _controller,
          ),

          // Orbiting Icons - Middle Ring (r2)
          OrbitingIcon(
            radius: r2,
            initialAngle: 0,
            iconWidget: Image.asset(
              'assets/logos/github.png',
              width: 28,
              height: 28,
            ),
            label: 'GitHub',
            glowColor: Colors.white,
            speedMultiplier: -1.2,
            controller: _controller,
          ),
          OrbitingIcon(
            radius: r2,
            initialAngle: 2 * math.pi / 3,
            iconWidget: const FaIcon(
              FontAwesomeIcons.git,
              color: Colors.deepOrange,
              size: 22,
            ),
            label: 'Git',
            glowColor: Colors.deepOrange,
            speedMultiplier: -1.2,
            controller: _controller,
          ),
          OrbitingIcon(
            radius: r2,
            initialAngle: 4 * math.pi / 3,
            iconWidget: Image.asset(
              'assets/logos/visual-studio-code.png',
              width: 26,
              height: 26,
            ),
            label: 'VS Code',
            glowColor: const Color(0xFF007ACC),
            speedMultiplier: -1.2,
            controller: _controller,
          ),

          // Orbiting Icons - Inner Ring (r1)
          OrbitingIcon(
            radius: r1,
            initialAngle: math.pi,
            iconWidget: Image.asset(
              'assets/logos/flutter.png',
              width: 28,
              height: 28,
            ),
            label: 'Flutter',
            glowColor: const Color(0xFF02569B),
            speedMultiplier: 1.5,
            controller: _controller,
          ),
          OrbitingIcon(
            radius: r1,
            initialAngle: 5 * math.pi / 3,
            iconWidget: const FaIcon(
              FontAwesomeIcons.css3,
              color: Colors.blue,
              size: 22,
            ),
            label: 'CSS3',
            glowColor: Colors.blue,
            speedMultiplier: 1.5,
            controller: _controller,
          ),
          OrbitingIcon(
            radius: r1,
            initialAngle: math.pi / 3,
            iconWidget: Image.asset(
              'assets/logos/dart.png',
              width: 28,
              height: 28,
            ),
            label: 'Dart',
            glowColor: const Color(0xFF00E5FF),
            speedMultiplier: 1.5,
            controller: _controller,
          ),
        ],
      ),
    );
  }

  Widget _buildMobileSkillsLayout() {
    final mobileSkills = [
      {
        'label': 'Flutter',
        'icon': Image.asset('assets/logos/flutter.png', width: 24, height: 24),
        'color': const Color(0xFF02569B),
        'tag': 'MOBILE ENGINE',
      },
      {
        'label': 'Dart',
        'icon': Image.asset('assets/logos/dart.png', width: 24, height: 24),
        'color': const Color(0xFF00E5FF),
        'tag': 'LANGUAGE',
      },
      {
        'label': 'Firebase',
        'icon': const FaIcon(
          FontAwesomeIcons.fire,
          color: Colors.amber,
          size: 20,
        ),
        'color': Colors.amber,
        'tag': 'CLOUD BAAS',
      },
      {
        'label': 'Java',
        'icon': Image.asset('assets/logos/java.png', width: 22, height: 22),
        'color': Colors.orangeAccent,
        'tag': 'BACKEND ARCH',
      },
      {
        'label': 'MongoDB',
        'icon': Image.asset('assets/logos/mongo-db.png', width: 24, height: 24),
        'color': const Color(0xFF47A248),
        'tag': 'DATABASE',
      },
      {
        'label': 'GitHub',
        'icon': Image.asset('assets/logos/github.png', width: 24, height: 24),
        'color': Colors.white,
        'tag': 'DEVOPS / VCS',
      },
      {
        'label': 'VS Code',
        'icon': Image.asset(
          'assets/logos/visual-studio-code.png',
          width: 22,
          height: 22,
        ),
        'color': const Color(0xFF007ACC),
        'tag': 'DEV ENVIRONMENT',
      },
      {
        'label': 'Git',
        'icon': const FaIcon(
          FontAwesomeIcons.git,
          color: Colors.deepOrange,
          size: 20,
        ),
        'color': Colors.deepOrange,
        'tag': 'VERSION CONTROL',
      },
      {
        'label': 'JavaScript',
        'icon': const FaIcon(
          FontAwesomeIcons.js,
          color: Colors.yellow,
          size: 20,
        ),
        'color': Colors.yellow,
        'tag': 'WEB LOGIC',
      },
      {
        'label': 'CSS3',
        'icon': const FaIcon(
          FontAwesomeIcons.css3,
          color: Colors.blue,
          size: 20,
        ),
        'color': Colors.blue,
        'tag': 'STYLING UI',
      },
    ];

    return Column(
      children: [
        // Top Central Badge
        _buildHolographicCentralCore(isMobile: true),
        const SizedBox(height: 35),
        // Glassmorphism Mobile Skill Card Matrix (2 Columns)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: mobileSkills.map((skill) {
              final String label = skill['label'] as String;
              final Widget icon = skill['icon'] as Widget;
              final Color glowColor = skill['color'] as Color;
              final String tag = skill['tag'] as String;

              return InkWell(
                onTap: () => _showMobileMockupDialog(label, icon, glowColor),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: MediaQuery.of(context).size.width > 380 ? 165 : 145,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.cardColor.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: glowColor.withValues(alpha: 0.4),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: glowColor.withValues(alpha: 0.15),
                        blurRadius: 15,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: glowColor.withValues(alpha: 0.15),
                        ),
                        child: icon,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              label,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              tag,
                              style: TextStyle(
                                color: glowColor,
                                fontSize: 8,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  void _showMobileMockupDialog(
    String label,
    Widget iconWidget,
    Color glowColor,
  ) {
    final deviceType = DeviceMockupType.values[label.hashCode.abs() % 3];

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(16),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.cardColor.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: glowColor.withValues(alpha: 0.6),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: glowColor.withValues(alpha: 0.4),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      label.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 1.2,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white54,
                        size: 20,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                _buildMockupPreviewContent(
                  deviceType,
                  label,
                  iconWidget,
                  glowColor,
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMockupPreviewContent(
    DeviceMockupType deviceType,
    String label,
    Widget iconWidget,
    Color glowColor,
  ) {
    switch (deviceType) {
      case DeviceMockupType.mobileLandscape:
        return Container(
          width: 220,
          height: 115,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: const Color(0xFF0D1117),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: glowColor.withValues(alpha: 0.8),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: glowColor.withValues(alpha: 0.4),
                blurRadius: 20,
              ),
            ],
          ),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.backgroundDark,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: glowColor.withValues(alpha: 0.15),
                      ),
                      child: iconWidget,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            label.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              letterSpacing: 1.1,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: glowColor.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              "MOBILE ENGINE",
                              style: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.w700,
                                color: glowColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );

      case DeviceMockupType.laptop:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 220,
              height: 120,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF161B22),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                border: Border.all(
                  color: glowColor.withValues(alpha: 0.8),
                  width: 1.5,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const SizedBox(width: 4),
                      CircleAvatar(
                        radius: 3,
                        backgroundColor: Colors.redAccent.shade100,
                      ),
                      const SizedBox(width: 3),
                      CircleAvatar(
                        radius: 3,
                        backgroundColor: Colors.amberAccent.shade100,
                      ),
                      const SizedBox(width: 3),
                      CircleAvatar(
                        radius: 3,
                        backgroundColor: Colors.greenAccent.shade100,
                      ),
                      const Spacer(),
                      Text(
                        "IDE",
                        style: TextStyle(
                          fontSize: 8,
                          color: Colors.white.withValues(alpha: 0.5),
                        ),
                      ),
                      const SizedBox(width: 4),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF090D16),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "class $label {",
                                  style: TextStyle(
                                    fontFamily: 'monospace',
                                    fontSize: 10,
                                    color: glowColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  "  status = 'EXPERT';",
                                  style: TextStyle(
                                    fontFamily: 'monospace',
                                    fontSize: 9,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  "}",
                                  style: TextStyle(
                                    fontFamily: 'monospace',
                                    fontSize: 10,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: glowColor.withValues(alpha: 0.15),
                            ),
                            child: iconWidget,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 240,
              height: 10,
              decoration: BoxDecoration(
                color: const Color(0xFF21262D),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(8),
                ),
                border: Border.all(color: Colors.white24, width: 0.8),
              ),
              child: Center(
                child: Container(
                  width: 30,
                  height: 2,
                  decoration: BoxDecoration(
                    color: Colors.white38,
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ),
            ),
          ],
        );

      case DeviceMockupType.tablet:
        return Container(
          width: 210,
          height: 120,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: const Color(0xFF0F141C),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: glowColor.withValues(alpha: 0.85),
              width: 1.5,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.cardColor,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: glowColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: iconWidget,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: 0.88,
                          minHeight: 4,
                          backgroundColor: Colors.white10,
                          valueColor: AlwaysStoppedAnimation<Color>(glowColor),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "PROSPECT: 100%",
                        style: TextStyle(
                          fontSize: 7,
                          color: Colors.white.withValues(alpha: 0.6),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
    }
  }

  Widget _buildHolographicCentralCore({required bool isMobile}) {
    final coreSize = isMobile ? 120.0 : 150.0;

    return Container(
      width: coreSize,
      height: coreSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            AppColors.primaryGlow.withValues(alpha: 0.8),
            AppColors.cardColor.withValues(alpha: 0.95),
            AppColors.backgroundDark,
          ],
          stops: const [0.0, 0.65, 1.0],
        ),
        border: Border.all(
          color: AppColors.accentCyan.withValues(alpha: 0.8),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentCyan.withValues(alpha: 0.4),
            blurRadius: 40,
            spreadRadius: 8,
          ),
          BoxShadow(
            color: AppColors.primaryGlow.withValues(alpha: 0.5),
            blurRadius: 70,
            spreadRadius: 15,
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "<",
                  style: TextStyle(
                    fontSize: isMobile ? 24 : 32,
                    fontWeight: FontWeight.w900,
                    color: AppColors.accentCyan,
                    shadows: [
                      Shadow(
                        color: AppColors.accentCyan.withValues(alpha: 0.8),
                        blurRadius: 15,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    "Skills",
                    style: TextStyle(
                      fontSize: isMobile ? 18 : 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.8,
                      shadows: [
                        Shadow(
                          color: Colors.white.withValues(alpha: 0.6),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                Text(
                  ">",
                  style: TextStyle(
                    fontSize: isMobile ? 24 : 32,
                    fontWeight: FontWeight.w900,
                    color: AppColors.accentCyan,
                    shadows: [
                      Shadow(
                        color: AppColors.accentCyan.withValues(alpha: 0.8),
                        blurRadius: 15,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.accentCyan.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.accentCyan.withValues(alpha: 0.4),
                  width: 0.8,
                ),
              ),
              child: Text(
                "EXPERTISE",
                style: TextStyle(
                  fontSize: isMobile ? 8 : 9,
                  fontWeight: FontWeight.w700,
                  color: AppColors.accentCyan,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrbitRing(double size, double opacity) {
    return Container(
      width: size,
      height: size / 2, // Squashed to look 3D
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withValues(alpha: opacity),
          width: 1,
        ),
      ),
    );
  }
}

enum DeviceMockupType { mobileLandscape, laptop, tablet }

class OrbitingIcon extends StatefulWidget {
  final double radius;
  final double initialAngle;
  final Widget iconWidget;
  final String label;
  final Color glowColor;
  final double speedMultiplier;
  final AnimationController controller;

  const OrbitingIcon({
    super.key,
    required this.radius,
    required this.initialAngle,
    required this.iconWidget,
    required this.label,
    this.glowColor = AppColors.accentCyan,
    required this.speedMultiplier,
    required this.controller,
  });

  @override
  State<OrbitingIcon> createState() => _OrbitingIconState();
}

class _OrbitingIconState extends State<OrbitingIcon> {
  bool _isHovered = false;
  late double _currentAngle;
  late double _lastValue;

  @override
  void initState() {
    super.initState();
    _currentAngle = widget.initialAngle;
    _lastValue = widget.controller.value;
    widget.controller.addListener(_onTick);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTick);
    super.dispose();
  }

  void _onTick() {
    double currentValue = widget.controller.value;
    double delta = currentValue - _lastValue;
    if (delta < -0.5) {
      delta += 1.0;
    }
    _lastValue = currentValue;

    if (!_isHovered) {
      setState(() {
        _currentAngle += delta * 2 * math.pi * widget.speedMultiplier;
      });
    }
  }

  DeviceMockupType _getDeviceType() {
    final index = widget.label.hashCode.abs() % 3;
    return DeviceMockupType.values[index];
  }

  @override
  Widget build(BuildContext context) {
    final double x = widget.radius * math.cos(_currentAngle);
    final double y = (widget.radius / 2) * math.sin(_currentAngle);
    final deviceType = _getDeviceType();

    return Transform.translate(
      offset: Offset(x, y),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            // Orbiting Skill Icon Badge
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.cardColor.withValues(alpha: 0.9),
                border: Border.all(
                  color: _isHovered
                      ? widget.glowColor
                      : widget.glowColor.withValues(alpha: 0.35),
                  width: _isHovered ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.glowColor.withValues(
                      alpha: _isHovered ? 0.6 : 0.25,
                    ),
                    blurRadius: _isHovered ? 20 : 10,
                    spreadRadius: _isHovered ? 3 : 1,
                  ),
                ],
              ),
              child: widget.iconWidget,
            ),

            // Animated Device Mockup Popover Preview on Hover
            if (_isHovered)
              Positioned(
                bottom: 52,
                child: AnimatedScale(
                  scale: _isHovered ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutBack,
                  child: AnimatedOpacity(
                    opacity: _isHovered ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 180),
                    child: _buildDeviceMockupPopover(deviceType),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceMockupPopover(DeviceMockupType deviceType) {
    switch (deviceType) {
      case DeviceMockupType.mobileLandscape:
        return _buildMobileLandscapeMockup();
      case DeviceMockupType.laptop:
        return _buildLaptopMockup();
      case DeviceMockupType.tablet:
        return _buildTabletMockup();
    }
  }

  // 1. Mobile Landscape Device Frame Mockup
  Widget _buildMobileLandscapeMockup() {
    return Container(
      width: 195,
      height: 105,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1117),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.glowColor.withValues(alpha: 0.8),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: widget.glowColor.withValues(alpha: 0.4),
            blurRadius: 20,
            spreadRadius: 2,
          ),
          const BoxShadow(
            color: Colors.black54,
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.backgroundDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 4,
                          height: 4,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white54,
                          ),
                        ),
                        const SizedBox(width: 3),
                        Text(
                          "9:41 AM",
                          style: TextStyle(
                            fontSize: 8,
                            color: Colors.white.withValues(alpha: 0.7),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.wifi, size: 9, color: widget.glowColor),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.battery_full,
                          size: 9,
                          color: Colors.white70,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: widget.glowColor.withValues(alpha: 0.15),
                          border: Border.all(
                            color: widget.glowColor.withValues(alpha: 0.5),
                          ),
                        ),
                        child: widget.iconWidget,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.label.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                letterSpacing: 1.1,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: widget.glowColor.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                "MOBILE ENGINE",
                                style: TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.w700,
                                  color: widget.glowColor,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 4,
            top: 42,
            child: Container(
              width: 5,
              height: 18,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 2. Laptop Device Frame Mockup
  Widget _buildLaptopMockup() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 200,
          height: 110,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: const Color(0xFF161B22),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            border: Border.all(
              color: widget.glowColor.withValues(alpha: 0.8),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.glowColor.withValues(alpha: 0.4),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const SizedBox(width: 4),
                  CircleAvatar(
                    radius: 3,
                    backgroundColor: Colors.redAccent.shade100,
                  ),
                  const SizedBox(width: 3),
                  CircleAvatar(
                    radius: 3,
                    backgroundColor: Colors.amberAccent.shade100,
                  ),
                  const SizedBox(width: 3),
                  CircleAvatar(
                    radius: 3,
                    backgroundColor: Colors.greenAccent.shade100,
                  ),
                  const Spacer(),
                  Container(
                    width: 4,
                    height: 4,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white30,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    "IDE",
                    style: TextStyle(
                      fontSize: 8,
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                  const SizedBox(width: 4),
                ],
              ),
              const SizedBox(height: 6),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF090D16),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "class ${widget.label} {",
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 9,
                                color: widget.glowColor,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              "  status = 'EXPERT';",
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 8,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              "}",
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 9,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: widget.glowColor.withValues(alpha: 0.15),
                        ),
                        child: widget.iconWidget,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 220,
          height: 10,
          decoration: BoxDecoration(
            color: const Color(0xFF21262D),
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(8),
            ),
            border: Border.all(color: Colors.white24, width: 0.8),
          ),
          child: Center(
            child: Container(
              width: 30,
              height: 2,
              decoration: BoxDecoration(
                color: Colors.white38,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // 3. Tablet Device Frame Mockup
  Widget _buildTabletMockup() {
    return Container(
      width: 185,
      height: 110,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFF0F141C),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: widget.glowColor.withValues(alpha: 0.85),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: widget.glowColor.withValues(alpha: 0.4),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardColor,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.glowColor,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "TABLET UI",
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                        color: widget.glowColor,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
                const Icon(Icons.wifi, size: 9, color: Colors.white54),
              ],
            ),
            const Divider(color: Colors.white12, height: 10),
            Expanded(
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: widget.glowColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: widget.glowColor.withValues(alpha: 0.4),
                      ),
                    ),
                    child: widget.iconWidget,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.label,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: 0.88,
                            minHeight: 4,
                            backgroundColor: Colors.white10,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              widget.glowColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "PROSPECT: 100%",
                          style: TextStyle(
                            fontSize: 7,
                            color: Colors.white.withValues(alpha: 0.6),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
