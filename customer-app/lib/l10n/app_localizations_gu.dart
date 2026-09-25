// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Gujarati (`gu`).
class AppLocalizationsGu extends AppLocalizations {
  AppLocalizationsGu([String locale = 'gu']) : super(locale);

  @override
  String get commonRetry => 'ફરી પ્રયાસ કરો';

  @override
  String get commonTryAgain => 'ફરી પ્રયાસ કરો';

  @override
  String get commonSignOut => 'સાઇન આઉટ કરો';

  @override
  String get assistantFabLabel => 'AI ને પૂછો';

  @override
  String get navHome => 'હોમ';

  @override
  String get navExplore => 'શોધો';

  @override
  String get navBookings => 'બુકિંગ';

  @override
  String get navAlerts => 'સૂચનાઓ';

  @override
  String get navProfile => 'પ્રોફાઇલ';

  @override
  String get configErrorTitle => 'એપ કૉન્ફિગર કરેલી નથી';

  @override
  String configErrorBody(String keys, String command) {
    return 'આ બિલ્ડમાં $keys નથી. આ રીતે ચલાવો:\n\n$command\n\nજેથી એપ વાસ્તવિક બૅકએન્ડ સુધી પહોંચી શકે.';
  }

  @override
  String get sessionProfileLoadFailedRetry =>
      'અમે તમારી પ્રોફાઇલ લોડ કરી શક્યા નહીં. કૃપા કરીને ફરી પ્રયાસ કરો.';

  @override
  String get sessionProfileLoadFailed =>
      'અમે તમારી પ્રોફાઇલ લોડ કરી શક્યા નહીં';

  @override
  String get sessionCheckClock => 'તમારા ફોનની ઘડિયાળ તપાસો';

  @override
  String get splashTagline => 'ઘરની સેવાઓ, યોગ્ય રીતે.';

  @override
  String get timelineBookingConfirmed => 'બુકિંગની પુષ્ટિ થઈ';

  @override
  String get timelineProviderOnTheWay => 'સેવા આપનાર રસ્તામાં છે';

  @override
  String get timelineServiceInProgress => 'સેવા ચાલુ છે';

  @override
  String get timelineCompleted => 'પૂર્ણ થયું';

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
  String get errorSessionEnded =>
      'તમારું સત્ર સમાપ્ત થયું છે. કૃપા કરીને ફરી સાઇન ઇન કરો.';

  @override
  String get errorUploadFailed => 'તે ફાઇલ અપલોડ થઈ શકી નહીં. ફરી પ્રયાસ કરો.';

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
  String get authErrorPhoneNotEnabled =>
      'ફોન સાઇન-ઇન ચાલુ નથી. સહાયનો સંપર્ક કરો.';

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
  String get languagePickerTitle => 'તમારી ભાષા પસંદ કરો';

  @override
  String get authCouldNotStartVerification =>
      'ચકાસણી શરૂ થઈ શકી નહીં. કૃપા કરીને ફરી પ્રયાસ કરો.';

  @override
  String get authWelcomeTitle => 'Wervexa માં આપનું સ્વાગત છે';

  @override
  String get authWelcomeSubtitle =>
      'ઘર સમારકામ, પ્લમ્બિંગ, ઇલેક્ટ્રિકલ, સફાઈ અને વધુ માટે નજીકના શ્રેષ્ઠ વ્યાવસાયિકો શોધો.';

  @override
  String get authEnterPhone => 'તમારો ફોન નંબર દાખલ કરો';

  @override
  String get authInvalidMobile => 'માન્ય 10 અંકનો મોબાઇલ નંબર દાખલ કરો';

  @override
  String get authGetOtp => 'OTP ચકાસણી મેળવો';

  @override
  String get authTermsNotice =>
      'આગળ વધીને, તમે અમારી સેવાની શરતો અને ગોપનીયતા નીતિ સાથે સંમત થાઓ છો';

  @override
  String get authNewCodeSent => 'અમે નવો કોડ મોકલ્યો છે.';

  @override
  String get authVerifyPhoneTitle => 'ફોન ચકાસો';

  @override
  String get authChangeNumber => 'નંબર બદલો';

  @override
  String get authEnterCodeTitle => '6 અંકનો કોડ દાખલ કરો';

  @override
  String authCodeSentTo(Object phone) {
    return 'અમે $phone પર SMS ચકાસણી કોડ મોકલ્યો છે';
  }

  @override
  String get authWrongNumber => 'ખોટો નંબર? બદલો';

  @override
  String get authEnterSixDigits => 'કૃપા કરીને 6 અંક દાખલ કરો';

  @override
  String get authResendCode => 'કોડ ફરી મોકલો';

  @override
  String authResendCodeIn(Object seconds) {
    return '$seconds સેકન્ડમાં કોડ ફરી મોકલો';
  }

  @override
  String get authVerifyAndContinue => 'ચકાસો અને આગળ વધો';

  @override
  String get registerTitle => 'પ્રોફાઇલ પૂર્ણ કરો';

  @override
  String get registerHeading => 'અમને તમારું નામ જણાવો';

  @override
  String get registerNameVisibility =>
      'જ્યારે તમે બુકિંગની વિનંતી કરશો ત્યારે તમારું નામ સેવા કર્મચારીઓને દેખાશે.';

  @override
  String get registerFullNameLabel => 'પૂરું નામ *';

  @override
  String get registerFullNameHint => 'દા.ત. રાહુલ શર્મા';

  @override
  String get registerFullNameRequired => 'કૃપા કરીને તમારું પૂરું નામ દાખલ કરો';

  @override
  String get registerEmailLabel => 'ઇમેઇલ સરનામું (વૈકલ્પિક)';

  @override
  String get registerEmailHint => 'દા.ત. rahul@example.com';

  @override
  String get registerSubmit => 'સાચવો અને શરૂ કરો';

  @override
  String get bookingStatusRequested => 'વ્યાવસાયિક શોધી રહ્યા છીએ…';

  @override
  String get bookingStatusAccepted => 'વ્યાવસાયિક મળી ગયા';

  @override
  String get bookingStatusConfirmed => 'પુષ્ટિ થઈ';

  @override
  String get bookingStatusTraveling => 'રસ્તામાં';

