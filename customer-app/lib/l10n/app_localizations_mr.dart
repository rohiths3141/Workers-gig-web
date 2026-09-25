// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Marathi (`mr`).
class AppLocalizationsMr extends AppLocalizations {
  AppLocalizationsMr([String locale = 'mr']) : super(locale);

  @override
  String get commonRetry => 'पुन्हा प्रयत्न करा';

  @override
  String get commonTryAgain => 'पुन्हा प्रयत्न करा';

  @override
  String get commonSignOut => 'साइन आउट करा';

  @override
  String get assistantFabLabel => 'AI ला विचारा';

  @override
  String get navHome => 'होम';

  @override
  String get navExplore => 'शोधा';

  @override
  String get navBookings => 'बुकिंग';

  @override
  String get navAlerts => 'सूचना';

  @override
  String get navProfile => 'प्रोफाइल';

  @override
  String get configErrorTitle => 'ॲप कॉन्फिगर केलेले नाही';

  @override
  String configErrorBody(String keys, String command) {
    return 'या बिल्डमध्ये $keys नाही. असे चालवा:\n\n$command\n\nजेणेकरून ॲप खऱ्या बॅकएंडपर्यंत पोहोचू शकेल.';
  }

  @override
  String get sessionProfileLoadFailedRetry =>
      'आम्ही तुमचे प्रोफाइल लोड करू शकलो नाही. कृपया पुन्हा प्रयत्न करा.';

  @override
  String get sessionProfileLoadFailed =>
      'आम्ही तुमचे प्रोफाइल लोड करू शकलो नाही';

  @override
  String get sessionCheckClock => 'तुमच्या फोनचे घड्याळ तपासा';

  @override
  String get splashTagline => 'घरगुती सेवा, योग्य पद्धतीने.';

  @override
  String get timelineBookingConfirmed => 'बुकिंगची पुष्टी झाली';

  @override
  String get timelineProviderOnTheWay => 'सेवा देणारे वाटेत आहेत';

  @override
  String get timelineServiceInProgress => 'सेवा सुरू आहे';

  @override
  String get timelineCompleted => 'पूर्ण झाले';

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
  String get errorSessionEnded =>
      'तुमचे सत्र संपले आहे. कृपया पुन्हा साइन इन करा.';

  @override
  String get errorUploadFailed =>
      'ती फाइल अपलोड होऊ शकली नाही. पुन्हा प्रयत्न करा.';

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
  String get authErrorPhoneNotEnabled =>
      'फोनद्वारे साइन-इन सुरू नाही. सहाय्याशी संपर्क साधा.';

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
  String get languagePickerTitle => 'तुमची भाषा निवडा';

  @override
  String get authCouldNotStartVerification =>
      'पडताळणी सुरू होऊ शकली नाही. कृपया पुन्हा प्रयत्न करा.';

  @override
  String get authWelcomeTitle => 'Wervexa मध्ये स्वागत आहे';

  @override
  String get authWelcomeSubtitle =>
      'घरदुरुस्ती, प्लंबिंग, इलेक्ट्रिकल, स्वच्छता आणि बरेच काही यासाठी जवळचे उत्तम व्यावसायिक शोधा.';

  @override
  String get authEnterPhone => 'तुमचा फोन नंबर टाका';

  @override
  String get authInvalidMobile => 'वैध 10 अंकी मोबाइल नंबर टाका';

  @override
  String get authGetOtp => 'OTP पडताळणी मिळवा';

  @override
  String get authTermsNotice =>
      'पुढे जाऊन तुम्ही आमच्या सेवा अटी आणि गोपनीयता धोरणाशी सहमत होता';

  @override
  String get authNewCodeSent => 'आम्ही नवीन कोड पाठवला आहे.';

  @override
  String get authVerifyPhoneTitle => 'फोन पडताळा';

  @override
  String get authChangeNumber => 'नंबर बदला';

  @override
  String get authEnterCodeTitle => '6 अंकी कोड टाका';

  @override
  String authCodeSentTo(Object phone) {
    return 'आम्ही $phone वर SMS पडताळणी कोड पाठवला आहे';
  }

  @override
  String get authWrongNumber => 'चुकीचा नंबर? बदला';

  @override
  String get authEnterSixDigits => 'कृपया 6 अंक टाका';

  @override
  String get authResendCode => 'कोड पुन्हा पाठवा';

  @override
  String authResendCodeIn(Object seconds) {
    return '$seconds सेकंदांत कोड पुन्हा पाठवा';
  }

  @override
  String get authVerifyAndContinue => 'पडताळा आणि पुढे जा';

  @override
  String get registerTitle => 'प्रोफाइल पूर्ण करा';

  @override
  String get registerHeading => 'तुमचे नाव सांगा';

  @override
  String get registerNameVisibility =>
      'तुम्ही बुकिंगची विनंती केल्यावर तुमचे नाव सेवा कर्मचाऱ्यांना दिसेल.';

  @override
  String get registerFullNameLabel => 'पूर्ण नाव *';

  @override
  String get registerFullNameHint => 'उदा. राहुल शर्मा';

  @override
  String get registerFullNameRequired => 'कृपया तुमचे पूर्ण नाव टाका';

  @override
  String get registerEmailLabel => 'ईमेल पत्ता (ऐच्छिक)';

  @override
  String get registerEmailHint => 'उदा. rahul@example.com';

  @override
  String get registerSubmit => 'जतन करा आणि सुरू करा';

  @override
  String get bookingStatusRequested => 'व्यावसायिक शोधत आहोत…';

  @override
  String get bookingStatusAccepted => 'व्यावसायिक मिळाले';

  @override
  String get bookingStatusConfirmed => 'पुष्टी झाली';

  @override
  String get bookingStatusTraveling => 'वाटेत';

