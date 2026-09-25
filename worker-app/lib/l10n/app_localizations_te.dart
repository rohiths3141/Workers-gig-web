// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Telugu (`te`).
class AppLocalizationsTe extends AppLocalizations {
  AppLocalizationsTe([String locale = 'te']) : super(locale);

  @override
  String get languagePickerTitle => 'మీ భాషను ఎంచుకోండి';

  @override
  String get startupMissingConfig => 'ఈ బిల్డ్‌లో కాన్ఫిగరేషన్ లేదు.';

  @override
  String startupPassDartDefine(Object keys) {
    return 'వీటిని --dart-define తో ఇవ్వండి:\n\n$keys';
  }

  @override
  String get startupCouldNotStart => 'యాప్ ప్రారంభం కాలేదు.';

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
  String get eligibilityStepIncomplete => 'ఈ దశ ఇంకా పూర్తి కాలేదు.';

  @override
  String get errorSessionEnded =>
      'మీ సెషన్ ముగిసింది. దయచేసి మళ్లీ సైన్ ఇన్ చేయండి.';

  @override
  String get errorUploadFailed =>
      'ఆ ఫైల్‌ను అప్‌లోడ్ చేయలేకపోయాము. మళ్లీ ప్రయత్నించండి.';

  @override
  String get errorServiceUnavailable =>
      'ఆ సేవ ప్రస్తుతం అందుబాటులో లేదు. కొద్దిసేపటి తర్వాత మళ్లీ ప్రయత్నించండి.';

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
  String get authErrorPhoneNotEnabledRegion =>
      'ఫోన్ సైన్-ఇన్ ప్రారంభించబడలేదు, లేదా ఈ ప్రాంతానికి SMS నిరోధించబడింది. Firebase Console సెట్టింగ్‌లను తనిఖీ చేయండి.';

  @override
  String get authErrorNumberInUse => 'ఆ నంబర్ ఇప్పటికే వేరే ఖాతాకు నమోదై ఉంది.';

  @override
  String get authErrorSignInAgain =>
      'కొనసాగించడానికి దయచేసి మళ్లీ సైన్ ఇన్ చేయండి.';

  @override
  String get authErrorSignInFailed =>
      'సైన్-ఇన్ విఫలమైంది. దయచేసి మళ్లీ ప్రయత్నించండి.';

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
  String get scheduleSpecificDate => 'నిర్దిష్ట తేదీ';

  @override
  String get offerStatusSubmitted => 'సమర్పించబడింది';

  @override
  String get offerStatusViewed => 'కస్టమర్ చూశారు';

  @override
  String get offerStatusShortlisted => 'షార్ట్‌లిస్ట్ చేయబడింది';

  @override
  String get offerStatusAccepted => 'అంగీకరించబడింది ✓';

  @override
  String get offerStatusRejected => 'ఎంచుకోలేదు';

  @override
  String get offerStatusWithdrawn => 'ఉపసంహరించబడింది';

  @override
  String get offerStatusExpired => 'గడువు ముగిసింది';

  @override
  String get offerStatusClosed => 'మూసివేయబడింది';

  @override
  String distanceMetresAway(Object metres) {
    return '$metres మీ దూరం';
  }

  @override
  String distanceKmAway(Object km) {
    return '$km కి.మీ దూరం';
  }

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
  String get gigErrorTrade => 'ఈ సేవ ఏ పనికి చెందుతుందో ఎంచుకోండి';

  @override
  String get gigErrorTitleShort =>
      'ఈ సేవకు కనీసం 6 అక్షరాల స్పష్టమైన పేరు ఇవ్వండి';

  @override
  String get gigErrorTitleLong => 'పేరును 120 అక్షరాల లోపు ఉంచండి';

  @override
  String get gigErrorPrice => 'ఈ సేవకు మీరు ఎంత తీసుకుంటారో నమోదు చేయండి';

  @override
  String get gigErrorDurationMissing => 'దీనికి సాధారణంగా ఎంత సమయం పడుతుంది?';

  @override
  String get gigErrorDurationShort =>
      'మేము జాబితా చేయగల అతి చిన్న పని 15 నిమిషాలు';

  @override
  String get gigErrorDurationLong =>
      'మేము జాబితా చేయగల అతి పెద్ద పని 14 రోజులు';

  @override
  String get gigErrorRadius => 'ప్రయాణ దూరం 1 నుండి 100 కి.మీ మధ్య ఉండాలి';

  @override
  String get jobAreaNearby => 'దగ్గర్లో';

  @override
  String get jobBlockerVerifyArrival => 'కస్టమర్ కోడ్‌తో చేరికను ధృవీకరించండి';

  @override
  String get jobBlockerAfterPhoto => 'పూర్తయిన పని ఫోటోను జోడించండి';

