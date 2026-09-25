// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Urdu (`ur`).
class AppLocalizationsUr extends AppLocalizations {
  AppLocalizationsUr([String locale = 'ur']) : super(locale);

  @override
  String get commonRetry => 'دوبارہ کوشش کریں';

  @override
  String get commonTryAgain => 'دوبارہ کوشش کریں';

  @override
  String get commonSignOut => 'سائن آؤٹ کریں';

  @override
  String get assistantFabLabel => 'AI سے پوچھیں';

  @override
  String get navHome => 'ہوم';

  @override
  String get navExplore => 'تلاش کریں';

  @override
  String get navBookings => 'بکنگز';

  @override
  String get navAlerts => 'الرٹس';

  @override
  String get navProfile => 'پروفائل';

  @override
  String get configErrorTitle => 'ایپ کنفیگر نہیں ہے';

  @override
  String configErrorBody(String keys, String command) {
    return 'اس بلڈ میں $keys موجود نہیں۔ اسے اس طرح چلائیں:\n\n$command\n\nتاکہ ایپ اصل بیک اینڈ تک پہنچ سکے۔';
  }

  @override
  String get sessionProfileLoadFailedRetry =>
      'ہم آپ کی پروفائل لوڈ نہیں کر سکے۔ براہ کرم دوبارہ کوشش کریں۔';

  @override
  String get sessionProfileLoadFailed => 'ہم آپ کی پروفائل لوڈ نہیں کر سکے';

  @override
  String get sessionCheckClock => 'اپنے فون کی گھڑی چیک کریں';

  @override
  String get splashTagline => 'گھر کی خدمات، درست طریقے سے۔';

  @override
  String get timelineBookingConfirmed => 'بکنگ کی تصدیق ہو گئی';

  @override
  String get timelineProviderOnTheWay => 'سروس فراہم کنندہ راستے میں ہیں';

  @override
  String get timelineServiceInProgress => 'سروس جاری ہے';

  @override
  String get timelineCompleted => 'مکمل';

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
  String get errorSessionEnded =>
      'آپ کا سیشن ختم ہو گیا ہے۔ براہ کرم دوبارہ سائن ان کریں۔';

  @override
  String get errorUploadFailed =>
      'وہ فائل اپ لوڈ نہیں ہو سکی۔ دوبارہ کوشش کریں۔';

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
  String get authErrorPhoneNotEnabled =>
      'فون سے سائن اِن فعال نہیں ہے۔ سپورٹ سے رابطہ کریں۔';

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
  String get languagePickerTitle => 'اپنی زبان منتخب کریں';

  @override
  String get authCouldNotStartVerification =>
      'تصدیق شروع نہیں ہو سکی۔ براہ کرم دوبارہ کوشش کریں۔';

  @override
  String get authWelcomeTitle => 'Wervexa میں خوش آمدید';

  @override
  String get authWelcomeSubtitle =>
      'گھر کی مرمت، پلمبنگ، بجلی کے کام، صفائی اور بہت کچھ کے لیے قریبی بہترین ماہرین تلاش کریں۔';

  @override
  String get authEnterPhone => 'اپنا فون نمبر درج کریں';

  @override
  String get authInvalidMobile => 'درست 10 ہندسوں کا موبائل نمبر درج کریں';

  @override
  String get authGetOtp => 'OTP تصدیق حاصل کریں';

  @override
  String get authTermsNotice =>
      'جاری رکھ کر، آپ ہماری سروس کی شرائط اور رازداری کی پالیسی سے اتفاق کرتے ہیں';

  @override
  String get authNewCodeSent => 'ہم نے نیا کوڈ بھیج دیا ہے۔';

  @override
  String get authVerifyPhoneTitle => 'فون کی تصدیق کریں';

  @override
  String get authChangeNumber => 'نمبر تبدیل کریں';

  @override
  String get authEnterCodeTitle => '6 ہندسوں کا کوڈ درج کریں';

  @override
  String authCodeSentTo(Object phone) {
    return 'ہم نے $phone پر SMS تصدیقی کوڈ بھیجا ہے';
  }

  @override
  String get authWrongNumber => 'غلط نمبر؟ تبدیل کریں';

  @override
  String get authEnterSixDigits => 'براہ کرم 6 ہندسے درج کریں';

  @override
  String get authResendCode => 'کوڈ دوبارہ بھیجیں';

  @override
  String authResendCodeIn(Object seconds) {
    return '$seconds سیکنڈ میں کوڈ دوبارہ بھیجیں';
  }

  @override
  String get authVerifyAndContinue => 'تصدیق کریں اور جاری رکھیں';

  @override
  String get registerTitle => 'پروفائل مکمل کریں';

  @override
  String get registerHeading => 'ہمیں اپنا نام بتائیں';

  @override
  String get registerNameVisibility =>
      'جب آپ بکنگ کی درخواست کریں گے تو آپ کا نام سروس کارکنوں کو نظر آئے گا۔';

  @override
  String get registerFullNameLabel => 'پورا نام *';

  @override
  String get registerFullNameHint => 'مثلاً راہل شرما';

  @override
  String get registerFullNameRequired => 'براہ کرم اپنا پورا نام درج کریں';

  @override
  String get registerEmailLabel => 'ای میل پتہ (اختیاری)';

  @override
  String get registerEmailHint => 'مثلاً rahul@example.com';

  @override
  String get registerSubmit => 'محفوظ کریں اور شروع کریں';

  @override
  String get bookingStatusRequested => 'ماہر تلاش کیا جا رہا ہے…';

  @override
  String get bookingStatusAccepted => 'ماہر مل گیا';

  @override
  String get bookingStatusConfirmed => 'تصدیق شدہ';

  @override
  String get bookingStatusTraveling => 'راستے میں';

  @override
  String get bookingStatusArrived => 'پہنچ گئے — اپنا کوڈ درج کریں';

