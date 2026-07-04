import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lerno/data/repositories/home_repository.dart';
import 'package:lerno/data/mock_data.dart';

// 1. Repository Provider
final homeRepositoryProvider = Provider<IHomeRepository>((ref) {
  return MockHomeRepository();
});

// 2. FutureProviders for UI Data
final coursesProvider = FutureProvider<List<MockCourse>>((ref) {
  final repo = ref.watch(homeRepositoryProvider);
  return repo.getCourses();
});

final activitiesProvider = FutureProvider<List<MockActivity>>((ref) {
  final repo = ref.watch(homeRepositoryProvider);
  return repo.getActivities();
});

final recommendationsProvider = FutureProvider<List<MockRecommendation>>((ref) {
  final repo = ref.watch(homeRepositoryProvider);
  return repo.getRecommendations();
});

final bannersProvider = FutureProvider<List<MockBanner>>((ref) {
  final repo = ref.watch(homeRepositoryProvider);
  return repo.getBanners();
});
