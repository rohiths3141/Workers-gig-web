// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Gujarati (`gu`).
class AppLocalizationsGu extends AppLocalizations {
  AppLocalizationsGu([String locale = 'gu']) : super(locale);

  @override
  String get languagePickerTitle => 'તમારી ભાષા પસંદ કરો';

  @override
  String get startupMissingConfig => 'આ બિલ્ડમાં કૉન્ફિગરેશન નથી.';

  @override
  String startupPassDartDefine(Object keys) {
    return 'આ --dart-define સાથે આપો:\n\n$keys';
  }

  @override
  String get startupCouldNotStart => 'એપ શરૂ થઈ શકી નહીં.';

  @override
  String get errorNoInternet =>
      'ઇન્ટરનેટ કનેક્શન નથી. તમારું નેટવર્ક તપાસો અને ફરી પ્રયાસ કરો.';

  @override
  String get errorTimeout => 'આમાં ખૂબ સમય લાગ્યો. ફરી પ્રયાસ કરો.';

  @override
  String get errorServer =>
      'અમારી બાજુ કંઈક ખોટું થયું. કૃપા કરીને ફરી પ્રયાસ કરો.';

  @override
  String get errorClockSkew =>
      'તમારા ફોનની તારીખ અને સમય મેળ ખાતા નથી. સેટિંગ્સમાં આપમેળે તારીખ અને સમય ચાલુ કરો, પછી ફરી પ્રયાસ કરો.';

  @override
  String get errorUnexpected => 'કંઈક ખોટું થયું. કૃપા કરીને ફરી પ્રયાસ કરો.';

  @override
  String get eligibilityStepIncomplete => 'આ પગલું હજુ પૂરું થયું નથી.';

  @override
  String get errorSessionEnded =>
      'તમારું સત્ર સમાપ્ત થયું છે. કૃપા કરીને ફરી સાઇન ઇન કરો.';

  @override
  String get errorUploadFailed => 'તે ફાઇલ અપલોડ થઈ શકી નહીં. ફરી પ્રયાસ કરો.';

  @override
  String get errorServiceUnavailable =>
      'તે સેવા અત્યારે ઉપલબ્ધ નથી. થોડી વારમાં ફરી પ્રયાસ કરો.';

  @override
  String get errorSignInNotReady =>
      'તમારું સાઇન-ઇન હજુ પૂરેપૂરું તૈયાર નથી. થોડી વારમાં ફરી પ્રયાસ કરો.';

  @override
  String get errorNoLongerAvailable => 'તે હવે ઉપલબ્ધ નથી.';

  @override
  String get errorNotAllowedToSee => 'તમે તે જોઈ શકતા નથી.';

  @override
  String get errorDidNotWork =>
      'તે કામ કર્યું નહીં. કૃપા કરીને ફરી પ્રયાસ કરો.';

  @override
  String get authErrorInvalidPhone => 'તે ફોન નંબર સાચો લાગતો નથી.';

  @override
  String get authErrorWrongCode => 'તે કોડ સાચો નથી. તપાસો અને ફરી પ્રયાસ કરો.';

  @override
  String get authErrorCodeExpired =>
      'તે કોડની મુદત પૂરી થઈ ગઈ છે. નવો કોડ માંગો.';

  @override
  String get authErrorTooManyAttempts =>
      'ઘણા બધા પ્રયાસો થયા. ફરી પ્રયાસ કરતા પહેલાં થોડી મિનિટ રાહ જુઓ.';

  @override
  String get authErrorQuota =>
      'અમે અત્યારે કોડ મોકલી શકતા નથી. થોડી વારમાં ફરી પ્રયાસ કરો.';

  @override
  String get authErrorDisabled =>
      'આ ખાતું બંધ કરવામાં આવ્યું છે. સહાયનો સંપર્ક કરો.';

  @override
  String get authErrorPhoneNotEnabledRegion =>
      'ફોન સાઇન-ઇન ચાલુ નથી, અથવા આ વિસ્તારમાં SMS અવરોધિત છે. Firebase Console ની સેટિંગ્સ તપાસો.';

  @override
  String get authErrorNumberInUse =>
      'તે નંબર પહેલેથી બીજા ખાતા સાથે નોંધાયેલો છે.';

  @override
  String get authErrorSignInAgain =>
      'આગળ વધવા માટે કૃપા કરીને ફરી સાઇન ઇન કરો.';

  @override
  String get authErrorSignInFailed =>
      'સાઇન-ઇન નિષ્ફળ થયું. કૃપા કરીને ફરી પ્રયાસ કરો.';

  @override
  String get budgetTypeFlexible => 'લવચીક';

  @override
  String get budgetTypeFixed => 'નિશ્ચિત કિંમત';

  @override
  String get budgetTypeRange => 'કિંમતની શ્રેણી';

  @override
  String get scheduleAsap => 'શક્ય તેટલું જલદી';

  @override
  String get scheduleToday => 'આજે';

  @override
  String get scheduleTomorrow => 'આવતીકાલે';

  @override
  String get scheduleSpecificDate => 'ચોક્કસ તારીખ';

  @override
  String get offerStatusSubmitted => 'મોકલી';

  @override
  String get offerStatusViewed => 'ગ્રાહકે જોઈ';

  @override
  String get offerStatusShortlisted => 'શૉર્ટલિસ્ટ કરી';

  @override
  String get offerStatusAccepted => 'સ્વીકારી ✓';

  @override
  String get offerStatusRejected => 'પસંદ કર્યું નથી';

  @override
  String get offerStatusWithdrawn => 'પાછી ખેંચી';

  @override
  String get offerStatusExpired => 'મુદત પૂરી';

  @override
  String get offerStatusClosed => 'બંધ';

  @override
  String distanceMetresAway(Object metres) {
    return '$metres મી દૂર';
  }

  @override
  String distanceKmAway(Object km) {
    return '$km કિમી દૂર';
  }

