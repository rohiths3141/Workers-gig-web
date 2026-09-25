// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get languagePickerTitle => 'अपनी भाषा चुनें';

  @override
  String get startupMissingConfig => 'इस बिल्ड में कॉन्फ़िगरेशन नहीं है।';

  @override
  String startupPassDartDefine(Object keys) {
    return 'इन्हें --dart-define के साथ दें:\n\n$keys';
  }

  @override
  String get startupCouldNotStart => 'ऐप शुरू नहीं हो सका।';

  @override
  String get errorNoInternet =>
      'इंटरनेट कनेक्शन नहीं है। अपना नेटवर्क जाँचें और फिर से कोशिश करें।';

  @override
  String get errorTimeout => 'इसमें बहुत समय लग गया। फिर से कोशिश करें।';

  @override
  String get errorServer =>
      'हमारी ओर से कुछ गड़बड़ हो गई। कृपया फिर से कोशिश करें।';

  @override
  String get errorClockSkew =>
      'आपके फ़ोन की तारीख और समय सही नहीं लग रहे। सेटिंग्स में स्वचालित तारीख और समय चालू करें, फिर से कोशिश करें।';

  @override
  String get errorUnexpected => 'कुछ गड़बड़ हो गई। कृपया फिर से कोशिश करें।';

  @override
  String get eligibilityStepIncomplete => 'यह चरण अभी पूरा नहीं हुआ है।';

  @override
  String get errorSessionEnded =>
      'आपका सत्र समाप्त हो गया है। कृपया फिर से साइन इन करें।';

  @override
  String get errorUploadFailed =>
      'वह फ़ाइल अपलोड नहीं हो सकी। फिर से कोशिश करें।';

  @override
  String get errorServiceUnavailable =>
      'यह सेवा अभी उपलब्ध नहीं है। थोड़ी देर में फिर से कोशिश करें।';

  @override
  String get errorSignInNotReady =>
      'आपका साइन-इन अभी पूरी तरह तैयार नहीं है। थोड़ी देर में फिर से कोशिश करें।';

  @override
  String get errorNoLongerAvailable => 'यह अब उपलब्ध नहीं है।';

  @override
  String get errorNotAllowedToSee => 'आप इसे नहीं देख सकते।';

  @override
  String get errorDidNotWork => 'यह काम नहीं किया। कृपया फिर से कोशिश करें।';

  @override
  String get authErrorInvalidPhone => 'यह फ़ोन नंबर सही नहीं लग रहा।';

  @override
  String get authErrorWrongCode =>
      'यह कोड सही नहीं है। जाँचें और फिर से कोशिश करें।';

  @override
  String get authErrorCodeExpired => 'यह कोड समाप्त हो गया है। नया कोड माँगें।';

  @override
  String get authErrorTooManyAttempts =>
      'बहुत अधिक प्रयास। फिर से कोशिश करने से पहले कुछ मिनट रुकें।';

  @override
  String get authErrorQuota =>
      'हम अभी कोड नहीं भेज सकते। थोड़ी देर में फिर से कोशिश करें।';

  @override
  String get authErrorDisabled =>
      'यह खाता बंद कर दिया गया है। सहायता से संपर्क करें।';

  @override
  String get authErrorPhoneNotEnabledRegion =>
      'फ़ोन से साइन-इन चालू नहीं है, या इस क्षेत्र में SMS रोका गया है। Firebase Console की सेटिंग्स जाँचें।';

  @override
  String get authErrorNumberInUse =>
      'यह नंबर पहले से किसी दूसरे खाते से जुड़ा है।';

  @override
  String get authErrorSignInAgain =>
      'जारी रखने के लिए कृपया फिर से साइन इन करें।';

  @override
  String get authErrorSignInFailed =>
      'साइन-इन नहीं हो सका। कृपया फिर से कोशिश करें।';

  @override
  String get budgetTypeFlexible => 'लचीला';

  @override
  String get budgetTypeFixed => 'तय कीमत';

  @override
  String get budgetTypeRange => 'कीमत की सीमा';

  @override
  String get scheduleAsap => 'जितनी जल्दी हो सके';

  @override
  String get scheduleToday => 'आज';

  @override
  String get scheduleTomorrow => 'कल';

  @override
  String get scheduleSpecificDate => 'तय तारीख';

  @override
  String get offerStatusSubmitted => 'भेजा गया';

  @override
  String get offerStatusViewed => 'ग्राहक ने देखा';

  @override
  String get offerStatusShortlisted => 'शॉर्टलिस्ट किया गया';

  @override
  String get offerStatusAccepted => 'स्वीकार हुआ ✓';

  @override
  String get offerStatusRejected => 'नहीं चुना गया';

  @override
  String get offerStatusWithdrawn => 'वापस लिया गया';

  @override
  String get offerStatusExpired => 'समाप्त';

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
      other: '$count ऑफ़र',
      one: '1 ऑफ़र',
      zero: 'अभी कोई ऑफ़र नहीं',
    );
    return '$_temp0';
  }

  @override
  String get gigErrorTrade => 'चुनें कि यह सेवा किस काम से जुड़ी है';

  @override
  String get gigErrorTitleShort =>
      'इस सेवा को कम से कम 6 अक्षरों का साफ़ नाम दें';

  @override
  String get gigErrorTitleLong => 'नाम 120 अक्षरों से कम रखें';

  @override
  String get gigErrorPrice => 'इस सेवा के लिए आप कितना लेते हैं, दर्ज करें';

  @override
  String get gigErrorDurationMissing => 'इसमें आमतौर पर कितना समय लगता है?';

  @override
  String get gigErrorDurationShort =>
      'सबसे छोटा काम जो हम सूचीबद्ध कर सकते हैं वह 15 मिनट का है';

  @override
  String get gigErrorDurationLong =>
      'सबसे लंबा काम जो हम सूचीबद्ध कर सकते हैं वह 14 दिन का है';

  @override
  String get gigErrorRadius => 'यात्रा की दूरी 1 से 100 किमी के बीच होनी चाहिए';

  @override
  String get jobAreaNearby => 'आस-पास';

  @override
  String get jobBlockerVerifyArrival =>
      'ग्राहक के कोड से पहुँचने की पुष्टि करें';

  @override
  String get jobBlockerAfterPhoto => 'पूरे हुए काम की फ़ोटो जोड़ें';

  @override
  String jobBlockerMaterialsPending(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'सामग्री के $count अनुरोध अभी ग्राहक के जवाब का इंतज़ार कर रहे हैं',
      one: 'सामग्री का 1 अनुरोध अभी ग्राहक के जवाब का इंतज़ार कर रहा है',
    );
    return '$_temp0';
  }

  @override
  String mediaTypeNotAccepted(Object kinds) {
    return 'यहाँ यह फ़ाइल प्रकार स्वीकार नहीं है। $kinds इस्तेमाल करें।';
  }

  @override
  String get mediaEmpty => 'यह फ़ाइल खाली है।';

  @override
  String mediaTooLarge(Object megabytes) {
    return 'यह फ़ाइल बहुत बड़ी है। सीमा ${megabytes}MB है।';
  }

  @override
  String get verificationNotStarted => 'शुरू नहीं हुआ';

  @override
  String get verificationSubmitted => 'भेजा गया';

  @override
  String get verificationUnderReview => 'समीक्षा हो रही है';

  @override
  String get verificationMoreInfo => 'और जानकारी चाहिए';

  @override
  String get verificationExpired => 'समाप्त';

  @override
  String get verificationVerified => 'सत्यापित';

  @override
  String get verificationNotApproved => 'मंज़ूर नहीं हुआ';

  @override
  String get verificationNotRequired => 'ज़रूरी नहीं';

  @override
  String get qualificationErrorInstitution => 'यह किस संस्थान ने जारी किया?';

  @override
  String get qualificationErrorName => 'इस योग्यता का नाम क्या है?';

  @override
  String get qualificationErrorYearMissing => 'आपने इसे किस साल पूरा किया?';

  @override
  String qualificationErrorYearRange(Object year) {
    return '1950 और $year के बीच का साल दर्ज करें';
  }

  @override
  String get walletTxJobEarning => 'काम की कमाई';

  @override
  String get walletTxMaterialReimbursed => 'सामग्री की भरपाई';

  @override
  String get walletTxAdjustment => 'समायोजन';

  @override
  String get walletTxPayoutReturned => 'पेआउट वापस आया';

  @override
  String get walletTxPlatformFee => 'प्लेटफ़ॉर्म शुल्क';

  @override
  String get walletTxWithdrawn => 'वापस लिया गया';

  @override
  String get walletTxClaimRecovery => 'दावे की वसूली';

  @override
  String get payoutStatusRequested => 'अनुरोध किया गया';

  @override
  String get payoutStatusProcessing => 'प्रक्रिया में';

  @override
  String get payoutStatusPaid => 'भुगतान हो गया';

  @override
  String get payoutStatusFailed => 'विफल';

  @override
  String get authPhoneTenDigits => '10 अंकों का मोबाइल नंबर दर्ज करें।';

  @override
  String get authCodeSendTimeout =>
      'हम कोड नहीं भेज सके। अपना नेटवर्क जाँचें और फिर से कोशिश करें।';

  @override
  String get authEnterReceivedCode => 'आपको मिला कोड दर्ज करें।';

  @override
  String get authSignInIncomplete =>
      'साइन-इन पूरा नहीं हुआ। कृपया फिर से कोशिश करें।';

  @override
  String get authSignInToContinue => 'जारी रखने के लिए कृपया साइन इन करें।';

  @override
  String get accountDeletionBySupport =>
      'खाता हटाने का काम हमारी सहायता टीम करती है। एक अनुरोध बनाएँ और काम पूरा होने पर हम पुष्टि करेंगे।';

  @override
  String get photoUploadFailed => 'यह फ़ोटो अपलोड नहीं हो सकी।';

  @override
  String get photoUploadFailedRetry =>
      'यह फ़ोटो अपलोड नहीं हो सकी। फिर से कोशिश करें।';

  @override
  String get locationInvalid => 'यह स्थान सही नहीं लग रहा।';

  @override
  String get travelDistanceRange =>
      '1 से 100 किमी के बीच यात्रा की दूरी चुनें।';

  @override
  String get profileLoadFailed => 'आपकी प्रोफ़ाइल लोड नहीं हो सकी।';

  @override
  String get uploadIncomplete => 'अपलोड पूरा नहीं हुआ। फिर से कोशिश करें।';

  @override
  String get uploadTooLarge => 'यह फ़ाइल बहुत बड़ी है।';

  @override
  String get uploadTypeNotAccepted => 'यह फ़ाइल प्रकार स्वीकार नहीं है।';

  @override
  String get uploadRefused => 'यह फ़ाइल अस्वीकार कर दी गई।';

  @override
  String get uploadTooMany =>
      'एक साथ बहुत सारे अपलोड। थोड़ा रुकें और फिर से कोशिश करें।';

  @override
  String get uploadGone => 'यह अपलोड अब उपलब्ध नहीं है। फ़ाइल फिर से चुनें।';

  @override
  String get uploadDidNotStart => 'अपलोड शुरू नहीं हुआ।';

  @override
  String get uploadDidNotFinish => 'यह अपलोड पूरा नहीं हुआ।';

  @override
  String get claimResponseTooShort =>
      'कृपया थोड़ा और विस्तार से बताएँ कि क्या हुआ।';

  @override
  String get walletLoadFailedRetry =>
      'आपका वॉलेट लोड नहीं हो सका। कृपया फिर से कोशिश करें।';

  @override
  String get walletLoadFailed => 'आपका वॉलेट लोड नहीं हो सका।';

  @override
  String get onboardingStepDetails => 'आपका विवरण';

  @override
  String get onboardingStepTrade => 'आपका मुख्य काम';

  @override
  String get onboardingStepSkills => 'आप क्या कर सकते हैं';

  @override
  String get onboardingStepArea => 'आप कहाँ काम करते हैं';

  @override
  String get onboardingStepKyc => 'पहचान की जाँच';

  @override
  String get onboardingStepReady => 'काम के लिए तैयार';

  @override
  String routerScreenNotFound(Object location) {
    return 'यह स्क्रीन नहीं खुल सकी।\n$location';
  }

  @override
  String get cameraOpenFailed => 'कैमरा नहीं खुल सका। ऐप की अनुमतियाँ जाँचें।';

  @override
  String get commonTryAgain => 'फिर से कोशिश करें';

  @override
  String get commonCancel => 'रद्द करें';

  @override
  String get commonConfirm => 'पुष्टि करें';

  @override
  String get offlineBanner =>
      'आप ऑफ़लाइन हैं। दोबारा जुड़ने पर काम से जुड़ी कार्रवाइयाँ फिर से चलेंगी।';

  @override
  String get badgeNew => 'नया';

  @override
  String get badgeAccepted => 'स्वीकार किया गया';

  @override
  String get badgeConfirmed => 'पुष्टि हुई';

  @override
  String get badgeOnTheWay => 'रास्ते में';

  @override
  String get badgeArrived => 'पहुँच गए';

  @override
  String get badgeWorking => 'काम चल रहा है';

  @override
  String get badgeAwaitingCustomer => 'ग्राहक का इंतज़ार';

  @override
  String get badgeDone => 'पूरा';

  @override
  String get badgePaymentDue => 'भुगतान बाकी';

  @override
  String get badgePaid => 'भुगतान हो गया';

  @override
  String get badgeClosed => 'बंद';

  @override
  String get badgeCancelled => 'रद्द';

  @override
  String get badgeDisputed => 'विवादित';

  @override
  String get badgeExpired => 'समाप्त';

  @override
  String get badgeDraft => 'ड्राफ़्ट';

  @override
  String get badgeInReview => 'समीक्षा में';

  @override
  String get badgeLive => 'लाइव';

  @override
  String get badgePaused => 'रुका हुआ';

  @override
  String get badgeNotApproved => 'मंज़ूर नहीं हुआ';

  @override
  String get badgeRemoved => 'हटाया गया';

  @override
  String get badgeNotStarted => 'शुरू नहीं हुआ';

  @override
  String get badgeSubmitted => 'भेजा गया';

  @override
  String get badgeActionNeeded => 'कार्रवाई ज़रूरी';

  @override
  String get badgeVerified => 'सत्यापित';

  @override
  String get badgeNotRequired => 'ज़रूरी नहीं';

  @override
  String get commonContinue => 'जारी रखें';

  @override
  String get commonSaving => 'सहेजा जा रहा है…';

  @override
  String get welcomePromiseWorkTitle => 'सही काम पाएँ';

  @override
  String get welcomePromiseWorkBody =>
      'आपके पास के काम, जो आपके असली कौशल से मेल खाते हैं।';

  @override
  String get welcomePromiseSkillsTitle => 'अपना कौशल साबित करें';

  @override
  String get welcomePromiseSkillsBody =>
      'आपके ITI और डिप्लोमा प्रमाणपत्र, एक बार सत्यापित और हर ग्राहक को दिखाए जाते हैं।';

  @override
  String get welcomePromiseTrackTitle => 'हर काम पर नज़र रखें';

  @override
  String get welcomePromiseTrackBody =>
      'काम स्वीकार करने से लेकर पूरा करने तक, हर चरण के फ़ोटो रिकॉर्ड के साथ।';

  @override
  String get welcomePromisePaidTitle => 'सुरक्षित भुगतान पाएँ';

  @override
  String get welcomePromisePaidBody =>
      'हर रुपया दर्ज, साफ़ स्टेटमेंट के साथ और निकासी आपकी शर्तों पर।';

  @override
  String get welcomeHeadline => 'काम जो आपको खुद ढूँढे';

  @override
  String get welcomeSubtitle =>
      'Wervexa कुशल पेशेवरों को उन ग्राहकों से जोड़ता है जिन्हें उनकी ज़रूरत है।';

  @override
  String get welcomeGetStarted => 'शुरू करें';

  @override
  String get welcomeCodeNotice =>
      'हम आपके मोबाइल नंबर पर एक बार का कोड भेजेंगे।';

  @override
  String get phoneTitle => 'आपका मोबाइल नंबर क्या है?';

  @override
  String get phoneSubtitle =>
      'यह आप ही हैं, इसकी पुष्टि के लिए हम एक बार का कोड भेजेंगे।';

  @override
  String get phoneSendCode => 'कोड भेजें';

  @override
  String get phoneSending => 'भेजा जा रहा है…';

  @override
  String get authNewCodeSent => 'हमने नया कोड भेज दिया है।';

  @override
  String get otpTitle => 'कोड दर्ज करें';

  @override
  String otpSentTo(Object phone) {
    return 'हमने $phone पर 6 अंकों का कोड भेजा है।';
  }

  @override
  String otpResendIn(int seconds) {
    String _temp0 = intl.Intl.pluralLogic(
      seconds,
      locale: localeName,
      other: 'आप $seconds सेकंड में नया कोड माँग सकते हैं',
      one: 'आप 1 सेकंड में नया कोड माँग सकते हैं',
    );
    return '$_temp0';
  }

  @override
  String get otpSendNew => 'नया कोड भेजें';

  @override
  String get otpVerify => 'सत्यापित करें';

  @override
  String get otpVerifying => 'सत्यापित किया जा रहा है…';

  @override
  String get registerNameRequired => 'कृपया अपना पूरा नाम दर्ज करें';

  @override
  String get registerEmailInvalid => 'कृपया सही ईमेल पता दर्ज करें';

  @override
  String get registerTitle => 'हम आपको क्या कहकर बुलाएँ?';

  @override
  String get registerSubtitle => 'ग्राहकों को यही नाम दिखेगा।';

  @override
  String get registerNameLabel => 'पूरा नाम';

  @override
  String get registerNameHint => 'अरुण कुमार';

  @override
  String get registerEmailLabel => 'ईमेल (वैकल्पिक)';

  @override
  String get registerEmailHelper => 'रसीदों और स्टेटमेंट के लिए।';

  @override
  String registerVerifiedPhone(Object phone) {
    return 'सत्यापित: $phone';
  }

  @override
  String get navHome => 'होम';

  @override
  String get navJobs => 'काम';

  @override
  String get navWallet => 'वॉलेट';

  @override
  String get navProfile => 'प्रोफ़ाइल';

  @override
  String get sessionProfileLoadFailedRetry =>
      'हम आपकी प्रोफ़ाइल लोड नहीं कर सके। कृपया फिर से कोशिश करें।';

  @override
  String get commonSignOut => 'साइन आउट करें';

  @override
  String get serviceElectrical => 'बिजली का काम';

  @override
  String get servicePlumbing => 'प्लंबिंग';

  @override
  String get serviceAcService => 'AC सर्विस';

  @override
  String get serviceApplianceRepair => 'उपकरण मरम्मत';

  @override
  String get serviceCarpentry => 'बढ़ईगीरी';

  @override
  String get servicePainting => 'पेंटिंग';

  @override
  String get serviceCleaning => 'सफ़ाई';

  @override
  String get servicePestControl => 'कीट नियंत्रण';

  @override
  String get serviceOtherHome => 'घर की अन्य सेवाएँ';

  @override
  String get commonSeeAll => 'सभी देखें';

  @override
  String distanceKm(Object km) {
    return '$km किमी';
  }

  @override
  String get homeRightNow => 'अभी';

  @override
  String get homeNewWork => 'नया काम';

  @override
  String homeJobsWaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count काम आपके जवाब का इंतज़ार कर रहे हैं',
      one: '1 काम आपके जवाब का इंतज़ार कर रहा है',
    );
    return '$_temp0';
  }

  @override
  String get homeComingUp => 'आने वाले';

  @override
  String get homeEarnings => 'कमाई';

  @override
  String get homeMyServices => 'मेरी सेवाएँ';

  @override
  String get homeVerification => 'सत्यापन';

  @override
  String get homeSupport => 'सहायता';

  @override
  String get homeRequests => 'अनुरोध';

  @override
  String get homeMyOffers => 'मेरे ऑफ़र';

  @override
  String get homeAddService => 'सेवा जोड़ें';

  @override
  String get homeAddServiceBody =>
      'ग्राहक आपको केवल उन्हीं सेवाओं के लिए बुक कर सकते हैं जो आपने प्रकाशित की हैं।';

  @override
  String get homeNotReady => 'अभी पूरी तरह तैयार नहीं';

  @override
  String get homeNotReadyBody =>
      'ये चरण पूरे करें और आप काम पाना शुरू कर सकते हैं।';

  @override
  String get homeGoodMorning => 'सुप्रभात';

  @override
  String get homeGoodAfternoon => 'नमस्कार';

  @override
  String get homeGoodEvening => 'शुभ संध्या';

  @override
  String get homeNotifications => 'सूचनाएँ';

  @override
  String get availabilityAvailable => 'उपलब्ध';

  @override
  String get availabilityAvailableBody => 'आप नए काम पा सकते हैं।';

  @override
  String get availabilityOnJob => 'काम पर';

  @override
  String get availabilityOnJobBody =>
      'यह काम पूरा होने तक आपको नया काम नहीं दिया जाएगा।';

  @override
  String get availabilityOff => 'बंद';

  @override
  String get availabilityOffBody => 'आपको नए काम नहीं मिलेंगे।';

  @override
  String get availabilityFinishJob =>
      'फिर से उपलब्ध होने के लिए अपना मौजूदा काम पूरा करें।';

  @override
  String get availabilityGoOff => 'ड्यूटी बंद करें';

  @override
  String get availabilityGoOn => 'उपलब्ध हो जाएँ';

  @override
  String get availabilityBeforeJobs => 'काम पाने से पहले';

  @override
  String get availabilityNowOn => 'आप काम के लिए उपलब्ध हैं।';

  @override
  String get availabilityNowOff => 'आप ड्यूटी से बाहर हैं।';

  @override
  String get workerStatusSetupIncomplete => 'सेटअप अधूरा';

  @override
  String get workerStatusUnderReview => 'समीक्षा में';

  @override
  String get workerStatusInactive => 'निष्क्रिय';

  @override
  String get workerStatusRestricted => 'प्रतिबंधित';

  @override
  String get workerStatusSuspended => 'निलंबित';

  @override
  String get homeAccount => 'खाता';

  @override
  String get homeWorkStatus => 'काम की स्थिति';

  @override
  String get availabilityOffDuty => 'ड्यूटी से बाहर';

  @override
  String get earningsThisWeek => 'इस हफ़्ते';

  @override
  String get earningsThisMonth => 'इस महीने';

  @override
  String get jobNextWaitConfirm => 'ग्राहक की पुष्टि का इंतज़ार';

  @override
  String get jobNextStartTravel => 'यात्रा शुरू करें';

  @override
  String get jobNextMarkArrived => 'पहुँचने का निशान लगाएँ';

  @override
  String get jobNextStartWork => 'काम शुरू करें';

  @override
  String get jobNextAskCode => 'ग्राहक से पहुँचने का कोड माँगें';

  @override
  String get jobNextFinish => 'पूरा करें और फ़ोटो जोड़ें';

  @override
  String get jobNextWaitApprove => 'ग्राहक की मंज़ूरी का इंतज़ार';

  @override
  String get jobNextOpen => 'काम खोलें';

  @override
  String get jobTimeTbc => 'समय की पुष्टि बाकी';

  @override
  String get settingsTitle => 'सेटिंग्स';

  @override
  String get settingsLanguage => 'भाषा';

  @override
  String get settingsAbout => 'जानकारी';

  @override
  String get settingsTerms => 'सेवा की शर्तें';

  @override
  String get settingsPrivacy => 'गोपनीयता नीति';

  @override
  String get settingsHelp => 'मदद और सहायता';

  @override
  String get settingsDeleteAccount => 'मेरा खाता हटाएँ';

  @override
  String get settingsSignOutTitle => 'साइन आउट करें?';

  @override
  String get settingsSignOutBody =>
      'फिर से साइन इन करने के लिए आपको अपना फ़ोन नंबर और एक कोड चाहिए होगा।';

  @override
  String get settingsDeleteTitle => 'अपना खाता हटाएँ';

  @override
  String get settingsDeleteBody =>
      'खाता हटाने से आपके काम का इतिहास, कमाई के रिकॉर्ड और कोई भी खुला भुगतान प्रभावित होता है, इसलिए यह अपने-आप नहीं बल्कि हमारी सहायता टीम द्वारा किया जाता है।\n\nसहायता अनुरोध बनाएँ और काम पूरा होने पर हम पुष्टि करेंगे।';

  @override
  String get settingsContactSupport => 'सहायता से संपर्क करें';

  @override
  String get notificationsMarkAllRead => 'सभी को पढ़ा हुआ चिह्नित करें';

  @override
  String get notificationsEmpty => 'आपने सब देख लिया है';

  @override
  String get notificationsEmptyBody =>
      'काम के ऑफ़र, भुगतान अपडेट और सत्यापन के नतीजे यहाँ दिखेंगे।';

  @override
  String get jobsTabUpcoming => 'आने वाले';

  @override
  String get jobsTabActive => 'चालू';

  @override
  String get jobsNoOffers => 'अभी कोई नया काम नहीं';

  @override
  String get jobsNoOffersBody =>
      'जब आप उपलब्ध होंगे, तो सही काम आते ही हम आपको बताएँगे।';

  @override
  String get jobsAccepted => 'काम स्वीकार किया गया।';

  @override
  String get jobsDeclineTitle => 'यह काम मना करें?';

  @override
  String get jobsDeclineBody =>
      'यह किसी दूसरे कर्मी को दिया जाएगा। बार-बार मना करने से आपको दिखाए जाने वाले काम कम हो सकते हैं।';

  @override
  String get jobsDecline => 'मना करें';

  @override
  String get jobsDeclined => 'काम मना कर दिया गया।';

  @override
  String get jobsEmptyUpcoming => 'कुछ तय नहीं है';

  @override
  String get jobsEmptyUpcomingBody => 'आपके स्वीकार किए गए काम यहाँ दिखेंगे।';

  @override
  String get jobsEmptyActive => 'कोई काम चल नहीं रहा';

  @override
  String get jobsEmptyActiveBody =>
      'जब आप कोई काम शुरू करेंगे, वह यहाँ दिखेगा।';

  @override
  String get jobsEmptyCompleted => 'अभी कोई पूरा काम नहीं';

  @override
  String get jobsEmptyCompletedBody =>
      'पूरे किए गए काम और उनसे आपकी कमाई यहाँ दिखेगी।';

  @override
  String get jobsEmptyCancelled => 'कुछ रद्द नहीं हुआ';

  @override
  String get jobsEmptyCancelledBody => 'रद्द हुए काम यहाँ दिखेंगे।';

  @override
  String get jobsEmptyOffers => 'कोई ऑफ़र नहीं';

  @override
  String get jobsEmptyOffersBody => 'नए काम यहाँ दिखेंगे।';

  @override
  String get jobTitleFallback => 'काम';

  @override
  String jobCancelledReason(Object reason) {
    return 'रद्द: $reason';
  }

  @override
  String get jobAmount => 'काम की राशि';

  @override
  String get jobMaterials => 'सामग्री';

  @override
  String get jobYouEarned => 'आपकी कमाई';

  @override
  String get jobRateCustomer => 'ग्राहक को रेटिंग दें';

  @override
  String get jobRateQuestion => 'यह काम आपके लिए कैसा रहा?';

  @override
  String get jobRate => 'रेटिंग दें';

  @override
  String get jobHistory => 'क्या-क्या हुआ';

  @override
  String get jobHistoryLoadFailed => 'काम का इतिहास लोड नहीं हो सका।';

  @override
  String get jobOfferExpired => 'यह काम अब उपलब्ध नहीं है।';

  @override
  String get jobOfferNewBadge => 'नया काम';

  @override
  String get jobOfferYouEarn => 'आपकी कमाई';

  @override
  String get jobOfferPriceAfterVisit => 'आने के बाद तय होगा';

  @override
  String get jobOfferAccept => 'काम स्वीकार करें';

  @override
  String get activeJobTitle => 'मौजूदा काम';

  @override
  String get activeJobEmptyBody =>
      'जब आप कोई काम स्वीकार करके शुरू करेंगे, वह यहाँ दिखेगा।';

  @override
  String get evidenceBeforeTitle => 'शुरू करने से पहले';

  @override
  String get evidenceBeforeBody =>
      'छूने से पहले समस्या की फ़ोटो लें। अगर ग्राहक बाद में काम पर विवाद करे तो यह आपकी रक्षा करता है।';

  @override
  String get evidenceAfterTitle => 'पूरा करने के बाद';

  @override
  String get evidenceAfterBody =>
      'पूरे हुए काम की फ़ोटो आपका सबूत है अगर ग्राहक बाद में विवाद करे। वैकल्पिक है, पर दस सेकंड देना ठीक है।';

  @override
  String get jobCustomerHidden =>
      'पुष्टि होने पर ग्राहक का विवरण साझा किया जाएगा';

  @override
  String get jobCall => 'कॉल करें';

  @override
  String get jobDirections => 'रास्ता';

  @override
  String get jobTrackOnMap => 'नक्शे पर देखें';

  @override
  String get trailAccepted => 'स्वीकार किया गया';

  @override
  String get trailOnTheWay => 'रास्ते में';

  @override
  String get trailArrived => 'पहुँच गए';

  @override
  String get trailArrivalConfirmed => 'पहुँचने की पुष्टि हुई';

  @override
  String get trailWorkStarted => 'काम शुरू हुआ';

  @override
  String get trailFinished => 'पूरा हुआ';

  @override
  String get jobProgress => 'प्रगति';

  @override
  String get jobBeforeFinish => 'पूरा करने से पहले';

  @override
  String get jobActionStartTravel => 'यात्रा शुरू करें';

  @override
  String get jobActionArrived => 'मैं पहुँच गया हूँ';

  @override
  String get jobActionEnterCode => 'पहुँचने का कोड दर्ज करें';

  @override
  String get jobActionStartWork => 'काम शुरू करें';

  @override
  String get jobActionFinish => 'काम पूरा करें';

  @override
  String get jobArrivalConfirmed => 'पहुँचने की पुष्टि हुई।';

  @override
  String get jobFinishTitle => 'यह काम पूरा करें?';

  @override
  String get jobFinishBody =>
      'ग्राहक से काम को मंज़ूरी देने को कहा जाएगा। इसके बाद आप फ़ोटो नहीं जोड़ पाएँगे।';

  @override
  String get jobOnYourWay => 'आप रास्ते में हैं।';

  @override
  String get jobMarkedArrived => 'पहुँचने का निशान लगा दिया गया।';

  @override
  String get jobWorkStarted => 'काम शुरू हुआ।';

  @override
  String get jobSentForApproval => 'मंज़ूरी के लिए ग्राहक को भेजा गया।';

  @override
  String get jobUpdated => 'अपडेट हो गया।';

  @override
  String get jobWaitConfirm => 'ग्राहक के बुकिंग की पुष्टि करने का इंतज़ार।';

  @override
  String get jobWaitApprove => 'ग्राहक के आपके काम को मंज़ूरी देने का इंतज़ार।';

  @override
  String get jobWaitPaymentProcessing =>
      'मंज़ूर हो गया। भुगतान की प्रक्रिया चल रही है।';

  @override
  String get jobWaitPayment => 'ग्राहक के भुगतान का इंतज़ार।';

  @override
  String get jobWaitPaid => 'भुगतान हो गया। आपकी कमाई आपके वॉलेट में दिखेगी।';

  @override
  String get jobWaitDisputed =>
      'हमारी टीम इस काम की समीक्षा कर रही है। हम आपसे संपर्क करेंगे।';

  @override
  String get jobWaitNothing => 'अभी कुछ करने को नहीं है।';

  @override
  String get travelRouteUnavailable => 'रास्ता उपलब्ध नहीं';

  @override
  String get travelNoDestination => 'कोई मंज़िल सेट नहीं';

  @override
  String get travelNoDestinationBody =>
      'इस काम का कोई सेवा स्थान नहीं है जहाँ तक रास्ता दिखाया जा सके।';

  @override
  String get travelJobLocation => 'काम का स्थान';

  @override
  String get travelYou => 'आप';

  @override
  String get travelCustomer => 'ग्राहक';

  @override
  String get travelCalculating => 'रास्ता निकाला जा रहा है...';

  @override
  String distanceMetres(Object metres) {
    return '$metres मी';
  }

  @override
  String etaMinutes(Object minutes) {
    return '$minutes मिनट';
  }

  @override
  String etaHours(Object hours) {
    return '$hours घंटे';
  }

  @override
  String get arrivalWrongCode => 'यह कोड सही नहीं है।';

  @override
  String arrivalWrongCodeAttempts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'यह कोड सही नहीं है। $count प्रयास बाकी हैं।',
      one: 'यह कोड सही नहीं है। 1 प्रयास बाकी है।',
    );
    return '$_temp0';
  }

  @override
  String get arrivalTitle => 'पुष्टि करें कि आप पहुँच गए हैं';

  @override
  String get arrivalBody =>
      'ग्राहक से उनके ऐप का कोड पढ़कर बताने को कहें, फिर उसे यहाँ लिखें।';

  @override
  String get arrivalLocked =>
      'बहुत बार गलत कोड डाला गया। यह काम जारी रखने के लिए कृपया सहायता से संपर्क करें।';

  @override
  String get arrivalConfirm => 'पहुँचने की पुष्टि करें';

  @override
  String get arrivalNotYet => 'अभी नहीं';

  @override
  String get rateThanks => 'आपकी प्रतिक्रिया के लिए धन्यवाद।';

  @override
  String get rateTitle => 'यह ग्राहक कैसा था?';

  @override
  String get rateBody =>
      'आपकी रेटिंग निजी है और हमें कर्मियों का ध्यान रखने में मदद करती है।';

  @override
  String get rateCommentLabel => 'कुछ और कहना है? (वैकल्पिक)';

  @override
  String get rateSubmit => 'रेटिंग भेजें';

  @override
  String get timerServiceTime => 'सेवा का समय';

  @override
  String get materialsAdd => 'जोड़ें';

  @override
  String get materialsLoadFailed => 'सामग्री लोड नहीं हो सकी।';

  @override
  String get materialsEmpty =>
      'अगर इस काम के लिए पुर्ज़े चाहिए, तो उन्हें यहाँ जोड़ें और ग्राहक से लागत मंज़ूर करने को कहा जाएगा।';

  @override
  String get materialStatusWaiting => 'ग्राहक का इंतज़ार';

  @override
  String get materialStatusApproved => 'मंज़ूर';

  @override
  String get materialStatusDeclined => 'मना किया';

  @override
  String get materialStatusBought => 'खरीदा';

  @override
  String get materialStatusCostRecorded => 'लागत दर्ज';

  @override
  String get materialStatusBilled => 'बिल में';

  @override
  String get materialStatusCancelled => 'रद्द';

  @override
  String materialQuantityEstimated(Object quantity, Object unit) {
    return '$quantity $unit · अनुमानित';
  }

  @override
  String materialQuantityActual(Object quantity, Object unit) {
    return '$quantity $unit · वास्तविक';
  }

  @override
  String get materialRecordCost => 'लागत दर्ज करें';

  @override
  String materialCustomerSaid(Object reason) {
    return 'ग्राहक ने कहा: $reason';
  }

  @override
  String get materialUnitPiece => 'नग';

  @override
  String get materialWhatNeeded => 'आपको क्या चाहिए?';

  @override
  String get materialEnterQuantity => 'कितने चाहिए, दर्ज करें';

  @override
  String get materialEnterCost => 'अनुमानित लागत दर्ज करें';

  @override
  String get materialRequestBody =>
      'खरीदने से पहले ग्राहक से इसे मंज़ूर करने को कहा जाएगा।';

  @override
  String get materialName => 'सामग्री';

  @override
  String get materialNameHint => 'जैसे 16A मॉड्यूलर स्विच';

  @override
  String get materialQuantity => 'मात्रा';

  @override
  String get materialUnit => 'इकाई';

  @override
  String get materialExpectedCost => 'अनुमानित लागत';

  @override
  String get materialAskCustomer => 'ग्राहक से पूछें';

  @override
  String get materialEnterPaid => 'आपने जितना भुगतान किया, वह राशि दर्ज करें';

  @override
  String get materialCostRecorded => 'लागत दर्ज हो गई।';

  @override
  String get materialWhatCost => 'इसकी लागत कितनी थी?';

  @override
  String get materialReceiptBody =>
      'रसीद जोड़ें ताकि इसे ग्राहक के बिल में जोड़ा जा सके।';

  @override
  String get materialAmountPaid => 'भुगतान की गई राशि';

  @override
  String get materialReceipt => 'रसीद';

  @override
  String get materialReceiptRequired => 'बिल की फ़ोटो ज़रूरी है।';

  @override
  String get evidenceDone => 'पूरा';

  @override
  String get evidenceRequired => 'ज़रूरी';

  @override
  String get evidenceCamera => 'कैमरा';

  @override
  String get evidenceGallery => 'गैलरी';

  @override
  String get evidenceSaved => 'सहेजा गया';

  @override
  String get uploadWaiting => 'इंतज़ार';

  @override
  String get uploadPreparing => 'तैयार हो रहा है';

  @override
  String get uploadStarting => 'अपलोड शुरू हो रहा है';

  @override
  String uploadPercent(Object percent) {
    return '$percent%';
  }

  @override
  String get uploadFinishing => 'पूरा हो रहा है';

  @override
  String get uploadCancel => 'अपलोड रद्द करें';

  @override
  String get uploadNotFinished => 'यह अपलोड पूरा नहीं हुआ।';

  @override
  String get commonRetry => 'फिर से कोशिश करें';

  @override
  String durationMinutes(Object minutes) {
    return '$minutes मिनट';
  }

  @override
  String durationHours(Object hours) {
    return '$hours घंटे';
  }

  @override
  String durationHoursMinutes(Object hours, Object minutes) {
    return '$hours घंटे $minutes मिनट';
  }

  @override
  String durationDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count दिन',
      one: '1 दिन',
    );
    return '$_temp0';
  }

  @override
  String pricePerHour(Object price) {
    return '$price/घंटा';
  }

  @override
  String pricePerDay(Object price) {
    return '$price/दिन';
  }

  @override
  String pricePerUnit(Object price) {
    return '$price/यूनिट';
  }

  @override
  String pricePerSqft(Object price) {
    return '$price/वर्ग फ़ुट';
  }

  @override
  String get gigsTitle => 'मेरी सेवाएँ';

  @override
  String get gigsAddTooltip => 'सेवा जोड़ें';

  @override
  String get gigsAdd => 'सेवा जोड़ें';

  @override
  String get gigsEmpty => 'अभी कोई सेवा नहीं';

  @override
  String get gigsEmptyBody =>
      'आप जो सेवाएँ देते हैं उन्हें जोड़ें। जितने कामों के लिए आप मंज़ूर हैं, उन सभी में जितनी चाहें उतनी सेवाएँ जोड़ सकते हैं।';

  @override
  String get gigsNoneLive =>
      'आपकी कोई भी सेवा चालू नहीं है, इसलिए ग्राहक आपको बुक नहीं कर सकते।';

  @override
  String gigsLiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count सेवाएँ चालू हैं।',
      one: '1 सेवा चालू है।',
    );
    return '$_temp0';
  }

  @override
  String get gigsAvailable => 'आप काम के लिए उपलब्ध हैं।';

  @override
  String get gigsOffDuty =>
      'आप ड्यूटी से बाहर हैं, इसलिए आपको काम नहीं दिए जाएँगे।';

  @override
  String gigJobsDone(int count) {
    return '$count पूरे';
  }

  @override
  String get gigEdit => 'बदलें';

  @override
  String get gigPause => 'रोकें';

  @override
  String get gigResume => 'फिर शुरू करें';

  @override
  String get gigInReview => 'समीक्षा में';

  @override
  String get gigDraftHint => 'ड्राफ़्ट — समीक्षा के लिए भेजें';

  @override
  String get gigRejectedHint => 'अस्वीकार — बदलकर फिर से भेजें';

  @override
  String get gigArchived => 'संग्रहित';

  @override
  String get gigNotLive => 'चालू नहीं';

  @override
  String get gigPaused => 'रोक दिया गया। आपको ये काम नहीं दिए जाएँगे।';

  @override
  String get gigLiveAgain => 'फिर से चालू।';

  @override
  String get gigDuration30m => '30 मिनट';

  @override
  String get gigDuration45m => '45 मिनट';

  @override
  String get gigDuration1h => '1 घंटा';

  @override
  String get gigDuration2h => '2 घंटे';

  @override
  String get gigDuration4h => '4 घंटे';

  @override
  String get gigDuration8h => '8 घंटे (एक कामकाजी दिन)';

  @override
  String get gigDuration24h => '24 घंटे';

  @override
  String get gigDuration2d => '2 दिन';

  @override
  String get gigDuration3d => '3 दिन';

  @override
  String get gigDuration1w => '1 हफ़्ता';

  @override
  String get gigSavedDraft => 'ड्राफ़्ट के रूप में सहेजा गया।';

  @override
  String get gigSubmitted => 'भेज दिया गया। हम इसकी समीक्षा करके आपको बताएँगे।';

  @override
  String get gigLive => 'आपकी सेवा चालू है।';

  @override
  String get gigSaved => 'सहेजा गया।';

  @override
  String get gigEditorAddTitle => 'सेवा जोड़ें';

  @override
  String get gigEditorEditTitle => 'सेवा बदलें';

  @override
  String get gigNoTrades => 'अभी कोई मंज़ूर काम नहीं';

  @override
  String get gigNoTradesBody =>
      'किसी काम के आपके लिए मंज़ूर होते ही आप उसके तहत सेवाएँ प्रकाशित कर सकते हैं। शुरू करने के लिए अपनी प्रोफ़ाइल से एक काम जोड़ें।';

  @override
  String get gigFieldTrade => 'कौन-सा काम?';

  @override
  String get gigFieldTitle => 'इस सेवा का नाम क्या है?';

  @override
  String get gigFieldTitleHint => 'ग्राहक इसे देखते हैं। साफ़-साफ़ लिखें।';

  @override
  String get gigFieldTitleExample => 'जैसे स्प्लिट AC की गहरी सफ़ाई';

  @override
  String get gigFieldDescription => 'इसमें क्या-क्या शामिल है?';

  @override
  String get gigFieldDescriptionHint =>
      'वैकल्पिक, पर इससे ग्राहकों को आपको चुनने में मदद मिलती है।';

  @override
  String get gigFieldDescriptionExample =>
      'जैसे इनडोर और आउटडोर यूनिट की पूरी सफ़ाई, फ़िल्टर धुलाई, गैस प्रेशर की जाँच।';

  @override
  String get gigFieldPrice => 'आप कितना लेते हैं?';

  @override
  String get gigFieldPriceHint =>
      'हर सेवा की अपनी कीमत होती है। इसका आपकी बाकी सेवाओं पर असर नहीं पड़ता।';

  @override
  String get gigUnitPerJob => 'प्रति काम';

  @override
  String get gigUnitPerHour => 'प्रति घंटा';

  @override
  String get gigUnitPerDay => 'प्रति दिन';

  @override
  String get gigUnitPerUnit => 'प्रति यूनिट';

  @override
  String get gigUnitPerSqft => 'प्रति वर्ग फ़ुट';

  @override
  String get gigFieldDuration => 'इसमें आमतौर पर कितना समय लगता है?';

  @override
  String get gigFieldRadius => 'इसके लिए आप कितनी दूर जाएँगे?';

  @override
  String get gigFieldRadiusHint =>
      'अपनी सामान्य यात्रा दूरी इस्तेमाल करने के लिए डिफ़ॉल्ट रहने दें।';

  @override
  String get gigUsualDistance => 'आपकी सामान्य दूरी';

  @override
  String get gigUseUsualDistance => 'मेरी सामान्य दूरी इस्तेमाल करें';

  @override
  String get gigReviewNotice =>
      'नई और बदली गई सेवाओं को चालू होने से पहले हमारी टीम जाँचती है। जाँच पूरी होते ही हम आपको बताएँगे।';

  @override
  String get gigSaveDraft => 'ड्राफ़्ट सहेजें';

  @override
  String get gigSubmitForReview => 'समीक्षा के लिए भेजें';

  @override
  String get walletAllTransactions => 'सभी लेन-देन';

  @override
  String get walletFrozen =>
      'किसी बात की जाँच के दौरान निकासी रोकी गई है। विवरण के लिए सहायता से संपर्क करें।';

  @override
  String get walletWithdraw => 'निकालें';

  @override
  String walletNothingPending(Object amount) {
    return 'अभी निकालने को कुछ नहीं है। $amount की प्रक्रिया चल रही है और उन कामों की मंज़ूरी के बाद यह आपके बैलेंस में आ जाएगा।';
  }

  @override
  String get walletNothingYet =>
      'अभी निकालने को कुछ नहीं है। ग्राहक के पूरे काम को मंज़ूरी देने पर आपकी कमाई यहाँ दिखेगी।';

  @override
  String get walletRecentEarnings => 'हाल की कमाई';

  @override
  String get walletNoEarnings => 'अभी कोई कमाई नहीं';

  @override
  String get walletNoEarningsBody =>
      'पूरे हुए काम का भुगतान होने पर आपकी कमाई यहाँ दिखेगी।';

  @override
  String get walletAvailable => 'निकालने के लिए उपलब्ध';

  @override
  String get walletProcessing => 'प्रक्रिया में';

  @override
  String get walletProcessingHint => 'रोक अवधि के बाद जारी होगा';

  @override
  String get walletTotalEarned => 'कुल कमाई';

  @override
  String get statementTitle => 'स्टेटमेंट';

  @override
  String get statementTabTransactions => 'लेन-देन';

  @override
  String get statementTabWithdrawals => 'निकासी';

  @override
  String get statementEmpty => 'अभी कुछ नहीं';

  @override
  String get statementEmptyBody =>
      'काम शुरू करने के बाद हर भुगतान, शुल्क और निकासी यहाँ दिखेगी।';

  @override
  String statementBalance(Object amount) {
    return 'बैलेंस $amount';
  }

  @override
  String get statementNoWithdrawals => 'अभी कोई निकासी नहीं';

  @override
  String get statementNoWithdrawalsBody =>
      'जब आप पैसे निकालेंगे, तो उसकी जानकारी यहाँ दिखेगी।';

  @override
  String payoutRequestedAt(Object date) {
    return '$date को अनुरोध किया';
  }

  @override
  String payoutPaidAt(Object date) {
    return '$date को भुगतान हुआ';
  }

  @override
  String get payoutEnterAmount => 'कितना निकालना चाहते हैं, दर्ज करें';

  @override
  String payoutUpTo(Object amount) {
    return 'आप अभी $amount तक निकाल सकते हैं';
  }

  @override
  String payoutMinimum(Object amount) {
    return 'सबसे कम निकासी $amount है';
  }

  @override
  String payoutRequested(Object amount) {
    return '$amount निकालने का अनुरोध किया गया। प्रक्रिया आगे बढ़ने पर हम आपको बताते रहेंगे।';
  }

  @override
  String get payoutAvailableNow => 'अभी उपलब्ध';

  @override
  String payoutPendingMore(Object amount) {
    return '$amount और की प्रक्रिया चल रही है और इसे अभी नहीं निकाला जा सकता।';
  }

  @override
  String get payoutHowMuch => 'कितना?';

  @override
  String get payoutAll => 'सभी';

  @override
  String payoutPercent(Object percent) {
    return '$percent%';
  }

  @override
  String get payoutProcessNotice =>
      'निकासी की जाँच होती है और फिर आपके पंजीकृत बैंक खाते में भेजी जाती है। हर चरण की स्थिति आपको यहाँ दिखेगी।';

  @override
  String get payoutRequest => 'निकासी का अनुरोध करें';

  @override
  String get bankChecking => 'आपका बैंक खाता जाँचा जा रहा है…';

  @override
  String bankPaidTo(Object last4) {
    return '$last4 पर खत्म होने वाले खाते में भुगतान';
  }

  @override
  String get bankVerifiedFallback => 'आपका सत्यापित बैंक खाता';

  @override
  String get bankBeingVerified => 'बैंक खाते का सत्यापन हो रहा है';

  @override
  String get bankBeingVerifiedBody =>
      'हमारी टीम के सत्यापन के बाद आप पैसे निकाल सकते हैं।';

  @override
  String get bankNotVerified => 'बैंक खाता सत्यापित नहीं हुआ';

  @override
  String get bankNotVerifiedBody => 'अपना विवरण जाँचें और फिर से भेजें।';

  @override
  String get bankAddTitle => 'बैंक खाता जोड़ें';

  @override
  String get bankAddBody =>
      'निकासी उसी बैंक खाते में भेजी जाती है जिसे हमारी टीम ने सत्यापित किया है।';

  @override
  String get bankAddAction => 'बैंक खाता जोड़ें';

  @override
  String get verificationTitle => 'सत्यापन';

  @override
  String get verificationProgress => 'सत्यापित जाँचें';

  @override
  String verificationCount(int approved, int total) {
    return '$total में से $approved';
  }

  @override
  String get verificationInsurance => 'बीमा';

  @override
  String get verificationNoCover => 'कोई चालू बीमा नहीं';

  @override
  String get verificationNoCoverBody =>
      'अभी हमारे पास आपकी कोई बीमा पॉलिसी दर्ज नहीं है।';

  @override
  String get verifyIdentity => 'पहचान';

  @override
  String get verifyIdentityBody =>
      'एक सरकारी पहचान पत्र, ताकि ग्राहकों को पता हो कि उनके घर कौन आ रहा है।';

  @override
  String get verifyAddress => 'पता';

  @override
  String get verifyAddressBody => 'आप कहाँ रहते हैं, इसका प्रमाण।';

  @override
  String get verifyIti => 'ITI प्रमाणपत्र';

  @override
  String get verifyItiBody =>
      'औद्योगिक प्रशिक्षण संस्थान (ITI) से आपका ट्रेड प्रमाणपत्र।';

  @override
  String get verifyDiploma => 'डिप्लोमा';

  @override
  String get verifyDiplomaBody => 'मान्यता प्राप्त तकनीकी डिप्लोमा।';

  @override
  String get verifyRpl => 'कौशल मूल्यांकन';

  @override
  String get verifyRplBody =>
      'पूर्व शिक्षा की मान्यता (RPL): आपके अनुभव का मूल्यांकन और प्रमाणन।';

  @override
  String get verifyBackground => 'पृष्ठभूमि जाँच';

  @override
  String get verifyBackgroundBody =>
      'यह हम खुद करते हैं। आपको कुछ करने की ज़रूरत नहीं है।';

  @override
  String get verifyInsuranceBody =>
      'काम के दौरान दुर्घटना से होने वाले नुकसान का बीमा। व्यवस्था होने पर हमारी टीम आपकी पॉलिसी जोड़ती है।';

  @override
  String get verifyBank => 'बैंक खाता';

  @override
  String get verifyBankBody => 'जहाँ आपकी निकासी भेजी जाती है।';

  @override
  String verificationValidUntil(Object date) {
    return '$date तक मान्य';
  }

  @override
  String get verificationStart => 'शुरू करें';

  @override
  String get verificationUpdate => 'अपडेट करें';

  @override
  String get policyActive => 'चालू';

  @override
  String get policyNotActive => 'चालू नहीं';

  @override
  String get policyNumber => 'पॉलिसी';

  @override
  String get policyCover => 'बीमा राशि';

  @override
  String get policyValidUntil => 'तक मान्य';

  @override
  String get kycStillWaiting =>
      'DigiLocker का अभी भी इंतज़ार है। आप बाद में यहाँ से फिर देख सकते हैं।';

  @override
  String get kycTitle => 'पहचान की जाँच';

  @override
  String get kycHeadline => 'पुष्टि करें कि आप कौन हैं';

  @override
  String get kycIntro =>
      'ग्राहक आपको अपने घर में आने देते हैं, इसलिए हम हर कर्मी की पहचान DigiLocker से सत्यापित करते हैं, जो भारत सरकार का दस्तावेज़ प्लेटफ़ॉर्म है। कुछ भी अपलोड नहीं होता — आप बस अपने आधार खाते पर अनुरोध को मंज़ूरी देते हैं।';

  @override
  String get kycPrivacy =>
      'आपके आधार का विवरण सीधे DigiLocker से पुष्ट होता है। हम केवल वही रखते हैं जो साबित करे कि जाँच हुई — आपकी फ़ोटो या आधार की कॉपी कभी नहीं।';

  @override
  String get kycVerified => 'आपकी पहचान सत्यापित हो गई है।';

  @override
  String get kycAwaitingConsent =>
      'अपने ब्राउज़र में DigiLocker की सहमति पूरी करें, फिर यहाँ वापस आएँ।';

  @override
  String get kycChecking => 'DigiLocker से जाँच हो रही है…';

  @override
  String get kycStart => 'DigiLocker से सत्यापित करें';

  @override
  String get qualSubmitted => 'समीक्षा के लिए भेजा गया।';

  @override
  String get qualTitle => 'आपकी योग्यता';

  @override
  String get qualIti => 'ITI';

  @override
  String get qualInstitute => 'संस्थान';

  @override
  String get qualInstituteHint => 'जैसे सरकारी ITI, कोयंबटूर';

  @override
  String get qualName => 'योग्यता';

  @override
  String get qualNameHint => 'जैसे इलेक्ट्रीशियन';

  @override
  String get qualSpeciality => 'विशेषज्ञता (वैकल्पिक)';

  @override
  String get qualSpecialityHint => 'जैसे औद्योगिक वायरिंग';

  @override
  String get qualYear => 'पूरा करने का साल';

  @override
  String get qualCertificate => 'आपका प्रमाणपत्र';

  @override
  String get qualCertificateBody => 'प्रमाणपत्र की साफ़ फ़ोटो या PDF।';

  @override
  String get bankErrorHolder => 'नाम ठीक वैसा ही दर्ज करें जैसा खाते में है';

  @override
  String get bankErrorNumber => 'खाता संख्या 9 से 18 अंकों की होती है';

  @override
  String get bankErrorMismatch => 'खाता संख्याएँ मेल नहीं खातीं';

  @override
  String get bankErrorIfsc => '11 अक्षरों का IFSC दर्ज करें, जैसे SBIN0001234';

  @override
  String get bankSent => 'बैंक खाता सत्यापन के लिए भेजा गया।';

  @override
  String get bankNotice =>
      'आपकी निकासी इस खाते में भेजी जाती है। पहली निकासी से पहले हमारी टीम इसे सत्यापित करती है।';

  @override
  String get bankHolder => 'खाताधारक का नाम';

  @override
  String get bankNumber => 'खाता संख्या';

  @override
  String get bankConfirmNumber => 'खाता संख्या फिर से दर्ज करें';

  @override
  String get bankIfsc => 'IFSC कोड';

  @override
  String get bankIfscHint => 'जैसे SBIN0001234';

  @override
  String get bankName => 'बैंक का नाम (वैकल्पिक)';

  @override
  String get bankSubmit => 'सत्यापन के लिए भेजें';

  @override
  String get profileCompleteness => 'प्रोफ़ाइल कितनी पूरी है';

  @override
  String get profileCompletenessBody =>
      'पूरी प्रोफ़ाइल से ग्राहकों को आपको चुनने में मदद मिलती है।';

  @override
  String get profileJobsDone => 'पूरे काम';

  @override
  String get profileRating => 'रेटिंग';

  @override
  String get profileExperience => 'अनुभव';

  @override
  String profileExperienceYears(Object years) {
    return '$years साल';
  }

  @override
  String get profileEdit => 'प्रोफ़ाइल बदलें';

  @override
  String get profileVerified => 'सत्यापित';

  @override
  String get profileNotVerified => 'सत्यापित नहीं';

  @override
  String get profilePinInvalid => 'सही 6 अंकों का पिन कोड दर्ज करें';

  @override
  String get profileUpdated => 'प्रोफ़ाइल अपडेट हो गई।';

  @override
  String get profilePhotoUpdated => 'फ़ोटो अपडेट हो गई।';

  @override
  String get profileChangePhoto => 'फ़ोटो बदलें';

  @override
  String get profileName => 'नाम';

  @override
  String get profilePhone => 'फ़ोन';

  @override
  String get profileLockedNotice =>
      'आपका नाम और नंबर आपकी पहचान जाँच से जुड़े हैं। इनमें से कुछ भी बदलना हो तो सहायता से संपर्क करें।';

  @override
  String get profileAbout => 'आपके बारे में';

  @override
  String get profileBioHint =>
      'ग्राहकों को अपने अनुभव और अपनी खूबियों के बारे में बताएँ।';

  @override
  String get profileYearsExperience => 'अनुभव के साल';

  @override
  String get profileBased => 'आप कहाँ रहते हैं';

  @override
  String get profileAddress => 'पता';

  @override
  String get profileCity => 'शहर';

  @override
  String get profilePin => 'पिन कोड';

  @override
  String get profileGender => 'लिंग';

  @override
  String get genderMale => 'पुरुष';

  @override
  String get genderFemale => 'महिला';

  @override
  String get genderOther => 'अन्य';

  @override
  String get profileTrades => 'आपके काम';

  @override
  String get profileTradesBody =>
      'आप उन सभी कामों में काम कर सकते हैं जिनके लिए आप मंज़ूर हैं।';

  @override
  String get profileTradesLoadFailed => 'आपके काम लोड नहीं हो सके।';

  @override
  String get tradePending => 'बाकी';

  @override
  String get profileAddTrade => 'काम जोड़ें';

  @override
  String get profileAddTradeBody =>
      'मंज़ूरी से पहले हम आपके कौशल का प्रमाण माँग सकते हैं।';

  @override
  String get profileTradeRequested =>
      'अनुरोध भेजा गया। मंज़ूरी मिलते ही हम आपको बताएँगे।';

  @override
  String get profileSave => 'बदलाव सहेजें';

  @override
  String get supportNewRequest => 'नया अनुरोध';

  @override
  String get supportEmpty => 'अभी कोई अनुरोध नहीं';

  @override
  String get supportEmptyBody =>
      'अगर किसी काम, भुगतान या आपके खाते में कुछ गड़बड़ हो, तो अनुरोध बनाएँ और हम मदद करेंगे।';

  @override
  String get supportYourRequests => 'आपके अनुरोध';

  @override
  String get supportEmergency => 'आपातकाल में';

  @override
  String get supportEmergencyBody =>
      'यह ऐप आपकी ओर से मदद नहीं बुला सकता। अगर आप खतरे में हैं, तो सीधे आपातकालीन सेवाओं को कॉल करें।';

  @override
  String get supportCall112 => '112 पर कॉल करें';

  @override
  String get supportPolice => 'पुलिस';

  @override
  String get ticketOpen => 'खुला';

  @override
  String get ticketInProgress => 'प्रगति में';

  @override
  String get ticketReplyNeeded => 'आपका जवाब चाहिए';

  @override
  String get ticketResolved => 'हल हो गया';

  @override
  String get ticketClosed => 'बंद';

  @override
  String ticketLastUpdate(Object date) {
    return 'आखिरी अपडेट $date';
  }

  @override
  String get supportCategoryJob => 'कोई काम';

  @override
  String get supportCategoryPayment => 'कोई भुगतान';

  @override
  String get supportCategoryWithdrawal => 'कोई निकासी';

  @override
  String get supportCategoryAccount => 'मेरा खाता';

  @override
  String get supportCategorySafety => 'सुरक्षा';

  @override
  String get supportCategoryApp => 'ऐप';

  @override
  String get supportCategoryOther => 'कुछ और';

  @override
  String supportRaised(Object code) {
    return 'अनुरोध $code बनाया गया।';
  }

  @override
  String get supportHowHelp => 'हम कैसे मदद करें?';

  @override
  String get supportAbout => 'यह किस बारे में है?';

  @override
  String get supportSubject => 'विषय';

  @override
  String get supportSubjectHint => 'समस्या के बारे में कुछ शब्द';

  @override
  String get supportWhatHappened => 'क्या हुआ?';

  @override
  String get supportSend => 'अनुरोध भेजें';

  @override
  String get ticketTitle => 'सहायता अनुरोध';

  @override
  String get ticketNoMessages => 'अभी कोई संदेश नहीं';

  @override
  String get ticketNoMessagesBody => 'आपकी बातचीत यहाँ दिखेगी।';

  @override
  String get ticketWriteMessage => 'संदेश लिखें';

  @override
  String get ticketSupportName => 'Wervexa सहायता';

  @override
  String get requestsTitle => 'ग्राहकों के अनुरोध';

  @override
  String get requestsRefresh => 'रीफ़्रेश करें';

  @override
  String get requestsLocationNeeded => 'लोकेशन चाहिए';

  @override
  String get requestsLocationBody =>
      'हम आपके पास के ग्राहक अनुरोध खोजने के लिए आपकी लोकेशन इस्तेमाल करते हैं।';

  @override
  String get requestsGrantLocation => 'लोकेशन की अनुमति दें';

  @override
  String get requestsEmpty => 'आस-पास कोई मेल खाता अनुरोध नहीं';

  @override
  String get requestsEmptyBody =>
      'आपकी सेवाओं से मेल खाने पर\nनए ग्राहक अनुरोध यहाँ दिखेंगे।';

  @override
  String get requestsViewOffer => 'देखें और ऑफ़र दें →';

  @override
  String get requestEnterPrice => 'सही कीमत दर्ज करें';

  @override
  String requestOfferSubmitted(Object price) {
    return '$price पर ऑफ़र भेजा गया!';
  }

  @override
  String get requestDetailsTitle => 'अनुरोध का विवरण';

  @override
  String get requestStatusOpen => 'खुला';

  @override
  String get requestCategory => 'श्रेणी';

  @override
  String get requestBudget => 'बजट';

  @override
  String get requestSchedule => 'समय';

  @override
  String get requestDistance => 'दूरी';

  @override
  String get requestArea => 'इलाका';

  @override
  String get requestOffers => 'ऑफ़र';

  @override
  String get requestNotes => 'नोट्स';

  @override
  String get requestAddressPrivacy =>
      'ग्राहक का सटीक पता उनके आपका ऑफ़र स्वीकार करने के बाद ही साझा किया जाता है।';

  @override
  String get requestYourOffer => 'आपका ऑफ़र';

  @override
  String get requestYourPrice => 'आपकी कीमत (₹)';

  @override
  String get requestPriceHint => 'जैसे 500';

  @override
  String get requestDuration => 'अनुमानित समय (वैकल्पिक)';

  @override
  String get requestDurationHint => 'जैसे 1-2 घंटे';

  @override
  String get requestMessage => 'ग्राहक के लिए संदेश (वैकल्पिक)';

  @override
  String get requestMessageHint => 'इस काम के लिए आप सही व्यक्ति क्यों हैं?';

  @override
  String get requestSubmitOffer => 'ऑफ़र भेजें';

  @override
  String get requestMakeOffer => 'ऑफ़र दें';

  @override
  String get requestAlreadyOffered =>
      'आप इस अनुरोध पर पहले ही ऑफ़र भेज चुके हैं।';

  @override
  String get requestViewOffers => 'ऑफ़र देखें';

  @override
  String get offersEmptyBody =>
      'ग्राहक अनुरोधों पर भेजे गए आपके ऑफ़र\nयहाँ दिखेंगे।';

  @override
  String get offerWithdraw => 'निकालें';

  @override
  String get offerWithdrawTitle => 'ऑफ़र वापस लें?';

  @override
  String get offerWithdrawBody => 'ग्राहक को यह ऑफ़र अब नहीं दिखेगा।';

  @override
  String get offerWithdrawn => 'ऑफ़र वापस लिया गया';

  @override
  String get onboardingTitle => 'अपनी प्रोफ़ाइल सेट करें';

  @override
  String get onboardingHelp => 'मदद';

  @override
  String onboardingHello(Object name) {
    return 'नमस्ते, $name';
  }

  @override
  String get onboardingIntro =>
      'बस कुछ चीज़ें और आप काम पाना शुरू करने के लिए तैयार हैं।';

  @override
  String get onboardingSetup => 'सेटअप';

  @override
  String onboardingStepCount(int done, int total) {
    return '$total में से $done';
  }

  @override
  String get onboardingBasicBody =>
      'आपका शहर और पिन कोड, ताकि हम आपके पास काम खोज सकें।';

  @override
  String get onboardingTradeBody => 'वह काम जो आप मुख्य रूप से करते हैं।';

  @override
  String get onboardingSkillsDoneBody =>
      'आपका मुख्य काम इनमें से एक गिना जाता है। बाकी सभी काम जोड़ने के लिए इसे खोलें।';

  @override
  String get onboardingSkillsBody =>
      'आप जो भी काम करते हैं, सब जोड़ें। आप एक काम तक सीमित नहीं हैं।';

  @override
  String get onboardingAreaBody =>
      'किसी काम के लिए आप कितनी दूर जाने को तैयार हैं।';

  @override
  String get onboardingKycBody =>
      'एक सरकारी पहचान पत्र। ग्राहक आपको अपने घर में आने दे रहे हैं।';

  @override
  String get onboardingReviewNotice =>
      'ये पूरे करने के बाद हमारी टीम आपके दस्तावेज़ जाँचती है। इंतज़ार के दौरान आप अपनी सेवाएँ सेट करते रह सकते हैं।';

  @override
  String get onboardingTradesLoadFailed =>
      'काम लोड नहीं हो सके। फिर से कोशिश करें।';

  @override
  String get onboardingMainTrade => 'आपका मुख्य काम क्या है?';

  @override
  String get onboardingMainTradeBody => 'आप बाद में और काम जोड़ सकते हैं।';

  @override
  String onboardingTradeSet(Object trade) {
    return '$trade आपका मुख्य काम सेट किया गया।';
  }

  @override
  String get onboardingTravelTitle => 'आप कितनी दूर जाएँगे?';

  @override
  String get onboardingTravelBody =>
      'हम आपको केवल आपकी मौजूदा जगह से इतनी दूरी के भीतर के काम देंगे।';

  @override
  String get onboardingTravelCentre =>
      'हम आपकी मौजूदा लोकेशन को केंद्र मानते हैं। आप इसे कभी भी अपनी प्रोफ़ाइल से बदल सकते हैं।';

  @override
  String get onboardingLocationOff =>
      'अपना काम का इलाका सेट करने के लिए लोकेशन की अनुमति चालू करें।';

  @override
  String get commonSave => 'सहेजें';

  @override
  String get notificationsStayOff =>
      'सूचनाएँ बंद रहेंगी। आप इन्हें अपने फ़ोन की सेटिंग्स में चालू कर सकते हैं।';

  @override
  String get notificationsPrimerTitle => 'काम आते ही सूचना पाएँ';

  @override
  String get notificationsPrimerBody =>
      'काम के ऑफ़र की समय-सीमा होती है। ऐप बंद होने पर सूचना से ही आपको पता चलता है — और कुछ नहीं भेजा जाता।';

  @override
  String get notificationsTurnOn => 'सूचनाएँ चालू करें';

  @override
  String get commonNotNow => 'अभी नहीं';

  @override
  String get onboardingCityRequired => 'कृपया अपना शहर दर्ज करें';

  @override
  String get onboardingGenderRequired => 'कृपया अपना लिंग चुनें';

  @override
  String get onboardingWhereBased => 'आप कहाँ रहते हैं?';
}
