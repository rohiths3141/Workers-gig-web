// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get languagePickerTitle => 'আপনার ভাষা বেছে নিন';

  @override
  String get startupMissingConfig => 'এই বিল্ডে কনফিগারেশন নেই।';

  @override
  String startupPassDartDefine(Object keys) {
    return 'এগুলো --dart-define দিয়ে দিন:\n\n$keys';
  }

  @override
  String get startupCouldNotStart => 'অ্যাপ চালু হতে পারেনি।';

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
  String get eligibilityStepIncomplete => 'এই ধাপটি এখনও সম্পূর্ণ হয়নি।';

  @override
  String get errorSessionEnded =>
      'আপনার সেশন শেষ হয়েছে। অনুগ্রহ করে আবার সাইন ইন করুন।';

  @override
  String get errorUploadFailed => 'ফাইলটি আপলোড করা যায়নি। আবার চেষ্টা করুন।';

  @override
  String get errorServiceUnavailable =>
      'এই পরিষেবাটি এখন উপলব্ধ নয়। একটু পরে আবার চেষ্টা করুন।';

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
  String get authErrorPhoneNotEnabledRegion =>
      'ফোন দিয়ে সাইন-ইন চালু নেই, অথবা এই অঞ্চলে SMS আটকানো আছে। Firebase Console-এর সেটিংস দেখুন।';

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
  String get scheduleSpecificDate => 'নির্দিষ্ট তারিখ';

  @override
  String get offerStatusSubmitted => 'জমা দেওয়া হয়েছে';

  @override
  String get offerStatusViewed => 'গ্রাহক দেখেছেন';

  @override
  String get offerStatusShortlisted => 'বাছাই তালিকায়';

  @override
  String get offerStatusAccepted => 'গৃহীত ✓';

  @override
  String get offerStatusRejected => 'বেছে নেওয়া হয়নি';

  @override
  String get offerStatusWithdrawn => 'প্রত্যাহার করা হয়েছে';

  @override
  String get offerStatusExpired => 'মেয়াদ শেষ';

  @override
  String get offerStatusClosed => 'বন্ধ';

  @override
  String distanceMetresAway(Object metres) {
    return '$metres মি দূরে';
  }

  @override
  String distanceKmAway(Object km) {
    return '$km কিমি দূরে';
  }

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
  String get gigErrorTrade => 'এই পরিষেবাটি কোন কাজের অন্তর্গত তা বেছে নিন';

  @override
  String get gigErrorTitleShort =>
      'এই পরিষেবার অন্তত ৬ অক্ষরের একটি স্পষ্ট নাম দিন';

  @override
  String get gigErrorTitleLong => 'নাম ১২০ অক্ষরের কম রাখুন';

  @override
  String get gigErrorPrice => 'এই পরিষেবার জন্য আপনি কত নেন তা লিখুন';

  @override
  String get gigErrorDurationMissing => 'এতে সাধারণত কত সময় লাগে?';

  @override
  String get gigErrorDurationShort =>
      'আমরা সবচেয়ে ছোট যে কাজ তালিকাভুক্ত করতে পারি তা ১৫ মিনিটের';

  @override
  String get gigErrorDurationLong =>
      'আমরা সবচেয়ে বড় যে কাজ তালিকাভুক্ত করতে পারি তা ১৪ দিনের';

  @override
  String get gigErrorRadius =>
      'যাতায়াতের দূরত্ব ১ থেকে ১০০ কিমির মধ্যে হতে হবে';

  @override
  String get jobAreaNearby => 'কাছাকাছি';

  @override
  String get jobBlockerVerifyArrival => 'গ্রাহকের কোড দিয়ে পৌঁছানো যাচাই করুন';

  @override
  String get jobBlockerAfterPhoto => 'শেষ হওয়া কাজের একটি ছবি যোগ করুন';

  @override
  String jobBlockerMaterialsPending(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'উপকরণের $countটি অনুরোধ এখনও গ্রাহকের অপেক্ষায়',
      one: 'উপকরণের ১টি অনুরোধ এখনও গ্রাহকের অপেক্ষায়',
    );
    return '$_temp0';
  }

  @override
  String mediaTypeNotAccepted(Object kinds) {
    return 'এখানে এই ধরনের ফাইল গ্রহণযোগ্য নয়। $kinds ব্যবহার করুন।';
  }

  @override
  String get mediaEmpty => 'ফাইলটি খালি।';

  @override
  String mediaTooLarge(Object megabytes) {
    return 'ফাইলটি খুব বড়। সীমা ${megabytes}MB।';
  }

  @override
  String get verificationNotStarted => 'শুরু হয়নি';

  @override
  String get verificationSubmitted => 'জমা দেওয়া হয়েছে';

  @override
  String get verificationUnderReview => 'পর্যালোচনা চলছে';

  @override
  String get verificationMoreInfo => 'আরও তথ্য দরকার';

  @override
  String get verificationExpired => 'মেয়াদ শেষ';

  @override
  String get verificationVerified => 'যাচাইকৃত';

  @override
  String get verificationNotApproved => 'অনুমোদিত নয়';

  @override
  String get verificationNotRequired => 'প্রয়োজন নেই';

  @override
  String get qualificationErrorInstitution => 'কোন প্রতিষ্ঠান এটি দিয়েছে?';

  @override
  String get qualificationErrorName => 'যোগ্যতার নাম কী?';

  @override
  String get qualificationErrorYearMissing =>
      'আপনি কোন বছর এটি সম্পূর্ণ করেছেন?';

  @override
  String qualificationErrorYearRange(Object year) {
    return '১৯৫০ থেকে $year-এর মধ্যে একটি বছর লিখুন';
  }

  @override
  String get walletTxJobEarning => 'কাজের আয়';

  @override
  String get walletTxMaterialReimbursed => 'উপকরণের খরচ ফেরত';

  @override
  String get walletTxAdjustment => 'সমন্বয়';

  @override
  String get walletTxPayoutReturned => 'পেআউট ফেরত এসেছে';

  @override
  String get walletTxPlatformFee => 'প্ল্যাটফর্ম ফি';

  @override
  String get walletTxWithdrawn => 'প্রত্যাহার করা হয়েছে';

  @override
  String get walletTxClaimRecovery => 'দাবি পুনরুদ্ধার';

  @override
  String get payoutStatusRequested => 'অনুরোধ করা হয়েছে';

  @override
  String get payoutStatusProcessing => 'প্রক্রিয়াধীন';

  @override
  String get payoutStatusPaid => 'পেমেন্ট হয়েছে';

  @override
  String get payoutStatusFailed => 'ব্যর্থ';

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
  String get accountDeletionBySupport =>
      'অ্যাকাউন্ট মোছার কাজ আমাদের সহায়তা দল করে। একটি অনুরোধ করুন, কাজ হলে আমরা নিশ্চিত করব।';

  @override
  String get photoUploadFailed => 'ছবিটি আপলোড করা যায়নি।';

  @override
  String get photoUploadFailedRetry =>
      'ছবিটি আপলোড করা যায়নি। আবার চেষ্টা করুন।';

  @override
  String get locationInvalid => 'অবস্থানটি সঠিক মনে হচ্ছে না।';

  @override
  String get travelDistanceRange =>
      '১ থেকে ১০০ কিমির মধ্যে যাতায়াতের দূরত্ব বেছে নিন।';

  @override
  String get profileLoadFailed => 'আপনার প্রোফাইল লোড করা যায়নি।';

  @override
  String get uploadIncomplete => 'আপলোড সম্পূর্ণ হয়নি। আবার চেষ্টা করুন।';

  @override
  String get uploadTooLarge => 'ফাইলটি খুব বড়।';

  @override
  String get uploadTypeNotAccepted => 'এই ধরনের ফাইল গ্রহণযোগ্য নয়।';

  @override
  String get uploadRefused => 'ফাইলটি প্রত্যাখ্যান করা হয়েছে।';

  @override
  String get uploadTooMany =>
      'একসঙ্গে অনেক আপলোড। একটু অপেক্ষা করে আবার চেষ্টা করুন।';

  @override
  String get uploadGone => 'এই আপলোডটি আর উপলব্ধ নেই। ফাইলটি আবার বেছে নিন।';

  @override
  String get uploadDidNotStart => 'আপলোড শুরু হয়নি।';

  @override
  String get uploadDidNotFinish => 'আপলোডটি শেষ হয়নি।';

  @override
  String get claimResponseTooShort =>
      'অনুগ্রহ করে কী হয়েছে একটু বিস্তারিত বলুন।';

  @override
  String get walletLoadFailedRetry =>
      'আপনার ওয়ালেট লোড করা যায়নি। অনুগ্রহ করে আবার চেষ্টা করুন।';

  @override
  String get walletLoadFailed => 'আপনার ওয়ালেট লোড করা যায়নি।';

  @override
  String get onboardingStepDetails => 'আপনার বিবরণ';

  @override
  String get onboardingStepTrade => 'আপনার প্রধান কাজ';

  @override
  String get onboardingStepSkills => 'আপনি কী করতে পারেন';

  @override
  String get onboardingStepArea => 'আপনি কোথায় কাজ করেন';

  @override
  String get onboardingStepKyc => 'পরিচয় যাচাই';

  @override
  String get onboardingStepReady => 'কাজের জন্য প্রস্তুত';

  @override
  String routerScreenNotFound(Object location) {
    return 'এই স্ক্রিনটি খোলা যায়নি।\n$location';
  }

  @override
  String get cameraOpenFailed => 'ক্যামেরা খোলা যায়নি। অ্যাপের অনুমতি দেখুন।';

  @override
  String get commonTryAgain => 'আবার চেষ্টা করুন';

  @override
  String get commonCancel => 'বাতিল';

  @override
  String get commonConfirm => 'নিশ্চিত করুন';

  @override
  String get offlineBanner =>
      'আপনি অফলাইনে আছেন। আবার সংযুক্ত হলে কাজের পদক্ষেপগুলো কাজ করবে।';

  @override
  String get badgeNew => 'নতুন';

  @override
  String get badgeAccepted => 'গৃহীত';

  @override
  String get badgeConfirmed => 'নিশ্চিত';

  @override
  String get badgeOnTheWay => 'পথে আছেন';

  @override
  String get badgeArrived => 'পৌঁছেছেন';

  @override
  String get badgeWorking => 'কাজ চলছে';

  @override
  String get badgeAwaitingCustomer => 'গ্রাহকের অপেক্ষায়';

  @override
  String get badgeDone => 'সম্পন্ন';

  @override
  String get badgePaymentDue => 'পেমেন্ট বাকি';

  @override
  String get badgePaid => 'পেমেন্ট হয়েছে';

  @override
  String get badgeClosed => 'বন্ধ';

  @override
  String get badgeCancelled => 'বাতিল';

  @override
  String get badgeDisputed => 'বিতর্কিত';

  @override
  String get badgeExpired => 'মেয়াদ শেষ';

  @override
  String get badgeDraft => 'খসড়া';

  @override
  String get badgeInReview => 'পর্যালোচনায়';

  @override
  String get badgeLive => 'লাইভ';

  @override
  String get badgePaused => 'বিরতি';

  @override
  String get badgeNotApproved => 'অনুমোদিত নয়';

  @override
  String get badgeRemoved => 'সরানো হয়েছে';

  @override
  String get badgeNotStarted => 'শুরু হয়নি';

  @override
  String get badgeSubmitted => 'জমা দেওয়া হয়েছে';

  @override
  String get badgeActionNeeded => 'পদক্ষেপ প্রয়োজন';

  @override
  String get badgeVerified => 'যাচাইকৃত';

  @override
  String get badgeNotRequired => 'প্রয়োজন নেই';

  @override
  String get commonContinue => 'চালিয়ে যান';

  @override
  String get commonSaving => 'সংরক্ষণ হচ্ছে…';

  @override
  String get welcomePromiseWorkTitle => 'উপযুক্ত কাজ পান';

  @override
  String get welcomePromiseWorkBody =>
      'আপনার কাছাকাছি কাজ, যা আপনি আসলে যে কাজ করেন তার সঙ্গে মেলে।';

  @override
  String get welcomePromiseSkillsTitle => 'আপনার দক্ষতা প্রমাণ করুন';

  @override
  String get welcomePromiseSkillsBody =>
      'আপনার ITI ও ডিপ্লোমা সার্টিফিকেট, একবার যাচাই করে প্রতিটি গ্রাহককে দেখানো হয়।';

  @override
  String get welcomePromiseTrackTitle => 'প্রতিটি কাজের হিসাব রাখুন';

  @override
  String get welcomePromiseTrackBody =>
      'কাজ গ্রহণ থেকে শেষ করা পর্যন্ত, প্রতিটি ধাপে ছবির রেকর্ড সহ।';

  @override
  String get welcomePromisePaidTitle => 'নিরাপদে টাকা পান';

  @override
  String get welcomePromisePaidBody =>
      'প্রতিটি টাকা নথিভুক্ত, স্পষ্ট স্টেটমেন্ট সহ এবং আপনার শর্তে টাকা তোলা।';

  @override
  String get welcomeHeadline => 'কাজ যা আপনাকে খুঁজে নেয়';

  @override
  String get welcomeSubtitle =>
      'Wervexa দক্ষ পেশাদারদের তাঁদের প্রয়োজন এমন গ্রাহকদের সঙ্গে যুক্ত করে।';

  @override
  String get welcomeGetStarted => 'শুরু করুন';

  @override
  String get welcomeCodeNotice =>
      'আমরা আপনার মোবাইল নম্বরে একটি ওয়ান-টাইম কোড পাঠাব।';

  @override
  String get phoneTitle => 'আপনার মোবাইল নম্বর কী?';

  @override
  String get phoneSubtitle =>
      'এটি আপনিই কিনা নিশ্চিত করতে আমরা একটি ওয়ান-টাইম কোড পাঠাব।';

  @override
  String get phoneSendCode => 'কোড পাঠান';

  @override
  String get phoneSending => 'পাঠানো হচ্ছে…';

  @override
  String get authNewCodeSent => 'আমরা একটি নতুন কোড পাঠিয়েছি।';

  @override
  String get otpTitle => 'কোড লিখুন';

  @override
  String otpSentTo(Object phone) {
    return 'আমরা $phone নম্বরে ৬ অঙ্কের একটি কোড পাঠিয়েছি।';
  }

  @override
  String otpResendIn(int seconds) {
    String _temp0 = intl.Intl.pluralLogic(
      seconds,
      locale: localeName,
      other: '$seconds সেকেন্ড পরে নতুন কোড চাইতে পারবেন',
      one: '১ সেকেন্ড পরে নতুন কোড চাইতে পারবেন',
    );
    return '$_temp0';
  }

  @override
  String get otpSendNew => 'নতুন কোড পাঠান';

  @override
  String get otpVerify => 'যাচাই করুন';

  @override
  String get otpVerifying => 'যাচাই হচ্ছে…';

  @override
  String get registerNameRequired => 'অনুগ্রহ করে আপনার পুরো নাম লিখুন';

  @override
  String get registerEmailInvalid => 'অনুগ্রহ করে সঠিক ইমেল ঠিকানা লিখুন';

  @override
  String get registerTitle => 'আমরা আপনাকে কী নামে ডাকব?';

  @override
  String get registerSubtitle => 'গ্রাহকরা এই নামটিই দেখবেন।';

  @override
  String get registerNameLabel => 'পুরো নাম';

  @override
  String get registerNameHint => 'অরুণ কুমার';

  @override
  String get registerEmailLabel => 'ইমেল (ঐচ্ছিক)';

  @override
  String get registerEmailHelper => 'রসিদ ও স্টেটমেন্টের জন্য।';

  @override
  String registerVerifiedPhone(Object phone) {
    return 'যাচাইকৃত: $phone';
  }

  @override
  String get navHome => 'হোম';

  @override
  String get navJobs => 'কাজ';

  @override
  String get navWallet => 'ওয়ালেট';

  @override
  String get navProfile => 'প্রোফাইল';

  @override
  String get sessionProfileLoadFailedRetry =>
      'আমরা আপনার প্রোফাইল লোড করতে পারিনি। অনুগ্রহ করে আবার চেষ্টা করুন।';

  @override
  String get commonSignOut => 'সাইন আউট করুন';

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
  String get commonSeeAll => 'সব দেখুন';

  @override
  String distanceKm(Object km) {
    return '$km কিমি';
  }

  @override
  String get homeRightNow => 'এই মুহূর্তে';

  @override
  String get homeNewWork => 'নতুন কাজ';

  @override
  String homeJobsWaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি কাজ আপনার উত্তরের অপেক্ষায়',
      one: '১টি কাজ আপনার উত্তরের অপেক্ষায়',
    );
    return '$_temp0';
  }

  @override
  String get homeComingUp => 'আসন্ন';

  @override
  String get homeEarnings => 'আয়';

  @override
  String get homeMyServices => 'আমার পরিষেবা';

  @override
  String get homeVerification => 'যাচাই';

  @override
  String get homeSupport => 'সহায়তা';

  @override
  String get homeRequests => 'অনুরোধ';

  @override
  String get homeMyOffers => 'আমার অফার';

  @override
  String get homeAddService => 'পরিষেবা যোগ করুন';

  @override
  String get homeAddServiceBody =>
      'আপনি যে পরিষেবা প্রকাশ করেছেন শুধু সেগুলোর জন্যই গ্রাহকরা আপনাকে বুক করতে পারেন।';

  @override
  String get homeNotReady => 'এখনও পুরো প্রস্তুত নয়';

  @override
  String get homeNotReadyBody =>
      'এই ধাপগুলো শেষ করলেই কাজ পাওয়া শুরু করতে পারবেন।';

  @override
  String get homeGoodMorning => 'সুপ্রভাত';

  @override
  String get homeGoodAfternoon => 'শুভ অপরাহ্ন';

  @override
  String get homeGoodEvening => 'শুভ সন্ধ্যা';

  @override
  String get homeNotifications => 'বিজ্ঞপ্তি';

  @override
  String get availabilityAvailable => 'উপলব্ধ';

  @override
  String get availabilityAvailableBody => 'আপনি নতুন কাজ পেতে পারেন।';

  @override
  String get availabilityOnJob => 'কাজে আছেন';

  @override
  String get availabilityOnJobBody =>
      'এই কাজ শেষ না হওয়া পর্যন্ত আপনাকে নতুন কাজ দেওয়া হবে না।';

  @override
  String get availabilityOff => 'বন্ধ';

  @override
  String get availabilityOffBody => 'আপনি নতুন কাজ পাবেন না।';

  @override
  String get availabilityFinishJob => 'আবার উপলব্ধ হতে বর্তমান কাজটি শেষ করুন।';

  @override
  String get availabilityGoOff => 'ডিউটি বন্ধ করুন';

  @override
  String get availabilityGoOn => 'উপলব্ধ হন';

  @override
  String get availabilityBeforeJobs => 'কাজ পাওয়ার আগে';

  @override
  String get availabilityNowOn => 'আপনি কাজের জন্য উপলব্ধ।';

  @override
  String get availabilityNowOff => 'আপনি ডিউটিতে নেই।';

  @override
  String get workerStatusSetupIncomplete => 'সেটআপ অসম্পূর্ণ';

  @override
  String get workerStatusUnderReview => 'পর্যালোচনায়';

  @override
  String get workerStatusInactive => 'নিষ্ক্রিয়';

  @override
  String get workerStatusRestricted => 'সীমাবদ্ধ';

  @override
  String get workerStatusSuspended => 'স্থগিত';

  @override
  String get homeAccount => 'অ্যাকাউন্ট';

  @override
  String get homeWorkStatus => 'কাজের অবস্থা';

  @override
  String get availabilityOffDuty => 'ডিউটিতে নেই';

  @override
  String get earningsThisWeek => 'এই সপ্তাহে';

  @override
  String get earningsThisMonth => 'এই মাসে';

  @override
  String get jobNextWaitConfirm => 'গ্রাহকের নিশ্চিতকরণের অপেক্ষায়';

  @override
  String get jobNextStartTravel => 'যাত্রা শুরু করুন';

  @override
  String get jobNextMarkArrived => 'পৌঁছেছেন বলে চিহ্নিত করুন';

  @override
  String get jobNextStartWork => 'কাজ শুরু করুন';

  @override
  String get jobNextAskCode => 'গ্রাহকের কাছে পৌঁছানোর কোড চান';

  @override
  String get jobNextFinish => 'শেষ করে ছবি যোগ করুন';

  @override
  String get jobNextWaitApprove => 'গ্রাহকের অনুমোদনের অপেক্ষায়';

  @override
  String get jobNextOpen => 'কাজ খুলুন';

  @override
  String get jobTimeTbc => 'সময় নিশ্চিত হবে';

  @override
  String get settingsTitle => 'সেটিংস';

  @override
  String get settingsLanguage => 'ভাষা';

  @override
  String get settingsAbout => 'সম্পর্কে';

  @override
  String get settingsTerms => 'পরিষেবার শর্তাবলী';

  @override
  String get settingsPrivacy => 'গোপনীয়তা নীতি';

  @override
  String get settingsHelp => 'সাহায্য ও সহায়তা';

  @override
  String get settingsDeleteAccount => 'আমার অ্যাকাউন্ট মুছুন';

  @override
  String get settingsSignOutTitle => 'সাইন আউট করবেন?';

  @override
  String get settingsSignOutBody =>
      'আবার সাইন ইন করতে আপনার ফোন নম্বর ও একটি কোড লাগবে।';

  @override
  String get settingsDeleteTitle => 'আপনার অ্যাকাউন্ট মুছুন';

  @override
  String get settingsDeleteBody =>
      'অ্যাকাউন্ট মুছলে আপনার কাজের ইতিহাস, আয়ের রেকর্ড ও খোলা পেমেন্ট প্রভাবিত হয়, তাই এটি স্বয়ংক্রিয়ভাবে নয়, আমাদের সহায়তা দল করে।\n\nএকটি সহায়তা অনুরোধ করুন, কাজ হলে আমরা নিশ্চিত করব।';

  @override
  String get settingsContactSupport => 'সহায়তার সঙ্গে যোগাযোগ করুন';

  @override
  String get notificationsMarkAllRead => 'সব পড়া হয়েছে চিহ্নিত করুন';

  @override
  String get notificationsEmpty => 'আপনি সব দেখে ফেলেছেন';

  @override
  String get notificationsEmptyBody =>
      'কাজের অফার, পেমেন্টের আপডেট ও যাচাইয়ের ফলাফল এখানে দেখা যাবে।';

  @override
  String get jobsTabUpcoming => 'আসন্ন';

  @override
  String get jobsTabActive => 'চলতি';

  @override
  String get jobsNoOffers => 'এখন কোনো নতুন কাজ নেই';

  @override
  String get jobsNoOffersBody =>
      'আপনি উপলব্ধ থাকলে উপযুক্ত কাজ আসামাত্র আমরা জানাব।';

  @override
  String get jobsAccepted => 'কাজ গ্রহণ করা হয়েছে।';

  @override
  String get jobsDeclineTitle => 'এই কাজটি প্রত্যাখ্যান করবেন?';

  @override
  String get jobsDeclineBody =>
      'এটি অন্য কর্মীকে দেওয়া হবে। প্রায়ই প্রত্যাখ্যান করলে আপনাকে দেখানো কাজের সংখ্যা কমতে পারে।';

  @override
  String get jobsDecline => 'প্রত্যাখ্যান করুন';

  @override
  String get jobsDeclined => 'কাজ প্রত্যাখ্যান করা হয়েছে।';

  @override
  String get jobsEmptyUpcoming => 'কিছু নির্ধারিত নেই';

  @override
  String get jobsEmptyUpcomingBody => 'আপনার গ্রহণ করা কাজ এখানে দেখা যাবে।';

  @override
  String get jobsEmptyActive => 'কোনো কাজ চলছে না';

  @override
  String get jobsEmptyActiveBody => 'কোনো কাজ শুরু করলে তা এখানে দেখা যাবে।';

  @override
  String get jobsEmptyCompleted => 'এখনও কোনো সম্পন্ন কাজ নেই';

  @override
  String get jobsEmptyCompletedBody =>
      'শেষ হওয়া কাজ ও সেগুলো থেকে আপনার আয় এখানে দেখানো হবে।';

  @override
  String get jobsEmptyCancelled => 'কিছু বাতিল হয়নি';

  @override
  String get jobsEmptyCancelledBody => 'বাতিল হওয়া কাজ এখানে দেখানো হবে।';

  @override
  String get jobsEmptyOffers => 'কোনো অফার নেই';

  @override
  String get jobsEmptyOffersBody => 'নতুন কাজ এখানে দেখা যাবে।';

  @override
  String get jobTitleFallback => 'কাজ';

  @override
  String jobCancelledReason(Object reason) {
    return 'বাতিল: $reason';
  }

  @override
  String get jobAmount => 'কাজের পরিমাণ';

  @override
  String get jobMaterials => 'উপকরণ';

  @override
  String get jobYouEarned => 'আপনার আয়';

  @override
  String get jobRateCustomer => 'গ্রাহককে রেটিং দিন';

  @override
  String get jobRateQuestion => 'কাজটি আপনার কেমন লাগল?';

  @override
  String get jobRate => 'রেটিং দিন';

  @override
  String get jobHistory => 'কী কী হয়েছে';

  @override
  String get jobHistoryLoadFailed => 'কাজের ইতিহাস লোড করা যায়নি।';

  @override
  String get jobOfferExpired => 'এই কাজটি আর উপলব্ধ নেই।';

  @override
  String get jobOfferNewBadge => 'নতুন কাজ';

  @override
  String get jobOfferYouEarn => 'আপনার আয়';

  @override
  String get jobOfferPriceAfterVisit => 'আসার পর নিশ্চিত হবে';

  @override
  String get jobOfferAccept => 'কাজ গ্রহণ করুন';

  @override
  String get activeJobTitle => 'বর্তমান কাজ';

  @override
  String get activeJobEmptyBody =>
      'কোনো কাজ গ্রহণ করে শুরু করলে তা এখানে দেখা যাবে।';

  @override
  String get evidenceBeforeTitle => 'শুরু করার আগে';

  @override
  String get evidenceBeforeBody =>
      'হাত দেওয়ার আগে সমস্যার ছবি তুলুন। গ্রাহক পরে কাজ নিয়ে আপত্তি তুললে এটি আপনাকে রক্ষা করবে।';

  @override
  String get evidenceAfterTitle => 'শেষ করার পরে';

  @override
  String get evidenceAfterBody =>
      'শেষ হওয়া কাজের ছবি আপনার প্রমাণ, যদি গ্রাহক পরে আপত্তি তোলেন। ঐচ্ছিক, তবে দশ সেকেন্ড দেওয়ার মতো।';

  @override
  String get jobCustomerHidden => 'নিশ্চিত হলে গ্রাহকের বিবরণ শেয়ার করা হবে';

  @override
  String get jobCall => 'কল করুন';

  @override
  String get jobDirections => 'পথনির্দেশ';

  @override
  String get jobTrackOnMap => 'মানচিত্রে ট্র্যাক করুন';

  @override
  String get trailAccepted => 'গৃহীত';

  @override
  String get trailOnTheWay => 'পথে আছেন';

  @override
  String get trailArrived => 'পৌঁছেছেন';

  @override
  String get trailArrivalConfirmed => 'পৌঁছানো নিশ্চিত';

  @override
  String get trailWorkStarted => 'কাজ শুরু হয়েছে';

  @override
  String get trailFinished => 'শেষ হয়েছে';

  @override
  String get jobProgress => 'অগ্রগতি';

  @override
  String get jobBeforeFinish => 'শেষ করার আগে';

  @override
  String get jobActionStartTravel => 'যাত্রা শুরু করুন';

  @override
  String get jobActionArrived => 'আমি পৌঁছে গেছি';

  @override
  String get jobActionEnterCode => 'পৌঁছানোর কোড লিখুন';

  @override
  String get jobActionStartWork => 'কাজ শুরু করুন';

  @override
  String get jobActionFinish => 'কাজ শেষ করুন';

  @override
  String get jobArrivalConfirmed => 'পৌঁছানো নিশ্চিত হয়েছে।';

  @override
  String get jobFinishTitle => 'এই কাজটি শেষ করবেন?';

  @override
  String get jobFinishBody =>
      'গ্রাহককে কাজটি অনুমোদন করতে বলা হবে। এরপর আপনি আর ছবি যোগ করতে পারবেন না।';

  @override
  String get jobOnYourWay => 'আপনি পথে আছেন।';

  @override
  String get jobMarkedArrived => 'পৌঁছেছেন বলে চিহ্নিত হয়েছে।';

  @override
  String get jobWorkStarted => 'কাজ শুরু হয়েছে।';

  @override
  String get jobSentForApproval =>
      'অনুমোদনের জন্য গ্রাহকের কাছে পাঠানো হয়েছে।';

  @override
  String get jobUpdated => 'আপডেট হয়েছে।';

  @override
  String get jobWaitConfirm => 'গ্রাহকের বুকিং নিশ্চিত করার অপেক্ষায়।';

  @override
  String get jobWaitApprove => 'গ্রাহকের আপনার কাজ অনুমোদনের অপেক্ষায়।';

  @override
  String get jobWaitPaymentProcessing => 'অনুমোদিত। পেমেন্ট প্রক্রিয়াধীন।';

  @override
  String get jobWaitPayment => 'গ্রাহকের পেমেন্টের অপেক্ষায়।';

  @override
  String get jobWaitPaid => 'পেমেন্ট হয়েছে। আপনার আয় ওয়ালেটে দেখা যাবে।';

  @override
  String get jobWaitDisputed =>
      'আমাদের দল এই কাজটি পর্যালোচনা করছে। আমরা যোগাযোগ করব।';

  @override
  String get jobWaitNothing => 'এখন কিছু করার নেই।';

  @override
  String get travelRouteUnavailable => 'রুট উপলব্ধ নেই';

  @override
  String get travelNoDestination => 'কোনো গন্তব্য সেট নেই';

  @override
  String get travelNoDestinationBody =>
      'এই কাজের কোনো পরিষেবার স্থান নেই যেখানে রুট দেখানো যায়।';

  @override
  String get travelJobLocation => 'কাজের স্থান';

  @override
  String get travelYou => 'আপনি';

  @override
  String get travelCustomer => 'গ্রাহক';

  @override
  String get travelCalculating => 'রুট হিসাব করা হচ্ছে...';

  @override
  String distanceMetres(Object metres) {
    return '$metres মি';
  }

  @override
  String etaMinutes(Object minutes) {
    return '$minutes মিনিট';
  }

  @override
  String etaHours(Object hours) {
    return '$hours ঘণ্টা';
  }

  @override
  String get arrivalWrongCode => 'কোডটি সঠিক নয়।';

  @override
  String arrivalWrongCodeAttempts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'কোডটি সঠিক নয়। আর $count বার চেষ্টা বাকি।',
      one: 'কোডটি সঠিক নয়। আর ১ বার চেষ্টা বাকি।',
    );
    return '$_temp0';
  }

  @override
  String get arrivalTitle => 'আপনি পৌঁছেছেন তা নিশ্চিত করুন';

  @override
  String get arrivalBody =>
      'গ্রাহককে তাঁর অ্যাপের কোডটি পড়ে শোনাতে বলুন, তারপর এখানে লিখুন।';

  @override
  String get arrivalLocked =>
      'অনেকবার ভুল কোড দেওয়া হয়েছে। এই কাজ চালিয়ে যেতে সহায়তার সঙ্গে যোগাযোগ করুন।';

  @override
  String get arrivalConfirm => 'পৌঁছানো নিশ্চিত করুন';

  @override
  String get arrivalNotYet => 'এখনও না';

  @override
  String get rateThanks => 'মতামতের জন্য ধন্যবাদ।';

  @override
  String get rateTitle => 'এই গ্রাহক কেমন ছিলেন?';

  @override
  String get rateBody =>
      'আপনার রেটিং গোপন থাকে এবং কর্মীদের দেখাশোনায় আমাদের সাহায্য করে।';

  @override
  String get rateCommentLabel => 'আর কিছু বলবেন? (ঐচ্ছিক)';

  @override
  String get rateSubmit => 'রেটিং জমা দিন';

  @override
  String get timerServiceTime => 'পরিষেবার সময়';

  @override
  String get materialsAdd => 'যোগ করুন';

  @override
  String get materialsLoadFailed => 'উপকরণ লোড করা যায়নি।';

  @override
  String get materialsEmpty =>
      'এই কাজের জন্য যন্ত্রাংশ দরকার হলে এখানে যোগ করুন, গ্রাহককে খরচ অনুমোদন করতে বলা হবে।';

  @override
  String get materialStatusWaiting => 'গ্রাহকের অপেক্ষায়';

  @override
  String get materialStatusApproved => 'অনুমোদিত';

  @override
  String get materialStatusDeclined => 'প্রত্যাখ্যাত';

  @override
  String get materialStatusBought => 'কেনা হয়েছে';

  @override
  String get materialStatusCostRecorded => 'খরচ নথিভুক্ত';

  @override
  String get materialStatusBilled => 'বিলে যুক্ত';

  @override
  String get materialStatusCancelled => 'বাতিল';

  @override
  String materialQuantityEstimated(Object quantity, Object unit) {
    return '$quantity $unit · আনুমানিক';
  }

  @override
  String materialQuantityActual(Object quantity, Object unit) {
    return '$quantity $unit · প্রকৃত';
  }

  @override
  String get materialRecordCost => 'খরচ নথিভুক্ত করুন';

  @override
  String materialCustomerSaid(Object reason) {
    return 'গ্রাহক বলেছেন: $reason';
  }

  @override
  String get materialUnitPiece => 'টি';

  @override
  String get materialWhatNeeded => 'আপনার কী দরকার?';

  @override
  String get materialEnterQuantity => 'কতগুলো লাগবে লিখুন';

  @override
  String get materialEnterCost => 'আনুমানিক খরচ লিখুন';

  @override
  String get materialRequestBody =>
      'কেনার আগে গ্রাহককে এটি অনুমোদন করতে বলা হবে।';

  @override
  String get materialName => 'উপকরণ';

  @override
  String get materialNameHint => 'যেমন 16A মডুলার সুইচ';

  @override
  String get materialQuantity => 'পরিমাণ';

  @override
  String get materialUnit => 'একক';

  @override
  String get materialExpectedCost => 'আনুমানিক খরচ';

  @override
  String get materialAskCustomer => 'গ্রাহককে জিজ্ঞাসা করুন';

  @override
  String get materialEnterPaid => 'আপনি যত টাকা দিয়েছেন তা লিখুন';

  @override
  String get materialCostRecorded => 'খরচ নথিভুক্ত হয়েছে।';

  @override
  String get materialWhatCost => 'এর খরচ কত হয়েছে?';

  @override
  String get materialReceiptBody =>
      'রসিদ যোগ করুন যাতে এটি গ্রাহকের বিলে যোগ করা যায়।';

  @override
  String get materialAmountPaid => 'প্রদত্ত পরিমাণ';

  @override
  String get materialReceipt => 'রসিদ';

  @override
  String get materialReceiptRequired => 'বিলের একটি ছবি আবশ্যক।';

  @override
  String get evidenceDone => 'সম্পন্ন';

  @override
  String get evidenceRequired => 'আবশ্যক';

  @override
  String get evidenceCamera => 'ক্যামেরা';

  @override
  String get evidenceGallery => 'গ্যালারি';

  @override
  String get evidenceSaved => 'সংরক্ষিত';

  @override
  String get uploadWaiting => 'অপেক্ষায়';

  @override
  String get uploadPreparing => 'প্রস্তুত হচ্ছে';

  @override
  String get uploadStarting => 'আপলোড শুরু হচ্ছে';

  @override
  String uploadPercent(Object percent) {
    return '$percent%';
  }

  @override
  String get uploadFinishing => 'শেষ হচ্ছে';

  @override
  String get uploadCancel => 'আপলোড বাতিল করুন';

  @override
  String get uploadNotFinished => 'আপলোডটি শেষ হয়নি।';

  @override
  String get commonRetry => 'আবার চেষ্টা করুন';

  @override
  String durationMinutes(Object minutes) {
    return '$minutes মিনিট';
  }

  @override
  String durationHours(Object hours) {
    return '$hours ঘণ্টা';
  }

  @override
  String durationHoursMinutes(Object hours, Object minutes) {
    return '$hours ঘণ্টা $minutes মিনিট';
  }

  @override
  String durationDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count দিন',
      one: '১ দিন',
    );
    return '$_temp0';
  }

  @override
  String pricePerHour(Object price) {
    return '$price/ঘণ্টা';
  }

  @override
  String pricePerDay(Object price) {
    return '$price/দিন';
  }

  @override
  String pricePerUnit(Object price) {
    return '$price/ইউনিট';
  }

  @override
  String pricePerSqft(Object price) {
    return '$price/বর্গফুট';
  }

  @override
  String get gigsTitle => 'আমার পরিষেবা';

  @override
  String get gigsAddTooltip => 'পরিষেবা যোগ করুন';

  @override
  String get gigsAdd => 'পরিষেবা যোগ করুন';

  @override
  String get gigsEmpty => 'এখনও কোনো পরিষেবা নেই';

  @override
  String get gigsEmptyBody =>
      'আপনি যে পরিষেবা দেন সেগুলো যোগ করুন। যত কাজের জন্য অনুমোদিত, সবগুলোতে যত খুশি পরিষেবা যোগ করতে পারেন।';

  @override
  String get gigsNoneLive =>
      'আপনার কোনো পরিষেবা চালু নেই, তাই গ্রাহকরা আপনাকে বুক করতে পারবেন না।';

  @override
  String gigsLiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি পরিষেবা চালু আছে।',
      one: '১টি পরিষেবা চালু আছে।',
    );
    return '$_temp0';
  }

  @override
  String get gigsAvailable => 'আপনি কাজের জন্য উপলব্ধ।';

  @override
  String get gigsOffDuty => 'আপনি ডিউটিতে নেই, তাই আপনাকে কাজ দেওয়া হবে না।';

  @override
  String gigJobsDone(int count) {
    return '$countটি সম্পন্ন';
  }

  @override
  String get gigEdit => 'সম্পাদনা';

  @override
  String get gigPause => 'বিরতি দিন';

  @override
  String get gigResume => 'আবার চালু করুন';

  @override
  String get gigInReview => 'পর্যালোচনায়';

  @override
  String get gigDraftHint => 'খসড়া — পর্যালোচনার জন্য জমা দিন';

  @override
  String get gigRejectedHint => 'প্রত্যাখ্যাত — সম্পাদনা করে আবার জমা দিন';

  @override
  String get gigArchived => 'আর্কাইভ করা';

  @override
  String get gigNotLive => 'চালু নয়';

  @override
  String get gigPaused =>
      'বিরতি দেওয়া হয়েছে। আপনাকে এই কাজগুলো দেওয়া হবে না।';

  @override
  String get gigLiveAgain => 'আবার চালু হয়েছে।';

  @override
  String get gigDuration30m => '৩০ মিনিট';

  @override
  String get gigDuration45m => '৪৫ মিনিট';

  @override
  String get gigDuration1h => '১ ঘণ্টা';

  @override
  String get gigDuration2h => '২ ঘণ্টা';

  @override
  String get gigDuration4h => '৪ ঘণ্টা';

  @override
  String get gigDuration8h => '৮ ঘণ্টা (একটি কর্মদিবস)';

  @override
  String get gigDuration24h => '২৪ ঘণ্টা';

  @override
  String get gigDuration2d => '২ দিন';

  @override
  String get gigDuration3d => '৩ দিন';

  @override
  String get gigDuration1w => '১ সপ্তাহ';

  @override
  String get gigSavedDraft => 'খসড়া হিসেবে সংরক্ষিত।';

  @override
  String get gigSubmitted => 'জমা দেওয়া হয়েছে। আমরা পর্যালোচনা করে জানাব।';

  @override
  String get gigLive => 'আপনার পরিষেবা চালু হয়েছে।';

  @override
  String get gigSaved => 'সংরক্ষিত।';

  @override
  String get gigEditorAddTitle => 'পরিষেবা যোগ করুন';

  @override
  String get gigEditorEditTitle => 'পরিষেবা সম্পাদনা করুন';

  @override
  String get gigNoTrades => 'এখনও কোনো অনুমোদিত কাজ নেই';

  @override
  String get gigNoTradesBody =>
      'কোনো কাজ আপনার জন্য অনুমোদিত হলে তার অধীনে পরিষেবা প্রকাশ করতে পারবেন। শুরু করতে প্রোফাইল থেকে একটি কাজ যোগ করুন।';

  @override
  String get gigFieldTrade => 'কোন কাজ?';

  @override
  String get gigFieldTitle => 'পরিষেবাটির নাম কী?';

  @override
  String get gigFieldTitleHint => 'গ্রাহকরা এটি দেখবেন। নির্দিষ্ট করে লিখুন।';

  @override
  String get gigFieldTitleExample => 'যেমন স্প্লিট AC ডিপ ক্লিনিং';

  @override
  String get gigFieldDescription => 'এতে কী কী অন্তর্ভুক্ত?';

  @override
  String get gigFieldDescriptionHint =>
      'ঐচ্ছিক, তবে এতে গ্রাহকদের আপনাকে বেছে নিতে সুবিধা হয়।';

  @override
  String get gigFieldDescriptionExample =>
      'যেমন ইনডোর ও আউটডোর ইউনিটের পুরো পরিষ্কার, ফিল্টার ধোয়া, গ্যাস প্রেশার পরীক্ষা।';

  @override
  String get gigFieldPrice => 'আপনি কত নেন?';

  @override
  String get gigFieldPriceHint =>
      'প্রতিটি পরিষেবার নিজস্ব দাম। এটি আপনার অন্য পরিষেবাগুলোকে প্রভাবিত করে না।';

  @override
  String get gigUnitPerJob => 'প্রতি কাজ';

  @override
  String get gigUnitPerHour => 'প্রতি ঘণ্টা';

  @override
  String get gigUnitPerDay => 'প্রতি দিন';

  @override
  String get gigUnitPerUnit => 'প্রতি ইউনিট';

  @override
  String get gigUnitPerSqft => 'প্রতি বর্গফুট';

  @override
  String get gigFieldDuration => 'এতে সাধারণত কত সময় লাগে?';

  @override
  String get gigFieldRadius => 'এর জন্য আপনি কত দূর যাবেন?';

  @override
  String get gigFieldRadiusHint =>
      'আপনার সাধারণ যাতায়াত দূরত্ব ব্যবহার করতে ডিফল্ট রাখুন।';

  @override
  String get gigUsualDistance => 'আপনার সাধারণ দূরত্ব';

  @override
  String get gigUseUsualDistance => 'আমার সাধারণ দূরত্ব ব্যবহার করুন';

  @override
  String get gigReviewNotice =>
      'নতুন ও সম্পাদিত পরিষেবা চালু হওয়ার আগে আমাদের দল পরীক্ষা করে। হয়ে গেলেই আমরা জানাব।';

  @override
  String get gigSaveDraft => 'খসড়া সংরক্ষণ করুন';

  @override
  String get gigSubmitForReview => 'পর্যালোচনার জন্য জমা দিন';

  @override
  String get walletAllTransactions => 'সব লেনদেন';

  @override
  String get walletFrozen =>
      'একটি বিষয় খতিয়ে দেখার সময় টাকা তোলা আটকে রাখা হয়েছে। বিস্তারিত জানতে সহায়তার সঙ্গে যোগাযোগ করুন।';

  @override
  String get walletWithdraw => 'টাকা তুলুন';

  @override
  String walletNothingPending(Object amount) {
    return 'এখনও তোলার মতো কিছু নেই। $amount এখনও প্রক্রিয়াধীন, ওই কাজগুলো অনুমোদিত হলে আপনার ব্যালেন্সে আসবে।';
  }

  @override
  String get walletNothingYet =>
      'এখনও তোলার মতো কিছু নেই। গ্রাহক শেষ হওয়া কাজ অনুমোদন করলে আপনার আয় এখানে দেখা যাবে।';

  @override
  String get walletRecentEarnings => 'সাম্প্রতিক আয়';

  @override
  String get walletNoEarnings => 'এখনও কোনো আয় নেই';

  @override
  String get walletNoEarningsBody =>
      'সম্পন্ন কাজের পেমেন্ট হলে আপনার আয় এখানে দেখা যাবে।';

  @override
  String get walletAvailable => 'তোলার জন্য উপলব্ধ';

  @override
  String get walletProcessing => 'প্রক্রিয়াধীন';

  @override
  String get walletProcessingHint => 'নির্দিষ্ট সময়ের পরে ছাড়া হবে';

  @override
  String get walletTotalEarned => 'মোট আয়';

  @override
  String get statementTitle => 'স্টেটমেন্ট';

  @override
  String get statementTabTransactions => 'লেনদেন';

  @override
  String get statementTabWithdrawals => 'টাকা তোলা';

  @override
  String get statementEmpty => 'এখনও কিছু নেই';

  @override
  String get statementEmptyBody =>
      'কাজ শুরু করলে প্রতিটি পেমেন্ট, ফি ও টাকা তোলা এখানে দেখানো হবে।';

  @override
  String statementBalance(Object amount) {
    return 'ব্যালেন্স $amount';
  }

  @override
  String get statementNoWithdrawals => 'এখনও টাকা তোলা হয়নি';

  @override
  String get statementNoWithdrawalsBody =>
      'টাকা তুললে তার হিসাব এখানে রাখা হবে।';

  @override
  String payoutRequestedAt(Object date) {
    return '$date-এ অনুরোধ করা হয়েছে';
  }

  @override
  String payoutPaidAt(Object date) {
    return '$date-এ দেওয়া হয়েছে';
  }

  @override
  String get payoutEnterAmount => 'কত টাকা তুলতে চান লিখুন';

  @override
  String payoutUpTo(Object amount) {
    return 'আপনি এখন $amount পর্যন্ত তুলতে পারেন';
  }

  @override
  String payoutMinimum(Object amount) {
    return 'সর্বনিম্ন টাকা তোলা $amount';
  }

  @override
  String payoutRequested(Object amount) {
    return '$amount তোলার অনুরোধ করা হয়েছে। প্রক্রিয়া চলাকালীন আমরা আপডেট দেব।';
  }

  @override
  String get payoutAvailableNow => 'এখন উপলব্ধ';

  @override
  String payoutPendingMore(Object amount) {
    return 'আরও $amount এখনও প্রক্রিয়াধীন এবং এখনই তোলা যাবে না।';
  }

  @override
  String get payoutHowMuch => 'কত?';

  @override
  String get payoutAll => 'সব';

  @override
  String payoutPercent(Object percent) {
    return '$percent%';
  }

  @override
  String get payoutProcessNotice =>
      'টাকা তোলার অনুরোধ যাচাই করে আপনার নথিভুক্ত ব্যাংক অ্যাকাউন্টে পাঠানো হয়। প্রতিটি ধাপের অবস্থা এখানে দেখতে পাবেন।';

  @override
  String get payoutRequest => 'টাকা তোলার অনুরোধ করুন';

  @override
  String get bankChecking => 'আপনার ব্যাংক অ্যাকাউন্ট যাচাই করা হচ্ছে…';

  @override
  String bankPaidTo(Object last4) {
    return '$last4 দিয়ে শেষ হওয়া অ্যাকাউন্টে দেওয়া হবে';
  }

  @override
  String get bankVerifiedFallback => 'আপনার যাচাইকৃত ব্যাংক অ্যাকাউন্ট';

  @override
  String get bankBeingVerified => 'ব্যাংক অ্যাকাউন্ট যাচাই হচ্ছে';

  @override
  String get bankBeingVerifiedBody =>
      'আমাদের দল যাচাই করলে আপনি টাকা তুলতে পারবেন।';

  @override
  String get bankNotVerified => 'ব্যাংক অ্যাকাউন্ট যাচাই হয়নি';

  @override
  String get bankNotVerifiedBody => 'আপনার বিবরণ দেখে আবার জমা দিন।';

  @override
  String get bankAddTitle => 'ব্যাংক অ্যাকাউন্ট যোগ করুন';

  @override
  String get bankAddBody =>
      'আমাদের দলের যাচাই করা ব্যাংক অ্যাকাউন্টেই টাকা পাঠানো হয়।';

  @override
  String get bankAddAction => 'ব্যাংক অ্যাকাউন্ট যোগ করুন';

  @override
  String get verificationTitle => 'যাচাই';

  @override
  String get verificationProgress => 'যাচাইকৃত পরীক্ষা';

  @override
  String verificationCount(int approved, int total) {
    return '$totalটির মধ্যে $approvedটি';
  }

  @override
  String get verificationInsurance => 'বিমা';

  @override
  String get verificationNoCover => 'কোনো চালু বিমা নেই';

  @override
  String get verificationNoCoverBody =>
      'এই মুহূর্তে আমাদের কাছে আপনার কোনো বিমা পলিসি নথিভুক্ত নেই।';

  @override
  String get verifyIdentity => 'পরিচয়';

  @override
  String get verifyIdentityBody =>
      'একটি সরকারি পরিচয়পত্র, যাতে গ্রাহকরা জানেন কে তাঁদের বাড়িতে আসছেন।';

  @override
  String get verifyAddress => 'ঠিকানা';

  @override
  String get verifyAddressBody => 'আপনি কোথায় থাকেন তার প্রমাণ।';

  @override
  String get verifyIti => 'ITI সার্টিফিকেট';

  @override
  String get verifyItiBody =>
      'শিল্প প্রশিক্ষণ প্রতিষ্ঠান (ITI) থেকে আপনার ট্রেড সার্টিফিকেট।';

  @override
  String get verifyDiploma => 'ডিপ্লোমা';

  @override
  String get verifyDiplomaBody => 'একটি স্বীকৃত কারিগরি ডিপ্লোমা।';

  @override
  String get verifyRpl => 'দক্ষতা মূল্যায়ন';

  @override
  String get verifyRplBody =>
      'পূর্ব শিক্ষার স্বীকৃতি (RPL): আপনার অভিজ্ঞতার মূল্যায়ন ও প্রত্যয়ন।';

  @override
  String get verifyBackground => 'পটভূমি যাচাই';

  @override
  String get verifyBackgroundBody =>
      'এটি আমরা নিজেরাই করি। আপনাকে কিছু করতে হবে না।';

  @override
  String get verifyInsuranceBody =>
      'কাজের সময় দুর্ঘটনাজনিত ক্ষতির বিমা। ব্যবস্থা হলে আমাদের দল আপনার পলিসি যোগ করবে।';

  @override
  String get verifyBank => 'ব্যাংক অ্যাকাউন্ট';

  @override
  String get verifyBankBody => 'যেখানে আপনার তোলা টাকা পাঠানো হয়।';

  @override
  String verificationValidUntil(Object date) {
    return '$date পর্যন্ত বৈধ';
  }

  @override
  String get verificationStart => 'শুরু করুন';

  @override
  String get verificationUpdate => 'আপডেট করুন';

  @override
  String get policyActive => 'চালু';

  @override
  String get policyNotActive => 'চালু নয়';

  @override
  String get policyNumber => 'পলিসি';

  @override
  String get policyCover => 'বিমার পরিমাণ';

  @override
  String get policyValidUntil => 'পর্যন্ত বৈধ';

  @override
  String get kycStillWaiting =>
      'এখনও DigiLocker-এর অপেক্ষায়। পরে এখান থেকে আবার দেখতে পারেন।';

  @override
  String get kycTitle => 'পরিচয় যাচাই';

  @override
  String get kycHeadline => 'আপনি কে তা নিশ্চিত করুন';

  @override
  String get kycIntro =>
      'গ্রাহকরা আপনাকে তাঁদের বাড়িতে ঢুকতে দেন, তাই আমরা প্রত্যেক কর্মীর পরিচয় DigiLocker-এর মাধ্যমে যাচাই করি, যা ভারত সরকারের নথি প্ল্যাটফর্ম। কিছুই আপলোড হয় না — আপনি শুধু নিজের আধার অ্যাকাউন্টে অনুরোধটি অনুমোদন করবেন।';

  @override
  String get kycPrivacy =>
      'আপনার আধারের বিবরণ সরাসরি DigiLocker-এর সঙ্গে নিশ্চিত করা হয়। যাচাই হয়েছে তার প্রমাণটুকুই আমরা রাখি — আপনার ছবি বা আধারের কপি কখনও নয়।';

  @override
  String get kycVerified => 'আপনার পরিচয় যাচাই হয়েছে।';

  @override
  String get kycAwaitingConsent =>
      'ব্রাউজারে DigiLocker-এর সম্মতি সম্পূর্ণ করুন, তারপর এখানে ফিরে আসুন।';

  @override
  String get kycChecking => 'DigiLocker-এর সঙ্গে যাচাই হচ্ছে…';

  @override
  String get kycStart => 'DigiLocker দিয়ে যাচাই করুন';

  @override
  String get qualSubmitted => 'পর্যালোচনার জন্য জমা দেওয়া হয়েছে।';

  @override
  String get qualTitle => 'আপনার যোগ্যতা';

  @override
  String get qualIti => 'ITI';

  @override
  String get qualInstitute => 'প্রতিষ্ঠান';

  @override
  String get qualInstituteHint => 'যেমন সরকারি ITI, কোয়েম্বাটুর';

  @override
  String get qualName => 'যোগ্যতা';

  @override
  String get qualNameHint => 'যেমন ইলেকট্রিশিয়ান';

  @override
  String get qualSpeciality => 'বিশেষত্ব (ঐচ্ছিক)';

  @override
  String get qualSpecialityHint => 'যেমন শিল্প ওয়্যারিং';

  @override
  String get qualYear => 'সম্পূর্ণ করার বছর';

  @override
  String get qualCertificate => 'আপনার সার্টিফিকেট';

  @override
  String get qualCertificateBody => 'সার্টিফিকেটের একটি স্পষ্ট ছবি বা PDF।';

  @override
  String get bankErrorHolder => 'অ্যাকাউন্টে যেমন আছে ঠিক তেমন নাম লিখুন';

  @override
  String get bankErrorNumber => 'অ্যাকাউন্ট নম্বর ৯ থেকে ১৮ অঙ্কের হয়';

  @override
  String get bankErrorMismatch => 'অ্যাকাউন্ট নম্বর মিলছে না';

  @override
  String get bankErrorIfsc => '১১ অক্ষরের IFSC লিখুন, যেমন SBIN0001234';

  @override
  String get bankSent => 'ব্যাংক অ্যাকাউন্ট যাচাইয়ের জন্য পাঠানো হয়েছে।';

  @override
  String get bankNotice =>
      'আপনার তোলা টাকা এই অ্যাকাউন্টে পাঠানো হয়। প্রথম পেআউটের আগে আমাদের দল এটি যাচাই করে।';

  @override
  String get bankHolder => 'অ্যাকাউন্টধারীর নাম';

  @override
  String get bankNumber => 'অ্যাকাউন্ট নম্বর';

  @override
  String get bankConfirmNumber => 'অ্যাকাউন্ট নম্বর আবার লিখুন';

  @override
  String get bankIfsc => 'IFSC কোড';

  @override
  String get bankIfscHint => 'যেমন SBIN0001234';

  @override
  String get bankName => 'ব্যাংকের নাম (ঐচ্ছিক)';

  @override
  String get bankSubmit => 'যাচাইয়ের জন্য জমা দিন';

  @override
  String get profileCompleteness => 'প্রোফাইল কতটা সম্পূর্ণ';

  @override
  String get profileCompletenessBody =>
      'সম্পূর্ণ প্রোফাইল গ্রাহকদের আপনাকে বেছে নিতে সাহায্য করে।';

  @override
  String get profileJobsDone => 'সম্পন্ন কাজ';

  @override
  String get profileRating => 'রেটিং';

  @override
  String get profileExperience => 'অভিজ্ঞতা';

  @override
  String profileExperienceYears(Object years) {
    return '$years বছর';
  }

  @override
  String get profileEdit => 'প্রোফাইল সম্পাদনা করুন';

  @override
  String get profileVerified => 'যাচাইকৃত';

  @override
  String get profileNotVerified => 'যাচাই হয়নি';

  @override
  String get profilePinInvalid => 'সঠিক ৬ অঙ্কের পিন কোড লিখুন';

  @override
  String get profileUpdated => 'প্রোফাইল আপডেট হয়েছে।';

  @override
  String get profilePhotoUpdated => 'ছবি আপডেট হয়েছে।';

  @override
  String get profileChangePhoto => 'ছবি বদলান';

  @override
  String get profileName => 'নাম';

  @override
  String get profilePhone => 'ফোন';

  @override
  String get profileLockedNotice =>
      'আপনার নাম ও নম্বর পরিচয় যাচাইয়ের সঙ্গে যুক্ত। কোনোটি বদলাতে হলে সহায়তার সঙ্গে যোগাযোগ করুন।';

  @override
  String get profileAbout => 'আপনার সম্পর্কে';

  @override
  String get profileBioHint =>
      'গ্রাহকদের আপনার অভিজ্ঞতা ও দক্ষতা সম্পর্কে বলুন।';

  @override
  String get profileYearsExperience => 'অভিজ্ঞতার বছর';

  @override
  String get profileBased => 'আপনি কোথায় থাকেন';

  @override
  String get profileAddress => 'ঠিকানা';

  @override
  String get profileCity => 'শহর';

  @override
  String get profilePin => 'পিন কোড';

  @override
  String get profileGender => 'লিঙ্গ';

  @override
  String get genderMale => 'পুরুষ';

  @override
  String get genderFemale => 'মহিলা';

  @override
  String get genderOther => 'অন্যান্য';

  @override
  String get profileTrades => 'আপনার কাজ';

  @override
  String get profileTradesBody =>
      'আপনি যত কাজের জন্য অনুমোদিত, সবগুলোতেই কাজ করতে পারেন।';

  @override
  String get profileTradesLoadFailed => 'আপনার কাজগুলো লোড করা যায়নি।';

  @override
  String get tradePending => 'বাকি';

  @override
  String get profileAddTrade => 'কাজ যোগ করুন';

  @override
  String get profileAddTradeBody =>
      'অনুমোদনের আগে আমরা আপনার দক্ষতার প্রমাণ চাইতে পারি।';

  @override
  String get profileTradeRequested =>
      'অনুরোধ করা হয়েছে। অনুমোদিত হলে আমরা জানাব।';

  @override
  String get profileSave => 'পরিবর্তন সংরক্ষণ করুন';

  @override
  String get supportNewRequest => 'নতুন অনুরোধ';

  @override
  String get supportEmpty => 'এখনও কোনো অনুরোধ নেই';

  @override
  String get supportEmptyBody =>
      'কোনো কাজ, পেমেন্ট বা অ্যাকাউন্টে সমস্যা হলে অনুরোধ করুন, আমরা সাহায্য করব।';

  @override
  String get supportYourRequests => 'আপনার অনুরোধ';

  @override
  String get supportEmergency => 'জরুরি অবস্থায়';

  @override
  String get supportEmergencyBody =>
      'এই অ্যাপ আপনার হয়ে সাহায্য ডাকতে পারে না। বিপদে থাকলে সরাসরি জরুরি পরিষেবায় কল করুন।';

  @override
  String get supportCall112 => '112-এ কল করুন';

  @override
  String get supportPolice => 'পুলিশ';

  @override
  String get ticketOpen => 'খোলা';

  @override
  String get ticketInProgress => 'চলছে';

  @override
  String get ticketReplyNeeded => 'আপনার উত্তর প্রয়োজন';

  @override
  String get ticketResolved => 'সমাধান হয়েছে';

  @override
  String get ticketClosed => 'বন্ধ';

  @override
  String ticketLastUpdate(Object date) {
    return 'শেষ আপডেট $date';
  }

  @override
  String get supportCategoryJob => 'কোনো কাজ';

  @override
  String get supportCategoryPayment => 'কোনো পেমেন্ট';

  @override
  String get supportCategoryWithdrawal => 'টাকা তোলা';

  @override
  String get supportCategoryAccount => 'আমার অ্যাকাউন্ট';

  @override
  String get supportCategorySafety => 'নিরাপত্তা';

  @override
  String get supportCategoryApp => 'অ্যাপ';

  @override
  String get supportCategoryOther => 'অন্য কিছু';

  @override
  String supportRaised(Object code) {
    return 'অনুরোধ $code তৈরি হয়েছে।';
  }

  @override
  String get supportHowHelp => 'আমরা কীভাবে সাহায্য করতে পারি?';

  @override
  String get supportAbout => 'এটি কী বিষয়ে?';

  @override
  String get supportSubject => 'বিষয়';

  @override
  String get supportSubjectHint => 'সমস্যা নিয়ে কয়েকটি কথা';

  @override
  String get supportWhatHappened => 'কী হয়েছে?';

  @override
  String get supportSend => 'অনুরোধ পাঠান';

  @override
  String get ticketTitle => 'সহায়তা অনুরোধ';

  @override
  String get ticketNoMessages => 'এখনও কোনো বার্তা নেই';

  @override
  String get ticketNoMessagesBody => 'আপনার কথোপকথন এখানে দেখা যাবে।';

  @override
  String get ticketWriteMessage => 'একটি বার্তা লিখুন';

  @override
  String get ticketSupportName => 'Wervexa সহায়তা';

  @override
  String get requestsTitle => 'গ্রাহকদের অনুরোধ';

  @override
  String get requestsRefresh => 'রিফ্রেশ করুন';

  @override
  String get requestsLocationNeeded => 'লোকেশন প্রয়োজন';

  @override
  String get requestsLocationBody =>
      'আপনার কাছাকাছি গ্রাহক অনুরোধ খুঁজতে আমরা আপনার লোকেশন ব্যবহার করি।';

  @override
  String get requestsGrantLocation => 'লোকেশনের অনুমতি দিন';

  @override
  String get requestsEmpty => 'কাছাকাছি কোনো মিলে যাওয়া অনুরোধ নেই';

  @override
  String get requestsEmptyBody =>
      'আপনার পরিষেবার সঙ্গে মিললে\nনতুন গ্রাহক অনুরোধ এখানে দেখা যাবে।';

  @override
  String get requestsViewOffer => 'দেখুন ও অফার দিন →';

  @override
  String get requestEnterPrice => 'সঠিক দাম লিখুন';

  @override
  String requestOfferSubmitted(Object price) {
    return '$price-এ অফার জমা দেওয়া হয়েছে!';
  }

  @override
  String get requestDetailsTitle => 'অনুরোধের বিবরণ';

  @override
  String get requestStatusOpen => 'খোলা';

  @override
  String get requestCategory => 'বিভাগ';

  @override
  String get requestBudget => 'বাজেট';

  @override
  String get requestSchedule => 'সময়সূচি';

  @override
  String get requestDistance => 'দূরত্ব';

  @override
  String get requestArea => 'এলাকা';

  @override
  String get requestOffers => 'অফার';

  @override
  String get requestNotes => 'নোট';

  @override
  String get requestAddressPrivacy =>
      'গ্রাহক আপনার অফার গ্রহণ করলেই কেবল তাঁর সঠিক ঠিকানা শেয়ার করা হয়।';

  @override
  String get requestYourOffer => 'আপনার অফার';

  @override
  String get requestYourPrice => 'আপনার দাম (₹)';

  @override
  String get requestPriceHint => 'যেমন 500';

  @override
  String get requestDuration => 'আনুমানিক সময় (ঐচ্ছিক)';

  @override
  String get requestDurationHint => 'যেমন ১-২ ঘণ্টা';

  @override
  String get requestMessage => 'গ্রাহকের জন্য বার্তা (ঐচ্ছিক)';

  @override
  String get requestMessageHint => 'এই কাজের জন্য আপনিই কেন সঠিক ব্যক্তি?';

  @override
  String get requestSubmitOffer => 'অফার জমা দিন';

  @override
  String get requestMakeOffer => 'অফার দিন';

  @override
  String get requestAlreadyOffered =>
      'আপনি এই অনুরোধে ইতিমধ্যে অফার জমা দিয়েছেন।';

  @override
  String get requestViewOffers => 'অফার দেখুন';

  @override
  String get offersEmptyBody =>
      'গ্রাহক অনুরোধে আপনার জমা দেওয়া অফার\nএখানে দেখা যাবে।';

  @override
  String get offerWithdraw => 'টাকা তুলুন';

  @override
  String get offerWithdrawTitle => 'অফার প্রত্যাহার করবেন?';

  @override
  String get offerWithdrawBody => 'গ্রাহক আর এই অফারটি দেখতে পাবেন না।';

  @override
  String get offerWithdrawn => 'অফার প্রত্যাহার করা হয়েছে';

  @override
  String get onboardingTitle => 'আপনার প্রোফাইল সেট আপ করুন';

  @override
  String get onboardingHelp => 'সাহায্য';

  @override
  String onboardingHello(Object name) {
    return 'নমস্কার, $name';
  }

  @override
  String get onboardingIntro =>
      'আর কয়েকটি জিনিস, তারপরই কাজ পাওয়া শুরু করতে পারবেন।';

  @override
  String get onboardingSetup => 'সেটআপ';

  @override
  String onboardingStepCount(int done, int total) {
    return '$totalটির মধ্যে $doneটি';
  }

  @override
  String get onboardingBasicBody =>
      'আপনার শহর ও পিন কোড, যাতে আমরা আপনার কাছাকাছি কাজ খুঁজে পাই।';

  @override
  String get onboardingTradeBody => 'আপনি মূলত যে কাজ করেন।';

  @override
  String get onboardingSkillsDoneBody =>
      'আপনার প্রধান কাজটি একটি হিসেবে গণ্য। বাকি সব কাজ যোগ করতে এটি খুলুন।';

  @override
  String get onboardingSkillsBody =>
      'আপনি যত কাজ করেন সব যোগ করুন। আপনি একটি কাজে সীমাবদ্ধ নন।';

  @override
  String get onboardingAreaBody => 'একটি কাজের জন্য আপনি কত দূর যেতে রাজি।';

  @override
  String get onboardingKycBody =>
      'একটি সরকারি পরিচয়পত্র। গ্রাহকরা আপনাকে তাঁদের বাড়িতে ঢুকতে দিচ্ছেন।';

  @override
  String get onboardingReviewNotice =>
      'এগুলো শেষ করলে আমাদের দল আপনার নথি পরীক্ষা করবে। অপেক্ষার সময় আপনি পরিষেবা সেট আপ চালিয়ে যেতে পারেন।';

  @override
  String get onboardingTradesLoadFailed =>
      'কাজের তালিকা লোড করা যায়নি। আবার চেষ্টা করুন।';

  @override
  String get onboardingMainTrade => 'আপনার প্রধান কাজ কী?';

  @override
  String get onboardingMainTradeBody => 'পরে আরও কাজ যোগ করতে পারবেন।';

  @override
  String onboardingTradeSet(Object trade) {
    return '$trade আপনার প্রধান কাজ হিসেবে সেট হয়েছে।';
  }

  @override
  String get onboardingTravelTitle => 'আপনি কত দূর যাবেন?';

  @override
  String get onboardingTravelBody =>
      'আপনি এখন যেখানে আছেন সেখান থেকে এই দূরত্বের মধ্যেই আমরা কাজ দেব।';

  @override
  String get onboardingTravelCentre =>
      'আমরা আপনার বর্তমান অবস্থানকে কেন্দ্র হিসেবে ধরি। প্রোফাইল থেকে যেকোনো সময় বদলাতে পারেন।';

  @override
  String get onboardingLocationOff =>
      'কাজের এলাকা সেট করতে লোকেশনের অনুমতি চালু করুন।';

  @override
  String get commonSave => 'সংরক্ষণ করুন';

  @override
  String get notificationsStayOff =>
      'বিজ্ঞপ্তি বন্ধ থাকবে। ফোনের সেটিংসে গিয়ে চালু করতে পারেন।';

  @override
  String get notificationsPrimerTitle => 'কাজ এলেই খবর পান';

  @override
  String get notificationsPrimerBody =>
      'কাজের অফারের মেয়াদ থাকে। অ্যাপ বন্ধ থাকলে বিজ্ঞপ্তির মাধ্যমেই জানতে পারেন — আর কিছু পাঠানো হয় না।';

  @override
  String get notificationsTurnOn => 'বিজ্ঞপ্তি চালু করুন';

  @override
  String get commonNotNow => 'এখন না';

  @override
  String get onboardingCityRequired => 'অনুগ্রহ করে আপনার শহর লিখুন';

  @override
  String get onboardingGenderRequired => 'অনুগ্রহ করে আপনার লিঙ্গ বেছে নিন';

  @override
  String get onboardingWhereBased => 'আপনি কোথায় থাকেন?';
}
