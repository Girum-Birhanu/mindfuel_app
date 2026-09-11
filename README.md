# MindFuel

**MindFuel** is an advanced cognitive health and wellness application designed to help users optimize their daily routines, avoid burnout, and maximize their productivity. By correlating your daily habits with your biological "Cognitive Capacity," MindFuel helps you discover exactly which activities recharge your mental energy and which ones drain it.

---

## Purpose and Vision
In today's fast-paced world, managing time isn't enough—we need to manage our *energy*. 
MindFuel tracks your **Human State Intelligence (HSI)** (metrics representing your mental bandwidth, focus, and fatigue) in real-time. By logging habits (like "Drank Coffee", "Meditated", or "Yoga"), you can visualize exactly how your behaviors physically impact your underlying biological state.

## How It Works (The Synheart Edge Engine Integration)
Translating raw heartbeat data into meaningful metrics like "Cognitive Capacity" and "Focus" requires complex machine learning. 

Rather than sending raw, private biometric data to the cloud for processing, MindFuel utilizes the **Synheart Edge Engine** to run medical-grade AI *directly on your device*.
1. **Local Telemetry & Synthetic Data:** The app ingests physiological telemetry (Heart Rate, RR intervals) and behavioral data. For testing and demonstration, MindFuel actively pushes dynamic synthetic HR/RR signals into the engine.
2. **On-Device ONNX Machine Learning:** The native C++/Rust Synheart engine processes this data locally on your phone using highly optimized ONNX models every 60 seconds.
3. **Live HSI Extraction:** MindFuel extracts the computed **HSI (Human State Interface)** scores—including *Focus*, *Capacity*, *Cognitive Load*, and *Mental Fatigue*—directly from the edge engine.
4. **Cloud Syncing (RAMEN Protocol):** After intelligence is generated locally for immediate UI feedback, the processed metrics are securely flushed to the Synheart cloud (`prj_mindfuel_hmqmubcrofd9`) for long-term storage and cross-device syncing.

---

## Core Features
- **Live HSI Intelligence Dashboard:** A dynamic, real-time metrics card displaying your exact Focus, Cognitive Load, Mental Fatigue, and Capacity scores computed by the local ONNX model.
- **Interactive Habit Logger:** Instantly log daily habits. The UI provides immediate feedback on how your habits (like drinking coffee or doing cardio) fuse with your biological data to impact your scores.
- **Offline Persistence:** Utilizing `Hive` local storage, the app caches your latest HSI metrics, ensuring your dashboard is instantly populated the second you open the app.
- **Capacity Gauge & Trends:** Beautiful visual gauge and historical trend charts showing how your capacity fluctuates over time alongside your logged habits.

---

## How to Use the App
1. **Launch the App:** You will be greeted by the main Dashboard.
2. **Observe the Engine:** Keep the app open for exactly 60 seconds. You will see the "Live HSI Engine Metrics" card dynamically appear as the local Synheart engine completes its first intelligence window.
3. **Log Habits:** Tap the quick-log inputs (e.g., "cup", "cardio", "yoga"). The dashboard will instantly recalculate your metrics to provide immediate feedback on how that habit impacted your current state.
4. **Analyze Trends:** Look at the "Capacity Trends" chart to see the cause-and-effect relationship between your logged habits and your brain's energy levels.

---

## 📥 Quick Install (No Coding Required)

If you just want to test the app on your Android phone without setting up any code, follow these steps:

1. **Download the App:** Click on the `MindFuel.apk` file in this repository, then click the **Download** button (or the raw button) to save it to your Android phone.
2. **Install:** Open the downloaded `.apk` file from your phone's notifications or Downloads folder.
3. **Permissions:** If your phone prompts you that it "blocked installation from unknown sources", simply click **Settings** and toggle **Allow from this source**.
4. **Open & Enjoy!** The app is fully packed with the local ML engine and ready to use.

---

## 💻 Developer Setup & Installation

### Prerequisites
- Flutter SDK installed (Version 3.12.2 or higher recommended).
- Android Studio or a connected Android device.
- **Note:** The Synheart SDK requires Android SDK 28 (Android 9.0) or higher.

### Installation Steps
1. **Clone the repository:**
   ```bash
   git clone https://github.com/Girum-Birhanu/mindfuel_app.git
   cd mindfuel_app
   ```

2. **Install Flutter dependencies:**
   ```bash
   flutter pub get
   ```

3. **Configure Synheart Credentials:**
   Ensure your `.env` file or `main.dart` is populated with the correct Synheart Live credentials:
   - `Organization ID`: `org_mindfuel_mj728spmb9fo`
   - `Project ID`: `prj_mindfuel_hmqmubcrofd9`
   - `App ID`: `app_mindfuel_and_c0y8awfx`

4. **Android Attestation Note:**
   Because this app is linked to a Live Synheart environment, it requires **Google Play Integrity** hardware attestation. Synheart has authorized the package name `com.example.mindfuel_app`. To run local debug builds without triggering a `403 Forbidden` error, ensure `allowUnsignedCapabilities: true` is set in the `Synheart.initialize` configuration until the app is officially published on the Google Play Store.

5. **Run the app:**
   ```bash
   flutter run
   ```

---
*Built with Flutter.*
