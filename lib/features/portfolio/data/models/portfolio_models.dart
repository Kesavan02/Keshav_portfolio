// ignore_for_file: overridden_fields

import '../../domain/entities/portfolio_data.dart';

class ProjectModel extends Project {
  @override
  final String title;

  @override
  final String description;

  @override
  final List<String> technologies;

  @override
  final String? tagline;

  @override
  final String? imageUrl;

  @override
  final String? githubUrl;

  @override
  final String? playStoreUrl;

  @override
  final String? category;

  @override
  final String? overview;

  @override
  final List<String>? webFeatures;

  @override
  final List<String>? mobileFeatures;

  @override
  final List<String>? architectureDetails;

  @override
  final Map<String, List<String>>? techStackMap;

  const ProjectModel({
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
  }) : super(
         title: title,
         description: description,
         technologies: technologies,
         tagline: tagline,
         imageUrl: imageUrl,
         githubUrl: githubUrl,
         playStoreUrl: playStoreUrl,
         category: category,
         overview: overview,
         webFeatures: webFeatures,
         mobileFeatures: mobileFeatures,
         architectureDetails: architectureDetails,
         techStackMap: techStackMap,
       );

  factory ProjectModel.fromEntity(Project entity) {
    return ProjectModel(
      title: entity.title,
      description: entity.description,
      technologies: entity.technologies,
      tagline: entity.tagline,
      imageUrl: entity.imageUrl,
      githubUrl: entity.githubUrl,
      playStoreUrl: entity.playStoreUrl,
      category: entity.category,
      overview: entity.overview,
      webFeatures: entity.webFeatures,
      mobileFeatures: entity.mobileFeatures,
      architectureDetails: entity.architectureDetails,
      techStackMap: entity.techStackMap,
    );
  }

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    Map<String, List<String>>? parsedTechStack;
    if (json['techStackMap'] != null) {
      final rawMap = json['techStackMap'] as Map<String, dynamic>;
      parsedTechStack = rawMap.map(
        (key, value) => MapEntry(key, List<String>.from(value as List)),
      );
    }

    return ProjectModel(
      title: json['title'] as String,
      description: json['description'] as String,
      technologies: List<String>.from(json['technologies']),
      tagline: json['tagline'] as String?,
      imageUrl: json['imageUrl'] as String?,
      githubUrl: json['githubUrl'] as String?,
      playStoreUrl: json['playStoreUrl'] as String?,
      category: json['category'] as String?,
      overview: json['overview'] as String?,
      webFeatures: json['webFeatures'] != null
          ? List<String>.from(json['webFeatures'])
          : null,
      mobileFeatures: json['mobileFeatures'] != null
          ? List<String>.from(json['mobileFeatures'])
          : null,
      architectureDetails: json['architectureDetails'] != null
          ? List<String>.from(json['architectureDetails'])
          : null,
      techStackMap: parsedTechStack,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'technologies': technologies,
      'tagline': tagline,
      'imageUrl': imageUrl,
      'githubUrl': githubUrl,
      'playStoreUrl': playStoreUrl,
      'category': category,
      'overview': overview,
      'webFeatures': webFeatures,
      'mobileFeatures': mobileFeatures,
      'architectureDetails': architectureDetails,
      'techStackMap': techStackMap,
    };
  }
}

class ExperienceModel extends Experience {
  @override
  final String role;

  @override
  final String company;

  @override
  final String duration;

  @override
  final List<String> responsibilities;

  const ExperienceModel({
    required this.role,
    required this.company,
    required this.duration,
    required this.responsibilities,
  }) : super(
         role: role,
         company: company,
         duration: duration,
         responsibilities: responsibilities,
       );

  factory ExperienceModel.fromEntity(Experience entity) {
    return ExperienceModel(
      role: entity.role,
      company: entity.company,
      duration: entity.duration,
      responsibilities: entity.responsibilities,
    );
  }

  factory ExperienceModel.fromJson(Map<String, dynamic> json) {
    return ExperienceModel(
      role: json['role'] as String,
      company: json['company'] as String,
      duration: json['duration'] as String,
      responsibilities: List<String>.from(json['responsibilities']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'company': company,
      'duration': duration,
      'responsibilities': responsibilities,
    };
  }
}

class CertificationModel extends Certification {
  @override
  final String name;

  @override
  final String issuer;

  const CertificationModel({required this.name, required this.issuer})
    : super(name: name, issuer: issuer);

  factory CertificationModel.fromEntity(Certification entity) {
    return CertificationModel(name: entity.name, issuer: entity.issuer);
  }

  factory CertificationModel.fromJson(Map<String, dynamic> json) {
    return CertificationModel(
      name: json['name'] as String,
      issuer: json['issuer'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'issuer': issuer};
  }
}

class SkillModel extends Skill {
  @override
  final String category;

  @override
  final List<String> items;

  const SkillModel({required this.category, required this.items})
    : super(category: category, items: items);

  factory SkillModel.fromEntity(Skill entity) {
    return SkillModel(category: entity.category, items: entity.items);
  }

  factory SkillModel.fromJson(Map<String, dynamic> json) {
    return SkillModel(
      category: json['category'] as String,
      items: List<String>.from(json['items']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'category': category, 'items': items};
  }
}

class PortfolioDataModel extends PortfolioData {
  @override
  final List<ProjectModel> projects;

  @override
  final List<ExperienceModel> experiences;

  @override
  final List<CertificationModel> certifications;

  @override
  final List<SkillModel> skills;

  const PortfolioDataModel({
    required this.projects,
    required this.experiences,
    required this.certifications,
    required this.skills,
  }) : super(
         projects: projects,
         experiences: experiences,
         certifications: certifications,
         skills: skills,
       );

  factory PortfolioDataModel.fromJson(Map<String, dynamic> json) {
    return PortfolioDataModel(
      projects: (json['projects'] as List)
          .map((e) => ProjectModel.fromJson(e))
          .toList(),
      experiences: (json['experiences'] as List)
          .map((e) => ExperienceModel.fromJson(e))
          .toList(),
      certifications: (json['certifications'] as List)
          .map((e) => CertificationModel.fromJson(e))
          .toList(),
      skills: (json['skills'] as List)
          .map((e) => SkillModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'projects': projects.map((e) => e.toJson()).toList(),
      'experiences': experiences.map((e) => e.toJson()).toList(),
      'certifications': certifications.map((e) => e.toJson()).toList(),
      'skills': skills.map((e) => e.toJson()).toList(),
    };
  }
}
