import 'package:equatable/equatable.dart';

class PortfolioData extends Equatable {
  final List<Project> projects;
  final List<Experience> experiences;
  final List<Certification> certifications;
  final List<Skill> skills;

  const PortfolioData({
    required this.projects,
    required this.experiences,
    required this.certifications,
    required this.skills,
  });

  @override
  List<Object?> get props => [projects, experiences, certifications, skills];
}

class Project extends Equatable {
  final String title;
  final String description;
  final List<String> technologies;
  final String? tagline;
  final String? imageUrl;
  final String? githubUrl;
  final String? playStoreUrl;
  final String? category;
  final String? overview;
  final List<String>? webFeatures;
  final List<String>? mobileFeatures;
  final List<String>? architectureDetails;
  final Map<String, List<String>>? techStackMap;

  const Project({
    required this.title,
    required this.description,
    required this.technologies,
    this.tagline,
    this.imageUrl,
    this.githubUrl,
    this.playStoreUrl,
    this.category,
    this.overview,
    this.webFeatures,
    this.mobileFeatures,
    this.architectureDetails,
    this.techStackMap,
  });

  @override
  List<Object?> get props => [
        title,
        description,
        technologies,
        tagline,
        imageUrl,
        githubUrl,
        playStoreUrl,
        category,
        overview,
        webFeatures,
        mobileFeatures,
        architectureDetails,
        techStackMap,
      ];
}

class Experience extends Equatable {
  final String role;
  final String company;
  final String duration;
  final List<String> responsibilities;

  const Experience({
    required this.role,
    required this.company,
    required this.duration,
    required this.responsibilities,
  });

  @override
  List<Object?> get props => [role, company, duration, responsibilities];
}

class Certification extends Equatable {
  final String name;
  final String issuer;

  const Certification({
    required this.name,
    required this.issuer,
  });

  @override
  List<Object?> get props => [name, issuer];
}

class Skill extends Equatable {
  final String category;
  final List<String> items;

  const Skill({
    required this.category,
    required this.items,
  });

  @override
  List<Object?> get props => [category, items];
}