  @override
  String get bookingStatusArrived => 'પહોંચી ગયા — તમારો કોડ દાખલ કરો';

  @override
  String get bookingStatusInProgress => 'કામ ચાલુ છે';

  @override
  String get bookingStatusAwaitingApproval => 'કામ પૂરું — આગળ વધવા મંજૂરી આપો';

  @override
  String get bookingStatusCompleted => 'પૂર્ણ થયું';

  @override
  String get bookingStatusPaymentPending => 'ચુકવણી બાકી';

  @override
  String get bookingStatusPaid => 'ચૂકવાયું';

  @override
  String get bookingStatusClosed => 'બંધ';

  @override
  String get bookingStatusCancelled => 'રદ';

  @override
  String get bookingStatusDisputed => 'વિવાદમાં';

  @override
  String get bookingStatusExpired => 'મુદત પૂરી — કોઈ ઉપલબ્ધ નહોતું';

  @override
  String get pricingPerJob => 'પ્રતિ કામ';

  @override
  String get pricingPerHour => 'પ્રતિ કલાક';

  @override
  String get pricingPerDay => 'પ્રતિ દિવસ';

  @override
  String get pricingPerUnit => 'પ્રતિ યુનિટ';

  @override
  String get pricingPerSqft => 'પ્રતિ ચો. ફૂટ';

  @override
  String get supportCategoryBooking => 'બુકિંગની સમસ્યા';

  @override
  String get supportCategoryPayment => 'ચુકવણી';

  @override
  String get supportCategoryPayout => 'પેઆઉટ';

  @override
  String get supportCategoryVerification => 'ચકાસણી';

  @override
  String get supportCategoryAccount => 'મારું ખાતું';

  @override
  String get supportCategorySafety => 'સલામતીની ચિંતા';

  @override
  String get supportCategoryClaim => 'વીમા દાવો';

  @override
  String get supportCategoryAppIssue => 'એપની સમસ્યા';

  @override
  String get supportCategoryOther => 'અન્ય';

  @override
  String get requestStatusDraft => 'ડ્રાફ્ટ';

  @override
  String get requestStatusOpen => 'ખુલ્લું — ઑફરની રાહ';

  @override
  String get requestStatusReceivingOffers => 'ઑફર આવી રહી છે';

  @override
  String get requestStatusWorkerSelected => 'વ્યાવસાયિક પસંદ થયા';

  @override
  String get requestStatusBooked => 'બુક થયું';

  @override
  String get requestStatusCancelled => 'રદ';

  @override
  String get requestStatusExpired => 'મુદત પૂરી';

  @override
  String get requestStatusClosed => 'બંધ';

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
  String get scheduleSpecificDate => 'ચોક્કસ તારીખે';

  @override
  String get scheduleScheduled => 'નિર્ધારિત';

  @override
  String get offerStatusSubmitted => 'નવી ઑફર';

  @override
  String get offerStatusViewed => 'જોવાઈ';

  @override
  String get offerStatusShortlisted => 'શૉર્ટલિસ્ટ કરી';

  @override
  String get offerStatusAccepted => 'સ્વીકારી';

  @override
  String get offerStatusRejected => 'નકારી';

  @override
  String get offerStatusWithdrawn => 'કર્મચારીએ પાછી ખેંચી';

  @override
  String get offerStatusExpired => 'મુદત પૂરી';

  @override
  String get offerStatusClosed => 'બંધ';

  @override
  String get gigRatingNew => 'નવું';

  @override
  String distanceMetres(Object metres) {
    return '$metres મી';
  }

  @override
  String distanceKm(Object km) {
    return '$km કિમી';
  }

  @override
  String durationMinutes(Object minutes) {
    return '$minutes મિનિટ';
  }

  @override
  String durationHours(Object hours) {
    return '$hours કલાક';
  }

  @override
  String durationHoursMinutes(int hours, int minutes) {
    return '$hours કલાક $minutes મિનિટ';
  }

  @override
  String get offerWorkerFallbackName => 'વ્યાવસાયિક';

  @override
  String get budgetFlexible => 'લવચીક બજેટ';

  @override
  String get budgetFixed => 'નિશ્ચિત બજેટ';

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
  String get paymentsNotConfigured =>
      'આ બિલ્ડ માટે ચુકવણી હજુ કૉન્ફિગર કરેલી નથી.';

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
  String get addressLabelHome => 'હોમ';

  @override
  String get addressLabelWork => 'ઑફિસ';

  @override
  String get addressLabelOther => 'અન્ય';

  @override
  String get commonSeeAll => 'બધું જુઓ';

  @override
  String get commonViewAll => 'બધું જુઓ';

  @override
  String get commonCheckBackLater => 'કૃપા કરીને પછીથી ફરી જુઓ.';

  @override
  String get commonUseCurrentLocation => 'હાલનું સ્થાન વાપરો';

  @override
  String get commonChooseOnMap => 'નકશા પર પસંદ કરો';

  @override
  String homeGreetingNamed(Object name) {
    return 'નમસ્તે, $name 👋';
  }

  @override
  String get homeGreeting => 'નમસ્તે 👋';

  @override
  String get homeWhatService => 'આજે તમારે કઈ સેવા જોઈએ છે?';

  @override
  String get homeSetLocation => 'તમારું સ્થાન સેટ કરો';

  @override
  String get homeWorkFinishedApprove => 'કામ પૂરું — મંજૂરી આપવા ટૅપ કરો';

  @override
  String get homeCategories => 'શ્રેણીઓ';

  @override
  String homeCategoriesLoadFailed(Object error) {
    return 'શ્રેણીઓ લોડ થઈ શકી નહીં: $error';
  }

  @override
  String get homeFindWorker => 'કર્મચારી શોધો';

  @override
  String get homeFindWorkerSubtitle => 'નજીકની સેવાઓ જુઓ';

  @override
  String get homePostRequest => 'વિનંતી પોસ્ટ કરો';

  @override
  String get homePostRequestSubtitle => 'કર્મચારીઓ તમારી પાસે આવે છે';

  @override
  String get homeNoServices => 'અત્યારે કોઈ સેવા ઉપલબ્ધ નથી';

  @override
  String get homeSearchNear => 'નજીક સેવાઓ શોધો';

