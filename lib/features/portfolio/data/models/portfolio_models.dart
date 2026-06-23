// ignore_for_file: overridden_fields

import '../../domain/entities/portfolio_data.dart';

class ProjectModel extends Project {
  @override
  final String title;

  @override
  final String description;

  @override
  final List<String> technologies;

  const ProjectModel({
    required this.title,
    required this.description,
    required this.technologies,
  }) : super(title: title, description: description, technologies: technologies);

  factory ProjectModel.fromEntity(Project entity) {
    return ProjectModel(
      title: entity.title,
      description: entity.description,
      technologies: entity.technologies,
    );
  }

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      title: json['title'] as String,
      description: json['description'] as String,
      technologies: List<String>.from(json['technologies']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'technologies': technologies,
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
  }) : super(role: role, company: company, duration: duration, responsibilities: responsibilities);

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

  const CertificationModel({
    required this.name,
    required this.issuer,
  }) : super(name: name, issuer: issuer);

  factory CertificationModel.fromEntity(Certification entity) {
    return CertificationModel(
      name: entity.name,
      issuer: entity.issuer,
    );
  }

  factory CertificationModel.fromJson(Map<String, dynamic> json) {
    return CertificationModel(
      name: json['name'] as String,
      issuer: json['issuer'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'issuer': issuer,
    };
  }
}

class SkillModel extends Skill {
  @override
  final String category;

  @override
  final List<String> items;

  const SkillModel({
    required this.category,
    required this.items,
  }) : super(category: category, items: items);

  factory SkillModel.fromEntity(Skill entity) {
    return SkillModel(
      category: entity.category,
      items: entity.items,
    );
  }

  factory SkillModel.fromJson(Map<String, dynamic> json) {
    return SkillModel(
      category: json['category'] as String,
      items: List<String>.from(json['items']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'items': items,
    };
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
  }) : super(projects: projects, experiences: experiences, certifications: certifications, skills: skills);

  factory PortfolioDataModel.fromJson(Map<String, dynamic> json) {
    return PortfolioDataModel(
      projects: (json['projects'] as List).map((e) => ProjectModel.fromJson(e)).toList(),
      experiences: (json['experiences'] as List).map((e) => ExperienceModel.fromJson(e)).toList(),
      certifications: (json['certifications'] as List).map((e) => CertificationModel.fromJson(e)).toList(),
      skills: (json['skills'] as List).map((e) => SkillModel.fromJson(e)).toList(),
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
