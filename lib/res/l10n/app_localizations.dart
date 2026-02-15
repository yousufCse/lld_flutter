import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Auto-generated localization class
/// Run `flutter gen-l10n` to regenerate this file
class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations? _current;

  static AppLocalizations get current {
    assert(
      _current != null,
      'AppLocalizations.current has not been set. Please call AppLocalizations.load() before accessing current.',
    );
    return _current!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  // App Information
  String get appTitle =>
      _localizedValues[locale.languageCode]!['app_title'] ?? 'Niramoy Health';

  // Common Actions
  String get welcome =>
      _localizedValues[locale.languageCode]!['welcome'] ?? 'Welcome';
  String get login =>
      _localizedValues[locale.languageCode]!['login'] ?? 'Login';
  String get logout =>
      _localizedValues[locale.languageCode]!['logout'] ?? 'Logout';
  String get password =>
      _localizedValues[locale.languageCode]!['password'] ?? 'Password';
  String get confirmPassword =>
      _localizedValues[locale.languageCode]!['confirm_password'] ??
      'Confirm Password';
  String get email =>
      _localizedValues[locale.languageCode]!['email'] ?? 'Email';
  String get phoneNumber =>
      _localizedValues[locale.languageCode]!['phone_number'] ?? 'Phone Number';
  String get submit =>
      _localizedValues[locale.languageCode]!['submit'] ?? 'Submit';
  String get cancel =>
      _localizedValues[locale.languageCode]!['cancel'] ?? 'Cancel';
  String get ok => _localizedValues[locale.languageCode]!['ok'] ?? 'OK';
  String get error =>
      _localizedValues[locale.languageCode]!['error'] ?? 'Error';
  String get success =>
      _localizedValues[locale.languageCode]!['success'] ?? 'Success';
  String get loading =>
      _localizedValues[locale.languageCode]!['loading'] ?? 'Loading...';
  String get retry =>
      _localizedValues[locale.languageCode]!['retry'] ?? 'Retry';

  // Error Messages
  String get errorNoInternet =>
      _localizedValues[locale.languageCode]!['error_no_internet'] ??
      'No internet connection. Please check your network settings.';
  String get errorSomethingWentWrong =>
      _localizedValues[locale.languageCode]!['error_something_went_wrong'] ??
      'Something went wrong. Please try again.';
  String get errorInvalidCredentials =>
      _localizedValues[locale.languageCode]!['error_invalid_credentials'] ??
      'Invalid email or password.';
  String get errorSessionExpired =>
      _localizedValues[locale.languageCode]!['error_session_expired'] ??
      'Your session has expired. Please login again.';

  // Vital Signs
  String get vitalHeartRate =>
      _localizedValues[locale.languageCode]!['vital_heart_rate'] ??
      'Heart Rate';
  String get vitalBloodPressure =>
      _localizedValues[locale.languageCode]!['vital_blood_pressure'] ??
      'Blood Pressure';
  String get vitalTemperature =>
      _localizedValues[locale.languageCode]!['vital_temperature'] ??
      'Temperature';
  String get vitalWeight =>
      _localizedValues[locale.languageCode]!['vital_weight'] ?? 'Weight';
  String get vitalGlucose =>
      _localizedValues[locale.languageCode]!['vital_glucose'] ?? 'Glucose';

  // Navigation
  String get profile =>
      _localizedValues[locale.languageCode]!['profile'] ?? 'Profile';
  String get settings =>
      _localizedValues[locale.languageCode]!['settings'] ?? 'Settings';
  String get home => _localizedValues[locale.languageCode]!['home'] ?? 'Home';
  String get dashboard =>
      _localizedValues[locale.languageCode]!['dashboard'] ?? 'Dashboard';
  String get myHealth =>
      _localizedValues[locale.languageCode]!['my_health'] ?? 'My Health';
  String get nutrition =>
      _localizedValues[locale.languageCode]!['nutrition'] ?? 'Nutrition';
  String get exercise =>
      _localizedValues[locale.languageCode]!['exercise'] ?? 'Exercise';
  String get journal =>
      _localizedValues[locale.languageCode]!['journal'] ?? 'Journal';

  // Time
  String get today =>
      _localizedValues[locale.languageCode]!['today'] ?? 'Today';
  String get yesterday =>
      _localizedValues[locale.languageCode]!['yesterday'] ?? 'Yesterday';
  String get thisWeek =>
      _localizedValues[locale.languageCode]!['this_week'] ?? 'This Week';
  String get thisMonth =>
      _localizedValues[locale.languageCode]!['this_month'] ?? 'This Month';

  // Data States
  String get noDataAvailable =>
      _localizedValues[locale.languageCode]!['no_data_available'] ??
      'No data available';
  String get pullToRefresh =>
      _localizedValues[locale.languageCode]!['pull_to_refresh'] ??
      'Pull to refresh';
  String get loadMore =>
      _localizedValues[locale.languageCode]!['load_more'] ?? 'Load More';

  // Notifications
  String get notification =>
      _localizedValues[locale.languageCode]!['notification'] ?? 'Notification';
  String get notifications =>
      _localizedValues[locale.languageCode]!['notifications'] ??
      'Notifications';
  String get markAllRead =>
      _localizedValues[locale.languageCode]!['mark_all_read'] ??
      'Mark All as Read';

  // Legal
  String get termsAndConditions =>
      _localizedValues[locale.languageCode]!['terms_and_conditions'] ??
      'Terms and Conditions';
  String get privacyPolicy =>
      _localizedValues[locale.languageCode]!['privacy_policy'] ??
      'Privacy Policy';
  String get agree =>
      _localizedValues[locale.languageCode]!['agree'] ?? 'I Agree';
  String get disagree =>
      _localizedValues[locale.languageCode]!['disagree'] ?? 'I Disagree';

  // Localization data
  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'app_title': 'Niramoy Health',
      'welcome': 'Welcome',
      'login': 'Login',
      'logout': 'Logout',
      'password': 'Password',
      'confirm_password': 'Confirm Password',
      'email': 'Email',
      'phone_number': 'Phone Number',
      'submit': 'Submit',
      'cancel': 'Cancel',
      'ok': 'OK',
      'error': 'Error',
      'success': 'Success',
      'loading': 'Loading...',
      'retry': 'Retry',
      'error_no_internet':
          'No internet connection. Please check your network settings.',
      'error_something_went_wrong': 'Something went wrong. Please try again.',
      'error_invalid_credentials': 'Invalid email or password.',
      'error_session_expired': 'Your session has expired. Please login again.',
      'vital_heart_rate': 'Heart Rate',
      'vital_blood_pressure': 'Blood Pressure',
      'vital_temperature': 'Temperature',
      'vital_weight': 'Weight',
      'vital_glucose': 'Glucose',
      'profile': 'Profile',
      'settings': 'Settings',
      'home': 'Home',
      'dashboard': 'Dashboard',
      'my_health': 'My Health',
      'nutrition': 'Nutrition',
      'exercise': 'Exercise',
      'journal': 'Journal',
      'today': 'Today',
      'yesterday': 'Yesterday',
      'this_week': 'This Week',
      'this_month': 'This Month',
      'no_data_available': 'No data available',
      'pull_to_refresh': 'Pull to refresh',
      'load_more': 'Load More',
      'notification': 'Notification',
      'notifications': 'Notifications',
      'mark_all_read': 'Mark All as Read',
      'terms_and_conditions': 'Terms and Conditions',
      'privacy_policy': 'Privacy Policy',
      'agree': 'I Agree',
      'disagree': 'I Disagree',
    },
    'bn': {
      'app_title': 'নিরাময় হেলথ',
      'welcome': 'স্বাগতম',
      'login': 'লগইন',
      'logout': 'লগআউট',
      'password': 'পাসওয়ার্ড',
      'confirm_password': 'পাসওয়ার্ড নিশ্চিত করুন',
      'email': 'ইমেল',
      'phone_number': 'ফোন নম্বর',
      'submit': 'জমা দিন',
      'cancel': 'বাতিল',
      'ok': 'ঠিক আছে',
      'error': 'ত্রুটি',
      'success': 'সফল',
      'loading': 'লোড হচ্ছে...',
      'retry': 'আবার চেষ্টা করুন',
      'error_no_internet':
          'ইন্টারনেট সংযোগ নেই। আপনার নেটওয়ার্ক সেটিংস চেক করুন।',
      'error_something_went_wrong': 'কিছু ভুল হয়েছে। আবার চেষ্টা করুন।',
      'error_invalid_credentials': 'অবৈধ ইমেল বা পাসওয়ার্ড।',
      'error_session_expired': 'আপনার সেশন শেষ হয়েছে। আবার লগইন করুন।',
      'vital_heart_rate': 'হার্ট রেট',
      'vital_blood_pressure': 'রক্তচাপ',
      'vital_temperature': 'তাপমাত্রা',
      'vital_weight': 'ওজন',
      'vital_glucose': 'গ্লুকোজ',
      'profile': 'প্রোফাইল',
      'settings': 'সেটিংস',
      'home': 'হোম',
      'dashboard': 'ড্যাশবোর্ড',
      'my_health': 'আমার স্বাস্থ্য',
      'nutrition': 'পুষ্টি',
      'exercise': 'ব্যায়াম',
      'journal': 'জার্নাল',
      'today': 'আজ',
      'yesterday': 'গতকাল',
      'this_week': 'এই সপ্তাহ',
      'this_month': 'এই মাস',
      'no_data_available': 'কোন ডেটা পাওয়া যায়নি',
      'pull_to_refresh': 'রিফ্রেশ করতে টানুন',
      'load_more': 'আরও লোড করুন',
      'notification': 'বিজ্ঞপ্তি',
      'notifications': 'বিজ্ঞপ্তিসমূহ',
      'mark_all_read': 'সব পঠিত হিসেবে চিহ্নিত করুন',
      'terms_and_conditions': 'শর্তাবলী এবং শর্তসমূহ',
      'privacy_policy': 'গোপনীয়তা নীতি',
      'agree': 'আমি সম্মতি',
      'disagree': 'আমি অসম্মতি',
    },
  };
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool isSupported(Locale locale) {
    return AppLocalizations._localizedValues.containsKey(locale.languageCode);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) =>
      false;
}
