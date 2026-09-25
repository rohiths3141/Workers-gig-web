// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Oriya (`or`).
class AppLocalizationsOr extends AppLocalizations {
  AppLocalizationsOr([String locale = 'or']) : super(locale);

  @override
  String get languagePickerTitle => 'ଆପଣଙ୍କ ଭାଷା ବାଛନ୍ତୁ';

  @override
  String get startupMissingConfig => 'ଏହି ବିଲ୍ଡରେ କନଫିଗରେସନ୍ ନାହିଁ।';

  @override
  String startupPassDartDefine(Object keys) {
    return 'ଏଗୁଡ଼ିକୁ --dart-define ସହ ଦିଅନ୍ତୁ:\n\n$keys';
  }

  @override
  String get startupCouldNotStart => 'ଆପ୍ ଆରମ୍ଭ ହୋଇପାରିଲା ନାହିଁ।';

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
  String get eligibilityStepIncomplete =>
      'ଏହି ପଦକ୍ଷେପ ଏପର୍ଯ୍ୟନ୍ତ ସମ୍ପୂର୍ଣ୍ଣ ହୋଇନାହିଁ।';

  @override
  String get errorSessionEnded =>
      'ଆପଣଙ୍କ ସେସନ୍ ଶେଷ ହୋଇଛି। ଦୟାକରି ପୁଣି ସାଇନ୍ ଇନ୍ କରନ୍ତୁ।';

  @override
  String get errorUploadFailed =>
      'ସେହି ଫାଇଲ୍ ଅପଲୋଡ୍ ହୋଇପାରିଲା ନାହିଁ। ପୁଣି ଚେଷ୍ଟା କରନ୍ତୁ।';

  @override
  String get errorServiceUnavailable =>
      'ସେହି ସେବା ଏବେ ଉପଲବ୍ଧ ନାହିଁ। କିଛି ସମୟ ପରେ ପୁଣି ଚେଷ୍ଟା କରନ୍ତୁ।';

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
  String get authErrorPhoneNotEnabledRegion =>
      'ଫୋନ୍ ସାଇନ୍-ଇନ୍ ଚାଲୁ ନାହିଁ, କିମ୍ବା ଏହି ଅଞ୍ଚଳକୁ SMS ଅବରୋଧିତ। Firebase Console ସେଟିଂସ ଯାଞ୍ଚ କରନ୍ତୁ।';

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
  String get scheduleSpecificDate => 'ନିର୍ଦ୍ଦିଷ୍ଟ ତାରିଖ';

  @override
  String get offerStatusSubmitted => 'ଦାଖଲ ହୋଇଛି';

  @override
  String get offerStatusViewed => 'ଗ୍ରାହକ ଦେଖିଛନ୍ତି';

  @override
  String get offerStatusShortlisted => 'ଶର୍ଟଲିଷ୍ଟ ହୋଇଛି';

  @override
  String get offerStatusAccepted => 'ଗ୍ରହଣ ହୋଇଛି ✓';

  @override
  String get offerStatusRejected => 'ବଛାଯାଇନାହିଁ';

  @override
  String get offerStatusWithdrawn => 'ପ୍ରତ୍ୟାହାର ହୋଇଛି';

  @override
  String get offerStatusExpired => 'ମିଆଦ ଶେଷ';

  @override
  String get offerStatusClosed => 'ବନ୍ଦ';

  @override
  String distanceMetresAway(Object metres) {
    return '$metres ମି ଦୂରରେ';
  }

  @override
  String distanceKmAway(Object km) {
    return '$km କିମି ଦୂରରେ';
  }

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
  String get gigErrorTrade => 'ଏହି ସେବା କେଉଁ କାମର ବାଛନ୍ତୁ';

  @override
  String get gigErrorTitleShort =>
      'ଏହି ସେବାକୁ ଅତିକମରେ 6 ଅକ୍ଷରର ସ୍ପଷ୍ଟ ନାମ ଦିଅନ୍ତୁ';

  @override
  String get gigErrorTitleLong => 'ନାମ 120 ଅକ୍ଷରରୁ କମ୍ ରଖନ୍ତୁ';

  @override
  String get gigErrorPrice => 'ଏହି ସେବା ପାଇଁ ଆପଣ କେତେ ନିଅନ୍ତି ଦିଅନ୍ତୁ';

  @override
  String get gigErrorDurationMissing => 'ଏଥିରେ ସାଧାରଣତଃ କେତେ ସମୟ ଲାଗେ?';

  @override
  String get gigErrorDurationShort =>
      'ଆମେ ତାଲିକାଭୁକ୍ତ କରିପାରୁଥିବା ସବୁଠାରୁ ଛୋଟ କାମ 15 ମିନିଟ୍';

  @override
  String get gigErrorDurationLong =>
      'ଆମେ ତାଲିକାଭୁକ୍ତ କରିପାରୁଥିବା ସବୁଠାରୁ ଲମ୍ବା କାମ 14 ଦିନ';

  @override
  String get gigErrorRadius => 'ଯାତ୍ରା ଦୂରତା 1 ରୁ 100 କିମି ମଧ୍ୟରେ ହେବା ଉଚିତ';

  @override
  String get jobAreaNearby => 'ନିକଟରେ';

  @override
  String get jobBlockerVerifyArrival =>
      'ଗ୍ରାହକଙ୍କ କୋଡ୍ ଦ୍ୱାରା ପହଞ୍ଚିବା ଯାଞ୍ଚ କରନ୍ତୁ';

  @override
  String get jobBlockerAfterPhoto => 'ଶେଷ ହୋଇଥିବା କାମର ଫଟୋ ଯୋଡ଼ନ୍ତୁ';

