import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/portfolio_models.dart';

abstract class PortfolioLocalDataSource {
  Future<PortfolioDataModel> getPortfolioData();
  Future<void> cachePortfolioData(PortfolioDataModel data);
}

class PortfolioLocalDataSourceImpl implements PortfolioLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String cacheKey = 'portfolio_data_cache';

  PortfolioLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<PortfolioDataModel> getPortfolioData() async {
    final seedData = _getSeedData();
    await cachePortfolioData(seedData);
    return seedData;
  }

  @override
  Future<void> cachePortfolioData(PortfolioDataModel data) async {
    final jsonString = jsonEncode(data.toJson());
    await sharedPreferences.setString(cacheKey, jsonString);
  }

  PortfolioDataModel _getSeedData() {
    return const PortfolioDataModel(
      projects: [
        ProjectModel(
          title: 'Meta-Arc-Reflux (MAR)',
          category: 'Enterprise & Onboarding',
          tagline:
              'Streamline workforce onboarding, skill assessment, and operational performance management.',
          description:
              'A cross-platform Flutter & Firebase enterprise system featuring a web administration dashboard for scheduling, dynamic assessment creation, and analytics alongside a mobile application for participant onboarding and activity tracking.',
          imageUrl: 'assets/meta_arc_reflux.png',
          technologies: [
            'Flutter (Dart 3.9)',
            'Riverpod & Freezed',
            'Firebase Auth & Firestore',
            'Cloud Functions',
            'fl_chart & PDF Exports',
            'Maps & Location APIs',
            'Media & Camera Tools',
          ],
          overview:
              'Meta-Arc-Reflux (MAR) is a robust, multi-platform enterprise solution designed to streamline workforce onboarding, skill assessment, activity tracking, and operational performance management.\n\nEngineered with Flutter for cross-platform deployment across Web and Mobile devices, the system bridges administrative management with field participant engagement through a role-tailored architecture.',
          webFeatures: [
            'Interactive Dashboard: High-level overview of batch operations, active participants, and assessment statistics.',
            'Question Bank & Assessment Builder: Dynamic tools for Subject Matter Experts (SMEs) to create, curate, and version test suites.',
            'Batch & User Scheduling: Tools for HR Admins and Schedulers to assign learning/assessment programs to targeted user cohorts.',
            'Advanced Analytics & Reporting: Data visualizers for individual and group performance, equipped with Excel dataset exports and PDF reporting.',
          ],
          mobileFeatures: [
            'Guided Onboarding: Interactive participant setup and personal information verification.',
            'Assessment & Practice Modules: Real-time quiz execution, instant scoring feedback, and practice dwelling windows.',
            'Activity & Progress Logging: Personal dashboard displaying completed tasks, upcoming deadlines, and historical activity timelines.',
            'Media & Location Tools: Embedded camera capture, audio/video resource playback, and location-aware maps.',
          ],
          architectureDetails: [
            'Role-Based Access Control (RBAC): Secure route protection (AuthGuard) strictly separating administrative web interfaces from participant mobile features based on user roles (HR Admin, Developer, Scheduler, SME, Participant).',
            'Cloud & Serverless Backend: Powered by Firebase Authentication, Cloud Firestore real-time database, Cloud Storage, and Firebase Cloud Functions.',
            'Modular Codebase: Dedicated separation between web_module, mob_app, and shared domain services.',
          ],
          techStackMap: {
            'Frontend & Architecture': ['Flutter (Dart 3.9)', 'Material 3 Design', 'Clean Architecture'],
            'State Management': ['Flutter Riverpod', 'Freezed Code Generation'],
            'Backend & Cloud Services': ['Firebase Auth', 'Cloud Firestore', 'Cloud Storage', 'Firebase Cloud Functions'],
            'Analytics & Reporting': ['fl_chart', 'excel', 'pdf', 'printing'],
            'Maps & Geolocation': ['flutter_map', 'syncfusion_flutter_maps', 'geolocator', 'geocoding'],
            'Media & Local Persistence': ['camera', 'chewie', 'video_player', 'audioplayers', 'sqflite', 'shared_preferences'],
            'Typography & UI Polish': ['Google Fonts (Poppins)', 'flutter_animate', 'flutter_advanced_drawer'],
          },
        ),
        ProjectModel(
          title: 'GeoPing (Geo Reminder)',
          description:
              'A cross-platform Flutter application that triggers intelligent location-based alarms using native background geofencing and real-time GPS tracking. Built with Clean Architecture and BLoC state management, it features system floating overlay bubbles, live Google Maps ETA updates, and cloud sync via Firebase.',
          technologies: [
            'Flutter',
            'Dart',
            'BLoC Pattern',
            'Google Maps API',
            'Firebase Auth & Firestore',
            'Native Geofencing',
            'System Overlay',
          ],
          tagline:
              'Never miss a stop again — intelligent location-triggered alarms for smart commuters.',
          imageUrl: 'assets/alert_alarmer.jpg',
          githubUrl: 'https://github.com/Kesavan02/Geoping',
          category: 'Location & Geofencing',
        ),
        ProjectModel(
          title: 'Bookymet (Turf Booking App)',
          category: 'Sports & Booking',
          tagline: 'Sports Turf Booking & Venue Management Platform',
          description:
              'A multi-platform mobile & web application built with Flutter and Firebase that connects sports enthusiasts with venue owners. Features real-time slot scheduling, location-aware turf discovery, automated coupon engine, Cashfree digital payments, and comprehensive admin analytics.',
          imageUrl: 'assets/bookymet.png',
          playStoreUrl:
              'https://play.google.com/store/apps/details?id=com.bookymet.user',
          technologies: [
            'Flutter (Dart 3.5+)',
            'GetX & Provider',
            'Firebase Suite',
            'Cashfree Payments',
            'Syncfusion Charts',
            'Geolocator & Maps',
            'FCM Notifications',
          ],
          overview:
              'Bookymet is an end-to-end sports turf reservation and facility management platform designed to streamline sports venue operations and simplify slot bookings for sports enthusiasts.\n\nBuilt using Flutter and powered by Firebase, the application delivers a seamless cross-platform experience with specialized workflows for three core roles: Players/Users, Turf Owners/Managers, and Super Admins.',
          webFeatures: [
            'Turf Manager Portal: Dedicated dashboard for venue owners to manage operating hours, list turfs, upload galleries, manage bookings, and analyze earnings.',
            'Admin Analytics & Operations: Platform super-admin dashboard equipped with Syncfusion interactive charts, user role management, support ticket resolution, and standardized sports categorization.',
          ],
          mobileFeatures: [
            'Location-Based Venue Discovery: Integrated GPS geolocation (geolocator) and dynamic distance calculation allow users to discover nearby turfs filtered by sport category (Cricket, Football, Badminton, Tennis, etc.), amenities, and price.',
            'Real-Time Slot Engine: Intelligent scheduling system preventing double-bookings with live slot status indicators, instant coupon application, and discount management.',
            'Secure Payment Integration: Frictionless checkout experience powered by Cashfree Payment Gateway SDK supporting UPI, cards, and net banking.',
            'Push Notifications & Support System: Real-time FCM notifications for booking updates and an integrated ticketing engine for customer care.',
          ],
          architectureDetails: [
            'Role-Based Multi-Tenant Architecture: Dedicated workflows for Players/Users, Turf Owners/Managers, and Super Admins.',
            'Serverless Cloud & Real-Time Sync: Firebase Authentication, Cloud Firestore real-time database, Firebase Storage, and Cloud Functions.',
            'Crash & Performance Monitoring: Firebase Crashlytics and Performance monitoring for peak reliability.',
          ],
          techStackMap: {
            'Frontend Framework': ['Flutter (Dart 3.5+)', 'Material Design'],
            'State & Navigation': ['GetX', 'Provider (ThemeProvider)'],
            'Backend & Cloud': [
              'Firebase Authentication',
              'Cloud Firestore',
              'Firebase Storage',
              'Cloud Functions'
            ],
            'Payments': ['Cashfree PG SDK (flutter_cashfree_pg_sdk)'],
            'Analytics & Monitoring': [
              'Syncfusion Flutter Charts',
              'Firebase Crashlytics & Performance'
            ],
            'Location & Maps': ['Geolocator', 'Geocoding'],
            'UI & UX Animations': [
              'Google Fonts',
              'Lottie',
              'Rive',
              'Shimmer',
              'Fluent UI Icons'
            ],
            'Notifications': [
              'Firebase Cloud Messaging (FCM)',
              'Local Notifications'
            ],
          },
        ),
        ProjectModel(
          title: 'Snake & Ladder Multiplayer',
          category: 'Mobile Game & Multiplayer',
          tagline:
              'Real-time cross-platform Snake & Ladder game built with Flutter & Firebase',
          description:
              'A feature-rich mobile board game with real-time room-based multiplayer, customizable dynamic board visual styles, interactive dice rolling animations, and cloud profile avatar integration.',
          imageUrl: 'assets/snakes_ladders.png',
          technologies: [
            'Flutter',
            'Dart',
            'BLoC Architecture',
            'Firebase Auth',
            'Firestore',
            'Cloudinary API',
            'CustomPainter',
            'AudioPlayers',
          ],
          overview:
              'Snake & Ladder Multiplayer modernizes the classic board game experience into a dynamic cross-platform mobile application. Powered by Flutter and Firebase, it delivers real-time synchronization across 2-4 online players, seamlessly integrated room matchmaking, and offline local pass-and-play gameplay.',
          webFeatures: [
            'Real-time Room Matchmaking & Lobby System: Users can instantly create or join private rooms with unique 6-digit access codes. Host controls allow managing player slots, dynamic player readiness checks, and kick capabilities.',
            'Lobby State Synchronization: Powered by Firestore real-time streams for instant room status updates.',
          ],
          mobileFeatures: [
            'Online & Offline Game Modes: Real-time state sync via Firebase Firestore streams (online mode) and local pass-and-play / vs-AI gameplay without network dependency (offline mode).',
            'Dynamic Theme Engines & Canvas Rendering: Utilizes CustomPainter to procedurally render 10x10 game boards with custom snake curves, ladder rungs, and coin rewards (Modern Jungle & Retro Classic themes).',
            'Interactive Audio & Dice Roll Mechanics: Realistic dice roll animations combined with spatial audio feedback via audioplayers for immersive turn progression.',
            'Authentication & Profile Personalization: Firebase Email/Password & Google Sign-In with Cloudinary direct image upload integration for custom avatars.',
          ],
          architectureDetails: [
            'Feature-First BLoC Architecture: Built using flutter_bloc, isolating data repositories, domain models, and presentation states for high testability and maintainability.',
            'Modular Directory Structure: Core services (CloudinaryService, SettingsRepository), Auth feature, Lobby feature, and Game loops (BoardPainter, DiceBloc).',
          ],
          techStackMap: {
            'Frontend & Canvas': ['Flutter', 'Dart', 'CustomPainter (BoardPainter)'],
            'State Management': ['flutter_bloc (BLoC Pattern)'],
            'Backend & Real-Time Sync': [
              'Firebase Auth',
              'Cloud Firestore Streams',
              'Google Sign-In'
            ],
            'Media & Cloud Services': [
              'Cloudinary API (Avatar Uploads)',
              'audioplayers (Spatial Audio)'
            ],
            'Game Modes': [
              'Online Multiplayer (2-4 Players)',
              'Offline Pass & Play / vs AI'
            ],
          },
        ),
        ProjectModel(
          title: 'Autenik (ERP Platform)',
          description:
              'Architected a cross-platform Enterprise Resource Planning (ERP) platform in Flutter to digitize and centralize core HR workflows. Integrates geolocation-backed attendance, dynamic leave management, automated payroll processing, and collaborative Kanban task boards.',
          technologies: ['Flutter', 'GetX', 'Firebase', 'PDF Generation'],
          category: 'Enterprise ERP',
        ),
        ProjectModel(
          title: 'Expense Tracker',
          description:
              'Architected and developed a premium Expense Tracker using Flutter and Dart, leveraging Clean Architecture. Managed complex state across multiple features using BLoC. Delivered a high-performance web experience with a custom-built design system and local-first persistence via Hive.',
          technologies: ['Flutter', 'BLoC', 'Clean Architecture', 'Hive'],
          githubUrl: 'https://github.com/Kesavan02/Expense_tracker',
          category: 'Finance & Analytics',
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
