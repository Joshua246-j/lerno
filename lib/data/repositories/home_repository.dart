import 'package:lerno/data/mock_data.dart';

abstract class IHomeRepository {
  Future<List<MockCourse>> getCourses();
  Future<List<MockActivity>> getActivities();
  Future<List<MockRecommendation>> getRecommendations();
  Future<List<MockBanner>> getBanners();
}

class MockHomeRepository implements IHomeRepository {
  // Simulate network latency (e.g. 800ms) to give a production feel
  static const Duration _delay = Duration(milliseconds: 800);

  @override
  Future<List<MockCourse>> getCourses() async {
    await Future.delayed(_delay);
    return MockData.courses;
  }

  @override
  Future<List<MockActivity>> getActivities() async {
    await Future.delayed(_delay);
    return MockData.activities;
  }

  @override
  Future<List<MockRecommendation>> getRecommendations() async {
    await Future.delayed(_delay);
    return MockData.recommendations;
  }

  @override
  Future<List<MockBanner>> getBanners() async {
    await Future.delayed(_delay);
    return MockData.banners;
  }
}
