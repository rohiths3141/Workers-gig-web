// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Marathi (`mr`).
class AppLocalizationsMr extends AppLocalizations {
  AppLocalizationsMr([String locale = 'mr']) : super(locale);

  @override
  String get languagePickerTitle => 'तुमची भाषा निवडा';

  @override
  String get startupMissingConfig => 'या बिल्डमध्ये कॉन्फिगरेशन नाही.';

  @override
  String startupPassDartDefine(Object keys) {
    return 'हे --dart-define सह द्या:\n\n$keys';
  }

  @override
  String get startupCouldNotStart => 'ॲप सुरू होऊ शकले नाही.';

  @override
  String get errorNoInternet =>
      'इंटरनेट कनेक्शन नाही. नेटवर्क तपासा आणि पुन्हा प्रयत्न करा.';

  @override
  String get errorTimeout => 'याला खूप वेळ लागला. पुन्हा प्रयत्न करा.';

  @override
  String get errorServer =>
      'आमच्याकडून काहीतरी चूक झाली. कृपया पुन्हा प्रयत्न करा.';

  @override
  String get errorClockSkew =>
      'तुमच्या फोनची तारीख आणि वेळ जुळत नाही असे दिसते. सेटिंग्जमध्ये स्वयंचलित तारीख व वेळ सुरू करा आणि पुन्हा प्रयत्न करा.';

  @override
  String get errorUnexpected => 'काहीतरी चूक झाली. कृपया पुन्हा प्रयत्न करा.';

  @override
  String get eligibilityStepIncomplete => 'ही पायरी अद्याप पूर्ण झालेली नाही.';

  @override
  String get errorSessionEnded =>
      'तुमचे सत्र संपले आहे. कृपया पुन्हा साइन इन करा.';

  @override
  String get errorUploadFailed =>
      'ती फाइल अपलोड होऊ शकली नाही. पुन्हा प्रयत्न करा.';

  @override
  String get errorServiceUnavailable =>
      'ती सेवा सध्या उपलब्ध नाही. थोड्या वेळाने पुन्हा प्रयत्न करा.';

  @override
  String get errorSignInNotReady =>
      'तुमचे साइन-इन अद्याप पूर्ण तयार नाही. थोड्या वेळाने पुन्हा प्रयत्न करा.';

  @override
  String get errorNoLongerAvailable => 'ते आता उपलब्ध नाही.';

  @override
  String get errorNotAllowedToSee => 'तुम्ही ते पाहू शकत नाही.';

  @override
  String get errorDidNotWork => 'ते काम झाले नाही. कृपया पुन्हा प्रयत्न करा.';

  @override
  String get authErrorInvalidPhone => 'तो फोन नंबर बरोबर वाटत नाही.';

  @override
  String get authErrorWrongCode =>
      'तो कोड बरोबर नाही. तपासा आणि पुन्हा प्रयत्न करा.';

  @override
  String get authErrorCodeExpired =>
      'त्या कोडची मुदत संपली आहे. नवीन कोड मागवा.';

  @override
  String get authErrorTooManyAttempts =>
      'खूप जास्त प्रयत्न झाले. पुन्हा प्रयत्न करण्यापूर्वी काही मिनिटे थांबा.';

  @override
  String get authErrorQuota =>
      'आम्ही आत्ता कोड पाठवू शकत नाही. थोड्या वेळाने पुन्हा प्रयत्न करा.';

  @override
  String get authErrorDisabled =>
      'हे खाते बंद केले आहे. सहाय्याशी संपर्क साधा.';

  @override
  String get authErrorPhoneNotEnabledRegion =>
      'फोनद्वारे साइन-इन सुरू नाही, किंवा या प्रदेशात SMS अडवले आहेत. Firebase Console सेटिंग्ज तपासा.';

  @override
  String get authErrorNumberInUse =>
      'हा नंबर आधीच दुसऱ्या खात्याशी जोडलेला आहे.';

  @override
  String get authErrorSignInAgain =>
      'पुढे जाण्यासाठी कृपया पुन्हा साइन इन करा.';

  @override
  String get authErrorSignInFailed =>
      'साइन-इन अयशस्वी झाले. कृपया पुन्हा प्रयत्न करा.';

  @override
  String get budgetTypeFlexible => 'लवचिक';

  @override
  String get budgetTypeFixed => 'ठरलेली किंमत';

  @override
  String get budgetTypeRange => 'किंमत श्रेणी';

  @override
  String get scheduleAsap => 'शक्य तितक्या लवकर';

  @override
  String get scheduleToday => 'आज';

  @override
  String get scheduleTomorrow => 'उद्या';

  @override
  String get scheduleSpecificDate => 'ठरावीक तारीख';

  @override
  String get offerStatusSubmitted => 'पाठवली';

  @override
  String get offerStatusViewed => 'ग्राहकाने पाहिली';

  @override
  String get offerStatusShortlisted => 'निवड यादीत';

  @override
  String get offerStatusAccepted => 'स्वीकारली ✓';

  @override
  String get offerStatusRejected => 'निवडलेले नाही';

  @override
  String get offerStatusWithdrawn => 'मागे घेतली';

  @override
  String get offerStatusExpired => 'मुदत संपली';

  @override
  String get offerStatusClosed => 'बंद';

  @override
  String distanceMetresAway(Object metres) {
    return '$metres मी दूर';
  }

  @override
  String distanceKmAway(Object km) {
    return '$km किमी दूर';
  }

