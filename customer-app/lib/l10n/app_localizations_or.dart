// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Oriya (`or`).
class AppLocalizationsOr extends AppLocalizations {
  AppLocalizationsOr([String locale = 'or']) : super(locale);

  @override
  String get commonRetry => 'ପୁଣି ଚେଷ୍ଟା କରନ୍ତୁ';

  @override
  String get commonTryAgain => 'ପୁଣି ଚେଷ୍ଟା କରନ୍ତୁ';

  @override
  String get commonSignOut => 'ସାଇନ୍ ଆଉଟ୍ କରନ୍ତୁ';

  @override
  String get assistantFabLabel => 'AI କୁ ପଚାରନ୍ତୁ';

  @override
  String get navHome => 'ହୋମ୍';

  @override
  String get navExplore => 'ଖୋଜନ୍ତୁ';

  @override
  String get navBookings => 'ବୁକିଂ';

  @override
  String get navAlerts => 'ସତର୍କ ସୂଚନା';

  @override
  String get navProfile => 'ପ୍ରୋଫାଇଲ୍';

  @override
  String get configErrorTitle => 'ଆପ୍ କନଫିଗର୍ ହୋଇନାହିଁ';

  @override
  String configErrorBody(String keys, String command) {
    return 'ଏହି ବିଲ୍ଡରେ $keys ନାହିଁ। ଏହିପରି ଚଲାନ୍ତୁ:\n\n$command\n\nଯାହାଦ୍ୱାରା ଆପ୍ ପ୍ରକୃତ ବ୍ୟାକଏଣ୍ଡରେ ପହଞ୍ଚିପାରିବ।';
  }

  @override
  String get sessionProfileLoadFailedRetry =>
      'ଆମେ ଆପଣଙ୍କ ପ୍ରୋଫାଇଲ୍ ଲୋଡ୍ କରିପାରିଲୁ ନାହିଁ। ଦୟାକରି ପୁଣି ଚେଷ୍ଟା କରନ୍ତୁ।';

  @override
  String get sessionProfileLoadFailed =>
      'ଆମେ ଆପଣଙ୍କ ପ୍ରୋଫାଇଲ୍ ଲୋଡ୍ କରିପାରିଲୁ ନାହିଁ';

  @override
  String get sessionCheckClock => 'ଆପଣଙ୍କ ଫୋନର ଘଣ୍ଟା ଯାଞ୍ଚ କରନ୍ତୁ';

  @override
  String get splashTagline => 'ଘରର ସେବା, ଠିକ୍ ଭାବରେ।';

  @override
  String get timelineBookingConfirmed => 'ବୁକିଂ ନିଶ୍ଚିତ ହେଲା';

  @override
  String get timelineProviderOnTheWay => 'ସେବା ପ୍ରଦାନକାରୀ ବାଟରେ ଅଛନ୍ତି';

  @override
  String get timelineServiceInProgress => 'ସେବା ଚାଲିଛି';

  @override
  String get timelineCompleted => 'ସମ୍ପୂର୍ଣ୍ଣ';

  @override
  String get errorNoInternet =>
      'ଇଣ୍ଟରନେଟ୍ ସଂଯୋଗ ନାହିଁ। ଆପଣଙ୍କ ନେଟୱର୍କ ଯାଞ୍ଚ କରି ପୁଣି ଚେଷ୍ଟା କରନ୍ତୁ।';

  @override
  String get errorTimeout => 'ଏଥିରେ ବହୁତ ସମୟ ଲାଗିଲା। ପୁଣି ଚେଷ୍ଟା କରନ୍ତୁ।';

  @override
  String get errorServer =>
      'ଆମ ପକ୍ଷରୁ କିଛି ଭୁଲ ହେଲା। ଦୟାକରି ପୁଣି ଚେଷ୍ଟା କରନ୍ତୁ।';

  @override
  String get errorClockSkew =>
      'ଆପଣଙ୍କ ଫୋନର ତାରିଖ ଓ ସମୟ ଠିକ୍ ନାହିଁ ପରି ଲାଗୁଛି। ସେଟିଂସରେ ସ୍ୱୟଂଚାଳିତ ତାରିଖ ଓ ସମୟ ଚାଲୁ କରି ପୁଣି ଚେଷ୍ଟା କରନ୍ତୁ।';

  @override
  String get errorUnexpected => 'କିଛି ଭୁଲ ହେଲା। ଦୟାକରି ପୁଣି ଚେଷ୍ଟା କରନ୍ତୁ।';

  @override
  String get errorSessionEnded =>
      'ଆପଣଙ୍କ ସେସନ୍ ଶେଷ ହୋଇଛି। ଦୟାକରି ପୁଣି ସାଇନ୍ ଇନ୍ କରନ୍ତୁ।';

  @override
  String get errorUploadFailed =>
      'ସେହି ଫାଇଲ୍ ଅପଲୋଡ୍ ହୋଇପାରିଲା ନାହିଁ। ପୁଣି ଚେଷ୍ଟା କରନ୍ତୁ।';

  @override
  String get errorSignInNotReady =>
      'ଆପଣଙ୍କ ସାଇନ୍-ଇନ୍ ଏପର୍ଯ୍ୟନ୍ତ ସମ୍ପୂର୍ଣ୍ଣ ପ୍ରସ୍ତୁତ ନାହିଁ। କିଛି ସମୟ ପରେ ପୁଣି ଚେଷ୍ଟା କରନ୍ତୁ।';

  @override
  String get errorNoLongerAvailable => 'ଏହା ଆଉ ଉପଲବ୍ଧ ନାହିଁ।';

  @override
  String get errorNotAllowedToSee => 'ଆପଣ ଏହା ଦେଖିପାରିବେ ନାହିଁ।';

  @override
  String get errorDidNotWork => 'ଏହା କାମ କଲା ନାହିଁ। ଦୟାକରି ପୁଣି ଚେଷ୍ଟା କରନ୍ତୁ।';

  @override
  String get authErrorInvalidPhone => 'ସେହି ଫୋନ୍ ନମ୍ବର ଠିକ୍ ଲାଗୁନାହିଁ।';

  @override
  String get authErrorWrongCode =>
      'ସେହି କୋଡ୍ ଠିକ୍ ନୁହେଁ। ଯାଞ୍ଚ କରି ପୁଣି ଚେଷ୍ଟା କରନ୍ତୁ।';

  @override
  String get authErrorCodeExpired =>
      'ସେହି କୋଡର ମିଆଦ ଶେଷ ହୋଇଛି। ନୂଆ କୋଡ୍ ମାଗନ୍ତୁ।';

  @override
  String get authErrorTooManyAttempts =>
      'ଅତ୍ୟଧିକ ଚେଷ୍ଟା ହୋଇଛି। ପୁଣି ଚେଷ୍ଟା କରିବା ପୂର୍ବରୁ କିଛି ମିନିଟ୍ ଅପେକ୍ଷା କରନ୍ତୁ।';

  @override
  String get authErrorQuota =>
      'ଆମେ ଏବେ କୋଡ୍ ପଠାଇପାରୁନାହୁଁ। କିଛି ସମୟ ପରେ ପୁଣି ଚେଷ୍ଟା କରନ୍ତୁ।';

  @override
  String get authErrorDisabled =>
      'ଏହି ଆକାଉଣ୍ଟ ବନ୍ଦ କରାଯାଇଛି। ସହାୟତା ସହ ଯୋଗାଯୋଗ କରନ୍ତୁ।';

  @override
  String get authErrorPhoneNotEnabled =>
      'ଫୋନ୍ ସାଇନ୍-ଇନ୍ ଚାଲୁ ନାହିଁ। ସହାୟତା ସହ ଯୋଗାଯୋଗ କରନ୍ତୁ।';

  @override
  String get authErrorNumberInUse =>
      'ସେହି ନମ୍ବର ପୂର୍ବରୁ ଅନ୍ୟ ଏକ ଆକାଉଣ୍ଟରେ ପଞ୍ଜୀକୃତ।';

  @override
  String get authErrorSignInAgain =>
      'ଜାରି ରଖିବାକୁ ଦୟାକରି ପୁଣି ସାଇନ୍ ଇନ୍ କରନ୍ତୁ।';

  @override
  String get authErrorSignInFailed =>
      'ସାଇନ୍-ଇନ୍ ବିଫଳ ହେଲା। ଦୟାକରି ପୁଣି ଚେଷ୍ଟା କରନ୍ତୁ।';

  @override
  String get languagePickerTitle => 'ଆପଣଙ୍କ ଭାଷା ବାଛନ୍ତୁ';

  @override
  String get authCouldNotStartVerification =>
      'ଯାଞ୍ଚ ଆରମ୍ଭ ହୋଇପାରିଲା ନାହିଁ। ଦୟାକରି ପୁଣି ଚେଷ୍ଟା କରନ୍ତୁ।';

  @override
  String get authWelcomeTitle => 'Wervexa କୁ ସ୍ୱାଗତ';

  @override
  String get authWelcomeSubtitle =>
      'ଘର ମରାମତି, ପ୍ଲମ୍ବିଂ, ବିଦ୍ୟୁତ୍ କାମ, ସଫେଇ ଓ ଆହୁରି ଅନେକ ପାଇଁ ନିକଟସ୍ଥ ସର୍ବୋତ୍ତମ ବୃତ୍ତିଗତଙ୍କୁ ଖୋଜନ୍ତୁ।';

  @override
  String get authEnterPhone => 'ଆପଣଙ୍କ ଫୋନ୍ ନମ୍ବର ଦିଅନ୍ତୁ';

  @override
  String get authInvalidMobile => 'ଏକ ବୈଧ 10 ଅଙ୍କର ମୋବାଇଲ୍ ନମ୍ବର ଦିଅନ୍ତୁ';