  @override
  String get bookingStatusArrived => 'पोहोचले — तुमचा कोड टाका';

  @override
  String get bookingStatusInProgress => 'काम सुरू आहे';

  @override
  String get bookingStatusAwaitingApproval =>
      'काम पूर्ण — पुढे जाण्यासाठी मंजुरी द्या';

  @override
  String get bookingStatusCompleted => 'पूर्ण झाले';

  @override
  String get bookingStatusPaymentPending => 'पेमेंट बाकी';

  @override
  String get bookingStatusPaid => 'पेमेंट झाले';

  @override
  String get bookingStatusClosed => 'बंद';

  @override
  String get bookingStatusCancelled => 'रद्द';

  @override
  String get bookingStatusDisputed => 'वादग्रस्त';

  @override
  String get bookingStatusExpired => 'मुदत संपली — कोणीही उपलब्ध नव्हते';

  @override
  String get pricingPerJob => 'प्रति काम';

  @override
  String get pricingPerHour => 'प्रति तास';

  @override
  String get pricingPerDay => 'प्रति दिवस';

  @override
  String get pricingPerUnit => 'प्रति युनिट';

  @override
  String get pricingPerSqft => 'प्रति चौ. फूट';

  @override
  String get supportCategoryBooking => 'बुकिंगशी संबंधित समस्या';

  @override
  String get supportCategoryPayment => 'पेमेंट';

  @override
  String get supportCategoryPayout => 'पेआउट';

  @override
  String get supportCategoryVerification => 'पडताळणी';

  @override
  String get supportCategoryAccount => 'माझे खाते';

  @override
  String get supportCategorySafety => 'सुरक्षेची चिंता';

  @override
  String get supportCategoryClaim => 'विमा दावा';

  @override
  String get supportCategoryAppIssue => 'ॲपमधील समस्या';

  @override
  String get supportCategoryOther => 'इतर';

  @override
  String get requestStatusDraft => 'मसुदा';

  @override
  String get requestStatusOpen => 'खुले — ऑफरची वाट';

  @override
  String get requestStatusReceivingOffers => 'ऑफर येत आहेत';

  @override
  String get requestStatusWorkerSelected => 'व्यावसायिक निवडले';

  @override
  String get requestStatusBooked => 'बुक झाले';

  @override
  String get requestStatusCancelled => 'रद्द';

  @override
  String get requestStatusExpired => 'मुदत संपली';

  @override
  String get requestStatusClosed => 'बंद';

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
  String get scheduleSpecificDate => 'ठरावीक तारखेला';

  @override
  String get scheduleScheduled => 'नियोजित';

  @override
  String get offerStatusSubmitted => 'नवीन ऑफर';

  @override
  String get offerStatusViewed => 'पाहिले';

  @override
  String get offerStatusShortlisted => 'निवड यादीत';

  @override
  String get offerStatusAccepted => 'स्वीकारले';

  @override
  String get offerStatusRejected => 'नाकारले';

  @override
  String get offerStatusWithdrawn => 'कर्मचाऱ्याने मागे घेतले';

  @override
  String get offerStatusExpired => 'मुदत संपली';

  @override
  String get offerStatusClosed => 'बंद';

  @override
  String get gigRatingNew => 'नवीन';

  @override
  String distanceMetres(Object metres) {
    return '$metres मी';
  }

  @override
  String distanceKm(Object km) {
    return '$km किमी';
  }

  @override
  String durationMinutes(Object minutes) {
    return '$minutes मिनिटे';
  }

  @override
  String durationHours(Object hours) {
    return '$hours तास';
  }

  @override
  String durationHoursMinutes(int hours, int minutes) {
    return '$hours तास $minutes मिनिटे';
  }

  @override
  String get offerWorkerFallbackName => 'व्यावसायिक';

  @override
  String get budgetFlexible => 'लवचिक बजेट';

  @override
  String get budgetFixed => 'ठरलेले बजेट';

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
  String get paymentsNotConfigured =>
      'या बिल्डसाठी पेमेंट अद्याप कॉन्फिगर केलेले नाही.';

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
  String get addressLabelHome => 'होम';

  @override
  String get addressLabelWork => 'ऑफिस';

  @override
  String get addressLabelOther => 'इतर';

  @override
  String get commonSeeAll => 'सर्व पहा';

  @override
  String get commonViewAll => 'सर्व पहा';

  @override
  String get commonCheckBackLater => 'कृपया नंतर पुन्हा पहा.';

  @override
  String get commonUseCurrentLocation => 'सध्याचे स्थान वापरा';

  @override
  String get commonChooseOnMap => 'नकाशावर निवडा';

  @override
  String homeGreetingNamed(Object name) {
    return 'नमस्कार, $name 👋';
  }

  @override
  String get homeGreeting => 'नमस्कार 👋';

  @override
  String get homeWhatService => 'आज तुम्हाला कोणती सेवा हवी आहे?';

  @override
  String get homeSetLocation => 'तुमचे स्थान सेट करा';

  @override
  String get homeWorkFinishedApprove => 'काम पूर्ण — मंजुरीसाठी टॅप करा';

  @override
  String get homeCategories => 'श्रेणी';

  @override
  String homeCategoriesLoadFailed(Object error) {
    return 'श्रेणी लोड होऊ शकल्या नाहीत: $error';
  }

  @override
  String get homeFindWorker => 'कर्मचारी शोधा';

  @override
  String get homeFindWorkerSubtitle => 'जवळच्या सेवा पहा';

  @override
  String get homePostRequest => 'विनंती पोस्ट करा';

  @override
  String get homePostRequestSubtitle => 'कर्मचारी तुमच्याकडे येतात';

  @override
  String get homeNoServices => 'सध्या कोणतीही सेवा उपलब्ध नाही';

  @override
  String get homeSearchNear => 'येथे जवळ सेवा शोधा';

