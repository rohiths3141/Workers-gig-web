// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Telugu (`te`).
class AppLocalizationsTe extends AppLocalizations {
  AppLocalizationsTe([String locale = 'te']) : super(locale);

  @override
  String get commonRetry => 'మళ్లీ ప్రయత్నించండి';

  @override
  String get commonTryAgain => 'మళ్లీ ప్రయత్నించండి';

  @override
  String get commonSignOut => 'సైన్ అవుట్ చేయండి';

  @override
  String get assistantFabLabel => 'AI ని అడగండి';

  @override
  String get navHome => 'హోమ్';

  @override
  String get navExplore => 'అన్వేషించండి';

  @override
  String get navBookings => 'బుకింగ్‌లు';

  @override
  String get navAlerts => 'హెచ్చరికలు';

  @override
  String get navProfile => 'ప్రొఫైల్';

  @override
  String get configErrorTitle => 'యాప్ కాన్ఫిగర్ చేయబడలేదు';

  @override
  String configErrorBody(String keys, String command) {
    return 'ఈ బిల్డ్‌లో $keys లేదు. ఇలా రన్ చేయండి:\n\n$command\n\nఅప్పుడే యాప్ అసలు బ్యాకెండ్‌ను చేరుకోగలదు.';
  }

  @override
  String get sessionProfileLoadFailedRetry =>
      'మీ ప్రొఫైల్‌ను లోడ్ చేయలేకపోయాము. దయచేసి మళ్లీ ప్రయత్నించండి.';

  @override
  String get sessionProfileLoadFailed => 'మీ ప్రొఫైల్‌ను లోడ్ చేయలేకపోయాము';

  @override
  String get sessionCheckClock => 'మీ ఫోన్ గడియారాన్ని తనిఖీ చేయండి';

  @override
  String get splashTagline => 'ఇంటి సేవలు, సరైన పద్ధతిలో.';

  @override
  String get timelineBookingConfirmed => 'బుకింగ్ నిర్ధారించబడింది';

  @override
  String get timelineProviderOnTheWay => 'సేవ అందించేవారు దారిలో ఉన్నారు';

  @override
  String get timelineServiceInProgress => 'సేవ జరుగుతోంది';

  @override
  String get timelineCompleted => 'పూర్తయింది';

  @override
  String get errorNoInternet =>
      'ఇంటర్నెట్ కనెక్షన్ లేదు. మీ నెట్‌వర్క్‌ను తనిఖీ చేసి మళ్లీ ప్రయత్నించండి.';

  @override
  String get errorTimeout => 'దీనికి చాలా సమయం పట్టింది. మళ్లీ ప్రయత్నించండి.';

  @override
  String get errorServer =>
      'మా వైపు ఏదో పొరపాటు జరిగింది. దయచేసి మళ్లీ ప్రయత్నించండి.';

  @override
  String get errorClockSkew =>
      'మీ ఫోన్ తేదీ మరియు సమయం సరిగ్గా లేవు. సెట్టింగ్‌లలో ఆటోమేటిక్ తేదీ & సమయాన్ని ఆన్ చేసి మళ్లీ ప్రయత్నించండి.';

  @override
  String get errorUnexpected =>
      'ఏదో పొరపాటు జరిగింది. దయచేసి మళ్లీ ప్రయత్నించండి.';

  @override
  String get errorSessionEnded =>
      'మీ సెషన్ ముగిసింది. దయచేసి మళ్లీ సైన్ ఇన్ చేయండి.';

  @override
  String get errorUploadFailed =>
      'ఆ ఫైల్‌ను అప్‌లోడ్ చేయలేకపోయాము. మళ్లీ ప్రయత్నించండి.';

  @override
  String get errorSignInNotReady =>
      'మీ సైన్-ఇన్ ఇంకా పూర్తిగా సిద్ధం కాలేదు. కొద్దిసేపటి తర్వాత మళ్లీ ప్రయత్నించండి.';

  @override
  String get errorNoLongerAvailable => 'అది ఇప్పుడు అందుబాటులో లేదు.';

  @override
  String get errorNotAllowedToSee => 'మీరు దాన్ని చూడలేరు.';

  @override
  String get errorDidNotWork => 'అది పని చేయలేదు. దయచేసి మళ్లీ ప్రయత్నించండి.';

  @override
  String get authErrorInvalidPhone => 'ఆ ఫోన్ నంబర్ సరిగ్గా అనిపించడం లేదు.';

  @override
  String get authErrorWrongCode =>
      'ఆ కోడ్ సరైనది కాదు. తనిఖీ చేసి మళ్లీ ప్రయత్నించండి.';

  @override
  String get authErrorCodeExpired =>
      'ఆ కోడ్ గడువు ముగిసింది. కొత్త కోడ్ అడగండి.';

  @override
  String get authErrorTooManyAttempts =>
      'చాలా ప్రయత్నాలు జరిగాయి. మళ్లీ ప్రయత్నించే ముందు కొన్ని నిమిషాలు ఆగండి.';

  @override
  String get authErrorQuota =>
      'ప్రస్తుతం కోడ్ పంపలేకపోతున్నాము. కొద్దిసేపటి తర్వాత మళ్లీ ప్రయత్నించండి.';

  @override
  String get authErrorDisabled =>
      'ఈ ఖాతా నిలిపివేయబడింది. సహాయ కేంద్రాన్ని సంప్రదించండి.';

  @override
  String get authErrorPhoneNotEnabled =>
      'ఫోన్ సైన్-ఇన్ ప్రారంభించబడలేదు. సహాయ కేంద్రాన్ని సంప్రదించండి.';

  @override
  String get authErrorNumberInUse => 'ఆ నంబర్ ఇప్పటికే వేరే ఖాతాకు నమోదై ఉంది.';

  @override
  String get authErrorSignInAgain =>
      'కొనసాగించడానికి దయచేసి మళ్లీ సైన్ ఇన్ చేయండి.';

  @override
  String get authErrorSignInFailed =>
      'సైన్-ఇన్ విఫలమైంది. దయచేసి మళ్లీ ప్రయత్నించండి.';

  @override
  String get languagePickerTitle => 'మీ భాషను ఎంచుకోండి';

  @override
  String get authCouldNotStartVerification =>
      'ధృవీకరణను ప్రారంభించలేకపోయాము. దయచేసి మళ్లీ ప్రయత్నించండి.';

  @override
  String get authWelcomeTitle => 'Wervexa కు స్వాగతం';

  @override
  String get authWelcomeSubtitle =>
      'ఇంటి మరమ్మతులు, ప్లంబింగ్, ఎలక్ట్రికల్, క్లీనింగ్ మరియు మరెన్నో పనులకు దగ్గర్లోని అత్యుత్తమ నిపుణులను కనుగొనండి.';

  @override
  String get authEnterPhone => 'మీ ఫోన్ నంబర్‌ను నమోదు చేయండి';

  @override
  String get authInvalidMobile => 'సరైన 10 అంకెల మొబైల్ నంబర్‌ను నమోదు చేయండి';

  @override
  String get authGetOtp => 'OTP ధృవీకరణ పొందండి';

  @override
  String get authTermsNotice =>
      'కొనసాగించడం ద్వారా మీరు మా సేవా నిబంధనలు & గోప్యతా విధానానికి అంగీకరిస్తున్నారు';

