// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get commonRetry => 'फिर से कोशिश करें';

  @override
  String get commonTryAgain => 'फिर से कोशिश करें';

  @override
  String get commonSignOut => 'साइन आउट करें';

  @override
  String get assistantFabLabel => 'AI से पूछें';

  @override
  String get navHome => 'होम';

  @override
  String get navExplore => 'खोजें';

  @override
  String get navBookings => 'बुकिंग';

  @override
  String get navAlerts => 'सूचनाएँ';

  @override
  String get navProfile => 'प्रोफ़ाइल';

  @override
  String get configErrorTitle => 'ऐप कॉन्फ़िगर नहीं है';

  @override
  String configErrorBody(String keys, String command) {
    return 'इस बिल्ड में $keys नहीं है। इसे इस तरह चलाएँ:\n\n$command\n\nताकि ऐप असली बैकएंड तक पहुँच सके।';
  }

  @override
  String get sessionProfileLoadFailedRetry =>
      'हम आपकी प्रोफ़ाइल लोड नहीं कर सके। कृपया फिर से कोशिश करें।';

  @override
  String get sessionProfileLoadFailed => 'हम आपकी प्रोफ़ाइल लोड नहीं कर सके';

  @override
  String get sessionCheckClock => 'अपने फ़ोन की घड़ी जाँचें';

  @override
  String get splashTagline => 'घर की सेवाएँ, सही तरीके से।';

  @override
  String get timelineBookingConfirmed => 'बुकिंग की पुष्टि हुई';

  @override
  String get timelineProviderOnTheWay => 'सेवा प्रदाता रास्ते में है';

  @override
  String get timelineServiceInProgress => 'सेवा चल रही है';

  @override
  String get timelineCompleted => 'पूरा हुआ';

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
  String get errorSessionEnded =>
      'आपका सत्र समाप्त हो गया है। कृपया फिर से साइन इन करें।';

  @override
  String get errorUploadFailed =>
      'वह फ़ाइल अपलोड नहीं हो सकी। फिर से कोशिश करें।';

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
  String get authErrorPhoneNotEnabled =>
      'फ़ोन से साइन-इन चालू नहीं है। सहायता से संपर्क करें।';

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
  String get languagePickerTitle => 'अपनी भाषा चुनें';

  @override
  String get authCouldNotStartVerification =>
      'सत्यापन शुरू नहीं हो सका। कृपया फिर से कोशिश करें।';

  @override
  String get authWelcomeTitle => 'Wervexa में आपका स्वागत है';

  @override
  String get authWelcomeSubtitle =>
      'घर की मरम्मत, प्लंबिंग, बिजली, सफ़ाई और बहुत कुछ के लिए अपने आस-पास के सबसे अच्छे पेशेवर खोजें।';

  @override
  String get authEnterPhone => 'अपना फ़ोन नंबर दर्ज करें';

  @override
  String get authInvalidMobile => 'सही 10 अंकों का मोबाइल नंबर दर्ज करें';

  @override
  String get authGetOtp => 'OTP सत्यापन पाएँ';

  @override
  String get authTermsNotice =>
      'जारी रखकर, आप हमारी सेवा की शर्तों और गोपनीयता नीति से सहमत होते हैं';

  @override
  String get authNewCodeSent => 'हमने नया कोड भेज दिया है।';

  @override
  String get authVerifyPhoneTitle => 'फ़ोन सत्यापित करें';

  @override
  String get authChangeNumber => 'नंबर बदलें';

  @override
  String get authEnterCodeTitle => '6 अंकों का कोड दर्ज करें';

  @override
  String authCodeSentTo(Object phone) {
    return 'हमने $phone पर SMS सत्यापन कोड भेजा है';
  }

  @override
  String get authWrongNumber => 'गलत नंबर? इसे बदलें';

  @override
  String get authEnterSixDigits => 'कृपया 6 अंक दर्ज करें';

  @override
  String get authResendCode => 'कोड फिर से भेजें';

  @override
  String authResendCodeIn(Object seconds) {
    return '$seconds सेकंड में कोड फिर से भेजें';
  }

  @override
  String get authVerifyAndContinue => 'सत्यापित करें और जारी रखें';

  @override
  String get registerTitle => 'प्रोफ़ाइल पूरी करें';

  @override
  String get registerHeading => 'हमें अपना नाम बताएँ';

  @override
  String get registerNameVisibility =>
      'जब आप बुकिंग का अनुरोध करेंगे, तो आपका नाम सेवा कर्मियों को दिखेगा।';

  @override
  String get registerFullNameLabel => 'पूरा नाम *';

  @override
  String get registerFullNameHint => 'जैसे राहुल शर्मा';

  @override
  String get registerFullNameRequired => 'कृपया अपना पूरा नाम दर्ज करें';

  @override
  String get registerEmailLabel => 'ईमेल पता (वैकल्पिक)';

  @override
  String get registerEmailHint => 'जैसे rahul@example.com';

  @override
  String get registerSubmit => 'सहेजें और शुरू करें';

  @override
  String get bookingStatusRequested => 'पेशेवर खोजा जा रहा है…';

  @override
  String get bookingStatusAccepted => 'पेशेवर मिल गया';

  @override
  String get bookingStatusConfirmed => 'पुष्टि हुई';

  @override
  String get bookingStatusTraveling => 'रास्ते में';

  @override
  String get bookingStatusArrived => 'पहुँच गए — अपना कोड दर्ज करें';

  @override
  String get bookingStatusInProgress => 'काम चल रहा है';

  @override
  String get bookingStatusAwaitingApproval =>
      'काम पूरा — आगे बढ़ने के लिए मंज़ूरी दें';

  @override
  String get bookingStatusCompleted => 'पूरा हुआ';

  @override
  String get bookingStatusPaymentPending => 'भुगतान बाकी है';

  @override
  String get bookingStatusPaid => 'भुगतान हो गया';

  @override
  String get bookingStatusClosed => 'बंद';

  @override
  String get bookingStatusCancelled => 'रद्द';

  @override
  String get bookingStatusDisputed => 'विवादित';

  @override
  String get bookingStatusExpired => 'समाप्त — कोई उपलब्ध नहीं था';

  @override
  String get pricingPerJob => 'प्रति काम';

  @override
  String get pricingPerHour => 'प्रति घंटा';

  @override
  String get pricingPerDay => 'प्रति दिन';

  @override
  String get pricingPerUnit => 'प्रति यूनिट';

  @override
  String get pricingPerSqft => 'प्रति वर्ग फ़ुट';

  @override
  String get supportCategoryBooking => 'बुकिंग से जुड़ी समस्या';

  @override
  String get supportCategoryPayment => 'भुगतान';

  @override
  String get supportCategoryPayout => 'पेआउट';

  @override
  String get supportCategoryVerification => 'सत्यापन';

  @override
  String get supportCategoryAccount => 'मेरा खाता';

  @override
  String get supportCategorySafety => 'सुरक्षा से जुड़ी चिंता';

  @override
  String get supportCategoryClaim => 'बीमा दावा';

  @override
  String get supportCategoryAppIssue => 'ऐप में समस्या';

  @override
  String get supportCategoryOther => 'अन्य';

  @override
  String get requestStatusDraft => 'ड्राफ़्ट';

  @override
  String get requestStatusOpen => 'खुला — ऑफ़र का इंतज़ार';

  @override
  String get requestStatusReceivingOffers => 'ऑफ़र मिल रहे हैं';

  @override
  String get requestStatusWorkerSelected => 'पेशेवर चुना गया';

  @override
  String get requestStatusBooked => 'बुक हो गया';

  @override
  String get requestStatusCancelled => 'रद्द';

  @override
  String get requestStatusExpired => 'समाप्त';

  @override
  String get requestStatusClosed => 'बंद';

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
  String get scheduleSpecificDate => 'किसी तय तारीख पर';

  @override
  String get scheduleScheduled => 'निर्धारित';

  @override
  String get offerStatusSubmitted => 'नया ऑफ़र';

  @override
  String get offerStatusViewed => 'देखा गया';

  @override
  String get offerStatusShortlisted => 'शॉर्टलिस्ट किया गया';

  @override
  String get offerStatusAccepted => 'स्वीकार किया गया';

  @override
  String get offerStatusRejected => 'अस्वीकार किया गया';

  @override
  String get offerStatusWithdrawn => 'कर्मी ने वापस ले लिया';

  @override
  String get offerStatusExpired => 'समाप्त';

  @override
  String get offerStatusClosed => 'बंद';

  @override
  String get gigRatingNew => 'नया';

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
    return '$minutes मिनट';
  }

  @override
  String durationHours(Object hours) {
    return '$hours घंटे';
  }

  @override
  String durationHoursMinutes(int hours, int minutes) {
    return '$hours घंटे $minutes मिनट';
  }

  @override
  String get offerWorkerFallbackName => 'पेशेवर';

  @override
  String get budgetFlexible => 'लचीला बजट';

  @override
  String get budgetFixed => 'तय बजट';

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
  String get paymentsNotConfigured =>
      'इस बिल्ड में अभी भुगतान कॉन्फ़िगर नहीं है।';

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
  String get addressLabelHome => 'होम';

  @override
  String get addressLabelWork => 'ऑफ़िस';

  @override
  String get addressLabelOther => 'अन्य';

  @override
  String get commonSeeAll => 'सभी देखें';

  @override
  String get commonViewAll => 'सभी देखें';

  @override
  String get commonCheckBackLater => 'कृपया बाद में फिर देखें।';

  @override
  String get commonUseCurrentLocation => 'मौजूदा स्थान इस्तेमाल करें';

  @override
  String get commonChooseOnMap => 'नक्शे पर चुनें';

  @override
  String homeGreetingNamed(Object name) {
    return 'नमस्ते, $name 👋';
  }

  @override
  String get homeGreeting => 'नमस्ते 👋';

  @override
  String get homeWhatService => 'आज आपको कौन-सी सेवा चाहिए?';

  @override
  String get homeSetLocation => 'अपना स्थान सेट करें';

  @override
  String get homeWorkFinishedApprove =>
      'काम पूरा — मंज़ूरी देने के लिए टैप करें';

  @override
  String get homeCategories => 'श्रेणियाँ';

  @override
  String homeCategoriesLoadFailed(Object error) {
    return 'श्रेणियाँ लोड नहीं हो सकीं: $error';
  }

  @override
  String get homeFindWorker => 'कर्मी खोजें';

  @override
  String get homeFindWorkerSubtitle => 'आस-पास की सेवाएँ देखें';

  @override
  String get homePostRequest => 'अनुरोध पोस्ट करें';

  @override
  String get homePostRequestSubtitle => 'कर्मी आपके पास आते हैं';

  @override
  String get homeNoServices => 'अभी कोई सेवा उपलब्ध नहीं है';

  @override
  String get homeSearchNear => 'यहाँ के पास सेवाएँ खोजें';

  @override
  String get homeSearchHint => 'सेवाएँ खोजें...';

  @override
  String homeActiveBooking(Object code) {
    return 'चालू बुकिंग #$code';
  }

  @override
  String get homeActiveRequests => 'आपके चालू अनुरोध';

  @override
  String get commonGrantPermission => 'अनुमति दें';

  @override
  String get commonView => 'देखें';

  @override
  String get exploreTitle => 'सेवाएँ खोजें';

  @override
  String get exploreListView => 'सूची दृश्य';

  @override
  String get exploreMapView => 'नक्शा दृश्य';

  @override
  String get exploreSearchHint => 'सेवाएँ, कर्मी या कौशल खोजें...';

  @override
  String get exploreLocationOffTitle => 'लोकेशन सेवाएँ बंद हैं';

  @override
  String get exploreLocationOffMessage =>
      'अपने आस-पास के पेशेवर खोजने के लिए लोकेशन चालू करें।';

  @override
  String get exploreLocationPermissionTitle => 'लोकेशन की अनुमति चाहिए';

  @override
  String get exploreLocationPermissionMessage =>
      'हम आस-पास के पेशेवर खोजने के लिए आपकी लोकेशन इस्तेमाल करते हैं।';

  @override
  String get exploreChooseService => 'खोजने के लिए एक सेवा चुनें';

  @override
  String get exploreChooseServiceMessage =>
      'आस-पास के पेशेवर देखने के लिए ऊपर एक श्रेणी चुनें।';

  @override
  String get exploreNoProfessionals =>
      'इस सेवा के लिए आस-पास कोई पेशेवर उपलब्ध नहीं है';

  @override
  String get exploreLoadFailed => 'पेशेवर लोड नहीं हो सके।';

  @override
  String exploreByWorker(Object name) {
    return '$name द्वारा';
  }

  @override
  String get bookingsTitle => 'मेरी सेवा बुकिंग';

  @override
  String get bookingsTabActive => 'चालू';

  @override
  String get bookingsTabCompleted => 'पूरा हुआ';

  @override
  String get bookingsTabCancelled => 'रद्द';

  @override
  String get bookingsLoadFailed => 'आपकी बुकिंग लोड नहीं हो सकीं।';

  @override
  String get bookingsEmpty => 'अभी कोई बुकिंग नहीं';

  @override
  String get bookingsFindService => 'सेवा खोजें';

  @override
  String get bookingsWaitingForProfessional => 'पेशेवर का इंतज़ार';

  @override
  String bookingsCode(Object code) {
    return 'बुकिंग कोड: #$code';
  }

  @override
  String get bookingsPayNow => 'अभी भुगतान करें';

  @override
  String get bookingsApproveWork => 'काम को मंज़ूरी दें';

  @override
  String get bookingsTrackLive => 'लाइव ट्रैक करें';

  @override
  String get bookingsDetails => 'विवरण';

  @override
  String get bookingDetailTitle => 'बुकिंग विवरण';

  @override
  String get bookingDetailLoadFailed => 'बुकिंग विवरण लोड नहीं हो सका।';

  @override
  String get bookingDetailWaitingAccept => 'पेशेवर के स्वीकार करने का इंतज़ार';

  @override
  String bookingDetailNumber(Object code) {
    return 'बुकिंग #$code';
  }

  @override
  String bookingDetailStatus(Object status) {
    return 'स्थिति: $status';
  }

  @override
  String get bookingDetailLiveMap => 'लाइव नक्शा';

  @override
  String get bookingDetailServiceInfo => 'सेवा अनुरोध की जानकारी';

  @override
  String get bookingDetailViewMaterials => 'सामग्री / पुर्ज़ों के अनुरोध देखें';

  @override
  String get bookingDetailFareDetails => 'किराए का विवरण';

  @override
  String get bookingDetailEstimatedFare => 'अनुमानित किराया';

  @override
  String get bookingDetailFinalFare => 'अंतिम पुष्ट किराया';

  @override
  String get bookingDetailRateReview => 'सेवा कर्मी को रेटिंग और समीक्षा दें';

  @override
  String get bookingDetailApproveCompletion => 'काम पूरा होने को मंज़ूरी दें';

  @override
  String get bookingDetailApprovePaidHint =>
      'आपके पेशेवर ने यह काम पूरा चिह्नित किया है। मंज़ूरी देने पर आपका भुगतान उन्हें जारी हो जाएगा।';

  @override
  String get bookingDetailApproveUnpaidHint =>
      'आपके पेशेवर ने यह काम पूरा चिह्नित किया है। पुष्टि करने और भुगतान पर जाने के लिए मंज़ूरी दें।';

  @override
  String get bookingDetailReportProblem => 'समस्या बताएँ';

  @override
  String get bookingDetailCompletionApproved =>
      'काम पूरा होने को मंज़ूरी मिल गई';

  @override
  String bookingDetailPayToConfirm(Object amount) {
    return 'पुष्टि के लिए $amount का भुगतान करें';
  }

  @override
  String get bookingDetailSentAfterPayment =>
      'भुगतान पूरा होते ही आपकी बुकिंग पेशेवर को भेज दी जाएगी।';

  @override
  String bookingDetailPayAmount(Object amount) {
    return '$amount का भुगतान करें';
  }

  @override
  String get bookingDetailCancelBooking => 'बुकिंग रद्द करें';

  @override
  String get cancelReasonMistake => 'गलती से बुक हो गया';

  @override
  String get cancelReasonNoLongerNeeded => 'मुझे अब इस सेवा की ज़रूरत नहीं है';

  @override
  String get cancelReasonDifferentTime =>
      'मैं कोई दूसरा समय चुनना चाहता/चाहती हूँ';

  @override
  String get cancelReasonFoundSomeoneElse => 'मुझे कोई और मिल गया';

  @override
  String get cancelDialogTitle => 'आप रद्द क्यों कर रहे हैं?';

  @override
  String get cancelDialogRefundNotice =>
      'इसे वापस नहीं किया जा सकता। आपका भुगतान मूल भुगतान तरीके में वापस कर दिया जाएगा।';

  @override
  String get cancelDialogCannotUndo => 'इसे वापस नहीं किया जा सकता।';

  @override
  String get cancelDialogKeepBooking => 'बुकिंग रखें';

  @override
  String get bookingCancelledRefund =>
      'बुकिंग रद्द हो गई। आपके रिफ़ंड का अनुरोध कर दिया गया है।';

  @override
  String get bookingCancelled => 'बुकिंग रद्द हो गई';

  @override
  String get arrivalCodeTitle => 'पहुँचने का कोड';

  @override
  String get arrivalCodeShare =>
      'पेशेवर के पहुँचने की पुष्टि के लिए यह कोड उनके साथ साझा करें:';

  @override
  String get arrivalCodeUnavailable => 'उपलब्ध नहीं';

  @override
  String get arrivalCodeLoadFailed => 'कोड लोड नहीं हो सका';

  @override
  String get activeBookingTitle => 'लाइव बुकिंग और कर्मी ट्रैकिंग';

  @override
  String get activeBookingLoadFailed => 'यह बुकिंग लोड नहीं हो सकी।';

  @override
  String get activeBookingMapUnavailable =>
      'इस बुकिंग के लिए लाइव नक्शा उपलब्ध नहीं है।';

  @override
  String get activeBookingViewDetails => 'बुकिंग विवरण देखें';

  @override
  String get activeBookingServiceLocation => 'सेवा का स्थान';

  @override
  String get activeBookingYourProfessional => 'आपके पेशेवर';

  @override
  String get activeBookingLive => 'लाइव';

  @override
  String get activeBookingLastKnown => 'आखिरी ज्ञात स्थान';

  @override
  String get activeBookingPhoneNotShared => 'फ़ोन नंबर अभी साझा नहीं किया गया';

  @override
  String get activeBookingCallProfessional => 'पेशेवर को कॉल करें';

  @override
  String get activeBookingMaterials => 'सामग्री';

  @override
  String get activeBookingViewDetailsShort => 'विवरण देखें';

  @override
  String get locationConnecting => 'लाइव लोकेशन से जुड़ रहे हैं...';

  @override
  String get locationLiveUnavailable => 'लाइव लोकेशन अभी उपलब्ध नहीं है';

  @override
  String get locationLiveActive => 'लाइव लोकेशन चालू है';

  @override
  String get locationUpdating => 'अपडेट हो रहा है...';

  @override
  String get locationUnavailable => 'लोकेशन अभी उपलब्ध नहीं है';

  @override
  String get activeBookingShareStartCode =>
      'कर्मी पहुँच गए! शुरू करने का कोड साझा करें:';

  @override
  String get commonBack => 'वापस';

  @override
  String get paymentCouldNotOpen =>
      'भुगतान स्क्रीन नहीं खुल सकी। कृपया फिर से कोशिश करें।';

  @override
  String get paymentReceived =>
      'भुगतान मिल गया। आपकी बुकिंग पेशेवर को भेज दी गई है।';

  @override
  String paymentNotConfirmed(String reason, String reference) {
    return 'हम इस भुगतान की पुष्टि नहीं कर सके: $reason। अगर पैसे कट गए हैं, तो संदर्भ $reference के साथ सहायता से संपर्क करें।';
  }

  @override
  String get paymentNotCompleted => 'भुगतान पूरा नहीं हुआ।';

  @override
  String paymentExternalWalletUnsupported(Object wallet) {
    return 'बाहरी वॉलेट ($wallet) चुना गया — यह अभी समर्थित नहीं है।';
  }

  @override
  String get paymentTitle => 'भुगतान';

  @override
  String get paymentStatusUnknown =>
      'हम यह नहीं जाँच सके कि इस बुकिंग का भुगतान पहले ही हो चुका है या नहीं। दो बार भुगतान करने के बजाय कृपया फिर से कोशिश करें।';

  @override
  String get paymentBookingLoadFailed => 'यह बुकिंग लोड नहीं हो सकी।';

  @override
  String get paymentComplete => 'भुगतान पूरा हुआ';

  @override
  String paymentPaidFor(String amount, String service) {
    return '$service के लिए $amount का भुगतान हुआ।';
  }

  @override
  String get paymentViewBooking => 'बुकिंग देखें';

  @override
  String get paymentBookingSummary => 'बुकिंग सारांश';

  @override
  String get paymentProvider => 'सेवा प्रदाता';

  @override
  String get paymentService => 'सेवा';

  @override
  String get paymentDate => 'तारीख';

  @override
  String get paymentTime => 'समय';

  @override
  String get paymentAddress => 'पता';

  @override
  String get paymentTotal => 'कुल';

  @override
  String get paymentHeldSecurely =>
      'आपका भुगतान सुरक्षित रखा जाता है और काम को आपकी मंज़ूरी के बाद ही पेशेवर को जारी किया जाता है। अगर काम शुरू होने से पहले बुकिंग रद्द होती है, तो आपको रिफ़ंड मिलता है।';

  @override
  String get commonChange => 'बदलें';

  @override
  String get bookMissingDetails =>
      'बुकिंग का विवरण अधूरा है — कृपया फिर से शुरू करें।';

  @override
  String get bookSlotPassed =>
      'वह समय निकल गया है। हमने आपको अगले उपलब्ध स्लॉट पर कर दिया है — इसे जाँचें और फिर से पुष्टि करें।';

  @override
  String bookFailed(Object reason) {
    return 'बुकिंग नहीं हो सकी: $reason';
  }

  @override
  String get bookNoAddress => 'कोई पता नहीं चुना गया';

  @override
  String get bookTitle => 'सेवा बुक करें';

  @override
  String get bookSelectDate => 'तारीख चुनें';

  @override
  String get bookSelectTime => 'समय चुनें';

  @override
  String get bookSpecialInstructions => 'विशेष निर्देश (वैकल्पिक)';

  @override
  String get bookSpecialInstructionsHint =>
      'जैसे रसोई और बाथरूम पर ध्यान दें...';

  @override
  String get bookConfirm => 'बुकिंग की पुष्टि करें →';

  @override
  String get gigUnknownProfessional => 'अज्ञात पेशेवर';

  @override
  String get gigNewProfessional => 'नया पेशेवर';

  @override
  String gigRatingWithCount(String rating, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count समीक्षाएँ',
      one: '1 समीक्षा',
    );
    return '$rating ($_temp0)';
  }

  @override
  String get gigPricing => 'कीमत';

  @override
  String get gigServiceRate => 'सेवा दर';

  @override
  String get gigFinalAmountNote =>
      'अंतिम राशि आपके पेशेवर द्वारा पुष्ट की जाती है और बुकिंग बनने पर उसमें दिखाई जाती है।';

  @override
  String get gigKycVerified => 'KYC सत्यापित';

  @override
  String get gigBackgroundVerified => 'पृष्ठभूमि सत्यापित';

  @override
  String get gigBookNow => 'अभी बुक करें →';

  @override
  String get discoveryTitle => 'उपलब्ध पेशेवर';

  @override
  String get discoveryMissingDetails => 'सेवा या स्थान का विवरण नहीं है।';

  @override
  String get discoveryLocalExperts => 'उपलब्ध स्थानीय विशेषज्ञ';

  @override
  String get discoveryWithin => 'दूरी के भीतर';

  @override
  String get discoveryNoProviders => 'आस-पास कोई सेवा प्रदाता उपलब्ध नहीं है';

  @override
  String get discoveryTryLargerRadius =>
      'बड़ी खोज दूरी आज़माएँ या बाद में फिर देखें।';

  @override
  String get discoveryLoadFailed => 'आस-पास के सेवा प्रदाता लोड नहीं हो सके।';

  @override
  String discoveryServicesForJob(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'इस काम के लिए $count सेवाएँ',
      one: 'इस काम के लिए 1 सेवा',
    );
    return '$_temp0';
  }

  @override
  String get discoveryBook => 'बुक करें';

  @override
  String get categoryServiceDetails => 'सेवा का विवरण';

  @override
  String get categoryTagline =>
      'पहले से तय कीमत और सेवा की गारंटी के साथ सत्यापित, पृष्ठभूमि-जाँचे गए स्थानीय विशेषज्ञ बुक करें।';

  @override
  String get categoryWhatHelp => 'आपको किस काम में मदद चाहिए?';

  @override
  String get categoryDescribeElse => 'कुछ और बताएँ';

  @override
  String get categoryLoadFailed => 'यह सेवा लोड नहीं हो सकी।';

  @override
  String get notificationsTitle => 'सूचनाएँ और अलर्ट';

  @override
  String get notificationsEmpty => 'आपने सब देख लिया है';

  @override
  String get notificationsLoadFailed => 'सूचनाएँ लोड नहीं हो सकीं।';

  @override
  String get timeJustNow => 'अभी-अभी';

  @override
  String timeMinutesAgo(Object minutes) {
    return '$minutes मिनट पहले';
  }

  @override
  String timeHoursAgo(Object hours) {
    return '$hours घंटे पहले';
  }

  @override
  String get timeYesterday => 'कल';

  @override
  String get completedTitle => 'सेवा पूरी हुई!';

  @override
  String get completedThanks => 'हमारी सेवाओं का उपयोग करने के लिए धन्यवाद।';

  @override
  String get completedViewBookings => 'बुकिंग देखें';

  @override
  String get completedBackHome => 'होम पर वापस जाएँ';

  @override
  String commonErrorDetail(Object detail) {
    return 'त्रुटि: $detail';
  }

  @override
  String get reviewTitle => 'अपने अनुभव को रेटिंग दें';

  @override
  String get reviewHeading => 'बढ़िया सेवा!';

  @override
  String get reviewQuestion => 'आपके पेशेवर के साथ आपका अनुभव कैसा रहा?';

  @override
  String reviewStars(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count स्टार',
      one: '1 स्टार',
    );
    return '$_temp0';
  }

  @override
  String get reviewCommentHint => 'हमें अपने अनुभव के बारे में बताएँ...';

  @override
  String get reviewSubmit => 'समीक्षा भेजें →';

  @override
  String get materialsTitle => 'सामग्री / पुर्ज़ों के अनुरोध';

  @override
  String get materialsEmpty =>
      'इस बुकिंग के लिए सामग्री का कोई अनुरोध नहीं भेजा गया';

  @override
  String materialsQuantityEstimated(Object quantity) {
    return '$quantity · अनुमानित';
  }

  @override
  String materialsQuantityActual(Object quantity) {
    return '$quantity · वास्तविक';
  }

  @override
  String get materialsReject => 'अस्वीकार करें';

  @override
  String get materialsApprove => 'मंज़ूरी दें';

  @override
  String get materialStatusRequested => 'अनुरोध किया गया';

  @override
  String get materialStatusCustomerReview => 'आपकी समीक्षा का इंतज़ार';

  @override
  String get materialStatusApproved => 'मंज़ूर';

  @override
  String get materialStatusRejected => 'अस्वीकार किया गया';

  @override
  String get materialStatusPurchased => 'खरीदा गया';

  @override
  String get materialStatusCostRecorded => 'लागत दर्ज की गई';

  @override
  String get materialStatusBilled => 'बिल में जोड़ा गया';

  @override
  String get materialStatusCancelled => 'रद्द';

  @override
  String get commonSaveChanges => 'बदलाव सहेजें';

  @override
  String get profileTitle => 'मेरी प्रोफ़ाइल और खाता';

  @override
  String get profileFallbackName => 'ग्राहक प्रोफ़ाइल';

  @override
  String get profileLanguage => 'भाषा';

  @override
  String get profileAddresses => 'सहेजे गए सेवा पते';

  @override
  String get profileAddressesSubtitle => 'घर, ऑफ़िस और अन्य पते प्रबंधित करें';

  @override
  String get profileHistory => 'पिछली सेवाओं का इतिहास';

  @override
  String get profileHistorySubtitle => 'रसीदें और पिछली बुकिंग देखें';

  @override
  String get profileSupport => 'मदद और ग्राहक सहायता';

  @override
  String get profileSupportSubtitle => 'टिकट बनाएँ, हमारी टीम के जवाब देखें';

  @override
  String get editProfileSaved => 'प्रोफ़ाइल सफलतापूर्वक अपडेट हो गई';

  @override
  String get editProfileTitle => 'प्रोफ़ाइल बदलें';

  @override
  String get editProfileFullName => 'पूरा नाम';

  @override
  String get editProfileNameEmpty => 'नाम खाली नहीं हो सकता';

  @override
  String get editProfileEmail => 'ईमेल पता';

  @override
  String get commonEdit => 'बदलें';

  @override
  String get commonDelete => 'हटाएँ';

  @override
  String get addressesAdd => 'नया पता जोड़ें';

  @override
  String get addressesEmpty => 'आपने अभी तक कोई पता नहीं सहेजा है';

  @override
  String get addressesEmptyMessage =>
      'अगली बार जल्दी बुक करने के लिए एक सेवा पता जोड़ें।';

  @override
  String get addressesDefaultBadge => 'डिफ़ॉल्ट';

  @override
  String get addressesSetDefault => 'डिफ़ॉल्ट बनाएँ';

  @override
  String get addressesLoadFailed => 'पते लोड नहीं हो सके।';

  @override
  String get addressesLabelSheet => 'इस पते को नाम दें';

  @override
  String get supportTitle => 'मदद और सहायता';

  @override
  String get supportNewTicket => 'नया टिकट';

  @override
  String get supportEmpty => 'अभी कोई सहायता टिकट नहीं';

  @override
  String get supportEmptyMessage =>
      'किसी बुकिंग या ऐप में मदद चाहिए? टिकट बनाएँ और हमारी टीम जवाब देगी।';

  @override
  String get supportLoadFailed => 'आपके सहायता टिकट लोड नहीं हो सके।';

  @override
  String get supportStatusOpen => 'खुला';

  @override
  String get supportStatusInProgress => 'प्रगति में';

  @override
  String get supportStatusWaitingForYou => 'आपके जवाब का इंतज़ार';

  @override
  String get supportStatusResolved => 'हल हो गया';

  @override
  String get supportStatusClosed => 'बंद';

  @override
  String get supportNewTicketTitle => 'नया सहायता टिकट';

  @override
  String get supportCategory => 'श्रेणी';

  @override
  String get supportSubject => 'विषय';

  @override
  String get supportDescribeIssue => 'समस्या बताएँ';

  @override
  String get supportFillSubjectMessage => 'कृपया विषय और संदेश भरें।';

  @override
  String get supportSubmitTicket => 'टिकट भेजें';

  @override
  String get supportTicketTitle => 'सहायता टिकट';

  @override
  String get supportNoMessages => 'अभी कोई संदेश नहीं';

  @override
  String get supportMessagesLoadFailed => 'संदेश लोड नहीं हो सके।';

  @override
  String get supportTypeMessage => 'संदेश लिखें...';

  @override
  String get supportSend => 'भेजें';

  @override
  String get pickerEnterAddress =>
      'कृपया इस पिन के लिए पता दर्ज करें या पुष्टि करें';

  @override
  String get pickerTitle => 'सेवा का पता चुनें';

  @override
  String get pickerGettingLocation => 'आपका स्थान पता किया जा रहा है...';

  @override
  String get pickerPermissionDenied =>
      'लोकेशन की अनुमति नहीं मिली — अपना पता चुनने के लिए नक्शे को खुद खिसकाएँ।';

  @override
  String get pickerConfirmPin => 'सेवा पिन की जगह की पुष्टि करें';

  @override
  String get pickerAddressLabel => 'मकान / फ़्लैट / गली का नाम';

  @override
  String get pickerAddressHint => 'जैसे #102, ग्रीन एवेन्यू, इंदिरानगर';

  @override
  String get pickerLandmarkLabel => 'निशानी (वैकल्पिक)';

  @override
  String get pickerLandmarkHint => 'जैसे HDFC बैंक ATM के पास';

  @override
  String get pickerConfirm => 'स्थान की पुष्टि करें और आगे बढ़ें';

  @override
  String get requestSelectLocation => 'कृपया सेवा का स्थान चुनें';

  @override
  String requestTitle(Object service) {
    return '$service का अनुरोध करें';
  }

  @override
  String get requestServiceAddress => 'सेवा का पता';

  @override
  String get requestDetectingLocation => 'आपका स्थान पता किया जा रहा है…';

  @override
  String get requestTapToPickLocation => 'सेवा का स्थान चुनने के लिए टैप करें';

  @override
  String get requestDescribeIssue => 'समस्या / काम बताएँ';

  @override
  String get requestDescribeHint =>
      'जैसे बैठक के कमरे की मुख्य छत की लाइट का स्विच चालू करने पर चिंगारी देता है।';

  @override
  String get requestDescribeMin => 'कृपया समस्या कम से कम 10 अक्षरों में बताएँ';

  @override
  String get requestAttachPhotos => 'समस्या की फ़ोटो जोड़ें (वैकल्पिक)';

  @override
  String get requestAddPhoto => 'फ़ोटो जोड़ें';

  @override
  String get requestWhen => 'आपको सेवा कब चाहिए?';

  @override
  String get requestInstant => '⚡ तुरंत (30 मिनट)';

  @override
  String get requestScheduleLater => '📅 बाद के लिए तय करें';

  @override
  String get requestFindWorkers => 'उपलब्ध कर्मी खोजें';

  @override
  String commonLoadFailedDetail(Object detail) {
    return 'लोड नहीं हो सका: $detail';
  }

  @override
  String get myRequestsTitle => 'मेरे सेवा अनुरोध';

  @override
  String get myRequestsTabAll => 'सभी';

  @override
  String get myRequestsNew => 'नया अनुरोध';

  @override
  String get myRequestsNoActive => 'कोई चालू अनुरोध नहीं';

  @override
  String get myRequestsNoCompleted => 'कोई पूरा अनुरोध नहीं';

  @override
  String get myRequestsNone => 'अभी कोई सेवा अनुरोध नहीं';

  @override
  String get myRequestsEmptyMessage =>
      'अपनी ज़रूरत पोस्ट करें और कर्मियों को अपने पास आने दें।';

  @override
  String get requestDetailTitle => 'अनुरोध का विवरण';

  @override
  String get requestDetailBudget => 'बजट';

  @override
  String get requestDetailSchedule => 'समय';

  @override
  String get requestDetailLocation => 'स्थान';

  @override
  String get requestDetailNotes => 'नोट्स';

  @override
  String get requestDetailCancel => 'अनुरोध रद्द करें';

  @override
  String requestDetailOffersReceived(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ऑफ़र मिले',
      one: '1 ऑफ़र मिला',
      zero: 'अभी कोई ऑफ़र नहीं',
    );
    return '$_temp0';
  }

  @override
  String get requestDetailTapToCompare => 'देखने और तुलना करने के लिए टैप करें';

  @override
  String get requestDetailWorkersSoon => 'कर्मी जल्द ही जवाब देना शुरू करेंगे';

  @override
  String get requestCancelDialogTitle => 'यह अनुरोध रद्द करें?';

  @override
  String get requestCancelDialogBody =>
      'सभी बाकी ऑफ़र बंद कर दिए जाएँगे। इसे वापस नहीं किया जा सकता।';

  @override
  String get requestCancelKeep => 'इसे रखें';

  @override
  String get requestCancelConfirm => 'अनुरोध रद्द करें';

  @override
  String get requestCancelled => 'अनुरोध रद्द हो गया';

  @override
  String requestExpiresInDaysHours(int days, int hours) {
    return '$days दिन $hours घंटे में समाप्त';
  }

  @override
  String requestExpiresInHoursMinutes(int hours, int minutes) {
    return '$hours घंटे $minutes मिनट में समाप्त';
  }

  @override
  String requestExpiresInMinutes(Object minutes) {
    return '$minutes मिनट में समाप्त';
  }

  @override
  String get requestExpiresSoon => 'जल्द समाप्त होगा';

  @override
  String get commonCancel => 'रद्द करें';

  @override
  String get offersTitle => 'मिले हुए ऑफ़र';

  @override
  String get offersEmptyMessage =>
      'कर्मी आपका अनुरोध देख रहे हैं। किसी के जवाब देने पर आपको सूचना मिलेगी।';

  @override
  String get offersPending => 'बाकी ऑफ़र';

  @override
  String get offersPast => 'पिछले ऑफ़र';

  @override
  String offersJobsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count काम',
      one: '1 काम',
    );
    return '$_temp0';
  }

  @override
  String get offersInsured => 'बीमित';

  @override
  String get offersDecline => 'मना करें';

  @override
  String get offersAcceptOffer => 'ऑफ़र स्वीकार करें';

  @override
  String get offersAcceptDialogTitle => 'यह ऑफ़र स्वीकार करें?';

  @override
  String offersAcceptDialogBody(String worker, String price) {
    return '$worker के साथ $price पर बुकिंग बनाई जाएगी। बाकी सभी ऑफ़र बंद कर दिए जाएँगे।';
  }

  @override
  String get offersAccept => 'स्वीकार करें';

  @override
  String offersBookingCreated(Object code) {
    return 'बुकिंग $code बन गई!';
  }

  @override
  String get commonNext => 'आगे';

  @override
  String postRequestPosted(Object code) {
    return 'सेवा अनुरोध $code पोस्ट हो गया!';
  }

  @override
  String get postRequestTitle => 'सेवा अनुरोध पोस्ट करें';

  @override
  String get postRequestWhatService => 'आपको कौन-सी सेवा चाहिए?';

  @override
  String get postRequestSelectCategory =>
      'वह श्रेणी चुनें जो आपकी ज़रूरत को सबसे अच्छी तरह बताती है।';

  @override
  String get postRequestDescribe => 'अपनी ज़रूरत बताएँ';

  @override
  String postRequestServiceLabel(Object service) {
    return 'सेवा: $service';
  }

  @override
  String get postRequestWhatDone => 'आपको क्या काम करवाना है?';

  @override
  String get postRequestFieldTitle => 'शीर्षक';

  @override
  String get postRequestTitleHint => 'जैसे रसोई का टपकता नल ठीक करना';

  @override
  String postRequestMinChars(Object count) {
    return 'कम से कम $count अक्षर दर्ज करें';
  }

  @override
  String get postRequestFieldDescription => 'विवरण';

  @override
  String get postRequestDescriptionHint => 'समस्या विस्तार से बताएँ…';

  @override
  String get postRequestFieldNotes => 'अतिरिक्त नोट्स (वैकल्पिक)';

  @override
  String get postRequestNotesHint => 'गेट कोड, पसंदीदा समय आदि';

  @override
  String get postRequestBudgetTitle => 'आपका बजट';

  @override
  String get postRequestBudgetHint =>
      'कर्मियों को बताएँ कि आप कितना देना चाहते हैं।';

  @override
  String get postRequestFixedPrice => 'तय कीमत (₹)';

  @override
  String postRequestExample(Object example) {
    return 'जैसे $example';
  }

  @override
  String get postRequestMin => 'न्यूनतम (₹)';

  @override
  String get postRequestMax => 'अधिकतम (₹)';

  @override
  String get postRequestWhenTitle => 'आपको यह कब चाहिए?';

  @override
  String get postRequestPickDate => 'तारीख चुनें';

  @override
  String get postRequestLocationTitle => 'सेवा का स्थान';

  @override
  String get postRequestAddressPrivate =>
      'आपका सटीक पता ऑफ़र स्वीकार करने के बाद ही साझा किया जाता है।';

  @override
  String get postRequestFullAddress => 'पूरा पता';

  @override
  String get postRequestValidAddress => 'सही पता दर्ज करें';

  @override
  String get postRequestCity => 'शहर';

  @override
  String get postRequestCityHint => 'जैसे बेंगलुरु';

  @override
  String get postRequestPincode => 'पिनकोड';

  @override
  String get postRequestLocationSet => 'स्थान सेट हो गया ✓';

  @override
  String get postRequestSetOnMap => 'नक्शे पर स्थान सेट करें';

  @override
  String get postRequestReviewTitle => 'अपना अनुरोध जाँचें';

  @override
  String get postRequestNotSelected => 'नहीं चुना गया';

  @override
  String get postRequestWhen => 'कब';

  @override
  String get postRequestPrivacyNote =>
      'जब तक आप ऑफ़र स्वीकार नहीं करते और बुकिंग नहीं बनती, आपका सटीक पता निजी रहता है।';

  @override
  String get postRequestSubmit => 'अनुरोध भेजें';

  @override
  String get assistantOpening =>
      'मुझे अपने शब्दों में बताएँ कि क्या खराब है — और मैं उसके लिए सही पेशेवर ढूँढ दूँगा।';

  @override
  String assistantCatalogueFailed(Object reason) {
    return '$reason इसका जवाब देने के लिए मुझे सेवाओं की सूची चाहिए।';
  }

  @override
  String get assistantCatalogueError =>
      'सेवाओं की सूची लोड करने में कुछ गड़बड़ हो गई।';

  @override
  String get assistantGreeting =>
      'नमस्ते। घर में आपको किस काम में मदद चाहिए? टपकता नल, ठंडा न करने वाला AC, चिंगारी देने वाला स्विच — जो भी हो, जैसे चाहें वैसे बताएँ।';

  @override
  String get assistantTooVague =>
      'मैं मदद कर सकता हूँ — बस मुझे जानना है कि समस्या क्या है। क्या काम नहीं कर रहा?';

  @override
  String assistantMultipleJobs(int count) {
    return 'यह $count अलग-अलग काम लगते हैं — इनके लिए अलग-अलग कारीगर चाहिए। हर एक यहाँ है:';
  }

  @override
  String get assistantAmbiguous =>
      'मैं इसे सही करना चाहता हूँ — यह एक से ज़्यादा काम में जा सकता है। कौन-सा ज़्यादा करीब है?';

  @override
  String get assistantUnmatched =>
      'मैं इसे प्लेटफ़ॉर्म की किसी सेवा से नहीं जोड़ सका। सबसे करीब वाली चुनें और मैं आपका विवरण वहाँ ले जाऊँगा — या इसे अनुरोध के रूप में पोस्ट करें और पेशेवरों को अपने पास आने दें।';

  @override
  String assistantConfidentWithProblem(String service, String problem) {
    return 'यह $service का काम लगता है — शायद \"$problem\"।';
  }

  @override
  String assistantConfident(Object service) {
    return 'यह $service का काम लगता है।';
  }

  @override
  String assistantChosen(Object service) {
    return 'ठीक है, $service। आपका विवरण जैसा आपने लिखा वैसा ही भेजा जाएगा।';
  }

  @override
  String get assistantTitle => 'सेवा सहायक';

  @override
  String get assistantSubtitle => 'आपकी समस्या के लिए सही काम ढूँढता है';

  @override
  String get assistantStartOver => 'फिर से शुरू करें';

  @override
  String assistantMatchedOn(Object terms) {
    return 'मेल खाए शब्द: $terms';
  }

  @override
  String get assistantFindWorkers => 'कर्मी खोजें';

  @override
  String get assistantPostRequest => 'अनुरोध पोस्ट करें';

  @override
  String get assistantInputHint => 'समस्या बताएँ...';
}
