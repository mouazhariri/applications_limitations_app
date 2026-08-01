abstract class AppRoutes {
  // ── Init ──────────────────────────────────────────────────────────────────
  static const String splashScreen = '/splash';
  static const String onBoarding = '/onBoarding';

  // ── Auth ──────────────────────────────────────────────────────────────────
  static const String authScreen = '/auth';
  static const String signInScreen = '/signIn';
  static const String signUpScreen = '/signUp';
  static const String verificationScreen = '/verification';

  // ── Main ──────────────────────────────────────────────────────────────────
  static const String homeScreen = '/home';
  static const String doctorsScreen = '/doctors';

  // ✅ Flat paths — no :doctorId in the path, doctorId goes in extra
  static const String doctorDetailsScreen = '/doctor-details';
  static const String bookAppointmentScreen = '/book-appointment';
  static const String bookAppointmentConfirmScreen = '/book-appointment/confirm';
  static const String bookAppointmentSuccessScreen = '/book-appointment/success';

  static const String appointmentsScreen = '/appointments';
  static const String profileScreen = '/profile';
  static const String sessionScreen = '/session';
  static const String chatScreen = '/chat';
  static const String appointmentTrackingScreen = '/appointment/tracking';
static const String sessionDetailsScreen = '/appointment/session';
  static const String privacyPolicyScreen = '/privacy-policy';
  static const String termsPrivacyScreen = '/terms-privacy';
  static const String changeLanguageScreen = '/change-language';
}