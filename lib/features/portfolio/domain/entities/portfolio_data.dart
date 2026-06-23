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

  const Project({
    required this.title,
    required this.description,
    required this.technologies,
  });

  @override
  List<Object?> get props => [title, description, technologies];
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
