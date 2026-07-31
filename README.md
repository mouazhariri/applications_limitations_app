# Focus Guard - Phone Usage Limiter & App Lock

A production-oriented Flutter application that helps reduce phone addiction by limiting daily phone usage and blocking distracting Android applications after their limits expire.

## Architecture

- Feature-based clean architecture under `lib/features/*`
- Presentation → Domain → Data dependency direction
- Riverpod v2 `AsyncNotifier` controllers and Riverpod dependency injection
- Repository pattern with `Either<Failure, Success>` style results
- Easy Localization JSON translations for English and Arabic
- GoRouter navigation
- Shared Material 3 theme, colors, typography, logger, and reusable widgets

## Android native protection

The Android implementation includes:

- `UsageStatsManager` for today/yesterday usage and per-app usage
- `AccessibilityService` to detect foreground applications
- Foreground monitoring service with persistent notification
- Full-screen overlay lock service for expired app/phone limits
- Boot receiver to restart protection after reboot/package update
- Device Admin receiver declaration for strongest supported Android policy integration
- MethodChannel bridge between Flutter and Kotlin

## Android limitation

A normal Android application cannot make itself impossible to uninstall, cannot fully block system UI such as the notification shade on all devices, and cannot bypass OS permission controls. Focus Guard implements the strongest supported non-root approach using Usage Access, Accessibility, overlays, foreground services, boot restart, and Device Admin APIs. If a required permission is removed, the app warns the user and routes back to permission setup.

## Setup

Run:

```bash
flutter pub get
flutter run
```

Then complete onboarding, enable all required Android permissions, and create the parent PIN or pattern.
