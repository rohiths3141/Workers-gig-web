// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malayalam (`ml`).
class AppLocalizationsMl extends AppLocalizations {
  AppLocalizationsMl([String locale = 'ml']) : super(locale);

  @override
  String get languagePickerTitle => 'നിങ്ങളുടെ ഭാഷ തിരഞ്ഞെടുക്കുക';

  @override
  String get startupMissingConfig => 'ഈ ബിൽഡിൽ കോൺഫിഗറേഷൻ ഇല്ല.';

  @override
  String startupPassDartDefine(Object keys) {
    return 'ഇവ --dart-define ഉപയോഗിച്ച് നൽകുക:\n\n$keys';
  }

  @override
  String get startupCouldNotStart => 'ആപ്പ് ആരംഭിക്കാനായില്ല.';

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
  String get eligibilityStepIncomplete => 'ഈ ഘട്ടം ഇതുവരെ പൂർത്തിയായിട്ടില്ല.';

  @override
  String get errorSessionEnded =>
      'നിങ്ങളുടെ സെഷൻ അവസാനിച്ചു. ദയവായി വീണ്ടും സൈൻ ഇൻ ചെയ്യുക.';

  @override
  String get errorUploadFailed =>
      'ആ ഫയൽ അപ്‌ലോഡ് ചെയ്യാനായില്ല. വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get errorServiceUnavailable =>
      'ആ സേവനം ഇപ്പോൾ ലഭ്യമല്ല. അൽപ്പസമയത്തിന് ശേഷം വീണ്ടും ശ്രമിക്കുക.';

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
  String get authErrorPhoneNotEnabledRegion =>
      'ഫോൺ സൈൻ-ഇൻ പ്രവർത്തനക്ഷമമല്ല, അല്ലെങ്കിൽ ഈ മേഖലയിലേക്ക് SMS തടഞ്ഞിരിക്കുന്നു. Firebase Console ക്രമീകരണങ്ങൾ പരിശോധിക്കുക.';

  @override
  String get authErrorNumberInUse =>
      'ആ നമ്പർ ഇതിനകം മറ്റൊരു അക്കൗണ്ടിൽ രജിസ്റ്റർ ചെയ്തിട്ടുണ്ട്.';

  @override
  String get authErrorSignInAgain => 'തുടരാൻ ദയവായി വീണ്ടും സൈൻ ഇൻ ചെയ്യുക.';

  @override
  String get authErrorSignInFailed =>
      'സൈൻ-ഇൻ പരാജയപ്പെട്ടു. ദയവായി വീണ്ടും ശ്രമിക്കുക.';

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
  String get scheduleSpecificDate => 'നിശ്ചിത തീയതി';

  @override
  String get offerStatusSubmitted => 'സമർപ്പിച്ചു';

  @override
  String get offerStatusViewed => 'ഉപഭോക്താവ് കണ്ടു';

  @override
  String get offerStatusShortlisted => 'ഷോർട്ട്‌ലിസ്റ്റ് ചെയ്തു';

  @override
  String get offerStatusAccepted => 'സ്വീകരിച്ചു ✓';

  @override
  String get offerStatusRejected => 'തിരഞ്ഞെടുത്തിട്ടില്ല';

  @override
  String get offerStatusWithdrawn => 'പിൻവലിച്ചു';

  @override
  String get offerStatusExpired => 'കാലാവധി കഴിഞ്ഞു';

  @override
  String get offerStatusClosed => 'അടച്ചു';

  @override
  String distanceMetresAway(Object metres) {
    return '$metres മീ അകലെ';
  }

  @override
  String distanceKmAway(Object km) {
    return '$km കി.മീ അകലെ';
  }

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
  String get gigErrorTrade =>
      'ഈ സേവനം ഏത് ജോലിയിൽ പെടുന്നുവെന്ന് തിരഞ്ഞെടുക്കുക';

  @override
  String get gigErrorTitleShort =>
      'ഈ സേവനത്തിന് കുറഞ്ഞത് 6 അക്ഷരങ്ങളുള്ള വ്യക്തമായ പേര് നൽകുക';

  @override
  String get gigErrorTitleLong => 'പേര് 120 അക്ഷരങ്ങളിൽ താഴെയാക്കുക';

  @override
  String get gigErrorPrice => 'ഈ സേവനത്തിന് നിങ്ങൾ ഈടാക്കുന്നത് നൽകുക';

  @override
  String get gigErrorDurationMissing => 'ഇതിന് സാധാരണ എത്ര സമയമെടുക്കും?';

  @override
  String get gigErrorDurationShort =>
      'ഞങ്ങൾക്ക് ലിസ്റ്റ് ചെയ്യാവുന്ന ഏറ്റവും ചെറിയ ജോലി 15 മിനിറ്റാണ്';

  @override
  String get gigErrorDurationLong =>
      'ഞങ്ങൾക്ക് ലിസ്റ്റ് ചെയ്യാവുന്ന ഏറ്റവും നീണ്ട ജോലി 14 ദിവസമാണ്';

  @override
  String get gigErrorRadius => 'യാത്രാദൂരം 1 മുതൽ 100 കി.മീ വരെ ആയിരിക്കണം';

  @override
  String get jobAreaNearby => 'സമീപത്ത്';

  @override
  String get jobBlockerVerifyArrival =>
      'ഉപഭോക്താവിന്റെ കോഡ് ഉപയോഗിച്ച് എത്തിച്ചേരൽ പരിശോധിക്കുക';

  @override
  String get jobBlockerAfterPhoto => 'പൂർത്തിയായ ജോലിയുടെ ഫോട്ടോ ചേർക്കുക';

