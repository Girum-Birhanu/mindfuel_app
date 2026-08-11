// lib/services/analytics/an_analytics_service.dart
import 'package:flutter/foundation.dart';

class AnAnalyticsService {
  static final AnAnalyticsService _instance = AnAnalyticsService._internal();
  factory AnAnalyticsService() => _instance;
  AnAnalyticsService._internal();

  void trackEvent(String eventName, {Map<String, dynamic>? properties}) {
    // Track analytics event
    debugPrint('Analytics: $eventName - $properties');
  }

  void trackScreenView(String screenName) {
    trackEvent('screen_view', properties: {'screen': screenName});
  }

  void trackHabitLogged(Map<String, dynamic> habitData) {
    trackEvent('habit_logged', properties: habitData);
  }
}
