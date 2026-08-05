import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../domain/entities/portfolio_data.dart';
import '../../../../core/theme.dart';

class ProjectDetailModal extends StatelessWidget {
  final Project project;

  const ProjectDetailModal({super.key, required this.project});

  /// Shows a dialog on both mobile and desktop.
  static Future<void> show(BuildContext context, Project project) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.80),
      builder: (_) => ProjectDetailModal(project: project),
    );
  }

  Future<void> _launchUrl(String urlString) async {
    final Uri uri = Uri.parse(urlString);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isMobile = screenSize.width < 750;

    if (isMobile) return _buildMobileModal(context, screenSize);

    // Core dimensions — base is ~11% wider than screen
    final double screenW = 860.0;
    final double baseW = 980.0;

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ═══════════════════════════════════════════════════════════
            //  💻  LAPTOP LID  (matches skills tooltip: #161B22 + cyan glow)
            // ═══════════════════════════════════════════════════════════
            Container(
              width: screenW,
              constraints: BoxConstraints(maxHeight: screenSize.height * 0.76),
              decoration: BoxDecoration(
                color: const Color(0xFF161B22),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                border: Border.all(
                  color: AppColors.accentCyan.withValues(alpha: 0.8),
                  width: 1.5,
                ),
                boxShadow: [
                  // Main cyan glow — matches image
                  BoxShadow(
                    color: AppColors.accentCyan.withValues(alpha: 0.35),
                    blurRadius: 28,
                    spreadRadius: 2,
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.85),
                    blurRadius: 40,
                    spreadRadius: 6,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ── Webcam notch strip (top of lid) ──────────────────
                  Container(
                    height: 20,
                    decoration: const BoxDecoration(
                      color: Color(0xFF0D1117),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(11),
                      ),
                    ),
                    child: Center(
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: const Color(0xFF040609),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white24, width: 0.8),
                        ),
                      ),
                    ),
                  ),

                  // ── Inner screen (6 px bezel inset on left/right/bottom) ──
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(6, 0, 6, 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D1117),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.06),
                          width: 0.5,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Column(
                          children: [
                            // ── macOS title bar ───────────────────────
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: const BoxDecoration(
                                color: Color(0xFF161B22),
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.white12,
                                    width: 0.5,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  // Traffic lights
                                  MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: GestureDetector(
                                      onTap: () => Navigator.of(context).pop(),
                                      child: const _TrafficDot(
                                        color: Color(0xFFFF5F56),
                                        icon: Icons.close,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  const _TrafficDot(color: Color(0xFFFFBD2E)),
                                  const SizedBox(width: 6),
                                  const _TrafficDot(color: Color(0xFF27C93F)),

                                  const Spacer(),

                                  // IDE label — top right, matches image
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.06,
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                        color: AppColors.accentCyan.withValues(
                                          alpha: 0.4,
                                        ),
                                        width: 0.8,
                                      ),
                                    ),
                                    child: Text(
                                      'IDE  —  ${(project.category ?? 'PROJECT').toUpperCase()}',
                                      style: const TextStyle(
                                        color: AppColors.accentCyan,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.6,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // ── Project header (category + title + close) ─
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: isMobile ? 14 : 22,
                                vertical: 11,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.backgroundDark.withValues(
                                  alpha: 0.95,
                                ),
                                border: const Border(
                                  bottom: BorderSide(
                                    color: Colors.white12,
                                    width: 0.5,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          (project.category ??
                                                  'PROJECT DETAILS')
                                              .toUpperCase(),
                                          style: const TextStyle(
                                            color: AppColors.accentCyan,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1.2,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          project.title,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: isMobile ? 16 : 21,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: -0.3,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => Navigator.of(context).pop(),
                                    child: Container(
                                      width: 28,
                                      height: 28,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(
                                          alpha: 0.07,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.close_rounded,
                                        color: Colors.white54,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // ── Scrollable content ─────────────────────
                            Flexible(
                              child: SingleChildScrollView(
                                padding: EdgeInsets.all(isMobile ? 14 : 22),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Cover image
                                    if (project.imageUrl != null) ...[
                                      Center(
                                        child: Container(
                                          constraints: BoxConstraints(
                                            maxHeight: isMobile ? 240 : 360,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.backgroundDark,
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            border: Border.all(
                                              color: AppColors.accentCyan
                                                  .withValues(alpha: 0.2),
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withValues(
                                                  alpha: 0.4,
                                                ),
                                                blurRadius: 14,
                                              ),
                                            ],
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            child: Image.asset(
                                              project.imageUrl!,
                                              fit: BoxFit.contain,
                                              errorBuilder: (_, _, _) =>
                                                  const Center(
                                                    child: Icon(
                                                      Icons
                                                          .business_center_rounded,
                                                      size: 48,
                                                      color:
                                                          AppColors.accentCyan,
                                                    ),
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                    ],

                                    // Tagline
                                    if (project.tagline != null) ...[
                                      Container(
                                        padding: const EdgeInsets.all(13),
                                        decoration: BoxDecoration(
                                          color: AppColors.accentCyan
                                              .withValues(alpha: 0.07),
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          border: Border.all(
                                            color: AppColors.accentCyan
                                                .withValues(alpha: 0.25),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.auto_awesome_rounded,
                                              color: AppColors.accentCyan,
                                              size: 16,
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Text(
                                                project.tagline!,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  height: 1.4,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 18),
                                    ],

                                    // Overview
                                    _buildSectionHeader(
                                      icon: Icons.article_rounded,
                                      title: 'Project Overview',
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      project.overview ?? project.description,
                                      style: const TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 13.5,
                                        height: 1.6,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                    const SizedBox(height: 20),

                                    // Web features
                                    if (project.webFeatures != null &&
                                        project.webFeatures!.isNotEmpty) ...[
                                      _buildSectionHeader(
                                        icon: Icons.computer_rounded,
                                        title:
                                            'Web Management Portal (Admin, SME, Developer, Scheduler)',
                                      ),
                                      const SizedBox(height: 10),
                                      ...project.webFeatures!.map(
                                        _buildFeatureItem,
                                      ),
                                      const SizedBox(height: 20),
                                    ],

                                    // Mobile features
                                    if (project.mobileFeatures != null &&
                                        project.mobileFeatures!.isNotEmpty) ...[
                                      _buildSectionHeader(
                                        icon: Icons.phone_android_rounded,
                                        title: 'Mobile Participant Application',
                                      ),
                                      const SizedBox(height: 10),
                                      ...project.mobileFeatures!.map(
                                        _buildFeatureItem,
                                      ),
                                      const SizedBox(height: 20),
                                    ],

                                    // Architecture
                                    if (project.architectureDetails != null &&
                                        project
                                            .architectureDetails!
                                            .isNotEmpty) ...[
                                      _buildSectionHeader(
                                        icon: Icons.security_rounded,
                                        title:
                                            'Technical Architecture & Security',
                                      ),
                                      const SizedBox(height: 10),
                                      ...project.architectureDetails!.map(
                                        _buildFeatureItem,
                                      ),
                                      const SizedBox(height: 20),
                                    ],

                                    // Tech stack
                                    if (project.techStackMap != null &&
                                        project.techStackMap!.isNotEmpty) ...[
                                      _buildSectionHeader(
                                        icon: Icons
                                            .integration_instructions_rounded,
                                        title: 'Tech Stack & Dependencies',
                                      ),
                                      const SizedBox(height: 10),
                                      ...project.techStackMap!.entries.map(
                                        (entry) => Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 12,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                entry.key.toUpperCase(),
                                                style: const TextStyle(
                                                  color: AppColors.accentCyan,
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 0.8,
                                                ),
                                              ),
                                              const SizedBox(height: 6),
                                              Wrap(
                                                spacing: 6,
                                                runSpacing: 6,
                                                children: entry.value
                                                    .map(
                                                      (tech) => Container(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 10,
                                                              vertical: 5,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          color: Colors.white
                                                              .withValues(
                                                                alpha: 0.06,
                                                              ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                14,
                                                              ),
                                                          border: Border.all(
                                                            color: Colors.white
                                                                .withValues(
                                                                  alpha: 0.12,
                                                                ),
                                                          ),
                                                        ),
                                                        child: Text(
                                                          tech,
                                                          style:
                                                              const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                        ),
                                                      ),
                                                    )
                                                    .toList(),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                    ],

                                    // External links
                                    if (project.githubUrl != null ||
                                        project.playStoreUrl != null) ...[
                                      const Divider(
                                        color: Colors.white12,
                                        height: 28,
                                      ),
                                      Wrap(
                                        spacing: 10,
                                        runSpacing: 10,
                                        children: [
                                          if (project.githubUrl != null)
                                            ElevatedButton.icon(
                                              onPressed: () => _launchUrl(
                                                project.githubUrl!,
                                              ),
                                              icon: const FaIcon(
                                                FontAwesomeIcons.github,
                                                size: 14,
                                                color: Colors.white,
                                              ),
                                              label: const Text(
                                                'GitHub Repository',
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    AppColors.backgroundDark,
                                                foregroundColor: Colors.white,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 10,
                                                    ),
                                              ),
                                            ),
                                          if (project.playStoreUrl != null)
                                            ElevatedButton.icon(
                                              onPressed: () => _launchUrl(
                                                project.playStoreUrl!,
                                              ),
                                              icon: const FaIcon(
                                                FontAwesomeIcons.googlePlay,
                                                size: 13,
                                                color: Colors.white,
                                              ),
                                              label: const Text('Play Store'),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: const Color(
                                                  0xFF00E676,
                                                ),
                                                foregroundColor: Colors.white,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 10,
                                                    ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ═══════════════════════════════════════════════════════════
            //  🔩  HINGE  (narrow dark strip — same as skills tooltip)
            // ═══════════════════════════════════════════════════════════
            Container(
              width: baseW * 0.94,
              height: 4,
              color: const Color(0xFF0A0D14),
            ),

            // ═══════════════════════════════════════════════════════════
            //  ⌨️  KEYBOARD DECK  (wider + glowing — the laptop base)
            // ═══════════════════════════════════════════════════════════
            Container(
              width: baseW,
              height: isMobile ? 20 : 30,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF21262D),
                    Color(0xFF2A3140),
                    Color(0xFF1C2128),
                  ],
                ),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(16),
                ),
                border: Border.all(
                  color: AppColors.accentCyan.withValues(alpha: 0.8),
                  width: 1.5,
                ),
                boxShadow: [
                  // Cyan glow on base — matching the image's yellow glow
                  BoxShadow(
                    color: AppColors.accentCyan.withValues(alpha: 0.30),
                    blurRadius: 24,
                    spreadRadius: 2,
                    offset: const Offset(0, 6),
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.7),
                    blurRadius: 18,
                    spreadRadius: 3,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Center(
                child: Container(
                  width: isMobile ? 44 : 70,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.accentCyan.withValues(alpha: 0.45),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Mobile dialog modal (no laptop frame) ─────────────────────────────────
  Widget _buildMobileModal(BuildContext context, Size screenSize) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: screenSize.width * 0.92,
          height: screenSize.height * 0.85,
          decoration: BoxDecoration(
            color: const Color(0xFF161B22),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.accentCyan.withValues(alpha: 0.6),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.accentCyan.withValues(alpha: 0.25),
                blurRadius: 28,
                spreadRadius: 2,
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.85),
                blurRadius: 40,
                spreadRadius: 6,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Column(
              children: [
          // Drag handle
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 6),
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.accentCyan.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(18, 8, 10, 12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
            ),
            child: Row(
              children: [
                // Traffic lights
                const _TrafficDot(color: Color(0xFFFF5F56)),
                const SizedBox(width: 6),
                const _TrafficDot(color: Color(0xFFFFBD2E)),
                const SizedBox(width: 6),
                const _TrafficDot(color: Color(0xFF27C93F)),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (project.category ?? 'PROJECT').toUpperCase(),
                        style: const TextStyle(
                          color: AppColors.accentCyan,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1,
                        ),
                      ),
                      Text(
                        project.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.07),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      color: Colors.white54,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Scrollable body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (project.imageUrl != null) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        project.imageUrl!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (_, _, _) => Container(
                          height: 160,
                          color: AppColors.backgroundDark,
                          child: const Center(
                            child: Icon(
                              Icons.business_center_rounded,
                              size: 40,
                              color: AppColors.accentCyan,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                  ],
                  if (project.tagline != null) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.accentCyan.withValues(alpha: 0.07),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.accentCyan.withValues(alpha: 0.25),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.auto_awesome_rounded,
                              color: AppColors.accentCyan, size: 15),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              project.tagline!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12.5,
                                fontWeight: FontWeight.w500,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  _buildSectionHeader(
                    icon: Icons.article_rounded,
                    title: 'Project Overview',
                  ),
                  const SizedBox(height: 7),
                  Text(
                    project.overview ?? project.description,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                      height: 1.6,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 18),
                  if (project.webFeatures != null &&
                      project.webFeatures!.isNotEmpty) ...[
                    _buildSectionHeader(
                        icon: Icons.computer_rounded,
                        title: 'Web Management Portal'),
                    const SizedBox(height: 8),
                    ...project.webFeatures!.map(_buildFeatureItem),
                    const SizedBox(height: 16),
                  ],
                  if (project.mobileFeatures != null &&
                      project.mobileFeatures!.isNotEmpty) ...[
                    _buildSectionHeader(
                        icon: Icons.phone_android_rounded,
                        title: 'Mobile Application'),
                    const SizedBox(height: 8),
                    ...project.mobileFeatures!.map(_buildFeatureItem),
                    const SizedBox(height: 16),
                  ],
                  if (project.architectureDetails != null &&
                      project.architectureDetails!.isNotEmpty) ...[
                    _buildSectionHeader(
                        icon: Icons.security_rounded,
                        title: 'Architecture & Security'),
                    const SizedBox(height: 8),
                    ...project.architectureDetails!.map(_buildFeatureItem),
                    const SizedBox(height: 16),
                  ],
                  if (project.techStackMap != null &&
                      project.techStackMap!.isNotEmpty) ...[
                    _buildSectionHeader(
                        icon: Icons.integration_instructions_rounded,
                        title: 'Tech Stack'),
                    const SizedBox(height: 8),
                    ...project.techStackMap!.entries.map(
                      (e) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(e.key.toUpperCase(),
                                style: const TextStyle(
                                    color: AppColors.accentCyan,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.8)),
                            const SizedBox(height: 5),
                            Wrap(
                              spacing: 5,
                              runSpacing: 5,
                              children: e.value
                                  .map((t) => Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 9, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.white
                                              .withValues(alpha: 0.06),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                              color: Colors.white
                                                  .withValues(alpha: 0.12)),
                                        ),
                                        child: Text(t,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 11)),
                                      ))
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  if (project.githubUrl != null ||
                      project.playStoreUrl != null) ...[
                    const Divider(color: Colors.white12, height: 24),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        if (project.githubUrl != null)
                          ElevatedButton.icon(
                            onPressed: () => _launchUrl(project.githubUrl!),
                            icon: const FaIcon(FontAwesomeIcons.github,
                                size: 13, color: Colors.white),
                            label: const Text('GitHub'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.backgroundDark,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 10),
                            ),
                          ),
                        if (project.playStoreUrl != null)
                          ElevatedButton.icon(
                            onPressed: () =>
                                _launchUrl(project.playStoreUrl!),
                            icon: const FaIcon(FontAwesomeIcons.googlePlay,
                                size: 12, color: Colors.white),
                            label: const Text('Play Store'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF00E676),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 10),
                            ),
                          ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  ),
),
);
  }

  Widget _buildSectionHeader({required IconData icon, required String title}) {
    return Row(
      children: [
        Icon(icon, color: AppColors.accentCyan, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureItem(String text) {
    final parts = text.split(':');
    final title = parts.isNotEmpty ? parts.first : '';
    final detail = parts.length > 1 ? text.substring(title.length + 1) : '';

    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 5,
            height: 5,
            decoration: const BoxDecoration(
              color: AppColors.accentCyan,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  height: 1.5,
                ),
                children: [
                  if (detail.isNotEmpty) ...[
                    TextSpan(
                      text: '$title: ',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(text: detail.trim()),
                  ] else ...[
                    TextSpan(text: text),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Coloured circle for macOS-style traffic lights.
class _TrafficDot extends StatelessWidget {
  final Color color;
  final IconData? icon;

  const _TrafficDot({required this.color, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 11,
      height: 11,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: icon != null ? Icon(icon, size: 7, color: Colors.black54) : null,
    );
  }
}
