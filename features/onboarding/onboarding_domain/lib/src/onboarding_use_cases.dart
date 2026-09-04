import 'package:injectable/injectable.dart';
import 'onboarding_repository.dart';

@lazySingleton
class ShouldShowOnboarding {
  const ShouldShowOnboarding(this.repository);
  final OnboardingRepository repository;

  Future<bool> call(String flowId) async =>
      !await repository.isCompleted(flowId);
}

@lazySingleton
class CompleteOnboarding {
  const CompleteOnboarding(this.repository);
  final OnboardingRepository repository;

  Future<void> call(String flowId) => repository.complete(flowId);
}