  @override
  String jobBlockerMaterialsPending(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count సామగ్రి అభ్యర్థనలు ఇంకా కస్టమర్ కోసం ఎదురుచూస్తున్నాయి',
      one: '1 సామగ్రి అభ్యర్థన ఇంకా కస్టమర్ కోసం ఎదురుచూస్తోంది',
    );
    return '$_temp0';
  }

  @override
  String mediaTypeNotAccepted(Object kinds) {
    return 'ఆ ఫైల్ రకం ఇక్కడ అంగీకరించబడదు. $kinds ఉపయోగించండి.';
  }

  @override
  String get mediaEmpty => 'ఆ ఫైల్ ఖాళీగా ఉంది.';

  @override
  String mediaTooLarge(Object megabytes) {
    return 'ఆ ఫైల్ చాలా పెద్దది. పరిమితి ${megabytes}MB.';
  }

  @override
  String get verificationNotStarted => 'ప్రారంభించలేదు';

  @override
  String get verificationSubmitted => 'సమర్పించబడింది';

  @override
  String get verificationUnderReview => 'సమీక్షలో ఉంది';

  @override
  String get verificationMoreInfo => 'మరింత సమాచారం అవసరం';

  @override
  String get verificationExpired => 'గడువు ముగిసింది';

  @override
  String get verificationVerified => 'ధృవీకరించబడింది';

  @override
  String get verificationNotApproved => 'ఆమోదించబడలేదు';

  @override
  String get verificationNotRequired => 'అవసరం లేదు';

  @override
  String get qualificationErrorInstitution => 'దీన్ని ఏ సంస్థ జారీ చేసింది?';

  @override
  String get qualificationErrorName => 'అర్హత పేరు ఏమిటి?';

  @override
  String get qualificationErrorYearMissing =>
      'మీరు దీన్ని ఏ సంవత్సరంలో పూర్తి చేశారు?';

  @override
  String qualificationErrorYearRange(Object year) {
    return '1950 మరియు $year మధ్య సంవత్సరాన్ని నమోదు చేయండి';
  }

  @override
  String get walletTxJobEarning => 'పని సంపాదన';

  @override
  String get walletTxMaterialReimbursed => 'సామగ్రి ఖర్చు తిరిగి చెల్లింపు';

  @override
  String get walletTxAdjustment => 'సర్దుబాటు';

  @override
  String get walletTxPayoutReturned => 'పేఅవుట్ తిరిగి వచ్చింది';

  @override
  String get walletTxPlatformFee => 'ప్లాట్‌ఫామ్ ఫీజు';

  @override
  String get walletTxWithdrawn => 'ఉపసంహరించబడింది';

  @override
  String get walletTxClaimRecovery => 'క్లెయిమ్ రికవరీ';

  @override
  String get payoutStatusRequested => 'అభ్యర్థించబడింది';

  @override
  String get payoutStatusProcessing => 'ప్రాసెస్ అవుతోంది';

  @override
  String get payoutStatusPaid => 'చెల్లించబడింది';

  @override
  String get payoutStatusFailed => 'విఫలమైంది';

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
  String get accountDeletionBySupport =>
      'ఖాతా తొలగింపును మా సపోర్ట్ బృందం నిర్వహిస్తుంది. అభ్యర్థన చేయండి, పూర్తయిన తర్వాత నిర్ధారిస్తాము.';

  @override
  String get photoUploadFailed => 'ఆ ఫోటోను అప్‌లోడ్ చేయలేకపోయాము.';

  @override
  String get photoUploadFailedRetry =>
      'ఆ ఫోటోను అప్‌లోడ్ చేయలేకపోయాము. మళ్లీ ప్రయత్నించండి.';

  @override
  String get locationInvalid => 'ఆ స్థానం సరిగ్గా అనిపించడం లేదు.';

  @override
  String get travelDistanceRange =>
      '1 నుండి 100 కి.మీ మధ్య ప్రయాణ దూరాన్ని ఎంచుకోండి.';

  @override
  String get profileLoadFailed => 'మీ ప్రొఫైల్‌ను లోడ్ చేయలేకపోయాము.';

  @override
  String get uploadIncomplete => 'అప్‌లోడ్ పూర్తి కాలేదు. మళ్లీ ప్రయత్నించండి.';

  @override
  String get uploadTooLarge => 'ఆ ఫైల్ చాలా పెద్దది.';

  @override
  String get uploadTypeNotAccepted => 'ఆ ఫైల్ రకం అంగీకరించబడదు.';

  @override
  String get uploadRefused => 'ఆ ఫైల్ తిరస్కరించబడింది.';

  @override
  String get uploadTooMany =>
      'ఒకేసారి చాలా అప్‌లోడ్‌లు. కొద్దిసేపు ఆగి మళ్లీ ప్రయత్నించండి.';

  @override
  String get uploadGone =>
      'ఆ అప్‌లోడ్ ఇప్పుడు అందుబాటులో లేదు. ఫైల్‌ను మళ్లీ ఎంచుకోండి.';

  @override
  String get uploadDidNotStart => 'అప్‌లోడ్ ప్రారంభం కాలేదు.';

  @override
  String get uploadDidNotFinish => 'ఆ అప్‌లోడ్ పూర్తి కాలేదు.';

  @override
  String get claimResponseTooShort =>
      'దయచేసి ఏమి జరిగిందో కొంచెం వివరంగా చెప్పండి.';

  @override
  String get walletLoadFailedRetry =>
      'మీ వాలెట్‌ను లోడ్ చేయలేకపోయాము. దయచేసి మళ్లీ ప్రయత్నించండి.';

  @override
  String get walletLoadFailed => 'మీ వాలెట్‌ను లోడ్ చేయలేకపోయాము.';

  @override
  String get onboardingStepDetails => 'మీ వివరాలు';

  @override
  String get onboardingStepTrade => 'మీ ప్రధాన పని';

  @override
  String get onboardingStepSkills => 'మీరు ఏమి చేయగలరు';

  @override
  String get onboardingStepArea => 'మీరు ఎక్కడ పని చేస్తారు';

  @override
  String get onboardingStepKyc => 'గుర్తింపు తనిఖీ';

  @override
  String get onboardingStepReady => 'పనికి సిద్ధం';

  @override
  String routerScreenNotFound(Object location) {
    return 'ఆ స్క్రీన్‌ను తెరవలేకపోయాము.\n$location';
  }

  @override
  String get cameraOpenFailed =>
      'కెమెరాను తెరవలేకపోయాము. యాప్ అనుమతులను తనిఖీ చేయండి.';

  @override
  String get commonTryAgain => 'మళ్లీ ప్రయత్నించండి';

  @override
  String get commonCancel => 'రద్దు చేయండి';

  @override
  String get commonConfirm => 'నిర్ధారించండి';

  @override
  String get offlineBanner =>
      'మీరు ఆఫ్‌లైన్‌లో ఉన్నారు. మళ్లీ కనెక్ట్ అయిన తర్వాత పని చర్యలు మళ్లీ పని చేస్తాయి.';

  @override
  String get badgeNew => 'కొత్త';

  @override
  String get badgeAccepted => 'అంగీకరించబడింది';

  @override
  String get badgeConfirmed => 'నిర్ధారించబడింది';

  @override
  String get badgeOnTheWay => 'దారిలో ఉన్నారు';

  @override
  String get badgeArrived => 'చేరుకున్నారు';

  @override
  String get badgeWorking => 'పని చేస్తున్నారు';

  @override
  String get badgeAwaitingCustomer => 'కస్టమర్ కోసం ఎదురుచూస్తోంది';

  @override
  String get badgeDone => 'పూర్తయింది';

  @override
  String get badgePaymentDue => 'చెల్లింపు బాకీ';

  @override
  String get badgePaid => 'చెల్లించబడింది';

  @override
  String get badgeClosed => 'మూసివేయబడింది';

  @override
  String get badgeCancelled => 'రద్దు చేయబడింది';

  @override
  String get badgeDisputed => 'వివాదంలో ఉంది';

  @override
  String get badgeExpired => 'గడువు ముగిసింది';

  @override
  String get badgeDraft => 'డ్రాఫ్ట్';

  @override
  String get badgeInReview => 'సమీక్షలో';

  @override
  String get badgeLive => 'లైవ్';

  @override
  String get badgePaused => 'నిలిపివేయబడింది';

  @override
  String get badgeNotApproved => 'ఆమోదించబడలేదు';

  @override
  String get badgeRemoved => 'తొలగించబడింది';

  @override
  String get badgeNotStarted => 'ప్రారంభించలేదు';

  @override
  String get badgeSubmitted => 'సమర్పించబడింది';

  @override
  String get badgeActionNeeded => 'చర్య అవసరం';

  @override
  String get badgeVerified => 'ధృవీకరించబడింది';

  @override
  String get badgeNotRequired => 'అవసరం లేదు';

  @override
  String get commonContinue => 'కొనసాగించండి';

  @override
  String get commonSaving => 'సేవ్ అవుతోంది…';

  @override
  String get welcomePromiseWorkTitle => 'తగిన పని పొందండి';

  @override
  String get welcomePromiseWorkBody =>
      'మీ దగ్గర్లోని పనులు, మీరు నిజంగా చేసే పనులకు సరిపోయేవి.';

  @override
  String get welcomePromiseSkillsTitle => 'మీ నైపుణ్యాలను నిరూపించండి';

  @override
  String get welcomePromiseSkillsBody =>
      'మీ ITI మరియు డిప్లొమా సర్టిఫికెట్లు, ఒకసారి ధృవీకరించి ప్రతి కస్టమర్‌కు చూపబడతాయి.';

  @override
  String get welcomePromiseTrackTitle => 'ప్రతి పనిని ట్రాక్ చేయండి';

  @override
  String get welcomePromiseTrackBody =>
      'పని అంగీకరించడం నుండి పూర్తి చేయడం వరకు, ప్రతి దశలో ఫోటో రికార్డులతో.';

  @override
  String get welcomePromisePaidTitle => 'సురక్షితంగా చెల్లింపు పొందండి';

  @override
  String get welcomePromisePaidBody =>
      'ప్రతి రూపాయి నమోదు, స్పష్టమైన స్టేట్‌మెంట్‌తో, మీ నిబంధనలపై విత్‌డ్రా.';

  @override
  String get welcomeHeadline => 'మిమ్మల్ని వెతుక్కుంటూ వచ్చే పని';

  @override
  String get welcomeSubtitle =>
      'Wervexa నైపుణ్యం గల నిపుణులను వారి అవసరం ఉన్న కస్టమర్లతో కలుపుతుంది.';

  @override
  String get welcomeGetStarted => 'ప్రారంభించండి';

  @override
  String get welcomeCodeNotice =>
      'మీ మొబైల్ నంబర్‌కు ఒకసారి ఉపయోగించే కోడ్ పంపుతాము.';

  @override
  String get phoneTitle => 'మీ మొబైల్ నంబర్ ఏమిటి?';

  @override
  String get phoneSubtitle =>
      'ఇది మీరేనని నిర్ధారించడానికి ఒకసారి ఉపయోగించే కోడ్ పంపుతాము.';

  @override
  String get phoneSendCode => 'కోడ్ పంపండి';

  @override
  String get phoneSending => 'పంపుతోంది…';

  @override
  String get authNewCodeSent => 'మేము కొత్త కోడ్ పంపాము.';

  @override
  String get otpTitle => 'కోడ్‌ను నమోదు చేయండి';

  @override
  String otpSentTo(Object phone) {
    return '$phone కు 6 అంకెల కోడ్ పంపాము.';
  }

  @override
  String otpResendIn(int seconds) {
    String _temp0 = intl.Intl.pluralLogic(
      seconds,
      locale: localeName,
      other: '$seconds సెకన్లలో కొత్త కోడ్ అడగవచ్చు',
      one: '1 సెకనులో కొత్త కోడ్ అడగవచ్చు',
    );
    return '$_temp0';
  }

  @override
  String get otpSendNew => 'కొత్త కోడ్ పంపండి';

  @override
  String get otpVerify => 'ధృవీకరించండి';

  @override
  String get otpVerifying => 'ధృవీకరిస్తోంది…';

  @override
  String get registerNameRequired => 'దయచేసి మీ పూర్తి పేరు నమోదు చేయండి';

  @override
  String get registerEmailInvalid =>
      'దయచేసి సరైన ఇమెయిల్ చిరునామాను నమోదు చేయండి';

  @override
  String get registerTitle => 'మిమ్మల్ని ఏమని పిలవాలి?';

  @override
  String get registerSubtitle => 'కస్టమర్లకు ఈ పేరే కనిపిస్తుంది.';

  @override
  String get registerNameLabel => 'పూర్తి పేరు';

  @override
  String get registerNameHint => 'అరుణ్ కుమార్';

  @override
  String get registerEmailLabel => 'ఇమెయిల్ (ఐచ్ఛికం)';

  @override
  String get registerEmailHelper => 'రసీదులు మరియు స్టేట్‌మెంట్‌ల కోసం.';

  @override
  String registerVerifiedPhone(Object phone) {
    return 'ధృవీకరించబడింది: $phone';
  }

  @override
  String get navHome => 'హోమ్';

  @override
  String get navJobs => 'పనులు';

  @override
  String get navWallet => 'వాలెట్';

  @override
  String get navProfile => 'ప్రొఫైల్';

  @override
  String get sessionProfileLoadFailedRetry =>
      'మీ ప్రొఫైల్‌ను లోడ్ చేయలేకపోయాము. దయచేసి మళ్లీ ప్రయత్నించండి.';

  @override
  String get commonSignOut => 'సైన్ అవుట్ చేయండి';

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
  String get commonSeeAll => 'అన్నీ చూడండి';

  @override
  String distanceKm(Object km) {
    return '$km కి.మీ';
  }

  @override
  String get homeRightNow => 'ప్రస్తుతం';

  @override
  String get homeNewWork => 'కొత్త పని';

  @override
  String homeJobsWaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count పనులు మీ సమాధానం కోసం ఎదురుచూస్తున్నాయి',
      one: '1 పని మీ సమాధానం కోసం ఎదురుచూస్తోంది',
    );
    return '$_temp0';
  }

  @override
  String get homeComingUp => 'రాబోయేవి';

  @override
  String get homeEarnings => 'సంపాదన';

  @override
  String get homeMyServices => 'నా సేవలు';

  @override
  String get homeVerification => 'ధృవీకరణ';

  @override
  String get homeSupport => 'సపోర్ట్';

  @override
  String get homeRequests => 'అభ్యర్థనలు';

  @override
  String get homeMyOffers => 'నా ఆఫర్‌లు';

  @override
  String get homeAddService => 'సేవను జోడించండి';

  @override
  String get homeAddServiceBody =>
      'మీరు ప్రచురించిన సేవలకు మాత్రమే కస్టమర్లు మిమ్మల్ని బుక్ చేయగలరు.';

  @override
  String get homeNotReady => 'ఇంకా పూర్తిగా సిద్ధం కాలేదు';

  @override
  String get homeNotReadyBody =>
      'ఈ దశలను పూర్తి చేస్తే పనులు పొందడం ప్రారంభించవచ్చు.';

  @override
  String get homeGoodMorning => 'శుభోదయం';

  @override
  String get homeGoodAfternoon => 'శుభ మధ్యాహ్నం';

  @override
  String get homeGoodEvening => 'శుభ సాయంత్రం';

  @override
  String get homeNotifications => 'నోటిఫికేషన్‌లు';

  @override
  String get availabilityAvailable => 'అందుబాటులో ఉన్నారు';

  @override
  String get availabilityAvailableBody => 'మీరు కొత్త పనులు పొందవచ్చు.';

  @override
  String get availabilityOnJob => 'పనిలో ఉన్నారు';

  @override
  String get availabilityOnJobBody =>
      'ఈ పని పూర్తయ్యే వరకు మీకు కొత్త పని ఇవ్వబడదు.';

  @override
  String get availabilityOff => 'ఆఫ్';

  @override
  String get availabilityOffBody => 'మీకు కొత్త పనులు రావు.';

  @override
  String get availabilityFinishJob =>
      'మళ్లీ అందుబాటులోకి రావడానికి ప్రస్తుత పనిని పూర్తి చేయండి.';

  @override
  String get availabilityGoOff => 'డ్యూటీ ఆఫ్ చేయండి';

  @override
  String get availabilityGoOn => 'అందుబాటులోకి రండి';

  @override
  String get availabilityBeforeJobs => 'పనులు పొందే ముందు';

  @override
  String get availabilityNowOn => 'మీరు పనికి అందుబాటులో ఉన్నారు.';

  @override
  String get availabilityNowOff => 'మీరు డ్యూటీలో లేరు.';

  @override
  String get workerStatusSetupIncomplete => 'సెటప్ అసంపూర్ణం';

  @override
  String get workerStatusUnderReview => 'సమీక్షలో ఉంది';

  @override
  String get workerStatusInactive => 'నిష్క్రియం';

  @override
  String get workerStatusRestricted => 'పరిమితం';

  @override
  String get workerStatusSuspended => 'సస్పెండ్ చేయబడింది';

  @override
  String get homeAccount => 'ఖాతా';

  @override
  String get homeWorkStatus => 'పని స్థితి';

  @override
  String get availabilityOffDuty => 'డ్యూటీలో లేరు';

  @override
  String get earningsThisWeek => 'ఈ వారం';

  @override
  String get earningsThisMonth => 'ఈ నెల';

  @override
  String get jobNextWaitConfirm => 'కస్టమర్ నిర్ధారణ కోసం ఎదురుచూస్తోంది';

  @override
  String get jobNextStartTravel => 'ప్రయాణం ప్రారంభించండి';

  @override
  String get jobNextMarkArrived => 'చేరుకున్నట్లు గుర్తించండి';

  @override
  String get jobNextStartWork => 'పనిని ప్రారంభించండి';

  @override
  String get jobNextAskCode => 'కస్టమర్‌ను చేరిక కోడ్ అడగండి';

  @override
  String get jobNextFinish => 'పూర్తి చేసి ఫోటోలు జోడించండి';

  @override
  String get jobNextWaitApprove => 'కస్టమర్ ఆమోదం కోసం ఎదురుచూస్తోంది';

  @override
  String get jobNextOpen => 'పనిని తెరవండి';

  @override
  String get jobTimeTbc => 'సమయం నిర్ధారించాలి';

  @override
  String get settingsTitle => 'సెట్టింగ్‌లు';

  @override
  String get settingsLanguage => 'భాష';

  @override
  String get settingsAbout => 'గురించి';

  @override
  String get settingsTerms => 'సేవా నిబంధనలు';

  @override
  String get settingsPrivacy => 'గోప్యతా విధానం';

  @override
  String get settingsHelp => 'సహాయం మరియు సపోర్ట్';

  @override
  String get settingsDeleteAccount => 'నా ఖాతాను తొలగించండి';

  @override
  String get settingsSignOutTitle => 'సైన్ అవుట్ చేయాలా?';

  @override
  String get settingsSignOutBody =>
      'మళ్లీ సైన్ ఇన్ చేయడానికి మీ ఫోన్ నంబర్ మరియు కోడ్ అవసరం.';

  @override
  String get settingsDeleteTitle => 'మీ ఖాతాను తొలగించండి';

  @override
  String get settingsDeleteBody =>
      'ఖాతాను తొలగిస్తే మీ పని చరిత్ర, సంపాదన రికార్డులు మరియు తెరిచి ఉన్న చెల్లింపులు ప్రభావితమవుతాయి, కాబట్టి ఇది ఆటోమేటిక్‌గా కాకుండా మా సపోర్ట్ బృందం చేస్తుంది.\n\nసపోర్ట్ అభ్యర్థన చేయండి, పూర్తయిన తర్వాత నిర్ధారిస్తాము.';

  @override
  String get settingsContactSupport => 'సపోర్ట్‌ను సంప్రదించండి';

  @override
  String get notificationsMarkAllRead => 'అన్నీ చదివినట్లు గుర్తించండి';

  @override
  String get notificationsEmpty => 'మీరు అన్నీ చూసేశారు';

  @override
  String get notificationsEmptyBody =>
      'పని ఆఫర్‌లు, చెల్లింపు అప్‌డేట్‌లు మరియు ధృవీకరణ ఫలితాలు ఇక్కడ కనిపిస్తాయి.';

  @override
  String get jobsTabUpcoming => 'రాబోయేవి';

  @override
  String get jobsTabActive => 'యాక్టివ్';

  @override
  String get jobsNoOffers => 'ప్రస్తుతం కొత్త పనులు లేవు';

  @override
  String get jobsNoOffersBody =>
      'మీరు అందుబాటులో ఉన్నప్పుడు, తగిన పని రాగానే మీకు తెలియజేస్తాము.';

  @override
  String get jobsAccepted => 'పని అంగీకరించబడింది.';

  @override
  String get jobsDeclineTitle => 'ఈ పనిని తిరస్కరించాలా?';

  @override
  String get jobsDeclineBody =>
      'ఇది వేరే కార్మికుడికి ఇవ్వబడుతుంది. తరచుగా తిరస్కరిస్తే మీకు చూపే పనుల సంఖ్య తగ్గవచ్చు.';

  @override
  String get jobsDecline => 'తిరస్కరించండి';

  @override
  String get jobsDeclined => 'పని తిరస్కరించబడింది.';

  @override
  String get jobsEmptyUpcoming => 'ఏదీ షెడ్యూల్ చేయలేదు';

  @override
  String get jobsEmptyUpcomingBody =>
      'మీరు అంగీకరించిన పనులు ఇక్కడ కనిపిస్తాయి.';

  @override
  String get jobsEmptyActive => 'ఏ పనీ జరగడం లేదు';

  @override
  String get jobsEmptyActiveBody =>
      'మీరు పనిని ప్రారంభించినప్పుడు అది ఇక్కడ కనిపిస్తుంది.';

  @override
  String get jobsEmptyCompleted => 'ఇంకా పూర్తయిన పనులు లేవు';

  @override
  String get jobsEmptyCompletedBody =>
      'పూర్తయిన పనులు మరియు వాటి నుండి మీ సంపాదన ఇక్కడ జాబితా చేయబడతాయి.';

  @override
  String get jobsEmptyCancelled => 'ఏదీ రద్దు కాలేదు';

  @override
  String get jobsEmptyCancelledBody => 'రద్దయిన పనులు ఇక్కడ జాబితా చేయబడతాయి.';

  @override
  String get jobsEmptyOffers => 'ఆఫర్‌లు లేవు';

  @override
  String get jobsEmptyOffersBody => 'కొత్త పనులు ఇక్కడ కనిపిస్తాయి.';

  @override
  String get jobTitleFallback => 'పని';

  @override
  String jobCancelledReason(Object reason) {
    return 'రద్దయింది: $reason';
  }

  @override
  String get jobAmount => 'పని మొత్తం';

  @override
  String get jobMaterials => 'సామగ్రి';

  @override
  String get jobYouEarned => 'మీ సంపాదన';

  @override
  String get jobRateCustomer => 'కస్టమర్‌కు రేటింగ్ ఇవ్వండి';

  @override
  String get jobRateQuestion => 'ఈ పని మీకు ఎలా అనిపించింది?';

  @override
  String get jobRate => 'రేట్ చేయండి';

  @override
  String get jobHistory => 'ఏమి జరిగింది';

  @override
  String get jobHistoryLoadFailed => 'పని చరిత్రను లోడ్ చేయలేకపోయాము.';

  @override
  String get jobOfferExpired => 'ఈ పని ఇప్పుడు అందుబాటులో లేదు.';

  @override
  String get jobOfferNewBadge => 'కొత్త పని';

  @override
  String get jobOfferYouEarn => 'మీ సంపాదన';

  @override
  String get jobOfferPriceAfterVisit => 'సందర్శన తర్వాత నిర్ధారిస్తారు';

  @override
  String get jobOfferAccept => 'పనిని అంగీకరించండి';

  @override
  String get activeJobTitle => 'ప్రస్తుత పని';

  @override
  String get activeJobEmptyBody =>
      'మీరు పనిని అంగీకరించి ప్రారంభించినప్పుడు అది ఇక్కడ కనిపిస్తుంది.';

  @override
  String get evidenceBeforeTitle => 'ప్రారంభించే ముందు';

  @override
  String get evidenceBeforeBody =>
      'తాకే ముందే సమస్య ఫోటో తీయండి. కస్టమర్ తర్వాత పనిపై వివాదం చేస్తే ఇది మిమ్మల్ని కాపాడుతుంది.';

  @override
  String get evidenceAfterTitle => 'పూర్తి చేసిన తర్వాత';

  @override
  String get evidenceAfterBody =>
      'కస్టమర్ తర్వాత వివాదం చేస్తే పూర్తయిన పని ఫోటోయే మీ సాక్ష్యం. ఐచ్ఛికం, కానీ పది సెకన్లు కేటాయించదగినది.';

  @override
  String get jobCustomerHidden =>
      'నిర్ధారణ తర్వాత కస్టమర్ వివరాలు పంచుకోబడతాయి';

  @override
  String get jobCall => 'కాల్ చేయండి';

  @override
  String get jobDirections => 'దిశలు';

  @override
  String get jobTrackOnMap => 'మ్యాప్‌లో ట్రాక్ చేయండి';

  @override
  String get trailAccepted => 'అంగీకరించబడింది';

  @override
  String get trailOnTheWay => 'దారిలో ఉన్నారు';

  @override
  String get trailArrived => 'చేరుకున్నారు';

  @override
  String get trailArrivalConfirmed => 'చేరిక నిర్ధారించబడింది';

  @override
  String get trailWorkStarted => 'పని ప్రారంభమైంది';

  @override
  String get trailFinished => 'పూర్తయింది';

  @override
  String get jobProgress => 'పురోగతి';

  @override
  String get jobBeforeFinish => 'పూర్తి చేసే ముందు';

  @override
  String get jobActionStartTravel => 'ప్రయాణం ప్రారంభించండి';

  @override
  String get jobActionArrived => 'నేను చేరుకున్నాను';

  @override
  String get jobActionEnterCode => 'చేరిక కోడ్ నమోదు చేయండి';

  @override
  String get jobActionStartWork => 'పని ప్రారంభించండి';

  @override
  String get jobActionFinish => 'పనిని పూర్తి చేయండి';

  @override
  String get jobArrivalConfirmed => 'చేరిక నిర్ధారించబడింది.';

  @override
  String get jobFinishTitle => 'ఈ పనిని పూర్తి చేయాలా?';

  @override
  String get jobFinishBody =>
      'పనిని ఆమోదించమని కస్టమర్‌ను అడుగుతాము. ఆ తర్వాత మీరు ఫోటోలు జోడించలేరు.';

  @override
  String get jobOnYourWay => 'మీరు దారిలో ఉన్నారు.';

  @override
  String get jobMarkedArrived => 'చేరుకున్నట్లు గుర్తించబడింది.';

  @override
  String get jobWorkStarted => 'పని ప్రారంభమైంది.';

  @override
  String get jobSentForApproval => 'ఆమోదం కోసం కస్టమర్‌కు పంపబడింది.';

  @override
  String get jobUpdated => 'అప్‌డేట్ అయింది.';

  @override
  String get jobWaitConfirm =>
      'కస్టమర్ బుకింగ్‌ను నిర్ధారించడం కోసం ఎదురుచూస్తోంది.';

  @override
  String get jobWaitApprove =>
      'కస్టమర్ మీ పనిని ఆమోదించడం కోసం ఎదురుచూస్తోంది.';

  @override
  String get jobWaitPaymentProcessing =>
      'ఆమోదించబడింది. చెల్లింపు ప్రాసెస్ అవుతోంది.';

  @override
  String get jobWaitPayment => 'కస్టమర్ చెల్లింపు కోసం ఎదురుచూస్తోంది.';

  @override
  String get jobWaitPaid =>
      'చెల్లించబడింది. మీ సంపాదన మీ వాలెట్‌లో కనిపిస్తుంది.';

  @override
  String get jobWaitDisputed =>
      'ఈ పనిని మా బృందం సమీక్షిస్తోంది. మేము సంప్రదిస్తాము.';

  @override
  String get jobWaitNothing => 'ప్రస్తుతం చేయాల్సింది ఏమీ లేదు.';

  @override
  String get travelRouteUnavailable => 'మార్గం అందుబాటులో లేదు';

  @override
  String get travelNoDestination => 'గమ్యం సెట్ చేయలేదు';

  @override
  String get travelNoDestinationBody =>
      'ఈ పనికి మార్గం చూపడానికి సేవా స్థలం లేదు.';

  @override
  String get travelJobLocation => 'పని స్థలం';

  @override
  String get travelYou => 'మీరు';

  @override
  String get travelCustomer => 'కస్టమర్';

  @override
  String get travelCalculating => 'మార్గాన్ని లెక్కిస్తోంది...';

  @override
  String distanceMetres(Object metres) {
    return '$metres మీ';
  }

  @override
  String etaMinutes(Object minutes) {
    return '$minutes ని';
  }

  @override
  String etaHours(Object hours) {
    return '$hours గం';
  }

  @override
  String get arrivalWrongCode => 'ఆ కోడ్ సరైనది కాదు.';

  @override
  String arrivalWrongCodeAttempts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ఆ కోడ్ సరైనది కాదు. $count ప్రయత్నాలు మిగిలి ఉన్నాయి.',
      one: 'ఆ కోడ్ సరైనది కాదు. 1 ప్రయత్నం మిగిలి ఉంది.',
    );
    return '$_temp0';
  }

  @override
  String get arrivalTitle => 'మీరు చేరుకున్నారని నిర్ధారించండి';

  @override
  String get arrivalBody =>
      'కస్టమర్‌ను వారి యాప్‌లోని కోడ్ చదివి చెప్పమనండి, ఆపై ఇక్కడ టైప్ చేయండి.';

  @override
  String get arrivalLocked =>
      'చాలా తప్పు కోడ్‌లు. ఈ పనిని కొనసాగించడానికి దయచేసి సపోర్ట్‌ను సంప్రదించండి.';

  @override
  String get arrivalConfirm => 'చేరికను నిర్ధారించండి';

  @override
  String get arrivalNotYet => 'ఇంకా లేదు';

  @override
  String get rateThanks => 'మీ అభిప్రాయానికి ధన్యవాదాలు.';

  @override
  String get rateTitle => 'ఈ కస్టమర్ ఎలా ఉన్నారు?';

  @override
  String get rateBody =>
      'మీ రేటింగ్ గోప్యంగా ఉంటుంది, కార్మికులను చూసుకోవడంలో మాకు సహాయపడుతుంది.';

  @override
  String get rateCommentLabel => 'ఇంకేమైనా చెప్పాలా? (ఐచ్ఛికం)';

  @override
  String get rateSubmit => 'రేటింగ్ సమర్పించండి';

  @override
  String get timerServiceTime => 'సేవా సమయం';

  @override
  String get materialsAdd => 'జోడించండి';

  @override
  String get materialsLoadFailed => 'సామగ్రిని లోడ్ చేయలేకపోయాము.';

  @override
  String get materialsEmpty =>
      'ఈ పనికి విడిభాగాలు కావాలంటే ఇక్కడ జోడించండి, ఖర్చును ఆమోదించమని కస్టమర్‌ను అడుగుతాము.';

  @override
  String get materialStatusWaiting => 'కస్టమర్ కోసం ఎదురుచూస్తోంది';

  @override
  String get materialStatusApproved => 'ఆమోదించబడింది';

  @override
  String get materialStatusDeclined => 'తిరస్కరించబడింది';

  @override
  String get materialStatusBought => 'కొన్నారు';

  @override
  String get materialStatusCostRecorded => 'ఖర్చు నమోదైంది';

  @override
  String get materialStatusBilled => 'బిల్లులో ఉంది';

  @override
  String get materialStatusCancelled => 'రద్దయింది';

  @override
  String materialQuantityEstimated(Object quantity, Object unit) {
    return '$quantity $unit · అంచనా';
  }

  @override
  String materialQuantityActual(Object quantity, Object unit) {
    return '$quantity $unit · వాస్తవం';
  }

  @override
  String get materialRecordCost => 'ఖర్చు నమోదు చేయండి';

  @override
  String materialCustomerSaid(Object reason) {
    return 'కస్టమర్ చెప్పింది: $reason';
  }

  @override
  String get materialUnitPiece => 'ముక్క';

  @override
  String get materialWhatNeeded => 'మీకు ఏమి కావాలి?';

  @override
  String get materialEnterQuantity => 'ఎన్ని కావాలో నమోదు చేయండి';

  @override
  String get materialEnterCost => 'అంచనా ఖర్చును నమోదు చేయండి';

  @override
  String get materialRequestBody =>
      'మీరు కొనే ముందు దీన్ని ఆమోదించమని కస్టమర్‌ను అడుగుతాము.';

  @override
  String get materialName => 'సామగ్రి';

  @override
  String get materialNameHint => 'ఉదా. 16A మాడ్యులర్ స్విచ్';

  @override
  String get materialQuantity => 'పరిమాణం';

  @override
  String get materialUnit => 'యూనిట్';

  @override
  String get materialExpectedCost => 'అంచనా ఖర్చు';

  @override
  String get materialAskCustomer => 'కస్టమర్‌ను అడగండి';

  @override
  String get materialEnterPaid => 'మీరు చెల్లించిన మొత్తాన్ని నమోదు చేయండి';

  @override
  String get materialCostRecorded => 'ఖర్చు నమోదైంది.';

  @override
  String get materialWhatCost => 'దీనికి ఎంత ఖర్చయింది?';

  @override
  String get materialReceiptBody =>
      'కస్టమర్ బిల్లులో చేర్చడానికి రసీదును జత చేయండి.';

  @override
  String get materialAmountPaid => 'చెల్లించిన మొత్తం';

  @override
  String get materialReceipt => 'రసీదు';

  @override
  String get materialReceiptRequired => 'బిల్లు ఫోటో తప్పనిసరి.';

  @override
  String get evidenceDone => 'పూర్తయింది';

  @override
  String get evidenceRequired => 'తప్పనిసరి';

  @override
  String get evidenceCamera => 'కెమెరా';

  @override
  String get evidenceGallery => 'గ్యాలరీ';

  @override
  String get evidenceSaved => 'సేవ్ అయింది';

  @override
  String get uploadWaiting => 'వేచి ఉంది';

  @override
  String get uploadPreparing => 'సిద్ధం చేస్తోంది';

  @override
  String get uploadStarting => 'అప్‌లోడ్ ప్రారంభమవుతోంది';

  @override
  String uploadPercent(Object percent) {
    return '$percent%';
  }

  @override
  String get uploadFinishing => 'పూర్తి చేస్తోంది';

  @override
  String get uploadCancel => 'అప్‌లోడ్ రద్దు చేయండి';

  @override
  String get uploadNotFinished => 'ఆ అప్‌లోడ్ పూర్తి కాలేదు.';

  @override
  String get commonRetry => 'మళ్లీ ప్రయత్నించండి';

  @override
  String durationMinutes(Object minutes) {
    return '$minutes ని';
  }

  @override
  String durationHours(Object hours) {
    return '$hours గం';
  }

  @override
  String durationHoursMinutes(Object hours, Object minutes) {
    return '$hours గం $minutes ని';
  }

  @override
  String durationDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count రోజులు',
      one: '1 రోజు',
    );
    return '$_temp0';
  }

  @override
  String pricePerHour(Object price) {
    return '$price/గం';
  }

  @override
  String pricePerDay(Object price) {
    return '$price/రోజు';
  }

  @override
  String pricePerUnit(Object price) {
    return '$price/యూనిట్';
  }

  @override
  String pricePerSqft(Object price) {
    return '$price/చ.అ';
  }

  @override
  String get gigsTitle => 'నా సేవలు';

  @override
  String get gigsAddTooltip => 'సేవను జోడించండి';

  @override
  String get gigsAdd => 'సేవను జోడించండి';

  @override
  String get gigsEmpty => 'ఇంకా సేవలు లేవు';

  @override
  String get gigsEmptyBody =>
      'మీరు అందించే సేవలను జోడించండి. మీకు ఆమోదం ఉన్న అన్ని పనుల్లో మీకు కావలసినన్ని సేవలు జోడించవచ్చు.';

  @override
  String get gigsNoneLive =>
      'మీ సేవల్లో ఏదీ లైవ్‌లో లేదు, కాబట్టి కస్టమర్లు మిమ్మల్ని బుక్ చేయలేరు.';

  @override
  String gigsLiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count సేవలు లైవ్‌లో ఉన్నాయి.',
      one: '1 సేవ లైవ్‌లో ఉంది.',
    );
    return '$_temp0';
  }

  @override
  String get gigsAvailable => 'మీరు పనికి అందుబాటులో ఉన్నారు.';

  @override
  String get gigsOffDuty => 'మీరు డ్యూటీలో లేరు, కాబట్టి మీకు పనులు ఇవ్వబడవు.';

  @override
  String gigJobsDone(int count) {
    return '$count పూర్తయ్యాయి';
  }

  @override
  String get gigEdit => 'సవరించండి';

  @override
  String get gigPause => 'నిలిపివేయండి';

  @override
  String get gigResume => 'మళ్లీ ప్రారంభించండి';

  @override
  String get gigInReview => 'సమీక్షలో';

  @override
  String get gigDraftHint => 'డ్రాఫ్ట్ — సమీక్షకు సమర్పించండి';

  @override
  String get gigRejectedHint => 'తిరస్కరించబడింది — సవరించి మళ్లీ సమర్పించండి';

  @override
  String get gigArchived => 'ఆర్కైవ్ చేయబడింది';

  @override
  String get gigNotLive => 'లైవ్‌లో లేదు';

  @override
  String get gigPaused => 'నిలిపివేయబడింది. ఈ పనులు మీకు ఇవ్వబడవు.';

  @override
  String get gigLiveAgain => 'మళ్లీ లైవ్‌లో ఉంది.';

  @override
  String get gigDuration30m => '30 నిమిషాలు';

  @override
  String get gigDuration45m => '45 నిమిషాలు';

  @override
  String get gigDuration1h => '1 గంట';

  @override
  String get gigDuration2h => '2 గంటలు';

  @override
  String get gigDuration4h => '4 గంటలు';

  @override
  String get gigDuration8h => '8 గంటలు (ఒక పని దినం)';

  @override
  String get gigDuration24h => '24 గంటలు';

  @override
  String get gigDuration2d => '2 రోజులు';

  @override
  String get gigDuration3d => '3 రోజులు';

  @override
  String get gigDuration1w => '1 వారం';

  @override
  String get gigSavedDraft => 'డ్రాఫ్ట్‌గా సేవ్ చేయబడింది.';

  @override
  String get gigSubmitted => 'సమర్పించబడింది. మేము సమీక్షించి తెలియజేస్తాము.';

  @override
  String get gigLive => 'మీ సేవ లైవ్‌లో ఉంది.';

  @override
  String get gigSaved => 'సేవ్ అయింది.';

  @override
  String get gigEditorAddTitle => 'సేవను జోడించండి';

  @override
  String get gigEditorEditTitle => 'సేవను సవరించండి';

  @override
  String get gigNoTrades => 'ఇంకా ఆమోదించిన పనులు లేవు';

  @override
  String get gigNoTradesBody =>
      'ఒక పని మీకు ఆమోదించబడిన తర్వాత, దాని కింద సేవలను ప్రచురించవచ్చు. ప్రారంభించడానికి మీ ప్రొఫైల్ నుండి పనిని జోడించండి.';

  @override
  String get gigFieldTrade => 'ఏ పని?';

  @override
  String get gigFieldTitle => 'ఈ సేవ పేరు ఏమిటి?';

  @override
  String get gigFieldTitleHint =>
      'కస్టమర్లు దీన్ని చూస్తారు. స్పష్టంగా రాయండి.';

  @override
  String get gigFieldTitleExample => 'ఉదా. స్ప్లిట్ AC డీప్ క్లీనింగ్';

  @override
  String get gigFieldDescription => 'ఇందులో ఏమేమి ఉంటాయి?';

  @override
  String get gigFieldDescriptionHint =>
      'ఐచ్ఛికం, కానీ కస్టమర్లు మిమ్మల్ని ఎంచుకోవడానికి సహాయపడుతుంది.';

  @override
  String get gigFieldDescriptionExample =>
      'ఉదా. ఇండోర్ మరియు అవుట్‌డోర్ యూనిట్ పూర్తి శుభ్రత, ఫిల్టర్ వాష్, గ్యాస్ ప్రెజర్ తనిఖీ.';

  @override
  String get gigFieldPrice => 'మీరు ఎంత తీసుకుంటారు?';

  @override
  String get gigFieldPriceHint =>
      'ప్రతి సేవకు దాని సొంత ధర ఉంటుంది. ఇది మీ ఇతర సేవలను ప్రభావితం చేయదు.';

  @override
  String get gigUnitPerJob => 'ప్రతి పనికి';

  @override
  String get gigUnitPerHour => 'గంటకు';

  @override
  String get gigUnitPerDay => 'రోజుకు';

  @override
  String get gigUnitPerUnit => 'యూనిట్‌కు';

  @override
  String get gigUnitPerSqft => 'చ.అడుగుకు';

  @override
  String get gigFieldDuration => 'దీనికి సాధారణంగా ఎంత సమయం పడుతుంది?';

  @override
  String get gigFieldRadius => 'దీని కోసం మీరు ఎంత దూరం ప్రయాణిస్తారు?';

  @override
  String get gigFieldRadiusHint =>
      'మీ సాధారణ ప్రయాణ దూరాన్ని ఉపయోగించడానికి డిఫాల్ట్‌గా వదిలేయండి.';

  @override
  String get gigUsualDistance => 'మీ సాధారణ దూరం';

  @override
  String get gigUseUsualDistance => 'నా సాధారణ దూరాన్ని ఉపయోగించండి';

  @override
  String get gigReviewNotice =>
      'కొత్త మరియు సవరించిన సేవలు లైవ్‌లోకి వెళ్లే ముందు మా బృందం తనిఖీ చేస్తుంది. పూర్తయిన వెంటనే తెలియజేస్తాము.';

  @override
  String get gigSaveDraft => 'డ్రాఫ్ట్ సేవ్ చేయండి';

  @override
  String get gigSubmitForReview => 'సమీక్షకు సమర్పించండి';

  @override
  String get walletAllTransactions => 'అన్ని లావాదేవీలు';

  @override
  String get walletFrozen =>
      'ఒక విషయాన్ని పరిశీలిస్తున్నందున విత్‌డ్రాలు నిలిపివేయబడ్డాయి. వివరాలకు సపోర్ట్‌ను సంప్రదించండి.';

  @override
  String get walletWithdraw => 'విత్‌డ్రా చేయండి';

  @override
  String walletNothingPending(Object amount) {
    return 'ఇంకా విత్‌డ్రా చేయడానికి ఏమీ లేదు. $amount ఇంకా ప్రాసెస్ అవుతోంది, ఆ పనులు ఆమోదించబడిన తర్వాత మీ బ్యాలెన్స్‌కు చేరుతుంది.';
  }

  @override
  String get walletNothingYet =>
      'ఇంకా విత్‌డ్రా చేయడానికి ఏమీ లేదు. కస్టమర్ పూర్తయిన పనిని ఆమోదించిన తర్వాత మీ సంపాదన ఇక్కడ కనిపిస్తుంది.';

  @override
  String get walletRecentEarnings => 'ఇటీవలి సంపాదన';

  @override
  String get walletNoEarnings => 'ఇంకా సంపాదన లేదు';

  @override
  String get walletNoEarningsBody =>
      'పూర్తయిన పనికి చెల్లింపు జరిగిన తర్వాత మీ సంపాదన ఇక్కడ కనిపిస్తుంది.';

  @override
  String get walletAvailable => 'విత్‌డ్రా చేయడానికి అందుబాటులో ఉంది';

  @override
  String get walletProcessing => 'ప్రాసెస్ అవుతోంది';

  @override
  String get walletProcessingHint => 'నిలుపుదల కాలం తర్వాత విడుదల అవుతుంది';

  @override
  String get walletTotalEarned => 'మొత్తం సంపాదన';

  @override
  String get statementTitle => 'స్టేట్‌మెంట్';

  @override
  String get statementTabTransactions => 'లావాదేవీలు';

  @override
  String get statementTabWithdrawals => 'విత్‌డ్రాలు';

  @override
  String get statementEmpty => 'ఇంకా ఏమీ లేదు';

  @override
  String get statementEmptyBody =>
      'మీరు పని ప్రారంభించిన తర్వాత ప్రతి చెల్లింపు, ఫీజు మరియు విత్‌డ్రా ఇక్కడ జాబితా చేయబడుతుంది.';

  @override
  String statementBalance(Object amount) {
    return 'బ్యాలెన్స్ $amount';
  }

  @override
  String get statementNoWithdrawals => 'ఇంకా విత్‌డ్రాలు లేవు';

  @override
  String get statementNoWithdrawalsBody =>
      'మీరు డబ్బు విత్‌డ్రా చేసినప్పుడు అది ఇక్కడ ట్రాక్ చేయబడుతుంది.';

  @override
  String payoutRequestedAt(Object date) {
    return '$date న అభ్యర్థించారు';
  }

  @override
  String payoutPaidAt(Object date) {
    return '$date న చెల్లించబడింది';
  }

  @override
  String get payoutEnterAmount =>
      'ఎంత విత్‌డ్రా చేయాలనుకుంటున్నారో నమోదు చేయండి';

  @override
  String payoutUpTo(Object amount) {
    return 'మీరు ప్రస్తుతం $amount వరకు విత్‌డ్రా చేయవచ్చు';
  }

  @override
  String payoutMinimum(Object amount) {
    return 'కనిష్ఠ విత్‌డ్రా $amount';
  }

  @override
  String payoutRequested(Object amount) {
    return '$amount విత్‌డ్రా కోసం అభ్యర్థించారు. ప్రాసెస్ అవుతున్న కొద్దీ అప్‌డేట్ ఇస్తాము.';
  }

  @override
  String get payoutAvailableNow => 'ఇప్పుడు అందుబాటులో ఉంది';

  @override
  String payoutPendingMore(Object amount) {
    return 'మరో $amount ఇంకా ప్రాసెస్ అవుతోంది, ఇప్పుడే విత్‌డ్రా చేయలేరు.';
  }

  @override
  String get payoutHowMuch => 'ఎంత?';

  @override
  String get payoutAll => 'అన్నీ';

  @override
  String payoutPercent(Object percent) {
    return '$percent%';
  }

  @override
  String get payoutProcessNotice =>
      'విత్‌డ్రాలను తనిఖీ చేసి మీ నమోదిత బ్యాంక్ ఖాతాకు పంపుతాము. ప్రతి దశలో స్థితి అప్‌డేట్ ఇక్కడ కనిపిస్తుంది.';

  @override
  String get payoutRequest => 'విత్‌డ్రా అభ్యర్థించండి';

  @override
  String get bankChecking => 'మీ బ్యాంక్ ఖాతాను తనిఖీ చేస్తోంది…';

  @override
  String bankPaidTo(Object last4) {
    return '$last4 తో ముగిసే ఖాతాకు చెల్లించబడుతుంది';
  }

  @override
  String get bankVerifiedFallback => 'మీ ధృవీకరించబడిన బ్యాంక్ ఖాతా';

  @override
  String get bankBeingVerified => 'బ్యాంక్ ఖాతా ధృవీకరించబడుతోంది';

  @override
  String get bankBeingVerifiedBody =>
      'మా బృందం ధృవీకరించిన తర్వాత మీరు విత్‌డ్రా చేయవచ్చు.';

  @override
  String get bankNotVerified => 'బ్యాంక్ ఖాతా ధృవీకరించబడలేదు';

  @override
  String get bankNotVerifiedBody => 'మీ వివరాలను తనిఖీ చేసి మళ్లీ సమర్పించండి.';

  @override
  String get bankAddTitle => 'బ్యాంక్ ఖాతాను జోడించండి';

  @override
  String get bankAddBody =>
      'మా బృందం ధృవీకరించిన బ్యాంక్ ఖాతాకే విత్‌డ్రాలు చెల్లించబడతాయి.';

  @override
  String get bankAddAction => 'బ్యాంక్ ఖాతాను జోడించండి';

  @override
  String get verificationTitle => 'ధృవీకరణ';

  @override
  String get verificationProgress => 'ధృవీకరించిన తనిఖీలు';

  @override
  String verificationCount(int approved, int total) {
    return '$total లో $approved';
  }

  @override
  String get verificationInsurance => 'బీమా';

  @override
  String get verificationNoCover => 'యాక్టివ్ బీమా లేదు';

  @override
  String get verificationNoCoverBody =>
      'ప్రస్తుతం మా దగ్గర మీ బీమా పాలసీ ఏదీ నమోదు కాలేదు.';

  @override
  String get verifyIdentity => 'గుర్తింపు';

  @override
  String get verifyIdentityBody =>
      'ప్రభుత్వ గుర్తింపు పత్రం, తమ ఇంటికి ఎవరు వస్తున్నారో కస్టమర్లకు తెలియడానికి.';

  @override
  String get verifyAddress => 'చిరునామా';

  @override
  String get verifyAddressBody => 'మీరు ఎక్కడ నివసిస్తున్నారో దానికి రుజువు.';

  @override
  String get verifyIti => 'ITI సర్టిఫికెట్';

  @override
  String get verifyItiBody =>
      'పారిశ్రామిక శిక్షణ సంస్థ (ITI) నుండి మీ ట్రేడ్ సర్టిఫికెట్.';

  @override
  String get verifyDiploma => 'డిప్లొమా';

  @override
  String get verifyDiplomaBody => 'గుర్తింపు పొందిన సాంకేతిక డిప్లొమా.';

  @override
  String get verifyRpl => 'నైపుణ్య అంచనా';

  @override
  String get verifyRplBody =>
      'పూర్వ అభ్యాస గుర్తింపు (RPL): మీ అనుభవాన్ని అంచనా వేసి ధృవీకరించడం.';

  @override
  String get verifyBackground => 'నేపథ్య తనిఖీ';

  @override
  String get verifyBackgroundBody =>
      'దీన్ని మేమే చేస్తాము. మీరు ఏమీ చేయనవసరం లేదు.';

  @override
  String get verifyInsuranceBody =>
      'పని చేస్తున్నప్పుడు ప్రమాదవశాత్తు జరిగే నష్టానికి బీమా. ఏర్పాటైన తర్వాత మా బృందం మీ పాలసీని జోడిస్తుంది.';

  @override
  String get verifyBank => 'బ్యాంక్ ఖాతా';

  @override
  String get verifyBankBody => 'మీ విత్‌డ్రాలు చెల్లించబడే చోటు.';

  @override
  String verificationValidUntil(Object date) {
    return '$date వరకు చెల్లుతుంది';
  }

  @override
  String get verificationStart => 'ప్రారంభించండి';

  @override
  String get verificationUpdate => 'అప్‌డేట్ చేయండి';

  @override
  String get policyActive => 'యాక్టివ్';

  @override
  String get policyNotActive => 'యాక్టివ్ కాదు';

  @override
  String get policyNumber => 'పాలసీ';

  @override
  String get policyCover => 'కవరేజ్';

  @override
  String get policyValidUntil => 'వరకు చెల్లుతుంది';

  @override
  String get kycStillWaiting =>
      'ఇంకా DigiLocker కోసం ఎదురుచూస్తోంది. తర్వాత ఇక్కడి నుండి మళ్లీ చూడవచ్చు.';

  @override
  String get kycTitle => 'గుర్తింపు తనిఖీ';

  @override
  String get kycHeadline => 'మీరు ఎవరో నిర్ధారించండి';

  @override
  String get kycIntro =>
      'కస్టమర్లు మిమ్మల్ని తమ ఇళ్లలోకి రానిస్తారు, అందుకే ప్రతి కార్మికుడి గుర్తింపును భారత ప్రభుత్వ డాక్యుమెంట్ ప్లాట్‌ఫామ్ అయిన DigiLocker ద్వారా ధృవీకరిస్తాము. ఏదీ అప్‌లోడ్ చేయబడదు — మీరు మీ ఆధార్ ఖాతాలో అభ్యర్థనను ఆమోదిస్తే చాలు.';

  @override
  String get kycPrivacy =>
      'మీ ఆధార్ వివరాలు నేరుగా DigiLocker తో నిర్ధారించబడతాయి. తనిఖీ జరిగిందని నిరూపించేది మాత్రమే మేము నిల్వ చేస్తాము — మీ ఫోటో లేదా ఆధార్ కాపీ ఎప్పటికీ కాదు.';

  @override
  String get kycVerified => 'మీ గుర్తింపు ధృవీకరించబడింది.';

  @override
  String get kycAwaitingConsent =>
      'మీ బ్రౌజర్‌లో DigiLocker సమ్మతిని పూర్తి చేసి, ఇక్కడికి తిరిగి రండి.';

  @override
  String get kycChecking => 'DigiLocker తో తనిఖీ చేస్తోంది…';

  @override
  String get kycStart => 'DigiLocker తో ధృవీకరించండి';

  @override
  String get qualSubmitted => 'సమీక్షకు సమర్పించబడింది.';

  @override
  String get qualTitle => 'మీ అర్హత';

  @override
  String get qualIti => 'ITI';

  @override
  String get qualInstitute => 'సంస్థ';

  @override
  String get qualInstituteHint => 'ఉదా. ప్రభుత్వ ITI, కోయంబత్తూర్';

  @override
  String get qualName => 'అర్హత';

  @override
  String get qualNameHint => 'ఉదా. ఎలక్ట్రీషియన్';

  @override
  String get qualSpeciality => 'ప్రత్యేకత (ఐచ్ఛికం)';

  @override
  String get qualSpecialityHint => 'ఉదా. పారిశ్రామిక వైరింగ్';

  @override
  String get qualYear => 'పూర్తి చేసిన సంవత్సరం';

  @override
  String get qualCertificate => 'మీ సర్టిఫికెట్';

  @override
  String get qualCertificateBody =>
      'సర్టిఫికెట్ యొక్క స్పష్టమైన ఫోటో లేదా PDF.';

  @override
  String get bankErrorHolder => 'ఖాతాలో ఉన్నట్లే పేరును నమోదు చేయండి';

  @override
  String get bankErrorNumber => 'ఖాతా నంబర్ 9 నుండి 18 అంకెలు ఉంటుంది';

  @override
  String get bankErrorMismatch => 'ఖాతా నంబర్లు సరిపోలడం లేదు';

  @override
  String get bankErrorIfsc => '11 అక్షరాల IFSC నమోదు చేయండి, ఉదా. SBIN0001234';

  @override
  String get bankSent => 'బ్యాంక్ ఖాతా ధృవీకరణకు పంపబడింది.';

  @override
  String get bankNotice =>
      'మీ విత్‌డ్రాలు ఈ ఖాతాకు చెల్లించబడతాయి. మొదటి పేఅవుట్‌కు ముందు మా బృందం దీన్ని ధృవీకరిస్తుంది.';

  @override
  String get bankHolder => 'ఖాతాదారుని పేరు';

  @override
  String get bankNumber => 'ఖాతా నంబర్';

  @override
  String get bankConfirmNumber => 'ఖాతా నంబర్‌ను మళ్లీ నమోదు చేయండి';

  @override
  String get bankIfsc => 'IFSC కోడ్';

  @override
  String get bankIfscHint => 'ఉదా. SBIN0001234';

  @override
  String get bankName => 'బ్యాంక్ పేరు (ఐచ్ఛికం)';

  @override
  String get bankSubmit => 'ధృవీకరణకు సమర్పించండి';

  @override
  String get profileCompleteness => 'ప్రొఫైల్ పూర్తి స్థాయి';

  @override
  String get profileCompletenessBody =>
      'పూర్తి ప్రొఫైల్ కస్టమర్లు మిమ్మల్ని ఎంచుకోవడానికి సహాయపడుతుంది.';

  @override
  String get profileJobsDone => 'పూర్తయిన పనులు';

  @override
  String get profileRating => 'రేటింగ్';

  @override
  String get profileExperience => 'అనుభవం';

  @override
  String profileExperienceYears(Object years) {
    return '$years సం';
  }

  @override
  String get profileEdit => 'ప్రొఫైల్‌ను సవరించండి';

  @override
  String get profileVerified => 'ధృవీకరించబడింది';

  @override
  String get profileNotVerified => 'ధృవీకరించబడలేదు';

  @override
  String get profilePinInvalid => 'సరైన 6 అంకెల పిన్ కోడ్ నమోదు చేయండి';

  @override
  String get profileUpdated => 'ప్రొఫైల్ అప్‌డేట్ అయింది.';

  @override
  String get profilePhotoUpdated => 'ఫోటో అప్‌డేట్ అయింది.';

  @override
  String get profileChangePhoto => 'ఫోటో మార్చండి';

  @override
  String get profileName => 'పేరు';

  @override
  String get profilePhone => 'ఫోన్';

  @override
  String get profileLockedNotice =>
      'మీ పేరు మరియు నంబర్ మీ గుర్తింపు తనిఖీతో అనుసంధానమై ఉన్నాయి. వీటిలో దేనినైనా మార్చాలంటే సపోర్ట్‌ను సంప్రదించండి.';

  @override
  String get profileAbout => 'మీ గురించి';

  @override
  String get profileBioHint =>
      'మీ అనుభవం మరియు మీరు దేనిలో నిపుణులో కస్టమర్లకు చెప్పండి.';

  @override
  String get profileYearsExperience => 'అనుభవ సంవత్సరాలు';

  @override
  String get profileBased => 'మీరు ఎక్కడ ఉంటారు';

  @override
  String get profileAddress => 'చిరునామా';

  @override
  String get profileCity => 'నగరం';

  @override
  String get profilePin => 'పిన్ కోడ్';

  @override
  String get profileGender => 'లింగం';

  @override
  String get genderMale => 'పురుషుడు';

  @override
  String get genderFemale => 'స్త్రీ';

  @override
  String get genderOther => 'ఇతర';

  @override
  String get profileTrades => 'మీ పనులు';

  @override
  String get profileTradesBody =>
      'మీకు ఆమోదం ఉన్న అన్ని పనుల్లో మీరు పని చేయవచ్చు.';

  @override
  String get profileTradesLoadFailed => 'మీ పనులను లోడ్ చేయలేకపోయాము.';

  @override
  String get tradePending => 'పెండింగ్';

  @override
  String get profileAddTrade => 'పనిని జోడించండి';

  @override
  String get profileAddTradeBody =>
      'ఆమోదించే ముందు మీ నైపుణ్యాలకు రుజువు అడగవచ్చు.';

  @override
  String get profileTradeRequested =>
      'అభ్యర్థించారు. ఆమోదించిన వెంటనే తెలియజేస్తాము.';

  @override
  String get profileSave => 'మార్పులను సేవ్ చేయండి';

  @override
  String get supportNewRequest => 'కొత్త అభ్యర్థన';

  @override
  String get supportEmpty => 'ఇంకా అభ్యర్థనలు లేవు';

  @override
  String get supportEmptyBody =>
      'ఏదైనా పని, చెల్లింపు లేదా మీ ఖాతాలో ఏదైనా తప్పు జరిగితే, అభ్యర్థన చేయండి, మేము సహాయం చేస్తాము.';

  @override
  String get supportYourRequests => 'మీ అభ్యర్థనలు';

  @override
  String get supportEmergency => 'అత్యవసర పరిస్థితిలో';

  @override
  String get supportEmergencyBody =>
      'ఈ యాప్ మీ తరపున సహాయం కోసం కాల్ చేయలేదు. మీరు ప్రమాదంలో ఉంటే, నేరుగా అత్యవసర సేవలకు కాల్ చేయండి.';

  @override
  String get supportCall112 => '112 కు కాల్ చేయండి';

  @override
  String get supportPolice => 'పోలీసు';

  @override
  String get ticketOpen => 'తెరిచి ఉంది';

  @override
  String get ticketInProgress => 'జరుగుతోంది';

  @override
  String get ticketReplyNeeded => 'మీ సమాధానం అవసరం';

  @override
  String get ticketResolved => 'పరిష్కరించబడింది';

  @override
  String get ticketClosed => 'మూసివేయబడింది';

  @override
  String ticketLastUpdate(Object date) {
    return 'చివరి అప్‌డేట్ $date';
  }

  @override
  String get supportCategoryJob => 'ఒక పని';

  @override
  String get supportCategoryPayment => 'ఒక చెల్లింపు';

  @override
  String get supportCategoryWithdrawal => 'ఒక విత్‌డ్రా';

  @override
  String get supportCategoryAccount => 'నా ఖాతా';

  @override
  String get supportCategorySafety => 'భద్రత';

  @override
  String get supportCategoryApp => 'యాప్';

  @override
  String get supportCategoryOther => 'వేరే ఏదైనా';

  @override
  String supportRaised(Object code) {
    return 'అభ్యర్థన $code నమోదైంది.';
  }

  @override
  String get supportHowHelp => 'మేము ఎలా సహాయపడగలం?';

  @override
  String get supportAbout => 'ఇది దేని గురించి?';

  @override
  String get supportSubject => 'విషయం';

  @override
  String get supportSubjectHint => 'సమస్య గురించి కొన్ని మాటలు';

  @override
  String get supportWhatHappened => 'ఏమి జరిగింది?';

  @override
  String get supportSend => 'అభ్యర్థన పంపండి';

  @override
  String get ticketTitle => 'సపోర్ట్ అభ్యర్థన';

  @override
  String get ticketNoMessages => 'ఇంకా సందేశాలు లేవు';

  @override
  String get ticketNoMessagesBody => 'మీ సంభాషణ ఇక్కడ కనిపిస్తుంది.';

  @override
  String get ticketWriteMessage => 'సందేశం రాయండి';

  @override
  String get ticketSupportName => 'Wervexa సపోర్ట్';

  @override
  String get requestsTitle => 'కస్టమర్ అభ్యర్థనలు';

  @override
  String get requestsRefresh => 'రిఫ్రెష్ చేయండి';

  @override
  String get requestsLocationNeeded => 'లొకేషన్ అవసరం';

  @override
  String get requestsLocationBody =>
      'మీ దగ్గర్లోని కస్టమర్ అభ్యర్థనలను కనుగొనడానికి మేము మీ లొకేషన్‌ను ఉపయోగిస్తాము.';

  @override
  String get requestsGrantLocation => 'లొకేషన్ యాక్సెస్ ఇవ్వండి';

  @override
  String get requestsEmpty => 'దగ్గర్లో సరిపోయే అభ్యర్థనలు లేవు';

  @override
  String get requestsEmptyBody =>
      'మీ సేవలకు సరిపోయినప్పుడు\nకొత్త కస్టమర్ అభ్యర్థనలు ఇక్కడ కనిపిస్తాయి.';

  @override
  String get requestsViewOffer => 'చూసి ఆఫర్ ఇవ్వండి →';

  @override
  String get requestEnterPrice => 'సరైన ధరను నమోదు చేయండి';

  @override
  String requestOfferSubmitted(Object price) {
    return '$price కు ఆఫర్ సమర్పించబడింది!';
  }

  @override
  String get requestDetailsTitle => 'అభ్యర్థన వివరాలు';

  @override
  String get requestStatusOpen => 'తెరిచి ఉంది';

  @override
  String get requestCategory => 'వర్గం';

  @override
  String get requestBudget => 'బడ్జెట్';

  @override
  String get requestSchedule => 'షెడ్యూల్';

  @override
  String get requestDistance => 'దూరం';

  @override
  String get requestArea => 'ప్రాంతం';

  @override
  String get requestOffers => 'ఆఫర్‌లు';

  @override
  String get requestNotes => 'గమనికలు';

  @override
  String get requestAddressPrivacy =>
      'కస్టమర్ మీ ఆఫర్‌ను అంగీకరించిన తర్వాతే వారి ఖచ్చితమైన చిరునామా పంచుకోబడుతుంది.';

  @override
  String get requestYourOffer => 'మీ ఆఫర్';

  @override
  String get requestYourPrice => 'మీ ధర (₹)';

  @override
  String get requestPriceHint => 'ఉదా. 500';

  @override
  String get requestDuration => 'అంచనా సమయం (ఐచ్ఛికం)';

  @override
  String get requestDurationHint => 'ఉదా. 1-2 గంటలు';

  @override
  String get requestMessage => 'కస్టమర్‌కు సందేశం (ఐచ్ఛికం)';

  @override
  String get requestMessageHint => 'ఈ పనికి మీరే సరైన వ్యక్తి ఎందుకు?';

  @override
  String get requestSubmitOffer => 'ఆఫర్ సమర్పించండి';

  @override
  String get requestMakeOffer => 'ఆఫర్ ఇవ్వండి';

  @override
  String get requestAlreadyOffered =>
      'ఈ అభ్యర్థనకు మీరు ఇప్పటికే ఆఫర్ సమర్పించారు.';

  @override
  String get requestViewOffers => 'ఆఫర్‌లు చూడండి';

  @override
  String get offersEmptyBody =>
      'కస్టమర్ అభ్యర్థనలపై మీరు సమర్పించిన ఆఫర్‌లు\nఇక్కడ కనిపిస్తాయి.';

  @override
  String get offerWithdraw => 'విత్‌డ్రా చేయండి';

  @override
  String get offerWithdrawTitle => 'ఆఫర్‌ను ఉపసంహరించాలా?';

  @override
  String get offerWithdrawBody => 'కస్టమర్‌కు ఈ ఆఫర్ ఇక కనిపించదు.';

  @override
  String get offerWithdrawn => 'ఆఫర్ ఉపసంహరించబడింది';

  @override
  String get onboardingTitle => 'మీ ప్రొఫైల్‌ను సెటప్ చేయండి';

  @override
  String get onboardingHelp => 'సహాయం';

  @override
  String onboardingHello(Object name) {
    return 'నమస్కారం, $name';
  }

  @override
  String get onboardingIntro =>
      'కొన్ని విషయాలు పూర్తి చేస్తే పనులు పొందడం ప్రారంభించడానికి సిద్ధం.';

  @override
  String get onboardingSetup => 'సెటప్';

  @override
  String onboardingStepCount(int done, int total) {
    return '$total లో $done';
  }

  @override
  String get onboardingBasicBody =>
      'మీ నగరం మరియు పిన్ కోడ్, మీ దగ్గర్లో పని కనుగొనడానికి.';

  @override
  String get onboardingTradeBody => 'మీరు ప్రధానంగా చేసే పని.';

  @override
  String get onboardingSkillsDoneBody =>
      'మీ ప్రధాన పని ఒకటిగా లెక్కించబడుతుంది. మీరు చేసే మిగతా అన్ని పనులను జోడించడానికి దీన్ని తెరవండి.';

  @override
  String get onboardingSkillsBody =>
      'మీరు చేసే అన్ని పనులను జోడించండి. మీరు ఒక్క పనికే పరిమితం కాదు.';

  @override
  String get onboardingAreaBody =>
      'ఒక పని కోసం మీరు ఎంత దూరం వెళ్లడానికి సిద్ధంగా ఉన్నారు.';

  @override
  String get onboardingKycBody =>
      'ప్రభుత్వ గుర్తింపు పత్రం. కస్టమర్లు మిమ్మల్ని తమ ఇళ్లలోకి రానిస్తున్నారు.';

  @override
  String get onboardingReviewNotice =>
      'ఇవి పూర్తి చేసిన తర్వాత మా బృందం మీ పత్రాలను తనిఖీ చేస్తుంది. వేచి ఉన్నప్పుడు మీ సేవలను సెటప్ చేస్తూ ఉండవచ్చు.';

  @override
  String get onboardingTradesLoadFailed =>
      'పనులను లోడ్ చేయలేకపోయాము. మళ్లీ ప్రయత్నించండి.';

  @override
  String get onboardingMainTrade => 'మీ ప్రధాన పని ఏమిటి?';

  @override
  String get onboardingMainTradeBody => 'తర్వాత మరిన్ని పనులను జోడించవచ్చు.';

  @override
  String onboardingTradeSet(Object trade) {
    return '$trade మీ ప్రధాన పనిగా సెట్ చేయబడింది.';
  }

  @override
  String get onboardingTravelTitle => 'మీరు ఎంత దూరం ప్రయాణిస్తారు?';

  @override
  String get onboardingTravelBody =>
      'మీరు ఇప్పుడు ఉన్న చోటు నుండి ఈ దూరంలోపు పనులనే మీకు ఇస్తాము.';

  @override
  String get onboardingTravelCentre =>
      'మీ ప్రస్తుత స్థానాన్ని కేంద్ర బిందువుగా ఉపయోగిస్తాము. మీ ప్రొఫైల్ నుండి ఎప్పుడైనా మార్చవచ్చు.';

  @override
  String get onboardingLocationOff =>
      'మీ పని ప్రాంతాన్ని సెట్ చేయడానికి లొకేషన్ యాక్సెస్ ఆన్ చేయండి.';

  @override
  String get commonSave => 'సేవ్ చేయండి';

  @override
  String get notificationsStayOff =>
      'నోటిఫికేషన్‌లు ఆఫ్‌లోనే ఉంటాయి. మీ ఫోన్ సెట్టింగ్‌లలో వాటిని ఆన్ చేయవచ్చు.';

  @override
  String get notificationsPrimerTitle => 'పని వచ్చినప్పుడు తెలుసుకోండి';

  @override
  String get notificationsPrimerBody =>
      'పని ఆఫర్‌లకు గడువు ఉంటుంది. యాప్ మూసి ఉన్నప్పుడు నోటిఫికేషన్ ద్వారానే మీకు తెలుస్తుంది — ఇంకేమీ పంపబడదు.';

  @override
  String get notificationsTurnOn => 'నోటిఫికేషన్‌లు ఆన్ చేయండి';

  @override
  String get commonNotNow => 'ఇప్పుడు కాదు';

  @override
  String get onboardingCityRequired => 'దయచేసి మీ నగరాన్ని నమోదు చేయండి';

  @override
  String get onboardingGenderRequired => 'దయచేసి మీ లింగాన్ని ఎంచుకోండి';

  @override
  String get onboardingWhereBased => 'మీరు ఎక్కడ ఉంటారు?';
}
