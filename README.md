# MindFuel App

MindFuel is a Flutter application designed to track behavioral metrics and human-system interactions (HSI). It is fully integrated with the [Synheart Platform](https://synheart.ai/) to continuously sync telemetry, motion, and interaction data to the cloud for deep cognitive and behavioral analysis.

## 🚀 Features
- **Behavioral Tracking**: Uses the `synheart_core` SDK to track and analyze user interactions, UI usage patterns, and device behavior.
- **Dynamic Session Handling**: Automatically generates anonymous `subject_id`s and `instance_id`s for seamless data synchronization.
- **Active Cloud Ingestion**: Automatically buffers and syncs real-time telemetry securely to the Synheart API.
- **Smartwatch Ready**: Supports `synheart_wear` components for high-frequency HRV and motion sampling (Android API 28+ required).

## 🛠️ Tech Stack & Requirements
- **Framework**: Flutter
- **Platform Support**: Android (minimum SDK version: 28)
- **Key Dependencies**:
  - `synheart_core`: Main engine for behavior tracking and cloud ingestion.
  - `uuid`: Used for anonymous session and subject generation.

## 📦 Getting Started

### Prerequisites
- Flutter SDK installed
- Android Studio or a connected Android device/emulator (Running Android 9.0 / API 28 or higher).

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/YOUR_GITHUB_USERNAME/mindfuel_app.git
   cd mindfuel_app
   ```

2. Install the Flutter dependencies:
   ```bash
   flutter pub get
   ```

3. Ensure you have the `synheart.json` configuration file in your `assets/` folder containing your `project_id`, `app_id`, and `app_api_key`.

4. Run the app:
   ```bash
   flutter run
   ```

## 🧠 Synheart Integration Details
This application uses `Synheart.wrapWithBehaviorDetector()` at the root level of the widget tree to capture global gestures and typing patterns. The SDK runs in `SynheartMode.insight` and automatically flushes batched interaction data every few minutes to the cloud dashboard. 

For development and testing, `allowUnsignedCapabilities: true` is enabled in `lib/main.dart` to bypass production authentication checks.