  @override
  String jobBlockerMaterialsPending(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count സാമഗ്രി അഭ്യർത്ഥനകൾ ഇപ്പോഴും ഉപഭോക്താവിനായി കാത്തിരിക്കുന്നു',
      one: '1 സാമഗ്രി അഭ്യർത്ഥന ഇപ്പോഴും ഉപഭോക്താവിനായി കാത്തിരിക്കുന്നു',
    );
    return '$_temp0';
  }

  @override
  String mediaTypeNotAccepted(Object kinds) {
    return 'ആ ഫയൽ തരം ഇവിടെ സ്വീകരിക്കില്ല. $kinds ഉപയോഗിക്കുക.';
  }

  @override
  String get mediaEmpty => 'ആ ഫയൽ ശൂന്യമാണ്.';

  @override
  String mediaTooLarge(Object megabytes) {
    return 'ആ ഫയൽ വളരെ വലുതാണ്. പരിധി ${megabytes}MB ആണ്.';
  }

  @override
  String get verificationNotStarted => 'ആരംഭിച്ചിട്ടില്ല';

  @override
  String get verificationSubmitted => 'സമർപ്പിച്ചു';

  @override
  String get verificationUnderReview => 'അവലോകനത്തിലാണ്';

  @override
  String get verificationMoreInfo => 'കൂടുതൽ വിവരങ്ങൾ വേണം';

  @override
  String get verificationExpired => 'കാലാവധി കഴിഞ്ഞു';

  @override
  String get verificationVerified => 'പരിശോധിച്ചു';

  @override
  String get verificationNotApproved => 'അംഗീകരിച്ചിട്ടില്ല';

  @override
  String get verificationNotRequired => 'ആവശ്യമില്ല';

  @override
  String get qualificationErrorInstitution => 'ഏത് സ്ഥാപനമാണ് ഇത് നൽകിയത്?';

  @override
  String get qualificationErrorName => 'യോഗ്യതയുടെ പേര് എന്താണ്?';

  @override
  String get qualificationErrorYearMissing =>
      'ഏത് വർഷമാണ് നിങ്ങൾ ഇത് പൂർത്തിയാക്കിയത്?';

  @override
  String qualificationErrorYearRange(Object year) {
    return '1950-നും $year-നും ഇടയിലുള്ള വർഷം നൽകുക';
  }

  @override
  String get walletTxJobEarning => 'ജോലിയുടെ വരുമാനം';

  @override
  String get walletTxMaterialReimbursed => 'സാമഗ്രി ചെലവ് തിരികെ';

  @override
  String get walletTxAdjustment => 'ക്രമീകരണം';

  @override
  String get walletTxPayoutReturned => 'പേഔട്ട് തിരികെ വന്നു';

  @override
  String get walletTxPlatformFee => 'പ്ലാറ്റ്‌ഫോം ഫീസ്';

  @override
  String get walletTxWithdrawn => 'പിൻവലിച്ചു';

  @override
  String get walletTxClaimRecovery => 'ക്ലെയിം വീണ്ടെടുക്കൽ';

  @override
  String get payoutStatusRequested => 'അഭ്യർത്ഥിച്ചു';

  @override
  String get payoutStatusProcessing => 'പ്രോസസ്സ് ചെയ്യുന്നു';

  @override
  String get payoutStatusPaid => 'പണമടച്ചു';

  @override
  String get payoutStatusFailed => 'പരാജയപ്പെട്ടു';

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
  String get accountDeletionBySupport =>
      'അക്കൗണ്ട് ഇല്ലാതാക്കൽ ഞങ്ങളുടെ പിന്തുണാ ടീമാണ് കൈകാര്യം ചെയ്യുന്നത്. അഭ്യർത്ഥന നൽകുക, പൂർത്തിയായാൽ ഞങ്ങൾ സ്ഥിരീകരിക്കും.';

  @override
  String get photoUploadFailed => 'ആ ഫോട്ടോ അപ്‌ലോഡ് ചെയ്യാനായില്ല.';

  @override
  String get photoUploadFailedRetry =>
      'ആ ഫോട്ടോ അപ്‌ലോഡ് ചെയ്യാനായില്ല. വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get locationInvalid => 'ആ ലൊക്കേഷൻ ശരിയായി തോന്നുന്നില്ല.';

  @override
  String get travelDistanceRange =>
      '1 മുതൽ 100 കി.മീ വരെയുള്ള യാത്രാദൂരം തിരഞ്ഞെടുക്കുക.';

  @override
  String get profileLoadFailed => 'നിങ്ങളുടെ പ്രൊഫൈൽ ലോഡ് ചെയ്യാനായില്ല.';

  @override
  String get uploadIncomplete => 'അപ്‌ലോഡ് പൂർത്തിയായില്ല. വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get uploadTooLarge => 'ആ ഫയൽ വളരെ വലുതാണ്.';

  @override
  String get uploadTypeNotAccepted => 'ആ ഫയൽ തരം സ്വീകരിക്കില്ല.';

  @override
  String get uploadRefused => 'ആ ഫയൽ നിരസിച്ചു.';

  @override
  String get uploadTooMany =>
      'ഒരേസമയം വളരെയധികം അപ്‌ലോഡുകൾ. അൽപ്പം കാത്തിരുന്ന് വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get uploadGone =>
      'ആ അപ്‌ലോഡ് ഇനി ലഭ്യമല്ല. ഫയൽ വീണ്ടും തിരഞ്ഞെടുക്കുക.';

  @override
  String get uploadDidNotStart => 'അപ്‌ലോഡ് ആരംഭിച്ചില്ല.';

  @override
  String get uploadDidNotFinish => 'ആ അപ്‌ലോഡ് പൂർത്തിയായില്ല.';

  @override
  String get claimResponseTooShort =>
      'ദയവായി എന്താണ് സംഭവിച്ചതെന്ന് കുറച്ചുകൂടി വിശദമായി പറയുക.';

  @override
  String get walletLoadFailedRetry =>
      'നിങ്ങളുടെ വാലറ്റ് ലോഡ് ചെയ്യാനായില്ല. ദയവായി വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get walletLoadFailed => 'നിങ്ങളുടെ വാലറ്റ് ലോഡ് ചെയ്യാനായില്ല.';

  @override
  String get onboardingStepDetails => 'നിങ്ങളുടെ വിവരങ്ങൾ';

  @override
  String get onboardingStepTrade => 'നിങ്ങളുടെ പ്രധാന ജോലി';

  @override
  String get onboardingStepSkills => 'നിങ്ങൾക്ക് എന്ത് ചെയ്യാനാകും';

  @override
  String get onboardingStepArea => 'നിങ്ങൾ എവിടെ ജോലി ചെയ്യുന്നു';

  @override
  String get onboardingStepKyc => 'ഐഡന്റിറ്റി പരിശോധന';

  @override
  String get onboardingStepReady => 'ജോലിക്ക് തയ്യാർ';

  @override
  String routerScreenNotFound(Object location) {
    return 'ആ സ്ക്രീൻ തുറക്കാനായില്ല.\n$location';
  }

  @override
  String get cameraOpenFailed =>
      'ക്യാമറ തുറക്കാനായില്ല. ആപ്പ് അനുമതികൾ പരിശോധിക്കുക.';

  @override
  String get commonTryAgain => 'വീണ്ടും ശ്രമിക്കുക';

  @override
  String get commonCancel => 'റദ്ദാക്കുക';

  @override
  String get commonConfirm => 'സ്ഥിരീകരിക്കുക';

  @override
  String get offlineBanner =>
      'നിങ്ങൾ ഓഫ്‌ലൈനാണ്. വീണ്ടും കണക്റ്റ് ചെയ്താൽ ജോലി പ്രവർത്തനങ്ങൾ വീണ്ടും പ്രവർത്തിക്കും.';

  @override
  String get badgeNew => 'പുതിയത്';

  @override
  String get badgeAccepted => 'സ്വീകരിച്ചു';

  @override
  String get badgeConfirmed => 'സ്ഥിരീകരിച്ചു';

  @override
  String get badgeOnTheWay => 'വഴിയിലാണ്';

  @override
  String get badgeArrived => 'എത്തി';

  @override
  String get badgeWorking => 'ജോലി ചെയ്യുന്നു';

  @override
  String get badgeAwaitingCustomer => 'ഉപഭോക്താവിനായി കാത്തിരിക്കുന്നു';

  @override
  String get badgeDone => 'പൂർത്തിയായി';

  @override
  String get badgePaymentDue => 'പേയ്‌മെന്റ് ബാക്കി';

  @override
  String get badgePaid => 'പണമടച്ചു';

  @override
  String get badgeClosed => 'അടച്ചു';

  @override
  String get badgeCancelled => 'റദ്ദാക്കി';

  @override
  String get badgeDisputed => 'തർക്കത്തിലാണ്';

  @override
  String get badgeExpired => 'കാലാവധി കഴിഞ്ഞു';

  @override
  String get badgeDraft => 'ഡ്രാഫ്റ്റ്';

  @override
  String get badgeInReview => 'അവലോകനത്തിൽ';

  @override
  String get badgeLive => 'ലൈവ്';

  @override
  String get badgePaused => 'താൽക്കാലികമായി നിർത്തി';

  @override
  String get badgeNotApproved => 'അംഗീകരിച്ചിട്ടില്ല';

  @override
  String get badgeRemoved => 'നീക്കം ചെയ്തു';

  @override
  String get badgeNotStarted => 'ആരംഭിച്ചിട്ടില്ല';

  @override
  String get badgeSubmitted => 'സമർപ്പിച്ചു';

  @override
  String get badgeActionNeeded => 'നടപടി ആവശ്യം';

  @override
  String get badgeVerified => 'പരിശോധിച്ചു';

  @override
  String get badgeNotRequired => 'ആവശ്യമില്ല';

  @override
  String get commonContinue => 'തുടരുക';

  @override
  String get commonSaving => 'സേവ് ചെയ്യുന്നു…';

  @override
  String get welcomePromiseWorkTitle => 'അനുയോജ്യമായ ജോലി നേടൂ';

  @override
  String get welcomePromiseWorkBody =>
      'നിങ്ങളുടെ സമീപത്തെ ജോലികൾ, നിങ്ങൾ യഥാർത്ഥത്തിൽ ചെയ്യുന്ന ജോലികളുമായി പൊരുത്തപ്പെടുന്നവ.';

  @override
  String get welcomePromiseSkillsTitle => 'നിങ്ങളുടെ കഴിവ് തെളിയിക്കൂ';

  @override
  String get welcomePromiseSkillsBody =>
      'നിങ്ങളുടെ ITI, ഡിപ്ലോമ സർട്ടിഫിക്കറ്റുകൾ, ഒരിക്കൽ പരിശോധിച്ച് എല്ലാ ഉപഭോക്താക്കൾക്കും കാണിക്കും.';

  @override
  String get welcomePromiseTrackTitle => 'എല്ലാ ജോലിയും ട്രാക്ക് ചെയ്യൂ';

  @override
  String get welcomePromiseTrackBody =>
      'ജോലി സ്വീകരിക്കുന്നത് മുതൽ പൂർത്തിയാക്കുന്നത് വരെ, ഓരോ ഘട്ടത്തിലും ഫോട്ടോ രേഖകളോടെ.';

  @override
  String get welcomePromisePaidTitle => 'സുരക്ഷിതമായി പണം നേടൂ';

  @override
  String get welcomePromisePaidBody =>
      'ഓരോ രൂപയും രേഖപ്പെടുത്തി, വ്യക്തമായ സ്റ്റേറ്റ്‌മെന്റും നിങ്ങളുടെ വ്യവസ്ഥകളിൽ പിൻവലിക്കലും.';

  @override
  String get welcomeHeadline => 'നിങ്ങളെ തേടിവരുന്ന ജോലി';

  @override
  String get welcomeSubtitle =>
      'Wervexa വൈദഗ്ധ്യമുള്ള പ്രൊഫഷണലുകളെ അവരെ ആവശ്യമുള്ള ഉപഭോക്താക്കളുമായി ബന്ധിപ്പിക്കുന്നു.';

  @override
  String get welcomeGetStarted => 'ആരംഭിക്കുക';

  @override
  String get welcomeCodeNotice =>
      'നിങ്ങളുടെ മൊബൈൽ നമ്പറിലേക്ക് ഒറ്റത്തവണ കോഡ് അയയ്ക്കും.';

  @override
  String get phoneTitle => 'നിങ്ങളുടെ മൊബൈൽ നമ്പർ എന്താണ്?';

  @override
  String get phoneSubtitle =>
      'ഇത് നിങ്ങളാണെന്ന് സ്ഥിരീകരിക്കാൻ ഒറ്റത്തവണ കോഡ് അയയ്ക്കും.';

  @override
  String get phoneSendCode => 'കോഡ് അയയ്ക്കുക';

  @override
  String get phoneSending => 'അയയ്ക്കുന്നു…';

  @override
  String get authNewCodeSent => 'ഞങ്ങൾ പുതിയ കോഡ് അയച്ചു.';

  @override
  String get otpTitle => 'കോഡ് നൽകുക';

  @override
  String otpSentTo(Object phone) {
    return '$phone എന്ന നമ്പറിലേക്ക് 6 അക്ക കോഡ് അയച്ചു.';
  }

  @override
  String otpResendIn(int seconds) {
    String _temp0 = intl.Intl.pluralLogic(
      seconds,
      locale: localeName,
      other: '$seconds സെക്കൻഡിൽ പുതിയ കോഡ് ചോദിക്കാം',
      one: '1 സെക്കൻഡിൽ പുതിയ കോഡ് ചോദിക്കാം',
    );
    return '$_temp0';
  }

  @override
  String get otpSendNew => 'പുതിയ കോഡ് അയയ്ക്കുക';

  @override
  String get otpVerify => 'പരിശോധിക്കുക';

  @override
  String get otpVerifying => 'പരിശോധിക്കുന്നു…';

  @override
  String get registerNameRequired => 'ദയവായി നിങ്ങളുടെ പൂർണ്ണ പേര് നൽകുക';

  @override
  String get registerEmailInvalid => 'ദയവായി സാധുവായ ഇമെയിൽ വിലാസം നൽകുക';

  @override
  String get registerTitle => 'ഞങ്ങൾ നിങ്ങളെ എന്ത് വിളിക്കണം?';

  @override
  String get registerSubtitle => 'ഉപഭോക്താക്കൾ ഈ പേരാണ് കാണുക.';

  @override
  String get registerNameLabel => 'പൂർണ്ണ പേര്';

  @override
  String get registerNameHint => 'അരുൺ കുമാർ';

  @override
  String get registerEmailLabel => 'ഇമെയിൽ (ഓപ്ഷണൽ)';

  @override
  String get registerEmailHelper => 'രസീതുകൾക്കും സ്റ്റേറ്റ്‌മെന്റുകൾക്കും.';

  @override
  String registerVerifiedPhone(Object phone) {
    return 'പരിശോധിച്ചു: $phone';
  }

  @override
  String get navHome => 'ഹോം';

  @override
  String get navJobs => 'ജോലികൾ';

  @override
  String get navWallet => 'വാലറ്റ്';

  @override
  String get navProfile => 'പ്രൊഫൈൽ';

  @override
  String get sessionProfileLoadFailedRetry =>
      'നിങ്ങളുടെ പ്രൊഫൈൽ ലോഡ് ചെയ്യാനായില്ല. ദയവായി വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get commonSignOut => 'സൈൻ ഔട്ട് ചെയ്യുക';

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
  String get commonSeeAll => 'എല്ലാം കാണുക';

  @override
  String distanceKm(Object km) {
    return '$km കി.മീ';
  }

  @override
  String get homeRightNow => 'ഇപ്പോൾ';

  @override
  String get homeNewWork => 'പുതിയ ജോലി';

  @override
  String homeJobsWaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ജോലികൾ നിങ്ങളുടെ മറുപടിക്കായി കാത്തിരിക്കുന്നു',
      one: '1 ജോലി നിങ്ങളുടെ മറുപടിക്കായി കാത്തിരിക്കുന്നു',
    );
    return '$_temp0';
  }

  @override
  String get homeComingUp => 'വരാനിരിക്കുന്നവ';

  @override
  String get homeEarnings => 'വരുമാനം';

  @override
  String get homeMyServices => 'എന്റെ സേവനങ്ങൾ';

  @override
  String get homeVerification => 'പരിശോധന';

  @override
  String get homeSupport => 'പിന്തുണ';

  @override
  String get homeRequests => 'അഭ്യർത്ഥനകൾ';

  @override
  String get homeMyOffers => 'എന്റെ ഓഫറുകൾ';

  @override
  String get homeAddService => 'സേവനം ചേർക്കുക';

  @override
  String get homeAddServiceBody =>
      'നിങ്ങൾ പ്രസിദ്ധീകരിച്ച സേവനങ്ങൾക്ക് മാത്രമേ ഉപഭോക്താക്കൾക്ക് നിങ്ങളെ ബുക്ക് ചെയ്യാനാകൂ.';

  @override
  String get homeNotReady => 'ഇതുവരെ പൂർണ്ണമായി തയ്യാറായിട്ടില്ല';

  @override
  String get homeNotReadyBody =>
      'ഈ ഘട്ടങ്ങൾ പൂർത്തിയാക്കിയാൽ ജോലികൾ ലഭിച്ചുതുടങ്ങും.';

  @override
  String get homeGoodMorning => 'സുപ്രഭാതം';

  @override
  String get homeGoodAfternoon => 'ശുഭ ഉച്ച';

  @override
  String get homeGoodEvening => 'ശുഭ സന്ധ്യ';

  @override
  String get homeNotifications => 'അറിയിപ്പുകൾ';

  @override
  String get availabilityAvailable => 'ലഭ്യമാണ്';

  @override
  String get availabilityAvailableBody => 'നിങ്ങൾക്ക് പുതിയ ജോലികൾ ലഭിക്കാം.';

  @override
  String get availabilityOnJob => 'ജോലിയിലാണ്';

  @override
  String get availabilityOnJobBody =>
      'ഈ ജോലി കഴിയുന്നതുവരെ പുതിയ ജോലി നൽകില്ല.';

  @override
  String get availabilityOff => 'ഓഫ്';

  @override
  String get availabilityOffBody => 'നിങ്ങൾക്ക് പുതിയ ജോലികൾ ലഭിക്കില്ല.';

  @override
  String get availabilityFinishJob =>
      'വീണ്ടും ലഭ്യമാകാൻ നിലവിലെ ജോലി പൂർത്തിയാക്കുക.';

  @override
  String get availabilityGoOff => 'ഡ്യൂട്ടി ഓഫ് ചെയ്യുക';

  @override
  String get availabilityGoOn => 'ലഭ്യമാകുക';

  @override
  String get availabilityBeforeJobs => 'ജോലികൾ ലഭിക്കുന്നതിന് മുമ്പ്';

  @override
  String get availabilityNowOn => 'നിങ്ങൾ ജോലിക്ക് ലഭ്യമാണ്.';

  @override
  String get availabilityNowOff => 'നിങ്ങൾ ഡ്യൂട്ടിയിലല്ല.';

  @override
  String get workerStatusSetupIncomplete => 'സജ്ജീകരണം പൂർത്തിയായിട്ടില്ല';

  @override
  String get workerStatusUnderReview => 'അവലോകനത്തിൽ';

  @override
  String get workerStatusInactive => 'നിഷ്ക്രിയം';

  @override
  String get workerStatusRestricted => 'നിയന്ത്രിതം';

  @override
  String get workerStatusSuspended => 'സസ്പെൻഡ് ചെയ്തു';

  @override
  String get homeAccount => 'അക്കൗണ്ട്';

  @override
  String get homeWorkStatus => 'ജോലി നില';

  @override
  String get availabilityOffDuty => 'ഡ്യൂട്ടിയിലല്ല';

  @override
  String get earningsThisWeek => 'ഈ ആഴ്ച';

  @override
  String get earningsThisMonth => 'ഈ മാസം';

  @override
  String get jobNextWaitConfirm =>
      'ഉപഭോക്താവിന്റെ സ്ഥിരീകരണത്തിനായി കാത്തിരിക്കുന്നു';

  @override
  String get jobNextStartTravel => 'യാത്ര ആരംഭിക്കുക';

  @override
  String get jobNextMarkArrived => 'എത്തിയതായി അടയാളപ്പെടുത്തുക';

  @override
  String get jobNextStartWork => 'ജോലി ആരംഭിക്കുക';

  @override
  String get jobNextAskCode => 'ഉപഭോക്താവിനോട് എത്തിച്ചേരൽ കോഡ് ചോദിക്കുക';

  @override
  String get jobNextFinish => 'പൂർത്തിയാക്കി ഫോട്ടോകൾ ചേർക്കുക';

  @override
  String get jobNextWaitApprove =>
      'ഉപഭോക്താവിന്റെ അംഗീകാരത്തിനായി കാത്തിരിക്കുന്നു';

  @override
  String get jobNextOpen => 'ജോലി തുറക്കുക';

  @override
  String get jobTimeTbc => 'സമയം സ്ഥിരീകരിക്കാനുണ്ട്';

  @override
  String get settingsTitle => 'ക്രമീകരണങ്ങൾ';

  @override
  String get settingsLanguage => 'ഭാഷ';

  @override
  String get settingsAbout => 'വിവരം';

  @override
  String get settingsTerms => 'സേവന നിബന്ധനകൾ';

  @override
  String get settingsPrivacy => 'സ്വകാര്യതാ നയം';

  @override
  String get settingsHelp => 'സഹായവും പിന്തുണയും';

  @override
  String get settingsDeleteAccount => 'എന്റെ അക്കൗണ്ട് ഇല്ലാതാക്കുക';

  @override
  String get settingsSignOutTitle => 'സൈൻ ഔട്ട് ചെയ്യണോ?';

  @override
  String get settingsSignOutBody =>
      'വീണ്ടും സൈൻ ഇൻ ചെയ്യാൻ നിങ്ങളുടെ ഫോൺ നമ്പറും ഒരു കോഡും വേണം.';

  @override
  String get settingsDeleteTitle => 'നിങ്ങളുടെ അക്കൗണ്ട് ഇല്ലാതാക്കുക';

  @override
  String get settingsDeleteBody =>
      'അക്കൗണ്ട് ഇല്ലാതാക്കുന്നത് നിങ്ങളുടെ ജോലി ചരിത്രം, വരുമാന രേഖകൾ, തുറന്ന പേയ്‌മെന്റുകൾ എന്നിവയെ ബാധിക്കുന്നതിനാൽ ഇത് സ്വയമേവയല്ല, ഞങ്ങളുടെ പിന്തുണാ ടീമാണ് ചെയ്യുന്നത്.\n\nപിന്തുണാ അഭ്യർത്ഥന നൽകുക, പൂർത്തിയായാൽ ഞങ്ങൾ സ്ഥിരീകരിക്കും.';

  @override
  String get settingsContactSupport => 'പിന്തുണയുമായി ബന്ധപ്പെടുക';

  @override
  String get notificationsMarkAllRead => 'എല്ലാം വായിച്ചതായി അടയാളപ്പെടുത്തുക';

  @override
  String get notificationsEmpty => 'നിങ്ങൾ എല്ലാം കണ്ടുകഴിഞ്ഞു';

  @override
  String get notificationsEmptyBody =>
      'ജോലി ഓഫറുകൾ, പേയ്‌മെന്റ് അപ്ഡേറ്റുകൾ, പരിശോധനാ ഫലങ്ങൾ എന്നിവ ഇവിടെ കാണാം.';

  @override
  String get jobsTabUpcoming => 'വരാനിരിക്കുന്നവ';

  @override
  String get jobsTabActive => 'സജീവം';

  @override
  String get jobsNoOffers => 'ഇപ്പോൾ പുതിയ ജോലികളില്ല';

  @override
  String get jobsNoOffersBody =>
      'നിങ്ങൾ ലഭ്യമായിരിക്കുമ്പോൾ, അനുയോജ്യമായ ജോലി വന്നാലുടൻ ഞങ്ങൾ അറിയിക്കും.';

  @override
  String get jobsAccepted => 'ജോലി സ്വീകരിച്ചു.';

  @override
  String get jobsDeclineTitle => 'ഈ ജോലി നിരസിക്കണോ?';

  @override
  String get jobsDeclineBody =>
      'ഇത് മറ്റൊരു ജീവനക്കാരന് നൽകും. ഇടയ്ക്കിടെ നിരസിക്കുന്നത് നിങ്ങൾക്ക് കാണിക്കുന്ന ജോലികൾ കുറച്ചേക്കാം.';

  @override
  String get jobsDecline => 'നിരസിക്കുക';

  @override
  String get jobsDeclined => 'ജോലി നിരസിച്ചു.';

  @override
  String get jobsEmptyUpcoming => 'ഒന്നും ഷെഡ്യൂൾ ചെയ്തിട്ടില്ല';

  @override
  String get jobsEmptyUpcomingBody => 'നിങ്ങൾ സ്വീകരിച്ച ജോലികൾ ഇവിടെ കാണാം.';

  @override
  String get jobsEmptyActive => 'ഒരു ജോലിയും നടക്കുന്നില്ല';

  @override
  String get jobsEmptyActiveBody =>
      'നിങ്ങൾ ജോലി ആരംഭിക്കുമ്പോൾ അത് ഇവിടെ കാണാം.';

  @override
  String get jobsEmptyCompleted => 'ഇതുവരെ പൂർത്തിയായ ജോലികളില്ല';

  @override
  String get jobsEmptyCompletedBody =>
      'പൂർത്തിയായ ജോലികളും അവയിൽ നിന്നുള്ള നിങ്ങളുടെ വരുമാനവും ഇവിടെ ലിസ്റ്റ് ചെയ്യും.';

  @override
  String get jobsEmptyCancelled => 'ഒന്നും റദ്ദാക്കിയിട്ടില്ല';

  @override
  String get jobsEmptyCancelledBody =>
      'റദ്ദാക്കിയ ജോലികൾ ഇവിടെ ലിസ്റ്റ് ചെയ്യും.';

  @override
  String get jobsEmptyOffers => 'ഓഫറുകളില്ല';

  @override
  String get jobsEmptyOffersBody => 'പുതിയ ജോലികൾ ഇവിടെ കാണാം.';

  @override
  String get jobTitleFallback => 'ജോലി';

  @override
  String jobCancelledReason(Object reason) {
    return 'റദ്ദാക്കി: $reason';
  }

  @override
  String get jobAmount => 'ജോലിയുടെ തുക';

  @override
  String get jobMaterials => 'സാമഗ്രികൾ';

  @override
  String get jobYouEarned => 'നിങ്ങളുടെ വരുമാനം';

  @override
  String get jobRateCustomer => 'ഉപഭോക്താവിനെ റേറ്റ് ചെയ്യുക';

  @override
  String get jobRateQuestion => 'ഈ ജോലി നിങ്ങൾക്ക് എങ്ങനെയായിരുന്നു?';

  @override
  String get jobRate => 'റേറ്റ് ചെയ്യുക';

  @override
  String get jobHistory => 'എന്തൊക്കെ സംഭവിച്ചു';

  @override
  String get jobHistoryLoadFailed => 'ജോലി ചരിത്രം ലോഡ് ചെയ്യാനായില്ല.';

  @override
  String get jobOfferExpired => 'ഈ ജോലി ഇനി ലഭ്യമല്ല.';

  @override
  String get jobOfferNewBadge => 'പുതിയ ജോലി';

  @override
  String get jobOfferYouEarn => 'നിങ്ങളുടെ വരുമാനം';

  @override
  String get jobOfferPriceAfterVisit => 'സന്ദർശനത്തിന് ശേഷം സ്ഥിരീകരിക്കും';

  @override
  String get jobOfferAccept => 'ജോലി സ്വീകരിക്കുക';

  @override
  String get activeJobTitle => 'നിലവിലെ ജോലി';

  @override
  String get activeJobEmptyBody =>
      'നിങ്ങൾ ജോലി സ്വീകരിച്ച് ആരംഭിക്കുമ്പോൾ അത് ഇവിടെ കാണാം.';

  @override
  String get evidenceBeforeTitle => 'ആരംഭിക്കുന്നതിന് മുമ്പ്';

  @override
  String get evidenceBeforeBody =>
      'തൊടുന്നതിന് മുമ്പ് പ്രശ്നത്തിന്റെ ഫോട്ടോ എടുക്കുക. ഉപഭോക്താവ് പിന്നീട് ജോലിയെക്കുറിച്ച് തർക്കിച്ചാൽ ഇത് നിങ്ങളെ സംരക്ഷിക്കും.';

  @override
  String get evidenceAfterTitle => 'പൂർത്തിയാക്കിയ ശേഷം';

  @override
  String get evidenceAfterBody =>
      'ഉപഭോക്താവ് പിന്നീട് തർക്കിച്ചാൽ പൂർത്തിയായ ജോലിയുടെ ഫോട്ടോയാണ് നിങ്ങളുടെ തെളിവ്. ഓപ്ഷണലാണ്, പക്ഷേ പത്ത് സെക്കൻഡ് ചെലവഴിക്കുന്നത് നല്ലതാണ്.';

  @override
  String get jobCustomerHidden =>
      'സ്ഥിരീകരിച്ച ശേഷം ഉപഭോക്തൃ വിശദാംശങ്ങൾ പങ്കിടും';

  @override
  String get jobCall => 'വിളിക്കുക';

  @override
  String get jobDirections => 'വഴി';

  @override
  String get jobTrackOnMap => 'മാപ്പിൽ ട്രാക്ക് ചെയ്യുക';

  @override
  String get trailAccepted => 'സ്വീകരിച്ചു';

  @override
  String get trailOnTheWay => 'വഴിയിലാണ്';

  @override
  String get trailArrived => 'എത്തി';

  @override
  String get trailArrivalConfirmed => 'എത്തിച്ചേരൽ സ്ഥിരീകരിച്ചു';

  @override
  String get trailWorkStarted => 'ജോലി ആരംഭിച്ചു';

  @override
  String get trailFinished => 'പൂർത്തിയായി';

  @override
  String get jobProgress => 'പുരോഗതി';

  @override
  String get jobBeforeFinish => 'പൂർത്തിയാക്കുന്നതിന് മുമ്പ്';

  @override
  String get jobActionStartTravel => 'യാത്ര ആരംഭിക്കുക';

  @override
  String get jobActionArrived => 'ഞാൻ എത്തി';

  @override
  String get jobActionEnterCode => 'എത്തിച്ചേരൽ കോഡ് നൽകുക';

  @override
  String get jobActionStartWork => 'ജോലി ആരംഭിക്കുക';

  @override
  String get jobActionFinish => 'ജോലി പൂർത്തിയാക്കുക';

  @override
  String get jobArrivalConfirmed => 'എത്തിച്ചേരൽ സ്ഥിരീകരിച്ചു.';

  @override
  String get jobFinishTitle => 'ഈ ജോലി പൂർത്തിയാക്കണോ?';

  @override
  String get jobFinishBody =>
      'ജോലി അംഗീകരിക്കാൻ ഉപഭോക്താവിനോട് ആവശ്യപ്പെടും. അതിന് ശേഷം നിങ്ങൾക്ക് ഫോട്ടോകൾ ചേർക്കാനാകില്ല.';

  @override
  String get jobOnYourWay => 'നിങ്ങൾ വഴിയിലാണ്.';

  @override
  String get jobMarkedArrived => 'എത്തിയതായി അടയാളപ്പെടുത്തി.';

  @override
  String get jobWorkStarted => 'ജോലി ആരംഭിച്ചു.';

  @override
  String get jobSentForApproval => 'അംഗീകാരത്തിനായി ഉപഭോക്താവിന് അയച്ചു.';

  @override
  String get jobUpdated => 'അപ്ഡേറ്റ് ചെയ്തു.';

  @override
  String get jobWaitConfirm =>
      'ഉപഭോക്താവ് ബുക്കിംഗ് സ്ഥിരീകരിക്കാൻ കാത്തിരിക്കുന്നു.';

  @override
  String get jobWaitApprove =>
      'ഉപഭോക്താവ് നിങ്ങളുടെ ജോലി അംഗീകരിക്കാൻ കാത്തിരിക്കുന്നു.';

  @override
  String get jobWaitPaymentProcessing =>
      'അംഗീകരിച്ചു. പേയ്‌മെന്റ് പ്രോസസ്സ് ചെയ്യുന്നു.';

  @override
  String get jobWaitPayment =>
      'ഉപഭോക്താവിന്റെ പേയ്‌മെന്റിനായി കാത്തിരിക്കുന്നു.';

  @override
  String get jobWaitPaid => 'പണമടച്ചു. നിങ്ങളുടെ വരുമാനം വാലറ്റിൽ കാണാം.';

  @override
  String get jobWaitDisputed =>
      'ഞങ്ങളുടെ ടീം ഈ ജോലി അവലോകനം ചെയ്യുന്നു. ഞങ്ങൾ ബന്ധപ്പെടും.';

  @override
  String get jobWaitNothing => 'ഇപ്പോൾ ചെയ്യാൻ ഒന്നുമില്ല.';

  @override
  String get travelRouteUnavailable => 'റൂട്ട് ലഭ്യമല്ല';

  @override
  String get travelNoDestination => 'ലക്ഷ്യസ്ഥാനം സജ്ജമാക്കിയിട്ടില്ല';

  @override
  String get travelNoDestinationBody =>
      'ഈ ജോലിക്ക് റൂട്ട് കാണിക്കാൻ സേവന സ്ഥലമില്ല.';

  @override
  String get travelJobLocation => 'ജോലി സ്ഥലം';

  @override
  String get travelYou => 'നിങ്ങൾ';

  @override
  String get travelCustomer => 'ഉപഭോക്താവ്';

  @override
  String get travelCalculating => 'റൂട്ട് കണക്കാക്കുന്നു...';

  @override
  String distanceMetres(Object metres) {
    return '$metres മീ';
  }

  @override
  String etaMinutes(Object minutes) {
    return '$minutes മിനിറ്റ്';
  }

  @override
  String etaHours(Object hours) {
    return '$hours മണിക്കൂർ';
  }

  @override
  String get arrivalWrongCode => 'ആ കോഡ് ശരിയല്ല.';

  @override
  String arrivalWrongCodeAttempts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ആ കോഡ് ശരിയല്ല. $count ശ്രമങ്ങൾ ബാക്കി.',
      one: 'ആ കോഡ് ശരിയല്ല. 1 ശ്രമം ബാക്കി.',
    );
    return '$_temp0';
  }

  @override
  String get arrivalTitle => 'നിങ്ങൾ എത്തിയെന്ന് സ്ഥിരീകരിക്കുക';

  @override
  String get arrivalBody =>
      'ഉപഭോക്താവിനോട് അവരുടെ ആപ്പിലെ കോഡ് വായിച്ചുതരാൻ പറയുക, തുടർന്ന് ഇവിടെ ടൈപ്പ് ചെയ്യുക.';

  @override
  String get arrivalLocked =>
      'വളരെയധികം തെറ്റായ കോഡുകൾ. ഈ ജോലി തുടരാൻ ദയവായി പിന്തുണയുമായി ബന്ധപ്പെടുക.';

  @override
  String get arrivalConfirm => 'എത്തിച്ചേരൽ സ്ഥിരീകരിക്കുക';

  @override
  String get arrivalNotYet => 'ഇനിയും ഇല്ല';

  @override
  String get rateThanks => 'നിങ്ങളുടെ അഭിപ്രായത്തിന് നന്ദി.';

  @override
  String get rateTitle => 'ഈ ഉപഭോക്താവ് എങ്ങനെയായിരുന്നു?';

  @override
  String get rateBody =>
      'നിങ്ങളുടെ റേറ്റിംഗ് സ്വകാര്യമാണ്, ജീവനക്കാരെ സംരക്ഷിക്കാൻ ഞങ്ങളെ സഹായിക്കുന്നു.';

  @override
  String get rateCommentLabel => 'മറ്റെന്തെങ്കിലും ചേർക്കാനുണ്ടോ? (ഓപ്ഷണൽ)';

  @override
  String get rateSubmit => 'റേറ്റിംഗ് സമർപ്പിക്കുക';

  @override
  String get timerServiceTime => 'സേവന സമയം';

  @override
  String get materialsAdd => 'ചേർക്കുക';

  @override
  String get materialsLoadFailed => 'സാമഗ്രികൾ ലോഡ് ചെയ്യാനായില്ല.';

  @override
  String get materialsEmpty =>
      'ഈ ജോലിക്ക് പാർട്സ് വേണമെങ്കിൽ ഇവിടെ ചേർക്കുക, ചെലവ് അംഗീകരിക്കാൻ ഉപഭോക്താവിനോട് ആവശ്യപ്പെടും.';

  @override
  String get materialStatusWaiting => 'ഉപഭോക്താവിനായി കാത്തിരിക്കുന്നു';

  @override
  String get materialStatusApproved => 'അംഗീകരിച്ചു';

  @override
  String get materialStatusDeclined => 'നിരസിച്ചു';

  @override
  String get materialStatusBought => 'വാങ്ങി';

  @override
  String get materialStatusCostRecorded => 'ചെലവ് രേഖപ്പെടുത്തി';

  @override
  String get materialStatusBilled => 'ബില്ലിൽ';

  @override
  String get materialStatusCancelled => 'റദ്ദാക്കി';

  @override
  String materialQuantityEstimated(Object quantity, Object unit) {
    return '$quantity $unit · കണക്കാക്കിയത്';
  }

  @override
  String materialQuantityActual(Object quantity, Object unit) {
    return '$quantity $unit · യഥാർത്ഥം';
  }

  @override
  String get materialRecordCost => 'ചെലവ് രേഖപ്പെടുത്തുക';

  @override
  String materialCustomerSaid(Object reason) {
    return 'ഉപഭോക്താവ് പറഞ്ഞത്: $reason';
  }

  @override
  String get materialUnitPiece => 'എണ്ണം';

  @override
  String get materialWhatNeeded => 'നിങ്ങൾക്ക് എന്താണ് വേണ്ടത്?';

  @override
  String get materialEnterQuantity => 'എത്ര വേണമെന്ന് നൽകുക';

  @override
  String get materialEnterCost => 'കണക്കാക്കിയ ചെലവ് നൽകുക';

  @override
  String get materialRequestBody =>
      'നിങ്ങൾ വാങ്ങുന്നതിന് മുമ്പ് ഇത് അംഗീകരിക്കാൻ ഉപഭോക്താവിനോട് ആവശ്യപ്പെടും.';

  @override
  String get materialName => 'സാമഗ്രി';

  @override
  String get materialNameHint => 'ഉദാ. 16A മോഡുലാർ സ്വിച്ച്';

  @override
  String get materialQuantity => 'അളവ്';

  @override
  String get materialUnit => 'യൂണിറ്റ്';

  @override
  String get materialExpectedCost => 'കണക്കാക്കിയ ചെലവ്';

  @override
  String get materialAskCustomer => 'ഉപഭോക്താവിനോട് ചോദിക്കുക';

  @override
  String get materialEnterPaid => 'നിങ്ങൾ അടച്ച തുക നൽകുക';

  @override
  String get materialCostRecorded => 'ചെലവ് രേഖപ്പെടുത്തി.';

  @override
  String get materialWhatCost => 'ഇതിന് എത്ര ചെലവായി?';

  @override
  String get materialReceiptBody =>
      'ഉപഭോക്താവിന്റെ ബില്ലിൽ ചേർക്കാൻ രസീത് അറ്റാച്ച് ചെയ്യുക.';

  @override
  String get materialAmountPaid => 'അടച്ച തുക';

  @override
  String get materialReceipt => 'രസീത്';

  @override
  String get materialReceiptRequired => 'ബില്ലിന്റെ ഫോട്ടോ നിർബന്ധമാണ്.';

  @override
  String get evidenceDone => 'പൂർത്തിയായി';

  @override
  String get evidenceRequired => 'നിർബന്ധം';

  @override
  String get evidenceCamera => 'ക്യാമറ';

  @override
  String get evidenceGallery => 'ഗാലറി';

  @override
  String get evidenceSaved => 'സേവ് ചെയ്തു';

  @override
  String get uploadWaiting => 'കാത്തിരിക്കുന്നു';

  @override
  String get uploadPreparing => 'തയ്യാറാക്കുന്നു';

  @override
  String get uploadStarting => 'അപ്‌ലോഡ് ആരംഭിക്കുന്നു';

  @override
  String uploadPercent(Object percent) {
    return '$percent%';
  }

  @override
  String get uploadFinishing => 'പൂർത്തിയാക്കുന്നു';

  @override
  String get uploadCancel => 'അപ്‌ലോഡ് റദ്ദാക്കുക';

  @override
  String get uploadNotFinished => 'ആ അപ്‌ലോഡ് പൂർത്തിയായില്ല.';

  @override
  String get commonRetry => 'വീണ്ടും ശ്രമിക്കുക';

  @override
  String durationMinutes(Object minutes) {
    return '$minutes മിനിറ്റ്';
  }

  @override
  String durationHours(Object hours) {
    return '$hours മണിക്കൂർ';
  }

  @override
  String durationHoursMinutes(Object hours, Object minutes) {
    return '$hours മണിക്കൂർ $minutes മിനിറ്റ്';
  }

  @override
  String durationDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ദിവസം',
      one: '1 ദിവസം',
    );
    return '$_temp0';
  }

  @override
  String pricePerHour(Object price) {
    return '$price/മണിക്കൂർ';
  }

  @override
  String pricePerDay(Object price) {
    return '$price/ദിവസം';
  }

  @override
  String pricePerUnit(Object price) {
    return '$price/യൂണിറ്റ്';
  }

  @override
  String pricePerSqft(Object price) {
    return '$price/ച.അടി';
  }

  @override
  String get gigsTitle => 'എന്റെ സേവനങ്ങൾ';

  @override
  String get gigsAddTooltip => 'സേവനം ചേർക്കുക';

  @override
  String get gigsAdd => 'സേവനം ചേർക്കുക';

  @override
  String get gigsEmpty => 'ഇതുവരെ സേവനങ്ങളില്ല';

  @override
  String get gigsEmptyBody =>
      'നിങ്ങൾ നൽകുന്ന സേവനങ്ങൾ ചേർക്കുക. നിങ്ങൾക്ക് അംഗീകാരമുള്ള എല്ലാ ജോലികളിലും ആവശ്യമുള്ളത്ര സേവനങ്ങൾ ചേർക്കാം.';

  @override
  String get gigsNoneLive =>
      'നിങ്ങളുടെ സേവനങ്ങളൊന്നും ലൈവല്ല, അതിനാൽ ഉപഭോക്താക്കൾക്ക് നിങ്ങളെ ബുക്ക് ചെയ്യാനാകില്ല.';

  @override
  String gigsLiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count സേവനങ്ങൾ ലൈവാണ്.',
      one: '1 സേവനം ലൈവാണ്.',
    );
    return '$_temp0';
  }

  @override
  String get gigsAvailable => 'നിങ്ങൾ ജോലിക്ക് ലഭ്യമാണ്.';

  @override
  String get gigsOffDuty =>
      'നിങ്ങൾ ഡ്യൂട്ടിയിലല്ല, അതിനാൽ നിങ്ങൾക്ക് ജോലികൾ നൽകില്ല.';

  @override
  String gigJobsDone(int count) {
    return '$count പൂർത്തിയായി';
  }

  @override
  String get gigEdit => 'എഡിറ്റ് ചെയ്യുക';

  @override
  String get gigPause => 'താൽക്കാലികമായി നിർത്തുക';

  @override
  String get gigResume => 'പുനരാരംഭിക്കുക';

  @override
  String get gigInReview => 'അവലോകനത്തിൽ';

  @override
  String get gigDraftHint => 'ഡ്രാഫ്റ്റ് — അവലോകനത്തിനായി സമർപ്പിക്കുക';

  @override
  String get gigRejectedHint =>
      'നിരസിച്ചു — എഡിറ്റ് ചെയ്ത് വീണ്ടും സമർപ്പിക്കുക';

  @override
  String get gigArchived => 'ആർക്കൈവ് ചെയ്തു';

  @override
  String get gigNotLive => 'ലൈവല്ല';

  @override
  String get gigPaused =>
      'താൽക്കാലികമായി നിർത്തി. ഈ ജോലികൾ നിങ്ങൾക്ക് നൽകില്ല.';

  @override
  String get gigLiveAgain => 'വീണ്ടും ലൈവ്.';

  @override
  String get gigDuration30m => '30 മിനിറ്റ്';

  @override
  String get gigDuration45m => '45 മിനിറ്റ്';

  @override
  String get gigDuration1h => '1 മണിക്കൂർ';

  @override
  String get gigDuration2h => '2 മണിക്കൂർ';

  @override
  String get gigDuration4h => '4 മണിക്കൂർ';

  @override
  String get gigDuration8h => '8 മണിക്കൂർ (ഒരു പ്രവൃത്തിദിനം)';

  @override
  String get gigDuration24h => '24 മണിക്കൂർ';

  @override
  String get gigDuration2d => '2 ദിവസം';

  @override
  String get gigDuration3d => '3 ദിവസം';

  @override
  String get gigDuration1w => '1 ആഴ്ച';

  @override
  String get gigSavedDraft => 'ഡ്രാഫ്റ്റായി സേവ് ചെയ്തു.';

  @override
  String get gigSubmitted => 'സമർപ്പിച്ചു. ഞങ്ങൾ അവലോകനം ചെയ്ത് അറിയിക്കും.';

  @override
  String get gigLive => 'നിങ്ങളുടെ സേവനം ലൈവാണ്.';

  @override
  String get gigSaved => 'സേവ് ചെയ്തു.';

  @override
  String get gigEditorAddTitle => 'സേവനം ചേർക്കുക';

  @override
  String get gigEditorEditTitle => 'സേവനം എഡിറ്റ് ചെയ്യുക';

  @override
  String get gigNoTrades => 'ഇതുവരെ അംഗീകൃത ജോലികളില്ല';

  @override
  String get gigNoTradesBody =>
      'ഒരു ജോലിക്ക് നിങ്ങൾക്ക് അംഗീകാരം ലഭിച്ചാൽ, അതിന് കീഴിൽ സേവനങ്ങൾ പ്രസിദ്ധീകരിക്കാം. ആരംഭിക്കാൻ നിങ്ങളുടെ പ്രൊഫൈലിൽ നിന്ന് ഒരു ജോലി ചേർക്കുക.';

  @override
  String get gigFieldTrade => 'ഏത് ജോലി?';

  @override
  String get gigFieldTitle => 'ഈ സേവനത്തിന്റെ പേര് എന്താണ്?';

  @override
  String get gigFieldTitleHint => 'ഉപഭോക്താക്കൾ ഇത് കാണും. കൃത്യമായി എഴുതുക.';

  @override
  String get gigFieldTitleExample => 'ഉദാ. സ്പ്ലിറ്റ് AC ഡീപ് ക്ലീനിംഗ്';

  @override
  String get gigFieldDescription => 'ഇതിൽ എന്തൊക്കെ ഉൾപ്പെടുന്നു?';

  @override
  String get gigFieldDescriptionHint =>
      'ഓപ്ഷണലാണ്, പക്ഷേ ഉപഭോക്താക്കൾക്ക് നിങ്ങളെ തിരഞ്ഞെടുക്കാൻ സഹായിക്കും.';

  @override
  String get gigFieldDescriptionExample =>
      'ഉദാ. ഇൻഡോർ, ഔട്ട്‌ഡോർ യൂണിറ്റിന്റെ പൂർണ്ണ ക്ലീനിംഗ്, ഫിൽട്ടർ കഴുകൽ, ഗ്യാസ് പ്രഷർ പരിശോധന.';

  @override
  String get gigFieldPrice => 'നിങ്ങൾ എത്ര ഈടാക്കുന്നു?';

  @override
  String get gigFieldPriceHint =>
      'ഓരോ സേവനത്തിനും സ്വന്തം വിലയുണ്ട്. ഇത് നിങ്ങളുടെ മറ്റ് സേവനങ്ങളെ ബാധിക്കില്ല.';

  @override
  String get gigUnitPerJob => 'ഒരു ജോലിക്ക്';

  @override
  String get gigUnitPerHour => 'മണിക്കൂറിന്';

  @override
  String get gigUnitPerDay => 'ദിവസത്തിന്';

  @override
  String get gigUnitPerUnit => 'യൂണിറ്റിന്';

  @override
  String get gigUnitPerSqft => 'ചതുരശ്ര അടിക്ക്';

  @override
  String get gigFieldDuration => 'ഇതിന് സാധാരണ എത്ര സമയമെടുക്കും?';

  @override
  String get gigFieldRadius => 'ഇതിനായി നിങ്ങൾ എത്ര ദൂരം യാത്ര ചെയ്യും?';

  @override
  String get gigFieldRadiusHint =>
      'നിങ്ങളുടെ സാധാരണ യാത്രാദൂരം ഉപയോഗിക്കാൻ ഡിഫോൾട്ടായി വിടുക.';

  @override
  String get gigUsualDistance => 'നിങ്ങളുടെ സാധാരണ ദൂരം';

  @override
  String get gigUseUsualDistance => 'എന്റെ സാധാരണ ദൂരം ഉപയോഗിക്കുക';

  @override
  String get gigReviewNotice =>
      'പുതിയതും എഡിറ്റ് ചെയ്തതുമായ സേവനങ്ങൾ ലൈവാകുന്നതിന് മുമ്പ് ഞങ്ങളുടെ ടീം പരിശോധിക്കും. കഴിഞ്ഞാലുടൻ ഞങ്ങൾ അറിയിക്കും.';

  @override
  String get gigSaveDraft => 'ഡ്രാഫ്റ്റ് സേവ് ചെയ്യുക';

  @override
  String get gigSubmitForReview => 'അവലോകനത്തിനായി സമർപ്പിക്കുക';

  @override
  String get walletAllTransactions => 'എല്ലാ ഇടപാടുകളും';

  @override
  String get walletFrozen =>
      'ഒരു കാര്യം പരിശോധിക്കുന്നതിനാൽ പിൻവലിക്കലുകൾ തടഞ്ഞുവച്ചിരിക്കുന്നു. വിശദാംശങ്ങൾക്ക് പിന്തുണയുമായി ബന്ധപ്പെടുക.';

  @override
  String get walletWithdraw => 'പിൻവലിക്കുക';

  @override
  String walletNothingPending(Object amount) {
    return 'ഇതുവരെ പിൻവലിക്കാൻ ഒന്നുമില്ല. $amount ഇപ്പോഴും പ്രോസസ്സ് ചെയ്യുന്നു, ആ ജോലികൾ അംഗീകരിച്ചാൽ നിങ്ങളുടെ ബാലൻസിലേക്ക് വരും.';
  }

  @override
  String get walletNothingYet =>
      'ഇതുവരെ പിൻവലിക്കാൻ ഒന്നുമില്ല. ഉപഭോക്താവ് പൂർത്തിയായ ജോലി അംഗീകരിച്ചാൽ നിങ്ങളുടെ വരുമാനം ഇവിടെ കാണാം.';

  @override
  String get walletRecentEarnings => 'സമീപകാല വരുമാനം';

  @override
  String get walletNoEarnings => 'ഇതുവരെ വരുമാനമില്ല';

  @override
  String get walletNoEarningsBody =>
      'പൂർത്തിയായ ജോലിക്ക് പണം ലഭിച്ചാൽ നിങ്ങളുടെ വരുമാനം ഇവിടെ കാണാം.';

  @override
  String get walletAvailable => 'പിൻവലിക്കാൻ ലഭ്യം';

  @override
  String get walletProcessing => 'പ്രോസസ്സ് ചെയ്യുന്നു';

  @override
  String get walletProcessingHint => 'തടഞ്ഞുവയ്ക്കൽ കാലയളവിന് ശേഷം നൽകും';

  @override
  String get walletTotalEarned => 'ആകെ വരുമാനം';

  @override
  String get statementTitle => 'സ്റ്റേറ്റ്‌മെന്റ്';

  @override
  String get statementTabTransactions => 'ഇടപാടുകൾ';

  @override
  String get statementTabWithdrawals => 'പിൻവലിക്കലുകൾ';

  @override
  String get statementEmpty => 'ഇതുവരെ ഒന്നുമില്ല';

  @override
  String get statementEmptyBody =>
      'നിങ്ങൾ ജോലി ആരംഭിച്ചാൽ ഓരോ പേയ്‌മെന്റും ഫീസും പിൻവലിക്കലും ഇവിടെ ലിസ്റ്റ് ചെയ്യും.';

  @override
  String statementBalance(Object amount) {
    return 'ബാലൻസ് $amount';
  }

  @override
  String get statementNoWithdrawals => 'ഇതുവരെ പിൻവലിക്കലുകളില്ല';

  @override
  String get statementNoWithdrawalsBody =>
      'നിങ്ങൾ പണം പിൻവലിക്കുമ്പോൾ അത് ഇവിടെ ട്രാക്ക് ചെയ്യും.';

  @override
  String payoutRequestedAt(Object date) {
    return '$date-ന് അഭ്യർത്ഥിച്ചു';
  }

  @override
  String payoutPaidAt(Object date) {
    return '$date-ന് നൽകി';
  }

  @override
  String get payoutEnterAmount => 'എത്ര പിൻവലിക്കണമെന്ന് നൽകുക';

  @override
  String payoutUpTo(Object amount) {
    return 'നിങ്ങൾക്ക് ഇപ്പോൾ $amount വരെ പിൻവലിക്കാം';
  }

  @override
  String payoutMinimum(Object amount) {
    return 'ഏറ്റവും കുറഞ്ഞ പിൻവലിക്കൽ $amount ആണ്';
  }

  @override
  String payoutRequested(Object amount) {
    return '$amount പിൻവലിക്കാൻ അഭ്യർത്ഥിച്ചു. പ്രോസസ്സ് ചെയ്യുന്നതനുസരിച്ച് ഞങ്ങൾ അറിയിച്ചുകൊണ്ടിരിക്കും.';
  }

  @override
  String get payoutAvailableNow => 'ഇപ്പോൾ ലഭ്യം';

  @override
  String payoutPendingMore(Object amount) {
    return 'ഇനിയും $amount പ്രോസസ്സ് ചെയ്യുന്നു, ഇപ്പോൾ പിൻവലിക്കാനാകില്ല.';
  }

  @override
  String get payoutHowMuch => 'എത്ര?';

  @override
  String get payoutAll => 'എല്ലാം';

  @override
  String payoutPercent(Object percent) {
    return '$percent%';
  }

  @override
  String get payoutProcessNotice =>
      'പിൻവലിക്കലുകൾ പരിശോധിച്ച് നിങ്ങളുടെ രജിസ്റ്റർ ചെയ്ത ബാങ്ക് അക്കൗണ്ടിലേക്ക് അയയ്ക്കും. ഓരോ ഘട്ടത്തിലെയും നില ഇവിടെ കാണാം.';

  @override
  String get payoutRequest => 'പിൻവലിക്കൽ അഭ്യർത്ഥിക്കുക';

  @override
  String get bankChecking => 'നിങ്ങളുടെ ബാങ്ക് അക്കൗണ്ട് പരിശോധിക്കുന്നു…';

  @override
  String bankPaidTo(Object last4) {
    return '$last4-ൽ അവസാനിക്കുന്ന അക്കൗണ്ടിലേക്ക് നൽകും';
  }

  @override
  String get bankVerifiedFallback => 'നിങ്ങളുടെ പരിശോധിച്ച ബാങ്ക് അക്കൗണ്ട്';

  @override
  String get bankBeingVerified => 'ബാങ്ക് അക്കൗണ്ട് പരിശോധിക്കുന്നു';

  @override
  String get bankBeingVerifiedBody =>
      'ഞങ്ങളുടെ ടീം പരിശോധിച്ചാൽ നിങ്ങൾക്ക് പിൻവലിക്കാം.';

  @override
  String get bankNotVerified => 'ബാങ്ക് അക്കൗണ്ട് പരിശോധിച്ചിട്ടില്ല';

  @override
  String get bankNotVerifiedBody =>
      'നിങ്ങളുടെ വിശദാംശങ്ങൾ പരിശോധിച്ച് വീണ്ടും സമർപ്പിക്കുക.';

  @override
  String get bankAddTitle => 'ബാങ്ക് അക്കൗണ്ട് ചേർക്കുക';

  @override
  String get bankAddBody =>
      'ഞങ്ങളുടെ ടീം പരിശോധിച്ച ബാങ്ക് അക്കൗണ്ടിലേക്ക് മാത്രമേ പിൻവലിക്കലുകൾ നൽകൂ.';

  @override
  String get bankAddAction => 'ബാങ്ക് അക്കൗണ്ട് ചേർക്കുക';

  @override
  String get verificationTitle => 'പരിശോധന';

  @override
  String get verificationProgress => 'പരിശോധിച്ച പരിശോധനകൾ';

  @override
  String verificationCount(int approved, int total) {
    return '$total-ൽ $approved';
  }

  @override
  String get verificationInsurance => 'ഇൻഷുറൻസ്';

  @override
  String get verificationNoCover => 'സജീവ ഇൻഷുറൻസ് ഇല്ല';

  @override
  String get verificationNoCoverBody =>
      'നിലവിൽ ഞങ്ങളുടെ പക്കൽ നിങ്ങളുടെ ഇൻഷുറൻസ് പോളിസി രേഖപ്പെടുത്തിയിട്ടില്ല.';

  @override
  String get verifyIdentity => 'ഐഡന്റിറ്റി';

  @override
  String get verifyIdentityBody =>
      'ഒരു സർക്കാർ ഐഡി, തങ്ങളുടെ വീട്ടിലേക്ക് ആരാണ് വരുന്നതെന്ന് ഉപഭോക്താക്കൾക്ക് അറിയാൻ.';

  @override
  String get verifyAddress => 'വിലാസം';

  @override
  String get verifyAddressBody =>
      'നിങ്ങൾ എവിടെ താമസിക്കുന്നു എന്നതിന്റെ തെളിവ്.';

  @override
  String get verifyIti => 'ITI സർട്ടിഫിക്കറ്റ്';

  @override
  String get verifyItiBody =>
      'ഇൻഡസ്ട്രിയൽ ട്രെയിനിംഗ് ഇൻസ്റ്റിറ്റ്യൂട്ടിൽ (ITI) നിന്നുള്ള നിങ്ങളുടെ ട്രേഡ് സർട്ടിഫിക്കറ്റ്.';

  @override
  String get verifyDiploma => 'ഡിപ്ലോമ';

  @override
  String get verifyDiplomaBody => 'അംഗീകൃത സാങ്കേതിക ഡിപ്ലോമ.';

  @override
  String get verifyRpl => 'നൈപുണ്യ വിലയിരുത്തൽ';

  @override
  String get verifyRplBody =>
      'മുൻ പഠനത്തിന്റെ അംഗീകാരം (RPL): നിങ്ങളുടെ അനുഭവം വിലയിരുത്തി സാക്ഷ്യപ്പെടുത്തുന്നു.';

  @override
  String get verifyBackground => 'പശ്ചാത്തല പരിശോധന';

  @override
  String get verifyBackgroundBody =>
      'ഇത് ഞങ്ങൾ തന്നെ ചെയ്യുന്നു. നിങ്ങൾ ഒന്നും ചെയ്യേണ്ടതില്ല.';

  @override
  String get verifyInsuranceBody =>
      'ജോലി ചെയ്യുമ്പോഴുള്ള ആകസ്മിക നാശനഷ്ടങ്ങൾക്കുള്ള ഇൻഷുറൻസ്. ക്രമീകരിച്ചാൽ ഞങ്ങളുടെ ടീം നിങ്ങളുടെ പോളിസി ചേർക്കും.';

  @override
  String get verifyBank => 'ബാങ്ക് അക്കൗണ്ട്';

  @override
  String get verifyBankBody => 'നിങ്ങളുടെ പിൻവലിക്കലുകൾ നൽകുന്ന ഇടം.';

  @override
  String verificationValidUntil(Object date) {
    return '$date വരെ സാധുവാണ്';
  }

  @override
  String get verificationStart => 'ആരംഭിക്കുക';

  @override
  String get verificationUpdate => 'അപ്ഡേറ്റ് ചെയ്യുക';

  @override
  String get policyActive => 'സജീവം';

  @override
  String get policyNotActive => 'സജീവമല്ല';

  @override
  String get policyNumber => 'പോളിസി';

  @override
  String get policyCover => 'പരിരക്ഷ';

  @override
  String get policyValidUntil => 'വരെ സാധുവാണ്';

  @override
  String get kycStillWaiting =>
      'ഇപ്പോഴും DigiLocker-നായി കാത്തിരിക്കുന്നു. പിന്നീട് ഇവിടെ നിന്ന് വീണ്ടും നോക്കാം.';

  @override
  String get kycTitle => 'ഐഡന്റിറ്റി പരിശോധന';

  @override
  String get kycHeadline => 'നിങ്ങൾ ആരാണെന്ന് സ്ഥിരീകരിക്കുക';

  @override
  String get kycIntro =>
      'ഉപഭോക്താക്കൾ നിങ്ങളെ അവരുടെ വീടുകളിലേക്ക് പ്രവേശിപ്പിക്കുന്നു, അതിനാൽ ഓരോ ജീവനക്കാരന്റെയും ഐഡന്റിറ്റി ഇന്ത്യാ ഗവൺമെന്റിന്റെ ഡോക്യുമെന്റ് പ്ലാറ്റ്‌ഫോമായ DigiLocker വഴി ഞങ്ങൾ പരിശോധിക്കുന്നു. ഒന്നും അപ്‌ലോഡ് ചെയ്യുന്നില്ല — നിങ്ങളുടെ ആധാർ അക്കൗണ്ടിൽ അഭ്യർത്ഥന അംഗീകരിച്ചാൽ മതി.';

  @override
  String get kycPrivacy =>
      'നിങ്ങളുടെ ആധാർ വിശദാംശങ്ങൾ DigiLocker-ൽ നിന്ന് നേരിട്ട് സ്ഥിരീകരിക്കുന്നു. പരിശോധന നടന്നു എന്ന് തെളിയിക്കുന്നത് മാത്രമേ ഞങ്ങൾ സൂക്ഷിക്കൂ — നിങ്ങളുടെ ഫോട്ടോയോ ആധാറിന്റെ പകർപ്പോ ഒരിക്കലുമില്ല.';

  @override
  String get kycVerified => 'നിങ്ങളുടെ ഐഡന്റിറ്റി പരിശോധിച്ചു.';

  @override
  String get kycAwaitingConsent =>
      'നിങ്ങളുടെ ബ്രൗസറിൽ DigiLocker സമ്മതം പൂർത്തിയാക്കി ഇവിടേക്ക് മടങ്ങുക.';

  @override
  String get kycChecking => 'DigiLocker-മായി പരിശോധിക്കുന്നു…';

  @override
  String get kycStart => 'DigiLocker ഉപയോഗിച്ച് പരിശോധിക്കുക';

  @override
  String get qualSubmitted => 'അവലോകനത്തിനായി സമർപ്പിച്ചു.';

  @override
  String get qualTitle => 'നിങ്ങളുടെ യോഗ്യത';

  @override
  String get qualIti => 'ITI';

  @override
  String get qualInstitute => 'സ്ഥാപനം';

  @override
  String get qualInstituteHint => 'ഉദാ. ഗവൺമെന്റ് ITI, കോയമ്പത്തൂർ';

  @override
  String get qualName => 'യോഗ്യത';

  @override
  String get qualNameHint => 'ഉദാ. ഇലക്ട്രീഷ്യൻ';

  @override
  String get qualSpeciality => 'പ്രത്യേകത (ഓപ്ഷണൽ)';

  @override
  String get qualSpecialityHint => 'ഉദാ. ഇൻഡസ്ട്രിയൽ വയറിംഗ്';

  @override
  String get qualYear => 'പൂർത്തിയാക്കിയ വർഷം';

  @override
  String get qualCertificate => 'നിങ്ങളുടെ സർട്ടിഫിക്കറ്റ്';

  @override
  String get qualCertificateBody =>
      'സർട്ടിഫിക്കറ്റിന്റെ വ്യക്തമായ ഫോട്ടോ അല്ലെങ്കിൽ PDF.';

  @override
  String get bankErrorHolder => 'അക്കൗണ്ടിൽ ഉള്ളതുപോലെ തന്നെ പേര് നൽകുക';

  @override
  String get bankErrorNumber => 'അക്കൗണ്ട് നമ്പർ 9 മുതൽ 18 അക്കങ്ങൾ വരെയാണ്';

  @override
  String get bankErrorMismatch => 'അക്കൗണ്ട് നമ്പറുകൾ പൊരുത്തപ്പെടുന്നില്ല';

  @override
  String get bankErrorIfsc => '11 അക്ഷര IFSC നൽകുക, ഉദാ. SBIN0001234';

  @override
  String get bankSent => 'ബാങ്ക് അക്കൗണ്ട് പരിശോധനയ്ക്ക് അയച്ചു.';

  @override
  String get bankNotice =>
      'നിങ്ങളുടെ പിൻവലിക്കലുകൾ ഈ അക്കൗണ്ടിലേക്ക് നൽകും. ആദ്യ പേഔട്ടിന് മുമ്പ് ഞങ്ങളുടെ ടീം ഇത് പരിശോധിക്കും.';

  @override
  String get bankHolder => 'അക്കൗണ്ട് ഉടമയുടെ പേര്';

  @override
  String get bankNumber => 'അക്കൗണ്ട് നമ്പർ';

  @override
  String get bankConfirmNumber => 'അക്കൗണ്ട് നമ്പർ വീണ്ടും നൽകുക';

  @override
  String get bankIfsc => 'IFSC കോഡ്';

  @override
  String get bankIfscHint => 'ഉദാ. SBIN0001234';

  @override
  String get bankName => 'ബാങ്കിന്റെ പേര് (ഓപ്ഷണൽ)';

  @override
  String get bankSubmit => 'പരിശോധനയ്ക്ക് സമർപ്പിക്കുക';

  @override
  String get profileCompleteness => 'പ്രൊഫൈൽ പൂർണ്ണത';

  @override
  String get profileCompletenessBody =>
      'പൂർണ്ണമായ പ്രൊഫൈൽ ഉപഭോക്താക്കൾക്ക് നിങ്ങളെ തിരഞ്ഞെടുക്കാൻ സഹായിക്കുന്നു.';

  @override
  String get profileJobsDone => 'പൂർത്തിയായ ജോലികൾ';

  @override
  String get profileRating => 'റേറ്റിംഗ്';

  @override
  String get profileExperience => 'അനുഭവം';

  @override
  String profileExperienceYears(Object years) {
    return '$years വർഷം';
  }

  @override
  String get profileEdit => 'പ്രൊഫൈൽ എഡിറ്റ് ചെയ്യുക';

  @override
  String get profileVerified => 'പരിശോധിച്ചു';

  @override
  String get profileNotVerified => 'പരിശോധിച്ചിട്ടില്ല';

  @override
  String get profilePinInvalid => 'സാധുവായ 6 അക്ക പിൻ കോഡ് നൽകുക';

  @override
  String get profileUpdated => 'പ്രൊഫൈൽ അപ്ഡേറ്റ് ചെയ്തു.';

  @override
  String get profilePhotoUpdated => 'ഫോട്ടോ അപ്ഡേറ്റ് ചെയ്തു.';

  @override
  String get profileChangePhoto => 'ഫോട്ടോ മാറ്റുക';

  @override
  String get profileName => 'പേര്';

  @override
  String get profilePhone => 'ഫോൺ';

  @override
  String get profileLockedNotice =>
      'നിങ്ങളുടെ പേരും നമ്പറും ഐഡന്റിറ്റി പരിശോധനയുമായി ബന്ധിപ്പിച്ചിരിക്കുന്നു. ഏതെങ്കിലും മാറ്റണമെങ്കിൽ പിന്തുണയുമായി ബന്ധപ്പെടുക.';

  @override
  String get profileAbout => 'നിങ്ങളെക്കുറിച്ച്';

  @override
  String get profileBioHint =>
      'നിങ്ങളുടെ അനുഭവത്തെക്കുറിച്ചും നിങ്ങൾ മികച്ചത് എന്തിലാണെന്നും ഉപഭോക്താക്കളോട് പറയൂ.';

  @override
  String get profileYearsExperience => 'അനുഭവ വർഷങ്ങൾ';

  @override
  String get profileBased => 'നിങ്ങൾ എവിടെ താമസിക്കുന്നു';

  @override
  String get profileAddress => 'വിലാസം';

  @override
  String get profileCity => 'നഗരം';

  @override
  String get profilePin => 'പിൻ കോഡ്';

  @override
  String get profileGender => 'ലിംഗം';

  @override
  String get genderMale => 'പുരുഷൻ';

  @override
  String get genderFemale => 'സ്ത്രീ';

  @override
  String get genderOther => 'മറ്റുള്ളവ';

  @override
  String get profileTrades => 'നിങ്ങളുടെ ജോലികൾ';

  @override
  String get profileTradesBody =>
      'നിങ്ങൾക്ക് അംഗീകാരമുള്ള എല്ലാ ജോലികളിലും നിങ്ങൾക്ക് ജോലി ചെയ്യാം.';

  @override
  String get profileTradesLoadFailed => 'നിങ്ങളുടെ ജോലികൾ ലോഡ് ചെയ്യാനായില്ല.';

  @override
  String get tradePending => 'തീർപ്പാകാനുണ്ട്';

  @override
  String get profileAddTrade => 'ജോലി ചേർക്കുക';

  @override
  String get profileAddTradeBody =>
      'അംഗീകരിക്കുന്നതിന് മുമ്പ് നിങ്ങളുടെ കഴിവുകളുടെ തെളിവ് ചോദിച്ചേക്കാം.';

  @override
  String get profileTradeRequested =>
      'അഭ്യർത്ഥിച്ചു. അംഗീകരിച്ചാലുടൻ ഞങ്ങൾ അറിയിക്കും.';

  @override
  String get profileSave => 'മാറ്റങ്ങൾ സേവ് ചെയ്യുക';

  @override
  String get supportNewRequest => 'പുതിയ അഭ്യർത്ഥന';

  @override
  String get supportEmpty => 'ഇതുവരെ അഭ്യർത്ഥനകളില്ല';

  @override
  String get supportEmptyBody =>
      'ഏതെങ്കിലും ജോലിയിലോ പേയ്‌മെന്റിലോ അക്കൗണ്ടിലോ പ്രശ്നമുണ്ടായാൽ, അഭ്യർത്ഥന നൽകുക, ഞങ്ങൾ സഹായിക്കും.';

  @override
  String get supportYourRequests => 'നിങ്ങളുടെ അഭ്യർത്ഥനകൾ';

  @override
  String get supportEmergency => 'അടിയന്തര സാഹചര്യത്തിൽ';

  @override
  String get supportEmergencyBody =>
      'ഈ ആപ്പിന് നിങ്ങൾക്ക് വേണ്ടി സഹായം വിളിക്കാനാകില്ല. നിങ്ങൾ അപകടത്തിലാണെങ്കിൽ, അടിയന്തര സേവനങ്ങളെ നേരിട്ട് വിളിക്കുക.';

  @override
  String get supportCall112 => '112-ൽ വിളിക്കുക';

  @override
  String get supportPolice => 'പോലീസ്';

  @override
  String get ticketOpen => 'തുറന്നത്';

  @override
  String get ticketInProgress => 'പുരോഗതിയിൽ';

  @override
  String get ticketReplyNeeded => 'നിങ്ങളുടെ മറുപടി വേണം';

  @override
  String get ticketResolved => 'പരിഹരിച്ചു';

  @override
  String get ticketClosed => 'അടച്ചു';

  @override
  String ticketLastUpdate(Object date) {
    return 'അവസാന അപ്ഡേറ്റ് $date';
  }

  @override
  String get supportCategoryJob => 'ഒരു ജോലി';

  @override
  String get supportCategoryPayment => 'ഒരു പേയ്‌മെന്റ്';

  @override
  String get supportCategoryWithdrawal => 'ഒരു പിൻവലിക്കൽ';

  @override
  String get supportCategoryAccount => 'എന്റെ അക്കൗണ്ട്';

  @override
  String get supportCategorySafety => 'സുരക്ഷ';

  @override
  String get supportCategoryApp => 'ആപ്പ്';

  @override
  String get supportCategoryOther => 'മറ്റെന്തെങ്കിലും';

  @override
  String supportRaised(Object code) {
    return 'അഭ്യർത്ഥന $code രേഖപ്പെടുത്തി.';
  }

  @override
  String get supportHowHelp => 'ഞങ്ങൾ എങ്ങനെ സഹായിക്കും?';

  @override
  String get supportAbout => 'ഇത് എന്തിനെക്കുറിച്ചാണ്?';

  @override
  String get supportSubject => 'വിഷയം';

  @override
  String get supportSubjectHint => 'പ്രശ്നത്തെക്കുറിച്ച് കുറച്ച് വാക്കുകൾ';

  @override
  String get supportWhatHappened => 'എന്താണ് സംഭവിച്ചത്?';

  @override
  String get supportSend => 'അഭ്യർത്ഥന അയയ്ക്കുക';

  @override
  String get ticketTitle => 'പിന്തുണാ അഭ്യർത്ഥന';

  @override
  String get ticketNoMessages => 'ഇതുവരെ സന്ദേശങ്ങളില്ല';

  @override
  String get ticketNoMessagesBody => 'നിങ്ങളുടെ സംഭാഷണം ഇവിടെ കാണാം.';

  @override
  String get ticketWriteMessage => 'ഒരു സന്ദേശം എഴുതുക';

  @override
  String get ticketSupportName => 'Wervexa പിന്തുണ';

  @override
  String get requestsTitle => 'ഉപഭോക്തൃ അഭ്യർത്ഥനകൾ';

  @override
  String get requestsRefresh => 'പുതുക്കുക';

  @override
  String get requestsLocationNeeded => 'ലൊക്കേഷൻ ആവശ്യമാണ്';

  @override
  String get requestsLocationBody =>
      'നിങ്ങളുടെ സമീപത്തെ ഉപഭോക്തൃ അഭ്യർത്ഥനകൾ കണ്ടെത്താൻ ഞങ്ങൾ നിങ്ങളുടെ ലൊക്കേഷൻ ഉപയോഗിക്കുന്നു.';

  @override
  String get requestsGrantLocation => 'ലൊക്കേഷൻ ആക്സസ് നൽകുക';

  @override
  String get requestsEmpty => 'സമീപത്ത് പൊരുത്തപ്പെടുന്ന അഭ്യർത്ഥനകളില്ല';

  @override
  String get requestsEmptyBody =>
      'നിങ്ങളുടെ സേവനങ്ങളുമായി പൊരുത്തപ്പെടുമ്പോൾ\nപുതിയ ഉപഭോക്തൃ അഭ്യർത്ഥനകൾ ഇവിടെ കാണാം.';

  @override
  String get requestsViewOffer => 'കണ്ട് ഓഫർ നൽകുക →';

  @override
  String get requestEnterPrice => 'സാധുവായ വില നൽകുക';

  @override
  String requestOfferSubmitted(Object price) {
    return '$price-ന് ഓഫർ സമർപ്പിച്ചു!';
  }

  @override
  String get requestDetailsTitle => 'അഭ്യർത്ഥന വിശദാംശങ്ങൾ';

  @override
  String get requestStatusOpen => 'തുറന്നത്';

  @override
  String get requestCategory => 'വിഭാഗം';

  @override
  String get requestBudget => 'ബജറ്റ്';

  @override
  String get requestSchedule => 'ഷെഡ്യൂൾ';

  @override
  String get requestDistance => 'ദൂരം';

  @override
  String get requestArea => 'പ്രദേശം';

  @override
  String get requestOffers => 'ഓഫറുകൾ';

  @override
  String get requestNotes => 'കുറിപ്പുകൾ';

  @override
  String get requestAddressPrivacy =>
      'ഉപഭോക്താവ് നിങ്ങളുടെ ഓഫർ സ്വീകരിച്ച ശേഷം മാത്രമേ അവരുടെ കൃത്യമായ വിലാസം പങ്കിടൂ.';

  @override
  String get requestYourOffer => 'നിങ്ങളുടെ ഓഫർ';

  @override
  String get requestYourPrice => 'നിങ്ങളുടെ വില (₹)';

  @override
  String get requestPriceHint => 'ഉദാ. 500';

  @override
  String get requestDuration => 'കണക്കാക്കിയ സമയം (ഓപ്ഷണൽ)';

  @override
  String get requestDurationHint => 'ഉദാ. 1-2 മണിക്കൂർ';

  @override
  String get requestMessage => 'ഉപഭോക്താവിനുള്ള സന്ദേശം (ഓപ്ഷണൽ)';

  @override
  String get requestMessageHint =>
      'ഈ ജോലിക്ക് നിങ്ങളാണ് ശരിയായ ആൾ എന്തുകൊണ്ട്?';

  @override
  String get requestSubmitOffer => 'ഓഫർ സമർപ്പിക്കുക';

  @override
  String get requestMakeOffer => 'ഓഫർ നൽകുക';

  @override
  String get requestAlreadyOffered =>
      'ഈ അഭ്യർത്ഥനയ്ക്ക് നിങ്ങൾ ഇതിനകം ഓഫർ സമർപ്പിച്ചു.';

  @override
  String get requestViewOffers => 'ഓഫറുകൾ കാണുക';

  @override
  String get offersEmptyBody =>
      'ഉപഭോക്തൃ അഭ്യർത്ഥനകളിൽ നിങ്ങൾ സമർപ്പിക്കുന്ന ഓഫറുകൾ\nഇവിടെ കാണാം.';

  @override
  String get offerWithdraw => 'പിൻവലിക്കുക';

  @override
  String get offerWithdrawTitle => 'ഓഫർ പിൻവലിക്കണോ?';

  @override
  String get offerWithdrawBody => 'ഉപഭോക്താവിന് ഇനി ഈ ഓഫർ കാണാനാകില്ല.';

  @override
  String get offerWithdrawn => 'ഓഫർ പിൻവലിച്ചു';

  @override
  String get onboardingTitle => 'നിങ്ങളുടെ പ്രൊഫൈൽ സജ്ജമാക്കുക';

  @override
  String get onboardingHelp => 'സഹായം';

  @override
  String onboardingHello(Object name) {
    return 'നമസ്കാരം, $name';
  }

  @override
  String get onboardingIntro =>
      'കുറച്ച് കാര്യങ്ങൾ കൂടി, പിന്നെ ജോലി ലഭിച്ചുതുടങ്ങാൻ നിങ്ങൾ തയ്യാർ.';

  @override
  String get onboardingSetup => 'സജ്ജീകരണം';

  @override
  String onboardingStepCount(int done, int total) {
    return '$total-ൽ $done';
  }

  @override
  String get onboardingBasicBody =>
      'നിങ്ങളുടെ നഗരവും പിൻ കോഡും, സമീപത്ത് ജോലി കണ്ടെത്താൻ.';

  @override
  String get onboardingTradeBody => 'നിങ്ങൾ പ്രധാനമായും ചെയ്യുന്ന ജോലി.';

  @override
  String get onboardingSkillsDoneBody =>
      'നിങ്ങളുടെ പ്രധാന ജോലി ഒന്നായി കണക്കാക്കും. നിങ്ങൾ ചെയ്യുന്ന മറ്റെല്ലാ ജോലികളും ചേർക്കാൻ ഇത് തുറക്കുക.';

  @override
  String get onboardingSkillsBody =>
      'നിങ്ങൾ ചെയ്യുന്ന എല്ലാ ജോലികളും ചേർക്കുക. നിങ്ങൾ ഒരു ജോലിയിൽ മാത്രം ഒതുങ്ങുന്നില്ല.';

  @override
  String get onboardingAreaBody =>
      'ഒരു ജോലിക്കായി നിങ്ങൾ എത്ര ദൂരം പോകാൻ തയ്യാറാണ്.';

  @override
  String get onboardingKycBody =>
      'ഒരു സർക്കാർ ഐഡി. ഉപഭോക്താക്കൾ നിങ്ങളെ അവരുടെ വീടുകളിലേക്ക് പ്രവേശിപ്പിക്കുന്നു.';

  @override
  String get onboardingReviewNotice =>
      'ഇവ പൂർത്തിയാക്കിയാൽ ഞങ്ങളുടെ ടീം നിങ്ങളുടെ രേഖകൾ പരിശോധിക്കും. കാത്തിരിക്കുമ്പോൾ നിങ്ങളുടെ സേവനങ്ങൾ സജ്ജമാക്കുന്നത് തുടരാം.';

  @override
  String get onboardingTradesLoadFailed =>
      'ജോലികൾ ലോഡ് ചെയ്യാനായില്ല. വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get onboardingMainTrade => 'നിങ്ങളുടെ പ്രധാന ജോലി ഏതാണ്?';

  @override
  String get onboardingMainTradeBody => 'പിന്നീട് കൂടുതൽ ജോലികൾ ചേർക്കാം.';

  @override
  String onboardingTradeSet(Object trade) {
    return '$trade നിങ്ങളുടെ പ്രധാന ജോലിയായി സജ്ജമാക്കി.';
  }

  @override
  String get onboardingTravelTitle => 'നിങ്ങൾ എത്ര ദൂരം യാത്ര ചെയ്യും?';

  @override
  String get onboardingTravelBody =>
      'നിങ്ങൾ ഇപ്പോൾ ഉള്ള സ്ഥലത്തുനിന്ന് ഈ ദൂരത്തിനുള്ളിലെ ജോലികൾ മാത്രമേ ഞങ്ങൾ നൽകൂ.';

  @override
  String get onboardingTravelCentre =>
      'നിങ്ങളുടെ നിലവിലെ ലൊക്കേഷൻ കേന്ദ്രബിന്ദുവായി ഉപയോഗിക്കുന്നു. പ്രൊഫൈലിൽ നിന്ന് എപ്പോൾ വേണമെങ്കിലും മാറ്റാം.';

  @override
  String get onboardingLocationOff =>
      'നിങ്ങളുടെ ജോലി പ്രദേശം സജ്ജമാക്കാൻ ലൊക്കേഷൻ ആക്സസ് ഓണാക്കുക.';

  @override
  String get commonSave => 'സേവ് ചെയ്യുക';

  @override
  String get notificationsStayOff =>
      'അറിയിപ്പുകൾ ഓഫായിരിക്കും. ഫോൺ ക്രമീകരണങ്ങളിൽ അവ ഓണാക്കാം.';

  @override
  String get notificationsPrimerTitle => 'ജോലി വരുമ്പോൾ അറിയുക';

  @override
  String get notificationsPrimerBody =>
      'ജോലി ഓഫറുകൾക്ക് കാലാവധിയുണ്ട്. ആപ്പ് അടച്ചിരിക്കുമ്പോൾ അറിയിപ്പിലൂടെയാണ് നിങ്ങൾ അറിയുന്നത് — മറ്റൊന്നും അയയ്ക്കില്ല.';

  @override
  String get notificationsTurnOn => 'അറിയിപ്പുകൾ ഓണാക്കുക';

  @override
  String get commonNotNow => 'ഇപ്പോൾ വേണ്ട';

  @override
  String get onboardingCityRequired => 'ദയവായി നിങ്ങളുടെ നഗരം നൽകുക';

  @override
  String get onboardingGenderRequired =>
      'ദയവായി നിങ്ങളുടെ ലിംഗം തിരഞ്ഞെടുക്കുക';

  @override
  String get onboardingWhereBased => 'നിങ്ങൾ എവിടെ താമസിക്കുന്നു?';
}