  @override
  String get bookingStatusInProgress => 'کام جاری ہے';

  @override
  String get bookingStatusAwaitingApproval =>
      'کام مکمل — آگے بڑھنے کے لیے منظوری دیں';

  @override
  String get bookingStatusCompleted => 'مکمل';

  @override
  String get bookingStatusPaymentPending => 'ادائیگی باقی ہے';

  @override
  String get bookingStatusPaid => 'ادائیگی ہو گئی';

  @override
  String get bookingStatusClosed => 'بند';

  @override
  String get bookingStatusCancelled => 'منسوخ';

  @override
  String get bookingStatusDisputed => 'متنازع';

  @override
  String get bookingStatusExpired => 'میعاد ختم — کوئی دستیاب نہیں تھا';

  @override
  String get pricingPerJob => 'فی کام';

  @override
  String get pricingPerHour => 'فی گھنٹہ';

  @override
  String get pricingPerDay => 'فی دن';

  @override
  String get pricingPerUnit => 'فی یونٹ';

  @override
  String get pricingPerSqft => 'فی مربع فٹ';

  @override
  String get supportCategoryBooking => 'بکنگ کا مسئلہ';

  @override
  String get supportCategoryPayment => 'ادائیگی';

  @override
  String get supportCategoryPayout => 'پے آؤٹ';

  @override
  String get supportCategoryVerification => 'تصدیق';

  @override
  String get supportCategoryAccount => 'میرا اکاؤنٹ';

  @override
  String get supportCategorySafety => 'حفاظت کی تشویش';

  @override
  String get supportCategoryClaim => 'انشورنس کلیم';

  @override
  String get supportCategoryAppIssue => 'ایپ کا مسئلہ';

  @override
  String get supportCategoryOther => 'دیگر';

  @override
  String get requestStatusDraft => 'مسودہ';

  @override
  String get requestStatusOpen => 'کھلی — آفرز کا انتظار';

  @override
  String get requestStatusReceivingOffers => 'آفرز آ رہی ہیں';

  @override
  String get requestStatusWorkerSelected => 'ماہر منتخب ہو گیا';

  @override
  String get requestStatusBooked => 'بک ہو گئی';

  @override
  String get requestStatusCancelled => 'منسوخ';

  @override
  String get requestStatusExpired => 'میعاد ختم';

  @override
  String get requestStatusClosed => 'بند';

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
  String get scheduleSpecificDate => 'کسی مخصوص تاریخ پر';

  @override
  String get scheduleScheduled => 'طے شدہ';

  @override
  String get offerStatusSubmitted => 'نئی آفر';

  @override
  String get offerStatusViewed => 'دیکھی گئی';

  @override
  String get offerStatusShortlisted => 'شارٹ لسٹ';

  @override
  String get offerStatusAccepted => 'قبول';

  @override
  String get offerStatusRejected => 'مسترد';

  @override
  String get offerStatusWithdrawn => 'کارکن نے واپس لے لی';

  @override
  String get offerStatusExpired => 'میعاد ختم';

  @override
  String get offerStatusClosed => 'بند';

  @override
  String get gigRatingNew => 'نیا';

  @override
  String distanceMetres(Object metres) {
    return '$metres میٹر';
  }

  @override
  String distanceKm(Object km) {
    return '$km کلومیٹر';
  }

  @override
  String durationMinutes(Object minutes) {
    return '$minutes منٹ';
  }

  @override
  String durationHours(Object hours) {
    return '$hours گھنٹے';
  }

  @override
  String durationHoursMinutes(int hours, int minutes) {
    return '$hours گھنٹے $minutes منٹ';
  }

  @override
  String get offerWorkerFallbackName => 'ماہر';

  @override
  String get budgetFlexible => 'لچکدار بجٹ';

  @override
  String get budgetFixed => 'مقررہ بجٹ';

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
  String get paymentsNotConfigured =>
      'اس بلڈ کے لیے ادائیگیاں ابھی کنفیگر نہیں ہیں۔';

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
  String get addressLabelHome => 'ہوم';

  @override
  String get addressLabelWork => 'دفتر';

  @override
  String get addressLabelOther => 'دیگر';

  @override
  String get commonSeeAll => 'سب دیکھیں';

  @override
  String get commonViewAll => 'سب دیکھیں';

  @override
  String get commonCheckBackLater => 'براہ کرم بعد میں دوبارہ دیکھیں۔';

  @override
  String get commonUseCurrentLocation => 'موجودہ مقام استعمال کریں';

  @override
  String get commonChooseOnMap => 'نقشے پر منتخب کریں';

  @override
  String homeGreetingNamed(Object name) {
    return 'السلام علیکم، $name 👋';
  }

  @override
  String get homeGreeting => 'السلام علیکم 👋';

  @override
  String get homeWhatService => 'آج آپ کو کون سی سروس چاہیے؟';

  @override
  String get homeSetLocation => 'اپنا مقام سیٹ کریں';

  @override
  String get homeWorkFinishedApprove => 'کام مکمل — منظوری کے لیے ٹیپ کریں';

  @override
  String get homeCategories => 'زمرے';

  @override
  String homeCategoriesLoadFailed(Object error) {
    return 'زمرے لوڈ نہیں ہو سکے: $error';
  }

  @override
  String get homeFindWorker => 'کارکن تلاش کریں';

  @override
  String get homeFindWorkerSubtitle => 'قریبی خدمات دیکھیں';

  @override
  String get homePostRequest => 'درخواست پوسٹ کریں';

  @override
  String get homePostRequestSubtitle => 'کارکن آپ کے پاس آتے ہیں';

  @override
  String get homeNoServices => 'ابھی کوئی سروس دستیاب نہیں ہے';

  @override
  String get homeSearchNear => 'قریب میں خدمات تلاش کریں';

  @override
  String get homeSearchHint => 'خدمات تلاش کریں...';

