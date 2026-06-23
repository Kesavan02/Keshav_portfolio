import 'package:flutter/material.dart';
import '../../domain/entities/portfolio_data.dart';
import '../../../../core/theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ExperienceSection extends StatelessWidget {
  final List<Experience> experiences;

  const ExperienceSection({super.key, required this.experiences});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Work Experience',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 60),
          Wrap(
            spacing: 30,
            runSpacing: 30,
            children: experiences.map((exp) => _buildExperienceCard(context, exp)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceCard(BuildContext context, Experience exp) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isMobile = constraints.maxWidth < 600;
        
        return Container(
          width: 600, // Constrained naturally by parent/wrap
          padding: EdgeInsets.all(isMobile ? 24 : 40),
          decoration: BoxDecoration(
            color: AppColors.cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              )
            ],
          ),
          child: isMobile 
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Glowing Icon
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryGlow.withValues(alpha: 0.1),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryGlow.withValues(alpha: 0.3),
                              blurRadius: 20,
                              spreadRadius: 1,
                            )
                          ],
                        ),
                        child: const FaIcon(FontAwesomeIcons.briefcase, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              exp.company,
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${exp.role} \n${exp.duration}',
                              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ...exp.responsibilities.map((task) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 6.0),
                          child: Icon(Icons.circle, size: 5, color: AppColors.accentCyan),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            task,
                            style: const TextStyle(color: AppColors.textSecondary, height: 1.6, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  )),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white24),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      child: const Text('LEARN MORE', style: TextStyle(fontSize: 12, letterSpacing: 1.5)),
                    ),
                  ),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Glowing Icon
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryGlow.withValues(alpha: 0.1),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryGlow.withValues(alpha: 0.3),
                          blurRadius: 30,
                          spreadRadius: 2,
                        )
                      ],
                    ),
                    child: const FaIcon(FontAwesomeIcons.briefcase, color: Colors.white, size: 30),
                  ),
                  const SizedBox(width: 30),
                  
                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          exp.company,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '${exp.role} | ${exp.duration}',
                          style: const TextStyle(fontSize: 14, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 20),
                        ...exp.responsibilities.map((task) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 6.0),
                                child: Icon(Icons.circle, size: 6, color: AppColors.accentCyan),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Text(
                                  task,
                                  style: const TextStyle(color: AppColors.textSecondary, height: 1.5),
                                ),
                              ),
                            ],
                          ),
                        )),
                        const SizedBox(height: 20),
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white24),
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          ),
                          child: const Text('LEARN MORE', style: TextStyle(fontSize: 12, letterSpacing: 1.5)),
                        )
                      ],
                    ),
                  )
                ],
              ),
        );
      },
    );
  }
}
