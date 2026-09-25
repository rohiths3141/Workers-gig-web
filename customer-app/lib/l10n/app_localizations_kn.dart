// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Kannada (`kn`).
class AppLocalizationsKn extends AppLocalizations {
  AppLocalizationsKn([String locale = 'kn']) : super(locale);

  @override
  String get commonRetry => 'ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ';

  @override
  String get commonTryAgain => 'ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ';

  @override
  String get commonSignOut => 'ಸೈನ್ ಔಟ್ ಮಾಡಿ';

  @override
  String get assistantFabLabel => 'AI ಅನ್ನು ಕೇಳಿ';

  @override
  String get navHome => 'ಮುಖಪುಟ';

  @override
  String get navExplore => 'ಅನ್ವೇಷಿಸಿ';

  @override
  String get navBookings => 'ಬುಕಿಂಗ್‌ಗಳು';

  @override
  String get navAlerts => 'ಎಚ್ಚರಿಕೆಗಳು';

  @override
  String get navProfile => 'ಪ್ರೊಫೈಲ್';

  @override
  String get configErrorTitle => 'ಆ್ಯಪ್ ಕಾನ್ಫಿಗರ್ ಆಗಿಲ್ಲ';

  @override
  String configErrorBody(String keys, String command) {
    return 'ಈ ಬಿಲ್ಡ್‌ನಲ್ಲಿ $keys ಇಲ್ಲ. ಹೀಗೆ ರನ್ ಮಾಡಿ:\n\n$command\n\nಆಗ ಆ್ಯಪ್ ನಿಜವಾದ ಬ್ಯಾಕ್‌ಎಂಡ್ ತಲುಪಬಹುದು.';
  }

  @override
  String get sessionProfileLoadFailedRetry =>
      'ನಿಮ್ಮ ಪ್ರೊಫೈಲ್ ಲೋಡ್ ಮಾಡಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ. ದಯವಿಟ್ಟು ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get sessionProfileLoadFailed =>
      'ನಿಮ್ಮ ಪ್ರೊಫೈಲ್ ಲೋಡ್ ಮಾಡಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ';

  @override
  String get sessionCheckClock => 'ನಿಮ್ಮ ಫೋನ್‌ನ ಗಡಿಯಾರ ಪರಿಶೀಲಿಸಿ';

  @override
  String get splashTagline => 'ಮನೆಯ ಸೇವೆಗಳು, ಸರಿಯಾದ ರೀತಿಯಲ್ಲಿ.';

  @override
  String get timelineBookingConfirmed => 'ಬುಕಿಂಗ್ ದೃಢೀಕರಿಸಲಾಗಿದೆ';

  @override
  String get timelineProviderOnTheWay => 'ಸೇವೆ ನೀಡುವವರು ದಾರಿಯಲ್ಲಿದ್ದಾರೆ';

  @override
  String get timelineServiceInProgress => 'ಸೇವೆ ನಡೆಯುತ್ತಿದೆ';

  @override
  String get timelineCompleted => 'ಪೂರ್ಣಗೊಂಡಿದೆ';

  @override
  String get errorNoInternet =>
      'ಇಂಟರ್ನೆಟ್ ಸಂಪರ್ಕವಿಲ್ಲ. ನಿಮ್ಮ ನೆಟ್‌ವರ್ಕ್ ಪರಿಶೀಲಿಸಿ ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get errorTimeout => 'ಇದಕ್ಕೆ ತುಂಬಾ ಸಮಯ ಹಿಡಿಯಿತು. ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get errorServer =>
      'ನಮ್ಮ ಕಡೆ ಏನೋ ತಪ್ಪಾಗಿದೆ. ದಯವಿಟ್ಟು ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get errorClockSkew =>
      'ನಿಮ್ಮ ಫೋನ್‌ನ ದಿನಾಂಕ ಮತ್ತು ಸಮಯ ಸರಿಯಾಗಿಲ್ಲ ಎಂದು ತೋರುತ್ತದೆ. ಸೆಟ್ಟಿಂಗ್‌ಗಳಲ್ಲಿ ಸ್ವಯಂಚಾಲಿತ ದಿನಾಂಕ ಮತ್ತು ಸಮಯ ಆನ್ ಮಾಡಿ, ನಂತರ ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get errorUnexpected => 'ಏನೋ ತಪ್ಪಾಗಿದೆ. ದಯವಿಟ್ಟು ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get errorSessionEnded =>
      'ನಿಮ್ಮ ಸೆಷನ್ ಮುಗಿದಿದೆ. ದಯವಿಟ್ಟು ಮತ್ತೆ ಸೈನ್ ಇನ್ ಮಾಡಿ.';

  @override
  String get errorUploadFailed =>
      'ಆ ಫೈಲ್ ಅಪ್‌ಲೋಡ್ ಮಾಡಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ. ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get errorSignInNotReady =>
      'ನಿಮ್ಮ ಸೈನ್-ಇನ್ ಇನ್ನೂ ಪೂರ್ಣವಾಗಿ ಸಿದ್ಧವಾಗಿಲ್ಲ. ಸ್ವಲ್ಪ ಹೊತ್ತಿನ ನಂತರ ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get errorNoLongerAvailable => 'ಅದು ಈಗ ಲಭ್ಯವಿಲ್ಲ.';

  @override
  String get errorNotAllowedToSee => 'ನೀವು ಅದನ್ನು ನೋಡಲು ಸಾಧ್ಯವಿಲ್ಲ.';

  @override
  String get errorDidNotWork => 'ಅದು ಕೆಲಸ ಮಾಡಲಿಲ್ಲ. ದಯವಿಟ್ಟು ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get authErrorInvalidPhone => 'ಆ ಫೋನ್ ಸಂಖ್ಯೆ ಸರಿಯಾಗಿ ಕಾಣುತ್ತಿಲ್ಲ.';

  @override
  String get authErrorWrongCode =>
      'ಆ ಕೋಡ್ ಸರಿಯಾಗಿಲ್ಲ. ಪರಿಶೀಲಿಸಿ ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get authErrorCodeExpired => 'ಆ ಕೋಡ್‌ನ ಅವಧಿ ಮುಗಿದಿದೆ. ಹೊಸ ಕೋಡ್ ಕೇಳಿ.';

  @override
  String get authErrorTooManyAttempts =>
      'ಹಲವು ಪ್ರಯತ್ನಗಳಾಗಿವೆ. ಮತ್ತೆ ಪ್ರಯತ್ನಿಸುವ ಮೊದಲು ಕೆಲವು ನಿಮಿಷ ಕಾಯಿರಿ.';

  @override
  String get authErrorQuota =>
      'ಈಗ ಕೋಡ್ ಕಳುಹಿಸಲು ಸಾಧ್ಯವಿಲ್ಲ. ಸ್ವಲ್ಪ ಹೊತ್ತಿನ ನಂತರ ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get authErrorDisabled =>
      'ಈ ಖಾತೆಯನ್ನು ನಿಷ್ಕ್ರಿಯಗೊಳಿಸಲಾಗಿದೆ. ಸಹಾಯವನ್ನು ಸಂಪರ್ಕಿಸಿ.';

  @override
  String get authErrorPhoneNotEnabled =>
      'ಫೋನ್ ಸೈನ್-ಇನ್ ಸಕ್ರಿಯವಾಗಿಲ್ಲ. ಸಹಾಯವನ್ನು ಸಂಪರ್ಕಿಸಿ.';

  @override
  String get authErrorNumberInUse =>
      'ಆ ಸಂಖ್ಯೆ ಈಗಾಗಲೇ ಬೇರೆ ಖಾತೆಗೆ ನೋಂದಣಿಯಾಗಿದೆ.';

  @override
  String get authErrorSignInAgain =>
      'ಮುಂದುವರಿಯಲು ದಯವಿಟ್ಟು ಮತ್ತೆ ಸೈನ್ ಇನ್ ಮಾಡಿ.';

  @override
  String get authErrorSignInFailed =>
      'ಸೈನ್-ಇನ್ ವಿಫಲವಾಗಿದೆ. ದಯವಿಟ್ಟು ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get languagePickerTitle => 'ನಿಮ್ಮ ಭಾಷೆಯನ್ನು ಆಯ್ಕೆಮಾಡಿ';

  @override
  String get authCouldNotStartVerification =>
      'ಪರಿಶೀಲನೆ ಪ್ರಾರಂಭಿಸಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ. ದಯವಿಟ್ಟು ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get authWelcomeTitle => 'Wervexa ಗೆ ಸ್ವಾಗತ';

  @override
  String get authWelcomeSubtitle =>
      'ಮನೆ ದುರಸ್ತಿ, ಪ್ಲಂಬಿಂಗ್, ಎಲೆಕ್ಟ್ರಿಕಲ್, ಸ್ವಚ್ಛತೆ ಮತ್ತು ಇನ್ನಷ್ಟಕ್ಕೆ ಹತ್ತಿರದ ಅತ್ಯುತ್ತಮ ವೃತ್ತಿಪರರನ್ನು ಹುಡುಕಿ.';

  @override
  String get authEnterPhone => 'ನಿಮ್ಮ ಫೋನ್ ಸಂಖ್ಯೆ ನಮೂದಿಸಿ';

  @override
  String get authInvalidMobile => 'ಮಾನ್ಯವಾದ 10 ಅಂಕಿಯ ಮೊಬೈಲ್ ಸಂಖ್ಯೆ ನಮೂದಿಸಿ';

  @override
  String get authGetOtp => 'OTP ಪರಿಶೀಲನೆ ಪಡೆಯಿರಿ';

  @override
  String get authTermsNotice =>
      'ಮುಂದುವರಿಯುವ ಮೂಲಕ, ನೀವು ನಮ್ಮ ಸೇವಾ ನಿಯಮಗಳು ಮತ್ತು ಗೌಪ್ಯತಾ ನೀತಿಗೆ ಒಪ್ಪುತ್ತೀರಿ';

  @override
  String get authNewCodeSent => 'ನಾವು ಹೊಸ ಕೋಡ್ ಕಳುಹಿಸಿದ್ದೇವೆ.';

  @override
  String get authVerifyPhoneTitle => 'ಫೋನ್ ಪರಿಶೀಲಿಸಿ';

  @override
  String get authChangeNumber => 'ಸಂಖ್ಯೆ ಬದಲಾಯಿಸಿ';

  @override
  String get authEnterCodeTitle => '6 ಅಂಕಿಯ ಕೋಡ್ ನಮೂದಿಸಿ';

