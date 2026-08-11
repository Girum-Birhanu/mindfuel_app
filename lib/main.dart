// lib/main.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:synheart_core/synheart_core.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/di/injection_container.dart';
import 'core/theme/app_theme.dart';
import 'data/models/habit_log.dart';
import 'presentation/screens/screen_dashboard/screen_dashboard.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize Hive
    await Hive.initFlutter();
    Hive.registerAdapter(HabitLogAdapter());
    try {
      await Hive.openBox<HabitLog>('habit_logs');
    } catch (e) {
      debugPrint('Hive box corrupted, deleting and reopening: $e');
      await Hive.deleteBoxFromDisk('habit_logs');
      await Hive.openBox<HabitLog>('habit_logs');
    }

    try {
      await dotenv.load(fileName: '.env');
    } catch (e) {
      debugPrint('.env not found or failed to load: $e');
    }

    final String generatedSubjectId = 'user_' + Uuid().v4().replaceAll('-', '').substring(0, 8);
    final String instanceId = Uuid().v4();

    // Initialize Synheart Core
    await Synheart.initialize(
      config: SynheartConfig(
        appId: 'app_d8c1ae97', // Extracted from assets
        subjectId: generatedSubjectId,
        mode: SynheartMode.insight,
        allowUnsignedCapabilities: true,
        cloudConfig: CloudConfig(
          subjectId: generatedSubjectId,
          instanceId: instanceId,
          apiKey: 'synheart_sk_live_dXig0dtGlZ-TaXSDA50nbsKuO7NYpD2rfjxZrsVuegw',
          orgId: 'org_2fdd42c5',
        ),
      ),
    );
    
    // Enable cloud upload capability (requires consent)
    Synheart.activate(SynheartFeature.cloud);
    
    // Start session asynchronously so it doesn't block runApp
    Future.microtask(() async {
      try {
        await Synheart.startSession();
      } catch (error) {
        debugPrint('Failed to start Synheart session: $error');
      }
    });

    runApp(
      UncontrolledProviderScope(
        container: providerContainer,
        child: const MyApp(),
      ),
    );
  } catch (error, stack) {
    debugPrint('Fatal error during startup: $error\n$stack');
    runApp(MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Startup Error: $error', style: const TextStyle(color: Colors.red)),
          ),
        ),
      ),
    ));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MindFuel',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      builder: (context, child) {
        return Synheart.wrapWithBehaviorDetector(child!);
      },
      home: const ScreenDashboard(),
      debugShowCheckedModeBanner: false,
    );
  }
}