  @override
  String get homeSearchHint => 'સેવાઓ શોધો...';

  @override
  String homeActiveBooking(Object code) {
    return 'ચાલુ બુકિંગ #$code';
  }

  @override
  String get homeActiveRequests => 'તમારી ચાલુ વિનંતીઓ';

  @override
  String get commonGrantPermission => 'પરવાનગી આપો';

  @override
  String get commonView => 'જુઓ';

  @override
  String get exploreTitle => 'સેવાઓ શોધો અને જાણો';

  @override
  String get exploreListView => 'સૂચિ દૃશ્ય';

  @override
  String get exploreMapView => 'નકશા દૃશ્ય';

  @override
  String get exploreSearchHint => 'સેવાઓ, કર્મચારીઓ કે કૌશલ્ય શોધો...';

  @override
  String get exploreLocationOffTitle => 'સ્થાન સેવાઓ બંધ છે';

  @override
  String get exploreLocationOffMessage =>
      'નજીકના વ્યાવસાયિકો શોધવા માટે સ્થાન ચાલુ કરો.';

  @override
  String get exploreLocationPermissionTitle => 'સ્થાનની પરવાનગી જરૂરી';

  @override
  String get exploreLocationPermissionMessage =>
      'નજીકના વ્યાવસાયિકો શોધવા અમે તમારું સ્થાન વાપરીએ છીએ.';

  @override
  String get exploreChooseService => 'શોધવા માટે સેવા પસંદ કરો';

  @override
  String get exploreChooseServiceMessage =>
      'નજીકના વ્યાવસાયિકો જોવા ઉપર એક શ્રેણી પસંદ કરો.';

  @override
  String get exploreNoProfessionals =>
      'આ સેવા માટે નજીકમાં કોઈ વ્યાવસાયિક ઉપલબ્ધ નથી';

  @override
  String get exploreLoadFailed => 'વ્યાવસાયિકો લોડ થઈ શક્યા નહીં.';

  @override
  String exploreByWorker(Object name) {
    return '$name દ્વારા';
  }

  @override
  String get bookingsTitle => 'મારી સેવા બુકિંગ';

  @override
  String get bookingsTabActive => 'ચાલુ';

  @override
  String get bookingsTabCompleted => 'પૂર્ણ થયું';

  @override
  String get bookingsTabCancelled => 'રદ';

  @override
  String get bookingsLoadFailed => 'તમારી બુકિંગ લોડ થઈ શકી નહીં.';

  @override
  String get bookingsEmpty => 'હજુ કોઈ બુકિંગ નથી';

  @override
  String get bookingsFindService => 'સેવા શોધો';

  @override
  String get bookingsWaitingForProfessional => 'વ્યાવસાયિકની રાહ';

  @override
  String bookingsCode(Object code) {
    return 'બુકિંગ કોડ: #$code';
  }

  @override
  String get bookingsPayNow => 'હમણાં ચૂકવો';

  @override
  String get bookingsApproveWork => 'કામને મંજૂરી આપો';

  @override
  String get bookingsTrackLive => 'લાઇવ ટ્રૅક કરો';

  @override
  String get bookingsDetails => 'વિગતો';

  @override
  String get bookingDetailTitle => 'બુકિંગની વિગતો';

  @override
  String get bookingDetailLoadFailed => 'બુકિંગની વિગતો લોડ થઈ શકી નહીં.';

  @override
  String get bookingDetailWaitingAccept => 'વ્યાવસાયિક સ્વીકારે તેની રાહ';

  @override
  String bookingDetailNumber(Object code) {
    return 'બુકિંગ #$code';
  }

  @override
  String bookingDetailStatus(Object status) {
    return 'સ્થિતિ: $status';
  }

  @override
  String get bookingDetailLiveMap => 'લાઇવ નકશો';

  @override
  String get bookingDetailServiceInfo => 'સેવા વિનંતીની માહિતી';

  @override
  String get bookingDetailViewMaterials => 'સામગ્રી / પાર્ટ્સની વિનંતીઓ જુઓ';

  @override
  String get bookingDetailFareDetails => 'ભાડાની વિગતો';

  @override
  String get bookingDetailEstimatedFare => 'અંદાજિત ભાડું';

  @override
  String get bookingDetailFinalFare => 'અંતિમ પુષ્ટિ થયેલું ભાડું';

  @override
  String get bookingDetailRateReview =>
      'સેવા કર્મચારીને રેટિંગ અને સમીક્ષા આપો';

  @override
  String get bookingDetailApproveCompletion => 'કામ પૂરું થયાની મંજૂરી આપો';

  @override
  String get bookingDetailApprovePaidHint =>
      'તમારા વ્યાવસાયિકે આ કામ પૂરું થયું તરીકે ચિહ્નિત કર્યું છે. મંજૂરી આપવાથી તમારી ચુકવણી તેમને મળી જશે.';

  @override
  String get bookingDetailApproveUnpaidHint =>
      'તમારા વ્યાવસાયિકે આ કામ પૂરું થયું તરીકે ચિહ્નિત કર્યું છે. પુષ્ટિ કરીને ચુકવણી પર જવા મંજૂરી આપો.';

  @override
  String get bookingDetailReportProblem => 'સમસ્યાની જાણ કરો';

  @override
  String get bookingDetailCompletionApproved => 'કામ પૂરું થયાની મંજૂરી મળી';

  @override
  String bookingDetailPayToConfirm(Object amount) {
    return 'પુષ્ટિ માટે $amount ચૂકવો';
  }

  @override
  String get bookingDetailSentAfterPayment =>
      'ચુકવણી પૂરી થયા પછી તમારું બુકિંગ વ્યાવસાયિકને મોકલવામાં આવશે.';

  @override
  String bookingDetailPayAmount(Object amount) {
    return '$amount ચૂકવો';
  }

  @override
  String get bookingDetailCancelBooking => 'બુકિંગ રદ કરો';

  @override
  String get cancelReasonMistake => 'ભૂલથી બુક થયું';

  @override
  String get cancelReasonNoLongerNeeded => 'મને હવે આ સેવાની જરૂર નથી';

  @override
  String get cancelReasonDifferentTime => 'મારે અલગ સમય પસંદ કરવો છે';