  @override
  String homeActiveBooking(Object code) {
    return 'فعال بکنگ #$code';
  }

  @override
  String get homeActiveRequests => 'آپ کی فعال درخواستیں';

  @override
  String get commonGrantPermission => 'اجازت دیں';

  @override
  String get commonView => 'دیکھیں';

  @override
  String get exploreTitle => 'خدمات تلاش کریں اور دریافت کریں';

  @override
  String get exploreListView => 'فہرست منظر';

  @override
  String get exploreMapView => 'نقشہ منظر';

  @override
  String get exploreSearchHint => 'خدمات، کارکن یا مہارتیں تلاش کریں...';

  @override
  String get exploreLocationOffTitle => 'لوکیشن سروسز بند ہیں';

  @override
  String get exploreLocationOffMessage =>
      'قریبی ماہرین تلاش کرنے کے لیے لوکیشن آن کریں۔';

  @override
  String get exploreLocationPermissionTitle => 'لوکیشن کی اجازت درکار ہے';

  @override
  String get exploreLocationPermissionMessage =>
      'ہم قریبی ماہرین تلاش کرنے کے لیے آپ کی لوکیشن استعمال کرتے ہیں۔';

  @override
  String get exploreChooseService => 'تلاش کے لیے ایک سروس منتخب کریں';

  @override
  String get exploreChooseServiceMessage =>
      'قریبی ماہرین دیکھنے کے لیے اوپر ایک زمرہ منتخب کریں۔';

  @override
  String get exploreNoProfessionals =>
      'اس سروس کے لیے قریب کوئی ماہر دستیاب نہیں ہے';

  @override
  String get exploreLoadFailed => 'ماہرین لوڈ نہیں ہو سکے۔';

  @override
  String exploreByWorker(Object name) {
    return 'از $name';
  }

  @override
  String get bookingsTitle => 'میری سروس بکنگز';

  @override
  String get bookingsTabActive => 'فعال';

  @override
  String get bookingsTabCompleted => 'مکمل';

  @override
  String get bookingsTabCancelled => 'منسوخ';

  @override
  String get bookingsLoadFailed => 'آپ کی بکنگز لوڈ نہیں ہو سکیں۔';

  @override
  String get bookingsEmpty => 'ابھی کوئی بکنگ نہیں';

  @override
  String get bookingsFindService => 'سروس تلاش کریں';

  @override
  String get bookingsWaitingForProfessional => 'ماہر کا انتظار';

  @override
  String bookingsCode(Object code) {
    return 'بکنگ کوڈ: #$code';
  }

  @override
  String get bookingsPayNow => 'ابھی ادائیگی کریں';

  @override
  String get bookingsApproveWork => 'کام کی منظوری دیں';

  @override
  String get bookingsTrackLive => 'لائیو ٹریک کریں';

  @override
  String get bookingsDetails => 'تفصیلات';

  @override
  String get bookingDetailTitle => 'بکنگ کی تفصیلات';

  @override
  String get bookingDetailLoadFailed => 'بکنگ کی تفصیلات لوڈ نہیں ہو سکیں۔';

  @override
  String get bookingDetailWaitingAccept => 'ماہر کے قبول کرنے کا انتظار';

  @override
  String bookingDetailNumber(Object code) {
    return 'بکنگ #$code';
  }

  @override
  String bookingDetailStatus(Object status) {
    return 'حیثیت: $status';
  }

  @override
  String get bookingDetailLiveMap => 'لائیو نقشہ';

  @override
  String get bookingDetailServiceInfo => 'سروس درخواست کی معلومات';

  @override
  String get bookingDetailViewMaterials => 'سامان / پرزوں کی درخواستیں دیکھیں';

  @override
  String get bookingDetailFareDetails => 'کرایے کی تفصیلات';

  @override
  String get bookingDetailEstimatedFare => 'تخمینی کرایہ';

  @override
  String get bookingDetailFinalFare => 'حتمی تصدیق شدہ کرایہ';

  @override
  String get bookingDetailRateReview => 'سروس کارکن کو ریٹنگ اور ریویو دیں';

  @override
  String get bookingDetailApproveCompletion => 'تکمیل کی منظوری دیں';

  @override
  String get bookingDetailApprovePaidHint =>
      'آپ کے ماہر نے یہ کام مکمل قرار دیا ہے۔ منظوری دینے سے آپ کی ادائیگی انہیں جاری ہو جائے گی۔';

  @override
  String get bookingDetailApproveUnpaidHint =>
      'آپ کے ماہر نے یہ کام مکمل قرار دیا ہے۔ تصدیق کر کے ادائیگی پر جانے کے لیے منظوری دیں۔';

  @override
  String get bookingDetailReportProblem => 'مسئلہ رپورٹ کریں';

  @override
  String get bookingDetailCompletionApproved => 'تکمیل کی منظوری ہو گئی';

  @override
  String bookingDetailPayToConfirm(Object amount) {
    return 'تصدیق کے لیے $amount ادا کریں';
  }

  @override
  String get bookingDetailSentAfterPayment =>
      'ادائیگی مکمل ہوتے ہی آپ کی بکنگ ماہر کو بھیج دی جائے گی۔';

  @override
  String bookingDetailPayAmount(Object amount) {
    return '$amount ادا کریں';
  }

  @override
  String get bookingDetailCancelBooking => 'بکنگ منسوخ کریں';

  @override
  String get cancelReasonMistake => 'غلطی سے بک ہو گئی';

  @override
  String get cancelReasonNoLongerNeeded => 'مجھے اب اس سروس کی ضرورت نہیں';

  @override
  String get cancelReasonDifferentTime =>
      'میں کوئی اور وقت منتخب کرنا چاہتا ہوں';

  @override
  String get cancelReasonFoundSomeoneElse => 'مجھے کوئی اور مل گیا';