  @override
  String get authGetOtp => 'OTP ଯାଞ୍ଚ ପାଆନ୍ତୁ';

  @override
  String get authTermsNotice =>
      'ଜାରି ରଖି, ଆପଣ ଆମର ସେବା ସର୍ତ୍ତାବଳୀ ଓ ଗୋପନୀୟତା ନୀତିରେ ସହମତ ହେଉଛନ୍ତି';

  @override
  String get authNewCodeSent => 'ଆମେ ଏକ ନୂଆ କୋଡ୍ ପଠାଇଛୁ।';

  @override
  String get authVerifyPhoneTitle => 'ଫୋନ୍ ଯାଞ୍ଚ କରନ୍ତୁ';

  @override
  String get authChangeNumber => 'ନମ୍ବର ବଦଳାନ୍ତୁ';

  @override
  String get authEnterCodeTitle => '6 ଅଙ୍କର କୋଡ୍ ଦିଅନ୍ତୁ';

  @override
  String authCodeSentTo(Object phone) {
    return 'ଆମେ $phone କୁ SMS ଯାଞ୍ଚ କୋଡ୍ ପଠାଇଛୁ';
  }

  @override
  String get authWrongNumber => 'ଭୁଲ ନମ୍ବର? ବଦଳାନ୍ତୁ';

  @override
  String get authEnterSixDigits => 'ଦୟାକରି 6ଟି ଅଙ୍କ ଦିଅନ୍ତୁ';

  @override
  String get authResendCode => 'କୋଡ୍ ପୁଣି ପଠାନ୍ତୁ';

  @override
  String authResendCodeIn(Object seconds) {
    return '$seconds ସେକେଣ୍ଡରେ କୋଡ୍ ପୁଣି ପଠାନ୍ତୁ';
  }

  @override
  String get authVerifyAndContinue => 'ଯାଞ୍ଚ କରି ଜାରି ରଖନ୍ତୁ';

  @override
  String get registerTitle => 'ପ୍ରୋଫାଇଲ୍ ସମ୍ପୂର୍ଣ୍ଣ କରନ୍ତୁ';

  @override
  String get registerHeading => 'ଆପଣଙ୍କ ନାମ କୁହନ୍ତୁ';

  @override
  String get registerNameVisibility =>
      'ଆପଣ ବୁକିଂ ଅନୁରୋଧ କଲେ ଆପଣଙ୍କ ନାମ ସେବା କର୍ମୀମାନଙ୍କୁ ଦେଖାଯିବ।';

  @override
  String get registerFullNameLabel => 'ପୂରା ନାମ *';

  @override
  String get registerFullNameHint => 'ଯଥା ରାହୁଲ ଶର୍ମା';

  @override
  String get registerFullNameRequired => 'ଦୟାକରି ଆପଣଙ୍କ ପୂରା ନାମ ଦିଅନ୍ତୁ';

  @override
  String get registerEmailLabel => 'ଇମେଲ୍ ଠିକଣା (ଇଚ୍ଛାଧୀନ)';

  @override
  String get registerEmailHint => 'ଯଥା rahul@example.com';

  @override
  String get registerSubmit => 'ସେଭ୍ କରି ଆରମ୍ଭ କରନ୍ତୁ';

  @override
  String get bookingStatusRequested => 'ବୃତ୍ତିଗତଙ୍କୁ ଖୋଜାଯାଉଛି…';

  @override
  String get bookingStatusAccepted => 'ବୃତ୍ତିଗତ ମିଳିଲେ';

  @override
  String get bookingStatusConfirmed => 'ନିଶ୍ଚିତ';

  @override
  String get bookingStatusTraveling => 'ବାଟରେ';

  @override
  String get bookingStatusArrived => 'ପହଞ୍ଚିଲେ — ଆପଣଙ୍କ କୋଡ୍ ଦିଅନ୍ତୁ';

  @override
  String get bookingStatusInProgress => 'କାମ ଚାଲିଛି';

  @override
  String get bookingStatusAwaitingApproval =>
      'କାମ ଶେଷ — ଆଗକୁ ବଢ଼ିବାକୁ ଅନୁମୋଦନ ଦିଅନ୍ତୁ';

  @override
  String get bookingStatusCompleted => 'ସମ୍ପୂର୍ଣ୍ଣ';

  @override
  String get bookingStatusPaymentPending => 'ପେମେଣ୍ଟ ବାକି';

  @override
  String get bookingStatusPaid => 'ପେମେଣ୍ଟ ହୋଇଛି';

  @override
  String get bookingStatusClosed => 'ବନ୍ଦ';

  @override
  String get bookingStatusCancelled => 'ବାତିଲ୍';

  @override
  String get bookingStatusDisputed => 'ବିବାଦୀୟ';

  @override
  String get bookingStatusExpired => 'ମିଆଦ ଶେଷ — କେହି ଉପଲବ୍ଧ ନଥିଲେ';

  @override
  String get pricingPerJob => 'ପ୍ରତି କାମ';

  @override
  String get pricingPerHour => 'ପ୍ରତି ଘଣ୍ଟା';

  @override
  String get pricingPerDay => 'ପ୍ରତି ଦିନ';

  @override
  String get pricingPerUnit => 'ପ୍ରତି ୟୁନିଟ୍';

  @override
  String get pricingPerSqft => 'ପ୍ରତି ବର୍ଗଫୁଟ';

  @override
  String get supportCategoryBooking => 'ବୁକିଂ ସମସ୍ୟା';

  @override
  String get supportCategoryPayment => 'ପେମେଣ୍ଟ';

  @override
  String get supportCategoryPayout => 'ପେଆଉଟ୍';

  @override
  String get supportCategoryVerification => 'ଯାଞ୍ଚ';

  @override
  String get supportCategoryAccount => 'ମୋ ଆକାଉଣ୍ଟ';

  @override
  String get supportCategorySafety => 'ସୁରକ୍ଷା ଚିନ୍ତା';

  @override
  String get supportCategoryClaim => 'ବୀମା ଦାବି';

  @override
  String get supportCategoryAppIssue => 'ଆପ୍ ସମସ୍ୟା';

  @override
  String get supportCategoryOther => 'ଅନ୍ୟ';

  @override
  String get requestStatusDraft => 'ଡ୍ରାଫ୍ଟ';

  @override
  String get requestStatusOpen => 'ଖୋଲା — ଅଫର୍ ପାଇଁ ଅପେକ୍ଷା';

  @override
  String get requestStatusReceivingOffers => 'ଅଫର୍ ଆସୁଛି';

  @override
  String get requestStatusWorkerSelected => 'ବୃତ୍ତିଗତ ଚୟନ ହେଲେ';

  @override
  String get requestStatusBooked => 'ବୁକ୍ ହୋଇଛି';

  @override
  String get requestStatusCancelled => 'ବାତିଲ୍';

  @override
  String get requestStatusExpired => 'ମିଆଦ ଶେଷ';

  @override
  String get requestStatusClosed => 'ବନ୍ଦ';

  @override
  String get budgetTypeFlexible => 'ନମନୀୟ';

  @override
  String get budgetTypeFixed => 'ସ୍ଥିର ମୂଲ୍ୟ';

  @override
  String get budgetTypeRange => 'ମୂଲ୍ୟ ସୀମା';

  @override
  String get scheduleAsap => 'ଯଥାଶୀଘ୍ର';

  @override
  String get scheduleToday => 'ଆଜି';

  @override
  String get scheduleTomorrow => 'କାଲି';

  @override
  String get scheduleSpecificDate => 'ନିର୍ଦ୍ଦିଷ୍ଟ ତାରିଖରେ';

  @override
  String get scheduleScheduled => 'ନିର୍ଦ୍ଧାରିତ';

  @override
  String get offerStatusSubmitted => 'ନୂଆ ଅଫର୍';

  @override
  String get offerStatusViewed => 'ଦେଖାଯାଇଛି';

  @override
  String get offerStatusShortlisted => 'ଶର୍ଟଲିଷ୍ଟ ହୋଇଛି';

  @override
  String get offerStatusAccepted => 'ଗ୍ରହଣ ହୋଇଛି';

  @override
  String get offerStatusRejected => 'ପ୍ରତ୍ୟାଖ୍ୟାତ';

  @override
  String get offerStatusWithdrawn => 'କର୍ମୀ ପ୍ରତ୍ୟାହାର କଲେ';

  @override
  String get offerStatusExpired => 'ମିଆଦ ଶେଷ';

  @override
  String get offerStatusClosed => 'ବନ୍ଦ';

  @override
  String get gigRatingNew => 'ନୂଆ';

  @override
  String distanceMetres(Object metres) {
    return '$metres ମି';
  }

  @override
  String distanceKm(Object km) {
    return '$km କିମି';
  }

  @override
  String durationMinutes(Object minutes) {
    return '$minutes ମିନିଟ୍';
  }

  @override
  String durationHours(Object hours) {
    return '$hours ଘଣ୍ଟା';
  }

  @override
  String durationHoursMinutes(int hours, int minutes) {
    return '$hours ଘଣ୍ଟା $minutes ମିନିଟ୍';
  }

  @override
  String get offerWorkerFallbackName => 'ବୃତ୍ତିଗତ';

  @override
  String get budgetFlexible => 'ନମନୀୟ ବଜେଟ୍';

  @override
  String get budgetFixed => 'ସ୍ଥିର ବଜେଟ୍';