  @override
  String get authNewCodeSent => 'మేము కొత్త కోడ్ పంపాము.';

  @override
  String get authVerifyPhoneTitle => 'ఫోన్‌ను ధృవీకరించండి';

  @override
  String get authChangeNumber => 'నంబర్ మార్చండి';

  @override
  String get authEnterCodeTitle => '6 అంకెల కోడ్ నమోదు చేయండి';

  @override
  String authCodeSentTo(Object phone) {
    return '$phone కు SMS ధృవీకరణ కోడ్ పంపాము';
  }

  @override
  String get authWrongNumber => 'తప్పు నంబరా? మార్చండి';

  @override
  String get authEnterSixDigits => 'దయచేసి 6 అంకెలు నమోదు చేయండి';

  @override
  String get authResendCode => 'కోడ్‌ను మళ్లీ పంపండి';

  @override
  String authResendCodeIn(Object seconds) {
    return '$seconds సెకన్లలో కోడ్‌ను మళ్లీ పంపండి';
  }

  @override
  String get authVerifyAndContinue => 'ధృవీకరించి కొనసాగించండి';

  @override
  String get registerTitle => 'ప్రొఫైల్‌ను పూర్తి చేయండి';

  @override
  String get registerHeading => 'మీ పేరు చెప్పండి';

  @override
  String get registerNameVisibility =>
      'మీరు బుకింగ్ అభ్యర్థన చేసినప్పుడు మీ పేరు సేవా కార్మికులకు కనిపిస్తుంది.';

  @override
  String get registerFullNameLabel => 'పూర్తి పేరు *';

  @override
  String get registerFullNameHint => 'ఉదా. రాహుల్ శర్మ';

  @override
  String get registerFullNameRequired => 'దయచేసి మీ పూర్తి పేరు నమోదు చేయండి';

  @override
  String get registerEmailLabel => 'ఇమెయిల్ చిరునామా (ఐచ్ఛికం)';

  @override
  String get registerEmailHint => 'ఉదా. rahul@example.com';

  @override
  String get registerSubmit => 'సేవ్ చేసి ప్రారంభించండి';

  @override
  String get bookingStatusRequested => 'నిపుణుడిని వెతుకుతున్నాము…';

  @override
  String get bookingStatusAccepted => 'నిపుణుడు దొరికారు';

  @override
  String get bookingStatusConfirmed => 'నిర్ధారించబడింది';

  @override
  String get bookingStatusTraveling => 'దారిలో ఉన్నారు';

  @override
  String get bookingStatusArrived => 'చేరుకున్నారు — మీ కోడ్ నమోదు చేయండి';

  @override
  String get bookingStatusInProgress => 'పని జరుగుతోంది';

  @override
  String get bookingStatusAwaitingApproval =>
      'పని పూర్తయింది — కొనసాగడానికి ఆమోదించండి';

  @override
  String get bookingStatusCompleted => 'పూర్తయింది';

  @override
  String get bookingStatusPaymentPending => 'చెల్లింపు పెండింగ్‌లో ఉంది';

  @override
  String get bookingStatusPaid => 'చెల్లించబడింది';

  @override
  String get bookingStatusClosed => 'మూసివేయబడింది';

  @override
  String get bookingStatusCancelled => 'రద్దు చేయబడింది';

  @override
  String get bookingStatusDisputed => 'వివాదంలో ఉంది';

  @override
  String get bookingStatusExpired => 'గడువు ముగిసింది — ఎవరూ అందుబాటులో లేరు';

  @override
  String get pricingPerJob => 'ప్రతి పనికి';

  @override
  String get pricingPerHour => 'గంటకు';

  @override
  String get pricingPerDay => 'రోజుకు';

  @override
  String get pricingPerUnit => 'యూనిట్‌కు';

  @override
  String get pricingPerSqft => 'చ.అడుగుకు';

  @override
  String get supportCategoryBooking => 'బుకింగ్ సమస్య';

  @override
  String get supportCategoryPayment => 'చెల్లింపు';

  @override
  String get supportCategoryPayout => 'పేఅవుట్';

  @override
  String get supportCategoryVerification => 'ధృవీకరణ';

  @override
  String get supportCategoryAccount => 'నా ఖాతా';

  @override
  String get supportCategorySafety => 'భద్రతా సమస్య';

  @override
  String get supportCategoryClaim => 'బీమా క్లెయిమ్';

  @override
  String get supportCategoryAppIssue => 'యాప్ సమస్య';

  @override
  String get supportCategoryOther => 'ఇతర';

  @override
  String get requestStatusDraft => 'డ్రాఫ్ట్';

  @override
  String get requestStatusOpen => 'తెరిచి ఉంది — ఆఫర్‌ల కోసం ఎదురుచూస్తోంది';

  @override
  String get requestStatusReceivingOffers => 'ఆఫర్‌లు వస్తున్నాయి';

  @override
  String get requestStatusWorkerSelected => 'నిపుణుడు ఎంపికయ్యారు';

  @override
  String get requestStatusBooked => 'బుక్ అయింది';

  @override
  String get requestStatusCancelled => 'రద్దు చేయబడింది';

  @override
  String get requestStatusExpired => 'గడువు ముగిసింది';

  @override
  String get requestStatusClosed => 'మూసివేయబడింది';

  @override
  String get budgetTypeFlexible => 'సర్దుబాటు';

  @override
  String get budgetTypeFixed => 'స్థిర ధర';

  @override
  String get budgetTypeRange => 'ధర పరిధి';

  @override
  String get scheduleAsap => 'వీలైనంత త్వరగా';

  @override
  String get scheduleToday => 'ఈరోజు';

  @override
  String get scheduleTomorrow => 'రేపు';

  @override
  String get scheduleSpecificDate => 'నిర్దిష్ట తేదీన';

  @override
  String get scheduleScheduled => 'షెడ్యూల్ చేయబడింది';

  @override
  String get offerStatusSubmitted => 'కొత్త ఆఫర్';

  @override
  String get offerStatusViewed => 'చూశారు';

  @override
  String get offerStatusShortlisted => 'షార్ట్‌లిస్ట్ చేయబడింది';

  @override
  String get offerStatusAccepted => 'అంగీకరించబడింది';

  @override
  String get offerStatusRejected => 'తిరస్కరించబడింది';

  @override
  String get offerStatusWithdrawn => 'కార్మికుడు ఉపసంహరించుకున్నారు';

  @override
  String get offerStatusExpired => 'గడువు ముగిసింది';

  @override
  String get offerStatusClosed => 'మూసివేయబడింది';

  @override
  String get gigRatingNew => 'కొత్త';

  @override
  String distanceMetres(Object metres) {
    return '$metres మీ';
  }

  @override
  String distanceKm(Object km) {
    return '$km కి.మీ';
  }

  @override
  String durationMinutes(Object minutes) {
    return '$minutes ని';
  }

  @override
  String durationHours(Object hours) {
    return '$hours గం';
  }

  @override
  String durationHoursMinutes(int hours, int minutes) {
    return '$hours గం $minutes ని';
  }

  @override
  String get offerWorkerFallbackName => 'నిపుణుడు';

  @override
  String get budgetFlexible => 'సర్దుబాటు బడ్జెట్';

