import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider to simulate online/offline status for testing
class NetworkNotifier extends StateNotifier<bool> {
  NetworkNotifier() : super(true); // true = online, false = offline

  void setOffline() => state = false;
  void setOnline() => state = true;
  void toggle() => state = !state;
}

final networkProvider = StateNotifierProvider<NetworkNotifier, bool>((ref) {
  return NetworkNotifier();
});
