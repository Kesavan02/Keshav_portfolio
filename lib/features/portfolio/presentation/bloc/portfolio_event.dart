import 'package:equatable/equatable.dart';

abstract class PortfolioEvent extends Equatable {
  const PortfolioEvent();

  @override
  List<Object> get props => [];
}

class LoadPortfolioData extends PortfolioEvent {}
