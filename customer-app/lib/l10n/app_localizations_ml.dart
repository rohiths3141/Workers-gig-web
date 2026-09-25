// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malayalam (`ml`).
class AppLocalizationsMl extends AppLocalizations {
  AppLocalizationsMl([String locale = 'ml']) : super(locale);

  @override
  String get commonRetry => 'വീണ്ടും ശ്രമിക്കുക';

  @override
  String get commonTryAgain => 'വീണ്ടും ശ്രമിക്കുക';

  @override
  String get commonSignOut => 'സൈൻ ഔട്ട് ചെയ്യുക';

  @override
  String get assistantFabLabel => 'AI-യോട് ചോദിക്കുക';

  @override
  String get navHome => 'ഹോം';

  @override
  String get navExplore => 'തിരയുക';

  @override
  String get navBookings => 'ബുക്കിംഗുകൾ';

  @override
  String get navAlerts => 'അറിയിപ്പുകൾ';

  @override
  String get navProfile => 'പ്രൊഫൈൽ';

  @override
  String get configErrorTitle => 'ആപ്പ് കോൺഫിഗർ ചെയ്തിട്ടില്ല';

  @override
  String configErrorBody(String keys, String command) {
    return 'ഈ ബിൽഡിൽ $keys ഇല്ല. ഇങ്ങനെ റൺ ചെയ്യുക:\n\n$command\n\nഅപ്പോൾ ആപ്പിന് യഥാർത്ഥ ബാക്കെൻഡിൽ എത്താനാകും.';
  }

  @override
  String get sessionProfileLoadFailedRetry =>
      'നിങ്ങളുടെ പ്രൊഫൈൽ ലോഡ് ചെയ്യാനായില്ല. ദയവായി വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get sessionProfileLoadFailed => 'നിങ്ങളുടെ പ്രൊഫൈൽ ലോഡ് ചെയ്യാനായില്ല';

  @override
  String get sessionCheckClock => 'നിങ്ങളുടെ ഫോണിലെ ക്ലോക്ക് പരിശോധിക്കുക';

  @override
  String get splashTagline => 'വീട്ടുസേവനങ്ങൾ, ശരിയായ രീതിയിൽ.';

  @override
  String get timelineBookingConfirmed => 'ബുക്കിംഗ് സ്ഥിരീകരിച്ചു';

  @override
  String get timelineProviderOnTheWay => 'സേവനദാതാവ് വഴിയിലാണ്';

  @override
  String get timelineServiceInProgress => 'സേവനം നടക്കുന്നു';

  @override
  String get timelineCompleted => 'പൂർത്തിയായി';

  @override
  String get errorNoInternet =>
      'ഇന്റർനെറ്റ് കണക്ഷൻ ഇല്ല. നിങ്ങളുടെ നെറ്റ്‌വർക്ക് പരിശോധിച്ച് വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get errorTimeout => 'ഇതിന് വളരെ സമയമെടുത്തു. വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get errorServer =>
      'ഞങ്ങളുടെ ഭാഗത്ത് എന്തോ പിശക് സംഭവിച്ചു. ദയവായി വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get errorClockSkew =>
      'നിങ്ങളുടെ ഫോണിലെ തീയതിയും സമയവും ശരിയല്ലെന്ന് തോന്നുന്നു. ക്രമീകരണങ്ങളിൽ ഓട്ടോമാറ്റിക് തീയതിയും സമയവും ഓണാക്കി വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get errorUnexpected =>
      'എന്തോ പിശക് സംഭവിച്ചു. ദയവായി വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get errorSessionEnded =>
      'നിങ്ങളുടെ സെഷൻ അവസാനിച്ചു. ദയവായി വീണ്ടും സൈൻ ഇൻ ചെയ്യുക.';

  @override
  String get errorUploadFailed =>
      'ആ ഫയൽ അപ്‌ലോഡ് ചെയ്യാനായില്ല. വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get errorSignInNotReady =>
      'നിങ്ങളുടെ സൈൻ-ഇൻ ഇതുവരെ പൂർണ്ണമായി തയ്യാറായിട്ടില്ല. അൽപ്പസമയത്തിന് ശേഷം വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get errorNoLongerAvailable => 'അത് ഇപ്പോൾ ലഭ്യമല്ല.';

  @override
  String get errorNotAllowedToSee => 'നിങ്ങൾക്ക് അത് കാണാനാകില്ല.';

  @override
  String get errorDidNotWork =>
      'അത് പ്രവർത്തിച്ചില്ല. ദയവായി വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get authErrorInvalidPhone => 'ആ ഫോൺ നമ്പർ ശരിയായി തോന്നുന്നില്ല.';

  @override
  String get authErrorWrongCode =>
      'ആ കോഡ് ശരിയല്ല. പരിശോധിച്ച് വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get authErrorCodeExpired =>
      'ആ കോഡിന്റെ കാലാവധി കഴിഞ്ഞു. പുതിയൊരെണ്ണം ചോദിക്കുക.';

  @override
  String get authErrorTooManyAttempts =>
      'വളരെയധികം ശ്രമങ്ങൾ. വീണ്ടും ശ്രമിക്കുന്നതിന് മുമ്പ് കുറച്ച് മിനിറ്റ് കാത്തിരിക്കുക.';

  @override
  String get authErrorQuota =>
      'ഇപ്പോൾ കോഡ് അയയ്ക്കാനാകില്ല. അൽപ്പസമയത്തിന് ശേഷം വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get authErrorDisabled =>
      'ഈ അക്കൗണ്ട് പ്രവർത്തനരഹിതമാക്കി. സഹായവുമായി ബന്ധപ്പെടുക.';

  @override
  String get authErrorPhoneNotEnabled =>
      'ഫോൺ സൈൻ-ഇൻ പ്രവർത്തനക്ഷമമല്ല. സഹായവുമായി ബന്ധപ്പെടുക.';

  @override
  String get authErrorNumberInUse =>
      'ആ നമ്പർ ഇതിനകം മറ്റൊരു അക്കൗണ്ടിൽ രജിസ്റ്റർ ചെയ്തിട്ടുണ്ട്.';

  @override
  String get authErrorSignInAgain => 'തുടരാൻ ദയവായി വീണ്ടും സൈൻ ഇൻ ചെയ്യുക.';

  @override
  String get authErrorSignInFailed =>
      'സൈൻ-ഇൻ പരാജയപ്പെട്ടു. ദയവായി വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get languagePickerTitle => 'നിങ്ങളുടെ ഭാഷ തിരഞ്ഞെടുക്കുക';

  @override
  String get authCouldNotStartVerification =>
      'പരിശോധന ആരംഭിക്കാനായില്ല. ദയവായി വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get authWelcomeTitle => 'Wervexa-യിലേക്ക് സ്വാഗതം';

  @override
  String get authWelcomeSubtitle =>
      'വീട്ടിലെ അറ്റകുറ്റപ്പണി, പ്ലംബിംഗ്, ഇലക്ട്രിക്കൽ, ക്ലീനിംഗ് എന്നിവയ്ക്കും മറ്റും സമീപത്തെ മികച്ച വിദഗ്ധരെ കണ്ടെത്തൂ.';

  @override
  String get authEnterPhone => 'നിങ്ങളുടെ ഫോൺ നമ്പർ നൽകുക';

  @override
  String get authInvalidMobile => 'സാധുവായ 10 അക്ക മൊബൈൽ നമ്പർ നൽകുക';

  @override
  String get authGetOtp => 'OTP പരിശോധന നേടുക';

  @override
  String get authTermsNotice =>
      'തുടരുന്നതിലൂടെ, ഞങ്ങളുടെ സേവന നിബന്ധനകളും സ്വകാര്യതാ നയവും നിങ്ങൾ അംഗീകരിക്കുന്നു';

  @override
  String get authNewCodeSent => 'ഞങ്ങൾ പുതിയ കോഡ് അയച്ചു.';

  @override
  String get authVerifyPhoneTitle => 'ഫോൺ പരിശോധിക്കുക';

  @override
  String get authChangeNumber => 'നമ്പർ മാറ്റുക';

  @override
  String get authEnterCodeTitle => '6 അക്ക കോഡ് നൽകുക';

  @override
  String authCodeSentTo(Object phone) {
    return '$phone എന്ന നമ്പറിലേക്ക് SMS പരിശോധനാ കോഡ് അയച്ചു';
  }