  @override
  String authCodeSentTo(Object phone) {
    return 'ನಾವು $phone ಗೆ SMS ಪರಿಶೀಲನಾ ಕೋಡ್ ಕಳುಹಿಸಿದ್ದೇವೆ';
  }

  @override
  String get authWrongNumber => 'ತಪ್ಪು ಸಂಖ್ಯೆಯೇ? ಬದಲಾಯಿಸಿ';

  @override
  String get authEnterSixDigits => 'ದಯವಿಟ್ಟು 6 ಅಂಕಿಗಳನ್ನು ನಮೂದಿಸಿ';

  @override
  String get authResendCode => 'ಕೋಡ್ ಮತ್ತೆ ಕಳುಹಿಸಿ';

  @override
  String authResendCodeIn(Object seconds) {
    return '$seconds ಸೆಕೆಂಡುಗಳಲ್ಲಿ ಕೋಡ್ ಮತ್ತೆ ಕಳುಹಿಸಿ';
  }

  @override
  String get authVerifyAndContinue => 'ಪರಿಶೀಲಿಸಿ ಮತ್ತು ಮುಂದುವರಿಯಿರಿ';

  @override
  String get registerTitle => 'ಪ್ರೊಫೈಲ್ ಪೂರ್ಣಗೊಳಿಸಿ';

  @override
  String get registerHeading => 'ನಿಮ್ಮ ಹೆಸರು ತಿಳಿಸಿ';

  @override
  String get registerNameVisibility =>
      'ನೀವು ಬುಕಿಂಗ್ ವಿನಂತಿ ಮಾಡಿದಾಗ ನಿಮ್ಮ ಹೆಸರು ಸೇವಾ ಕಾರ್ಮಿಕರಿಗೆ ಕಾಣಿಸುತ್ತದೆ.';

  @override
  String get registerFullNameLabel => 'ಪೂರ್ಣ ಹೆಸರು *';

  @override
  String get registerFullNameHint => 'ಉದಾ. ರಾಹುಲ್ ಶರ್ಮಾ';

  @override
  String get registerFullNameRequired => 'ದಯವಿಟ್ಟು ನಿಮ್ಮ ಪೂರ್ಣ ಹೆಸರು ನಮೂದಿಸಿ';

  @override
  String get registerEmailLabel => 'ಇಮೇಲ್ ವಿಳಾಸ (ಐಚ್ಛಿಕ)';

  @override
  String get registerEmailHint => 'ಉದಾ. rahul@example.com';

  @override
  String get registerSubmit => 'ಉಳಿಸಿ ಮತ್ತು ಪ್ರಾರಂಭಿಸಿ';

  @override
  String get bookingStatusRequested => 'ವೃತ್ತಿಪರರನ್ನು ಹುಡುಕುತ್ತಿದ್ದೇವೆ…';

  @override
  String get bookingStatusAccepted => 'ವೃತ್ತಿಪರರು ಸಿಕ್ಕಿದ್ದಾರೆ';

  @override
  String get bookingStatusConfirmed => 'ದೃಢೀಕರಿಸಲಾಗಿದೆ';

  @override
  String get bookingStatusTraveling => 'ದಾರಿಯಲ್ಲಿದ್ದಾರೆ';

  @override
  String get bookingStatusArrived => 'ತಲುಪಿದ್ದಾರೆ — ನಿಮ್ಮ ಕೋಡ್ ನಮೂದಿಸಿ';

  @override
  String get bookingStatusInProgress => 'ಕೆಲಸ ನಡೆಯುತ್ತಿದೆ';

  @override
  String get bookingStatusAwaitingApproval =>
      'ಕೆಲಸ ಮುಗಿದಿದೆ — ಮುಂದುವರಿಯಲು ಅನುಮೋದಿಸಿ';

  @override
  String get bookingStatusCompleted => 'ಪೂರ್ಣಗೊಂಡಿದೆ';

  @override
  String get bookingStatusPaymentPending => 'ಪಾವತಿ ಬಾಕಿ ಇದೆ';

  @override
  String get bookingStatusPaid => 'ಪಾವತಿಸಲಾಗಿದೆ';

  @override
  String get bookingStatusClosed => 'ಮುಚ್ಚಲಾಗಿದೆ';

  @override
  String get bookingStatusCancelled => 'ರದ್ದುಗೊಳಿಸಲಾಗಿದೆ';

  @override
  String get bookingStatusDisputed => 'ವಿವಾದದಲ್ಲಿದೆ';

  @override
  String get bookingStatusExpired => 'ಅವಧಿ ಮುಗಿದಿದೆ — ಯಾರೂ ಲಭ್ಯವಿರಲಿಲ್ಲ';

  @override
  String get pricingPerJob => 'ಪ್ರತಿ ಕೆಲಸಕ್ಕೆ';

  @override
  String get pricingPerHour => 'ಗಂಟೆಗೆ';

  @override
  String get pricingPerDay => 'ದಿನಕ್ಕೆ';

  @override
  String get pricingPerUnit => 'ಪ್ರತಿ ಯೂನಿಟ್‌ಗೆ';

  @override
  String get pricingPerSqft => 'ಪ್ರತಿ ಚದರ ಅಡಿಗೆ';

  @override
  String get supportCategoryBooking => 'ಬುಕಿಂಗ್ ಸಮಸ್ಯೆ';

  @override
  String get supportCategoryPayment => 'ಪಾವತಿ';

  @override
  String get supportCategoryPayout => 'ಪೇಔಟ್';

  @override
  String get supportCategoryVerification => 'ಪರಿಶೀಲನೆ';

  @override
  String get supportCategoryAccount => 'ನನ್ನ ಖಾತೆ';

  @override
  String get supportCategorySafety => 'ಸುರಕ್ಷತಾ ಕಾಳಜಿ';

  @override
  String get supportCategoryClaim => 'ವಿಮಾ ಕ್ಲೈಮ್';

  @override
  String get supportCategoryAppIssue => 'ಆ್ಯಪ್ ಸಮಸ್ಯೆ';

  @override
  String get supportCategoryOther => 'ಇತರೆ';

  @override
  String get requestStatusDraft => 'ಕರಡು';

  @override
  String get requestStatusOpen => 'ತೆರೆದಿದೆ — ಆಫರ್‌ಗಳಿಗಾಗಿ ಕಾಯುತ್ತಿದೆ';

  @override
  String get requestStatusReceivingOffers => 'ಆಫರ್‌ಗಳು ಬರುತ್ತಿವೆ';

  @override
  String get requestStatusWorkerSelected => 'ವೃತ್ತಿಪರರನ್ನು ಆಯ್ಕೆ ಮಾಡಲಾಗಿದೆ';

  @override
  String get requestStatusBooked => 'ಬುಕ್ ಆಗಿದೆ';

  @override
  String get requestStatusCancelled => 'ರದ್ದುಗೊಳಿಸಲಾಗಿದೆ';

  @override
  String get requestStatusExpired => 'ಅವಧಿ ಮುಗಿದಿದೆ';

  @override
  String get requestStatusClosed => 'ಮುಚ್ಚಲಾಗಿದೆ';

  @override
  String get budgetTypeFlexible => 'ಹೊಂದಿಕೊಳ್ಳುವ';

  @override
  String get budgetTypeFixed => 'ನಿಗದಿತ ಬೆಲೆ';

  @override
  String get budgetTypeRange => 'ಬೆಲೆ ಶ್ರೇಣಿ';

  @override
  String get scheduleAsap => 'ಸಾಧ್ಯವಾದಷ್ಟು ಬೇಗ';

  @override
  String get scheduleToday => 'ಇಂದು';

  @override
  String get scheduleTomorrow => 'ನಾಳೆ';

  @override
  String get scheduleSpecificDate => 'ನಿರ್ದಿಷ್ಟ ದಿನಾಂಕದಂದು';

  @override
  String get scheduleScheduled => 'ನಿಗದಿಪಡಿಸಲಾಗಿದೆ';

  @override
  String get offerStatusSubmitted => 'ಹೊಸ ಆಫರ್';

  @override
  String get offerStatusViewed => 'ನೋಡಲಾಗಿದೆ';

  @override
  String get offerStatusShortlisted => 'ಶಾರ್ಟ್‌ಲಿಸ್ಟ್ ಆಗಿದೆ';

  @override
  String get offerStatusAccepted => 'ಸ್ವೀಕರಿಸಲಾಗಿದೆ';

  @override
  String get offerStatusRejected => 'ತಿರಸ್ಕರಿಸಲಾಗಿದೆ';

  @override
  String get offerStatusWithdrawn => 'ಕಾರ್ಮಿಕರು ಹಿಂಪಡೆದಿದ್ದಾರೆ';

  @override
  String get offerStatusExpired => 'ಅವಧಿ ಮುಗಿದಿದೆ';

  @override
  String get offerStatusClosed => 'ಮುಚ್ಚಲಾಗಿದೆ';

  @override
  String get gigRatingNew => 'ಹೊಸ';

  @override
  String distanceMetres(Object metres) {
    return '$metres ಮೀ';
  }

  @override
  String distanceKm(Object km) {
    return '$km ಕಿಮೀ';
  }

  @override
  String durationMinutes(Object minutes) {
    return '$minutes ನಿಮಿಷ';
  }

  @override
  String durationHours(Object hours) {
    return '$hours ಗಂಟೆ';
  }

  @override
  String durationHoursMinutes(int hours, int minutes) {
    return '$hours ಗಂಟೆ $minutes ನಿಮಿಷ';
  }

  @override
  String get offerWorkerFallbackName => 'ವೃತ್ತಿಪರ';

  @override
  String get budgetFlexible => 'ಹೊಂದಿಕೊಳ್ಳುವ ಬಜೆಟ್';

  @override
  String get budgetFixed => 'ನಿಗದಿತ ಬಜೆಟ್';

