// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Urdu (`ur`).
class AppLocalizationsUr extends AppLocalizations {
  AppLocalizationsUr([String locale = 'ur']) : super(locale);

  @override
  String get languagePickerTitle => 'اپنی زبان منتخب کریں';

  @override
  String get startupMissingConfig => 'اس بلڈ میں کنفیگریشن موجود نہیں۔';

  @override
  String startupPassDartDefine(Object keys) {
    return 'انہیں --dart-define کے ساتھ دیں:\n\n$keys';
  }

  @override
  String get startupCouldNotStart => 'ایپ شروع نہیں ہو سکی۔';

  @override
  String get errorNoInternet =>
      'انٹرنیٹ کنکشن نہیں ہے۔ اپنا نیٹ ورک چیک کریں اور دوبارہ کوشش کریں۔';

  @override
  String get errorTimeout => 'اس میں بہت وقت لگ گیا۔ دوبارہ کوشش کریں۔';

  @override
  String get errorServer =>
      'ہماری طرف کچھ غلط ہو گیا۔ براہ کرم دوبارہ کوشش کریں۔';

  @override
  String get errorClockSkew =>
      'آپ کے فون کی تاریخ اور وقت درست نہیں لگ رہے۔ سیٹنگز میں خودکار تاریخ اور وقت آن کریں، پھر دوبارہ کوشش کریں۔';

  @override
  String get errorUnexpected => 'کچھ غلط ہو گیا۔ براہ کرم دوبارہ کوشش کریں۔';

  @override
  String get eligibilityStepIncomplete => 'یہ مرحلہ ابھی مکمل نہیں ہوا۔';

  @override
  String get errorSessionEnded =>
      'آپ کا سیشن ختم ہو گیا ہے۔ براہ کرم دوبارہ سائن ان کریں۔';

  @override
  String get errorUploadFailed =>
      'وہ فائل اپ لوڈ نہیں ہو سکی۔ دوبارہ کوشش کریں۔';

  @override
  String get errorServiceUnavailable =>
      'یہ سروس ابھی دستیاب نہیں ہے۔ تھوڑی دیر میں دوبارہ کوشش کریں۔';

  @override
  String get errorSignInNotReady =>
      'آپ کا سائن اِن ابھی پوری طرح تیار نہیں ہے۔ تھوڑی دیر میں دوبارہ کوشش کریں۔';

  @override
  String get errorNoLongerAvailable => 'یہ اب دستیاب نہیں ہے۔';

  @override
  String get errorNotAllowedToSee => 'آپ اسے نہیں دیکھ سکتے۔';

  @override
  String get errorDidNotWork => 'یہ کام نہیں کیا۔ براہ کرم دوبارہ کوشش کریں۔';

  @override
  String get authErrorInvalidPhone => 'یہ فون نمبر درست نہیں لگ رہا۔';

  @override
  String get authErrorWrongCode =>
      'یہ کوڈ درست نہیں ہے۔ چیک کر کے دوبارہ کوشش کریں۔';

  @override
  String get authErrorCodeExpired =>
      'اس کوڈ کی میعاد ختم ہو گئی ہے۔ نیا کوڈ مانگیں۔';

  @override
  String get authErrorTooManyAttempts =>
      'بہت زیادہ کوششیں ہو گئیں۔ دوبارہ کوشش سے پہلے چند منٹ انتظار کریں۔';

  @override
  String get authErrorQuota =>
      'ہم ابھی کوڈ نہیں بھیج سکتے۔ تھوڑی دیر میں دوبارہ کوشش کریں۔';

  @override
  String get authErrorDisabled =>
      'یہ اکاؤنٹ بند کر دیا گیا ہے۔ سپورٹ سے رابطہ کریں۔';

  @override
  String get authErrorPhoneNotEnabledRegion =>
      'فون سے سائن اِن فعال نہیں ہے، یا اس علاقے میں SMS بلاک ہے۔ Firebase Console کی سیٹنگز چیک کریں۔';

  @override
  String get authErrorNumberInUse =>
      'یہ نمبر پہلے سے کسی دوسرے اکاؤنٹ میں رجسٹرڈ ہے۔';

  @override
  String get authErrorSignInAgain =>
      'جاری رکھنے کے لیے براہ کرم دوبارہ سائن ان کریں۔';

  @override
  String get authErrorSignInFailed =>
      'سائن اِن ناکام ہو گیا۔ براہ کرم دوبارہ کوشش کریں۔';

  @override
  String get budgetTypeFlexible => 'لچکدار';

  @override
  String get budgetTypeFixed => 'مقررہ قیمت';

  @override
  String get budgetTypeRange => 'قیمت کی حد';

  @override
  String get scheduleAsap => 'جتنی جلدی ممکن ہو';

  @override
  String get scheduleToday => 'آج';

  @override
  String get scheduleTomorrow => 'کل';

  @override
  String get scheduleSpecificDate => 'مخصوص تاریخ';

  @override
  String get offerStatusSubmitted => 'جمع کرائی گئی';

  @override
  String get offerStatusViewed => 'کسٹمر نے دیکھی';

  @override
  String get offerStatusShortlisted => 'شارٹ لسٹ';

  @override
  String get offerStatusAccepted => 'قبول ✓';

  @override
  String get offerStatusRejected => 'منتخب نہیں';

  @override
  String get offerStatusWithdrawn => 'واپس لی گئی';

  @override
  String get offerStatusExpired => 'میعاد ختم';

  @override
  String get offerStatusClosed => 'بند';

  @override
  String distanceMetresAway(Object metres) {
    return '$metres میٹر دور';
  }

  @override
  String distanceKmAway(Object km) {
    return '$km کلومیٹر دور';
  }

