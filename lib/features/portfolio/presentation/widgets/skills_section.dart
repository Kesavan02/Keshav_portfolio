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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 150),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "I'm currently looking to join a cross-functional team",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          const Text(
            "that values improving people's lives through accessible design",
            style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 150),

          // Orbital Animation
          SizedBox(
            height: 400,
            width: double.infinity,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Center Glowing Logo
                Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryGlow.withValues(alpha: 0.2),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryGlow.withValues(alpha: 0.6),
                        blurRadius: 80,
                        spreadRadius: 20,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "<",
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          TextSpan(
                            text: "Skills",
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                              letterSpacing: 1.6,
                            ),
                          ),
                          TextSpan(
                            text: ">",
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Orbit Rings
                _buildOrbitRing(350, 0.05),
                _buildOrbitRing(500, 0.03),
                _buildOrbitRing(650, 0.02),

                // Orbiting Icons - Ring 3 (Outer - radius 300)
                OrbitingIcon(
                  radius: 300,
                  initialAngle: 0,
                  iconWidget: const FaIcon(
                    FontAwesomeIcons.java,
                    color: Colors.orange,
                    size: 24,
                  ),
                  label: 'Java',
                  speedMultiplier: 1.0,
                  controller: _controller,
                ),
                OrbitingIcon(
                  radius: 300,
                  initialAngle: math.pi / 2,
                  iconWidget: const FaIcon(
                    FontAwesomeIcons.js,
                    color: Colors.yellow,
                    size: 24,
                  ),
                  label: 'JavaScript',
                  speedMultiplier: 1.0,
                  controller: _controller,
                ),
                OrbitingIcon(
                  radius: 300,
                  initialAngle: math.pi,
                  iconWidget: const FaIcon(
                    FontAwesomeIcons.fire,
                    color: Colors.amber,
                    size: 24,
                  ),
                  label: 'Firebase',
                  speedMultiplier: 1.0,
                  controller: _controller,
                ),
                OrbitingIcon(
                  radius: 300,
                  initialAngle: 3 * math.pi / 2,
                  iconWidget: const FaIcon(
                    FontAwesomeIcons.envira,
                    color: Colors.green,
                    size: 24,
                  ),
                  label: 'MongoDB',
                  speedMultiplier: 1.0,
                  controller: _controller,
                ),

                // Orbiting Icons - Ring 2 (Middle - radius 225)
                OrbitingIcon(
                  radius: 225,
                  initialAngle: 0,
                  iconWidget: const FaIcon(
                    FontAwesomeIcons.github,
                    color: Colors.white,
                    size: 24,
                  ),
                  label: 'GitHub',
                  speedMultiplier: -1.2,
                  controller: _controller,
                ),
                OrbitingIcon(
                  radius: 225,
                  initialAngle: 2 * math.pi / 3,
                  iconWidget: const FaIcon(
                    FontAwesomeIcons.git,
                    color: Colors.deepOrange,
                    size: 24,
                  ),
                  label: 'Git',
                  speedMultiplier: -1.2,
                  controller: _controller,
                ),
                OrbitingIcon(
                  radius: 225,
                  initialAngle: 4 * math.pi / 3,
                  iconWidget: const FaIcon(
                    FontAwesomeIcons.html5,
                    color: Colors.orangeAccent,
                    size: 24,
                  ),
                  label: 'HTML5',
                  speedMultiplier: -1.2,
                  controller: _controller,
                ),

                // Orbiting Icons - Ring 1 (Inner - radius 150)
                OrbitingIcon(
                  radius: 150,
                  initialAngle: math.pi,
                  iconWidget: const Icon(
                    Icons.flutter_dash,
                    color: Colors.cyan,
                    size: 24,
                  ),
                  label: 'Flutter',
                  speedMultiplier: 1.5,
                  controller: _controller,
                ),
                OrbitingIcon(
                  radius: 150,
                  initialAngle: 5 * math.pi / 3,
                  iconWidget: const FaIcon(
                    FontAwesomeIcons.css3,
                    color: Colors.blue,
                    size: 24,
                  ),
                  label: 'CSS3',
                  speedMultiplier: 1.5,
                  controller: _controller,
                ),
                OrbitingIcon(
                  radius: 150,
                  initialAngle: math.pi / 3,
                  iconWidget: const Icon(
                    Icons.bolt,
                    color: Colors.purpleAccent,
                    size: 24,
                  ),
                  label: 'Dart',
                  speedMultiplier: 1.5,
                  controller: _controller,
                ),
              ],
            ),
          ),
        ],
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

class OrbitingIcon extends StatefulWidget {
  final double radius;
  final double initialAngle;
  final Widget iconWidget;
  final String label;
  final double speedMultiplier;
  final AnimationController controller;

  const OrbitingIcon({
    super.key,
    required this.radius,
    required this.initialAngle,
    required this.iconWidget,
    required this.label,
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
    // Handle the loop from 1.0 back to 0.0
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

  @override
  Widget build(BuildContext context) {
    // We adjust the Y radius to make it look like a 3D orbit (elliptical)
    final double x = widget.radius * math.cos(_currentAngle);
    final double y = (widget.radius / 2) * math.sin(_currentAngle);

    return Transform.translate(
      offset: Offset(x, y),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: Tooltip(
          message: widget.label,
          decoration: BoxDecoration(
            color: AppColors.primaryGlow.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.textSecondary.withValues(alpha: 0.5),
            ),
          ),
          textStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          verticalOffset: 30,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.backgroundDark,
              border: Border.all(
                color: _isHovered ? AppColors.primaryGlow : Colors.white12,
                width: _isHovered ? 2 : 1,
              ),
              boxShadow: _isHovered
                  ? [
                      BoxShadow(
                        color: AppColors.accentCyan.withValues(alpha: 0.5),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                    ]
                  : [],
            ),
            child: widget.iconWidget,
          ),
        ),
      ),
    );
  }
}