  @override
  String get homeSearchHint => 'सेवा शोधा...';

  @override
  String homeActiveBooking(Object code) {
    return 'सुरू असलेले बुकिंग #$code';
  }

  @override
  String get homeActiveRequests => 'तुमच्या सुरू असलेल्या विनंत्या';

  @override
  String get commonGrantPermission => 'परवानगी द्या';

  @override
  String get commonView => 'पहा';

  @override
  String get exploreTitle => 'सेवा शोधा आणि पहा';

  @override
  String get exploreListView => 'यादी दृश्य';

  @override
  String get exploreMapView => 'नकाशा दृश्य';

  @override
  String get exploreSearchHint => 'सेवा, कर्मचारी किंवा कौशल्ये शोधा...';

  @override
  String get exploreLocationOffTitle => 'स्थान सेवा बंद आहेत';

  @override
  String get exploreLocationOffMessage =>
      'जवळचे व्यावसायिक शोधण्यासाठी स्थान सुरू करा.';

  @override
  String get exploreLocationPermissionTitle => 'स्थानाची परवानगी हवी';

  @override
  String get exploreLocationPermissionMessage =>
      'जवळचे व्यावसायिक शोधण्यासाठी आम्ही तुमचे स्थान वापरतो.';

  @override
  String get exploreChooseService => 'शोधण्यासाठी सेवा निवडा';

  @override
  String get exploreChooseServiceMessage =>
      'जवळचे व्यावसायिक पाहण्यासाठी वरील श्रेणी निवडा.';

  @override
  String get exploreNoProfessionals =>
      'या सेवेसाठी जवळ कोणतेही व्यावसायिक उपलब्ध नाहीत';

  @override
  String get exploreLoadFailed => 'व्यावसायिक लोड होऊ शकले नाहीत.';

  @override
  String exploreByWorker(Object name) {
    return '$name यांच्याकडून';
  }

  @override
  String get bookingsTitle => 'माझी सेवा बुकिंग';

  @override
  String get bookingsTabActive => 'सुरू';

  @override
  String get bookingsTabCompleted => 'पूर्ण झाले';

  @override
  String get bookingsTabCancelled => 'रद्द';

  @override
  String get bookingsLoadFailed => 'तुमची बुकिंग लोड होऊ शकली नाहीत.';

  @override
  String get bookingsEmpty => 'अद्याप बुकिंग नाही';

  @override
  String get bookingsFindService => 'सेवा शोधा';

  @override
  String get bookingsWaitingForProfessional => 'व्यावसायिकाची वाट';

  @override
  String bookingsCode(Object code) {
    return 'बुकिंग कोड: #$code';
  }

  @override
  String get bookingsPayNow => 'आत्ता पेमेंट करा';

  @override
  String get bookingsApproveWork => 'कामाला मंजुरी द्या';

  @override
  String get bookingsTrackLive => 'लाइव्ह ट्रॅक करा';

  @override
  String get bookingsDetails => 'तपशील';

  @override
  String get bookingDetailTitle => 'बुकिंग तपशील';

  @override
  String get bookingDetailLoadFailed => 'बुकिंग तपशील लोड होऊ शकला नाही.';

  @override
  String get bookingDetailWaitingAccept => 'व्यावसायिक स्वीकारण्याची वाट';

  @override
  String bookingDetailNumber(Object code) {
    return 'बुकिंग #$code';
  }

  @override
  String bookingDetailStatus(Object status) {
    return 'स्थिती: $status';
  }

  @override
  String get bookingDetailLiveMap => 'लाइव्ह नकाशा';

  @override
  String get bookingDetailServiceInfo => 'सेवा विनंतीची माहिती';

  @override
  String get bookingDetailViewMaterials =>
      'साहित्य / सुट्या भागांच्या विनंत्या पहा';

  @override
  String get bookingDetailFareDetails => 'भाड्याचा तपशील';

  @override
  String get bookingDetailEstimatedFare => 'अंदाजे भाडे';

  @override
  String get bookingDetailFinalFare => 'अंतिम निश्चित भाडे';

  @override
  String get bookingDetailRateReview =>
      'सेवा कर्मचाऱ्याला रेटिंग व अभिप्राय द्या';

  @override
  String get bookingDetailApproveCompletion => 'काम पूर्ण झाल्याला मंजुरी द्या';

  @override
  String get bookingDetailApprovePaidHint =>
      'तुमच्या व्यावसायिकाने हे काम पूर्ण म्हणून चिन्हांकित केले आहे. मंजुरी दिल्यावर तुमचे पेमेंट त्यांना दिले जाईल.';

  @override
  String get bookingDetailApproveUnpaidHint =>
      'तुमच्या व्यावसायिकाने हे काम पूर्ण म्हणून चिन्हांकित केले आहे. पुष्टी करून पेमेंटकडे जाण्यासाठी मंजुरी द्या.';

  @override
  String get bookingDetailReportProblem => 'समस्या कळवा';

  @override
  String get bookingDetailCompletionApproved =>
      'काम पूर्ण झाल्याला मंजुरी मिळाली';

  @override
  String bookingDetailPayToConfirm(Object amount) {
    return 'पुष्टीसाठी $amount भरा';
  }

  @override
  String get bookingDetailSentAfterPayment =>
      'पेमेंट पूर्ण झाल्यावर तुमचे बुकिंग व्यावसायिकाला पाठवले जाईल.';

  @override
  String bookingDetailPayAmount(Object amount) {
    return '$amount भरा';
  }

  @override
  String get bookingDetailCancelBooking => 'बुकिंग रद्द करा';

  @override
  String get cancelReasonMistake => 'चुकून बुक झाले';

  @override
  String get cancelReasonNoLongerNeeded => 'मला आता या सेवेची गरज नाही';