  @override
  String offerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ऑफर',
      one: '1 ऑफर',
      zero: 'अद्याप ऑफर नाहीत',
    );
    return '$_temp0';
  }

  @override
  String get gigErrorTrade => 'ही सेवा कोणत्या कामाची आहे ते निवडा';

  @override
  String get gigErrorTitleShort =>
      'या सेवेला किमान 6 अक्षरांचे स्पष्ट नाव द्या';

  @override
  String get gigErrorTitleLong => 'नाव 120 अक्षरांपेक्षा कमी ठेवा';

  @override
  String get gigErrorPrice => 'या सेवेसाठी तुम्ही किती घेता ते टाका';

  @override
  String get gigErrorDurationMissing => 'याला सहसा किती वेळ लागतो?';

  @override
  String get gigErrorDurationShort =>
      'आम्ही यादीत टाकू शकतो ते सर्वात लहान काम 15 मिनिटांचे आहे';

  @override
  String get gigErrorDurationLong =>
      'आम्ही यादीत टाकू शकतो ते सर्वात मोठे काम 14 दिवसांचे आहे';

  @override
  String get gigErrorRadius => 'प्रवासाचे अंतर 1 ते 100 किमी दरम्यान असावे';

  @override
  String get jobAreaNearby => 'जवळपास';

  @override
  String get jobBlockerVerifyArrival => 'ग्राहकाच्या कोडने आगमनाची पडताळणी करा';

  @override
  String get jobBlockerAfterPhoto => 'पूर्ण झालेल्या कामाचा फोटो जोडा';

  @override
  String jobBlockerMaterialsPending(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'साहित्याच्या $count विनंत्या अजून ग्राहकाच्या प्रतिसादाची वाट पाहत आहेत',
      one: 'साहित्याची 1 विनंती अजून ग्राहकाच्या प्रतिसादाची वाट पाहत आहे',
    );
    return '$_temp0';
  }

  @override
  String mediaTypeNotAccepted(Object kinds) {
    return 'येथे हा फाइल प्रकार स्वीकारला जात नाही. $kinds वापरा.';
  }

  @override
  String get mediaEmpty => 'ती फाइल रिकामी आहे.';

  @override
  String mediaTooLarge(Object megabytes) {
    return 'ती फाइल खूप मोठी आहे. मर्यादा ${megabytes}MB आहे.';
  }

  @override
  String get verificationNotStarted => 'सुरू झाले नाही';

  @override
  String get verificationSubmitted => 'पाठवली';

  @override
  String get verificationUnderReview => 'पुनरावलोकन सुरू आहे';

  @override
  String get verificationMoreInfo => 'अधिक माहिती हवी';

  @override
  String get verificationExpired => 'मुदत संपली';

  @override
  String get verificationVerified => 'पडताळलेले';

  @override
  String get verificationNotApproved => 'मंजूर नाही';

  @override
  String get verificationNotRequired => 'आवश्यक नाही';

  @override
  String get qualificationErrorInstitution => 'हे कोणत्या संस्थेने दिले?';

  @override
  String get qualificationErrorName => 'या पात्रतेचे नाव काय आहे?';

  @override
  String get qualificationErrorYearMissing =>
      'तुम्ही हे कोणत्या वर्षी पूर्ण केले?';

  @override
  String qualificationErrorYearRange(Object year) {
    return '1950 ते $year दरम्यानचे वर्ष टाका';
  }

  @override
  String get walletTxJobEarning => 'कामाची कमाई';

  @override
  String get walletTxMaterialReimbursed => 'साहित्याची भरपाई';

  @override
  String get walletTxAdjustment => 'समायोजन';

  @override
  String get walletTxPayoutReturned => 'पेआउट परत आले';

  @override
  String get walletTxPlatformFee => 'प्लॅटफॉर्म शुल्क';

  @override
  String get walletTxWithdrawn => 'मागे घेतली';

  @override
  String get walletTxClaimRecovery => 'दाव्याची वसुली';

  @override
  String get payoutStatusRequested => 'विनंती केली';

  @override
  String get payoutStatusProcessing => 'प्रक्रिया सुरू';

  @override
  String get payoutStatusPaid => 'पेमेंट झाले';

  @override
  String get payoutStatusFailed => 'अयशस्वी';

  @override
  String get authPhoneTenDigits => '10 अंकी मोबाइल नंबर टाका.';

  @override
  String get authCodeSendTimeout =>
      'आम्ही कोड पाठवू शकलो नाही. नेटवर्क तपासा आणि पुन्हा प्रयत्न करा.';

  @override
  String get authEnterReceivedCode => 'तुम्हाला मिळालेला कोड टाका.';

  @override
  String get authSignInIncomplete =>
      'साइन-इन पूर्ण झाले नाही. कृपया पुन्हा प्रयत्न करा.';

  @override
  String get authSignInToContinue => 'पुढे जाण्यासाठी कृपया साइन इन करा.';

  @override
  String get accountDeletionBySupport =>
      'खाते हटवण्याचे काम आमची सहाय्य टीम करते. विनंती करा, पूर्ण झाल्यावर आम्ही पुष्टी करू.';

  @override
  String get photoUploadFailed => 'तो फोटो अपलोड होऊ शकला नाही.';

  @override
  String get photoUploadFailedRetry =>
      'तो फोटो अपलोड होऊ शकला नाही. पुन्हा प्रयत्न करा.';

  @override
  String get locationInvalid => 'ते स्थान बरोबर वाटत नाही.';

  @override
  String get travelDistanceRange =>
      '1 ते 100 किमी दरम्यान प्रवासाचे अंतर निवडा.';

  @override
  String get profileLoadFailed => 'तुमचे प्रोफाइल लोड होऊ शकले नाही.';

  @override
  String get uploadIncomplete => 'अपलोड पूर्ण झाले नाही. पुन्हा प्रयत्न करा.';

  @override
  String get uploadTooLarge => 'ती फाइल खूप मोठी आहे.';

  @override
  String get uploadTypeNotAccepted => 'हा फाइल प्रकार स्वीकारला जात नाही.';

  @override
  String get uploadRefused => 'ती फाइल नाकारली गेली.';

  @override
  String get uploadTooMany =>
      'एकाच वेळी खूप अपलोड. थोडे थांबा आणि पुन्हा प्रयत्न करा.';

  @override
  String get uploadGone => 'ते अपलोड आता उपलब्ध नाही. फाइल पुन्हा निवडा.';

  @override
  String get uploadDidNotStart => 'अपलोड सुरू झाले नाही.';

  @override
  String get uploadDidNotFinish => 'ते अपलोड पूर्ण झाले नाही.';

  @override
  String get claimResponseTooShort =>
      'कृपया काय झाले ते थोडे अधिक तपशीलात सांगा.';

  @override
  String get walletLoadFailedRetry =>
      'तुमचे वॉलेट लोड होऊ शकले नाही. कृपया पुन्हा प्रयत्न करा.';

  @override
  String get walletLoadFailed => 'तुमचे वॉलेट लोड होऊ शकले नाही.';

  @override
  String get onboardingStepDetails => 'तुमचा तपशील';

  @override
  String get onboardingStepTrade => 'तुमचे मुख्य काम';

  @override
  String get onboardingStepSkills => 'तुम्ही काय करू शकता';

  @override
  String get onboardingStepArea => 'तुम्ही कुठे काम करता';

  @override
  String get onboardingStepKyc => 'ओळख पडताळणी';

  @override
  String get onboardingStepReady => 'कामासाठी तयार';

  @override
  String routerScreenNotFound(Object location) {
    return 'ती स्क्रीन उघडू शकली नाही.\n$location';
  }

  @override
  String get cameraOpenFailed =>
      'कॅमेरा उघडू शकला नाही. ॲपच्या परवानग्या तपासा.';

  @override
  String get commonTryAgain => 'पुन्हा प्रयत्न करा';

  @override
  String get commonCancel => 'रद्द करा';

  @override
  String get commonConfirm => 'पुष्टी करा';

  @override
  String get offlineBanner =>
      'तुम्ही ऑफलाइन आहात. पुन्हा कनेक्ट झाल्यावर कामाच्या कृती पुन्हा चालतील.';

  @override
  String get badgeNew => 'नवीन';

  @override
  String get badgeAccepted => 'स्वीकारले';

  @override
  String get badgeConfirmed => 'पुष्टी झाली';

  @override
  String get badgeOnTheWay => 'वाटेत';

  @override
  String get badgeArrived => 'पोहोचले';

  @override
  String get badgeWorking => 'काम सुरू';

  @override
  String get badgeAwaitingCustomer => 'ग्राहकाची वाट';

  @override
  String get badgeDone => 'पूर्ण';

  @override
  String get badgePaymentDue => 'पेमेंट बाकी';

  @override
  String get badgePaid => 'पेमेंट झाले';

  @override
  String get badgeClosed => 'बंद';

  @override
  String get badgeCancelled => 'रद्द';

  @override
  String get badgeDisputed => 'वादग्रस्त';

  @override
  String get badgeExpired => 'मुदत संपली';

  @override
  String get badgeDraft => 'मसुदा';

  @override
  String get badgeInReview => 'पुनरावलोकनात';

  @override
  String get badgeLive => 'लाइव्ह';

  @override
  String get badgePaused => 'थांबवले';

  @override
  String get badgeNotApproved => 'मंजूर नाही';

  @override
  String get badgeRemoved => 'काढले';

  @override
  String get badgeNotStarted => 'सुरू झाले नाही';

  @override
  String get badgeSubmitted => 'पाठवली';

  @override
  String get badgeActionNeeded => 'कृती आवश्यक';

  @override
  String get badgeVerified => 'पडताळलेले';

  @override
  String get badgeNotRequired => 'आवश्यक नाही';

  @override
  String get commonContinue => 'पुढे जा';

  @override
  String get commonSaving => 'जतन करत आहे…';

  @override
  String get welcomePromiseWorkTitle => 'योग्य काम मिळवा';

  @override
  String get welcomePromiseWorkBody =>
      'तुमच्या जवळची कामे, तुम्ही प्रत्यक्ष करता त्या कामांशी जुळणारी.';

  @override
  String get welcomePromiseSkillsTitle => 'तुमचे कौशल्य सिद्ध करा';

  @override
  String get welcomePromiseSkillsBody =>
      'तुमची ITI आणि डिप्लोमा प्रमाणपत्रे, एकदा पडताळून प्रत्येक ग्राहकाला दाखवली जातात.';

  @override
  String get welcomePromiseTrackTitle => 'प्रत्येक कामाचा मागोवा घ्या';

  @override
  String get welcomePromiseTrackBody =>
      'काम स्वीकारण्यापासून पूर्ण करण्यापर्यंत, प्रत्येक टप्प्यावर फोटो नोंदीसह.';

  @override
  String get welcomePromisePaidTitle => 'सुरक्षित पेमेंट मिळवा';

  @override
  String get welcomePromisePaidBody =>
      'प्रत्येक रुपयाची नोंद, स्पष्ट स्टेटमेंटसह आणि तुमच्या अटींवर पैसे काढणे.';

  @override
  String get welcomeHeadline => 'काम जे तुम्हाला शोधते';

  @override
  String get welcomeSubtitle =>
      'Wervexa कुशल व्यावसायिकांना त्यांची गरज असलेल्या ग्राहकांशी जोडते.';

  @override
  String get welcomeGetStarted => 'सुरू करा';

  @override
  String get welcomeCodeNotice =>
      'आम्ही तुमच्या मोबाइल नंबरवर एक वेळचा कोड पाठवू.';

  @override
  String get phoneTitle => 'तुमचा मोबाइल नंबर काय आहे?';

  @override
  String get phoneSubtitle =>
      'हे तुम्हीच आहात याची पुष्टी करण्यासाठी आम्ही एक वेळचा कोड पाठवू.';

  @override
  String get phoneSendCode => 'कोड पाठवा';

  @override
  String get phoneSending => 'पाठवत आहे…';

  @override
  String get authNewCodeSent => 'आम्ही नवीन कोड पाठवला आहे.';

  @override
  String get otpTitle => 'कोड टाका';

  @override
  String otpSentTo(Object phone) {
    return 'आम्ही $phone वर 6 अंकी कोड पाठवला आहे.';
  }

  @override
  String otpResendIn(int seconds) {
    String _temp0 = intl.Intl.pluralLogic(
      seconds,
      locale: localeName,
      other: 'तुम्ही $seconds सेकंदांत नवीन कोड मागवू शकता',
      one: 'तुम्ही 1 सेकंदात नवीन कोड मागवू शकता',
    );
    return '$_temp0';
  }

  @override
  String get otpSendNew => 'नवीन कोड पाठवा';

  @override
  String get otpVerify => 'पडताळा';

  @override
  String get otpVerifying => 'पडताळत आहे…';

  @override
  String get registerNameRequired => 'कृपया तुमचे पूर्ण नाव टाका';

  @override
  String get registerEmailInvalid => 'कृपया वैध ईमेल पत्ता टाका';

  @override
  String get registerTitle => 'आम्ही तुम्हाला काय म्हणावे?';

  @override
  String get registerSubtitle => 'ग्राहकांना हेच नाव दिसेल.';

  @override
  String get registerNameLabel => 'पूर्ण नाव';

  @override
  String get registerNameHint => 'अरुण कुमार';

  @override
  String get registerEmailLabel => 'ईमेल (ऐच्छिक)';

  @override
  String get registerEmailHelper => 'पावत्या आणि स्टेटमेंटसाठी.';

  @override
  String registerVerifiedPhone(Object phone) {
    return 'पडताळलेला: $phone';
  }

  @override
  String get navHome => 'होम';

  @override
  String get navJobs => 'कामे';

  @override
  String get navWallet => 'वॉलेट';

  @override
  String get navProfile => 'प्रोफाइल';

  @override
  String get sessionProfileLoadFailedRetry =>
      'आम्ही तुमचे प्रोफाइल लोड करू शकलो नाही. कृपया पुन्हा प्रयत्न करा.';

  @override
  String get commonSignOut => 'साइन आउट करा';

  @override
  String get serviceElectrical => 'इलेक्ट्रिकल';

  @override
  String get servicePlumbing => 'प्लंबिंग';

  @override
  String get serviceAcService => 'AC सर्व्हिस';

  @override
  String get serviceApplianceRepair => 'उपकरण दुरुस्ती';

  @override
  String get serviceCarpentry => 'सुतारकाम';

  @override
  String get servicePainting => 'रंगकाम';

  @override
  String get serviceCleaning => 'स्वच्छता';

  @override
  String get servicePestControl => 'कीटक नियंत्रण';

  @override
  String get serviceOtherHome => 'इतर घरगुती सेवा';

  @override
  String get commonSeeAll => 'सर्व पहा';

  @override
  String distanceKm(Object km) {
    return '$km किमी';
  }

  @override
  String get homeRightNow => 'आत्ता';

  @override
  String get homeNewWork => 'नवीन काम';

  @override
  String homeJobsWaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count कामे तुमच्या उत्तराची वाट पाहत आहेत',
      one: '1 काम तुमच्या उत्तराची वाट पाहत आहे',
    );
    return '$_temp0';
  }

  @override
  String get homeComingUp => 'पुढील';

  @override
  String get homeEarnings => 'कमाई';

  @override
  String get homeMyServices => 'माझ्या सेवा';

  @override
  String get homeVerification => 'पडताळणी';

  @override
  String get homeSupport => 'सहाय्य';

  @override
  String get homeRequests => 'विनंत्या';

  @override
  String get homeMyOffers => 'माझ्या ऑफर';

  @override
  String get homeAddService => 'सेवा जोडा';

  @override
  String get homeAddServiceBody =>
      'तुम्ही प्रकाशित केलेल्या सेवांसाठीच ग्राहक तुम्हाला बुक करू शकतात.';

  @override
  String get homeNotReady => 'अजून पूर्ण तयार नाही';

  @override
  String get homeNotReadyBody =>
      'या पायऱ्या पूर्ण करा आणि तुम्हाला कामे मिळू लागतील.';

  @override
  String get homeGoodMorning => 'सुप्रभात';

  @override
  String get homeGoodAfternoon => 'शुभ दुपार';

  @override
  String get homeGoodEvening => 'शुभ संध्याकाळ';

  @override
  String get homeNotifications => 'सूचना';

  @override
  String get availabilityAvailable => 'उपलब्ध';

  @override
  String get availabilityAvailableBody => 'तुम्हाला नवीन कामे मिळू शकतात.';

  @override
  String get availabilityOnJob => 'कामावर';

  @override
  String get availabilityOnJobBody =>
      'हे काम पूर्ण होईपर्यंत तुम्हाला नवीन काम दिले जाणार नाही.';

  @override
  String get availabilityOff => 'बंद';

  @override
  String get availabilityOffBody => 'तुम्हाला नवीन कामे मिळणार नाहीत.';

  @override
  String get availabilityFinishJob =>
      'पुन्हा उपलब्ध होण्यासाठी सध्याचे काम पूर्ण करा.';

  @override
  String get availabilityGoOff => 'ड्यूटी बंद करा';

  @override
  String get availabilityGoOn => 'उपलब्ध व्हा';

  @override
  String get availabilityBeforeJobs => 'कामे मिळण्यापूर्वी';

  @override
  String get availabilityNowOn => 'तुम्ही कामासाठी उपलब्ध आहात.';

  @override
  String get availabilityNowOff => 'तुम्ही ड्यूटीवर नाही.';

  @override
  String get workerStatusSetupIncomplete => 'सेटअप अपूर्ण';

  @override
  String get workerStatusUnderReview => 'पुनरावलोकनात';

  @override
  String get workerStatusInactive => 'निष्क्रिय';

  @override
  String get workerStatusRestricted => 'प्रतिबंधित';

  @override
  String get workerStatusSuspended => 'निलंबित';

  @override
  String get homeAccount => 'खाते';

  @override
  String get homeWorkStatus => 'कामाची स्थिती';

  @override
  String get availabilityOffDuty => 'ड्यूटीवर नाही';

  @override
  String get earningsThisWeek => 'या आठवड्यात';

  @override
  String get earningsThisMonth => 'या महिन्यात';

  @override
  String get jobNextWaitConfirm => 'ग्राहकाच्या पुष्टीची वाट';

  @override
  String get jobNextStartTravel => 'प्रवास सुरू करा';

  @override
  String get jobNextMarkArrived => 'पोहोचल्याचे नोंदवा';

  @override
  String get jobNextStartWork => 'काम सुरू करा';

  @override
  String get jobNextAskCode => 'ग्राहकाकडे आगमन कोड मागा';

  @override
  String get jobNextFinish => 'पूर्ण करा आणि फोटो जोडा';

  @override
  String get jobNextWaitApprove => 'ग्राहकाच्या मंजुरीची वाट';

  @override
  String get jobNextOpen => 'काम उघडा';

  @override
  String get jobTimeTbc => 'वेळ निश्चित व्हायची आहे';

  @override
  String get settingsTitle => 'सेटिंग्ज';

  @override
  String get settingsLanguage => 'भाषा';

  @override
  String get settingsAbout => 'माहिती';

  @override
  String get settingsTerms => 'सेवा अटी';

  @override
  String get settingsPrivacy => 'गोपनीयता धोरण';

  @override
  String get settingsHelp => 'मदत आणि सहाय्य';

  @override
  String get settingsDeleteAccount => 'माझे खाते हटवा';

  @override
  String get settingsSignOutTitle => 'साइन आउट करायचे?';

  @override
  String get settingsSignOutBody =>
      'पुन्हा साइन इन करण्यासाठी तुमचा फोन नंबर आणि कोड लागेल.';

  @override
  String get settingsDeleteTitle => 'तुमचे खाते हटवा';

  @override
  String get settingsDeleteBody =>
      'खाते हटवल्याने तुमचा कामाचा इतिहास, कमाईच्या नोंदी आणि कोणतेही खुले पेमेंट प्रभावित होते, म्हणून हे आपोआप न होता आमची सहाय्य टीम करते.\n\nसहाय्य विनंती करा, पूर्ण झाल्यावर आम्ही पुष्टी करू.';

  @override
  String get settingsContactSupport => 'सहाय्याशी संपर्क साधा';

  @override
  String get notificationsMarkAllRead => 'सर्व वाचले म्हणून चिन्हांकित करा';

  @override
  String get notificationsEmpty => 'तुम्ही सर्व पाहिले आहे';

  @override
  String get notificationsEmptyBody =>
      'कामाच्या ऑफर, पेमेंट अपडेट आणि पडताळणीचे निकाल येथे दिसतील.';

  @override
  String get jobsTabUpcoming => 'पुढील';

  @override
  String get jobsTabActive => 'सुरू';

  @override
  String get jobsNoOffers => 'सध्या नवीन कामे नाहीत';

  @override
  String get jobsNoOffersBody =>
      'तुम्ही उपलब्ध असताना योग्य काम आले की लगेच आम्ही कळवू.';

  @override
  String get jobsAccepted => 'काम स्वीकारले.';

  @override
  String get jobsDeclineTitle => 'हे काम नाकारायचे?';

  @override
  String get jobsDeclineBody =>
      'ते दुसऱ्या कर्मचाऱ्याला दिले जाईल. वारंवार नाकारल्यास तुम्हाला दिसणारी कामे कमी होऊ शकतात.';

  @override
  String get jobsDecline => 'नाकारा';

  @override
  String get jobsDeclined => 'काम नाकारले.';

  @override
  String get jobsEmptyUpcoming => 'काहीही नियोजित नाही';

  @override
  String get jobsEmptyUpcomingBody => 'तुम्ही स्वीकारलेली कामे येथे दिसतील.';

  @override
  String get jobsEmptyActive => 'कोणतेही काम सुरू नाही';

  @override
  String get jobsEmptyActiveBody => 'तुम्ही काम सुरू केल्यावर ते येथे दिसेल.';

  @override
  String get jobsEmptyCompleted => 'अद्याप पूर्ण झालेली कामे नाहीत';

  @override
  String get jobsEmptyCompletedBody =>
      'पूर्ण झालेली कामे आणि त्यातून तुमची कमाई येथे दिसेल.';

  @override
  String get jobsEmptyCancelled => 'काहीही रद्द नाही';

  @override
  String get jobsEmptyCancelledBody => 'रद्द झालेली कामे येथे दिसतील.';

  @override
  String get jobsEmptyOffers => 'ऑफर नाहीत';

  @override
  String get jobsEmptyOffersBody => 'नवीन कामे येथे दिसतील.';

  @override
  String get jobTitleFallback => 'काम';

  @override
  String jobCancelledReason(Object reason) {
    return 'रद्द: $reason';
  }

  @override
  String get jobAmount => 'कामाची रक्कम';

  @override
  String get jobMaterials => 'साहित्य';

  @override
  String get jobYouEarned => 'तुमची कमाई';

  @override
  String get jobRateCustomer => 'ग्राहकाला रेटिंग द्या';

  @override
  String get jobRateQuestion => 'हे काम तुमच्यासाठी कसे होते?';

  @override
  String get jobRate => 'रेटिंग द्या';

  @override
  String get jobHistory => 'काय काय झाले';

  @override
  String get jobHistoryLoadFailed => 'कामाचा इतिहास लोड होऊ शकला नाही.';

  @override
  String get jobOfferExpired => 'हे काम आता उपलब्ध नाही.';

  @override
  String get jobOfferNewBadge => 'नवीन काम';

  @override
  String get jobOfferYouEarn => 'तुमची कमाई';

  @override
  String get jobOfferPriceAfterVisit => 'भेटीनंतर निश्चित';

  @override
  String get jobOfferAccept => 'काम स्वीकारा';

  @override
  String get activeJobTitle => 'सध्याचे काम';

  @override
  String get activeJobEmptyBody =>
      'तुम्ही काम स्वीकारून सुरू केल्यावर ते येथे दिसेल.';

  @override
  String get evidenceBeforeTitle => 'सुरू करण्यापूर्वी';

  @override
  String get evidenceBeforeBody =>
      'हात लावण्यापूर्वी समस्येचा फोटो काढा. ग्राहकाने नंतर कामावर वाद घातल्यास हे तुमचे संरक्षण करते.';

  @override
  String get evidenceAfterTitle => 'पूर्ण केल्यानंतर';

  @override
  String get evidenceAfterBody =>
      'ग्राहकाने नंतर वाद घातल्यास पूर्ण कामाचा फोटो हाच तुमचा पुरावा आहे. ऐच्छिक, पण दहा सेकंद देण्यासारखे.';

  @override
  String get jobCustomerHidden =>
      'पुष्टी झाल्यावर ग्राहकाचा तपशील शेअर केला जाईल';

  @override
  String get jobCall => 'कॉल करा';

  @override
  String get jobDirections => 'दिशा';

  @override
  String get jobTrackOnMap => 'नकाशावर पहा';

  @override
  String get trailAccepted => 'स्वीकारले';

  @override
  String get trailOnTheWay => 'वाटेत';

  @override
  String get trailArrived => 'पोहोचले';

  @override
  String get trailArrivalConfirmed => 'आगमनाची पुष्टी झाली';

  @override
  String get trailWorkStarted => 'काम सुरू झाले';

  @override
  String get trailFinished => 'पूर्ण झाले';

  @override
  String get jobProgress => 'प्रगती';

  @override
  String get jobBeforeFinish => 'पूर्ण करण्यापूर्वी';

  @override
  String get jobActionStartTravel => 'प्रवास सुरू करा';

  @override
  String get jobActionArrived => 'मी पोहोचलो आहे';

  @override
  String get jobActionEnterCode => 'आगमन कोड टाका';

  @override
  String get jobActionStartWork => 'काम सुरू करा';

  @override
  String get jobActionFinish => 'काम पूर्ण करा';

  @override
  String get jobArrivalConfirmed => 'आगमनाची पुष्टी झाली.';

  @override
  String get jobFinishTitle => 'हे काम पूर्ण करायचे?';

  @override
  String get jobFinishBody =>
      'ग्राहकाला कामाला मंजुरी देण्यास सांगितले जाईल. त्यानंतर तुम्हाला फोटो जोडता येणार नाहीत.';

  @override
  String get jobOnYourWay => 'तुम्ही वाटेत आहात.';

  @override
  String get jobMarkedArrived => 'पोहोचल्याची नोंद झाली.';

  @override
  String get jobWorkStarted => 'काम सुरू झाले.';

  @override
  String get jobSentForApproval => 'मंजुरीसाठी ग्राहकाला पाठवले.';

  @override
  String get jobUpdated => 'अपडेट झाले.';

  @override
  String get jobWaitConfirm => 'ग्राहक बुकिंगची पुष्टी करण्याची वाट.';

  @override
  String get jobWaitApprove => 'ग्राहक तुमच्या कामाला मंजुरी देण्याची वाट.';

  @override
  String get jobWaitPaymentProcessing => 'मंजूर. पेमेंटची प्रक्रिया सुरू आहे.';

  @override
  String get jobWaitPayment => 'ग्राहकाच्या पेमेंटची वाट.';

  @override
  String get jobWaitPaid => 'पेमेंट झाले. तुमची कमाई वॉलेटमध्ये दिसेल.';

  @override
  String get jobWaitDisputed =>
      'आमची टीम या कामाचे पुनरावलोकन करत आहे. आम्ही संपर्क करू.';

  @override
  String get jobWaitNothing => 'सध्या काही करायचे नाही.';

  @override
  String get travelRouteUnavailable => 'मार्ग उपलब्ध नाही';

  @override
  String get travelNoDestination => 'गंतव्य सेट नाही';

  @override
  String get travelNoDestinationBody =>
      'या कामाला मार्ग दाखवण्यासाठी सेवेचे ठिकाण नाही.';

  @override
  String get travelJobLocation => 'कामाचे ठिकाण';

  @override
  String get travelYou => 'तुम्ही';

  @override
  String get travelCustomer => 'ग्राहक';

  @override
  String get travelCalculating => 'मार्ग मोजत आहे...';

  @override
  String distanceMetres(Object metres) {
    return '$metres मी';
  }

  @override
  String etaMinutes(Object minutes) {
    return '$minutes मिनिटे';
  }

  @override
  String etaHours(Object hours) {
    return '$hours तास';
  }

  @override
  String get arrivalWrongCode => 'तो कोड बरोबर नाही.';

  @override
  String arrivalWrongCodeAttempts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'तो कोड बरोबर नाही. $count प्रयत्न बाकी.',
      one: 'तो कोड बरोबर नाही. 1 प्रयत्न बाकी.',
    );
    return '$_temp0';
  }

  @override
  String get arrivalTitle => 'तुम्ही पोहोचल्याची पुष्टी करा';

  @override
  String get arrivalBody =>
      'ग्राहकाला त्यांच्या ॲपमधील कोड वाचून दाखवायला सांगा, मग तो येथे टाइप करा.';

  @override
  String get arrivalLocked =>
      'खूप वेळा चुकीचे कोड. हे काम सुरू ठेवण्यासाठी कृपया सहाय्याशी संपर्क साधा.';

  @override
  String get arrivalConfirm => 'आगमनाची पुष्टी करा';

  @override
  String get arrivalNotYet => 'अजून नाही';

  @override
  String get rateThanks => 'अभिप्रायाबद्दल धन्यवाद.';

  @override
  String get rateTitle => 'हा ग्राहक कसा होता?';

  @override
  String get rateBody =>
      'तुमचे रेटिंग खाजगी आहे आणि कर्मचाऱ्यांची काळजी घेण्यास आम्हाला मदत करते.';

  @override
  String get rateCommentLabel => 'आणखी काही सांगायचे? (ऐच्छिक)';

  @override
  String get rateSubmit => 'रेटिंग पाठवा';

  @override
  String get timerServiceTime => 'सेवेचा वेळ';

  @override
  String get materialsAdd => 'जोडा';

  @override
  String get materialsLoadFailed => 'साहित्य लोड होऊ शकले नाही.';

  @override
  String get materialsEmpty =>
      'या कामासाठी सुटे भाग लागल्यास ते येथे जोडा, आणि ग्राहकाला खर्च मंजूर करण्यास सांगितले जाईल.';

  @override
  String get materialStatusWaiting => 'ग्राहकाची वाट';

  @override
  String get materialStatusApproved => 'मंजूर';

  @override
  String get materialStatusDeclined => 'नाकारले';

  @override
  String get materialStatusBought => 'खरेदी केले';

  @override
  String get materialStatusCostRecorded => 'खर्च नोंदवला';

  @override
  String get materialStatusBilled => 'बिलात';

  @override
  String get materialStatusCancelled => 'रद्द';

  @override
  String materialQuantityEstimated(Object quantity, Object unit) {
    return '$quantity $unit · अंदाजे';
  }

  @override
  String materialQuantityActual(Object quantity, Object unit) {
    return '$quantity $unit · प्रत्यक्ष';
  }

  @override
  String get materialRecordCost => 'खर्च नोंदवा';

  @override
  String materialCustomerSaid(Object reason) {
    return 'ग्राहक म्हणाले: $reason';
  }

  @override
  String get materialUnitPiece => 'नग';

  @override
  String get materialWhatNeeded => 'तुम्हाला काय हवे आहे?';

  @override
  String get materialEnterQuantity => 'किती हवे ते टाका';

  @override
  String get materialEnterCost => 'अंदाजे खर्च टाका';

  @override
  String get materialRequestBody =>
      'खरेदी करण्यापूर्वी ग्राहकाला हे मंजूर करण्यास सांगितले जाईल.';

  @override
  String get materialName => 'साहित्य';

  @override
  String get materialNameHint => 'उदा. 16A मॉड्यूलर स्विच';

  @override
  String get materialQuantity => 'प्रमाण';

  @override
  String get materialUnit => 'एकक';

  @override
  String get materialExpectedCost => 'अंदाजे खर्च';

  @override
  String get materialAskCustomer => 'ग्राहकाला विचारा';

  @override
  String get materialEnterPaid => 'तुम्ही भरलेली रक्कम टाका';

  @override
  String get materialCostRecorded => 'खर्च नोंदवला.';

  @override
  String get materialWhatCost => 'याचा खर्च किती झाला?';

  @override
  String get materialReceiptBody =>
      'पावती जोडा जेणेकरून हे ग्राहकाच्या बिलात जोडता येईल.';

  @override
  String get materialAmountPaid => 'भरलेली रक्कम';

  @override
  String get materialReceipt => 'पावती';

  @override
  String get materialReceiptRequired => 'बिलाचा फोटो आवश्यक आहे.';

  @override
  String get evidenceDone => 'पूर्ण';

  @override
  String get evidenceRequired => 'आवश्यक';

  @override
  String get evidenceCamera => 'कॅमेरा';

  @override
  String get evidenceGallery => 'गॅलरी';

  @override
  String get evidenceSaved => 'जतन केले';

  @override
  String get uploadWaiting => 'प्रतीक्षेत';

  @override
  String get uploadPreparing => 'तयार करत आहे';

  @override
  String get uploadStarting => 'अपलोड सुरू होत आहे';

  @override
  String uploadPercent(Object percent) {
    return '$percent%';
  }

  @override
  String get uploadFinishing => 'पूर्ण होत आहे';

  @override
  String get uploadCancel => 'अपलोड रद्द करा';

  @override
  String get uploadNotFinished => 'ते अपलोड पूर्ण झाले नाही.';

  @override
  String get commonRetry => 'पुन्हा प्रयत्न करा';

  @override
  String durationMinutes(Object minutes) {
    return '$minutes मिनिटे';
  }

  @override
  String durationHours(Object hours) {
    return '$hours तास';
  }

  @override
  String durationHoursMinutes(Object hours, Object minutes) {
    return '$hours तास $minutes मिनिटे';
  }

  @override
  String durationDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count दिवस',
      one: '1 दिवस',
    );
    return '$_temp0';
  }

  @override
  String pricePerHour(Object price) {
    return '$price/तास';
  }

  @override
  String pricePerDay(Object price) {
    return '$price/दिवस';
  }

  @override
  String pricePerUnit(Object price) {
    return '$price/युनिट';
  }

  @override
  String pricePerSqft(Object price) {
    return '$price/चौ. फूट';
  }

  @override
  String get gigsTitle => 'माझ्या सेवा';

  @override
  String get gigsAddTooltip => 'सेवा जोडा';

  @override
  String get gigsAdd => 'सेवा जोडा';

  @override
  String get gigsEmpty => 'अद्याप सेवा नाहीत';

  @override
  String get gigsEmptyBody =>
      'तुम्ही देता त्या सेवा जोडा. तुम्हाला मंजूर असलेल्या सर्व कामांत हव्या तितक्या सेवा जोडू शकता.';

  @override
  String get gigsNoneLive =>
      'तुमची कोणतीही सेवा सुरू नाही, त्यामुळे ग्राहक तुम्हाला बुक करू शकत नाहीत.';

  @override
  String gigsLiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count सेवा सुरू आहेत.',
      one: '1 सेवा सुरू आहे.',
    );
    return '$_temp0';
  }

  @override
  String get gigsAvailable => 'तुम्ही कामासाठी उपलब्ध आहात.';

  @override
  String get gigsOffDuty =>
      'तुम्ही ड्यूटीवर नाही, त्यामुळे तुम्हाला कामे दिली जाणार नाहीत.';

  @override
  String gigJobsDone(int count) {
    return '$count पूर्ण';
  }

  @override
  String get gigEdit => 'संपादित करा';

  @override
  String get gigPause => 'थांबवा';

  @override
  String get gigResume => 'पुन्हा सुरू करा';

  @override
  String get gigInReview => 'पुनरावलोकनात';

  @override
  String get gigDraftHint => 'मसुदा — पुनरावलोकनासाठी पाठवा';

  @override
  String get gigRejectedHint => 'नाकारले — संपादित करून पुन्हा पाठवा';

  @override
  String get gigArchived => 'संग्रहित';

  @override
  String get gigNotLive => 'सुरू नाही';

  @override
  String get gigPaused => 'थांबवले. तुम्हाला ही कामे दिली जाणार नाहीत.';

  @override
  String get gigLiveAgain => 'पुन्हा सुरू.';

  @override
  String get gigDuration30m => '30 मिनिटे';

  @override
  String get gigDuration45m => '45 मिनिटे';

  @override
  String get gigDuration1h => '1 तास';

  @override
  String get gigDuration2h => '2 तास';

  @override
  String get gigDuration4h => '4 तास';

  @override
  String get gigDuration8h => '8 तास (एक कामाचा दिवस)';

  @override
  String get gigDuration24h => '24 तास';

  @override
  String get gigDuration2d => '2 दिवस';

  @override
  String get gigDuration3d => '3 दिवस';

  @override
  String get gigDuration1w => '1 आठवडा';

  @override
  String get gigSavedDraft => 'मसुदा म्हणून जतन केले.';

  @override
  String get gigSubmitted => 'पाठवले. आम्ही पुनरावलोकन करून कळवू.';

  @override
  String get gigLive => 'तुमची सेवा सुरू झाली आहे.';

  @override
  String get gigSaved => 'जतन केले.';

  @override
  String get gigEditorAddTitle => 'सेवा जोडा';

  @override
  String get gigEditorEditTitle => 'सेवा संपादित करा';

  @override
  String get gigNoTrades => 'अद्याप मंजूर कामे नाहीत';

  @override
  String get gigNoTradesBody =>
      'एखादे काम तुमच्यासाठी मंजूर झाल्यावर त्या अंतर्गत सेवा प्रकाशित करू शकता. सुरू करण्यासाठी प्रोफाइलमधून काम जोडा.';

  @override
  String get gigFieldTrade => 'कोणते काम?';

  @override
  String get gigFieldTitle => 'सेवेचे नाव काय आहे?';

  @override
  String get gigFieldTitleHint => 'ग्राहक हे पाहतात. नेमके लिहा.';

  @override
  String get gigFieldTitleExample => 'उदा. स्प्लिट AC डीप क्लीनिंग';

  @override
  String get gigFieldDescription => 'यात काय समाविष्ट आहे?';

  @override
  String get gigFieldDescriptionHint =>
      'ऐच्छिक, पण यामुळे ग्राहकांना तुम्हाला निवडण्यास मदत होते.';

  @override
  String get gigFieldDescriptionExample =>
      'उदा. इनडोअर आणि आउटडोअर युनिटची संपूर्ण स्वच्छता, फिल्टर धुणे, गॅस प्रेशर तपासणी.';

  @override
  String get gigFieldPrice => 'तुम्ही किती घेता?';

  @override
  String get gigFieldPriceHint =>
      'प्रत्येक सेवेची स्वतःची किंमत असते. याचा तुमच्या इतर सेवांवर परिणाम होत नाही.';

  @override
  String get gigUnitPerJob => 'प्रति काम';

  @override
  String get gigUnitPerHour => 'प्रति तास';

  @override
  String get gigUnitPerDay => 'प्रति दिवस';

  @override
  String get gigUnitPerUnit => 'प्रति युनिट';

  @override
  String get gigUnitPerSqft => 'प्रति चौ. फूट';

  @override
  String get gigFieldDuration => 'याला सहसा किती वेळ लागतो?';

  @override
  String get gigFieldRadius => 'यासाठी तुम्ही किती दूर जाल?';

  @override
  String get gigFieldRadiusHint =>
      'तुमचे नेहमीचे प्रवास अंतर वापरण्यासाठी डीफॉल्ट ठेवा.';

  @override
  String get gigUsualDistance => 'तुमचे नेहमीचे अंतर';

  @override
  String get gigUseUsualDistance => 'माझे नेहमीचे अंतर वापरा';

  @override
  String get gigReviewNotice =>
      'नवीन आणि संपादित सेवा सुरू होण्यापूर्वी आमची टीम तपासते. तपासणी झाल्यावर लगेच कळवू.';

  @override
  String get gigSaveDraft => 'मसुदा जतन करा';

  @override
  String get gigSubmitForReview => 'पुनरावलोकनासाठी पाठवा';

  @override
  String get walletAllTransactions => 'सर्व व्यवहार';

  @override
  String get walletFrozen =>
      'एका गोष्टीची तपासणी सुरू असताना पैसे काढणे थांबवले आहे. तपशीलासाठी सहाय्याशी संपर्क साधा.';

  @override
  String get walletWithdraw => 'पैसे काढा';

  @override
  String walletNothingPending(Object amount) {
    return 'अजून काढण्यासारखे काही नाही. $amount ची प्रक्रिया सुरू आहे आणि ती कामे मंजूर झाल्यावर तुमच्या शिलकीत येईल.';
  }

  @override
  String get walletNothingYet =>
      'अजून काढण्यासारखे काही नाही. ग्राहकाने पूर्ण काम मंजूर केल्यावर तुमची कमाई येथे दिसेल.';

  @override
  String get walletRecentEarnings => 'अलीकडील कमाई';

  @override
  String get walletNoEarnings => 'अद्याप कमाई नाही';

  @override
  String get walletNoEarningsBody =>
      'पूर्ण झालेल्या कामाचे पेमेंट झाल्यावर तुमची कमाई येथे दिसेल.';

  @override
  String get walletAvailable => 'काढण्यासाठी उपलब्ध';

  @override
  String get walletProcessing => 'प्रक्रिया सुरू';

  @override
  String get walletProcessingHint => 'राखीव कालावधीनंतर दिले जाईल';

  @override
  String get walletTotalEarned => 'एकूण कमाई';

  @override
  String get statementTitle => 'स्टेटमेंट';

  @override
  String get statementTabTransactions => 'व्यवहार';

  @override
  String get statementTabWithdrawals => 'पैसे काढणे';

  @override
  String get statementEmpty => 'अजून काही नाही';

  @override
  String get statementEmptyBody =>
      'तुम्ही काम सुरू केल्यावर प्रत्येक पेमेंट, शुल्क आणि पैसे काढणे येथे दिसेल.';

  @override
  String statementBalance(Object amount) {
    return 'शिल्लक $amount';
  }

  @override
  String get statementNoWithdrawals => 'अद्याप पैसे काढलेले नाहीत';

  @override
  String get statementNoWithdrawalsBody =>
      'तुम्ही पैसे काढल्यावर त्याची नोंद येथे ठेवली जाईल.';

  @override
  String payoutRequestedAt(Object date) {
    return '$date रोजी विनंती केली';
  }

  @override
  String payoutPaidAt(Object date) {
    return '$date रोजी दिले';
  }

  @override
  String get payoutEnterAmount => 'किती पैसे काढायचे ते टाका';

  @override
  String payoutUpTo(Object amount) {
    return 'तुम्ही सध्या $amount पर्यंत काढू शकता';
  }

  @override
  String payoutMinimum(Object amount) {
    return 'किमान पैसे काढणे $amount आहे';
  }

  @override
  String payoutRequested(Object amount) {
    return '$amount काढण्याची विनंती केली. प्रक्रिया होताना आम्ही कळवत राहू.';
  }

  @override
  String get payoutAvailableNow => 'आत्ता उपलब्ध';

  @override
  String payoutPendingMore(Object amount) {
    return 'आणखी $amount ची प्रक्रिया सुरू आहे आणि ते अजून काढता येणार नाही.';
  }

  @override
  String get payoutHowMuch => 'किती?';

  @override
  String get payoutAll => 'सर्व';

  @override
  String payoutPercent(Object percent) {
    return '$percent%';
  }

  @override
  String get payoutProcessNotice =>
      'पैसे काढण्याची तपासणी करून ते तुमच्या नोंदणीकृत बँक खात्यात पाठवले जातात. प्रत्येक टप्प्याची स्थिती येथे दिसेल.';

  @override
  String get payoutRequest => 'पैसे काढण्याची विनंती करा';

  @override
  String get bankChecking => 'तुमचे बँक खाते तपासत आहे…';

  @override
  String bankPaidTo(Object last4) {
    return '$last4 ने संपणाऱ्या खात्यात दिले जाईल';
  }

  @override
  String get bankVerifiedFallback => 'तुमचे पडताळलेले बँक खाते';

  @override
  String get bankBeingVerified => 'बँक खात्याची पडताळणी सुरू आहे';

  @override
  String get bankBeingVerifiedBody =>
      'आमच्या टीमने पडताळणी केल्यावर तुम्ही पैसे काढू शकता.';

  @override
  String get bankNotVerified => 'बँक खाते पडताळलेले नाही';

  @override
  String get bankNotVerifiedBody => 'तुमचा तपशील तपासा आणि पुन्हा पाठवा.';

  @override
  String get bankAddTitle => 'बँक खाते जोडा';

  @override
  String get bankAddBody =>
      'आमच्या टीमने पडताळलेल्या बँक खात्यातच पैसे पाठवले जातात.';

  @override
  String get bankAddAction => 'बँक खाते जोडा';

  @override
  String get verificationTitle => 'पडताळणी';

  @override
  String get verificationProgress => 'पडताळलेल्या तपासण्या';

  @override
  String verificationCount(int approved, int total) {
    return '$total पैकी $approved';
  }

  @override
  String get verificationInsurance => 'विमा';

  @override
  String get verificationNoCover => 'कोणताही सुरू विमा नाही';

  @override
  String get verificationNoCoverBody =>
      'सध्या आमच्याकडे तुमची कोणतीही विमा पॉलिसी नोंदलेली नाही.';

  @override
  String get verifyIdentity => 'ओळख';

  @override
  String get verifyIdentityBody =>
      'सरकारी ओळखपत्र, जेणेकरून ग्राहकांना कळेल की त्यांच्या घरी कोण येत आहे.';

  @override
  String get verifyAddress => 'पत्ता';

  @override
  String get verifyAddressBody => 'तुम्ही कुठे राहता याचा पुरावा.';

  @override
  String get verifyIti => 'ITI प्रमाणपत्र';

  @override
  String get verifyItiBody =>
      'औद्योगिक प्रशिक्षण संस्थेकडून (ITI) तुमचे ट्रेड प्रमाणपत्र.';

  @override
  String get verifyDiploma => 'डिप्लोमा';

  @override
  String get verifyDiplomaBody => 'मान्यताप्राप्त तांत्रिक डिप्लोमा.';

  @override
  String get verifyRpl => 'कौशल्य मूल्यांकन';

  @override
  String get verifyRplBody =>
      'पूर्व शिक्षणाची मान्यता (RPL): तुमच्या अनुभवाचे मूल्यांकन आणि प्रमाणन.';

  @override
  String get verifyBackground => 'पार्श्वभूमी तपासणी';

  @override
  String get verifyBackgroundBody =>
      'हे आम्ही स्वतः करतो. तुम्हाला काहीही करावे लागत नाही.';

  @override
  String get verifyInsuranceBody =>
      'काम करताना अपघाती नुकसानासाठी विमा. व्यवस्था झाल्यावर आमची टीम तुमची पॉलिसी जोडते.';

  @override
  String get verifyBank => 'बँक खाते';

  @override
  String get verifyBankBody => 'जिथे तुमचे काढलेले पैसे पाठवले जातात.';

  @override
  String verificationValidUntil(Object date) {
    return '$date पर्यंत वैध';
  }

  @override
  String get verificationStart => 'सुरू करा';

  @override
  String get verificationUpdate => 'अपडेट करा';

  @override
  String get policyActive => 'सुरू';

  @override
  String get policyNotActive => 'सुरू नाही';

  @override
  String get policyNumber => 'पॉलिसी';

  @override
  String get policyCover => 'विमा रक्कम';

  @override
  String get policyValidUntil => 'पर्यंत वैध';

  @override
  String get kycStillWaiting =>
      'अजूनही DigiLocker ची वाट पाहत आहोत. तुम्ही नंतर येथून पुन्हा पाहू शकता.';

  @override
  String get kycTitle => 'ओळख पडताळणी';

  @override
  String get kycHeadline => 'तुम्ही कोण आहात याची पुष्टी करा';

  @override
  String get kycIntro =>
      'ग्राहक तुम्हाला त्यांच्या घरात येऊ देतात, म्हणून आम्ही प्रत्येक कर्मचाऱ्याची ओळख DigiLocker द्वारे पडताळतो, जे भारत सरकारचे दस्तऐवज व्यासपीठ आहे. काहीही अपलोड होत नाही — तुम्ही फक्त तुमच्या आधार खात्यावर विनंती मंजूर करता.';

  @override
  String get kycPrivacy =>
      'तुमच्या आधारचा तपशील थेट DigiLocker कडून पुष्टी केला जातो. तपासणी झाल्याचा पुरावा एवढेच आम्ही ठेवतो — तुमचा फोटो किंवा आधारची प्रत कधीच नाही.';

  @override
  String get kycVerified => 'तुमची ओळख पडताळली गेली आहे.';

  @override
  String get kycAwaitingConsent =>
      'तुमच्या ब्राउझरमध्ये DigiLocker ची संमती पूर्ण करा, मग येथे परत या.';

  @override
  String get kycChecking => 'DigiLocker कडे तपासत आहे…';

  @override
  String get kycStart => 'DigiLocker द्वारे पडताळा';

  @override
  String get qualSubmitted => 'पुनरावलोकनासाठी पाठवले.';

  @override
  String get qualTitle => 'तुमची पात्रता';

  @override
  String get qualIti => 'ITI';

  @override
  String get qualInstitute => 'संस्था';

  @override
  String get qualInstituteHint => 'उदा. शासकीय ITI, कोइम्बतूर';

  @override
  String get qualName => 'पात्रता';

  @override
  String get qualNameHint => 'उदा. इलेक्ट्रिशियन';

  @override
  String get qualSpeciality => 'विशेषता (ऐच्छिक)';

  @override
  String get qualSpecialityHint => 'उदा. औद्योगिक वायरिंग';

  @override
  String get qualYear => 'पूर्ण केलेले वर्ष';

  @override
  String get qualCertificate => 'तुमचे प्रमाणपत्र';

  @override
  String get qualCertificateBody => 'प्रमाणपत्राचा स्पष्ट फोटो किंवा PDF.';

  @override
  String get bankErrorHolder => 'खात्यावर जसे आहे तसेच नाव टाका';

  @override
  String get bankErrorNumber => 'खाते क्रमांक 9 ते 18 अंकी असतो';

  @override
  String get bankErrorMismatch => 'खाते क्रमांक जुळत नाहीत';

  @override
  String get bankErrorIfsc => '11 अक्षरी IFSC टाका, उदा. SBIN0001234';

  @override
  String get bankSent => 'बँक खाते पडताळणीसाठी पाठवले.';

  @override
  String get bankNotice =>
      'तुमचे काढलेले पैसे या खात्यात पाठवले जातात. पहिल्या पेआउटपूर्वी आमची टीम याची पडताळणी करते.';

  @override
  String get bankHolder => 'खातेधारकाचे नाव';

  @override
  String get bankNumber => 'खाते क्रमांक';

  @override
  String get bankConfirmNumber => 'खाते क्रमांक पुन्हा टाका';

  @override
  String get bankIfsc => 'IFSC कोड';

  @override
  String get bankIfscHint => 'उदा. SBIN0001234';

  @override
  String get bankName => 'बँकेचे नाव (ऐच्छिक)';

  @override
  String get bankSubmit => 'पडताळणीसाठी पाठवा';

  @override
  String get profileCompleteness => 'प्रोफाइल किती पूर्ण आहे';

  @override
  String get profileCompletenessBody =>
      'पूर्ण प्रोफाइलमुळे ग्राहकांना तुम्हाला निवडण्यास मदत होते.';

  @override
  String get profileJobsDone => 'पूर्ण कामे';

  @override
  String get profileRating => 'रेटिंग';

  @override
  String get profileExperience => 'अनुभव';

  @override
  String profileExperienceYears(Object years) {
    return '$years वर्षे';
  }

  @override
  String get profileEdit => 'प्रोफाइल संपादित करा';

  @override
  String get profileVerified => 'पडताळलेले';

  @override
  String get profileNotVerified => 'पडताळलेले नाही';

  @override
  String get profilePinInvalid => 'वैध 6 अंकी पिन कोड टाका';

  @override
  String get profileUpdated => 'प्रोफाइल अपडेट झाले.';

  @override
  String get profilePhotoUpdated => 'फोटो अपडेट झाला.';

  @override
  String get profileChangePhoto => 'फोटो बदला';

  @override
  String get profileName => 'नाव';

  @override
  String get profilePhone => 'फोन';

  @override
  String get profileLockedNotice =>
      'तुमचे नाव आणि नंबर ओळख पडताळणीशी जोडलेले आहेत. यापैकी काही बदलायचे असल्यास सहाय्याशी संपर्क साधा.';

  @override
  String get profileAbout => 'तुमच्याबद्दल';

  @override
  String get profileBioHint =>
      'ग्राहकांना तुमचा अनुभव आणि तुम्ही कशात चांगले आहात ते सांगा.';

  @override
  String get profileYearsExperience => 'अनुभवाची वर्षे';

  @override
  String get profileBased => 'तुम्ही कुठे राहता';

  @override
  String get profileAddress => 'पत्ता';

  @override
  String get profileCity => 'शहर';

  @override
  String get profilePin => 'पिन कोड';

  @override
  String get profileGender => 'लिंग';

  @override
  String get genderMale => 'पुरुष';

  @override
  String get genderFemale => 'स्त्री';

  @override
  String get genderOther => 'इतर';

  @override
  String get profileTrades => 'तुमची कामे';

  @override
  String get profileTradesBody =>
      'तुम्हाला मंजूर असलेल्या सर्व कामांत तुम्ही काम करू शकता.';

  @override
  String get profileTradesLoadFailed => 'तुमची कामे लोड होऊ शकली नाहीत.';

  @override
  String get tradePending => 'प्रलंबित';

  @override
  String get profileAddTrade => 'काम जोडा';

  @override
  String get profileAddTradeBody =>
      'मंजुरीपूर्वी आम्ही तुमच्या कौशल्याचा पुरावा मागू शकतो.';

  @override
  String get profileTradeRequested => 'विनंती केली. मंजूर झाल्यावर आम्ही कळवू.';

  @override
  String get profileSave => 'बदल जतन करा';

  @override
  String get supportNewRequest => 'नवीन विनंती';

  @override
  String get supportEmpty => 'अद्याप विनंत्या नाहीत';

  @override
  String get supportEmptyBody =>
      'एखाद्या कामात, पेमेंटमध्ये किंवा खात्यात काही चुकले तर विनंती करा, आम्ही मदत करू.';

  @override
  String get supportYourRequests => 'तुमच्या विनंत्या';

  @override
  String get supportEmergency => 'आपत्कालीन परिस्थितीत';

  @override
  String get supportEmergencyBody =>
      'हे ॲप तुमच्या वतीने मदत बोलावू शकत नाही. तुम्ही धोक्यात असाल तर थेट आपत्कालीन सेवांना कॉल करा.';

  @override
  String get supportCall112 => '112 वर कॉल करा';

  @override
  String get supportPolice => 'पोलीस';

  @override
  String get ticketOpen => 'खुले';

  @override
  String get ticketInProgress => 'प्रगतीत';

  @override
  String get ticketReplyNeeded => 'तुमचे उत्तर हवे';

  @override
  String get ticketResolved => 'सोडवले';

  @override
  String get ticketClosed => 'बंद';

  @override
  String ticketLastUpdate(Object date) {
    return 'शेवटचे अपडेट $date';
  }

  @override
  String get supportCategoryJob => 'एखादे काम';

  @override
  String get supportCategoryPayment => 'एखादे पेमेंट';

  @override
  String get supportCategoryWithdrawal => 'पैसे काढणे';

  @override
  String get supportCategoryAccount => 'माझे खाते';

  @override
  String get supportCategorySafety => 'सुरक्षा';

  @override
  String get supportCategoryApp => 'ॲप';

  @override
  String get supportCategoryOther => 'दुसरे काहीतरी';

  @override
  String supportRaised(Object code) {
    return 'विनंती $code नोंदवली.';
  }

  @override
  String get supportHowHelp => 'आम्ही कशी मदत करू?';

  @override
  String get supportAbout => 'हे कशाबद्दल आहे?';

  @override
  String get supportSubject => 'विषय';

  @override
  String get supportSubjectHint => 'समस्येबद्दल काही शब्द';

  @override
  String get supportWhatHappened => 'काय झाले?';

  @override
  String get supportSend => 'विनंती पाठवा';

  @override
  String get ticketTitle => 'सहाय्य विनंती';

  @override
  String get ticketNoMessages => 'अद्याप संदेश नाहीत';

  @override
  String get ticketNoMessagesBody => 'तुमचे संभाषण येथे दिसेल.';

  @override
  String get ticketWriteMessage => 'संदेश लिहा';

  @override
  String get ticketSupportName => 'Wervexa सहाय्य';

  @override
  String get requestsTitle => 'ग्राहकांच्या विनंत्या';

  @override
  String get requestsRefresh => 'रिफ्रेश करा';

  @override
  String get requestsLocationNeeded => 'स्थान आवश्यक';

  @override
  String get requestsLocationBody =>
      'तुमच्या जवळच्या ग्राहक विनंत्या शोधण्यासाठी आम्ही तुमचे स्थान वापरतो.';

  @override
  String get requestsGrantLocation => 'स्थानाची परवानगी द्या';

  @override
  String get requestsEmpty => 'जवळपास जुळणाऱ्या विनंत्या नाहीत';

  @override
  String get requestsEmptyBody =>
      'तुमच्या सेवांशी जुळल्यावर\nनवीन ग्राहक विनंत्या येथे दिसतील.';

  @override
  String get requestsViewOffer => 'पहा आणि ऑफर द्या →';

  @override
  String get requestEnterPrice => 'वैध किंमत टाका';

  @override
  String requestOfferSubmitted(Object price) {
    return '$price ला ऑफर पाठवली!';
  }

  @override
  String get requestDetailsTitle => 'विनंतीचा तपशील';

  @override
  String get requestStatusOpen => 'खुले';

  @override
  String get requestCategory => 'श्रेणी';

  @override
  String get requestBudget => 'बजेट';

  @override
  String get requestSchedule => 'वेळापत्रक';

  @override
  String get requestDistance => 'अंतर';

  @override
  String get requestArea => 'परिसर';

  @override
  String get requestOffers => 'ऑफर';

  @override
  String get requestNotes => 'नोंदी';

  @override
  String get requestAddressPrivacy =>
      'ग्राहकाने तुमची ऑफर स्वीकारल्यानंतरच त्यांचा नेमका पत्ता शेअर केला जातो.';

  @override
  String get requestYourOffer => 'तुमची ऑफर';

  @override
  String get requestYourPrice => 'तुमची किंमत (₹)';

  @override
  String get requestPriceHint => 'उदा. 500';

  @override
  String get requestDuration => 'अंदाजे कालावधी (ऐच्छिक)';

  @override
  String get requestDurationHint => 'उदा. 1-2 तास';

  @override
  String get requestMessage => 'ग्राहकासाठी संदेश (ऐच्छिक)';

  @override
  String get requestMessageHint => 'या कामासाठी तुम्हीच योग्य व्यक्ती का आहात?';

  @override
  String get requestSubmitOffer => 'ऑफर पाठवा';

  @override
  String get requestMakeOffer => 'ऑफर द्या';

  @override
  String get requestAlreadyOffered => 'तुम्ही या विनंतीवर आधीच ऑफर पाठवली आहे.';

  @override
  String get requestViewOffers => 'ऑफर पहा';

  @override
  String get offersEmptyBody =>
      'ग्राहक विनंत्यांवर तुम्ही पाठवलेल्या ऑफर\nयेथे दिसतील.';

  @override
  String get offerWithdraw => 'पैसे काढा';

  @override
  String get offerWithdrawTitle => 'ऑफर मागे घ्यायची?';

  @override
  String get offerWithdrawBody => 'ग्राहकाला ही ऑफर आता दिसणार नाही.';

  @override
  String get offerWithdrawn => 'ऑफर मागे घेतली';

  @override
  String get onboardingTitle => 'तुमचे प्रोफाइल सेट करा';

  @override
  String get onboardingHelp => 'मदत';

  @override
  String onboardingHello(Object name) {
    return 'नमस्कार, $name';
  }

  @override
  String get onboardingIntro =>
      'आणखी काही गोष्टी आणि तुम्ही काम मिळवण्यास तयार आहात.';

  @override
  String get onboardingSetup => 'सेटअप';

  @override
  String onboardingStepCount(int done, int total) {
    return '$total पैकी $done';
  }

  @override
  String get onboardingBasicBody =>
      'तुमचे शहर आणि पिन कोड, जेणेकरून आम्ही तुमच्या जवळ काम शोधू शकू.';

  @override
  String get onboardingTradeBody => 'तुम्ही मुख्यतः करता ते काम.';

  @override
  String get onboardingSkillsDoneBody =>
      'तुमचे मुख्य काम एक म्हणून गणले जाते. इतर सर्व कामे जोडण्यासाठी हे उघडा.';

  @override
  String get onboardingSkillsBody =>
      'तुम्ही करता ती सर्व कामे जोडा. तुम्ही एकाच कामापुरते मर्यादित नाही.';

  @override
  String get onboardingAreaBody =>
      'एखाद्या कामासाठी तुम्ही किती दूर जायला तयार आहात.';

  @override
  String get onboardingKycBody =>
      'सरकारी ओळखपत्र. ग्राहक तुम्हाला त्यांच्या घरात येऊ देत आहेत.';

  @override
  String get onboardingReviewNotice =>
      'हे पूर्ण केल्यावर आमची टीम तुमची कागदपत्रे तपासते. वाट पाहताना तुम्ही तुमच्या सेवा सेट करणे सुरू ठेवू शकता.';

  @override
  String get onboardingTradesLoadFailed =>
      'कामे लोड होऊ शकली नाहीत. पुन्हा प्रयत्न करा.';

  @override
  String get onboardingMainTrade => 'तुमचे मुख्य काम कोणते?';

  @override
  String get onboardingMainTradeBody => 'नंतर आणखी कामे जोडू शकता.';

  @override
  String onboardingTradeSet(Object trade) {
    return '$trade तुमचे मुख्य काम म्हणून सेट केले.';
  }

  @override
  String get onboardingTravelTitle => 'तुम्ही किती दूर जाल?';

  @override
  String get onboardingTravelBody =>
      'तुम्ही आत्ता जिथे आहात तिथून याच अंतरातील कामे आम्ही देऊ.';

  @override
  String get onboardingTravelCentre =>
      'आम्ही तुमचे सध्याचे स्थान मध्यबिंदू म्हणून वापरतो. प्रोफाइलमधून हे कधीही बदलू शकता.';

  @override
  String get onboardingLocationOff =>
      'कामाचा परिसर सेट करण्यासाठी स्थानाची परवानगी सुरू करा.';

  @override
  String get commonSave => 'जतन करा';

  @override
  String get notificationsStayOff =>
      'सूचना बंद राहतील. फोनच्या सेटिंग्जमध्ये त्या सुरू करू शकता.';

  @override
  String get notificationsPrimerTitle => 'काम आल्यावर लगेच कळवा';

  @override
  String get notificationsPrimerBody =>
      'कामाच्या ऑफरची मुदत संपते. ॲप बंद असताना सूचनेद्वारेच तुम्हाला कळते — दुसरे काहीही पाठवले जात नाही.';

  @override
  String get notificationsTurnOn => 'सूचना सुरू करा';

  @override
  String get commonNotNow => 'आत्ता नाही';

  @override
  String get onboardingCityRequired => 'कृपया तुमचे शहर टाका';

  @override
  String get onboardingGenderRequired => 'कृपया तुमचे लिंग निवडा';

  @override
  String get onboardingWhereBased => 'तुम्ही कुठे राहता?';
}
