// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Kannada (`kn`).
class AppLocalizationsKn extends AppLocalizations {
  AppLocalizationsKn([String locale = 'kn']) : super(locale);

  @override
  String get languagePickerTitle => 'ನಿಮ್ಮ ಭಾಷೆಯನ್ನು ಆಯ್ಕೆಮಾಡಿ';

  @override
  String get startupMissingConfig => 'ಈ ಬಿಲ್ಡ್‌ನಲ್ಲಿ ಕಾನ್ಫಿಗರೇಶನ್ ಇಲ್ಲ.';

  @override
  String startupPassDartDefine(Object keys) {
    return 'ಇವುಗಳನ್ನು --dart-define ಜೊತೆ ನೀಡಿ:\n\n$keys';
  }

  @override
  String get startupCouldNotStart => 'ಆ್ಯಪ್ ಪ್ರಾರಂಭವಾಗಲಿಲ್ಲ.';

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
  String get eligibilityStepIncomplete => 'ಈ ಹಂತ ಇನ್ನೂ ಪೂರ್ಣಗೊಂಡಿಲ್ಲ.';

  @override
  String get errorSessionEnded =>
      'ನಿಮ್ಮ ಸೆಷನ್ ಮುಗಿದಿದೆ. ದಯವಿಟ್ಟು ಮತ್ತೆ ಸೈನ್ ಇನ್ ಮಾಡಿ.';

  @override
  String get errorUploadFailed =>
      'ಆ ಫೈಲ್ ಅಪ್‌ಲೋಡ್ ಮಾಡಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ. ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get errorServiceUnavailable =>
      'ಆ ಸೇವೆ ಈಗ ಲಭ್ಯವಿಲ್ಲ. ಸ್ವಲ್ಪ ಹೊತ್ತಿನ ನಂತರ ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

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
  String get authErrorPhoneNotEnabledRegion =>
      'ಫೋನ್ ಸೈನ್-ಇನ್ ಸಕ್ರಿಯವಾಗಿಲ್ಲ, ಅಥವಾ ಈ ಪ್ರದೇಶಕ್ಕೆ SMS ನಿರ್ಬಂಧಿಸಲಾಗಿದೆ. Firebase Console ಸೆಟ್ಟಿಂಗ್‌ಗಳನ್ನು ಪರಿಶೀಲಿಸಿ.';

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
  String get scheduleSpecificDate => 'ನಿರ್ದಿಷ್ಟ ದಿನಾಂಕ';

  @override
  String get offerStatusSubmitted => 'ಸಲ್ಲಿಸಲಾಗಿದೆ';

  @override
  String get offerStatusViewed => 'ಗ್ರಾಹಕರು ನೋಡಿದ್ದಾರೆ';

  @override
  String get offerStatusShortlisted => 'ಶಾರ್ಟ್‌ಲಿಸ್ಟ್ ಆಗಿದೆ';

  @override
  String get offerStatusAccepted => 'ಸ್ವೀಕರಿಸಲಾಗಿದೆ ✓';

  @override
  String get offerStatusRejected => 'ಆಯ್ಕೆಮಾಡಿಲ್ಲ';

  @override
  String get offerStatusWithdrawn => 'ಹಿಂಪಡೆಯಲಾಗಿದೆ';

  @override
  String get offerStatusExpired => 'ಅವಧಿ ಮುಗಿದಿದೆ';

  @override
  String get offerStatusClosed => 'ಮುಚ್ಚಲಾಗಿದೆ';

  @override
  String distanceMetresAway(Object metres) {
    return '$metres ಮೀ ದೂರದಲ್ಲಿ';
  }

  @override
  String distanceKmAway(Object km) {
    return '$km ಕಿಮೀ ದೂರದಲ್ಲಿ';
  }

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
  String get gigErrorTrade => 'ಈ ಸೇವೆ ಯಾವ ಕೆಲಸಕ್ಕೆ ಸೇರಿದೆ ಎಂದು ಆಯ್ಕೆಮಾಡಿ';

  @override
  String get gigErrorTitleShort =>
      'ಈ ಸೇವೆಗೆ ಕನಿಷ್ಠ 6 ಅಕ್ಷರಗಳ ಸ್ಪಷ್ಟ ಹೆಸರು ನೀಡಿ';

  @override
  String get gigErrorTitleLong => 'ಹೆಸರನ್ನು 120 ಅಕ್ಷರಗಳೊಳಗೆ ಇಡಿ';

  @override
  String get gigErrorPrice =>
      'ಈ ಸೇವೆಗೆ ನೀವು ಎಷ್ಟು ತೆಗೆದುಕೊಳ್ಳುತ್ತೀರಿ ಎಂದು ನಮೂದಿಸಿ';

  @override
  String get gigErrorDurationMissing => 'ಇದಕ್ಕೆ ಸಾಮಾನ್ಯವಾಗಿ ಎಷ್ಟು ಸಮಯ ಬೇಕು?';

  @override
  String get gigErrorDurationShort =>
      'ನಾವು ಪಟ್ಟಿ ಮಾಡಬಹುದಾದ ಅತಿ ಚಿಕ್ಕ ಕೆಲಸ 15 ನಿಮಿಷ';

  @override
  String get gigErrorDurationLong =>
      'ನಾವು ಪಟ್ಟಿ ಮಾಡಬಹುದಾದ ಅತಿ ದೀರ್ಘ ಕೆಲಸ 14 ದಿನ';

  @override
  String get gigErrorRadius => 'ಪ್ರಯಾಣದ ದೂರ 1 ರಿಂದ 100 ಕಿಮೀ ನಡುವೆ ಇರಬೇಕು';

  @override
  String get jobAreaNearby => 'ಹತ್ತಿರದಲ್ಲಿ';

  @override
  String get jobBlockerVerifyArrival => 'ಗ್ರಾಹಕರ ಕೋಡ್‌ನಿಂದ ಆಗಮನ ಪರಿಶೀಲಿಸಿ';

  @override
  String get jobBlockerAfterPhoto => 'ಮುಗಿದ ಕೆಲಸದ ಫೋಟೋ ಸೇರಿಸಿ';