  @override
  String get cancelReasonDifferentTime => 'मला वेगळी वेळ निवडायची आहे';

  @override
  String get cancelReasonFoundSomeoneElse => 'मला दुसरे कोणी मिळाले';

  @override
  String get cancelDialogTitle => 'तुम्ही का रद्द करत आहात?';

  @override
  String get cancelDialogRefundNotice =>
      'हे पूर्ववत करता येणार नाही. तुमचे पेमेंट मूळ पेमेंट पद्धतीत परत केले जाईल.';

  @override
  String get cancelDialogCannotUndo => 'हे पूर्ववत करता येणार नाही.';

  @override
  String get cancelDialogKeepBooking => 'बुकिंग ठेवा';

  @override
  String get bookingCancelledRefund =>
      'बुकिंग रद्द झाले. तुमच्या परताव्याची विनंती केली आहे.';

  @override
  String get bookingCancelled => 'बुकिंग रद्द झाले';

  @override
  String get arrivalCodeTitle => 'आगमन कोड';

  @override
  String get arrivalCodeShare =>
      'व्यावसायिक पोहोचल्याची पुष्टी करण्यासाठी हा कोड त्यांना सांगा:';

  @override
  String get arrivalCodeUnavailable => 'उपलब्ध नाही';

  @override
  String get arrivalCodeLoadFailed => 'कोड लोड होऊ शकला नाही';

  @override
  String get activeBookingTitle => 'लाइव्ह बुकिंग आणि कर्मचारी ट्रॅकिंग';

  @override
  String get activeBookingLoadFailed => 'हे बुकिंग लोड होऊ शकले नाही.';

  @override
  String get activeBookingMapUnavailable =>
      'या बुकिंगसाठी लाइव्ह नकाशा उपलब्ध नाही.';

  @override
  String get activeBookingViewDetails => 'बुकिंग तपशील पहा';

  @override
  String get activeBookingServiceLocation => 'सेवेचे ठिकाण';

  @override
  String get activeBookingYourProfessional => 'तुमचे व्यावसायिक';

  @override
  String get activeBookingLive => 'लाइव्ह';

  @override
  String get activeBookingLastKnown => 'शेवटचे माहीत असलेले ठिकाण';

  @override
  String get activeBookingPhoneNotShared => 'फोन अद्याप शेअर केलेला नाही';

  @override
  String get activeBookingCallProfessional => 'व्यावसायिकाला कॉल करा';

  @override
  String get activeBookingMaterials => 'साहित्य';

  @override
  String get activeBookingViewDetailsShort => 'तपशील पहा';

  @override
  String get locationConnecting => 'लाइव्ह स्थानाशी जोडत आहे...';

  @override
  String get locationLiveUnavailable => 'लाइव्ह स्थान तात्पुरते उपलब्ध नाही';

  @override
  String get locationLiveActive => 'लाइव्ह स्थान सुरू आहे';

  @override
  String get locationUpdating => 'अपडेट होत आहे...';

  @override
  String get locationUnavailable => 'स्थान तात्पुरते उपलब्ध नाही';

  @override
  String get activeBookingShareStartCode =>
      'कर्मचारी पोहोचले! सुरुवातीचा कोड सांगा:';

  @override
  String get commonBack => 'मागे';

  @override
  String get paymentCouldNotOpen =>
      'पेमेंट स्क्रीन उघडू शकली नाही. कृपया पुन्हा प्रयत्न करा.';

  @override
  String get paymentReceived =>
      'पेमेंट मिळाले. तुमचे बुकिंग व्यावसायिकाला पाठवले आहे.';

  @override
  String paymentNotConfirmed(String reason, String reference) {
    return 'आम्ही या पेमेंटची पुष्टी करू शकलो नाही: $reason. पैसे कापले गेले असल्यास $reference संदर्भासह सहाय्याशी संपर्क साधा.';
  }

  @override
  String get paymentNotCompleted => 'पेमेंट पूर्ण झाले नाही.';

  @override
  String paymentExternalWalletUnsupported(Object wallet) {
    return 'बाह्य वॉलेट ($wallet) निवडले — ते अद्याप समर्थित नाही.';
  }

  @override
  String get paymentTitle => 'पेमेंट';

  @override
  String get paymentStatusUnknown =>
      'या बुकिंगचे पेमेंट आधीच झाले आहे का ते आम्ही तपासू शकलो नाही. दोनदा पेमेंट करण्याऐवजी कृपया पुन्हा प्रयत्न करा.';

  @override
  String get paymentBookingLoadFailed => 'हे बुकिंग लोड होऊ शकले नाही.';

  @override
  String get paymentComplete => 'पेमेंट पूर्ण';

  @override
  String paymentPaidFor(String amount, String service) {
    return '$service साठी $amount भरले.';
  }

  @override
  String get paymentViewBooking => 'बुकिंग पहा';

  @override
  String get paymentBookingSummary => 'बुकिंग सारांश';

  @override
  String get paymentProvider => 'सेवा देणारे';

  @override
  String get paymentService => 'सेवा';

  @override
  String get paymentDate => 'तारीख';

  @override
  String get paymentTime => 'वेळ';

  @override
  String get paymentAddress => 'पत्ता';

  @override
  String get paymentTotal => 'एकूण';

  @override
  String get paymentHeldSecurely =>
      'तुमचे पेमेंट सुरक्षित ठेवले जाते आणि तुम्ही कामाला मंजुरी दिल्यानंतरच व्यावसायिकाला दिले जाते. काम सुरू होण्यापूर्वी बुकिंग रद्द झाल्यास तुम्हाला परतावा मिळतो.';

  @override
  String get commonChange => 'बदला';

  @override
  String get bookMissingDetails =>
      'बुकिंगचा तपशील अपूर्ण आहे — कृपया पुन्हा सुरू करा.';