  @override
  String get cancelReasonFoundSomeoneElse => 'મને બીજું કોઈ મળી ગયું';

  @override
  String get cancelDialogTitle => 'તમે કેમ રદ કરી રહ્યા છો?';

  @override
  String get cancelDialogRefundNotice =>
      'આ પાછું ફેરવી શકાશે નહીં. તમારી ચુકવણી મૂળ ચુકવણી પદ્ધતિમાં પરત કરવામાં આવશે.';

  @override
  String get cancelDialogCannotUndo => 'આ પાછું ફેરવી શકાશે નહીં.';

  @override
  String get cancelDialogKeepBooking => 'બુકિંગ રાખો';

  @override
  String get bookingCancelledRefund =>
      'બુકિંગ રદ થયું. તમારા રિફંડની વિનંતી કરવામાં આવી છે.';

  @override
  String get bookingCancelled => 'બુકિંગ રદ થયું';

  @override
  String get arrivalCodeTitle => 'આગમન કોડ';

  @override
  String get arrivalCodeShare =>
      'વ્યાવસાયિક પહોંચી ગયા છે તેની પુષ્ટિ માટે આ કોડ તેમને આપો:';

  @override
  String get arrivalCodeUnavailable => 'ઉપલબ્ધ નથી';

  @override
  String get arrivalCodeLoadFailed => 'કોડ લોડ થઈ શક્યો નહીં';

  @override
  String get activeBookingTitle => 'લાઇવ બુકિંગ અને કર્મચારી ટ્રૅકિંગ';

  @override
  String get activeBookingLoadFailed => 'આ બુકિંગ લોડ થઈ શક્યું નહીં.';

  @override
  String get activeBookingMapUnavailable =>
      'આ બુકિંગ માટે લાઇવ નકશો ઉપલબ્ધ નથી.';

  @override
  String get activeBookingViewDetails => 'બુકિંગની વિગતો જુઓ';

  @override
  String get activeBookingServiceLocation => 'સેવાનું સ્થાન';

  @override
  String get activeBookingYourProfessional => 'તમારા વ્યાવસાયિક';

  @override
  String get activeBookingLive => 'લાઇવ';

  @override
  String get activeBookingLastKnown => 'છેલ્લું જાણીતું સ્થાન';

  @override
  String get activeBookingPhoneNotShared => 'ફોન હજુ શેર કર્યો નથી';

  @override
  String get activeBookingCallProfessional => 'વ્યાવસાયિકને કૉલ કરો';

  @override
  String get activeBookingMaterials => 'સામગ્રી';

  @override
  String get activeBookingViewDetailsShort => 'વિગતો જુઓ';

  @override
  String get locationConnecting => 'લાઇવ સ્થાન સાથે જોડાઈ રહ્યા છીએ...';

  @override
  String get locationLiveUnavailable => 'લાઇવ સ્થાન હાલ ઉપલબ્ધ નથી';

  @override
  String get locationLiveActive => 'લાઇવ સ્થાન ચાલુ છે';

  @override
  String get locationUpdating => 'અપડેટ થઈ રહ્યું છે...';

  @override
  String get locationUnavailable => 'સ્થાન હાલ ઉપલબ્ધ નથી';

  @override
  String get activeBookingShareStartCode =>
      'કર્મચારી પહોંચી ગયા! શરૂઆતનો કોડ આપો:';

  @override
  String get commonBack => 'પાછા';

  @override
  String get paymentCouldNotOpen =>
      'ચુકવણી સ્ક્રીન ખૂલી શકી નહીં. કૃપા કરીને ફરી પ્રયાસ કરો.';

  @override
  String get paymentReceived =>
      'ચુકવણી મળી. તમારું બુકિંગ વ્યાવસાયિકને મોકલવામાં આવ્યું છે.';

  @override
  String paymentNotConfirmed(String reason, String reference) {
    return 'અમે આ ચુકવણીની પુષ્ટિ કરી શક્યા નહીં: $reason. જો પૈસા કપાયા હોય, તો $reference સંદર્ભ સાથે સહાયનો સંપર્ક કરો.';
  }

  @override
  String get paymentNotCompleted => 'ચુકવણી પૂર્ણ થઈ નહીં.';

  @override
  String paymentExternalWalletUnsupported(Object wallet) {
    return 'બાહ્ય વૉલેટ ($wallet) પસંદ કર્યું — તે હજુ સપોર્ટેડ નથી.';
  }

  @override
  String get paymentTitle => 'ચુકવણી';

  @override
  String get paymentStatusUnknown =>
      'આ બુકિંગની ચુકવણી પહેલેથી થઈ છે કે નહીં તે અમે ચકાસી શક્યા નહીં. બે વાર ચૂકવવાને બદલે કૃપા કરીને ફરી પ્રયાસ કરો.';

  @override
  String get paymentBookingLoadFailed => 'આ બુકિંગ લોડ થઈ શક્યું નહીં.';

  @override
  String get paymentComplete => 'ચુકવણી પૂર્ણ';

  @override
  String paymentPaidFor(String amount, String service) {
    return '$service માટે $amount ચૂકવ્યા.';
  }

  @override
  String get paymentViewBooking => 'બુકિંગ જુઓ';

  @override
  String get paymentBookingSummary => 'બુકિંગ સારાંશ';

  @override
  String get paymentProvider => 'સેવા આપનાર';

  @override
  String get paymentService => 'સેવા';

  @override
  String get paymentDate => 'તારીખ';

  @override
  String get paymentTime => 'સમય';

  @override
  String get paymentAddress => 'સરનામું';

  @override
  String get paymentTotal => 'કુલ';

  @override
  String get paymentHeldSecurely =>
      'તમારી ચુકવણી સુરક્ષિત રાખવામાં આવે છે અને તમે કામને મંજૂરી આપો પછી જ વ્યાવસાયિકને મળે છે. કામ શરૂ થાય તે પહેલાં બુકિંગ રદ થાય, તો તમને રિફંડ મળે છે.';

  @override
  String get commonChange => 'બદલો';

  @override
  String get bookMissingDetails =>
      'બુકિંગની વિગતો ખૂટે છે — કૃપા કરીને ફરી શરૂ કરો.';

