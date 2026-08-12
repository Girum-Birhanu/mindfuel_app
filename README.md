# MindFuel

**MindFuel** is a cognitive health and wellness application designed to help users optimize their daily routines, avoid burnout, and maximize their productivity. By correlating your daily habits with your biological "Cognitive Capacity," MindFuel helps you discover exactly which activities recharge your mental energy and which ones drain it.

---

## Purpose and Vision
In today's fast-paced world, managing time isn't enough—we need to manage our *energy*. 
MindFuel tracks your **Cognitive Capacity** (a metric representing your mental bandwidth and focus) in real-time. By logging habits (like "Drank Coffee", "Meditated", or "Deep Work Session"), you can visualize exactly how your behaviors impact your underlying biological state over time.

## How It Works (The Synheart Integration)
Translating raw heartbeat data into a meaningful metric like "Cognitive Capacity" requires complex machine learning and medical-grade AI. 

Instead of processing this massive amount of data locally, MindFuel is deeply integrated with the **Synheart Platform** via the `synheart_core` SDK.
1. **Data Collection:** The app securely collects physiological telemetry (Heart Rate, HRV, RR intervals) and kinematic motion data from connected wearables (like Apple Watch, Garmin, or WearOS devices).
2. **Cloud Processing:** This data is streamed via Synheart's heavily encrypted RAMEN protocol to the Synheart cloud (`prj_mindfuel_hmqmubcrofd9`).
3. **AI Analysis:** Synheart runs this data through advanced AI biomarker models to filter noise, establish your personal baseline, and compute your exact **HSI (Human State Interface)** scores.
4. **Real-time Feedback:** The Synheart SDK streams these computed metrics (like Capacity) back into MindFuel, powering the live dashboard gauges and historical trend charts.

---

## Features
- **Live Capacity Dashboard:** A real-time gauge displaying your current cognitive bandwidth (0-100%).
- **Quick Habit Logger:** Instantly log daily habits and activities with a single tap.
- **Capacity Trend Analysis:** A sleek, interactive trendline chart showing how your capacity fluctuates over time alongside your logged habits.
- **Synheart Biometric Engine:** Fully integrated with `synheart_core` for medical-grade physiological processing.

---

## How to Use the App
1. **Launch the App:** You will be greeted by the main Dashboard.
2. **Connect a Wearable:** (If you have a supported smartwatch) wear it to begin streaming live physiological data.
3. **Monitor Your Capacity:** Watch the circular gauge on the home screen. A high percentage (e.g., 85%) means you have high mental bandwidth. A lower percentage indicates it might be a good time to rest.
4. **Log Habits:** Tap any of the quick-log buttons (e.g., "Workout", "Meditation") when you perform an activity.
5. **Analyze Trends:** Look at the "Capacity Trends" chart to see the cause-and-effect relationship between your logged habits and your brain's energy levels.

---

## Developer Setup & Installation

### Prerequisites
- Flutter SDK installed (Version 3.12.2 or higher recommended).
- Android Studio or a connected Android device/emulator.
- **Note:** The Synheart SDK requires Android SDK 28 (Android 9.0) or higher.

### Installation Steps
1. **Clone the repository:**
   ```bash
   git clone https://github.com/YOUR_GITHUB_USERNAME/mindfuel_app.git
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