  @override
  String jobBlockerMaterialsPending(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ಸಾಮಗ್ರಿ ವಿನಂತಿಗಳು ಇನ್ನೂ ಗ್ರಾಹಕರಿಗಾಗಿ ಕಾಯುತ್ತಿವೆ',
      one: '1 ಸಾಮಗ್ರಿ ವಿನಂತಿ ಇನ್ನೂ ಗ್ರಾಹಕರಿಗಾಗಿ ಕಾಯುತ್ತಿದೆ',
    );
    return '$_temp0';
  }

  @override
  String mediaTypeNotAccepted(Object kinds) {
    return 'ಆ ರೀತಿಯ ಫೈಲ್ ಇಲ್ಲಿ ಸ್ವೀಕಾರಾರ್ಹವಲ್ಲ. $kinds ಬಳಸಿ.';
  }

  @override
  String get mediaEmpty => 'ಆ ಫೈಲ್ ಖಾಲಿಯಾಗಿದೆ.';

  @override
  String mediaTooLarge(Object megabytes) {
    return 'ಆ ಫೈಲ್ ತುಂಬಾ ದೊಡ್ಡದಾಗಿದೆ. ಮಿತಿ ${megabytes}MB.';
  }

  @override
  String get verificationNotStarted => 'ಪ್ರಾರಂಭವಾಗಿಲ್ಲ';

  @override
  String get verificationSubmitted => 'ಸಲ್ಲಿಸಲಾಗಿದೆ';

  @override
  String get verificationUnderReview => 'ಪರಿಶೀಲನೆಯಲ್ಲಿದೆ';

  @override
  String get verificationMoreInfo => 'ಹೆಚ್ಚಿನ ಮಾಹಿತಿ ಬೇಕು';

  @override
  String get verificationExpired => 'ಅವಧಿ ಮುಗಿದಿದೆ';

  @override
  String get verificationVerified => 'ಪರಿಶೀಲಿಸಲಾಗಿದೆ';

  @override
  String get verificationNotApproved => 'ಅನುಮೋದಿಸಲಾಗಿಲ್ಲ';

  @override
  String get verificationNotRequired => 'ಅಗತ್ಯವಿಲ್ಲ';

  @override
  String get qualificationErrorInstitution => 'ಇದನ್ನು ಯಾವ ಸಂಸ್ಥೆ ನೀಡಿದೆ?';

  @override
  String get qualificationErrorName => 'ಅರ್ಹತೆಯ ಹೆಸರು ಏನು?';

  @override
  String get qualificationErrorYearMissing =>
      'ನೀವು ಇದನ್ನು ಯಾವ ವರ್ಷ ಪೂರ್ಣಗೊಳಿಸಿದಿರಿ?';

  @override
  String qualificationErrorYearRange(Object year) {
    return '1950 ಮತ್ತು $year ನಡುವಿನ ವರ್ಷ ನಮೂದಿಸಿ';
  }

  @override
  String get walletTxJobEarning => 'ಕೆಲಸದ ಗಳಿಕೆ';

  @override
  String get walletTxMaterialReimbursed => 'ಸಾಮಗ್ರಿ ಮರುಪಾವತಿ';

  @override
  String get walletTxAdjustment => 'ಹೊಂದಾಣಿಕೆ';

  @override
  String get walletTxPayoutReturned => 'ಪೇಔಟ್ ಹಿಂತಿರುಗಿದೆ';

  @override
  String get walletTxPlatformFee => 'ಪ್ಲಾಟ್‌ಫಾರ್ಮ್ ಶುಲ್ಕ';

  @override
  String get walletTxWithdrawn => 'ಹಿಂಪಡೆಯಲಾಗಿದೆ';

  @override
  String get walletTxClaimRecovery => 'ಕ್ಲೈಮ್ ವಸೂಲಾತಿ';

  @override
  String get payoutStatusRequested => 'ವಿನಂತಿಸಲಾಗಿದೆ';

  @override
  String get payoutStatusProcessing => 'ಪ್ರಕ್ರಿಯೆಯಲ್ಲಿದೆ';

  @override
  String get payoutStatusPaid => 'ಪಾವತಿಸಲಾಗಿದೆ';

  @override
  String get payoutStatusFailed => 'ವಿಫಲವಾಗಿದೆ';

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
  String get accountDeletionBySupport =>
      'ಖಾತೆ ಅಳಿಸುವಿಕೆಯನ್ನು ನಮ್ಮ ಬೆಂಬಲ ತಂಡ ನಿರ್ವಹಿಸುತ್ತದೆ. ವಿನಂತಿ ಮಾಡಿ, ಮುಗಿದ ನಂತರ ನಾವು ದೃಢೀಕರಿಸುತ್ತೇವೆ.';

  @override
  String get photoUploadFailed => 'ಆ ಫೋಟೋ ಅಪ್‌ಲೋಡ್ ಮಾಡಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ.';

  @override
  String get photoUploadFailedRetry =>
      'ಆ ಫೋಟೋ ಅಪ್‌ಲೋಡ್ ಮಾಡಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ. ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get locationInvalid => 'ಆ ಸ್ಥಳ ಸರಿಯಾಗಿ ಕಾಣುತ್ತಿಲ್ಲ.';

  @override
  String get travelDistanceRange =>
      '1 ರಿಂದ 100 ಕಿಮೀ ನಡುವಿನ ಪ್ರಯಾಣ ದೂರ ಆಯ್ಕೆಮಾಡಿ.';

  @override
  String get profileLoadFailed => 'ನಿಮ್ಮ ಪ್ರೊಫೈಲ್ ಲೋಡ್ ಮಾಡಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ.';

  @override
  String get uploadIncomplete => 'ಅಪ್‌ಲೋಡ್ ಪೂರ್ಣಗೊಳ್ಳಲಿಲ್ಲ. ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get uploadTooLarge => 'ಆ ಫೈಲ್ ತುಂಬಾ ದೊಡ್ಡದಾಗಿದೆ.';

  @override
  String get uploadTypeNotAccepted => 'ಆ ರೀತಿಯ ಫೈಲ್ ಸ್ವೀಕಾರಾರ್ಹವಲ್ಲ.';

  @override
  String get uploadRefused => 'ಆ ಫೈಲ್ ತಿರಸ್ಕರಿಸಲಾಗಿದೆ.';

  @override
  String get uploadTooMany =>
      'ಒಂದೇ ಬಾರಿಗೆ ಹಲವು ಅಪ್‌ಲೋಡ್‌ಗಳು. ಸ್ವಲ್ಪ ಕಾಯಿರಿ ಮತ್ತು ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get uploadGone =>
      'ಆ ಅಪ್‌ಲೋಡ್ ಈಗ ಲಭ್ಯವಿಲ್ಲ. ಫೈಲ್ ಅನ್ನು ಮತ್ತೆ ಆಯ್ಕೆಮಾಡಿ.';

  @override
  String get uploadDidNotStart => 'ಅಪ್‌ಲೋಡ್ ಪ್ರಾರಂಭವಾಗಲಿಲ್ಲ.';

  @override
  String get uploadDidNotFinish => 'ಆ ಅಪ್‌ಲೋಡ್ ಮುಗಿಯಲಿಲ್ಲ.';

  @override
  String get claimResponseTooShort =>
      'ದಯವಿಟ್ಟು ಏನಾಯಿತು ಎಂದು ಸ್ವಲ್ಪ ಹೆಚ್ಚು ವಿವರವಾಗಿ ತಿಳಿಸಿ.';

  @override
  String get walletLoadFailedRetry =>
      'ನಿಮ್ಮ ವಾಲೆಟ್ ಲೋಡ್ ಮಾಡಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ. ದಯವಿಟ್ಟು ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get walletLoadFailed => 'ನಿಮ್ಮ ವಾಲೆಟ್ ಲೋಡ್ ಮಾಡಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ.';

  @override
  String get onboardingStepDetails => 'ನಿಮ್ಮ ವಿವರಗಳು';

  @override
  String get onboardingStepTrade => 'ನಿಮ್ಮ ಮುಖ್ಯ ಕೆಲಸ';

  @override
  String get onboardingStepSkills => 'ನೀವು ಏನು ಮಾಡಬಲ್ಲಿರಿ';

  @override
  String get onboardingStepArea => 'ನೀವು ಎಲ್ಲಿ ಕೆಲಸ ಮಾಡುತ್ತೀರಿ';

  @override
  String get onboardingStepKyc => 'ಗುರುತು ಪರಿಶೀಲನೆ';

  @override
  String get onboardingStepReady => 'ಕೆಲಸಕ್ಕೆ ಸಿದ್ಧ';

  @override
  String routerScreenNotFound(Object location) {
    return 'ಆ ಪರದೆ ತೆರೆಯಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ.\n$location';
  }

  @override
  String get cameraOpenFailed =>
      'ಕ್ಯಾಮೆರಾ ತೆರೆಯಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ. ಆ್ಯಪ್ ಅನುಮತಿಗಳನ್ನು ಪರಿಶೀಲಿಸಿ.';

  @override
  String get commonTryAgain => 'ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ';

  @override
  String get commonCancel => 'ರದ್ದುಮಾಡಿ';

  @override
  String get commonConfirm => 'ದೃಢೀಕರಿಸಿ';

  @override
  String get offlineBanner =>
      'ನೀವು ಆಫ್‌ಲೈನ್‌ನಲ್ಲಿದ್ದೀರಿ. ಮತ್ತೆ ಸಂಪರ್ಕಗೊಂಡಾಗ ಕೆಲಸದ ಕ್ರಿಯೆಗಳು ಮತ್ತೆ ಕೆಲಸ ಮಾಡುತ್ತವೆ.';

  @override
  String get badgeNew => 'ಹೊಸ';

  @override
  String get badgeAccepted => 'ಸ್ವೀಕರಿಸಲಾಗಿದೆ';

  @override
  String get badgeConfirmed => 'ದೃಢೀಕರಿಸಲಾಗಿದೆ';

  @override
  String get badgeOnTheWay => 'ದಾರಿಯಲ್ಲಿದ್ದಾರೆ';

  @override
  String get badgeArrived => 'ತಲುಪಿದ್ದಾರೆ';

  @override
  String get badgeWorking => 'ಕೆಲಸ ನಡೆಯುತ್ತಿದೆ';

  @override
  String get badgeAwaitingCustomer => 'ಗ್ರಾಹಕರಿಗಾಗಿ ಕಾಯುತ್ತಿದೆ';

  @override
  String get badgeDone => 'ಮುಗಿದಿದೆ';

  @override
  String get badgePaymentDue => 'ಪಾವತಿ ಬಾಕಿ';

  @override
  String get badgePaid => 'ಪಾವತಿಸಲಾಗಿದೆ';

  @override
  String get badgeClosed => 'ಮುಚ್ಚಲಾಗಿದೆ';

  @override
  String get badgeCancelled => 'ರದ್ದುಗೊಳಿಸಲಾಗಿದೆ';

  @override
  String get badgeDisputed => 'ವಿವಾದದಲ್ಲಿದೆ';

  @override
  String get badgeExpired => 'ಅವಧಿ ಮುಗಿದಿದೆ';

  @override
  String get badgeDraft => 'ಕರಡು';

  @override
  String get badgeInReview => 'ಪರಿಶೀಲನೆಯಲ್ಲಿ';

  @override
  String get badgeLive => 'ಲೈವ್';

  @override
  String get badgePaused => 'ವಿರಾಮದಲ್ಲಿ';

  @override
  String get badgeNotApproved => 'ಅನುಮೋದಿಸಲಾಗಿಲ್ಲ';

  @override
  String get badgeRemoved => 'ತೆಗೆದುಹಾಕಲಾಗಿದೆ';

  @override
  String get badgeNotStarted => 'ಪ್ರಾರಂಭವಾಗಿಲ್ಲ';

  @override
  String get badgeSubmitted => 'ಸಲ್ಲಿಸಲಾಗಿದೆ';

  @override
  String get badgeActionNeeded => 'ಕ್ರಮ ಅಗತ್ಯ';

  @override
  String get badgeVerified => 'ಪರಿಶೀಲಿಸಲಾಗಿದೆ';

  @override
  String get badgeNotRequired => 'ಅಗತ್ಯವಿಲ್ಲ';

  @override
  String get commonContinue => 'ಮುಂದುವರಿಸಿ';

  @override
  String get commonSaving => 'ಉಳಿಸಲಾಗುತ್ತಿದೆ…';

  @override
  String get welcomePromiseWorkTitle => 'ಸೂಕ್ತ ಕೆಲಸ ಪಡೆಯಿರಿ';

  @override
  String get welcomePromiseWorkBody =>
      'ನಿಮ್ಮ ಹತ್ತಿರದ ಕೆಲಸಗಳು, ನೀವು ನಿಜವಾಗಿ ಮಾಡುವ ಕೆಲಸಗಳಿಗೆ ಹೊಂದಿಕೆಯಾಗುವಂತೆ.';

  @override
  String get welcomePromiseSkillsTitle => 'ನಿಮ್ಮ ಕೌಶಲ್ಯ ಸಾಬೀತುಪಡಿಸಿ';

  @override
  String get welcomePromiseSkillsBody =>
      'ನಿಮ್ಮ ITI ಮತ್ತು ಡಿಪ್ಲೊಮಾ ಪ್ರಮಾಣಪತ್ರಗಳು, ಒಮ್ಮೆ ಪರಿಶೀಲಿಸಿ ಪ್ರತಿ ಗ್ರಾಹಕರಿಗೂ ತೋರಿಸಲಾಗುತ್ತದೆ.';

  @override
  String get welcomePromiseTrackTitle => 'ಪ್ರತಿ ಕೆಲಸವನ್ನು ಟ್ರ್ಯಾಕ್ ಮಾಡಿ';

  @override
  String get welcomePromiseTrackBody =>
      'ಕೆಲಸ ಸ್ವೀಕರಿಸುವುದರಿಂದ ಮುಗಿಸುವವರೆಗೆ, ಪ್ರತಿ ಹಂತದಲ್ಲೂ ಫೋಟೋ ದಾಖಲೆಗಳೊಂದಿಗೆ.';

  @override
  String get welcomePromisePaidTitle => 'ಸುರಕ್ಷಿತವಾಗಿ ಹಣ ಪಡೆಯಿರಿ';

  @override
  String get welcomePromisePaidBody =>
      'ಪ್ರತಿ ರೂಪಾಯಿ ದಾಖಲು, ಸ್ಪಷ್ಟ ಸ್ಟೇಟ್‌ಮೆಂಟ್‌ನೊಂದಿಗೆ ಮತ್ತು ನಿಮ್ಮ ಷರತ್ತಿನ ಮೇಲೆ ಹಣ ಹಿಂಪಡೆಯುವಿಕೆ.';

  @override
  String get welcomeHeadline => 'ನಿಮ್ಮನ್ನು ಹುಡುಕಿ ಬರುವ ಕೆಲಸ';

  @override
  String get welcomeSubtitle =>
      'Wervexa ಕುಶಲ ವೃತ್ತಿಪರರನ್ನು ಅವರ ಅಗತ್ಯವಿರುವ ಗ್ರಾಹಕರೊಂದಿಗೆ ಜೋಡಿಸುತ್ತದೆ.';

  @override
  String get welcomeGetStarted => 'ಪ್ರಾರಂಭಿಸಿ';

  @override
  String get welcomeCodeNotice =>
      'ನಿಮ್ಮ ಮೊಬೈಲ್ ಸಂಖ್ಯೆಗೆ ಒಂದು ಬಾರಿಯ ಕೋಡ್ ಕಳುಹಿಸುತ್ತೇವೆ.';

  @override
  String get phoneTitle => 'ನಿಮ್ಮ ಮೊಬೈಲ್ ಸಂಖ್ಯೆ ಏನು?';

  @override
  String get phoneSubtitle =>
      'ಇದು ನೀವೇ ಎಂದು ದೃಢೀಕರಿಸಲು ಒಂದು ಬಾರಿಯ ಕೋಡ್ ಕಳುಹಿಸುತ್ತೇವೆ.';

  @override
  String get phoneSendCode => 'ಕೋಡ್ ಕಳುಹಿಸಿ';

  @override
  String get phoneSending => 'ಕಳುಹಿಸಲಾಗುತ್ತಿದೆ…';

  @override
  String get authNewCodeSent => 'ನಾವು ಹೊಸ ಕೋಡ್ ಕಳುಹಿಸಿದ್ದೇವೆ.';

  @override
  String get otpTitle => 'ಕೋಡ್ ನಮೂದಿಸಿ';

  @override
  String otpSentTo(Object phone) {
    return 'ನಾವು $phone ಗೆ 6 ಅಂಕಿಯ ಕೋಡ್ ಕಳುಹಿಸಿದ್ದೇವೆ.';
  }

  @override
  String otpResendIn(int seconds) {
    String _temp0 = intl.Intl.pluralLogic(
      seconds,
      locale: localeName,
      other: '$seconds ಸೆಕೆಂಡುಗಳಲ್ಲಿ ಹೊಸ ಕೋಡ್ ಕೇಳಬಹುದು',
      one: '1 ಸೆಕೆಂಡಿನಲ್ಲಿ ಹೊಸ ಕೋಡ್ ಕೇಳಬಹುದು',
    );
    return '$_temp0';
  }

  @override
  String get otpSendNew => 'ಹೊಸ ಕೋಡ್ ಕಳುಹಿಸಿ';

  @override
  String get otpVerify => 'ಪರಿಶೀಲಿಸಿ';

  @override
  String get otpVerifying => 'ಪರಿಶೀಲಿಸಲಾಗುತ್ತಿದೆ…';

  @override
  String get registerNameRequired => 'ದಯವಿಟ್ಟು ನಿಮ್ಮ ಪೂರ್ಣ ಹೆಸರು ನಮೂದಿಸಿ';

  @override
  String get registerEmailInvalid => 'ದಯವಿಟ್ಟು ಮಾನ್ಯ ಇಮೇಲ್ ವಿಳಾಸ ನಮೂದಿಸಿ';

  @override
  String get registerTitle => 'ನಿಮ್ಮನ್ನು ಏನೆಂದು ಕರೆಯಬೇಕು?';

  @override
  String get registerSubtitle => 'ಗ್ರಾಹಕರು ಇದೇ ಹೆಸರನ್ನು ನೋಡುತ್ತಾರೆ.';

  @override
  String get registerNameLabel => 'ಪೂರ್ಣ ಹೆಸರು';

  @override
  String get registerNameHint => 'ಅರುಣ್ ಕುಮಾರ್';

  @override
  String get registerEmailLabel => 'ಇಮೇಲ್ (ಐಚ್ಛಿಕ)';

  @override
  String get registerEmailHelper => 'ರಸೀದಿಗಳು ಮತ್ತು ಸ್ಟೇಟ್‌ಮೆಂಟ್‌ಗಳಿಗಾಗಿ.';

  @override
  String registerVerifiedPhone(Object phone) {
    return 'ಪರಿಶೀಲಿಸಲಾಗಿದೆ: $phone';
  }

  @override
  String get navHome => 'ಮುಖಪುಟ';

  @override
  String get navJobs => 'ಕೆಲಸಗಳು';

  @override
  String get navWallet => 'ವಾಲೆಟ್';

  @override
  String get navProfile => 'ಪ್ರೊಫೈಲ್';

  @override
  String get sessionProfileLoadFailedRetry =>
      'ನಿಮ್ಮ ಪ್ರೊಫೈಲ್ ಲೋಡ್ ಮಾಡಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ. ದಯವಿಟ್ಟು ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get commonSignOut => 'ಸೈನ್ ಔಟ್ ಮಾಡಿ';

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
  String get commonSeeAll => 'ಎಲ್ಲವನ್ನೂ ನೋಡಿ';

  @override
  String distanceKm(Object km) {
    return '$km ಕಿಮೀ';
  }

  @override
  String get homeRightNow => 'ಈಗ';

  @override
  String get homeNewWork => 'ಹೊಸ ಕೆಲಸ';

  @override
  String homeJobsWaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ಕೆಲಸಗಳು ನಿಮ್ಮ ಉತ್ತರಕ್ಕಾಗಿ ಕಾಯುತ್ತಿವೆ',
      one: '1 ಕೆಲಸ ನಿಮ್ಮ ಉತ್ತರಕ್ಕಾಗಿ ಕಾಯುತ್ತಿದೆ',
    );
    return '$_temp0';
  }

  @override
  String get homeComingUp => 'ಮುಂಬರುವ';

  @override
  String get homeEarnings => 'ಗಳಿಕೆ';

  @override
  String get homeMyServices => 'ನನ್ನ ಸೇವೆಗಳು';

  @override
  String get homeVerification => 'ಪರಿಶೀಲನೆ';

  @override
  String get homeSupport => 'ಬೆಂಬಲ';

  @override
  String get homeRequests => 'ವಿನಂತಿಗಳು';

  @override
  String get homeMyOffers => 'ನನ್ನ ಆಫರ್‌ಗಳು';

  @override
  String get homeAddService => 'ಸೇವೆ ಸೇರಿಸಿ';

  @override
  String get homeAddServiceBody =>
      'ನೀವು ಪ್ರಕಟಿಸಿದ ಸೇವೆಗಳಿಗೆ ಮಾತ್ರ ಗ್ರಾಹಕರು ನಿಮ್ಮನ್ನು ಬುಕ್ ಮಾಡಬಹುದು.';

  @override
  String get homeNotReady => 'ಇನ್ನೂ ಪೂರ್ಣ ಸಿದ್ಧವಾಗಿಲ್ಲ';

  @override
  String get homeNotReadyBody =>
      'ಈ ಹಂತಗಳನ್ನು ಪೂರ್ಣಗೊಳಿಸಿ, ನಿಮಗೆ ಕೆಲಸ ಸಿಗಲು ಪ್ರಾರಂಭವಾಗುತ್ತದೆ.';

  @override
  String get homeGoodMorning => 'ಶುಭೋದಯ';

  @override
  String get homeGoodAfternoon => 'ಶುಭ ಮಧ್ಯಾಹ್ನ';

  @override
  String get homeGoodEvening => 'ಶುಭ ಸಂಜೆ';

  @override
  String get homeNotifications => 'ಅಧಿಸೂಚನೆಗಳು';

  @override
  String get availabilityAvailable => 'ಲಭ್ಯ';

  @override
  String get availabilityAvailableBody => 'ನೀವು ಹೊಸ ಕೆಲಸಗಳನ್ನು ಪಡೆಯಬಹುದು.';

  @override
  String get availabilityOnJob => 'ಕೆಲಸದಲ್ಲಿದ್ದಾರೆ';

  @override
  String get availabilityOnJobBody =>
      'ಈ ಕೆಲಸ ಮುಗಿಯುವವರೆಗೆ ನಿಮಗೆ ಹೊಸ ಕೆಲಸ ನೀಡಲಾಗುವುದಿಲ್ಲ.';

  @override
  String get availabilityOff => 'ಆಫ್';

  @override
  String get availabilityOffBody => 'ನಿಮಗೆ ಹೊಸ ಕೆಲಸಗಳು ಬರುವುದಿಲ್ಲ.';

  @override
  String get availabilityFinishJob => 'ಮತ್ತೆ ಲಭ್ಯರಾಗಲು ಪ್ರಸ್ತುತ ಕೆಲಸ ಮುಗಿಸಿ.';

  @override
  String get availabilityGoOff => 'ಡ್ಯೂಟಿ ಆಫ್ ಮಾಡಿ';

  @override
  String get availabilityGoOn => 'ಲಭ್ಯರಾಗಿ';

  @override
  String get availabilityBeforeJobs => 'ಕೆಲಸ ಪಡೆಯುವ ಮೊದಲು';

  @override
  String get availabilityNowOn => 'ನೀವು ಕೆಲಸಕ್ಕೆ ಲಭ್ಯರಿದ್ದೀರಿ.';

  @override
  String get availabilityNowOff => 'ನೀವು ಡ್ಯೂಟಿಯಲ್ಲಿಲ್ಲ.';

  @override
  String get workerStatusSetupIncomplete => 'ಸೆಟಪ್ ಅಪೂರ್ಣ';

  @override
  String get workerStatusUnderReview => 'ಪರಿಶೀಲನೆಯಲ್ಲಿ';

  @override
  String get workerStatusInactive => 'ನಿಷ್ಕ್ರಿಯ';

  @override
  String get workerStatusRestricted => 'ನಿರ್ಬಂಧಿತ';

  @override
  String get workerStatusSuspended => 'ಅಮಾನತು';

  @override
  String get homeAccount => 'ಖಾತೆ';

  @override
  String get homeWorkStatus => 'ಕೆಲಸದ ಸ್ಥಿತಿ';

  @override
  String get availabilityOffDuty => 'ಡ್ಯೂಟಿಯಲ್ಲಿಲ್ಲ';

  @override
  String get earningsThisWeek => 'ಈ ವಾರ';

  @override
  String get earningsThisMonth => 'ಈ ತಿಂಗಳು';

  @override
  String get jobNextWaitConfirm => 'ಗ್ರಾಹಕರ ದೃಢೀಕರಣಕ್ಕಾಗಿ ಕಾಯುತ್ತಿದೆ';

  @override
  String get jobNextStartTravel => 'ಪ್ರಯಾಣ ಪ್ರಾರಂಭಿಸಿ';

  @override
  String get jobNextMarkArrived => 'ತಲುಪಿದ್ದೀರಿ ಎಂದು ಗುರುತಿಸಿ';

  @override
  String get jobNextStartWork => 'ಕೆಲಸ ಪ್ರಾರಂಭಿಸಿ';

  @override
  String get jobNextAskCode => 'ಗ್ರಾಹಕರಿಂದ ಆಗಮನ ಕೋಡ್ ಕೇಳಿ';

  @override
  String get jobNextFinish => 'ಮುಗಿಸಿ ಫೋಟೋ ಸೇರಿಸಿ';

  @override
  String get jobNextWaitApprove => 'ಗ್ರಾಹಕರ ಅನುಮೋದನೆಗಾಗಿ ಕಾಯುತ್ತಿದೆ';

  @override
  String get jobNextOpen => 'ಕೆಲಸ ತೆರೆಯಿರಿ';

  @override
  String get jobTimeTbc => 'ಸಮಯ ದೃಢೀಕರಿಸಬೇಕಿದೆ';

  @override
  String get settingsTitle => 'ಸೆಟ್ಟಿಂಗ್‌ಗಳು';

  @override
  String get settingsLanguage => 'ಭಾಷೆ';

  @override
  String get settingsAbout => 'ಬಗ್ಗೆ';

  @override
  String get settingsTerms => 'ಸೇವಾ ನಿಯಮಗಳು';

  @override
  String get settingsPrivacy => 'ಗೌಪ್ಯತಾ ನೀತಿ';

  @override
  String get settingsHelp => 'ಸಹಾಯ ಮತ್ತು ಬೆಂಬಲ';

  @override
  String get settingsDeleteAccount => 'ನನ್ನ ಖಾತೆ ಅಳಿಸಿ';

  @override
  String get settingsSignOutTitle => 'ಸೈನ್ ಔಟ್ ಮಾಡಬೇಕೇ?';

  @override
  String get settingsSignOutBody =>
      'ಮತ್ತೆ ಸೈನ್ ಇನ್ ಮಾಡಲು ನಿಮ್ಮ ಫೋನ್ ಸಂಖ್ಯೆ ಮತ್ತು ಕೋಡ್ ಬೇಕು.';

  @override
  String get settingsDeleteTitle => 'ನಿಮ್ಮ ಖಾತೆ ಅಳಿಸಿ';

  @override
  String get settingsDeleteBody =>
      'ಖಾತೆ ಅಳಿಸುವುದರಿಂದ ನಿಮ್ಮ ಕೆಲಸದ ಇತಿಹಾಸ, ಗಳಿಕೆಯ ದಾಖಲೆಗಳು ಮತ್ತು ತೆರೆದ ಪಾವತಿಗಳ ಮೇಲೆ ಪರಿಣಾಮ ಬೀರುತ್ತದೆ, ಆದ್ದರಿಂದ ಇದನ್ನು ಸ್ವಯಂಚಾಲಿತವಾಗಿ ಅಲ್ಲ, ನಮ್ಮ ಬೆಂಬಲ ತಂಡ ನಿರ್ವಹಿಸುತ್ತದೆ.\n\nಬೆಂಬಲ ವಿನಂತಿ ಮಾಡಿ, ಮುಗಿದ ನಂತರ ನಾವು ದೃಢೀಕರಿಸುತ್ತೇವೆ.';

  @override
  String get settingsContactSupport => 'ಬೆಂಬಲವನ್ನು ಸಂಪರ್ಕಿಸಿ';

  @override
  String get notificationsMarkAllRead => 'ಎಲ್ಲವನ್ನೂ ಓದಿದೆ ಎಂದು ಗುರುತಿಸಿ';

  @override
  String get notificationsEmpty => 'ನೀವು ಎಲ್ಲವನ್ನೂ ನೋಡಿದ್ದೀರಿ';

  @override
  String get notificationsEmptyBody =>
      'ಕೆಲಸದ ಆಫರ್‌ಗಳು, ಪಾವತಿ ಅಪ್‌ಡೇಟ್‌ಗಳು ಮತ್ತು ಪರಿಶೀಲನಾ ಫಲಿತಾಂಶಗಳು ಇಲ್ಲಿ ಕಾಣಿಸುತ್ತವೆ.';

  @override
  String get jobsTabUpcoming => 'ಮುಂಬರುವ';

  @override
  String get jobsTabActive => 'ಸಕ್ರಿಯ';

  @override
  String get jobsNoOffers => 'ಈಗ ಹೊಸ ಕೆಲಸಗಳಿಲ್ಲ';

  @override
  String get jobsNoOffersBody =>
      'ನೀವು ಲಭ್ಯವಿರುವಾಗ, ಸೂಕ್ತ ಕೆಲಸ ಬಂದ ತಕ್ಷಣ ನಿಮಗೆ ತಿಳಿಸುತ್ತೇವೆ.';

  @override
  String get jobsAccepted => 'ಕೆಲಸ ಸ್ವೀಕರಿಸಲಾಗಿದೆ.';

  @override
  String get jobsDeclineTitle => 'ಈ ಕೆಲಸ ನಿರಾಕರಿಸಬೇಕೇ?';

  @override
  String get jobsDeclineBody =>
      'ಇದನ್ನು ಬೇರೆ ಕಾರ್ಮಿಕರಿಗೆ ನೀಡಲಾಗುತ್ತದೆ. ಆಗಾಗ್ಗೆ ನಿರಾಕರಿಸಿದರೆ ನಿಮಗೆ ತೋರಿಸುವ ಕೆಲಸಗಳು ಕಡಿಮೆಯಾಗಬಹುದು.';

  @override
  String get jobsDecline => 'ನಿರಾಕರಿಸಿ';

  @override
  String get jobsDeclined => 'ಕೆಲಸ ನಿರಾಕರಿಸಲಾಗಿದೆ.';

  @override
  String get jobsEmptyUpcoming => 'ಏನೂ ನಿಗದಿಯಾಗಿಲ್ಲ';

  @override
  String get jobsEmptyUpcomingBody =>
      'ನೀವು ಸ್ವೀಕರಿಸಿದ ಕೆಲಸಗಳು ಇಲ್ಲಿ ಕಾಣಿಸುತ್ತವೆ.';

  @override
  String get jobsEmptyActive => 'ಯಾವುದೇ ಕೆಲಸ ನಡೆಯುತ್ತಿಲ್ಲ';

  @override
  String get jobsEmptyActiveBody =>
      'ನೀವು ಕೆಲಸ ಪ್ರಾರಂಭಿಸಿದಾಗ ಅದು ಇಲ್ಲಿ ಕಾಣಿಸುತ್ತದೆ.';

  @override
  String get jobsEmptyCompleted => 'ಇನ್ನೂ ಪೂರ್ಣಗೊಂಡ ಕೆಲಸಗಳಿಲ್ಲ';

  @override
  String get jobsEmptyCompletedBody =>
      'ಮುಗಿದ ಕೆಲಸಗಳು ಮತ್ತು ಅವುಗಳಿಂದ ನಿಮ್ಮ ಗಳಿಕೆ ಇಲ್ಲಿ ಪಟ್ಟಿಯಾಗುತ್ತದೆ.';

  @override
  String get jobsEmptyCancelled => 'ಏನೂ ರದ್ದಾಗಿಲ್ಲ';

  @override
  String get jobsEmptyCancelledBody => 'ರದ್ದಾದ ಕೆಲಸಗಳು ಇಲ್ಲಿ ಪಟ್ಟಿಯಾಗುತ್ತವೆ.';

  @override
  String get jobsEmptyOffers => 'ಆಫರ್‌ಗಳಿಲ್ಲ';

  @override
  String get jobsEmptyOffersBody => 'ಹೊಸ ಕೆಲಸಗಳು ಇಲ್ಲಿ ಕಾಣಿಸುತ್ತವೆ.';

  @override
  String get jobTitleFallback => 'ಕೆಲಸ';

  @override
  String jobCancelledReason(Object reason) {
    return 'ರದ್ದಾಗಿದೆ: $reason';
  }

  @override
  String get jobAmount => 'ಕೆಲಸದ ಮೊತ್ತ';

  @override
  String get jobMaterials => 'ಸಾಮಗ್ರಿಗಳು';

  @override
  String get jobYouEarned => 'ನಿಮ್ಮ ಗಳಿಕೆ';

  @override
  String get jobRateCustomer => 'ಗ್ರಾಹಕರಿಗೆ ರೇಟಿಂಗ್ ನೀಡಿ';

  @override
  String get jobRateQuestion => 'ಈ ಕೆಲಸ ನಿಮಗೆ ಹೇಗಿತ್ತು?';

  @override
  String get jobRate => 'ರೇಟ್ ಮಾಡಿ';

  @override
  String get jobHistory => 'ಏನೇನಾಯಿತು';

  @override
  String get jobHistoryLoadFailed => 'ಕೆಲಸದ ಇತಿಹಾಸ ಲೋಡ್ ಮಾಡಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ.';

  @override
  String get jobOfferExpired => 'ಈ ಕೆಲಸ ಈಗ ಲಭ್ಯವಿಲ್ಲ.';

  @override
  String get jobOfferNewBadge => 'ಹೊಸ ಕೆಲಸ';

  @override
  String get jobOfferYouEarn => 'ನಿಮ್ಮ ಗಳಿಕೆ';

  @override
  String get jobOfferPriceAfterVisit => 'ಭೇಟಿಯ ನಂತರ ದೃಢೀಕರಿಸಲಾಗುತ್ತದೆ';

  @override
  String get jobOfferAccept => 'ಕೆಲಸ ಸ್ವೀಕರಿಸಿ';

  @override
  String get activeJobTitle => 'ಪ್ರಸ್ತುತ ಕೆಲಸ';

  @override
  String get activeJobEmptyBody =>
      'ನೀವು ಕೆಲಸ ಸ್ವೀಕರಿಸಿ ಪ್ರಾರಂಭಿಸಿದಾಗ ಅದು ಇಲ್ಲಿ ಕಾಣಿಸುತ್ತದೆ.';

  @override
  String get evidenceBeforeTitle => 'ಪ್ರಾರಂಭಿಸುವ ಮೊದಲು';

  @override
  String get evidenceBeforeBody =>
      'ಮುಟ್ಟುವ ಮೊದಲೇ ಸಮಸ್ಯೆಯ ಫೋಟೋ ತೆಗೆಯಿರಿ. ಗ್ರಾಹಕರು ನಂತರ ಕೆಲಸದ ಬಗ್ಗೆ ವಿವಾದ ಮಾಡಿದರೆ ಇದು ನಿಮ್ಮನ್ನು ರಕ್ಷಿಸುತ್ತದೆ.';

  @override
  String get evidenceAfterTitle => 'ಮುಗಿಸಿದ ನಂತರ';

  @override
  String get evidenceAfterBody =>
      'ಗ್ರಾಹಕರು ನಂತರ ವಿವಾದ ಮಾಡಿದರೆ ಮುಗಿದ ಕೆಲಸದ ಫೋಟೋವೇ ನಿಮ್ಮ ಸಾಕ್ಷಿ. ಐಚ್ಛಿಕ, ಆದರೆ ಹತ್ತು ಸೆಕೆಂಡು ಕೊಡುವುದು ಯೋಗ್ಯ.';

  @override
  String get jobCustomerHidden =>
      'ದೃಢೀಕರಣದ ನಂತರ ಗ್ರಾಹಕರ ವಿವರಗಳನ್ನು ಹಂಚಲಾಗುತ್ತದೆ';

  @override
  String get jobCall => 'ಕರೆ ಮಾಡಿ';

  @override
  String get jobDirections => 'ದಿಕ್ಕುಗಳು';

  @override
  String get jobTrackOnMap => 'ನಕ್ಷೆಯಲ್ಲಿ ಟ್ರ್ಯಾಕ್ ಮಾಡಿ';

  @override
  String get trailAccepted => 'ಸ್ವೀಕರಿಸಲಾಗಿದೆ';

  @override
  String get trailOnTheWay => 'ದಾರಿಯಲ್ಲಿದ್ದಾರೆ';

  @override
  String get trailArrived => 'ತಲುಪಿದ್ದಾರೆ';

  @override
  String get trailArrivalConfirmed => 'ಆಗಮನ ದೃಢೀಕರಿಸಲಾಗಿದೆ';

  @override
  String get trailWorkStarted => 'ಕೆಲಸ ಪ್ರಾರಂಭವಾಗಿದೆ';

  @override
  String get trailFinished => 'ಮುಗಿದಿದೆ';

  @override
  String get jobProgress => 'ಪ್ರಗತಿ';

  @override
  String get jobBeforeFinish => 'ಮುಗಿಸುವ ಮೊದಲು';

  @override
  String get jobActionStartTravel => 'ಪ್ರಯಾಣ ಪ್ರಾರಂಭಿಸಿ';

  @override
  String get jobActionArrived => 'ನಾನು ತಲುಪಿದ್ದೇನೆ';

  @override
  String get jobActionEnterCode => 'ಆಗಮನ ಕೋಡ್ ನಮೂದಿಸಿ';

  @override
  String get jobActionStartWork => 'ಕೆಲಸ ಪ್ರಾರಂಭಿಸಿ';

  @override
  String get jobActionFinish => 'ಕೆಲಸ ಮುಗಿಸಿ';

  @override
  String get jobArrivalConfirmed => 'ಆಗಮನ ದೃಢೀಕರಿಸಲಾಗಿದೆ.';

  @override
  String get jobFinishTitle => 'ಈ ಕೆಲಸ ಮುಗಿಸಬೇಕೇ?';

  @override
  String get jobFinishBody =>
      'ಕೆಲಸವನ್ನು ಅನುಮೋದಿಸಲು ಗ್ರಾಹಕರನ್ನು ಕೇಳಲಾಗುತ್ತದೆ. ನಂತರ ನೀವು ಫೋಟೋ ಸೇರಿಸಲು ಸಾಧ್ಯವಿಲ್ಲ.';

  @override
  String get jobOnYourWay => 'ನೀವು ದಾರಿಯಲ್ಲಿದ್ದೀರಿ.';

  @override
  String get jobMarkedArrived => 'ತಲುಪಿದ್ದೀರಿ ಎಂದು ಗುರುತಿಸಲಾಗಿದೆ.';

  @override
  String get jobWorkStarted => 'ಕೆಲಸ ಪ್ರಾರಂಭವಾಗಿದೆ.';

  @override
  String get jobSentForApproval => 'ಅನುಮೋದನೆಗಾಗಿ ಗ್ರಾಹಕರಿಗೆ ಕಳುಹಿಸಲಾಗಿದೆ.';

  @override
  String get jobUpdated => 'ಅಪ್‌ಡೇಟ್ ಆಗಿದೆ.';

  @override
  String get jobWaitConfirm => 'ಗ್ರಾಹಕರು ಬುಕಿಂಗ್ ದೃಢೀಕರಿಸಲು ಕಾಯುತ್ತಿದೆ.';

  @override
  String get jobWaitApprove => 'ಗ್ರಾಹಕರು ನಿಮ್ಮ ಕೆಲಸ ಅನುಮೋದಿಸಲು ಕಾಯುತ್ತಿದೆ.';

  @override
  String get jobWaitPaymentProcessing =>
      'ಅನುಮೋದಿಸಲಾಗಿದೆ. ಪಾವತಿ ಪ್ರಕ್ರಿಯೆಯಲ್ಲಿದೆ.';

  @override
  String get jobWaitPayment => 'ಗ್ರಾಹಕರ ಪಾವತಿಗಾಗಿ ಕಾಯುತ್ತಿದೆ.';

  @override
  String get jobWaitPaid =>
      'ಪಾವತಿಸಲಾಗಿದೆ. ನಿಮ್ಮ ಗಳಿಕೆ ನಿಮ್ಮ ವಾಲೆಟ್‌ನಲ್ಲಿ ಕಾಣಿಸುತ್ತದೆ.';

  @override
  String get jobWaitDisputed =>
      'ನಮ್ಮ ತಂಡ ಈ ಕೆಲಸವನ್ನು ಪರಿಶೀಲಿಸುತ್ತಿದೆ. ನಾವು ಸಂಪರ್ಕಿಸುತ್ತೇವೆ.';

  @override
  String get jobWaitNothing => 'ಈಗ ಮಾಡಲು ಏನೂ ಇಲ್ಲ.';

  @override
  String get travelRouteUnavailable => 'ಮಾರ್ಗ ಲಭ್ಯವಿಲ್ಲ';

  @override
  String get travelNoDestination => 'ಗಮ್ಯಸ್ಥಾನ ಹೊಂದಿಸಿಲ್ಲ';

  @override
  String get travelNoDestinationBody =>
      'ಈ ಕೆಲಸಕ್ಕೆ ಮಾರ್ಗ ತೋರಿಸಲು ಸೇವಾ ಸ್ಥಳವಿಲ್ಲ.';

  @override
  String get travelJobLocation => 'ಕೆಲಸದ ಸ್ಥಳ';

  @override
  String get travelYou => 'ನೀವು';

  @override
  String get travelCustomer => 'ಗ್ರಾಹಕ';

  @override
  String get travelCalculating => 'ಮಾರ್ಗ ಲೆಕ್ಕಹಾಕುತ್ತಿದೆ...';

  @override
  String distanceMetres(Object metres) {
    return '$metres ಮೀ';
  }

  @override
  String etaMinutes(Object minutes) {
    return '$minutes ನಿಮಿಷ';
  }

  @override
  String etaHours(Object hours) {
    return '$hours ಗಂಟೆ';
  }

  @override
  String get arrivalWrongCode => 'ಆ ಕೋಡ್ ಸರಿಯಾಗಿಲ್ಲ.';

  @override
  String arrivalWrongCodeAttempts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ಆ ಕೋಡ್ ಸರಿಯಾಗಿಲ್ಲ. $count ಪ್ರಯತ್ನಗಳು ಉಳಿದಿವೆ.',
      one: 'ಆ ಕೋಡ್ ಸರಿಯಾಗಿಲ್ಲ. 1 ಪ್ರಯತ್ನ ಉಳಿದಿದೆ.',
    );
    return '$_temp0';
  }

  @override
  String get arrivalTitle => 'ನೀವು ತಲುಪಿದ್ದೀರಿ ಎಂದು ದೃಢೀಕರಿಸಿ';

  @override
  String get arrivalBody =>
      'ಗ್ರಾಹಕರಿಗೆ ಅವರ ಆ್ಯಪ್‌ನ ಕೋಡ್ ಓದಿ ಹೇಳಲು ಕೇಳಿ, ನಂತರ ಇಲ್ಲಿ ಟೈಪ್ ಮಾಡಿ.';

  @override
  String get arrivalLocked =>
      'ಹಲವು ತಪ್ಪು ಕೋಡ್‌ಗಳು. ಈ ಕೆಲಸ ಮುಂದುವರಿಸಲು ದಯವಿಟ್ಟು ಬೆಂಬಲವನ್ನು ಸಂಪರ್ಕಿಸಿ.';

  @override
  String get arrivalConfirm => 'ಆಗಮನ ದೃಢೀಕರಿಸಿ';

  @override
  String get arrivalNotYet => 'ಇನ್ನೂ ಇಲ್ಲ';

  @override
  String get rateThanks => 'ನಿಮ್ಮ ಪ್ರತಿಕ್ರಿಯೆಗೆ ಧನ್ಯವಾದಗಳು.';

  @override
  String get rateTitle => 'ಈ ಗ್ರಾಹಕರು ಹೇಗಿದ್ದರು?';

  @override
  String get rateBody =>
      'ನಿಮ್ಮ ರೇಟಿಂಗ್ ಖಾಸಗಿಯಾಗಿರುತ್ತದೆ ಮತ್ತು ಕಾರ್ಮಿಕರ ಕಾಳಜಿ ವಹಿಸಲು ನಮಗೆ ಸಹಾಯ ಮಾಡುತ್ತದೆ.';

  @override
  String get rateCommentLabel => 'ಬೇರೆ ಏನಾದರೂ ಹೇಳಬೇಕೇ? (ಐಚ್ಛಿಕ)';

  @override
  String get rateSubmit => 'ರೇಟಿಂಗ್ ಸಲ್ಲಿಸಿ';

  @override
  String get timerServiceTime => 'ಸೇವಾ ಸಮಯ';

  @override
  String get materialsAdd => 'ಸೇರಿಸಿ';

  @override
  String get materialsLoadFailed => 'ಸಾಮಗ್ರಿಗಳನ್ನು ಲೋಡ್ ಮಾಡಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ.';

  @override
  String get materialsEmpty =>
      'ಈ ಕೆಲಸಕ್ಕೆ ಬಿಡಿಭಾಗಗಳು ಬೇಕಾದರೆ ಇಲ್ಲಿ ಸೇರಿಸಿ, ವೆಚ್ಚ ಅನುಮೋದಿಸಲು ಗ್ರಾಹಕರನ್ನು ಕೇಳಲಾಗುತ್ತದೆ.';

  @override
  String get materialStatusWaiting => 'ಗ್ರಾಹಕರಿಗಾಗಿ ಕಾಯುತ್ತಿದೆ';

  @override
  String get materialStatusApproved => 'ಅನುಮೋದಿತ';

  @override
  String get materialStatusDeclined => 'ನಿರಾಕರಿಸಲಾಗಿದೆ';

  @override
  String get materialStatusBought => 'ಖರೀದಿಸಲಾಗಿದೆ';

  @override
  String get materialStatusCostRecorded => 'ವೆಚ್ಚ ದಾಖಲು';

  @override
  String get materialStatusBilled => 'ಬಿಲ್‌ನಲ್ಲಿದೆ';

  @override
  String get materialStatusCancelled => 'ರದ್ದಾಗಿದೆ';

  @override
  String materialQuantityEstimated(Object quantity, Object unit) {
    return '$quantity $unit · ಅಂದಾಜು';
  }

  @override
  String materialQuantityActual(Object quantity, Object unit) {
    return '$quantity $unit · ನಿಜವಾದ';
  }

  @override
  String get materialRecordCost => 'ವೆಚ್ಚ ದಾಖಲಿಸಿ';

  @override
  String materialCustomerSaid(Object reason) {
    return 'ಗ್ರಾಹಕರು ಹೇಳಿದ್ದು: $reason';
  }

  @override
  String get materialUnitPiece => 'ತುಂಡು';

  @override
  String get materialWhatNeeded => 'ನಿಮಗೆ ಏನು ಬೇಕು?';

  @override
  String get materialEnterQuantity => 'ಎಷ್ಟು ಬೇಕು ಎಂದು ನಮೂದಿಸಿ';

  @override
  String get materialEnterCost => 'ಅಂದಾಜು ವೆಚ್ಚ ನಮೂದಿಸಿ';

  @override
  String get materialRequestBody =>
      'ನೀವು ಖರೀದಿಸುವ ಮೊದಲು ಇದನ್ನು ಅನುಮೋದಿಸಲು ಗ್ರಾಹಕರನ್ನು ಕೇಳಲಾಗುತ್ತದೆ.';

  @override
  String get materialName => 'ಸಾಮಗ್ರಿ';

  @override
  String get materialNameHint => 'ಉದಾ. 16A ಮಾಡ್ಯುಲರ್ ಸ್ವಿಚ್';

  @override
  String get materialQuantity => 'ಪ್ರಮಾಣ';

  @override
  String get materialUnit => 'ಘಟಕ';

  @override
  String get materialExpectedCost => 'ಅಂದಾಜು ವೆಚ್ಚ';

  @override
  String get materialAskCustomer => 'ಗ್ರಾಹಕರನ್ನು ಕೇಳಿ';

  @override
  String get materialEnterPaid => 'ನೀವು ಪಾವತಿಸಿದ ಮೊತ್ತ ನಮೂದಿಸಿ';

  @override
  String get materialCostRecorded => 'ವೆಚ್ಚ ದಾಖಲಾಗಿದೆ.';

  @override
  String get materialWhatCost => 'ಇದಕ್ಕೆ ಎಷ್ಟು ವೆಚ್ಚವಾಯಿತು?';

  @override
  String get materialReceiptBody => 'ಗ್ರಾಹಕರ ಬಿಲ್‌ಗೆ ಸೇರಿಸಲು ರಸೀದಿ ಲಗತ್ತಿಸಿ.';

  @override
  String get materialAmountPaid => 'ಪಾವತಿಸಿದ ಮೊತ್ತ';

  @override
  String get materialReceipt => 'ರಸೀದಿ';

  @override
  String get materialReceiptRequired => 'ಬಿಲ್‌ನ ಫೋಟೋ ಕಡ್ಡಾಯ.';

  @override
  String get evidenceDone => 'ಮುಗಿದಿದೆ';

  @override
  String get evidenceRequired => 'ಕಡ್ಡಾಯ';

  @override
  String get evidenceCamera => 'ಕ್ಯಾಮೆರಾ';

  @override
  String get evidenceGallery => 'ಗ್ಯಾಲರಿ';

  @override
  String get evidenceSaved => 'ಉಳಿಸಲಾಗಿದೆ';

  @override
  String get uploadWaiting => 'ಕಾಯುತ್ತಿದೆ';

  @override
  String get uploadPreparing => 'ಸಿದ್ಧಪಡಿಸುತ್ತಿದೆ';

  @override
  String get uploadStarting => 'ಅಪ್‌ಲೋಡ್ ಪ್ರಾರಂಭವಾಗುತ್ತಿದೆ';

  @override
  String uploadPercent(Object percent) {
    return '$percent%';
  }

  @override
  String get uploadFinishing => 'ಮುಗಿಸುತ್ತಿದೆ';

  @override
  String get uploadCancel => 'ಅಪ್‌ಲೋಡ್ ರದ್ದುಮಾಡಿ';

  @override
  String get uploadNotFinished => 'ಆ ಅಪ್‌ಲೋಡ್ ಮುಗಿಯಲಿಲ್ಲ.';

  @override
  String get commonRetry => 'ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ';

  @override
  String durationMinutes(Object minutes) {
    return '$minutes ನಿಮಿಷ';
  }

  @override
  String durationHours(Object hours) {
    return '$hours ಗಂಟೆ';
  }

  @override
  String durationHoursMinutes(Object hours, Object minutes) {
    return '$hours ಗಂಟೆ $minutes ನಿಮಿಷ';
  }

  @override
  String durationDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ದಿನಗಳು',
      one: '1 ದಿನ',
    );
    return '$_temp0';
  }

  @override
  String pricePerHour(Object price) {
    return '$price/ಗಂಟೆ';
  }

  @override
  String pricePerDay(Object price) {
    return '$price/ದಿನ';
  }

  @override
  String pricePerUnit(Object price) {
    return '$price/ಯೂನಿಟ್';
  }

  @override
  String pricePerSqft(Object price) {
    return '$price/ಚ.ಅಡಿ';
  }

  @override
  String get gigsTitle => 'ನನ್ನ ಸೇವೆಗಳು';

  @override
  String get gigsAddTooltip => 'ಸೇವೆ ಸೇರಿಸಿ';

  @override
  String get gigsAdd => 'ಸೇವೆ ಸೇರಿಸಿ';

  @override
  String get gigsEmpty => 'ಇನ್ನೂ ಸೇವೆಗಳಿಲ್ಲ';

  @override
  String get gigsEmptyBody =>
      'ನೀವು ನೀಡುವ ಸೇವೆಗಳನ್ನು ಸೇರಿಸಿ. ನಿಮಗೆ ಅನುಮೋದನೆ ಇರುವ ಎಲ್ಲಾ ಕೆಲಸಗಳಲ್ಲಿ ಬೇಕಾದಷ್ಟು ಸೇವೆಗಳನ್ನು ಸೇರಿಸಬಹುದು.';

  @override
  String get gigsNoneLive =>
      'ನಿಮ್ಮ ಯಾವುದೇ ಸೇವೆ ಲೈವ್ ಆಗಿಲ್ಲ, ಆದ್ದರಿಂದ ಗ್ರಾಹಕರು ನಿಮ್ಮನ್ನು ಬುಕ್ ಮಾಡಲು ಸಾಧ್ಯವಿಲ್ಲ.';

  @override
  String gigsLiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ಸೇವೆಗಳು ಲೈವ್ ಆಗಿವೆ.',
      one: '1 ಸೇವೆ ಲೈವ್ ಆಗಿದೆ.',
    );
    return '$_temp0';
  }

  @override
  String get gigsAvailable => 'ನೀವು ಕೆಲಸಕ್ಕೆ ಲಭ್ಯರಿದ್ದೀರಿ.';

  @override
  String get gigsOffDuty =>
      'ನೀವು ಡ್ಯೂಟಿಯಲ್ಲಿಲ್ಲ, ಆದ್ದರಿಂದ ನಿಮಗೆ ಕೆಲಸ ನೀಡಲಾಗುವುದಿಲ್ಲ.';

  @override
  String gigJobsDone(int count) {
    return '$count ಮುಗಿದಿವೆ';
  }

  @override
  String get gigEdit => 'ಸಂಪಾದಿಸಿ';

  @override
  String get gigPause => 'ವಿರಾಮ ನೀಡಿ';

  @override
  String get gigResume => 'ಮತ್ತೆ ಪ್ರಾರಂಭಿಸಿ';

  @override
  String get gigInReview => 'ಪರಿಶೀಲನೆಯಲ್ಲಿ';

  @override
  String get gigDraftHint => 'ಕರಡು — ಪರಿಶೀಲನೆಗೆ ಸಲ್ಲಿಸಿ';

  @override
  String get gigRejectedHint => 'ತಿರಸ್ಕರಿಸಲಾಗಿದೆ — ಸಂಪಾದಿಸಿ ಮತ್ತೆ ಸಲ್ಲಿಸಿ';

  @override
  String get gigArchived => 'ಆರ್ಕೈವ್ ಮಾಡಲಾಗಿದೆ';

  @override
  String get gigNotLive => 'ಲೈವ್ ಆಗಿಲ್ಲ';

  @override
  String get gigPaused => 'ವಿರಾಮ ನೀಡಲಾಗಿದೆ. ಈ ಕೆಲಸಗಳನ್ನು ನಿಮಗೆ ನೀಡಲಾಗುವುದಿಲ್ಲ.';

  @override
  String get gigLiveAgain => 'ಮತ್ತೆ ಲೈವ್.';

  @override
  String get gigDuration30m => '30 ನಿಮಿಷ';

  @override
  String get gigDuration45m => '45 ನಿಮಿಷ';

  @override
  String get gigDuration1h => '1 ಗಂಟೆ';

  @override
  String get gigDuration2h => '2 ಗಂಟೆ';

  @override
  String get gigDuration4h => '4 ಗಂಟೆ';

  @override
  String get gigDuration8h => '8 ಗಂಟೆ (ಒಂದು ಕೆಲಸದ ದಿನ)';

  @override
  String get gigDuration24h => '24 ಗಂಟೆ';

  @override
  String get gigDuration2d => '2 ದಿನ';

  @override
  String get gigDuration3d => '3 ದಿನ';

  @override
  String get gigDuration1w => '1 ವಾರ';

  @override
  String get gigSavedDraft => 'ಕರಡಾಗಿ ಉಳಿಸಲಾಗಿದೆ.';

  @override
  String get gigSubmitted => 'ಸಲ್ಲಿಸಲಾಗಿದೆ. ನಾವು ಪರಿಶೀಲಿಸಿ ತಿಳಿಸುತ್ತೇವೆ.';

  @override
  String get gigLive => 'ನಿಮ್ಮ ಸೇವೆ ಲೈವ್ ಆಗಿದೆ.';

  @override
  String get gigSaved => 'ಉಳಿಸಲಾಗಿದೆ.';

  @override
  String get gigEditorAddTitle => 'ಸೇವೆ ಸೇರಿಸಿ';

  @override
  String get gigEditorEditTitle => 'ಸೇವೆ ಸಂಪಾದಿಸಿ';

  @override
  String get gigNoTrades => 'ಇನ್ನೂ ಅನುಮೋದಿತ ಕೆಲಸಗಳಿಲ್ಲ';

  @override
  String get gigNoTradesBody =>
      'ಒಂದು ಕೆಲಸ ನಿಮಗೆ ಅನುಮೋದನೆಯಾದ ನಂತರ, ಅದರಡಿ ಸೇವೆಗಳನ್ನು ಪ್ರಕಟಿಸಬಹುದು. ಪ್ರಾರಂಭಿಸಲು ನಿಮ್ಮ ಪ್ರೊಫೈಲ್‌ನಿಂದ ಕೆಲಸ ಸೇರಿಸಿ.';

  @override
  String get gigFieldTrade => 'ಯಾವ ಕೆಲಸ?';

  @override
  String get gigFieldTitle => 'ಈ ಸೇವೆಯ ಹೆಸರು ಏನು?';

  @override
  String get gigFieldTitleHint =>
      'ಗ್ರಾಹಕರು ಇದನ್ನು ನೋಡುತ್ತಾರೆ. ನಿರ್ದಿಷ್ಟವಾಗಿ ಬರೆಯಿರಿ.';

  @override
  String get gigFieldTitleExample => 'ಉದಾ. ಸ್ಪ್ಲಿಟ್ AC ಡೀಪ್ ಕ್ಲೀನಿಂಗ್';

  @override
  String get gigFieldDescription => 'ಇದರಲ್ಲಿ ಏನೇನು ಸೇರಿದೆ?';

  @override
  String get gigFieldDescriptionHint =>
      'ಐಚ್ಛಿಕ, ಆದರೆ ಗ್ರಾಹಕರು ನಿಮ್ಮನ್ನು ಆಯ್ಕೆಮಾಡಲು ಸಹಾಯವಾಗುತ್ತದೆ.';

  @override
  String get gigFieldDescriptionExample =>
      'ಉದಾ. ಒಳಾಂಗಣ ಮತ್ತು ಹೊರಾಂಗಣ ಯೂನಿಟ್ ಪೂರ್ಣ ಸ್ವಚ್ಛತೆ, ಫಿಲ್ಟರ್ ತೊಳೆಯುವುದು, ಗ್ಯಾಸ್ ಪ್ರೆಶರ್ ಪರಿಶೀಲನೆ.';

  @override
  String get gigFieldPrice => 'ನೀವು ಎಷ್ಟು ತೆಗೆದುಕೊಳ್ಳುತ್ತೀರಿ?';

  @override
  String get gigFieldPriceHint =>
      'ಪ್ರತಿ ಸೇವೆಗೂ ತನ್ನದೇ ಬೆಲೆ ಇದೆ. ಇದು ನಿಮ್ಮ ಇತರ ಸೇವೆಗಳ ಮೇಲೆ ಪರಿಣಾಮ ಬೀರುವುದಿಲ್ಲ.';

  @override
  String get gigUnitPerJob => 'ಪ್ರತಿ ಕೆಲಸಕ್ಕೆ';

  @override
  String get gigUnitPerHour => 'ಗಂಟೆಗೆ';

  @override
  String get gigUnitPerDay => 'ದಿನಕ್ಕೆ';

  @override
  String get gigUnitPerUnit => 'ಪ್ರತಿ ಯೂನಿಟ್‌ಗೆ';

  @override
  String get gigUnitPerSqft => 'ಪ್ರತಿ ಚದರ ಅಡಿಗೆ';

  @override
  String get gigFieldDuration => 'ಇದಕ್ಕೆ ಸಾಮಾನ್ಯವಾಗಿ ಎಷ್ಟು ಸಮಯ ಬೇಕು?';

  @override
  String get gigFieldRadius => 'ಇದಕ್ಕಾಗಿ ನೀವು ಎಷ್ಟು ದೂರ ಪ್ರಯಾಣಿಸುತ್ತೀರಿ?';

  @override
  String get gigFieldRadiusHint =>
      'ನಿಮ್ಮ ಸಾಮಾನ್ಯ ಪ್ರಯಾಣ ದೂರ ಬಳಸಲು ಡೀಫಾಲ್ಟ್ ಆಗಿ ಬಿಡಿ.';

  @override
  String get gigUsualDistance => 'ನಿಮ್ಮ ಸಾಮಾನ್ಯ ದೂರ';

  @override
  String get gigUseUsualDistance => 'ನನ್ನ ಸಾಮಾನ್ಯ ದೂರ ಬಳಸಿ';

  @override
  String get gigReviewNotice =>
      'ಹೊಸ ಮತ್ತು ಸಂಪಾದಿತ ಸೇವೆಗಳು ಲೈವ್ ಆಗುವ ಮೊದಲು ನಮ್ಮ ತಂಡ ಪರಿಶೀಲಿಸುತ್ತದೆ. ಮುಗಿದ ತಕ್ಷಣ ನಿಮಗೆ ತಿಳಿಸುತ್ತೇವೆ.';

  @override
  String get gigSaveDraft => 'ಕರಡು ಉಳಿಸಿ';

  @override
  String get gigSubmitForReview => 'ಪರಿಶೀಲನೆಗೆ ಸಲ್ಲಿಸಿ';

  @override
  String get walletAllTransactions => 'ಎಲ್ಲಾ ವಹಿವಾಟುಗಳು';

  @override
  String get walletFrozen =>
      'ಒಂದು ವಿಷಯ ಪರಿಶೀಲಿಸುತ್ತಿರುವಾಗ ಹಣ ಹಿಂಪಡೆಯುವಿಕೆಯನ್ನು ತಡೆಹಿಡಿಯಲಾಗಿದೆ. ವಿವರಗಳಿಗೆ ಬೆಂಬಲವನ್ನು ಸಂಪರ್ಕಿಸಿ.';

  @override
  String get walletWithdraw => 'ಹಣ ಹಿಂಪಡೆಯಿರಿ';

  @override
  String walletNothingPending(Object amount) {
    return 'ಇನ್ನೂ ಹಿಂಪಡೆಯಲು ಏನೂ ಇಲ್ಲ. $amount ಇನ್ನೂ ಪ್ರಕ್ರಿಯೆಯಲ್ಲಿದೆ, ಆ ಕೆಲಸಗಳು ಅನುಮೋದನೆಯಾದ ನಂತರ ನಿಮ್ಮ ಬ್ಯಾಲೆನ್ಸ್‌ಗೆ ಬರುತ್ತದೆ.';
  }

  @override
  String get walletNothingYet =>
      'ಇನ್ನೂ ಹಿಂಪಡೆಯಲು ಏನೂ ಇಲ್ಲ. ಗ್ರಾಹಕರು ಮುಗಿದ ಕೆಲಸ ಅನುಮೋದಿಸಿದ ನಂತರ ನಿಮ್ಮ ಗಳಿಕೆ ಇಲ್ಲಿ ಕಾಣಿಸುತ್ತದೆ.';

  @override
  String get walletRecentEarnings => 'ಇತ್ತೀಚಿನ ಗಳಿಕೆ';

  @override
  String get walletNoEarnings => 'ಇನ್ನೂ ಗಳಿಕೆ ಇಲ್ಲ';

  @override
  String get walletNoEarningsBody =>
      'ಮುಗಿದ ಕೆಲಸಕ್ಕೆ ಪಾವತಿಯಾದ ನಂತರ ನಿಮ್ಮ ಗಳಿಕೆ ಇಲ್ಲಿ ಕಾಣಿಸುತ್ತದೆ.';

  @override
  String get walletAvailable => 'ಹಿಂಪಡೆಯಲು ಲಭ್ಯ';

  @override
  String get walletProcessing => 'ಪ್ರಕ್ರಿಯೆಯಲ್ಲಿದೆ';

  @override
  String get walletProcessingHint => 'ತಡೆ ಅವಧಿಯ ನಂತರ ಬಿಡುಗಡೆಯಾಗುತ್ತದೆ';

  @override
  String get walletTotalEarned => 'ಒಟ್ಟು ಗಳಿಕೆ';

  @override
  String get statementTitle => 'ಸ್ಟೇಟ್‌ಮೆಂಟ್';

  @override
  String get statementTabTransactions => 'ವಹಿವಾಟುಗಳು';

  @override
  String get statementTabWithdrawals => 'ಹಿಂಪಡೆಯುವಿಕೆಗಳು';

  @override
  String get statementEmpty => 'ಇನ್ನೂ ಏನೂ ಇಲ್ಲ';

  @override
  String get statementEmptyBody =>
      'ನೀವು ಕೆಲಸ ಪ್ರಾರಂಭಿಸಿದ ನಂತರ ಪ್ರತಿ ಪಾವತಿ, ಶುಲ್ಕ ಮತ್ತು ಹಿಂಪಡೆಯುವಿಕೆ ಇಲ್ಲಿ ಪಟ್ಟಿಯಾಗುತ್ತದೆ.';

  @override
  String statementBalance(Object amount) {
    return 'ಬ್ಯಾಲೆನ್ಸ್ $amount';
  }

  @override
  String get statementNoWithdrawals => 'ಇನ್ನೂ ಹಿಂಪಡೆಯುವಿಕೆಗಳಿಲ್ಲ';

  @override
  String get statementNoWithdrawalsBody =>
      'ನೀವು ಹಣ ಹಿಂಪಡೆದಾಗ ಅದನ್ನು ಇಲ್ಲಿ ಟ್ರ್ಯಾಕ್ ಮಾಡಲಾಗುತ್ತದೆ.';

  @override
  String payoutRequestedAt(Object date) {
    return '$date ರಂದು ವಿನಂತಿಸಲಾಗಿದೆ';
  }

  @override
  String payoutPaidAt(Object date) {
    return '$date ರಂದು ಪಾವತಿಸಲಾಗಿದೆ';
  }

  @override
  String get payoutEnterAmount => 'ಎಷ್ಟು ಹಿಂಪಡೆಯಲು ಬಯಸುತ್ತೀರಿ ಎಂದು ನಮೂದಿಸಿ';

  @override
  String payoutUpTo(Object amount) {
    return 'ನೀವು ಈಗ $amount ವರೆಗೆ ಹಿಂಪಡೆಯಬಹುದು';
  }

  @override
  String payoutMinimum(Object amount) {
    return 'ಕನಿಷ್ಠ ಹಿಂಪಡೆಯುವಿಕೆ $amount';
  }

  @override
  String payoutRequested(Object amount) {
    return '$amount ಹಿಂಪಡೆಯಲು ವಿನಂತಿಸಲಾಗಿದೆ. ಪ್ರಕ್ರಿಯೆಯಾದಂತೆ ನಿಮಗೆ ತಿಳಿಸುತ್ತೇವೆ.';
  }

  @override
  String get payoutAvailableNow => 'ಈಗ ಲಭ್ಯ';

  @override
  String payoutPendingMore(Object amount) {
    return 'ಇನ್ನೂ $amount ಪ್ರಕ್ರಿಯೆಯಲ್ಲಿದೆ, ಈಗ ಹಿಂಪಡೆಯಲು ಸಾಧ್ಯವಿಲ್ಲ.';
  }

  @override
  String get payoutHowMuch => 'ಎಷ್ಟು?';

  @override
  String get payoutAll => 'ಎಲ್ಲಾ';

  @override
  String payoutPercent(Object percent) {
    return '$percent%';
  }

  @override
  String get payoutProcessNotice =>
      'ಹಿಂಪಡೆಯುವಿಕೆಗಳನ್ನು ಪರಿಶೀಲಿಸಿ ನಿಮ್ಮ ನೋಂದಾಯಿತ ಬ್ಯಾಂಕ್ ಖಾತೆಗೆ ಕಳುಹಿಸಲಾಗುತ್ತದೆ. ಪ್ರತಿ ಹಂತದ ಸ್ಥಿತಿ ಇಲ್ಲಿ ಕಾಣಿಸುತ್ತದೆ.';

  @override
  String get payoutRequest => 'ಹಿಂಪಡೆಯುವಿಕೆ ವಿನಂತಿಸಿ';

  @override
  String get bankChecking => 'ನಿಮ್ಮ ಬ್ಯಾಂಕ್ ಖಾತೆ ಪರಿಶೀಲಿಸುತ್ತಿದೆ…';

  @override
  String bankPaidTo(Object last4) {
    return '$last4 ನಲ್ಲಿ ಕೊನೆಗೊಳ್ಳುವ ಖಾತೆಗೆ ಪಾವತಿಸಲಾಗುತ್ತದೆ';
  }

  @override
  String get bankVerifiedFallback => 'ನಿಮ್ಮ ಪರಿಶೀಲಿತ ಬ್ಯಾಂಕ್ ಖಾತೆ';

  @override
  String get bankBeingVerified => 'ಬ್ಯಾಂಕ್ ಖಾತೆ ಪರಿಶೀಲನೆಯಲ್ಲಿದೆ';

  @override
  String get bankBeingVerifiedBody =>
      'ನಮ್ಮ ತಂಡ ಪರಿಶೀಲಿಸಿದ ನಂತರ ನೀವು ಹಣ ಹಿಂಪಡೆಯಬಹುದು.';

  @override
  String get bankNotVerified => 'ಬ್ಯಾಂಕ್ ಖಾತೆ ಪರಿಶೀಲಿಸಲಾಗಿಲ್ಲ';

  @override
  String get bankNotVerifiedBody => 'ನಿಮ್ಮ ವಿವರಗಳನ್ನು ಪರಿಶೀಲಿಸಿ ಮತ್ತೆ ಸಲ್ಲಿಸಿ.';

  @override
  String get bankAddTitle => 'ಬ್ಯಾಂಕ್ ಖಾತೆ ಸೇರಿಸಿ';

  @override
  String get bankAddBody =>
      'ನಮ್ಮ ತಂಡ ಪರಿಶೀಲಿಸಿದ ಬ್ಯಾಂಕ್ ಖಾತೆಗೆ ಮಾತ್ರ ಹಣ ಪಾವತಿಸಲಾಗುತ್ತದೆ.';

  @override
  String get bankAddAction => 'ಬ್ಯಾಂಕ್ ಖಾತೆ ಸೇರಿಸಿ';

  @override
  String get verificationTitle => 'ಪರಿಶೀಲನೆ';

  @override
  String get verificationProgress => 'ಪರಿಶೀಲಿತ ತಪಾಸಣೆಗಳು';

  @override
  String verificationCount(int approved, int total) {
    return '$total ರಲ್ಲಿ $approved';
  }

  @override
  String get verificationInsurance => 'ವಿಮೆ';

  @override
  String get verificationNoCover => 'ಸಕ್ರಿಯ ವಿಮೆ ಇಲ್ಲ';

  @override
  String get verificationNoCoverBody =>
      'ಪ್ರಸ್ತುತ ನಮ್ಮಲ್ಲಿ ನಿಮ್ಮ ಯಾವುದೇ ವಿಮಾ ಪಾಲಿಸಿ ದಾಖಲಾಗಿಲ್ಲ.';

  @override
  String get verifyIdentity => 'ಗುರುತು';

  @override
  String get verifyIdentityBody =>
      'ಸರ್ಕಾರಿ ಗುರುತಿನ ಚೀಟಿ, ತಮ್ಮ ಮನೆಗೆ ಯಾರು ಬರುತ್ತಿದ್ದಾರೆ ಎಂದು ಗ್ರಾಹಕರಿಗೆ ತಿಳಿಯಲು.';

  @override
  String get verifyAddress => 'ವಿಳಾಸ';

  @override
  String get verifyAddressBody => 'ನೀವು ಎಲ್ಲಿ ವಾಸಿಸುತ್ತೀರಿ ಎಂಬುದರ ಪುರಾವೆ.';

  @override
  String get verifyIti => 'ITI ಪ್ರಮಾಣಪತ್ರ';

  @override
  String get verifyItiBody =>
      'ಕೈಗಾರಿಕಾ ತರಬೇತಿ ಸಂಸ್ಥೆಯಿಂದ (ITI) ನಿಮ್ಮ ಟ್ರೇಡ್ ಪ್ರಮಾಣಪತ್ರ.';

  @override
  String get verifyDiploma => 'ಡಿಪ್ಲೊಮಾ';

  @override
  String get verifyDiplomaBody => 'ಮಾನ್ಯತೆ ಪಡೆದ ತಾಂತ್ರಿಕ ಡಿಪ್ಲೊಮಾ.';

  @override
  String get verifyRpl => 'ಕೌಶಲ್ಯ ಮೌಲ್ಯಮಾಪನ';

  @override
  String get verifyRplBody =>
      'ಪೂರ್ವ ಕಲಿಕೆಯ ಮಾನ್ಯತೆ (RPL): ನಿಮ್ಮ ಅನುಭವದ ಮೌಲ್ಯಮಾಪನ ಮತ್ತು ಪ್ರಮಾಣೀಕರಣ.';

  @override
  String get verifyBackground => 'ಹಿನ್ನೆಲೆ ತಪಾಸಣೆ';

  @override
  String get verifyBackgroundBody =>
      'ಇದನ್ನು ನಾವೇ ಮಾಡುತ್ತೇವೆ. ನೀವು ಏನೂ ಮಾಡಬೇಕಿಲ್ಲ.';

  @override
  String get verifyInsuranceBody =>
      'ಕೆಲಸ ಮಾಡುವಾಗ ಆಕಸ್ಮಿಕ ಹಾನಿಗೆ ವಿಮೆ. ವ್ಯವಸ್ಥೆಯಾದ ನಂತರ ನಮ್ಮ ತಂಡ ನಿಮ್ಮ ಪಾಲಿಸಿ ಸೇರಿಸುತ್ತದೆ.';

  @override
  String get verifyBank => 'ಬ್ಯಾಂಕ್ ಖಾತೆ';

  @override
  String get verifyBankBody => 'ನಿಮ್ಮ ಹಿಂಪಡೆಯುವಿಕೆಗಳು ಪಾವತಿಯಾಗುವ ಸ್ಥಳ.';

  @override
  String verificationValidUntil(Object date) {
    return '$date ವರೆಗೆ ಮಾನ್ಯ';
  }

  @override
  String get verificationStart => 'ಪ್ರಾರಂಭಿಸಿ';

  @override
  String get verificationUpdate => 'ಅಪ್‌ಡೇಟ್ ಮಾಡಿ';

  @override
  String get policyActive => 'ಸಕ್ರಿಯ';

  @override
  String get policyNotActive => 'ಸಕ್ರಿಯವಲ್ಲ';

  @override
  String get policyNumber => 'ಪಾಲಿಸಿ';

  @override
  String get policyCover => 'ವಿಮಾ ಮೊತ್ತ';

  @override
  String get policyValidUntil => 'ವರೆಗೆ ಮಾನ್ಯ';

  @override
  String get kycStillWaiting =>
      'ಇನ್ನೂ DigiLocker ಗಾಗಿ ಕಾಯುತ್ತಿದೆ. ನಂತರ ಇಲ್ಲಿಂದ ಮತ್ತೆ ನೋಡಬಹುದು.';

  @override
  String get kycTitle => 'ಗುರುತು ಪರಿಶೀಲನೆ';

  @override
  String get kycHeadline => 'ನೀವು ಯಾರು ಎಂದು ದೃಢೀಕರಿಸಿ';

  @override
  String get kycIntro =>
      'ಗ್ರಾಹಕರು ನಿಮ್ಮನ್ನು ತಮ್ಮ ಮನೆಗಳಿಗೆ ಬರಲು ಬಿಡುತ್ತಾರೆ, ಆದ್ದರಿಂದ ಪ್ರತಿ ಕಾರ್ಮಿಕರ ಗುರುತನ್ನು ಭಾರತ ಸರ್ಕಾರದ ದಾಖಲೆ ವೇದಿಕೆಯಾದ DigiLocker ಮೂಲಕ ಪರಿಶೀಲಿಸುತ್ತೇವೆ. ಏನೂ ಅಪ್‌ಲೋಡ್ ಆಗುವುದಿಲ್ಲ — ನೀವು ನಿಮ್ಮ ಆಧಾರ್ ಖಾತೆಯಲ್ಲಿ ವಿನಂತಿಯನ್ನು ಅನುಮೋದಿಸಿದರೆ ಸಾಕು.';

  @override
  String get kycPrivacy =>
      'ನಿಮ್ಮ ಆಧಾರ್ ವಿವರಗಳನ್ನು ನೇರವಾಗಿ DigiLocker ನೊಂದಿಗೆ ದೃಢೀಕರಿಸಲಾಗುತ್ತದೆ. ತಪಾಸಣೆ ನಡೆದಿದೆ ಎಂದು ಸಾಬೀತುಪಡಿಸುವುದನ್ನು ಮಾತ್ರ ನಾವು ಉಳಿಸುತ್ತೇವೆ — ನಿಮ್ಮ ಫೋಟೋ ಅಥವಾ ಆಧಾರ್ ಪ್ರತಿ ಎಂದಿಗೂ ಅಲ್ಲ.';

  @override
  String get kycVerified => 'ನಿಮ್ಮ ಗುರುತು ಪರಿಶೀಲಿಸಲಾಗಿದೆ.';

  @override
  String get kycAwaitingConsent =>
      'ನಿಮ್ಮ ಬ್ರೌಸರ್‌ನಲ್ಲಿ DigiLocker ಒಪ್ಪಿಗೆ ಪೂರ್ಣಗೊಳಿಸಿ, ನಂತರ ಇಲ್ಲಿಗೆ ಹಿಂತಿರುಗಿ.';

  @override
  String get kycChecking => 'DigiLocker ನೊಂದಿಗೆ ಪರಿಶೀಲಿಸುತ್ತಿದೆ…';

  @override
  String get kycStart => 'DigiLocker ಮೂಲಕ ಪರಿಶೀಲಿಸಿ';

  @override
  String get qualSubmitted => 'ಪರಿಶೀಲನೆಗೆ ಸಲ್ಲಿಸಲಾಗಿದೆ.';

  @override
  String get qualTitle => 'ನಿಮ್ಮ ಅರ್ಹತೆ';

  @override
  String get qualIti => 'ITI';

  @override
  String get qualInstitute => 'ಸಂಸ್ಥೆ';

  @override
  String get qualInstituteHint => 'ಉದಾ. ಸರ್ಕಾರಿ ITI, ಕೊಯಮತ್ತೂರು';

  @override
  String get qualName => 'ಅರ್ಹತೆ';

  @override
  String get qualNameHint => 'ಉದಾ. ಎಲೆಕ್ಟ್ರಿಷಿಯನ್';

  @override
  String get qualSpeciality => 'ವಿಶೇಷತೆ (ಐಚ್ಛಿಕ)';

  @override
  String get qualSpecialityHint => 'ಉದಾ. ಕೈಗಾರಿಕಾ ವೈರಿಂಗ್';

  @override
  String get qualYear => 'ಪೂರ್ಣಗೊಳಿಸಿದ ವರ್ಷ';

  @override
  String get qualCertificate => 'ನಿಮ್ಮ ಪ್ರಮಾಣಪತ್ರ';

  @override
  String get qualCertificateBody => 'ಪ್ರಮಾಣಪತ್ರದ ಸ್ಪಷ್ಟ ಫೋಟೋ ಅಥವಾ PDF.';

  @override
  String get bankErrorHolder => 'ಖಾತೆಯಲ್ಲಿರುವಂತೆಯೇ ಹೆಸರು ನಮೂದಿಸಿ';

  @override
  String get bankErrorNumber => 'ಖಾತೆ ಸಂಖ್ಯೆ 9 ರಿಂದ 18 ಅಂಕಿಗಳಿರುತ್ತದೆ';

  @override
  String get bankErrorMismatch => 'ಖಾತೆ ಸಂಖ್ಯೆಗಳು ಹೊಂದಾಣಿಕೆಯಾಗುತ್ತಿಲ್ಲ';

  @override
  String get bankErrorIfsc => '11 ಅಕ್ಷರಗಳ IFSC ನಮೂದಿಸಿ, ಉದಾ. SBIN0001234';

  @override
  String get bankSent => 'ಬ್ಯಾಂಕ್ ಖಾತೆ ಪರಿಶೀಲನೆಗೆ ಕಳುಹಿಸಲಾಗಿದೆ.';

  @override
  String get bankNotice =>
      'ನಿಮ್ಮ ಹಿಂಪಡೆಯುವಿಕೆಗಳು ಈ ಖಾತೆಗೆ ಪಾವತಿಯಾಗುತ್ತವೆ. ಮೊದಲ ಪೇಔಟ್‌ಗೆ ಮೊದಲು ನಮ್ಮ ತಂಡ ಇದನ್ನು ಪರಿಶೀಲಿಸುತ್ತದೆ.';

  @override
  String get bankHolder => 'ಖಾತೆದಾರರ ಹೆಸರು';

  @override
  String get bankNumber => 'ಖಾತೆ ಸಂಖ್ಯೆ';

  @override
  String get bankConfirmNumber => 'ಖಾತೆ ಸಂಖ್ಯೆ ಮತ್ತೆ ನಮೂದಿಸಿ';

  @override
  String get bankIfsc => 'IFSC ಕೋಡ್';

  @override
  String get bankIfscHint => 'ಉದಾ. SBIN0001234';

  @override
  String get bankName => 'ಬ್ಯಾಂಕ್ ಹೆಸರು (ಐಚ್ಛಿಕ)';

  @override
  String get bankSubmit => 'ಪರಿಶೀಲನೆಗೆ ಸಲ್ಲಿಸಿ';

  @override
  String get profileCompleteness => 'ಪ್ರೊಫೈಲ್ ಪೂರ್ಣತೆ';

  @override
  String get profileCompletenessBody =>
      'ಪೂರ್ಣ ಪ್ರೊಫೈಲ್ ಗ್ರಾಹಕರು ನಿಮ್ಮನ್ನು ಆಯ್ಕೆಮಾಡಲು ಸಹಾಯ ಮಾಡುತ್ತದೆ.';

  @override
  String get profileJobsDone => 'ಮುಗಿದ ಕೆಲಸಗಳು';

  @override
  String get profileRating => 'ರೇಟಿಂಗ್';

  @override
  String get profileExperience => 'ಅನುಭವ';

  @override
  String profileExperienceYears(Object years) {
    return '$years ವರ್ಷ';
  }

  @override
  String get profileEdit => 'ಪ್ರೊಫೈಲ್ ಸಂಪಾದಿಸಿ';

  @override
  String get profileVerified => 'ಪರಿಶೀಲಿತ';

  @override
  String get profileNotVerified => 'ಪರಿಶೀಲಿಸಲಾಗಿಲ್ಲ';

  @override
  String get profilePinInvalid => 'ಮಾನ್ಯ 6 ಅಂಕಿಯ ಪಿನ್ ಕೋಡ್ ನಮೂದಿಸಿ';

  @override
  String get profileUpdated => 'ಪ್ರೊಫೈಲ್ ಅಪ್‌ಡೇಟ್ ಆಗಿದೆ.';

  @override
  String get profilePhotoUpdated => 'ಫೋಟೋ ಅಪ್‌ಡೇಟ್ ಆಗಿದೆ.';

  @override
  String get profileChangePhoto => 'ಫೋಟೋ ಬದಲಾಯಿಸಿ';

  @override
  String get profileName => 'ಹೆಸರು';

  @override
  String get profilePhone => 'ಫೋನ್';

  @override
  String get profileLockedNotice =>
      'ನಿಮ್ಮ ಹೆಸರು ಮತ್ತು ಸಂಖ್ಯೆ ನಿಮ್ಮ ಗುರುತು ಪರಿಶೀಲನೆಗೆ ಜೋಡಿಸಲಾಗಿದೆ. ಯಾವುದನ್ನಾದರೂ ಬದಲಾಯಿಸಬೇಕಾದರೆ ಬೆಂಬಲವನ್ನು ಸಂಪರ್ಕಿಸಿ.';

  @override
  String get profileAbout => 'ನಿಮ್ಮ ಬಗ್ಗೆ';

  @override
  String get profileBioHint =>
      'ನಿಮ್ಮ ಅನುಭವ ಮತ್ತು ನೀವು ಯಾವುದರಲ್ಲಿ ನಿಪುಣರು ಎಂದು ಗ್ರಾಹಕರಿಗೆ ತಿಳಿಸಿ.';

  @override
  String get profileYearsExperience => 'ಅನುಭವದ ವರ್ಷಗಳು';

  @override
  String get profileBased => 'ನೀವು ಎಲ್ಲಿ ವಾಸಿಸುತ್ತೀರಿ';

  @override
  String get profileAddress => 'ವಿಳಾಸ';

  @override
  String get profileCity => 'ನಗರ';

  @override
  String get profilePin => 'ಪಿನ್ ಕೋಡ್';

  @override
  String get profileGender => 'ಲಿಂಗ';

  @override
  String get genderMale => 'ಪುರುಷ';

  @override
  String get genderFemale => 'ಮಹಿಳೆ';

  @override
  String get genderOther => 'ಇತರೆ';

  @override
  String get profileTrades => 'ನಿಮ್ಮ ಕೆಲಸಗಳು';

  @override
  String get profileTradesBody =>
      'ನಿಮಗೆ ಅನುಮೋದನೆ ಇರುವ ಎಲ್ಲಾ ಕೆಲಸಗಳಲ್ಲಿ ನೀವು ಕೆಲಸ ಮಾಡಬಹುದು.';

  @override
  String get profileTradesLoadFailed =>
      'ನಿಮ್ಮ ಕೆಲಸಗಳನ್ನು ಲೋಡ್ ಮಾಡಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ.';

  @override
  String get tradePending => 'ಬಾಕಿ';

  @override
  String get profileAddTrade => 'ಕೆಲಸ ಸೇರಿಸಿ';

  @override
  String get profileAddTradeBody =>
      'ಅನುಮೋದಿಸುವ ಮೊದಲು ನಿಮ್ಮ ಕೌಶಲ್ಯಗಳ ಪುರಾವೆ ಕೇಳಬಹುದು.';

  @override
  String get profileTradeRequested =>
      'ವಿನಂತಿಸಲಾಗಿದೆ. ಅನುಮೋದನೆಯಾದ ತಕ್ಷಣ ತಿಳಿಸುತ್ತೇವೆ.';

  @override
  String get profileSave => 'ಬದಲಾವಣೆಗಳನ್ನು ಉಳಿಸಿ';

  @override
  String get supportNewRequest => 'ಹೊಸ ವಿನಂತಿ';

  @override
  String get supportEmpty => 'ಇನ್ನೂ ವಿನಂತಿಗಳಿಲ್ಲ';

  @override
  String get supportEmptyBody =>
      'ಯಾವುದೇ ಕೆಲಸ, ಪಾವತಿ ಅಥವಾ ನಿಮ್ಮ ಖಾತೆಯಲ್ಲಿ ಏನಾದರೂ ತಪ್ಪಾದರೆ, ವಿನಂತಿ ಮಾಡಿ, ನಾವು ಸಹಾಯ ಮಾಡುತ್ತೇವೆ.';

  @override
  String get supportYourRequests => 'ನಿಮ್ಮ ವಿನಂತಿಗಳು';

  @override
  String get supportEmergency => 'ತುರ್ತು ಸಂದರ್ಭದಲ್ಲಿ';

  @override
  String get supportEmergencyBody =>
      'ಈ ಆ್ಯಪ್ ನಿಮ್ಮ ಪರವಾಗಿ ಸಹಾಯಕ್ಕೆ ಕರೆ ಮಾಡಲು ಸಾಧ್ಯವಿಲ್ಲ. ನೀವು ಅಪಾಯದಲ್ಲಿದ್ದರೆ, ನೇರವಾಗಿ ತುರ್ತು ಸೇವೆಗಳಿಗೆ ಕರೆ ಮಾಡಿ.';

  @override
  String get supportCall112 => '112 ಗೆ ಕರೆ ಮಾಡಿ';

  @override
  String get supportPolice => 'ಪೊಲೀಸ್';

  @override
  String get ticketOpen => 'ತೆರೆದಿದೆ';

  @override
  String get ticketInProgress => 'ಪ್ರಗತಿಯಲ್ಲಿದೆ';

  @override
  String get ticketReplyNeeded => 'ನಿಮ್ಮ ಉತ್ತರ ಬೇಕು';

  @override
  String get ticketResolved => 'ಪರಿಹರಿಸಲಾಗಿದೆ';

  @override
  String get ticketClosed => 'ಮುಚ್ಚಲಾಗಿದೆ';

  @override
  String ticketLastUpdate(Object date) {
    return 'ಕೊನೆಯ ಅಪ್‌ಡೇಟ್ $date';
  }

  @override
  String get supportCategoryJob => 'ಒಂದು ಕೆಲಸ';

  @override
  String get supportCategoryPayment => 'ಒಂದು ಪಾವತಿ';

  @override
  String get supportCategoryWithdrawal => 'ಹಣ ಹಿಂಪಡೆಯುವಿಕೆ';

  @override
  String get supportCategoryAccount => 'ನನ್ನ ಖಾತೆ';

  @override
  String get supportCategorySafety => 'ಸುರಕ್ಷತೆ';

  @override
  String get supportCategoryApp => 'ಆ್ಯಪ್';

  @override
  String get supportCategoryOther => 'ಬೇರೆ ಏನಾದರೂ';

  @override
  String supportRaised(Object code) {
    return 'ವಿನಂತಿ $code ದಾಖಲಾಗಿದೆ.';
  }

  @override
  String get supportHowHelp => 'ನಾವು ಹೇಗೆ ಸಹಾಯ ಮಾಡಬಹುದು?';

  @override
  String get supportAbout => 'ಇದು ಯಾವುದರ ಬಗ್ಗೆ?';

  @override
  String get supportSubject => 'ವಿಷಯ';

  @override
  String get supportSubjectHint => 'ಸಮಸ್ಯೆಯ ಬಗ್ಗೆ ಕೆಲವು ಪದಗಳು';

  @override
  String get supportWhatHappened => 'ಏನಾಯಿತು?';

  @override
  String get supportSend => 'ವಿನಂತಿ ಕಳುಹಿಸಿ';

  @override
  String get ticketTitle => 'ಬೆಂಬಲ ವಿನಂತಿ';

  @override
  String get ticketNoMessages => 'ಇನ್ನೂ ಸಂದೇಶಗಳಿಲ್ಲ';

  @override
  String get ticketNoMessagesBody => 'ನಿಮ್ಮ ಸಂಭಾಷಣೆ ಇಲ್ಲಿ ಕಾಣಿಸುತ್ತದೆ.';

  @override
  String get ticketWriteMessage => 'ಸಂದೇಶ ಬರೆಯಿರಿ';

  @override
  String get ticketSupportName => 'Wervexa ಬೆಂಬಲ';

  @override
  String get requestsTitle => 'ಗ್ರಾಹಕರ ವಿನಂತಿಗಳು';

  @override
  String get requestsRefresh => 'ರಿಫ್ರೆಶ್ ಮಾಡಿ';

  @override
  String get requestsLocationNeeded => 'ಸ್ಥಳ ಅಗತ್ಯ';

  @override
  String get requestsLocationBody =>
      'ನಿಮ್ಮ ಹತ್ತಿರದ ಗ್ರಾಹಕ ವಿನಂತಿಗಳನ್ನು ಹುಡುಕಲು ನಾವು ನಿಮ್ಮ ಸ್ಥಳ ಬಳಸುತ್ತೇವೆ.';

  @override
  String get requestsGrantLocation => 'ಸ್ಥಳ ಪ್ರವೇಶ ನೀಡಿ';

  @override
  String get requestsEmpty => 'ಹತ್ತಿರದಲ್ಲಿ ಹೊಂದಿಕೆಯಾಗುವ ವಿನಂತಿಗಳಿಲ್ಲ';

  @override
  String get requestsEmptyBody =>
      'ನಿಮ್ಮ ಸೇವೆಗಳಿಗೆ ಹೊಂದಿಕೆಯಾದಾಗ\nಹೊಸ ಗ್ರಾಹಕ ವಿನಂತಿಗಳು ಇಲ್ಲಿ ಕಾಣಿಸುತ್ತವೆ.';

  @override
  String get requestsViewOffer => 'ನೋಡಿ ಮತ್ತು ಆಫರ್ ನೀಡಿ →';

  @override
  String get requestEnterPrice => 'ಮಾನ್ಯ ಬೆಲೆ ನಮೂದಿಸಿ';

  @override
  String requestOfferSubmitted(Object price) {
    return '$price ಗೆ ಆಫರ್ ಸಲ್ಲಿಸಲಾಗಿದೆ!';
  }

  @override
  String get requestDetailsTitle => 'ವಿನಂತಿ ವಿವರಗಳು';

  @override
  String get requestStatusOpen => 'ತೆರೆದಿದೆ';

  @override
  String get requestCategory => 'ವರ್ಗ';

  @override
  String get requestBudget => 'ಬಜೆಟ್';

  @override
  String get requestSchedule => 'ವೇಳಾಪಟ್ಟಿ';

  @override
  String get requestDistance => 'ದೂರ';

  @override
  String get requestArea => 'ಪ್ರದೇಶ';

  @override
  String get requestOffers => 'ಆಫರ್‌ಗಳು';

  @override
  String get requestNotes => 'ಟಿಪ್ಪಣಿಗಳು';

  @override
  String get requestAddressPrivacy =>
      'ಗ್ರಾಹಕರು ನಿಮ್ಮ ಆಫರ್ ಸ್ವೀಕರಿಸಿದ ನಂತರವೇ ಅವರ ನಿಖರ ವಿಳಾಸ ಹಂಚಲಾಗುತ್ತದೆ.';

  @override
  String get requestYourOffer => 'ನಿಮ್ಮ ಆಫರ್';

  @override
  String get requestYourPrice => 'ನಿಮ್ಮ ಬೆಲೆ (₹)';

  @override
  String get requestPriceHint => 'ಉದಾ. 500';

  @override
  String get requestDuration => 'ಅಂದಾಜು ಅವಧಿ (ಐಚ್ಛಿಕ)';

  @override
  String get requestDurationHint => 'ಉದಾ. 1-2 ಗಂಟೆ';

  @override
  String get requestMessage => 'ಗ್ರಾಹಕರಿಗೆ ಸಂದೇಶ (ಐಚ್ಛಿಕ)';

  @override
  String get requestMessageHint => 'ಈ ಕೆಲಸಕ್ಕೆ ನೀವೇ ಸರಿಯಾದ ವ್ಯಕ್ತಿ ಏಕೆ?';

  @override
  String get requestSubmitOffer => 'ಆಫರ್ ಸಲ್ಲಿಸಿ';

  @override
  String get requestMakeOffer => 'ಆಫರ್ ನೀಡಿ';

  @override
  String get requestAlreadyOffered =>
      'ನೀವು ಈ ವಿನಂತಿಗೆ ಈಗಾಗಲೇ ಆಫರ್ ಸಲ್ಲಿಸಿದ್ದೀರಿ.';

  @override
  String get requestViewOffers => 'ಆಫರ್‌ಗಳನ್ನು ನೋಡಿ';

  @override
  String get offersEmptyBody =>
      'ಗ್ರಾಹಕ ವಿನಂತಿಗಳಿಗೆ ನೀವು ಸಲ್ಲಿಸಿದ ಆಫರ್‌ಗಳು\nಇಲ್ಲಿ ಕಾಣಿಸುತ್ತವೆ.';

  @override
  String get offerWithdraw => 'ಹಣ ಹಿಂಪಡೆಯಿರಿ';

  @override
  String get offerWithdrawTitle => 'ಆಫರ್ ಹಿಂಪಡೆಯಬೇಕೇ?';

  @override
  String get offerWithdrawBody => 'ಗ್ರಾಹಕರಿಗೆ ಈ ಆಫರ್ ಇನ್ನು ಕಾಣಿಸುವುದಿಲ್ಲ.';

  @override
  String get offerWithdrawn => 'ಆಫರ್ ಹಿಂಪಡೆಯಲಾಗಿದೆ';

  @override
  String get onboardingTitle => 'ನಿಮ್ಮ ಪ್ರೊಫೈಲ್ ಹೊಂದಿಸಿ';

  @override
  String get onboardingHelp => 'ಸಹಾಯ';

  @override
  String onboardingHello(Object name) {
    return 'ನಮಸ್ಕಾರ, $name';
  }

  @override
  String get onboardingIntro =>
      'ಇನ್ನು ಕೆಲವು ವಿಷಯಗಳು, ನಂತರ ನೀವು ಕೆಲಸ ಪಡೆಯಲು ಸಿದ್ಧ.';

  @override
  String get onboardingSetup => 'ಸೆಟಪ್';

  @override
  String onboardingStepCount(int done, int total) {
    return '$total ರಲ್ಲಿ $done';
  }

  @override
  String get onboardingBasicBody =>
      'ನಿಮ್ಮ ನಗರ ಮತ್ತು ಪಿನ್ ಕೋಡ್, ನಿಮ್ಮ ಹತ್ತಿರ ಕೆಲಸ ಹುಡುಕಲು.';

  @override
  String get onboardingTradeBody => 'ನೀವು ಮುಖ್ಯವಾಗಿ ಮಾಡುವ ಕೆಲಸ.';

  @override
  String get onboardingSkillsDoneBody =>
      'ನಿಮ್ಮ ಮುಖ್ಯ ಕೆಲಸ ಒಂದಾಗಿ ಎಣಿಕೆಯಾಗುತ್ತದೆ. ನೀವು ಮಾಡುವ ಇತರ ಎಲ್ಲಾ ಕೆಲಸಗಳನ್ನು ಸೇರಿಸಲು ಇದನ್ನು ತೆರೆಯಿರಿ.';

  @override
  String get onboardingSkillsBody =>
      'ನೀವು ಮಾಡುವ ಎಲ್ಲಾ ಕೆಲಸಗಳನ್ನು ಸೇರಿಸಿ. ನೀವು ಒಂದೇ ಕೆಲಸಕ್ಕೆ ಸೀಮಿತರಲ್ಲ.';

  @override
  String get onboardingAreaBody =>
      'ಒಂದು ಕೆಲಸಕ್ಕಾಗಿ ನೀವು ಎಷ್ಟು ದೂರ ಹೋಗಲು ಸಿದ್ಧರಿದ್ದೀರಿ.';

  @override
  String get onboardingKycBody =>
      'ಸರ್ಕಾರಿ ಗುರುತಿನ ಚೀಟಿ. ಗ್ರಾಹಕರು ನಿಮ್ಮನ್ನು ತಮ್ಮ ಮನೆಗಳಿಗೆ ಬರಲು ಬಿಡುತ್ತಿದ್ದಾರೆ.';

  @override
  String get onboardingReviewNotice =>
      'ಇವುಗಳನ್ನು ಮುಗಿಸಿದ ನಂತರ ನಮ್ಮ ತಂಡ ನಿಮ್ಮ ದಾಖಲೆಗಳನ್ನು ಪರಿಶೀಲಿಸುತ್ತದೆ. ಕಾಯುವಾಗ ನಿಮ್ಮ ಸೇವೆಗಳನ್ನು ಹೊಂದಿಸುವುದನ್ನು ಮುಂದುವರಿಸಬಹುದು.';

  @override
  String get onboardingTradesLoadFailed =>
      'ಕೆಲಸಗಳನ್ನು ಲೋಡ್ ಮಾಡಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ. ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get onboardingMainTrade => 'ನಿಮ್ಮ ಮುಖ್ಯ ಕೆಲಸ ಯಾವುದು?';

  @override
  String get onboardingMainTradeBody => 'ನಂತರ ಇನ್ನಷ್ಟು ಕೆಲಸಗಳನ್ನು ಸೇರಿಸಬಹುದು.';

  @override
  String onboardingTradeSet(Object trade) {
    return '$trade ನಿಮ್ಮ ಮುಖ್ಯ ಕೆಲಸವಾಗಿ ಹೊಂದಿಸಲಾಗಿದೆ.';
  }

  @override
  String get onboardingTravelTitle => 'ನೀವು ಎಷ್ಟು ದೂರ ಪ್ರಯಾಣಿಸುತ್ತೀರಿ?';

  @override
  String get onboardingTravelBody =>
      'ನೀವು ಈಗ ಇರುವ ಸ್ಥಳದಿಂದ ಈ ದೂರದೊಳಗಿನ ಕೆಲಸಗಳನ್ನು ಮಾತ್ರ ನಿಮಗೆ ನೀಡುತ್ತೇವೆ.';

  @override
  String get onboardingTravelCentre =>
      'ನಿಮ್ಮ ಪ್ರಸ್ತುತ ಸ್ಥಳವನ್ನು ಕೇಂದ್ರಬಿಂದುವಾಗಿ ಬಳಸುತ್ತೇವೆ. ಪ್ರೊಫೈಲ್‌ನಿಂದ ಯಾವಾಗ ಬೇಕಾದರೂ ಬದಲಾಯಿಸಬಹುದು.';

  @override
  String get onboardingLocationOff =>
      'ನಿಮ್ಮ ಕೆಲಸದ ಪ್ರದೇಶ ಹೊಂದಿಸಲು ಸ್ಥಳ ಪ್ರವೇಶ ಆನ್ ಮಾಡಿ.';

  @override
  String get commonSave => 'ಉಳಿಸಿ';

  @override
  String get notificationsStayOff =>
      'ಅಧಿಸೂಚನೆಗಳು ಆಫ್ ಆಗಿಯೇ ಇರುತ್ತವೆ. ನಿಮ್ಮ ಫೋನ್ ಸೆಟ್ಟಿಂಗ್‌ಗಳಲ್ಲಿ ಅವುಗಳನ್ನು ಆನ್ ಮಾಡಬಹುದು.';

  @override
  String get notificationsPrimerTitle => 'ಕೆಲಸ ಬಂದಾಗ ತಿಳಿಯಿರಿ';

  @override
  String get notificationsPrimerBody =>
      'ಕೆಲಸದ ಆಫರ್‌ಗಳ ಅವಧಿ ಮುಗಿಯುತ್ತದೆ. ಆ್ಯಪ್ ಮುಚ್ಚಿರುವಾಗ ಅಧಿಸೂಚನೆಯ ಮೂಲಕವೇ ನಿಮಗೆ ತಿಳಿಯುತ್ತದೆ — ಬೇರೇನೂ ಕಳುಹಿಸಲಾಗುವುದಿಲ್ಲ.';

  @override
  String get notificationsTurnOn => 'ಅಧಿಸೂಚನೆಗಳನ್ನು ಆನ್ ಮಾಡಿ';

  @override
  String get commonNotNow => 'ಈಗ ಬೇಡ';

  @override
  String get onboardingCityRequired => 'ದಯವಿಟ್ಟು ನಿಮ್ಮ ನಗರ ನಮೂದಿಸಿ';

  @override
  String get onboardingGenderRequired => 'ದಯವಿಟ್ಟು ನಿಮ್ಮ ಲಿಂಗ ಆಯ್ಕೆಮಾಡಿ';

  @override
  String get onboardingWhereBased => 'ನೀವು ಎಲ್ಲಿ ವಾಸಿಸುತ್ತೀರಿ?';
}