  @override
  String offerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count آفرز',
      one: '1 آفر',
      zero: 'ابھی کوئی آفر نہیں',
    );
    return '$_temp0';
  }

  @override
  String get gigErrorTrade => 'منتخب کریں کہ یہ سروس کس کام سے متعلق ہے';

  @override
  String get gigErrorTitleShort => 'اس سروس کو کم از کم 6 حروف کا واضح نام دیں';

  @override
  String get gigErrorTitleLong => 'نام 120 حروف سے کم رکھیں';

  @override
  String get gigErrorPrice => 'اس سروس کے لیے آپ کتنا لیتے ہیں درج کریں';

  @override
  String get gigErrorDurationMissing => 'اس میں عام طور پر کتنا وقت لگتا ہے؟';

  @override
  String get gigErrorDurationShort =>
      'ہم جو سب سے چھوٹا کام درج کر سکتے ہیں وہ 15 منٹ کا ہے';

  @override
  String get gigErrorDurationLong =>
      'ہم جو سب سے لمبا کام درج کر سکتے ہیں وہ 14 دن کا ہے';

  @override
  String get gigErrorRadius =>
      'سفر کا فاصلہ 1 سے 100 کلومیٹر کے درمیان ہونا چاہیے';

  @override
  String get jobAreaNearby => 'قریب';

  @override
  String get jobBlockerVerifyArrival => 'کسٹمر کے کوڈ سے آمد کی تصدیق کریں';

  @override
  String get jobBlockerAfterPhoto => 'مکمل کام کی تصویر شامل کریں';

  @override
  String jobBlockerMaterialsPending(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'سامان کی $count درخواستیں ابھی کسٹمر کے انتظار میں ہیں',
      one: 'سامان کی 1 درخواست ابھی کسٹمر کے انتظار میں ہے',
    );
    return '$_temp0';
  }

  @override
  String mediaTypeNotAccepted(Object kinds) {
    return 'یہاں اس قسم کی فائل قبول نہیں۔ $kinds استعمال کریں۔';
  }

  @override
  String get mediaEmpty => 'یہ فائل خالی ہے۔';

  @override
  String mediaTooLarge(Object megabytes) {
    return 'یہ فائل بہت بڑی ہے۔ حد ${megabytes}MB ہے۔';
  }

  @override
  String get verificationNotStarted => 'شروع نہیں ہوا';

  @override
  String get verificationSubmitted => 'جمع کرائی گئی';

  @override
  String get verificationUnderReview => 'جائزہ جاری ہے';

  @override
  String get verificationMoreInfo => 'مزید معلومات درکار';

  @override
  String get verificationExpired => 'میعاد ختم';

  @override
  String get verificationVerified => 'تصدیق شدہ';

  @override
  String get verificationNotApproved => 'منظور نہیں';

  @override
  String get verificationNotRequired => 'ضروری نہیں';

  @override
  String get qualificationErrorInstitution => 'یہ کس ادارے نے جاری کیا؟';

  @override
  String get qualificationErrorName => 'اس قابلیت کا نام کیا ہے؟';

  @override
  String get qualificationErrorYearMissing => 'آپ نے یہ کس سال مکمل کیا؟';

  @override
  String qualificationErrorYearRange(Object year) {
    return '1950 اور $year کے درمیان سال درج کریں';
  }

  @override
  String get walletTxJobEarning => 'کام کی کمائی';

  @override
  String get walletTxMaterialReimbursed => 'سامان کی ادائیگی واپس';

  @override
  String get walletTxAdjustment => 'ایڈجسٹمنٹ';

  @override
  String get walletTxPayoutReturned => 'پے آؤٹ واپس آیا';

  @override
  String get walletTxPlatformFee => 'پلیٹ فارم فیس';

  @override
  String get walletTxWithdrawn => 'واپس لی گئی';

  @override
  String get walletTxClaimRecovery => 'کلیم کی وصولی';

  @override
  String get payoutStatusRequested => 'درخواست کی گئی';

  @override
  String get payoutStatusProcessing => 'کارروائی جاری';

  @override
  String get payoutStatusPaid => 'ادائیگی ہو گئی';

  @override
  String get payoutStatusFailed => 'ناکام';

  @override
  String get authPhoneTenDigits => '10 ہندسوں کا موبائل نمبر درج کریں۔';

  @override
  String get authCodeSendTimeout =>
      'ہم کوڈ نہیں بھیج سکے۔ اپنا نیٹ ورک چیک کریں اور دوبارہ کوشش کریں۔';

  @override
  String get authEnterReceivedCode => 'آپ کو ملنے والا کوڈ درج کریں۔';

  @override
  String get authSignInIncomplete =>
      'سائن اِن مکمل نہیں ہوا۔ براہ کرم دوبارہ کوشش کریں۔';

  @override
  String get authSignInToContinue => 'جاری رکھنے کے لیے براہ کرم سائن ان کریں۔';

  @override
  String get accountDeletionBySupport =>
      'اکاؤنٹ حذف کرنے کا کام ہماری سپورٹ ٹیم کرتی ہے۔ درخواست دیں اور کام مکمل ہونے پر ہم تصدیق کریں گے۔';

  @override
  String get photoUploadFailed => 'یہ تصویر اپ لوڈ نہیں ہو سکی۔';

  @override
  String get photoUploadFailedRetry =>
      'یہ تصویر اپ لوڈ نہیں ہو سکی۔ دوبارہ کوشش کریں۔';

  @override
  String get locationInvalid => 'یہ مقام درست نہیں لگ رہا۔';

  @override
  String get travelDistanceRange =>
      '1 سے 100 کلومیٹر کے درمیان سفر کا فاصلہ منتخب کریں۔';

  @override
  String get profileLoadFailed => 'آپ کی پروفائل لوڈ نہیں ہو سکی۔';

  @override
  String get uploadIncomplete => 'اپ لوڈ مکمل نہیں ہوا۔ دوبارہ کوشش کریں۔';

  @override
  String get uploadTooLarge => 'یہ فائل بہت بڑی ہے۔';

  @override
  String get uploadTypeNotAccepted => 'اس قسم کی فائل قبول نہیں۔';

  @override
  String get uploadRefused => 'یہ فائل مسترد کر دی گئی۔';

  @override
  String get uploadTooMany =>
      'ایک ساتھ بہت زیادہ اپ لوڈز۔ تھوڑا انتظار کر کے دوبارہ کوشش کریں۔';

  @override
  String get uploadGone => 'یہ اپ لوڈ اب دستیاب نہیں۔ فائل دوبارہ منتخب کریں۔';

  @override
  String get uploadDidNotStart => 'اپ لوڈ شروع نہیں ہوا۔';

  @override
  String get uploadDidNotFinish => 'یہ اپ لوڈ مکمل نہیں ہوا۔';

  @override
  String get claimResponseTooShort =>
      'براہ کرم تھوڑی مزید تفصیل سے بتائیں کہ کیا ہوا۔';

  @override
  String get walletLoadFailedRetry =>
      'آپ کا والیٹ لوڈ نہیں ہو سکا۔ براہ کرم دوبارہ کوشش کریں۔';

  @override
  String get walletLoadFailed => 'آپ کا والیٹ لوڈ نہیں ہو سکا۔';

  @override
  String get onboardingStepDetails => 'آپ کی تفصیلات';

  @override
  String get onboardingStepTrade => 'آپ کا بنیادی کام';

  @override
  String get onboardingStepSkills => 'آپ کیا کر سکتے ہیں';

  @override
  String get onboardingStepArea => 'آپ کہاں کام کرتے ہیں';

  @override
  String get onboardingStepKyc => 'شناخت کی جانچ';

  @override
  String get onboardingStepReady => 'کام کے لیے تیار';

  @override
  String routerScreenNotFound(Object location) {
    return 'یہ اسکرین نہیں کھل سکی۔\n$location';
  }

  @override
  String get cameraOpenFailed => 'کیمرا نہیں کھل سکا۔ ایپ کی اجازتیں چیک کریں۔';

  @override
  String get commonTryAgain => 'دوبارہ کوشش کریں';

  @override
  String get commonCancel => 'منسوخ کریں';

  @override
  String get commonConfirm => 'تصدیق کریں';

  @override
  String get offlineBanner =>
      'آپ آف لائن ہیں۔ دوبارہ جڑنے پر کام کی کارروائیاں پھر سے چلیں گی۔';

  @override
  String get badgeNew => 'نیا';

  @override
  String get badgeAccepted => 'قبول';

  @override
  String get badgeConfirmed => 'تصدیق شدہ';

  @override
  String get badgeOnTheWay => 'راستے میں';

  @override
  String get badgeArrived => 'پہنچ گئے';

  @override
  String get badgeWorking => 'کام جاری';

  @override
  String get badgeAwaitingCustomer => 'کسٹمر کا انتظار';

  @override
  String get badgeDone => 'مکمل';

  @override
  String get badgePaymentDue => 'ادائیگی باقی';

  @override
  String get badgePaid => 'ادائیگی ہو گئی';

  @override
  String get badgeClosed => 'بند';

  @override
  String get badgeCancelled => 'منسوخ';

  @override
  String get badgeDisputed => 'متنازع';

  @override
  String get badgeExpired => 'میعاد ختم';

  @override
  String get badgeDraft => 'مسودہ';

  @override
  String get badgeInReview => 'جائزے میں';

  @override
  String get badgeLive => 'لائیو';

  @override
  String get badgePaused => 'موقوف';

  @override
  String get badgeNotApproved => 'منظور نہیں';

  @override
  String get badgeRemoved => 'ہٹا دیا گیا';

  @override
  String get badgeNotStarted => 'شروع نہیں ہوا';

  @override
  String get badgeSubmitted => 'جمع کرائی گئی';

  @override
  String get badgeActionNeeded => 'کارروائی درکار';

  @override
  String get badgeVerified => 'تصدیق شدہ';

  @override
  String get badgeNotRequired => 'ضروری نہیں';

  @override
  String get commonContinue => 'جاری رکھیں';

  @override
  String get commonSaving => 'محفوظ ہو رہا ہے…';

  @override
  String get welcomePromiseWorkTitle => 'مناسب کام پائیں';

  @override
  String get welcomePromiseWorkBody =>
      'آپ کے قریب کے کام، جو آپ کے اصل کاموں سے میل کھاتے ہیں۔';

  @override
  String get welcomePromiseSkillsTitle => 'اپنی مہارت ثابت کریں';

  @override
  String get welcomePromiseSkillsBody =>
      'آپ کے ITI اور ڈپلومہ سرٹیفکیٹ، ایک بار تصدیق ہو کر ہر کسٹمر کو دکھائے جاتے ہیں۔';

  @override
  String get welcomePromiseTrackTitle => 'ہر کام پر نظر رکھیں';

  @override
  String get welcomePromiseTrackBody =>
      'کام قبول کرنے سے مکمل کرنے تک، ہر مرحلے پر تصویری ریکارڈ کے ساتھ۔';

  @override
  String get welcomePromisePaidTitle => 'محفوظ طریقے سے ادائیگی پائیں';

  @override
  String get welcomePromisePaidBody =>
      'ہر روپیہ درج، واضح اسٹیٹمنٹ کے ساتھ اور آپ کی شرائط پر رقم نکالنا۔';

  @override
  String get welcomeHeadline => 'کام جو آپ کو ڈھونڈے';

  @override
  String get welcomeSubtitle =>
      'Wervexa ہنرمند ماہرین کو ان کسٹمرز سے جوڑتا ہے جنہیں ان کی ضرورت ہے۔';

  @override
  String get welcomeGetStarted => 'شروع کریں';

  @override
  String get welcomeCodeNotice =>
      'ہم آپ کے موبائل نمبر پر ایک بار کا کوڈ بھیجیں گے۔';

  @override
  String get phoneTitle => 'آپ کا موبائل نمبر کیا ہے؟';

  @override
  String get phoneSubtitle =>
      'یہ آپ ہی ہیں، اس کی تصدیق کے لیے ہم ایک بار کا کوڈ بھیجیں گے۔';

  @override
  String get phoneSendCode => 'کوڈ بھیجیں';

  @override
  String get phoneSending => 'بھیجا جا رہا ہے…';

  @override
  String get authNewCodeSent => 'ہم نے نیا کوڈ بھیج دیا ہے۔';

  @override
  String get otpTitle => 'کوڈ درج کریں';

  @override
  String otpSentTo(Object phone) {
    return 'ہم نے $phone پر 6 ہندسوں کا کوڈ بھیجا ہے۔';
  }

  @override
  String otpResendIn(int seconds) {
    String _temp0 = intl.Intl.pluralLogic(
      seconds,
      locale: localeName,
      other: 'آپ $seconds سیکنڈ میں نیا کوڈ مانگ سکتے ہیں',
      one: 'آپ 1 سیکنڈ میں نیا کوڈ مانگ سکتے ہیں',
    );
    return '$_temp0';
  }

  @override
  String get otpSendNew => 'نیا کوڈ بھیجیں';

  @override
  String get otpVerify => 'تصدیق کریں';

  @override
  String get otpVerifying => 'تصدیق ہو رہی ہے…';

  @override
  String get registerNameRequired => 'براہ کرم اپنا پورا نام درج کریں';

  @override
  String get registerEmailInvalid => 'براہ کرم درست ای میل پتہ درج کریں';

  @override
  String get registerTitle => 'ہم آپ کو کس نام سے پکاریں؟';

  @override
  String get registerSubtitle => 'کسٹمرز یہی نام دیکھیں گے۔';

  @override
  String get registerNameLabel => 'پورا نام';

  @override
  String get registerNameHint => 'ارون کمار';

  @override
  String get registerEmailLabel => 'ای میل (اختیاری)';

  @override
  String get registerEmailHelper => 'رسیدوں اور اسٹیٹمنٹس کے لیے۔';

  @override
  String registerVerifiedPhone(Object phone) {
    return 'تصدیق شدہ: $phone';
  }

  @override
  String get navHome => 'ہوم';

  @override
  String get navJobs => 'کام';

  @override
  String get navWallet => 'والیٹ';

  @override
  String get navProfile => 'پروفائل';

  @override
  String get sessionProfileLoadFailedRetry =>
      'ہم آپ کی پروفائل لوڈ نہیں کر سکے۔ براہ کرم دوبارہ کوشش کریں۔';

  @override
  String get commonSignOut => 'سائن آؤٹ کریں';

  @override
  String get serviceElectrical => 'بجلی کا کام';

  @override
  String get servicePlumbing => 'پلمبنگ';

  @override
  String get serviceAcService => 'AC سروس';

  @override
  String get serviceApplianceRepair => 'آلات کی مرمت';

  @override
  String get serviceCarpentry => 'بڑھئی کا کام';

  @override
  String get servicePainting => 'پینٹنگ';

  @override
  String get serviceCleaning => 'صفائی';

  @override
  String get servicePestControl => 'کیڑوں پر قابو';

  @override
  String get serviceOtherHome => 'گھر کی دیگر خدمات';

  @override
  String get commonSeeAll => 'سب دیکھیں';

  @override
  String distanceKm(Object km) {
    return '$km کلومیٹر';
  }

  @override
  String get homeRightNow => 'ابھی';

  @override
  String get homeNewWork => 'نیا کام';

  @override
  String homeJobsWaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count کام آپ کے جواب کے منتظر ہیں',
      one: '1 کام آپ کے جواب کا منتظر ہے',
    );
    return '$_temp0';
  }

  @override
  String get homeComingUp => 'آنے والے';

  @override
  String get homeEarnings => 'کمائی';

  @override
  String get homeMyServices => 'میری خدمات';

  @override
  String get homeVerification => 'تصدیق';

  @override
  String get homeSupport => 'سپورٹ';

  @override
  String get homeRequests => 'درخواستیں';

  @override
  String get homeMyOffers => 'میری آفرز';

  @override
  String get homeAddService => 'سروس شامل کریں';

  @override
  String get homeAddServiceBody =>
      'کسٹمرز آپ کو صرف انہی خدمات کے لیے بک کر سکتے ہیں جو آپ نے شائع کی ہیں۔';

  @override
  String get homeNotReady => 'ابھی پوری طرح تیار نہیں';

  @override
  String get homeNotReadyBody =>
      'یہ مراحل مکمل کریں اور آپ کو کام ملنا شروع ہو جائیں گے۔';

  @override
  String get homeGoodMorning => 'صبح بخیر';

  @override
  String get homeGoodAfternoon => 'سہ پہر بخیر';

  @override
  String get homeGoodEvening => 'شام بخیر';

  @override
  String get homeNotifications => 'اطلاعات';

  @override
  String get availabilityAvailable => 'دستیاب';

  @override
  String get availabilityAvailableBody => 'آپ نئے کام حاصل کر سکتے ہیں۔';

  @override
  String get availabilityOnJob => 'کام پر';

  @override
  String get availabilityOnJobBody =>
      'یہ کام مکمل ہونے تک آپ کو نیا کام نہیں دیا جائے گا۔';

  @override
  String get availabilityOff => 'بند';

  @override
  String get availabilityOffBody => 'آپ کو نئے کام نہیں ملیں گے۔';

  @override
  String get availabilityFinishJob =>
      'دوبارہ دستیاب ہونے کے لیے موجودہ کام مکمل کریں۔';

  @override
  String get availabilityGoOff => 'ڈیوٹی بند کریں';

  @override
  String get availabilityGoOn => 'دستیاب ہو جائیں';

  @override
  String get availabilityBeforeJobs => 'کام ملنے سے پہلے';

  @override
  String get availabilityNowOn => 'آپ کام کے لیے دستیاب ہیں۔';

  @override
  String get availabilityNowOff => 'آپ ڈیوٹی پر نہیں ہیں۔';

  @override
  String get workerStatusSetupIncomplete => 'سیٹ اپ نامکمل';

  @override
  String get workerStatusUnderReview => 'جائزے میں';

  @override
  String get workerStatusInactive => 'غیر فعال';

  @override
  String get workerStatusRestricted => 'محدود';

  @override
  String get workerStatusSuspended => 'معطل';

  @override
  String get homeAccount => 'اکاؤنٹ';

  @override
  String get homeWorkStatus => 'کام کی حیثیت';

  @override
  String get availabilityOffDuty => 'ڈیوٹی پر نہیں';

  @override
  String get earningsThisWeek => 'اس ہفتے';

  @override
  String get earningsThisMonth => 'اس مہینے';

  @override
  String get jobNextWaitConfirm => 'کسٹمر کی تصدیق کا انتظار';

  @override
  String get jobNextStartTravel => 'سفر شروع کریں';

  @override
  String get jobNextMarkArrived => 'پہنچنے کا نشان لگائیں';

  @override
  String get jobNextStartWork => 'کام شروع کریں';

  @override
  String get jobNextAskCode => 'کسٹمر سے آمد کا کوڈ مانگیں';

  @override
  String get jobNextFinish => 'مکمل کریں اور تصاویر شامل کریں';

  @override
  String get jobNextWaitApprove => 'کسٹمر کی منظوری کا انتظار';

  @override
  String get jobNextOpen => 'کام کھولیں';

  @override
  String get jobTimeTbc => 'وقت کی تصدیق باقی';

  @override
  String get settingsTitle => 'سیٹنگز';

  @override
  String get settingsLanguage => 'زبان';

  @override
  String get settingsAbout => 'بارے میں';

  @override
  String get settingsTerms => 'سروس کی شرائط';

  @override
  String get settingsPrivacy => 'رازداری کی پالیسی';

  @override
  String get settingsHelp => 'مدد اور سپورٹ';

  @override
  String get settingsDeleteAccount => 'میرا اکاؤنٹ حذف کریں';

  @override
  String get settingsSignOutTitle => 'سائن آؤٹ کریں؟';

  @override
  String get settingsSignOutBody =>
      'دوبارہ سائن ان کرنے کے لیے آپ کو اپنا فون نمبر اور ایک کوڈ درکار ہوگا۔';

  @override
  String get settingsDeleteTitle => 'اپنا اکاؤنٹ حذف کریں';

  @override
  String get settingsDeleteBody =>
      'اکاؤنٹ حذف کرنے سے آپ کے کام کی تاریخ، کمائی کے ریکارڈ اور کھلی ادائیگیاں متاثر ہوتی ہیں، اس لیے یہ خودکار طور پر نہیں بلکہ ہماری سپورٹ ٹیم کرتی ہے۔\n\nسپورٹ کی درخواست دیں اور کام مکمل ہونے پر ہم تصدیق کریں گے۔';

  @override
  String get settingsContactSupport => 'سپورٹ سے رابطہ کریں';

  @override
  String get notificationsMarkAllRead => 'سب کو پڑھا ہوا نشان زد کریں';

  @override
  String get notificationsEmpty => 'آپ نے سب دیکھ لیا ہے';

  @override
  String get notificationsEmptyBody =>
      'کام کی آفرز، ادائیگی کی اپ ڈیٹس اور تصدیق کے نتائج یہاں نظر آئیں گے۔';

  @override
  String get jobsTabUpcoming => 'آنے والے';

  @override
  String get jobsTabActive => 'فعال';

  @override
  String get jobsNoOffers => 'ابھی کوئی نیا کام نہیں';

  @override
  String get jobsNoOffersBody =>
      'جب آپ دستیاب ہوں گے تو مناسب کام آتے ہی ہم آپ کو بتائیں گے۔';

  @override
  String get jobsAccepted => 'کام قبول کر لیا گیا۔';

  @override
  String get jobsDeclineTitle => 'یہ کام مسترد کریں؟';

  @override
  String get jobsDeclineBody =>
      'یہ کسی دوسرے کارکن کو دیا جائے گا۔ بار بار مسترد کرنے سے آپ کو دکھائے جانے والے کام کم ہو سکتے ہیں۔';

  @override
  String get jobsDecline => 'مسترد کریں';

  @override
  String get jobsDeclined => 'کام مسترد کر دیا گیا۔';

  @override
  String get jobsEmptyUpcoming => 'کچھ طے نہیں';

  @override
  String get jobsEmptyUpcomingBody =>
      'آپ کے قبول کیے ہوئے کام یہاں نظر آئیں گے۔';

  @override
  String get jobsEmptyActive => 'کوئی کام جاری نہیں';

  @override
  String get jobsEmptyActiveBody =>
      'جب آپ کام شروع کریں گے تو وہ یہاں نظر آئے گا۔';

  @override
  String get jobsEmptyCompleted => 'ابھی کوئی مکمل کام نہیں';

  @override
  String get jobsEmptyCompletedBody =>
      'مکمل کام اور ان سے آپ کی کمائی یہاں درج ہوگی۔';

  @override
  String get jobsEmptyCancelled => 'کچھ منسوخ نہیں ہوا';

  @override
  String get jobsEmptyCancelledBody => 'منسوخ شدہ کام یہاں درج ہوں گے۔';

  @override
  String get jobsEmptyOffers => 'کوئی آفر نہیں';

  @override
  String get jobsEmptyOffersBody => 'نئے کام یہاں نظر آئیں گے۔';

  @override
  String get jobTitleFallback => 'کام';

  @override
  String jobCancelledReason(Object reason) {
    return 'منسوخ: $reason';
  }

  @override
  String get jobAmount => 'کام کی رقم';

  @override
  String get jobMaterials => 'سامان';

  @override
  String get jobYouEarned => 'آپ کی کمائی';

  @override
  String get jobRateCustomer => 'کسٹمر کو ریٹنگ دیں';

  @override
  String get jobRateQuestion => 'یہ کام آپ کے لیے کیسا رہا؟';

  @override
  String get jobRate => 'ریٹنگ دیں';

  @override
  String get jobHistory => 'کیا کیا ہوا';

  @override
  String get jobHistoryLoadFailed => 'کام کی تاریخ لوڈ نہیں ہو سکی۔';

  @override
  String get jobOfferExpired => 'یہ کام اب دستیاب نہیں ہے۔';

  @override
  String get jobOfferNewBadge => 'نیا کام';

  @override
  String get jobOfferYouEarn => 'آپ کی کمائی';

  @override
  String get jobOfferPriceAfterVisit => 'آنے کے بعد طے ہوگی';

  @override
  String get jobOfferAccept => 'کام قبول کریں';

  @override
  String get activeJobTitle => 'موجودہ کام';

  @override
  String get activeJobEmptyBody =>
      'جب آپ کام قبول کر کے شروع کریں گے تو وہ یہاں نظر آئے گا۔';

  @override
  String get evidenceBeforeTitle => 'شروع کرنے سے پہلے';

  @override
  String get evidenceBeforeBody =>
      'ہاتھ لگانے سے پہلے مسئلے کی تصویر لیں۔ اگر کسٹمر بعد میں کام پر اعتراض کرے تو یہ آپ کی حفاظت کرتی ہے۔';

  @override
  String get evidenceAfterTitle => 'مکمل کرنے کے بعد';

  @override
  String get evidenceAfterBody =>
      'اگر کسٹمر بعد میں اعتراض کرے تو مکمل کام کی تصویر آپ کا ثبوت ہے۔ اختیاری ہے، مگر دس سیکنڈ دینے کے لائق ہے۔';

  @override
  String get jobCustomerHidden =>
      'تصدیق کے بعد کسٹمر کی تفصیلات شیئر کی جائیں گی';

  @override
  String get jobCall => 'کال کریں';

  @override
  String get jobDirections => 'راستہ';

  @override
  String get jobTrackOnMap => 'نقشے پر ٹریک کریں';

  @override
  String get trailAccepted => 'قبول';

  @override
  String get trailOnTheWay => 'راستے میں';

  @override
  String get trailArrived => 'پہنچ گئے';

  @override
  String get trailArrivalConfirmed => 'آمد کی تصدیق ہو گئی';

  @override
  String get trailWorkStarted => 'کام شروع ہوا';

  @override
  String get trailFinished => 'مکمل ہوا';

  @override
  String get jobProgress => 'پیش رفت';

  @override
  String get jobBeforeFinish => 'مکمل کرنے سے پہلے';

  @override
  String get jobActionStartTravel => 'سفر شروع کریں';

  @override
  String get jobActionArrived => 'میں پہنچ گیا ہوں';

  @override
  String get jobActionEnterCode => 'آمد کا کوڈ درج کریں';

  @override
  String get jobActionStartWork => 'کام شروع کریں';

  @override
  String get jobActionFinish => 'کام مکمل کریں';

  @override
  String get jobArrivalConfirmed => 'آمد کی تصدیق ہو گئی۔';

  @override
  String get jobFinishTitle => 'یہ کام مکمل کریں؟';

  @override
  String get jobFinishBody =>
      'کسٹمر سے کام کی منظوری کے لیے کہا جائے گا۔ اس کے بعد آپ تصاویر شامل نہیں کر سکیں گے۔';

  @override
  String get jobOnYourWay => 'آپ راستے میں ہیں۔';

  @override
  String get jobMarkedArrived => 'پہنچنے کا نشان لگا دیا گیا۔';

  @override
  String get jobWorkStarted => 'کام شروع ہو گیا۔';

  @override
  String get jobSentForApproval => 'منظوری کے لیے کسٹمر کو بھیج دیا گیا۔';

  @override
  String get jobUpdated => 'اپ ڈیٹ ہو گیا۔';

  @override
  String get jobWaitConfirm => 'کسٹمر کے بکنگ کی تصدیق کرنے کا انتظار۔';

  @override
  String get jobWaitApprove => 'کسٹمر کے آپ کے کام کی منظوری دینے کا انتظار۔';

  @override
  String get jobWaitPaymentProcessing =>
      'منظور ہو گیا۔ ادائیگی پر کارروائی جاری ہے۔';

  @override
  String get jobWaitPayment => 'کسٹمر کی ادائیگی کا انتظار۔';

  @override
  String get jobWaitPaid =>
      'ادائیگی ہو گئی۔ آپ کی کمائی آپ کے والیٹ میں نظر آئے گی۔';

  @override
  String get jobWaitDisputed =>
      'ہماری ٹیم اس کام کا جائزہ لے رہی ہے۔ ہم رابطہ کریں گے۔';

  @override
  String get jobWaitNothing => 'ابھی کرنے کو کچھ نہیں۔';

  @override
  String get travelRouteUnavailable => 'راستہ دستیاب نہیں';

  @override
  String get travelNoDestination => 'کوئی منزل سیٹ نہیں';

  @override
  String get travelNoDestinationBody =>
      'اس کام کا کوئی سروس مقام نہیں جس تک راستہ دکھایا جا سکے۔';

  @override
  String get travelJobLocation => 'کام کا مقام';

  @override
  String get travelYou => 'آپ';

  @override
  String get travelCustomer => 'کسٹمر';

  @override
  String get travelCalculating => 'راستہ معلوم کیا جا رہا ہے...';

  @override
  String distanceMetres(Object metres) {
    return '$metres میٹر';
  }

  @override
  String etaMinutes(Object minutes) {
    return '$minutes منٹ';
  }

  @override
  String etaHours(Object hours) {
    return '$hours گھنٹے';
  }

  @override
  String get arrivalWrongCode => 'یہ کوڈ درست نہیں ہے۔';

  @override
  String arrivalWrongCodeAttempts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'یہ کوڈ درست نہیں ہے۔ $count کوششیں باقی ہیں۔',
      one: 'یہ کوڈ درست نہیں ہے۔ 1 کوشش باقی ہے۔',
    );
    return '$_temp0';
  }

  @override
  String get arrivalTitle => 'تصدیق کریں کہ آپ پہنچ گئے ہیں';

  @override
  String get arrivalBody =>
      'کسٹمر سے ان کی ایپ کا کوڈ پڑھ کر سنانے کو کہیں، پھر اسے یہاں لکھیں۔';

  @override
  String get arrivalLocked =>
      'بہت زیادہ غلط کوڈ۔ یہ کام جاری رکھنے کے لیے براہ کرم سپورٹ سے رابطہ کریں۔';

  @override
  String get arrivalConfirm => 'آمد کی تصدیق کریں';

  @override
  String get arrivalNotYet => 'ابھی نہیں';

  @override
  String get rateThanks => 'آپ کی رائے کا شکریہ۔';

  @override
  String get rateTitle => 'یہ کسٹمر کیسے تھے؟';

  @override
  String get rateBody =>
      'آپ کی ریٹنگ نجی ہے اور کارکنوں کا خیال رکھنے میں ہماری مدد کرتی ہے۔';

  @override
  String get rateCommentLabel => 'کچھ اور کہنا ہے؟ (اختیاری)';

  @override
  String get rateSubmit => 'ریٹنگ جمع کریں';

  @override
  String get timerServiceTime => 'سروس کا وقت';

  @override
  String get materialsAdd => 'شامل کریں';

  @override
  String get materialsLoadFailed => 'سامان لوڈ نہیں ہو سکا۔';

  @override
  String get materialsEmpty =>
      'اگر اس کام کے لیے پرزے چاہییں تو انہیں یہاں شامل کریں، اور کسٹمر سے لاگت منظور کرنے کو کہا جائے گا۔';

  @override
  String get materialStatusWaiting => 'کسٹمر کا انتظار';

  @override
  String get materialStatusApproved => 'منظور';

  @override
  String get materialStatusDeclined => 'مسترد';

  @override
  String get materialStatusBought => 'خرید لیا';

  @override
  String get materialStatusCostRecorded => 'لاگت درج';

  @override
  String get materialStatusBilled => 'بل میں';

  @override
  String get materialStatusCancelled => 'منسوخ';

  @override
  String materialQuantityEstimated(Object quantity, Object unit) {
    return '$quantity $unit · تخمینی';
  }

  @override
  String materialQuantityActual(Object quantity, Object unit) {
    return '$quantity $unit · اصل';
  }

  @override
  String get materialRecordCost => 'لاگت درج کریں';

  @override
  String materialCustomerSaid(Object reason) {
    return 'کسٹمر نے کہا: $reason';
  }

  @override
  String get materialUnitPiece => 'عدد';

  @override
  String get materialWhatNeeded => 'آپ کو کیا چاہیے؟';

  @override
  String get materialEnterQuantity => 'کتنے چاہییں درج کریں';

  @override
  String get materialEnterCost => 'تخمینی لاگت درج کریں';

  @override
  String get materialRequestBody =>
      'خریدنے سے پہلے کسٹمر سے اس کی منظوری لی جائے گی۔';

  @override
  String get materialName => 'سامان';

  @override
  String get materialNameHint => 'مثلاً 16A ماڈیولر سوئچ';

  @override
  String get materialQuantity => 'مقدار';

  @override
  String get materialUnit => 'اکائی';

  @override
  String get materialExpectedCost => 'تخمینی لاگت';

  @override
  String get materialAskCustomer => 'کسٹمر سے پوچھیں';

  @override
  String get materialEnterPaid => 'آپ نے جو رقم ادا کی وہ درج کریں';

  @override
  String get materialCostRecorded => 'لاگت درج ہو گئی۔';

  @override
  String get materialWhatCost => 'اس کی لاگت کتنی تھی؟';

  @override
  String get materialReceiptBody =>
      'رسید منسلک کریں تاکہ اسے کسٹمر کے بل میں شامل کیا جا سکے۔';

  @override
  String get materialAmountPaid => 'ادا کی گئی رقم';

  @override
  String get materialReceipt => 'رسید';

  @override
  String get materialReceiptRequired => 'بل کی تصویر ضروری ہے۔';

  @override
  String get evidenceDone => 'مکمل';

  @override
  String get evidenceRequired => 'ضروری';

  @override
  String get evidenceCamera => 'کیمرا';

  @override
  String get evidenceGallery => 'گیلری';

  @override
  String get evidenceSaved => 'محفوظ';

  @override
  String get uploadWaiting => 'انتظار';

  @override
  String get uploadPreparing => 'تیاری';

  @override
  String get uploadStarting => 'اپ لوڈ شروع ہو رہا ہے';

  @override
  String uploadPercent(Object percent) {
    return '$percent%';
  }

  @override
  String get uploadFinishing => 'مکمل ہو رہا ہے';

  @override
  String get uploadCancel => 'اپ لوڈ منسوخ کریں';

  @override
  String get uploadNotFinished => 'یہ اپ لوڈ مکمل نہیں ہوا۔';

  @override
  String get commonRetry => 'دوبارہ کوشش کریں';

  @override
  String durationMinutes(Object minutes) {
    return '$minutes منٹ';
  }

  @override
  String durationHours(Object hours) {
    return '$hours گھنٹے';
  }

  @override
  String durationHoursMinutes(Object hours, Object minutes) {
    return '$hours گھنٹے $minutes منٹ';
  }

  @override
  String durationDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count دن',
      one: '1 دن',
    );
    return '$_temp0';
  }

  @override
  String pricePerHour(Object price) {
    return '$price/گھنٹہ';
  }

  @override
  String pricePerDay(Object price) {
    return '$price/دن';
  }

  @override
  String pricePerUnit(Object price) {
    return '$price/یونٹ';
  }

  @override
  String pricePerSqft(Object price) {
    return '$price/مربع فٹ';
  }

  @override
  String get gigsTitle => 'میری خدمات';

  @override
  String get gigsAddTooltip => 'سروس شامل کریں';

  @override
  String get gigsAdd => 'سروس شامل کریں';

  @override
  String get gigsEmpty => 'ابھی کوئی سروس نہیں';

  @override
  String get gigsEmptyBody =>
      'آپ جو خدمات پیش کرتے ہیں وہ شامل کریں۔ جن کاموں کے لیے آپ منظور ہیں ان سب میں جتنی چاہیں خدمات شامل کر سکتے ہیں۔';

  @override
  String get gigsNoneLive =>
      'آپ کی کوئی سروس فعال نہیں، اس لیے کسٹمرز آپ کو بک نہیں کر سکتے۔';

  @override
  String gigsLiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count خدمات فعال ہیں۔',
      one: '1 سروس فعال ہے۔',
    );
    return '$_temp0';
  }

  @override
  String get gigsAvailable => 'آپ کام کے لیے دستیاب ہیں۔';

  @override
  String get gigsOffDuty =>
      'آپ ڈیوٹی پر نہیں ہیں، اس لیے آپ کو کام نہیں دیے جائیں گے۔';

  @override
  String gigJobsDone(int count) {
    return '$count مکمل';
  }

  @override
  String get gigEdit => 'ترمیم کریں';

  @override
  String get gigPause => 'روکیں';

  @override
  String get gigResume => 'دوبارہ شروع کریں';

  @override
  String get gigInReview => 'جائزے میں';

  @override
  String get gigDraftHint => 'مسودہ — جائزے کے لیے جمع کریں';

  @override
  String get gigRejectedHint => 'مسترد — ترمیم کر کے دوبارہ جمع کریں';

  @override
  String get gigArchived => 'آرکائیو';

  @override
  String get gigNotLive => 'فعال نہیں';

  @override
  String get gigPaused => 'روک دیا گیا۔ آپ کو یہ کام نہیں دیے جائیں گے۔';

  @override
  String get gigLiveAgain => 'دوبارہ فعال۔';

  @override
  String get gigDuration30m => '30 منٹ';

  @override
  String get gigDuration45m => '45 منٹ';

  @override
  String get gigDuration1h => '1 گھنٹہ';

  @override
  String get gigDuration2h => '2 گھنٹے';

  @override
  String get gigDuration4h => '4 گھنٹے';

  @override
  String get gigDuration8h => '8 گھنٹے (ایک کام کا دن)';

  @override
  String get gigDuration24h => '24 گھنٹے';

  @override
  String get gigDuration2d => '2 دن';

  @override
  String get gigDuration3d => '3 دن';

  @override
  String get gigDuration1w => '1 ہفتہ';

  @override
  String get gigSavedDraft => 'مسودے کے طور پر محفوظ۔';

  @override
  String get gigSubmitted => 'جمع ہو گیا۔ ہم جائزہ لے کر آپ کو بتائیں گے۔';

  @override
  String get gigLive => 'آپ کی سروس فعال ہے۔';

  @override
  String get gigSaved => 'محفوظ ہو گیا۔';

  @override
  String get gigEditorAddTitle => 'سروس شامل کریں';

  @override
  String get gigEditorEditTitle => 'سروس میں ترمیم کریں';

  @override
  String get gigNoTrades => 'ابھی کوئی منظور شدہ کام نہیں';

  @override
  String get gigNoTradesBody =>
      'کسی کام کی منظوری ملنے پر آپ اس کے تحت خدمات شائع کر سکتے ہیں۔ شروع کرنے کے لیے اپنی پروفائل سے ایک کام شامل کریں۔';

  @override
  String get gigFieldTrade => 'کون سا کام؟';

  @override
  String get gigFieldTitle => 'اس سروس کا نام کیا ہے؟';

  @override
  String get gigFieldTitleHint => 'کسٹمرز یہ دیکھتے ہیں۔ واضح لکھیں۔';

  @override
  String get gigFieldTitleExample => 'مثلاً اسپلٹ AC کی گہری صفائی';

  @override
  String get gigFieldDescription => 'اس میں کیا کیا شامل ہے؟';

  @override
  String get gigFieldDescriptionHint =>
      'اختیاری، مگر اس سے کسٹمرز کو آپ کو منتخب کرنے میں مدد ملتی ہے۔';

  @override
  String get gigFieldDescriptionExample =>
      'مثلاً اندرونی اور بیرونی یونٹ کی مکمل صفائی، فلٹر کی دھلائی، گیس پریشر کی جانچ۔';

  @override
  String get gigFieldPrice => 'آپ کتنا لیتے ہیں؟';

  @override
  String get gigFieldPriceHint =>
      'ہر سروس کی اپنی قیمت ہوتی ہے۔ اس سے آپ کی دوسری خدمات متاثر نہیں ہوتیں۔';

  @override
  String get gigUnitPerJob => 'فی کام';

  @override
  String get gigUnitPerHour => 'فی گھنٹہ';

  @override
  String get gigUnitPerDay => 'فی دن';

  @override
  String get gigUnitPerUnit => 'فی یونٹ';

  @override
  String get gigUnitPerSqft => 'فی مربع فٹ';

  @override
  String get gigFieldDuration => 'اس میں عام طور پر کتنا وقت لگتا ہے؟';

  @override
  String get gigFieldRadius => 'اس کے لیے آپ کتنی دور جائیں گے؟';

  @override
  String get gigFieldRadiusHint =>
      'اپنا معمول کا سفری فاصلہ استعمال کرنے کے لیے ڈیفالٹ رہنے دیں۔';

  @override
  String get gigUsualDistance => 'آپ کا معمول کا فاصلہ';

  @override
  String get gigUseUsualDistance => 'میرا معمول کا فاصلہ استعمال کریں';

  @override
  String get gigReviewNotice =>
      'نئی اور ترمیم شدہ خدمات فعال ہونے سے پہلے ہماری ٹیم جانچتی ہے۔ مکمل ہوتے ہی ہم آپ کو بتائیں گے۔';

  @override
  String get gigSaveDraft => 'مسودہ محفوظ کریں';

  @override
  String get gigSubmitForReview => 'جائزے کے لیے جمع کریں';

  @override
  String get walletAllTransactions => 'تمام لین دین';

  @override
  String get walletFrozen =>
      'ایک معاملے کی جانچ کے دوران رقم نکالنا روک دیا گیا ہے۔ تفصیلات کے لیے سپورٹ سے رابطہ کریں۔';

  @override
  String get walletWithdraw => 'رقم نکالیں';

  @override
  String walletNothingPending(Object amount) {
    return 'ابھی نکالنے کو کچھ نہیں۔ $amount پر ابھی کارروائی جاری ہے اور ان کاموں کی منظوری کے بعد آپ کے بیلنس میں آ جائے گا۔';
  }

  @override
  String get walletNothingYet =>
      'ابھی نکالنے کو کچھ نہیں۔ کسٹمر کے مکمل کام کی منظوری دینے پر آپ کی کمائی یہاں نظر آئے گی۔';

  @override
  String get walletRecentEarnings => 'حالیہ کمائی';

  @override
  String get walletNoEarnings => 'ابھی کوئی کمائی نہیں';

  @override
  String get walletNoEarningsBody =>
      'مکمل کام کی ادائیگی ہونے پر آپ کی کمائی یہاں نظر آئے گی۔';

  @override
  String get walletAvailable => 'نکالنے کے لیے دستیاب';

  @override
  String get walletProcessing => 'کارروائی جاری';

  @override
  String get walletProcessingHint => 'روکنے کی مدت کے بعد جاری ہوگی';

  @override
  String get walletTotalEarned => 'کُل کمائی';

  @override
  String get statementTitle => 'اسٹیٹمنٹ';

  @override
  String get statementTabTransactions => 'لین دین';

  @override
  String get statementTabWithdrawals => 'نکالی گئی رقم';

  @override
  String get statementEmpty => 'ابھی کچھ نہیں';

  @override
  String get statementEmptyBody =>
      'کام شروع کرنے کے بعد ہر ادائیگی، فیس اور رقم نکالنا یہاں درج ہوگا۔';

  @override
  String statementBalance(Object amount) {
    return 'بیلنس $amount';
  }

  @override
  String get statementNoWithdrawals => 'ابھی کوئی رقم نہیں نکالی گئی';

  @override
  String get statementNoWithdrawalsBody =>
      'جب آپ رقم نکالیں گے تو اس کا حساب یہاں رکھا جائے گا۔';

  @override
  String payoutRequestedAt(Object date) {
    return '$date کو درخواست کی گئی';
  }

  @override
  String payoutPaidAt(Object date) {
    return '$date کو ادا کی گئی';
  }

  @override
  String get payoutEnterAmount => 'کتنی رقم نکالنا چاہتے ہیں درج کریں';

  @override
  String payoutUpTo(Object amount) {
    return 'آپ ابھی $amount تک نکال سکتے ہیں';
  }

  @override
  String payoutMinimum(Object amount) {
    return 'کم سے کم نکالنے کی رقم $amount ہے';
  }

  @override
  String payoutRequested(Object amount) {
    return '$amount نکالنے کی درخواست کی گئی۔ کارروائی کے دوران ہم آپ کو بتاتے رہیں گے۔';
  }

  @override
  String get payoutAvailableNow => 'ابھی دستیاب';

  @override
  String payoutPendingMore(Object amount) {
    return 'مزید $amount پر ابھی کارروائی جاری ہے اور ابھی نہیں نکالا جا سکتا۔';
  }

  @override
  String get payoutHowMuch => 'کتنا؟';

  @override
  String get payoutAll => 'سب';

  @override
  String payoutPercent(Object percent) {
    return '$percent%';
  }

  @override
  String get payoutProcessNotice =>
      'رقم نکالنے کی درخواستیں جانچ کر آپ کے رجسٹرڈ بینک اکاؤنٹ میں بھیجی جاتی ہیں۔ ہر مرحلے پر حیثیت یہاں نظر آئے گی۔';

  @override
  String get payoutRequest => 'رقم نکالنے کی درخواست کریں';

  @override
  String get bankChecking => 'آپ کا بینک اکاؤنٹ چیک کیا جا رہا ہے…';

  @override
  String bankPaidTo(Object last4) {
    return '$last4 پر ختم ہونے والے اکاؤنٹ میں ادا ہوگی';
  }

  @override
  String get bankVerifiedFallback => 'آپ کا تصدیق شدہ بینک اکاؤنٹ';

  @override
  String get bankBeingVerified => 'بینک اکاؤنٹ کی تصدیق ہو رہی ہے';

  @override
  String get bankBeingVerifiedBody =>
      'ہماری ٹیم کی تصدیق کے بعد آپ رقم نکال سکتے ہیں۔';

  @override
  String get bankNotVerified => 'بینک اکاؤنٹ کی تصدیق نہیں ہوئی';

  @override
  String get bankNotVerifiedBody =>
      'اپنی تفصیلات چیک کریں اور دوبارہ جمع کریں۔';

  @override
  String get bankAddTitle => 'بینک اکاؤنٹ شامل کریں';

  @override
  String get bankAddBody =>
      'رقم اسی بینک اکاؤنٹ میں ادا کی جاتی ہے جس کی ہماری ٹیم نے تصدیق کی ہو۔';

  @override
  String get bankAddAction => 'بینک اکاؤنٹ شامل کریں';

  @override
  String get verificationTitle => 'تصدیق';

  @override
  String get verificationProgress => 'تصدیق شدہ جانچیں';

  @override
  String verificationCount(int approved, int total) {
    return '$total میں سے $approved';
  }

  @override
  String get verificationInsurance => 'انشورنس';

  @override
  String get verificationNoCover => 'کوئی فعال انشورنس نہیں';

  @override
  String get verificationNoCoverBody =>
      'فی الحال ہمارے پاس آپ کی کوئی انشورنس پالیسی درج نہیں ہے۔';

  @override
  String get verifyIdentity => 'شناخت';

  @override
  String get verifyIdentityBody =>
      'ایک سرکاری شناختی کارڈ، تاکہ کسٹمرز جانیں کہ ان کے گھر کون آ رہا ہے۔';

  @override
  String get verifyAddress => 'پتہ';

  @override
  String get verifyAddressBody => 'آپ کہاں رہتے ہیں اس کا ثبوت۔';

  @override
  String get verifyIti => 'ITI سرٹیفکیٹ';

  @override
  String get verifyItiBody =>
      'صنعتی تربیتی ادارے (ITI) سے آپ کا ٹریڈ سرٹیفکیٹ۔';

  @override
  String get verifyDiploma => 'ڈپلومہ';

  @override
  String get verifyDiplomaBody => 'ایک تسلیم شدہ تکنیکی ڈپلومہ۔';

  @override
  String get verifyRpl => 'مہارت کی جانچ';

  @override
  String get verifyRplBody =>
      'سابقہ تعلیم کی شناخت (RPL): آپ کے تجربے کی جانچ اور تصدیق۔';

  @override
  String get verifyBackground => 'پس منظر کی جانچ';

  @override
  String get verifyBackgroundBody =>
      'یہ ہم خود کرتے ہیں۔ آپ کو کچھ کرنے کی ضرورت نہیں۔';

  @override
  String get verifyInsuranceBody =>
      'کام کے دوران حادثاتی نقصان کا بیمہ۔ انتظام ہونے پر ہماری ٹیم آپ کی پالیسی شامل کرتی ہے۔';

  @override
  String get verifyBank => 'بینک اکاؤنٹ';

  @override
  String get verifyBankBody => 'جہاں آپ کی نکالی گئی رقم ادا کی جاتی ہے۔';

  @override
  String verificationValidUntil(Object date) {
    return '$date تک درست';
  }

  @override
  String get verificationStart => 'شروع کریں';

  @override
  String get verificationUpdate => 'اپ ڈیٹ کریں';

  @override
  String get policyActive => 'فعال';

  @override
  String get policyNotActive => 'غیر فعال';

  @override
  String get policyNumber => 'پالیسی';

  @override
  String get policyCover => 'کور';

  @override
  String get policyValidUntil => 'تک درست';

  @override
  String get kycStillWaiting =>
      'ابھی بھی DigiLocker کا انتظار ہے۔ آپ بعد میں یہاں سے دوبارہ دیکھ سکتے ہیں۔';

  @override
  String get kycTitle => 'شناخت کی جانچ';

  @override
  String get kycHeadline => 'تصدیق کریں کہ آپ کون ہیں';

  @override
  String get kycIntro =>
      'کسٹمرز آپ کو اپنے گھروں میں آنے دیتے ہیں، اس لیے ہم ہر کارکن کی شناخت حکومتِ ہند کے دستاویزی پلیٹ فارم DigiLocker کے ذریعے تصدیق کرتے ہیں۔ کچھ بھی اپ لوڈ نہیں ہوتا — آپ بس اپنے آدھار اکاؤنٹ پر درخواست منظور کرتے ہیں۔';

  @override
  String get kycPrivacy =>
      'آپ کے آدھار کی تفصیلات براہ راست DigiLocker سے تصدیق ہوتی ہیں۔ ہم صرف وہی رکھتے ہیں جو ثابت کرے کہ جانچ ہوئی — آپ کی تصویر یا آدھار کی کاپی کبھی نہیں۔';

  @override
  String get kycVerified => 'آپ کی شناخت کی تصدیق ہو گئی ہے۔';

  @override
  String get kycAwaitingConsent =>
      'اپنے براؤزر میں DigiLocker کی رضامندی مکمل کریں، پھر یہاں واپس آئیں۔';

  @override
  String get kycChecking => 'DigiLocker سے جانچ ہو رہی ہے…';

  @override
  String get kycStart => 'DigiLocker سے تصدیق کریں';

  @override
  String get qualSubmitted => 'جائزے کے لیے جمع ہو گیا۔';

  @override
  String get qualTitle => 'آپ کی قابلیت';

  @override
  String get qualIti => 'ITI';

  @override
  String get qualInstitute => 'ادارہ';

  @override
  String get qualInstituteHint => 'مثلاً سرکاری ITI، کوئمبٹور';

  @override
  String get qualName => 'قابلیت';

  @override
  String get qualNameHint => 'مثلاً الیکٹریشن';

  @override
  String get qualSpeciality => 'مہارت کا شعبہ (اختیاری)';

  @override
  String get qualSpecialityHint => 'مثلاً صنعتی وائرنگ';

  @override
  String get qualYear => 'مکمل کرنے کا سال';

  @override
  String get qualCertificate => 'آپ کا سرٹیفکیٹ';

  @override
  String get qualCertificateBody => 'سرٹیفکیٹ کی واضح تصویر یا PDF۔';

  @override
  String get bankErrorHolder => 'نام بالکل ویسا ہی درج کریں جیسا اکاؤنٹ میں ہے';

  @override
  String get bankErrorNumber => 'اکاؤنٹ نمبر 9 سے 18 ہندسوں کا ہوتا ہے';

  @override
  String get bankErrorMismatch => 'اکاؤنٹ نمبر میل نہیں کھاتے';

  @override
  String get bankErrorIfsc => '11 حروف کا IFSC درج کریں، مثلاً SBIN0001234';

  @override
  String get bankSent => 'بینک اکاؤنٹ تصدیق کے لیے بھیج دیا گیا۔';

  @override
  String get bankNotice =>
      'آپ کی نکالی گئی رقم اس اکاؤنٹ میں ادا کی جاتی ہے۔ پہلی ادائیگی سے پہلے ہماری ٹیم اس کی تصدیق کرتی ہے۔';

  @override
  String get bankHolder => 'اکاؤنٹ ہولڈر کا نام';

  @override
  String get bankNumber => 'اکاؤنٹ نمبر';

  @override
  String get bankConfirmNumber => 'اکاؤنٹ نمبر دوبارہ درج کریں';

  @override
  String get bankIfsc => 'IFSC کوڈ';

  @override
  String get bankIfscHint => 'مثلاً SBIN0001234';

  @override
  String get bankName => 'بینک کا نام (اختیاری)';

  @override
  String get bankSubmit => 'تصدیق کے لیے جمع کریں';

  @override
  String get profileCompleteness => 'پروفائل کی تکمیل';

  @override
  String get profileCompletenessBody =>
      'مکمل پروفائل سے کسٹمرز کو آپ کو منتخب کرنے میں مدد ملتی ہے۔';

  @override
  String get profileJobsDone => 'مکمل کام';

  @override
  String get profileRating => 'ریٹنگ';

  @override
  String get profileExperience => 'تجربہ';

  @override
  String profileExperienceYears(Object years) {
    return '$years سال';
  }

  @override
  String get profileEdit => 'پروفائل میں ترمیم کریں';

  @override
  String get profileVerified => 'تصدیق شدہ';

  @override
  String get profileNotVerified => 'غیر تصدیق شدہ';

  @override
  String get profilePinInvalid => 'درست 6 ہندسوں کا پن کوڈ درج کریں';

  @override
  String get profileUpdated => 'پروفائل اپ ڈیٹ ہو گئی۔';

  @override
  String get profilePhotoUpdated => 'تصویر اپ ڈیٹ ہو گئی۔';

  @override
  String get profileChangePhoto => 'تصویر تبدیل کریں';

  @override
  String get profileName => 'نام';

  @override
  String get profilePhone => 'فون';

  @override
  String get profileLockedNotice =>
      'آپ کا نام اور نمبر آپ کی شناخت کی جانچ سے منسلک ہیں۔ ان میں سے کچھ بھی بدلنا ہو تو سپورٹ سے رابطہ کریں۔';

  @override
  String get profileAbout => 'آپ کے بارے میں';

  @override
  String get profileBioHint =>
      'کسٹمرز کو اپنے تجربے اور اپنی خوبیوں کے بارے میں بتائیں۔';

  @override
  String get profileYearsExperience => 'تجربے کے سال';

  @override
  String get profileBased => 'آپ کہاں رہتے ہیں';

  @override
  String get profileAddress => 'پتہ';

  @override
  String get profileCity => 'شہر';

  @override
  String get profilePin => 'پن کوڈ';

  @override
  String get profileGender => 'جنس';

  @override
  String get genderMale => 'مرد';

  @override
  String get genderFemale => 'عورت';

  @override
  String get genderOther => 'دیگر';

  @override
  String get profileTrades => 'آپ کے کام';

  @override
  String get profileTradesBody =>
      'آپ ان تمام کاموں میں کام کر سکتے ہیں جن کے لیے آپ منظور ہیں۔';

  @override
  String get profileTradesLoadFailed => 'آپ کے کام لوڈ نہیں ہو سکے۔';

  @override
  String get tradePending => 'زیر التوا';

  @override
  String get profileAddTrade => 'کام شامل کریں';

  @override
  String get profileAddTradeBody =>
      'منظوری سے پہلے ہم آپ کی مہارت کا ثبوت مانگ سکتے ہیں۔';

  @override
  String get profileTradeRequested =>
      'درخواست کی گئی۔ منظوری ملتے ہی ہم آپ کو بتائیں گے۔';

  @override
  String get profileSave => 'تبدیلیاں محفوظ کریں';

  @override
  String get supportNewRequest => 'نئی درخواست';

  @override
  String get supportEmpty => 'ابھی کوئی درخواست نہیں';

  @override
  String get supportEmptyBody =>
      'اگر کسی کام، ادائیگی یا آپ کے اکاؤنٹ میں کچھ غلط ہو جائے تو درخواست دیں اور ہم مدد کریں گے۔';

  @override
  String get supportYourRequests => 'آپ کی درخواستیں';

  @override
  String get supportEmergency => 'ہنگامی صورت میں';

  @override
  String get supportEmergencyBody =>
      'یہ ایپ آپ کی طرف سے مدد نہیں بلا سکتی۔ اگر آپ خطرے میں ہیں تو براہ راست ہنگامی خدمات کو کال کریں۔';

  @override
  String get supportCall112 => '112 پر کال کریں';

  @override
  String get supportPolice => 'پولیس';

  @override
  String get ticketOpen => 'کھلا';

  @override
  String get ticketInProgress => 'جاری';

  @override
  String get ticketReplyNeeded => 'آپ کا جواب درکار';

  @override
  String get ticketResolved => 'حل ہو گیا';

  @override
  String get ticketClosed => 'بند';

  @override
  String ticketLastUpdate(Object date) {
    return 'آخری اپ ڈیٹ $date';
  }

  @override
  String get supportCategoryJob => 'کوئی کام';

  @override
  String get supportCategoryPayment => 'کوئی ادائیگی';

  @override
  String get supportCategoryWithdrawal => 'رقم نکالنا';

  @override
  String get supportCategoryAccount => 'میرا اکاؤنٹ';

  @override
  String get supportCategorySafety => 'حفاظت';

  @override
  String get supportCategoryApp => 'ایپ';

  @override
  String get supportCategoryOther => 'کچھ اور';

  @override
  String supportRaised(Object code) {
    return 'درخواست $code درج ہو گئی۔';
  }

  @override
  String get supportHowHelp => 'ہم کیسے مدد کریں؟';

  @override
  String get supportAbout => 'یہ کس بارے میں ہے؟';

  @override
  String get supportSubject => 'موضوع';

  @override
  String get supportSubjectHint => 'مسئلے کے بارے میں چند الفاظ';

  @override
  String get supportWhatHappened => 'کیا ہوا؟';

  @override
  String get supportSend => 'درخواست بھیجیں';

  @override
  String get ticketTitle => 'سپورٹ کی درخواست';

  @override
  String get ticketNoMessages => 'ابھی کوئی پیغام نہیں';

  @override
  String get ticketNoMessagesBody => 'آپ کی گفتگو یہاں نظر آئے گی۔';

  @override
  String get ticketWriteMessage => 'پیغام لکھیں';

  @override
  String get ticketSupportName => 'Wervexa سپورٹ';

  @override
  String get requestsTitle => 'کسٹمرز کی درخواستیں';

  @override
  String get requestsRefresh => 'ریفریش کریں';

  @override
  String get requestsLocationNeeded => 'لوکیشن درکار ہے';

  @override
  String get requestsLocationBody =>
      'ہم آپ کے قریب کسٹمر درخواستیں تلاش کرنے کے لیے آپ کی لوکیشن استعمال کرتے ہیں۔';

  @override
  String get requestsGrantLocation => 'لوکیشن کی اجازت دیں';

  @override
  String get requestsEmpty => 'قریب کوئی میل کھاتی درخواست نہیں';

  @override
  String get requestsEmptyBody =>
      'آپ کی خدمات سے میل کھانے پر\nنئی کسٹمر درخواستیں یہاں نظر آئیں گی۔';

  @override
  String get requestsViewOffer => 'دیکھیں اور آفر دیں ←';

  @override
  String get requestEnterPrice => 'درست قیمت درج کریں';

  @override
  String requestOfferSubmitted(Object price) {
    return '$price پر آفر جمع ہو گئی!';
  }

  @override
  String get requestDetailsTitle => 'درخواست کی تفصیلات';

  @override
  String get requestStatusOpen => 'کھلا';

  @override
  String get requestCategory => 'زمرہ';

  @override
  String get requestBudget => 'بجٹ';

  @override
  String get requestSchedule => 'شیڈول';

  @override
  String get requestDistance => 'فاصلہ';

  @override
  String get requestArea => 'علاقہ';

  @override
  String get requestOffers => 'آفرز';

  @override
  String get requestNotes => 'نوٹس';

  @override
  String get requestAddressPrivacy =>
      'کسٹمر کا درست پتہ آپ کی آفر قبول کرنے کے بعد ہی شیئر کیا جاتا ہے۔';

  @override
  String get requestYourOffer => 'آپ کی آفر';

  @override
  String get requestYourPrice => 'آپ کی قیمت (₹)';

  @override
  String get requestPriceHint => 'مثلاً 500';

  @override
  String get requestDuration => 'تخمینی وقت (اختیاری)';

  @override
  String get requestDurationHint => 'مثلاً 1-2 گھنٹے';

  @override
  String get requestMessage => 'کسٹمر کے لیے پیغام (اختیاری)';

  @override
  String get requestMessageHint => 'اس کام کے لیے آپ ہی صحیح شخص کیوں ہیں؟';

  @override
  String get requestSubmitOffer => 'آفر جمع کریں';

  @override
  String get requestMakeOffer => 'آفر دیں';

  @override
  String get requestAlreadyOffered =>
      'آپ اس درخواست پر پہلے ہی آفر جمع کر چکے ہیں۔';

  @override
  String get requestViewOffers => 'آفرز دیکھیں';

  @override
  String get offersEmptyBody =>
      'کسٹمر درخواستوں پر آپ کی جمع کردہ آفرز\nیہاں نظر آئیں گی۔';

  @override
  String get offerWithdraw => 'رقم نکالیں';

  @override
  String get offerWithdrawTitle => 'آفر واپس لیں؟';

  @override
  String get offerWithdrawBody => 'کسٹمر کو یہ آفر اب نظر نہیں آئے گی۔';

  @override
  String get offerWithdrawn => 'آفر واپس لے لی گئی';

  @override
  String get onboardingTitle => 'اپنی پروفائل سیٹ کریں';

  @override
  String get onboardingHelp => 'مدد';

  @override
  String onboardingHello(Object name) {
    return 'السلام علیکم، $name';
  }

  @override
  String get onboardingIntro =>
      'بس چند چیزیں اور آپ کام حاصل کرنا شروع کرنے کے لیے تیار ہیں۔';

  @override
  String get onboardingSetup => 'سیٹ اپ';

  @override
  String onboardingStepCount(int done, int total) {
    return '$total میں سے $done';
  }

  @override
  String get onboardingBasicBody =>
      'آپ کا شہر اور پن کوڈ، تاکہ ہم آپ کے قریب کام تلاش کر سکیں۔';

  @override
  String get onboardingTradeBody => 'وہ کام جو آپ بنیادی طور پر کرتے ہیں۔';

  @override
  String get onboardingSkillsDoneBody =>
      'آپ کا بنیادی کام ان میں سے ایک شمار ہوتا ہے۔ باقی تمام کام شامل کرنے کے لیے اسے کھولیں۔';

  @override
  String get onboardingSkillsBody =>
      'آپ جو بھی کام کرتے ہیں سب شامل کریں۔ آپ ایک کام تک محدود نہیں ہیں۔';

  @override
  String get onboardingAreaBody =>
      'کسی کام کے لیے آپ کتنی دور جانے کو تیار ہیں۔';

  @override
  String get onboardingKycBody =>
      'ایک سرکاری شناختی کارڈ۔ کسٹمرز آپ کو اپنے گھروں میں آنے دے رہے ہیں۔';

  @override
  String get onboardingReviewNotice =>
      'یہ مکمل کرنے کے بعد ہماری ٹیم آپ کی دستاویزات جانچتی ہے۔ انتظار کے دوران آپ اپنی خدمات سیٹ کرتے رہ سکتے ہیں۔';

  @override
  String get onboardingTradesLoadFailed =>
      'کام لوڈ نہیں ہو سکے۔ دوبارہ کوشش کریں۔';

  @override
  String get onboardingMainTrade => 'آپ کا بنیادی کام کیا ہے؟';

  @override
  String get onboardingMainTradeBody => 'آپ بعد میں مزید کام شامل کر سکتے ہیں۔';

  @override
  String onboardingTradeSet(Object trade) {
    return '$trade آپ کا بنیادی کام سیٹ ہو گیا۔';
  }

  @override
  String get onboardingTravelTitle => 'آپ کتنی دور جائیں گے؟';

  @override
  String get onboardingTravelBody =>
      'ہم آپ کو صرف آپ کی موجودہ جگہ سے اتنے فاصلے کے اندر کے کام دیں گے۔';

  @override
  String get onboardingTravelCentre =>
      'ہم آپ کے موجودہ مقام کو مرکز مانتے ہیں۔ آپ اسے کبھی بھی اپنی پروفائل سے بدل سکتے ہیں۔';

  @override
  String get onboardingLocationOff =>
      'اپنے کام کا علاقہ سیٹ کرنے کے لیے لوکیشن کی اجازت آن کریں۔';

  @override
  String get commonSave => 'محفوظ کریں';

  @override
  String get notificationsStayOff =>
      'اطلاعات بند رہیں گی۔ آپ انہیں اپنے فون کی سیٹنگز میں آن کر سکتے ہیں۔';

  @override
  String get notificationsPrimerTitle => 'کام آتے ہی اطلاع پائیں';

  @override
  String get notificationsPrimerBody =>
      'کام کی آفرز کی میعاد ختم ہو جاتی ہے۔ ایپ بند ہونے پر اطلاع ہی سے آپ کو پتہ چلتا ہے — اور کچھ نہیں بھیجا جاتا۔';

  @override
  String get notificationsTurnOn => 'اطلاعات آن کریں';

  @override
  String get commonNotNow => 'ابھی نہیں';

  @override
  String get onboardingCityRequired => 'براہ کرم اپنا شہر درج کریں';

  @override
  String get onboardingGenderRequired => 'براہ کرم اپنی جنس منتخب کریں';

  @override
  String get onboardingWhereBased => 'آپ کہاں رہتے ہیں؟';
}