  @override
  String get authWrongNumber => 'തെറ്റായ നമ്പറാണോ? മാറ്റുക';

  @override
  String get authEnterSixDigits => 'ദയവായി 6 അക്കങ്ങൾ നൽകുക';

  @override
  String get authResendCode => 'കോഡ് വീണ്ടും അയയ്ക്കുക';

  @override
  String authResendCodeIn(Object seconds) {
    return '$seconds സെക്കൻഡിൽ കോഡ് വീണ്ടും അയയ്ക്കാം';
  }

  @override
  String get authVerifyAndContinue => 'പരിശോധിച്ച് തുടരുക';

  @override
  String get registerTitle => 'പ്രൊഫൈൽ പൂർത്തിയാക്കുക';

  @override
  String get registerHeading => 'നിങ്ങളുടെ പേര് പറയൂ';

  @override
  String get registerNameVisibility =>
      'നിങ്ങൾ ബുക്കിംഗ് അഭ്യർത്ഥന നടത്തുമ്പോൾ നിങ്ങളുടെ പേര് സേവന ജീവനക്കാർക്ക് കാണാം.';

  @override
  String get registerFullNameLabel => 'പൂർണ്ണ പേര് *';

  @override
  String get registerFullNameHint => 'ഉദാ. രാഹുൽ ശർമ്മ';

  @override
  String get registerFullNameRequired => 'ദയവായി നിങ്ങളുടെ പൂർണ്ണ പേര് നൽകുക';

  @override
  String get registerEmailLabel => 'ഇമെയിൽ വിലാസം (ഓപ്ഷണൽ)';

  @override
  String get registerEmailHint => 'ഉദാ. rahul@example.com';

  @override
  String get registerSubmit => 'സേവ് ചെയ്ത് ആരംഭിക്കുക';

  @override
  String get bookingStatusRequested => 'വിദഗ്ധനെ തിരയുന്നു…';

  @override
  String get bookingStatusAccepted => 'വിദഗ്ധനെ കണ്ടെത്തി';

  @override
  String get bookingStatusConfirmed => 'സ്ഥിരീകരിച്ചു';

  @override
  String get bookingStatusTraveling => 'വഴിയിലാണ്';

  @override
  String get bookingStatusArrived => 'എത്തി — നിങ്ങളുടെ കോഡ് നൽകുക';

  @override
  String get bookingStatusInProgress => 'ജോലി നടക്കുന്നു';

  @override
  String get bookingStatusAwaitingApproval =>
      'ജോലി കഴിഞ്ഞു — തുടരാൻ അംഗീകരിക്കുക';

  @override
  String get bookingStatusCompleted => 'പൂർത്തിയായി';

  @override
  String get bookingStatusPaymentPending => 'പേയ്‌മെന്റ് ബാക്കിയുണ്ട്';

  @override
  String get bookingStatusPaid => 'പണമടച്ചു';

  @override
  String get bookingStatusClosed => 'അടച്ചു';

  @override
  String get bookingStatusCancelled => 'റദ്ദാക്കി';

  @override
  String get bookingStatusDisputed => 'തർക്കത്തിലാണ്';

  @override
  String get bookingStatusExpired => 'കാലാവധി കഴിഞ്ഞു — ആരും ലഭ്യമായിരുന്നില്ല';

  @override
  String get pricingPerJob => 'ഒരു ജോലിക്ക്';

  @override
  String get pricingPerHour => 'മണിക്കൂറിന്';

  @override
  String get pricingPerDay => 'ദിവസത്തിന്';

  @override
  String get pricingPerUnit => 'യൂണിറ്റിന്';

  @override
  String get pricingPerSqft => 'ചതുരശ്ര അടിക്ക്';

  @override
  String get supportCategoryBooking => 'ബുക്കിംഗ് പ്രശ്നം';

  @override
  String get supportCategoryPayment => 'പേയ്‌മെന്റ്';

  @override
  String get supportCategoryPayout => 'പേഔട്ട്';

  @override
  String get supportCategoryVerification => 'പരിശോധന';

  @override
  String get supportCategoryAccount => 'എന്റെ അക്കൗണ്ട്';

  @override
  String get supportCategorySafety => 'സുരക്ഷാ ആശങ്ക';

  @override
  String get supportCategoryClaim => 'ഇൻഷുറൻസ് ക്ലെയിം';

  @override
  String get supportCategoryAppIssue => 'ആപ്പ് പ്രശ്നം';

  @override
  String get supportCategoryOther => 'മറ്റുള്ളവ';

  @override
  String get requestStatusDraft => 'ഡ്രാഫ്റ്റ്';

  @override
  String get requestStatusOpen =>
      'തുറന്നിരിക്കുന്നു — ഓഫറുകൾക്കായി കാത്തിരിക്കുന്നു';

  @override
  String get requestStatusReceivingOffers => 'ഓഫറുകൾ ലഭിക്കുന്നു';

  @override
  String get requestStatusWorkerSelected => 'വിദഗ്ധനെ തിരഞ്ഞെടുത്തു';

  @override
  String get requestStatusBooked => 'ബുക്ക് ചെയ്തു';

  @override
  String get requestStatusCancelled => 'റദ്ദാക്കി';

  @override
  String get requestStatusExpired => 'കാലാവധി കഴിഞ്ഞു';

  @override
  String get requestStatusClosed => 'അടച്ചു';

  @override
  String get budgetTypeFlexible => 'വഴക്കമുള്ളത്';

  @override
  String get budgetTypeFixed => 'നിശ്ചിത വില';

  @override
  String get budgetTypeRange => 'വില പരിധി';

  @override
  String get scheduleAsap => 'എത്രയും വേഗം';

  @override
  String get scheduleToday => 'ഇന്ന്';

  @override
  String get scheduleTomorrow => 'നാളെ';

  @override
  String get scheduleSpecificDate => 'ഒരു നിശ്ചിത തീയതിയിൽ';

  @override
  String get scheduleScheduled => 'ഷെഡ്യൂൾ ചെയ്തു';

  @override
  String get offerStatusSubmitted => 'പുതിയ ഓഫർ';

  @override
  String get offerStatusViewed => 'കണ്ടു';

  @override
  String get offerStatusShortlisted => 'ഷോർട്ട്‌ലിസ്റ്റ് ചെയ്തു';

  @override
  String get offerStatusAccepted => 'സ്വീകരിച്ചു';

  @override
  String get offerStatusRejected => 'നിരസിച്ചു';

  @override
  String get offerStatusWithdrawn => 'ജീവനക്കാരൻ പിൻവലിച്ചു';

  @override
  String get offerStatusExpired => 'കാലാവധി കഴിഞ്ഞു';

  @override
  String get offerStatusClosed => 'അടച്ചു';

  @override
  String get gigRatingNew => 'പുതിയത്';

  @override
  String distanceMetres(Object metres) {
    return '$metres മീ';
  }

  @override
  String distanceKm(Object km) {
    return '$km കി.മീ';
  }

  @override
  String durationMinutes(Object minutes) {
    return '$minutes മിനിറ്റ്';
  }

  @override
  String durationHours(Object hours) {
    return '$hours മണിക്കൂർ';
  }

  @override
  String durationHoursMinutes(int hours, int minutes) {
    return '$hours മണിക്കൂർ $minutes മിനിറ്റ്';
  }

  @override
  String get offerWorkerFallbackName => 'വിദഗ്ധൻ';

  @override
  String get budgetFlexible => 'വഴക്കമുള്ള ബജറ്റ്';

  @override
  String get budgetFixed => 'നിശ്ചിത ബജറ്റ്';