  @override
  String get budgetFixed => 'స్థిర బడ్జెట్';

  @override
  String offerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ఆఫర్‌లు',
      one: '1 ఆఫర్',
      zero: 'ఇంకా ఆఫర్‌లు లేవు',
    );
    return '$_temp0';
  }

  @override
  String get authPhoneTenDigits => '10 అంకెల మొబైల్ నంబర్ నమోదు చేయండి.';

  @override
  String get authCodeSendTimeout =>
      'కోడ్ పంపలేకపోయాము. మీ నెట్‌వర్క్‌ను తనిఖీ చేసి మళ్లీ ప్రయత్నించండి.';

  @override
  String get authEnterReceivedCode => 'మీకు వచ్చిన కోడ్‌ను నమోదు చేయండి.';

  @override
  String get authSignInIncomplete =>
      'సైన్-ఇన్ పూర్తి కాలేదు. దయచేసి మళ్లీ ప్రయత్నించండి.';

  @override
  String get authSignInToContinue => 'కొనసాగించడానికి దయచేసి సైన్ ఇన్ చేయండి.';

  @override
  String get paymentsNotConfigured =>
      'ఈ బిల్డ్‌కు చెల్లింపులు ఇంకా కాన్ఫిగర్ చేయబడలేదు.';

  @override
  String get serviceElectrical => 'ఎలక్ట్రికల్';

  @override
  String get servicePlumbing => 'ప్లంబింగ్';

  @override
  String get serviceAcService => 'AC సర్వీస్';

  @override
  String get serviceApplianceRepair => 'ఉపకరణాల మరమ్మతు';

  @override
  String get serviceCarpentry => 'వడ్రంగి పని';

  @override
  String get servicePainting => 'పెయింటింగ్';

  @override
  String get serviceCleaning => 'క్లీనింగ్';

  @override
  String get servicePestControl => 'పురుగుల నియంత్రణ';

  @override
  String get serviceOtherHome => 'ఇతర ఇంటి సేవలు';

  @override
  String get addressLabelHome => 'హోమ్';

  @override
  String get addressLabelWork => 'ఆఫీస్';

  @override
  String get addressLabelOther => 'ఇతర';

  @override
  String get commonSeeAll => 'అన్నీ చూడండి';

  @override
  String get commonViewAll => 'అన్నీ చూడండి';

  @override
  String get commonCheckBackLater => 'దయచేసి తర్వాత మళ్లీ చూడండి.';

  @override
  String get commonUseCurrentLocation => 'ప్రస్తుత స్థానాన్ని ఉపయోగించండి';

  @override
  String get commonChooseOnMap => 'మ్యాప్‌లో ఎంచుకోండి';

  @override
  String homeGreetingNamed(Object name) {
    return 'నమస్కారం, $name 👋';
  }

  @override
  String get homeGreeting => 'నమస్కారం 👋';

  @override
  String get homeWhatService => 'ఈరోజు మీకు ఏ సేవ కావాలి?';

  @override
  String get homeSetLocation => 'మీ స్థానాన్ని సెట్ చేయండి';

  @override
  String get homeWorkFinishedApprove =>
      'పని పూర్తయింది — ఆమోదించడానికి నొక్కండి';

  @override
  String get homeCategories => 'వర్గాలు';

  @override
  String homeCategoriesLoadFailed(Object error) {
    return 'వర్గాలను లోడ్ చేయలేకపోయాము: $error';
  }

  @override
  String get homeFindWorker => 'కార్మికుడిని కనుగొనండి';

  @override
  String get homeFindWorkerSubtitle => 'దగ్గర్లోని సేవలను చూడండి';

  @override
  String get homePostRequest => 'అభ్యర్థనను పోస్ట్ చేయండి';

  @override
  String get homePostRequestSubtitle => 'కార్మికులు మీ దగ్గరికి వస్తారు';

  @override
  String get homeNoServices => 'ప్రస్తుతం సేవలు ఏవీ అందుబాటులో లేవు';

  @override
  String get homeSearchNear => 'దగ్గర్లో సేవలను వెతకండి';

  @override
  String get homeSearchHint => 'సేవల కోసం వెతకండి...';

  @override
  String homeActiveBooking(Object code) {
    return 'యాక్టివ్ బుకింగ్ #$code';
  }

  @override
  String get homeActiveRequests => 'మీ యాక్టివ్ అభ్యర్థనలు';

  @override
  String get commonGrantPermission => 'అనుమతి ఇవ్వండి';

  @override
  String get commonView => 'చూడండి';

  @override
  String get exploreTitle => 'సేవలను అన్వేషించండి & కనుగొనండి';

  @override
  String get exploreListView => 'జాబితా వీక్షణ';

  @override
  String get exploreMapView => 'మ్యాప్ వీక్షణ';

  @override
  String get exploreSearchHint =>
      'సేవలు, కార్మికులు లేదా నైపుణ్యాల కోసం వెతకండి...';

  @override
  String get exploreLocationOffTitle => 'లొకేషన్ సేవలు ఆఫ్‌లో ఉన్నాయి';

  @override
  String get exploreLocationOffMessage =>
      'దగ్గర్లోని నిపుణులను కనుగొనడానికి లొకేషన్ ఆన్ చేయండి.';

  @override
  String get exploreLocationPermissionTitle => 'లొకేషన్ అనుమతి అవసరం';

  @override
  String get exploreLocationPermissionMessage =>
      'దగ్గర్లోని నిపుణులను కనుగొనడానికి మేము మీ లొకేషన్‌ను ఉపయోగిస్తాము.';

  @override
  String get exploreChooseService => 'అన్వేషించడానికి ఒక సేవను ఎంచుకోండి';

  @override
  String get exploreChooseServiceMessage =>
      'దగ్గర్లోని నిపుణులను చూడటానికి పైన ఒక వర్గాన్ని ఎంచుకోండి.';

  @override
  String get exploreNoProfessionals =>
      'ఈ సేవకు దగ్గర్లో నిపుణులు ఎవరూ అందుబాటులో లేరు';

  @override
  String get exploreLoadFailed => 'నిపుణులను లోడ్ చేయలేకపోయాము.';

  @override
  String exploreByWorker(Object name) {
    return '$name ద్వారా';
  }

  @override
  String get bookingsTitle => 'నా సేవా బుకింగ్‌లు';

  @override
  String get bookingsTabActive => 'యాక్టివ్';

  @override
  String get bookingsTabCompleted => 'పూర్తయింది';

  @override
  String get bookingsTabCancelled => 'రద్దు చేయబడింది';

  @override
  String get bookingsLoadFailed => 'మీ బుకింగ్‌లను లోడ్ చేయలేకపోయాము.';

  @override
  String get bookingsEmpty => 'ఇంకా బుకింగ్‌లు లేవు';

  @override
  String get bookingsFindService => 'సేవను కనుగొనండి';

  @override
  String get bookingsWaitingForProfessional => 'నిపుణుడి కోసం ఎదురుచూస్తోంది';

  @override
  String bookingsCode(Object code) {
    return 'బుకింగ్ కోడ్: #$code';
  }

  @override
  String get bookingsPayNow => 'ఇప్పుడే చెల్లించండి';

  @override
  String get bookingsApproveWork => 'పనిని ఆమోదించండి';

  @override
  String get bookingsTrackLive => 'లైవ్‌గా ట్రాక్ చేయండి';

  @override
  String get bookingsDetails => 'వివరాలు';

  @override
  String get bookingDetailTitle => 'బుకింగ్ వివరాలు';

  @override
  String get bookingDetailLoadFailed => 'బుకింగ్ వివరాలను లోడ్ చేయలేకపోయాము.';

  @override
  String get bookingDetailWaitingAccept =>
      'నిపుణుడు అంగీకరించడం కోసం ఎదురుచూస్తోంది';

  @override
  String bookingDetailNumber(Object code) {
    return 'బుకింగ్ #$code';
  }

  @override
  String bookingDetailStatus(Object status) {
    return 'స్థితి: $status';
  }

  @override
  String get bookingDetailLiveMap => 'లైవ్ మ్యాప్';

  @override
  String get bookingDetailServiceInfo => 'సేవా అభ్యర్థన సమాచారం';

  @override
  String get bookingDetailViewMaterials =>
      'సామగ్రి / విడిభాగాల అభ్యర్థనలను చూడండి';

  @override
  String get bookingDetailFareDetails => 'ఛార్జీ వివరాలు';

  @override
  String get bookingDetailEstimatedFare => 'అంచనా ఛార్జీ';

  @override
  String get bookingDetailFinalFare => 'తుది నిర్ధారిత ఛార్జీ';

  @override
  String get bookingDetailRateReview =>
      'సేవా కార్మికుడికి రేటింగ్ & సమీక్ష ఇవ్వండి';

  @override
  String get bookingDetailApproveCompletion => 'పని పూర్తయినట్లు ఆమోదించండి';

  @override
  String get bookingDetailApprovePaidHint =>
      'మీ నిపుణుడు ఈ పనిని పూర్తయినట్లు గుర్తించారు. ఆమోదిస్తే మీ చెల్లింపు వారికి విడుదల అవుతుంది.';

  @override
  String get bookingDetailApproveUnpaidHint =>
      'మీ నిపుణుడు ఈ పనిని పూర్తయినట్లు గుర్తించారు. నిర్ధారించి చెల్లింపుకు వెళ్లడానికి ఆమోదించండి.';

  @override
  String get bookingDetailReportProblem => 'సమస్యను నివేదించండి';

  @override
  String get bookingDetailCompletionApproved => 'పని పూర్తి ఆమోదించబడింది';

  @override
  String bookingDetailPayToConfirm(Object amount) {
    return 'నిర్ధారించడానికి $amount చెల్లించండి';
  }

  @override
  String get bookingDetailSentAfterPayment =>
      'చెల్లింపు పూర్తయిన తర్వాత మీ బుకింగ్ నిపుణుడికి పంపబడుతుంది.';

  @override
  String bookingDetailPayAmount(Object amount) {
    return '$amount చెల్లించండి';
  }

  @override
  String get bookingDetailCancelBooking => 'బుకింగ్‌ను రద్దు చేయండి';

  @override
  String get cancelReasonMistake => 'పొరపాటున బుక్ చేశాను';

  @override
  String get cancelReasonNoLongerNeeded => 'నాకు ఇక ఈ సేవ అవసరం లేదు';

  @override
  String get cancelReasonDifferentTime =>
      'నేను వేరే సమయాన్ని ఎంచుకోవాలనుకుంటున్నాను';

  @override
  String get cancelReasonFoundSomeoneElse => 'నాకు వేరొకరు దొరికారు';

  @override
  String get cancelDialogTitle => 'మీరు ఎందుకు రద్దు చేస్తున్నారు?';

  @override
  String get cancelDialogRefundNotice =>
      'దీన్ని వెనక్కి తీసుకోలేరు. మీ చెల్లింపు అసలు చెల్లింపు పద్ధతికి తిరిగి ఇవ్వబడుతుంది.';

  @override
  String get cancelDialogCannotUndo => 'దీన్ని వెనక్కి తీసుకోలేరు.';

  @override
  String get cancelDialogKeepBooking => 'బుకింగ్‌ను ఉంచండి';

  @override
  String get bookingCancelledRefund =>
      'బుకింగ్ రద్దయింది. మీ రీఫండ్ కోసం అభ్యర్థించబడింది.';

  @override
  String get bookingCancelled => 'బుకింగ్ రద్దయింది';

  @override
  String get arrivalCodeTitle => 'చేరిక కోడ్';

  @override
  String get arrivalCodeShare =>
      'నిపుణుడు చేరుకున్నారని నిర్ధారించడానికి ఈ కోడ్‌ను వారితో పంచుకోండి:';

  @override
  String get arrivalCodeUnavailable => 'అందుబాటులో లేదు';

  @override
  String get arrivalCodeLoadFailed => 'కోడ్‌ను లోడ్ చేయలేకపోయాము';

  @override
  String get activeBookingTitle => 'లైవ్ బుకింగ్ & కార్మికుడి ట్రాకింగ్';

  @override
  String get activeBookingLoadFailed => 'ఈ బుకింగ్‌ను లోడ్ చేయలేకపోయాము.';

  @override
  String get activeBookingMapUnavailable =>
      'ఈ బుకింగ్‌కు లైవ్ మ్యాప్ అందుబాటులో లేదు.';

  @override
  String get activeBookingViewDetails => 'బుకింగ్ వివరాలు చూడండి';

  @override
  String get activeBookingServiceLocation => 'సేవా స్థలం';

  @override
  String get activeBookingYourProfessional => 'మీ నిపుణుడు';

  @override
  String get activeBookingLive => 'లైవ్';

  @override
  String get activeBookingLastKnown => 'చివరిగా తెలిసిన స్థానం';

  @override
  String get activeBookingPhoneNotShared => 'ఫోన్ ఇంకా పంచుకోలేదు';

  @override
  String get activeBookingCallProfessional => 'నిపుణుడికి కాల్ చేయండి';

  @override
  String get activeBookingMaterials => 'సామగ్రి';

  @override
  String get activeBookingViewDetailsShort => 'వివరాలు చూడండి';

  @override
  String get locationConnecting => 'లైవ్ లొకేషన్‌కు కనెక్ట్ అవుతోంది...';

  @override
  String get locationLiveUnavailable =>
      'లైవ్ లొకేషన్ తాత్కాలికంగా అందుబాటులో లేదు';

  @override
  String get locationLiveActive => 'లైవ్ లొకేషన్ యాక్టివ్‌గా ఉంది';

  @override
  String get locationUpdating => 'అప్‌డేట్ అవుతోంది...';

  @override
  String get locationUnavailable => 'లొకేషన్ తాత్కాలికంగా అందుబాటులో లేదు';

  @override
  String get activeBookingShareStartCode =>
      'కార్మికుడు చేరుకున్నారు! ప్రారంభ కోడ్‌ను పంచుకోండి:';

  @override
  String get commonBack => 'వెనక్కి';

  @override
  String get paymentCouldNotOpen =>
      'చెల్లింపు స్క్రీన్‌ను తెరవలేకపోయాము. దయచేసి మళ్లీ ప్రయత్నించండి.';

  @override
  String get paymentReceived =>
      'చెల్లింపు అందింది. మీ బుకింగ్ నిపుణుడికి పంపబడింది.';

  @override
  String paymentNotConfirmed(String reason, String reference) {
    return 'ఈ చెల్లింపును నిర్ధారించలేకపోయాము: $reason. డబ్బు కట్ అయితే, $reference రిఫరెన్స్‌తో సహాయ కేంద్రాన్ని సంప్రదించండి.';
  }

  @override
  String get paymentNotCompleted => 'చెల్లింపు పూర్తి కాలేదు.';

  @override
  String paymentExternalWalletUnsupported(Object wallet) {
    return 'బాహ్య వాలెట్ ($wallet) ఎంచుకున్నారు — ఇది ఇంకా సపోర్ట్ చేయబడదు.';
  }

  @override
  String get paymentTitle => 'చెల్లింపు';

  @override
  String get paymentStatusUnknown =>
      'ఈ బుకింగ్‌కు ఇప్పటికే చెల్లించారో లేదో తనిఖీ చేయలేకపోయాము. రెండుసార్లు చెల్లించకుండా దయచేసి మళ్లీ ప్రయత్నించండి.';

  @override
  String get paymentBookingLoadFailed => 'ఈ బుకింగ్‌ను లోడ్ చేయలేకపోయాము.';

  @override
  String get paymentComplete => 'చెల్లింపు పూర్తయింది';

  @override
  String paymentPaidFor(String amount, String service) {
    return '$service కోసం $amount చెల్లించారు.';
  }

  @override
  String get paymentViewBooking => 'బుకింగ్ చూడండి';

  @override
  String get paymentBookingSummary => 'బుకింగ్ సారాంశం';

  @override
  String get paymentProvider => 'సేవ అందించేవారు';

  @override
  String get paymentService => 'సేవ';

  @override
  String get paymentDate => 'తేదీ';

  @override
  String get paymentTime => 'సమయం';

  @override
  String get paymentAddress => 'చిరునామా';

  @override
  String get paymentTotal => 'మొత్తం';

  @override
  String get paymentHeldSecurely =>
      'మీ చెల్లింపు సురక్షితంగా ఉంచబడుతుంది, మీరు పనిని ఆమోదించిన తర్వాత మాత్రమే నిపుణుడికి విడుదల అవుతుంది. పని ప్రారంభం కాకముందే బుకింగ్ రద్దయితే, మీకు రీఫండ్ వస్తుంది.';

  @override
  String get commonChange => 'మార్చండి';

  @override
  String get bookMissingDetails =>
      'బుకింగ్ వివరాలు లేవు — దయచేసి మళ్లీ ప్రారంభించండి.';

  @override
  String get bookSlotPassed =>
      'ఆ సమయం దాటిపోయింది. మిమ్మల్ని తదుపరి అందుబాటులో ఉన్న స్లాట్‌కు మార్చాము — తనిఖీ చేసి మళ్లీ నిర్ధారించండి.';

  @override
  String bookFailed(Object reason) {
    return 'బుకింగ్ విఫలమైంది: $reason';
  }

  @override
  String get bookNoAddress => 'చిరునామా ఏదీ ఎంచుకోలేదు';

  @override
  String get bookTitle => 'సేవను బుక్ చేయండి';

  @override
  String get bookSelectDate => 'తేదీని ఎంచుకోండి';

  @override
  String get bookSelectTime => 'సమయాన్ని ఎంచుకోండి';

  @override
  String get bookSpecialInstructions => 'ప్రత్యేక సూచనలు (ఐచ్ఛికం)';

  @override
  String get bookSpecialInstructionsHint =>
      'ఉదా. వంటగది మరియు బాత్‌రూమ్‌పై దృష్టి పెట్టండి...';

  @override
  String get bookConfirm => 'బుకింగ్‌ను నిర్ధారించండి →';

  @override
  String get gigUnknownProfessional => 'తెలియని నిపుణుడు';

  @override
  String get gigNewProfessional => 'కొత్త నిపుణుడు';

  @override
  String gigRatingWithCount(String rating, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count సమీక్షలు',
      one: '1 సమీక్ష',
    );
    return '$rating ($_temp0)';
  }

  @override
  String get gigPricing => 'ధర';

  @override
  String get gigServiceRate => 'సేవా రేటు';

  @override
  String get gigFinalAmountNote =>
      'తుది మొత్తాన్ని మీ నిపుణుడు నిర్ధారిస్తారు, బుకింగ్ సృష్టించిన తర్వాత అందులో చూపబడుతుంది.';

  @override
  String get gigKycVerified => 'KYC ధృవీకరించబడింది';

  @override
  String get gigBackgroundVerified => 'నేపథ్యం ధృవీకరించబడింది';

  @override
  String get gigBookNow => 'ఇప్పుడే బుక్ చేయండి →';

  @override
  String get discoveryTitle => 'అందుబాటులో ఉన్న నిపుణులు';

  @override
  String get discoveryMissingDetails => 'సేవ లేదా స్థానం వివరాలు లేవు.';

  @override
  String get discoveryLocalExperts => 'అందుబాటులో ఉన్న స్థానిక నిపుణులు';

  @override
  String get discoveryWithin => 'దూరంలోపు';

  @override
  String get discoveryNoProviders =>
      'దగ్గర్లో సేవ అందించేవారు ఎవరూ అందుబాటులో లేరు';

  @override
  String get discoveryTryLargerRadius =>
      'పెద్ద వెతుకులాట దూరాన్ని ప్రయత్నించండి లేదా తర్వాత మళ్లీ చూడండి.';

  @override
  String get discoveryLoadFailed =>
      'దగ్గర్లోని సేవ అందించేవారిని లోడ్ చేయలేకపోయాము.';

  @override
  String discoveryServicesForJob(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ఈ పనికి $count సేవలు',
      one: 'ఈ పనికి 1 సేవ',
    );
    return '$_temp0';
  }

  @override
  String get discoveryBook => 'బుక్ చేయండి';

  @override
  String get categoryServiceDetails => 'సేవా వివరాలు';

  @override
  String get categoryTagline =>
      'ముందే తెలిపిన ధర & సేవా హామీతో ధృవీకరించబడిన, నేపథ్యం తనిఖీ చేసిన స్థానిక నిపుణులను బుక్ చేయండి.';

  @override
  String get categoryWhatHelp => 'మీకు దేనిలో సహాయం కావాలి?';

  @override
  String get categoryDescribeElse => 'వేరే ఏదైనా వివరించండి';

  @override
  String get categoryLoadFailed => 'ఈ సేవను లోడ్ చేయలేకపోయాము.';

  @override
  String get notificationsTitle => 'నోటిఫికేషన్‌లు & హెచ్చరికలు';

  @override
  String get notificationsEmpty => 'మీరు అన్నీ చూసేశారు';

  @override
  String get notificationsLoadFailed => 'నోటిఫికేషన్‌లను లోడ్ చేయలేకపోయాము.';

  @override
  String get timeJustNow => 'ఇప్పుడే';

  @override
  String timeMinutesAgo(Object minutes) {
    return '$minutes ని క్రితం';
  }

  @override
  String timeHoursAgo(Object hours) {
    return '$hours గం క్రితం';
  }

  @override
  String get timeYesterday => 'నిన్న';

  @override
  String get completedTitle => 'సేవ పూర్తయింది!';

  @override
  String get completedThanks => 'మా సేవలను ఉపయోగించినందుకు ధన్యవాదాలు.';

  @override
  String get completedViewBookings => 'బుకింగ్‌లు చూడండి';

  @override
  String get completedBackHome => 'హోమ్‌కు తిరిగి వెళ్లండి';

  @override
  String commonErrorDetail(Object detail) {
    return 'లోపం: $detail';
  }

  @override
  String get reviewTitle => 'మీ అనుభవానికి రేటింగ్ ఇవ్వండి';

  @override
  String get reviewHeading => 'అద్భుతమైన సేవ!';

  @override
  String get reviewQuestion => 'మీ నిపుణుడితో మీ అనుభవం ఎలా ఉంది?';

  @override
  String reviewStars(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count నక్షత్రాలు',
      one: '1 నక్షత్రం',
    );
    return '$_temp0';
  }

  @override
  String get reviewCommentHint => 'మీ అనుభవం గురించి చెప్పండి...';

  @override
  String get reviewSubmit => 'సమీక్షను సమర్పించండి →';

  @override
  String get materialsTitle => 'సామగ్రి / విడిభాగాల అభ్యర్థనలు';

  @override
  String get materialsEmpty =>
      'ఈ బుకింగ్‌కు సామగ్రి అభ్యర్థనలు ఏవీ సమర్పించబడలేదు';

  @override
  String materialsQuantityEstimated(Object quantity) {
    return '$quantity · అంచనా';
  }

  @override
  String materialsQuantityActual(Object quantity) {
    return '$quantity · వాస్తవం';
  }

  @override
  String get materialsReject => 'తిరస్కరించండి';

  @override
  String get materialsApprove => 'ఆమోదించండి';

  @override
  String get materialStatusRequested => 'అభ్యర్థించబడింది';

  @override
  String get materialStatusCustomerReview => 'మీ సమీక్ష కోసం ఎదురుచూస్తోంది';

  @override
  String get materialStatusApproved => 'ఆమోదించబడింది';

  @override
  String get materialStatusRejected => 'తిరస్కరించబడింది';

  @override
  String get materialStatusPurchased => 'కొనుగోలు చేయబడింది';

  @override
  String get materialStatusCostRecorded => 'ఖర్చు నమోదైంది';

  @override
  String get materialStatusBilled => 'బిల్లులో చేర్చబడింది';

  @override
  String get materialStatusCancelled => 'రద్దు చేయబడింది';

  @override
  String get commonSaveChanges => 'మార్పులను సేవ్ చేయండి';

  @override
  String get profileTitle => 'నా ప్రొఫైల్ & ఖాతా';

  @override
  String get profileFallbackName => 'కస్టమర్ ప్రొఫైల్';

  @override
  String get profileLanguage => 'భాష';

  @override
  String get profileAddresses => 'సేవ్ చేసిన సేవా చిరునామాలు';

  @override
  String get profileAddressesSubtitle =>
      'ఇల్లు, ఆఫీస్ & ఇతర చిరునామాలను నిర్వహించండి';

  @override
  String get profileHistory => 'గత సేవల చరిత్ర';

  @override
  String get profileHistorySubtitle => 'రసీదులు & గత బుకింగ్‌లు చూడండి';

  @override
  String get profileSupport => 'సహాయం & కస్టమర్ సపోర్ట్';

  @override
  String get profileSupportSubtitle =>
      'టికెట్ సృష్టించండి, మా బృందం సమాధానాలను చూడండి';

  @override
  String get editProfileSaved => 'ప్రొఫైల్ విజయవంతంగా అప్‌డేట్ అయింది';

  @override
  String get editProfileTitle => 'ప్రొఫైల్‌ను సవరించండి';

  @override
  String get editProfileFullName => 'పూర్తి పేరు';

  @override
  String get editProfileNameEmpty => 'పేరు ఖాళీగా ఉండకూడదు';

  @override
  String get editProfileEmail => 'ఇమెయిల్ చిరునామా';

  @override
  String get commonEdit => 'సవరించండి';

  @override
  String get commonDelete => 'తొలగించండి';

  @override
  String get addressesAdd => 'కొత్త చిరునామా జోడించండి';

  @override
  String get addressesEmpty => 'మీరు ఇంకా చిరునామాలు ఏవీ సేవ్ చేయలేదు';

  @override
  String get addressesEmptyMessage =>
      'తదుపరిసారి వేగంగా బుక్ చేయడానికి సేవా చిరునామాను జోడించండి.';

  @override
  String get addressesDefaultBadge => 'డిఫాల్ట్';

  @override
  String get addressesSetDefault => 'డిఫాల్ట్‌గా సెట్ చేయండి';

  @override
  String get addressesLoadFailed => 'చిరునామాలను లోడ్ చేయలేకపోయాము.';

  @override
  String get addressesLabelSheet => 'ఈ చిరునామాకు పేరు పెట్టండి';

  @override
  String get supportTitle => 'సహాయం & సపోర్ట్';

  @override
  String get supportNewTicket => 'కొత్త టికెట్';

  @override
  String get supportEmpty => 'ఇంకా సపోర్ట్ టికెట్‌లు లేవు';

  @override
  String get supportEmptyMessage =>
      'బుకింగ్ లేదా యాప్ గురించి సహాయం కావాలా? టికెట్ సృష్టించండి, మా బృందం సమాధానం ఇస్తుంది.';

  @override
  String get supportLoadFailed => 'మీ సపోర్ట్ టికెట్‌లను లోడ్ చేయలేకపోయాము.';

  @override
  String get supportStatusOpen => 'తెరిచి ఉంది';

  @override
  String get supportStatusInProgress => 'జరుగుతోంది';

  @override
  String get supportStatusWaitingForYou => 'మీ కోసం ఎదురుచూస్తోంది';

  @override
  String get supportStatusResolved => 'పరిష్కరించబడింది';

  @override
  String get supportStatusClosed => 'మూసివేయబడింది';

  @override
  String get supportNewTicketTitle => 'కొత్త సపోర్ట్ టికెట్';

  @override
  String get supportCategory => 'వర్గం';

  @override
  String get supportSubject => 'విషయం';

  @override
  String get supportDescribeIssue => 'సమస్యను వివరించండి';

  @override
  String get supportFillSubjectMessage =>
      'దయచేసి విషయం మరియు సందేశాన్ని నింపండి.';

  @override
  String get supportSubmitTicket => 'టికెట్ సమర్పించండి';

  @override
  String get supportTicketTitle => 'సపోర్ట్ టికెట్';

  @override
  String get supportNoMessages => 'ఇంకా సందేశాలు లేవు';

  @override
  String get supportMessagesLoadFailed => 'సందేశాలను లోడ్ చేయలేకపోయాము.';

  @override
  String get supportTypeMessage => 'సందేశం టైప్ చేయండి...';

  @override
  String get supportSend => 'పంపండి';

  @override
  String get pickerEnterAddress =>
      'దయచేసి ఈ పిన్‌కు చిరునామాను నమోదు చేయండి లేదా నిర్ధారించండి';

  @override
  String get pickerTitle => 'సేవా చిరునామాను ఎంచుకోండి';

  @override
  String get pickerGettingLocation => 'మీ స్థానాన్ని పొందుతున్నాము...';

  @override
  String get pickerPermissionDenied =>
      'లొకేషన్ అనుమతి నిరాకరించబడింది — మీ చిరునామాను ఎంచుకోవడానికి మ్యాప్‌ను మీరే కదపండి.';

  @override
  String get pickerConfirmPin => 'సేవా పిన్ స్థానాన్ని నిర్ధారించండి';

  @override
  String get pickerAddressLabel => 'ఇల్లు / ఫ్లాట్ / వీధి పేరు';

  @override
  String get pickerAddressHint => 'ఉదా. #102, గ్రీన్ అవెన్యూ, ఇందిరానగర్';

  @override
  String get pickerLandmarkLabel => 'గుర్తు (ఐచ్ఛికం)';

  @override
  String get pickerLandmarkHint => 'ఉదా. HDFC బ్యాంక్ ATM దగ్గర';

  @override
  String get pickerConfirm => 'స్థానాన్ని నిర్ధారించి కొనసాగండి';

  @override
  String get requestSelectLocation => 'దయచేసి సేవా స్థలాన్ని ఎంచుకోండి';

  @override
  String requestTitle(Object service) {
    return '$service కోసం అభ్యర్థించండి';
  }

  @override
  String get requestServiceAddress => 'సేవా చిరునామా';

  @override
  String get requestDetectingLocation => 'మీ స్థానాన్ని గుర్తిస్తున్నాము…';

  @override
  String get requestTapToPickLocation =>
      'సేవా స్థలాన్ని ఎంచుకోవడానికి నొక్కండి';

  @override
  String get requestDescribeIssue => 'సమస్య / పనిని వివరించండి';

  @override
  String get requestDescribeHint =>
      'ఉదా. హాల్‌లోని ప్రధాన సీలింగ్ లైట్ స్విచ్ ఆన్ చేసినప్పుడు నిప్పురవ్వలు వస్తున్నాయి.';

  @override
  String get requestDescribeMin =>
      'దయచేసి సమస్యను కనీసం 10 అక్షరాలలో వివరించండి';

  @override
  String get requestAttachPhotos => 'సమస్య ఫోటోలను జత చేయండి (ఐచ్ఛికం)';

  @override
  String get requestAddPhoto => 'ఫోటో జోడించండి';

  @override
  String get requestWhen => 'మీకు సేవ ఎప్పుడు కావాలి?';

  @override
  String get requestInstant => '⚡ తక్షణం (30 ని)';

  @override
  String get requestScheduleLater => '📅 తర్వాత షెడ్యూల్ చేయండి';

  @override
  String get requestFindWorkers => 'అందుబాటులో ఉన్న కార్మికులను కనుగొనండి';

  @override
  String commonLoadFailedDetail(Object detail) {
    return 'లోడ్ చేయలేకపోయాము: $detail';
  }

  @override
  String get myRequestsTitle => 'నా సేవా అభ్యర్థనలు';

  @override
  String get myRequestsTabAll => 'అన్నీ';

  @override
  String get myRequestsNew => 'కొత్త అభ్యర్థన';

  @override
  String get myRequestsNoActive => 'యాక్టివ్ అభ్యర్థనలు లేవు';

  @override
  String get myRequestsNoCompleted => 'పూర్తయిన అభ్యర్థనలు లేవు';

  @override
  String get myRequestsNone => 'ఇంకా సేవా అభ్యర్థనలు లేవు';

  @override
  String get myRequestsEmptyMessage =>
      'మీ అవసరాన్ని పోస్ట్ చేయండి, కార్మికులు మీ దగ్గరికి వస్తారు.';

  @override
  String get requestDetailTitle => 'అభ్యర్థన వివరాలు';

  @override
  String get requestDetailBudget => 'బడ్జెట్';

  @override
  String get requestDetailSchedule => 'షెడ్యూల్';

  @override
  String get requestDetailLocation => 'స్థానం';

  @override
  String get requestDetailNotes => 'గమనికలు';

  @override
  String get requestDetailCancel => 'అభ్యర్థనను రద్దు చేయండి';

  @override
  String requestDetailOffersReceived(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ఆఫర్‌లు వచ్చాయి',
      one: '1 ఆఫర్ వచ్చింది',
      zero: 'ఇంకా ఆఫర్‌లు లేవు',
    );
    return '$_temp0';
  }

  @override
  String get requestDetailTapToCompare =>
      'చూడటానికి మరియు పోల్చడానికి నొక్కండి';

  @override
  String get requestDetailWorkersSoon =>
      'కార్మికులు త్వరలో స్పందించడం ప్రారంభిస్తారు';

  @override
  String get requestCancelDialogTitle => 'ఈ అభ్యర్థనను రద్దు చేయాలా?';

  @override
  String get requestCancelDialogBody =>
      'పెండింగ్‌లో ఉన్న ఆఫర్‌లన్నీ మూసివేయబడతాయి. దీన్ని వెనక్కి తీసుకోలేరు.';

  @override
  String get requestCancelKeep => 'ఉంచండి';

  @override
  String get requestCancelConfirm => 'అభ్యర్థనను రద్దు చేయండి';

  @override
  String get requestCancelled => 'అభ్యర్థన రద్దయింది';

  @override
  String requestExpiresInDaysHours(int days, int hours) {
    return '$daysరో $hoursగం లో గడువు ముగుస్తుంది';
  }

  @override
  String requestExpiresInHoursMinutes(int hours, int minutes) {
    return '$hoursగం $minutesని లో గడువు ముగుస్తుంది';
  }

  @override
  String requestExpiresInMinutes(Object minutes) {
    return '$minutesని లో గడువు ముగుస్తుంది';
  }

  @override
  String get requestExpiresSoon => 'త్వరలో గడువు ముగుస్తుంది';

  @override
  String get commonCancel => 'రద్దు చేయండి';

  @override
  String get offersTitle => 'వచ్చిన ఆఫర్‌లు';

  @override
  String get offersEmptyMessage =>
      'కార్మికులు మీ అభ్యర్థనను చూస్తున్నారు. ఎవరైనా స్పందిస్తే మీకు తెలియజేస్తాము.';

  @override
  String get offersPending => 'పెండింగ్ ఆఫర్‌లు';

  @override
  String get offersPast => 'గత ఆఫర్‌లు';

  @override
  String offersJobsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count పనులు',
      one: '1 పని',
    );
    return '$_temp0';
  }

  @override
  String get offersInsured => 'బీమా ఉంది';

  @override
  String get offersDecline => 'తిరస్కరించండి';

  @override
  String get offersAcceptOffer => 'ఆఫర్‌ను అంగీకరించండి';

  @override
  String get offersAcceptDialogTitle => 'ఈ ఆఫర్‌ను అంగీకరించాలా?';

  @override
  String offersAcceptDialogBody(String worker, String price) {
    return '$worker తో $price కు బుకింగ్ సృష్టించబడుతుంది. మిగతా ఆఫర్‌లన్నీ మూసివేయబడతాయి.';
  }

  @override
  String get offersAccept => 'అంగీకరించండి';

  @override
  String offersBookingCreated(Object code) {
    return 'బుకింగ్ $code సృష్టించబడింది!';
  }

  @override
  String get commonNext => 'తదుపరి';

  @override
  String postRequestPosted(Object code) {
    return 'సేవా అభ్యర్థన $code పోస్ట్ చేయబడింది!';
  }

  @override
  String get postRequestTitle => 'సేవా అభ్యర్థనను పోస్ట్ చేయండి';

  @override
  String get postRequestWhatService => 'మీకు ఏ సేవ కావాలి?';

  @override
  String get postRequestSelectCategory =>
      'మీ అవసరాన్ని బాగా వివరించే వర్గాన్ని ఎంచుకోండి.';

  @override
  String get postRequestDescribe => 'మీ అవసరాన్ని వివరించండి';

  @override
  String postRequestServiceLabel(Object service) {
    return 'సేవ: $service';
  }

  @override
  String get postRequestWhatDone => 'మీకు ఏ పని చేయించాలి?';

  @override
  String get postRequestFieldTitle => 'శీర్షిక';

  @override
  String get postRequestTitleHint =>
      'ఉదా. వంటగదిలో కారుతున్న కుళాయిని సరిచేయడం';

  @override
  String postRequestMinChars(Object count) {
    return 'కనీసం $count అక్షరాలు నమోదు చేయండి';
  }

  @override
  String get postRequestFieldDescription => 'వివరణ';

  @override
  String get postRequestDescriptionHint => 'సమస్యను వివరంగా చెప్పండి…';

  @override
  String get postRequestFieldNotes => 'అదనపు గమనికలు (ఐచ్ఛికం)';

  @override
  String get postRequestNotesHint => 'గేట్ కోడ్, ఇష్టమైన సమయం మొదలైనవి';

  @override
  String get postRequestBudgetTitle => 'మీ బడ్జెట్';

  @override
  String get postRequestBudgetHint =>
      'మీరు ఎంత చెల్లించడానికి సిద్ధంగా ఉన్నారో కార్మికులకు తెలియజేయండి.';

  @override
  String get postRequestFixedPrice => 'స్థిర ధర (₹)';

  @override
  String postRequestExample(Object example) {
    return 'ఉదా. $example';
  }

  @override
  String get postRequestMin => 'కనిష్ఠం (₹)';

  @override
  String get postRequestMax => 'గరిష్ఠం (₹)';

  @override
  String get postRequestWhenTitle => 'మీకు ఇది ఎప్పుడు కావాలి?';

  @override
  String get postRequestPickDate => 'తేదీని ఎంచుకోండి';

  @override
  String get postRequestLocationTitle => 'సేవా స్థలం';

  @override
  String get postRequestAddressPrivate =>
      'మీరు ఆఫర్‌ను అంగీకరించిన తర్వాతే మీ ఖచ్చితమైన చిరునామా పంచుకోబడుతుంది.';

  @override
  String get postRequestFullAddress => 'పూర్తి చిరునామా';

  @override
  String get postRequestValidAddress => 'సరైన చిరునామాను నమోదు చేయండి';

  @override
  String get postRequestCity => 'నగరం';

  @override
  String get postRequestCityHint => 'ఉదా. బెంగళూరు';

  @override
  String get postRequestPincode => 'పిన్‌కోడ్';

  @override
  String get postRequestLocationSet => 'స్థానం సెట్ చేయబడింది ✓';

  @override
  String get postRequestSetOnMap => 'మ్యాప్‌లో స్థానాన్ని సెట్ చేయండి';

  @override
  String get postRequestReviewTitle => 'మీ అభ్యర్థనను సమీక్షించండి';

  @override
  String get postRequestNotSelected => 'ఎంచుకోలేదు';

  @override
  String get postRequestWhen => 'ఎప్పుడు';

  @override
  String get postRequestPrivacyNote =>
      'మీరు ఆఫర్‌ను అంగీకరించి బుకింగ్ సృష్టించబడే వరకు మీ ఖచ్చితమైన చిరునామా గోప్యంగా ఉంటుంది.';

  @override
  String get postRequestSubmit => 'అభ్యర్థనను సమర్పించండి';

  @override
  String get assistantOpening =>
      'ఏమి పాడైందో మీ మాటల్లో చెప్పండి — దానికి సరైన నిపుణుడిని నేను కనుగొంటాను.';

  @override
  String assistantCatalogueFailed(Object reason) {
    return '$reason దానికి సమాధానం ఇవ్వడానికి నాకు సేవల జాబితా అవసరం.';
  }

  @override
  String get assistantCatalogueError =>
      'సేవల జాబితాను లోడ్ చేయడంలో ఏదో పొరపాటు జరిగింది.';

  @override
  String get assistantGreeting =>
      'నమస్కారం. ఇంట్లో మీకు దేనిలో సహాయం కావాలి? కారుతున్న కుళాయి, చల్లబరచని AC, నిప్పురవ్వలు వచ్చే స్విచ్ — ఏదైనా సరే, మీకు నచ్చినట్లు వివరించండి.';

  @override
  String get assistantTooVague =>
      'నేను సహాయం చేయగలను — సమస్య ఏమిటో తెలియాలి అంతే. ఏది పని చేయడం లేదు?';

  @override
  String assistantMultipleJobs(int count) {
    return 'ఇవి $count వేర్వేరు పనులుగా అనిపిస్తున్నాయి — వీటికి వేర్వేరు నిపుణులు కావాలి. ఒక్కొక్కటి ఇక్కడ ఉంది:';
  }

  @override
  String get assistantAmbiguous =>
      'దీన్ని సరిగ్గా చేయాలనుకుంటున్నాను — ఇది ఒకటి కంటే ఎక్కువ పనులకు చెందవచ్చు. ఏది దగ్గరగా ఉంది?';

  @override
  String get assistantUnmatched =>
      'ప్లాట్‌ఫామ్‌లోని ఏ సేవతోనూ దీన్ని జతచేయలేకపోయాను. దగ్గరగా ఉన్నదాన్ని ఎంచుకోండి, మీ వివరణను అక్కడికి తీసుకెళ్తాను — లేదా అభ్యర్థనగా పోస్ట్ చేయండి, నిపుణులు మీ దగ్గరికి వస్తారు.';

  @override
  String assistantConfidentWithProblem(String service, String problem) {
    return 'ఇది $service పనిలా అనిపిస్తోంది — బహుశా \"$problem\".';
  }

  @override
  String assistantConfident(Object service) {
    return 'ఇది $service పనిలా అనిపిస్తోంది.';
  }

  @override
  String assistantChosen(Object service) {
    return 'సరే, $service. మీరు రాసిన వివరణ అలాగే పంపబడుతుంది.';
  }

  @override
  String get assistantTitle => 'సేవా సహాయకుడు';

  @override
  String get assistantSubtitle => 'మీ సమస్యకు సరైన పనిని కనుగొంటుంది';

  @override
  String get assistantStartOver => 'మళ్లీ ప్రారంభించండి';

  @override
  String assistantMatchedOn(Object terms) {
    return 'సరిపోలినవి: $terms';
  }

  @override
  String get assistantFindWorkers => 'కార్మికులను కనుగొనండి';

  @override
  String get assistantPostRequest => 'అభ్యర్థనను పోస్ట్ చేయండి';

  @override
  String get assistantInputHint => 'సమస్యను వివరించండి...';
}
