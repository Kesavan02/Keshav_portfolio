import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/portfolio_models.dart';

abstract class PortfolioLocalDataSource {
  Future<PortfolioDataModel> getPortfolioData();
  Future<void> cachePortfolioData(PortfolioDataModel data);
}

class PortfolioLocalDataSourceImpl implements PortfolioLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String CACHE_KEY = 'portfolio_data_cache';

  PortfolioLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<PortfolioDataModel> getPortfolioData() async {
    final cachedDataString = sharedPreferences.getString(CACHE_KEY);
    if (cachedDataString != null) {
      try {
        final json = jsonDecode(cachedDataString);
        return PortfolioDataModel.fromJson(json);
      } catch (e) {
        return _getSeedData();
      }
    } else {
      // Return seed data if nothing is cached
      final seedData = _getSeedData();
      await cachePortfolioData(seedData);
      return seedData;
    }
  }

  @override
  Future<void> cachePortfolioData(PortfolioDataModel data) async {
    final jsonString = jsonEncode(data.toJson());
    await sharedPreferences.setString(CACHE_KEY, jsonString);
  }

  PortfolioDataModel _getSeedData() {
    return const PortfolioDataModel(
      projects: [
        ProjectModel(
          title: 'Bookymet (Turf Booking App)',
          description: 'Developed a scalable Flutter application that connects sports enthusiasts with local turf venues. Built a comprehensive multi-tenant architecture supporting separate flows for Users, Turf Owners, and Managers. Leveraged Firebase for real-time data sync and utilized Google Maps for location-based discovery.',
          technologies: ['Flutter', 'Firebase', 'Google Maps'],
        ),
        ProjectModel(
          title: 'Autenik (ERP Platform)',
          description: 'Architected a cross-platform Enterprise Resource Planning (ERP) platform in Flutter to digitize and centralize core HR workflows. Integrates geolocation-backed attendance, dynamic leave management, automated payroll processing, and collaborative Kanban task boards.',
          technologies: ['Flutter', 'GetX', 'Firebase', 'PDF Generation'],
        ),
        ProjectModel(
          title: 'Expense Tracker',
          description: 'Architected and developed a premium Expense Tracker using Flutter and Dart, leveraging Clean Architecture. Managed complex state across multiple features using BLoC. Delivered a high-performance web experience with a custom-built design system and local-first persistence via Hive.',
          technologies: ['Flutter', 'BLoC', 'Clean Architecture', 'Hive'],
        ),
      ],
      experiences: [
        ExperienceModel(
          role: 'Mobile & Web Application Intern',
          company: 'Brix Networks Private Limited',
          duration: 'June 2025 – Present',
          responsibilities: [
            'Collaborated on cross-platform application development, focusing on modular architecture and clean state management.',
            'Built and optimized functional application modules, integrating backend services and ensuring reliable performance.',
            'Participated in the complete development lifecycle, from initial feature drafting to local testing and deployment.'
          ],
        ),
      ],
      certifications: [
        CertificationModel(
          name: 'Certification in Android Application Development',
          issuer: 'Internshala Learning Platform',
        ),
        CertificationModel(
          name: 'Flutter Framework Certification',
          issuer: 'Great Learning Academy',
        ),
        CertificationModel(
          name: 'Elite Certification in Cloud Computing',
          issuer: 'NPTEL / SWAYAM',
        ),
        CertificationModel(
          name: 'Google Play Store Listing Certificate',
          issuer: 'Google Play Academy',
        ),
      ],
      skills: [
        SkillModel(
          category: 'Framework',
          items: ['Flutter'],
        ),
        SkillModel(
          category: 'Languages',
          items: ['Java', 'Dart', 'Html', 'Css', 'Javascript'],
        ),
        SkillModel(
          category: 'Database',
          items: ['Firebase', 'MongoDB'],
        ),
        SkillModel(
          category: 'State Management',
          items: ['GetX', 'Provider', 'Bloc'],
        ),
        SkillModel(
          category: 'Version control',
          items: ['Git', 'Github'],
        ),
      ],
    );
  }
}
