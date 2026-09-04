// lib/main.dart
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:synheart_core/synheart_core.dart';
import 'package:synheart_wear/synheart_wear.dart';
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
    
    // Open HSI Cache box for persistence
    try {
      await Hive.openBox('hsi_cache');
    } catch (e) {
      await Hive.deleteBoxFromDisk('hsi_cache');
      await Hive.openBox('hsi_cache');
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
        appId: 'app_mindfuel_and_9m9eophc',
        subjectId: generatedSubjectId,
        mode: SynheartMode.research,
        allowUnsignedCapabilities: true,
        privacy: const PrivacyConfig(
          allowResearch: true,
        ),
        batchIngestOnStop: true,
        runtimeLogEnvFilter: 'debug,synheart_core_runtime::cloud=trace,synheart_core_runtime::auth=trace',
        phoneConfig: const PhoneConfig(
          enableMotion: false,
          enableScreenState: false,
          enableAppTracking: false,
        ),
        behaviorConfig: const BehaviorConfig(
          enableGestureTracking: true,
          enableTypingTracking: true,
        ),
        cloudConfig: CloudConfig(
          subjectId: generatedSubjectId,
          instanceId: instanceId,
          apiKey: 'synheart_sk_live_GpKUGEiqgG3SMukE8j7lPeJGG0rX0EVBxWomyXGtd7s',
          orgId: 'org_mindfuel_mj728spmb9fo',
          uploadInterval: const Duration(seconds: 10),
          batchSize: 1,
        ),
        deviceAuthConfig: const DeviceAuthConfig(
          authBaseUrl: 'https://api.synheart.ai',
          packageName: 'com.example.mindfuel_app',
          allowUnattestedDevRegistration: true,
        ),
        consentConfig: ConsentConfig(
          appId: 'app_mindfuel_and_9m9eophc',
          appApiKey: 'synheart_sk_live_GpKUGEiqgG3SMukE8j7lPeJGG0rX0EVBxWomyXGtd7s',
        ),
      ),
    );
    
    // Enable cloud upload capability
    Synheart.activate(SynheartFeature.cloud);
    
    // Step 1: Grant basic consent (triggers device auth in background)
    await Synheart.grantConsent(
      biosignals: false,
      behavior: true,
      phoneContext: false,
      cloudUpload: true,
      research: true,
      syni: true,
      vendorSync: false,
    );
    debugPrint('[MindFuel] Basic consent granted');

    // Step 2: Wait for device registration to complete  
    try {
      await Synheart.ensureDeviceAuthRegistered();
      debugPrint('[MindFuel] Device auth registered successfully!');
    } catch (e) {
      debugPrint('[MindFuel] Device auth registration error: $e');
    }

    // Step 3: Extract the generated device ID from the runtime (poll until available)
    String? deviceId;
    for (int i = 0; i < 40; i++) {
      final authStatus = Synheart.coreDeviceAuthStatus();
      deviceId = authStatus?['device_id']?.toString() ?? authStatus?['deviceId']?.toString();
      if (deviceId != null && deviceId.isNotEmpty) {
        break;
      }
      debugPrint('[MindFuel] Waiting for device_id... ($i/40)');
      await Future.delayed(const Duration(seconds: 1));
    }
    debugPrint('[MindFuel] Got device_id for consent form: $deviceId');

    // Step 4: Submit the typed consent form explicitly passing device_id and platform
    final consentResult = await Synheart.consentSubmitFormTyped(
      form: ConsentForm(
        profileId: '6f193dd8-f262-45a1-8408-647e7989931e',
        biosignals: false,
        behavior: true,
        phoneContext: false,
        allowCloud: true,
        allowResearch: true,
        allowVendorSync: false,
        syni: true,
        consentTier: ConsentTier.research,
      ),
      deviceId: deviceId,
      platform: 'android',
    );
    debugPrint('[MindFuel] Consent form submitted: $consentResult');

    // Step 5: Ensure cloud consent token is ready
    try {
      await Synheart.ensureCloudConsentReady();
      debugPrint('[MindFuel] Cloud consent ready!');
    } catch (e) {
      debugPrint('[MindFuel] Cloud consent error: $e');
    }
    
    // Start session asynchronously so it doesn't block runApp
    Future.microtask(() async {
      try {
        // Small delay to let consent token propagate
        await Future.delayed(const Duration(seconds: 3));
        
        await Synheart.startSession();
        debugPrint('[MindFuel] Session started! Generating behavior data...');
        
        // Rapidly push synthetic biosignals and behavior touches to populate the session data!
        Timer.periodic(const Duration(milliseconds: 100), (timer) {
           final now = DateTime.now().millisecondsSinceEpoch;
           Synheart.pushBehaviorTouch(now);
           
           // Generate synthetic HR (e.g. oscillating around 70 BPM) and RR (around 850ms)
           Synheart.pushWearHr(now, 70.0 + (timer.tick % 5));
           Synheart.pushRr(now, 850.0 - (timer.tick % 20));
        });

        // The app will now run continuously to ensure HSI windows complete.
        // We removed the hardcoded 120-second stopSession() timer so the engine 
        // doesn't accidentally get killed right before the 60-second window closes.

        // Also try periodic flush every 30 seconds
        Timer.periodic(const Duration(seconds: 30), (timer) async {
          try {
            final depth = Synheart.uploadQueueLength;
            debugPrint('[MindFuel] Upload queue depth: $depth');
            final result = await Synheart.ingestion.flushIfEligible();
            debugPrint('[MindFuel] Flush: uploaded=${result.uploaded} failed=${result.failed} requeued=${result.requeued}');
          } catch (e) {
            debugPrint('[MindFuel] Periodic flush error: $e');
          }
        });

        // Capture and explicitly display the locally generated HSI JSON from the engine!
        Synheart.onHSIUpdate.listen((hsiJson) {
          debugPrint('\n==== LOCAL ENGINE HSI DATA GENERATED ====');
          debugPrint('The app is successfully extracting HSI from the local edge engine (NOT cloud).');
          try {
             // Basic parsing to list out the structure to the terminal
             final Map<String, dynamic> data = jsonDecode(hsiJson);
             debugPrint('HSI Metrics Extracted:');
             data.forEach((key, value) {
                // Formatting it as a list for the terminal
                debugPrint(' -> $key: $value');
             });
          } catch (e) {
             debugPrint('Raw JSON: $hsiJson');
          }
          debugPrint('=========================================\n');
        });

        // Listen to raw behavior events
        Synheart.behaviorEventStream.listen((event) {
          debugPrint('==== BEHAVIOR EVENT CAPTURED ====');
        });
        
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