  @override
  String get cancelDialogTitle => 'آپ کیوں منسوخ کر رہے ہیں؟';

  @override
  String get cancelDialogRefundNotice =>
      'اسے واپس نہیں کیا جا سکتا۔ آپ کی ادائیگی اصل ادائیگی کے طریقے میں واپس کر دی جائے گی۔';

  @override
  String get cancelDialogCannotUndo => 'اسے واپس نہیں کیا جا سکتا۔';

  @override
  String get cancelDialogKeepBooking => 'بکنگ رکھیں';

  @override
  String get bookingCancelledRefund =>
      'بکنگ منسوخ ہو گئی۔ آپ کے ریفنڈ کی درخواست کر دی گئی ہے۔';

  @override
  String get bookingCancelled => 'بکنگ منسوخ ہو گئی';

  @override
  String get arrivalCodeTitle => 'آمد کا کوڈ';

  @override
  String get arrivalCodeShare =>
      'ماہر کے پہنچنے کی تصدیق کے لیے یہ کوڈ انہیں بتائیں:';

  @override
  String get arrivalCodeUnavailable => 'دستیاب نہیں';

  @override
  String get arrivalCodeLoadFailed => 'کوڈ لوڈ نہیں ہو سکا';

  @override
  String get activeBookingTitle => 'لائیو بکنگ اور کارکن ٹریکنگ';

  @override
  String get activeBookingLoadFailed => 'یہ بکنگ لوڈ نہیں ہو سکی۔';

  @override
  String get activeBookingMapUnavailable =>
      'اس بکنگ کے لیے لائیو نقشہ دستیاب نہیں ہے۔';

  @override
  String get activeBookingViewDetails => 'بکنگ کی تفصیلات دیکھیں';

  @override
  String get activeBookingServiceLocation => 'سروس کا مقام';

  @override
  String get activeBookingYourProfessional => 'آپ کے ماہر';

  @override
  String get activeBookingLive => 'لائیو';

  @override
  String get activeBookingLastKnown => 'آخری معلوم مقام';

  @override
  String get activeBookingPhoneNotShared => 'فون ابھی شیئر نہیں کیا گیا';

  @override
  String get activeBookingCallProfessional => 'ماہر کو کال کریں';

  @override
  String get activeBookingMaterials => 'سامان';

  @override
  String get activeBookingViewDetailsShort => 'تفصیلات دیکھیں';

  @override
  String get locationConnecting => 'لائیو لوکیشن سے جڑ رہے ہیں...';

  @override
  String get locationLiveUnavailable => 'لائیو لوکیشن عارضی طور پر دستیاب نہیں';

  @override
  String get locationLiveActive => 'لائیو لوکیشن فعال ہے';

  @override
  String get locationUpdating => 'اپ ڈیٹ ہو رہا ہے...';

  @override
  String get locationUnavailable => 'لوکیشن عارضی طور پر دستیاب نہیں';

  @override
  String get activeBookingShareStartCode =>
      'کارکن پہنچ گئے! شروع کرنے کا کوڈ بتائیں:';

  @override
  String get commonBack => 'واپس';

  @override
  String get paymentCouldNotOpen =>
      'ادائیگی کی اسکرین نہیں کھل سکی۔ براہ کرم دوبارہ کوشش کریں۔';

  @override
  String get paymentReceived =>
      'ادائیگی موصول ہو گئی۔ آپ کی بکنگ ماہر کو بھیج دی گئی ہے۔';

  @override
  String paymentNotConfirmed(String reason, String reference) {
    return 'ہم اس ادائیگی کی تصدیق نہیں کر سکے: $reason۔ اگر رقم کٹ گئی ہے تو حوالہ $reference کے ساتھ سپورٹ سے رابطہ کریں۔';
  }

  @override
  String get paymentNotCompleted => 'ادائیگی مکمل نہیں ہوئی۔';

  @override
  String paymentExternalWalletUnsupported(Object wallet) {
    return 'بیرونی والیٹ ($wallet) منتخب کیا گیا — یہ ابھی معاون نہیں ہے۔';
  }

  @override
  String get paymentTitle => 'ادائیگی';

  @override
  String get paymentStatusUnknown =>
      'ہم یہ چیک نہیں کر سکے کہ اس بکنگ کی ادائیگی پہلے ہو چکی ہے یا نہیں۔ دو بار ادائیگی کرنے کے بجائے براہ کرم دوبارہ کوشش کریں۔';

  @override
  String get paymentBookingLoadFailed => 'یہ بکنگ لوڈ نہیں ہو سکی۔';

  @override
  String get paymentComplete => 'ادائیگی مکمل';

  @override
  String paymentPaidFor(String amount, String service) {
    return '$service کے لیے $amount ادا کیے گئے۔';
  }

  @override
  String get paymentViewBooking => 'بکنگ دیکھیں';

  @override
  String get paymentBookingSummary => 'بکنگ کا خلاصہ';

  @override
  String get paymentProvider => 'فراہم کنندہ';

  @override
  String get paymentService => 'سروس';

  @override
  String get paymentDate => 'تاریخ';

  @override
  String get paymentTime => 'وقت';

  @override
  String get paymentAddress => 'پتہ';

  @override
  String get paymentTotal => 'کُل';

  @override
  String get paymentHeldSecurely =>
      'آپ کی ادائیگی محفوظ رکھی جاتی ہے اور آپ کے کام کی منظوری کے بعد ہی ماہر کو جاری کی جاتی ہے۔ اگر کام شروع ہونے سے پہلے بکنگ منسوخ ہو جائے تو آپ کو ریفنڈ ملتا ہے۔';

  @override
  String get commonChange => 'تبدیل کریں';

  @override
  String get bookMissingDetails =>
      'بکنگ کی تفصیلات موجود نہیں — براہ کرم دوبارہ شروع کریں۔';

