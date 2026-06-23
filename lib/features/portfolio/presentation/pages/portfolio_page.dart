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

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Stack(
        children: [
          // Ambient glowing background
          Positioned(
            top: -200,
            left: -200,
            child: Container(
              width: 600,
              height: 600,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondaryGlow.withValues(alpha: 0.1),
                // boxShadow: [
                //   BoxShadow(
                //     color: AppColors.secondaryGlow.withValues(alpha: 0.1),
                //     blurRadius: 200,
                //     spreadRadius: 100,
                //   ),
                // ],
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
                color: AppColors.primaryGlow.withValues(alpha: 0.1),
                // boxShadow: [
                //   BoxShadow(
                //     color: AppColors.primaryGlow.withValues(alpha: 0.1),
                //     blurRadius: 200,
                //     spreadRadius: 100,
                //   ),
                // ],
              ),
            ),
          ),
          // The hero section is shown IMMEDIATELY — no loading gate.
          // Portfolio data sections appear below once the bloc emits PortfolioLoaded.
          BlocBuilder<PortfolioBloc, PortfolioState>(
            builder: (context, state) {
              // Always render the scroll view with the hero — never block on data.
              final isLoaded = state is PortfolioLoaded;
              final isError = state is PortfolioError;

              return CustomScrollView(
                controller: _scrollController,
                slivers: [
                  // ── Hero — always visible instantly ─────────────────────────
                  SliverMainAxisGroup(
                    slivers: [
                      HeroSliver(scrollController: _scrollController),
                    ],
                  ),

                  // ── Data-driven sections — only when loaded ─────────────────
                  if (isLoaded) ...[
                    SliverToBoxAdapter(
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1200),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SkillsSection(
                                skills: state.portfolioData.skills,
                                certifications:
                                    state.portfolioData.certifications,
                              ),
                              ExperienceSection(
                                experiences: state.portfolioData.experiences,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SliverMainAxisGroup(
                      slivers: [
                        ProjectsSliver(projects: state.portfolioData.projects),
                      ],
                    ),
                    SliverToBoxAdapter(
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1200),
                          child: const ContactSection(),
                        ),
                      ),
                    ),
                  ],

                  // ── Inline error state ──────────────────────────────────────
                  if (isError)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(40),
                        child: Center(
                          child: Text(
                            state.message,
                            style: const TextStyle(color: Colors.redAccent),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
