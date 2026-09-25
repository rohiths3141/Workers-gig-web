// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class AppLocalizationsTa extends AppLocalizations {
  AppLocalizationsTa([String locale = 'ta']) : super(locale);

  @override
  String get commonRetry => 'மீண்டும் முயலவும்';

  @override
  String get commonTryAgain => 'மீண்டும் முயலவும்';

  @override
  String get commonSignOut => 'வெளியேறு';

  @override
  String get assistantFabLabel => 'AI-யிடம் கேளுங்கள்';

  @override
  String get navHome => 'முகப்பு';

  @override
  String get navExplore => 'ஆராய்க';

  @override
  String get navBookings => 'முன்பதிவுகள்';

  @override
  String get navAlerts => 'விழிப்பூட்டல்கள்';

  @override
  String get navProfile => 'சுயவிவரம்';

  @override
  String get configErrorTitle => 'ஆப் கட்டமைக்கப்படவில்லை';

  @override
  String configErrorBody(String keys, String command) {
    return 'இந்த பில்டில் $keys இல்லை. இப்படி இயக்கவும்:\n\n$command\n\nஅப்போதுதான் ஆப் உண்மையான பேக்எண்டை அணுக முடியும்.';
  }

  @override
  String get sessionProfileLoadFailedRetry =>
      'உங்கள் சுயவிவரத்தை ஏற்ற முடியவில்லை. மீண்டும் முயலவும்.';

  @override
  String get sessionProfileLoadFailed => 'உங்கள் சுயவிவரத்தை ஏற்ற முடியவில்லை';

  @override
  String get sessionCheckClock => 'உங்கள் போனின் கடிகாரத்தைச் சரிபார்க்கவும்';

  @override
  String get splashTagline => 'வீட்டுச் சேவைகள், சரியான முறையில்.';

  @override
  String get timelineBookingConfirmed => 'முன்பதிவு உறுதிசெய்யப்பட்டது';

  @override
  String get timelineProviderOnTheWay => 'சேவை வழங்குநர் வழியில் உள்ளார்';

  @override
  String get timelineServiceInProgress => 'சேவை நடைபெறுகிறது';

  @override
  String get timelineCompleted => 'முடிந்தது';

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
  String get errorSessionEnded =>
      'உங்கள் அமர்வு முடிந்தது. மீண்டும் உள்நுழையவும்.';

  @override
  String get errorUploadFailed =>
      'அந்தக் கோப்பைப் பதிவேற்ற முடியவில்லை. மீண்டும் முயலவும்.';

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
  String get authErrorPhoneNotEnabled =>
      'போன் மூலம் உள்நுழைவு இயக்கப்படவில்லை. உதவி மையத்தைத் தொடர்பு கொள்ளவும்.';

  @override
  String get authErrorNumberInUse =>
      'அந்த எண் ஏற்கனவே வேறொரு கணக்கில் பதிவு செய்யப்பட்டுள்ளது.';

  @override
  String get authErrorSignInAgain => 'தொடர மீண்டும் உள்நுழையவும்.';

  @override
  String get authErrorSignInFailed =>
      'உள்நுழைவு தோல்வியடைந்தது. மீண்டும் முயலவும்.';

  @override
  String get languagePickerTitle => 'உங்கள் மொழியைத் தேர்ந்தெடுக்கவும்';

  @override
  String get authCouldNotStartVerification =>
      'சரிபார்ப்பைத் தொடங்க முடியவில்லை. மீண்டும் முயலவும்.';

  @override
  String get authWelcomeTitle => 'Wervexa-க்கு வரவேற்கிறோம்';

  @override
  String get authWelcomeSubtitle =>
      'வீட்டுப் பழுதுபார்ப்பு, பிளம்பிங், மின்சாரம், சுத்தம் மற்றும் பலவற்றுக்கு அருகிலுள்ள சிறந்த நிபுணர்களைக் கண்டறியுங்கள்.';

  @override
  String get authEnterPhone => 'உங்கள் போன் எண்ணை உள்ளிடவும்';

  @override
  String get authInvalidMobile => 'சரியான 10 இலக்க மொபைல் எண்ணை உள்ளிடவும்';

  @override
  String get authGetOtp => 'OTP சரிபார்ப்பைப் பெறுக';

  @override
  String get authTermsNotice =>
      'தொடர்வதன் மூலம், எங்கள் சேவை விதிமுறைகள் & தனியுரிமைக் கொள்கையை ஏற்கிறீர்கள்';

  @override
  String get authNewCodeSent => 'புதிய குறியீட்டை அனுப்பியுள்ளோம்.';

  @override
  String get authVerifyPhoneTitle => 'போனைச் சரிபார்க்கவும்';

  @override
  String get authChangeNumber => 'எண்ணை மாற்று';

  @override
  String get authEnterCodeTitle => '6 இலக்கக் குறியீட்டை உள்ளிடவும்';

  @override
  String authCodeSentTo(Object phone) {
    return '$phone எண்ணுக்கு SMS சரிபார்ப்புக் குறியீட்டை அனுப்பியுள்ளோம்';
  }

  @override
  String get authWrongNumber => 'தவறான எண்ணா? மாற்றுங்கள்';

  @override
  String get authEnterSixDigits => '6 இலக்கங்களை உள்ளிடவும்';

  @override
  String get authResendCode => 'குறியீட்டை மீண்டும் அனுப்பு';

  @override
  String authResendCodeIn(Object seconds) {
    return '$seconds வினாடிகளில் குறியீட்டை மீண்டும் அனுப்பலாம்';
  }

  @override
  String get authVerifyAndContinue => 'சரிபார்த்துத் தொடரவும்';

  @override
  String get registerTitle => 'சுயவிவரத்தை நிறைவு செய்யவும்';

  @override
  String get registerHeading => 'உங்கள் பெயரைச் சொல்லுங்கள்';

  @override
  String get registerNameVisibility =>
      'நீங்கள் முன்பதிவுக் கோரிக்கை வைக்கும்போது உங்கள் பெயர் சேவைப் பணியாளர்களுக்குத் தெரியும்.';

  @override
  String get registerFullNameLabel => 'முழுப் பெயர் *';

  @override
  String get registerFullNameHint => 'எ.கா. ராகுல் சர்மா';

  @override
  String get registerFullNameRequired => 'உங்கள் முழுப் பெயரை உள்ளிடவும்';

  @override
  String get registerEmailLabel => 'மின்னஞ்சல் முகவரி (விருப்பத்தேர்வு)';

  @override
  String get registerEmailHint => 'எ.கா. rahul@example.com';

  @override
  String get registerSubmit => 'சேமித்துத் தொடங்கவும்';

  @override
  String get bookingStatusRequested => 'நிபுணரைத் தேடுகிறோம்…';

  @override
  String get bookingStatusAccepted => 'நிபுணர் கிடைத்தார்';

  @override
  String get bookingStatusConfirmed => 'உறுதிசெய்யப்பட்டது';

  @override
  String get bookingStatusTraveling => 'வழியில் உள்ளார்';

  @override
  String get bookingStatusArrived =>
      'வந்துவிட்டார் — உங்கள் குறியீட்டை உள்ளிடவும்';

  @override
  String get bookingStatusInProgress => 'வேலை நடைபெறுகிறது';

  @override
  String get bookingStatusAwaitingApproval =>
      'வேலை முடிந்தது — தொடர ஒப்புதல் அளிக்கவும்';

  @override
  String get bookingStatusCompleted => 'முடிந்தது';

  @override
  String get bookingStatusPaymentPending => 'கட்டணம் நிலுவையில்';

  @override
  String get bookingStatusPaid => 'கட்டணம் செலுத்தப்பட்டது';

  @override
  String get bookingStatusClosed => 'மூடப்பட்டது';

  @override
  String get bookingStatusCancelled => 'ரத்துசெய்யப்பட்டது';

  @override
  String get bookingStatusDisputed => 'சர்ச்சையில்';

  @override
  String get bookingStatusExpired => 'காலாவதியானது — யாரும் கிடைக்கவில்லை';

  @override
  String get pricingPerJob => 'ஒரு வேலைக்கு';

  @override
  String get pricingPerHour => 'மணிக்கு';

  @override
  String get pricingPerDay => 'நாளுக்கு';

  @override
  String get pricingPerUnit => 'யூனிட்டுக்கு';

  @override
  String get pricingPerSqft => 'சதுர அடிக்கு';

  @override
  String get supportCategoryBooking => 'முன்பதிவுச் சிக்கல்';

  @override
  String get supportCategoryPayment => 'கட்டணம்';

  @override
  String get supportCategoryPayout => 'பேஅவுட்';

  @override
  String get supportCategoryVerification => 'சரிபார்ப்பு';

  @override
  String get supportCategoryAccount => 'என் கணக்கு';

  @override
  String get supportCategorySafety => 'பாதுகாப்புக் கவலை';

  @override
  String get supportCategoryClaim => 'காப்பீட்டுக் கோரிக்கை';

  @override
  String get supportCategoryAppIssue => 'ஆப் சிக்கல்';

  @override
  String get supportCategoryOther => 'மற்றவை';

  @override
  String get requestStatusDraft => 'வரைவு';

  @override
  String get requestStatusOpen =>
      'திறந்துள்ளது — சலுகைகளுக்காகக் காத்திருக்கிறது';

  @override
  String get requestStatusReceivingOffers => 'சலுகைகள் வருகின்றன';

  @override
  String get requestStatusWorkerSelected => 'நிபுணர் தேர்ந்தெடுக்கப்பட்டார்';

  @override
  String get requestStatusBooked => 'முன்பதிவு செய்யப்பட்டது';

  @override
  String get requestStatusCancelled => 'ரத்துசெய்யப்பட்டது';

  @override
  String get requestStatusExpired => 'காலாவதியானது';

  @override
  String get requestStatusClosed => 'மூடப்பட்டது';

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
  String get scheduleSpecificDate => 'குறிப்பிட்ட தேதியில்';

  @override
  String get scheduleScheduled => 'திட்டமிடப்பட்டது';

  @override
  String get offerStatusSubmitted => 'புதிய சலுகை';

  @override
  String get offerStatusViewed => 'பார்க்கப்பட்டது';

  @override
  String get offerStatusShortlisted => 'குறுகிய பட்டியலில்';

  @override
  String get offerStatusAccepted => 'ஏற்கப்பட்டது';

  @override
  String get offerStatusRejected => 'நிராகரிக்கப்பட்டது';

  @override
  String get offerStatusWithdrawn => 'பணியாளர் திரும்பப் பெற்றார்';

  @override
  String get offerStatusExpired => 'காலாவதியானது';

  @override
  String get offerStatusClosed => 'மூடப்பட்டது';

  @override
  String get gigRatingNew => 'புதியவர்';

  @override
  String distanceMetres(Object metres) {
    return '$metres மீ';
  }

  @override
  String distanceKm(Object km) {
    return '$km கி.மீ';
  }

  @override
  String durationMinutes(Object minutes) {
    return '$minutes நிமி';
  }

  @override
  String durationHours(Object hours) {
    return '$hours மணி';
  }

  @override
  String durationHoursMinutes(int hours, int minutes) {
    return '$hours மணி $minutes நிமி';
  }

  @override
  String get offerWorkerFallbackName => 'நிபுணர்';

  @override
  String get budgetFlexible => 'நெகிழ்வான பட்ஜெட்';

  @override
  String get budgetFixed => 'நிலையான பட்ஜெட்';

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
  String get paymentsNotConfigured =>
      'இந்த பில்டில் கட்டணங்கள் இன்னும் கட்டமைக்கப்படவில்லை.';

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
  String get addressLabelHome => 'முகப்பு';

  @override
  String get addressLabelWork => 'அலுவலகம்';

  @override
  String get addressLabelOther => 'மற்றவை';

  @override
  String get commonSeeAll => 'அனைத்தையும் காண்க';

  @override
  String get commonViewAll => 'அனைத்தையும் காண்க';

  @override
  String get commonCheckBackLater => 'பின்னர் மீண்டும் பார்க்கவும்.';

  @override
  String get commonUseCurrentLocation => 'தற்போதைய இருப்பிடத்தைப் பயன்படுத்து';

  @override
  String get commonChooseOnMap => 'வரைபடத்தில் தேர்ந்தெடு';

  @override
  String homeGreetingNamed(Object name) {
    return 'வணக்கம், $name 👋';
  }

  @override
  String get homeGreeting => 'வணக்கம் 👋';

  @override
  String get homeWhatService => 'இன்று உங்களுக்கு என்ன சேவை வேண்டும்?';

  @override
  String get homeSetLocation => 'உங்கள் இருப்பிடத்தை அமைக்கவும்';

  @override
  String get homeWorkFinishedApprove =>
      'வேலை முடிந்தது — ஒப்புதல் அளிக்கத் தட்டவும்';

  @override
  String get homeCategories => 'வகைகள்';

  @override
  String homeCategoriesLoadFailed(Object error) {
    return 'வகைகளை ஏற்ற முடியவில்லை: $error';
  }

  @override
  String get homeFindWorker => 'பணியாளரைக் கண்டறிக';

  @override
  String get homeFindWorkerSubtitle => 'அருகிலுள்ள சேவைகளைப் பாருங்கள்';

  @override
  String get homePostRequest => 'கோரிக்கையை இடுக';

  @override
  String get homePostRequestSubtitle => 'பணியாளர்கள் உங்களிடம் வருவார்கள்';

  @override
  String get homeNoServices => 'தற்போது சேவைகள் எதுவும் கிடைக்கவில்லை';

  @override
  String get homeSearchNear => 'அருகில் சேவைகளைத் தேடுக';

  @override
  String get homeSearchHint => 'சேவைகளைத் தேடுக...';

  @override
  String homeActiveBooking(Object code) {
    return 'செயலில் உள்ள முன்பதிவு #$code';
  }

  @override
  String get homeActiveRequests => 'உங்கள் செயலில் உள்ள கோரிக்கைகள்';

  @override
  String get commonGrantPermission => 'அனுமதி வழங்கு';

  @override
  String get commonView => 'காண்க';

  @override
  String get exploreTitle => 'சேவைகளை ஆராய்ந்து கண்டறிக';

  @override
  String get exploreListView => 'பட்டியல் காட்சி';

  @override
  String get exploreMapView => 'வரைபடக் காட்சி';

  @override
  String get exploreSearchHint =>
      'சேவைகள், பணியாளர்கள் அல்லது திறன்களைத் தேடுக...';

  @override
  String get exploreLocationOffTitle => 'இருப்பிடச் சேவைகள் முடக்கப்பட்டுள்ளன';

  @override
  String get exploreLocationOffMessage =>
      'அருகிலுள்ள நிபுணர்களைக் கண்டறிய இருப்பிடத்தை இயக்கவும்.';

  @override
  String get exploreLocationPermissionTitle => 'இருப்பிட அனுமதி தேவை';

  @override
  String get exploreLocationPermissionMessage =>
      'அருகிலுள்ள நிபுணர்களைக் கண்டறிய உங்கள் இருப்பிடத்தைப் பயன்படுத்துகிறோம்.';

  @override
  String get exploreChooseService => 'ஆராய ஒரு சேவையைத் தேர்ந்தெடுக்கவும்';

  @override
  String get exploreChooseServiceMessage =>
      'அருகிலுள்ள நிபுணர்களைக் காண மேலே ஒரு வகையைத் தேர்ந்தெடுக்கவும்.';

  @override
  String get exploreNoProfessionals =>
      'இந்தச் சேவைக்கு அருகில் நிபுணர்கள் யாரும் இல்லை';

  @override
  String get exploreLoadFailed => 'நிபுணர்களை ஏற்ற முடியவில்லை.';

  @override
  String exploreByWorker(Object name) {
    return '$name வழங்குவது';
  }

  @override
  String get bookingsTitle => 'என் சேவை முன்பதிவுகள்';

  @override
  String get bookingsTabActive => 'செயலில்';

  @override
  String get bookingsTabCompleted => 'முடிந்தது';

  @override
  String get bookingsTabCancelled => 'ரத்துசெய்யப்பட்டது';

  @override
  String get bookingsLoadFailed => 'உங்கள் முன்பதிவுகளை ஏற்ற முடியவில்லை.';

  @override
  String get bookingsEmpty => 'இன்னும் முன்பதிவுகள் இல்லை';

  @override
  String get bookingsFindService => 'சேவையைக் கண்டறிக';

  @override
  String get bookingsWaitingForProfessional => 'நிபுணருக்காகக் காத்திருக்கிறது';

  @override
  String bookingsCode(Object code) {
    return 'முன்பதிவுக் குறியீடு: #$code';
  }

  @override
  String get bookingsPayNow => 'இப்போது செலுத்து';

  @override
  String get bookingsApproveWork => 'வேலைக்கு ஒப்புதல் அளி';

  @override
  String get bookingsTrackLive => 'நேரலையில் கண்காணி';

  @override
  String get bookingsDetails => 'விவரங்கள்';

  @override
  String get bookingDetailTitle => 'முன்பதிவு விவரங்கள்';

  @override
  String get bookingDetailLoadFailed => 'முன்பதிவு விவரங்களை ஏற்ற முடியவில்லை.';

  @override
  String get bookingDetailWaitingAccept => 'நிபுணர் ஏற்கக் காத்திருக்கிறது';

  @override
  String bookingDetailNumber(Object code) {
    return 'முன்பதிவு #$code';
  }

  @override
  String bookingDetailStatus(Object status) {
    return 'நிலை: $status';
  }

  @override
  String get bookingDetailLiveMap => 'நேரலை வரைபடம்';

  @override
  String get bookingDetailServiceInfo => 'சேவைக் கோரிக்கைத் தகவல்';

  @override
  String get bookingDetailViewMaterials =>
      'பொருள் / உதிரிபாகக் கோரிக்கைகளைக் காண்க';

  @override
  String get bookingDetailFareDetails => 'கட்டண விவரங்கள்';

  @override
  String get bookingDetailEstimatedFare => 'மதிப்பிடப்பட்ட கட்டணம்';

  @override
  String get bookingDetailFinalFare => 'இறுதி உறுதிசெய்யப்பட்ட கட்டணம்';

  @override
  String get bookingDetailRateReview =>
      'சேவைப் பணியாளரை மதிப்பிட்டு விமர்சிக்கவும்';

  @override
  String get bookingDetailApproveCompletion => 'நிறைவுக்கு ஒப்புதல் அளி';

  @override
  String get bookingDetailApprovePaidHint =>
      'உங்கள் நிபுணர் இந்த வேலையை முடிந்ததாகக் குறித்துள்ளார். ஒப்புதல் அளித்தால் உங்கள் கட்டணம் அவருக்கு விடுவிக்கப்படும்.';

  @override
  String get bookingDetailApproveUnpaidHint =>
      'உங்கள் நிபுணர் இந்த வேலையை முடிந்ததாகக் குறித்துள்ளார். உறுதிசெய்து கட்டணத்திற்குச் செல்ல ஒப்புதல் அளிக்கவும்.';

  @override
  String get bookingDetailReportProblem => 'சிக்கலைப் புகாரளி';

  @override
  String get bookingDetailCompletionApproved =>
      'நிறைவுக்கு ஒப்புதல் அளிக்கப்பட்டது';

  @override
  String bookingDetailPayToConfirm(Object amount) {
    return 'உறுதிசெய்ய $amount செலுத்தவும்';
  }

  @override
  String get bookingDetailSentAfterPayment =>
      'கட்டணம் முடிந்ததும் உங்கள் முன்பதிவு நிபுணருக்கு அனுப்பப்படும்.';

  @override
  String bookingDetailPayAmount(Object amount) {
    return '$amount செலுத்து';
  }

  @override
  String get bookingDetailCancelBooking => 'முன்பதிவை ரத்துசெய்';

  @override
  String get cancelReasonMistake => 'தவறுதலாக முன்பதிவு செய்தேன்';

  @override
  String get cancelReasonNoLongerNeeded => 'எனக்கு இனி இந்தச் சேவை தேவையில்லை';

  @override
  String get cancelReasonDifferentTime =>
      'வேறு நேரத்தைத் தேர்ந்தெடுக்க விரும்புகிறேன்';

  @override
  String get cancelReasonFoundSomeoneElse => 'எனக்கு வேறொருவர் கிடைத்தார்';

  @override
  String get cancelDialogTitle => 'ஏன் ரத்துசெய்கிறீர்கள்?';

  @override
  String get cancelDialogRefundNotice =>
      'இதைத் திரும்பப் பெற முடியாது. உங்கள் கட்டணம் அசல் கட்டண முறைக்குத் திருப்பி அளிக்கப்படும்.';

  @override
  String get cancelDialogCannotUndo => 'இதைத் திரும்பப் பெற முடியாது.';

  @override
  String get cancelDialogKeepBooking => 'முன்பதிவை வைத்திரு';

  @override
  String get bookingCancelledRefund =>
      'முன்பதிவு ரத்துசெய்யப்பட்டது. உங்கள் பணத்திருப்பம் கோரப்பட்டுள்ளது.';

  @override
  String get bookingCancelled => 'முன்பதிவு ரத்துசெய்யப்பட்டது';

  @override
  String get arrivalCodeTitle => 'வருகைக் குறியீடு';

  @override
  String get arrivalCodeShare =>
      'நிபுணர் வந்ததை உறுதிசெய்ய இந்தக் குறியீட்டை அவரிடம் பகிரவும்:';

  @override
  String get arrivalCodeUnavailable => 'கிடைக்கவில்லை';

  @override
  String get arrivalCodeLoadFailed => 'குறியீட்டை ஏற்ற முடியவில்லை';

  @override
  String get activeBookingTitle => 'நேரலை முன்பதிவு & பணியாளர் கண்காணிப்பு';

  @override
  String get activeBookingLoadFailed => 'இந்த முன்பதிவை ஏற்ற முடியவில்லை.';

  @override
  String get activeBookingMapUnavailable =>
      'இந்த முன்பதிவுக்கு நேரலை வரைபடம் இல்லை.';

  @override
  String get activeBookingViewDetails => 'முன்பதிவு விவரங்களைக் காண்க';

  @override
  String get activeBookingServiceLocation => 'சேவை இடம்';

  @override
  String get activeBookingYourProfessional => 'உங்கள் நிபுணர்';

  @override
  String get activeBookingLive => 'நேரலை';

  @override
  String get activeBookingLastKnown => 'கடைசியாகத் தெரிந்த இடம்';

  @override
  String get activeBookingPhoneNotShared => 'போன் எண் இன்னும் பகிரப்படவில்லை';

  @override
  String get activeBookingCallProfessional => 'நிபுணரை அழை';

  @override
  String get activeBookingMaterials => 'பொருட்கள்';

  @override
  String get activeBookingViewDetailsShort => 'விவரங்களைக் காண்க';

  @override
  String get locationConnecting => 'நேரலை இருப்பிடத்துடன் இணைக்கிறது...';

  @override
  String get locationLiveUnavailable =>
      'நேரலை இருப்பிடம் தற்காலிகமாகக் கிடைக்கவில்லை';

  @override
  String get locationLiveActive => 'நேரலை இருப்பிடம் செயலில் உள்ளது';

  @override
  String get locationUpdating => 'புதுப்பிக்கிறது...';

  @override
  String get locationUnavailable => 'இருப்பிடம் தற்காலிகமாகக் கிடைக்கவில்லை';

  @override
  String get activeBookingShareStartCode =>
      'பணியாளர் வந்துவிட்டார்! தொடக்கக் குறியீட்டைப் பகிரவும்:';

  @override
  String get commonBack => 'பின்செல்';

  @override
  String get paymentCouldNotOpen =>
      'கட்டணத் திரையைத் திறக்க முடியவில்லை. மீண்டும் முயலவும்.';

  @override
  String get paymentReceived =>
      'கட்டணம் பெறப்பட்டது. உங்கள் முன்பதிவு நிபுணருக்கு அனுப்பப்பட்டது.';

  @override
  String paymentNotConfirmed(String reason, String reference) {
    return 'இந்தக் கட்டணத்தை உறுதிசெய்ய முடியவில்லை: $reason. பணம் கழிக்கப்பட்டிருந்தால், $reference குறிப்புடன் உதவி மையத்தைத் தொடர்பு கொள்ளவும்.';
  }

  @override
  String get paymentNotCompleted => 'கட்டணம் நிறைவடையவில்லை.';

  @override
  String paymentExternalWalletUnsupported(Object wallet) {
    return 'வெளிப்புற வாலெட் ($wallet) தேர்ந்தெடுக்கப்பட்டது — இது இன்னும் ஆதரிக்கப்படவில்லை.';
  }

  @override
  String get paymentTitle => 'கட்டணம்';

  @override
  String get paymentStatusUnknown =>
      'இந்த முன்பதிவுக்கு ஏற்கனவே பணம் செலுத்தப்பட்டதா என்று சரிபார்க்க முடியவில்லை. இருமுறை செலுத்துவதற்குப் பதிலாக மீண்டும் முயலவும்.';

  @override
  String get paymentBookingLoadFailed => 'இந்த முன்பதிவை ஏற்ற முடியவில்லை.';

  @override
  String get paymentComplete => 'கட்டணம் முடிந்தது';

  @override
  String paymentPaidFor(String amount, String service) {
    return '$service-க்கு $amount செலுத்தப்பட்டது.';
  }

  @override
  String get paymentViewBooking => 'முன்பதிவைக் காண்க';

  @override
  String get paymentBookingSummary => 'முன்பதிவுச் சுருக்கம்';

  @override
  String get paymentProvider => 'சேவை வழங்குநர்';

  @override
  String get paymentService => 'சேவை';

  @override
  String get paymentDate => 'தேதி';

  @override
  String get paymentTime => 'நேரம்';

  @override
  String get paymentAddress => 'முகவரி';

  @override
  String get paymentTotal => 'மொத்தம்';

  @override
  String get paymentHeldSecurely =>
      'உங்கள் கட்டணம் பாதுகாப்பாக வைக்கப்பட்டு, நீங்கள் வேலைக்கு ஒப்புதல் அளித்த பிறகே நிபுணருக்கு விடுவிக்கப்படும். வேலை தொடங்கும் முன் முன்பதிவு ரத்தானால், பணம் திருப்பி அளிக்கப்படும்.';

  @override
  String get commonChange => 'மாற்று';

  @override
  String get bookMissingDetails =>
      'முன்பதிவு விவரங்கள் இல்லை — மீண்டும் தொடங்கவும்.';

  @override
  String get bookSlotPassed =>
      'அந்த நேரம் கடந்துவிட்டது. அடுத்த கிடைக்கும் நேரத்திற்கு மாற்றியுள்ளோம் — சரிபார்த்து மீண்டும் உறுதிசெய்யவும்.';

  @override
  String bookFailed(Object reason) {
    return 'முன்பதிவு தோல்வியடைந்தது: $reason';
  }

  @override
  String get bookNoAddress => 'முகவரி எதுவும் தேர்ந்தெடுக்கப்படவில்லை';

  @override
  String get bookTitle => 'சேவையை முன்பதிவு செய்';

  @override
  String get bookSelectDate => 'தேதியைத் தேர்ந்தெடு';

  @override
  String get bookSelectTime => 'நேரத்தைத் தேர்ந்தெடு';

  @override
  String get bookSpecialInstructions => 'சிறப்பு வழிமுறைகள் (விருப்பத்தேர்வு)';

  @override
  String get bookSpecialInstructionsHint =>
      'எ.கா. சமையலறை மற்றும் குளியலறையில் கவனம் செலுத்தவும்...';

  @override
  String get bookConfirm => 'முன்பதிவை உறுதிசெய் →';

  @override
  String get gigUnknownProfessional => 'அறியப்படாத நிபுணர்';

  @override
  String get gigNewProfessional => 'புதிய நிபுணர்';

  @override
  String gigRatingWithCount(String rating, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count மதிப்பாய்வுகள்',
      one: '1 மதிப்பாய்வு',
    );
    return '$rating ($_temp0)';
  }

  @override
  String get gigPricing => 'விலை';

  @override
  String get gigServiceRate => 'சேவைக் கட்டணம்';

  @override
  String get gigFinalAmountNote =>
      'இறுதித் தொகையை உங்கள் நிபுணர் உறுதிசெய்வார், முன்பதிவு உருவானதும் அதில் காட்டப்படும்.';

  @override
  String get gigKycVerified => 'KYC சரிபார்க்கப்பட்டது';

  @override
  String get gigBackgroundVerified => 'பின்னணி சரிபார்க்கப்பட்டது';

  @override
  String get gigBookNow => 'இப்போது முன்பதிவு செய் →';

  @override
  String get discoveryTitle => 'கிடைக்கும் நிபுணர்கள்';

  @override
  String get discoveryMissingDetails => 'சேவை அல்லது இருப்பிட விவரங்கள் இல்லை.';

  @override
  String get discoveryLocalExperts => 'கிடைக்கும் உள்ளூர் நிபுணர்கள்';

  @override
  String get discoveryWithin => 'தூரத்திற்குள்';

  @override
  String get discoveryNoProviders => 'அருகில் சேவை வழங்குநர்கள் யாரும் இல்லை';

  @override
  String get discoveryTryLargerRadius =>
      'பெரிய தேடல் தூரத்தை முயலவும் அல்லது பின்னர் பார்க்கவும்.';

  @override
  String get discoveryLoadFailed =>
      'அருகிலுள்ள சேவை வழங்குநர்களை ஏற்ற முடியவில்லை.';

  @override
  String discoveryServicesForJob(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'இந்த வேலைக்கு $count சேவைகள்',
      one: 'இந்த வேலைக்கு 1 சேவை',
    );
    return '$_temp0';
  }

  @override
  String get discoveryBook => 'முன்பதிவு செய்';

  @override
  String get categoryServiceDetails => 'சேவை விவரங்கள்';

  @override
  String get categoryTagline =>
      'முன்கூட்டியே தெரிந்த விலை & சேவை உத்தரவாதத்துடன் சரிபார்க்கப்பட்ட, பின்னணி சோதிக்கப்பட்ட உள்ளூர் நிபுணர்களை முன்பதிவு செய்யுங்கள்.';

  @override
  String get categoryWhatHelp => 'உங்களுக்கு எதில் உதவி தேவை?';

  @override
  String get categoryDescribeElse => 'வேறு ஏதாவது விவரிக்கவும்';

  @override
  String get categoryLoadFailed => 'இந்தச் சேவையை ஏற்ற முடியவில்லை.';

  @override
  String get notificationsTitle => 'அறிவிப்புகள் & விழிப்பூட்டல்கள்';

  @override
  String get notificationsEmpty => 'அனைத்தையும் பார்த்துவிட்டீர்கள்';

  @override
  String get notificationsLoadFailed => 'அறிவிப்புகளை ஏற்ற முடியவில்லை.';

  @override
  String get timeJustNow => 'இப்போதுதான்';

  @override
  String timeMinutesAgo(Object minutes) {
    return '$minutes நிமி முன்';
  }

  @override
  String timeHoursAgo(Object hours) {
    return '$hours மணி முன்';
  }

  @override
  String get timeYesterday => 'நேற்று';

  @override
  String get completedTitle => 'சேவை முடிந்தது!';

  @override
  String get completedThanks => 'எங்கள் சேவைகளைப் பயன்படுத்தியதற்கு நன்றி.';

  @override
  String get completedViewBookings => 'முன்பதிவுகளைக் காண்க';

  @override
  String get completedBackHome => 'முகப்புக்குத் திரும்பு';

  @override
  String commonErrorDetail(Object detail) {
    return 'பிழை: $detail';
  }

  @override
  String get reviewTitle => 'உங்கள் அனுபவத்தை மதிப்பிடுங்கள்';

  @override
  String get reviewHeading => 'சிறந்த சேவை!';

  @override
  String get reviewQuestion => 'உங்கள் நிபுணருடனான அனுபவம் எப்படி இருந்தது?';

  @override
  String reviewStars(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count நட்சத்திரங்கள்',
      one: '1 நட்சத்திரம்',
    );
    return '$_temp0';
  }

  @override
  String get reviewCommentHint => 'உங்கள் அனுபவத்தைப் பற்றிச் சொல்லுங்கள்...';

  @override
  String get reviewSubmit => 'மதிப்பாய்வைச் சமர்ப்பி →';

  @override
  String get materialsTitle => 'பொருள் / உதிரிபாகக் கோரிக்கைகள்';

  @override
  String get materialsEmpty =>
      'இந்த முன்பதிவுக்குப் பொருள் கோரிக்கைகள் எதுவும் சமர்ப்பிக்கப்படவில்லை';

  @override
  String materialsQuantityEstimated(Object quantity) {
    return '$quantity · மதிப்பீடு';
  }

  @override
  String materialsQuantityActual(Object quantity) {
    return '$quantity · உண்மை';
  }

  @override
  String get materialsReject => 'நிராகரி';

  @override
  String get materialsApprove => 'ஒப்புதல் அளி';

  @override
  String get materialStatusRequested => 'கோரப்பட்டது';

  @override
  String get materialStatusCustomerReview =>
      'உங்கள் பரிசீலனைக்காகக் காத்திருக்கிறது';

  @override
  String get materialStatusApproved => 'ஒப்புதல் அளிக்கப்பட்டது';

  @override
  String get materialStatusRejected => 'நிராகரிக்கப்பட்டது';

  @override
  String get materialStatusPurchased => 'வாங்கப்பட்டது';

  @override
  String get materialStatusCostRecorded => 'செலவு பதிவு செய்யப்பட்டது';

  @override
  String get materialStatusBilled => 'பில்லில் சேர்க்கப்பட்டது';

  @override
  String get materialStatusCancelled => 'ரத்துசெய்யப்பட்டது';

  @override
  String get commonSaveChanges => 'மாற்றங்களைச் சேமி';

  @override
  String get profileTitle => 'என் சுயவிவரம் & கணக்கு';

  @override
  String get profileFallbackName => 'வாடிக்கையாளர் சுயவிவரம்';

  @override
  String get profileLanguage => 'மொழி';

  @override
  String get profileAddresses => 'சேமித்த சேவை முகவரிகள்';

  @override
  String get profileAddressesSubtitle =>
      'வீடு, அலுவலகம் & பிற முகவரிகளை நிர்வகிக்கவும்';

  @override
  String get profileHistory => 'முந்தைய சேவை வரலாறு';

  @override
  String get profileHistorySubtitle =>
      'ரசீதுகள் & முந்தைய முன்பதிவுகளைக் காண்க';

  @override
  String get profileSupport => 'உதவி & வாடிக்கையாளர் ஆதரவு';

  @override
  String get profileSupportSubtitle =>
      'டிக்கெட் உருவாக்கவும், எங்கள் குழுவின் பதில்களைக் காணவும்';

  @override
  String get editProfileSaved => 'சுயவிவரம் வெற்றிகரமாகப் புதுப்பிக்கப்பட்டது';

  @override
  String get editProfileTitle => 'சுயவிவரத்தைத் திருத்து';

  @override
  String get editProfileFullName => 'முழுப் பெயர்';

  @override
  String get editProfileNameEmpty => 'பெயர் காலியாக இருக்கக்கூடாது';

  @override
  String get editProfileEmail => 'மின்னஞ்சல் முகவரி';

  @override
  String get commonEdit => 'திருத்து';

  @override
  String get commonDelete => 'நீக்கு';

  @override
  String get addressesAdd => 'புதிய முகவரியைச் சேர்';

  @override
  String get addressesEmpty => 'நீங்கள் இன்னும் முகவரி எதையும் சேமிக்கவில்லை';

  @override
  String get addressesEmptyMessage =>
      'அடுத்த முறை விரைவாக முன்பதிவு செய்ய ஒரு சேவை முகவரியைச் சேர்க்கவும்.';

  @override
  String get addressesDefaultBadge => 'இயல்புநிலை';

  @override
  String get addressesSetDefault => 'இயல்புநிலையாக அமை';

  @override
  String get addressesLoadFailed => 'முகவரிகளை ஏற்ற முடியவில்லை.';

  @override
  String get addressesLabelSheet => 'இந்த முகவரிக்குப் பெயரிடுக';

  @override
  String get supportTitle => 'உதவி & ஆதரவு';

  @override
  String get supportNewTicket => 'புதிய டிக்கெட்';

  @override
  String get supportEmpty => 'இன்னும் ஆதரவு டிக்கெட்டுகள் இல்லை';

  @override
  String get supportEmptyMessage =>
      'முன்பதிவு அல்லது ஆப் பற்றி உதவி வேண்டுமா? டிக்கெட் உருவாக்குங்கள், எங்கள் குழு பதிலளிக்கும்.';

  @override
  String get supportLoadFailed =>
      'உங்கள் ஆதரவு டிக்கெட்டுகளை ஏற்ற முடியவில்லை.';

  @override
  String get supportStatusOpen => 'திறந்துள்ளது';

  @override
  String get supportStatusInProgress => 'நடைபெறுகிறது';

  @override
  String get supportStatusWaitingForYou => 'உங்களுக்காகக் காத்திருக்கிறது';

  @override
  String get supportStatusResolved => 'தீர்க்கப்பட்டது';

  @override
  String get supportStatusClosed => 'மூடப்பட்டது';

  @override
  String get supportNewTicketTitle => 'புதிய ஆதரவு டிக்கெட்';

  @override
  String get supportCategory => 'வகை';

  @override
  String get supportSubject => 'தலைப்பு';

  @override
  String get supportDescribeIssue => 'சிக்கலை விவரிக்கவும்';

  @override
  String get supportFillSubjectMessage =>
      'தலைப்பையும் செய்தியையும் நிரப்பவும்.';

  @override
  String get supportSubmitTicket => 'டிக்கெட்டைச் சமர்ப்பி';

  @override
  String get supportTicketTitle => 'ஆதரவு டிக்கெட்';

  @override
  String get supportNoMessages => 'இன்னும் செய்திகள் இல்லை';

  @override
  String get supportMessagesLoadFailed => 'செய்திகளை ஏற்ற முடியவில்லை.';

  @override
  String get supportTypeMessage => 'செய்தியைத் தட்டச்சு செய்யவும்...';

  @override
  String get supportSend => 'அனுப்பு';

  @override
  String get pickerEnterAddress =>
      'இந்த பின்னுக்கான முகவரியை உள்ளிடவும் அல்லது உறுதிசெய்யவும்';

  @override
  String get pickerTitle => 'சேவை முகவரியைத் தேர்ந்தெடு';

  @override
  String get pickerGettingLocation => 'உங்கள் இருப்பிடத்தைப் பெறுகிறது...';

  @override
  String get pickerPermissionDenied =>
      'இருப்பிட அனுமதி மறுக்கப்பட்டது — முகவரியைத் தேர்ந்தெடுக்க வரைபடத்தை நீங்களே நகர்த்தவும்.';

  @override
  String get pickerConfirmPin => 'சேவை பின் இடத்தை உறுதிசெய்';

  @override
  String get pickerAddressLabel => 'வீடு / பிளாட் / தெருப் பெயர்';

  @override
  String get pickerAddressHint => 'எ.கா. #102, கிரீன் அவென்யூ, இந்திரா நகர்';

  @override
  String get pickerLandmarkLabel => 'அடையாளம் (விருப்பத்தேர்வு)';

  @override
  String get pickerLandmarkHint => 'எ.கா. HDFC வங்கி ATM அருகில்';

  @override
  String get pickerConfirm => 'இருப்பிடத்தை உறுதிசெய்து தொடரவும்';

  @override
  String get requestSelectLocation => 'சேவை இடத்தைத் தேர்ந்தெடுக்கவும்';

  @override
  String requestTitle(Object service) {
    return '$service கோருக';
  }

  @override
  String get requestServiceAddress => 'சேவை முகவரி';

  @override
  String get requestDetectingLocation => 'உங்கள் இருப்பிடத்தைக் கண்டறிகிறது…';

  @override
  String get requestTapToPickLocation =>
      'சேவை இடத்தைத் தேர்ந்தெடுக்கத் தட்டவும்';

  @override
  String get requestDescribeIssue => 'சிக்கல் / வேலையை விவரிக்கவும்';

  @override
  String get requestDescribeHint =>
      'எ.கா. வரவேற்பறையின் முக்கிய மேற்கூரை விளக்கு சுவிட்சை இயக்கும்போது தீப்பொறி வருகிறது.';

  @override
  String get requestDescribeMin =>
      'சிக்கலைக் குறைந்தது 10 எழுத்துகளில் விவரிக்கவும்';

  @override
  String get requestAttachPhotos =>
      'சிக்கலின் புகைப்படங்களை இணைக்கவும் (விருப்பத்தேர்வு)';

  @override
  String get requestAddPhoto => 'புகைப்படத்தைச் சேர்';

  @override
  String get requestWhen => 'உங்களுக்குச் சேவை எப்போது வேண்டும்?';

  @override
  String get requestInstant => '⚡ உடனடி (30 நிமி)';

  @override
  String get requestScheduleLater => '📅 பின்னர் திட்டமிடு';

  @override
  String get requestFindWorkers => 'கிடைக்கும் பணியாளர்களைக் கண்டறிக';

  @override
  String commonLoadFailedDetail(Object detail) {
    return 'ஏற்ற முடியவில்லை: $detail';
  }

  @override
  String get myRequestsTitle => 'என் சேவைக் கோரிக்கைகள்';

  @override
  String get myRequestsTabAll => 'அனைத்தும்';

  @override
  String get myRequestsNew => 'புதிய கோரிக்கை';

  @override
  String get myRequestsNoActive => 'செயலில் உள்ள கோரிக்கைகள் இல்லை';

  @override
  String get myRequestsNoCompleted => 'முடிந்த கோரிக்கைகள் இல்லை';

  @override
  String get myRequestsNone => 'இன்னும் சேவைக் கோரிக்கைகள் இல்லை';

  @override
  String get myRequestsEmptyMessage =>
      'உங்கள் தேவையை இடுங்கள், பணியாளர்கள் உங்களிடம் வருவார்கள்.';

  @override
  String get requestDetailTitle => 'கோரிக்கை விவரங்கள்';

  @override
  String get requestDetailBudget => 'பட்ஜெட்';

  @override
  String get requestDetailSchedule => 'அட்டவணை';

  @override
  String get requestDetailLocation => 'இருப்பிடம்';

  @override
  String get requestDetailNotes => 'குறிப்புகள்';

  @override
  String get requestDetailCancel => 'கோரிக்கையை ரத்துசெய்';

  @override
  String requestDetailOffersReceived(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count சலுகைகள் வந்துள்ளன',
      one: '1 சலுகை வந்துள்ளது',
      zero: 'இன்னும் சலுகைகள் இல்லை',
    );
    return '$_temp0';
  }

  @override
  String get requestDetailTapToCompare => 'பார்க்கவும் ஒப்பிடவும் தட்டவும்';

  @override
  String get requestDetailWorkersSoon =>
      'பணியாளர்கள் விரைவில் பதிலளிக்கத் தொடங்குவார்கள்';

  @override
  String get requestCancelDialogTitle => 'இந்தக் கோரிக்கையை ரத்துசெய்யவா?';

  @override
  String get requestCancelDialogBody =>
      'நிலுவையில் உள்ள அனைத்துச் சலுகைகளும் மூடப்படும். இதைத் திரும்பப் பெற முடியாது.';

  @override
  String get requestCancelKeep => 'வைத்திரு';

  @override
  String get requestCancelConfirm => 'கோரிக்கையை ரத்துசெய்';

  @override
  String get requestCancelled => 'கோரிக்கை ரத்துசெய்யப்பட்டது';

  @override
  String requestExpiresInDaysHours(int days, int hours) {
    return '$days நாள் $hours மணியில் காலாவதியாகும்';
  }

  @override
  String requestExpiresInHoursMinutes(int hours, int minutes) {
    return '$hours மணி $minutes நிமியில் காலாவதியாகும்';
  }

  @override
  String requestExpiresInMinutes(Object minutes) {
    return '$minutes நிமியில் காலாவதியாகும்';
  }

  @override
  String get requestExpiresSoon => 'விரைவில் காலாவதியாகும்';

  @override
  String get commonCancel => 'ரத்துசெய்';

  @override
  String get offersTitle => 'பெற்ற சலுகைகள்';

  @override
  String get offersEmptyMessage =>
      'பணியாளர்கள் உங்கள் கோரிக்கையைப் பார்க்கிறார்கள். யாராவது பதிலளித்தால் உங்களுக்குத் தெரிவிக்கப்படும்.';

  @override
  String get offersPending => 'நிலுவையில் உள்ள சலுகைகள்';

  @override
  String get offersPast => 'முந்தைய சலுகைகள்';

  @override
  String offersJobsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count வேலைகள்',
      one: '1 வேலை',
    );
    return '$_temp0';
  }

  @override
  String get offersInsured => 'காப்பீடு உள்ளது';

  @override
  String get offersDecline => 'மறு';

  @override
  String get offersAcceptOffer => 'சலுகையை ஏற்கவும்';

  @override
  String get offersAcceptDialogTitle => 'இந்தச் சலுகையை ஏற்கவா?';

  @override
  String offersAcceptDialogBody(String worker, String price) {
    return '$worker உடன் $price-க்கு முன்பதிவு உருவாக்கப்படும். மற்ற அனைத்துச் சலுகைகளும் மூடப்படும்.';
  }

  @override
  String get offersAccept => 'ஏற்கவும்';

  @override
  String offersBookingCreated(Object code) {
    return 'முன்பதிவு $code உருவாக்கப்பட்டது!';
  }

  @override
  String get commonNext => 'அடுத்து';

  @override
  String postRequestPosted(Object code) {
    return 'சேவைக் கோரிக்கை $code இடப்பட்டது!';
  }

  @override
  String get postRequestTitle => 'சேவைக் கோரிக்கையை இடுக';

  @override
  String get postRequestWhatService => 'உங்களுக்கு என்ன சேவை வேண்டும்?';

  @override
  String get postRequestSelectCategory =>
      'உங்கள் தேவையைச் சிறப்பாக விவரிக்கும் வகையைத் தேர்ந்தெடுக்கவும்.';

  @override
  String get postRequestDescribe => 'உங்கள் தேவையை விவரிக்கவும்';

  @override
  String postRequestServiceLabel(Object service) {
    return 'சேவை: $service';
  }

  @override
  String get postRequestWhatDone => 'என்ன வேலை செய்ய வேண்டும்?';

  @override
  String get postRequestFieldTitle => 'தலைப்பு';

  @override
  String get postRequestTitleHint =>
      'எ.கா. சமையலறையில் ஒழுகும் குழாயைச் சரிசெய்தல்';

  @override
  String postRequestMinChars(Object count) {
    return 'குறைந்தது $count எழுத்துகளை உள்ளிடவும்';
  }

  @override
  String get postRequestFieldDescription => 'விளக்கம்';

  @override
  String get postRequestDescriptionHint => 'சிக்கலை விரிவாக விவரிக்கவும்…';

  @override
  String get postRequestFieldNotes => 'கூடுதல் குறிப்புகள் (விருப்பத்தேர்வு)';

  @override
  String get postRequestNotesHint => 'கேட் குறியீடு, விருப்பமான நேரம் போன்றவை';

  @override
  String get postRequestBudgetTitle => 'உங்கள் பட்ஜெட்';

  @override
  String get postRequestBudgetHint =>
      'நீங்கள் எவ்வளவு செலுத்தத் தயார் என்பதைப் பணியாளர்களுக்குத் தெரிவிக்கவும்.';

  @override
  String get postRequestFixedPrice => 'நிலையான விலை (₹)';

  @override
  String postRequestExample(Object example) {
    return 'எ.கா. $example';
  }

  @override
  String get postRequestMin => 'குறைந்தபட்சம் (₹)';

  @override
  String get postRequestMax => 'அதிகபட்சம் (₹)';

  @override
  String get postRequestWhenTitle => 'இது உங்களுக்கு எப்போது வேண்டும்?';

  @override
  String get postRequestPickDate => 'தேதியைத் தேர்ந்தெடு';

  @override
  String get postRequestLocationTitle => 'சேவை இடம்';

  @override
  String get postRequestAddressPrivate =>
      'நீங்கள் சலுகையை ஏற்ற பிறகே உங்கள் சரியான முகவரி பகிரப்படும்.';

  @override
  String get postRequestFullAddress => 'முழு முகவரி';

  @override
  String get postRequestValidAddress => 'சரியான முகவரியை உள்ளிடவும்';

  @override
  String get postRequestCity => 'நகரம்';

  @override
  String get postRequestCityHint => 'எ.கா. பெங்களூரு';

  @override
  String get postRequestPincode => 'பின்கோடு';

  @override
  String get postRequestLocationSet => 'இருப்பிடம் அமைக்கப்பட்டது ✓';

  @override
  String get postRequestSetOnMap => 'வரைபடத்தில் இருப்பிடத்தை அமை';

  @override
  String get postRequestReviewTitle => 'உங்கள் கோரிக்கையைச் சரிபார்க்கவும்';

  @override
  String get postRequestNotSelected => 'தேர்ந்தெடுக்கப்படவில்லை';

  @override
  String get postRequestWhen => 'எப்போது';

  @override
  String get postRequestPrivacyNote =>
      'நீங்கள் சலுகையை ஏற்று முன்பதிவு உருவாகும் வரை உங்கள் சரியான முகவரி தனிப்பட்டதாக இருக்கும்.';

  @override
  String get postRequestSubmit => 'கோரிக்கையைச் சமர்ப்பி';

  @override
  String get assistantOpening =>
      'என்ன பிரச்சினை என்று உங்கள் சொந்த வார்த்தைகளில் சொல்லுங்கள் — அதற்கான சரியான நிபுணரைக் கண்டுபிடிக்கிறேன்.';

  @override
  String assistantCatalogueFailed(Object reason) {
    return '$reason அதற்குப் பதிலளிக்க எனக்குச் சேவைப் பட்டியல் தேவை.';
  }

  @override
  String get assistantCatalogueError =>
      'சேவைப் பட்டியலை ஏற்றுவதில் ஏதோ தவறு நடந்தது.';

  @override
  String get assistantGreeting =>
      'வணக்கம். வீட்டில் உங்களுக்கு எதில் உதவி தேவை? ஒழுகும் குழாய், குளிராத AC, தீப்பொறி வரும் சுவிட்ச் — எதுவாக இருந்தாலும், உங்களுக்கு விருப்பமான முறையில் விவரிக்கவும்.';

  @override
  String get assistantTooVague =>
      'என்னால் உதவ முடியும் — பிரச்சினை என்னவென்று தெரிய வேண்டும். எது வேலை செய்யவில்லை?';

  @override
  String assistantMultipleJobs(int count) {
    return 'இவை $count தனித்தனி வேலைகள் போல் தெரிகின்றன — வெவ்வேறு தொழிலாளர்கள் தேவை. ஒவ்வொன்றும் இதோ:';
  }

  @override
  String get assistantAmbiguous =>
      'இதைச் சரியாகச் செய்ய விரும்புகிறேன் — இது ஒன்றுக்கு மேற்பட்ட தொழில்களுக்குப் பொருந்தலாம். எது நெருக்கமானது?';

  @override
  String get assistantUnmatched =>
      'தளத்தில் உள்ள எந்தச் சேவையுடனும் இதைப் பொருத்த முடியவில்லை. நெருக்கமானதைத் தேர்ந்தெடுங்கள், உங்கள் விளக்கத்தை அங்கே கொண்டு செல்கிறேன் — அல்லது கோரிக்கையாக இடுங்கள், நிபுணர்கள் உங்களிடம் வருவார்கள்.';

  @override
  String assistantConfidentWithProblem(String service, String problem) {
    return 'இது $service வேலை போல் தெரிகிறது — பெரும்பாலும் \"$problem\".';
  }

  @override
  String assistantConfident(Object service) {
    return 'இது $service வேலை போல் தெரிகிறது.';
  }

  @override
  String assistantChosen(Object service) {
    return 'சரி, $service. நீங்கள் எழுதிய விளக்கம் அப்படியே அனுப்பப்படும்.';
  }

  @override
  String get assistantTitle => 'சேவை உதவியாளர்';

  @override
  String get assistantSubtitle =>
      'உங்கள் பிரச்சினைக்குச் சரியான தொழிலைக் கண்டறிகிறது';

  @override
  String get assistantStartOver => 'மீண்டும் தொடங்கு';

  @override
  String assistantMatchedOn(Object terms) {
    return 'பொருந்தியவை: $terms';
  }

  @override
  String get assistantFindWorkers => 'பணியாளர்களைக் கண்டறிக';

  @override
  String get assistantPostRequest => 'கோரிக்கையை இடுக';

  @override
  String get assistantInputHint => 'பிரச்சினையை விவரிக்கவும்...';
}