  @override
  String jobBlockerMaterialsPending(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countଟି ସାମଗ୍ରୀ ଅନୁରୋଧ ଏବେ ବି ଗ୍ରାହକଙ୍କ ପାଇଁ ଅପେକ୍ଷା କରୁଛି',
      one: '1ଟି ସାମଗ୍ରୀ ଅନୁରୋଧ ଏବେ ବି ଗ୍ରାହକଙ୍କ ପାଇଁ ଅପେକ୍ଷା କରୁଛି',
    );
    return '$_temp0';
  }

  @override
  String mediaTypeNotAccepted(Object kinds) {
    return 'ଏଠାରେ ସେହି ପ୍ରକାର ଫାଇଲ୍ ଗ୍ରହଣୀୟ ନୁହେଁ। $kinds ବ୍ୟବହାର କରନ୍ତୁ।';
  }

  @override
  String get mediaEmpty => 'ସେହି ଫାଇଲ୍ ଖାଲି ଅଛି।';

  @override
  String mediaTooLarge(Object megabytes) {
    return 'ସେହି ଫାଇଲ୍ ବହୁତ ବଡ଼। ସୀମା ${megabytes}MB।';
  }

  @override
  String get verificationNotStarted => 'ଆରମ୍ଭ ହୋଇନାହିଁ';

  @override
  String get verificationSubmitted => 'ଦାଖଲ ହୋଇଛି';

  @override
  String get verificationUnderReview => 'ସମୀକ୍ଷା ଚାଲିଛି';

  @override
  String get verificationMoreInfo => 'ଅଧିକ ସୂଚନା ଦରକାର';

  @override
  String get verificationExpired => 'ମିଆଦ ଶେଷ';

  @override
  String get verificationVerified => 'ଯାଞ୍ଚିତ';

  @override
  String get verificationNotApproved => 'ଅନୁମୋଦିତ ନୁହେଁ';

  @override
  String get verificationNotRequired => 'ଆବଶ୍ୟକ ନାହିଁ';

  @override
  String get qualificationErrorInstitution => 'ଏହା କେଉଁ ସଂସ୍ଥା ଜାରି କଲା?';

  @override
  String get qualificationErrorName => 'ଯୋଗ୍ୟତାର ନାମ କ\'ଣ?';

  @override
  String get qualificationErrorYearMissing =>
      'ଆପଣ ଏହା କେଉଁ ବର୍ଷ ସମ୍ପୂର୍ଣ୍ଣ କଲେ?';

  @override
  String qualificationErrorYearRange(Object year) {
    return '1950 ଓ $year ମଧ୍ୟରେ ଏକ ବର୍ଷ ଦିଅନ୍ତୁ';
  }

  @override
  String get walletTxJobEarning => 'କାମର ଆୟ';

  @override
  String get walletTxMaterialReimbursed => 'ସାମଗ୍ରୀ ଖର୍ଚ୍ଚ ଫେରସ୍ତ';

  @override
  String get walletTxAdjustment => 'ସମାୟୋଜନ';

  @override
  String get walletTxPayoutReturned => 'ପେଆଉଟ୍ ଫେରିଆସିଲା';

  @override
  String get walletTxPlatformFee => 'ପ୍ଲାଟଫର୍ମ ଶୁଳ୍କ';

  @override
  String get walletTxWithdrawn => 'ପ୍ରତ୍ୟାହାର ହୋଇଛି';

  @override
  String get walletTxClaimRecovery => 'ଦାବି ପୁନରୁଦ୍ଧାର';

  @override
  String get payoutStatusRequested => 'ଅନୁରୋଧ କରାଯାଇଛି';

  @override
  String get payoutStatusProcessing => 'ପ୍ରକ୍ରିୟାରେ';

  @override
  String get payoutStatusPaid => 'ପେମେଣ୍ଟ ହୋଇଛି';

  @override
  String get payoutStatusFailed => 'ବିଫଳ';

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
  String get accountDeletionBySupport =>
      'ଆକାଉଣ୍ଟ ଡିଲିଟ୍ କରିବା କାମ ଆମ ସହାୟତା ଦଳ କରେ। ଅନୁରୋଧ କରନ୍ତୁ, ହୋଇଗଲେ ଆମେ ନିଶ୍ଚିତ କରିବୁ।';

  @override
  String get photoUploadFailed => 'ସେହି ଫଟୋ ଅପଲୋଡ୍ ହୋଇପାରିଲା ନାହିଁ।';

  @override
  String get photoUploadFailedRetry =>
      'ସେହି ଫଟୋ ଅପଲୋଡ୍ ହୋଇପାରିଲା ନାହିଁ। ପୁଣି ଚେଷ୍ଟା କରନ୍ତୁ।';

  @override
  String get locationInvalid => 'ସେହି ସ୍ଥାନ ଠିକ୍ ଲାଗୁନାହିଁ।';

  @override
  String get travelDistanceRange =>
      '1 ରୁ 100 କିମି ମଧ୍ୟରେ ଯାତ୍ରା ଦୂରତା ବାଛନ୍ତୁ।';

  @override
  String get profileLoadFailed => 'ଆପଣଙ୍କ ପ୍ରୋଫାଇଲ୍ ଲୋଡ୍ ହୋଇପାରିଲା ନାହିଁ।';

  @override
  String get uploadIncomplete =>
      'ଅପଲୋଡ୍ ସମ୍ପୂର୍ଣ୍ଣ ହେଲା ନାହିଁ। ପୁଣି ଚେଷ୍ଟା କରନ୍ତୁ।';

  @override
  String get uploadTooLarge => 'ସେହି ଫାଇଲ୍ ବହୁତ ବଡ଼।';

  @override
  String get uploadTypeNotAccepted => 'ସେହି ପ୍ରକାର ଫାଇଲ୍ ଗ୍ରହଣୀୟ ନୁହେଁ।';

  @override
  String get uploadRefused => 'ସେହି ଫାଇଲ୍ ପ୍ରତ୍ୟାଖ୍ୟାନ ହେଲା।';

  @override
  String get uploadTooMany =>
      'ଏକାସାଙ୍ଗରେ ଅନେକ ଅପଲୋଡ୍। ଟିକେ ଅପେକ୍ଷା କରି ପୁଣି ଚେଷ୍ଟା କରନ୍ତୁ।';

  @override
  String get uploadGone =>
      'ସେହି ଅପଲୋଡ୍ ଆଉ ଉପଲବ୍ଧ ନାହିଁ। ଫାଇଲ୍‌ଟି ପୁଣି ବାଛନ୍ତୁ।';

  @override
  String get uploadDidNotStart => 'ଅପଲୋଡ୍ ଆରମ୍ଭ ହେଲା ନାହିଁ।';

  @override
  String get uploadDidNotFinish => 'ସେହି ଅପଲୋଡ୍ ଶେଷ ହେଲା ନାହିଁ।';

  @override
  String get claimResponseTooShort =>
      'ଦୟାକରି କ\'ଣ ହେଲା ଟିକେ ଅଧିକ ବିସ୍ତାରରେ କୁହନ୍ତୁ।';

  @override
  String get walletLoadFailedRetry =>
      'ଆପଣଙ୍କ ୱାଲେଟ୍ ଲୋଡ୍ ହୋଇପାରିଲା ନାହିଁ। ଦୟାକରି ପୁଣି ଚେଷ୍ଟା କରନ୍ତୁ।';

  @override
  String get walletLoadFailed => 'ଆପଣଙ୍କ ୱାଲେଟ୍ ଲୋଡ୍ ହୋଇପାରିଲା ନାହିଁ।';

  @override
  String get onboardingStepDetails => 'ଆପଣଙ୍କ ବିବରଣୀ';

  @override
  String get onboardingStepTrade => 'ଆପଣଙ୍କ ମୁଖ୍ୟ କାମ';

  @override
  String get onboardingStepSkills => 'ଆପଣ କ\'ଣ କରିପାରନ୍ତି';

  @override
  String get onboardingStepArea => 'ଆପଣ କେଉଁଠି କାମ କରନ୍ତି';

  @override
  String get onboardingStepKyc => 'ପରିଚୟ ଯାଞ୍ଚ';

  @override
  String get onboardingStepReady => 'କାମ ପାଇଁ ପ୍ରସ୍ତୁତ';

  @override
  String routerScreenNotFound(Object location) {
    return 'ସେହି ସ୍କ୍ରିନ୍ ଖୋଲିପାରିଲା ନାହିଁ।\n$location';
  }

  @override
  String get cameraOpenFailed =>
      'କ୍ୟାମେରା ଖୋଲିପାରିଲା ନାହିଁ। ଆପ୍ ଅନୁମତି ଯାଞ୍ଚ କରନ୍ତୁ।';

  @override
  String get commonTryAgain => 'ପୁଣି ଚେଷ୍ଟା କରନ୍ତୁ';

  @override
  String get commonCancel => 'ବାତିଲ୍ କରନ୍ତୁ';

  @override
  String get commonConfirm => 'ନିଶ୍ଚିତ କରନ୍ତୁ';

  @override
  String get offlineBanner =>
      'ଆପଣ ଅଫଲାଇନ୍ ଅଛନ୍ତି। ପୁଣି ସଂଯୁକ୍ତ ହେଲେ କାମର କାର୍ଯ୍ୟ ପୁଣି ଚାଲିବ।';

  @override
  String get badgeNew => 'ନୂଆ';

  @override
  String get badgeAccepted => 'ଗ୍ରହଣ ହୋଇଛି';

  @override
  String get badgeConfirmed => 'ନିଶ୍ଚିତ';

  @override
  String get badgeOnTheWay => 'ବାଟରେ';

  @override
  String get badgeArrived => 'ପହଞ୍ଚିଲେ';

  @override
  String get badgeWorking => 'କାମ ଚାଲିଛି';

  @override
  String get badgeAwaitingCustomer => 'ଗ୍ରାହକଙ୍କ ପାଇଁ ଅପେକ୍ଷା';

  @override
  String get badgeDone => 'ସମ୍ପୂର୍ଣ୍ଣ';

  @override
  String get badgePaymentDue => 'ପେମେଣ୍ଟ ବାକି';

  @override
  String get badgePaid => 'ପେମେଣ୍ଟ ହୋଇଛି';

  @override
  String get badgeClosed => 'ବନ୍ଦ';

  @override
  String get badgeCancelled => 'ବାତିଲ୍';

  @override
  String get badgeDisputed => 'ବିବାଦୀୟ';

  @override
  String get badgeExpired => 'ମିଆଦ ଶେଷ';

  @override
  String get badgeDraft => 'ଡ୍ରାଫ୍ଟ';

  @override
  String get badgeInReview => 'ସମୀକ୍ଷାରେ';

  @override
  String get badgeLive => 'ଲାଇଭ୍';

  @override
  String get badgePaused => 'ବିରତ';

  @override
  String get badgeNotApproved => 'ଅନୁମୋଦିତ ନୁହେଁ';

  @override
  String get badgeRemoved => 'ହଟାଯାଇଛି';

  @override
  String get badgeNotStarted => 'ଆରମ୍ଭ ହୋଇନାହିଁ';

  @override
  String get badgeSubmitted => 'ଦାଖଲ ହୋଇଛି';

  @override
  String get badgeActionNeeded => 'କାର୍ଯ୍ୟ ଆବଶ୍ୟକ';

  @override
  String get badgeVerified => 'ଯାଞ୍ଚିତ';

  @override
  String get badgeNotRequired => 'ଆବଶ୍ୟକ ନାହିଁ';

  @override
  String get commonContinue => 'ଜାରି ରଖନ୍ତୁ';

  @override
  String get commonSaving => 'ସେଭ୍ ହେଉଛି…';

  @override
  String get welcomePromiseWorkTitle => 'ଉପଯୁକ୍ତ କାମ ପାଆନ୍ତୁ';

  @override
  String get welcomePromiseWorkBody =>
      'ଆପଣଙ୍କ ନିକଟର କାମ, ଆପଣ ପ୍ରକୃତରେ କରୁଥିବା କାମ ସହ ମେଳ ଖାଉଥିବା।';

  @override
  String get welcomePromiseSkillsTitle => 'ଆପଣଙ୍କ ଦକ୍ଷତା ପ୍ରମାଣ କରନ୍ତୁ';

  @override
  String get welcomePromiseSkillsBody =>
      'ଆପଣଙ୍କ ITI ଓ ଡିପ୍ଲୋମା ପ୍ରମାଣପତ୍ର, ଥରେ ଯାଞ୍ଚ କରି ପ୍ରତ୍ୟେକ ଗ୍ରାହକଙ୍କୁ ଦେଖାଯାଏ।';

  @override
  String get welcomePromiseTrackTitle => 'ପ୍ରତ୍ୟେକ କାମ ଟ୍ରାକ୍ କରନ୍ତୁ';

  @override
  String get welcomePromiseTrackBody =>
      'କାମ ଗ୍ରହଣଠାରୁ ଶେଷ କରିବା ପର୍ଯ୍ୟନ୍ତ, ପ୍ରତ୍ୟେକ ପଦକ୍ଷେପରେ ଫଟୋ ରେକର୍ଡ ସହ।';

  @override
  String get welcomePromisePaidTitle => 'ସୁରକ୍ଷିତ ଭାବେ ଟଙ୍କା ପାଆନ୍ତୁ';

  @override
  String get welcomePromisePaidBody =>
      'ପ୍ରତ୍ୟେକ ଟଙ୍କା ଲିପିବଦ୍ଧ, ସ୍ପଷ୍ଟ ଷ୍ଟେଟମେଣ୍ଟ ସହ ଏବଂ ଆପଣଙ୍କ ସର୍ତ୍ତରେ ଟଙ୍କା ଉଠାଣ।';

  @override
  String get welcomeHeadline => 'କାମ ଯାହା ଆପଣଙ୍କୁ ଖୋଜେ';

  @override
  String get welcomeSubtitle =>
      'Wervexa ଦକ୍ଷ ବୃତ୍ତିଗତଙ୍କୁ ସେମାନଙ୍କ ଆବଶ୍ୟକତା ଥିବା ଗ୍ରାହକଙ୍କ ସହ ଯୋଡ଼େ।';

  @override
  String get welcomeGetStarted => 'ଆରମ୍ଭ କରନ୍ତୁ';

  @override
  String get welcomeCodeNotice =>
      'ଆମେ ଆପଣଙ୍କ ମୋବାଇଲ୍ ନମ୍ବରକୁ ଏକ ଥର ବ୍ୟବହାର୍ଯ୍ୟ କୋଡ୍ ପଠାଇବୁ।';

  @override
  String get phoneTitle => 'ଆପଣଙ୍କ ମୋବାଇଲ୍ ନମ୍ବର କ\'ଣ?';

  @override
  String get phoneSubtitle =>
      'ଏହା ଆପଣ ବୋଲି ନିଶ୍ଚିତ କରିବାକୁ ଆମେ ଏକ ଥର ବ୍ୟବହାର୍ଯ୍ୟ କୋଡ୍ ପଠାଇବୁ।';

  @override
  String get phoneSendCode => 'କୋଡ୍ ପଠାନ୍ତୁ';

  @override
  String get phoneSending => 'ପଠାଯାଉଛି…';

  @override
  String get authNewCodeSent => 'ଆମେ ଏକ ନୂଆ କୋଡ୍ ପଠାଇଛୁ।';

  @override
  String get otpTitle => 'କୋଡ୍ ଦିଅନ୍ତୁ';

  @override
  String otpSentTo(Object phone) {
    return 'ଆମେ $phone କୁ 6 ଅଙ୍କର କୋଡ୍ ପଠାଇଛୁ।';
  }

  @override
  String otpResendIn(int seconds) {
    String _temp0 = intl.Intl.pluralLogic(
      seconds,
      locale: localeName,
      other: 'ଆପଣ $seconds ସେକେଣ୍ଡରେ ନୂଆ କୋଡ୍ ମାଗିପାରିବେ',
      one: 'ଆପଣ 1 ସେକେଣ୍ଡରେ ନୂଆ କୋଡ୍ ମାଗିପାରିବେ',
    );
    return '$_temp0';
  }

  @override
  String get otpSendNew => 'ନୂଆ କୋଡ୍ ପଠାନ୍ତୁ';

  @override
  String get otpVerify => 'ଯାଞ୍ଚ କରନ୍ତୁ';

  @override
  String get otpVerifying => 'ଯାଞ୍ଚ ହେଉଛି…';

  @override
  String get registerNameRequired => 'ଦୟାକରି ଆପଣଙ୍କ ପୂରା ନାମ ଦିଅନ୍ତୁ';

  @override
  String get registerEmailInvalid => 'ଦୟାକରି ଏକ ବୈଧ ଇମେଲ୍ ଠିକଣା ଦିଅନ୍ତୁ';

  @override
  String get registerTitle => 'ଆମେ ଆପଣଙ୍କୁ କ\'ଣ ବୋଲି ଡାକିବୁ?';

  @override
  String get registerSubtitle => 'ଗ୍ରାହକମାନେ ଏହି ନାମ ହିଁ ଦେଖିବେ।';

  @override
  String get registerNameLabel => 'ପୂରା ନାମ';

  @override
  String get registerNameHint => 'ଅରୁଣ କୁମାର';

  @override
  String get registerEmailLabel => 'ଇମେଲ୍ (ଇଚ୍ଛାଧୀନ)';

  @override
  String get registerEmailHelper => 'ରସିଦ ଓ ଷ୍ଟେଟମେଣ୍ଟ ପାଇଁ।';

  @override
  String registerVerifiedPhone(Object phone) {
    return 'ଯାଞ୍ଚିତ: $phone';
  }

  @override
  String get navHome => 'ହୋମ୍';

  @override
  String get navJobs => 'କାମ';

  @override
  String get navWallet => 'ୱାଲେଟ୍';

  @override
  String get navProfile => 'ପ୍ରୋଫାଇଲ୍';

  @override
  String get sessionProfileLoadFailedRetry =>
      'ଆମେ ଆପଣଙ୍କ ପ୍ରୋଫାଇଲ୍ ଲୋଡ୍ କରିପାରିଲୁ ନାହିଁ। ଦୟାକରି ପୁଣି ଚେଷ୍ଟା କରନ୍ତୁ।';

  @override
  String get commonSignOut => 'ସାଇନ୍ ଆଉଟ୍ କରନ୍ତୁ';

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
  String get commonSeeAll => 'ସବୁ ଦେଖନ୍ତୁ';

  @override
  String distanceKm(Object km) {
    return '$km କିମି';
  }

  @override
  String get homeRightNow => 'ଏବେ';

  @override
  String get homeNewWork => 'ନୂଆ କାମ';

  @override
  String homeJobsWaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countଟି କାମ ଆପଣଙ୍କ ଉତ୍ତର ପାଇଁ ଅପେକ୍ଷା କରୁଛି',
      one: '1ଟି କାମ ଆପଣଙ୍କ ଉତ୍ତର ପାଇଁ ଅପେକ୍ଷା କରୁଛି',
    );
    return '$_temp0';
  }

  @override
  String get homeComingUp => 'ଆଗାମୀ';

  @override
  String get homeEarnings => 'ଆୟ';

  @override
  String get homeMyServices => 'ମୋ ସେବା';

  @override
  String get homeVerification => 'ଯାଞ୍ଚ';

  @override
  String get homeSupport => 'ସହାୟତା';

  @override
  String get homeRequests => 'ଅନୁରୋଧ';

  @override
  String get homeMyOffers => 'ମୋ ଅଫର୍';

  @override
  String get homeAddService => 'ସେବା ଯୋଡ଼ନ୍ତୁ';

  @override
  String get homeAddServiceBody =>
      'ଆପଣ ପ୍ରକାଶ କରିଥିବା ସେବା ପାଇଁ ହିଁ ଗ୍ରାହକମାନେ ଆପଣଙ୍କୁ ବୁକ୍ କରିପାରିବେ।';

  @override
  String get homeNotReady => 'ଏପର୍ଯ୍ୟନ୍ତ ସମ୍ପୂର୍ଣ୍ଣ ପ୍ରସ୍ତୁତ ନୁହେଁ';

  @override
  String get homeNotReadyBody =>
      'ଏହି ପଦକ୍ଷେପଗୁଡ଼ିକ ଶେଷ କରନ୍ତୁ, ଆପଣ କାମ ପାଇବା ଆରମ୍ଭ କରିବେ।';

  @override
  String get homeGoodMorning => 'ଶୁଭ ସକାଳ';

  @override
  String get homeGoodAfternoon => 'ଶୁଭ ଅପରାହ୍ନ';

  @override
  String get homeGoodEvening => 'ଶୁଭ ସନ୍ଧ୍ୟା';

  @override
  String get homeNotifications => 'ବିଜ୍ଞପ୍ତି';

  @override
  String get availabilityAvailable => 'ଉପଲବ୍ଧ';

  @override
  String get availabilityAvailableBody => 'ଆପଣ ନୂଆ କାମ ପାଇପାରିବେ।';

  @override
  String get availabilityOnJob => 'କାମରେ';

  @override
  String get availabilityOnJobBody =>
      'ଏହି କାମ ଶେଷ ନହେବା ପର୍ଯ୍ୟନ୍ତ ଆପଣଙ୍କୁ ନୂଆ କାମ ଦିଆଯିବ ନାହିଁ।';

  @override
  String get availabilityOff => 'ବନ୍ଦ';

  @override
  String get availabilityOffBody => 'ଆପଣ ନୂଆ କାମ ପାଇବେ ନାହିଁ।';

  @override
  String get availabilityFinishJob =>
      'ପୁଣି ଉପଲବ୍ଧ ହେବାକୁ ବର୍ତ୍ତମାନର କାମ ଶେଷ କରନ୍ତୁ।';

  @override
  String get availabilityGoOff => 'ଡ୍ୟୁଟି ବନ୍ଦ କରନ୍ତୁ';

  @override
  String get availabilityGoOn => 'ଉପଲବ୍ଧ ହୁଅନ୍ତୁ';

  @override
  String get availabilityBeforeJobs => 'କାମ ପାଇବା ପୂର୍ବରୁ';

  @override
  String get availabilityNowOn => 'ଆପଣ କାମ ପାଇଁ ଉପଲବ୍ଧ।';

  @override
  String get availabilityNowOff => 'ଆପଣ ଡ୍ୟୁଟିରେ ନାହାନ୍ତି।';

  @override
  String get workerStatusSetupIncomplete => 'ସେଟଅପ୍ ଅସମ୍ପୂର୍ଣ୍ଣ';

  @override
  String get workerStatusUnderReview => 'ସମୀକ୍ଷାରେ';

  @override
  String get workerStatusInactive => 'ନିଷ୍କ୍ରିୟ';

  @override
  String get workerStatusRestricted => 'ପ୍ରତିବନ୍ଧିତ';

  @override
  String get workerStatusSuspended => 'ନିଲମ୍ବିତ';

  @override
  String get homeAccount => 'ଆକାଉଣ୍ଟ';

  @override
  String get homeWorkStatus => 'କାମର ସ୍ଥିତି';

  @override
  String get availabilityOffDuty => 'ଡ୍ୟୁଟିରେ ନାହାନ୍ତି';

  @override
  String get earningsThisWeek => 'ଏହି ସପ୍ତାହ';

  @override
  String get earningsThisMonth => 'ଏହି ମାସ';

  @override
  String get jobNextWaitConfirm => 'ଗ୍ରାହକଙ୍କ ନିଶ୍ଚିତକରଣ ପାଇଁ ଅପେକ୍ଷା';

  @override
  String get jobNextStartTravel => 'ଯାତ୍ରା ଆରମ୍ଭ କରନ୍ତୁ';

  @override
  String get jobNextMarkArrived => 'ପହଞ୍ଚିଥିବା ଚିହ୍ନିତ କରନ୍ତୁ';

  @override
  String get jobNextStartWork => 'କାମ ଆରମ୍ଭ କରନ୍ତୁ';

  @override
  String get jobNextAskCode => 'ଗ୍ରାହକଙ୍କୁ ପହଞ୍ଚିବା କୋଡ୍ ମାଗନ୍ତୁ';

  @override
  String get jobNextFinish => 'ଶେଷ କରି ଫଟୋ ଯୋଡ଼ନ୍ତୁ';

  @override
  String get jobNextWaitApprove => 'ଗ୍ରାହକଙ୍କ ଅନୁମୋଦନ ପାଇଁ ଅପେକ୍ଷା';

  @override
  String get jobNextOpen => 'କାମ ଖୋଲନ୍ତୁ';

  @override
  String get jobTimeTbc => 'ସମୟ ନିଶ୍ଚିତ ହେବା ବାକି';

  @override
  String get settingsTitle => 'ସେଟିଂସ';

  @override
  String get settingsLanguage => 'ଭାଷା';

  @override
  String get settingsAbout => 'ବିଷୟରେ';

  @override
  String get settingsTerms => 'ସେବା ସର୍ତ୍ତାବଳୀ';

  @override
  String get settingsPrivacy => 'ଗୋପନୀୟତା ନୀତି';

  @override
  String get settingsHelp => 'ସାହାଯ୍ୟ ଓ ସହାୟତା';

  @override
  String get settingsDeleteAccount => 'ମୋ ଆକାଉଣ୍ଟ ଡିଲିଟ୍ କରନ୍ତୁ';

  @override
  String get settingsSignOutTitle => 'ସାଇନ୍ ଆଉଟ୍ କରିବେ?';

  @override
  String get settingsSignOutBody =>
      'ପୁଣି ସାଇନ୍ ଇନ୍ କରିବାକୁ ଆପଣଙ୍କ ଫୋନ୍ ନମ୍ବର ଓ ଏକ କୋଡ୍ ଦରକାର ହେବ।';

  @override
  String get settingsDeleteTitle => 'ଆପଣଙ୍କ ଆକାଉଣ୍ଟ ଡିଲିଟ୍ କରନ୍ତୁ';

  @override
  String get settingsDeleteBody =>
      'ଆକାଉଣ୍ଟ ଡିଲିଟ୍ କଲେ ଆପଣଙ୍କ କାମ ଇତିହାସ, ଆୟ ରେକର୍ଡ ଓ ଖୋଲା ପେମେଣ୍ଟ ପ୍ରଭାବିତ ହୁଏ, ତେଣୁ ଏହା ସ୍ୱୟଂଚାଳିତ ଭାବେ ନୁହେଁ, ଆମ ସହାୟତା ଦଳ ଦ୍ୱାରା କରାଯାଏ।\n\nସହାୟତା ଅନୁରୋଧ କରନ୍ତୁ, ହୋଇଗଲେ ଆମେ ନିଶ୍ଚିତ କରିବୁ।';

  @override
  String get settingsContactSupport => 'ସହାୟତା ସହ ଯୋଗାଯୋଗ କରନ୍ତୁ';

  @override
  String get notificationsMarkAllRead => 'ସବୁ ପଢ଼ାଯାଇଛି ବୋଲି ଚିହ୍ନିତ କରନ୍ତୁ';

  @override
  String get notificationsEmpty => 'ଆପଣ ସବୁ ଦେଖିସାରିଛନ୍ତି';

  @override
  String get notificationsEmptyBody =>
      'କାମ ଅଫର୍, ପେମେଣ୍ଟ ଅପଡେଟ୍ ଓ ଯାଞ୍ଚ ଫଳାଫଳ ଏଠାରେ ଦେଖାଯିବ।';

  @override
  String get jobsTabUpcoming => 'ଆଗାମୀ';

  @override
  String get jobsTabActive => 'ସକ୍ରିୟ';

  @override
  String get jobsNoOffers => 'ଏବେ କୌଣସି ନୂଆ କାମ ନାହିଁ';

  @override
  String get jobsNoOffersBody =>
      'ଆପଣ ଉପଲବ୍ଧ ଥିବାବେଳେ, ଉପଯୁକ୍ତ କାମ ଆସିବା ମାତ୍ରେ ଆମେ ଜଣାଇବୁ।';

  @override
  String get jobsAccepted => 'କାମ ଗ୍ରହଣ ହେଲା।';

  @override
  String get jobsDeclineTitle => 'ଏହି କାମ ମନା କରିବେ?';

  @override
  String get jobsDeclineBody =>
      'ଏହା ଅନ୍ୟ କର୍ମୀଙ୍କୁ ଦିଆଯିବ। ବାରମ୍ବାର ମନା କଲେ ଆପଣଙ୍କୁ ଦେଖାଯାଉଥିବା କାମ କମିପାରେ।';

  @override
  String get jobsDecline => 'ମନା କରନ୍ତୁ';

  @override
  String get jobsDeclined => 'କାମ ମନା କରାଗଲା।';

  @override
  String get jobsEmptyUpcoming => 'କିଛି ନିର୍ଦ୍ଧାରିତ ନାହିଁ';

  @override
  String get jobsEmptyUpcomingBody => 'ଆପଣ ଗ୍ରହଣ କରିଥିବା କାମ ଏଠାରେ ଦେଖାଯିବ।';

  @override
  String get jobsEmptyActive => 'କୌଣସି କାମ ଚାଲୁନାହିଁ';

  @override
  String get jobsEmptyActiveBody => 'ଆପଣ କାମ ଆରମ୍ଭ କଲେ ଏହା ଏଠାରେ ଦେଖାଯିବ।';

  @override
  String get jobsEmptyCompleted => 'ଏପର୍ଯ୍ୟନ୍ତ କୌଣସି ସମ୍ପୂର୍ଣ୍ଣ କାମ ନାହିଁ';

  @override
  String get jobsEmptyCompletedBody =>
      'ଶେଷ ହୋଇଥିବା କାମ ଓ ସେଥିରୁ ଆପଣଙ୍କ ଆୟ ଏଠାରେ ତାଲିକାଭୁକ୍ତ ହେବ।';

  @override
  String get jobsEmptyCancelled => 'କିଛି ବାତିଲ୍ ହୋଇନାହିଁ';

  @override
  String get jobsEmptyCancelledBody =>
      'ବାତିଲ୍ ହୋଇଥିବା କାମ ଏଠାରେ ତାଲିକାଭୁକ୍ତ ହେବ।';

  @override
  String get jobsEmptyOffers => 'କୌଣସି ଅଫର୍ ନାହିଁ';

  @override
  String get jobsEmptyOffersBody => 'ନୂଆ କାମ ଏଠାରେ ଦେଖାଯିବ।';

  @override
  String get jobTitleFallback => 'କାମ';

  @override
  String jobCancelledReason(Object reason) {
    return 'ବାତିଲ୍: $reason';
  }

  @override
  String get jobAmount => 'କାମର ରାଶି';

  @override
  String get jobMaterials => 'ସାମଗ୍ରୀ';

  @override
  String get jobYouEarned => 'ଆପଣଙ୍କ ଆୟ';

  @override
  String get jobRateCustomer => 'ଗ୍ରାହକଙ୍କୁ ରେଟିଂ ଦିଅନ୍ତୁ';

  @override
  String get jobRateQuestion => 'ଏହି କାମ ଆପଣଙ୍କ ପାଇଁ କିପରି ଥିଲା?';

  @override
  String get jobRate => 'ରେଟିଂ ଦିଅନ୍ତୁ';

  @override
  String get jobHistory => 'କ\'ଣ କ\'ଣ ହେଲା';

  @override
  String get jobHistoryLoadFailed => 'କାମର ଇତିହାସ ଲୋଡ୍ ହୋଇପାରିଲା ନାହିଁ।';

  @override
  String get jobOfferExpired => 'ଏହି କାମ ଆଉ ଉପଲବ୍ଧ ନାହିଁ।';

  @override
  String get jobOfferNewBadge => 'ନୂଆ କାମ';

  @override
  String get jobOfferYouEarn => 'ଆପଣଙ୍କ ଆୟ';

  @override
  String get jobOfferPriceAfterVisit => 'ଆସିବା ପରେ ନିଶ୍ଚିତ ହେବ';

  @override
  String get jobOfferAccept => 'କାମ ଗ୍ରହଣ କରନ୍ତୁ';

  @override
  String get activeJobTitle => 'ବର୍ତ୍ତମାନର କାମ';

  @override
  String get activeJobEmptyBody =>
      'ଆପଣ କାମ ଗ୍ରହଣ କରି ଆରମ୍ଭ କଲେ ଏହା ଏଠାରେ ଦେଖାଯିବ।';

  @override
  String get evidenceBeforeTitle => 'ଆରମ୍ଭ କରିବା ପୂର୍ବରୁ';

  @override
  String get evidenceBeforeBody =>
      'ଛୁଇଁବା ପୂର୍ବରୁ ସମସ୍ୟାର ଫଟୋ ନିଅନ୍ତୁ। ଗ୍ରାହକ ପରେ କାମ ଉପରେ ବିବାଦ କଲେ ଏହା ଆପଣଙ୍କୁ ସୁରକ୍ଷା ଦିଏ।';

  @override
  String get evidenceAfterTitle => 'ଶେଷ କରିବା ପରେ';

  @override
  String get evidenceAfterBody =>
      'ଗ୍ରାହକ ପରେ ବିବାଦ କଲେ ଶେଷ ହୋଇଥିବା କାମର ଫଟୋ ହିଁ ଆପଣଙ୍କ ପ୍ରମାଣ। ଇଚ୍ଛାଧୀନ, କିନ୍ତୁ ଦଶ ସେକେଣ୍ଡ ଦେବା ଉଚିତ।';

  @override
  String get jobCustomerHidden =>
      'ନିଶ୍ଚିତ ହେବା ପରେ ଗ୍ରାହକଙ୍କ ବିବରଣୀ ସେୟାର୍ ହେବ';

  @override
  String get jobCall => 'କଲ୍ କରନ୍ତୁ';

  @override
  String get jobDirections => 'ଦିଗ ନିର୍ଦ୍ଦେଶ';

  @override
  String get jobTrackOnMap => 'ମାନଚିତ୍ରରେ ଟ୍ରାକ୍ କରନ୍ତୁ';

  @override
  String get trailAccepted => 'ଗ୍ରହଣ ହୋଇଛି';

  @override
  String get trailOnTheWay => 'ବାଟରେ';

  @override
  String get trailArrived => 'ପହଞ୍ଚିଲେ';

  @override
  String get trailArrivalConfirmed => 'ପହଞ୍ଚିବା ନିଶ୍ଚିତ';

  @override
  String get trailWorkStarted => 'କାମ ଆରମ୍ଭ ହେଲା';

  @override
  String get trailFinished => 'ଶେଷ ହେଲା';

  @override
  String get jobProgress => 'ପ୍ରଗତି';

  @override
  String get jobBeforeFinish => 'ଶେଷ କରିବା ପୂର୍ବରୁ';

  @override
  String get jobActionStartTravel => 'ଯାତ୍ରା ଆରମ୍ଭ କରନ୍ତୁ';

  @override
  String get jobActionArrived => 'ମୁଁ ପହଞ୍ଚିଗଲି';

  @override
  String get jobActionEnterCode => 'ପହଞ୍ଚିବା କୋଡ୍ ଦିଅନ୍ତୁ';

  @override
  String get jobActionStartWork => 'କାମ ଆରମ୍ଭ କରନ୍ତୁ';

  @override
  String get jobActionFinish => 'କାମ ଶେଷ କରନ୍ତୁ';

  @override
  String get jobArrivalConfirmed => 'ପହଞ୍ଚିବା ନିଶ୍ଚିତ ହେଲା।';

  @override
  String get jobFinishTitle => 'ଏହି କାମ ଶେଷ କରିବେ?';

  @override
  String get jobFinishBody =>
      'ଗ୍ରାହକଙ୍କୁ କାମ ଅନୁମୋଦନ କରିବାକୁ କୁହାଯିବ। ଏହା ପରେ ଆପଣ ଫଟୋ ଯୋଡ଼ିପାରିବେ ନାହିଁ।';

  @override
  String get jobOnYourWay => 'ଆପଣ ବାଟରେ ଅଛନ୍ତି।';

  @override
  String get jobMarkedArrived => 'ପହଞ୍ଚିଥିବା ଚିହ୍ନିତ ହେଲା।';

  @override
  String get jobWorkStarted => 'କାମ ଆରମ୍ଭ ହେଲା।';

  @override
  String get jobSentForApproval => 'ଅନୁମୋଦନ ପାଇଁ ଗ୍ରାହକଙ୍କୁ ପଠାଗଲା।';

  @override
  String get jobUpdated => 'ଅପଡେଟ୍ ହେଲା।';

  @override
  String get jobWaitConfirm => 'ଗ୍ରାହକ ବୁକିଂ ନିଶ୍ଚିତ କରିବା ପାଇଁ ଅପେକ୍ଷା।';

  @override
  String get jobWaitApprove => 'ଗ୍ରାହକ ଆପଣଙ୍କ କାମ ଅନୁମୋଦନ କରିବା ପାଇଁ ଅପେକ୍ଷା।';

  @override
  String get jobWaitPaymentProcessing => 'ଅନୁମୋଦିତ। ପେମେଣ୍ଟ ପ୍ରକ୍ରିୟାରେ ଅଛି।';

  @override
  String get jobWaitPayment => 'ଗ୍ରାହକଙ୍କ ପେମେଣ୍ଟ ପାଇଁ ଅପେକ୍ଷା।';

  @override
  String get jobWaitPaid => 'ପେମେଣ୍ଟ ହେଲା। ଆପଣଙ୍କ ଆୟ ଆପଣଙ୍କ ୱାଲେଟ୍‌ରେ ଦେଖାଯିବ।';

  @override
  String get jobWaitDisputed =>
      'ଆମ ଦଳ ଏହି କାମର ସମୀକ୍ଷା କରୁଛି। ଆମେ ଯୋଗାଯୋଗ କରିବୁ।';

  @override
  String get jobWaitNothing => 'ଏବେ କିଛି କରିବାର ନାହିଁ।';

  @override
  String get travelRouteUnavailable => 'ରାସ୍ତା ଉପଲବ୍ଧ ନାହିଁ';

  @override
  String get travelNoDestination => 'କୌଣସି ଗନ୍ତବ୍ୟ ସେଟ୍ ହୋଇନାହିଁ';

  @override
  String get travelNoDestinationBody =>
      'ଏହି କାମର ରାସ୍ତା ଦେଖାଇବା ପାଇଁ କୌଣସି ସେବା ସ୍ଥାନ ନାହିଁ।';

  @override
  String get travelJobLocation => 'କାମର ସ୍ଥାନ';

  @override
  String get travelYou => 'ଆପଣ';

  @override
  String get travelCustomer => 'ଗ୍ରାହକ';

  @override
  String get travelCalculating => 'ରାସ୍ତା ହିସାବ କରାଯାଉଛି...';

  @override
  String distanceMetres(Object metres) {
    return '$metres ମି';
  }

  @override
  String etaMinutes(Object minutes) {
    return '$minutes ମିନିଟ୍';
  }

  @override
  String etaHours(Object hours) {
    return '$hours ଘଣ୍ଟା';
  }

  @override
  String get arrivalWrongCode => 'ସେହି କୋଡ୍ ଠିକ୍ ନୁହେଁ।';

  @override
  String arrivalWrongCodeAttempts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ସେହି କୋଡ୍ ଠିକ୍ ନୁହେଁ। $countଟି ଚେଷ୍ଟା ବାକି।',
      one: 'ସେହି କୋଡ୍ ଠିକ୍ ନୁହେଁ। 1ଟି ଚେଷ୍ଟା ବାକି।',
    );
    return '$_temp0';
  }

  @override
  String get arrivalTitle => 'ଆପଣ ପହଞ୍ଚିଛନ୍ତି ବୋଲି ନିଶ୍ଚିତ କରନ୍ତୁ';

  @override
  String get arrivalBody =>
      'ଗ୍ରାହକଙ୍କୁ ତାଙ୍କ ଆପ୍‌ର କୋଡ୍ ପଢ଼ି ଶୁଣାଇବାକୁ କୁହନ୍ତୁ, ତାପରେ ଏଠାରେ ଟାଇପ୍ କରନ୍ତୁ।';

  @override
  String get arrivalLocked =>
      'ଅନେକ ଭୁଲ କୋଡ୍। ଏହି କାମ ଜାରି ରଖିବାକୁ ଦୟାକରି ସହାୟତା ସହ ଯୋଗାଯୋଗ କରନ୍ତୁ।';

  @override
  String get arrivalConfirm => 'ପହଞ୍ଚିବା ନିଶ୍ଚିତ କରନ୍ତୁ';

  @override
  String get arrivalNotYet => 'ଏପର୍ଯ୍ୟନ୍ତ ନୁହେଁ';

  @override
  String get rateThanks => 'ଆପଣଙ୍କ ମତାମତ ପାଇଁ ଧନ୍ୟବାଦ।';

  @override
  String get rateTitle => 'ଏହି ଗ୍ରାହକ କିପରି ଥିଲେ?';

  @override
  String get rateBody =>
      'ଆପଣଙ୍କ ରେଟିଂ ଗୋପନ ଏବଂ କର୍ମୀମାନଙ୍କ ଯତ୍ନ ନେବାରେ ଆମକୁ ସାହାଯ୍ୟ କରେ।';

  @override
  String get rateCommentLabel => 'ଆଉ କିଛି କହିବେ? (ଇଚ୍ଛାଧୀନ)';

  @override
  String get rateSubmit => 'ରେଟିଂ ଦାଖଲ କରନ୍ତୁ';

  @override
  String get timerServiceTime => 'ସେବା ସମୟ';

  @override
  String get materialsAdd => 'ଯୋଡ଼ନ୍ତୁ';

  @override
  String get materialsLoadFailed => 'ସାମଗ୍ରୀ ଲୋଡ୍ ହୋଇପାରିଲା ନାହିଁ।';

  @override
  String get materialsEmpty =>
      'ଏହି କାମ ପାଇଁ ଯନ୍ତ୍ରାଂଶ ଦରକାର ହେଲେ ଏଠାରେ ଯୋଡ଼ନ୍ତୁ, ଗ୍ରାହକଙ୍କୁ ଖର୍ଚ୍ଚ ଅନୁମୋଦନ କରିବାକୁ କୁହାଯିବ।';

  @override
  String get materialStatusWaiting => 'ଗ୍ରାହକଙ୍କ ପାଇଁ ଅପେକ୍ଷା';

  @override
  String get materialStatusApproved => 'ଅନୁମୋଦିତ';

  @override
  String get materialStatusDeclined => 'ମନା କରାଗଲା';

  @override
  String get materialStatusBought => 'କିଣାଗଲା';

  @override
  String get materialStatusCostRecorded => 'ଖର୍ଚ୍ଚ ଲିପିବଦ୍ଧ';

  @override
  String get materialStatusBilled => 'ବିଲ୍‌ରେ';

  @override
  String get materialStatusCancelled => 'ବାତିଲ୍';

  @override
  String materialQuantityEstimated(Object quantity, Object unit) {
    return '$quantity $unit · ଆନୁମାନିକ';
  }

  @override
  String materialQuantityActual(Object quantity, Object unit) {
    return '$quantity $unit · ପ୍ରକୃତ';
  }

  @override
  String get materialRecordCost => 'ଖର୍ଚ୍ଚ ଲିପିବଦ୍ଧ କରନ୍ତୁ';

  @override
  String materialCustomerSaid(Object reason) {
    return 'ଗ୍ରାହକ କହିଲେ: $reason';
  }

  @override
  String get materialUnitPiece => 'ଖଣ୍ଡ';

  @override
  String get materialWhatNeeded => 'ଆପଣଙ୍କୁ କ\'ଣ ଦରକାର?';

  @override
  String get materialEnterQuantity => 'କେତୋଟି ଦରକାର ଦିଅନ୍ତୁ';

  @override
  String get materialEnterCost => 'ଆନୁମାନିକ ଖର୍ଚ୍ଚ ଦିଅନ୍ତୁ';

  @override
  String get materialRequestBody =>
      'ଆପଣ କିଣିବା ପୂର୍ବରୁ ଗ୍ରାହକଙ୍କୁ ଏହା ଅନୁମୋଦନ କରିବାକୁ କୁହାଯିବ।';

  @override
  String get materialName => 'ସାମଗ୍ରୀ';

  @override
  String get materialNameHint => 'ଯଥା 16A ମଡ୍ୟୁଲାର୍ ସୁଇଚ୍';

  @override
  String get materialQuantity => 'ପରିମାଣ';

  @override
  String get materialUnit => 'ଏକକ';

  @override
  String get materialExpectedCost => 'ଆନୁମାନିକ ଖର୍ଚ୍ଚ';

  @override
  String get materialAskCustomer => 'ଗ୍ରାହକଙ୍କୁ ପଚାରନ୍ତୁ';

  @override
  String get materialEnterPaid => 'ଆପଣ ଦେଇଥିବା ରାଶି ଦିଅନ୍ତୁ';

  @override
  String get materialCostRecorded => 'ଖର୍ଚ୍ଚ ଲିପିବଦ୍ଧ ହେଲା।';

  @override
  String get materialWhatCost => 'ଏହାର ଖର୍ଚ୍ଚ କେତେ ହେଲା?';

  @override
  String get materialReceiptBody =>
      'ରସିଦ ସଂଲଗ୍ନ କରନ୍ତୁ ଯାହାଦ୍ୱାରା ଏହା ଗ୍ରାହକଙ୍କ ବିଲ୍‌ରେ ଯୋଡ଼ାଯାଇପାରିବ।';

  @override
  String get materialAmountPaid => 'ଦିଆଯାଇଥିବା ରାଶି';

  @override
  String get materialReceipt => 'ରସିଦ';

  @override
  String get materialReceiptRequired => 'ବିଲ୍‌ର ଫଟୋ ଆବଶ୍ୟକ।';

  @override
  String get evidenceDone => 'ସମ୍ପୂର୍ଣ୍ଣ';

  @override
  String get evidenceRequired => 'ଆବଶ୍ୟକ';

  @override
  String get evidenceCamera => 'କ୍ୟାମେରା';

  @override
  String get evidenceGallery => 'ଗ୍ୟାଲେରୀ';

  @override
  String get evidenceSaved => 'ସେଭ୍ ହୋଇଛି';

  @override
  String get uploadWaiting => 'ଅପେକ୍ଷା';

  @override
  String get uploadPreparing => 'ପ୍ରସ୍ତୁତ ହେଉଛି';

  @override
  String get uploadStarting => 'ଅପଲୋଡ୍ ଆରମ୍ଭ ହେଉଛି';

  @override
  String uploadPercent(Object percent) {
    return '$percent%';
  }

  @override
  String get uploadFinishing => 'ଶେଷ ହେଉଛି';

  @override
  String get uploadCancel => 'ଅପଲୋଡ୍ ବାତିଲ୍ କରନ୍ତୁ';

  @override
  String get uploadNotFinished => 'ସେହି ଅପଲୋଡ୍ ଶେଷ ହେଲା ନାହିଁ।';

  @override
  String get commonRetry => 'ପୁଣି ଚେଷ୍ଟା କରନ୍ତୁ';

  @override
  String durationMinutes(Object minutes) {
    return '$minutes ମିନିଟ୍';
  }

  @override
  String durationHours(Object hours) {
    return '$hours ଘଣ୍ଟା';
  }

  @override
  String durationHoursMinutes(Object hours, Object minutes) {
    return '$hours ଘଣ୍ଟା $minutes ମିନିଟ୍';
  }

  @override
  String durationDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ଦିନ',
      one: '1 ଦିନ',
    );
    return '$_temp0';
  }

  @override
  String pricePerHour(Object price) {
    return '$price/ଘଣ୍ଟା';
  }

  @override
  String pricePerDay(Object price) {
    return '$price/ଦିନ';
  }

  @override
  String pricePerUnit(Object price) {
    return '$price/ୟୁନିଟ୍';
  }

  @override
  String pricePerSqft(Object price) {
    return '$price/ବର୍ଗଫୁଟ';
  }

  @override
  String get gigsTitle => 'ମୋ ସେବା';

  @override
  String get gigsAddTooltip => 'ସେବା ଯୋଡ଼ନ୍ତୁ';

  @override
  String get gigsAdd => 'ସେବା ଯୋଡ଼ନ୍ତୁ';

  @override
  String get gigsEmpty => 'ଏପର୍ଯ୍ୟନ୍ତ କୌଣସି ସେବା ନାହିଁ';

  @override
  String get gigsEmptyBody =>
      'ଆପଣ ଦେଉଥିବା ସେବା ଯୋଡ଼ନ୍ତୁ। ଆପଣ ଅନୁମୋଦିତ ଥିବା ସମସ୍ତ କାମରେ ଯେତେ ଇଚ୍ଛା ସେତେ ସେବା ଯୋଡ଼ିପାରିବେ।';

  @override
  String get gigsNoneLive =>
      'ଆପଣଙ୍କ କୌଣସି ସେବା ଲାଇଭ୍ ନାହିଁ, ତେଣୁ ଗ୍ରାହକମାନେ ଆପଣଙ୍କୁ ବୁକ୍ କରିପାରିବେ ନାହିଁ।';

  @override
  String gigsLiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countଟି ସେବା ଲାଇଭ୍ ଅଛି।',
      one: '1ଟି ସେବା ଲାଇଭ୍ ଅଛି।',
    );
    return '$_temp0';
  }

  @override
  String get gigsAvailable => 'ଆପଣ କାମ ପାଇଁ ଉପଲବ୍ଧ।';

  @override
  String get gigsOffDuty =>
      'ଆପଣ ଡ୍ୟୁଟିରେ ନାହାନ୍ତି, ତେଣୁ ଆପଣଙ୍କୁ କାମ ଦିଆଯିବ ନାହିଁ।';

  @override
  String gigJobsDone(int count) {
    return '$countଟି ସମ୍ପୂର୍ଣ୍ଣ';
  }

  @override
  String get gigEdit => 'ସମ୍ପାଦନ';

  @override
  String get gigPause => 'ବିରତ କରନ୍ତୁ';

  @override
  String get gigResume => 'ପୁଣି ଆରମ୍ଭ କରନ୍ତୁ';

  @override
  String get gigInReview => 'ସମୀକ୍ଷାରେ';

  @override
  String get gigDraftHint => 'ଡ୍ରାଫ୍ଟ — ସମୀକ୍ଷା ପାଇଁ ଦାଖଲ କରନ୍ତୁ';

  @override
  String get gigRejectedHint => 'ପ୍ରତ୍ୟାଖ୍ୟାତ — ସମ୍ପାଦନ କରି ପୁଣି ଦାଖଲ କରନ୍ତୁ';

  @override
  String get gigArchived => 'ଆର୍କାଇଭ୍ ହୋଇଛି';

  @override
  String get gigNotLive => 'ଲାଇଭ୍ ନାହିଁ';

  @override
  String get gigPaused => 'ବିରତ ହେଲା। ଆପଣଙ୍କୁ ଏହି କାମ ଦିଆଯିବ ନାହିଁ।';

  @override
  String get gigLiveAgain => 'ପୁଣି ଲାଇଭ୍।';

  @override
  String get gigDuration30m => '30 ମିନିଟ୍';

  @override
  String get gigDuration45m => '45 ମିନିଟ୍';

  @override
  String get gigDuration1h => '1 ଘଣ୍ଟା';

  @override
  String get gigDuration2h => '2 ଘଣ୍ଟା';

  @override
  String get gigDuration4h => '4 ଘଣ୍ଟା';

  @override
  String get gigDuration8h => '8 ଘଣ୍ଟା (ଗୋଟିଏ କାମ ଦିନ)';

  @override
  String get gigDuration24h => '24 ଘଣ୍ଟା';

  @override
  String get gigDuration2d => '2 ଦିନ';

  @override
  String get gigDuration3d => '3 ଦିନ';

  @override
  String get gigDuration1w => '1 ସପ୍ତାହ';

  @override
  String get gigSavedDraft => 'ଡ୍ରାଫ୍ଟ ଭାବେ ସେଭ୍ ହେଲା।';

  @override
  String get gigSubmitted => 'ଦାଖଲ ହେଲା। ଆମେ ସମୀକ୍ଷା କରି ଜଣାଇବୁ।';

  @override
  String get gigLive => 'ଆପଣଙ୍କ ସେବା ଲାଇଭ୍ ଅଛି।';

  @override
  String get gigSaved => 'ସେଭ୍ ହେଲା।';

  @override
  String get gigEditorAddTitle => 'ସେବା ଯୋଡ଼ନ୍ତୁ';

  @override
  String get gigEditorEditTitle => 'ସେବା ସମ୍ପାଦନ କରନ୍ତୁ';

  @override
  String get gigNoTrades => 'ଏପର୍ଯ୍ୟନ୍ତ କୌଣସି ଅନୁମୋଦିତ କାମ ନାହିଁ';

  @override
  String get gigNoTradesBody =>
      'କୌଣସି କାମ ଆପଣଙ୍କ ପାଇଁ ଅନୁମୋଦିତ ହେଲେ, ତା\' ଅଧୀନରେ ସେବା ପ୍ରକାଶ କରିପାରିବେ। ଆରମ୍ଭ କରିବାକୁ ଆପଣଙ୍କ ପ୍ରୋଫାଇଲ୍‌ରୁ ଏକ କାମ ଯୋଡ଼ନ୍ତୁ।';

  @override
  String get gigFieldTrade => 'କେଉଁ କାମ?';

  @override
  String get gigFieldTitle => 'ଏହି ସେବାର ନାମ କ\'ଣ?';

  @override
  String get gigFieldTitleHint =>
      'ଗ୍ରାହକମାନେ ଏହା ଦେଖନ୍ତି। ନିର୍ଦ୍ଦିଷ୍ଟ ଭାବେ ଲେଖନ୍ତୁ।';

  @override
  String get gigFieldTitleExample => 'ଯଥା ସ୍ପ୍ଲିଟ୍ AC ଡିପ୍ କ୍ଲିନିଂ';

  @override
  String get gigFieldDescription => 'ଏଥିରେ କ\'ଣ କ\'ଣ ଅନ୍ତର୍ଭୁକ୍ତ?';

  @override
  String get gigFieldDescriptionHint =>
      'ଇଚ୍ଛାଧୀନ, କିନ୍ତୁ ଗ୍ରାହକମାନଙ୍କୁ ଆପଣଙ୍କୁ ବାଛିବାରେ ସାହାଯ୍ୟ କରେ।';

  @override
  String get gigFieldDescriptionExample =>
      'ଯଥା ଇନଡୋର୍ ଓ ଆଉଟଡୋର୍ ୟୁନିଟ୍‌ର ସମ୍ପୂର୍ଣ୍ଣ ସଫେଇ, ଫିଲ୍ଟର୍ ଧୁଆ, ଗ୍ୟାସ୍ ପ୍ରେସର୍ ଯାଞ୍ଚ।';

  @override
  String get gigFieldPrice => 'ଆପଣ କେତେ ନିଅନ୍ତି?';

  @override
  String get gigFieldPriceHint =>
      'ପ୍ରତ୍ୟେକ ସେବାର ନିଜସ୍ୱ ମୂଲ୍ୟ ଅଛି। ଏହା ଆପଣଙ୍କ ଅନ୍ୟ ସେବାକୁ ପ୍ରଭାବିତ କରେ ନାହିଁ।';

  @override
  String get gigUnitPerJob => 'ପ୍ରତି କାମ';

  @override
  String get gigUnitPerHour => 'ପ୍ରତି ଘଣ୍ଟା';

  @override
  String get gigUnitPerDay => 'ପ୍ରତି ଦିନ';

  @override
  String get gigUnitPerUnit => 'ପ୍ରତି ୟୁନିଟ୍';

  @override
  String get gigUnitPerSqft => 'ପ୍ରତି ବର୍ଗଫୁଟ';

  @override
  String get gigFieldDuration => 'ଏଥିରେ ସାଧାରଣତଃ କେତେ ସମୟ ଲାଗେ?';

  @override
  String get gigFieldRadius => 'ଏଥିପାଇଁ ଆପଣ କେତେ ଦୂର ଯିବେ?';

  @override
  String get gigFieldRadiusHint =>
      'ଆପଣଙ୍କ ସାଧାରଣ ଯାତ୍ରା ଦୂରତା ବ୍ୟବହାର କରିବାକୁ ଡିଫଲ୍ଟ ରହିବାକୁ ଦିଅନ୍ତୁ।';

  @override
  String get gigUsualDistance => 'ଆପଣଙ୍କ ସାଧାରଣ ଦୂରତା';

  @override
  String get gigUseUsualDistance => 'ମୋ ସାଧାରଣ ଦୂରତା ବ୍ୟବହାର କରନ୍ତୁ';

  @override
  String get gigReviewNotice =>
      'ନୂଆ ଓ ସମ୍ପାଦିତ ସେବା ଲାଇଭ୍ ହେବା ପୂର୍ବରୁ ଆମ ଦଳ ଯାଞ୍ଚ କରେ। ହୋଇଗଲେ ଆମେ ତୁରନ୍ତ ଜଣାଇବୁ।';

  @override
  String get gigSaveDraft => 'ଡ୍ରାଫ୍ଟ ସେଭ୍ କରନ୍ତୁ';

  @override
  String get gigSubmitForReview => 'ସମୀକ୍ଷା ପାଇଁ ଦାଖଲ କରନ୍ତୁ';

  @override
  String get walletAllTransactions => 'ସମସ୍ତ କାରବାର';

  @override
  String get walletFrozen =>
      'ଏକ ବିଷୟ ଯାଞ୍ଚ ଚାଲିଥିବାରୁ ଟଙ୍କା ଉଠାଣ ବନ୍ଦ ରଖାଯାଇଛି। ବିବରଣୀ ପାଇଁ ସହାୟତା ସହ ଯୋଗାଯୋଗ କରନ୍ତୁ।';

  @override
  String get walletWithdraw => 'ଟଙ୍କା ଉଠାନ୍ତୁ';

  @override
  String walletNothingPending(Object amount) {
    return 'ଏପର୍ଯ୍ୟନ୍ତ ଉଠାଇବାକୁ କିଛି ନାହିଁ। $amount ଏବେ ବି ପ୍ରକ୍ରିୟାରେ ଅଛି ଏବଂ ସେହି କାମ ଅନୁମୋଦିତ ହେଲେ ଆପଣଙ୍କ ବାଲାନ୍ସକୁ ଆସିବ।';
  }

  @override
  String get walletNothingYet =>
      'ଏପର୍ଯ୍ୟନ୍ତ ଉଠାଇବାକୁ କିଛି ନାହିଁ। ଗ୍ରାହକ ଶେଷ ହୋଇଥିବା କାମ ଅନୁମୋଦନ କଲେ ଆପଣଙ୍କ ଆୟ ଏଠାରେ ଦେଖାଯିବ।';

  @override
  String get walletRecentEarnings => 'ସାମ୍ପ୍ରତିକ ଆୟ';

  @override
  String get walletNoEarnings => 'ଏପର୍ଯ୍ୟନ୍ତ କୌଣସି ଆୟ ନାହିଁ';

  @override
  String get walletNoEarningsBody =>
      'ସମ୍ପୂର୍ଣ୍ଣ କାମର ପେମେଣ୍ଟ ହେଲେ ଆପଣଙ୍କ ଆୟ ଏଠାରେ ଦେଖାଯିବ।';

  @override
  String get walletAvailable => 'ଉଠାଇବାକୁ ଉପଲବ୍ଧ';

  @override
  String get walletProcessing => 'ପ୍ରକ୍ରିୟାରେ';

  @override
  String get walletProcessingHint => 'ଅଟକ ଅବଧି ପରେ ମୁକ୍ତ ହେବ';

  @override
  String get walletTotalEarned => 'ମୋଟ ଆୟ';

  @override
  String get statementTitle => 'ଷ୍ଟେଟମେଣ୍ଟ';

  @override
  String get statementTabTransactions => 'କାରବାର';

  @override
  String get statementTabWithdrawals => 'ଟଙ୍କା ଉଠାଣ';

  @override
  String get statementEmpty => 'ଏପର୍ଯ୍ୟନ୍ତ କିଛି ନାହିଁ';

  @override
  String get statementEmptyBody =>
      'ଆପଣ କାମ ଆରମ୍ଭ କଲେ ପ୍ରତ୍ୟେକ ପେମେଣ୍ଟ, ଶୁଳ୍କ ଓ ଟଙ୍କା ଉଠାଣ ଏଠାରେ ତାଲିକାଭୁକ୍ତ ହେବ।';

  @override
  String statementBalance(Object amount) {
    return 'ବାଲାନ୍ସ $amount';
  }

  @override
  String get statementNoWithdrawals => 'ଏପର୍ଯ୍ୟନ୍ତ କୌଣସି ଟଙ୍କା ଉଠାଣ ନାହିଁ';

  @override
  String get statementNoWithdrawalsBody =>
      'ଆପଣ ଟଙ୍କା ଉଠାଇଲେ ଏହାର ହିସାବ ଏଠାରେ ରହିବ।';

  @override
  String payoutRequestedAt(Object date) {
    return '$date ରେ ଅନୁରୋଧ କରାଯାଇଛି';
  }

  @override
  String payoutPaidAt(Object date) {
    return '$date ରେ ଦିଆଯାଇଛି';
  }

  @override
  String get payoutEnterAmount => 'କେତେ ଉଠାଇବାକୁ ଚାହାଁନ୍ତି ଦିଅନ୍ତୁ';

  @override
  String payoutUpTo(Object amount) {
    return 'ଆପଣ ଏବେ $amount ପର୍ଯ୍ୟନ୍ତ ଉଠାଇପାରିବେ';
  }

  @override
  String payoutMinimum(Object amount) {
    return 'ସର୍ବନିମ୍ନ ଟଙ୍କା ଉଠାଣ $amount';
  }

  @override
  String payoutRequested(Object amount) {
    return '$amount ଉଠାଇବାକୁ ଅନୁରୋଧ କରାଗଲା। ପ୍ରକ୍ରିୟା ଚାଲିବା ସହ ଆମେ ଜଣାଉଥିବୁ।';
  }

  @override
  String get payoutAvailableNow => 'ଏବେ ଉପଲବ୍ଧ';

  @override
  String payoutPendingMore(Object amount) {
    return 'ଆଉ $amount ଏବେ ବି ପ୍ରକ୍ରିୟାରେ ଅଛି ଏବଂ ଏବେ ଉଠାଯାଇପାରିବ ନାହିଁ।';
  }

  @override
  String get payoutHowMuch => 'କେତେ?';

  @override
  String get payoutAll => 'ସବୁ';

  @override
  String payoutPercent(Object percent) {
    return '$percent%';
  }

  @override
  String get payoutProcessNotice =>
      'ଟଙ୍କା ଉଠାଣ ଯାଞ୍ଚ ହୋଇ ଆପଣଙ୍କ ପଞ୍ଜୀକୃତ ବ୍ୟାଙ୍କ ଆକାଉଣ୍ଟକୁ ପଠାଯାଏ। ପ୍ରତ୍ୟେକ ପଦକ୍ଷେପର ସ୍ଥିତି ଏଠାରେ ଦେଖାଯିବ।';

  @override
  String get payoutRequest => 'ଟଙ୍କା ଉଠାଣ ଅନୁରୋଧ କରନ୍ତୁ';

  @override
  String get bankChecking => 'ଆପଣଙ୍କ ବ୍ୟାଙ୍କ ଆକାଉଣ୍ଟ ଯାଞ୍ଚ ହେଉଛି…';

  @override
  String bankPaidTo(Object last4) {
    return '$last4 ରେ ଶେଷ ହେଉଥିବା ଆକାଉଣ୍ଟକୁ ଦିଆଯିବ';
  }

  @override
  String get bankVerifiedFallback => 'ଆପଣଙ୍କ ଯାଞ୍ଚିତ ବ୍ୟାଙ୍କ ଆକାଉଣ୍ଟ';

  @override
  String get bankBeingVerified => 'ବ୍ୟାଙ୍କ ଆକାଉଣ୍ଟ ଯାଞ୍ଚ ହେଉଛି';

  @override
  String get bankBeingVerifiedBody =>
      'ଆମ ଦଳ ଯାଞ୍ଚ କଲା ପରେ ଆପଣ ଟଙ୍କା ଉଠାଇପାରିବେ।';

  @override
  String get bankNotVerified => 'ବ୍ୟାଙ୍କ ଆକାଉଣ୍ଟ ଯାଞ୍ଚ ହୋଇନାହିଁ';

  @override
  String get bankNotVerifiedBody => 'ଆପଣଙ୍କ ବିବରଣୀ ଯାଞ୍ଚ କରି ପୁଣି ଦାଖଲ କରନ୍ତୁ।';

  @override
  String get bankAddTitle => 'ବ୍ୟାଙ୍କ ଆକାଉଣ୍ଟ ଯୋଡ଼ନ୍ତୁ';

  @override
  String get bankAddBody =>
      'ଆମ ଦଳ ଯାଞ୍ଚ କରିଥିବା ବ୍ୟାଙ୍କ ଆକାଉଣ୍ଟକୁ ହିଁ ଟଙ୍କା ଦିଆଯାଏ।';

  @override
  String get bankAddAction => 'ବ୍ୟାଙ୍କ ଆକାଉଣ୍ଟ ଯୋଡ଼ନ୍ତୁ';

  @override
  String get verificationTitle => 'ଯାଞ୍ଚ';

  @override
  String get verificationProgress => 'ଯାଞ୍ଚିତ ପରୀକ୍ଷା';

  @override
  String verificationCount(int approved, int total) {
    return '$total ମଧ୍ୟରୁ $approved';
  }

  @override
  String get verificationInsurance => 'ବୀମା';

  @override
  String get verificationNoCover => 'କୌଣସି ସକ୍ରିୟ ବୀମା ନାହିଁ';

  @override
  String get verificationNoCoverBody =>
      'ବର୍ତ୍ତମାନ ଆମ ପାଖରେ ଆପଣଙ୍କ କୌଣସି ବୀମା ପଲିସି ଲିପିବଦ୍ଧ ନାହିଁ।';

  @override
  String get verifyIdentity => 'ପରିଚୟ';

  @override
  String get verifyIdentityBody =>
      'ଏକ ସରକାରୀ ପରିଚୟ ପତ୍ର, ଯାହାଦ୍ୱାରା ଗ୍ରାହକମାନେ ଜାଣନ୍ତି ସେମାନଙ୍କ ଘରକୁ କିଏ ଆସୁଛନ୍ତି।';

  @override
  String get verifyAddress => 'ଠିକଣା';

  @override
  String get verifyAddressBody => 'ଆପଣ କେଉଁଠି ରୁହନ୍ତି ତା\'ର ପ୍ରମାଣ।';

  @override
  String get verifyIti => 'ITI ପ୍ରମାଣପତ୍ର';

  @override
  String get verifyItiBody =>
      'ଶିଳ୍ପ ପ୍ରଶିକ୍ଷଣ ସଂସ୍ଥା (ITI) ରୁ ଆପଣଙ୍କ ଟ୍ରେଡ୍ ପ୍ରମାଣପତ୍ର।';

  @override
  String get verifyDiploma => 'ଡିପ୍ଲୋମା';

  @override
  String get verifyDiplomaBody => 'ଏକ ସ୍ୱୀକୃତ ବୈଷୟିକ ଡିପ୍ଲୋମା।';

  @override
  String get verifyRpl => 'ଦକ୍ଷତା ମୂଲ୍ୟାଙ୍କନ';

  @override
  String get verifyRplBody =>
      'ପୂର୍ବ ଶିକ୍ଷାର ସ୍ୱୀକୃତି (RPL): ଆପଣଙ୍କ ଅଭିଜ୍ଞତାର ମୂଲ୍ୟାଙ୍କନ ଓ ପ୍ରମାଣୀକରଣ।';

  @override
  String get verifyBackground => 'ପୃଷ୍ଠଭୂମି ଯାଞ୍ଚ';

  @override
  String get verifyBackgroundBody =>
      'ଏହା ଆମେ ନିଜେ କରୁ। ଆପଣଙ୍କୁ କିଛି କରିବାକୁ ପଡ଼ିବ ନାହିଁ।';

  @override
  String get verifyInsuranceBody =>
      'କାମ କରିବା ସମୟରେ ଦୁର୍ଘଟଣାଜନିତ କ୍ଷତି ପାଇଁ ବୀମା। ବ୍ୟବସ୍ଥା ହେଲେ ଆମ ଦଳ ଆପଣଙ୍କ ପଲିସି ଯୋଡ଼େ।';

  @override
  String get verifyBank => 'ବ୍ୟାଙ୍କ ଆକାଉଣ୍ଟ';

  @override
  String get verifyBankBody => 'ଯେଉଁଠି ଆପଣଙ୍କ ଉଠାଇଥିବା ଟଙ୍କା ଦିଆଯାଏ।';

  @override
  String verificationValidUntil(Object date) {
    return '$date ପର୍ଯ୍ୟନ୍ତ ବୈଧ';
  }

  @override
  String get verificationStart => 'ଆରମ୍ଭ କରନ୍ତୁ';

  @override
  String get verificationUpdate => 'ଅପଡେଟ୍ କରନ୍ତୁ';

  @override
  String get policyActive => 'ସକ୍ରିୟ';

  @override
  String get policyNotActive => 'ସକ୍ରିୟ ନୁହେଁ';

  @override
  String get policyNumber => 'ପଲିସି';

  @override
  String get policyCover => 'ବୀମା ରାଶି';

  @override
  String get policyValidUntil => 'ପର୍ଯ୍ୟନ୍ତ ବୈଧ';

  @override
  String get kycStillWaiting =>
      'ଏବେ ବି DigiLocker ପାଇଁ ଅପେକ୍ଷା। ଆପଣ ପରେ ଏଠାରୁ ପୁଣି ଦେଖିପାରିବେ।';

  @override
  String get kycTitle => 'ପରିଚୟ ଯାଞ୍ଚ';

  @override
  String get kycHeadline => 'ଆପଣ କିଏ ନିଶ୍ଚିତ କରନ୍ତୁ';

  @override
  String get kycIntro =>
      'ଗ୍ରାହକମାନେ ଆପଣଙ୍କୁ ସେମାନଙ୍କ ଘରେ ପଶିବାକୁ ଦିଅନ୍ତି, ତେଣୁ ଆମେ ପ୍ରତ୍ୟେକ କର୍ମୀଙ୍କ ପରିଚୟ ଭାରତ ସରକାରଙ୍କ ଦଲିଲ ପ୍ଲାଟଫର୍ମ DigiLocker ମାଧ୍ୟମରେ ଯାଞ୍ଚ କରୁ। କିଛି ଅପଲୋଡ୍ ହୁଏ ନାହିଁ — ଆପଣ କେବଳ ନିଜ ଆଧାର ଆକାଉଣ୍ଟରେ ଅନୁରୋଧ ଅନୁମୋଦନ କରନ୍ତି।';

  @override
  String get kycPrivacy =>
      'ଆପଣଙ୍କ ଆଧାର ବିବରଣୀ ସିଧାସଳଖ DigiLocker ସହ ନିଶ୍ଚିତ ହୁଏ। ଯାଞ୍ଚ ହୋଇଛି ବୋଲି ପ୍ରମାଣ କରୁଥିବା ଜିନିଷ ହିଁ ଆମେ ରଖୁ — ଆପଣଙ୍କ ଫଟୋ କିମ୍ବା ଆଧାରର କପି କେବେ ନୁହେଁ।';

  @override
  String get kycVerified => 'ଆପଣଙ୍କ ପରିଚୟ ଯାଞ୍ଚିତ ହେଲା।';

  @override
  String get kycAwaitingConsent =>
      'ଆପଣଙ୍କ ବ୍ରାଉଜରରେ DigiLocker ସମ୍ମତି ସମ୍ପୂର୍ଣ୍ଣ କରନ୍ତୁ, ତାପରେ ଏଠାକୁ ଫେରନ୍ତୁ।';

  @override
  String get kycChecking => 'DigiLocker ସହ ଯାଞ୍ଚ ହେଉଛି…';

  @override
  String get kycStart => 'DigiLocker ଦ୍ୱାରା ଯାଞ୍ଚ କରନ୍ତୁ';

  @override
  String get qualSubmitted => 'ସମୀକ୍ଷା ପାଇଁ ଦାଖଲ ହେଲା।';

  @override
  String get qualTitle => 'ଆପଣଙ୍କ ଯୋଗ୍ୟତା';

  @override
  String get qualIti => 'ITI';

  @override
  String get qualInstitute => 'ସଂସ୍ଥା';

  @override
  String get qualInstituteHint => 'ଯଥା ସରକାରୀ ITI, କୋଏମ୍ବାଟୁର';

  @override
  String get qualName => 'ଯୋଗ୍ୟତା';

  @override
  String get qualNameHint => 'ଯଥା ଇଲେକ୍ଟ୍ରିସିଆନ୍';

  @override
  String get qualSpeciality => 'ବିଶେଷତା (ଇଚ୍ଛାଧୀନ)';

  @override
  String get qualSpecialityHint => 'ଯଥା ଶିଳ୍ପ ୱାୟରିଂ';

  @override
  String get qualYear => 'ସମ୍ପୂର୍ଣ୍ଣ କରିଥିବା ବର୍ଷ';

  @override
  String get qualCertificate => 'ଆପଣଙ୍କ ପ୍ରମାଣପତ୍ର';

  @override
  String get qualCertificateBody => 'ପ୍ରମାଣପତ୍ରର ସ୍ପଷ୍ଟ ଫଟୋ କିମ୍ବା PDF।';

  @override
  String get bankErrorHolder => 'ଆକାଉଣ୍ଟରେ ଯେପରି ଅଛି ଠିକ୍ ସେପରି ନାମ ଦିଅନ୍ତୁ';

  @override
  String get bankErrorNumber => 'ଆକାଉଣ୍ଟ ନମ୍ବର 9 ରୁ 18 ଅଙ୍କର ହୁଏ';

  @override
  String get bankErrorMismatch => 'ଆକାଉଣ୍ଟ ନମ୍ବର ମେଳ ଖାଉନାହିଁ';

  @override
  String get bankErrorIfsc => '11 ଅକ୍ଷରର IFSC ଦିଅନ୍ତୁ, ଯଥା SBIN0001234';

  @override
  String get bankSent => 'ବ୍ୟାଙ୍କ ଆକାଉଣ୍ଟ ଯାଞ୍ଚ ପାଇଁ ପଠାଗଲା।';

  @override
  String get bankNotice =>
      'ଆପଣଙ୍କ ଉଠାଇଥିବା ଟଙ୍କା ଏହି ଆକାଉଣ୍ଟକୁ ଦିଆଯାଏ। ପ୍ରଥମ ପେଆଉଟ୍ ପୂର୍ବରୁ ଆମ ଦଳ ଏହାକୁ ଯାଞ୍ଚ କରେ।';

  @override
  String get bankHolder => 'ଆକାଉଣ୍ଟଧାରୀଙ୍କ ନାମ';

  @override
  String get bankNumber => 'ଆକାଉଣ୍ଟ ନମ୍ବର';

  @override
  String get bankConfirmNumber => 'ଆକାଉଣ୍ଟ ନମ୍ବର ପୁଣି ଦିଅନ୍ତୁ';

  @override
  String get bankIfsc => 'IFSC କୋଡ୍';

  @override
  String get bankIfscHint => 'ଯଥା SBIN0001234';

  @override
  String get bankName => 'ବ୍ୟାଙ୍କ ନାମ (ଇଚ୍ଛାଧୀନ)';

  @override
  String get bankSubmit => 'ଯାଞ୍ଚ ପାଇଁ ଦାଖଲ କରନ୍ତୁ';

  @override
  String get profileCompleteness => 'ପ୍ରୋଫାଇଲ୍ ସମ୍ପୂର୍ଣ୍ଣତା';

  @override
  String get profileCompletenessBody =>
      'ସମ୍ପୂର୍ଣ୍ଣ ପ୍ରୋଫାଇଲ୍ ଗ୍ରାହକମାନଙ୍କୁ ଆପଣଙ୍କୁ ବାଛିବାରେ ସାହାଯ୍ୟ କରେ।';

  @override
  String get profileJobsDone => 'ସମ୍ପୂର୍ଣ୍ଣ କାମ';

  @override
  String get profileRating => 'ରେଟିଂ';

  @override
  String get profileExperience => 'ଅଭିଜ୍ଞତା';

  @override
  String profileExperienceYears(Object years) {
    return '$years ବର୍ଷ';
  }

  @override
  String get profileEdit => 'ପ୍ରୋଫାଇଲ୍ ସମ୍ପାଦନ କରନ୍ତୁ';

  @override
  String get profileVerified => 'ଯାଞ୍ଚିତ';

  @override
  String get profileNotVerified => 'ଯାଞ୍ଚିତ ନୁହେଁ';

  @override
  String get profilePinInvalid => 'ଏକ ବୈଧ 6 ଅଙ୍କର ପିନ୍ କୋଡ୍ ଦିଅନ୍ତୁ';

  @override
  String get profileUpdated => 'ପ୍ରୋଫାଇଲ୍ ଅପଡେଟ୍ ହେଲା।';

  @override
  String get profilePhotoUpdated => 'ଫଟୋ ଅପଡେଟ୍ ହେଲା।';

  @override
  String get profileChangePhoto => 'ଫଟୋ ବଦଳାନ୍ତୁ';

  @override
  String get profileName => 'ନାମ';

  @override
  String get profilePhone => 'ଫୋନ୍';

  @override
  String get profileLockedNotice =>
      'ଆପଣଙ୍କ ନାମ ଓ ନମ୍ବର ଆପଣଙ୍କ ପରିଚୟ ଯାଞ୍ଚ ସହ ଯୋଡ଼ା। ଏଥିରୁ କିଛି ବଦଳାଇବାକୁ ହେଲେ ସହାୟତା ସହ ଯୋଗାଯୋଗ କରନ୍ତୁ।';

  @override
  String get profileAbout => 'ଆପଣଙ୍କ ବିଷୟରେ';

  @override
  String get profileBioHint =>
      'ଗ୍ରାହକମାନଙ୍କୁ ଆପଣଙ୍କ ଅଭିଜ୍ଞତା ଓ ଆପଣ କେଉଁଥିରେ ଭଲ ସେ ବିଷୟରେ କୁହନ୍ତୁ।';

  @override
  String get profileYearsExperience => 'ଅଭିଜ୍ଞତାର ବର୍ଷ';

  @override
  String get profileBased => 'ଆପଣ କେଉଁଠି ରୁହନ୍ତି';

  @override
  String get profileAddress => 'ଠିକଣା';

  @override
  String get profileCity => 'ସହର';

  @override
  String get profilePin => 'ପିନ୍ କୋଡ୍';

  @override
  String get profileGender => 'ଲିଙ୍ଗ';

  @override
  String get genderMale => 'ପୁରୁଷ';

  @override
  String get genderFemale => 'ମହିଳା';

  @override
  String get genderOther => 'ଅନ୍ୟ';

  @override
  String get profileTrades => 'ଆପଣଙ୍କ କାମ';

  @override
  String get profileTradesBody =>
      'ଆପଣ ଅନୁମୋଦିତ ଥିବା ସମସ୍ତ କାମରେ କାମ କରିପାରିବେ।';

  @override
  String get profileTradesLoadFailed => 'ଆପଣଙ୍କ କାମ ଲୋଡ୍ ହୋଇପାରିଲା ନାହିଁ।';

  @override
  String get tradePending => 'ବାକି';

  @override
  String get profileAddTrade => 'କାମ ଯୋଡ଼ନ୍ତୁ';

  @override
  String get profileAddTradeBody =>
      'ଅନୁମୋଦନ ପୂର୍ବରୁ ଆମେ ଆପଣଙ୍କ ଦକ୍ଷତାର ପ୍ରମାଣ ମାଗିପାରୁ।';

  @override
  String get profileTradeRequested =>
      'ଅନୁରୋଧ କରାଗଲା। ଅନୁମୋଦିତ ହେଲେ ଆମେ ଜଣାଇବୁ।';

  @override
  String get profileSave => 'ପରିବର୍ତ୍ତନ ସେଭ୍ କରନ୍ତୁ';

  @override
  String get supportNewRequest => 'ନୂଆ ଅନୁରୋଧ';

  @override
  String get supportEmpty => 'ଏପର୍ଯ୍ୟନ୍ତ କୌଣସି ଅନୁରୋଧ ନାହିଁ';

  @override
  String get supportEmptyBody =>
      'କୌଣସି କାମ, ପେମେଣ୍ଟ କିମ୍ବା ଆପଣଙ୍କ ଆକାଉଣ୍ଟରେ କିଛି ଭୁଲ ହେଲେ ଅନୁରୋଧ କରନ୍ତୁ, ଆମେ ସାହାଯ୍ୟ କରିବୁ।';

  @override
  String get supportYourRequests => 'ଆପଣଙ୍କ ଅନୁରୋଧ';

  @override
  String get supportEmergency => 'ଜରୁରୀକାଳୀନ ପରିସ୍ଥିତିରେ';

  @override
  String get supportEmergencyBody =>
      'ଏହି ଆପ୍ ଆପଣଙ୍କ ତରଫରୁ ସାହାଯ୍ୟ ଡାକିପାରିବ ନାହିଁ। ଆପଣ ବିପଦରେ ଥିଲେ ସିଧାସଳଖ ଜରୁରୀ ସେବାକୁ କଲ୍ କରନ୍ତୁ।';

  @override
  String get supportCall112 => '112 କୁ କଲ୍ କରନ୍ତୁ';

  @override
  String get supportPolice => 'ପୋଲିସ୍';

  @override
  String get ticketOpen => 'ଖୋଲା';

  @override
  String get ticketInProgress => 'ଚାଲିଛି';

  @override
  String get ticketReplyNeeded => 'ଆପଣଙ୍କ ଉତ୍ତର ଦରକାର';

  @override
  String get ticketResolved => 'ସମାଧାନ ହେଲା';

  @override
  String get ticketClosed => 'ବନ୍ଦ';

  @override
  String ticketLastUpdate(Object date) {
    return 'ଶେଷ ଅପଡେଟ୍ $date';
  }

  @override
  String get supportCategoryJob => 'ଏକ କାମ';

  @override
  String get supportCategoryPayment => 'ଏକ ପେମେଣ୍ଟ';

  @override
  String get supportCategoryWithdrawal => 'ଟଙ୍କା ଉଠାଣ';

  @override
  String get supportCategoryAccount => 'ମୋ ଆକାଉଣ୍ଟ';

  @override
  String get supportCategorySafety => 'ସୁରକ୍ଷା';

  @override
  String get supportCategoryApp => 'ଆପ୍';

  @override
  String get supportCategoryOther => 'ଅନ୍ୟ କିଛି';

  @override
  String supportRaised(Object code) {
    return 'ଅନୁରୋଧ $code ଦାଖଲ ହେଲା।';
  }

  @override
  String get supportHowHelp => 'ଆମେ କିପରି ସାହାଯ୍ୟ କରିପାରିବୁ?';

  @override
  String get supportAbout => 'ଏହା କେଉଁ ବିଷୟରେ?';

  @override
  String get supportSubject => 'ବିଷୟ';

  @override
  String get supportSubjectHint => 'ସମସ୍ୟା ବିଷୟରେ କିଛି ଶବ୍ଦ';

  @override
  String get supportWhatHappened => 'କ\'ଣ ହେଲା?';

  @override
  String get supportSend => 'ଅନୁରୋଧ ପଠାନ୍ତୁ';

  @override
  String get ticketTitle => 'ସହାୟତା ଅନୁରୋଧ';

  @override
  String get ticketNoMessages => 'ଏପର୍ଯ୍ୟନ୍ତ କୌଣସି ବାର୍ତ୍ତା ନାହିଁ';

  @override
  String get ticketNoMessagesBody => 'ଆପଣଙ୍କ କଥାବାର୍ତ୍ତା ଏଠାରେ ଦେଖାଯିବ।';

  @override
  String get ticketWriteMessage => 'ଏକ ବାର୍ତ୍ତା ଲେଖନ୍ତୁ';

  @override
  String get ticketSupportName => 'Wervexa ସହାୟତା';

  @override
  String get requestsTitle => 'ଗ୍ରାହକଙ୍କ ଅନୁରୋଧ';

  @override
  String get requestsRefresh => 'ରିଫ୍ରେସ୍ କରନ୍ତୁ';

  @override
  String get requestsLocationNeeded => 'ଲୋକେସନ୍ ଦରକାର';

  @override
  String get requestsLocationBody =>
      'ଆପଣଙ୍କ ନିକଟର ଗ୍ରାହକ ଅନୁରୋଧ ଖୋଜିବାକୁ ଆମେ ଆପଣଙ୍କ ଲୋକେସନ୍ ବ୍ୟବହାର କରୁ।';

  @override
  String get requestsGrantLocation => 'ଲୋକେସନ୍ ଅନୁମତି ଦିଅନ୍ତୁ';

  @override
  String get requestsEmpty => 'ନିକଟରେ କୌଣସି ମେଳ ଖାଉଥିବା ଅନୁରୋଧ ନାହିଁ';

  @override
  String get requestsEmptyBody =>
      'ଆପଣଙ୍କ ସେବା ସହ ମେଳ ଖାଇଲେ\nନୂଆ ଗ୍ରାହକ ଅନୁରୋଧ ଏଠାରେ ଦେଖାଯିବ।';

  @override
  String get requestsViewOffer => 'ଦେଖନ୍ତୁ ଓ ଅଫର୍ ଦିଅନ୍ତୁ →';

  @override
  String get requestEnterPrice => 'ଏକ ବୈଧ ମୂଲ୍ୟ ଦିଅନ୍ତୁ';

  @override
  String requestOfferSubmitted(Object price) {
    return '$price ରେ ଅଫର୍ ଦାଖଲ ହେଲା!';
  }

  @override
  String get requestDetailsTitle => 'ଅନୁରୋଧ ବିବରଣୀ';

  @override
  String get requestStatusOpen => 'ଖୋଲା';

  @override
  String get requestCategory => 'ବର୍ଗ';

  @override
  String get requestBudget => 'ବଜେଟ୍';

  @override
  String get requestSchedule => 'ସମୟସୂଚୀ';

  @override
  String get requestDistance => 'ଦୂରତା';

  @override
  String get requestArea => 'ଅଞ୍ଚଳ';

  @override
  String get requestOffers => 'ଅଫର୍';

  @override
  String get requestNotes => 'ଟିପ୍ପଣୀ';

  @override
  String get requestAddressPrivacy =>
      'ଗ୍ରାହକ ଆପଣଙ୍କ ଅଫର୍ ଗ୍ରହଣ କଲା ପରେ ହିଁ ତାଙ୍କ ସଠିକ୍ ଠିକଣା ସେୟାର୍ ହୁଏ।';

  @override
  String get requestYourOffer => 'ଆପଣଙ୍କ ଅଫର୍';

  @override
  String get requestYourPrice => 'ଆପଣଙ୍କ ମୂଲ୍ୟ (₹)';

  @override
  String get requestPriceHint => 'ଯଥା 500';

  @override
  String get requestDuration => 'ଆନୁମାନିକ ସମୟ (ଇଚ୍ଛାଧୀନ)';

  @override
  String get requestDurationHint => 'ଯଥା 1-2 ଘଣ୍ଟା';

  @override
  String get requestMessage => 'ଗ୍ରାହକଙ୍କ ପାଇଁ ବାର୍ତ୍ତା (ଇଚ୍ଛାଧୀନ)';

  @override
  String get requestMessageHint => 'ଏହି କାମ ପାଇଁ ଆପଣ କାହିଁକି ଉପଯୁକ୍ତ ବ୍ୟକ୍ତି?';

  @override
  String get requestSubmitOffer => 'ଅଫର୍ ଦାଖଲ କରନ୍ତୁ';

  @override
  String get requestMakeOffer => 'ଅଫର୍ ଦିଅନ୍ତୁ';

  @override
  String get requestAlreadyOffered =>
      'ଆପଣ ଏହି ଅନୁରୋଧରେ ପୂର୍ବରୁ ଅଫର୍ ଦାଖଲ କରିସାରିଛନ୍ତି।';

  @override
  String get requestViewOffers => 'ଅଫର୍ ଦେଖନ୍ତୁ';

  @override
  String get offersEmptyBody =>
      'ଗ୍ରାହକ ଅନୁରୋଧରେ ଆପଣ ଦାଖଲ କରିଥିବା ଅଫର୍\nଏଠାରେ ଦେଖାଯିବ।';

  @override
  String get offerWithdraw => 'ଟଙ୍କା ଉଠାନ୍ତୁ';

  @override
  String get offerWithdrawTitle => 'ଅଫର୍ ପ୍ରତ୍ୟାହାର କରିବେ?';

  @override
  String get offerWithdrawBody => 'ଗ୍ରାହକ ଆଉ ଏହି ଅଫର୍ ଦେଖିପାରିବେ ନାହିଁ।';

  @override
  String get offerWithdrawn => 'ଅଫର୍ ପ୍ରତ୍ୟାହାର ହେଲା';

  @override
  String get onboardingTitle => 'ଆପଣଙ୍କ ପ୍ରୋଫାଇଲ୍ ସେଟ୍ କରନ୍ତୁ';

  @override
  String get onboardingHelp => 'ସାହାଯ୍ୟ';

  @override
  String onboardingHello(Object name) {
    return 'ନମସ୍କାର, $name';
  }

  @override
  String get onboardingIntro =>
      'ଆଉ କିଛି ଜିନିଷ, ତାପରେ ଆପଣ କାମ ପାଇବା ଆରମ୍ଭ କରିବାକୁ ପ୍ରସ୍ତୁତ।';

  @override
  String get onboardingSetup => 'ସେଟଅପ୍';

  @override
  String onboardingStepCount(int done, int total) {
    return '$total ମଧ୍ୟରୁ $done';
  }

  @override
  String get onboardingBasicBody =>
      'ଆପଣଙ୍କ ସହର ଓ ପିନ୍ କୋଡ୍, ଯାହାଦ୍ୱାରା ଆମେ ଆପଣଙ୍କ ନିକଟରେ କାମ ଖୋଜିପାରିବୁ।';

  @override
  String get onboardingTradeBody => 'ଆପଣ ମୁଖ୍ୟତଃ କରୁଥିବା କାମ।';

  @override
  String get onboardingSkillsDoneBody =>
      'ଆପଣଙ୍କ ମୁଖ୍ୟ କାମ ଗୋଟିଏ ଭାବେ ଗଣାଯାଏ। ଆପଣ କରୁଥିବା ବାକି ସମସ୍ତ କାମ ଯୋଡ଼ିବାକୁ ଏହା ଖୋଲନ୍ତୁ।';

  @override
  String get onboardingSkillsBody =>
      'ଆପଣ କରୁଥିବା ସମସ୍ତ କାମ ଯୋଡ଼ନ୍ତୁ। ଆପଣ ଗୋଟିଏ କାମରେ ସୀମିତ ନୁହଁନ୍ତି।';

  @override
  String get onboardingAreaBody => 'ଗୋଟିଏ କାମ ପାଇଁ ଆପଣ କେତେ ଦୂର ଯିବାକୁ ଇଚ୍ଛୁକ।';

  @override
  String get onboardingKycBody =>
      'ଏକ ସରକାରୀ ପରିଚୟ ପତ୍ର। ଗ୍ରାହକମାନେ ଆପଣଙ୍କୁ ସେମାନଙ୍କ ଘରେ ପଶିବାକୁ ଦେଉଛନ୍ତି।';

  @override
  String get onboardingReviewNotice =>
      'ଏଗୁଡ଼ିକ ଶେଷ କଲା ପରେ ଆମ ଦଳ ଆପଣଙ୍କ ଦଲିଲ ଯାଞ୍ଚ କରେ। ଅପେକ୍ଷା ସମୟରେ ଆପଣ ନିଜ ସେବା ସେଟ୍ କରିବା ଜାରି ରଖିପାରିବେ।';

  @override
  String get onboardingTradesLoadFailed =>
      'କାମ ଲୋଡ୍ ହୋଇପାରିଲା ନାହିଁ। ପୁଣି ଚେଷ୍ଟା କରନ୍ତୁ।';

  @override
  String get onboardingMainTrade => 'ଆପଣଙ୍କ ମୁଖ୍ୟ କାମ କ\'ଣ?';

  @override
  String get onboardingMainTradeBody => 'ଆପଣ ପରେ ଆହୁରି କାମ ଯୋଡ଼ିପାରିବେ।';

  @override
  String onboardingTradeSet(Object trade) {
    return '$trade ଆପଣଙ୍କ ମୁଖ୍ୟ କାମ ଭାବେ ସେଟ୍ ହେଲା।';
  }

  @override
  String get onboardingTravelTitle => 'ଆପଣ କେତେ ଦୂର ଯିବେ?';

  @override
  String get onboardingTravelBody =>
      'ଆପଣ ଏବେ ଯେଉଁଠି ଅଛନ୍ତି ସେଠାରୁ ଏହି ଦୂରତା ମଧ୍ୟରେ ଥିବା କାମ ହିଁ ଆମେ ଦେବୁ।';

  @override
  String get onboardingTravelCentre =>
      'ଆମେ ଆପଣଙ୍କ ବର୍ତ୍ତମାନ ସ୍ଥାନକୁ କେନ୍ଦ୍ର ଭାବେ ବ୍ୟବହାର କରୁ। ଆପଣ ପ୍ରୋଫାଇଲ୍‌ରୁ ଯେକୌଣସି ସମୟରେ ବଦଳାଇପାରିବେ।';

  @override
  String get onboardingLocationOff =>
      'ଆପଣଙ୍କ କାମ ଅଞ୍ଚଳ ସେଟ୍ କରିବାକୁ ଲୋକେସନ୍ ଅନୁମତି ଚାଲୁ କରନ୍ତୁ।';

  @override
  String get commonSave => 'ସେଭ୍ କରନ୍ତୁ';

  @override
  String get notificationsStayOff =>
      'ବିଜ୍ଞପ୍ତି ବନ୍ଦ ରହିବ। ଆପଣ ଫୋନ୍ ସେଟିଂସରେ ଏହାକୁ ଚାଲୁ କରିପାରିବେ।';

  @override
  String get notificationsPrimerTitle => 'କାମ ଆସିଲେ ଖବର ପାଆନ୍ତୁ';

  @override
  String get notificationsPrimerBody =>
      'କାମ ଅଫର୍‌ର ମିଆଦ ଶେଷ ହୁଏ। ଆପ୍ ବନ୍ଦ ଥିବାବେଳେ ବିଜ୍ଞପ୍ତି ଦ୍ୱାରା ହିଁ ଆପଣ ଜାଣନ୍ତି — ଆଉ କିଛି ପଠାଯାଏ ନାହିଁ।';

  @override
  String get notificationsTurnOn => 'ବିଜ୍ଞପ୍ତି ଚାଲୁ କରନ୍ତୁ';

  @override
  String get commonNotNow => 'ଏବେ ନୁହେଁ';

  @override
  String get onboardingCityRequired => 'ଦୟାକରି ଆପଣଙ୍କ ସହର ଦିଅନ୍ତୁ';

  @override
  String get onboardingGenderRequired => 'ଦୟାକରି ଆପଣଙ୍କ ଲିଙ୍ଗ ବାଛନ୍ତୁ';

  @override
  String get onboardingWhereBased => 'ଆପଣ କେଉଁଠି ରୁହନ୍ତି?';
}