  @override
  String offerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ઑફર',
      one: '1 ઑફર',
      zero: 'હજુ કોઈ ઑફર નથી',
    );
    return '$_temp0';
  }

  @override
  String get gigErrorTrade => 'આ સેવા કયા કામની છે તે પસંદ કરો';

  @override
  String get gigErrorTitleShort =>
      'આ સેવાને ઓછામાં ઓછા 6 અક્ષરનું સ્પષ્ટ નામ આપો';

  @override
  String get gigErrorTitleLong => 'નામ 120 અક્ષરથી ઓછું રાખો';

  @override
  String get gigErrorPrice => 'આ સેવા માટે તમે કેટલું લો છો તે દાખલ કરો';

  @override
  String get gigErrorDurationMissing => 'આમાં સામાન્ય રીતે કેટલો સમય લાગે છે?';

  @override
  String get gigErrorDurationShort =>
      'અમે સૂચિમાં મૂકી શકીએ તે સૌથી નાનું કામ 15 મિનિટનું છે';

  @override
  String get gigErrorDurationLong =>
      'અમે સૂચિમાં મૂકી શકીએ તે સૌથી લાંબું કામ 14 દિવસનું છે';

  @override
  String get gigErrorRadius => 'મુસાફરીનું અંતર 1 થી 100 કિમી વચ્ચે હોવું જોઈએ';

  @override
  String get jobAreaNearby => 'નજીકમાં';

  @override
  String get jobBlockerVerifyArrival => 'ગ્રાહકના કોડથી આગમન ચકાસો';

  @override
  String get jobBlockerAfterPhoto => 'પૂરા થયેલા કામનો ફોટો ઉમેરો';

  @override
  String jobBlockerMaterialsPending(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'સામગ્રીની $count વિનંતીઓ હજુ ગ્રાહકની રાહ જુએ છે',
      one: 'સામગ્રીની 1 વિનંતી હજુ ગ્રાહકની રાહ જુએ છે',
    );
    return '$_temp0';
  }

  @override
  String mediaTypeNotAccepted(Object kinds) {
    return 'આ પ્રકારની ફાઇલ અહીં સ્વીકાર્ય નથી. $kinds વાપરો.';
  }

  @override
  String get mediaEmpty => 'તે ફાઇલ ખાલી છે.';

  @override
  String mediaTooLarge(Object megabytes) {
    return 'તે ફાઇલ ખૂબ મોટી છે. મર્યાદા ${megabytes}MB છે.';
  }

  @override
  String get verificationNotStarted => 'શરૂ થયું નથી';

  @override
  String get verificationSubmitted => 'મોકલી';

  @override
  String get verificationUnderReview => 'સમીક્ષા ચાલુ છે';

  @override
  String get verificationMoreInfo => 'વધુ માહિતી જોઈએ';

  @override
  String get verificationExpired => 'મુદત પૂરી';

  @override
  String get verificationVerified => 'ચકાસેલું';

  @override
  String get verificationNotApproved => 'મંજૂર નથી';

  @override
  String get verificationNotRequired => 'જરૂરી નથી';

  @override
  String get qualificationErrorInstitution => 'આ કઈ સંસ્થાએ આપ્યું?';

  @override
  String get qualificationErrorName => 'આ લાયકાતનું નામ શું છે?';

  @override
  String get qualificationErrorYearMissing => 'તમે આ કયા વર્ષે પૂર્ણ કર્યું?';

  @override
  String qualificationErrorYearRange(Object year) {
    return '1950 અને $year વચ્ચેનું વર્ષ દાખલ કરો';
  }

  @override
  String get walletTxJobEarning => 'કામની કમાણી';

  @override
  String get walletTxMaterialReimbursed => 'સામગ્રીની ભરપાઈ';

  @override
  String get walletTxAdjustment => 'સમાયોજન';

  @override
  String get walletTxPayoutReturned => 'પેઆઉટ પાછું આવ્યું';

  @override
  String get walletTxPlatformFee => 'પ્લૅટફૉર્મ ફી';

  @override
  String get walletTxWithdrawn => 'પાછી ખેંચી';

  @override
  String get walletTxClaimRecovery => 'દાવાની વસૂલાત';

  @override
  String get payoutStatusRequested => 'વિનંતી કરી';

  @override
  String get payoutStatusProcessing => 'પ્રક્રિયામાં';

  @override
  String get payoutStatusPaid => 'ચૂકવાયું';

  @override
  String get payoutStatusFailed => 'નિષ્ફળ';

  @override
  String get authPhoneTenDigits => '10 અંકનો મોબાઇલ નંબર દાખલ કરો.';

  @override
  String get authCodeSendTimeout =>
      'અમે કોડ મોકલી શક્યા નહીં. તમારું નેટવર્ક તપાસો અને ફરી પ્રયાસ કરો.';

  @override
  String get authEnterReceivedCode => 'તમને મળેલો કોડ દાખલ કરો.';

  @override
  String get authSignInIncomplete =>
      'સાઇન-ઇન પૂર્ણ થયું નહીં. કૃપા કરીને ફરી પ્રયાસ કરો.';

  @override
  String get authSignInToContinue => 'આગળ વધવા માટે કૃપા કરીને સાઇન ઇન કરો.';

  @override
  String get accountDeletionBySupport =>
      'ખાતું કાઢી નાખવાનું કામ અમારી સહાય ટીમ કરે છે. વિનંતી કરો અને કામ થયા પછી અમે પુષ્ટિ કરીશું.';

  @override
  String get photoUploadFailed => 'તે ફોટો અપલોડ થઈ શક્યો નહીં.';

  @override
  String get photoUploadFailedRetry =>
      'તે ફોટો અપલોડ થઈ શક્યો નહીં. ફરી પ્રયાસ કરો.';

  @override
  String get locationInvalid => 'તે સ્થાન સાચું લાગતું નથી.';

  @override
  String get travelDistanceRange =>
      '1 થી 100 કિમી વચ્ચે મુસાફરીનું અંતર પસંદ કરો.';

  @override
  String get profileLoadFailed => 'તમારી પ્રોફાઇલ લોડ થઈ શકી નહીં.';

  @override
  String get uploadIncomplete => 'અપલોડ પૂર્ણ થયું નહીં. ફરી પ્રયાસ કરો.';

  @override
  String get uploadTooLarge => 'તે ફાઇલ ખૂબ મોટી છે.';

  @override
  String get uploadTypeNotAccepted => 'આ પ્રકારની ફાઇલ સ્વીકાર્ય નથી.';

  @override
  String get uploadRefused => 'તે ફાઇલ નકારી કાઢવામાં આવી.';

  @override
  String get uploadTooMany =>
      'એકસાથે ઘણા અપલોડ. થોડી રાહ જુઓ અને ફરી પ્રયાસ કરો.';

  @override
  String get uploadGone => 'તે અપલોડ હવે ઉપલબ્ધ નથી. ફાઇલ ફરી પસંદ કરો.';

  @override
  String get uploadDidNotStart => 'અપલોડ શરૂ થયું નહીં.';

  @override
  String get uploadDidNotFinish => 'તે અપલોડ પૂરું થયું નહીં.';

  @override
  String get claimResponseTooShort =>
      'કૃપા કરીને શું થયું તે થોડું વધુ વિગતે જણાવો.';

  @override
  String get walletLoadFailedRetry =>
      'તમારું વૉલેટ લોડ થઈ શક્યું નહીં. કૃપા કરીને ફરી પ્રયાસ કરો.';

  @override
  String get walletLoadFailed => 'તમારું વૉલેટ લોડ થઈ શક્યું નહીં.';

  @override
  String get onboardingStepDetails => 'તમારી વિગતો';

  @override
  String get onboardingStepTrade => 'તમારું મુખ્ય કામ';

  @override
  String get onboardingStepSkills => 'તમે શું કરી શકો છો';

  @override
  String get onboardingStepArea => 'તમે ક્યાં કામ કરો છો';

  @override
  String get onboardingStepKyc => 'ઓળખ ચકાસણી';

  @override
  String get onboardingStepReady => 'કામ માટે તૈયાર';

  @override
  String routerScreenNotFound(Object location) {
    return 'તે સ્ક્રીન ખૂલી શકી નહીં.\n$location';
  }

  @override
  String get cameraOpenFailed => 'કૅમેરા ખૂલી શક્યો નહીં. એપની પરવાનગીઓ તપાસો.';

  @override
  String get commonTryAgain => 'ફરી પ્રયાસ કરો';

  @override
  String get commonCancel => 'રદ કરો';

  @override
  String get commonConfirm => 'પુષ્ટિ કરો';

  @override
  String get offlineBanner =>
      'તમે ઑફલાઇન છો. ફરી કનેક્ટ થશો ત્યારે કામની ક્રિયાઓ ફરી ચાલશે.';

  @override
  String get badgeNew => 'નવું';

  @override
  String get badgeAccepted => 'સ્વીકારી';

  @override
  String get badgeConfirmed => 'પુષ્ટિ થઈ';

  @override
  String get badgeOnTheWay => 'રસ્તામાં';

  @override
  String get badgeArrived => 'પહોંચ્યા';

  @override
  String get badgeWorking => 'કામ ચાલુ';

  @override
  String get badgeAwaitingCustomer => 'ગ્રાહકની રાહ';

  @override
  String get badgeDone => 'પૂર્ણ';

  @override
  String get badgePaymentDue => 'ચુકવણી બાકી';

  @override
  String get badgePaid => 'ચૂકવાયું';

  @override
  String get badgeClosed => 'બંધ';

  @override
  String get badgeCancelled => 'રદ';

  @override
  String get badgeDisputed => 'વિવાદમાં';

  @override
  String get badgeExpired => 'મુદત પૂરી';

  @override
  String get badgeDraft => 'ડ્રાફ્ટ';

  @override
  String get badgeInReview => 'સમીક્ષામાં';

  @override
  String get badgeLive => 'લાઇવ';

  @override
  String get badgePaused => 'થોભાવેલું';

  @override
  String get badgeNotApproved => 'મંજૂર નથી';

  @override
  String get badgeRemoved => 'દૂર કર્યું';

  @override
  String get badgeNotStarted => 'શરૂ થયું નથી';

  @override
  String get badgeSubmitted => 'મોકલી';

  @override
  String get badgeActionNeeded => 'પગલું જરૂરી';

  @override
  String get badgeVerified => 'ચકાસેલું';

  @override
  String get badgeNotRequired => 'જરૂરી નથી';

  @override
  String get commonContinue => 'આગળ વધો';

  @override
  String get commonSaving => 'સાચવી રહ્યા છીએ…';

  @override
  String get welcomePromiseWorkTitle => 'યોગ્ય કામ મેળવો';

  @override
  String get welcomePromiseWorkBody =>
      'તમારી નજીકનાં કામ, તમે ખરેખર કરો છો તે કામ સાથે મેળ ખાતાં.';

  @override
  String get welcomePromiseSkillsTitle => 'તમારું કૌશલ્ય સાબિત કરો';

  @override
  String get welcomePromiseSkillsBody =>
      'તમારાં ITI અને ડિપ્લોમા પ્રમાણપત્રો, એકવાર ચકાસીને દરેક ગ્રાહકને બતાવાય છે.';

  @override
  String get welcomePromiseTrackTitle => 'દરેક કામ પર નજર રાખો';

  @override
  String get welcomePromiseTrackBody =>
      'કામ સ્વીકારવાથી પૂરું કરવા સુધી, દરેક પગલે ફોટો રેકૉર્ડ સાથે.';

  @override
  String get welcomePromisePaidTitle => 'સુરક્ષિત ચુકવણી મેળવો';

  @override
  String get welcomePromisePaidBody =>
      'દરેક રૂપિયો નોંધાયેલો, સ્પષ્ટ સ્ટેટમેન્ટ સાથે અને તમારી શરતે ઉપાડ.';

  @override
  String get welcomeHeadline => 'કામ જે તમને શોધે';

  @override
  String get welcomeSubtitle =>
      'Wervexa કુશળ વ્યાવસાયિકોને તેમની જરૂર હોય તેવા ગ્રાહકો સાથે જોડે છે.';

  @override
  String get welcomeGetStarted => 'શરૂ કરો';

  @override
  String get welcomeCodeNotice =>
      'અમે તમારા મોબાઇલ નંબર પર એક વખતનો કોડ મોકલીશું.';

  @override
  String get phoneTitle => 'તમારો મોબાઇલ નંબર શું છે?';

  @override
  String get phoneSubtitle =>
      'આ તમે જ છો તેની પુષ્ટિ માટે અમે એક વખતનો કોડ મોકલીશું.';

  @override
  String get phoneSendCode => 'કોડ મોકલો';

  @override
  String get phoneSending => 'મોકલી રહ્યા છીએ…';

  @override
  String get authNewCodeSent => 'અમે નવો કોડ મોકલ્યો છે.';

  @override
  String get otpTitle => 'કોડ દાખલ કરો';

  @override
  String otpSentTo(Object phone) {
    return 'અમે $phone પર 6 અંકનો કોડ મોકલ્યો છે.';
  }

  @override
  String otpResendIn(int seconds) {
    String _temp0 = intl.Intl.pluralLogic(
      seconds,
      locale: localeName,
      other: 'તમે $seconds સેકન્ડમાં નવો કોડ માંગી શકો છો',
      one: 'તમે 1 સેકન્ડમાં નવો કોડ માંગી શકો છો',
    );
    return '$_temp0';
  }

  @override
  String get otpSendNew => 'નવો કોડ મોકલો';

  @override
  String get otpVerify => 'ચકાસો';

  @override
  String get otpVerifying => 'ચકાસી રહ્યા છીએ…';

  @override
  String get registerNameRequired => 'કૃપા કરીને તમારું પૂરું નામ દાખલ કરો';

  @override
  String get registerEmailInvalid => 'કૃપા કરીને માન્ય ઇમેઇલ સરનામું દાખલ કરો';

  @override
  String get registerTitle => 'અમે તમને શું કહીને બોલાવીએ?';

  @override
  String get registerSubtitle => 'ગ્રાહકોને આ જ નામ દેખાશે.';

  @override
  String get registerNameLabel => 'પૂરું નામ';

  @override
  String get registerNameHint => 'અરુણ કુમાર';

  @override
  String get registerEmailLabel => 'ઇમેઇલ (વૈકલ્પિક)';

  @override
  String get registerEmailHelper => 'રસીદો અને સ્ટેટમેન્ટ માટે.';

  @override
  String registerVerifiedPhone(Object phone) {
    return 'ચકાસેલો: $phone';
  }

  @override
  String get navHome => 'હોમ';

  @override
  String get navJobs => 'કામ';

  @override
  String get navWallet => 'વૉલેટ';

  @override
  String get navProfile => 'પ્રોફાઇલ';

  @override
  String get sessionProfileLoadFailedRetry =>
      'અમે તમારી પ્રોફાઇલ લોડ કરી શક્યા નહીં. કૃપા કરીને ફરી પ્રયાસ કરો.';

  @override
  String get commonSignOut => 'સાઇન આઉટ કરો';

  @override
  String get serviceElectrical => 'ઇલેક્ટ્રિકલ';

  @override
  String get servicePlumbing => 'પ્લમ્બિંગ';

  @override
  String get serviceAcService => 'AC સર્વિસ';

  @override
  String get serviceApplianceRepair => 'ઉપકરણ સમારકામ';

  @override
  String get serviceCarpentry => 'સુથારીકામ';

  @override
  String get servicePainting => 'રંગકામ';

  @override
  String get serviceCleaning => 'સફાઈ';

  @override
  String get servicePestControl => 'જીવાત નિયંત્રણ';

  @override
  String get serviceOtherHome => 'અન્ય ઘરેલું સેવાઓ';

  @override
  String get commonSeeAll => 'બધું જુઓ';

  @override
  String distanceKm(Object km) {
    return '$km કિમી';
  }

  @override
  String get homeRightNow => 'અત્યારે';

  @override
  String get homeNewWork => 'નવું કામ';

  @override
  String homeJobsWaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count કામ તમારા જવાબની રાહ જુએ છે',
      one: '1 કામ તમારા જવાબની રાહ જુએ છે',
    );
    return '$_temp0';
  }

  @override
  String get homeComingUp => 'આગામી';

  @override
  String get homeEarnings => 'કમાણી';

  @override
  String get homeMyServices => 'મારી સેવાઓ';

  @override
  String get homeVerification => 'ચકાસણી';

  @override
  String get homeSupport => 'સહાય';

  @override
  String get homeRequests => 'વિનંતીઓ';

  @override
  String get homeMyOffers => 'મારી ઑફર';

  @override
  String get homeAddService => 'સેવા ઉમેરો';

  @override
  String get homeAddServiceBody =>
      'તમે પ્રકાશિત કરેલી સેવાઓ માટે જ ગ્રાહકો તમને બુક કરી શકે છે.';

  @override
  String get homeNotReady => 'હજુ પૂરેપૂરા તૈયાર નથી';

  @override
  String get homeNotReadyBody =>
      'આ પગલાં પૂરાં કરો અને તમને કામ મળવાનું શરૂ થશે.';

  @override
  String get homeGoodMorning => 'સુપ્રભાત';

  @override
  String get homeGoodAfternoon => 'શુભ બપોર';

  @override
  String get homeGoodEvening => 'શુભ સાંજ';

  @override
  String get homeNotifications => 'સૂચનાઓ';

  @override
  String get availabilityAvailable => 'ઉપલબ્ધ';

  @override
  String get availabilityAvailableBody => 'તમે નવાં કામ મેળવી શકો છો.';

  @override
  String get availabilityOnJob => 'કામ પર';

  @override
  String get availabilityOnJobBody =>
      'આ કામ પૂરું ન થાય ત્યાં સુધી તમને નવું કામ નહીં મળે.';

  @override
  String get availabilityOff => 'બંધ';

  @override
  String get availabilityOffBody => 'તમને નવાં કામ નહીં મળે.';

  @override
  String get availabilityFinishJob => 'ફરી ઉપલબ્ધ થવા હાલનું કામ પૂરું કરો.';

  @override
  String get availabilityGoOff => 'ડ્યૂટી બંધ કરો';

  @override
  String get availabilityGoOn => 'ઉપલબ્ધ થાઓ';

  @override
  String get availabilityBeforeJobs => 'કામ મળે તે પહેલાં';

  @override
  String get availabilityNowOn => 'તમે કામ માટે ઉપલબ્ધ છો.';

  @override
  String get availabilityNowOff => 'તમે ડ્યૂટી પર નથી.';

  @override
  String get workerStatusSetupIncomplete => 'સેટઅપ અધૂરું';

  @override
  String get workerStatusUnderReview => 'સમીક્ષામાં';

  @override
  String get workerStatusInactive => 'નિષ્ક્રિય';

  @override
  String get workerStatusRestricted => 'પ્રતિબંધિત';

  @override
  String get workerStatusSuspended => 'સસ્પેન્ડ';

  @override
  String get homeAccount => 'ખાતું';

  @override
  String get homeWorkStatus => 'કામની સ્થિતિ';

  @override
  String get availabilityOffDuty => 'ડ્યૂટી પર નથી';

  @override
  String get earningsThisWeek => 'આ અઠવાડિયે';

  @override
  String get earningsThisMonth => 'આ મહિને';

  @override
  String get jobNextWaitConfirm => 'ગ્રાહકની પુષ્ટિની રાહ';

  @override
  String get jobNextStartTravel => 'મુસાફરી શરૂ કરો';

  @override
  String get jobNextMarkArrived => 'પહોંચ્યાની નોંધ કરો';

  @override
  String get jobNextStartWork => 'કામ શરૂ કરો';

  @override
  String get jobNextAskCode => 'ગ્રાહક પાસે આગમન કોડ માંગો';

  @override
  String get jobNextFinish => 'પૂરું કરો અને ફોટા ઉમેરો';

  @override
  String get jobNextWaitApprove => 'ગ્રાહકની મંજૂરીની રાહ';

  @override
  String get jobNextOpen => 'કામ ખોલો';

  @override
  String get jobTimeTbc => 'સમય નક્કી થવાનો બાકી';

  @override
  String get settingsTitle => 'સેટિંગ્સ';

  @override
  String get settingsLanguage => 'ભાષા';

  @override
  String get settingsAbout => 'વિશે';

  @override
  String get settingsTerms => 'સેવાની શરતો';

  @override
  String get settingsPrivacy => 'ગોપનીયતા નીતિ';

  @override
  String get settingsHelp => 'મદદ અને સહાય';

  @override
  String get settingsDeleteAccount => 'મારું ખાતું કાઢી નાખો';

  @override
  String get settingsSignOutTitle => 'સાઇન આઉટ કરીએ?';

  @override
  String get settingsSignOutBody =>
      'ફરી સાઇન ઇન કરવા તમારો ફોન નંબર અને કોડ જોઈશે.';

  @override
  String get settingsDeleteTitle => 'તમારું ખાતું કાઢી નાખો';

  @override
  String get settingsDeleteBody =>
      'ખાતું કાઢી નાખવાથી તમારો કામનો ઇતિહાસ, કમાણીના રેકૉર્ડ અને ખુલ્લી ચુકવણીઓ પર અસર થાય છે, તેથી તે આપમેળે નહીં પણ અમારી સહાય ટીમ કરે છે.\n\nસહાય વિનંતી કરો અને કામ થયા પછી અમે પુષ્ટિ કરીશું.';

  @override
  String get settingsContactSupport => 'સહાયનો સંપર્ક કરો';

  @override
  String get notificationsMarkAllRead => 'બધી વાંચેલી ચિહ્નિત કરો';

  @override
  String get notificationsEmpty => 'તમે બધું જોઈ લીધું છે';

  @override
  String get notificationsEmptyBody =>
      'કામની ઑફર, ચુકવણીનાં અપડેટ અને ચકાસણીનાં પરિણામો અહીં દેખાશે.';

  @override
  String get jobsTabUpcoming => 'આગામી';

  @override
  String get jobsTabActive => 'ચાલુ';

  @override
  String get jobsNoOffers => 'અત્યારે નવાં કામ નથી';

  @override
  String get jobsNoOffersBody =>
      'તમે ઉપલબ્ધ હશો ત્યારે યોગ્ય કામ આવતાં જ અમે જણાવીશું.';

  @override
  String get jobsAccepted => 'કામ સ્વીકાર્યું.';

  @override
  String get jobsDeclineTitle => 'આ કામ નકારીએ?';

  @override
  String get jobsDeclineBody =>
      'તે બીજા કર્મચારીને આપવામાં આવશે. વારંવાર નકારવાથી તમને દેખાતાં કામ ઓછાં થઈ શકે છે.';

  @override
  String get jobsDecline => 'નકારો';

  @override
  String get jobsDeclined => 'કામ નકાર્યું.';

  @override
  String get jobsEmptyUpcoming => 'કંઈ નક્કી નથી';

  @override
  String get jobsEmptyUpcomingBody => 'તમે સ્વીકારેલાં કામ અહીં દેખાશે.';

  @override
  String get jobsEmptyActive => 'કોઈ કામ ચાલુ નથી';

  @override
  String get jobsEmptyActiveBody => 'તમે કામ શરૂ કરશો ત્યારે તે અહીં દેખાશે.';

  @override
  String get jobsEmptyCompleted => 'હજુ કોઈ કામ પૂરું થયું નથી';

  @override
  String get jobsEmptyCompletedBody =>
      'પૂરાં થયેલાં કામ અને તેમાંથી તમારી કમાણી અહીં દેખાશે.';

  @override
  String get jobsEmptyCancelled => 'કંઈ રદ થયું નથી';

  @override
  String get jobsEmptyCancelledBody => 'રદ થયેલાં કામ અહીં દેખાશે.';

  @override
  String get jobsEmptyOffers => 'કોઈ ઑફર નથી';

  @override
  String get jobsEmptyOffersBody => 'નવાં કામ અહીં દેખાશે.';

  @override
  String get jobTitleFallback => 'કામ';

  @override
  String jobCancelledReason(Object reason) {
    return 'રદ: $reason';
  }

  @override
  String get jobAmount => 'કામની રકમ';

  @override
  String get jobMaterials => 'સામગ્રી';

  @override
  String get jobYouEarned => 'તમારી કમાણી';

  @override
  String get jobRateCustomer => 'ગ્રાહકને રેટિંગ આપો';

  @override
  String get jobRateQuestion => 'આ કામ તમારા માટે કેવું રહ્યું?';

  @override
  String get jobRate => 'રેટિંગ આપો';

  @override
  String get jobHistory => 'શું શું થયું';

  @override
  String get jobHistoryLoadFailed => 'કામનો ઇતિહાસ લોડ થઈ શક્યો નહીં.';

  @override
  String get jobOfferExpired => 'આ કામ હવે ઉપલબ્ધ નથી.';

  @override
  String get jobOfferNewBadge => 'નવું કામ';

  @override
  String get jobOfferYouEarn => 'તમારી કમાણી';

  @override
  String get jobOfferPriceAfterVisit => 'મુલાકાત પછી નક્કી થશે';

  @override
  String get jobOfferAccept => 'કામ સ્વીકારો';

  @override
  String get activeJobTitle => 'હાલનું કામ';

  @override
  String get activeJobEmptyBody =>
      'તમે કામ સ્વીકારીને શરૂ કરશો ત્યારે તે અહીં દેખાશે.';

  @override
  String get evidenceBeforeTitle => 'શરૂ કરતા પહેલાં';

  @override
  String get evidenceBeforeBody =>
      'હાથ લગાડતા પહેલાં સમસ્યાનો ફોટો લો. ગ્રાહક પછીથી કામ પર વિવાદ કરે તો આ તમારું રક્ષણ કરે છે.';

  @override
  String get evidenceAfterTitle => 'પૂરું કર્યા પછી';

  @override
  String get evidenceAfterBody =>
      'ગ્રાહક પછીથી વિવાદ કરે તો પૂરા કામનો ફોટો જ તમારો પુરાવો છે. વૈકલ્પિક, પણ દસ સેકન્ડ આપવા જેવું.';

  @override
  String get jobCustomerHidden => 'પુષ્ટિ થયા પછી ગ્રાહકની વિગતો શેર થશે';

  @override
  String get jobCall => 'કૉલ કરો';

  @override
  String get jobDirections => 'દિશાઓ';

  @override
  String get jobTrackOnMap => 'નકશા પર ટ્રૅક કરો';

  @override
  String get trailAccepted => 'સ્વીકારી';

  @override
  String get trailOnTheWay => 'રસ્તામાં';

  @override
  String get trailArrived => 'પહોંચ્યા';

  @override
  String get trailArrivalConfirmed => 'આગમનની પુષ્ટિ થઈ';

  @override
  String get trailWorkStarted => 'કામ શરૂ થયું';

  @override
  String get trailFinished => 'પૂરું થયું';

  @override
  String get jobProgress => 'પ્રગતિ';

  @override
  String get jobBeforeFinish => 'પૂરું કરતા પહેલાં';

  @override
  String get jobActionStartTravel => 'મુસાફરી શરૂ કરો';

  @override
  String get jobActionArrived => 'હું પહોંચી ગયો છું';

  @override
  String get jobActionEnterCode => 'આગમન કોડ દાખલ કરો';

  @override
  String get jobActionStartWork => 'કામ શરૂ કરો';

  @override
  String get jobActionFinish => 'કામ પૂરું કરો';

  @override
  String get jobArrivalConfirmed => 'આગમનની પુષ્ટિ થઈ.';

  @override
  String get jobFinishTitle => 'આ કામ પૂરું કરીએ?';

  @override
  String get jobFinishBody =>
      'ગ્રાહકને કામ મંજૂર કરવા કહેવાશે. પછી તમે ફોટા ઉમેરી શકશો નહીં.';

  @override
  String get jobOnYourWay => 'તમે રસ્તામાં છો.';

  @override
  String get jobMarkedArrived => 'પહોંચ્યાની નોંધ થઈ.';

  @override
  String get jobWorkStarted => 'કામ શરૂ થયું.';

  @override
  String get jobSentForApproval => 'મંજૂરી માટે ગ્રાહકને મોકલ્યું.';

  @override
  String get jobUpdated => 'અપડેટ થયું.';

  @override
  String get jobWaitConfirm => 'ગ્રાહક બુકિંગની પુષ્ટિ કરે તેની રાહ.';

  @override
  String get jobWaitApprove => 'ગ્રાહક તમારું કામ મંજૂર કરે તેની રાહ.';

  @override
  String get jobWaitPaymentProcessing => 'મંજૂર. ચુકવણી પ્રક્રિયામાં છે.';

  @override
  String get jobWaitPayment => 'ગ્રાહકની ચુકવણીની રાહ.';

  @override
  String get jobWaitPaid => 'ચૂકવાયું. તમારી કમાણી તમારા વૉલેટમાં દેખાશે.';

  @override
  String get jobWaitDisputed =>
      'અમારી ટીમ આ કામની સમીક્ષા કરી રહી છે. અમે સંપર્ક કરીશું.';

  @override
  String get jobWaitNothing => 'અત્યારે કંઈ કરવાનું નથી.';

  @override
  String get travelRouteUnavailable => 'રસ્તો ઉપલબ્ધ નથી';

  @override
  String get travelNoDestination => 'કોઈ મંજિલ સેટ નથી';

  @override
  String get travelNoDestinationBody =>
      'આ કામમાં રસ્તો બતાવવા માટે સેવાનું સ્થાન નથી.';

  @override
  String get travelJobLocation => 'કામનું સ્થાન';

  @override
  String get travelYou => 'તમે';

  @override
  String get travelCustomer => 'ગ્રાહક';

  @override
  String get travelCalculating => 'રસ્તો ગણી રહ્યા છીએ...';

  @override
  String distanceMetres(Object metres) {
    return '$metres મી';
  }

  @override
  String etaMinutes(Object minutes) {
    return '$minutes મિનિટ';
  }

  @override
  String etaHours(Object hours) {
    return '$hours કલાક';
  }

  @override
  String get arrivalWrongCode => 'તે કોડ સાચો નથી.';

  @override
  String arrivalWrongCodeAttempts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'તે કોડ સાચો નથી. $count પ્રયાસ બાકી.',
      one: 'તે કોડ સાચો નથી. 1 પ્રયાસ બાકી.',
    );
    return '$_temp0';
  }

  @override
  String get arrivalTitle => 'તમે પહોંચી ગયા છો તેની પુષ્ટિ કરો';

  @override
  String get arrivalBody =>
      'ગ્રાહકને તેમની એપનો કોડ વાંચી સંભળાવવા કહો, પછી અહીં લખો.';

  @override
  String get arrivalLocked =>
      'ઘણા ખોટા કોડ. આ કામ ચાલુ રાખવા કૃપા કરીને સહાયનો સંપર્ક કરો.';

  @override
  String get arrivalConfirm => 'આગમનની પુષ્ટિ કરો';

  @override
  String get arrivalNotYet => 'હજુ નહીં';

  @override
  String get rateThanks => 'તમારા પ્રતિસાદ બદલ આભાર.';

  @override
  String get rateTitle => 'આ ગ્રાહક કેવા હતા?';

  @override
  String get rateBody =>
      'તમારું રેટિંગ ખાનગી છે અને કર્મચારીઓની કાળજી રાખવામાં અમને મદદ કરે છે.';

  @override
  String get rateCommentLabel => 'બીજું કંઈ ઉમેરવું છે? (વૈકલ્પિક)';

  @override
  String get rateSubmit => 'રેટિંગ મોકલો';

  @override
  String get timerServiceTime => 'સેવાનો સમય';

  @override
  String get materialsAdd => 'ઉમેરો';

  @override
  String get materialsLoadFailed => 'સામગ્રી લોડ થઈ શકી નહીં.';

  @override
  String get materialsEmpty =>
      'આ કામ માટે પાર્ટ્સ જોઈએ તો અહીં ઉમેરો, ગ્રાહકને ખર્ચ મંજૂર કરવા કહેવાશે.';

  @override
  String get materialStatusWaiting => 'ગ્રાહકની રાહ';

  @override
  String get materialStatusApproved => 'મંજૂર';

  @override
  String get materialStatusDeclined => 'નકાર્યું';

  @override
  String get materialStatusBought => 'ખરીદ્યું';

  @override
  String get materialStatusCostRecorded => 'ખર્ચ નોંધાયો';

  @override
  String get materialStatusBilled => 'બિલમાં';

  @override
  String get materialStatusCancelled => 'રદ';

  @override
  String materialQuantityEstimated(Object quantity, Object unit) {
    return '$quantity $unit · અંદાજિત';
  }

  @override
  String materialQuantityActual(Object quantity, Object unit) {
    return '$quantity $unit · વાસ્તવિક';
  }

  @override
  String get materialRecordCost => 'ખર્ચ નોંધો';

  @override
  String materialCustomerSaid(Object reason) {
    return 'ગ્રાહકે કહ્યું: $reason';
  }

  @override
  String get materialUnitPiece => 'નંગ';

  @override
  String get materialWhatNeeded => 'તમારે શું જોઈએ છે?';

  @override
  String get materialEnterQuantity => 'કેટલા જોઈએ તે દાખલ કરો';

  @override
  String get materialEnterCost => 'અંદાજિત ખર્ચ દાખલ કરો';

  @override
  String get materialRequestBody =>
      'તમે ખરીદો તે પહેલાં ગ્રાહકને આ મંજૂર કરવા કહેવાશે.';

  @override
  String get materialName => 'સામગ્રી';

  @override
  String get materialNameHint => 'દા.ત. 16A મોડ્યુલર સ્વિચ';

  @override
  String get materialQuantity => 'જથ્થો';

  @override
  String get materialUnit => 'એકમ';

  @override
  String get materialExpectedCost => 'અંદાજિત ખર્ચ';

  @override
  String get materialAskCustomer => 'ગ્રાહકને પૂછો';

  @override
  String get materialEnterPaid => 'તમે ચૂકવેલી રકમ દાખલ કરો';

  @override
  String get materialCostRecorded => 'ખર્ચ નોંધાયો.';

  @override
  String get materialWhatCost => 'આનો ખર્ચ કેટલો થયો?';

  @override
  String get materialReceiptBody =>
      'રસીદ જોડો જેથી આ ગ્રાહકના બિલમાં ઉમેરી શકાય.';

  @override
  String get materialAmountPaid => 'ચૂકવેલી રકમ';

  @override
  String get materialReceipt => 'રસીદ';

  @override
  String get materialReceiptRequired => 'બિલનો ફોટો જરૂરી છે.';

  @override
  String get evidenceDone => 'પૂર્ણ';

  @override
  String get evidenceRequired => 'જરૂરી';

  @override
  String get evidenceCamera => 'કૅમેરા';

  @override
  String get evidenceGallery => 'ગૅલેરી';

  @override
  String get evidenceSaved => 'સાચવ્યું';

  @override
  String get uploadWaiting => 'રાહ';

  @override
  String get uploadPreparing => 'તૈયાર થઈ રહ્યું છે';

  @override
  String get uploadStarting => 'અપલોડ શરૂ થઈ રહ્યું છે';

  @override
  String uploadPercent(Object percent) {
    return '$percent%';
  }

  @override
  String get uploadFinishing => 'પૂરું થઈ રહ્યું છે';

  @override
  String get uploadCancel => 'અપલોડ રદ કરો';

  @override
  String get uploadNotFinished => 'તે અપલોડ પૂરું થયું નહીં.';

  @override
  String get commonRetry => 'ફરી પ્રયાસ કરો';

  @override
  String durationMinutes(Object minutes) {
    return '$minutes મિનિટ';
  }

  @override
  String durationHours(Object hours) {
    return '$hours કલાક';
  }

  @override
  String durationHoursMinutes(Object hours, Object minutes) {
    return '$hours કલાક $minutes મિનિટ';
  }

  @override
  String durationDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count દિવસ',
      one: '1 દિવસ',
    );
    return '$_temp0';
  }

  @override
  String pricePerHour(Object price) {
    return '$price/કલાક';
  }

  @override
  String pricePerDay(Object price) {
    return '$price/દિવસ';
  }

  @override
  String pricePerUnit(Object price) {
    return '$price/યુનિટ';
  }

  @override
  String pricePerSqft(Object price) {
    return '$price/ચો. ફૂટ';
  }

  @override
  String get gigsTitle => 'મારી સેવાઓ';

  @override
  String get gigsAddTooltip => 'સેવા ઉમેરો';

  @override
  String get gigsAdd => 'સેવા ઉમેરો';

  @override
  String get gigsEmpty => 'હજુ કોઈ સેવા નથી';

  @override
  String get gigsEmptyBody =>
      'તમે આપો છો તે સેવાઓ ઉમેરો. તમને મંજૂર હોય તેવાં બધાં કામમાં જેટલી જોઈએ તેટલી સેવાઓ ઉમેરી શકો છો.';

  @override
  String get gigsNoneLive =>
      'તમારી કોઈ સેવા ચાલુ નથી, તેથી ગ્રાહકો તમને બુક કરી શકતા નથી.';

  @override
  String gigsLiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count સેવાઓ ચાલુ છે.',
      one: '1 સેવા ચાલુ છે.',
    );
    return '$_temp0';
  }

  @override
  String get gigsAvailable => 'તમે કામ માટે ઉપલબ્ધ છો.';

  @override
  String get gigsOffDuty => 'તમે ડ્યૂટી પર નથી, તેથી તમને કામ નહીં મળે.';

  @override
  String gigJobsDone(int count) {
    return '$count પૂર્ણ';
  }

  @override
  String get gigEdit => 'સંપાદિત કરો';

  @override
  String get gigPause => 'થોભાવો';

  @override
  String get gigResume => 'ફરી શરૂ કરો';

  @override
  String get gigInReview => 'સમીક્ષામાં';

  @override
  String get gigDraftHint => 'ડ્રાફ્ટ — સમીક્ષા માટે મોકલો';

  @override
  String get gigRejectedHint => 'નકારાયું — સંપાદિત કરીને ફરી મોકલો';

  @override
  String get gigArchived => 'આર્કાઇવ કરેલું';

  @override
  String get gigNotLive => 'ચાલુ નથી';

  @override
  String get gigPaused => 'થોભાવ્યું. તમને આ કામ નહીં મળે.';

  @override
  String get gigLiveAgain => 'ફરી ચાલુ.';

  @override
  String get gigDuration30m => '30 મિનિટ';

  @override
  String get gigDuration45m => '45 મિનિટ';

  @override
  String get gigDuration1h => '1 કલાક';

  @override
  String get gigDuration2h => '2 કલાક';

  @override
  String get gigDuration4h => '4 કલાક';

  @override
  String get gigDuration8h => '8 કલાક (એક કામકાજનો દિવસ)';

  @override
  String get gigDuration24h => '24 કલાક';

  @override
  String get gigDuration2d => '2 દિવસ';

  @override
  String get gigDuration3d => '3 દિવસ';

  @override
  String get gigDuration1w => '1 અઠવાડિયું';

  @override
  String get gigSavedDraft => 'ડ્રાફ્ટ તરીકે સાચવ્યું.';

  @override
  String get gigSubmitted => 'મોકલ્યું. અમે સમીક્ષા કરીને જણાવીશું.';

  @override
  String get gigLive => 'તમારી સેવા ચાલુ છે.';

  @override
  String get gigSaved => 'સાચવ્યું.';

  @override
  String get gigEditorAddTitle => 'સેવા ઉમેરો';

  @override
  String get gigEditorEditTitle => 'સેવા સંપાદિત કરો';

  @override
  String get gigNoTrades => 'હજુ કોઈ મંજૂર કામ નથી';

  @override
  String get gigNoTradesBody =>
      'કોઈ કામ તમારા માટે મંજૂર થાય પછી તેના હેઠળ સેવાઓ પ્રકાશિત કરી શકો છો. શરૂ કરવા તમારી પ્રોફાઇલમાંથી કામ ઉમેરો.';

  @override
  String get gigFieldTrade => 'કયું કામ?';

  @override
  String get gigFieldTitle => 'આ સેવાનું નામ શું છે?';

  @override
  String get gigFieldTitleHint => 'ગ્રાહકો આ જુએ છે. ચોક્કસ લખો.';

  @override
  String get gigFieldTitleExample => 'દા.ત. સ્પ્લિટ AC ડીપ ક્લીનિંગ';

  @override
  String get gigFieldDescription => 'આમાં શું શું સામેલ છે?';

  @override
  String get gigFieldDescriptionHint =>
      'વૈકલ્પિક, પણ તેનાથી ગ્રાહકોને તમને પસંદ કરવામાં મદદ મળે છે.';

  @override
  String get gigFieldDescriptionExample =>
      'દા.ત. ઇન્ડોર અને આઉટડોર યુનિટની પૂરી સફાઈ, ફિલ્ટર ધોવું, ગૅસ પ્રેશર તપાસ.';

  @override
  String get gigFieldPrice => 'તમે કેટલું લો છો?';

  @override
  String get gigFieldPriceHint =>
      'દરેક સેવાની પોતાની કિંમત હોય છે. તેનાથી તમારી બીજી સેવાઓ પર અસર થતી નથી.';

  @override
  String get gigUnitPerJob => 'પ્રતિ કામ';

  @override
  String get gigUnitPerHour => 'પ્રતિ કલાક';

  @override
  String get gigUnitPerDay => 'પ્રતિ દિવસ';

  @override
  String get gigUnitPerUnit => 'પ્રતિ યુનિટ';

  @override
  String get gigUnitPerSqft => 'પ્રતિ ચો. ફૂટ';

  @override
  String get gigFieldDuration => 'આમાં સામાન્ય રીતે કેટલો સમય લાગે છે?';

  @override
  String get gigFieldRadius => 'આ માટે તમે કેટલું દૂર જશો?';

  @override
  String get gigFieldRadiusHint =>
      'તમારું સામાન્ય મુસાફરી અંતર વાપરવા ડિફૉલ્ટ રહેવા દો.';

  @override
  String get gigUsualDistance => 'તમારું સામાન્ય અંતર';

  @override
  String get gigUseUsualDistance => 'મારું સામાન્ય અંતર વાપરો';

  @override
  String get gigReviewNotice =>
      'નવી અને સંપાદિત સેવાઓ ચાલુ થાય તે પહેલાં અમારી ટીમ તપાસે છે. થઈ જતાં જ અમે જણાવીશું.';

  @override
  String get gigSaveDraft => 'ડ્રાફ્ટ સાચવો';

  @override
  String get gigSubmitForReview => 'સમીક્ષા માટે મોકલો';

  @override
  String get walletAllTransactions => 'બધા વ્યવહારો';

  @override
  String get walletFrozen =>
      'એક બાબતની તપાસ ચાલે છે ત્યાં સુધી ઉપાડ રોકાયા છે. વિગતો માટે સહાયનો સંપર્ક કરો.';

  @override
  String get walletWithdraw => 'ઉપાડો';

  @override
  String walletNothingPending(Object amount) {
    return 'હજુ ઉપાડવા જેવું કંઈ નથી. $amount હજુ પ્રક્રિયામાં છે અને તે કામ મંજૂર થયા પછી તમારા બૅલેન્સમાં આવશે.';
  }

  @override
  String get walletNothingYet =>
      'હજુ ઉપાડવા જેવું કંઈ નથી. ગ્રાહક પૂરું થયેલું કામ મંજૂર કરે પછી તમારી કમાણી અહીં દેખાશે.';

  @override
  String get walletRecentEarnings => 'તાજેતરની કમાણી';

  @override
  String get walletNoEarnings => 'હજુ કોઈ કમાણી નથી';

  @override
  String get walletNoEarningsBody =>
      'પૂરા થયેલા કામની ચુકવણી થાય પછી તમારી કમાણી અહીં દેખાશે.';

  @override
  String get walletAvailable => 'ઉપાડવા માટે ઉપલબ્ધ';

  @override
  String get walletProcessing => 'પ્રક્રિયામાં';

  @override
  String get walletProcessingHint => 'રોકાણ અવધિ પછી મળશે';

  @override
  String get walletTotalEarned => 'કુલ કમાણી';

  @override
  String get statementTitle => 'સ્ટેટમેન્ટ';

  @override
  String get statementTabTransactions => 'વ્યવહારો';

  @override
  String get statementTabWithdrawals => 'ઉપાડ';

  @override
  String get statementEmpty => 'હજુ કંઈ નથી';

  @override
  String get statementEmptyBody =>
      'તમે કામ શરૂ કરો પછી દરેક ચુકવણી, ફી અને ઉપાડ અહીં દેખાશે.';

  @override
  String statementBalance(Object amount) {
    return 'બૅલેન્સ $amount';
  }

  @override
  String get statementNoWithdrawals => 'હજુ કોઈ ઉપાડ નથી';

  @override
  String get statementNoWithdrawalsBody =>
      'તમે પૈસા ઉપાડશો ત્યારે તેનો હિસાબ અહીં રહેશે.';

  @override
  String payoutRequestedAt(Object date) {
    return '$date ના રોજ વિનંતી કરી';
  }

  @override
  String payoutPaidAt(Object date) {
    return '$date ના રોજ ચૂકવ્યું';
  }

  @override
  String get payoutEnterAmount => 'કેટલું ઉપાડવું છે તે દાખલ કરો';

  @override
  String payoutUpTo(Object amount) {
    return 'તમે અત્યારે $amount સુધી ઉપાડી શકો છો';
  }

  @override
  String payoutMinimum(Object amount) {
    return 'સૌથી ઓછો ઉપાડ $amount છે';
  }

  @override
  String payoutRequested(Object amount) {
    return '$amount ઉપાડની વિનંતી કરી. પ્રક્રિયા થતાં અમે જણાવતા રહીશું.';
  }

  @override
  String get payoutAvailableNow => 'અત્યારે ઉપલબ્ધ';

  @override
  String payoutPendingMore(Object amount) {
    return 'બીજા $amount હજુ પ્રક્રિયામાં છે અને હમણાં ઉપાડી શકાશે નહીં.';
  }

  @override
  String get payoutHowMuch => 'કેટલું?';

  @override
  String get payoutAll => 'બધી';

  @override
  String payoutPercent(Object percent) {
    return '$percent%';
  }

  @override
  String get payoutProcessNotice =>
      'ઉપાડ તપાસીને તમારા નોંધાયેલા બૅન્ક ખાતામાં મોકલાય છે. દરેક પગલે સ્થિતિ અહીં દેખાશે.';

  @override
  String get payoutRequest => 'ઉપાડની વિનંતી કરો';

  @override
  String get bankChecking => 'તમારું બૅન્ક ખાતું તપાસી રહ્યા છીએ…';

  @override
  String bankPaidTo(Object last4) {
    return '$last4 થી પૂરા થતા ખાતામાં ચૂકવાશે';
  }

  @override
  String get bankVerifiedFallback => 'તમારું ચકાસેલું બૅન્ક ખાતું';

  @override
  String get bankBeingVerified => 'બૅન્ક ખાતાની ચકાસણી ચાલુ છે';

  @override
  String get bankBeingVerifiedBody => 'અમારી ટીમ ચકાસે પછી તમે ઉપાડી શકશો.';

  @override
  String get bankNotVerified => 'બૅન્ક ખાતું ચકાસાયું નથી';

  @override
  String get bankNotVerifiedBody => 'તમારી વિગતો તપાસો અને ફરી મોકલો.';

  @override
  String get bankAddTitle => 'બૅન્ક ખાતું ઉમેરો';

  @override
  String get bankAddBody =>
      'અમારી ટીમે ચકાસેલા બૅન્ક ખાતામાં જ ઉપાડ ચૂકવાય છે.';

  @override
  String get bankAddAction => 'બૅન્ક ખાતું ઉમેરો';

  @override
  String get verificationTitle => 'ચકાસણી';

  @override
  String get verificationProgress => 'ચકાસેલી તપાસો';

  @override
  String verificationCount(int approved, int total) {
    return '$total માંથી $approved';
  }

  @override
  String get verificationInsurance => 'વીમો';

  @override
  String get verificationNoCover => 'કોઈ ચાલુ વીમો નથી';

  @override
  String get verificationNoCoverBody =>
      'હાલમાં અમારી પાસે તમારી કોઈ વીમા પૉલિસી નોંધાયેલી નથી.';

  @override
  String get verifyIdentity => 'ઓળખ';

  @override
  String get verifyIdentityBody =>
      'સરકારી ઓળખપત્ર, જેથી ગ્રાહકો જાણે કે તેમના ઘરે કોણ આવે છે.';

  @override
  String get verifyAddress => 'સરનામું';

  @override
  String get verifyAddressBody => 'તમે ક્યાં રહો છો તેનો પુરાવો.';

  @override
  String get verifyIti => 'ITI પ્રમાણપત્ર';

  @override
  String get verifyItiBody =>
      'ઔદ્યોગિક તાલીમ સંસ્થા (ITI) તરફથી તમારું ટ્રેડ પ્રમાણપત્ર.';

  @override
  String get verifyDiploma => 'ડિપ્લોમા';

  @override
  String get verifyDiplomaBody => 'માન્ય ટેક્નિકલ ડિપ્લોમા.';

  @override
  String get verifyRpl => 'કૌશલ્ય મૂલ્યાંકન';

  @override
  String get verifyRplBody =>
      'પૂર્વ શિક્ષણની માન્યતા (RPL): તમારા અનુભવનું મૂલ્યાંકન અને પ્રમાણન.';

  @override
  String get verifyBackground => 'પૃષ્ઠભૂમિ તપાસ';

  @override
  String get verifyBackgroundBody =>
      'આ અમે જાતે કરીએ છીએ. તમારે કંઈ કરવાની જરૂર નથી.';

  @override
  String get verifyInsuranceBody =>
      'કામ દરમિયાન અકસ્માતે થતા નુકસાનનો વીમો. વ્યવસ્થા થાય પછી અમારી ટીમ તમારી પૉલિસી ઉમેરે છે.';

  @override
  String get verifyBank => 'બૅન્ક ખાતું';

  @override
  String get verifyBankBody => 'જ્યાં તમારા ઉપાડ ચૂકવાય છે.';

  @override
  String verificationValidUntil(Object date) {
    return '$date સુધી માન્ય';
  }

  @override
  String get verificationStart => 'શરૂ કરો';

  @override
  String get verificationUpdate => 'અપડેટ કરો';

  @override
  String get policyActive => 'ચાલુ';

  @override
  String get policyNotActive => 'ચાલુ નથી';

  @override
  String get policyNumber => 'પૉલિસી';

  @override
  String get policyCover => 'વીમા રકમ';

  @override
  String get policyValidUntil => 'સુધી માન્ય';

  @override
  String get kycStillWaiting =>
      'હજુ DigiLocker ની રાહ છે. તમે પછીથી અહીંથી ફરી જોઈ શકો છો.';

  @override
  String get kycTitle => 'ઓળખ ચકાસણી';

  @override
  String get kycHeadline => 'તમે કોણ છો તેની પુષ્ટિ કરો';

  @override
  String get kycIntro =>
      'ગ્રાહકો તમને તેમના ઘરમાં આવવા દે છે, તેથી અમે દરેક કર્મચારીની ઓળખ ભારત સરકારના દસ્તાવેજ પ્લૅટફૉર્મ DigiLocker દ્વારા ચકાસીએ છીએ. કંઈ અપલોડ થતું નથી — તમે ફક્ત તમારા આધાર ખાતા પર વિનંતી મંજૂર કરો છો.';

  @override
  String get kycPrivacy =>
      'તમારી આધારની વિગતો સીધી DigiLocker સાથે પુષ્ટિ થાય છે. તપાસ થઈ તે સાબિત કરે એટલું જ અમે રાખીએ છીએ — તમારો ફોટો કે આધારની નકલ ક્યારેય નહીં.';

  @override
  String get kycVerified => 'તમારી ઓળખ ચકાસાઈ ગઈ છે.';

  @override
  String get kycAwaitingConsent =>
      'તમારા બ્રાઉઝરમાં DigiLocker ની સંમતિ પૂરી કરો, પછી અહીં પાછા આવો.';

  @override
  String get kycChecking => 'DigiLocker સાથે તપાસી રહ્યા છીએ…';

  @override
  String get kycStart => 'DigiLocker થી ચકાસો';

  @override
  String get qualSubmitted => 'સમીક્ષા માટે મોકલ્યું.';

  @override
  String get qualTitle => 'તમારી લાયકાત';

  @override
  String get qualIti => 'ITI';

  @override
  String get qualInstitute => 'સંસ્થા';

  @override
  String get qualInstituteHint => 'દા.ત. સરકારી ITI, કોઇમ્બતુર';

  @override
  String get qualName => 'લાયકાત';

  @override
  String get qualNameHint => 'દા.ત. ઇલેક્ટ્રિશિયન';

  @override
  String get qualSpeciality => 'વિશેષતા (વૈકલ્પિક)';

  @override
  String get qualSpecialityHint => 'દા.ત. ઔદ્યોગિક વાયરિંગ';

  @override
  String get qualYear => 'પૂર્ણ કર્યાનું વર્ષ';

  @override
  String get qualCertificate => 'તમારું પ્રમાણપત્ર';

  @override
  String get qualCertificateBody => 'પ્રમાણપત્રનો સ્પષ્ટ ફોટો અથવા PDF.';

  @override
  String get bankErrorHolder => 'ખાતામાં હોય તેવું જ નામ દાખલ કરો';

  @override
  String get bankErrorNumber => 'ખાતા નંબર 9 થી 18 અંકનો હોય છે';

  @override
  String get bankErrorMismatch => 'ખાતા નંબર મેળ ખાતા નથી';

  @override
  String get bankErrorIfsc => '11 અક્ષરનો IFSC દાખલ કરો, દા.ત. SBIN0001234';

  @override
  String get bankSent => 'બૅન્ક ખાતું ચકાસણી માટે મોકલ્યું.';

  @override
  String get bankNotice =>
      'તમારા ઉપાડ આ ખાતામાં ચૂકવાય છે. પહેલા પેઆઉટ પહેલાં અમારી ટીમ તેને ચકાસે છે.';

  @override
  String get bankHolder => 'ખાતાધારકનું નામ';

  @override
  String get bankNumber => 'ખાતા નંબર';

  @override
  String get bankConfirmNumber => 'ખાતા નંબર ફરી દાખલ કરો';

  @override
  String get bankIfsc => 'IFSC કોડ';

  @override
  String get bankIfscHint => 'દા.ત. SBIN0001234';

  @override
  String get bankName => 'બૅન્કનું નામ (વૈકલ્પિક)';

  @override
  String get bankSubmit => 'ચકાસણી માટે મોકલો';

  @override
  String get profileCompleteness => 'પ્રોફાઇલ કેટલી પૂર્ણ છે';

  @override
  String get profileCompletenessBody =>
      'પૂર્ણ પ્રોફાઇલથી ગ્રાહકોને તમને પસંદ કરવામાં મદદ મળે છે.';

  @override
  String get profileJobsDone => 'પૂરાં કામ';

  @override
  String get profileRating => 'રેટિંગ';

  @override
  String get profileExperience => 'અનુભવ';

  @override
  String profileExperienceYears(Object years) {
    return '$years વર્ષ';
  }

  @override
  String get profileEdit => 'પ્રોફાઇલ સંપાદિત કરો';

  @override
  String get profileVerified => 'ચકાસેલું';

  @override
  String get profileNotVerified => 'ચકાસાયું નથી';

  @override
  String get profilePinInvalid => 'માન્ય 6 અંકનો પિન કોડ દાખલ કરો';

  @override
  String get profileUpdated => 'પ્રોફાઇલ અપડેટ થઈ.';

  @override
  String get profilePhotoUpdated => 'ફોટો અપડેટ થયો.';

  @override
  String get profileChangePhoto => 'ફોટો બદલો';

  @override
  String get profileName => 'નામ';

  @override
  String get profilePhone => 'ફોન';

  @override
  String get profileLockedNotice =>
      'તમારું નામ અને નંબર ઓળખ ચકાસણી સાથે જોડાયેલાં છે. તેમાંથી કંઈ બદલવું હોય તો સહાયનો સંપર્ક કરો.';

  @override
  String get profileAbout => 'તમારા વિશે';

  @override
  String get profileBioHint =>
      'ગ્રાહકોને તમારા અનુભવ અને તમે શેમાં કુશળ છો તે જણાવો.';

  @override
  String get profileYearsExperience => 'અનુભવનાં વર્ષ';

  @override
  String get profileBased => 'તમે ક્યાં રહો છો';

  @override
  String get profileAddress => 'સરનામું';

  @override
  String get profileCity => 'શહેર';

  @override
  String get profilePin => 'પિન કોડ';

  @override
  String get profileGender => 'જાતિ';

  @override
  String get genderMale => 'પુરુષ';

  @override
  String get genderFemale => 'સ્ત્રી';

  @override
  String get genderOther => 'અન્ય';

  @override
  String get profileTrades => 'તમારાં કામ';

  @override
  String get profileTradesBody =>
      'તમને મંજૂર હોય તેવાં બધાં કામમાં તમે કામ કરી શકો છો.';

  @override
  String get profileTradesLoadFailed => 'તમારાં કામ લોડ થઈ શક્યાં નહીં.';

  @override
  String get tradePending => 'બાકી';

  @override
  String get profileAddTrade => 'કામ ઉમેરો';

  @override
  String get profileAddTradeBody =>
      'મંજૂરી પહેલાં અમે તમારા કૌશલ્યનો પુરાવો માંગી શકીએ.';

  @override
  String get profileTradeRequested => 'વિનંતી કરી. મંજૂર થતાં જ અમે જણાવીશું.';

  @override
  String get profileSave => 'ફેરફારો સાચવો';

  @override
  String get supportNewRequest => 'નવી વિનંતી';

  @override
  String get supportEmpty => 'હજુ કોઈ વિનંતી નથી';

  @override
  String get supportEmptyBody =>
      'કોઈ કામ, ચુકવણી કે તમારા ખાતામાં કંઈ ખોટું થાય, તો વિનંતી કરો અને અમે મદદ કરીશું.';

  @override
  String get supportYourRequests => 'તમારી વિનંતીઓ';

  @override
  String get supportEmergency => 'કટોકટીમાં';

  @override
  String get supportEmergencyBody =>
      'આ એપ તમારા વતી મદદ બોલાવી શકતી નથી. જો તમે જોખમમાં હો, તો સીધા કટોકટી સેવાઓને કૉલ કરો.';

  @override
  String get supportCall112 => '112 પર કૉલ કરો';

  @override
  String get supportPolice => 'પોલીસ';

  @override
  String get ticketOpen => 'ખુલ્લી';

  @override
  String get ticketInProgress => 'ચાલુ છે';

  @override
  String get ticketReplyNeeded => 'તમારો જવાબ જોઈએ';

  @override
  String get ticketResolved => 'ઉકેલાઈ';

  @override
  String get ticketClosed => 'બંધ';

  @override
  String ticketLastUpdate(Object date) {
    return 'છેલ્લું અપડેટ $date';
  }

  @override
  String get supportCategoryJob => 'કોઈ કામ';

  @override
  String get supportCategoryPayment => 'કોઈ ચુકવણી';

  @override
  String get supportCategoryWithdrawal => 'કોઈ ઉપાડ';

  @override
  String get supportCategoryAccount => 'મારું ખાતું';

  @override
  String get supportCategorySafety => 'સલામતી';

  @override
  String get supportCategoryApp => 'એપ';

  @override
  String get supportCategoryOther => 'બીજું કંઈક';

  @override
  String supportRaised(Object code) {
    return 'વિનંતી $code નોંધાઈ.';
  }

  @override
  String get supportHowHelp => 'અમે કેવી રીતે મદદ કરીએ?';

  @override
  String get supportAbout => 'આ શેના વિશે છે?';

  @override
  String get supportSubject => 'વિષય';

  @override
  String get supportSubjectHint => 'સમસ્યા વિશે થોડા શબ્દો';

  @override
  String get supportWhatHappened => 'શું થયું?';

  @override
  String get supportSend => 'વિનંતી મોકલો';

  @override
  String get ticketTitle => 'સહાય વિનંતી';

  @override
  String get ticketNoMessages => 'હજુ કોઈ સંદેશ નથી';

  @override
  String get ticketNoMessagesBody => 'તમારી વાતચીત અહીં દેખાશે.';

  @override
  String get ticketWriteMessage => 'સંદેશ લખો';

  @override
  String get ticketSupportName => 'Wervexa સહાય';

  @override
  String get requestsTitle => 'ગ્રાહકોની વિનંતીઓ';

  @override
  String get requestsRefresh => 'રિફ્રેશ કરો';

  @override
  String get requestsLocationNeeded => 'સ્થાન જરૂરી';

  @override
  String get requestsLocationBody =>
      'તમારી નજીકની ગ્રાહક વિનંતીઓ શોધવા અમે તમારું સ્થાન વાપરીએ છીએ.';

  @override
  String get requestsGrantLocation => 'સ્થાનની પરવાનગી આપો';

  @override
  String get requestsEmpty => 'નજીકમાં કોઈ મેળ ખાતી વિનંતી નથી';

  @override
  String get requestsEmptyBody =>
      'તમારી સેવાઓ સાથે મેળ ખાશે ત્યારે\nનવી ગ્રાહક વિનંતીઓ અહીં દેખાશે.';

  @override
  String get requestsViewOffer => 'જુઓ અને ઑફર આપો →';

  @override
  String get requestEnterPrice => 'માન્ય કિંમત દાખલ કરો';

  @override
  String requestOfferSubmitted(Object price) {
    return '$price પર ઑફર મોકલી!';
  }

  @override
  String get requestDetailsTitle => 'વિનંતીની વિગતો';

  @override
  String get requestStatusOpen => 'ખુલ્લી';

  @override
  String get requestCategory => 'શ્રેણી';

  @override
  String get requestBudget => 'બજેટ';

  @override
  String get requestSchedule => 'સમયપત્રક';

  @override
  String get requestDistance => 'અંતર';

  @override
  String get requestArea => 'વિસ્તાર';

  @override
  String get requestOffers => 'ઑફર';

  @override
  String get requestNotes => 'નોંધ';

  @override
  String get requestAddressPrivacy =>
      'ગ્રાહક તમારી ઑફર સ્વીકારે પછી જ તેમનું ચોક્કસ સરનામું શેર થાય છે.';

  @override
  String get requestYourOffer => 'તમારી ઑફર';

  @override
  String get requestYourPrice => 'તમારી કિંમત (₹)';

  @override
  String get requestPriceHint => 'દા.ત. 500';

  @override
  String get requestDuration => 'અંદાજિત સમય (વૈકલ્પિક)';

  @override
  String get requestDurationHint => 'દા.ત. 1-2 કલાક';

  @override
  String get requestMessage => 'ગ્રાહક માટે સંદેશ (વૈકલ્પિક)';

  @override
  String get requestMessageHint => 'આ કામ માટે તમે જ યોગ્ય વ્યક્તિ કેમ છો?';

  @override
  String get requestSubmitOffer => 'ઑફર મોકલો';

  @override
  String get requestMakeOffer => 'ઑફર આપો';

  @override
  String get requestAlreadyOffered => 'તમે આ વિનંતી પર પહેલેથી ઑફર મોકલી છે.';

  @override
  String get requestViewOffers => 'ઑફર જુઓ';

  @override
  String get offersEmptyBody =>
      'ગ્રાહક વિનંતીઓ પર તમે મોકલેલી ઑફર\nઅહીં દેખાશે.';

  @override
  String get offerWithdraw => 'ઉપાડો';

  @override
  String get offerWithdrawTitle => 'ઑફર પાછી ખેંચીએ?';

  @override
  String get offerWithdrawBody => 'ગ્રાહકને આ ઑફર હવે દેખાશે નહીં.';

  @override
  String get offerWithdrawn => 'ઑફર પાછી ખેંચી';

  @override
  String get onboardingTitle => 'તમારી પ્રોફાઇલ સેટ કરો';

  @override
  String get onboardingHelp => 'મદદ';

  @override
  String onboardingHello(Object name) {
    return 'નમસ્તે, $name';
  }

  @override
  String get onboardingIntro => 'થોડી બાબતો અને તમે કામ મેળવવા તૈયાર છો.';

  @override
  String get onboardingSetup => 'સેટઅપ';

  @override
  String onboardingStepCount(int done, int total) {
    return '$total માંથી $done';
  }

  @override
  String get onboardingBasicBody =>
      'તમારું શહેર અને પિન કોડ, જેથી અમે તમારી નજીક કામ શોધી શકીએ.';

  @override
  String get onboardingTradeBody => 'તમે મુખ્યત્વે જે કામ કરો છો.';

  @override
  String get onboardingSkillsDoneBody =>
      'તમારું મુખ્ય કામ એક તરીકે ગણાય છે. તમે કરો છો તે બાકીનાં બધાં કામ ઉમેરવા આ ખોલો.';

  @override
  String get onboardingSkillsBody =>
      'તમે કરો છો તે બધાં કામ ઉમેરો. તમે એક જ કામ સુધી મર્યાદિત નથી.';

  @override
  String get onboardingAreaBody => 'કોઈ કામ માટે તમે કેટલું દૂર જવા તૈયાર છો.';

  @override
  String get onboardingKycBody =>
      'સરકારી ઓળખપત્ર. ગ્રાહકો તમને તેમના ઘરમાં આવવા દે છે.';

  @override
  String get onboardingReviewNotice =>
      'આ પૂરાં થયા પછી અમારી ટીમ તમારા દસ્તાવેજો તપાસે છે. રાહ જોતી વખતે તમે તમારી સેવાઓ સેટ કરવાનું ચાલુ રાખી શકો છો.';

  @override
  String get onboardingTradesLoadFailed =>
      'કામ લોડ થઈ શક્યાં નહીં. ફરી પ્રયાસ કરો.';

  @override
  String get onboardingMainTrade => 'તમારું મુખ્ય કામ કયું છે?';

  @override
  String get onboardingMainTradeBody => 'તમે પછીથી વધુ કામ ઉમેરી શકો છો.';

  @override
  String onboardingTradeSet(Object trade) {
    return '$trade તમારા મુખ્ય કામ તરીકે સેટ થયું.';
  }

  @override
  String get onboardingTravelTitle => 'તમે કેટલું દૂર જશો?';

  @override
  String get onboardingTravelBody =>
      'તમે અત્યારે જ્યાં છો ત્યાંથી આટલા અંતરની અંદરનાં જ કામ અમે આપીશું.';

  @override
  String get onboardingTravelCentre =>
      'અમે તમારા હાલના સ્થાનને કેન્દ્રબિંદુ તરીકે વાપરીએ છીએ. તમે પ્રોફાઇલમાંથી ગમે ત્યારે બદલી શકો છો.';

  @override
  String get onboardingLocationOff =>
      'કામનો વિસ્તાર સેટ કરવા સ્થાનની પરવાનગી ચાલુ કરો.';

  @override
  String get commonSave => 'સાચવો';

  @override
  String get notificationsStayOff =>
      'સૂચનાઓ બંધ રહેશે. તમે તેને ફોનની સેટિંગ્સમાં ચાલુ કરી શકો છો.';

  @override
  String get notificationsPrimerTitle => 'કામ આવે ત્યારે જાણ મેળવો';

  @override
  String get notificationsPrimerBody =>
      'કામની ઑફરની મુદત પૂરી થાય છે. એપ બંધ હોય ત્યારે સૂચનાથી જ તમને ખબર પડે છે — બીજું કંઈ મોકલાતું નથી.';

  @override
  String get notificationsTurnOn => 'સૂચનાઓ ચાલુ કરો';

  @override
  String get commonNotNow => 'હમણાં નહીં';

  @override
  String get onboardingCityRequired => 'કૃપા કરીને તમારું શહેર દાખલ કરો';

  @override
  String get onboardingGenderRequired => 'કૃપા કરીને તમારી જાતિ પસંદ કરો';

  @override
  String get onboardingWhereBased => 'તમે ક્યાં રહો છો?';
}