  @override
  String get bookSlotPassed =>
      'وہ وقت گزر چکا ہے۔ ہم نے آپ کو اگلے دستیاب سلاٹ پر منتقل کر دیا ہے — چیک کر کے دوبارہ تصدیق کریں۔';

  @override
  String bookFailed(Object reason) {
    return 'بکنگ ناکام: $reason';
  }

  @override
  String get bookNoAddress => 'کوئی پتہ منتخب نہیں کیا گیا';

  @override
  String get bookTitle => 'سروس بک کریں';

  @override
  String get bookSelectDate => 'تاریخ منتخب کریں';

  @override
  String get bookSelectTime => 'وقت منتخب کریں';

  @override
  String get bookSpecialInstructions => 'خصوصی ہدایات (اختیاری)';

  @override
  String get bookSpecialInstructionsHint =>
      'مثلاً باورچی خانے اور باتھ روم پر توجہ دیں...';

  @override
  String get bookConfirm => 'بکنگ کی تصدیق کریں ←';

  @override
  String get gigUnknownProfessional => 'نامعلوم ماہر';

  @override
  String get gigNewProfessional => 'نیا ماہر';

  @override
  String gigRatingWithCount(String rating, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ریویوز',
      one: '1 ریویو',
    );
    return '$rating ($_temp0)';
  }

  @override
  String get gigPricing => 'قیمت';

  @override
  String get gigServiceRate => 'سروس ریٹ';

  @override
  String get gigFinalAmountNote =>
      'حتمی رقم آپ کے ماہر طے کرتے ہیں اور بکنگ بننے پر اس میں دکھائی جاتی ہے۔';

  @override
  String get gigKycVerified => 'KYC تصدیق شدہ';

  @override
  String get gigBackgroundVerified => 'پس منظر تصدیق شدہ';

  @override
  String get gigBookNow => 'ابھی بک کریں ←';

  @override
  String get discoveryTitle => 'دستیاب ماہرین';

  @override
  String get discoveryMissingDetails => 'سروس یا مقام کی تفصیلات موجود نہیں۔';

  @override
  String get discoveryLocalExperts => 'دستیاب مقامی ماہرین';

  @override
  String get discoveryWithin => 'فاصلے کے اندر';

  @override
  String get discoveryNoProviders => 'قریب کوئی فراہم کنندہ دستیاب نہیں';

  @override
  String get discoveryTryLargerRadius =>
      'زیادہ تلاش کا فاصلہ آزمائیں یا بعد میں دوبارہ دیکھیں۔';

  @override
  String get discoveryLoadFailed => 'قریبی فراہم کنندگان لوڈ نہیں ہو سکے۔';

  @override
  String discoveryServicesForJob(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'اس کام کے لیے $count خدمات',
      one: 'اس کام کے لیے 1 سروس',
    );
    return '$_temp0';
  }

  @override
  String get discoveryBook => 'بک کریں';

  @override
  String get categoryServiceDetails => 'سروس کی تفصیلات';

  @override
  String get categoryTagline =>
      'پہلے سے طے شدہ قیمت اور سروس کی ضمانت کے ساتھ تصدیق شدہ، پس منظر جانچے گئے مقامی ماہرین بک کریں۔';

  @override
  String get categoryWhatHelp => 'آپ کو کس کام میں مدد چاہیے؟';

  @override
  String get categoryDescribeElse => 'کچھ اور بیان کریں';

  @override
  String get categoryLoadFailed => 'یہ سروس لوڈ نہیں ہو سکی۔';

  @override
  String get notificationsTitle => 'اطلاعات اور الرٹس';

  @override
  String get notificationsEmpty => 'آپ نے سب دیکھ لیا ہے';

  @override
  String get notificationsLoadFailed => 'اطلاعات لوڈ نہیں ہو سکیں۔';

  @override
  String get timeJustNow => 'ابھی ابھی';

  @override
  String timeMinutesAgo(Object minutes) {
    return '$minutes منٹ پہلے';
  }

  @override
  String timeHoursAgo(Object hours) {
    return '$hours گھنٹے پہلے';
  }

  @override
  String get timeYesterday => 'کل';

  @override
  String get completedTitle => 'سروس مکمل!';

  @override
  String get completedThanks => 'ہماری خدمات استعمال کرنے کا شکریہ۔';

  @override
  String get completedViewBookings => 'بکنگز دیکھیں';

  @override
  String get completedBackHome => 'ہوم پر واپس جائیں';

  @override
  String commonErrorDetail(Object detail) {
    return 'خرابی: $detail';
  }

  @override
  String get reviewTitle => 'اپنے تجربے کی ریٹنگ دیں';

  @override
  String get reviewHeading => 'بہترین سروس!';

  @override
  String get reviewQuestion => 'آپ کے ماہر کے ساتھ آپ کا تجربہ کیسا رہا؟';

  @override
  String reviewStars(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ستارے',
      one: '1 ستارہ',
    );
    return '$_temp0';
  }

  @override
  String get reviewCommentHint => 'اپنے تجربے کے بارے میں بتائیں...';

  @override
  String get reviewSubmit => 'ریویو جمع کریں ←';

  @override
  String get materialsTitle => 'سامان / پرزوں کی درخواستیں';

  @override
  String get materialsEmpty =>
      'اس بکنگ کے لیے سامان کی کوئی درخواست جمع نہیں ہوئی';

  @override
  String materialsQuantityEstimated(Object quantity) {
    return '$quantity · تخمینی';
  }

  @override
  String materialsQuantityActual(Object quantity) {
    return '$quantity · اصل';
  }

  @override
  String get materialsReject => 'مسترد کریں';

  @override
  String get materialsApprove => 'منظور کریں';

  @override
  String get materialStatusRequested => 'درخواست کی گئی';

  @override
  String get materialStatusCustomerReview => 'آپ کے جائزے کا انتظار';

  @override
  String get materialStatusApproved => 'منظور شدہ';

  @override
  String get materialStatusRejected => 'مسترد';

  @override
  String get materialStatusPurchased => 'خریدا گیا';

  @override
  String get materialStatusCostRecorded => 'لاگت درج';

  @override
  String get materialStatusBilled => 'بل میں شامل';

  @override
  String get materialStatusCancelled => 'منسوخ';

  @override
  String get commonSaveChanges => 'تبدیلیاں محفوظ کریں';

  @override
  String get profileTitle => 'میری پروفائل اور اکاؤنٹ';

  @override
  String get profileFallbackName => 'کسٹمر پروفائل';

  @override
  String get profileLanguage => 'زبان';

  @override
  String get profileAddresses => 'محفوظ کردہ سروس پتے';

  @override
  String get profileAddressesSubtitle => 'گھر، دفتر اور دیگر پتے سنبھالیں';

  @override
  String get profileHistory => 'گزشتہ خدمات کی تاریخ';

  @override
  String get profileHistorySubtitle => 'رسیدیں اور گزشتہ بکنگز دیکھیں';

  @override
  String get profileSupport => 'مدد اور کسٹمر سپورٹ';

  @override
  String get profileSupportSubtitle => 'ٹکٹ بنائیں، ہماری ٹیم کے جوابات دیکھیں';

  @override
  String get editProfileSaved => 'پروفائل کامیابی سے اپ ڈیٹ ہو گئی';

  @override
  String get editProfileTitle => 'پروفائل میں ترمیم کریں';

  @override
  String get editProfileFullName => 'پورا نام';

  @override
  String get editProfileNameEmpty => 'نام خالی نہیں ہو سکتا';

  @override
  String get editProfileEmail => 'ای میل پتہ';

  @override
  String get commonEdit => 'ترمیم کریں';

  @override
  String get commonDelete => 'حذف کریں';

  @override
  String get addressesAdd => 'نیا پتہ شامل کریں';

  @override
  String get addressesEmpty => 'آپ نے ابھی کوئی پتہ محفوظ نہیں کیا';

  @override
  String get addressesEmptyMessage =>
      'اگلی بار تیزی سے بک کرنے کے لیے سروس کا پتہ شامل کریں۔';

  @override
  String get addressesDefaultBadge => 'ڈیفالٹ';

  @override
  String get addressesSetDefault => 'ڈیفالٹ بنائیں';

  @override
  String get addressesLoadFailed => 'پتے لوڈ نہیں ہو سکے۔';

  @override
  String get addressesLabelSheet => 'اس پتے کو نام دیں';

  @override
  String get supportTitle => 'مدد اور سپورٹ';

  @override
  String get supportNewTicket => 'نیا ٹکٹ';

  @override
  String get supportEmpty => 'ابھی کوئی سپورٹ ٹکٹ نہیں';

  @override
  String get supportEmptyMessage =>
      'کسی بکنگ یا ایپ کے بارے میں مدد چاہیے؟ ٹکٹ بنائیں اور ہماری ٹیم جواب دے گی۔';

  @override
  String get supportLoadFailed => 'آپ کے سپورٹ ٹکٹ لوڈ نہیں ہو سکے۔';

  @override
  String get supportStatusOpen => 'کھلا';

  @override
  String get supportStatusInProgress => 'جاری';

  @override
  String get supportStatusWaitingForYou => 'آپ کا انتظار';

  @override
  String get supportStatusResolved => 'حل ہو گیا';

  @override
  String get supportStatusClosed => 'بند';

  @override
  String get supportNewTicketTitle => 'نیا سپورٹ ٹکٹ';

  @override
  String get supportCategory => 'زمرہ';

  @override
  String get supportSubject => 'موضوع';

  @override
  String get supportDescribeIssue => 'مسئلہ بیان کریں';

  @override
  String get supportFillSubjectMessage => 'براہ کرم موضوع اور پیغام بھریں۔';

  @override
  String get supportSubmitTicket => 'ٹکٹ جمع کریں';

  @override
  String get supportTicketTitle => 'سپورٹ ٹکٹ';

  @override
  String get supportNoMessages => 'ابھی کوئی پیغام نہیں';

  @override
  String get supportMessagesLoadFailed => 'پیغامات لوڈ نہیں ہو سکے۔';

  @override
  String get supportTypeMessage => 'پیغام لکھیں...';

  @override
  String get supportSend => 'بھیجیں';

  @override
  String get pickerEnterAddress =>
      'براہ کرم اس پن کا پتہ درج کریں یا تصدیق کریں';

  @override
  String get pickerTitle => 'سروس کا پتہ منتخب کریں';

  @override
  String get pickerGettingLocation => 'آپ کا مقام معلوم کیا جا رہا ہے...';

  @override
  String get pickerPermissionDenied =>
      'لوکیشن کی اجازت نہیں ملی — پتہ منتخب کرنے کے لیے نقشہ خود ہلائیں۔';

  @override
  String get pickerConfirmPin => 'سروس پن کی جگہ کی تصدیق کریں';

  @override
  String get pickerAddressLabel => 'مکان / فلیٹ / گلی کا نام';

  @override
  String get pickerAddressHint => 'مثلاً #102، گرین ایونیو، اندرانگر';

  @override
  String get pickerLandmarkLabel => 'نشانی (اختیاری)';

  @override
  String get pickerLandmarkHint => 'مثلاً HDFC بینک ATM کے قریب';

  @override
  String get pickerConfirm => 'مقام کی تصدیق کریں اور آگے بڑھیں';

  @override
  String get requestSelectLocation => 'براہ کرم سروس کا مقام منتخب کریں';

  @override
  String requestTitle(Object service) {
    return '$service کی درخواست کریں';
  }

  @override
  String get requestServiceAddress => 'سروس کا پتہ';

  @override
  String get requestDetectingLocation => 'آپ کا مقام معلوم کیا جا رہا ہے…';

  @override
  String get requestTapToPickLocation =>
      'سروس کا مقام منتخب کرنے کے لیے ٹیپ کریں';

  @override
  String get requestDescribeIssue => 'مسئلہ / کام بیان کریں';

  @override
  String get requestDescribeHint =>
      'مثلاً بیٹھک کی مرکزی چھت کی لائٹ کا سوئچ آن کرنے پر چنگاری نکلتی ہے۔';

  @override
  String get requestDescribeMin =>
      'براہ کرم مسئلہ کم از کم 10 حروف میں بیان کریں';

  @override
  String get requestAttachPhotos => 'مسئلے کی تصاویر منسلک کریں (اختیاری)';

  @override
  String get requestAddPhoto => 'تصویر شامل کریں';

  @override
  String get requestWhen => 'آپ کو سروس کب چاہیے؟';

  @override
  String get requestInstant => '⚡ فوری (30 منٹ)';

  @override
  String get requestScheduleLater => '📅 بعد کے لیے طے کریں';

  @override
  String get requestFindWorkers => 'دستیاب کارکن تلاش کریں';

  @override
  String commonLoadFailedDetail(Object detail) {
    return 'لوڈ نہیں ہو سکا: $detail';
  }

  @override
  String get myRequestsTitle => 'میری سروس درخواستیں';

  @override
  String get myRequestsTabAll => 'سب';

  @override
  String get myRequestsNew => 'نئی درخواست';

  @override
  String get myRequestsNoActive => 'کوئی فعال درخواست نہیں';

  @override
  String get myRequestsNoCompleted => 'کوئی مکمل درخواست نہیں';

  @override
  String get myRequestsNone => 'ابھی کوئی سروس درخواست نہیں';

  @override
  String get myRequestsEmptyMessage =>
      'اپنی ضرورت پوسٹ کریں اور کارکنوں کو اپنے پاس آنے دیں۔';

  @override
  String get requestDetailTitle => 'درخواست کی تفصیلات';

  @override
  String get requestDetailBudget => 'بجٹ';

  @override
  String get requestDetailSchedule => 'شیڈول';

  @override
  String get requestDetailLocation => 'مقام';

  @override
  String get requestDetailNotes => 'نوٹس';

  @override
  String get requestDetailCancel => 'درخواست منسوخ کریں';

  @override
  String requestDetailOffersReceived(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count آفرز موصول ہوئیں',
      one: '1 آفر موصول ہوئی',
      zero: 'ابھی کوئی آفر نہیں',
    );
    return '$_temp0';
  }

  @override
  String get requestDetailTapToCompare =>
      'دیکھنے اور موازنہ کرنے کے لیے ٹیپ کریں';

  @override
  String get requestDetailWorkersSoon => 'کارکن جلد جواب دینا شروع کریں گے';

  @override
  String get requestCancelDialogTitle => 'یہ درخواست منسوخ کریں؟';

  @override
  String get requestCancelDialogBody =>
      'تمام زیر التوا آفرز بند کر دی جائیں گی۔ اسے واپس نہیں کیا جا سکتا۔';

  @override
  String get requestCancelKeep => 'رکھیں';

  @override
  String get requestCancelConfirm => 'درخواست منسوخ کریں';

  @override
  String get requestCancelled => 'درخواست منسوخ ہو گئی';

  @override
  String requestExpiresInDaysHours(int days, int hours) {
    return '$days دن $hours گھنٹے میں میعاد ختم';
  }

  @override
  String requestExpiresInHoursMinutes(int hours, int minutes) {
    return '$hours گھنٹے $minutes منٹ میں میعاد ختم';
  }

  @override
  String requestExpiresInMinutes(Object minutes) {
    return '$minutes منٹ میں میعاد ختم';
  }

  @override
  String get requestExpiresSoon => 'جلد میعاد ختم ہو گی';

  @override
  String get commonCancel => 'منسوخ کریں';

  @override
  String get offersTitle => 'موصول آفرز';

  @override
  String get offersEmptyMessage =>
      'کارکن آپ کی درخواست دیکھ رہے ہیں۔ کسی کے جواب دینے پر آپ کو اطلاع دی جائے گی۔';

  @override
  String get offersPending => 'زیر التوا آفرز';

  @override
  String get offersPast => 'گزشتہ آفرز';

  @override
  String offersJobsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count کام',
      one: '1 کام',
    );
    return '$_temp0';
  }

  @override
  String get offersInsured => 'بیمہ شدہ';

  @override
  String get offersDecline => 'مسترد کریں';

  @override
  String get offersAcceptOffer => 'آفر قبول کریں';

  @override
  String get offersAcceptDialogTitle => 'یہ آفر قبول کریں؟';

  @override
  String offersAcceptDialogBody(String worker, String price) {
    return '$worker کے ساتھ $price پر بکنگ بنائی جائے گی۔ باقی تمام آفرز بند ہو جائیں گی۔';
  }

  @override
  String get offersAccept => 'قبول کریں';

  @override
  String offersBookingCreated(Object code) {
    return 'بکنگ $code بن گئی!';
  }

  @override
  String get commonNext => 'آگے';

  @override
  String postRequestPosted(Object code) {
    return 'سروس درخواست $code پوسٹ ہو گئی!';
  }

  @override
  String get postRequestTitle => 'سروس درخواست پوسٹ کریں';

  @override
  String get postRequestWhatService => 'آپ کو کون سی سروس چاہیے؟';

  @override
  String get postRequestSelectCategory =>
      'وہ زمرہ منتخب کریں جو آپ کی ضرورت کو بہترین طور پر بیان کرے۔';

  @override
  String get postRequestDescribe => 'اپنی ضرورت بیان کریں';

  @override
  String postRequestServiceLabel(Object service) {
    return 'سروس: $service';
  }

  @override
  String get postRequestWhatDone => 'آپ کو کیا کام کروانا ہے؟';

  @override
  String get postRequestFieldTitle => 'عنوان';

  @override
  String get postRequestTitleHint => 'مثلاً باورچی خانے کا ٹپکتا نل ٹھیک کرنا';

  @override
  String postRequestMinChars(Object count) {
    return 'کم از کم $count حروف درج کریں';
  }

  @override
  String get postRequestFieldDescription => 'تفصیل';

  @override
  String get postRequestDescriptionHint => 'مسئلہ تفصیل سے بیان کریں…';

  @override
  String get postRequestFieldNotes => 'اضافی نوٹس (اختیاری)';

  @override
  String get postRequestNotesHint => 'گیٹ کوڈ، پسندیدہ وقت وغیرہ';

  @override
  String get postRequestBudgetTitle => 'آپ کا بجٹ';

  @override
  String get postRequestBudgetHint =>
      'کارکنوں کو بتائیں کہ آپ کتنا ادا کرنے کو تیار ہیں۔';

  @override
  String get postRequestFixedPrice => 'مقررہ قیمت (₹)';

  @override
  String postRequestExample(Object example) {
    return 'مثلاً $example';
  }

  @override
  String get postRequestMin => 'کم از کم (₹)';

  @override
  String get postRequestMax => 'زیادہ سے زیادہ (₹)';

  @override
  String get postRequestWhenTitle => 'آپ کو یہ کب چاہیے؟';

  @override
  String get postRequestPickDate => 'تاریخ منتخب کریں';

  @override
  String get postRequestLocationTitle => 'سروس کا مقام';

  @override
  String get postRequestAddressPrivate =>
      'آپ کا درست پتہ آفر قبول کرنے کے بعد ہی شیئر کیا جاتا ہے۔';

  @override
  String get postRequestFullAddress => 'مکمل پتہ';

  @override
  String get postRequestValidAddress => 'درست پتہ درج کریں';

  @override
  String get postRequestCity => 'شہر';

  @override
  String get postRequestCityHint => 'مثلاً بنگلور';

  @override
  String get postRequestPincode => 'پن کوڈ';

  @override
  String get postRequestLocationSet => 'مقام سیٹ ہو گیا ✓';

  @override
  String get postRequestSetOnMap => 'نقشے پر مقام سیٹ کریں';

  @override
  String get postRequestReviewTitle => 'اپنی درخواست کا جائزہ لیں';

  @override
  String get postRequestNotSelected => 'منتخب نہیں';

  @override
  String get postRequestWhen => 'کب';

  @override
  String get postRequestPrivacyNote =>
      'جب تک آپ آفر قبول نہیں کرتے اور بکنگ نہیں بنتی، آپ کا درست پتہ نجی رہتا ہے۔';

  @override
  String get postRequestSubmit => 'درخواست جمع کریں';

  @override
  String get assistantOpening =>
      'اپنے الفاظ میں بتائیں کہ کیا خراب ہے — اور میں اس کے لیے صحیح ماہر تلاش کر دوں گا۔';

  @override
  String assistantCatalogueFailed(Object reason) {
    return '$reason اس کا جواب دینے کے لیے مجھے خدمات کی فہرست چاہیے۔';
  }

  @override
  String get assistantCatalogueError =>
      'خدمات کی فہرست لوڈ کرنے میں کچھ غلط ہو گیا۔';

  @override
  String get assistantGreeting =>
      'السلام علیکم۔ گھر میں آپ کو کس کام میں مدد چاہیے؟ ٹپکتا نل، ٹھنڈا نہ کرنے والا AC، چنگاری دینے والا سوئچ — جو بھی ہو، جیسے چاہیں بیان کریں۔';

  @override
  String get assistantTooVague =>
      'میں مدد کر سکتا ہوں — بس یہ جاننا ہے کہ مسئلہ کیا ہے۔ کیا کام نہیں کر رہا؟';

  @override
  String assistantMultipleJobs(int count) {
    return 'یہ $count الگ الگ کام لگتے ہیں — ان کے لیے الگ الگ کاریگر چاہییں۔ ہر ایک یہاں ہے:';
  }

  @override
  String get assistantAmbiguous =>
      'میں اسے درست کرنا چاہتا ہوں — یہ ایک سے زیادہ کاموں میں جا سکتا ہے۔ کون سا زیادہ قریب ہے؟';

  @override
  String get assistantUnmatched =>
      'میں اسے پلیٹ فارم کی کسی سروس سے نہیں ملا سکا۔ سب سے قریبی منتخب کریں اور میں آپ کی تفصیل وہاں لے جاؤں گا — یا اسے درخواست کے طور پر پوسٹ کریں اور ماہرین کو اپنے پاس آنے دیں۔';

  @override
  String assistantConfidentWithProblem(String service, String problem) {
    return 'یہ $service کا کام لگتا ہے — غالباً \"$problem\"۔';
  }

  @override
  String assistantConfident(Object service) {
    return 'یہ $service کا کام لگتا ہے۔';
  }

  @override
  String assistantChosen(Object service) {
    return 'ٹھیک ہے، $service۔ آپ کی لکھی ہوئی تفصیل ویسے ہی بھیجی جائے گی۔';
  }

  @override
  String get assistantTitle => 'سروس اسسٹنٹ';

  @override
  String get assistantSubtitle => 'آپ کے مسئلے کے لیے صحیح کام تلاش کرتا ہے';

  @override
  String get assistantStartOver => 'دوبارہ شروع کریں';

  @override
  String assistantMatchedOn(Object terms) {
    return 'ملنے والے الفاظ: $terms';
  }

  @override
  String get assistantFindWorkers => 'کارکن تلاش کریں';

  @override
  String get assistantPostRequest => 'درخواست پوسٹ کریں';

  @override
  String get assistantInputHint => 'مسئلہ بیان کریں...';
}
