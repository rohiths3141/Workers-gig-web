// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class AppLocalizationsTa extends AppLocalizations {
  AppLocalizationsTa([String locale = 'ta']) : super(locale);

  @override
  String get languagePickerTitle => 'உங்கள் மொழியைத் தேர்ந்தெடுக்கவும்';

  @override
  String get startupMissingConfig => 'இந்த பில்டில் கட்டமைப்பு இல்லை.';

  @override
  String startupPassDartDefine(Object keys) {
    return 'இவற்றை --dart-define உடன் அனுப்பவும்:\n\n$keys';
  }

  @override
  String get startupCouldNotStart => 'ஆப் தொடங்க முடியவில்லை.';

  @override
  String get errorNoInternet =>
      'இணைய இணைப்பு இல்லை. உங்கள் நெட்வொர்க்கைச் சரிபார்த்து மீண்டும் முயலவும்.';

  @override
  String get errorTimeout => 'அதிக நேரம் ஆனது. மீண்டும் முயலவும்.';

  @override
  String get errorServer =>
      'எங்கள் பக்கத்தில் ஏதோ தவறு நடந்தது. மீண்டும் முயலவும்.';

  @override
  String get errorClockSkew =>
      'உங்கள் போனின் தேதியும் நேரமும் சரியாக இல்லை போல் தெரிகிறது. அமைப்புகளில் தானியங்கு தேதி & நேரத்தை இயக்கி மீண்டும் முயலவும்.';

  @override
  String get errorUnexpected => 'ஏதோ தவறு நடந்தது. மீண்டும் முயலவும்.';

  @override
  String get eligibilityStepIncomplete => 'இந்தப் படி இன்னும் முடியவில்லை.';

  @override
  String get errorSessionEnded =>
      'உங்கள் அமர்வு முடிந்தது. மீண்டும் உள்நுழையவும்.';

  @override
  String get errorUploadFailed =>
      'அந்தக் கோப்பைப் பதிவேற்ற முடியவில்லை. மீண்டும் முயலவும்.';

  @override
  String get errorServiceUnavailable =>
      'அந்தச் சேவை இப்போது கிடைக்கவில்லை. சிறிது நேரத்தில் மீண்டும் முயலவும்.';

  @override
  String get errorSignInNotReady =>
      'உங்கள் உள்நுழைவு இன்னும் முழுமையாகத் தயாராகவில்லை. சிறிது நேரத்தில் மீண்டும் முயலவும்.';

  @override
  String get errorNoLongerAvailable => 'அது இப்போது கிடைக்கவில்லை.';

  @override
  String get errorNotAllowedToSee => 'அதை நீங்கள் பார்க்க முடியாது.';

  @override
  String get errorDidNotWork => 'அது வேலை செய்யவில்லை. மீண்டும் முயலவும்.';

  @override
  String get authErrorInvalidPhone => 'அந்த போன் எண் சரியாகத் தெரியவில்லை.';

  @override
  String get authErrorWrongCode =>
      'அந்தக் குறியீடு தவறானது. சரிபார்த்து மீண்டும் முயலவும்.';

  @override
  String get authErrorCodeExpired =>
      'அந்தக் குறியீடு காலாவதியாகிவிட்டது. புதியதைக் கேளுங்கள்.';

  @override
  String get authErrorTooManyAttempts =>
      'பல முயற்சிகள் நடந்துவிட்டன. மீண்டும் முயலும் முன் சில நிமிடங்கள் காத்திருக்கவும்.';

  @override
  String get authErrorQuota =>
      'இப்போது குறியீட்டை அனுப்ப முடியவில்லை. சிறிது நேரத்தில் மீண்டும் முயலவும்.';

  @override
  String get authErrorDisabled =>
      'இந்தக் கணக்கு முடக்கப்பட்டுள்ளது. உதவி மையத்தைத் தொடர்பு கொள்ளவும்.';

  @override
  String get authErrorPhoneNotEnabledRegion =>
      'போன் உள்நுழைவு இயக்கப்படவில்லை, அல்லது இந்தப் பகுதிக்கு SMS தடுக்கப்பட்டுள்ளது. Firebase Console அமைப்புகளைச் சரிபார்க்கவும்.';

  @override
  String get authErrorNumberInUse =>
      'அந்த எண் ஏற்கனவே வேறொரு கணக்கில் பதிவு செய்யப்பட்டுள்ளது.';

  @override
  String get authErrorSignInAgain => 'தொடர மீண்டும் உள்நுழையவும்.';

  @override
  String get authErrorSignInFailed =>
      'உள்நுழைவு தோல்வியடைந்தது. மீண்டும் முயலவும்.';

  @override
  String get budgetTypeFlexible => 'நெகிழ்வானது';

  @override
  String get budgetTypeFixed => 'நிலையான விலை';

  @override
  String get budgetTypeRange => 'விலை வரம்பு';

  @override
  String get scheduleAsap => 'விரைவில் முடிந்தவரை';

  @override
  String get scheduleToday => 'இன்று';

  @override
  String get scheduleTomorrow => 'நாளை';

  @override
  String get scheduleSpecificDate => 'குறிப்பிட்ட தேதி';

  @override
  String get offerStatusSubmitted => 'சமர்ப்பிக்கப்பட்டது';

  @override
  String get offerStatusViewed => 'வாடிக்கையாளர் பார்த்தார்';

  @override
  String get offerStatusShortlisted => 'குறுகிய பட்டியலில்';

  @override
  String get offerStatusAccepted => 'ஏற்கப்பட்டது ✓';

  @override
  String get offerStatusRejected => 'தேர்ந்தெடுக்கப்படவில்லை';

  @override
  String get offerStatusWithdrawn => 'திரும்பப் பெறப்பட்டது';

  @override
  String get offerStatusExpired => 'காலாவதியானது';

  @override
  String get offerStatusClosed => 'மூடப்பட்டது';

  @override
  String distanceMetresAway(Object metres) {
    return '$metres மீ தொலைவில்';
  }

  @override
  String distanceKmAway(Object km) {
    return '$km கி.மீ தொலைவில்';
  }

  @override
  String offerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count சலுகைகள்',
      one: '1 சலுகை',
      zero: 'இன்னும் சலுகைகள் இல்லை',
    );
    return '$_temp0';
  }

  @override
  String get gigErrorTrade =>
      'இந்தச் சேவை எந்தத் தொழிலைச் சேர்ந்தது என்பதைத் தேர்ந்தெடுக்கவும்';

  @override
  String get gigErrorTitleShort =>
      'இந்தச் சேவைக்குக் குறைந்தது 6 எழுத்துகள் கொண்ட தெளிவான பெயர் கொடுக்கவும்';

  @override
  String get gigErrorTitleLong => 'பெயரை 120 எழுத்துகளுக்குள் வைக்கவும்';

  @override
  String get gigErrorPrice =>
      'இந்தச் சேவைக்கு நீங்கள் வசூலிக்கும் தொகையை உள்ளிடவும்';

  @override
  String get gigErrorDurationMissing => 'இதற்கு வழக்கமாக எவ்வளவு நேரம் ஆகும்?';

  @override
  String get gigErrorDurationShort =>
      'நாங்கள் பட்டியலிடக்கூடிய மிகக் குறுகிய வேலை 15 நிமிடங்கள்';

  @override
  String get gigErrorDurationLong =>
      'நாங்கள் பட்டியலிடக்கூடிய மிக நீண்ட வேலை 14 நாட்கள்';

  @override
  String get gigErrorRadius =>
      'பயணத் தூரம் 1 முதல் 100 கி.மீ-க்குள் இருக்க வேண்டும்';

  @override
  String get jobAreaNearby => 'அருகில்';

  @override
  String get jobBlockerVerifyArrival =>
      'வாடிக்கையாளரின் குறியீட்டுடன் வருகையைச் சரிபார்க்கவும்';

  @override
  String get jobBlockerAfterPhoto =>
      'முடிந்த வேலையின் புகைப்படத்தைச் சேர்க்கவும்';

  @override
  String jobBlockerMaterialsPending(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count பொருள் கோரிக்கைகள் இன்னும் வாடிக்கையாளருக்காகக் காத்திருக்கின்றன',
      one: '1 பொருள் கோரிக்கை இன்னும் வாடிக்கையாளருக்காகக் காத்திருக்கிறது',
    );
    return '$_temp0';
  }

  @override
  String mediaTypeNotAccepted(Object kinds) {
    return 'அந்தக் கோப்பு வகை இங்கே ஏற்கப்படாது. $kinds பயன்படுத்தவும்.';
  }

  @override
  String get mediaEmpty => 'அந்தக் கோப்பு காலியாக உள்ளது.';

  @override
  String mediaTooLarge(Object megabytes) {
    return 'அந்தக் கோப்பு மிகப் பெரியது. வரம்பு ${megabytes}MB.';
  }

  @override
  String get verificationNotStarted => 'தொடங்கவில்லை';

  @override
  String get verificationSubmitted => 'சமர்ப்பிக்கப்பட்டது';

  @override
  String get verificationUnderReview => 'பரிசீலனையில்';

  @override
  String get verificationMoreInfo => 'கூடுதல் தகவல் தேவை';

  @override
  String get verificationExpired => 'காலாவதியானது';

  @override
  String get verificationVerified => 'சரிபார்க்கப்பட்டது';

  @override
  String get verificationNotApproved => 'ஒப்புதல் அளிக்கப்படவில்லை';

  @override
  String get verificationNotRequired => 'தேவையில்லை';

  @override
  String get qualificationErrorInstitution => 'இதை எந்த நிறுவனம் வழங்கியது?';

  @override
  String get qualificationErrorName => 'தகுதியின் பெயர் என்ன?';

  @override
  String get qualificationErrorYearMissing => 'இதை எந்த ஆண்டு முடித்தீர்கள்?';

  @override
  String qualificationErrorYearRange(Object year) {
    return '1950 முதல் $year வரையிலான ஆண்டை உள்ளிடவும்';
  }

  @override
  String get walletTxJobEarning => 'வேலை வருமானம்';

  @override
  String get walletTxMaterialReimbursed => 'பொருள் செலவு திருப்பி அளிப்பு';

  @override
  String get walletTxAdjustment => 'சரிசெய்தல்';

  @override
  String get walletTxPayoutReturned => 'பேஅவுட் திரும்பி வந்தது';

  @override
  String get walletTxPlatformFee => 'தளக் கட்டணம்';

  @override
  String get walletTxWithdrawn => 'திரும்பப் பெறப்பட்டது';

  @override
  String get walletTxClaimRecovery => 'கோரிக்கை மீட்பு';

  @override
  String get payoutStatusRequested => 'கோரப்பட்டது';

  @override
  String get payoutStatusProcessing => 'செயலாக்கத்தில்';

  @override
  String get payoutStatusPaid => 'கட்டணம் செலுத்தப்பட்டது';

  @override
  String get payoutStatusFailed => 'தோல்வியடைந்தது';

  @override
  String get authPhoneTenDigits => '10 இலக்க மொபைல் எண்ணை உள்ளிடவும்.';

  @override
  String get authCodeSendTimeout =>
      'குறியீட்டை அனுப்ப முடியவில்லை. உங்கள் நெட்வொர்க்கைச் சரிபார்த்து மீண்டும் முயலவும்.';

  @override
  String get authEnterReceivedCode => 'உங்களுக்கு வந்த குறியீட்டை உள்ளிடவும்.';

  @override
  String get authSignInIncomplete =>
      'உள்நுழைவு நிறைவடையவில்லை. மீண்டும் முயலவும்.';

  @override
  String get authSignInToContinue => 'தொடர உள்நுழையவும்.';

  @override
  String get accountDeletionBySupport =>
      'கணக்கு நீக்கத்தை எங்கள் ஆதரவுக் குழு கையாளுகிறது. கோரிக்கை வையுங்கள், முடிந்ததும் உறுதிப்படுத்துவோம்.';

  @override
  String get photoUploadFailed => 'அந்தப் புகைப்படத்தைப் பதிவேற்ற முடியவில்லை.';

  @override
  String get photoUploadFailedRetry =>
      'அந்தப் புகைப்படத்தைப் பதிவேற்ற முடியவில்லை. மீண்டும் முயலவும்.';

  @override
  String get locationInvalid => 'அந்த இருப்பிடம் சரியாகத் தெரியவில்லை.';

  @override
  String get travelDistanceRange =>
      '1 முதல் 100 கி.மீ வரையிலான பயணத் தூரத்தைத் தேர்ந்தெடுக்கவும்.';

  @override
  String get profileLoadFailed => 'உங்கள் சுயவிவரத்தை ஏற்ற முடியவில்லை.';

  @override
  String get uploadIncomplete =>
      'பதிவேற்றம் நிறைவடையவில்லை. மீண்டும் முயலவும்.';

  @override
  String get uploadTooLarge => 'அந்தக் கோப்பு மிகப் பெரியது.';

  @override
  String get uploadTypeNotAccepted => 'அந்தக் கோப்பு வகை ஏற்கப்படாது.';

  @override
  String get uploadRefused => 'அந்தக் கோப்பு நிராகரிக்கப்பட்டது.';

  @override
  String get uploadTooMany =>
      'ஒரே நேரத்தில் பல பதிவேற்றங்கள். சிறிது காத்திருந்து மீண்டும் முயலவும்.';

  @override
  String get uploadGone =>
      'அந்தப் பதிவேற்றம் இப்போது கிடைக்கவில்லை. கோப்பை மீண்டும் தேர்ந்தெடுக்கவும்.';

  @override
  String get uploadDidNotStart => 'பதிவேற்றம் தொடங்கவில்லை.';

  @override
  String get uploadDidNotFinish => 'அந்தப் பதிவேற்றம் முடியவில்லை.';

  @override
  String get claimResponseTooShort =>
      'என்ன நடந்தது என்பதைச் சற்று விரிவாக விளக்கவும்.';

  @override
  String get walletLoadFailedRetry =>
      'உங்கள் வாலெட்டை ஏற்ற முடியவில்லை. மீண்டும் முயலவும்.';

  @override
  String get walletLoadFailed => 'உங்கள் வாலெட்டை ஏற்ற முடியவில்லை.';

  @override
  String get onboardingStepDetails => 'உங்கள் விவரங்கள்';

  @override
  String get onboardingStepTrade => 'உங்கள் முக்கியத் தொழில்';

  @override
  String get onboardingStepSkills => 'நீங்கள் என்ன செய்ய முடியும்';

  @override
  String get onboardingStepArea => 'நீங்கள் எங்கே வேலை செய்கிறீர்கள்';

  @override
  String get onboardingStepKyc => 'அடையாளச் சரிபார்ப்பு';

  @override
  String get onboardingStepReady => 'வேலைக்குத் தயார்';

  @override
  String routerScreenNotFound(Object location) {
    return 'அந்தத் திரையைத் திறக்க முடியவில்லை.\n$location';
  }

  @override
  String get cameraOpenFailed =>
      'கேமராவைத் திறக்க முடியவில்லை. ஆப் அனுமதிகளைச் சரிபார்க்கவும்.';

  @override
  String get commonTryAgain => 'மீண்டும் முயலவும்';

  @override
  String get commonCancel => 'ரத்துசெய்';

  @override
  String get commonConfirm => 'உறுதிசெய்';

  @override
  String get offlineBanner =>
      'நீங்கள் ஆஃப்லைனில் உள்ளீர்கள். மீண்டும் இணைந்ததும் வேலைச் செயல்கள் மீண்டும் இயங்கும்.';

  @override
  String get badgeNew => 'புதியவர்';

  @override
  String get badgeAccepted => 'ஏற்கப்பட்டது';

  @override
  String get badgeConfirmed => 'உறுதிசெய்யப்பட்டது';

  @override
  String get badgeOnTheWay => 'வழியில் உள்ளார்';

  @override
  String get badgeArrived => 'வந்துவிட்டார்';

  @override
  String get badgeWorking => 'வேலை நடக்கிறது';

  @override
  String get badgeAwaitingCustomer => 'வாடிக்கையாளருக்காகக் காத்திருக்கிறது';

  @override
  String get badgeDone => 'முடிந்தது';

  @override
  String get badgePaymentDue => 'கட்டணம் நிலுவை';

  @override
  String get badgePaid => 'கட்டணம் செலுத்தப்பட்டது';

  @override
  String get badgeClosed => 'மூடப்பட்டது';

  @override
  String get badgeCancelled => 'ரத்துசெய்யப்பட்டது';

  @override
  String get badgeDisputed => 'சர்ச்சையில்';

  @override
  String get badgeExpired => 'காலாவதியானது';

  @override
  String get badgeDraft => 'வரைவு';

  @override
  String get badgeInReview => 'பரிசீலனையில்';

  @override
  String get badgeLive => 'நேரலை';

  @override
  String get badgePaused => 'இடைநிறுத்தம்';

  @override
  String get badgeNotApproved => 'ஒப்புதல் அளிக்கப்படவில்லை';

  @override
  String get badgeRemoved => 'அகற்றப்பட்டது';

  @override
  String get badgeNotStarted => 'தொடங்கவில்லை';

  @override
  String get badgeSubmitted => 'சமர்ப்பிக்கப்பட்டது';

  @override
  String get badgeActionNeeded => 'நடவடிக்கை தேவை';

  @override
  String get badgeVerified => 'சரிபார்க்கப்பட்டது';

  @override
  String get badgeNotRequired => 'தேவையில்லை';

  @override
  String get commonContinue => 'தொடரவும்';

  @override
  String get commonSaving => 'சேமிக்கிறது…';

  @override
  String get welcomePromiseWorkTitle => 'பொருத்தமான வேலை பெறுங்கள்';

  @override
  String get welcomePromiseWorkBody =>
      'உங்கள் அருகிலுள்ள வேலைகள், நீங்கள் உண்மையில் செய்யும் தொழில்களுக்குப் பொருந்துபவை.';

  @override
  String get welcomePromiseSkillsTitle => 'உங்கள் திறன்களை நிரூபியுங்கள்';

  @override
  String get welcomePromiseSkillsBody =>
      'உங்கள் ITI மற்றும் டிப்ளோமா சான்றிதழ்கள், ஒருமுறை சரிபார்க்கப்பட்டு ஒவ்வொரு வாடிக்கையாளருக்கும் காட்டப்படும்.';

  @override
  String get welcomePromiseTrackTitle => 'ஒவ்வொரு வேலையையும் கண்காணியுங்கள்';

  @override
  String get welcomePromiseTrackBody =>
      'வேலையை ஏற்பதிலிருந்து முடிப்பது வரை, ஒவ்வொரு படியிலும் புகைப்படப் பதிவுகளுடன்.';

  @override
  String get welcomePromisePaidTitle => 'பாதுகாப்பாகப் பணம் பெறுங்கள்';

  @override
  String get welcomePromisePaidBody =>
      'ஒவ்வொரு ரூபாயும் பதிவு, தெளிவான அறிக்கையுடன், உங்கள் விருப்பப்படி பணம் எடுத்தல்.';

  @override
  String get welcomeHeadline => 'உங்களைத் தேடி வரும் வேலை';

  @override
  String get welcomeSubtitle =>
      'Wervexa திறமையான நிபுணர்களை அவர்கள் தேவைப்படும் வாடிக்கையாளர்களுடன் இணைக்கிறது.';

  @override
  String get welcomeGetStarted => 'தொடங்குங்கள்';

  @override
  String get welcomeCodeNotice =>
      'உங்கள் மொபைல் எண்ணுக்கு ஒருமுறைக் குறியீட்டை அனுப்புவோம்.';

  @override
  String get phoneTitle => 'உங்கள் மொபைல் எண் என்ன?';

  @override
  String get phoneSubtitle =>
      'இது நீங்கள்தான் என்பதை உறுதிசெய்ய ஒருமுறைக் குறியீட்டை அனுப்புவோம்.';

  @override
  String get phoneSendCode => 'குறியீட்டை அனுப்பு';

  @override
  String get phoneSending => 'அனுப்புகிறது…';

  @override
  String get authNewCodeSent => 'புதிய குறியீட்டை அனுப்பியுள்ளோம்.';

  @override
  String get otpTitle => 'குறியீட்டை உள்ளிடவும்';

  @override
  String otpSentTo(Object phone) {
    return '$phone எண்ணுக்கு 6 இலக்கக் குறியீட்டை அனுப்பியுள்ளோம்.';
  }

  @override
  String otpResendIn(int seconds) {
    String _temp0 = intl.Intl.pluralLogic(
      seconds,
      locale: localeName,
      other: '$seconds வினாடிகளில் புதிய குறியீட்டைக் கேட்கலாம்',
      one: '1 வினாடியில் புதிய குறியீட்டைக் கேட்கலாம்',
    );
    return '$_temp0';
  }

  @override
  String get otpSendNew => 'புதிய குறியீட்டை அனுப்பு';

  @override
  String get otpVerify => 'சரிபார்';

  @override
  String get otpVerifying => 'சரிபார்க்கிறது…';

  @override
  String get registerNameRequired => 'உங்கள் முழுப் பெயரை உள்ளிடவும்';

  @override
  String get registerEmailInvalid => 'சரியான மின்னஞ்சல் முகவரியை உள்ளிடவும்';

  @override
  String get registerTitle => 'உங்களை எப்படி அழைக்க வேண்டும்?';

  @override
  String get registerSubtitle =>
      'வாடிக்கையாளர்கள் இந்தப் பெயரையே பார்ப்பார்கள்.';

  @override
  String get registerNameLabel => 'முழுப் பெயர்';

  @override
  String get registerNameHint => 'அருண் குமார்';

  @override
  String get registerEmailLabel => 'மின்னஞ்சல் (விருப்பத்தேர்வு)';

  @override
  String get registerEmailHelper => 'ரசீதுகள் மற்றும் அறிக்கைகளுக்காக.';

  @override
  String registerVerifiedPhone(Object phone) {
    return 'சரிபார்க்கப்பட்டது: $phone';
  }

  @override
  String get navHome => 'முகப்பு';

  @override
  String get navJobs => 'வேலைகள்';

  @override
  String get navWallet => 'வாலெட்';

  @override
  String get navProfile => 'சுயவிவரம்';

  @override
  String get sessionProfileLoadFailedRetry =>
      'உங்கள் சுயவிவரத்தை ஏற்ற முடியவில்லை. மீண்டும் முயலவும்.';

  @override
  String get commonSignOut => 'வெளியேறு';

  @override
  String get serviceElectrical => 'மின் வேலை';

  @override
  String get servicePlumbing => 'பிளம்பிங்';

  @override
  String get serviceAcService => 'AC சர்வீஸ்';

  @override
  String get serviceApplianceRepair => 'சாதனப் பழுதுபார்ப்பு';

  @override
  String get serviceCarpentry => 'தச்சு வேலை';

  @override
  String get servicePainting => 'பெயிண்டிங்';

  @override
  String get serviceCleaning => 'சுத்தம் செய்தல்';

  @override
  String get servicePestControl => 'பூச்சிக் கட்டுப்பாடு';

  @override
  String get serviceOtherHome => 'பிற வீட்டுச் சேவைகள்';

  @override
  String get commonSeeAll => 'அனைத்தையும் காண்க';

  @override
  String distanceKm(Object km) {
    return '$km கி.மீ';
  }

  @override
  String get homeRightNow => 'இப்போது';

  @override
  String get homeNewWork => 'புதிய வேலை';

  @override
  String homeJobsWaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count வேலைகள் உங்கள் பதிலுக்காகக் காத்திருக்கின்றன',
      one: '1 வேலை உங்கள் பதிலுக்காகக் காத்திருக்கிறது',
    );
    return '$_temp0';
  }

  @override
  String get homeComingUp => 'வரவிருப்பவை';

  @override
  String get homeEarnings => 'வருமானம்';

  @override
  String get homeMyServices => 'என் சேவைகள்';

  @override
  String get homeVerification => 'சரிபார்ப்பு';

  @override
  String get homeSupport => 'ஆதரவு';

  @override
  String get homeRequests => 'கோரிக்கைகள்';

  @override
  String get homeMyOffers => 'என் சலுகைகள்';

  @override
  String get homeAddService => 'சேவையைச் சேர்';

  @override
  String get homeAddServiceBody =>
      'நீங்கள் வெளியிட்ட சேவைகளுக்கு மட்டுமே வாடிக்கையாளர்கள் உங்களை முன்பதிவு செய்ய முடியும்.';

  @override
  String get homeNotReady => 'இன்னும் முழுமையாகத் தயாராகவில்லை';

  @override
  String get homeNotReadyBody =>
      'இந்தப் படிகளை முடித்தால் வேலைகளைப் பெறத் தொடங்கலாம்.';

  @override
  String get homeGoodMorning => 'காலை வணக்கம்';

  @override
  String get homeGoodAfternoon => 'மதிய வணக்கம்';

  @override
  String get homeGoodEvening => 'மாலை வணக்கம்';

  @override
  String get homeNotifications => 'அறிவிப்புகள்';

  @override
  String get availabilityAvailable => 'கிடைக்கிறேன்';

  @override
  String get availabilityAvailableBody => 'நீங்கள் புதிய வேலைகளைப் பெறலாம்.';

  @override
  String get availabilityOnJob => 'வேலையில்';

  @override
  String get availabilityOnJobBody =>
      'இந்த வேலை முடியும் வரை புதிய வேலை வழங்கப்படாது.';

  @override
  String get availabilityOff => 'ஆஃப்';

  @override
  String get availabilityOffBody => 'உங்களுக்குப் புதிய வேலைகள் வராது.';

  @override
  String get availabilityFinishJob =>
      'மீண்டும் கிடைக்க உங்கள் தற்போதைய வேலையை முடிக்கவும்.';

  @override
  String get availabilityGoOff => 'பணியிலிருந்து விலகு';

  @override
  String get availabilityGoOn => 'கிடைப்பவராகு';

  @override
  String get availabilityBeforeJobs => 'வேலைகளைப் பெறுவதற்கு முன்';

  @override
  String get availabilityNowOn => 'நீங்கள் வேலைக்குக் கிடைக்கிறீர்கள்.';

  @override
  String get availabilityNowOff => 'நீங்கள் பணியில் இல்லை.';

  @override
  String get workerStatusSetupIncomplete => 'அமைப்பு முழுமையடையவில்லை';

  @override
  String get workerStatusUnderReview => 'பரிசீலனையில்';

  @override
  String get workerStatusInactive => 'செயலற்றது';

  @override
  String get workerStatusRestricted => 'கட்டுப்படுத்தப்பட்டது';

  @override
  String get workerStatusSuspended => 'இடைநீக்கம் செய்யப்பட்டது';

  @override
  String get homeAccount => 'கணக்கு';

  @override
  String get homeWorkStatus => 'வேலை நிலை';

  @override
  String get availabilityOffDuty => 'பணியில் இல்லை';

  @override
  String get earningsThisWeek => 'இந்த வாரம்';

  @override
  String get earningsThisMonth => 'இந்த மாதம்';

  @override
  String get jobNextWaitConfirm => 'வாடிக்கையாளர் உறுதிசெய்யக் காத்திருக்கிறது';

  @override
  String get jobNextStartTravel => 'பயணத்தைத் தொடங்கு';

  @override
  String get jobNextMarkArrived => 'வந்துவிட்டதாகக் குறி';

  @override
  String get jobNextStartWork => 'வேலையைத் தொடங்கு';

  @override
  String get jobNextAskCode => 'வாடிக்கையாளரிடம் வருகைக் குறியீட்டைக் கேள்';

  @override
  String get jobNextFinish => 'முடித்துப் புகைப்படங்களைச் சேர்';

  @override
  String get jobNextWaitApprove =>
      'வாடிக்கையாளர் ஒப்புதலுக்காகக் காத்திருக்கிறது';

  @override
  String get jobNextOpen => 'வேலையைத் திற';

  @override
  String get jobTimeTbc => 'நேரம் உறுதிசெய்யப்பட வேண்டும்';

  @override
  String get settingsTitle => 'அமைப்புகள்';

  @override
  String get settingsLanguage => 'மொழி';

  @override
  String get settingsAbout => 'பற்றி';

  @override
  String get settingsTerms => 'சேவை விதிமுறைகள்';

  @override
  String get settingsPrivacy => 'தனியுரிமைக் கொள்கை';

  @override
  String get settingsHelp => 'உதவி மற்றும் ஆதரவு';

  @override
  String get settingsDeleteAccount => 'என் கணக்கை நீக்கு';

  @override
  String get settingsSignOutTitle => 'வெளியேறவா?';

  @override
  String get settingsSignOutBody =>
      'மீண்டும் உள்நுழைய உங்கள் போன் எண்ணும் ஒரு குறியீடும் தேவைப்படும்.';

  @override
  String get settingsDeleteTitle => 'உங்கள் கணக்கை நீக்கு';

  @override
  String get settingsDeleteBody =>
      'கணக்கை நீக்குவது உங்கள் வேலை வரலாறு, வருமானப் பதிவுகள் மற்றும் திறந்த கட்டணங்களைப் பாதிக்கும், எனவே இது தானாக அல்லாமல் எங்கள் ஆதரவுக் குழுவால் கையாளப்படுகிறது.\n\nஆதரவுக் கோரிக்கை வையுங்கள், முடிந்ததும் உறுதிப்படுத்துவோம்.';

  @override
  String get settingsContactSupport => 'ஆதரவைத் தொடர்பு கொள்';

  @override
  String get notificationsMarkAllRead => 'அனைத்தையும் படித்ததாகக் குறி';

  @override
  String get notificationsEmpty => 'அனைத்தையும் பார்த்துவிட்டீர்கள்';

  @override
  String get notificationsEmptyBody =>
      'வேலைச் சலுகைகள், கட்டணப் புதுப்பிப்புகள் மற்றும் சரிபார்ப்பு முடிவுகள் இங்கே தோன்றும்.';

  @override
  String get jobsTabUpcoming => 'வரவிருப்பவை';

  @override
  String get jobsTabActive => 'செயலில்';

  @override
  String get jobsNoOffers => 'இப்போது புதிய வேலைகள் இல்லை';

  @override
  String get jobsNoOffersBody =>
      'நீங்கள் கிடைக்கும்போது, பொருத்தமான வேலை வந்தவுடன் உங்களுக்குத் தெரிவிப்போம்.';

  @override
  String get jobsAccepted => 'வேலை ஏற்கப்பட்டது.';

  @override
  String get jobsDeclineTitle => 'இந்த வேலையை மறுக்கவா?';

  @override
  String get jobsDeclineBody =>
      'இது வேறொரு பணியாளருக்கு வழங்கப்படும். அடிக்கடி மறுத்தால் உங்களுக்குக் காட்டப்படும் வேலைகள் குறையலாம்.';

  @override
  String get jobsDecline => 'மறு';

  @override
  String get jobsDeclined => 'வேலை மறுக்கப்பட்டது.';

  @override
  String get jobsEmptyUpcoming => 'எதுவும் திட்டமிடப்படவில்லை';

  @override
  String get jobsEmptyUpcomingBody => 'நீங்கள் ஏற்ற வேலைகள் இங்கே தோன்றும்.';

  @override
  String get jobsEmptyActive => 'எந்த வேலையும் நடக்கவில்லை';

  @override
  String get jobsEmptyActiveBody =>
      'நீங்கள் வேலையைத் தொடங்கும்போது அது இங்கே தோன்றும்.';

  @override
  String get jobsEmptyCompleted => 'இன்னும் முடிந்த வேலைகள் இல்லை';

  @override
  String get jobsEmptyCompletedBody =>
      'முடிந்த வேலைகளும் அவற்றிலிருந்து நீங்கள் சம்பாதித்ததும் இங்கே பட்டியலிடப்படும்.';

  @override
  String get jobsEmptyCancelled => 'எதுவும் ரத்தாகவில்லை';

  @override
  String get jobsEmptyCancelledBody => 'ரத்தான வேலைகள் இங்கே பட்டியலிடப்படும்.';

  @override
  String get jobsEmptyOffers => 'சலுகைகள் இல்லை';

  @override
  String get jobsEmptyOffersBody => 'புதிய வேலைகள் இங்கே தோன்றும்.';

  @override
  String get jobTitleFallback => 'வேலை';

  @override
  String jobCancelledReason(Object reason) {
    return 'ரத்துசெய்யப்பட்டது: $reason';
  }

  @override
  String get jobAmount => 'வேலைத் தொகை';

  @override
  String get jobMaterials => 'பொருட்கள்';

  @override
  String get jobYouEarned => 'நீங்கள் சம்பாதித்தது';

  @override
  String get jobRateCustomer => 'வாடிக்கையாளரை மதிப்பிடு';

  @override
  String get jobRateQuestion => 'இந்த வேலை உங்களுக்கு எப்படி இருந்தது?';

  @override
  String get jobRate => 'மதிப்பிடு';

  @override
  String get jobHistory => 'என்ன நடந்தது';

  @override
  String get jobHistoryLoadFailed => 'வேலை வரலாற்றை ஏற்ற முடியவில்லை.';

  @override
  String get jobOfferExpired => 'இந்த வேலை இப்போது கிடைக்கவில்லை.';

  @override
  String get jobOfferNewBadge => 'புதிய வேலை';

  @override
  String get jobOfferYouEarn => 'உங்கள் வருமானம்';

  @override
  String get jobOfferPriceAfterVisit => 'வருகைக்குப் பின் உறுதிசெய்யப்படும்';

  @override
  String get jobOfferAccept => 'வேலையை ஏற்கவும்';

  @override
  String get activeJobTitle => 'தற்போதைய வேலை';

  @override
  String get activeJobEmptyBody =>
      'நீங்கள் வேலையை ஏற்றுத் தொடங்கும்போது அது இங்கே தோன்றும்.';

  @override
  String get evidenceBeforeTitle => 'தொடங்கும் முன்';

  @override
  String get evidenceBeforeBody =>
      'தொடுவதற்கு முன் பிரச்சினையைப் புகைப்படம் எடுங்கள். வாடிக்கையாளர் பின்னர் வேலையில் சர்ச்சை செய்தால் இது உங்களைப் பாதுகாக்கும்.';

  @override
  String get evidenceAfterTitle => 'முடித்த பின்';

  @override
  String get evidenceAfterBody =>
      'வாடிக்கையாளர் பின்னர் சர்ச்சை செய்தால் முடிந்த வேலையின் புகைப்படமே உங்கள் ஆதாரம். விருப்பத்தேர்வு, ஆனால் பத்து வினாடிகள் செலவிடத் தகுந்தது.';

  @override
  String get jobCustomerHidden =>
      'உறுதிசெய்யப்பட்டதும் வாடிக்கையாளர் விவரங்கள் பகிரப்படும்';

  @override
  String get jobCall => 'அழை';

  @override
  String get jobDirections => 'வழிகாட்டுதல்';

  @override
  String get jobTrackOnMap => 'வரைபடத்தில் கண்காணி';

  @override
  String get trailAccepted => 'ஏற்கப்பட்டது';

  @override
  String get trailOnTheWay => 'வழியில் உள்ளார்';

  @override
  String get trailArrived => 'வந்துவிட்டார்';

  @override
  String get trailArrivalConfirmed => 'வருகை உறுதிசெய்யப்பட்டது';

  @override
  String get trailWorkStarted => 'வேலை தொடங்கியது';

  @override
  String get trailFinished => 'முடிந்தது';

  @override
  String get jobProgress => 'முன்னேற்றம்';

  @override
  String get jobBeforeFinish => 'முடிப்பதற்கு முன்';

  @override
  String get jobActionStartTravel => 'பயணத்தைத் தொடங்கு';

  @override
  String get jobActionArrived => 'நான் வந்துவிட்டேன்';

  @override
  String get jobActionEnterCode => 'வருகைக் குறியீட்டை உள்ளிடு';

  @override
  String get jobActionStartWork => 'வேலையைத் தொடங்கு';

  @override
  String get jobActionFinish => 'வேலையை முடி';

  @override
  String get jobArrivalConfirmed => 'வருகை உறுதிசெய்யப்பட்டது.';

  @override
  String get jobFinishTitle => 'இந்த வேலையை முடிக்கவா?';

  @override
  String get jobFinishBody =>
      'வேலைக்கு ஒப்புதல் அளிக்குமாறு வாடிக்கையாளரிடம் கேட்கப்படும். அதன் பிறகு புகைப்படங்களைச் சேர்க்க முடியாது.';

  @override
  String get jobOnYourWay => 'நீங்கள் வழியில் உள்ளீர்கள்.';

  @override
  String get jobMarkedArrived => 'வந்துவிட்டதாகக் குறிக்கப்பட்டது.';

  @override
  String get jobWorkStarted => 'வேலை தொடங்கியது.';

  @override
  String get jobSentForApproval =>
      'ஒப்புதலுக்காக வாடிக்கையாளருக்கு அனுப்பப்பட்டது.';

  @override
  String get jobUpdated => 'புதுப்பிக்கப்பட்டது.';

  @override
  String get jobWaitConfirm =>
      'வாடிக்கையாளர் முன்பதிவை உறுதிசெய்யக் காத்திருக்கிறது.';

  @override
  String get jobWaitApprove =>
      'வாடிக்கையாளர் உங்கள் வேலைக்கு ஒப்புதல் அளிக்கக் காத்திருக்கிறது.';

  @override
  String get jobWaitPaymentProcessing =>
      'ஒப்புதல் அளிக்கப்பட்டது. கட்டணம் செயலாக்கத்தில் உள்ளது.';

  @override
  String get jobWaitPayment =>
      'வாடிக்கையாளரின் கட்டணத்திற்காகக் காத்திருக்கிறது.';

  @override
  String get jobWaitPaid =>
      'செலுத்தப்பட்டது. உங்கள் வருமானம் வாலெட்டில் தோன்றும்.';

  @override
  String get jobWaitDisputed =>
      'இந்த வேலையை எங்கள் குழு பரிசீலிக்கிறது. நாங்கள் தொடர்பு கொள்வோம்.';

  @override
  String get jobWaitNothing => 'இப்போது செய்ய எதுவும் இல்லை.';

  @override
  String get travelRouteUnavailable => 'வழி கிடைக்கவில்லை';

  @override
  String get travelNoDestination => 'சேருமிடம் அமைக்கப்படவில்லை';

  @override
  String get travelNoDestinationBody =>
      'இந்த வேலைக்கு வழிகாட்ட சேவை இடம் இல்லை.';

  @override
  String get travelJobLocation => 'வேலை இடம்';

  @override
  String get travelYou => 'நீங்கள்';

  @override
  String get travelCustomer => 'வாடிக்கையாளர்';

  @override
  String get travelCalculating => 'வழியைக் கணக்கிடுகிறது...';

  @override
  String distanceMetres(Object metres) {
    return '$metres மீ';
  }

  @override
  String etaMinutes(Object minutes) {
    return '$minutes நிமி';
  }

  @override
  String etaHours(Object hours) {
    return '$hours மணி';
  }

  @override
  String get arrivalWrongCode => 'அந்தக் குறியீடு தவறானது.';

  @override
  String arrivalWrongCodeAttempts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'அந்தக் குறியீடு தவறானது. $count முயற்சிகள் மீதமுள்ளன.',
      one: 'அந்தக் குறியீடு தவறானது. 1 முயற்சி மீதமுள்ளது.',
    );
    return '$_temp0';
  }

  @override
  String get arrivalTitle => 'நீங்கள் வந்ததை உறுதிசெய்யவும்';

  @override
  String get arrivalBody =>
      'வாடிக்கையாளரிடம் அவரது ஆப்பில் உள்ள குறியீட்டைப் படிக்கச் சொல்லி, இங்கே தட்டச்சு செய்யவும்.';

  @override
  String get arrivalLocked =>
      'பல தவறான குறியீடுகள். இந்த வேலையைத் தொடர ஆதரவைத் தொடர்பு கொள்ளவும்.';

  @override
  String get arrivalConfirm => 'வருகையை உறுதிசெய்';

  @override
  String get arrivalNotYet => 'இன்னும் இல்லை';

  @override
  String get rateThanks => 'உங்கள் கருத்துக்கு நன்றி.';

  @override
  String get rateTitle => 'இந்த வாடிக்கையாளர் எப்படி இருந்தார்?';

  @override
  String get rateBody =>
      'உங்கள் மதிப்பீடு தனிப்பட்டது, பணியாளர்களைக் கவனித்துக்கொள்ள எங்களுக்கு உதவுகிறது.';

  @override
  String get rateCommentLabel =>
      'வேறு ஏதாவது சொல்ல வேண்டுமா? (விருப்பத்தேர்வு)';

  @override
  String get rateSubmit => 'மதிப்பீட்டைச் சமர்ப்பி';

  @override
  String get timerServiceTime => 'சேவை நேரம்';

  @override
  String get materialsAdd => 'சேர்';

  @override
  String get materialsLoadFailed => 'பொருட்களை ஏற்ற முடியவில்லை.';

  @override
  String get materialsEmpty =>
      'இந்த வேலைக்கு உதிரிபாகங்கள் தேவைப்பட்டால் இங்கே சேர்க்கவும், செலவுக்கு ஒப்புதல் அளிக்குமாறு வாடிக்கையாளரிடம் கேட்கப்படும்.';

  @override
  String get materialStatusWaiting => 'வாடிக்கையாளருக்காகக் காத்திருக்கிறது';

  @override
  String get materialStatusApproved => 'ஒப்புதல் பெற்றது';

  @override
  String get materialStatusDeclined => 'மறுக்கப்பட்டது';

  @override
  String get materialStatusBought => 'வாங்கப்பட்டது';

  @override
  String get materialStatusCostRecorded => 'செலவு பதிவானது';

  @override
  String get materialStatusBilled => 'பில்லில் உள்ளது';

  @override
  String get materialStatusCancelled => 'ரத்தானது';

  @override
  String materialQuantityEstimated(Object quantity, Object unit) {
    return '$quantity $unit · மதிப்பீடு';
  }

  @override
  String materialQuantityActual(Object quantity, Object unit) {
    return '$quantity $unit · உண்மை';
  }

  @override
  String get materialRecordCost => 'செலவைப் பதிவு செய்';

  @override
  String materialCustomerSaid(Object reason) {
    return 'வாடிக்கையாளர் சொன்னது: $reason';
  }

  @override
  String get materialUnitPiece => 'எண்ணிக்கை';

  @override
  String get materialWhatNeeded => 'உங்களுக்கு என்ன தேவை?';

  @override
  String get materialEnterQuantity => 'எத்தனை என்பதை உள்ளிடவும்';

  @override
  String get materialEnterCost => 'மதிப்பிடப்பட்ட செலவை உள்ளிடவும்';

  @override
  String get materialRequestBody =>
      'நீங்கள் வாங்கும் முன் இதற்கு ஒப்புதல் அளிக்குமாறு வாடிக்கையாளரிடம் கேட்கப்படும்.';

  @override
  String get materialName => 'பொருள்';

  @override
  String get materialNameHint => 'எ.கா. 16A மாடுலர் சுவிட்ச்';

  @override
  String get materialQuantity => 'அளவு';

  @override
  String get materialUnit => 'அலகு';

  @override
  String get materialExpectedCost => 'மதிப்பிடப்பட்ட செலவு';

  @override
  String get materialAskCustomer => 'வாடிக்கையாளரிடம் கேள்';

  @override
  String get materialEnterPaid => 'நீங்கள் செலுத்திய தொகையை உள்ளிடவும்';

  @override
  String get materialCostRecorded => 'செலவு பதிவு செய்யப்பட்டது.';

  @override
  String get materialWhatCost => 'இதற்கு எவ்வளவு செலவானது?';

  @override
  String get materialReceiptBody =>
      'வாடிக்கையாளரின் பில்லில் சேர்க்க ரசீதை இணைக்கவும்.';

  @override
  String get materialAmountPaid => 'செலுத்திய தொகை';

  @override
  String get materialReceipt => 'ரசீது';

  @override
  String get materialReceiptRequired => 'பில்லின் புகைப்படம் அவசியம்.';

  @override
  String get evidenceDone => 'முடிந்தது';

  @override
  String get evidenceRequired => 'அவசியம்';

  @override
  String get evidenceCamera => 'கேமரா';

  @override
  String get evidenceGallery => 'கேலரி';

  @override
  String get evidenceSaved => 'சேமிக்கப்பட்டது';

  @override
  String get uploadWaiting => 'காத்திருக்கிறது';

  @override
  String get uploadPreparing => 'தயாராகிறது';

  @override
  String get uploadStarting => 'பதிவேற்றம் தொடங்குகிறது';

  @override
  String uploadPercent(Object percent) {
    return '$percent%';
  }

  @override
  String get uploadFinishing => 'முடிக்கிறது';

  @override
  String get uploadCancel => 'பதிவேற்றத்தை ரத்துசெய்';

  @override
  String get uploadNotFinished => 'அந்தப் பதிவேற்றம் முடியவில்லை.';

  @override
  String get commonRetry => 'மீண்டும் முயலவும்';

  @override
  String durationMinutes(Object minutes) {
    return '$minutes நிமி';
  }

  @override
  String durationHours(Object hours) {
    return '$hours மணி';
  }

  @override
  String durationHoursMinutes(Object hours, Object minutes) {
    return '$hours மணி $minutes நிமி';
  }

  @override
  String durationDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count நாட்கள்',
      one: '1 நாள்',
    );
    return '$_temp0';
  }

  @override
  String pricePerHour(Object price) {
    return '$price/மணி';
  }

  @override
  String pricePerDay(Object price) {
    return '$price/நாள்';
  }

  @override
  String pricePerUnit(Object price) {
    return '$price/யூனிட்';
  }

  @override
  String pricePerSqft(Object price) {
    return '$price/ச.அடி';
  }

  @override
  String get gigsTitle => 'என் சேவைகள்';

  @override
  String get gigsAddTooltip => 'சேவையைச் சேர்';

  @override
  String get gigsAdd => 'சேவையைச் சேர்';

  @override
  String get gigsEmpty => 'இன்னும் சேவைகள் இல்லை';

  @override
  String get gigsEmptyBody =>
      'நீங்கள் வழங்கும் சேவைகளைச் சேர்க்கவும். உங்களுக்கு ஒப்புதல் உள்ள அனைத்துத் தொழில்களிலும் விரும்பிய அளவு சேவைகளைச் சேர்க்கலாம்.';

  @override
  String get gigsNoneLive =>
      'உங்கள் சேவைகள் எதுவும் நேரலையில் இல்லை, எனவே வாடிக்கையாளர்கள் உங்களை முன்பதிவு செய்ய முடியாது.';

  @override
  String gigsLiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count சேவைகள் நேரலையில் உள்ளன.',
      one: '1 சேவை நேரலையில் உள்ளது.',
    );
    return '$_temp0';
  }

  @override
  String get gigsAvailable => 'நீங்கள் வேலைக்குக் கிடைக்கிறீர்கள்.';

  @override
  String get gigsOffDuty =>
      'நீங்கள் பணியில் இல்லை, எனவே உங்களுக்கு வேலைகள் வழங்கப்படாது.';

  @override
  String gigJobsDone(int count) {
    return '$count முடிந்தன';
  }

  @override
  String get gigEdit => 'திருத்து';

  @override
  String get gigPause => 'இடைநிறுத்து';

  @override
  String get gigResume => 'மீண்டும் தொடங்கு';

  @override
  String get gigInReview => 'பரிசீலனையில்';

  @override
  String get gigDraftHint => 'வரைவு — பரிசீலனைக்குச் சமர்ப்பிக்கவும்';

  @override
  String get gigRejectedHint =>
      'நிராகரிக்கப்பட்டது — திருத்தி மீண்டும் சமர்ப்பிக்கவும்';

  @override
  String get gigArchived => 'காப்பகப்படுத்தப்பட்டது';

  @override
  String get gigNotLive => 'நேரலையில் இல்லை';

  @override
  String get gigPaused =>
      'இடைநிறுத்தப்பட்டது. இந்த வேலைகள் உங்களுக்கு வழங்கப்படாது.';

  @override
  String get gigLiveAgain => 'மீண்டும் நேரலையில்.';

  @override
  String get gigDuration30m => '30 நிமிடங்கள்';

  @override
  String get gigDuration45m => '45 நிமிடங்கள்';

  @override
  String get gigDuration1h => '1 மணிநேரம்';

  @override
  String get gigDuration2h => '2 மணிநேரம்';

  @override
  String get gigDuration4h => '4 மணிநேரம்';

  @override
  String get gigDuration8h => '8 மணிநேரம் (ஒரு வேலை நாள்)';

  @override
  String get gigDuration24h => '24 மணிநேரம்';

  @override
  String get gigDuration2d => '2 நாட்கள்';

  @override
  String get gigDuration3d => '3 நாட்கள்';

  @override
  String get gigDuration1w => '1 வாரம்';

  @override
  String get gigSavedDraft => 'வரைவாகச் சேமிக்கப்பட்டது.';

  @override
  String get gigSubmitted => 'சமர்ப்பிக்கப்பட்டது. பரிசீலித்துத் தெரிவிப்போம்.';

  @override
  String get gigLive => 'உங்கள் சேவை நேரலையில் உள்ளது.';

  @override
  String get gigSaved => 'சேமிக்கப்பட்டது.';

  @override
  String get gigEditorAddTitle => 'சேவையைச் சேர்';

  @override
  String get gigEditorEditTitle => 'சேவையைத் திருத்து';

  @override
  String get gigNoTrades => 'இன்னும் ஒப்புதல் பெற்ற தொழில்கள் இல்லை';

  @override
  String get gigNoTradesBody =>
      'ஒரு தொழிலுக்கு உங்களுக்கு ஒப்புதல் கிடைத்ததும், அதன் கீழ் சேவைகளை வெளியிடலாம். தொடங்க உங்கள் சுயவிவரத்திலிருந்து ஒரு தொழிலைச் சேர்க்கவும்.';

  @override
  String get gigFieldTrade => 'எந்தத் தொழில்?';

  @override
  String get gigFieldTitle => 'இந்தச் சேவையின் பெயர் என்ன?';

  @override
  String get gigFieldTitleHint =>
      'வாடிக்கையாளர்கள் இதைப் பார்ப்பார்கள். குறிப்பாக எழுதுங்கள்.';

  @override
  String get gigFieldTitleExample => 'எ.கா. ஸ்பிளிட் AC ஆழமான சுத்தம்';

  @override
  String get gigFieldDescription => 'இதில் என்னென்ன அடங்கும்?';

  @override
  String get gigFieldDescriptionHint =>
      'விருப்பத்தேர்வு, ஆனால் வாடிக்கையாளர்கள் உங்களைத் தேர்ந்தெடுக்க உதவும்.';

  @override
  String get gigFieldDescriptionExample =>
      'எ.கா. உட்புற மற்றும் வெளிப்புற யூனிட் முழுச் சுத்தம், ஃபில்டர் கழுவுதல், கேஸ் அழுத்தச் சோதனை.';

  @override
  String get gigFieldPrice => 'நீங்கள் எவ்வளவு வசூலிக்கிறீர்கள்?';

  @override
  String get gigFieldPriceHint =>
      'ஒவ்வொரு சேவைக்கும் தனி விலை உண்டு. இது உங்கள் மற்ற சேவைகளைப் பாதிக்காது.';

  @override
  String get gigUnitPerJob => 'ஒரு வேலைக்கு';

  @override
  String get gigUnitPerHour => 'மணிக்கு';

  @override
  String get gigUnitPerDay => 'நாளுக்கு';

  @override
  String get gigUnitPerUnit => 'யூனிட்டுக்கு';

  @override
  String get gigUnitPerSqft => 'சதுர அடிக்கு';

  @override
  String get gigFieldDuration => 'இதற்கு வழக்கமாக எவ்வளவு நேரம் ஆகும்?';

  @override
  String get gigFieldRadius => 'இதற்காக எவ்வளவு தூரம் பயணிப்பீர்கள்?';

  @override
  String get gigFieldRadiusHint =>
      'உங்கள் வழக்கமான பயணத் தூரத்தைப் பயன்படுத்த இயல்புநிலையில் விடவும்.';

  @override
  String get gigUsualDistance => 'உங்கள் வழக்கமான தூரம்';

  @override
  String get gigUseUsualDistance => 'என் வழக்கமான தூரத்தைப் பயன்படுத்து';

  @override
  String get gigReviewNotice =>
      'புதிய மற்றும் திருத்தப்பட்ட சேவைகள் நேரலைக்கு வரும் முன் எங்கள் குழு சரிபார்க்கும். முடிந்தவுடன் தெரிவிப்போம்.';

  @override
  String get gigSaveDraft => 'வரைவைச் சேமி';

  @override
  String get gigSubmitForReview => 'பரிசீலனைக்குச் சமர்ப்பி';

  @override
  String get walletAllTransactions => 'அனைத்துப் பரிவர்த்தனைகள்';

  @override
  String get walletFrozen =>
      'ஒரு விஷயத்தை ஆராயும் வரை பணம் எடுத்தல் நிறுத்திவைக்கப்பட்டுள்ளது. விவரங்களுக்கு ஆதரவைத் தொடர்பு கொள்ளவும்.';

  @override
  String get walletWithdraw => 'பணம் எடு';

  @override
  String walletNothingPending(Object amount) {
    return 'இன்னும் எடுக்க எதுவும் இல்லை. $amount இன்னும் செயலாக்கத்தில் உள்ளது, அந்த வேலைகளுக்கு ஒப்புதல் கிடைத்ததும் உங்கள் இருப்புக்கு வரும்.';
  }

  @override
  String get walletNothingYet =>
      'இன்னும் எடுக்க எதுவும் இல்லை. வாடிக்கையாளர் முடிந்த வேலைக்கு ஒப்புதல் அளித்ததும் உங்கள் வருமானம் இங்கே தோன்றும்.';

  @override
  String get walletRecentEarnings => 'சமீபத்திய வருமானம்';

  @override
  String get walletNoEarnings => 'இன்னும் வருமானம் இல்லை';

  @override
  String get walletNoEarningsBody =>
      'முடிந்த வேலைக்குக் கட்டணம் செலுத்தப்பட்டதும் உங்கள் வருமானம் இங்கே தோன்றும்.';

  @override
  String get walletAvailable => 'எடுக்கக் கிடைப்பது';

  @override
  String get walletProcessing => 'செயலாக்கத்தில்';

  @override
  String get walletProcessingHint =>
      'நிறுத்திவைப்புக் காலத்திற்குப் பிறகு விடுவிக்கப்படும்';

  @override
  String get walletTotalEarned => 'மொத்த வருமானம்';

  @override
  String get statementTitle => 'அறிக்கை';

  @override
  String get statementTabTransactions => 'பரிவர்த்தனைகள்';

  @override
  String get statementTabWithdrawals => 'பணம் எடுத்தல்கள்';

  @override
  String get statementEmpty => 'இன்னும் எதுவும் இல்லை';

  @override
  String get statementEmptyBody =>
      'நீங்கள் வேலை செய்யத் தொடங்கியதும் ஒவ்வொரு கட்டணம், கட்டணக் கழிவு மற்றும் பணம் எடுத்தலும் இங்கே பட்டியலிடப்படும்.';

  @override
  String statementBalance(Object amount) {
    return 'இருப்பு $amount';
  }

  @override
  String get statementNoWithdrawals => 'இன்னும் பணம் எடுக்கவில்லை';

  @override
  String get statementNoWithdrawalsBody =>
      'நீங்கள் பணம் எடுக்கும்போது அது இங்கே கண்காணிக்கப்படும்.';

  @override
  String payoutRequestedAt(Object date) {
    return '$date அன்று கோரப்பட்டது';
  }

  @override
  String payoutPaidAt(Object date) {
    return '$date அன்று செலுத்தப்பட்டது';
  }

  @override
  String get payoutEnterAmount =>
      'எவ்வளவு எடுக்க விரும்புகிறீர்கள் என்பதை உள்ளிடவும்';

  @override
  String payoutUpTo(Object amount) {
    return 'இப்போது $amount வரை எடுக்கலாம்';
  }

  @override
  String payoutMinimum(Object amount) {
    return 'குறைந்தபட்ச பணம் எடுத்தல் $amount';
  }

  @override
  String payoutRequested(Object amount) {
    return '$amount எடுக்கக் கோரப்பட்டது. செயலாக்கத்தின்போது தெரிவித்துக்கொண்டிருப்போம்.';
  }

  @override
  String get payoutAvailableNow => 'இப்போது கிடைப்பது';

  @override
  String payoutPendingMore(Object amount) {
    return 'மேலும் $amount இன்னும் செயலாக்கத்தில் உள்ளது, இப்போது எடுக்க முடியாது.';
  }

  @override
  String get payoutHowMuch => 'எவ்வளவு?';

  @override
  String get payoutAll => 'அனைத்தும்';

  @override
  String payoutPercent(Object percent) {
    return '$percent%';
  }

  @override
  String get payoutProcessNotice =>
      'பணம் எடுத்தல்கள் சரிபார்க்கப்பட்டு உங்கள் பதிவுசெய்த வங்கிக் கணக்குக்கு அனுப்பப்படும். ஒவ்வொரு படியிலும் நிலையை இங்கே காணலாம்.';

  @override
  String get payoutRequest => 'பணம் எடுக்கக் கோரு';

  @override
  String get bankChecking => 'உங்கள் வங்கிக் கணக்கைச் சரிபார்க்கிறது…';

  @override
  String bankPaidTo(Object last4) {
    return '$last4 இல் முடியும் கணக்குக்குச் செலுத்தப்படும்';
  }

  @override
  String get bankVerifiedFallback => 'உங்கள் சரிபார்க்கப்பட்ட வங்கிக் கணக்கு';

  @override
  String get bankBeingVerified => 'வங்கிக் கணக்கு சரிபார்க்கப்படுகிறது';

  @override
  String get bankBeingVerifiedBody =>
      'எங்கள் குழு சரிபார்த்ததும் நீங்கள் பணம் எடுக்கலாம்.';

  @override
  String get bankNotVerified => 'வங்கிக் கணக்கு சரிபார்க்கப்படவில்லை';

  @override
  String get bankNotVerifiedBody =>
      'உங்கள் விவரங்களைச் சரிபார்த்து மீண்டும் சமர்ப்பிக்கவும்.';

  @override
  String get bankAddTitle => 'வங்கிக் கணக்கைச் சேர்';

  @override
  String get bankAddBody =>
      'எங்கள் குழு சரிபார்த்த வங்கிக் கணக்குக்கே பணம் அனுப்பப்படும்.';

  @override
  String get bankAddAction => 'வங்கிக் கணக்கைச் சேர்';

  @override
  String get verificationTitle => 'சரிபார்ப்பு';

  @override
  String get verificationProgress => 'சரிபார்க்கப்பட்ட சோதனைகள்';

  @override
  String verificationCount(int approved, int total) {
    return '$total-இல் $approved';
  }

  @override
  String get verificationInsurance => 'காப்பீடு';

  @override
  String get verificationNoCover => 'செயலில் உள்ள காப்பீடு இல்லை';

  @override
  String get verificationNoCoverBody =>
      'தற்போது எங்களிடம் உங்கள் காப்பீட்டுப் பாலிசி எதுவும் பதிவில் இல்லை.';

  @override
  String get verifyIdentity => 'அடையாளம்';

  @override
  String get verifyIdentityBody =>
      'அரசு அடையாள அட்டை, தங்கள் வீட்டுக்கு யார் வருகிறார்கள் என்று வாடிக்கையாளர்கள் அறிய.';

  @override
  String get verifyAddress => 'முகவரி';

  @override
  String get verifyAddressBody => 'நீங்கள் வசிக்கும் இடத்திற்கான சான்று.';

  @override
  String get verifyIti => 'ITI சான்றிதழ்';

  @override
  String get verifyItiBody =>
      'தொழிற்பயிற்சி நிலையத்திலிருந்து (ITI) உங்கள் தொழில் சான்றிதழ்.';

  @override
  String get verifyDiploma => 'டிப்ளோமா';

  @override
  String get verifyDiplomaBody => 'அங்கீகரிக்கப்பட்ட தொழில்நுட்ப டிப்ளோமா.';

  @override
  String get verifyRpl => 'திறன் மதிப்பீடு';

  @override
  String get verifyRplBody =>
      'முன் கற்றல் அங்கீகாரம் (RPL): உங்கள் அனுபவம் மதிப்பிடப்பட்டுச் சான்றளிக்கப்படுகிறது.';

  @override
  String get verifyBackground => 'பின்னணிச் சோதனை';

  @override
  String get verifyBackgroundBody =>
      'இதை நாங்களே செய்கிறோம். நீங்கள் எதுவும் செய்ய வேண்டியதில்லை.';

  @override
  String get verifyInsuranceBody =>
      'வேலை செய்யும்போது ஏற்படும் விபத்துச் சேதத்திற்கான காப்பீடு. ஏற்பாடானதும் எங்கள் குழு உங்கள் பாலிசியைச் சேர்க்கும்.';

  @override
  String get verifyBank => 'வங்கிக் கணக்கு';

  @override
  String get verifyBankBody => 'உங்கள் பணம் எடுத்தல்கள் செலுத்தப்படும் இடம்.';

  @override
  String verificationValidUntil(Object date) {
    return '$date வரை செல்லும்';
  }

  @override
  String get verificationStart => 'தொடங்கு';

  @override
  String get verificationUpdate => 'புதுப்பி';

  @override
  String get policyActive => 'செயலில்';

  @override
  String get policyNotActive => 'செயலில் இல்லை';

  @override
  String get policyNumber => 'பாலிசி';

  @override
  String get policyCover => 'காப்பீட்டுத் தொகை';

  @override
  String get policyValidUntil => 'வரை செல்லும்';

  @override
  String get kycStillWaiting =>
      'இன்னும் DigiLocker-க்காகக் காத்திருக்கிறது. பின்னர் இங்கிருந்து மீண்டும் பார்க்கலாம்.';

  @override
  String get kycTitle => 'அடையாளச் சரிபார்ப்பு';

  @override
  String get kycHeadline => 'நீங்கள் யார் என்பதை உறுதிசெய்யவும்';

  @override
  String get kycIntro =>
      'வாடிக்கையாளர்கள் உங்களைத் தங்கள் வீடுகளுக்குள் அனுமதிக்கிறார்கள், எனவே ஒவ்வொரு பணியாளரின் அடையாளத்தையும் இந்திய அரசின் ஆவணத் தளமான DigiLocker மூலம் சரிபார்க்கிறோம். எதுவும் பதிவேற்றப்படாது — உங்கள் ஆதார் கணக்கில் கோரிக்கைக்கு ஒப்புதல் அளித்தால் போதும்.';

  @override
  String get kycPrivacy =>
      'உங்கள் ஆதார் விவரங்கள் நேரடியாக DigiLocker உடன் உறுதிசெய்யப்படுகின்றன. சோதனை நடந்தது என்பதை நிரூபிப்பதை மட்டுமே சேமிக்கிறோம் — உங்கள் புகைப்படம் அல்லது ஆதார் நகலை ஒருபோதும் இல்லை.';

  @override
  String get kycVerified => 'உங்கள் அடையாளம் சரிபார்க்கப்பட்டது.';

  @override
  String get kycAwaitingConsent =>
      'உங்கள் உலாவியில் DigiLocker ஒப்புதலை முடித்து, இங்கே திரும்பி வாருங்கள்.';

  @override
  String get kycChecking => 'DigiLocker உடன் சரிபார்க்கிறது…';

  @override
  String get kycStart => 'DigiLocker மூலம் சரிபார்';

  @override
  String get qualSubmitted => 'பரிசீலனைக்குச் சமர்ப்பிக்கப்பட்டது.';

  @override
  String get qualTitle => 'உங்கள் தகுதி';

  @override
  String get qualIti => 'ITI';

  @override
  String get qualInstitute => 'நிறுவனம்';

  @override
  String get qualInstituteHint => 'எ.கா. அரசு ITI, கோயம்புத்தூர்';

  @override
  String get qualName => 'தகுதி';

  @override
  String get qualNameHint => 'எ.கா. எலக்ட்ரீஷியன்';

  @override
  String get qualSpeciality => 'சிறப்புத் திறன் (விருப்பத்தேர்வு)';

  @override
  String get qualSpecialityHint => 'எ.கா. தொழிற்சாலை வயரிங்';

  @override
  String get qualYear => 'முடித்த ஆண்டு';

  @override
  String get qualCertificate => 'உங்கள் சான்றிதழ்';

  @override
  String get qualCertificateBody =>
      'சான்றிதழின் தெளிவான புகைப்படம் அல்லது PDF.';

  @override
  String get bankErrorHolder => 'கணக்கில் உள்ளபடியே பெயரை உள்ளிடவும்';

  @override
  String get bankErrorNumber => 'கணக்கு எண் 9 முதல் 18 இலக்கங்கள் கொண்டது';

  @override
  String get bankErrorMismatch => 'கணக்கு எண்கள் பொருந்தவில்லை';

  @override
  String get bankErrorIfsc => '11 எழுத்து IFSC-ஐ உள்ளிடவும், எ.கா. SBIN0001234';

  @override
  String get bankSent => 'வங்கிக் கணக்கு சரிபார்ப்புக்கு அனுப்பப்பட்டது.';

  @override
  String get bankNotice =>
      'உங்கள் பணம் எடுத்தல்கள் இந்தக் கணக்குக்குச் செலுத்தப்படும். முதல் பேஅவுட்டுக்கு முன் எங்கள் குழு இதைச் சரிபார்க்கும்.';

  @override
  String get bankHolder => 'கணக்கு வைத்திருப்பவர் பெயர்';

  @override
  String get bankNumber => 'கணக்கு எண்';

  @override
  String get bankConfirmNumber => 'கணக்கு எண்ணை மீண்டும் உள்ளிடவும்';

  @override
  String get bankIfsc => 'IFSC குறியீடு';

  @override
  String get bankIfscHint => 'எ.கா. SBIN0001234';

  @override
  String get bankName => 'வங்கியின் பெயர் (விருப்பத்தேர்வு)';

  @override
  String get bankSubmit => 'சரிபார்ப்புக்குச் சமர்ப்பி';

  @override
  String get profileCompleteness => 'சுயவிவர நிறைவு';

  @override
  String get profileCompletenessBody =>
      'முழுமையான சுயவிவரம் வாடிக்கையாளர்கள் உங்களைத் தேர்ந்தெடுக்க உதவுகிறது.';

  @override
  String get profileJobsDone => 'முடிந்த வேலைகள்';

  @override
  String get profileRating => 'மதிப்பீடு';

  @override
  String get profileExperience => 'அனுபவம்';

  @override
  String profileExperienceYears(Object years) {
    return '$years ஆண்டு';
  }

  @override
  String get profileEdit => 'சுயவிவரத்தைத் திருத்து';

  @override
  String get profileVerified => 'சரிபார்க்கப்பட்டது';

  @override
  String get profileNotVerified => 'சரிபார்க்கப்படவில்லை';

  @override
  String get profilePinInvalid => 'சரியான 6 இலக்க பின் குறியீட்டை உள்ளிடவும்';

  @override
  String get profileUpdated => 'சுயவிவரம் புதுப்பிக்கப்பட்டது.';

  @override
  String get profilePhotoUpdated => 'புகைப்படம் புதுப்பிக்கப்பட்டது.';

  @override
  String get profileChangePhoto => 'புகைப்படத்தை மாற்று';

  @override
  String get profileName => 'பெயர்';

  @override
  String get profilePhone => 'போன்';

  @override
  String get profileLockedNotice =>
      'உங்கள் பெயரும் எண்ணும் அடையாளச் சரிபார்ப்புடன் இணைக்கப்பட்டுள்ளன. இவற்றில் எதையாவது மாற்ற ஆதரவைத் தொடர்பு கொள்ளவும்.';

  @override
  String get profileAbout => 'உங்களைப் பற்றி';

  @override
  String get profileBioHint =>
      'உங்கள் அனுபவம் மற்றும் நீங்கள் சிறந்து விளங்கும் விஷயங்களை வாடிக்கையாளர்களுக்குச் சொல்லுங்கள்.';

  @override
  String get profileYearsExperience => 'அனுபவ ஆண்டுகள்';

  @override
  String get profileBased => 'நீங்கள் எங்கே வசிக்கிறீர்கள்';

  @override
  String get profileAddress => 'முகவரி';

  @override
  String get profileCity => 'நகரம்';

  @override
  String get profilePin => 'பின் குறியீடு';

  @override
  String get profileGender => 'பாலினம்';

  @override
  String get genderMale => 'ஆண்';

  @override
  String get genderFemale => 'பெண்';

  @override
  String get genderOther => 'மற்றவை';

  @override
  String get profileTrades => 'உங்கள் தொழில்கள்';

  @override
  String get profileTradesBody =>
      'உங்களுக்கு ஒப்புதல் உள்ள அனைத்துத் தொழில்களிலும் வேலை செய்யலாம்.';

  @override
  String get profileTradesLoadFailed => 'உங்கள் தொழில்களை ஏற்ற முடியவில்லை.';

  @override
  String get tradePending => 'நிலுவையில்';

  @override
  String get profileAddTrade => 'தொழிலைச் சேர்';

  @override
  String get profileAddTradeBody =>
      'ஒப்புதல் அளிக்கும் முன் உங்கள் திறன்களுக்கான சான்றைக் கேட்கலாம்.';

  @override
  String get profileTradeRequested =>
      'கோரப்பட்டது. ஒப்புதல் கிடைத்ததும் தெரிவிப்போம்.';

  @override
  String get profileSave => 'மாற்றங்களைச் சேமி';

  @override
  String get supportNewRequest => 'புதிய கோரிக்கை';

  @override
  String get supportEmpty => 'இன்னும் கோரிக்கைகள் இல்லை';

  @override
  String get supportEmptyBody =>
      'ஏதாவது வேலை, கட்டணம் அல்லது உங்கள் கணக்கில் சிக்கல் இருந்தால், கோரிக்கை வையுங்கள், நாங்கள் உதவுவோம்.';

  @override
  String get supportYourRequests => 'உங்கள் கோரிக்கைகள்';

  @override
  String get supportEmergency => 'அவசரநிலையில்';

  @override
  String get supportEmergencyBody =>
      'இந்த ஆப் உங்கள் சார்பாக உதவிக்கு அழைக்க முடியாது. நீங்கள் ஆபத்தில் இருந்தால், நேரடியாக அவசரச் சேவைகளை அழைக்கவும்.';

  @override
  String get supportCall112 => '112-ஐ அழை';

  @override
  String get supportPolice => 'காவல்துறை';

  @override
  String get ticketOpen => 'திறந்துள்ளது';

  @override
  String get ticketInProgress => 'நடைபெறுகிறது';

  @override
  String get ticketReplyNeeded => 'உங்கள் பதில் தேவை';

  @override
  String get ticketResolved => 'தீர்க்கப்பட்டது';

  @override
  String get ticketClosed => 'மூடப்பட்டது';

  @override
  String ticketLastUpdate(Object date) {
    return 'கடைசிப் புதுப்பிப்பு $date';
  }

  @override
  String get supportCategoryJob => 'ஒரு வேலை';

  @override
  String get supportCategoryPayment => 'ஒரு கட்டணம்';

  @override
  String get supportCategoryWithdrawal => 'பணம் எடுத்தல்';

  @override
  String get supportCategoryAccount => 'என் கணக்கு';

  @override
  String get supportCategorySafety => 'பாதுகாப்பு';

  @override
  String get supportCategoryApp => 'ஆப்';

  @override
  String get supportCategoryOther => 'வேறு ஏதாவது';

  @override
  String supportRaised(Object code) {
    return 'கோரிக்கை $code பதிவானது.';
  }

  @override
  String get supportHowHelp => 'நாங்கள் எப்படி உதவலாம்?';

  @override
  String get supportAbout => 'இது எதைப் பற்றியது?';

  @override
  String get supportSubject => 'தலைப்பு';

  @override
  String get supportSubjectHint => 'பிரச்சினை பற்றிச் சில வார்த்தைகள்';

  @override
  String get supportWhatHappened => 'என்ன நடந்தது?';

  @override
  String get supportSend => 'கோரிக்கையை அனுப்பு';

  @override
  String get ticketTitle => 'ஆதரவுக் கோரிக்கை';

  @override
  String get ticketNoMessages => 'இன்னும் செய்திகள் இல்லை';

  @override
  String get ticketNoMessagesBody => 'உங்கள் உரையாடல் இங்கே தோன்றும்.';

  @override
  String get ticketWriteMessage => 'செய்தியை எழுதவும்';

  @override
  String get ticketSupportName => 'Wervexa ஆதரவு';

  @override
  String get requestsTitle => 'வாடிக்கையாளர் கோரிக்கைகள்';

  @override
  String get requestsRefresh => 'புதுப்பி';

  @override
  String get requestsLocationNeeded => 'இருப்பிடம் தேவை';

  @override
  String get requestsLocationBody =>
      'உங்கள் அருகிலுள்ள வாடிக்கையாளர் கோரிக்கைகளைக் கண்டறிய உங்கள் இருப்பிடத்தைப் பயன்படுத்துகிறோம்.';

  @override
  String get requestsGrantLocation => 'இருப்பிட அணுகலை வழங்கு';

  @override
  String get requestsEmpty => 'அருகில் பொருந்தும் கோரிக்கைகள் இல்லை';

  @override
  String get requestsEmptyBody =>
      'உங்கள் சேவைகளுக்குப் பொருந்தும்போது\nபுதிய வாடிக்கையாளர் கோரிக்கைகள் இங்கே தோன்றும்.';

  @override
  String get requestsViewOffer => 'பார்த்துச் சலுகை கொடு →';

  @override
  String get requestEnterPrice => 'சரியான விலையை உள்ளிடவும்';

  @override
  String requestOfferSubmitted(Object price) {
    return '$price-க்குச் சலுகை சமர்ப்பிக்கப்பட்டது!';
  }

  @override
  String get requestDetailsTitle => 'கோரிக்கை விவரங்கள்';

  @override
  String get requestStatusOpen => 'திறந்துள்ளது';

  @override
  String get requestCategory => 'வகை';

  @override
  String get requestBudget => 'பட்ஜெட்';

  @override
  String get requestSchedule => 'அட்டவணை';

  @override
  String get requestDistance => 'தூரம்';

  @override
  String get requestArea => 'பகுதி';

  @override
  String get requestOffers => 'சலுகைகள்';

  @override
  String get requestNotes => 'குறிப்புகள்';

  @override
  String get requestAddressPrivacy =>
      'வாடிக்கையாளர் உங்கள் சலுகையை ஏற்ற பிறகே அவரது சரியான முகவரி பகிரப்படும்.';

  @override
  String get requestYourOffer => 'உங்கள் சலுகை';

  @override
  String get requestYourPrice => 'உங்கள் விலை (₹)';

  @override
  String get requestPriceHint => 'எ.கா. 500';

  @override
  String get requestDuration => 'மதிப்பிடப்பட்ட நேரம் (விருப்பத்தேர்வு)';

  @override
  String get requestDurationHint => 'எ.கா. 1-2 மணிநேரம்';

  @override
  String get requestMessage => 'வாடிக்கையாளருக்குச் செய்தி (விருப்பத்தேர்வு)';

  @override
  String get requestMessageHint => 'இந்த வேலைக்கு நீங்கள்தான் சரியான நபர் ஏன்?';

  @override
  String get requestSubmitOffer => 'சலுகையைச் சமர்ப்பி';

  @override
  String get requestMakeOffer => 'சலுகை கொடு';

  @override
  String get requestAlreadyOffered =>
      'இந்தக் கோரிக்கைக்கு ஏற்கனவே சலுகை சமர்ப்பித்துவிட்டீர்கள்.';

  @override
  String get requestViewOffers => 'சலுகைகளைக் காண்க';

  @override
  String get offersEmptyBody =>
      'வாடிக்கையாளர் கோரிக்கைகளுக்கு நீங்கள் சமர்ப்பிக்கும் சலுகைகள்\nஇங்கே தோன்றும்.';

  @override
  String get offerWithdraw => 'பணம் எடு';

  @override
  String get offerWithdrawTitle => 'சலுகையைத் திரும்பப் பெறவா?';

  @override
  String get offerWithdrawBody =>
      'வாடிக்கையாளருக்கு இந்தச் சலுகை இனி தெரியாது.';

  @override
  String get offerWithdrawn => 'சலுகை திரும்பப் பெறப்பட்டது';

  @override
  String get onboardingTitle => 'உங்கள் சுயவிவரத்தை அமைக்கவும்';

  @override
  String get onboardingHelp => 'உதவி';

  @override
  String onboardingHello(Object name) {
    return 'வணக்கம், $name';
  }

  @override
  String get onboardingIntro =>
      'சில விஷயங்கள் முடித்தால் வேலை பெறத் தயாராகிவிடுவீர்கள்.';

  @override
  String get onboardingSetup => 'அமைப்பு';

  @override
  String onboardingStepCount(int done, int total) {
    return '$total-இல் $done';
  }

  @override
  String get onboardingBasicBody =>
      'உங்கள் நகரம் மற்றும் பின் குறியீடு, அருகில் வேலை கண்டறிய.';

  @override
  String get onboardingTradeBody => 'நீங்கள் முக்கியமாகச் செய்யும் தொழில்.';

  @override
  String get onboardingSkillsDoneBody =>
      'உங்கள் முக்கியத் தொழில் ஒன்றாகக் கணக்கிடப்படும். நீங்கள் செய்யும் மற்ற எல்லாத் தொழில்களையும் சேர்க்க இதைத் திறக்கவும்.';

  @override
  String get onboardingSkillsBody =>
      'நீங்கள் செய்யும் எல்லாத் தொழில்களையும் சேர்க்கவும். நீங்கள் ஒரே தொழிலுக்குக் கட்டுப்பட்டவர் அல்ல.';

  @override
  String get onboardingAreaBody =>
      'ஒரு வேலைக்காக நீங்கள் எவ்வளவு தூரம் பயணிக்கத் தயார்.';

  @override
  String get onboardingKycBody =>
      'அரசு அடையாள அட்டை. வாடிக்கையாளர்கள் உங்களைத் தங்கள் வீடுகளுக்குள் அனுமதிக்கிறார்கள்.';

  @override
  String get onboardingReviewNotice =>
      'இவற்றை முடித்ததும் எங்கள் குழு உங்கள் ஆவணங்களைச் சரிபார்க்கும். காத்திருக்கும்போது உங்கள் சேவைகளை அமைத்துக்கொண்டே இருக்கலாம்.';

  @override
  String get onboardingTradesLoadFailed =>
      'தொழில்களை ஏற்ற முடியவில்லை. மீண்டும் முயலவும்.';

  @override
  String get onboardingMainTrade => 'உங்கள் முக்கியத் தொழில் என்ன?';

  @override
  String get onboardingMainTradeBody =>
      'பின்னர் மேலும் தொழில்களைச் சேர்க்கலாம்.';

  @override
  String onboardingTradeSet(Object trade) {
    return '$trade உங்கள் முக்கியத் தொழிலாக அமைக்கப்பட்டது.';
  }

  @override
  String get onboardingTravelTitle => 'எவ்வளவு தூரம் பயணிப்பீர்கள்?';

  @override
  String get onboardingTravelBody =>
      'நீங்கள் இப்போது இருக்கும் இடத்திலிருந்து இந்தத் தூரத்திற்குள் உள்ள வேலைகளை மட்டுமே வழங்குவோம்.';

  @override
  String get onboardingTravelCentre =>
      'உங்கள் தற்போதைய இருப்பிடத்தை மையப் புள்ளியாகப் பயன்படுத்துகிறோம். சுயவிவரத்திலிருந்து எப்போது வேண்டுமானாலும் மாற்றலாம்.';

  @override
  String get onboardingLocationOff =>
      'உங்கள் வேலைப் பகுதியை அமைக்க இருப்பிட அணுகலை இயக்கவும்.';

  @override
  String get commonSave => 'சேமி';

  @override
  String get notificationsStayOff =>
      'அறிவிப்புகள் முடக்கத்திலேயே இருக்கும். உங்கள் போன் அமைப்புகளில் அவற்றை இயக்கலாம்.';

  @override
  String get notificationsPrimerTitle => 'வேலை வந்ததும் தெரிந்துகொள்ளுங்கள்';

  @override
  String get notificationsPrimerBody =>
      'வேலைச் சலுகைகள் காலாவதியாகும். ஆப் மூடியிருக்கும்போது அறிவிப்பின் மூலமே உங்களுக்குத் தெரியும் — வேறு எதுவும் அனுப்பப்படாது.';

  @override
  String get notificationsTurnOn => 'அறிவிப்புகளை இயக்கு';

  @override
  String get commonNotNow => 'இப்போது வேண்டாம்';

  @override
  String get onboardingCityRequired => 'உங்கள் நகரத்தை உள்ளிடவும்';

  @override
  String get onboardingGenderRequired => 'உங்கள் பாலினத்தைத் தேர்ந்தெடுக்கவும்';

  @override
  String get onboardingWhereBased => 'நீங்கள் எங்கே வசிக்கிறீர்கள்?';
}