  @override
  String offerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ಆಫರ್‌ಗಳು',
      one: '1 ಆಫರ್',
      zero: 'ಇನ್ನೂ ಆಫರ್‌ಗಳಿಲ್ಲ',
    );
    return '$_temp0';
  }

  @override
  String get authPhoneTenDigits => '10 ಅಂಕಿಯ ಮೊಬೈಲ್ ಸಂಖ್ಯೆ ನಮೂದಿಸಿ.';

  @override
  String get authCodeSendTimeout =>
      'ಕೋಡ್ ಕಳುಹಿಸಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ. ನಿಮ್ಮ ನೆಟ್‌ವರ್ಕ್ ಪರಿಶೀಲಿಸಿ ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get authEnterReceivedCode => 'ನೀವು ಪಡೆದ ಕೋಡ್ ನಮೂದಿಸಿ.';

  @override
  String get authSignInIncomplete =>
      'ಸೈನ್-ಇನ್ ಪೂರ್ಣಗೊಳ್ಳಲಿಲ್ಲ. ದಯವಿಟ್ಟು ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get authSignInToContinue => 'ಮುಂದುವರಿಯಲು ದಯವಿಟ್ಟು ಸೈನ್ ಇನ್ ಮಾಡಿ.';

  @override
  String get paymentsNotConfigured =>
      'ಈ ಬಿಲ್ಡ್‌ಗೆ ಪಾವತಿಗಳನ್ನು ಇನ್ನೂ ಕಾನ್ಫಿಗರ್ ಮಾಡಿಲ್ಲ.';

  @override
  String get serviceElectrical => 'ಎಲೆಕ್ಟ್ರಿಕಲ್';

  @override
  String get servicePlumbing => 'ಪ್ಲಂಬಿಂಗ್';

  @override
  String get serviceAcService => 'AC ಸರ್ವಿಸ್';

  @override
  String get serviceApplianceRepair => 'ಉಪಕರಣ ದುರಸ್ತಿ';

  @override
  String get serviceCarpentry => 'ಬಡಗಿ ಕೆಲಸ';

  @override
  String get servicePainting => 'ಪೇಂಟಿಂಗ್';

  @override
  String get serviceCleaning => 'ಸ್ವಚ್ಛತೆ';

  @override
  String get servicePestControl => 'ಕೀಟ ನಿಯಂತ್ರಣ';

  @override
  String get serviceOtherHome => 'ಇತರ ಮನೆ ಸೇವೆಗಳು';

  @override
  String get addressLabelHome => 'ಮುಖಪುಟ';

  @override
  String get addressLabelWork => 'ಕಚೇರಿ';

  @override
  String get addressLabelOther => 'ಇತರೆ';

  @override
  String get commonSeeAll => 'ಎಲ್ಲವನ್ನೂ ನೋಡಿ';

  @override
  String get commonViewAll => 'ಎಲ್ಲವನ್ನೂ ನೋಡಿ';

  @override
  String get commonCheckBackLater => 'ದಯವಿಟ್ಟು ನಂತರ ಮತ್ತೆ ನೋಡಿ.';

  @override
  String get commonUseCurrentLocation => 'ಪ್ರಸ್ತುತ ಸ್ಥಳ ಬಳಸಿ';

  @override
  String get commonChooseOnMap => 'ನಕ್ಷೆಯಲ್ಲಿ ಆಯ್ಕೆಮಾಡಿ';

  @override
  String homeGreetingNamed(Object name) {
    return 'ನಮಸ್ಕಾರ, $name 👋';
  }

  @override
  String get homeGreeting => 'ನಮಸ್ಕಾರ 👋';

  @override
  String get homeWhatService => 'ಇಂದು ನಿಮಗೆ ಯಾವ ಸೇವೆ ಬೇಕು?';

  @override
  String get homeSetLocation => 'ನಿಮ್ಮ ಸ್ಥಳ ಹೊಂದಿಸಿ';

  @override
  String get homeWorkFinishedApprove =>
      'ಕೆಲಸ ಮುಗಿದಿದೆ — ಅನುಮೋದಿಸಲು ಟ್ಯಾಪ್ ಮಾಡಿ';

  @override
  String get homeCategories => 'ವರ್ಗಗಳು';

  @override
  String homeCategoriesLoadFailed(Object error) {
    return 'ವರ್ಗಗಳನ್ನು ಲೋಡ್ ಮಾಡಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ: $error';
  }

  @override
  String get homeFindWorker => 'ಕಾರ್ಮಿಕರನ್ನು ಹುಡುಕಿ';

  @override
  String get homeFindWorkerSubtitle => 'ಹತ್ತಿರದ ಸೇವೆಗಳನ್ನು ನೋಡಿ';

  @override
  String get homePostRequest => 'ವಿನಂತಿ ಪೋಸ್ಟ್ ಮಾಡಿ';

  @override
  String get homePostRequestSubtitle => 'ಕಾರ್ಮಿಕರು ನಿಮ್ಮ ಬಳಿ ಬರುತ್ತಾರೆ';

  @override
  String get homeNoServices => 'ಈಗ ಯಾವುದೇ ಸೇವೆ ಲಭ್ಯವಿಲ್ಲ';

  @override
  String get homeSearchNear => 'ಹತ್ತಿರದಲ್ಲಿ ಸೇವೆಗಳನ್ನು ಹುಡುಕಿ';

  @override
  String get homeSearchHint => 'ಸೇವೆಗಳನ್ನು ಹುಡುಕಿ...';

  @override
  String homeActiveBooking(Object code) {
    return 'ಸಕ್ರಿಯ ಬುಕಿಂಗ್ #$code';
  }

  @override
  String get homeActiveRequests => 'ನಿಮ್ಮ ಸಕ್ರಿಯ ವಿನಂತಿಗಳು';

  @override
  String get commonGrantPermission => 'ಅನುಮತಿ ನೀಡಿ';

  @override
  String get commonView => 'ನೋಡಿ';

  @override
  String get exploreTitle => 'ಸೇವೆಗಳನ್ನು ಅನ್ವೇಷಿಸಿ ಮತ್ತು ಕಂಡುಹಿಡಿಯಿರಿ';

  @override
  String get exploreListView => 'ಪಟ್ಟಿ ನೋಟ';

  @override
  String get exploreMapView => 'ನಕ್ಷೆ ನೋಟ';

  @override
  String get exploreSearchHint =>
      'ಸೇವೆಗಳು, ಕಾರ್ಮಿಕರು ಅಥವಾ ಕೌಶಲ್ಯಗಳನ್ನು ಹುಡುಕಿ...';

  @override
  String get exploreLocationOffTitle => 'ಸ್ಥಳ ಸೇವೆಗಳು ಆಫ್ ಆಗಿವೆ';

  @override
  String get exploreLocationOffMessage =>
      'ಹತ್ತಿರದ ವೃತ್ತಿಪರರನ್ನು ಹುಡುಕಲು ಸ್ಥಳ ಆನ್ ಮಾಡಿ.';

  @override
  String get exploreLocationPermissionTitle => 'ಸ್ಥಳ ಅನುಮತಿ ಅಗತ್ಯ';

  @override
  String get exploreLocationPermissionMessage =>
      'ಹತ್ತಿರದ ವೃತ್ತಿಪರರನ್ನು ಹುಡುಕಲು ನಾವು ನಿಮ್ಮ ಸ್ಥಳ ಬಳಸುತ್ತೇವೆ.';

  @override
  String get exploreChooseService => 'ಅನ್ವೇಷಿಸಲು ಒಂದು ಸೇವೆ ಆಯ್ಕೆಮಾಡಿ';

  @override
  String get exploreChooseServiceMessage =>
      'ಹತ್ತಿರದ ವೃತ್ತಿಪರರನ್ನು ನೋಡಲು ಮೇಲೆ ಒಂದು ವರ್ಗ ಆಯ್ಕೆಮಾಡಿ.';

  @override
  String get exploreNoProfessionals =>
      'ಈ ಸೇವೆಗೆ ಹತ್ತಿರದಲ್ಲಿ ಯಾವುದೇ ವೃತ್ತಿಪರರು ಲಭ್ಯವಿಲ್ಲ';

  @override
  String get exploreLoadFailed => 'ವೃತ್ತಿಪರರನ್ನು ಲೋಡ್ ಮಾಡಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ.';

  @override
  String exploreByWorker(Object name) {
    return '$name ಅವರಿಂದ';
  }

  @override
  String get bookingsTitle => 'ನನ್ನ ಸೇವಾ ಬುಕಿಂಗ್‌ಗಳು';

  @override
  String get bookingsTabActive => 'ಸಕ್ರಿಯ';

  @override
  String get bookingsTabCompleted => 'ಪೂರ್ಣಗೊಂಡಿದೆ';

  @override
  String get bookingsTabCancelled => 'ರದ್ದುಗೊಳಿಸಲಾಗಿದೆ';

  @override
  String get bookingsLoadFailed =>
      'ನಿಮ್ಮ ಬುಕಿಂಗ್‌ಗಳನ್ನು ಲೋಡ್ ಮಾಡಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ.';

  @override
  String get bookingsEmpty => 'ಇನ್ನೂ ಬುಕಿಂಗ್‌ಗಳಿಲ್ಲ';

  @override
  String get bookingsFindService => 'ಸೇವೆ ಹುಡುಕಿ';

  @override
  String get bookingsWaitingForProfessional => 'ವೃತ್ತಿಪರರಿಗಾಗಿ ಕಾಯುತ್ತಿದೆ';

  @override
  String bookingsCode(Object code) {
    return 'ಬುಕಿಂಗ್ ಕೋಡ್: #$code';
  }

  @override
  String get bookingsPayNow => 'ಈಗ ಪಾವತಿಸಿ';

  @override
  String get bookingsApproveWork => 'ಕೆಲಸ ಅನುಮೋದಿಸಿ';

  @override
  String get bookingsTrackLive => 'ಲೈವ್ ಟ್ರ್ಯಾಕ್ ಮಾಡಿ';

  @override
  String get bookingsDetails => 'ವಿವರಗಳು';

  @override
  String get bookingDetailTitle => 'ಬುಕಿಂಗ್ ವಿವರಗಳು';

  @override
  String get bookingDetailLoadFailed =>
      'ಬುಕಿಂಗ್ ವಿವರಗಳನ್ನು ಲೋಡ್ ಮಾಡಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ.';

  @override
  String get bookingDetailWaitingAccept => 'ವೃತ್ತಿಪರರು ಸ್ವೀಕರಿಸಲು ಕಾಯುತ್ತಿದೆ';

  @override
  String bookingDetailNumber(Object code) {
    return 'ಬುಕಿಂಗ್ #$code';
  }

  @override
  String bookingDetailStatus(Object status) {
    return 'ಸ್ಥಿತಿ: $status';
  }

  @override
  String get bookingDetailLiveMap => 'ಲೈವ್ ನಕ್ಷೆ';

  @override
  String get bookingDetailServiceInfo => 'ಸೇವಾ ವಿನಂತಿ ಮಾಹಿತಿ';

  @override
  String get bookingDetailViewMaterials =>
      'ಸಾಮಗ್ರಿ / ಬಿಡಿಭಾಗಗಳ ವಿನಂತಿಗಳನ್ನು ನೋಡಿ';

  @override
  String get bookingDetailFareDetails => 'ಶುಲ್ಕದ ವಿವರಗಳು';

  @override
  String get bookingDetailEstimatedFare => 'ಅಂದಾಜು ಶುಲ್ಕ';

  @override
  String get bookingDetailFinalFare => 'ಅಂತಿಮ ದೃಢೀಕೃತ ಶುಲ್ಕ';

  @override
  String get bookingDetailRateReview =>
      'ಸೇವಾ ಕಾರ್ಮಿಕರಿಗೆ ರೇಟಿಂಗ್ ಮತ್ತು ವಿಮರ್ಶೆ ನೀಡಿ';

  @override
  String get bookingDetailApproveCompletion => 'ಪೂರ್ಣಗೊಂಡಿರುವುದನ್ನು ಅನುಮೋದಿಸಿ';

  @override
  String get bookingDetailApprovePaidHint =>
      'ನಿಮ್ಮ ವೃತ್ತಿಪರರು ಈ ಕೆಲಸವನ್ನು ಮುಗಿದಿದೆ ಎಂದು ಗುರುತಿಸಿದ್ದಾರೆ. ಅನುಮೋದಿಸಿದರೆ ನಿಮ್ಮ ಪಾವತಿ ಅವರಿಗೆ ಬಿಡುಗಡೆಯಾಗುತ್ತದೆ.';

  @override
  String get bookingDetailApproveUnpaidHint =>
      'ನಿಮ್ಮ ವೃತ್ತಿಪರರು ಈ ಕೆಲಸವನ್ನು ಮುಗಿದಿದೆ ಎಂದು ಗುರುತಿಸಿದ್ದಾರೆ. ದೃಢೀಕರಿಸಿ ಪಾವತಿಗೆ ಮುಂದುವರಿಯಲು ಅನುಮೋದಿಸಿ.';

  @override
  String get bookingDetailReportProblem => 'ಸಮಸ್ಯೆ ವರದಿ ಮಾಡಿ';

  @override
  String get bookingDetailCompletionApproved =>
      'ಪೂರ್ಣಗೊಂಡಿರುವುದು ಅನುಮೋದಿತವಾಗಿದೆ';

  @override
  String bookingDetailPayToConfirm(Object amount) {
    return 'ದೃಢೀಕರಿಸಲು $amount ಪಾವತಿಸಿ';
  }

  @override
  String get bookingDetailSentAfterPayment =>
      'ಪಾವತಿ ಪೂರ್ಣಗೊಂಡ ನಂತರ ನಿಮ್ಮ ಬುಕಿಂಗ್ ವೃತ್ತಿಪರರಿಗೆ ಕಳುಹಿಸಲಾಗುತ್ತದೆ.';

  @override
  String bookingDetailPayAmount(Object amount) {
    return '$amount ಪಾವತಿಸಿ';
  }

  @override
  String get bookingDetailCancelBooking => 'ಬುಕಿಂಗ್ ರದ್ದುಮಾಡಿ';

  @override
  String get cancelReasonMistake => 'ತಪ್ಪಾಗಿ ಬುಕ್ ಮಾಡಿದೆ';

  @override
  String get cancelReasonNoLongerNeeded => 'ನನಗೆ ಇನ್ನು ಈ ಸೇವೆ ಬೇಕಿಲ್ಲ';

  @override
  String get cancelReasonDifferentTime =>
      'ನಾನು ಬೇರೆ ಸಮಯ ಆಯ್ಕೆ ಮಾಡಲು ಬಯಸುತ್ತೇನೆ';

  @override
  String get cancelReasonFoundSomeoneElse => 'ನನಗೆ ಬೇರೆಯವರು ಸಿಕ್ಕಿದ್ದಾರೆ';

  @override
  String get cancelDialogTitle => 'ನೀವು ಏಕೆ ರದ್ದುಮಾಡುತ್ತಿದ್ದೀರಿ?';

  @override
  String get cancelDialogRefundNotice =>
      'ಇದನ್ನು ರದ್ದುಗೊಳಿಸಲು ಸಾಧ್ಯವಿಲ್ಲ. ನಿಮ್ಮ ಪಾವತಿಯನ್ನು ಮೂಲ ಪಾವತಿ ವಿಧಾನಕ್ಕೆ ಹಿಂದಿರುಗಿಸಲಾಗುತ್ತದೆ.';

  @override
  String get cancelDialogCannotUndo => 'ಇದನ್ನು ರದ್ದುಗೊಳಿಸಲು ಸಾಧ್ಯವಿಲ್ಲ.';

  @override
  String get cancelDialogKeepBooking => 'ಬುಕಿಂಗ್ ಉಳಿಸಿಕೊಳ್ಳಿ';

  @override
  String get bookingCancelledRefund =>
      'ಬುಕಿಂಗ್ ರದ್ದಾಗಿದೆ. ನಿಮ್ಮ ಮರುಪಾವತಿಗೆ ವಿನಂತಿಸಲಾಗಿದೆ.';

  @override
  String get bookingCancelled => 'ಬುಕಿಂಗ್ ರದ್ದಾಗಿದೆ';

  @override
  String get arrivalCodeTitle => 'ಆಗಮನ ಕೋಡ್';

  @override
  String get arrivalCodeShare =>
      'ವೃತ್ತಿಪರರು ತಲುಪಿದ್ದಾರೆ ಎಂದು ದೃಢೀಕರಿಸಲು ಈ ಕೋಡ್ ಅನ್ನು ಅವರಿಗೆ ತಿಳಿಸಿ:';

  @override
  String get arrivalCodeUnavailable => 'ಲಭ್ಯವಿಲ್ಲ';

  @override
  String get arrivalCodeLoadFailed => 'ಕೋಡ್ ಲೋಡ್ ಮಾಡಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ';

  @override
  String get activeBookingTitle => 'ಲೈವ್ ಬುಕಿಂಗ್ ಮತ್ತು ಕಾರ್ಮಿಕ ಟ್ರ್ಯಾಕಿಂಗ್';

  @override
  String get activeBookingLoadFailed => 'ಈ ಬುಕಿಂಗ್ ಲೋಡ್ ಮಾಡಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ.';

  @override
  String get activeBookingMapUnavailable =>
      'ಈ ಬುಕಿಂಗ್‌ಗೆ ಲೈವ್ ನಕ್ಷೆ ಲಭ್ಯವಿಲ್ಲ.';

  @override
  String get activeBookingViewDetails => 'ಬುಕಿಂಗ್ ವಿವರಗಳನ್ನು ನೋಡಿ';

  @override
  String get activeBookingServiceLocation => 'ಸೇವಾ ಸ್ಥಳ';

  @override
  String get activeBookingYourProfessional => 'ನಿಮ್ಮ ವೃತ್ತಿಪರರು';

  @override
  String get activeBookingLive => 'ಲೈವ್';

  @override
  String get activeBookingLastKnown => 'ಕೊನೆಯದಾಗಿ ತಿಳಿದ ಸ್ಥಳ';

  @override
  String get activeBookingPhoneNotShared => 'ಫೋನ್ ಇನ್ನೂ ಹಂಚಿಕೊಂಡಿಲ್ಲ';

  @override
  String get activeBookingCallProfessional => 'ವೃತ್ತಿಪರರಿಗೆ ಕರೆ ಮಾಡಿ';

  @override
  String get activeBookingMaterials => 'ಸಾಮಗ್ರಿಗಳು';

  @override
  String get activeBookingViewDetailsShort => 'ವಿವರಗಳನ್ನು ನೋಡಿ';

  @override
  String get locationConnecting => 'ಲೈವ್ ಸ್ಥಳಕ್ಕೆ ಸಂಪರ್ಕಿಸುತ್ತಿದೆ...';

  @override
  String get locationLiveUnavailable => 'ಲೈವ್ ಸ್ಥಳ ತಾತ್ಕಾಲಿಕವಾಗಿ ಲಭ್ಯವಿಲ್ಲ';

  @override
  String get locationLiveActive => 'ಲೈವ್ ಸ್ಥಳ ಸಕ್ರಿಯವಾಗಿದೆ';

  @override
  String get locationUpdating => 'ಅಪ್‌ಡೇಟ್ ಆಗುತ್ತಿದೆ...';

  @override
  String get locationUnavailable => 'ಸ್ಥಳ ತಾತ್ಕಾಲಿಕವಾಗಿ ಲಭ್ಯವಿಲ್ಲ';

  @override
  String get activeBookingShareStartCode =>
      'ಕಾರ್ಮಿಕರು ತಲುಪಿದ್ದಾರೆ! ಆರಂಭದ ಕೋಡ್ ತಿಳಿಸಿ:';

  @override
  String get commonBack => 'ಹಿಂದೆ';

  @override
  String get paymentCouldNotOpen =>
      'ಪಾವತಿ ಪರದೆ ತೆರೆಯಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ. ದಯವಿಟ್ಟು ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get paymentReceived =>
      'ಪಾವತಿ ಸ್ವೀಕರಿಸಲಾಗಿದೆ. ನಿಮ್ಮ ಬುಕಿಂಗ್ ವೃತ್ತಿಪರರಿಗೆ ಕಳುಹಿಸಲಾಗಿದೆ.';

  @override
  String paymentNotConfirmed(String reason, String reference) {
    return 'ಈ ಪಾವತಿಯನ್ನು ದೃಢೀಕರಿಸಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ: $reason. ಹಣ ಕಡಿತಗೊಂಡಿದ್ದರೆ, $reference ಉಲ್ಲೇಖದೊಂದಿಗೆ ಸಹಾಯವನ್ನು ಸಂಪರ್ಕಿಸಿ.';
  }

  @override
  String get paymentNotCompleted => 'ಪಾವತಿ ಪೂರ್ಣಗೊಳ್ಳಲಿಲ್ಲ.';

  @override
  String paymentExternalWalletUnsupported(Object wallet) {
    return 'ಬಾಹ್ಯ ವಾಲೆಟ್ ($wallet) ಆಯ್ಕೆಮಾಡಲಾಗಿದೆ — ಇದು ಇನ್ನೂ ಬೆಂಬಲಿತವಾಗಿಲ್ಲ.';
  }

  @override
  String get paymentTitle => 'ಪಾವತಿ';

  @override
  String get paymentStatusUnknown =>
      'ಈ ಬುಕಿಂಗ್‌ಗೆ ಈಗಾಗಲೇ ಪಾವತಿಸಲಾಗಿದೆಯೇ ಎಂದು ಪರಿಶೀಲಿಸಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ. ಎರಡು ಬಾರಿ ಪಾವತಿಸುವ ಬದಲು ದಯವಿಟ್ಟು ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get paymentBookingLoadFailed => 'ಈ ಬುಕಿಂಗ್ ಲೋಡ್ ಮಾಡಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ.';

  @override
  String get paymentComplete => 'ಪಾವತಿ ಪೂರ್ಣಗೊಂಡಿದೆ';

  @override
  String paymentPaidFor(String amount, String service) {
    return '$service ಗೆ $amount ಪಾವತಿಸಲಾಗಿದೆ.';
  }

  @override
  String get paymentViewBooking => 'ಬುಕಿಂಗ್ ನೋಡಿ';

  @override
  String get paymentBookingSummary => 'ಬುಕಿಂಗ್ ಸಾರಾಂಶ';

  @override
  String get paymentProvider => 'ಸೇವೆ ನೀಡುವವರು';

  @override
  String get paymentService => 'ಸೇವೆ';

  @override
  String get paymentDate => 'ದಿನಾಂಕ';

  @override
  String get paymentTime => 'ಸಮಯ';

  @override
  String get paymentAddress => 'ವಿಳಾಸ';

  @override
  String get paymentTotal => 'ಒಟ್ಟು';

  @override
  String get paymentHeldSecurely =>
      'ನಿಮ್ಮ ಪಾವತಿಯನ್ನು ಸುರಕ್ಷಿತವಾಗಿ ಇಡಲಾಗುತ್ತದೆ ಮತ್ತು ನೀವು ಕೆಲಸವನ್ನು ಅನುಮೋದಿಸಿದ ನಂತರವೇ ವೃತ್ತಿಪರರಿಗೆ ಬಿಡುಗಡೆ ಮಾಡಲಾಗುತ್ತದೆ. ಕೆಲಸ ಪ್ರಾರಂಭವಾಗುವ ಮೊದಲು ಬುಕಿಂಗ್ ರದ್ದಾದರೆ, ನಿಮಗೆ ಮರುಪಾವತಿ ಸಿಗುತ್ತದೆ.';

  @override
  String get commonChange => 'ಬದಲಾಯಿಸಿ';

  @override
  String get bookMissingDetails =>
      'ಬುಕಿಂಗ್ ವಿವರಗಳು ಇಲ್ಲ — ದಯವಿಟ್ಟು ಮತ್ತೆ ಪ್ರಾರಂಭಿಸಿ.';

  @override
  String get bookSlotPassed =>
      'ಆ ಸಮಯ ಕಳೆದುಹೋಗಿದೆ. ನಿಮ್ಮನ್ನು ಮುಂದಿನ ಲಭ್ಯ ಸ್ಲಾಟ್‌ಗೆ ಸರಿಸಿದ್ದೇವೆ — ಪರಿಶೀಲಿಸಿ ಮತ್ತೆ ದೃಢೀಕರಿಸಿ.';

  @override
  String bookFailed(Object reason) {
    return 'ಬುಕಿಂಗ್ ವಿಫಲವಾಗಿದೆ: $reason';
  }

  @override
  String get bookNoAddress => 'ಯಾವುದೇ ವಿಳಾಸ ಆಯ್ಕೆಮಾಡಿಲ್ಲ';

  @override
  String get bookTitle => 'ಸೇವೆ ಬುಕ್ ಮಾಡಿ';

  @override
  String get bookSelectDate => 'ದಿನಾಂಕ ಆಯ್ಕೆಮಾಡಿ';

  @override
  String get bookSelectTime => 'ಸಮಯ ಆಯ್ಕೆಮಾಡಿ';

  @override
  String get bookSpecialInstructions => 'ವಿಶೇಷ ಸೂಚನೆಗಳು (ಐಚ್ಛಿಕ)';

  @override
  String get bookSpecialInstructionsHint =>
      'ಉದಾ. ಅಡುಗೆಮನೆ ಮತ್ತು ಸ್ನಾನಗೃಹದ ಮೇಲೆ ಗಮನ ಕೊಡಿ...';

  @override
  String get bookConfirm => 'ಬುಕಿಂಗ್ ದೃಢೀಕರಿಸಿ →';

  @override
  String get gigUnknownProfessional => 'ಅಪರಿಚಿತ ವೃತ್ತಿಪರ';

  @override
  String get gigNewProfessional => 'ಹೊಸ ವೃತ್ತಿಪರ';

  @override
  String gigRatingWithCount(String rating, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ವಿಮರ್ಶೆಗಳು',
      one: '1 ವಿಮರ್ಶೆ',
    );
    return '$rating ($_temp0)';
  }

  @override
  String get gigPricing => 'ಬೆಲೆ';

  @override
  String get gigServiceRate => 'ಸೇವಾ ದರ';

  @override
  String get gigFinalAmountNote =>
      'ಅಂತಿಮ ಮೊತ್ತವನ್ನು ನಿಮ್ಮ ವೃತ್ತಿಪರರು ದೃಢೀಕರಿಸುತ್ತಾರೆ ಮತ್ತು ಬುಕಿಂಗ್ ರಚನೆಯಾದ ನಂತರ ಅದರಲ್ಲಿ ತೋರಿಸಲಾಗುತ್ತದೆ.';

  @override
  String get gigKycVerified => 'KYC ಪರಿಶೀಲಿಸಲಾಗಿದೆ';

  @override
  String get gigBackgroundVerified => 'ಹಿನ್ನೆಲೆ ಪರಿಶೀಲಿಸಲಾಗಿದೆ';

  @override
  String get gigBookNow => 'ಈಗ ಬುಕ್ ಮಾಡಿ →';

  @override
  String get discoveryTitle => 'ಲಭ್ಯವಿರುವ ವೃತ್ತಿಪರರು';

  @override
  String get discoveryMissingDetails => 'ಸೇವೆ ಅಥವಾ ಸ್ಥಳದ ವಿವರಗಳು ಇಲ್ಲ.';

  @override
  String get discoveryLocalExperts => 'ಲಭ್ಯವಿರುವ ಸ್ಥಳೀಯ ತಜ್ಞರು';

  @override
  String get discoveryWithin => 'ದೂರದೊಳಗೆ';

  @override
  String get discoveryNoProviders =>
      'ಹತ್ತಿರದಲ್ಲಿ ಯಾವುದೇ ಸೇವೆ ನೀಡುವವರು ಲಭ್ಯವಿಲ್ಲ';

  @override
  String get discoveryTryLargerRadius =>
      'ದೊಡ್ಡ ಹುಡುಕಾಟ ದೂರ ಪ್ರಯತ್ನಿಸಿ ಅಥವಾ ನಂತರ ಮತ್ತೆ ನೋಡಿ.';

  @override
  String get discoveryLoadFailed =>
      'ಹತ್ತಿರದ ಸೇವೆ ನೀಡುವವರನ್ನು ಲೋಡ್ ಮಾಡಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ.';

  @override
  String discoveryServicesForJob(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ಈ ಕೆಲಸಕ್ಕೆ $count ಸೇವೆಗಳು',
      one: 'ಈ ಕೆಲಸಕ್ಕೆ 1 ಸೇವೆ',
    );
    return '$_temp0';
  }

  @override
  String get discoveryBook => 'ಬುಕ್ ಮಾಡಿ';

  @override
  String get categoryServiceDetails => 'ಸೇವಾ ವಿವರಗಳು';

  @override
  String get categoryTagline =>
      'ಮುಂಚಿತವಾಗಿ ತಿಳಿಸಿದ ಬೆಲೆ ಮತ್ತು ಸೇವಾ ಖಾತರಿಯೊಂದಿಗೆ ಪರಿಶೀಲಿತ, ಹಿನ್ನೆಲೆ ತಪಾಸಣೆ ಮಾಡಿದ ಸ್ಥಳೀಯ ತಜ್ಞರನ್ನು ಬುಕ್ ಮಾಡಿ.';

  @override
  String get categoryWhatHelp => 'ನಿಮಗೆ ಯಾವುದರಲ್ಲಿ ಸಹಾಯ ಬೇಕು?';

  @override
  String get categoryDescribeElse => 'ಬೇರೆ ಏನನ್ನಾದರೂ ವಿವರಿಸಿ';

  @override
  String get categoryLoadFailed => 'ಈ ಸೇವೆಯನ್ನು ಲೋಡ್ ಮಾಡಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ.';

  @override
  String get notificationsTitle => 'ಅಧಿಸೂಚನೆಗಳು ಮತ್ತು ಎಚ್ಚರಿಕೆಗಳು';

  @override
  String get notificationsEmpty => 'ನೀವು ಎಲ್ಲವನ್ನೂ ನೋಡಿದ್ದೀರಿ';

  @override
  String get notificationsLoadFailed =>
      'ಅಧಿಸೂಚನೆಗಳನ್ನು ಲೋಡ್ ಮಾಡಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ.';

  @override
  String get timeJustNow => 'ಈಗಷ್ಟೇ';

  @override
  String timeMinutesAgo(Object minutes) {
    return '$minutes ನಿಮಿಷ ಹಿಂದೆ';
  }

  @override
  String timeHoursAgo(Object hours) {
    return '$hours ಗಂಟೆ ಹಿಂದೆ';
  }

  @override
  String get timeYesterday => 'ನಿನ್ನೆ';

  @override
  String get completedTitle => 'ಸೇವೆ ಪೂರ್ಣಗೊಂಡಿದೆ!';

  @override
  String get completedThanks => 'ನಮ್ಮ ಸೇವೆಗಳನ್ನು ಬಳಸಿದ್ದಕ್ಕಾಗಿ ಧನ್ಯವಾದಗಳು.';

  @override
  String get completedViewBookings => 'ಬುಕಿಂಗ್‌ಗಳನ್ನು ನೋಡಿ';

  @override
  String get completedBackHome => 'ಮುಖಪುಟಕ್ಕೆ ಹಿಂತಿರುಗಿ';

  @override
  String commonErrorDetail(Object detail) {
    return 'ದೋಷ: $detail';
  }

  @override
  String get reviewTitle => 'ನಿಮ್ಮ ಅನುಭವಕ್ಕೆ ರೇಟಿಂಗ್ ನೀಡಿ';

  @override
  String get reviewHeading => 'ಅತ್ಯುತ್ತಮ ಸೇವೆ!';

  @override
  String get reviewQuestion => 'ನಿಮ್ಮ ವೃತ್ತಿಪರರೊಂದಿಗಿನ ಅನುಭವ ಹೇಗಿತ್ತು?';

  @override
  String reviewStars(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ನಕ್ಷತ್ರಗಳು',
      one: '1 ನಕ್ಷತ್ರ',
    );
    return '$_temp0';
  }

  @override
  String get reviewCommentHint => 'ನಿಮ್ಮ ಅನುಭವದ ಬಗ್ಗೆ ತಿಳಿಸಿ...';

  @override
  String get reviewSubmit => 'ವಿಮರ್ಶೆ ಸಲ್ಲಿಸಿ →';

  @override
  String get materialsTitle => 'ಸಾಮಗ್ರಿ / ಬಿಡಿಭಾಗಗಳ ವಿನಂತಿಗಳು';

  @override
  String get materialsEmpty => 'ಈ ಬುಕಿಂಗ್‌ಗೆ ಯಾವುದೇ ಸಾಮಗ್ರಿ ವಿನಂತಿ ಸಲ್ಲಿಸಿಲ್ಲ';

  @override
  String materialsQuantityEstimated(Object quantity) {
    return '$quantity · ಅಂದಾಜು';
  }

  @override
  String materialsQuantityActual(Object quantity) {
    return '$quantity · ನಿಜವಾದ';
  }

  @override
  String get materialsReject => 'ತಿರಸ್ಕರಿಸಿ';

  @override
  String get materialsApprove => 'ಅನುಮೋದಿಸಿ';

  @override
  String get materialStatusRequested => 'ವಿನಂತಿಸಲಾಗಿದೆ';

  @override
  String get materialStatusCustomerReview => 'ನಿಮ್ಮ ಪರಿಶೀಲನೆಗಾಗಿ ಕಾಯುತ್ತಿದೆ';

  @override
  String get materialStatusApproved => 'ಅನುಮೋದಿಸಲಾಗಿದೆ';

  @override
  String get materialStatusRejected => 'ತಿರಸ್ಕರಿಸಲಾಗಿದೆ';

  @override
  String get materialStatusPurchased => 'ಖರೀದಿಸಲಾಗಿದೆ';

  @override
  String get materialStatusCostRecorded => 'ವೆಚ್ಚ ದಾಖಲಾಗಿದೆ';

  @override
  String get materialStatusBilled => 'ಬಿಲ್‌ಗೆ ಸೇರಿಸಲಾಗಿದೆ';

  @override
  String get materialStatusCancelled => 'ರದ್ದುಗೊಳಿಸಲಾಗಿದೆ';

  @override
  String get commonSaveChanges => 'ಬದಲಾವಣೆಗಳನ್ನು ಉಳಿಸಿ';

  @override
  String get profileTitle => 'ನನ್ನ ಪ್ರೊಫೈಲ್ ಮತ್ತು ಖಾತೆ';

  @override
  String get profileFallbackName => 'ಗ್ರಾಹಕ ಪ್ರೊಫೈಲ್';

  @override
  String get profileLanguage => 'ಭಾಷೆ';

  @override
  String get profileAddresses => 'ಉಳಿಸಿದ ಸೇವಾ ವಿಳಾಸಗಳು';

  @override
  String get profileAddressesSubtitle =>
      'ಮನೆ, ಕಚೇರಿ ಮತ್ತು ಇತರ ವಿಳಾಸಗಳನ್ನು ನಿರ್ವಹಿಸಿ';

  @override
  String get profileHistory => 'ಹಿಂದಿನ ಸೇವೆಗಳ ಇತಿಹಾಸ';

  @override
  String get profileHistorySubtitle =>
      'ರಸೀದಿಗಳು ಮತ್ತು ಹಿಂದಿನ ಬುಕಿಂಗ್‌ಗಳನ್ನು ನೋಡಿ';

  @override
  String get profileSupport => 'ಸಹಾಯ ಮತ್ತು ಗ್ರಾಹಕ ಬೆಂಬಲ';

  @override
  String get profileSupportSubtitle =>
      'ಟಿಕೆಟ್ ರಚಿಸಿ, ನಮ್ಮ ತಂಡದ ಉತ್ತರಗಳನ್ನು ನೋಡಿ';

  @override
  String get editProfileSaved => 'ಪ್ರೊಫೈಲ್ ಯಶಸ್ವಿಯಾಗಿ ಅಪ್‌ಡೇಟ್ ಆಗಿದೆ';

  @override
  String get editProfileTitle => 'ಪ್ರೊಫೈಲ್ ಸಂಪಾದಿಸಿ';

  @override
  String get editProfileFullName => 'ಪೂರ್ಣ ಹೆಸರು';

  @override
  String get editProfileNameEmpty => 'ಹೆಸರು ಖಾಲಿ ಇರಬಾರದು';

  @override
  String get editProfileEmail => 'ಇಮೇಲ್ ವಿಳಾಸ';

  @override
  String get commonEdit => 'ಸಂಪಾದಿಸಿ';

  @override
  String get commonDelete => 'ಅಳಿಸಿ';

  @override
  String get addressesAdd => 'ಹೊಸ ವಿಳಾಸ ಸೇರಿಸಿ';

  @override
  String get addressesEmpty => 'ನೀವು ಇನ್ನೂ ಯಾವುದೇ ವಿಳಾಸ ಉಳಿಸಿಲ್ಲ';

  @override
  String get addressesEmptyMessage =>
      'ಮುಂದಿನ ಬಾರಿ ವೇಗವಾಗಿ ಬುಕ್ ಮಾಡಲು ಸೇವಾ ವಿಳಾಸ ಸೇರಿಸಿ.';

  @override
  String get addressesDefaultBadge => 'ಡೀಫಾಲ್ಟ್';

  @override
  String get addressesSetDefault => 'ಡೀಫಾಲ್ಟ್ ಆಗಿ ಹೊಂದಿಸಿ';

  @override
  String get addressesLoadFailed => 'ವಿಳಾಸಗಳನ್ನು ಲೋಡ್ ಮಾಡಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ.';

  @override
  String get addressesLabelSheet => 'ಈ ವಿಳಾಸಕ್ಕೆ ಹೆಸರು ನೀಡಿ';

  @override
  String get supportTitle => 'ಸಹಾಯ ಮತ್ತು ಬೆಂಬಲ';

  @override
  String get supportNewTicket => 'ಹೊಸ ಟಿಕೆಟ್';

  @override
  String get supportEmpty => 'ಇನ್ನೂ ಬೆಂಬಲ ಟಿಕೆಟ್‌ಗಳಿಲ್ಲ';

  @override
  String get supportEmptyMessage =>
      'ಬುಕಿಂಗ್ ಅಥವಾ ಆ್ಯಪ್ ಬಗ್ಗೆ ಸಹಾಯ ಬೇಕೇ? ಟಿಕೆಟ್ ರಚಿಸಿ, ನಮ್ಮ ತಂಡ ಉತ್ತರಿಸುತ್ತದೆ.';

  @override
  String get supportLoadFailed =>
      'ನಿಮ್ಮ ಬೆಂಬಲ ಟಿಕೆಟ್‌ಗಳನ್ನು ಲೋಡ್ ಮಾಡಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ.';

  @override
  String get supportStatusOpen => 'ತೆರೆದಿದೆ';

  @override
  String get supportStatusInProgress => 'ಪ್ರಗತಿಯಲ್ಲಿದೆ';

  @override
  String get supportStatusWaitingForYou => 'ನಿಮಗಾಗಿ ಕಾಯುತ್ತಿದೆ';

  @override
  String get supportStatusResolved => 'ಪರಿಹರಿಸಲಾಗಿದೆ';

  @override
  String get supportStatusClosed => 'ಮುಚ್ಚಲಾಗಿದೆ';

  @override
  String get supportNewTicketTitle => 'ಹೊಸ ಬೆಂಬಲ ಟಿಕೆಟ್';

  @override
  String get supportCategory => 'ವರ್ಗ';

  @override
  String get supportSubject => 'ವಿಷಯ';

  @override
  String get supportDescribeIssue => 'ಸಮಸ್ಯೆಯನ್ನು ವಿವರಿಸಿ';

  @override
  String get supportFillSubjectMessage => 'ದಯವಿಟ್ಟು ವಿಷಯ ಮತ್ತು ಸಂದೇಶ ತುಂಬಿಸಿ.';

  @override
  String get supportSubmitTicket => 'ಟಿಕೆಟ್ ಸಲ್ಲಿಸಿ';

  @override
  String get supportTicketTitle => 'ಬೆಂಬಲ ಟಿಕೆಟ್';

  @override
  String get supportNoMessages => 'ಇನ್ನೂ ಸಂದೇಶಗಳಿಲ್ಲ';

  @override
  String get supportMessagesLoadFailed =>
      'ಸಂದೇಶಗಳನ್ನು ಲೋಡ್ ಮಾಡಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ.';

  @override
  String get supportTypeMessage => 'ಸಂದೇಶ ಟೈಪ್ ಮಾಡಿ...';

  @override
  String get supportSend => 'ಕಳುಹಿಸಿ';

  @override
  String get pickerEnterAddress =>
      'ದಯವಿಟ್ಟು ಈ ಪಿನ್‌ಗೆ ವಿಳಾಸ ನಮೂದಿಸಿ ಅಥವಾ ದೃಢೀಕರಿಸಿ';

  @override
  String get pickerTitle => 'ಸೇವಾ ವಿಳಾಸ ಆಯ್ಕೆಮಾಡಿ';

  @override
  String get pickerGettingLocation => 'ನಿಮ್ಮ ಸ್ಥಳ ಪಡೆಯುತ್ತಿದೆ...';

  @override
  String get pickerPermissionDenied =>
      'ಸ್ಥಳ ಅನುಮತಿ ನಿರಾಕರಿಸಲಾಗಿದೆ — ವಿಳಾಸ ಆಯ್ಕೆಮಾಡಲು ನಕ್ಷೆಯನ್ನು ನೀವೇ ಸರಿಸಿ.';

  @override
  String get pickerConfirmPin => 'ಸೇವಾ ಪಿನ್ ಸ್ಥಾನ ದೃಢೀಕರಿಸಿ';

  @override
  String get pickerAddressLabel => 'ಮನೆ / ಫ್ಲ್ಯಾಟ್ / ಬೀದಿ ಹೆಸರು';

  @override
  String get pickerAddressHint => 'ಉದಾ. #102, ಗ್ರೀನ್ ಅವೆನ್ಯೂ, ಇಂದಿರಾನಗರ';

  @override
  String get pickerLandmarkLabel => 'ಹೆಗ್ಗುರುತು (ಐಚ್ಛಿಕ)';

  @override
  String get pickerLandmarkHint => 'ಉದಾ. HDFC ಬ್ಯಾಂಕ್ ATM ಹತ್ತಿರ';

  @override
  String get pickerConfirm => 'ಸ್ಥಳ ದೃಢೀಕರಿಸಿ ಮುಂದುವರಿಯಿರಿ';

  @override
  String get requestSelectLocation => 'ದಯವಿಟ್ಟು ಸೇವಾ ಸ್ಥಳ ಆಯ್ಕೆಮಾಡಿ';

  @override
  String requestTitle(Object service) {
    return '$service ವಿನಂತಿಸಿ';
  }

  @override
  String get requestServiceAddress => 'ಸೇವಾ ವಿಳಾಸ';

  @override
  String get requestDetectingLocation => 'ನಿಮ್ಮ ಸ್ಥಳ ಪತ್ತೆಹಚ್ಚುತ್ತಿದೆ…';

  @override
  String get requestTapToPickLocation => 'ಸೇವಾ ಸ್ಥಳ ಆಯ್ಕೆಮಾಡಲು ಟ್ಯಾಪ್ ಮಾಡಿ';

  @override
  String get requestDescribeIssue => 'ಸಮಸ್ಯೆ / ಕೆಲಸವನ್ನು ವಿವರಿಸಿ';

  @override
  String get requestDescribeHint =>
      'ಉದಾ. ಹಾಲ್‌ನ ಮುಖ್ಯ ಸೀಲಿಂಗ್ ಲೈಟ್ ಸ್ವಿಚ್ ಆನ್ ಮಾಡಿದಾಗ ಕಿಡಿ ಬರುತ್ತಿದೆ.';

  @override
  String get requestDescribeMin =>
      'ದಯವಿಟ್ಟು ಸಮಸ್ಯೆಯನ್ನು ಕನಿಷ್ಠ 10 ಅಕ್ಷರಗಳಲ್ಲಿ ವಿವರಿಸಿ';

  @override
  String get requestAttachPhotos => 'ಸಮಸ್ಯೆಯ ಫೋಟೋಗಳನ್ನು ಲಗತ್ತಿಸಿ (ಐಚ್ಛಿಕ)';

  @override
  String get requestAddPhoto => 'ಫೋಟೋ ಸೇರಿಸಿ';

  @override
  String get requestWhen => 'ನಿಮಗೆ ಸೇವೆ ಯಾವಾಗ ಬೇಕು?';

  @override
  String get requestInstant => '⚡ ತಕ್ಷಣ (30 ನಿಮಿಷ)';

  @override
  String get requestScheduleLater => '📅 ನಂತರಕ್ಕೆ ನಿಗದಿಪಡಿಸಿ';

  @override
  String get requestFindWorkers => 'ಲಭ್ಯವಿರುವ ಕಾರ್ಮಿಕರನ್ನು ಹುಡುಕಿ';

  @override
  String commonLoadFailedDetail(Object detail) {
    return 'ಲೋಡ್ ಮಾಡಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ: $detail';
  }

  @override
  String get myRequestsTitle => 'ನನ್ನ ಸೇವಾ ವಿನಂತಿಗಳು';

  @override
  String get myRequestsTabAll => 'ಎಲ್ಲಾ';

  @override
  String get myRequestsNew => 'ಹೊಸ ವಿನಂತಿ';

  @override
  String get myRequestsNoActive => 'ಸಕ್ರಿಯ ವಿನಂತಿಗಳಿಲ್ಲ';

  @override
  String get myRequestsNoCompleted => 'ಪೂರ್ಣಗೊಂಡ ವಿನಂತಿಗಳಿಲ್ಲ';

  @override
  String get myRequestsNone => 'ಇನ್ನೂ ಸೇವಾ ವಿನಂತಿಗಳಿಲ್ಲ';

  @override
  String get myRequestsEmptyMessage =>
      'ನಿಮ್ಮ ಅಗತ್ಯವನ್ನು ಪೋಸ್ಟ್ ಮಾಡಿ, ಕಾರ್ಮಿಕರು ನಿಮ್ಮ ಬಳಿ ಬರುತ್ತಾರೆ.';

  @override
  String get requestDetailTitle => 'ವಿನಂತಿ ವಿವರಗಳು';

  @override
  String get requestDetailBudget => 'ಬಜೆಟ್';

  @override
  String get requestDetailSchedule => 'ವೇಳಾಪಟ್ಟಿ';

  @override
  String get requestDetailLocation => 'ಸ್ಥಳ';

  @override
  String get requestDetailNotes => 'ಟಿಪ್ಪಣಿಗಳು';

  @override
  String get requestDetailCancel => 'ವಿನಂತಿ ರದ್ದುಮಾಡಿ';

  @override
  String requestDetailOffersReceived(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ಆಫರ್‌ಗಳು ಬಂದಿವೆ',
      one: '1 ಆಫರ್ ಬಂದಿದೆ',
      zero: 'ಇನ್ನೂ ಆಫರ್‌ಗಳಿಲ್ಲ',
    );
    return '$_temp0';
  }

  @override
  String get requestDetailTapToCompare => 'ನೋಡಲು ಮತ್ತು ಹೋಲಿಸಲು ಟ್ಯಾಪ್ ಮಾಡಿ';

  @override
  String get requestDetailWorkersSoon =>
      'ಕಾರ್ಮಿಕರು ಶೀಘ್ರದಲ್ಲೇ ಪ್ರತಿಕ್ರಿಯಿಸಲು ಪ್ರಾರಂಭಿಸುತ್ತಾರೆ';

  @override
  String get requestCancelDialogTitle => 'ಈ ವಿನಂತಿ ರದ್ದುಮಾಡಬೇಕೇ?';

  @override
  String get requestCancelDialogBody =>
      'ಬಾಕಿ ಇರುವ ಎಲ್ಲಾ ಆಫರ್‌ಗಳನ್ನು ಮುಚ್ಚಲಾಗುತ್ತದೆ. ಇದನ್ನು ರದ್ದುಗೊಳಿಸಲು ಸಾಧ್ಯವಿಲ್ಲ.';

  @override
  String get requestCancelKeep => 'ಉಳಿಸಿಕೊಳ್ಳಿ';

  @override
  String get requestCancelConfirm => 'ವಿನಂತಿ ರದ್ದುಮಾಡಿ';

  @override
  String get requestCancelled => 'ವಿನಂತಿ ರದ್ದಾಗಿದೆ';

  @override
  String requestExpiresInDaysHours(int days, int hours) {
    return '$days ದಿನ $hours ಗಂಟೆಯಲ್ಲಿ ಅವಧಿ ಮುಗಿಯುತ್ತದೆ';
  }

  @override
  String requestExpiresInHoursMinutes(int hours, int minutes) {
    return '$hours ಗಂಟೆ $minutes ನಿಮಿಷದಲ್ಲಿ ಅವಧಿ ಮುಗಿಯುತ್ತದೆ';
  }

  @override
  String requestExpiresInMinutes(Object minutes) {
    return '$minutes ನಿಮಿಷದಲ್ಲಿ ಅವಧಿ ಮುಗಿಯುತ್ತದೆ';
  }

  @override
  String get requestExpiresSoon => 'ಶೀಘ್ರದಲ್ಲೇ ಅವಧಿ ಮುಗಿಯುತ್ತದೆ';

  @override
  String get commonCancel => 'ರದ್ದುಮಾಡಿ';

  @override
  String get offersTitle => 'ಬಂದ ಆಫರ್‌ಗಳು';

  @override
  String get offersEmptyMessage =>
      'ಕಾರ್ಮಿಕರು ನಿಮ್ಮ ವಿನಂತಿ ನೋಡುತ್ತಿದ್ದಾರೆ. ಯಾರಾದರೂ ಪ್ರತಿಕ್ರಿಯಿಸಿದಾಗ ನಿಮಗೆ ತಿಳಿಸಲಾಗುತ್ತದೆ.';

  @override
  String get offersPending => 'ಬಾಕಿ ಆಫರ್‌ಗಳು';

  @override
  String get offersPast => 'ಹಿಂದಿನ ಆಫರ್‌ಗಳು';

  @override
  String offersJobsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ಕೆಲಸಗಳು',
      one: '1 ಕೆಲಸ',
    );
    return '$_temp0';
  }

  @override
  String get offersInsured => 'ವಿಮೆ ಇದೆ';

  @override
  String get offersDecline => 'ನಿರಾಕರಿಸಿ';

  @override
  String get offersAcceptOffer => 'ಆಫರ್ ಸ್ವೀಕರಿಸಿ';

  @override
  String get offersAcceptDialogTitle => 'ಈ ಆಫರ್ ಸ್ವೀಕರಿಸಬೇಕೇ?';

  @override
  String offersAcceptDialogBody(String worker, String price) {
    return '$worker ಅವರೊಂದಿಗೆ $price ಗೆ ಬುಕಿಂಗ್ ರಚಿಸಲಾಗುತ್ತದೆ. ಉಳಿದ ಎಲ್ಲಾ ಆಫರ್‌ಗಳನ್ನು ಮುಚ್ಚಲಾಗುತ್ತದೆ.';
  }

  @override
  String get offersAccept => 'ಸ್ವೀಕರಿಸಿ';

  @override
  String offersBookingCreated(Object code) {
    return 'ಬುಕಿಂಗ್ $code ರಚಿಸಲಾಗಿದೆ!';
  }

  @override
  String get commonNext => 'ಮುಂದೆ';

  @override
  String postRequestPosted(Object code) {
    return 'ಸೇವಾ ವಿನಂತಿ $code ಪೋಸ್ಟ್ ಆಗಿದೆ!';
  }

  @override
  String get postRequestTitle => 'ಸೇವಾ ವಿನಂತಿ ಪೋಸ್ಟ್ ಮಾಡಿ';

  @override
  String get postRequestWhatService => 'ನಿಮಗೆ ಯಾವ ಸೇವೆ ಬೇಕು?';

  @override
  String get postRequestSelectCategory =>
      'ನಿಮ್ಮ ಅಗತ್ಯವನ್ನು ಉತ್ತಮವಾಗಿ ವಿವರಿಸುವ ವರ್ಗ ಆಯ್ಕೆಮಾಡಿ.';

  @override
  String get postRequestDescribe => 'ನಿಮ್ಮ ಅಗತ್ಯವನ್ನು ವಿವರಿಸಿ';

  @override
  String postRequestServiceLabel(Object service) {
    return 'ಸೇವೆ: $service';
  }

  @override
  String get postRequestWhatDone => 'ನಿಮಗೆ ಏನು ಕೆಲಸ ಆಗಬೇಕು?';

  @override
  String get postRequestFieldTitle => 'ಶೀರ್ಷಿಕೆ';

  @override
  String get postRequestTitleHint => 'ಉದಾ. ಅಡುಗೆಮನೆಯ ಸೋರುವ ನಲ್ಲಿ ಸರಿಪಡಿಸುವುದು';

  @override
  String postRequestMinChars(Object count) {
    return 'ಕನಿಷ್ಠ $count ಅಕ್ಷರಗಳನ್ನು ನಮೂದಿಸಿ';
  }

  @override
  String get postRequestFieldDescription => 'ವಿವರಣೆ';

  @override
  String get postRequestDescriptionHint => 'ಸಮಸ್ಯೆಯನ್ನು ವಿವರವಾಗಿ ತಿಳಿಸಿ…';

  @override
  String get postRequestFieldNotes => 'ಹೆಚ್ಚುವರಿ ಟಿಪ್ಪಣಿಗಳು (ಐಚ್ಛಿಕ)';

  @override
  String get postRequestNotesHint => 'ಗೇಟ್ ಕೋಡ್, ಇಷ್ಟದ ಸಮಯ ಇತ್ಯಾದಿ';

  @override
  String get postRequestBudgetTitle => 'ನಿಮ್ಮ ಬಜೆಟ್';

  @override
  String get postRequestBudgetHint =>
      'ನೀವು ಎಷ್ಟು ಪಾವತಿಸಲು ಸಿದ್ಧರಿದ್ದೀರಿ ಎಂದು ಕಾರ್ಮಿಕರಿಗೆ ತಿಳಿಸಿ.';

  @override
  String get postRequestFixedPrice => 'ನಿಗದಿತ ಬೆಲೆ (₹)';

  @override
  String postRequestExample(Object example) {
    return 'ಉದಾ. $example';
  }

  @override
  String get postRequestMin => 'ಕನಿಷ್ಠ (₹)';

  @override
  String get postRequestMax => 'ಗರಿಷ್ಠ (₹)';

  @override
  String get postRequestWhenTitle => 'ನಿಮಗೆ ಇದು ಯಾವಾಗ ಬೇಕು?';

  @override
  String get postRequestPickDate => 'ದಿನಾಂಕ ಆಯ್ಕೆಮಾಡಿ';

  @override
  String get postRequestLocationTitle => 'ಸೇವಾ ಸ್ಥಳ';

  @override
  String get postRequestAddressPrivate =>
      'ನೀವು ಆಫರ್ ಸ್ವೀಕರಿಸಿದ ನಂತರವೇ ನಿಮ್ಮ ನಿಖರ ವಿಳಾಸ ಹಂಚಿಕೊಳ್ಳಲಾಗುತ್ತದೆ.';

  @override
  String get postRequestFullAddress => 'ಪೂರ್ಣ ವಿಳಾಸ';

  @override
  String get postRequestValidAddress => 'ಮಾನ್ಯ ವಿಳಾಸ ನಮೂದಿಸಿ';

  @override
  String get postRequestCity => 'ನಗರ';

  @override
  String get postRequestCityHint => 'ಉದಾ. ಬೆಂಗಳೂರು';

  @override
  String get postRequestPincode => 'ಪಿನ್‌ಕೋಡ್';

  @override
  String get postRequestLocationSet => 'ಸ್ಥಳ ಹೊಂದಿಸಲಾಗಿದೆ ✓';

  @override
  String get postRequestSetOnMap => 'ನಕ್ಷೆಯಲ್ಲಿ ಸ್ಥಳ ಹೊಂದಿಸಿ';

  @override
  String get postRequestReviewTitle => 'ನಿಮ್ಮ ವಿನಂತಿ ಪರಿಶೀಲಿಸಿ';

  @override
  String get postRequestNotSelected => 'ಆಯ್ಕೆಮಾಡಿಲ್ಲ';

  @override
  String get postRequestWhen => 'ಯಾವಾಗ';

  @override
  String get postRequestPrivacyNote =>
      'ನೀವು ಆಫರ್ ಸ್ವೀಕರಿಸಿ ಬುಕಿಂಗ್ ರಚನೆಯಾಗುವವರೆಗೆ ನಿಮ್ಮ ನಿಖರ ವಿಳಾಸ ಖಾಸಗಿಯಾಗಿರುತ್ತದೆ.';

  @override
  String get postRequestSubmit => 'ವಿನಂತಿ ಸಲ್ಲಿಸಿ';

  @override
  String get assistantOpening =>
      'ಏನು ತೊಂದರೆ ಎಂದು ನಿಮ್ಮ ಮಾತಿನಲ್ಲೇ ಹೇಳಿ — ಅದಕ್ಕೆ ಸರಿಯಾದ ವೃತ್ತಿಪರರನ್ನು ನಾನು ಹುಡುಕುತ್ತೇನೆ.';

  @override
  String assistantCatalogueFailed(Object reason) {
    return '$reason ಅದಕ್ಕೆ ಉತ್ತರಿಸಲು ನನಗೆ ಸೇವೆಗಳ ಪಟ್ಟಿ ಬೇಕು.';
  }

  @override
  String get assistantCatalogueError =>
      'ಸೇವೆಗಳ ಪಟ್ಟಿ ಲೋಡ್ ಮಾಡುವಲ್ಲಿ ಏನೋ ತಪ್ಪಾಗಿದೆ.';

  @override
  String get assistantGreeting =>
      'ನಮಸ್ಕಾರ. ಮನೆಯಲ್ಲಿ ನಿಮಗೆ ಯಾವುದರಲ್ಲಿ ಸಹಾಯ ಬೇಕು? ಸೋರುವ ನಲ್ಲಿ, ತಂಪಾಗಿಸದ AC, ಕಿಡಿ ಬರುವ ಸ್ವಿಚ್ — ಏನೇ ಇರಲಿ, ನಿಮಗೆ ಇಷ್ಟವಾದಂತೆ ವಿವರಿಸಿ.';

  @override
  String get assistantTooVague =>
      'ನಾನು ಸಹಾಯ ಮಾಡಬಲ್ಲೆ — ಸಮಸ್ಯೆ ಏನು ಎಂದು ತಿಳಿಯಬೇಕಷ್ಟೆ. ಯಾವುದು ಕೆಲಸ ಮಾಡುತ್ತಿಲ್ಲ?';

  @override
  String assistantMultipleJobs(int count) {
    return 'ಇವು $count ಬೇರೆ ಬೇರೆ ಕೆಲಸಗಳಂತೆ ಕಾಣುತ್ತವೆ — ಇವುಗಳಿಗೆ ಬೇರೆ ಬೇರೆ ಕಾರಿಗರು ಬೇಕು. ಪ್ರತಿಯೊಂದೂ ಇಲ್ಲಿದೆ:';
  }

  @override
  String get assistantAmbiguous =>
      'ಇದನ್ನು ಸರಿಯಾಗಿ ಮಾಡಲು ಬಯಸುತ್ತೇನೆ — ಇದು ಒಂದಕ್ಕಿಂತ ಹೆಚ್ಚು ಕೆಲಸಗಳಿಗೆ ಸೇರಬಹುದು. ಯಾವುದು ಹೆಚ್ಚು ಹತ್ತಿರ?';

  @override
  String get assistantUnmatched =>
      'ಪ್ಲಾಟ್‌ಫಾರ್ಮ್‌ನ ಯಾವುದೇ ಸೇವೆಯೊಂದಿಗೆ ಇದನ್ನು ಹೊಂದಿಸಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ. ಹತ್ತಿರದ್ದನ್ನು ಆಯ್ಕೆಮಾಡಿ, ನಿಮ್ಮ ವಿವರಣೆಯನ್ನು ಅಲ್ಲಿಗೆ ಕೊಂಡೊಯ್ಯುತ್ತೇನೆ — ಅಥವಾ ವಿನಂತಿಯಾಗಿ ಪೋಸ್ಟ್ ಮಾಡಿ, ವೃತ್ತಿಪರರು ನಿಮ್ಮ ಬಳಿ ಬರುತ್ತಾರೆ.';

  @override
  String assistantConfidentWithProblem(String service, String problem) {
    return 'ಇದು $service ಕೆಲಸದಂತೆ ಕಾಣುತ್ತದೆ — ಬಹುಶಃ \"$problem\".';
  }

  @override
  String assistantConfident(Object service) {
    return 'ಇದು $service ಕೆಲಸದಂತೆ ಕಾಣುತ್ತದೆ.';
  }

  @override
  String assistantChosen(Object service) {
    return 'ಸರಿ, $service. ನೀವು ಬರೆದ ವಿವರಣೆ ಹಾಗೆಯೇ ಕಳುಹಿಸಲಾಗುತ್ತದೆ.';
  }

  @override
  String get assistantTitle => 'ಸೇವಾ ಸಹಾಯಕ';

  @override
  String get assistantSubtitle => 'ನಿಮ್ಮ ಸಮಸ್ಯೆಗೆ ಸರಿಯಾದ ಕೆಲಸ ಹುಡುಕುತ್ತದೆ';

  @override
  String get assistantStartOver => 'ಮತ್ತೆ ಪ್ರಾರಂಭಿಸಿ';

  @override
  String assistantMatchedOn(Object terms) {
    return 'ಹೊಂದಿಕೆಯಾದವು: $terms';
  }

  @override
  String get assistantFindWorkers => 'ಕಾರ್ಮಿಕರನ್ನು ಹುಡುಕಿ';

  @override
  String get assistantPostRequest => 'ವಿನಂತಿ ಪೋಸ್ಟ್ ಮಾಡಿ';

  @override
  String get assistantInputHint => 'ಸಮಸ್ಯೆಯನ್ನು ವಿವರಿಸಿ...';
}
