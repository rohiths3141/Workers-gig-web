import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @languagePickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your language'**
  String get languagePickerTitle;

  /// No description provided for @startupMissingConfig.
  ///
  /// In en, this message translates to:
  /// **'This build is missing its configuration.'**
  String get startupMissingConfig;

  /// No description provided for @startupPassDartDefine.
  ///
  /// In en, this message translates to:
  /// **'Pass these with --dart-define:\n\n{keys}'**
  String startupPassDartDefine(Object keys);

  /// No description provided for @startupCouldNotStart.
  ///
  /// In en, this message translates to:
  /// **'The app could not start.'**
  String get startupCouldNotStart;

  /// No description provided for @errorNoInternet.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Check your network and try again.'**
  String get errorNoInternet;

  /// No description provided for @errorTimeout.
  ///
  /// In en, this message translates to:
  /// **'That took too long. Try again.'**
  String get errorTimeout;

  /// No description provided for @errorServer.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong at our end. Please try again.'**
  String get errorServer;

  /// No description provided for @errorClockSkew.
  ///
  /// In en, this message translates to:
  /// **'Your phone\'s date and time look out of sync. Turn on automatic date & time in Settings, then try again.'**
  String get errorClockSkew;

  /// No description provided for @errorUnexpected.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorUnexpected;

  /// No description provided for @eligibilityStepIncomplete.
  ///
  /// In en, this message translates to:
  /// **'This step is not complete yet.'**
  String get eligibilityStepIncomplete;

  /// No description provided for @errorSessionEnded.
  ///
  /// In en, this message translates to:
  /// **'Your session has ended. Please sign in again.'**
  String get errorSessionEnded;

  /// No description provided for @errorUploadFailed.
  ///
  /// In en, this message translates to:
  /// **'That file could not be uploaded. Try again.'**
  String get errorUploadFailed;

  /// No description provided for @errorServiceUnavailable.
  ///
  /// In en, this message translates to:
  /// **'That service is unavailable right now. Try again shortly.'**
  String get errorServiceUnavailable;

  /// No description provided for @errorSignInNotReady.
  ///
  /// In en, this message translates to:
  /// **'Your sign-in is not fully set up yet. Try again in a moment.'**
  String get errorSignInNotReady;

  /// No description provided for @errorNoLongerAvailable.
  ///
  /// In en, this message translates to:
  /// **'That is no longer available.'**
  String get errorNoLongerAvailable;

  /// No description provided for @errorNotAllowedToSee.
  ///
  /// In en, this message translates to:
  /// **'You are not able to see that.'**
  String get errorNotAllowedToSee;

  /// No description provided for @errorDidNotWork.
  ///
  /// In en, this message translates to:
  /// **'That did not work. Please try again.'**
  String get errorDidNotWork;

  /// No description provided for @authErrorInvalidPhone.
  ///
  /// In en, this message translates to:
  /// **'That phone number does not look right.'**
  String get authErrorInvalidPhone;

  /// No description provided for @authErrorWrongCode.
  ///
  /// In en, this message translates to:
  /// **'That code is not correct. Check and try again.'**
  String get authErrorWrongCode;

  /// No description provided for @authErrorCodeExpired.
  ///
  /// In en, this message translates to:
  /// **'That code has expired. Ask for a new one.'**
  String get authErrorCodeExpired;

  /// No description provided for @authErrorTooManyAttempts.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Wait a few minutes before trying again.'**
  String get authErrorTooManyAttempts;

  /// No description provided for @authErrorQuota.
  ///
  /// In en, this message translates to:
  /// **'We cannot send a code right now. Try again shortly.'**
  String get authErrorQuota;

  /// No description provided for @authErrorDisabled.
  ///
  /// In en, this message translates to:
  /// **'This account has been disabled. Contact support.'**
  String get authErrorDisabled;

  /// No description provided for @authErrorPhoneNotEnabledRegion.
  ///
  /// In en, this message translates to:
  /// **'Phone sign-in is not enabled, or SMS to this region is blocked. Check Firebase Console settings.'**
  String get authErrorPhoneNotEnabledRegion;

  /// No description provided for @authErrorNumberInUse.
  ///
  /// In en, this message translates to:
  /// **'That number is already registered to another account.'**
  String get authErrorNumberInUse;

  /// No description provided for @authErrorSignInAgain.
  ///
  /// In en, this message translates to:
  /// **'Please sign in again to continue.'**
  String get authErrorSignInAgain;

  /// No description provided for @authErrorSignInFailed.
  ///
  /// In en, this message translates to:
  /// **'Sign-in failed. Please try again.'**
  String get authErrorSignInFailed;

  /// No description provided for @budgetTypeFlexible.
  ///
  /// In en, this message translates to:
  /// **'Flexible'**
  String get budgetTypeFlexible;

  /// No description provided for @budgetTypeFixed.
  ///
  /// In en, this message translates to:
  /// **'Fixed price'**
  String get budgetTypeFixed;

  /// No description provided for @budgetTypeRange.
  ///
  /// In en, this message translates to:
  /// **'Price range'**
  String get budgetTypeRange;

  /// No description provided for @scheduleAsap.
  ///
  /// In en, this message translates to:
  /// **'As soon as possible'**
  String get scheduleAsap;

  /// No description provided for @scheduleToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get scheduleToday;

  /// No description provided for @scheduleTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get scheduleTomorrow;

  /// No description provided for @scheduleSpecificDate.
  ///
  /// In en, this message translates to:
  /// **'Specific date'**
  String get scheduleSpecificDate;

  /// No description provided for @offerStatusSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Submitted'**
  String get offerStatusSubmitted;

  /// No description provided for @offerStatusViewed.
  ///
  /// In en, this message translates to:
  /// **'Viewed by customer'**
  String get offerStatusViewed;

  /// No description provided for @offerStatusShortlisted.
  ///
  /// In en, this message translates to:
  /// **'Shortlisted'**
  String get offerStatusShortlisted;

  /// No description provided for @offerStatusAccepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted ✓'**
  String get offerStatusAccepted;

  /// No description provided for @offerStatusRejected.
  ///
  /// In en, this message translates to:
  /// **'Not selected'**
  String get offerStatusRejected;

  /// No description provided for @offerStatusWithdrawn.
  ///
  /// In en, this message translates to:
  /// **'Withdrawn'**
  String get offerStatusWithdrawn;

  /// No description provided for @offerStatusExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get offerStatusExpired;

  /// No description provided for @offerStatusClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get offerStatusClosed;

  /// No description provided for @distanceMetresAway.
  ///
  /// In en, this message translates to:
  /// **'{metres} m away'**
  String distanceMetresAway(Object metres);

  /// No description provided for @distanceKmAway.
  ///
  /// In en, this message translates to:
  /// **'{km} km away'**
  String distanceKmAway(Object km);

  /// No description provided for @offerCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No offers yet} =1{1 offer} other{{count} offers}}'**
  String offerCount(int count);

  /// No description provided for @gigErrorTrade.
  ///
  /// In en, this message translates to:
  /// **'Choose which trade this service belongs to'**
  String get gigErrorTrade;

  /// No description provided for @gigErrorTitleShort.
  ///
  /// In en, this message translates to:
  /// **'Give this service a clear name of at least 6 characters'**
  String get gigErrorTitleShort;

  /// No description provided for @gigErrorTitleLong.
  ///
  /// In en, this message translates to:
  /// **'Keep the name under 120 characters'**
  String get gigErrorTitleLong;

  /// No description provided for @gigErrorPrice.
  ///
  /// In en, this message translates to:
  /// **'Enter what you charge for this service'**
  String get gigErrorPrice;

  /// No description provided for @gigErrorDurationMissing.
  ///
  /// In en, this message translates to:
  /// **'How long does this usually take?'**
  String get gigErrorDurationMissing;

  /// No description provided for @gigErrorDurationShort.
  ///
  /// In en, this message translates to:
  /// **'The shortest job we can list is 15 minutes'**
  String get gigErrorDurationShort;

  /// No description provided for @gigErrorDurationLong.
  ///
  /// In en, this message translates to:
  /// **'The longest job we can list is 14 days'**
  String get gigErrorDurationLong;

  /// No description provided for @gigErrorRadius.
  ///
  /// In en, this message translates to:
  /// **'Travel distance must be between 1 and 100 km'**
  String get gigErrorRadius;

  /// No description provided for @jobAreaNearby.
  ///
  /// In en, this message translates to:
  /// **'Nearby'**
  String get jobAreaNearby;

  /// No description provided for @jobBlockerVerifyArrival.
  ///
  /// In en, this message translates to:
  /// **'Verify arrival with the customer\'s code'**
  String get jobBlockerVerifyArrival;

  /// No description provided for @jobBlockerAfterPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add a photo of the finished work'**
  String get jobBlockerAfterPhoto;

  /// No description provided for @jobBlockerMaterialsPending.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 material request still waiting on the customer} other{{count} material requests still waiting on the customer}}'**
  String jobBlockerMaterialsPending(int count);

  /// No description provided for @mediaTypeNotAccepted.
  ///
  /// In en, this message translates to:
  /// **'That file type is not accepted here. Use {kinds}.'**
  String mediaTypeNotAccepted(Object kinds);

  /// No description provided for @mediaEmpty.
  ///
  /// In en, this message translates to:
  /// **'That file is empty.'**
  String get mediaEmpty;

  /// No description provided for @mediaTooLarge.
  ///
  /// In en, this message translates to:
  /// **'That file is too large. The limit is {megabytes}MB.'**
  String mediaTooLarge(Object megabytes);

  /// No description provided for @verificationNotStarted.
  ///
  /// In en, this message translates to:
  /// **'Not started'**
  String get verificationNotStarted;

  /// No description provided for @verificationSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Submitted'**
  String get verificationSubmitted;

  /// No description provided for @verificationUnderReview.
  ///
  /// In en, this message translates to:
  /// **'Being reviewed'**
  String get verificationUnderReview;

  /// No description provided for @verificationMoreInfo.
  ///
  /// In en, this message translates to:
  /// **'More information needed'**
  String get verificationMoreInfo;

  /// No description provided for @verificationExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get verificationExpired;

  /// No description provided for @verificationVerified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get verificationVerified;

  /// No description provided for @verificationNotApproved.
  ///
  /// In en, this message translates to:
  /// **'Not approved'**
  String get verificationNotApproved;

  /// No description provided for @verificationNotRequired.
  ///
  /// In en, this message translates to:
  /// **'Not required'**
  String get verificationNotRequired;

  /// No description provided for @qualificationErrorInstitution.
  ///
  /// In en, this message translates to:
  /// **'Which institute issued this?'**
  String get qualificationErrorInstitution;

  /// No description provided for @qualificationErrorName.
  ///
  /// In en, this message translates to:
  /// **'What is the qualification called?'**
  String get qualificationErrorName;

  /// No description provided for @qualificationErrorYearMissing.
  ///
  /// In en, this message translates to:
  /// **'Which year did you complete it?'**
  String get qualificationErrorYearMissing;

  /// No description provided for @qualificationErrorYearRange.
  ///
  /// In en, this message translates to:
  /// **'Enter a year between 1950 and {year}'**
  String qualificationErrorYearRange(Object year);

  /// No description provided for @walletTxJobEarning.
  ///
  /// In en, this message translates to:
  /// **'Job earning'**
  String get walletTxJobEarning;

  /// No description provided for @walletTxMaterialReimbursed.
  ///
  /// In en, this message translates to:
  /// **'Material reimbursed'**
  String get walletTxMaterialReimbursed;

  /// No description provided for @walletTxAdjustment.
  ///
  /// In en, this message translates to:
  /// **'Adjustment'**
  String get walletTxAdjustment;

  /// No description provided for @walletTxPayoutReturned.
  ///
  /// In en, this message translates to:
  /// **'Payout returned'**
  String get walletTxPayoutReturned;

  /// No description provided for @walletTxPlatformFee.
  ///
  /// In en, this message translates to:
  /// **'Platform fee'**
  String get walletTxPlatformFee;

  /// No description provided for @walletTxWithdrawn.
  ///
  /// In en, this message translates to:
  /// **'Withdrawn'**
  String get walletTxWithdrawn;

  /// No description provided for @walletTxClaimRecovery.
  ///
  /// In en, this message translates to:
  /// **'Claim recovery'**
  String get walletTxClaimRecovery;

  /// No description provided for @payoutStatusRequested.
  ///
  /// In en, this message translates to:
  /// **'Requested'**
  String get payoutStatusRequested;

  /// No description provided for @payoutStatusProcessing.
  ///
  /// In en, this message translates to:
  /// **'Being processed'**
  String get payoutStatusProcessing;

  /// No description provided for @payoutStatusPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get payoutStatusPaid;

  /// No description provided for @payoutStatusFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get payoutStatusFailed;

  /// No description provided for @authPhoneTenDigits.
  ///
  /// In en, this message translates to:
  /// **'Enter a 10-digit mobile number.'**
  String get authPhoneTenDigits;

  /// No description provided for @authCodeSendTimeout.
  ///
  /// In en, this message translates to:
  /// **'We could not send the code. Check your network and try again.'**
  String get authCodeSendTimeout;

  /// No description provided for @authEnterReceivedCode.
  ///
  /// In en, this message translates to:
  /// **'Enter the code you received.'**
  String get authEnterReceivedCode;

  /// No description provided for @authSignInIncomplete.
  ///
  /// In en, this message translates to:
  /// **'Sign-in did not complete. Please try again.'**
  String get authSignInIncomplete;

  /// No description provided for @authSignInToContinue.
  ///
  /// In en, this message translates to:
  /// **'Please sign in to continue.'**
  String get authSignInToContinue;

  /// No description provided for @accountDeletionBySupport.
  ///
  /// In en, this message translates to:
  /// **'Account deletion is handled by our support team. Raise a request and we will confirm once it is done.'**
  String get accountDeletionBySupport;

  /// No description provided for @photoUploadFailed.
  ///
  /// In en, this message translates to:
  /// **'That photo could not be uploaded.'**
  String get photoUploadFailed;

  /// No description provided for @photoUploadFailedRetry.
  ///
  /// In en, this message translates to:
  /// **'That photo could not be uploaded. Try again.'**
  String get photoUploadFailedRetry;

  /// No description provided for @locationInvalid.
  ///
  /// In en, this message translates to:
  /// **'That location does not look right.'**
  String get locationInvalid;

  /// No description provided for @travelDistanceRange.
  ///
  /// In en, this message translates to:
  /// **'Choose a travel distance between 1 and 100 km.'**
  String get travelDistanceRange;

  /// No description provided for @profileLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Your profile could not be loaded.'**
  String get profileLoadFailed;

  /// No description provided for @uploadIncomplete.
  ///
  /// In en, this message translates to:
  /// **'The upload did not complete. Try again.'**
  String get uploadIncomplete;

  /// No description provided for @uploadTooLarge.
  ///
  /// In en, this message translates to:
  /// **'That file is too large.'**
  String get uploadTooLarge;

  /// No description provided for @uploadTypeNotAccepted.
  ///
  /// In en, this message translates to:
  /// **'That file type is not accepted.'**
  String get uploadTypeNotAccepted;

  /// No description provided for @uploadRefused.
  ///
  /// In en, this message translates to:
  /// **'That file was refused.'**
  String get uploadRefused;

  /// No description provided for @uploadTooMany.
  ///
  /// In en, this message translates to:
  /// **'Too many uploads at once. Wait a moment and try again.'**
  String get uploadTooMany;

  /// No description provided for @uploadGone.
  ///
  /// In en, this message translates to:
  /// **'That upload is no longer available. Choose the file again.'**
  String get uploadGone;

  /// No description provided for @uploadDidNotStart.
  ///
  /// In en, this message translates to:
  /// **'The upload did not start.'**
  String get uploadDidNotStart;

  /// No description provided for @uploadDidNotFinish.
  ///
  /// In en, this message translates to:
  /// **'That upload did not finish.'**
  String get uploadDidNotFinish;

  /// No description provided for @claimResponseTooShort.
  ///
  /// In en, this message translates to:
  /// **'Please explain what happened in a little more detail.'**
  String get claimResponseTooShort;

  /// No description provided for @walletLoadFailedRetry.
  ///
  /// In en, this message translates to:
  /// **'Your wallet could not be loaded. Please try again.'**
  String get walletLoadFailedRetry;

  /// No description provided for @walletLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Your wallet could not be loaded.'**
  String get walletLoadFailed;

  /// No description provided for @onboardingStepDetails.
  ///
  /// In en, this message translates to:
  /// **'Your details'**
  String get onboardingStepDetails;

  /// No description provided for @onboardingStepTrade.
  ///
  /// In en, this message translates to:
  /// **'Your main trade'**
  String get onboardingStepTrade;

  /// No description provided for @onboardingStepSkills.
  ///
  /// In en, this message translates to:
  /// **'What you can do'**
  String get onboardingStepSkills;

  /// No description provided for @onboardingStepArea.
  ///
  /// In en, this message translates to:
  /// **'Where you work'**
  String get onboardingStepArea;

  /// No description provided for @onboardingStepKyc.
  ///
  /// In en, this message translates to:
  /// **'Identity check'**
  String get onboardingStepKyc;

  /// No description provided for @onboardingStepReady.
  ///
  /// In en, this message translates to:
  /// **'Ready to work'**
  String get onboardingStepReady;

  /// No description provided for @routerScreenNotFound.
  ///
  /// In en, this message translates to:
  /// **'That screen could not be opened.\n{location}'**
  String routerScreenNotFound(Object location);

  /// No description provided for @cameraOpenFailed.
  ///
  /// In en, this message translates to:
  /// **'The camera could not be opened. Check app permissions.'**
  String get cameraOpenFailed;

  /// No description provided for @commonTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get commonTryAgain;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get commonConfirm;

  /// No description provided for @offlineBanner.
  ///
  /// In en, this message translates to:
  /// **'You are offline. Job actions will work again once you reconnect.'**
  String get offlineBanner;

  /// No description provided for @badgeNew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get badgeNew;

  /// No description provided for @badgeAccepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get badgeAccepted;

  /// No description provided for @badgeConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get badgeConfirmed;

  /// No description provided for @badgeOnTheWay.
  ///
  /// In en, this message translates to:
  /// **'On the way'**
  String get badgeOnTheWay;

  /// No description provided for @badgeArrived.
  ///
  /// In en, this message translates to:
  /// **'Arrived'**
  String get badgeArrived;

  /// No description provided for @badgeWorking.
  ///
  /// In en, this message translates to:
  /// **'Working'**
  String get badgeWorking;

  /// No description provided for @badgeAwaitingCustomer.
  ///
  /// In en, this message translates to:
  /// **'Awaiting customer'**
  String get badgeAwaitingCustomer;

  /// No description provided for @badgeDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get badgeDone;

  /// No description provided for @badgePaymentDue.
  ///
  /// In en, this message translates to:
  /// **'Payment due'**
  String get badgePaymentDue;

  /// No description provided for @badgePaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get badgePaid;

  /// No description provided for @badgeClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get badgeClosed;

  /// No description provided for @badgeCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get badgeCancelled;

  /// No description provided for @badgeDisputed.
  ///
  /// In en, this message translates to:
  /// **'Disputed'**
  String get badgeDisputed;

  /// No description provided for @badgeExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get badgeExpired;

  /// No description provided for @badgeDraft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get badgeDraft;

  /// No description provided for @badgeInReview.
  ///
  /// In en, this message translates to:
  /// **'In review'**
  String get badgeInReview;

  /// No description provided for @badgeLive.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get badgeLive;

  /// No description provided for @badgePaused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get badgePaused;

  /// No description provided for @badgeNotApproved.
  ///
  /// In en, this message translates to:
  /// **'Not approved'**
  String get badgeNotApproved;

  /// No description provided for @badgeRemoved.
  ///
  /// In en, this message translates to:
  /// **'Removed'**
  String get badgeRemoved;

  /// No description provided for @badgeNotStarted.
  ///
  /// In en, this message translates to:
  /// **'Not started'**
  String get badgeNotStarted;

  /// No description provided for @badgeSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Submitted'**
  String get badgeSubmitted;

  /// No description provided for @badgeActionNeeded.
  ///
  /// In en, this message translates to:
  /// **'Action needed'**
  String get badgeActionNeeded;

  /// No description provided for @badgeVerified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get badgeVerified;

  /// No description provided for @badgeNotRequired.
  ///
  /// In en, this message translates to:
  /// **'Not required'**
  String get badgeNotRequired;

  /// No description provided for @commonContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get commonContinue;

  /// No description provided for @commonSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving…'**
  String get commonSaving;

  /// No description provided for @welcomePromiseWorkTitle.
  ///
  /// In en, this message translates to:
  /// **'Get suitable work'**
  String get welcomePromiseWorkTitle;

  /// No description provided for @welcomePromiseWorkBody.
  ///
  /// In en, this message translates to:
  /// **'Jobs near you, matched to the trades you actually offer.'**
  String get welcomePromiseWorkBody;

  /// No description provided for @welcomePromiseSkillsTitle.
  ///
  /// In en, this message translates to:
  /// **'Prove your skills'**
  String get welcomePromiseSkillsTitle;

  /// No description provided for @welcomePromiseSkillsBody.
  ///
  /// In en, this message translates to:
  /// **'Your ITI and diploma certificates, verified once and shown to every customer.'**
  String get welcomePromiseSkillsBody;

  /// No description provided for @welcomePromiseTrackTitle.
  ///
  /// In en, this message translates to:
  /// **'Track every job'**
  String get welcomePromiseTrackTitle;

  /// No description provided for @welcomePromiseTrackBody.
  ///
  /// In en, this message translates to:
  /// **'From accepting a job to finishing it, with photo records at each step.'**
  String get welcomePromiseTrackBody;

  /// No description provided for @welcomePromisePaidTitle.
  ///
  /// In en, this message translates to:
  /// **'Get paid securely'**
  String get welcomePromisePaidTitle;

  /// No description provided for @welcomePromisePaidBody.
  ///
  /// In en, this message translates to:
  /// **'Every rupee recorded, with a clear statement and withdrawals on your terms.'**
  String get welcomePromisePaidBody;

  /// No description provided for @welcomeHeadline.
  ///
  /// In en, this message translates to:
  /// **'Work that finds you'**
  String get welcomeHeadline;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Wervexa connects skilled professionals with customers who need them.'**
  String get welcomeSubtitle;

  /// No description provided for @welcomeGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get welcomeGetStarted;

  /// No description provided for @welcomeCodeNotice.
  ///
  /// In en, this message translates to:
  /// **'We will send a one-time code to your mobile number.'**
  String get welcomeCodeNotice;

  /// No description provided for @phoneTitle.
  ///
  /// In en, this message translates to:
  /// **'What is your mobile number?'**
  String get phoneTitle;

  /// No description provided for @phoneSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We will send you a one-time code to confirm it is you.'**
  String get phoneSubtitle;

  /// No description provided for @phoneSendCode.
  ///
  /// In en, this message translates to:
  /// **'Send code'**
  String get phoneSendCode;

  /// No description provided for @phoneSending.
  ///
  /// In en, this message translates to:
  /// **'Sending…'**
  String get phoneSending;

  /// No description provided for @authNewCodeSent.
  ///
  /// In en, this message translates to:
  /// **'We sent a new code.'**
  String get authNewCodeSent;

  /// No description provided for @otpTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the code'**
  String get otpTitle;

  /// No description provided for @otpSentTo.
  ///
  /// In en, this message translates to:
  /// **'We sent a 6-digit code to {phone}.'**
  String otpSentTo(Object phone);

  /// No description provided for @otpResendIn.
  ///
  /// In en, this message translates to:
  /// **'{seconds, plural, =1{You can ask for a new code in 1 second} other{You can ask for a new code in {seconds} seconds}}'**
  String otpResendIn(int seconds);

  /// No description provided for @otpSendNew.
  ///
  /// In en, this message translates to:
  /// **'Send a new code'**
  String get otpSendNew;

  /// No description provided for @otpVerify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get otpVerify;

  /// No description provided for @otpVerifying.
  ///
  /// In en, this message translates to:
  /// **'Verifying…'**
  String get otpVerifying;

  /// No description provided for @registerNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your full name'**
  String get registerNameRequired;

  /// No description provided for @registerEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get registerEmailInvalid;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'What should we call you?'**
  String get registerTitle;

  /// No description provided for @registerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This is the name customers will see.'**
  String get registerSubtitle;

  /// No description provided for @registerNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get registerNameLabel;

  /// No description provided for @registerNameHint.
  ///
  /// In en, this message translates to:
  /// **'Arun Kumar'**
  String get registerNameHint;

  /// No description provided for @registerEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email (optional)'**
  String get registerEmailLabel;

  /// No description provided for @registerEmailHelper.
  ///
  /// In en, this message translates to:
  /// **'For receipts and statements.'**
  String get registerEmailHelper;

  /// No description provided for @registerVerifiedPhone.
  ///
  /// In en, this message translates to:
  /// **'Verified: {phone}'**
  String registerVerifiedPhone(Object phone);

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navJobs.
  ///
  /// In en, this message translates to:
  /// **'Jobs'**
  String get navJobs;

  /// No description provided for @navWallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get navWallet;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @sessionProfileLoadFailedRetry.
  ///
  /// In en, this message translates to:
  /// **'We could not load your profile. Please try again.'**
  String get sessionProfileLoadFailedRetry;

  /// No description provided for @commonSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get commonSignOut;

  /// No description provided for @serviceElectrical.
  ///
  /// In en, this message translates to:
  /// **'Electrical'**
  String get serviceElectrical;

  /// No description provided for @servicePlumbing.
  ///
  /// In en, this message translates to:
  /// **'Plumbing'**
  String get servicePlumbing;

  /// No description provided for @serviceAcService.
  ///
  /// In en, this message translates to:
  /// **'AC Service'**
  String get serviceAcService;

  /// No description provided for @serviceApplianceRepair.
  ///
  /// In en, this message translates to:
  /// **'Appliance Repair'**
  String get serviceApplianceRepair;

  /// No description provided for @serviceCarpentry.
  ///
  /// In en, this message translates to:
  /// **'Carpentry'**
  String get serviceCarpentry;

  /// No description provided for @servicePainting.
  ///
  /// In en, this message translates to:
  /// **'Painting'**
  String get servicePainting;

  /// No description provided for @serviceCleaning.
  ///
  /// In en, this message translates to:
  /// **'Cleaning'**
  String get serviceCleaning;

  /// No description provided for @servicePestControl.
  ///
  /// In en, this message translates to:
  /// **'Pest Control'**
  String get servicePestControl;

  /// No description provided for @serviceOtherHome.
  ///
  /// In en, this message translates to:
  /// **'Other Home Services'**
  String get serviceOtherHome;

  /// No description provided for @commonSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get commonSeeAll;

  /// No description provided for @distanceKm.
  ///
  /// In en, this message translates to:
  /// **'{km} km'**
  String distanceKm(Object km);

  /// No description provided for @homeRightNow.
  ///
  /// In en, this message translates to:
  /// **'Right now'**
  String get homeRightNow;

  /// No description provided for @homeNewWork.
  ///
  /// In en, this message translates to:
  /// **'New work'**
  String get homeNewWork;

  /// No description provided for @homeJobsWaiting.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 job waiting for your answer} other{{count} jobs waiting for your answer}}'**
  String homeJobsWaiting(int count);

  /// No description provided for @homeComingUp.
  ///
  /// In en, this message translates to:
  /// **'Coming up'**
  String get homeComingUp;

  /// No description provided for @homeEarnings.
  ///
  /// In en, this message translates to:
  /// **'Earnings'**
  String get homeEarnings;

  /// No description provided for @homeMyServices.
  ///
  /// In en, this message translates to:
  /// **'My services'**
  String get homeMyServices;

  /// No description provided for @homeVerification.
  ///
  /// In en, this message translates to:
  /// **'Verification'**
  String get homeVerification;

  /// No description provided for @homeSupport.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get homeSupport;

  /// No description provided for @homeRequests.
  ///
  /// In en, this message translates to:
  /// **'Requests'**
  String get homeRequests;

  /// No description provided for @homeMyOffers.
  ///
  /// In en, this message translates to:
  /// **'My offers'**
  String get homeMyOffers;

  /// No description provided for @homeAddService.
  ///
  /// In en, this message translates to:
  /// **'Add a service'**
  String get homeAddService;

  /// No description provided for @homeAddServiceBody.
  ///
  /// In en, this message translates to:
  /// **'Customers can only book you for services you have published.'**
  String get homeAddServiceBody;

  /// No description provided for @homeNotReady.
  ///
  /// In en, this message translates to:
  /// **'Not quite ready'**
  String get homeNotReady;

  /// No description provided for @homeNotReadyBody.
  ///
  /// In en, this message translates to:
  /// **'Finish these steps and you can start receiving jobs.'**
  String get homeNotReadyBody;

  /// No description provided for @homeGoodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get homeGoodMorning;

  /// No description provided for @homeGoodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get homeGoodAfternoon;

  /// No description provided for @homeGoodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get homeGoodEvening;

  /// No description provided for @homeNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get homeNotifications;

  /// No description provided for @availabilityAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get availabilityAvailable;

  /// No description provided for @availabilityAvailableBody.
  ///
  /// In en, this message translates to:
  /// **'You can receive new jobs.'**
  String get availabilityAvailableBody;

  /// No description provided for @availabilityOnJob.
  ///
  /// In en, this message translates to:
  /// **'On a job'**
  String get availabilityOnJob;

  /// No description provided for @availabilityOnJobBody.
  ///
  /// In en, this message translates to:
  /// **'You will not be offered new work until this job is done.'**
  String get availabilityOnJobBody;

  /// No description provided for @availabilityOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get availabilityOff;

  /// No description provided for @availabilityOffBody.
  ///
  /// In en, this message translates to:
  /// **'You will not receive new jobs.'**
  String get availabilityOffBody;

  /// No description provided for @availabilityFinishJob.
  ///
  /// In en, this message translates to:
  /// **'Finish your current job to become available again.'**
  String get availabilityFinishJob;

  /// No description provided for @availabilityGoOff.
  ///
  /// In en, this message translates to:
  /// **'Go off duty'**
  String get availabilityGoOff;

  /// No description provided for @availabilityGoOn.
  ///
  /// In en, this message translates to:
  /// **'Go available'**
  String get availabilityGoOn;

  /// No description provided for @availabilityBeforeJobs.
  ///
  /// In en, this message translates to:
  /// **'Before you can receive jobs'**
  String get availabilityBeforeJobs;

  /// No description provided for @availabilityNowOn.
  ///
  /// In en, this message translates to:
  /// **'You are available for work.'**
  String get availabilityNowOn;

  /// No description provided for @availabilityNowOff.
  ///
  /// In en, this message translates to:
  /// **'You are off duty.'**
  String get availabilityNowOff;

  /// No description provided for @workerStatusSetupIncomplete.
  ///
  /// In en, this message translates to:
  /// **'Setup incomplete'**
  String get workerStatusSetupIncomplete;

  /// No description provided for @workerStatusUnderReview.
  ///
  /// In en, this message translates to:
  /// **'Under review'**
  String get workerStatusUnderReview;

  /// No description provided for @workerStatusInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get workerStatusInactive;

  /// No description provided for @workerStatusRestricted.
  ///
  /// In en, this message translates to:
  /// **'Restricted'**
  String get workerStatusRestricted;

  /// No description provided for @workerStatusSuspended.
  ///
  /// In en, this message translates to:
  /// **'Suspended'**
  String get workerStatusSuspended;

  /// No description provided for @homeAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get homeAccount;

  /// No description provided for @homeWorkStatus.
  ///
  /// In en, this message translates to:
  /// **'Work status'**
  String get homeWorkStatus;

  /// No description provided for @availabilityOffDuty.
  ///
  /// In en, this message translates to:
  /// **'Off duty'**
  String get availabilityOffDuty;

  /// No description provided for @earningsThisWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get earningsThisWeek;

  /// No description provided for @earningsThisMonth.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get earningsThisMonth;

  /// No description provided for @jobNextWaitConfirm.
  ///
  /// In en, this message translates to:
  /// **'Waiting for the customer to confirm'**
  String get jobNextWaitConfirm;

  /// No description provided for @jobNextStartTravel.
  ///
  /// In en, this message translates to:
  /// **'Start travelling'**
  String get jobNextStartTravel;

  /// No description provided for @jobNextMarkArrived.
  ///
  /// In en, this message translates to:
  /// **'Mark yourself as arrived'**
  String get jobNextMarkArrived;

  /// No description provided for @jobNextStartWork.
  ///
  /// In en, this message translates to:
  /// **'Start the work'**
  String get jobNextStartWork;

  /// No description provided for @jobNextAskCode.
  ///
  /// In en, this message translates to:
  /// **'Ask the customer for the arrival code'**
  String get jobNextAskCode;

  /// No description provided for @jobNextFinish.
  ///
  /// In en, this message translates to:
  /// **'Finish and add photos'**
  String get jobNextFinish;

  /// No description provided for @jobNextWaitApprove.
  ///
  /// In en, this message translates to:
  /// **'Waiting for the customer to approve'**
  String get jobNextWaitApprove;

  /// No description provided for @jobNextOpen.
  ///
  /// In en, this message translates to:
  /// **'Open job'**
  String get jobNextOpen;

  /// No description provided for @jobTimeTbc.
  ///
  /// In en, this message translates to:
  /// **'Time to be confirmed'**
  String get jobTimeTbc;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @settingsTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms of service'**
  String get settingsTerms;

  /// No description provided for @settingsPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get settingsPrivacy;

  /// No description provided for @settingsHelp.
  ///
  /// In en, this message translates to:
  /// **'Help and support'**
  String get settingsHelp;

  /// No description provided for @settingsDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete my account'**
  String get settingsDeleteAccount;

  /// No description provided for @settingsSignOutTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign out?'**
  String get settingsSignOutTitle;

  /// No description provided for @settingsSignOutBody.
  ///
  /// In en, this message translates to:
  /// **'You will need your phone number and a code to sign back in.'**
  String get settingsSignOutBody;

  /// No description provided for @settingsDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete your account'**
  String get settingsDeleteTitle;

  /// No description provided for @settingsDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'Deleting an account affects your job history, your earnings records and any open payments, so it is handled by our support team rather than automatically.\n\nRaise a support request and we will confirm once it is done.'**
  String get settingsDeleteBody;

  /// No description provided for @settingsContactSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact support'**
  String get settingsContactSupport;

  /// No description provided for @notificationsMarkAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all read'**
  String get notificationsMarkAllRead;

  /// No description provided for @notificationsEmpty.
  ///
  /// In en, this message translates to:
  /// **'You are all caught up'**
  String get notificationsEmpty;

  /// No description provided for @notificationsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Job offers, payment updates and verification results will appear here.'**
  String get notificationsEmptyBody;

  /// No description provided for @jobsTabUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get jobsTabUpcoming;

  /// No description provided for @jobsTabActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get jobsTabActive;

  /// No description provided for @jobsNoOffers.
  ///
  /// In en, this message translates to:
  /// **'No new jobs right now'**
  String get jobsNoOffers;

  /// No description provided for @jobsNoOffersBody.
  ///
  /// In en, this message translates to:
  /// **'When you are available, we will let you know as soon as a suitable job comes in.'**
  String get jobsNoOffersBody;

  /// No description provided for @jobsAccepted.
  ///
  /// In en, this message translates to:
  /// **'Job accepted.'**
  String get jobsAccepted;

  /// No description provided for @jobsDeclineTitle.
  ///
  /// In en, this message translates to:
  /// **'Decline this job?'**
  String get jobsDeclineTitle;

  /// No description provided for @jobsDeclineBody.
  ///
  /// In en, this message translates to:
  /// **'It will be offered to another worker. Declining often may affect how many jobs you are shown.'**
  String get jobsDeclineBody;

  /// No description provided for @jobsDecline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get jobsDecline;

  /// No description provided for @jobsDeclined.
  ///
  /// In en, this message translates to:
  /// **'Job declined.'**
  String get jobsDeclined;

  /// No description provided for @jobsEmptyUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Nothing scheduled'**
  String get jobsEmptyUpcoming;

  /// No description provided for @jobsEmptyUpcomingBody.
  ///
  /// In en, this message translates to:
  /// **'Jobs you have accepted will appear here.'**
  String get jobsEmptyUpcomingBody;

  /// No description provided for @jobsEmptyActive.
  ///
  /// In en, this message translates to:
  /// **'No job in progress'**
  String get jobsEmptyActive;

  /// No description provided for @jobsEmptyActiveBody.
  ///
  /// In en, this message translates to:
  /// **'When you start a job it will show up here.'**
  String get jobsEmptyActiveBody;

  /// No description provided for @jobsEmptyCompleted.
  ///
  /// In en, this message translates to:
  /// **'No completed jobs yet'**
  String get jobsEmptyCompleted;

  /// No description provided for @jobsEmptyCompletedBody.
  ///
  /// In en, this message translates to:
  /// **'Finished jobs and what you earned from them will be listed here.'**
  String get jobsEmptyCompletedBody;

  /// No description provided for @jobsEmptyCancelled.
  ///
  /// In en, this message translates to:
  /// **'Nothing cancelled'**
  String get jobsEmptyCancelled;

  /// No description provided for @jobsEmptyCancelledBody.
  ///
  /// In en, this message translates to:
  /// **'Cancelled jobs will be listed here.'**
  String get jobsEmptyCancelledBody;

  /// No description provided for @jobsEmptyOffers.
  ///
  /// In en, this message translates to:
  /// **'No offers'**
  String get jobsEmptyOffers;

  /// No description provided for @jobsEmptyOffersBody.
  ///
  /// In en, this message translates to:
  /// **'New jobs will appear here.'**
  String get jobsEmptyOffersBody;

  /// No description provided for @jobTitleFallback.
  ///
  /// In en, this message translates to:
  /// **'Job'**
  String get jobTitleFallback;

  /// No description provided for @jobCancelledReason.
  ///
  /// In en, this message translates to:
  /// **'Cancelled: {reason}'**
  String jobCancelledReason(Object reason);

  /// No description provided for @jobAmount.
  ///
  /// In en, this message translates to:
  /// **'Job amount'**
  String get jobAmount;

  /// No description provided for @jobMaterials.
  ///
  /// In en, this message translates to:
  /// **'Materials'**
  String get jobMaterials;

  /// No description provided for @jobYouEarned.
  ///
  /// In en, this message translates to:
  /// **'You earned'**
  String get jobYouEarned;

  /// No description provided for @jobRateCustomer.
  ///
  /// In en, this message translates to:
  /// **'Rate the customer'**
  String get jobRateCustomer;

  /// No description provided for @jobRateQuestion.
  ///
  /// In en, this message translates to:
  /// **'How was this job for you?'**
  String get jobRateQuestion;

  /// No description provided for @jobRate.
  ///
  /// In en, this message translates to:
  /// **'Rate'**
  String get jobRate;

  /// No description provided for @jobHistory.
  ///
  /// In en, this message translates to:
  /// **'What happened'**
  String get jobHistory;

  /// No description provided for @jobHistoryLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'The job history could not be loaded.'**
  String get jobHistoryLoadFailed;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