  @override
  String get bookSlotPassed =>
      'તે સમય વીતી ગયો છે. અમે તમને આગલા ઉપલબ્ધ સ્લૉટ પર ખસેડ્યા છે — તપાસો અને ફરી પુષ્ટિ કરો.';

  @override
  String bookFailed(Object reason) {
    return 'બુકિંગ નિષ્ફળ: $reason';
  }

  @override
  String get bookNoAddress => 'કોઈ સરનામું પસંદ કર્યું નથી';

  @override
  String get bookTitle => 'સેવા બુક કરો';

  @override
  String get bookSelectDate => 'તારીખ પસંદ કરો';

  @override
  String get bookSelectTime => 'સમય પસંદ કરો';

  @override
  String get bookSpecialInstructions => 'ખાસ સૂચનાઓ (વૈકલ્પિક)';

  @override
  String get bookSpecialInstructionsHint =>
      'દા.ત. રસોડા અને બાથરૂમ પર ધ્યાન આપો...';

  @override
  String get bookConfirm => 'બુકિંગની પુષ્ટિ કરો →';

  @override
  String get gigUnknownProfessional => 'અજાણ્યા વ્યાવસાયિક';

  @override
  String get gigNewProfessional => 'નવા વ્યાવસાયિક';

  @override
  String gigRatingWithCount(String rating, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count સમીક્ષાઓ',
      one: '1 સમીક્ષા',
    );
    return '$rating ($_temp0)';
  }

  @override
  String get gigPricing => 'કિંમત';

  @override
  String get gigServiceRate => 'સેવા દર';

  @override
  String get gigFinalAmountNote =>
      'અંતિમ રકમ તમારા વ્યાવસાયિક નક્કી કરે છે અને બુકિંગ બન્યા પછી તેમાં દર્શાવાય છે.';

  @override
  String get gigKycVerified => 'KYC ચકાસેલું';

  @override
  String get gigBackgroundVerified => 'પૃષ્ઠભૂમિ ચકાસેલી';

  @override
  String get gigBookNow => 'હમણાં બુક કરો →';

  @override
  String get discoveryTitle => 'ઉપલબ્ધ વ્યાવસાયિકો';

  @override
  String get discoveryMissingDetails => 'સેવા કે સ્થાનની વિગતો ખૂટે છે.';

  @override
  String get discoveryLocalExperts => 'ઉપલબ્ધ સ્થાનિક નિષ્ણાતો';

  @override
  String get discoveryWithin => 'અંતરની અંદર';

  @override
  String get discoveryNoProviders => 'નજીકમાં કોઈ સેવા આપનાર ઉપલબ્ધ નથી';

  @override
  String get discoveryTryLargerRadius =>
      'મોટું શોધ અંતર અજમાવો અથવા પછીથી ફરી જુઓ.';

  @override
  String get discoveryLoadFailed => 'નજીકના સેવા આપનારા લોડ થઈ શક્યા નહીં.';

  @override
  String discoveryServicesForJob(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'આ કામ માટે $count સેવાઓ',
      one: 'આ કામ માટે 1 સેવા',
    );
    return '$_temp0';
  }

  @override
  String get discoveryBook => 'બુક કરો';

  @override
  String get categoryServiceDetails => 'સેવાની વિગતો';

  @override
  String get categoryTagline =>
      'અગાઉથી નક્કી કિંમત અને સેવાની ગૅરંટી સાથે ચકાસેલા, પૃષ્ઠભૂમિ તપાસેલા સ્થાનિક નિષ્ણાતો બુક કરો.';

  @override
  String get categoryWhatHelp => 'તમારે શેમાં મદદ જોઈએ છે?';

  @override
  String get categoryDescribeElse => 'કંઈક બીજું વર્ણવો';

  @override
  String get categoryLoadFailed => 'આ સેવા લોડ થઈ શકી નહીં.';

  @override
  String get notificationsTitle => 'સૂચનાઓ અને ચેતવણીઓ';

  @override
  String get notificationsEmpty => 'તમે બધું જોઈ લીધું છે';

  @override
  String get notificationsLoadFailed => 'સૂચનાઓ લોડ થઈ શકી નહીં.';

  @override
  String get timeJustNow => 'હમણાં જ';

  @override
  String timeMinutesAgo(Object minutes) {
    return '$minutes મિનિટ પહેલાં';
  }

  @override
  String timeHoursAgo(Object hours) {
    return '$hours કલાક પહેલાં';
  }

  @override
  String get timeYesterday => 'ગઈકાલે';

  @override
  String get completedTitle => 'સેવા પૂર્ણ થઈ!';

  @override
  String get completedThanks => 'અમારી સેવાઓનો ઉપયોગ કરવા બદલ આભાર.';

  @override
  String get completedViewBookings => 'બુકિંગ જુઓ';

  @override
  String get completedBackHome => 'હોમ પર પાછા જાઓ';

  @override
  String commonErrorDetail(Object detail) {
    return 'ભૂલ: $detail';
  }

  @override
  String get reviewTitle => 'તમારા અનુભવને રેટિંગ આપો';

  @override
  String get reviewHeading => 'શાનદાર સેવા!';

  @override
  String get reviewQuestion => 'તમારા વ્યાવસાયિક સાથેનો અનુભવ કેવો રહ્યો?';

  @override
  String reviewStars(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count સ્ટાર',
      one: '1 સ્ટાર',
    );
    return '$_temp0';
  }

  @override
  String get reviewCommentHint => 'તમારા અનુભવ વિશે જણાવો...';

  @override
  String get reviewSubmit => 'સમીક્ષા મોકલો →';

  @override
  String get materialsTitle => 'સામગ્રી / પાર્ટ્સની વિનંતીઓ';

  @override
  String get materialsEmpty => 'આ બુકિંગ માટે સામગ્રીની કોઈ વિનંતી આવી નથી';

  @override
  String materialsQuantityEstimated(Object quantity) {
    return '$quantity · અંદાજિત';
  }

  @override
  String materialsQuantityActual(Object quantity) {
    return '$quantity · વાસ્તવિક';
  }

  @override
  String get materialsReject => 'નકારો';

  @override
  String get materialsApprove => 'મંજૂર કરો';

  @override
  String get materialStatusRequested => 'વિનંતી કરી';

  @override
  String get materialStatusCustomerReview => 'તમારી સમીક્ષાની રાહ';

  @override
  String get materialStatusApproved => 'મંજૂર';

  @override
  String get materialStatusRejected => 'નકારી';

  @override
  String get materialStatusPurchased => 'ખરીદ્યું';

  @override
  String get materialStatusCostRecorded => 'ખર્ચ નોંધાયો';

  @override
  String get materialStatusBilled => 'બિલમાં ઉમેર્યું';

  @override
  String get materialStatusCancelled => 'રદ';

  @override
  String get commonSaveChanges => 'ફેરફારો સાચવો';

  @override
  String get profileTitle => 'મારી પ્રોફાઇલ અને ખાતું';

  @override
  String get profileFallbackName => 'ગ્રાહક પ્રોફાઇલ';

  @override
  String get profileLanguage => 'ભાષા';

  @override
  String get profileAddresses => 'સાચવેલાં સેવા સરનામાં';

  @override
  String get profileAddressesSubtitle => 'ઘર, ઑફિસ અને અન્ય સરનામાં સંભાળો';

  @override
  String get profileHistory => 'અગાઉની સેવાઓનો ઇતિહાસ';

  @override
  String get profileHistorySubtitle => 'રસીદો અને અગાઉનાં બુકિંગ જુઓ';

  @override
  String get profileSupport => 'મદદ અને ગ્રાહક સહાય';

  @override
  String get profileSupportSubtitle => 'ટિકિટ બનાવો, અમારી ટીમના જવાબો જુઓ';

  @override
  String get editProfileSaved => 'પ્રોફાઇલ સફળતાપૂર્વક અપડેટ થઈ';

  @override
  String get editProfileTitle => 'પ્રોફાઇલ સંપાદિત કરો';

  @override
  String get editProfileFullName => 'પૂરું નામ';

  @override
  String get editProfileNameEmpty => 'નામ ખાલી ન હોઈ શકે';

  @override
  String get editProfileEmail => 'ઇમેઇલ સરનામું';

  @override
  String get commonEdit => 'સંપાદિત કરો';

  @override
  String get commonDelete => 'કાઢી નાખો';

  @override
  String get addressesAdd => 'નવું સરનામું ઉમેરો';

  @override
  String get addressesEmpty => 'તમે હજુ કોઈ સરનામું સાચવ્યું નથી';

  @override
  String get addressesEmptyMessage =>
      'આગલી વખતે ઝડપથી બુક કરવા સેવાનું સરનામું ઉમેરો.';

  @override
  String get addressesDefaultBadge => 'ડિફૉલ્ટ';

  @override
  String get addressesSetDefault => 'ડિફૉલ્ટ તરીકે સેટ કરો';

  @override
  String get addressesLoadFailed => 'સરનામાં લોડ થઈ શક્યાં નહીં.';

  @override
  String get addressesLabelSheet => 'આ સરનામાને નામ આપો';

  @override
  String get supportTitle => 'મદદ અને સહાય';

  @override
  String get supportNewTicket => 'નવી ટિકિટ';

  @override
  String get supportEmpty => 'હજુ કોઈ સહાય ટિકિટ નથી';

  @override
  String get supportEmptyMessage =>
      'બુકિંગ કે એપ વિશે મદદ જોઈએ છે? ટિકિટ બનાવો અને અમારી ટીમ જવાબ આપશે.';

  @override
  String get supportLoadFailed => 'તમારી સહાય ટિકિટો લોડ થઈ શકી નહીં.';

  @override
  String get supportStatusOpen => 'ખુલ્લી';

  @override
  String get supportStatusInProgress => 'ચાલુ છે';

  @override
  String get supportStatusWaitingForYou => 'તમારી રાહ';

  @override
  String get supportStatusResolved => 'ઉકેલાઈ';

  @override
  String get supportStatusClosed => 'બંધ';

  @override
  String get supportNewTicketTitle => 'નવી સહાય ટિકિટ';

  @override
  String get supportCategory => 'શ્રેણી';

  @override
  String get supportSubject => 'વિષય';

  @override
  String get supportDescribeIssue => 'સમસ્યા વર્ણવો';

  @override
  String get supportFillSubjectMessage => 'કૃપા કરીને વિષય અને સંદેશ ભરો.';

  @override
  String get supportSubmitTicket => 'ટિકિટ મોકલો';

  @override
  String get supportTicketTitle => 'સહાય ટિકિટ';

  @override
  String get supportNoMessages => 'હજુ કોઈ સંદેશ નથી';

  @override
  String get supportMessagesLoadFailed => 'સંદેશા લોડ થઈ શક્યા નહીં.';

  @override
  String get supportTypeMessage => 'સંદેશ લખો...';

  @override
  String get supportSend => 'મોકલો';

  @override
  String get pickerEnterAddress =>
      'કૃપા કરીને આ પિન માટે સરનામું દાખલ કરો અથવા પુષ્ટિ કરો';

  @override
  String get pickerTitle => 'સેવાનું સરનામું પસંદ કરો';

  @override
  String get pickerGettingLocation => 'તમારું સ્થાન મેળવી રહ્યા છીએ...';

  @override
  String get pickerPermissionDenied =>
      'સ્થાનની પરવાનગી નકારાઈ — સરનામું પસંદ કરવા નકશો જાતે ખસેડો.';

  @override
  String get pickerConfirmPin => 'સેવા પિનની જગ્યાની પુષ્ટિ કરો';

  @override
  String get pickerAddressLabel => 'ઘર / ફ્લૅટ / શેરીનું નામ';

  @override
  String get pickerAddressHint => 'દા.ત. #102, ગ્રીન એવન્યુ, ઇન્દિરાનગર';

  @override
  String get pickerLandmarkLabel => 'સીમાચિહ્ન (વૈકલ્પિક)';

  @override
  String get pickerLandmarkHint => 'દા.ત. HDFC બૅન્ક ATM પાસે';

  @override
  String get pickerConfirm => 'સ્થાનની પુષ્ટિ કરો અને આગળ વધો';

  @override
  String get requestSelectLocation => 'કૃપા કરીને સેવાનું સ્થાન પસંદ કરો';

  @override
  String requestTitle(Object service) {
    return '$service માટે વિનંતી કરો';
  }

  @override
  String get requestServiceAddress => 'સેવાનું સરનામું';

  @override
  String get requestDetectingLocation => 'તમારું સ્થાન શોધી રહ્યા છીએ…';

  @override
  String get requestTapToPickLocation => 'સેવાનું સ્થાન પસંદ કરવા ટૅપ કરો';

  @override
  String get requestDescribeIssue => 'સમસ્યા / કામ વર્ણવો';

  @override
  String get requestDescribeHint =>
      'દા.ત. બેઠકખંડની મુખ્ય છતની લાઇટની સ્વિચ ચાલુ કરતાં તણખા ઝરે છે.';

  @override
  String get requestDescribeMin =>
      'કૃપા કરીને સમસ્યા ઓછામાં ઓછા 10 અક્ષરોમાં વર્ણવો';

  @override
  String get requestAttachPhotos => 'સમસ્યાના ફોટા જોડો (વૈકલ્પિક)';

  @override
  String get requestAddPhoto => 'ફોટો ઉમેરો';

  @override
  String get requestWhen => 'તમારે સેવા ક્યારે જોઈએ છે?';

  @override
  String get requestInstant => '⚡ તરત (30 મિનિટ)';

  @override
  String get requestScheduleLater => '📅 પછી માટે નક્કી કરો';

  @override
  String get requestFindWorkers => 'ઉપલબ્ધ કર્મચારીઓ શોધો';

  @override
  String commonLoadFailedDetail(Object detail) {
    return 'લોડ થઈ શક્યું નહીં: $detail';
  }

  @override
  String get myRequestsTitle => 'મારી સેવા વિનંતીઓ';

  @override
  String get myRequestsTabAll => 'બધી';

  @override
  String get myRequestsNew => 'નવી વિનંતી';

  @override
  String get myRequestsNoActive => 'કોઈ ચાલુ વિનંતી નથી';

  @override
  String get myRequestsNoCompleted => 'કોઈ પૂર્ણ વિનંતી નથી';

  @override
  String get myRequestsNone => 'હજુ કોઈ સેવા વિનંતી નથી';

  @override
  String get myRequestsEmptyMessage =>
      'તમારી જરૂરિયાત પોસ્ટ કરો અને કર્મચારીઓને તમારી પાસે આવવા દો.';

  @override
  String get requestDetailTitle => 'વિનંતીની વિગતો';

  @override
  String get requestDetailBudget => 'બજેટ';

  @override
  String get requestDetailSchedule => 'સમયપત્રક';

  @override
  String get requestDetailLocation => 'સ્થાન';

  @override
  String get requestDetailNotes => 'નોંધ';

  @override
  String get requestDetailCancel => 'વિનંતી રદ કરો';

  @override
  String requestDetailOffersReceived(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ઑફર મળી',
      one: '1 ઑફર મળી',
      zero: 'હજુ કોઈ ઑફર નથી',
    );
    return '$_temp0';
  }

  @override
  String get requestDetailTapToCompare => 'જોવા અને સરખાવવા ટૅપ કરો';

  @override
  String get requestDetailWorkersSoon => 'કર્મચારીઓ જલદી જવાબ આપવાનું શરૂ કરશે';

  @override
  String get requestCancelDialogTitle => 'આ વિનંતી રદ કરીએ?';

  @override
  String get requestCancelDialogBody =>
      'બાકી બધી ઑફર બંધ કરી દેવાશે. આ પાછું ફેરવી શકાશે નહીં.';

  @override
  String get requestCancelKeep => 'રાખો';

  @override
  String get requestCancelConfirm => 'વિનંતી રદ કરો';

  @override
  String get requestCancelled => 'વિનંતી રદ થઈ';

  @override
  String requestExpiresInDaysHours(int days, int hours) {
    return '$days દિવસ $hours કલાકમાં મુદત પૂરી';
  }

  @override
  String requestExpiresInHoursMinutes(int hours, int minutes) {
    return '$hours કલાક $minutes મિનિટમાં મુદત પૂરી';
  }

  @override
  String requestExpiresInMinutes(Object minutes) {
    return '$minutes મિનિટમાં મુદત પૂરી';
  }

  @override
  String get requestExpiresSoon => 'જલદી મુદત પૂરી થશે';

  @override
  String get commonCancel => 'રદ કરો';

  @override
  String get offersTitle => 'મળેલી ઑફર';

  @override
  String get offersEmptyMessage =>
      'કર્મચારીઓ તમારી વિનંતી જોઈ રહ્યા છે. કોઈ જવાબ આપશે ત્યારે તમને જાણ કરાશે.';

  @override
  String get offersPending => 'બાકી ઑફર';

  @override
  String get offersPast => 'અગાઉની ઑફર';

  @override
  String offersJobsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count કામ',
      one: '1 કામ',
    );
    return '$_temp0';
  }

  @override
  String get offersInsured => 'વીમો છે';

  @override
  String get offersDecline => 'નકારો';

  @override
  String get offersAcceptOffer => 'ઑફર સ્વીકારો';

  @override
  String get offersAcceptDialogTitle => 'આ ઑફર સ્વીકારીએ?';

  @override
  String offersAcceptDialogBody(String worker, String price) {
    return '$worker સાથે $price માં બુકિંગ બનશે. બાકીની બધી ઑફર બંધ થઈ જશે.';
  }

  @override
  String get offersAccept => 'સ્વીકારો';

  @override
  String offersBookingCreated(Object code) {
    return 'બુકિંગ $code બન્યું!';
  }

  @override
  String get commonNext => 'આગળ';

  @override
  String postRequestPosted(Object code) {
    return 'સેવા વિનંતી $code પોસ્ટ થઈ!';
  }

  @override
  String get postRequestTitle => 'સેવા વિનંતી પોસ્ટ કરો';

  @override
  String get postRequestWhatService => 'તમારે કઈ સેવા જોઈએ છે?';

  @override
  String get postRequestSelectCategory =>
      'તમારી જરૂરિયાતને શ્રેષ્ઠ રીતે દર્શાવતી શ્રેણી પસંદ કરો.';

  @override
  String get postRequestDescribe => 'તમારી જરૂરિયાત વર્ણવો';

  @override
  String postRequestServiceLabel(Object service) {
    return 'સેવા: $service';
  }

  @override
  String get postRequestWhatDone => 'તમારે શું કામ કરાવવું છે?';

  @override
  String get postRequestFieldTitle => 'શીર્ષક';

  @override
  String get postRequestTitleHint => 'દા.ત. રસોડાનો ટપકતો નળ સરખો કરવો';

  @override
  String postRequestMinChars(Object count) {
    return 'ઓછામાં ઓછા $count અક્ષર દાખલ કરો';
  }

  @override
  String get postRequestFieldDescription => 'વર્ણન';

  @override
  String get postRequestDescriptionHint => 'સમસ્યા વિગતવાર વર્ણવો…';

  @override
  String get postRequestFieldNotes => 'વધારાની નોંધ (વૈકલ્પિક)';

  @override
  String get postRequestNotesHint => 'ગેટ કોડ, પસંદગીનો સમય વગેરે';

  @override
  String get postRequestBudgetTitle => 'તમારું બજેટ';

  @override
  String get postRequestBudgetHint =>
      'તમે કેટલું ચૂકવવા તૈયાર છો તેનો કર્મચારીઓને અંદાજ આપો.';

  @override
  String get postRequestFixedPrice => 'નિશ્ચિત કિંમત (₹)';

  @override
  String postRequestExample(Object example) {
    return 'દા.ત. $example';
  }

  @override
  String get postRequestMin => 'ન્યૂનતમ (₹)';

  @override
  String get postRequestMax => 'મહત્તમ (₹)';

  @override
  String get postRequestWhenTitle => 'તમારે આ ક્યારે જોઈએ છે?';

  @override
  String get postRequestPickDate => 'તારીખ પસંદ કરો';

  @override
  String get postRequestLocationTitle => 'સેવાનું સ્થાન';

  @override
  String get postRequestAddressPrivate =>
      'તમે ઑફર સ્વીકારો પછી જ તમારું ચોક્કસ સરનામું શેર થાય છે.';

  @override
  String get postRequestFullAddress => 'પૂરું સરનામું';

  @override
  String get postRequestValidAddress => 'માન્ય સરનામું દાખલ કરો';

  @override
  String get postRequestCity => 'શહેર';

  @override
  String get postRequestCityHint => 'દા.ત. બેંગલુરુ';

  @override
  String get postRequestPincode => 'પિનકોડ';

  @override
  String get postRequestLocationSet => 'સ્થાન સેટ થયું ✓';

  @override
  String get postRequestSetOnMap => 'નકશા પર સ્થાન સેટ કરો';

  @override
  String get postRequestReviewTitle => 'તમારી વિનંતી તપાસો';

  @override
  String get postRequestNotSelected => 'પસંદ કર્યું નથી';

  @override
  String get postRequestWhen => 'ક્યારે';

  @override
  String get postRequestPrivacyNote =>
      'તમે ઑફર સ્વીકારો અને બુકિંગ બને ત્યાં સુધી તમારું ચોક્કસ સરનામું ખાનગી રહે છે.';

  @override
  String get postRequestSubmit => 'વિનંતી મોકલો';

  @override
  String get assistantOpening =>
      'શું ખરાબ છે તે તમારા શબ્દોમાં કહો — હું તેના માટે યોગ્ય વ્યાવસાયિક શોધી આપીશ.';

  @override
  String assistantCatalogueFailed(Object reason) {
    return '$reason તેનો જવાબ આપવા મારે સેવાઓની યાદી જોઈએ.';
  }

  @override
  String get assistantCatalogueError =>
      'સેવાઓની યાદી લોડ કરવામાં કંઈક ખોટું થયું.';

  @override
  String get assistantGreeting =>
      'નમસ્તે. ઘરમાં તમારે શેમાં મદદ જોઈએ છે? ટપકતો નળ, ઠંડક ન આપતું AC, તણખા ઝરતી સ્વિચ — જે પણ હોય, તમને ગમે તે રીતે વર્ણવો.';

  @override
  String get assistantTooVague =>
      'હું મદદ કરી શકું — બસ સમસ્યા શું છે તે જાણવું છે. શું કામ નથી કરતું?';

  @override
  String assistantMultipleJobs(int count) {
    return 'આ $count અલગ-અલગ કામ લાગે છે — તેમાં અલગ-અલગ કારીગરો જોઈએ. દરેક અહીં છે:';
  }

  @override
  String get assistantAmbiguous =>
      'હું આ સાચું કરવા માગું છું — આ એકથી વધુ કામમાં જઈ શકે. કયું વધુ નજીક છે?';

  @override
  String get assistantUnmatched =>
      'પ્લૅટફૉર્મ પરની કોઈ સેવા સાથે હું આ મેળવી શક્યો નહીં. સૌથી નજીકની પસંદ કરો અને હું તમારું વર્ણન ત્યાં લઈ જઈશ — અથવા તેને વિનંતી તરીકે પોસ્ટ કરો અને વ્યાવસાયિકોને તમારી પાસે આવવા દો.';

  @override
  String assistantConfidentWithProblem(String service, String problem) {
    return 'આ $service નું કામ લાગે છે — મોટે ભાગે \"$problem\".';
  }

  @override
  String assistantConfident(Object service) {
    return 'આ $service નું કામ લાગે છે.';
  }

  @override
  String assistantChosen(Object service) {
    return 'ઠીક છે, $service. તમે લખેલું વર્ણન જેમ છે તેમ મોકલાશે.';
  }

  @override
  String get assistantTitle => 'સેવા સહાયક';

  @override
  String get assistantSubtitle => 'તમારી સમસ્યા માટે યોગ્ય કામ શોધે છે';

  @override
  String get assistantStartOver => 'ફરી શરૂ કરો';

  @override
  String assistantMatchedOn(Object terms) {
    return 'મેળ ખાતા શબ્દો: $terms';
  }

  @override
  String get assistantFindWorkers => 'કર્મચારીઓ શોધો';

  @override
  String get assistantPostRequest => 'વિનંતી પોસ્ટ કરો';

  @override
  String get assistantInputHint => 'સમસ્યા વર્ણવો...';
}
