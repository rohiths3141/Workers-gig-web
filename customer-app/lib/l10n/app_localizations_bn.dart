// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get commonRetry => 'আবার চেষ্টা করুন';

  @override
  String get commonTryAgain => 'আবার চেষ্টা করুন';

  @override
  String get commonSignOut => 'সাইন আউট করুন';

  @override
  String get assistantFabLabel => 'AI-কে জিজ্ঞাসা করুন';

  @override
  String get navHome => 'হোম';

  @override
  String get navExplore => 'খুঁজুন';

  @override
  String get navBookings => 'বুকিং';

  @override
  String get navAlerts => 'সতর্কবার্তা';

  @override
  String get navProfile => 'প্রোফাইল';

  @override
  String get configErrorTitle => 'অ্যাপ কনফিগার করা নেই';

  @override
  String configErrorBody(String keys, String command) {
    return 'এই বিল্ডে $keys নেই। এভাবে চালান:\n\n$command\n\nযাতে অ্যাপ আসল ব্যাকএন্ডে পৌঁছাতে পারে।';
  }

  @override
  String get sessionProfileLoadFailedRetry =>
      'আমরা আপনার প্রোফাইল লোড করতে পারিনি। অনুগ্রহ করে আবার চেষ্টা করুন।';

  @override
  String get sessionProfileLoadFailed => 'আমরা আপনার প্রোফাইল লোড করতে পারিনি';

  @override
  String get sessionCheckClock => 'আপনার ফোনের ঘড়ি পরীক্ষা করুন';

  @override
  String get splashTagline => 'বাড়ির পরিষেবা, সঠিকভাবে।';

  @override
  String get timelineBookingConfirmed => 'বুকিং নিশ্চিত হয়েছে';

  @override
  String get timelineProviderOnTheWay => 'পরিষেবাদাতা পথে আছেন';

  @override
  String get timelineServiceInProgress => 'পরিষেবা চলছে';

  @override
  String get timelineCompleted => 'সম্পন্ন';

  @override
  String get errorNoInternet =>
      'ইন্টারনেট সংযোগ নেই। নেটওয়ার্ক পরীক্ষা করে আবার চেষ্টা করুন।';

  @override
  String get errorTimeout => 'অনেক বেশি সময় লাগছে। আবার চেষ্টা করুন।';

  @override
  String get errorServer =>
      'আমাদের দিকে কিছু সমস্যা হয়েছে। অনুগ্রহ করে আবার চেষ্টা করুন।';

  @override
  String get errorClockSkew =>
      'আপনার ফোনের তারিখ ও সময় ঠিক নেই বলে মনে হচ্ছে। সেটিংসে স্বয়ংক্রিয় তারিখ ও সময় চালু করে আবার চেষ্টা করুন।';

  @override
  String get errorUnexpected =>
      'কিছু সমস্যা হয়েছে। অনুগ্রহ করে আবার চেষ্টা করুন।';

  @override
  String get errorSessionEnded =>
      'আপনার সেশন শেষ হয়েছে। অনুগ্রহ করে আবার সাইন ইন করুন।';

  @override
  String get errorUploadFailed => 'ফাইলটি আপলোড করা যায়নি। আবার চেষ্টা করুন।';

  @override
  String get errorSignInNotReady =>
      'আপনার সাইন-ইন এখনও পুরোপুরি তৈরি হয়নি। একটু পরে আবার চেষ্টা করুন।';

  @override
  String get errorNoLongerAvailable => 'এটি আর উপলব্ধ নেই।';

  @override
  String get errorNotAllowedToSee => 'আপনি এটি দেখতে পারবেন না।';

  @override
  String get errorDidNotWork => 'এটি কাজ করেনি। অনুগ্রহ করে আবার চেষ্টা করুন।';

  @override
  String get authErrorInvalidPhone => 'ফোন নম্বরটি সঠিক মনে হচ্ছে না।';

  @override
  String get authErrorWrongCode => 'কোডটি সঠিক নয়। দেখে আবার চেষ্টা করুন।';

  @override
  String get authErrorCodeExpired =>
      'কোডটির মেয়াদ শেষ হয়ে গেছে। নতুন কোড চান।';

  @override
  String get authErrorTooManyAttempts =>
      'অনেকবার চেষ্টা করা হয়েছে। আবার চেষ্টার আগে কয়েক মিনিট অপেক্ষা করুন।';

  @override
  String get authErrorQuota =>
      'আমরা এখন কোড পাঠাতে পারছি না। একটু পরে আবার চেষ্টা করুন।';

  @override
  String get authErrorDisabled =>
      'এই অ্যাকাউন্টটি বন্ধ করা হয়েছে। সহায়তার সঙ্গে যোগাযোগ করুন।';

  @override
  String get authErrorPhoneNotEnabled =>
      'ফোন দিয়ে সাইন-ইন চালু নেই। সহায়তার সঙ্গে যোগাযোগ করুন।';

  @override
  String get authErrorNumberInUse =>
      'এই নম্বরটি ইতিমধ্যে অন্য একটি অ্যাকাউন্টে নথিভুক্ত।';

  @override
  String get authErrorSignInAgain =>
      'চালিয়ে যেতে অনুগ্রহ করে আবার সাইন ইন করুন।';

  @override
  String get authErrorSignInFailed =>
      'সাইন-ইন ব্যর্থ হয়েছে। অনুগ্রহ করে আবার চেষ্টা করুন।';

  @override
  String get languagePickerTitle => 'আপনার ভাষা বেছে নিন';

  @override
  String get authCouldNotStartVerification =>
      'যাচাই শুরু করা যায়নি। অনুগ্রহ করে আবার চেষ্টা করুন।';

  @override
  String get authWelcomeTitle => 'Wervexa-তে স্বাগতম';

  @override
  String get authWelcomeSubtitle =>
      'বাড়ির মেরামত, প্লাম্বিং, ইলেকট্রিক্যাল, পরিষ্কার ও আরও অনেক কাজের জন্য আশেপাশের সেরা পেশাদারদের খুঁজুন।';

  @override
  String get authEnterPhone => 'আপনার ফোন নম্বর লিখুন';

  @override
  String get authInvalidMobile => 'সঠিক ১০ অঙ্কের মোবাইল নম্বর লিখুন';

  @override
  String get authGetOtp => 'OTP যাচাই পান';

  @override
  String get authTermsNotice =>
      'চালিয়ে গেলে আপনি আমাদের পরিষেবার শর্তাবলী ও গোপনীয়তা নীতিতে সম্মত হচ্ছেন';

  @override
  String get authNewCodeSent => 'আমরা একটি নতুন কোড পাঠিয়েছি।';

  @override
  String get authVerifyPhoneTitle => 'ফোন যাচাই করুন';

  @override
  String get authChangeNumber => 'নম্বর বদলান';

  @override
  String get authEnterCodeTitle => '৬ অঙ্কের কোড লিখুন';

  @override
  String authCodeSentTo(Object phone) {
    return 'আমরা $phone নম্বরে একটি SMS যাচাই কোড পাঠিয়েছি';
  }

  @override
  String get authWrongNumber => 'ভুল নম্বর? বদলান';

  @override
  String get authEnterSixDigits => 'অনুগ্রহ করে ৬টি অঙ্ক লিখুন';

  @override
  String get authResendCode => 'কোড আবার পাঠান';

  @override
  String authResendCodeIn(Object seconds) {
    return '$seconds সেকেন্ডে কোড আবার পাঠান';
  }

  @override
  String get authVerifyAndContinue => 'যাচাই করে চালিয়ে যান';

  @override
  String get registerTitle => 'প্রোফাইল সম্পূর্ণ করুন';

  @override
  String get registerHeading => 'আপনার নাম বলুন';

  @override
  String get registerNameVisibility =>
      'বুকিংয়ের অনুরোধ করলে আপনার নাম পরিষেবাকর্মীরা দেখতে পাবেন।';

  @override
  String get registerFullNameLabel => 'পুরো নাম *';

  @override
  String get registerFullNameHint => 'যেমন রাহুল শর্মা';

  @override
  String get registerFullNameRequired => 'অনুগ্রহ করে আপনার পুরো নাম লিখুন';

  @override
  String get registerEmailLabel => 'ইমেল ঠিকানা (ঐচ্ছিক)';

  @override
  String get registerEmailHint => 'যেমন rahul@example.com';

  @override
  String get registerSubmit => 'সংরক্ষণ করে শুরু করুন';

  @override
  String get bookingStatusRequested => 'পেশাদার খোঁজা হচ্ছে…';

  @override
  String get bookingStatusAccepted => 'পেশাদার পাওয়া গেছে';

  @override
  String get bookingStatusConfirmed => 'নিশ্চিত';

  @override
  String get bookingStatusTraveling => 'পথে আছেন';

  @override
  String get bookingStatusArrived => 'পৌঁছেছেন — আপনার কোড লিখুন';

  @override
  String get bookingStatusInProgress => 'কাজ চলছে';

  @override
  String get bookingStatusAwaitingApproval => 'কাজ শেষ — এগোতে অনুমোদন দিন';

  @override
  String get bookingStatusCompleted => 'সম্পন্ন';

  @override
  String get bookingStatusPaymentPending => 'পেমেন্ট বাকি';

  @override
  String get bookingStatusPaid => 'পেমেন্ট হয়েছে';

  @override
  String get bookingStatusClosed => 'বন্ধ';

  @override
  String get bookingStatusCancelled => 'বাতিল';

  @override
  String get bookingStatusDisputed => 'বিতর্কিত';

  @override
  String get bookingStatusExpired => 'মেয়াদ শেষ — কেউ উপলব্ধ ছিলেন না';

  @override
  String get pricingPerJob => 'প্রতি কাজ';

  @override
  String get pricingPerHour => 'প্রতি ঘণ্টা';

  @override
  String get pricingPerDay => 'প্রতি দিন';

  @override
  String get pricingPerUnit => 'প্রতি ইউনিট';

  @override
  String get pricingPerSqft => 'প্রতি বর্গফুট';

  @override
  String get supportCategoryBooking => 'বুকিং সংক্রান্ত সমস্যা';

  @override
  String get supportCategoryPayment => 'পেমেন্ট';

  @override
  String get supportCategoryPayout => 'পেআউট';

  @override
  String get supportCategoryVerification => 'যাচাই';

  @override
  String get supportCategoryAccount => 'আমার অ্যাকাউন্ট';

  @override
  String get supportCategorySafety => 'নিরাপত্তা সংক্রান্ত উদ্বেগ';

  @override
  String get supportCategoryClaim => 'বিমা দাবি';

  @override
  String get supportCategoryAppIssue => 'অ্যাপের সমস্যা';

  @override
  String get supportCategoryOther => 'অন্যান্য';

  @override
  String get requestStatusDraft => 'খসড়া';

  @override
  String get requestStatusOpen => 'খোলা — অফারের অপেক্ষায়';

  @override
  String get requestStatusReceivingOffers => 'অফার আসছে';

  @override
  String get requestStatusWorkerSelected => 'পেশাদার বেছে নেওয়া হয়েছে';

  @override
  String get requestStatusBooked => 'বুক করা হয়েছে';

  @override
  String get requestStatusCancelled => 'বাতিল';

  @override
  String get requestStatusExpired => 'মেয়াদ শেষ';

  @override
  String get requestStatusClosed => 'বন্ধ';

  @override
  String get budgetTypeFlexible => 'নমনীয়';

  @override
  String get budgetTypeFixed => 'নির্দিষ্ট দাম';

  @override
  String get budgetTypeRange => 'দামের সীমা';

  @override
  String get scheduleAsap => 'যত তাড়াতাড়ি সম্ভব';

  @override
  String get scheduleToday => 'আজ';

  @override
  String get scheduleTomorrow => 'আগামীকাল';

  @override
  String get scheduleSpecificDate => 'নির্দিষ্ট তারিখে';

  @override
  String get scheduleScheduled => 'নির্ধারিত';

  @override
  String get offerStatusSubmitted => 'নতুন অফার';

  @override
  String get offerStatusViewed => 'দেখা হয়েছে';

  @override
  String get offerStatusShortlisted => 'বাছাই তালিকায়';

  @override
  String get offerStatusAccepted => 'গৃহীত';

  @override
  String get offerStatusRejected => 'প্রত্যাখ্যাত';

  @override
  String get offerStatusWithdrawn => 'কর্মী প্রত্যাহার করেছেন';

  @override
  String get offerStatusExpired => 'মেয়াদ শেষ';

  @override
  String get offerStatusClosed => 'বন্ধ';

  @override
  String get gigRatingNew => 'নতুন';

  @override
  String distanceMetres(Object metres) {
    return '$metres মি';
  }

  @override
  String distanceKm(Object km) {
    return '$km কিমি';
  }

  @override
  String durationMinutes(Object minutes) {
    return '$minutes মিনিট';
  }

  @override
  String durationHours(Object hours) {
    return '$hours ঘণ্টা';
  }

  @override
  String durationHoursMinutes(int hours, int minutes) {
    return '$hours ঘণ্টা $minutes মিনিট';
  }

  @override
  String get offerWorkerFallbackName => 'পেশাদার';

  @override
  String get budgetFlexible => 'নমনীয় বাজেট';

  @override
  String get budgetFixed => 'নির্দিষ্ট বাজেট';

  @override
  String offerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি অফার',
      one: '১টি অফার',
      zero: 'এখনও কোনো অফার নেই',
    );
    return '$_temp0';
  }

  @override
  String get authPhoneTenDigits => '১০ অঙ্কের মোবাইল নম্বর লিখুন।';

  @override
  String get authCodeSendTimeout =>
      'আমরা কোড পাঠাতে পারিনি। নেটওয়ার্ক পরীক্ষা করে আবার চেষ্টা করুন।';

  @override
  String get authEnterReceivedCode => 'আপনি যে কোড পেয়েছেন তা লিখুন।';

  @override
  String get authSignInIncomplete =>
      'সাইন-ইন সম্পূর্ণ হয়নি। অনুগ্রহ করে আবার চেষ্টা করুন।';

  @override
  String get authSignInToContinue => 'চালিয়ে যেতে অনুগ্রহ করে সাইন ইন করুন।';

  @override
  String get paymentsNotConfigured =>
      'এই বিল্ডে এখনও পেমেন্ট কনফিগার করা হয়নি।';

  @override
  String get serviceElectrical => 'ইলেকট্রিক্যাল';

  @override
  String get servicePlumbing => 'প্লাম্বিং';

  @override
  String get serviceAcService => 'AC সার্ভিস';

  @override
  String get serviceApplianceRepair => 'যন্ত্রপাতি মেরামত';

  @override
  String get serviceCarpentry => 'কাঠমিস্ত্রির কাজ';

  @override
  String get servicePainting => 'রং করা';

  @override
  String get serviceCleaning => 'পরিষ্কার';

  @override
  String get servicePestControl => 'পোকামাকড় নিয়ন্ত্রণ';

  @override
  String get serviceOtherHome => 'বাড়ির অন্যান্য পরিষেবা';

  @override
  String get addressLabelHome => 'হোম';

  @override
  String get addressLabelWork => 'অফিস';

  @override
  String get addressLabelOther => 'অন্যান্য';

  @override
  String get commonSeeAll => 'সব দেখুন';

  @override
  String get commonViewAll => 'সব দেখুন';

  @override
  String get commonCheckBackLater => 'অনুগ্রহ করে পরে আবার দেখুন।';

  @override
  String get commonUseCurrentLocation => 'বর্তমান অবস্থান ব্যবহার করুন';

  @override
  String get commonChooseOnMap => 'মানচিত্রে বেছে নিন';

  @override
  String homeGreetingNamed(Object name) {
    return 'নমস্কার, $name 👋';
  }

  @override
  String get homeGreeting => 'নমস্কার 👋';

  @override
  String get homeWhatService => 'আজ আপনার কোন পরিষেবা দরকার?';

  @override
  String get homeSetLocation => 'আপনার অবস্থান সেট করুন';

  @override
  String get homeWorkFinishedApprove => 'কাজ শেষ — অনুমোদন দিতে ট্যাপ করুন';

  @override
  String get homeCategories => 'বিভাগ';

  @override
  String homeCategoriesLoadFailed(Object error) {
    return 'বিভাগ লোড করা যায়নি: $error';
  }

  @override
  String get homeFindWorker => 'কর্মী খুঁজুন';

  @override
  String get homeFindWorkerSubtitle => 'আশেপাশের পরিষেবা দেখুন';

  @override
  String get homePostRequest => 'অনুরোধ পোস্ট করুন';

  @override
  String get homePostRequestSubtitle => 'কর্মীরা আপনার কাছে আসবেন';

  @override
  String get homeNoServices => 'এখন কোনো পরিষেবা উপলব্ধ নেই';

  @override
  String get homeSearchNear => 'এর কাছে পরিষেবা খুঁজুন';

  @override
  String get homeSearchHint => 'পরিষেবা খুঁজুন...';

  @override
  String homeActiveBooking(Object code) {
    return 'চলতি বুকিং #$code';
  }

  @override
  String get homeActiveRequests => 'আপনার চলতি অনুরোধ';

  @override
  String get commonGrantPermission => 'অনুমতি দিন';

  @override
  String get commonView => 'দেখুন';

  @override
  String get exploreTitle => 'পরিষেবা খুঁজুন ও আবিষ্কার করুন';

  @override
  String get exploreListView => 'তালিকা দৃশ্য';

  @override
  String get exploreMapView => 'মানচিত্র দৃশ্য';

  @override
  String get exploreSearchHint => 'পরিষেবা, কর্মী বা দক্ষতা খুঁজুন...';

  @override
  String get exploreLocationOffTitle => 'লোকেশন পরিষেবা বন্ধ';

  @override
  String get exploreLocationOffMessage =>
      'আশেপাশের পেশাদারদের খুঁজতে লোকেশন চালু করুন।';

  @override
  String get exploreLocationPermissionTitle => 'লোকেশনের অনুমতি প্রয়োজন';

  @override
  String get exploreLocationPermissionMessage =>
      'আশেপাশের পেশাদার খুঁজতে আমরা আপনার লোকেশন ব্যবহার করি।';

  @override
  String get exploreChooseService => 'খোঁজার জন্য একটি পরিষেবা বেছে নিন';

  @override
  String get exploreChooseServiceMessage =>
      'আশেপাশের পেশাদার দেখতে ওপরে একটি বিভাগ বেছে নিন।';

  @override
  String get exploreNoProfessionals =>
      'এই পরিষেবার জন্য আশেপাশে কোনো পেশাদার উপলব্ধ নেই';

  @override
  String get exploreLoadFailed => 'পেশাদারদের লোড করা যায়নি।';

  @override
  String exploreByWorker(Object name) {
    return '$name-এর দ্বারা';
  }

  @override
  String get bookingsTitle => 'আমার পরিষেবা বুকিং';

  @override
  String get bookingsTabActive => 'চলতি';

  @override
  String get bookingsTabCompleted => 'সম্পন্ন';

  @override
  String get bookingsTabCancelled => 'বাতিল';

  @override
  String get bookingsLoadFailed => 'আপনার বুকিং লোড করা যায়নি।';

  @override
  String get bookingsEmpty => 'এখনও কোনো বুকিং নেই';

  @override
  String get bookingsFindService => 'পরিষেবা খুঁজুন';

  @override
  String get bookingsWaitingForProfessional => 'পেশাদারের অপেক্ষায়';

  @override
  String bookingsCode(Object code) {
    return 'বুকিং কোড: #$code';
  }

  @override
  String get bookingsPayNow => 'এখনই পেমেন্ট করুন';

  @override
  String get bookingsApproveWork => 'কাজ অনুমোদন করুন';

  @override
  String get bookingsTrackLive => 'লাইভ ট্র্যাক করুন';

  @override
  String get bookingsDetails => 'বিবরণ';

  @override
  String get bookingDetailTitle => 'বুকিংয়ের বিবরণ';

  @override
  String get bookingDetailLoadFailed => 'বুকিংয়ের বিবরণ লোড করা যায়নি।';

  @override
  String get bookingDetailWaitingAccept => 'পেশাদারের গ্রহণের অপেক্ষায়';

  @override
  String bookingDetailNumber(Object code) {
    return 'বুকিং #$code';
  }

  @override
  String bookingDetailStatus(Object status) {
    return 'অবস্থা: $status';
  }

  @override
  String get bookingDetailLiveMap => 'লাইভ মানচিত্র';

  @override
  String get bookingDetailServiceInfo => 'পরিষেবা অনুরোধের তথ্য';

  @override
  String get bookingDetailViewMaterials => 'উপকরণ / যন্ত্রাংশের অনুরোধ দেখুন';

  @override
  String get bookingDetailFareDetails => 'ভাড়ার বিবরণ';

  @override
  String get bookingDetailEstimatedFare => 'আনুমানিক ভাড়া';

  @override
  String get bookingDetailFinalFare => 'চূড়ান্ত নিশ্চিত ভাড়া';

  @override
  String get bookingDetailRateReview => 'পরিষেবাকর্মীকে রেটিং ও রিভিউ দিন';

  @override
  String get bookingDetailApproveCompletion => 'কাজ শেষ হওয়া অনুমোদন করুন';

  @override
  String get bookingDetailApprovePaidHint =>
      'আপনার পেশাদার এই কাজটি সম্পন্ন বলে চিহ্নিত করেছেন। অনুমোদন দিলে আপনার পেমেন্ট তাঁর কাছে ছাড়া হবে।';

  @override
  String get bookingDetailApproveUnpaidHint =>
      'আপনার পেশাদার এই কাজটি সম্পন্ন বলে চিহ্নিত করেছেন। নিশ্চিত করে পেমেন্টে যেতে অনুমোদন দিন।';

  @override
  String get bookingDetailReportProblem => 'সমস্যা জানান';

  @override
  String get bookingDetailCompletionApproved => 'কাজ শেষ হওয়া অনুমোদিত';

  @override
  String bookingDetailPayToConfirm(Object amount) {
    return 'নিশ্চিত করতে $amount পেমেন্ট করুন';
  }

  @override
  String get bookingDetailSentAfterPayment =>
      'পেমেন্ট সম্পূর্ণ হলে আপনার বুকিং পেশাদারের কাছে পাঠানো হবে।';

  @override
  String bookingDetailPayAmount(Object amount) {
    return '$amount পেমেন্ট করুন';
  }

  @override
  String get bookingDetailCancelBooking => 'বুকিং বাতিল করুন';

  @override
  String get cancelReasonMistake => 'ভুল করে বুক করেছি';

  @override
  String get cancelReasonNoLongerNeeded => 'আমার আর এই পরিষেবার দরকার নেই';

  @override
  String get cancelReasonDifferentTime => 'আমি অন্য সময় বেছে নিতে চাই';

  @override
  String get cancelReasonFoundSomeoneElse => 'আমি অন্য কাউকে পেয়েছি';

  @override
  String get cancelDialogTitle => 'আপনি কেন বাতিল করছেন?';

  @override
  String get cancelDialogRefundNotice =>
      'এটি ফেরানো যাবে না। আপনার পেমেন্ট মূল পেমেন্ট পদ্ধতিতে ফেরত দেওয়া হবে।';

  @override
  String get cancelDialogCannotUndo => 'এটি ফেরানো যাবে না।';

  @override
  String get cancelDialogKeepBooking => 'বুকিং রাখুন';

  @override
  String get bookingCancelledRefund =>
      'বুকিং বাতিল হয়েছে। আপনার রিফান্ডের অনুরোধ করা হয়েছে।';

  @override
  String get bookingCancelled => 'বুকিং বাতিল হয়েছে';

  @override
  String get arrivalCodeTitle => 'পৌঁছানোর কোড';

  @override
  String get arrivalCodeShare =>
      'পেশাদার পৌঁছেছেন তা নিশ্চিত করতে এই কোডটি তাঁকে দিন:';

  @override
  String get arrivalCodeUnavailable => 'উপলব্ধ নেই';

  @override
  String get arrivalCodeLoadFailed => 'কোড লোড করা যায়নি';

  @override
  String get activeBookingTitle => 'লাইভ বুকিং ও কর্মী ট্র্যাকিং';

  @override
  String get activeBookingLoadFailed => 'এই বুকিং লোড করা যায়নি।';

  @override
  String get activeBookingMapUnavailable =>
      'এই বুকিংয়ের জন্য লাইভ মানচিত্র উপলব্ধ নেই।';

  @override
  String get activeBookingViewDetails => 'বুকিংয়ের বিবরণ দেখুন';

  @override
  String get activeBookingServiceLocation => 'পরিষেবার স্থান';

  @override
  String get activeBookingYourProfessional => 'আপনার পেশাদার';

  @override
  String get activeBookingLive => 'লাইভ';

  @override
  String get activeBookingLastKnown => 'সর্বশেষ জানা অবস্থান';

  @override
  String get activeBookingPhoneNotShared => 'ফোন নম্বর এখনও শেয়ার করা হয়নি';

  @override
  String get activeBookingCallProfessional => 'পেশাদারকে কল করুন';

  @override
  String get activeBookingMaterials => 'উপকরণ';

  @override
  String get activeBookingViewDetailsShort => 'বিবরণ দেখুন';

  @override
  String get locationConnecting => 'লাইভ লোকেশনের সঙ্গে সংযোগ হচ্ছে...';

  @override
  String get locationLiveUnavailable => 'লাইভ লোকেশন সাময়িকভাবে উপলব্ধ নেই';

  @override
  String get locationLiveActive => 'লাইভ লোকেশন চালু';

  @override
  String get locationUpdating => 'আপডেট হচ্ছে...';

  @override
  String get locationUnavailable => 'লোকেশন সাময়িকভাবে উপলব্ধ নেই';

  @override
  String get activeBookingShareStartCode => 'কর্মী পৌঁছেছেন! শুরুর কোড দিন:';

  @override
  String get commonBack => 'ফিরে যান';

  @override
  String get paymentCouldNotOpen =>
      'পেমেন্ট স্ক্রিন খোলা যায়নি। অনুগ্রহ করে আবার চেষ্টা করুন।';

  @override
  String get paymentReceived =>
      'পেমেন্ট পাওয়া গেছে। আপনার বুকিং পেশাদারের কাছে পাঠানো হয়েছে।';

  @override
  String paymentNotConfirmed(String reason, String reference) {
    return 'আমরা এই পেমেন্ট নিশ্চিত করতে পারিনি: $reason। টাকা কেটে থাকলে $reference রেফারেন্স দিয়ে সহায়তার সঙ্গে যোগাযোগ করুন।';
  }

  @override
  String get paymentNotCompleted => 'পেমেন্ট সম্পূর্ণ হয়নি।';

  @override
  String paymentExternalWalletUnsupported(Object wallet) {
    return 'বাহ্যিক ওয়ালেট ($wallet) বেছে নেওয়া হয়েছে — এটি এখনও সমর্থিত নয়।';
  }

  @override
  String get paymentTitle => 'পেমেন্ট';

  @override
  String get paymentStatusUnknown =>
      'এই বুকিংয়ের পেমেন্ট আগেই হয়েছে কিনা আমরা যাচাই করতে পারিনি। দুবার পেমেন্ট না করে অনুগ্রহ করে আবার চেষ্টা করুন।';

  @override
  String get paymentBookingLoadFailed => 'এই বুকিং লোড করা যায়নি।';

  @override
  String get paymentComplete => 'পেমেন্ট সম্পূর্ণ';

  @override
  String paymentPaidFor(String amount, String service) {
    return '$service-এর জন্য $amount পেমেন্ট হয়েছে।';
  }

  @override
  String get paymentViewBooking => 'বুকিং দেখুন';

  @override
  String get paymentBookingSummary => 'বুকিংয়ের সারসংক্ষেপ';

  @override
  String get paymentProvider => 'পরিষেবাদাতা';

  @override
  String get paymentService => 'পরিষেবা';

  @override
  String get paymentDate => 'তারিখ';

  @override
  String get paymentTime => 'সময়';

  @override
  String get paymentAddress => 'ঠিকানা';

  @override
  String get paymentTotal => 'মোট';

  @override
  String get paymentHeldSecurely =>
      'আপনার পেমেন্ট নিরাপদে রাখা হয় এবং আপনি কাজ অনুমোদন করার পরেই পেশাদারকে দেওয়া হয়। কাজ শুরুর আগে বুকিং বাতিল হলে আপনি রিফান্ড পাবেন।';

  @override
  String get commonChange => 'বদলান';

  @override
  String get bookMissingDetails =>
      'বুকিংয়ের বিবরণ অসম্পূর্ণ — অনুগ্রহ করে আবার শুরু করুন।';

  @override
  String get bookSlotPassed =>
      'সেই সময় পেরিয়ে গেছে। আমরা আপনাকে পরবর্তী উপলব্ধ স্লটে সরিয়েছি — দেখে আবার নিশ্চিত করুন।';

  @override
  String bookFailed(Object reason) {
    return 'বুকিং ব্যর্থ হয়েছে: $reason';
  }

  @override
  String get bookNoAddress => 'কোনো ঠিকানা বেছে নেওয়া হয়নি';

  @override
  String get bookTitle => 'পরিষেবা বুক করুন';

  @override
  String get bookSelectDate => 'তারিখ বেছে নিন';

  @override
  String get bookSelectTime => 'সময় বেছে নিন';

  @override
  String get bookSpecialInstructions => 'বিশেষ নির্দেশনা (ঐচ্ছিক)';

  @override
  String get bookSpecialInstructionsHint =>
      'যেমন রান্নাঘর ও বাথরুমে বেশি মনোযোগ দিন...';

  @override
  String get bookConfirm => 'বুকিং নিশ্চিত করুন →';

  @override
  String get gigUnknownProfessional => 'অজানা পেশাদার';

  @override
  String get gigNewProfessional => 'নতুন পেশাদার';

  @override
  String gigRatingWithCount(String rating, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি রিভিউ',
      one: '১টি রিভিউ',
    );
    return '$rating ($_temp0)';
  }

  @override
  String get gigPricing => 'দাম';

  @override
  String get gigServiceRate => 'পরিষেবার হার';

  @override
  String get gigFinalAmountNote =>
      'চূড়ান্ত পরিমাণ আপনার পেশাদার নিশ্চিত করবেন এবং বুকিং তৈরি হলে তাতে দেখানো হবে।';

  @override
  String get gigKycVerified => 'KYC যাচাইকৃত';

  @override
  String get gigBackgroundVerified => 'পটভূমি যাচাইকৃত';

  @override
  String get gigBookNow => 'এখনই বুক করুন →';

  @override
  String get discoveryTitle => 'উপলব্ধ পেশাদার';

  @override
  String get discoveryMissingDetails => 'পরিষেবা বা অবস্থানের বিবরণ নেই।';

  @override
  String get discoveryLocalExperts => 'উপলব্ধ স্থানীয় বিশেষজ্ঞ';

  @override
  String get discoveryWithin => 'দূরত্বের মধ্যে';

  @override
  String get discoveryNoProviders => 'আশেপাশে কোনো পরিষেবাদাতা উপলব্ধ নেই';

  @override
  String get discoveryTryLargerRadius =>
      'বড় খোঁজার দূরত্ব চেষ্টা করুন বা পরে আবার দেখুন।';

  @override
  String get discoveryLoadFailed => 'আশেপাশের পরিষেবাদাতাদের লোড করা যায়নি।';

  @override
  String discoveryServicesForJob(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'এই কাজের জন্য $countটি পরিষেবা',
      one: 'এই কাজের জন্য ১টি পরিষেবা',
    );
    return '$_temp0';
  }

  @override
  String get discoveryBook => 'বুক করুন';

  @override
  String get categoryServiceDetails => 'পরিষেবার বিবরণ';

  @override
  String get categoryTagline =>
      'আগে থেকে নির্দিষ্ট দাম ও পরিষেবার নিশ্চয়তা সহ যাচাইকৃত, পটভূমি-পরীক্ষিত স্থানীয় বিশেষজ্ঞ বুক করুন।';

  @override
  String get categoryWhatHelp => 'আপনার কী কাজে সাহায্য দরকার?';

  @override
  String get categoryDescribeElse => 'অন্য কিছু বর্ণনা করুন';

  @override
  String get categoryLoadFailed => 'এই পরিষেবা লোড করা যায়নি।';

  @override
  String get notificationsTitle => 'বিজ্ঞপ্তি ও সতর্কবার্তা';

  @override
  String get notificationsEmpty => 'আপনি সব দেখে ফেলেছেন';

  @override
  String get notificationsLoadFailed => 'বিজ্ঞপ্তি লোড করা যায়নি।';

  @override
  String get timeJustNow => 'এইমাত্র';

  @override
  String timeMinutesAgo(Object minutes) {
    return '$minutes মিনিট আগে';
  }

  @override
  String timeHoursAgo(Object hours) {
    return '$hours ঘণ্টা আগে';
  }

  @override
  String get timeYesterday => 'গতকাল';

  @override
  String get completedTitle => 'পরিষেবা সম্পন্ন!';

  @override
  String get completedThanks => 'আমাদের পরিষেবা ব্যবহারের জন্য ধন্যবাদ।';

  @override
  String get completedViewBookings => 'বুকিং দেখুন';

  @override
  String get completedBackHome => 'হোমে ফিরে যান';

  @override
  String commonErrorDetail(Object detail) {
    return 'ত্রুটি: $detail';
  }

  @override
  String get reviewTitle => 'আপনার অভিজ্ঞতার রেটিং দিন';

  @override
  String get reviewHeading => 'দারুণ পরিষেবা!';

  @override
  String get reviewQuestion => 'আপনার পেশাদারের সঙ্গে অভিজ্ঞতা কেমন ছিল?';

  @override
  String reviewStars(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count তারা',
      one: '১ তারা',
    );
    return '$_temp0';
  }

  @override
  String get reviewCommentHint => 'আপনার অভিজ্ঞতা সম্পর্কে বলুন...';

  @override
  String get reviewSubmit => 'রিভিউ জমা দিন →';

  @override
  String get materialsTitle => 'উপকরণ / যন্ত্রাংশের অনুরোধ';

  @override
  String get materialsEmpty =>
      'এই বুকিংয়ের জন্য কোনো উপকরণের অনুরোধ জমা পড়েনি';

  @override
  String materialsQuantityEstimated(Object quantity) {
    return '$quantity · আনুমানিক';
  }

  @override
  String materialsQuantityActual(Object quantity) {
    return '$quantity · প্রকৃত';
  }

  @override
  String get materialsReject => 'প্রত্যাখ্যান করুন';

  @override
  String get materialsApprove => 'অনুমোদন করুন';

  @override
  String get materialStatusRequested => 'অনুরোধ করা হয়েছে';

  @override
  String get materialStatusCustomerReview => 'আপনার পর্যালোচনার অপেক্ষায়';

  @override
  String get materialStatusApproved => 'অনুমোদিত';

  @override
  String get materialStatusRejected => 'প্রত্যাখ্যাত';

  @override
  String get materialStatusPurchased => 'কেনা হয়েছে';

  @override
  String get materialStatusCostRecorded => 'খরচ নথিভুক্ত';

  @override
  String get materialStatusBilled => 'বিলে যুক্ত';

  @override
  String get materialStatusCancelled => 'বাতিল';

  @override
  String get commonSaveChanges => 'পরিবর্তন সংরক্ষণ করুন';

  @override
  String get profileTitle => 'আমার প্রোফাইল ও অ্যাকাউন্ট';

  @override
  String get profileFallbackName => 'গ্রাহক প্রোফাইল';

  @override
  String get profileLanguage => 'ভাষা';

  @override
  String get profileAddresses => 'সংরক্ষিত পরিষেবা ঠিকানা';

  @override
  String get profileAddressesSubtitle =>
      'বাড়ি, অফিস ও অন্যান্য ঠিকানা পরিচালনা করুন';

  @override
  String get profileHistory => 'আগের পরিষেবার ইতিহাস';

  @override
  String get profileHistorySubtitle => 'রসিদ ও আগের বুকিং দেখুন';

  @override
  String get profileSupport => 'সাহায্য ও গ্রাহক সহায়তা';

  @override
  String get profileSupportSubtitle =>
      'টিকিট তৈরি করুন, আমাদের দলের উত্তর দেখুন';

  @override
  String get editProfileSaved => 'প্রোফাইল সফলভাবে আপডেট হয়েছে';

  @override
  String get editProfileTitle => 'প্রোফাইল সম্পাদনা করুন';

  @override
  String get editProfileFullName => 'পুরো নাম';

  @override
  String get editProfileNameEmpty => 'নাম খালি রাখা যাবে না';

  @override
  String get editProfileEmail => 'ইমেল ঠিকানা';

  @override
  String get commonEdit => 'সম্পাদনা';

  @override
  String get commonDelete => 'মুছুন';

  @override
  String get addressesAdd => 'নতুন ঠিকানা যোগ করুন';

  @override
  String get addressesEmpty => 'আপনি এখনও কোনো ঠিকানা সংরক্ষণ করেননি';

  @override
  String get addressesEmptyMessage =>
      'পরের বার দ্রুত বুক করতে একটি পরিষেবা ঠিকানা যোগ করুন।';

  @override
  String get addressesDefaultBadge => 'ডিফল্ট';

  @override
  String get addressesSetDefault => 'ডিফল্ট হিসেবে সেট করুন';

  @override
  String get addressesLoadFailed => 'ঠিকানা লোড করা যায়নি।';

  @override
  String get addressesLabelSheet => 'এই ঠিকানার নাম দিন';

  @override
  String get supportTitle => 'সাহায্য ও সহায়তা';

  @override
  String get supportNewTicket => 'নতুন টিকিট';

  @override
  String get supportEmpty => 'এখনও কোনো সহায়তা টিকিট নেই';

  @override
  String get supportEmptyMessage =>
      'বুকিং বা অ্যাপ নিয়ে সাহায্য দরকার? একটি টিকিট তৈরি করুন, আমাদের দল উত্তর দেবে।';

  @override
  String get supportLoadFailed => 'আপনার সহায়তা টিকিট লোড করা যায়নি।';

  @override
  String get supportStatusOpen => 'খোলা';

  @override
  String get supportStatusInProgress => 'চলছে';

  @override
  String get supportStatusWaitingForYou => 'আপনার অপেক্ষায়';

  @override
  String get supportStatusResolved => 'সমাধান হয়েছে';

  @override
  String get supportStatusClosed => 'বন্ধ';

  @override
  String get supportNewTicketTitle => 'নতুন সহায়তা টিকিট';

  @override
  String get supportCategory => 'বিভাগ';

  @override
  String get supportSubject => 'বিষয়';

  @override
  String get supportDescribeIssue => 'সমস্যাটি বর্ণনা করুন';

  @override
  String get supportFillSubjectMessage => 'অনুগ্রহ করে বিষয় ও বার্তা লিখুন।';

  @override
  String get supportSubmitTicket => 'টিকিট জমা দিন';

  @override
  String get supportTicketTitle => 'সহায়তা টিকিট';

  @override
  String get supportNoMessages => 'এখনও কোনো বার্তা নেই';

  @override
  String get supportMessagesLoadFailed => 'বার্তা লোড করা যায়নি।';

  @override
  String get supportTypeMessage => 'একটি বার্তা লিখুন...';

  @override
  String get supportSend => 'পাঠান';

  @override
  String get pickerEnterAddress =>
      'অনুগ্রহ করে এই পিনের ঠিকানা লিখুন বা নিশ্চিত করুন';

  @override
  String get pickerTitle => 'পরিষেবার ঠিকানা বেছে নিন';

  @override
  String get pickerGettingLocation => 'আপনার অবস্থান জানা হচ্ছে...';

  @override
  String get pickerPermissionDenied =>
      'লোকেশনের অনুমতি দেওয়া হয়নি — ঠিকানা বেছে নিতে মানচিত্রটি নিজে সরান।';

  @override
  String get pickerConfirmPin => 'পরিষেবা পিনের অবস্থান নিশ্চিত করুন';

  @override
  String get pickerAddressLabel => 'বাড়ি / ফ্ল্যাট / রাস্তার নাম';

  @override
  String get pickerAddressHint => 'যেমন #102, গ্রিন অ্যাভিনিউ, ইন্দিরানগর';

  @override
  String get pickerLandmarkLabel => 'ল্যান্ডমার্ক (ঐচ্ছিক)';

  @override
  String get pickerLandmarkHint => 'যেমন HDFC ব্যাংক ATM-এর কাছে';

  @override
  String get pickerConfirm => 'অবস্থান নিশ্চিত করে এগিয়ে যান';

  @override
  String get requestSelectLocation => 'অনুগ্রহ করে পরিষেবার স্থান বেছে নিন';

  @override
  String requestTitle(Object service) {
    return '$service-এর অনুরোধ করুন';
  }

  @override
  String get requestServiceAddress => 'পরিষেবার ঠিকানা';

  @override
  String get requestDetectingLocation => 'আপনার অবস্থান শনাক্ত করা হচ্ছে…';

  @override
  String get requestTapToPickLocation => 'পরিষেবার স্থান বেছে নিতে ট্যাপ করুন';

  @override
  String get requestDescribeIssue => 'সমস্যা / কাজ বর্ণনা করুন';

  @override
  String get requestDescribeHint =>
      'যেমন বসার ঘরের মূল সিলিং লাইটের সুইচ চালু করলে স্পার্ক করছে।';

  @override
  String get requestDescribeMin =>
      'অনুগ্রহ করে সমস্যাটি অন্তত ১০টি অক্ষরে বর্ণনা করুন';

  @override
  String get requestAttachPhotos => 'সমস্যার ছবি যোগ করুন (ঐচ্ছিক)';

  @override
  String get requestAddPhoto => 'একটি ছবি যোগ করুন';

  @override
  String get requestWhen => 'আপনার কখন পরিষেবা দরকার?';

  @override
  String get requestInstant => '⚡ তাৎক্ষণিক (৩০ মিনিট)';

  @override
  String get requestScheduleLater => '📅 পরের জন্য নির্ধারণ করুন';

  @override
  String get requestFindWorkers => 'উপলব্ধ কর্মী খুঁজুন';

  @override
  String commonLoadFailedDetail(Object detail) {
    return 'লোড করা যায়নি: $detail';
  }

  @override
  String get myRequestsTitle => 'আমার পরিষেবা অনুরোধ';

  @override
  String get myRequestsTabAll => 'সব';

  @override
  String get myRequestsNew => 'নতুন অনুরোধ';

  @override
  String get myRequestsNoActive => 'কোনো চলতি অনুরোধ নেই';

  @override
  String get myRequestsNoCompleted => 'কোনো সম্পন্ন অনুরোধ নেই';

  @override
  String get myRequestsNone => 'এখনও কোনো পরিষেবা অনুরোধ নেই';

  @override
  String get myRequestsEmptyMessage =>
      'আপনার প্রয়োজন পোস্ট করুন, কর্মীরা আপনার কাছে আসবেন।';

  @override
  String get requestDetailTitle => 'অনুরোধের বিবরণ';

  @override
  String get requestDetailBudget => 'বাজেট';

  @override
  String get requestDetailSchedule => 'সময়সূচি';

  @override
  String get requestDetailLocation => 'অবস্থান';

  @override
  String get requestDetailNotes => 'নোট';

  @override
  String get requestDetailCancel => 'অনুরোধ বাতিল করুন';

  @override
  String requestDetailOffersReceived(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি অফার এসেছে',
      one: '১টি অফার এসেছে',
      zero: 'এখনও কোনো অফার নেই',
    );
    return '$_temp0';
  }

  @override
  String get requestDetailTapToCompare => 'দেখতে ও তুলনা করতে ট্যাপ করুন';

  @override
  String get requestDetailWorkersSoon => 'কর্মীরা শীঘ্রই সাড়া দিতে শুরু করবেন';

  @override
  String get requestCancelDialogTitle => 'এই অনুরোধ বাতিল করবেন?';

  @override
  String get requestCancelDialogBody =>
      'সব বাকি অফার বন্ধ করে দেওয়া হবে। এটি ফেরানো যাবে না।';

  @override
  String get requestCancelKeep => 'রেখে দিন';

  @override
  String get requestCancelConfirm => 'অনুরোধ বাতিল করুন';

  @override
  String get requestCancelled => 'অনুরোধ বাতিল হয়েছে';

  @override
  String requestExpiresInDaysHours(int days, int hours) {
    return '$days দিন $hours ঘণ্টায় মেয়াদ শেষ';
  }

  @override
  String requestExpiresInHoursMinutes(int hours, int minutes) {
    return '$hours ঘণ্টা $minutes মিনিটে মেয়াদ শেষ';
  }

  @override
  String requestExpiresInMinutes(Object minutes) {
    return '$minutes মিনিটে মেয়াদ শেষ';
  }

  @override
  String get requestExpiresSoon => 'শীঘ্রই মেয়াদ শেষ';

  @override
  String get commonCancel => 'বাতিল';

  @override
  String get offersTitle => 'প্রাপ্ত অফার';

  @override
  String get offersEmptyMessage =>
      'কর্মীরা আপনার অনুরোধ দেখছেন। কেউ সাড়া দিলে আপনাকে জানানো হবে।';

  @override
  String get offersPending => 'বাকি অফার';

  @override
  String get offersPast => 'আগের অফার';

  @override
  String offersJobsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি কাজ',
      one: '১টি কাজ',
    );
    return '$_temp0';
  }

  @override
  String get offersInsured => 'বিমাকৃত';

  @override
  String get offersDecline => 'প্রত্যাখ্যান করুন';

  @override
  String get offersAcceptOffer => 'অফার গ্রহণ করুন';

  @override
  String get offersAcceptDialogTitle => 'এই অফার গ্রহণ করবেন?';

  @override
  String offersAcceptDialogBody(String worker, String price) {
    return '$worker-এর সঙ্গে $price-এ একটি বুকিং তৈরি হবে। বাকি সব অফার বন্ধ হয়ে যাবে।';
  }

  @override
  String get offersAccept => 'গ্রহণ করুন';

  @override
  String offersBookingCreated(Object code) {
    return 'বুকিং $code তৈরি হয়েছে!';
  }

  @override
  String get commonNext => 'পরবর্তী';

  @override
  String postRequestPosted(Object code) {
    return 'পরিষেবা অনুরোধ $code পোস্ট হয়েছে!';
  }

  @override
  String get postRequestTitle => 'পরিষেবা অনুরোধ পোস্ট করুন';

  @override
  String get postRequestWhatService => 'আপনার কোন পরিষেবা দরকার?';

  @override
  String get postRequestSelectCategory =>
      'আপনার প্রয়োজনকে সবচেয়ে ভালো বোঝায় এমন বিভাগ বেছে নিন।';

  @override
  String get postRequestDescribe => 'আপনার প্রয়োজন বর্ণনা করুন';

  @override
  String postRequestServiceLabel(Object service) {
    return 'পরিষেবা: $service';
  }

  @override
  String get postRequestWhatDone => 'আপনার কী কাজ করাতে হবে?';

  @override
  String get postRequestFieldTitle => 'শিরোনাম';

  @override
  String get postRequestTitleHint => 'যেমন রান্নাঘরের লিক করা কল সারানো';

  @override
  String postRequestMinChars(Object count) {
    return 'অন্তত $countটি অক্ষর লিখুন';
  }

  @override
  String get postRequestFieldDescription => 'বিবরণ';

  @override
  String get postRequestDescriptionHint => 'সমস্যাটি বিস্তারিত বর্ণনা করুন…';

  @override
  String get postRequestFieldNotes => 'অতিরিক্ত নোট (ঐচ্ছিক)';

  @override
  String get postRequestNotesHint => 'গেট কোড, পছন্দের সময় ইত্যাদি';

  @override
  String get postRequestBudgetTitle => 'আপনার বাজেট';

  @override
  String get postRequestBudgetHint => 'আপনি কত দিতে চান তা কর্মীদের জানান।';

  @override
  String get postRequestFixedPrice => 'নির্দিষ্ট দাম (₹)';

  @override
  String postRequestExample(Object example) {
    return 'যেমন $example';
  }

  @override
  String get postRequestMin => 'সর্বনিম্ন (₹)';

  @override
  String get postRequestMax => 'সর্বোচ্চ (₹)';

  @override
  String get postRequestWhenTitle => 'আপনার কখন এটি দরকার?';

  @override
  String get postRequestPickDate => 'একটি তারিখ বেছে নিন';

  @override
  String get postRequestLocationTitle => 'পরিষেবার স্থান';

  @override
  String get postRequestAddressPrivate =>
      'আপনার সঠিক ঠিকানা শুধু অফার গ্রহণ করার পরেই শেয়ার করা হয়।';

  @override
  String get postRequestFullAddress => 'সম্পূর্ণ ঠিকানা';

  @override
  String get postRequestValidAddress => 'সঠিক ঠিকানা লিখুন';

  @override
  String get postRequestCity => 'শহর';

  @override
  String get postRequestCityHint => 'যেমন বেঙ্গালুরু';

  @override
  String get postRequestPincode => 'পিনকোড';

  @override
  String get postRequestLocationSet => 'অবস্থান সেট হয়েছে ✓';

  @override
  String get postRequestSetOnMap => 'মানচিত্রে অবস্থান সেট করুন';

  @override
  String get postRequestReviewTitle => 'আপনার অনুরোধ পর্যালোচনা করুন';

  @override
  String get postRequestNotSelected => 'বেছে নেওয়া হয়নি';

  @override
  String get postRequestWhen => 'কখন';

  @override
  String get postRequestPrivacyNote =>
      'অফার গ্রহণ করে বুকিং তৈরি না হওয়া পর্যন্ত আপনার সঠিক ঠিকানা গোপন থাকে।';

  @override
  String get postRequestSubmit => 'অনুরোধ জমা দিন';

  @override
  String get assistantOpening =>
      'নিজের ভাষায় বলুন কী সমস্যা — আমি তার জন্য সঠিক পেশাদার খুঁজে দেব।';

  @override
  String assistantCatalogueFailed(Object reason) {
    return '$reason এর উত্তর দিতে আমার পরিষেবার তালিকা দরকার।';
  }

  @override
  String get assistantCatalogueError =>
      'পরিষেবার তালিকা লোড করতে সমস্যা হয়েছে।';

  @override
  String get assistantGreeting =>
      'নমস্কার। বাড়িতে কী কাজে সাহায্য দরকার? লিক করা কল, ঠান্ডা না করা AC, স্পার্ক করা সুইচ — যা-ই হোক, যেভাবে খুশি বর্ণনা করুন।';

  @override
  String get assistantTooVague =>
      'আমি সাহায্য করতে পারি — শুধু জানতে হবে সমস্যাটা কী। কী কাজ করছে না?';

  @override
  String assistantMultipleJobs(int count) {
    return 'এগুলো $countটি আলাদা কাজ মনে হচ্ছে — এগুলোর জন্য আলাদা কারিগর লাগবে। প্রতিটি এখানে:';
  }

  @override
  String get assistantAmbiguous =>
      'আমি এটা ঠিকভাবে করতে চাই — এটি একাধিক কাজের মধ্যে পড়তে পারে। কোনটি বেশি কাছাকাছি?';

  @override
  String get assistantUnmatched =>
      'প্ল্যাটফর্মের কোনো পরিষেবার সঙ্গে এটি মেলাতে পারিনি। সবচেয়ে কাছেরটি বেছে নিন, আমি আপনার বর্ণনা সেখানে নিয়ে যাব — অথবা অনুরোধ হিসেবে পোস্ট করুন, পেশাদাররা আপনার কাছে আসবেন।';

  @override
  String assistantConfidentWithProblem(String service, String problem) {
    return 'এটি $service-এর কাজ মনে হচ্ছে — সম্ভবত \"$problem\"।';
  }

  @override
  String assistantConfident(Object service) {
    return 'এটি $service-এর কাজ মনে হচ্ছে।';
  }

  @override
  String assistantChosen(Object service) {
    return 'ঠিক আছে, $service। আপনার বর্ণনা যেমন লিখেছেন তেমনই পাঠানো হবে।';
  }

  @override
  String get assistantTitle => 'পরিষেবা সহায়ক';

  @override
  String get assistantSubtitle => 'আপনার সমস্যার জন্য সঠিক কাজ খুঁজে দেয়';

  @override
  String get assistantStartOver => 'আবার শুরু করুন';

  @override
  String assistantMatchedOn(Object terms) {
    return 'মিলেছে: $terms';
  }

  @override
  String get assistantFindWorkers => 'কর্মী খুঁজুন';

  @override
  String get assistantPostRequest => 'অনুরোধ পোস্ট করুন';

  @override
  String get assistantInputHint => 'সমস্যাটি বর্ণনা করুন...';
}
