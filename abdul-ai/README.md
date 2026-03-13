# Abdul AI

Personal JARVIS AI Assistant with Real-time Caller ID

## Features

- 🤖 AI-powered chat assistant using Groq API
- 📞 Real-time caller ID with AI-powered information lookup
- 🔔 Overlay notifications during incoming calls
- 🚀 Background service for continuous monitoring
- 🔒 Privacy-focused with on-device processing

## Requirements

- Flutter SDK 3.0.0 or higher
- Android SDK (minSdk 21)
- Groq API key

## Setup

1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Configure Groq API key in `lib/config/app_config.dart`

4. Build and run:
   ```bash
   flutter run
   ```

## Permissions

The app requires the following permissions:
- Phone state access (for caller ID)
- Overlay permission (for displaying caller info)
- Background service (for continuous monitoring)
- Boot completed (for auto-start)

## Build

To build a release APK:
```bash
flutter build apk --release
```

## License

Copyright © 2024 Halal Billionaires