  @override
  String offerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countଟି ଅଫର୍',
      one: '1ଟି ଅଫର୍',
      zero: 'ଏପର୍ଯ୍ୟନ୍ତ କୌଣସି ଅଫର୍ ନାହିଁ',
    );
    return '$_temp0';
  }

  @override
  String get authPhoneTenDigits => '10 ଅଙ୍କର ମୋବାଇଲ୍ ନମ୍ବର ଦିଅନ୍ତୁ।';

  @override
  String get authCodeSendTimeout =>
      'ଆମେ କୋଡ୍ ପଠାଇପାରିଲୁ ନାହିଁ। ଆପଣଙ୍କ ନେଟୱର୍କ ଯାଞ୍ଚ କରି ପୁଣି ଚେଷ୍ଟା କରନ୍ତୁ।';

  @override
  String get authEnterReceivedCode => 'ଆପଣ ପାଇଥିବା କୋଡ୍ ଦିଅନ୍ତୁ।';

  @override
  String get authSignInIncomplete =>
      'ସାଇନ୍-ଇନ୍ ସମ୍ପୂର୍ଣ୍ଣ ହେଲା ନାହିଁ। ଦୟାକରି ପୁଣି ଚେଷ୍ଟା କରନ୍ତୁ।';

  @override
  String get authSignInToContinue => 'ଜାରି ରଖିବାକୁ ଦୟାକରି ସାଇନ୍ ଇନ୍ କରନ୍ତୁ।';

  @override
  String get paymentsNotConfigured =>
      'ଏହି ବିଲ୍ଡ ପାଇଁ ପେମେଣ୍ଟ ଏପର୍ଯ୍ୟନ୍ତ କନଫିଗର୍ ହୋଇନାହିଁ।';

  @override
  String get serviceElectrical => 'ବିଦ୍ୟୁତ୍ କାମ';

  @override
  String get servicePlumbing => 'ପ୍ଲମ୍ବିଂ';

  @override
  String get serviceAcService => 'AC ସର୍ଭିସ୍';

  @override
  String get serviceApplianceRepair => 'ଉପକରଣ ମରାମତି';

  @override
  String get serviceCarpentry => 'ବଢ଼େଇ କାମ';

  @override
  String get servicePainting => 'ପେଣ୍ଟିଂ';

  @override
  String get serviceCleaning => 'ସଫେଇ';

  @override
  String get servicePestControl => 'କୀଟ ନିୟନ୍ତ୍ରଣ';

  @override
  String get serviceOtherHome => 'ଅନ୍ୟ ଘରୋଇ ସେବା';

  @override
  String get addressLabelHome => 'ହୋମ୍';

  @override
  String get addressLabelWork => 'ଅଫିସ୍';

  @override
  String get addressLabelOther => 'ଅନ୍ୟ';

  @override
  String get commonSeeAll => 'ସବୁ ଦେଖନ୍ତୁ';

  @override
  String get commonViewAll => 'ସବୁ ଦେଖନ୍ତୁ';

  @override
  String get commonCheckBackLater => 'ଦୟାକରି ପରେ ପୁଣି ଦେଖନ୍ତୁ।';

  @override
  String get commonUseCurrentLocation => 'ବର୍ତ୍ତମାନ ସ୍ଥାନ ବ୍ୟବହାର କରନ୍ତୁ';

  @override
  String get commonChooseOnMap => 'ମାନଚିତ୍ରରେ ବାଛନ୍ତୁ';

  @override
  String homeGreetingNamed(Object name) {
    return 'ନମସ୍କାର, $name 👋';
  }

  @override
  String get homeGreeting => 'ନମସ୍କାର 👋';

  @override
  String get homeWhatService => 'ଆଜି ଆପଣଙ୍କୁ କେଉଁ ସେବା ଦରକାର?';

  @override
  String get homeSetLocation => 'ଆପଣଙ୍କ ସ୍ଥାନ ସେଟ୍ କରନ୍ତୁ';

  @override
  String get homeWorkFinishedApprove => 'କାମ ଶେଷ — ଅନୁମୋଦନ ପାଇଁ ଟ୍ୟାପ୍ କରନ୍ତୁ';

  @override
  String get homeCategories => 'ବର୍ଗ';

  @override
  String homeCategoriesLoadFailed(Object error) {
    return 'ବର୍ଗ ଲୋଡ୍ ହୋଇପାରିଲା ନାହିଁ: $error';
  }

  @override
  String get homeFindWorker => 'କର୍ମୀ ଖୋଜନ୍ତୁ';

  @override
  String get homeFindWorkerSubtitle => 'ନିକଟସ୍ଥ ସେବା ଦେଖନ୍ତୁ';

  @override
  String get homePostRequest => 'ଅନୁରୋଧ ପୋଷ୍ଟ କରନ୍ତୁ';

  @override
  String get homePostRequestSubtitle => 'କର୍ମୀମାନେ ଆପଣଙ୍କ ପାଖକୁ ଆସନ୍ତି';

  @override
  String get homeNoServices => 'ଏବେ କୌଣସି ସେବା ଉପଲବ୍ଧ ନାହିଁ';

  @override
  String get homeSearchNear => 'ନିକଟରେ ସେବା ଖୋଜନ୍ତୁ';

  @override
  String get homeSearchHint => 'ସେବା ଖୋଜନ୍ତୁ...';

  @override
  String homeActiveBooking(Object code) {
    return 'ସକ୍ରିୟ ବୁକିଂ #$code';
  }

  @override
  String get homeActiveRequests => 'ଆପଣଙ୍କ ସକ୍ରିୟ ଅନୁରୋଧ';

  @override
  String get commonGrantPermission => 'ଅନୁମତି ଦିଅନ୍ତୁ';

  @override
  String get commonView => 'ଦେଖନ୍ତୁ';

  @override
  String get exploreTitle => 'ସେବା ଖୋଜନ୍ତୁ ଓ ଆବିଷ୍କାର କରନ୍ତୁ';

  @override
  String get exploreListView => 'ତାଲିକା ଦୃଶ୍ୟ';

  @override
  String get exploreMapView => 'ମାନଚିତ୍ର ଦୃଶ୍ୟ';

  @override
  String get exploreSearchHint => 'ସେବା, କର୍ମୀ କିମ୍ବା ଦକ୍ଷତା ଖୋଜନ୍ତୁ...';

  @override
  String get exploreLocationOffTitle => 'ଲୋକେସନ୍ ସେବା ବନ୍ଦ ଅଛି';

  @override
  String get exploreLocationOffMessage =>
      'ନିକଟସ୍ଥ ବୃତ୍ତିଗତଙ୍କୁ ଖୋଜିବାକୁ ଲୋକେସନ୍ ଚାଲୁ କରନ୍ତୁ।';

  @override
  String get exploreLocationPermissionTitle => 'ଲୋକେସନ୍ ଅନୁମତି ଆବଶ୍ୟକ';

  @override
  String get exploreLocationPermissionMessage =>
      'ନିକଟସ୍ଥ ବୃତ୍ତିଗତଙ୍କୁ ଖୋଜିବାକୁ ଆମେ ଆପଣଙ୍କ ଲୋକେସନ୍ ବ୍ୟବହାର କରୁ।';

  @override
  String get exploreChooseService => 'ଖୋଜିବାକୁ ଏକ ସେବା ବାଛନ୍ତୁ';

  @override
  String get exploreChooseServiceMessage =>
      'ନିକଟସ୍ଥ ବୃତ୍ତିଗତଙ୍କୁ ଦେଖିବାକୁ ଉପରେ ଏକ ବର୍ଗ ବାଛନ୍ତୁ।';

  @override
  String get exploreNoProfessionals =>
      'ଏହି ସେବା ପାଇଁ ନିକଟରେ କୌଣସି ବୃତ୍ତିଗତ ଉପଲବ୍ଧ ନାହାନ୍ତି';

  @override
  String get exploreLoadFailed => 'ବୃତ୍ତିଗତଙ୍କୁ ଲୋଡ୍ କରାଯାଇପାରିଲା ନାହିଁ।';

  @override
  String exploreByWorker(Object name) {
    return '$name ଙ୍କ ଦ୍ୱାରା';
  }

  @override
  String get bookingsTitle => 'ମୋ ସେବା ବୁକିଂ';

  @override
  String get bookingsTabActive => 'ସକ୍ରିୟ';

  @override
  String get bookingsTabCompleted => 'ସମ୍ପୂର୍ଣ୍ଣ';

  @override
  String get bookingsTabCancelled => 'ବାତିଲ୍';

  @override
  String get bookingsLoadFailed => 'ଆପଣଙ୍କ ବୁକିଂ ଲୋଡ୍ ହୋଇପାରିଲା ନାହିଁ।';

  @override
  String get bookingsEmpty => 'ଏପର୍ଯ୍ୟନ୍ତ କୌଣସି ବୁକିଂ ନାହିଁ';

  @override
  String get bookingsFindService => 'ସେବା ଖୋଜନ୍ତୁ';

  @override
  String get bookingsWaitingForProfessional => 'ବୃତ୍ତିଗତଙ୍କ ପାଇଁ ଅପେକ୍ଷା';

  @override
  String bookingsCode(Object code) {
    return 'ବୁକିଂ କୋଡ୍: #$code';
  }

  @override
  String get bookingsPayNow => 'ଏବେ ପେମେଣ୍ଟ କରନ୍ତୁ';

  @override
  String get bookingsApproveWork => 'କାମ ଅନୁମୋଦନ କରନ୍ତୁ';

  @override
  String get bookingsTrackLive => 'ଲାଇଭ୍ ଟ୍ରାକ୍ କରନ୍ତୁ';

  @override
  String get bookingsDetails => 'ବିବରଣୀ';

  @override
  String get bookingDetailTitle => 'ବୁକିଂ ବିବରଣୀ';

  @override
  String get bookingDetailLoadFailed => 'ବୁକିଂ ବିବରଣୀ ଲୋଡ୍ ହୋଇପାରିଲା ନାହିଁ।';

  @override
  String get bookingDetailWaitingAccept => 'ବୃତ୍ତିଗତ ଗ୍ରହଣ କରିବା ପାଇଁ ଅପେକ୍ଷା';

  @override
  String bookingDetailNumber(Object code) {
    return 'ବୁକିଂ #$code';
  }

  @override
  String bookingDetailStatus(Object status) {
    return 'ସ୍ଥିତି: $status';
  }

  @override
  String get bookingDetailLiveMap => 'ଲାଇଭ୍ ମାନଚିତ୍ର';

  @override
  String get bookingDetailServiceInfo => 'ସେବା ଅନୁରୋଧ ସୂଚନା';

  @override
  String get bookingDetailViewMaterials => 'ସାମଗ୍ରୀ / ଯନ୍ତ୍ରାଂଶ ଅନୁରୋଧ ଦେଖନ୍ତୁ';

  @override
  String get bookingDetailFareDetails => 'ଭଡ଼ା ବିବରଣୀ';

  @override
  String get bookingDetailEstimatedFare => 'ଆନୁମାନିକ ଭଡ଼ା';

  @override
  String get bookingDetailFinalFare => 'ଅନ୍ତିମ ନିଶ୍ଚିତ ଭଡ଼ା';

  @override
  String get bookingDetailRateReview =>
      'ସେବା କର୍ମୀଙ୍କୁ ରେଟିଂ ଓ ସମୀକ୍ଷା ଦିଅନ୍ତୁ';

  @override
  String get bookingDetailApproveCompletion => 'ସମାପ୍ତି ଅନୁମୋଦନ କରନ୍ତୁ';

  @override
  String get bookingDetailApprovePaidHint =>
      'ଆପଣଙ୍କ ବୃତ୍ତିଗତ ଏହି କାମକୁ ଶେଷ ବୋଲି ଚିହ୍ନିତ କରିଛନ୍ତି। ଅନୁମୋଦନ ଦେଲେ ଆପଣଙ୍କ ପେମେଣ୍ଟ ତାଙ୍କୁ ମିଳିବ।';

  @override
  String get bookingDetailApproveUnpaidHint =>
      'ଆପଣଙ୍କ ବୃତ୍ତିଗତ ଏହି କାମକୁ ଶେଷ ବୋଲି ଚିହ୍ନିତ କରିଛନ୍ତି। ନିଶ୍ଚିତ କରି ପେମେଣ୍ଟକୁ ଯିବାକୁ ଅନୁମୋଦନ ଦିଅନ୍ତୁ।';

  @override
  String get bookingDetailReportProblem => 'ସମସ୍ୟା ଜଣାନ୍ତୁ';

  @override
  String get bookingDetailCompletionApproved => 'ସମାପ୍ତି ଅନୁମୋଦିତ';

  @override
  String bookingDetailPayToConfirm(Object amount) {
    return 'ନିଶ୍ଚିତ କରିବାକୁ $amount ପେମେଣ୍ଟ କରନ୍ତୁ';
  }

  @override
  String get bookingDetailSentAfterPayment =>
      'ପେମେଣ୍ଟ ସମ୍ପୂର୍ଣ୍ଣ ହେବା ପରେ ଆପଣଙ୍କ ବୁକିଂ ବୃତ୍ତିଗତଙ୍କୁ ପଠାଯିବ।';

  @override
  String bookingDetailPayAmount(Object amount) {
    return '$amount ପେମେଣ୍ଟ କରନ୍ତୁ';
  }

  @override
  String get bookingDetailCancelBooking => 'ବୁକିଂ ବାତିଲ୍ କରନ୍ତୁ';

  @override
  String get cancelReasonMistake => 'ଭୁଲରେ ବୁକ୍ ହୋଇଗଲା';

  @override
  String get cancelReasonNoLongerNeeded => 'ମୋତେ ଆଉ ଏହି ସେବା ଦରକାର ନାହିଁ';

  @override
  String get cancelReasonDifferentTime => 'ମୁଁ ଅନ୍ୟ ଏକ ସମୟ ବାଛିବାକୁ ଚାହେଁ';

  @override
  String get cancelReasonFoundSomeoneElse => 'ମୋତେ ଅନ୍ୟ କେହି ମିଳିଗଲେ';

  @override
  String get cancelDialogTitle => 'ଆପଣ କାହିଁକି ବାତିଲ୍ କରୁଛନ୍ତି?';

  @override
  String get cancelDialogRefundNotice =>
      'ଏହାକୁ ଫେରାଇ ହେବ ନାହିଁ। ଆପଣଙ୍କ ପେମେଣ୍ଟ ମୂଳ ପେମେଣ୍ଟ ପଦ୍ଧତିକୁ ଫେରାଇ ଦିଆଯିବ।';

  @override
  String get cancelDialogCannotUndo => 'ଏହାକୁ ଫେରାଇ ହେବ ନାହିଁ।';

  @override
  String get cancelDialogKeepBooking => 'ବୁକିଂ ରଖନ୍ତୁ';

  @override
  String get bookingCancelledRefund =>
      'ବୁକିଂ ବାତିଲ୍ ହେଲା। ଆପଣଙ୍କ ରିଫଣ୍ଡ ପାଇଁ ଅନୁରୋଧ କରାଯାଇଛି।';

  @override
  String get bookingCancelled => 'ବୁକିଂ ବାତିଲ୍ ହେଲା';

  @override
  String get arrivalCodeTitle => 'ପହଞ୍ଚିବା କୋଡ୍';

  @override
  String get arrivalCodeShare =>
      'ବୃତ୍ତିଗତ ପହଞ୍ଚିଛନ୍ତି ବୋଲି ନିଶ୍ଚିତ କରିବାକୁ ଏହି କୋଡ୍ ତାଙ୍କୁ କୁହନ୍ତୁ:';

  @override
  String get arrivalCodeUnavailable => 'ଉପଲବ୍ଧ ନାହିଁ';

  @override
  String get arrivalCodeLoadFailed => 'କୋଡ୍ ଲୋଡ୍ ହୋଇପାରିଲା ନାହିଁ';

  @override
  String get activeBookingTitle => 'ଲାଇଭ୍ ବୁକିଂ ଓ କର୍ମୀ ଟ୍ରାକିଂ';

  @override
  String get activeBookingLoadFailed => 'ଏହି ବୁକିଂ ଲୋଡ୍ ହୋଇପାରିଲା ନାହିଁ।';

  @override
  String get activeBookingMapUnavailable =>
      'ଏହି ବୁକିଂ ପାଇଁ ଲାଇଭ୍ ମାନଚିତ୍ର ଉପଲବ୍ଧ ନାହିଁ।';

  @override
  String get activeBookingViewDetails => 'ବୁକିଂ ବିବରଣୀ ଦେଖନ୍ତୁ';

  @override
  String get activeBookingServiceLocation => 'ସେବା ସ୍ଥାନ';

  @override
  String get activeBookingYourProfessional => 'ଆପଣଙ୍କ ବୃତ୍ତିଗତ';

  @override
  String get activeBookingLive => 'ଲାଇଭ୍';

  @override
  String get activeBookingLastKnown => 'ଶେଷ ଜଣାଥିବା ସ୍ଥାନ';

  @override
  String get activeBookingPhoneNotShared => 'ଫୋନ୍ ଏପର୍ଯ୍ୟନ୍ତ ସେୟାର୍ ହୋଇନାହିଁ';

  @override
  String get activeBookingCallProfessional => 'ବୃତ୍ତିଗତଙ୍କୁ କଲ୍ କରନ୍ତୁ';

  @override
  String get activeBookingMaterials => 'ସାମଗ୍ରୀ';

  @override
  String get activeBookingViewDetailsShort => 'ବିବରଣୀ ଦେଖନ୍ତୁ';

  @override
  String get locationConnecting => 'ଲାଇଭ୍ ଲୋକେସନ୍ ସହ ଯୋଡ଼ାଯାଉଛି...';

  @override
  String get locationLiveUnavailable =>
      'ଲାଇଭ୍ ଲୋକେସନ୍ ଅସ୍ଥାୟୀ ଭାବେ ଉପଲବ୍ଧ ନାହିଁ';

  @override
  String get locationLiveActive => 'ଲାଇଭ୍ ଲୋକେସନ୍ ସକ୍ରିୟ';

  @override
  String get locationUpdating => 'ଅପଡେଟ୍ ହେଉଛି...';

  @override
  String get locationUnavailable => 'ଲୋକେସନ୍ ଅସ୍ଥାୟୀ ଭାବେ ଉପଲବ୍ଧ ନାହିଁ';

  @override
  String get activeBookingShareStartCode =>
      'କର୍ମୀ ପହଞ୍ଚିଗଲେ! ଆରମ୍ଭ କୋଡ୍ କୁହନ୍ତୁ:';

  @override
  String get commonBack => 'ପଛକୁ';

  @override
  String get paymentCouldNotOpen =>
      'ପେମେଣ୍ଟ ସ୍କ୍ରିନ୍ ଖୋଲିପାରିଲା ନାହିଁ। ଦୟାକରି ପୁଣି ଚେଷ୍ଟା କରନ୍ତୁ।';

  @override
  String get paymentReceived =>
      'ପେମେଣ୍ଟ ମିଳିଲା। ଆପଣଙ୍କ ବୁକିଂ ବୃତ୍ତିଗତଙ୍କୁ ପଠାଯାଇଛି।';

  @override
  String paymentNotConfirmed(String reason, String reference) {
    return 'ଆମେ ଏହି ପେମେଣ୍ଟ ନିଶ୍ଚିତ କରିପାରିଲୁ ନାହିଁ: $reason। ଟଙ୍କା କଟିଥିଲେ $reference ରେଫରେନ୍ସ ସହ ସହାୟତା ସହ ଯୋଗାଯୋଗ କରନ୍ତୁ।';
  }

  @override
  String get paymentNotCompleted => 'ପେମେଣ୍ଟ ସମ୍ପୂର୍ଣ୍ଣ ହେଲା ନାହିଁ।';

  @override
  String paymentExternalWalletUnsupported(Object wallet) {
    return 'ବାହ୍ୟ ୱାଲେଟ୍ ($wallet) ବଛାଯାଇଛି — ଏହା ଏପର୍ଯ୍ୟନ୍ତ ସମର୍ଥିତ ନୁହେଁ।';
  }

  @override
  String get paymentTitle => 'ପେମେଣ୍ଟ';

  @override
  String get paymentStatusUnknown =>
      'ଏହି ବୁକିଂର ପେମେଣ୍ଟ ପୂର୍ବରୁ ହୋଇଛି କି ନାହିଁ ଆମେ ଯାଞ୍ଚ କରିପାରିଲୁ ନାହିଁ। ଦୁଇଥର ପେମେଣ୍ଟ କରିବା ବଦଳରେ ଦୟାକରି ପୁଣି ଚେଷ୍ଟା କରନ୍ତୁ।';

  @override
  String get paymentBookingLoadFailed => 'ଏହି ବୁକିଂ ଲୋଡ୍ ହୋଇପାରିଲା ନାହିଁ।';

  @override
  String get paymentComplete => 'ପେମେଣ୍ଟ ସମ୍ପୂର୍ଣ୍ଣ';

  @override
  String paymentPaidFor(String amount, String service) {
    return '$service ପାଇଁ $amount ପେମେଣ୍ଟ ହେଲା।';
  }

  @override
  String get paymentViewBooking => 'ବୁକିଂ ଦେଖନ୍ତୁ';

  @override
  String get paymentBookingSummary => 'ବୁକିଂ ସାରାଂଶ';

  @override
  String get paymentProvider => 'ପ୍ରଦାନକାରୀ';

  @override
  String get paymentService => 'ସେବା';

  @override
  String get paymentDate => 'ତାରିଖ';

  @override
  String get paymentTime => 'ସମୟ';

  @override
  String get paymentAddress => 'ଠିକଣା';

  @override
  String get paymentTotal => 'ମୋଟ';

  @override
  String get paymentHeldSecurely =>
      'ଆପଣଙ୍କ ପେମେଣ୍ଟ ସୁରକ୍ଷିତ ଭାବେ ରଖାଯାଏ ଏବଂ ଆପଣ କାମ ଅନୁମୋଦନ କରିବା ପରେ ହିଁ ବୃତ୍ତିଗତଙ୍କୁ ଦିଆଯାଏ। କାମ ଆରମ୍ଭ ପୂର୍ବରୁ ବୁକିଂ ବାତିଲ୍ ହେଲେ ଆପଣ ରିଫଣ୍ଡ ପାଇବେ।';

  @override
  String get commonChange => 'ବଦଳାନ୍ତୁ';

  @override
  String get bookMissingDetails =>
      'ବୁକିଂ ବିବରଣୀ ଅସମ୍ପୂର୍ଣ୍ଣ — ଦୟାକରି ପୁଣି ଆରମ୍ଭ କରନ୍ତୁ।';

  @override
  String get bookSlotPassed =>
      'ସେହି ସମୟ ବିତିଗଲାଣି। ଆମେ ଆପଣଙ୍କୁ ପରବର୍ତ୍ତୀ ଉପଲବ୍ଧ ସ୍ଲଟ୍‌କୁ ନେଇଛୁ — ଯାଞ୍ଚ କରି ପୁଣି ନିଶ୍ଚିତ କରନ୍ତୁ।';

  @override
  String bookFailed(Object reason) {
    return 'ବୁକିଂ ବିଫଳ: $reason';
  }

  @override
  String get bookNoAddress => 'କୌଣସି ଠିକଣା ବଛାଯାଇନାହିଁ';

  @override
  String get bookTitle => 'ସେବା ବୁକ୍ କରନ୍ତୁ';

  @override
  String get bookSelectDate => 'ତାରିଖ ବାଛନ୍ତୁ';

  @override
  String get bookSelectTime => 'ସମୟ ବାଛନ୍ତୁ';

  @override
  String get bookSpecialInstructions => 'ବିଶେଷ ନିର୍ଦ୍ଦେଶ (ଇଚ୍ଛାଧୀନ)';

  @override
  String get bookSpecialInstructionsHint =>
      'ଯଥା ରୋଷେଇ ଘର ଓ ବାଥରୁମ୍ ଉପରେ ଧ୍ୟାନ ଦିଅନ୍ତୁ...';

  @override
  String get bookConfirm => 'ବୁକିଂ ନିଶ୍ଚିତ କରନ୍ତୁ →';

  @override
  String get gigUnknownProfessional => 'ଅଜଣା ବୃତ୍ତିଗତ';

  @override
  String get gigNewProfessional => 'ନୂଆ ବୃତ୍ତିଗତ';

  @override
  String gigRatingWithCount(String rating, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countଟି ସମୀକ୍ଷା',
      one: '1ଟି ସମୀକ୍ଷା',
    );
    return '$rating ($_temp0)';
  }

  @override
  String get gigPricing => 'ମୂଲ୍ୟ';

  @override
  String get gigServiceRate => 'ସେବା ଦର';

  @override
  String get gigFinalAmountNote =>
      'ଅନ୍ତିମ ରାଶି ଆପଣଙ୍କ ବୃତ୍ତିଗତ ନିଶ୍ଚିତ କରନ୍ତି ଏବଂ ବୁକିଂ ତିଆରି ହେବା ପରେ ସେଥିରେ ଦେଖାଯାଏ।';

  @override
  String get gigKycVerified => 'KYC ଯାଞ୍ଚିତ';

  @override
  String get gigBackgroundVerified => 'ପୃଷ୍ଠଭୂମି ଯାଞ୍ଚିତ';

  @override
  String get gigBookNow => 'ଏବେ ବୁକ୍ କରନ୍ତୁ →';

  @override
  String get discoveryTitle => 'ଉପଲବ୍ଧ ବୃତ୍ତିଗତ';

  @override
  String get discoveryMissingDetails => 'ସେବା କିମ୍ବା ସ୍ଥାନ ବିବରଣୀ ନାହିଁ।';

  @override
  String get discoveryLocalExperts => 'ଉପଲବ୍ଧ ସ୍ଥାନୀୟ ବିଶେଷଜ୍ଞ';

  @override
  String get discoveryWithin => 'ଦୂରତା ମଧ୍ୟରେ';

  @override
  String get discoveryNoProviders => 'ନିକଟରେ କୌଣସି ପ୍ରଦାନକାରୀ ଉପଲବ୍ଧ ନାହାନ୍ତି';

  @override
  String get discoveryTryLargerRadius =>
      'ବଡ଼ ସନ୍ଧାନ ଦୂରତା ଚେଷ୍ଟା କରନ୍ତୁ କିମ୍ବା ପରେ ପୁଣି ଦେଖନ୍ତୁ।';

  @override
  String get discoveryLoadFailed =>
      'ନିକଟସ୍ଥ ପ୍ରଦାନକାରୀଙ୍କୁ ଲୋଡ୍ କରାଯାଇପାରିଲା ନାହିଁ।';

  @override
  String discoveryServicesForJob(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ଏହି କାମ ପାଇଁ $countଟି ସେବା',
      one: 'ଏହି କାମ ପାଇଁ 1ଟି ସେବା',
    );
    return '$_temp0';
  }

  @override
  String get discoveryBook => 'ବୁକ୍ କରନ୍ତୁ';

  @override
  String get categoryServiceDetails => 'ସେବା ବିବରଣୀ';

  @override
  String get categoryTagline =>
      'ଆଗରୁ ଜଣାଥିବା ମୂଲ୍ୟ ଓ ସେବା ଗ୍ୟାରେଣ୍ଟି ସହ ଯାଞ୍ଚିତ, ପୃଷ୍ଠଭୂମି-ଯାଞ୍ଚିତ ସ୍ଥାନୀୟ ବିଶେଷଜ୍ଞଙ୍କୁ ବୁକ୍ କରନ୍ତୁ।';

  @override
  String get categoryWhatHelp => 'ଆପଣଙ୍କୁ କେଉଁଥିରେ ସାହାଯ୍ୟ ଦରକାର?';

  @override
  String get categoryDescribeElse => 'ଅନ୍ୟ କିଛି ବର୍ଣ୍ଣନା କରନ୍ତୁ';

  @override
  String get categoryLoadFailed => 'ଏହି ସେବା ଲୋଡ୍ ହୋଇପାରିଲା ନାହିଁ।';

  @override
  String get notificationsTitle => 'ବିଜ୍ଞପ୍ତି ଓ ସତର୍କ ସୂଚନା';

  @override
  String get notificationsEmpty => 'ଆପଣ ସବୁ ଦେଖିସାରିଛନ୍ତି';

  @override
  String get notificationsLoadFailed => 'ବିଜ୍ଞପ୍ତି ଲୋଡ୍ ହୋଇପାରିଲା ନାହିଁ।';

  @override
  String get timeJustNow => 'ଏଇମାତ୍ର';

  @override
  String timeMinutesAgo(Object minutes) {
    return '$minutes ମିନିଟ୍ ପୂର୍ବରୁ';
  }

  @override
  String timeHoursAgo(Object hours) {
    return '$hours ଘଣ୍ଟା ପୂର୍ବରୁ';
  }

  @override
  String get timeYesterday => 'ଗତକାଲି';

  @override
  String get completedTitle => 'ସେବା ସମ୍ପୂର୍ଣ୍ଣ!';

  @override
  String get completedThanks => 'ଆମ ସେବା ବ୍ୟବହାର କରିଥିବାରୁ ଧନ୍ୟବାଦ।';

  @override
  String get completedViewBookings => 'ବୁକିଂ ଦେଖନ୍ତୁ';

  @override
  String get completedBackHome => 'ହୋମ୍‌କୁ ଫେରନ୍ତୁ';

  @override
  String commonErrorDetail(Object detail) {
    return 'ତ୍ରୁଟି: $detail';
  }

  @override
  String get reviewTitle => 'ଆପଣଙ୍କ ଅନୁଭୂତିକୁ ରେଟିଂ ଦିଅନ୍ତୁ';

  @override
  String get reviewHeading => 'ଉତ୍ତମ ସେବା!';

  @override
  String get reviewQuestion => 'ଆପଣଙ୍କ ବୃତ୍ତିଗତଙ୍କ ସହ ଅନୁଭୂତି କିପରି ଥିଲା?';

  @override
  String reviewStars(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countଟି ତାରା',
      one: '1ଟି ତାରା',
    );
    return '$_temp0';
  }

  @override
  String get reviewCommentHint => 'ଆପଣଙ୍କ ଅନୁଭୂତି ବିଷୟରେ କୁହନ୍ତୁ...';

  @override
  String get reviewSubmit => 'ସମୀକ୍ଷା ଦାଖଲ କରନ୍ତୁ →';

  @override
  String get materialsTitle => 'ସାମଗ୍ରୀ / ଯନ୍ତ୍ରାଂଶ ଅନୁରୋଧ';

  @override
  String get materialsEmpty =>
      'ଏହି ବୁକିଂ ପାଇଁ କୌଣସି ସାମଗ୍ରୀ ଅନୁରୋଧ ଦାଖଲ ହୋଇନାହିଁ';

  @override
  String materialsQuantityEstimated(Object quantity) {
    return '$quantity · ଆନୁମାନିକ';
  }

  @override
  String materialsQuantityActual(Object quantity) {
    return '$quantity · ପ୍ରକୃତ';
  }

  @override
  String get materialsReject => 'ପ୍ରତ୍ୟାଖ୍ୟାନ କରନ୍ତୁ';

  @override
  String get materialsApprove => 'ଅନୁମୋଦନ କରନ୍ତୁ';

  @override
  String get materialStatusRequested => 'ଅନୁରୋଧ କରାଯାଇଛି';

  @override
  String get materialStatusCustomerReview => 'ଆପଣଙ୍କ ସମୀକ୍ଷା ପାଇଁ ଅପେକ୍ଷା';

  @override
  String get materialStatusApproved => 'ଅନୁମୋଦିତ';

  @override
  String get materialStatusRejected => 'ପ୍ରତ୍ୟାଖ୍ୟାତ';

  @override
  String get materialStatusPurchased => 'କିଣାଯାଇଛି';

  @override
  String get materialStatusCostRecorded => 'ଖର୍ଚ୍ଚ ଲିପିବଦ୍ଧ';

  @override
  String get materialStatusBilled => 'ବିଲ୍‌ରେ ଯୋଡ଼ାଯାଇଛି';

  @override
  String get materialStatusCancelled => 'ବାତିଲ୍';

  @override
  String get commonSaveChanges => 'ପରିବର୍ତ୍ତନ ସେଭ୍ କରନ୍ତୁ';

  @override
  String get profileTitle => 'ମୋ ପ୍ରୋଫାଇଲ୍ ଓ ଆକାଉଣ୍ଟ';

  @override
  String get profileFallbackName => 'ଗ୍ରାହକ ପ୍ରୋଫାଇଲ୍';

  @override
  String get profileLanguage => 'ଭାଷା';

  @override
  String get profileAddresses => 'ସେଭ୍ ହୋଇଥିବା ସେବା ଠିକଣା';

  @override
  String get profileAddressesSubtitle =>
      'ଘର, ଅଫିସ୍ ଓ ଅନ୍ୟ ଠିକଣା ପରିଚାଳନା କରନ୍ତୁ';

  @override
  String get profileHistory => 'ପୂର୍ବ ସେବା ଇତିହାସ';

  @override
  String get profileHistorySubtitle => 'ରସିଦ ଓ ପୂର୍ବ ବୁକିଂ ଦେଖନ୍ତୁ';

  @override
  String get profileSupport => 'ସାହାଯ୍ୟ ଓ ଗ୍ରାହକ ସହାୟତା';

  @override
  String get profileSupportSubtitle =>
      'ଟିକେଟ୍ ତିଆରି କରନ୍ତୁ, ଆମ ଦଳର ଉତ୍ତର ଦେଖନ୍ତୁ';

  @override
  String get editProfileSaved => 'ପ୍ରୋଫାଇଲ୍ ସଫଳତାର ସହ ଅପଡେଟ୍ ହେଲା';

  @override
  String get editProfileTitle => 'ପ୍ରୋଫାଇଲ୍ ସମ୍ପାଦନ କରନ୍ତୁ';

  @override
  String get editProfileFullName => 'ପୂରା ନାମ';

  @override
  String get editProfileNameEmpty => 'ନାମ ଖାଲି ରହିପାରିବ ନାହିଁ';

  @override
  String get editProfileEmail => 'ଇମେଲ୍ ଠିକଣା';

  @override
  String get commonEdit => 'ସମ୍ପାଦନ';

  @override
  String get commonDelete => 'ଡିଲିଟ୍ କରନ୍ତୁ';

  @override
  String get addressesAdd => 'ନୂଆ ଠିକଣା ଯୋଡ଼ନ୍ତୁ';

  @override
  String get addressesEmpty => 'ଆପଣ ଏପର୍ଯ୍ୟନ୍ତ କୌଣସି ଠିକଣା ସେଭ୍ କରିନାହାନ୍ତି';

  @override
  String get addressesEmptyMessage =>
      'ପରବର୍ତ୍ତୀ ଥର ଶୀଘ୍ର ବୁକ୍ କରିବାକୁ ଏକ ସେବା ଠିକଣା ଯୋଡ଼ନ୍ତୁ।';

  @override
  String get addressesDefaultBadge => 'ଡିଫଲ୍ଟ';

  @override
  String get addressesSetDefault => 'ଡିଫଲ୍ଟ ଭାବେ ସେଟ୍ କରନ୍ତୁ';

  @override
  String get addressesLoadFailed => 'ଠିକଣା ଲୋଡ୍ ହୋଇପାରିଲା ନାହିଁ।';

  @override
  String get addressesLabelSheet => 'ଏହି ଠିକଣାକୁ ନାମ ଦିଅନ୍ତୁ';

  @override
  String get supportTitle => 'ସାହାଯ୍ୟ ଓ ସହାୟତା';

  @override
  String get supportNewTicket => 'ନୂଆ ଟିକେଟ୍';

  @override
  String get supportEmpty => 'ଏପର୍ଯ୍ୟନ୍ତ କୌଣସି ସହାୟତା ଟିକେଟ୍ ନାହିଁ';

  @override
  String get supportEmptyMessage =>
      'ବୁକିଂ କିମ୍ବା ଆପ୍ ବିଷୟରେ ସାହାଯ୍ୟ ଦରକାର? ଟିକେଟ୍ ତିଆରି କରନ୍ତୁ, ଆମ ଦଳ ଉତ୍ତର ଦେବ।';

  @override
  String get supportLoadFailed => 'ଆପଣଙ୍କ ସହାୟତା ଟିକେଟ୍ ଲୋଡ୍ ହୋଇପାରିଲା ନାହିଁ।';

  @override
  String get supportStatusOpen => 'ଖୋଲା';

  @override
  String get supportStatusInProgress => 'ଚାଲିଛି';

  @override
  String get supportStatusWaitingForYou => 'ଆପଣଙ୍କ ପାଇଁ ଅପେକ୍ଷା';

  @override
  String get supportStatusResolved => 'ସମାଧାନ ହେଲା';

  @override
  String get supportStatusClosed => 'ବନ୍ଦ';

  @override
  String get supportNewTicketTitle => 'ନୂଆ ସହାୟତା ଟିକେଟ୍';

  @override
  String get supportCategory => 'ବର୍ଗ';

  @override
  String get supportSubject => 'ବିଷୟ';

  @override
  String get supportDescribeIssue => 'ସମସ୍ୟା ବର୍ଣ୍ଣନା କରନ୍ତୁ';

  @override
  String get supportFillSubjectMessage => 'ଦୟାକରି ବିଷୟ ଓ ବାର୍ତ୍ତା ଭରନ୍ତୁ।';

  @override
  String get supportSubmitTicket => 'ଟିକେଟ୍ ଦାଖଲ କରନ୍ତୁ';

  @override
  String get supportTicketTitle => 'ସହାୟତା ଟିକେଟ୍';

  @override
  String get supportNoMessages => 'ଏପର୍ଯ୍ୟନ୍ତ କୌଣସି ବାର୍ତ୍ତା ନାହିଁ';

  @override
  String get supportMessagesLoadFailed => 'ବାର୍ତ୍ତା ଲୋଡ୍ ହୋଇପାରିଲା ନାହିଁ।';

  @override
  String get supportTypeMessage => 'ଏକ ବାର୍ତ୍ତା ଲେଖନ୍ତୁ...';

  @override
  String get supportSend => 'ପଠାନ୍ତୁ';

  @override
  String get pickerEnterAddress =>
      'ଦୟାକରି ଏହି ପିନ୍ ପାଇଁ ଠିକଣା ଦିଅନ୍ତୁ କିମ୍ବା ନିଶ୍ଚିତ କରନ୍ତୁ';

  @override
  String get pickerTitle => 'ସେବା ଠିକଣା ବାଛନ୍ତୁ';

  @override
  String get pickerGettingLocation => 'ଆପଣଙ୍କ ସ୍ଥାନ ଜାଣାଯାଉଛି...';

  @override
  String get pickerPermissionDenied =>
      'ଲୋକେସନ୍ ଅନୁମତି ମିଳିଲା ନାହିଁ — ଠିକଣା ବାଛିବାକୁ ମାନଚିତ୍ରକୁ ନିଜେ ଘୁଞ୍ଚାନ୍ତୁ।';

  @override
  String get pickerConfirmPin => 'ସେବା ପିନ୍ ସ୍ଥାନ ନିଶ୍ଚିତ କରନ୍ତୁ';

  @override
  String get pickerAddressLabel => 'ଘର / ଫ୍ଲାଟ୍ / ରାସ୍ତା ନାମ';

  @override
  String get pickerAddressHint => 'ଯଥା #102, ଗ୍ରୀନ୍ ଏଭେନ୍ୟୁ, ଇନ୍ଦିରାନଗର';

  @override
  String get pickerLandmarkLabel => 'ଚିହ୍ନ (ଇଚ୍ଛାଧୀନ)';

  @override
  String get pickerLandmarkHint => 'ଯଥା HDFC ବ୍ୟାଙ୍କ ATM ପାଖରେ';

  @override
  String get pickerConfirm => 'ସ୍ଥାନ ନିଶ୍ଚିତ କରି ଆଗକୁ ବଢ଼ନ୍ତୁ';

  @override
  String get requestSelectLocation => 'ଦୟାକରି ସେବା ସ୍ଥାନ ବାଛନ୍ତୁ';

  @override
  String requestTitle(Object service) {
    return '$service ଅନୁରୋଧ କରନ୍ତୁ';
  }

  @override
  String get requestServiceAddress => 'ସେବା ଠିକଣା';

  @override
  String get requestDetectingLocation => 'ଆପଣଙ୍କ ସ୍ଥାନ ଚିହ୍ନଟ କରାଯାଉଛି…';

  @override
  String get requestTapToPickLocation => 'ସେବା ସ୍ଥାନ ବାଛିବାକୁ ଟ୍ୟାପ୍ କରନ୍ତୁ';

  @override
  String get requestDescribeIssue => 'ସମସ୍ୟା / କାମ ବର୍ଣ୍ଣନା କରନ୍ତୁ';

  @override
  String get requestDescribeHint =>
      'ଯଥା ବୈଠକଖାନାର ମୁଖ୍ୟ ଛାତ ଲାଇଟ୍ ସୁଇଚ୍ ଅନ୍ କଲେ ଫୁଲିଙ୍ଗ ବାହାରୁଛି।';

  @override
  String get requestDescribeMin =>
      'ଦୟାକରି ସମସ୍ୟାଟି ଅତିକମରେ 10ଟି ଅକ୍ଷରରେ ବର୍ଣ୍ଣନା କରନ୍ତୁ';

  @override
  String get requestAttachPhotos => 'ସମସ୍ୟାର ଫଟୋ ସଂଲଗ୍ନ କରନ୍ତୁ (ଇଚ୍ଛାଧୀନ)';

  @override
  String get requestAddPhoto => 'ଫଟୋ ଯୋଡ଼ନ୍ତୁ';

  @override
  String get requestWhen => 'ଆପଣଙ୍କୁ ସେବା କେବେ ଦରକାର?';

  @override
  String get requestInstant => '⚡ ତୁରନ୍ତ (30 ମିନିଟ୍)';

  @override
  String get requestScheduleLater => '📅 ପରେ ପାଇଁ ନିର୍ଦ୍ଧାରଣ କରନ୍ତୁ';

  @override
  String get requestFindWorkers => 'ଉପଲବ୍ଧ କର୍ମୀ ଖୋଜନ୍ତୁ';

  @override
  String commonLoadFailedDetail(Object detail) {
    return 'ଲୋଡ୍ ହୋଇପାରିଲା ନାହିଁ: $detail';
  }

  @override
  String get myRequestsTitle => 'ମୋ ସେବା ଅନୁରୋଧ';

  @override
  String get myRequestsTabAll => 'ସବୁ';

  @override
  String get myRequestsNew => 'ନୂଆ ଅନୁରୋଧ';

  @override
  String get myRequestsNoActive => 'କୌଣସି ସକ୍ରିୟ ଅନୁରୋଧ ନାହିଁ';

  @override
  String get myRequestsNoCompleted => 'କୌଣସି ସମ୍ପୂର୍ଣ୍ଣ ଅନୁରୋଧ ନାହିଁ';

  @override
  String get myRequestsNone => 'ଏପର୍ଯ୍ୟନ୍ତ କୌଣସି ସେବା ଅନୁରୋଧ ନାହିଁ';

  @override
  String get myRequestsEmptyMessage =>
      'ଆପଣଙ୍କ ଆବଶ୍ୟକତା ପୋଷ୍ଟ କରନ୍ତୁ, କର୍ମୀମାନେ ଆପଣଙ୍କ ପାଖକୁ ଆସିବେ।';

  @override
  String get requestDetailTitle => 'ଅନୁରୋଧ ବିବରଣୀ';

  @override
  String get requestDetailBudget => 'ବଜେଟ୍';

  @override
  String get requestDetailSchedule => 'ସମୟସୂଚୀ';

  @override
  String get requestDetailLocation => 'ସ୍ଥାନ';

  @override
  String get requestDetailNotes => 'ଟିପ୍ପଣୀ';

  @override
  String get requestDetailCancel => 'ଅନୁରୋଧ ବାତିଲ୍ କରନ୍ତୁ';

  @override
  String requestDetailOffersReceived(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countଟି ଅଫର୍ ମିଳିଛି',
      one: '1ଟି ଅଫର୍ ମିଳିଛି',
      zero: 'ଏପର୍ଯ୍ୟନ୍ତ କୌଣସି ଅଫର୍ ନାହିଁ',
    );
    return '$_temp0';
  }

  @override
  String get requestDetailTapToCompare =>
      'ଦେଖିବା ଓ ତୁଳନା କରିବାକୁ ଟ୍ୟାପ୍ କରନ୍ତୁ';

  @override
  String get requestDetailWorkersSoon =>
      'କର୍ମୀମାନେ ଶୀଘ୍ର ଉତ୍ତର ଦେବା ଆରମ୍ଭ କରିବେ';

  @override
  String get requestCancelDialogTitle => 'ଏହି ଅନୁରୋଧ ବାତିଲ୍ କରିବେ?';

  @override
  String get requestCancelDialogBody =>
      'ସମସ୍ତ ବାକି ଅଫର୍ ବନ୍ଦ ହୋଇଯିବ। ଏହାକୁ ଫେରାଇ ହେବ ନାହିଁ।';

  @override
  String get requestCancelKeep => 'ରଖନ୍ତୁ';

  @override
  String get requestCancelConfirm => 'ଅନୁରୋଧ ବାତିଲ୍ କରନ୍ତୁ';

  @override
  String get requestCancelled => 'ଅନୁରୋଧ ବାତିଲ୍ ହେଲା';

  @override
  String requestExpiresInDaysHours(int days, int hours) {
    return '$days ଦିନ $hours ଘଣ୍ଟାରେ ମିଆଦ ଶେଷ';
  }

  @override
  String requestExpiresInHoursMinutes(int hours, int minutes) {
    return '$hours ଘଣ୍ଟା $minutes ମିନିଟ୍‌ରେ ମିଆଦ ଶେଷ';
  }

  @override
  String requestExpiresInMinutes(Object minutes) {
    return '$minutes ମିନିଟ୍‌ରେ ମିଆଦ ଶେଷ';
  }

  @override
  String get requestExpiresSoon => 'ଶୀଘ୍ର ମିଆଦ ଶେଷ ହେବ';

  @override
  String get commonCancel => 'ବାତିଲ୍ କରନ୍ତୁ';

  @override
  String get offersTitle => 'ମିଳିଥିବା ଅଫର୍';

  @override
  String get offersEmptyMessage =>
      'କର୍ମୀମାନେ ଆପଣଙ୍କ ଅନୁରୋଧ ଦେଖୁଛନ୍ତି। କେହି ଉତ୍ତର ଦେଲେ ଆପଣଙ୍କୁ ଜଣାଯିବ।';

  @override
  String get offersPending => 'ବାକି ଅଫର୍';

  @override
  String get offersPast => 'ପୂର୍ବ ଅଫର୍';

  @override
  String offersJobsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countଟି କାମ',
      one: '1ଟି କାମ',
    );
    return '$_temp0';
  }

  @override
  String get offersInsured => 'ବୀମାଭୁକ୍ତ';

  @override
  String get offersDecline => 'ମନା କରନ୍ତୁ';

  @override
  String get offersAcceptOffer => 'ଅଫର୍ ଗ୍ରହଣ କରନ୍ତୁ';

  @override
  String get offersAcceptDialogTitle => 'ଏହି ଅଫର୍ ଗ୍ରହଣ କରିବେ?';

  @override
  String offersAcceptDialogBody(String worker, String price) {
    return '$worker ଙ୍କ ସହ $price ରେ ବୁକିଂ ତିଆରି ହେବ। ବାକି ସମସ୍ତ ଅଫର୍ ବନ୍ଦ ହୋଇଯିବ।';
  }

  @override
  String get offersAccept => 'ଗ୍ରହଣ କରନ୍ତୁ';

  @override
  String offersBookingCreated(Object code) {
    return 'ବୁକିଂ $code ତିଆରି ହେଲା!';
  }

  @override
  String get commonNext => 'ପରବର୍ତ୍ତୀ';

  @override
  String postRequestPosted(Object code) {
    return 'ସେବା ଅନୁରୋଧ $code ପୋଷ୍ଟ ହେଲା!';
  }

  @override
  String get postRequestTitle => 'ସେବା ଅନୁରୋଧ ପୋଷ୍ଟ କରନ୍ତୁ';

  @override
  String get postRequestWhatService => 'ଆପଣଙ୍କୁ କେଉଁ ସେବା ଦରକାର?';

  @override
  String get postRequestSelectCategory =>
      'ଆପଣଙ୍କ ଆବଶ୍ୟକତାକୁ ସର୍ବୋତ୍ତମ ଭାବେ ବର୍ଣ୍ଣନା କରୁଥିବା ବର୍ଗ ବାଛନ୍ତୁ।';

  @override
  String get postRequestDescribe => 'ଆପଣଙ୍କ ଆବଶ୍ୟକତା ବର୍ଣ୍ଣନା କରନ୍ତୁ';

  @override
  String postRequestServiceLabel(Object service) {
    return 'ସେବା: $service';
  }

  @override
  String get postRequestWhatDone => 'ଆପଣ କ\'ଣ କାମ କରାଇବାକୁ ଚାହାଁନ୍ତି?';

  @override
  String get postRequestFieldTitle => 'ଶୀର୍ଷକ';

  @override
  String get postRequestTitleHint => 'ଯଥା ରୋଷେଇ ଘରର ଲିକ୍ ହେଉଥିବା କଳ ଠିକ୍ କରିବା';

  @override
  String postRequestMinChars(Object count) {
    return 'ଅତିକମରେ $countଟି ଅକ୍ଷର ଦିଅନ୍ତୁ';
  }

  @override
  String get postRequestFieldDescription => 'ବିବରଣୀ';

  @override
  String get postRequestDescriptionHint =>
      'ସମସ୍ୟାଟି ବିସ୍ତୃତ ଭାବେ ବର୍ଣ୍ଣନା କରନ୍ତୁ…';

  @override
  String get postRequestFieldNotes => 'ଅତିରିକ୍ତ ଟିପ୍ପଣୀ (ଇଚ୍ଛାଧୀନ)';

  @override
  String get postRequestNotesHint => 'ଗେଟ୍ କୋଡ୍, ପସନ୍ଦର ସମୟ ଇତ୍ୟାଦି';

  @override
  String get postRequestBudgetTitle => 'ଆପଣଙ୍କ ବଜେଟ୍';

  @override
  String get postRequestBudgetHint =>
      'ଆପଣ କେତେ ଦେବାକୁ ଇଚ୍ଛୁକ ତାହା କର୍ମୀମାନଙ୍କୁ ଜଣାନ୍ତୁ।';

  @override
  String get postRequestFixedPrice => 'ସ୍ଥିର ମୂଲ୍ୟ (₹)';

  @override
  String postRequestExample(Object example) {
    return 'ଯଥା $example';
  }

  @override
  String get postRequestMin => 'ସର୍ବନିମ୍ନ (₹)';

  @override
  String get postRequestMax => 'ସର୍ବାଧିକ (₹)';

  @override
  String get postRequestWhenTitle => 'ଆପଣଙ୍କୁ ଏହା କେବେ ଦରକାର?';

  @override
  String get postRequestPickDate => 'ଏକ ତାରିଖ ବାଛନ୍ତୁ';

  @override
  String get postRequestLocationTitle => 'ସେବା ସ୍ଥାନ';

  @override
  String get postRequestAddressPrivate =>
      'ଆପଣ ଅଫର୍ ଗ୍ରହଣ କରିବା ପରେ ହିଁ ଆପଣଙ୍କ ସଠିକ୍ ଠିକଣା ସେୟାର୍ ହୁଏ।';

  @override
  String get postRequestFullAddress => 'ପୂରା ଠିକଣା';

  @override
  String get postRequestValidAddress => 'ଏକ ବୈଧ ଠିକଣା ଦିଅନ୍ତୁ';

  @override
  String get postRequestCity => 'ସହର';

  @override
  String get postRequestCityHint => 'ଯଥା ବେଙ୍ଗାଲୁରୁ';

  @override
  String get postRequestPincode => 'ପିନକୋଡ୍';

  @override
  String get postRequestLocationSet => 'ସ୍ଥାନ ସେଟ୍ ହେଲା ✓';

  @override
  String get postRequestSetOnMap => 'ମାନଚିତ୍ରରେ ସ୍ଥାନ ସେଟ୍ କରନ୍ତୁ';

  @override
  String get postRequestReviewTitle => 'ଆପଣଙ୍କ ଅନୁରୋଧ ଯାଞ୍ଚ କରନ୍ତୁ';

  @override
  String get postRequestNotSelected => 'ବଛାଯାଇନାହିଁ';

  @override
  String get postRequestWhen => 'କେବେ';

  @override
  String get postRequestPrivacyNote =>
      'ଆପଣ ଅଫର୍ ଗ୍ରହଣ କରି ବୁକିଂ ତିଆରି ନହେବା ପର୍ଯ୍ୟନ୍ତ ଆପଣଙ୍କ ସଠିକ୍ ଠିକଣା ଗୋପନ ରହେ।';

  @override
  String get postRequestSubmit => 'ଅନୁରୋଧ ଦାଖଲ କରନ୍ତୁ';

  @override
  String get assistantOpening =>
      'ନିଜ ଭାଷାରେ କୁହନ୍ତୁ କ\'ଣ ଖରାପ ହୋଇଛି — ମୁଁ ସେଥିପାଇଁ ଠିକ୍ ବୃତ୍ତିଗତଙ୍କୁ ଖୋଜିଦେବି।';

  @override
  String assistantCatalogueFailed(Object reason) {
    return '$reason ଏହାର ଉତ୍ତର ଦେବାକୁ ମୋତେ ସେବା ତାଲିକା ଦରକାର।';
  }

  @override
  String get assistantCatalogueError =>
      'ସେବା ତାଲିକା ଲୋଡ୍ କରିବାରେ କିଛି ଭୁଲ ହେଲା।';

  @override
  String get assistantGreeting =>
      'ନମସ୍କାର। ଘରେ ଆପଣଙ୍କୁ କେଉଁଥିରେ ସାହାଯ୍ୟ ଦରକାର? ଲିକ୍ ହେଉଥିବା କଳ, ଥଣ୍ଡା କରୁନଥିବା AC, ଫୁଲିଙ୍ଗ ଦେଉଥିବା ସୁଇଚ୍ — ଯାହା ବି ହେଉ, ଯେପରି ଇଚ୍ଛା ବର୍ଣ୍ଣନା କରନ୍ତୁ।';

  @override
  String get assistantTooVague =>
      'ମୁଁ ସାହାଯ୍ୟ କରିପାରିବି — କେବଳ ସମସ୍ୟାଟି କ\'ଣ ଜାଣିବା ଦରକାର। କ\'ଣ କାମ କରୁନାହିଁ?';

  @override
  String assistantMultipleJobs(int count) {
    return 'ଏଗୁଡ଼ିକ $countଟି ଅଲଗା କାମ ପରି ଲାଗୁଛି — ଏଥିପାଇଁ ଅଲଗା ଅଲଗା କାରିଗର ଦରକାର। ପ୍ରତ୍ୟେକଟି ଏଠାରେ:';
  }

  @override
  String get assistantAmbiguous =>
      'ମୁଁ ଏହାକୁ ଠିକ୍ କରିବାକୁ ଚାହେଁ — ଏହା ଏକାଧିକ କାମରେ ପଡ଼ିପାରେ। କେଉଁଟି ଅଧିକ ନିକଟ?';

  @override
  String get assistantUnmatched =>
      'ପ୍ଲାଟଫର୍ମର କୌଣସି ସେବା ସହ ଏହାକୁ ମିଳାଇପାରିଲି ନାହିଁ। ସବୁଠାରୁ ନିକଟଟି ବାଛନ୍ତୁ, ମୁଁ ଆପଣଙ୍କ ବର୍ଣ୍ଣନା ସେଠାକୁ ନେବି — କିମ୍ବା ଅନୁରୋଧ ଭାବେ ପୋଷ୍ଟ କରନ୍ତୁ, ବୃତ୍ତିଗତମାନେ ଆପଣଙ୍କ ପାଖକୁ ଆସିବେ।';

  @override
  String assistantConfidentWithProblem(String service, String problem) {
    return 'ଏହା $service କାମ ପରି ଲାଗୁଛି — ସମ୍ଭବତଃ \"$problem\"।';
  }

  @override
  String assistantConfident(Object service) {
    return 'ଏହା $service କାମ ପରି ଲାଗୁଛି।';
  }

  @override
  String assistantChosen(Object service) {
    return 'ଠିକ୍ ଅଛି, $service। ଆପଣ ଲେଖିଥିବା ବର୍ଣ୍ଣନା ସେପରି ହିଁ ପଠାଯିବ।';
  }

  @override
  String get assistantTitle => 'ସେବା ସହାୟକ';

  @override
  String get assistantSubtitle => 'ଆପଣଙ୍କ ସମସ୍ୟା ପାଇଁ ଠିକ୍ କାମ ଖୋଜେ';

  @override
  String get assistantStartOver => 'ପୁଣି ଆରମ୍ଭ କରନ୍ତୁ';

  @override
  String assistantMatchedOn(Object terms) {
    return 'ମେଳ ଖାଇଥିବା: $terms';
  }

  @override
  String get assistantFindWorkers => 'କର୍ମୀ ଖୋଜନ୍ତୁ';

  @override
  String get assistantPostRequest => 'ଅନୁରୋଧ ପୋଷ୍ଟ କରନ୍ତୁ';

  @override
  String get assistantInputHint => 'ସମସ୍ୟା ବର୍ଣ୍ଣନା କରନ୍ତୁ...';
}