  @override
  String offerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ഓഫറുകൾ',
      one: '1 ഓഫർ',
      zero: 'ഇതുവരെ ഓഫറുകളില്ല',
    );
    return '$_temp0';
  }

  @override
  String get authPhoneTenDigits => '10 അക്ക മൊബൈൽ നമ്പർ നൽകുക.';

  @override
  String get authCodeSendTimeout =>
      'കോഡ് അയയ്ക്കാനായില്ല. നിങ്ങളുടെ നെറ്റ്‌വർക്ക് പരിശോധിച്ച് വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get authEnterReceivedCode => 'നിങ്ങൾക്ക് ലഭിച്ച കോഡ് നൽകുക.';

  @override
  String get authSignInIncomplete =>
      'സൈൻ-ഇൻ പൂർത്തിയായില്ല. ദയവായി വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get authSignInToContinue => 'തുടരാൻ ദയവായി സൈൻ ഇൻ ചെയ്യുക.';

  @override
  String get paymentsNotConfigured =>
      'ഈ ബിൽഡിൽ പേയ്‌മെന്റുകൾ ഇതുവരെ കോൺഫിഗർ ചെയ്തിട്ടില്ല.';

  @override
  String get serviceElectrical => 'ഇലക്ട്രിക്കൽ';

  @override
  String get servicePlumbing => 'പ്ലംബിംഗ്';

  @override
  String get serviceAcService => 'AC സർവീസ്';

  @override
  String get serviceApplianceRepair => 'ഉപകരണ അറ്റകുറ്റപ്പണി';

  @override
  String get serviceCarpentry => 'മരപ്പണി';

  @override
  String get servicePainting => 'പെയിന്റിംഗ്';

  @override
  String get serviceCleaning => 'ക്ലീനിംഗ്';

  @override
  String get servicePestControl => 'കീടനിയന്ത്രണം';

  @override
  String get serviceOtherHome => 'മറ്റ് വീട്ടുസേവനങ്ങൾ';

  @override
  String get addressLabelHome => 'ഹോം';

  @override
  String get addressLabelWork => 'ഓഫീസ്';

  @override
  String get addressLabelOther => 'മറ്റുള്ളവ';

  @override
  String get commonSeeAll => 'എല്ലാം കാണുക';

  @override
  String get commonViewAll => 'എല്ലാം കാണുക';

  @override
  String get commonCheckBackLater => 'ദയവായി പിന്നീട് വീണ്ടും നോക്കുക.';

  @override
  String get commonUseCurrentLocation => 'നിലവിലെ ലൊക്കേഷൻ ഉപയോഗിക്കുക';

  @override
  String get commonChooseOnMap => 'മാപ്പിൽ തിരഞ്ഞെടുക്കുക';

  @override
  String homeGreetingNamed(Object name) {
    return 'നമസ്കാരം, $name 👋';
  }

  @override
  String get homeGreeting => 'നമസ്കാരം 👋';

  @override
  String get homeWhatService => 'ഇന്ന് നിങ്ങൾക്ക് ഏത് സേവനമാണ് വേണ്ടത്?';

  @override
  String get homeSetLocation => 'നിങ്ങളുടെ ലൊക്കേഷൻ സജ്ജമാക്കുക';

  @override
  String get homeWorkFinishedApprove =>
      'ജോലി കഴിഞ്ഞു — അംഗീകരിക്കാൻ ടാപ്പ് ചെയ്യുക';

  @override
  String get homeCategories => 'വിഭാഗങ്ങൾ';

  @override
  String homeCategoriesLoadFailed(Object error) {
    return 'വിഭാഗങ്ങൾ ലോഡ് ചെയ്യാനായില്ല: $error';
  }

  @override
  String get homeFindWorker => 'ജീവനക്കാരനെ കണ്ടെത്തുക';

  @override
  String get homeFindWorkerSubtitle => 'സമീപത്തെ സേവനങ്ങൾ കാണുക';

  @override
  String get homePostRequest => 'അഭ്യർത്ഥന പോസ്റ്റ് ചെയ്യുക';

  @override
  String get homePostRequestSubtitle => 'ജീവനക്കാർ നിങ്ങളുടെ അടുത്തേക്ക് വരും';

  @override
  String get homeNoServices => 'ഇപ്പോൾ സേവനങ്ങളൊന്നും ലഭ്യമല്ല';

  @override
  String get homeSearchNear => 'സമീപത്ത് സേവനങ്ങൾ തിരയുക';

  @override
  String get homeSearchHint => 'സേവനങ്ങൾ തിരയുക...';

  @override
  String homeActiveBooking(Object code) {
    return 'സജീവ ബുക്കിംഗ് #$code';
  }

  @override
  String get homeActiveRequests => 'നിങ്ങളുടെ സജീവ അഭ്യർത്ഥനകൾ';

  @override
  String get commonGrantPermission => 'അനുമതി നൽകുക';

  @override
  String get commonView => 'കാണുക';

  @override
  String get exploreTitle => 'സേവനങ്ങൾ തിരയുക, കണ്ടെത്തുക';

  @override
  String get exploreListView => 'ലിസ്റ്റ് കാഴ്ച';

  @override
  String get exploreMapView => 'മാപ്പ് കാഴ്ച';

  @override
  String get exploreSearchHint =>
      'സേവനങ്ങൾ, ജീവനക്കാർ അല്ലെങ്കിൽ കഴിവുകൾ തിരയുക...';

  @override
  String get exploreLocationOffTitle => 'ലൊക്കേഷൻ സേവനങ്ങൾ ഓഫാണ്';

  @override
  String get exploreLocationOffMessage =>
      'സമീപത്തെ വിദഗ്ധരെ കണ്ടെത്താൻ ലൊക്കേഷൻ ഓണാക്കുക.';

  @override
  String get exploreLocationPermissionTitle => 'ലൊക്കേഷൻ അനുമതി ആവശ്യമാണ്';

  @override
  String get exploreLocationPermissionMessage =>
      'സമീപത്തെ വിദഗ്ധരെ കണ്ടെത്താൻ ഞങ്ങൾ നിങ്ങളുടെ ലൊക്കേഷൻ ഉപയോഗിക്കുന്നു.';

  @override
  String get exploreChooseService => 'തിരയാൻ ഒരു സേവനം തിരഞ്ഞെടുക്കുക';

  @override
  String get exploreChooseServiceMessage =>
      'സമീപത്തെ വിദഗ്ധരെ കാണാൻ മുകളിൽ ഒരു വിഭാഗം തിരഞ്ഞെടുക്കുക.';

  @override
  String get exploreNoProfessionals =>
      'ഈ സേവനത്തിന് സമീപത്ത് വിദഗ്ധരാരും ലഭ്യമല്ല';

  @override
  String get exploreLoadFailed => 'വിദഗ്ധരെ ലോഡ് ചെയ്യാനായില്ല.';

  @override
  String exploreByWorker(Object name) {
    return '$name നൽകുന്നത്';
  }

  @override
  String get bookingsTitle => 'എന്റെ സേവന ബുക്കിംഗുകൾ';

  @override
  String get bookingsTabActive => 'സജീവം';

  @override
  String get bookingsTabCompleted => 'പൂർത്തിയായി';

  @override
  String get bookingsTabCancelled => 'റദ്ദാക്കി';

  @override
  String get bookingsLoadFailed => 'നിങ്ങളുടെ ബുക്കിംഗുകൾ ലോഡ് ചെയ്യാനായില്ല.';

  @override
  String get bookingsEmpty => 'ഇതുവരെ ബുക്കിംഗുകളില്ല';

  @override
  String get bookingsFindService => 'സേവനം കണ്ടെത്തുക';

  @override
  String get bookingsWaitingForProfessional => 'വിദഗ്ധനായി കാത്തിരിക്കുന്നു';

  @override
  String bookingsCode(Object code) {
    return 'ബുക്കിംഗ് കോഡ്: #$code';
  }

  @override
  String get bookingsPayNow => 'ഇപ്പോൾ പണമടയ്ക്കുക';

  @override
  String get bookingsApproveWork => 'ജോലി അംഗീകരിക്കുക';

  @override
  String get bookingsTrackLive => 'ലൈവായി ട്രാക്ക് ചെയ്യുക';

  @override
  String get bookingsDetails => 'വിശദാംശങ്ങൾ';

  @override
  String get bookingDetailTitle => 'ബുക്കിംഗ് വിശദാംശങ്ങൾ';

  @override
  String get bookingDetailLoadFailed =>
      'ബുക്കിംഗ് വിശദാംശങ്ങൾ ലോഡ് ചെയ്യാനായില്ല.';

  @override
  String get bookingDetailWaitingAccept =>
      'വിദഗ്ധൻ സ്വീകരിക്കാൻ കാത്തിരിക്കുന്നു';

  @override
  String bookingDetailNumber(Object code) {
    return 'ബുക്കിംഗ് #$code';
  }

  @override
  String bookingDetailStatus(Object status) {
    return 'നില: $status';
  }

  @override
  String get bookingDetailLiveMap => 'ലൈവ് മാപ്പ്';

  @override
  String get bookingDetailServiceInfo => 'സേവന അഭ്യർത്ഥന വിവരങ്ങൾ';

  @override
  String get bookingDetailViewMaterials =>
      'സാമഗ്രി / പാർട്സ് അഭ്യർത്ഥനകൾ കാണുക';

  @override
  String get bookingDetailFareDetails => 'നിരക്ക് വിശദാംശങ്ങൾ';

  @override
  String get bookingDetailEstimatedFare => 'കണക്കാക്കിയ നിരക്ക്';

  @override
  String get bookingDetailFinalFare => 'അന്തിമ സ്ഥിരീകരിച്ച നിരക്ക്';

  @override
  String get bookingDetailRateReview =>
      'സേവന ജീവനക്കാരന് റേറ്റിംഗും അവലോകനവും നൽകുക';

  @override
  String get bookingDetailApproveCompletion => 'പൂർത്തീകരണം അംഗീകരിക്കുക';

  @override
  String get bookingDetailApprovePaidHint =>
      'നിങ്ങളുടെ വിദഗ്ധൻ ഈ ജോലി പൂർത്തിയായതായി അടയാളപ്പെടുത്തി. അംഗീകരിച്ചാൽ നിങ്ങളുടെ പേയ്‌മെന്റ് അവർക്ക് നൽകും.';

  @override
  String get bookingDetailApproveUnpaidHint =>
      'നിങ്ങളുടെ വിദഗ്ധൻ ഈ ജോലി പൂർത്തിയായതായി അടയാളപ്പെടുത്തി. സ്ഥിരീകരിച്ച് പേയ്‌മെന്റിലേക്ക് പോകാൻ അംഗീകരിക്കുക.';

  @override
  String get bookingDetailReportProblem => 'പ്രശ്നം റിപ്പോർട്ട് ചെയ്യുക';

  @override
  String get bookingDetailCompletionApproved => 'പൂർത്തീകരണം അംഗീകരിച്ചു';

  @override
  String bookingDetailPayToConfirm(Object amount) {
    return 'സ്ഥിരീകരിക്കാൻ $amount അടയ്ക്കുക';
  }

  @override
  String get bookingDetailSentAfterPayment =>
      'പേയ്‌മെന്റ് പൂർത്തിയായാൽ നിങ്ങളുടെ ബുക്കിംഗ് വിദഗ്ധന് അയയ്ക്കും.';

  @override
  String bookingDetailPayAmount(Object amount) {
    return '$amount അടയ്ക്കുക';
  }

  @override
  String get bookingDetailCancelBooking => 'ബുക്കിംഗ് റദ്ദാക്കുക';

  @override
  String get cancelReasonMistake => 'തെറ്റായി ബുക്ക് ചെയ്തു';

  @override
  String get cancelReasonNoLongerNeeded => 'എനിക്ക് ഇനി ഈ സേവനം ആവശ്യമില്ല';

  @override
  String get cancelReasonDifferentTime => 'എനിക്ക് മറ്റൊരു സമയം തിരഞ്ഞെടുക്കണം';

  @override
  String get cancelReasonFoundSomeoneElse => 'എനിക്ക് മറ്റൊരാളെ കിട്ടി';

  @override
  String get cancelDialogTitle => 'എന്തുകൊണ്ടാണ് റദ്ദാക്കുന്നത്?';

  @override
  String get cancelDialogRefundNotice =>
      'ഇത് പഴയപടിയാക്കാനാകില്ല. നിങ്ങളുടെ പേയ്‌മെന്റ് യഥാർത്ഥ പേയ്‌മെന്റ് രീതിയിലേക്ക് തിരികെ നൽകും.';

  @override
  String get cancelDialogCannotUndo => 'ഇത് പഴയപടിയാക്കാനാകില്ല.';

  @override
  String get cancelDialogKeepBooking => 'ബുക്കിംഗ് നിലനിർത്തുക';

  @override
  String get bookingCancelledRefund =>
      'ബുക്കിംഗ് റദ്ദാക്കി. നിങ്ങളുടെ റീഫണ്ടിന് അഭ്യർത്ഥിച്ചിട്ടുണ്ട്.';

  @override
  String get bookingCancelled => 'ബുക്കിംഗ് റദ്ദാക്കി';

  @override
  String get arrivalCodeTitle => 'എത്തിച്ചേരൽ കോഡ്';

  @override
  String get arrivalCodeShare =>
      'വിദഗ്ധൻ എത്തിയെന്ന് സ്ഥിരീകരിക്കാൻ ഈ കോഡ് അവരോട് പറയുക:';

  @override
  String get arrivalCodeUnavailable => 'ലഭ്യമല്ല';

  @override
  String get arrivalCodeLoadFailed => 'കോഡ് ലോഡ് ചെയ്യാനായില്ല';

  @override
  String get activeBookingTitle => 'ലൈവ് ബുക്കിംഗും ജീവനക്കാരന്റെ ട്രാക്കിംഗും';

  @override
  String get activeBookingLoadFailed => 'ഈ ബുക്കിംഗ് ലോഡ് ചെയ്യാനായില്ല.';

  @override
  String get activeBookingMapUnavailable =>
      'ഈ ബുക്കിംഗിന് ലൈവ് മാപ്പ് ലഭ്യമല്ല.';

  @override
  String get activeBookingViewDetails => 'ബുക്കിംഗ് വിശദാംശങ്ങൾ കാണുക';

  @override
  String get activeBookingServiceLocation => 'സേവന സ്ഥലം';

  @override
  String get activeBookingYourProfessional => 'നിങ്ങളുടെ വിദഗ്ധൻ';

  @override
  String get activeBookingLive => 'ലൈവ്';

  @override
  String get activeBookingLastKnown => 'അവസാനം അറിയാവുന്ന സ്ഥലം';

  @override
  String get activeBookingPhoneNotShared => 'ഫോൺ ഇതുവരെ പങ്കിട്ടിട്ടില്ല';

  @override
  String get activeBookingCallProfessional => 'വിദഗ്ധനെ വിളിക്കുക';

  @override
  String get activeBookingMaterials => 'സാമഗ്രികൾ';

  @override
  String get activeBookingViewDetailsShort => 'വിശദാംശങ്ങൾ കാണുക';

  @override
  String get locationConnecting =>
      'ലൈവ് ലൊക്കേഷനിലേക്ക് കണക്റ്റ് ചെയ്യുന്നു...';

  @override
  String get locationLiveUnavailable => 'ലൈവ് ലൊക്കേഷൻ താൽക്കാലികമായി ലഭ്യമല്ല';

  @override
  String get locationLiveActive => 'ലൈവ് ലൊക്കേഷൻ സജീവമാണ്';

  @override
  String get locationUpdating => 'അപ്ഡേറ്റ് ചെയ്യുന്നു...';

  @override
  String get locationUnavailable => 'ലൊക്കേഷൻ താൽക്കാലികമായി ലഭ്യമല്ല';

  @override
  String get activeBookingShareStartCode =>
      'ജീവനക്കാരൻ എത്തി! ആരംഭ കോഡ് പറയുക:';

  @override
  String get commonBack => 'തിരികെ';

  @override
  String get paymentCouldNotOpen =>
      'പേയ്‌മെന്റ് സ്ക്രീൻ തുറക്കാനായില്ല. ദയവായി വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get paymentReceived =>
      'പേയ്‌മെന്റ് ലഭിച്ചു. നിങ്ങളുടെ ബുക്കിംഗ് വിദഗ്ധന് അയച്ചു.';

  @override
  String paymentNotConfirmed(String reason, String reference) {
    return 'ഈ പേയ്‌മെന്റ് സ്ഥിരീകരിക്കാനായില്ല: $reason. പണം കുറഞ്ഞിട്ടുണ്ടെങ്കിൽ, $reference റഫറൻസുമായി സഹായവുമായി ബന്ധപ്പെടുക.';
  }

  @override
  String get paymentNotCompleted => 'പേയ്‌മെന്റ് പൂർത്തിയായില്ല.';

  @override
  String paymentExternalWalletUnsupported(Object wallet) {
    return 'ബാഹ്യ വാലറ്റ് ($wallet) തിരഞ്ഞെടുത്തു — ഇത് ഇതുവരെ പിന്തുണയ്ക്കുന്നില്ല.';
  }

  @override
  String get paymentTitle => 'പേയ്‌മെന്റ്';

  @override
  String get paymentStatusUnknown =>
      'ഈ ബുക്കിംഗിന് ഇതിനകം പണമടച്ചോ എന്ന് പരിശോധിക്കാനായില്ല. രണ്ടുതവണ പണമടയ്ക്കുന്നതിന് പകരം ദയവായി വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get paymentBookingLoadFailed => 'ഈ ബുക്കിംഗ് ലോഡ് ചെയ്യാനായില്ല.';

  @override
  String get paymentComplete => 'പേയ്‌മെന്റ് പൂർത്തിയായി';

  @override
  String paymentPaidFor(String amount, String service) {
    return '$service-ന് $amount അടച്ചു.';
  }

  @override
  String get paymentViewBooking => 'ബുക്കിംഗ് കാണുക';

  @override
  String get paymentBookingSummary => 'ബുക്കിംഗ് സംഗ്രഹം';

  @override
  String get paymentProvider => 'സേവനദാതാവ്';

  @override
  String get paymentService => 'സേവനം';

  @override
  String get paymentDate => 'തീയതി';

  @override
  String get paymentTime => 'സമയം';

  @override
  String get paymentAddress => 'വിലാസം';

  @override
  String get paymentTotal => 'ആകെ';

  @override
  String get paymentHeldSecurely =>
      'നിങ്ങളുടെ പേയ്‌മെന്റ് സുരക്ഷിതമായി സൂക്ഷിക്കുകയും നിങ്ങൾ ജോലി അംഗീകരിച്ച ശേഷം മാത്രം വിദഗ്ധന് നൽകുകയും ചെയ്യും. ജോലി തുടങ്ങുന്നതിന് മുമ്പ് ബുക്കിംഗ് റദ്ദാക്കിയാൽ നിങ്ങൾക്ക് റീഫണ്ട് ലഭിക്കും.';

  @override
  String get commonChange => 'മാറ്റുക';

  @override
  String get bookMissingDetails =>
      'ബുക്കിംഗ് വിശദാംശങ്ങൾ ഇല്ല — ദയവായി വീണ്ടും ആരംഭിക്കുക.';

  @override
  String get bookSlotPassed =>
      'ആ സമയം കഴിഞ്ഞു. അടുത്ത ലഭ്യമായ സ്ലോട്ടിലേക്ക് നിങ്ങളെ മാറ്റി — പരിശോധിച്ച് വീണ്ടും സ്ഥിരീകരിക്കുക.';

  @override
  String bookFailed(Object reason) {
    return 'ബുക്കിംഗ് പരാജയപ്പെട്ടു: $reason';
  }

  @override
  String get bookNoAddress => 'വിലാസമൊന്നും തിരഞ്ഞെടുത്തിട്ടില്ല';

  @override
  String get bookTitle => 'സേവനം ബുക്ക് ചെയ്യുക';

  @override
  String get bookSelectDate => 'തീയതി തിരഞ്ഞെടുക്കുക';

  @override
  String get bookSelectTime => 'സമയം തിരഞ്ഞെടുക്കുക';

  @override
  String get bookSpecialInstructions => 'പ്രത്യേക നിർദ്ദേശങ്ങൾ (ഓപ്ഷണൽ)';

  @override
  String get bookSpecialInstructionsHint =>
      'ഉദാ. അടുക്കളയിലും കുളിമുറിയിലും ശ്രദ്ധിക്കുക...';

  @override
  String get bookConfirm => 'ബുക്കിംഗ് സ്ഥിരീകരിക്കുക →';

  @override
  String get gigUnknownProfessional => 'അജ്ഞാത വിദഗ്ധൻ';

  @override
  String get gigNewProfessional => 'പുതിയ വിദഗ്ധൻ';

  @override
  String gigRatingWithCount(String rating, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count അവലോകനങ്ങൾ',
      one: '1 അവലോകനം',
    );
    return '$rating ($_temp0)';
  }

  @override
  String get gigPricing => 'വില';

  @override
  String get gigServiceRate => 'സേവന നിരക്ക്';

  @override
  String get gigFinalAmountNote =>
      'അന്തിമ തുക നിങ്ങളുടെ വിദഗ്ധൻ സ്ഥിരീകരിക്കും, ബുക്കിംഗ് സൃഷ്ടിച്ചാൽ അതിൽ കാണിക്കും.';

  @override
  String get gigKycVerified => 'KYC പരിശോധിച്ചു';

  @override
  String get gigBackgroundVerified => 'പശ്ചാത്തലം പരിശോധിച്ചു';

  @override
  String get gigBookNow => 'ഇപ്പോൾ ബുക്ക് ചെയ്യുക →';

  @override
  String get discoveryTitle => 'ലഭ്യമായ വിദഗ്ധർ';

  @override
  String get discoveryMissingDetails =>
      'സേവനമോ ലൊക്കേഷനോ സംബന്ധിച്ച വിശദാംശങ്ങൾ ഇല്ല.';

  @override
  String get discoveryLocalExperts => 'ലഭ്യമായ പ്രാദേശിക വിദഗ്ധർ';

  @override
  String get discoveryWithin => 'ദൂരപരിധിയിൽ';

  @override
  String get discoveryNoProviders => 'സമീപത്ത് സേവനദാതാക്കളാരും ലഭ്യമല്ല';

  @override
  String get discoveryTryLargerRadius =>
      'വലിയ തിരയൽ ദൂരം പരീക്ഷിക്കുക അല്ലെങ്കിൽ പിന്നീട് നോക്കുക.';

  @override
  String get discoveryLoadFailed =>
      'സമീപത്തെ സേവനദാതാക്കളെ ലോഡ് ചെയ്യാനായില്ല.';

  @override
  String discoveryServicesForJob(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ഈ ജോലിക്ക് $count സേവനങ്ങൾ',
      one: 'ഈ ജോലിക്ക് 1 സേവനം',
    );
    return '$_temp0';
  }

  @override
  String get discoveryBook => 'ബുക്ക് ചെയ്യുക';

  @override
  String get categoryServiceDetails => 'സേവന വിശദാംശങ്ങൾ';

  @override
  String get categoryTagline =>
      'മുൻകൂട്ടി അറിയാവുന്ന വിലയും സേവന ഗ്യാരണ്ടിയുമായി പരിശോധിച്ച, പശ്ചാത്തലം ഉറപ്പാക്കിയ പ്രാദേശിക വിദഗ്ധരെ ബുക്ക് ചെയ്യൂ.';

  @override
  String get categoryWhatHelp => 'എന്തിനാണ് നിങ്ങൾക്ക് സഹായം വേണ്ടത്?';

  @override
  String get categoryDescribeElse => 'മറ്റെന്തെങ്കിലും വിവരിക്കുക';

  @override
  String get categoryLoadFailed => 'ഈ സേവനം ലോഡ് ചെയ്യാനായില്ല.';

  @override
  String get notificationsTitle => 'അറിയിപ്പുകളും അലേർട്ടുകളും';

  @override
  String get notificationsEmpty => 'നിങ്ങൾ എല്ലാം കണ്ടുകഴിഞ്ഞു';

  @override
  String get notificationsLoadFailed => 'അറിയിപ്പുകൾ ലോഡ് ചെയ്യാനായില്ല.';

  @override
  String get timeJustNow => 'ഇപ്പോൾ';

  @override
  String timeMinutesAgo(Object minutes) {
    return '$minutes മിനിറ്റ് മുമ്പ്';
  }

  @override
  String timeHoursAgo(Object hours) {
    return '$hours മണിക്കൂർ മുമ്പ്';
  }

  @override
  String get timeYesterday => 'ഇന്നലെ';

  @override
  String get completedTitle => 'സേവനം പൂർത്തിയായി!';

  @override
  String get completedThanks => 'ഞങ്ങളുടെ സേവനങ്ങൾ ഉപയോഗിച്ചതിന് നന്ദി.';

  @override
  String get completedViewBookings => 'ബുക്കിംഗുകൾ കാണുക';

  @override
  String get completedBackHome => 'ഹോമിലേക്ക് മടങ്ങുക';

  @override
  String commonErrorDetail(Object detail) {
    return 'പിശക്: $detail';
  }

  @override
  String get reviewTitle => 'നിങ്ങളുടെ അനുഭവം റേറ്റ് ചെയ്യുക';

  @override
  String get reviewHeading => 'മികച്ച സേവനം!';

  @override
  String get reviewQuestion =>
      'നിങ്ങളുടെ വിദഗ്ധനുമായുള്ള അനുഭവം എങ്ങനെയായിരുന്നു?';

  @override
  String reviewStars(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count നക്ഷത്രങ്ങൾ',
      one: '1 നക്ഷത്രം',
    );
    return '$_temp0';
  }

  @override
  String get reviewCommentHint => 'നിങ്ങളുടെ അനുഭവത്തെക്കുറിച്ച് പറയൂ...';

  @override
  String get reviewSubmit => 'അവലോകനം സമർപ്പിക്കുക →';

  @override
  String get materialsTitle => 'സാമഗ്രി / പാർട്സ് അഭ്യർത്ഥനകൾ';

  @override
  String get materialsEmpty =>
      'ഈ ബുക്കിംഗിന് സാമഗ്രി അഭ്യർത്ഥനകളൊന്നും സമർപ്പിച്ചിട്ടില്ല';

  @override
  String materialsQuantityEstimated(Object quantity) {
    return '$quantity · കണക്കാക്കിയത്';
  }

  @override
  String materialsQuantityActual(Object quantity) {
    return '$quantity · യഥാർത്ഥം';
  }

  @override
  String get materialsReject => 'നിരസിക്കുക';

  @override
  String get materialsApprove => 'അംഗീകരിക്കുക';

  @override
  String get materialStatusRequested => 'അഭ്യർത്ഥിച്ചു';

  @override
  String get materialStatusCustomerReview =>
      'നിങ്ങളുടെ അവലോകനത്തിനായി കാത്തിരിക്കുന്നു';

  @override
  String get materialStatusApproved => 'അംഗീകരിച്ചു';

  @override
  String get materialStatusRejected => 'നിരസിച്ചു';

  @override
  String get materialStatusPurchased => 'വാങ്ങി';

  @override
  String get materialStatusCostRecorded => 'ചെലവ് രേഖപ്പെടുത്തി';

  @override
  String get materialStatusBilled => 'ബില്ലിൽ ചേർത്തു';

  @override
  String get materialStatusCancelled => 'റദ്ദാക്കി';

  @override
  String get commonSaveChanges => 'മാറ്റങ്ങൾ സേവ് ചെയ്യുക';

  @override
  String get profileTitle => 'എന്റെ പ്രൊഫൈലും അക്കൗണ്ടും';

  @override
  String get profileFallbackName => 'ഉപഭോക്തൃ പ്രൊഫൈൽ';

  @override
  String get profileLanguage => 'ഭാഷ';

  @override
  String get profileAddresses => 'സേവ് ചെയ്ത സേവന വിലാസങ്ങൾ';

  @override
  String get profileAddressesSubtitle =>
      'വീട്, ഓഫീസ്, മറ്റ് വിലാസങ്ങൾ നിയന്ത്രിക്കുക';

  @override
  String get profileHistory => 'മുൻ സേവന ചരിത്രം';

  @override
  String get profileHistorySubtitle => 'രസീതുകളും മുൻ ബുക്കിംഗുകളും കാണുക';

  @override
  String get profileSupport => 'സഹായവും ഉപഭോക്തൃ പിന്തുണയും';

  @override
  String get profileSupportSubtitle =>
      'ടിക്കറ്റ് ഉണ്ടാക്കുക, ഞങ്ങളുടെ ടീമിന്റെ മറുപടികൾ കാണുക';

  @override
  String get editProfileSaved => 'പ്രൊഫൈൽ വിജയകരമായി അപ്ഡേറ്റ് ചെയ്തു';

  @override
  String get editProfileTitle => 'പ്രൊഫൈൽ എഡിറ്റ് ചെയ്യുക';

  @override
  String get editProfileFullName => 'പൂർണ്ണ പേര്';

  @override
  String get editProfileNameEmpty => 'പേര് ശൂന്യമാകരുത്';

  @override
  String get editProfileEmail => 'ഇമെയിൽ വിലാസം';

  @override
  String get commonEdit => 'എഡിറ്റ് ചെയ്യുക';

  @override
  String get commonDelete => 'ഇല്ലാതാക്കുക';

  @override
  String get addressesAdd => 'പുതിയ വിലാസം ചേർക്കുക';

  @override
  String get addressesEmpty => 'നിങ്ങൾ ഇതുവരെ വിലാസമൊന്നും സേവ് ചെയ്തിട്ടില്ല';

  @override
  String get addressesEmptyMessage =>
      'അടുത്ത തവണ വേഗത്തിൽ ബുക്ക് ചെയ്യാൻ ഒരു സേവന വിലാസം ചേർക്കുക.';

  @override
  String get addressesDefaultBadge => 'ഡിഫോൾട്ട്';

  @override
  String get addressesSetDefault => 'ഡിഫോൾട്ടായി സജ്ജമാക്കുക';

  @override
  String get addressesLoadFailed => 'വിലാസങ്ങൾ ലോഡ് ചെയ്യാനായില്ല.';

  @override
  String get addressesLabelSheet => 'ഈ വിലാസത്തിന് പേര് നൽകുക';

  @override
  String get supportTitle => 'സഹായവും പിന്തുണയും';

  @override
  String get supportNewTicket => 'പുതിയ ടിക്കറ്റ്';

  @override
  String get supportEmpty => 'ഇതുവരെ പിന്തുണാ ടിക്കറ്റുകളില്ല';

  @override
  String get supportEmptyMessage =>
      'ബുക്കിംഗിനെക്കുറിച്ചോ ആപ്പിനെക്കുറിച്ചോ സഹായം വേണോ? ടിക്കറ്റ് ഉണ്ടാക്കൂ, ഞങ്ങളുടെ ടീം മറുപടി നൽകും.';

  @override
  String get supportLoadFailed =>
      'നിങ്ങളുടെ പിന്തുണാ ടിക്കറ്റുകൾ ലോഡ് ചെയ്യാനായില്ല.';

  @override
  String get supportStatusOpen => 'തുറന്നത്';

  @override
  String get supportStatusInProgress => 'പുരോഗതിയിൽ';

  @override
  String get supportStatusWaitingForYou => 'നിങ്ങൾക്കായി കാത്തിരിക്കുന്നു';

  @override
  String get supportStatusResolved => 'പരിഹരിച്ചു';

  @override
  String get supportStatusClosed => 'അടച്ചു';

  @override
  String get supportNewTicketTitle => 'പുതിയ പിന്തുണാ ടിക്കറ്റ്';

  @override
  String get supportCategory => 'വിഭാഗം';

  @override
  String get supportSubject => 'വിഷയം';

  @override
  String get supportDescribeIssue => 'പ്രശ്നം വിവരിക്കുക';

  @override
  String get supportFillSubjectMessage =>
      'ദയവായി വിഷയവും സന്ദേശവും പൂരിപ്പിക്കുക.';

  @override
  String get supportSubmitTicket => 'ടിക്കറ്റ് സമർപ്പിക്കുക';

  @override
  String get supportTicketTitle => 'പിന്തുണാ ടിക്കറ്റ്';

  @override
  String get supportNoMessages => 'ഇതുവരെ സന്ദേശങ്ങളില്ല';

  @override
  String get supportMessagesLoadFailed => 'സന്ദേശങ്ങൾ ലോഡ് ചെയ്യാനായില്ല.';

  @override
  String get supportTypeMessage => 'ഒരു സന്ദേശം ടൈപ്പ് ചെയ്യുക...';

  @override
  String get supportSend => 'അയയ്ക്കുക';

  @override
  String get pickerEnterAddress =>
      'ദയവായി ഈ പിന്നിന്റെ വിലാസം നൽകുക അല്ലെങ്കിൽ സ്ഥിരീകരിക്കുക';

  @override
  String get pickerTitle => 'സേവന വിലാസം തിരഞ്ഞെടുക്കുക';

  @override
  String get pickerGettingLocation => 'നിങ്ങളുടെ ലൊക്കേഷൻ കണ്ടെത്തുന്നു...';

  @override
  String get pickerPermissionDenied =>
      'ലൊക്കേഷൻ അനുമതി നിഷേധിച്ചു — വിലാസം തിരഞ്ഞെടുക്കാൻ മാപ്പ് സ്വയം നീക്കുക.';

  @override
  String get pickerConfirmPin => 'സേവന പിൻ സ്ഥാനം സ്ഥിരീകരിക്കുക';

  @override
  String get pickerAddressLabel => 'വീട് / ഫ്ലാറ്റ് / തെരുവിന്റെ പേര്';

  @override
  String get pickerAddressHint => 'ഉദാ. #102, ഗ്രീൻ അവന്യൂ, ഇന്ദിരാനഗർ';

  @override
  String get pickerLandmarkLabel => 'അടയാളം (ഓപ്ഷണൽ)';

  @override
  String get pickerLandmarkHint => 'ഉദാ. HDFC ബാങ്ക് ATM-ന് സമീപം';

  @override
  String get pickerConfirm => 'ലൊക്കേഷൻ സ്ഥിരീകരിച്ച് തുടരുക';

  @override
  String get requestSelectLocation => 'ദയവായി സേവന സ്ഥലം തിരഞ്ഞെടുക്കുക';

  @override
  String requestTitle(Object service) {
    return '$service അഭ്യർത്ഥിക്കുക';
  }

  @override
  String get requestServiceAddress => 'സേവന വിലാസം';

  @override
  String get requestDetectingLocation => 'നിങ്ങളുടെ ലൊക്കേഷൻ കണ്ടെത്തുന്നു…';

  @override
  String get requestTapToPickLocation =>
      'സേവന സ്ഥലം തിരഞ്ഞെടുക്കാൻ ടാപ്പ് ചെയ്യുക';

  @override
  String get requestDescribeIssue => 'പ്രശ്നം / ജോലി വിവരിക്കുക';

  @override
  String get requestDescribeHint =>
      'ഉദാ. സ്വീകരണമുറിയിലെ പ്രധാന സീലിംഗ് ലൈറ്റ് സ്വിച്ച് ഓണാക്കുമ്പോൾ തീപ്പൊരി വരുന്നു.';

  @override
  String get requestDescribeMin =>
      'ദയവായി പ്രശ്നം കുറഞ്ഞത് 10 അക്ഷരങ്ങളിൽ വിവരിക്കുക';

  @override
  String get requestAttachPhotos => 'പ്രശ്നത്തിന്റെ ഫോട്ടോകൾ ചേർക്കുക (ഓപ്ഷണൽ)';

  @override
  String get requestAddPhoto => 'ഫോട്ടോ ചേർക്കുക';

  @override
  String get requestWhen => 'നിങ്ങൾക്ക് എപ്പോഴാണ് സേവനം വേണ്ടത്?';

  @override
  String get requestInstant => '⚡ ഉടനടി (30 മിനിറ്റ്)';

  @override
  String get requestScheduleLater => '📅 പിന്നീടത്തേക്ക് ഷെഡ്യൂൾ ചെയ്യുക';

  @override
  String get requestFindWorkers => 'ലഭ്യമായ ജീവനക്കാരെ കണ്ടെത്തുക';

  @override
  String commonLoadFailedDetail(Object detail) {
    return 'ലോഡ് ചെയ്യാനായില്ല: $detail';
  }

  @override
  String get myRequestsTitle => 'എന്റെ സേവന അഭ്യർത്ഥനകൾ';

  @override
  String get myRequestsTabAll => 'എല്ലാം';

  @override
  String get myRequestsNew => 'പുതിയ അഭ്യർത്ഥന';

  @override
  String get myRequestsNoActive => 'സജീവ അഭ്യർത്ഥനകളില്ല';

  @override
  String get myRequestsNoCompleted => 'പൂർത്തിയായ അഭ്യർത്ഥനകളില്ല';

  @override
  String get myRequestsNone => 'ഇതുവരെ സേവന അഭ്യർത്ഥനകളില്ല';

  @override
  String get myRequestsEmptyMessage =>
      'നിങ്ങളുടെ ആവശ്യം പോസ്റ്റ് ചെയ്യൂ, ജീവനക്കാർ നിങ്ങളുടെ അടുത്തേക്ക് വരും.';

  @override
  String get requestDetailTitle => 'അഭ്യർത്ഥന വിശദാംശങ്ങൾ';

  @override
  String get requestDetailBudget => 'ബജറ്റ്';

  @override
  String get requestDetailSchedule => 'ഷെഡ്യൂൾ';

  @override
  String get requestDetailLocation => 'ലൊക്കേഷൻ';

  @override
  String get requestDetailNotes => 'കുറിപ്പുകൾ';

  @override
  String get requestDetailCancel => 'അഭ്യർത്ഥന റദ്ദാക്കുക';

  @override
  String requestDetailOffersReceived(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ഓഫറുകൾ ലഭിച്ചു',
      one: '1 ഓഫർ ലഭിച്ചു',
      zero: 'ഇതുവരെ ഓഫറുകളില്ല',
    );
    return '$_temp0';
  }

  @override
  String get requestDetailTapToCompare =>
      'കാണാനും താരതമ്യം ചെയ്യാനും ടാപ്പ് ചെയ്യുക';

  @override
  String get requestDetailWorkersSoon => 'ജീവനക്കാർ ഉടൻ പ്രതികരിച്ചുതുടങ്ങും';

  @override
  String get requestCancelDialogTitle => 'ഈ അഭ്യർത്ഥന റദ്ദാക്കണോ?';

  @override
  String get requestCancelDialogBody =>
      'തീർപ്പാകാത്ത എല്ലാ ഓഫറുകളും അടയ്ക്കും. ഇത് പഴയപടിയാക്കാനാകില്ല.';

  @override
  String get requestCancelKeep => 'നിലനിർത്തുക';

  @override
  String get requestCancelConfirm => 'അഭ്യർത്ഥന റദ്ദാക്കുക';

  @override
  String get requestCancelled => 'അഭ്യർത്ഥന റദ്ദാക്കി';

  @override
  String requestExpiresInDaysHours(int days, int hours) {
    return '$days ദിവസം $hours മണിക്കൂറിൽ കാലാവധി കഴിയും';
  }

  @override
  String requestExpiresInHoursMinutes(int hours, int minutes) {
    return '$hours മണിക്കൂർ $minutes മിനിറ്റിൽ കാലാവധി കഴിയും';
  }

  @override
  String requestExpiresInMinutes(Object minutes) {
    return '$minutes മിനിറ്റിൽ കാലാവധി കഴിയും';
  }

  @override
  String get requestExpiresSoon => 'ഉടൻ കാലാവധി കഴിയും';

  @override
  String get commonCancel => 'റദ്ദാക്കുക';

  @override
  String get offersTitle => 'ലഭിച്ച ഓഫറുകൾ';

  @override
  String get offersEmptyMessage =>
      'ജീവനക്കാർ നിങ്ങളുടെ അഭ്യർത്ഥന പരിശോധിക്കുന്നു. ആരെങ്കിലും പ്രതികരിച്ചാൽ നിങ്ങളെ അറിയിക്കും.';

  @override
  String get offersPending => 'തീർപ്പാകാത്ത ഓഫറുകൾ';

  @override
  String get offersPast => 'മുൻ ഓഫറുകൾ';

  @override
  String offersJobsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ജോലികൾ',
      one: '1 ജോലി',
    );
    return '$_temp0';
  }

  @override
  String get offersInsured => 'ഇൻഷുർ ചെയ്തത്';

  @override
  String get offersDecline => 'നിരസിക്കുക';

  @override
  String get offersAcceptOffer => 'ഓഫർ സ്വീകരിക്കുക';

  @override
  String get offersAcceptDialogTitle => 'ഈ ഓഫർ സ്വീകരിക്കണോ?';

  @override
  String offersAcceptDialogBody(String worker, String price) {
    return '$worker-മായി $price-ന് ഒരു ബുക്കിംഗ് സൃഷ്ടിക്കും. മറ്റെല്ലാ ഓഫറുകളും അടയ്ക്കും.';
  }

  @override
  String get offersAccept => 'സ്വീകരിക്കുക';

  @override
  String offersBookingCreated(Object code) {
    return 'ബുക്കിംഗ് $code സൃഷ്ടിച്ചു!';
  }

  @override
  String get commonNext => 'അടുത്തത്';

  @override
  String postRequestPosted(Object code) {
    return 'സേവന അഭ്യർത്ഥന $code പോസ്റ്റ് ചെയ്തു!';
  }

  @override
  String get postRequestTitle => 'സേവന അഭ്യർത്ഥന പോസ്റ്റ് ചെയ്യുക';

  @override
  String get postRequestWhatService => 'നിങ്ങൾക്ക് ഏത് സേവനമാണ് വേണ്ടത്?';

  @override
  String get postRequestSelectCategory =>
      'നിങ്ങളുടെ ആവശ്യത്തെ ഏറ്റവും നന്നായി വിവരിക്കുന്ന വിഭാഗം തിരഞ്ഞെടുക്കുക.';

  @override
  String get postRequestDescribe => 'നിങ്ങളുടെ ആവശ്യം വിവരിക്കുക';

  @override
  String postRequestServiceLabel(Object service) {
    return 'സേവനം: $service';
  }

  @override
  String get postRequestWhatDone => 'എന്ത് ജോലിയാണ് ചെയ്യേണ്ടത്?';

  @override
  String get postRequestFieldTitle => 'തലക്കെട്ട്';

  @override
  String get postRequestTitleHint =>
      'ഉദാ. അടുക്കളയിലെ ചോരുന്ന ടാപ്പ് നന്നാക്കൽ';

  @override
  String postRequestMinChars(Object count) {
    return 'കുറഞ്ഞത് $count അക്ഷരങ്ങൾ നൽകുക';
  }

  @override
  String get postRequestFieldDescription => 'വിവരണം';

  @override
  String get postRequestDescriptionHint => 'പ്രശ്നം വിശദമായി വിവരിക്കുക…';

  @override
  String get postRequestFieldNotes => 'അധിക കുറിപ്പുകൾ (ഓപ്ഷണൽ)';

  @override
  String get postRequestNotesHint => 'ഗേറ്റ് കോഡ്, ഇഷ്ടപ്പെട്ട സമയം തുടങ്ങിയവ';

  @override
  String get postRequestBudgetTitle => 'നിങ്ങളുടെ ബജറ്റ്';

  @override
  String get postRequestBudgetHint =>
      'നിങ്ങൾ എത്ര നൽകാൻ തയ്യാറാണെന്ന് ജീവനക്കാരെ അറിയിക്കുക.';

  @override
  String get postRequestFixedPrice => 'നിശ്ചിത വില (₹)';

  @override
  String postRequestExample(Object example) {
    return 'ഉദാ. $example';
  }

  @override
  String get postRequestMin => 'കുറഞ്ഞത് (₹)';

  @override
  String get postRequestMax => 'കൂടിയത് (₹)';

  @override
  String get postRequestWhenTitle => 'നിങ്ങൾക്ക് ഇത് എപ്പോൾ വേണം?';

  @override
  String get postRequestPickDate => 'ഒരു തീയതി തിരഞ്ഞെടുക്കുക';

  @override
  String get postRequestLocationTitle => 'സേവന സ്ഥലം';

  @override
  String get postRequestAddressPrivate =>
      'നിങ്ങൾ ഓഫർ സ്വീകരിച്ച ശേഷം മാത്രമേ നിങ്ങളുടെ കൃത്യമായ വിലാസം പങ്കിടൂ.';

  @override
  String get postRequestFullAddress => 'പൂർണ്ണ വിലാസം';

  @override
  String get postRequestValidAddress => 'സാധുവായ വിലാസം നൽകുക';

  @override
  String get postRequestCity => 'നഗരം';

  @override
  String get postRequestCityHint => 'ഉദാ. ബെംഗളൂരു';

  @override
  String get postRequestPincode => 'പിൻകോഡ്';

  @override
  String get postRequestLocationSet => 'ലൊക്കേഷൻ സജ്ജമാക്കി ✓';

  @override
  String get postRequestSetOnMap => 'മാപ്പിൽ ലൊക്കേഷൻ സജ്ജമാക്കുക';

  @override
  String get postRequestReviewTitle => 'നിങ്ങളുടെ അഭ്യർത്ഥന അവലോകനം ചെയ്യുക';

  @override
  String get postRequestNotSelected => 'തിരഞ്ഞെടുത്തിട്ടില്ല';

  @override
  String get postRequestWhen => 'എപ്പോൾ';

  @override
  String get postRequestPrivacyNote =>
      'നിങ്ങൾ ഓഫർ സ്വീകരിച്ച് ബുക്കിംഗ് സൃഷ്ടിക്കുന്നതുവരെ നിങ്ങളുടെ കൃത്യമായ വിലാസം സ്വകാര്യമായിരിക്കും.';

  @override
  String get postRequestSubmit => 'അഭ്യർത്ഥന സമർപ്പിക്കുക';

  @override
  String get assistantOpening =>
      'എന്താണ് പ്രശ്നമെന്ന് നിങ്ങളുടെ വാക്കുകളിൽ പറയൂ — അതിന് പറ്റിയ വിദഗ്ധനെ ഞാൻ കണ്ടെത്തിത്തരാം.';

  @override
  String assistantCatalogueFailed(Object reason) {
    return '$reason അതിന് മറുപടി നൽകാൻ എനിക്ക് സേവനങ്ങളുടെ പട്ടിക വേണം.';
  }

  @override
  String get assistantCatalogueError =>
      'സേവനങ്ങളുടെ പട്ടിക ലോഡ് ചെയ്യുന്നതിൽ എന്തോ പിശക് സംഭവിച്ചു.';

  @override
  String get assistantGreeting =>
      'നമസ്കാരം. വീട്ടിൽ എന്തിനാണ് സഹായം വേണ്ടത്? ചോരുന്ന ടാപ്പ്, തണുപ്പിക്കാത്ത AC, തീപ്പൊരി വരുന്ന സ്വിച്ച് — എന്തായാലും, നിങ്ങൾക്ക് ഇഷ്ടമുള്ള രീതിയിൽ വിവരിക്കൂ.';

  @override
  String get assistantTooVague =>
      'എനിക്ക് സഹായിക്കാനാകും — പ്രശ്നം എന്താണെന്ന് അറിഞ്ഞാൽ മതി. എന്താണ് പ്രവർത്തിക്കാത്തത്?';

  @override
  String assistantMultipleJobs(int count) {
    return 'ഇവ $count വ്യത്യസ്ത ജോലികളായി തോന്നുന്നു — ഇവയ്ക്ക് വ്യത്യസ്ത പണിക്കാർ വേണം. ഓരോന്നും ഇവിടെ:';
  }

  @override
  String get assistantAmbiguous =>
      'ഇത് ശരിയായി ചെയ്യണമെന്നുണ്ട് — ഇത് ഒന്നിലധികം ജോലികളിൽ പെടാം. ഏതാണ് കൂടുതൽ അടുത്തത്?';

  @override
  String get assistantUnmatched =>
      'പ്ലാറ്റ്‌ഫോമിലെ ഒരു സേവനവുമായും ഇത് ചേർക്കാനായില്ല. ഏറ്റവും അടുത്തത് തിരഞ്ഞെടുക്കൂ, നിങ്ങളുടെ വിവരണം ഞാൻ അവിടേക്ക് കൊണ്ടുപോകാം — അല്ലെങ്കിൽ അഭ്യർത്ഥനയായി പോസ്റ്റ് ചെയ്യൂ, വിദഗ്ധർ നിങ്ങളുടെ അടുത്തേക്ക് വരും.';

  @override
  String assistantConfidentWithProblem(String service, String problem) {
    return 'ഇത് $service ജോലിയാണെന്ന് തോന്നുന്നു — മിക്കവാറും \"$problem\".';
  }

  @override
  String assistantConfident(Object service) {
    return 'ഇത് $service ജോലിയാണെന്ന് തോന്നുന്നു.';
  }

  @override
  String assistantChosen(Object service) {
    return 'ശരി, $service. നിങ്ങൾ എഴുതിയ വിവരണം അതേപടി അയയ്ക്കും.';
  }

  @override
  String get assistantTitle => 'സേവന സഹായി';

  @override
  String get assistantSubtitle =>
      'നിങ്ങളുടെ പ്രശ്നത്തിന് പറ്റിയ ജോലി കണ്ടെത്തുന്നു';

  @override
  String get assistantStartOver => 'വീണ്ടും ആരംഭിക്കുക';

  @override
  String assistantMatchedOn(Object terms) {
    return 'പൊരുത്തപ്പെട്ടവ: $terms';
  }

  @override
  String get assistantFindWorkers => 'ജീവനക്കാരെ കണ്ടെത്തുക';

  @override
  String get assistantPostRequest => 'അഭ്യർത്ഥന പോസ്റ്റ് ചെയ്യുക';

  @override
  String get assistantInputHint => 'പ്രശ്നം വിവരിക്കുക...';
}