  @override
  String get bookSlotPassed =>
      'ती वेळ निघून गेली आहे. आम्ही तुम्हाला पुढील उपलब्ध वेळेवर नेले आहे — तपासा आणि पुन्हा पुष्टी करा.';

  @override
  String bookFailed(Object reason) {
    return 'बुकिंग अयशस्वी: $reason';
  }

  @override
  String get bookNoAddress => 'कोणताही पत्ता निवडलेला नाही';

  @override
  String get bookTitle => 'सेवा बुक करा';

  @override
  String get bookSelectDate => 'तारीख निवडा';

  @override
  String get bookSelectTime => 'वेळ निवडा';

  @override
  String get bookSpecialInstructions => 'विशेष सूचना (ऐच्छिक)';

  @override
  String get bookSpecialInstructionsHint =>
      'उदा. स्वयंपाकघर आणि बाथरूमवर लक्ष द्या...';

  @override
  String get bookConfirm => 'बुकिंगची पुष्टी करा →';

  @override
  String get gigUnknownProfessional => 'अज्ञात व्यावसायिक';

  @override
  String get gigNewProfessional => 'नवीन व्यावसायिक';

  @override
  String gigRatingWithCount(String rating, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count अभिप्राय',
      one: '1 अभिप्राय',
    );
    return '$rating ($_temp0)';
  }

  @override
  String get gigPricing => 'किंमत';

  @override
  String get gigServiceRate => 'सेवा दर';

  @override
  String get gigFinalAmountNote =>
      'अंतिम रक्कम तुमचे व्यावसायिक निश्चित करतात आणि बुकिंग तयार झाल्यावर त्यात दिसते.';

  @override
  String get gigKycVerified => 'KYC पडताळलेले';

  @override
  String get gigBackgroundVerified => 'पार्श्वभूमी पडताळलेली';

  @override
  String get gigBookNow => 'आत्ता बुक करा →';

  @override
  String get discoveryTitle => 'उपलब्ध व्यावसायिक';

  @override
  String get discoveryMissingDetails => 'सेवा किंवा स्थानाचा तपशील नाही.';

  @override
  String get discoveryLocalExperts => 'उपलब्ध स्थानिक तज्ज्ञ';

  @override
  String get discoveryWithin => 'अंतराच्या आत';

  @override
  String get discoveryNoProviders => 'जवळ कोणतेही सेवा देणारे उपलब्ध नाहीत';

  @override
  String get discoveryTryLargerRadius =>
      'मोठे शोध अंतर वापरून पहा किंवा नंतर पुन्हा पहा.';

  @override
  String get discoveryLoadFailed => 'जवळचे सेवा देणारे लोड होऊ शकले नाहीत.';

  @override
  String discoveryServicesForJob(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'या कामासाठी $count सेवा',
      one: 'या कामासाठी 1 सेवा',
    );
    return '$_temp0';
  }

  @override
  String get discoveryBook => 'बुक करा';

  @override
  String get categoryServiceDetails => 'सेवेचा तपशील';

  @override
  String get categoryTagline =>
      'आधीच ठरलेली किंमत आणि सेवा हमीसह पडताळलेले, पार्श्वभूमी तपासलेले स्थानिक तज्ज्ञ बुक करा.';

  @override
  String get categoryWhatHelp => 'तुम्हाला कशासाठी मदत हवी आहे?';

  @override
  String get categoryDescribeElse => 'दुसरे काहीतरी सांगा';

  @override
  String get categoryLoadFailed => 'ही सेवा लोड होऊ शकली नाही.';

  @override
  String get notificationsTitle => 'सूचना आणि अलर्ट';

  @override
  String get notificationsEmpty => 'तुम्ही सर्व पाहिले आहे';

  @override
  String get notificationsLoadFailed => 'सूचना लोड होऊ शकल्या नाहीत.';

  @override
  String get timeJustNow => 'आत्ताच';

  @override
  String timeMinutesAgo(Object minutes) {
    return '$minutes मिनिटांपूर्वी';
  }

  @override
  String timeHoursAgo(Object hours) {
    return '$hours तासांपूर्वी';
  }

  @override
  String get timeYesterday => 'काल';

  @override
  String get completedTitle => 'सेवा पूर्ण झाली!';

  @override
  String get completedThanks => 'आमच्या सेवा वापरल्याबद्दल धन्यवाद.';

  @override
  String get completedViewBookings => 'बुकिंग पहा';

  @override
  String get completedBackHome => 'होमवर परत जा';

  @override
  String commonErrorDetail(Object detail) {
    return 'त्रुटी: $detail';
  }

  @override
  String get reviewTitle => 'तुमच्या अनुभवाला रेटिंग द्या';

  @override
  String get reviewHeading => 'उत्तम सेवा!';

  @override
  String get reviewQuestion => 'तुमच्या व्यावसायिकासोबतचा अनुभव कसा होता?';

  @override
  String reviewStars(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count तारे',
      one: '1 तारा',
    );
    return '$_temp0';
  }

  @override
  String get reviewCommentHint => 'तुमच्या अनुभवाबद्दल सांगा...';

  @override
  String get reviewSubmit => 'अभिप्राय पाठवा →';

  @override
  String get materialsTitle => 'साहित्य / सुट्या भागांच्या विनंत्या';

  @override
  String get materialsEmpty =>
      'या बुकिंगसाठी साहित्याची कोणतीही विनंती आलेली नाही';

  @override
  String materialsQuantityEstimated(Object quantity) {
    return '$quantity · अंदाजे';
  }

  @override
  String materialsQuantityActual(Object quantity) {
    return '$quantity · प्रत्यक्ष';
  }

  @override
  String get materialsReject => 'नाकारा';

  @override
  String get materialsApprove => 'मंजूर करा';

  @override
  String get materialStatusRequested => 'विनंती केली';

  @override
  String get materialStatusCustomerReview => 'तुमच्या पुनरावलोकनाची वाट';

  @override
  String get materialStatusApproved => 'मंजूर';

  @override
  String get materialStatusRejected => 'नाकारले';

  @override
  String get materialStatusPurchased => 'खरेदी केले';

  @override
  String get materialStatusCostRecorded => 'खर्च नोंदवला';

  @override
  String get materialStatusBilled => 'बिलात जोडले';

  @override
  String get materialStatusCancelled => 'रद्द';

  @override
  String get commonSaveChanges => 'बदल जतन करा';

  @override
  String get profileTitle => 'माझे प्रोफाइल आणि खाते';

  @override
  String get profileFallbackName => 'ग्राहक प्रोफाइल';

  @override
  String get profileLanguage => 'भाषा';

  @override
  String get profileAddresses => 'जतन केलेले सेवा पत्ते';

  @override
  String get profileAddressesSubtitle =>
      'घर, ऑफिस आणि इतर पत्ते व्यवस्थापित करा';

  @override
  String get profileHistory => 'मागील सेवांचा इतिहास';

  @override
  String get profileHistorySubtitle => 'पावत्या आणि मागील बुकिंग पहा';

  @override
  String get profileSupport => 'मदत आणि ग्राहक सहाय्य';

  @override
  String get profileSupportSubtitle =>
      'तिकीट तयार करा, आमच्या टीमची उत्तरे पहा';

  @override
  String get editProfileSaved => 'प्रोफाइल यशस्वीरित्या अपडेट झाले';

  @override
  String get editProfileTitle => 'प्रोफाइल संपादित करा';

  @override
  String get editProfileFullName => 'पूर्ण नाव';

  @override
  String get editProfileNameEmpty => 'नाव रिकामे असू शकत नाही';

  @override
  String get editProfileEmail => 'ईमेल पत्ता';

  @override
  String get commonEdit => 'संपादित करा';

  @override
  String get commonDelete => 'हटवा';

  @override
  String get addressesAdd => 'नवीन पत्ता जोडा';

  @override
  String get addressesEmpty => 'तुम्ही अद्याप कोणताही पत्ता जतन केलेला नाही';

  @override
  String get addressesEmptyMessage =>
      'पुढच्या वेळी पटकन बुक करण्यासाठी सेवा पत्ता जोडा.';

  @override
  String get addressesDefaultBadge => 'डीफॉल्ट';

  @override
  String get addressesSetDefault => 'डीफॉल्ट म्हणून सेट करा';

  @override
  String get addressesLoadFailed => 'पत्ते लोड होऊ शकले नाहीत.';

  @override
  String get addressesLabelSheet => 'या पत्त्याला नाव द्या';

  @override
  String get supportTitle => 'मदत आणि सहाय्य';

  @override
  String get supportNewTicket => 'नवीन तिकीट';

  @override
  String get supportEmpty => 'अद्याप सहाय्य तिकीट नाही';

  @override
  String get supportEmptyMessage =>
      'बुकिंग किंवा ॲपबद्दल मदत हवी आहे? तिकीट तयार करा, आमची टीम उत्तर देईल.';

  @override
  String get supportLoadFailed => 'तुमची सहाय्य तिकिटे लोड होऊ शकली नाहीत.';

  @override
  String get supportStatusOpen => 'खुले';

  @override
  String get supportStatusInProgress => 'प्रगतीत';

  @override
  String get supportStatusWaitingForYou => 'तुमची वाट';

  @override
  String get supportStatusResolved => 'सोडवले';

  @override
  String get supportStatusClosed => 'बंद';

  @override
  String get supportNewTicketTitle => 'नवीन सहाय्य तिकीट';

  @override
  String get supportCategory => 'श्रेणी';

  @override
  String get supportSubject => 'विषय';

  @override
  String get supportDescribeIssue => 'समस्या सांगा';

  @override
  String get supportFillSubjectMessage => 'कृपया विषय आणि संदेश भरा.';

  @override
  String get supportSubmitTicket => 'तिकीट पाठवा';

  @override
  String get supportTicketTitle => 'सहाय्य तिकीट';

  @override
  String get supportNoMessages => 'अद्याप संदेश नाहीत';

  @override
  String get supportMessagesLoadFailed => 'संदेश लोड होऊ शकले नाहीत.';

  @override
  String get supportTypeMessage => 'संदेश लिहा...';

  @override
  String get supportSend => 'पाठवा';

  @override
  String get pickerEnterAddress =>
      'कृपया या पिनसाठी पत्ता टाका किंवा पुष्टी करा';

  @override
  String get pickerTitle => 'सेवेचा पत्ता निवडा';

  @override
  String get pickerGettingLocation => 'तुमचे स्थान मिळवत आहोत...';

  @override
  String get pickerPermissionDenied =>
      'स्थानाची परवानगी नाकारली — पत्ता निवडण्यासाठी नकाशा स्वतः हलवा.';

  @override
  String get pickerConfirmPin => 'सेवा पिनच्या जागेची पुष्टी करा';

  @override
  String get pickerAddressLabel => 'घर / फ्लॅट / रस्त्याचे नाव';

  @override
  String get pickerAddressHint => 'उदा. #102, ग्रीन ॲव्हेन्यू, इंदिरानगर';

  @override
  String get pickerLandmarkLabel => 'खूण (ऐच्छिक)';

  @override
  String get pickerLandmarkHint => 'उदा. HDFC बँक ATM जवळ';

  @override
  String get pickerConfirm => 'स्थानाची पुष्टी करा आणि पुढे जा';

  @override
  String get requestSelectLocation => 'कृपया सेवेचे ठिकाण निवडा';

  @override
  String requestTitle(Object service) {
    return '$service ची विनंती करा';
  }

  @override
  String get requestServiceAddress => 'सेवेचा पत्ता';

  @override
  String get requestDetectingLocation => 'तुमचे स्थान शोधत आहोत…';

  @override
  String get requestTapToPickLocation => 'सेवेचे ठिकाण निवडण्यासाठी टॅप करा';

  @override
  String get requestDescribeIssue => 'समस्या / काम सांगा';

  @override
  String get requestDescribeHint =>
      'उदा. दिवाणखान्यातील मुख्य छताच्या दिव्याचे बटण सुरू केल्यावर ठिणगी पडते.';

  @override
  String get requestDescribeMin => 'कृपया समस्या किमान 10 अक्षरांत सांगा';

  @override
  String get requestAttachPhotos => 'समस्येचे फोटो जोडा (ऐच्छिक)';

  @override
  String get requestAddPhoto => 'फोटो जोडा';

  @override
  String get requestWhen => 'तुम्हाला सेवा केव्हा हवी आहे?';

  @override
  String get requestInstant => '⚡ लगेच (30 मिनिटे)';

  @override
  String get requestScheduleLater => '📅 नंतरसाठी ठरवा';

  @override
  String get requestFindWorkers => 'उपलब्ध कर्मचारी शोधा';

  @override
  String commonLoadFailedDetail(Object detail) {
    return 'लोड होऊ शकले नाही: $detail';
  }

  @override
  String get myRequestsTitle => 'माझ्या सेवा विनंत्या';

  @override
  String get myRequestsTabAll => 'सर्व';

  @override
  String get myRequestsNew => 'नवीन विनंती';

  @override
  String get myRequestsNoActive => 'सुरू असलेल्या विनंत्या नाहीत';

  @override
  String get myRequestsNoCompleted => 'पूर्ण झालेल्या विनंत्या नाहीत';

  @override
  String get myRequestsNone => 'अद्याप सेवा विनंत्या नाहीत';

  @override
  String get myRequestsEmptyMessage =>
      'तुमची गरज पोस्ट करा आणि कर्मचाऱ्यांना तुमच्याकडे येऊ द्या.';

  @override
  String get requestDetailTitle => 'विनंतीचा तपशील';

  @override
  String get requestDetailBudget => 'बजेट';

  @override
  String get requestDetailSchedule => 'वेळापत्रक';

  @override
  String get requestDetailLocation => 'स्थान';

  @override
  String get requestDetailNotes => 'नोंदी';

  @override
  String get requestDetailCancel => 'विनंती रद्द करा';

  @override
  String requestDetailOffersReceived(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ऑफर मिळाल्या',
      one: '1 ऑफर मिळाली',
      zero: 'अद्याप ऑफर नाहीत',
    );
    return '$_temp0';
  }

  @override
  String get requestDetailTapToCompare =>
      'पाहण्यासाठी आणि तुलना करण्यासाठी टॅप करा';

  @override
  String get requestDetailWorkersSoon => 'कर्मचारी लवकरच प्रतिसाद देऊ लागतील';

  @override
  String get requestCancelDialogTitle => 'ही विनंती रद्द करायची?';

  @override
  String get requestCancelDialogBody =>
      'सर्व प्रलंबित ऑफर बंद केल्या जातील. हे पूर्ववत करता येणार नाही.';

  @override
  String get requestCancelKeep => 'ठेवा';

  @override
  String get requestCancelConfirm => 'विनंती रद्द करा';

  @override
  String get requestCancelled => 'विनंती रद्द झाली';

  @override
  String requestExpiresInDaysHours(int days, int hours) {
    return '$days दिवस $hours तासांत मुदत संपेल';
  }

  @override
  String requestExpiresInHoursMinutes(int hours, int minutes) {
    return '$hours तास $minutes मिनिटांत मुदत संपेल';
  }

  @override
  String requestExpiresInMinutes(Object minutes) {
    return '$minutes मिनिटांत मुदत संपेल';
  }

  @override
  String get requestExpiresSoon => 'लवकरच मुदत संपेल';

  @override
  String get commonCancel => 'रद्द करा';

  @override
  String get offersTitle => 'मिळालेल्या ऑफर';

  @override
  String get offersEmptyMessage =>
      'कर्मचारी तुमची विनंती पाहत आहेत. कोणी प्रतिसाद दिल्यावर तुम्हाला कळवले जाईल.';

  @override
  String get offersPending => 'प्रलंबित ऑफर';

  @override
  String get offersPast => 'मागील ऑफर';

  @override
  String offersJobsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count कामे',
      one: '1 काम',
    );
    return '$_temp0';
  }

  @override
  String get offersInsured => 'विमा असलेले';

  @override
  String get offersDecline => 'नाकारा';

  @override
  String get offersAcceptOffer => 'ऑफर स्वीकारा';

  @override
  String get offersAcceptDialogTitle => 'ही ऑफर स्वीकारायची?';

  @override
  String offersAcceptDialogBody(String worker, String price) {
    return '$worker यांच्यासोबत $price ला बुकिंग तयार होईल. इतर सर्व ऑफर बंद केल्या जातील.';
  }

  @override
  String get offersAccept => 'स्वीकारा';

  @override
  String offersBookingCreated(Object code) {
    return 'बुकिंग $code तयार झाले!';
  }

  @override
  String get commonNext => 'पुढे';

  @override
  String postRequestPosted(Object code) {
    return 'सेवा विनंती $code पोस्ट झाली!';
  }

  @override
  String get postRequestTitle => 'सेवा विनंती पोस्ट करा';

  @override
  String get postRequestWhatService => 'तुम्हाला कोणती सेवा हवी आहे?';

  @override
  String get postRequestSelectCategory =>
      'तुमची गरज सर्वात चांगल्या प्रकारे सांगणारी श्रेणी निवडा.';

  @override
  String get postRequestDescribe => 'तुमची गरज सांगा';

  @override
  String postRequestServiceLabel(Object service) {
    return 'सेवा: $service';
  }

  @override
  String get postRequestWhatDone => 'तुम्हाला काय करून हवे आहे?';

  @override
  String get postRequestFieldTitle => 'शीर्षक';

  @override
  String get postRequestTitleHint =>
      'उदा. स्वयंपाकघरातील गळणारा नळ दुरुस्त करणे';

  @override
  String postRequestMinChars(Object count) {
    return 'किमान $count अक्षरे टाका';
  }

  @override
  String get postRequestFieldDescription => 'वर्णन';

  @override
  String get postRequestDescriptionHint => 'समस्या सविस्तर सांगा…';

  @override
  String get postRequestFieldNotes => 'अतिरिक्त नोंदी (ऐच्छिक)';

  @override
  String get postRequestNotesHint => 'गेट कोड, पसंतीची वेळ इ.';

  @override
  String get postRequestBudgetTitle => 'तुमचे बजेट';

  @override
  String get postRequestBudgetHint =>
      'तुम्ही किती देण्यास तयार आहात याची कर्मचाऱ्यांना कल्पना द्या.';

  @override
  String get postRequestFixedPrice => 'ठरलेली किंमत (₹)';

  @override
  String postRequestExample(Object example) {
    return 'उदा. $example';
  }

  @override
  String get postRequestMin => 'किमान (₹)';

  @override
  String get postRequestMax => 'कमाल (₹)';

  @override
  String get postRequestWhenTitle => 'तुम्हाला हे केव्हा हवे आहे?';

  @override
  String get postRequestPickDate => 'तारीख निवडा';

  @override
  String get postRequestLocationTitle => 'सेवेचे ठिकाण';

  @override
  String get postRequestAddressPrivate =>
      'तुमचा नेमका पत्ता ऑफर स्वीकारल्यानंतरच शेअर केला जातो.';

  @override
  String get postRequestFullAddress => 'पूर्ण पत्ता';

  @override
  String get postRequestValidAddress => 'वैध पत्ता टाका';

  @override
  String get postRequestCity => 'शहर';

  @override
  String get postRequestCityHint => 'उदा. बंगळुरू';

  @override
  String get postRequestPincode => 'पिनकोड';

  @override
  String get postRequestLocationSet => 'स्थान सेट झाले ✓';

  @override
  String get postRequestSetOnMap => 'नकाशावर स्थान सेट करा';

  @override
  String get postRequestReviewTitle => 'तुमची विनंती तपासा';

  @override
  String get postRequestNotSelected => 'निवडलेले नाही';

  @override
  String get postRequestWhen => 'केव्हा';

  @override
  String get postRequestPrivacyNote =>
      'तुम्ही ऑफर स्वीकारून बुकिंग तयार होईपर्यंत तुमचा नेमका पत्ता खाजगी राहतो.';

  @override
  String get postRequestSubmit => 'विनंती पाठवा';

  @override
  String get assistantOpening =>
      'काय बिघडले आहे ते तुमच्या शब्दांत सांगा — मी त्यासाठी योग्य व्यावसायिक शोधून देईन.';

  @override
  String assistantCatalogueFailed(Object reason) {
    return '$reason याचे उत्तर देण्यासाठी मला सेवांची यादी हवी आहे.';
  }

  @override
  String get assistantCatalogueError =>
      'सेवांची यादी लोड करताना काहीतरी चूक झाली.';

  @override
  String get assistantGreeting =>
      'नमस्कार. घरात कशासाठी मदत हवी आहे? गळणारा नळ, थंड न करणारा AC, ठिणगी टाकणारे बटण — काहीही असो, तुम्हाला हवे तसे सांगा.';

  @override
  String get assistantTooVague =>
      'मी मदत करू शकतो — फक्त समस्या काय आहे ते कळायला हवे. काय काम करत नाही?';

  @override
  String assistantMultipleJobs(int count) {
    return 'ही $count वेगवेगळी कामे वाटतात — त्यांना वेगवेगळे कारागीर लागतील. प्रत्येक इथे आहे:';
  }

  @override
  String get assistantAmbiguous =>
      'मला हे बरोबर करायचे आहे — हे एकापेक्षा जास्त कामांत जाऊ शकते. कोणते जास्त जवळचे आहे?';

  @override
  String get assistantUnmatched =>
      'प्लॅटफॉर्मवरील कोणत्याही सेवेशी मी हे जुळवू शकलो नाही. सर्वात जवळची निवडा, मी तुमचे वर्णन तिथे नेईन — किंवा विनंती म्हणून पोस्ट करा आणि व्यावसायिकांना तुमच्याकडे येऊ द्या.';

  @override
  String assistantConfidentWithProblem(String service, String problem) {
    return 'हे $service चे काम वाटते — बहुधा \"$problem\".';
  }

  @override
  String assistantConfident(Object service) {
    return 'हे $service चे काम वाटते.';
  }

  @override
  String assistantChosen(Object service) {
    return 'ठीक आहे, $service. तुम्ही लिहिलेले वर्णन जसेच्या तसे पाठवले जाईल.';
  }

  @override
  String get assistantTitle => 'सेवा सहाय्यक';

  @override
  String get assistantSubtitle => 'तुमच्या समस्येसाठी योग्य काम शोधतो';

  @override
  String get assistantStartOver => 'पुन्हा सुरू करा';

  @override
  String assistantMatchedOn(Object terms) {
    return 'जुळलेले शब्द: $terms';
  }

  @override
  String get assistantFindWorkers => 'कर्मचारी शोधा';

  @override
  String get assistantPostRequest => 'विनंती पोस्ट करा';

  @override
  String get assistantInputHint => 'समस्या सांगा...';
}
