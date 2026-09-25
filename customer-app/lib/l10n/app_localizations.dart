import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

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
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi')
  ];

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// No description provided for @commonTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get commonTryAgain;

  /// No description provided for @commonSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get commonSignOut;

  /// No description provided for @assistantFabLabel.
  ///
  /// In en, this message translates to:
  /// **'Ask AI'**
  String get assistantFabLabel;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navExplore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get navExplore;

  /// No description provided for @navBookings.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get navBookings;

  /// No description provided for @navAlerts.
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get navAlerts;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @configErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'App not configured'**
  String get configErrorTitle;

  /// No description provided for @configErrorBody.
  ///
  /// In en, this message translates to:
  /// **'This build is missing {keys}. Run with:\n\n{command}\n\nso the app can reach the real backend.'**
  String configErrorBody(String keys, String command);

  /// No description provided for @sessionProfileLoadFailedRetry.
  ///
  /// In en, this message translates to:
  /// **'We could not load your profile. Please try again.'**
  String get sessionProfileLoadFailedRetry;

  /// No description provided for @sessionProfileLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'We could not load your profile'**
  String get sessionProfileLoadFailed;

  /// No description provided for @sessionCheckClock.
  ///
  /// In en, this message translates to:
  /// **'Check your phone\'s clock'**
  String get sessionCheckClock;

  /// No description provided for @splashTagline.
  ///
  /// In en, this message translates to:
  /// **'Home services, done right.'**
  String get splashTagline;

  /// No description provided for @timelineBookingConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Booking Confirmed'**
  String get timelineBookingConfirmed;

  /// No description provided for @timelineProviderOnTheWay.
  ///
  /// In en, this message translates to:
  /// **'Provider on the way'**
  String get timelineProviderOnTheWay;

  /// No description provided for @timelineServiceInProgress.
  ///
  /// In en, this message translates to:
  /// **'Service in Progress'**
  String get timelineServiceInProgress;

  /// No description provided for @timelineCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get timelineCompleted;

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

  /// No description provided for @authErrorPhoneNotEnabled.
  ///
  /// In en, this message translates to:
  /// **'Phone sign-in is not enabled. Contact support.'**
  String get authErrorPhoneNotEnabled;

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

  /// No description provided for @languagePickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your language'**
  String get languagePickerTitle;

  /// No description provided for @authCouldNotStartVerification.
  ///
  /// In en, this message translates to:
  /// **'Could not start verification. Please try again.'**
  String get authCouldNotStartVerification;

  /// No description provided for @authWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Wervexa'**
  String get authWelcomeTitle;

  /// No description provided for @authWelcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Find top-rated local professionals for home repairs, plumbing, electrical, cleaning & more.'**
  String get authWelcomeSubtitle;

  /// No description provided for @authEnterPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get authEnterPhone;

  /// No description provided for @authInvalidMobile.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid 10-digit mobile number'**
  String get authInvalidMobile;

  /// No description provided for @authGetOtp.
  ///
  /// In en, this message translates to:
  /// **'Get OTP Verification'**
  String get authGetOtp;

  /// No description provided for @authTermsNotice.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to our Terms of Service & Privacy Policy'**
  String get authTermsNotice;

  /// No description provided for @authNewCodeSent.
  ///
  /// In en, this message translates to:
  /// **'We sent a new code.'**
  String get authNewCodeSent;

  /// No description provided for @authVerifyPhoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify phone'**
  String get authVerifyPhoneTitle;

  /// No description provided for @authChangeNumber.
  ///
  /// In en, this message translates to:
  /// **'Change number'**
  String get authChangeNumber;

  /// No description provided for @authEnterCodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter 6-digit code'**
  String get authEnterCodeTitle;

  /// No description provided for @authCodeSentTo.
  ///
  /// In en, this message translates to:
  /// **'We sent an SMS verification code to {phone}'**
  String authCodeSentTo(Object phone);

  /// No description provided for @authWrongNumber.
  ///
  /// In en, this message translates to:
  /// **'Wrong number? Change it'**
  String get authWrongNumber;

  /// No description provided for @authEnterSixDigits.
  ///
  /// In en, this message translates to:
  /// **'Please enter 6 digits'**
  String get authEnterSixDigits;

  /// No description provided for @authResendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get authResendCode;

  /// No description provided for @authResendCodeIn.
  ///
  /// In en, this message translates to:
  /// **'Resend code in {seconds}s'**
  String authResendCodeIn(Object seconds);

  /// No description provided for @authVerifyAndContinue.
  ///
  /// In en, this message translates to:
  /// **'Verify & Continue'**
  String get authVerifyAndContinue;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Complete Profile'**
  String get registerTitle;

  /// No description provided for @registerHeading.
  ///
  /// In en, this message translates to:
  /// **'Tell us your name'**
  String get registerHeading;

  /// No description provided for @registerNameVisibility.
  ///
  /// In en, this message translates to:
  /// **'Your name will be visible to service workers when you make a booking request.'**
  String get registerNameVisibility;

  /// No description provided for @registerFullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full Name *'**
  String get registerFullNameLabel;

  /// No description provided for @registerFullNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Rahul Sharma'**
  String get registerFullNameHint;

  /// No description provided for @registerFullNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your full name'**
  String get registerFullNameRequired;

  /// No description provided for @registerEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email Address (Optional)'**
  String get registerEmailLabel;

  /// No description provided for @registerEmailHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. rahul@example.com'**
  String get registerEmailHint;

  /// No description provided for @registerSubmit.
  ///
  /// In en, this message translates to:
  /// **'Save & Get Started'**
  String get registerSubmit;

  /// No description provided for @bookingStatusRequested.
  ///
  /// In en, this message translates to:
  /// **'Finding a professional…'**
  String get bookingStatusRequested;

  /// No description provided for @bookingStatusAccepted.
  ///
  /// In en, this message translates to:
  /// **'Professional found'**
  String get bookingStatusAccepted;

  /// No description provided for @bookingStatusConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get bookingStatusConfirmed;

  /// No description provided for @bookingStatusTraveling.
  ///
  /// In en, this message translates to:
  /// **'On the way'**
  String get bookingStatusTraveling;

  /// No description provided for @bookingStatusArrived.
  ///
  /// In en, this message translates to:
  /// **'Arrived — enter your code'**
  String get bookingStatusArrived;

  /// No description provided for @bookingStatusInProgress.
  ///
  /// In en, this message translates to:
  /// **'Work in progress'**
  String get bookingStatusInProgress;

  /// No description provided for @bookingStatusAwaitingApproval.
  ///
  /// In en, this message translates to:
  /// **'Work done — approve to proceed'**
  String get bookingStatusAwaitingApproval;

  /// No description provided for @bookingStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get bookingStatusCompleted;

  /// No description provided for @bookingStatusPaymentPending.
  ///
  /// In en, this message translates to:
  /// **'Payment pending'**
  String get bookingStatusPaymentPending;

  /// No description provided for @bookingStatusPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get bookingStatusPaid;

  /// No description provided for @bookingStatusClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get bookingStatusClosed;

  /// No description provided for @bookingStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get bookingStatusCancelled;

  /// No description provided for @bookingStatusDisputed.
  ///
  /// In en, this message translates to:
  /// **'Disputed'**
  String get bookingStatusDisputed;

  /// No description provided for @bookingStatusExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired — no one was available'**
  String get bookingStatusExpired;

  /// No description provided for @pricingPerJob.
  ///
  /// In en, this message translates to:
  /// **'per job'**
  String get pricingPerJob;

  /// No description provided for @pricingPerHour.
  ///
  /// In en, this message translates to:
  /// **'per hour'**
  String get pricingPerHour;

  /// No description provided for @pricingPerDay.
  ///
  /// In en, this message translates to:
  /// **'per day'**
  String get pricingPerDay;

  /// No description provided for @pricingPerUnit.
  ///
  /// In en, this message translates to:
  /// **'per unit'**
  String get pricingPerUnit;

  /// No description provided for @pricingPerSqft.
  ///
  /// In en, this message translates to:
  /// **'per sq ft'**
  String get pricingPerSqft;

  /// No description provided for @supportCategoryBooking.
  ///
  /// In en, this message translates to:
  /// **'Booking issue'**
  String get supportCategoryBooking;

  /// No description provided for @supportCategoryPayment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get supportCategoryPayment;

  /// No description provided for @supportCategoryPayout.
  ///
  /// In en, this message translates to:
  /// **'Payout'**
  String get supportCategoryPayout;

  /// No description provided for @supportCategoryVerification.
  ///
  /// In en, this message translates to:
  /// **'Verification'**
  String get supportCategoryVerification;

  /// No description provided for @supportCategoryAccount.
  ///
  /// In en, this message translates to:
  /// **'My account'**
  String get supportCategoryAccount;

  /// No description provided for @supportCategorySafety.
  ///
  /// In en, this message translates to:
  /// **'Safety concern'**
  String get supportCategorySafety;

  /// No description provided for @supportCategoryClaim.
  ///
  /// In en, this message translates to:
  /// **'Insurance claim'**
  String get supportCategoryClaim;

  /// No description provided for @supportCategoryAppIssue.
  ///
  /// In en, this message translates to:
  /// **'App problem'**
  String get supportCategoryAppIssue;

  /// No description provided for @supportCategoryOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get supportCategoryOther;

  /// No description provided for @requestStatusDraft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get requestStatusDraft;

  /// No description provided for @requestStatusOpen.
  ///
  /// In en, this message translates to:
  /// **'Open — waiting for offers'**
  String get requestStatusOpen;

  /// No description provided for @requestStatusReceivingOffers.
  ///
  /// In en, this message translates to:
  /// **'Receiving offers'**
  String get requestStatusReceivingOffers;

  /// No description provided for @requestStatusWorkerSelected.
  ///
  /// In en, this message translates to:
  /// **'Professional selected'**
  String get requestStatusWorkerSelected;

  /// No description provided for @requestStatusBooked.
  ///
  /// In en, this message translates to:
  /// **'Booked'**
  String get requestStatusBooked;

  /// No description provided for @requestStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get requestStatusCancelled;

  /// No description provided for @requestStatusExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get requestStatusExpired;

  /// No description provided for @requestStatusClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get requestStatusClosed;

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
  /// **'On a specific date'**
  String get scheduleSpecificDate;

  /// No description provided for @scheduleScheduled.
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get scheduleScheduled;

  /// No description provided for @offerStatusSubmitted.
  ///
  /// In en, this message translates to:
  /// **'New offer'**
  String get offerStatusSubmitted;

  /// No description provided for @offerStatusViewed.
  ///
  /// In en, this message translates to:
  /// **'Viewed'**
  String get offerStatusViewed;

  /// No description provided for @offerStatusShortlisted.
  ///
  /// In en, this message translates to:
  /// **'Shortlisted'**
  String get offerStatusShortlisted;

  /// No description provided for @offerStatusAccepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get offerStatusAccepted;

  /// No description provided for @offerStatusRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get offerStatusRejected;

  /// No description provided for @offerStatusWithdrawn.
  ///
  /// In en, this message translates to:
  /// **'Withdrawn by worker'**
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

  /// No description provided for @gigRatingNew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get gigRatingNew;

  /// No description provided for @distanceMetres.
  ///
  /// In en, this message translates to:
  /// **'{metres} m'**
  String distanceMetres(Object metres);

  /// No description provided for @distanceKm.
  ///
  /// In en, this message translates to:
  /// **'{km} km'**
  String distanceKm(Object km);

  /// No description provided for @durationMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String durationMinutes(Object minutes);

  /// No description provided for @durationHours.
  ///
  /// In en, this message translates to:
  /// **'{hours} hr'**
  String durationHours(Object hours);

  /// No description provided for @durationHoursMinutes.
  ///
  /// In en, this message translates to:
  /// **'{hours} hr {minutes} min'**
  String durationHoursMinutes(int hours, int minutes);

  /// No description provided for @offerWorkerFallbackName.
  ///
  /// In en, this message translates to:
  /// **'Professional'**
  String get offerWorkerFallbackName;

  /// No description provided for @budgetFlexible.
  ///
  /// In en, this message translates to:
  /// **'Flexible budget'**
  String get budgetFlexible;

  /// No description provided for @budgetFixed.
  ///
  /// In en, this message translates to:
  /// **'Fixed budget'**
  String get budgetFixed;

  /// No description provided for @offerCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No offers yet} =1{1 offer} other{{count} offers}}'**
  String offerCount(int count);

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

  /// No description provided for @paymentsNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'Payments are not configured for this build yet.'**
  String get paymentsNotConfigured;

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

  /// No description provided for @addressLabelHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get addressLabelHome;

  /// No description provided for @addressLabelWork.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get addressLabelWork;

  /// No description provided for @addressLabelOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get addressLabelOther;

  /// No description provided for @commonSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get commonSeeAll;

  /// No description provided for @commonViewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get commonViewAll;

  /// No description provided for @commonCheckBackLater.
  ///
  /// In en, this message translates to:
  /// **'Please check back later.'**
  String get commonCheckBackLater;

  /// No description provided for @commonUseCurrentLocation.
  ///
  /// In en, this message translates to:
  /// **'Use current location'**
  String get commonUseCurrentLocation;

  /// No description provided for @commonChooseOnMap.
  ///
  /// In en, this message translates to:
  /// **'Choose on map'**
  String get commonChooseOnMap;

  /// No description provided for @homeGreetingNamed.
  ///
  /// In en, this message translates to:
  /// **'Hello, {name} 👋'**
  String homeGreetingNamed(Object name);

  /// No description provided for @homeGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hello 👋'**
  String get homeGreeting;

  /// No description provided for @homeWhatService.
  ///
  /// In en, this message translates to:
  /// **'What service do you need today?'**
  String get homeWhatService;

  /// No description provided for @homeSetLocation.
  ///
  /// In en, this message translates to:
  /// **'Set your location'**
  String get homeSetLocation;

  /// No description provided for @homeWorkFinishedApprove.
  ///
  /// In en, this message translates to:
  /// **'Work finished — tap to approve'**
  String get homeWorkFinishedApprove;

  /// No description provided for @homeCategories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get homeCategories;

  /// No description provided for @homeCategoriesLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load categories: {error}'**
  String homeCategoriesLoadFailed(Object error);

  /// No description provided for @homeFindWorker.
  ///
  /// In en, this message translates to:
  /// **'Find a Worker'**
  String get homeFindWorker;

  /// No description provided for @homeFindWorkerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Browse nearby gigs'**
  String get homeFindWorkerSubtitle;

  /// No description provided for @homePostRequest.
  ///
  /// In en, this message translates to:
  /// **'Post a Request'**
  String get homePostRequest;

  /// No description provided for @homePostRequestSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Workers come to you'**
  String get homePostRequestSubtitle;

  /// No description provided for @homeNoServices.
  ///
  /// In en, this message translates to:
  /// **'No services available right now'**
  String get homeNoServices;

  /// No description provided for @homeSearchNear.
  ///
  /// In en, this message translates to:
  /// **'Search services near'**
  String get homeSearchNear;

  /// No description provided for @homeSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search for services...'**
  String get homeSearchHint;

  /// No description provided for @homeActiveBooking.
  ///
  /// In en, this message translates to:
  /// **'Active Booking #{code}'**
  String homeActiveBooking(Object code);

  /// No description provided for @homeActiveRequests.
  ///
  /// In en, this message translates to:
  /// **'Your Active Requests'**
  String get homeActiveRequests;

  /// No description provided for @commonGrantPermission.
  ///
  /// In en, this message translates to:
  /// **'Grant Permission'**
  String get commonGrantPermission;

  /// No description provided for @commonView.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get commonView;

  /// No description provided for @exploreTitle.
  ///
  /// In en, this message translates to:
  /// **'Explore & Discover Gigs'**
  String get exploreTitle;

  /// No description provided for @exploreListView.
  ///
  /// In en, this message translates to:
  /// **'List View'**
  String get exploreListView;

  /// No description provided for @exploreMapView.
  ///
  /// In en, this message translates to:
  /// **'Map View'**
  String get exploreMapView;

  /// No description provided for @exploreSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search services, workers or skills...'**
  String get exploreSearchHint;

  /// No description provided for @exploreLocationOffTitle.
  ///
  /// In en, this message translates to:
  /// **'Location services are off'**
  String get exploreLocationOffTitle;

  /// No description provided for @exploreLocationOffMessage.
  ///
  /// In en, this message translates to:
  /// **'Turn on location to discover professionals near you.'**
  String get exploreLocationOffMessage;

  /// No description provided for @exploreLocationPermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Location permission needed'**
  String get exploreLocationPermissionTitle;

  /// No description provided for @exploreLocationPermissionMessage.
  ///
  /// In en, this message translates to:
  /// **'We use your location to find professionals nearby.'**
  String get exploreLocationPermissionMessage;

  /// No description provided for @exploreChooseService.
  ///
  /// In en, this message translates to:
  /// **'Choose a service to explore'**
  String get exploreChooseService;

  /// No description provided for @exploreChooseServiceMessage.
  ///
  /// In en, this message translates to:
  /// **'Select a category above to see nearby professionals.'**
  String get exploreChooseServiceMessage;

  /// No description provided for @exploreNoProfessionals.
  ///
  /// In en, this message translates to:
  /// **'No professionals are available for this service nearby'**
  String get exploreNoProfessionals;

  /// No description provided for @exploreLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load professionals.'**
  String get exploreLoadFailed;

  /// No description provided for @exploreByWorker.
  ///
  /// In en, this message translates to:
  /// **'By {name}'**
  String exploreByWorker(Object name);

  /// No description provided for @bookingsTitle.
  ///
  /// In en, this message translates to:
  /// **'My Service Bookings'**
  String get bookingsTitle;

  /// No description provided for @bookingsTabActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get bookingsTabActive;

  /// No description provided for @bookingsTabCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get bookingsTabCompleted;

  /// No description provided for @bookingsTabCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get bookingsTabCancelled;

  /// No description provided for @bookingsLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load your bookings.'**
  String get bookingsLoadFailed;

  /// No description provided for @bookingsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No bookings yet'**
  String get bookingsEmpty;

  /// No description provided for @bookingsFindService.
  ///
  /// In en, this message translates to:
  /// **'Find a Service'**
  String get bookingsFindService;

  /// No description provided for @bookingsWaitingForProfessional.
  ///
  /// In en, this message translates to:
  /// **'Waiting for professional'**
  String get bookingsWaitingForProfessional;

  /// No description provided for @bookingsCode.
  ///
  /// In en, this message translates to:
  /// **'Booking Code: #{code}'**
  String bookingsCode(Object code);

  /// No description provided for @bookingsPayNow.
  ///
  /// In en, this message translates to:
  /// **'Pay now'**
  String get bookingsPayNow;

  /// No description provided for @bookingsApproveWork.
  ///
  /// In en, this message translates to:
  /// **'Approve work'**
  String get bookingsApproveWork;

  /// No description provided for @bookingsTrackLive.
  ///
  /// In en, this message translates to:
  /// **'Track Live'**
  String get bookingsTrackLive;

  /// No description provided for @bookingsDetails.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get bookingsDetails;

  /// No description provided for @bookingDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Booking Details'**
  String get bookingDetailTitle;

  /// No description provided for @bookingDetailLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load booking details.'**
  String get bookingDetailLoadFailed;

  /// No description provided for @bookingDetailWaitingAccept.
  ///
  /// In en, this message translates to:
  /// **'Waiting for the professional to accept'**
  String get bookingDetailWaitingAccept;

  /// No description provided for @bookingDetailNumber.
  ///
  /// In en, this message translates to:
  /// **'Booking #{code}'**
  String bookingDetailNumber(Object code);

  /// No description provided for @bookingDetailStatus.
  ///
  /// In en, this message translates to:
  /// **'Status: {status}'**
  String bookingDetailStatus(Object status);

  /// No description provided for @bookingDetailLiveMap.
  ///
  /// In en, this message translates to:
  /// **'Live Map'**
  String get bookingDetailLiveMap;

  /// No description provided for @bookingDetailServiceInfo.
  ///
  /// In en, this message translates to:
  /// **'Service Request Info'**
  String get bookingDetailServiceInfo;

  /// No description provided for @bookingDetailViewMaterials.
  ///
  /// In en, this message translates to:
  /// **'View Material / Parts Requests'**
  String get bookingDetailViewMaterials;

  /// No description provided for @bookingDetailFareDetails.
  ///
  /// In en, this message translates to:
  /// **'Fare Details'**
  String get bookingDetailFareDetails;

  /// No description provided for @bookingDetailEstimatedFare.
  ///
  /// In en, this message translates to:
  /// **'Estimated Fare'**
  String get bookingDetailEstimatedFare;

  /// No description provided for @bookingDetailFinalFare.
  ///
  /// In en, this message translates to:
  /// **'Final Confirmed Fare'**
  String get bookingDetailFinalFare;

  /// No description provided for @bookingDetailRateReview.
  ///
  /// In en, this message translates to:
  /// **'Rate & Review Service Worker'**
  String get bookingDetailRateReview;

  /// No description provided for @bookingDetailApproveCompletion.
  ///
  /// In en, this message translates to:
  /// **'Approve Completion'**
  String get bookingDetailApproveCompletion;

  /// No description provided for @bookingDetailApprovePaidHint.
  ///
  /// In en, this message translates to:
  /// **'Your professional has marked this job as done. Approving releases your payment to them.'**
  String get bookingDetailApprovePaidHint;

  /// No description provided for @bookingDetailApproveUnpaidHint.
  ///
  /// In en, this message translates to:
  /// **'Your professional has marked this job as done. Approve to confirm and proceed to payment.'**
  String get bookingDetailApproveUnpaidHint;

  /// No description provided for @bookingDetailReportProblem.
  ///
  /// In en, this message translates to:
  /// **'Report Problem'**
  String get bookingDetailReportProblem;

  /// No description provided for @bookingDetailCompletionApproved.
  ///
  /// In en, this message translates to:
  /// **'Completion approved'**
  String get bookingDetailCompletionApproved;

  /// No description provided for @bookingDetailPayToConfirm.
  ///
  /// In en, this message translates to:
  /// **'Pay {amount} to confirm'**
  String bookingDetailPayToConfirm(Object amount);

  /// No description provided for @bookingDetailSentAfterPayment.
  ///
  /// In en, this message translates to:
  /// **'Your booking is sent to the professional once payment is complete.'**
  String get bookingDetailSentAfterPayment;

  /// No description provided for @bookingDetailPayAmount.
  ///
  /// In en, this message translates to:
  /// **'Pay {amount}'**
  String bookingDetailPayAmount(Object amount);

  /// No description provided for @bookingDetailCancelBooking.
  ///
  /// In en, this message translates to:
  /// **'Cancel Booking'**
  String get bookingDetailCancelBooking;

  /// No description provided for @cancelReasonMistake.
  ///
  /// In en, this message translates to:
  /// **'Booked by mistake'**
  String get cancelReasonMistake;

  /// No description provided for @cancelReasonNoLongerNeeded.
  ///
  /// In en, this message translates to:
  /// **'I no longer need this service'**
  String get cancelReasonNoLongerNeeded;

  /// No description provided for @cancelReasonDifferentTime.
  ///
  /// In en, this message translates to:
  /// **'I want to choose a different time'**
  String get cancelReasonDifferentTime;

  /// No description provided for @cancelReasonFoundSomeoneElse.
  ///
  /// In en, this message translates to:
  /// **'I found someone else'**
  String get cancelReasonFoundSomeoneElse;

  /// No description provided for @cancelDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Why are you cancelling?'**
  String get cancelDialogTitle;

  /// No description provided for @cancelDialogRefundNotice.
  ///
  /// In en, this message translates to:
  /// **'This cannot be undone. Your payment will be refunded to the original payment method.'**
  String get cancelDialogRefundNotice;

  /// No description provided for @cancelDialogCannotUndo.
  ///
  /// In en, this message translates to:
  /// **'This cannot be undone.'**
  String get cancelDialogCannotUndo;

  /// No description provided for @cancelDialogKeepBooking.
  ///
  /// In en, this message translates to:
  /// **'Keep booking'**
  String get cancelDialogKeepBooking;

  /// No description provided for @bookingCancelledRefund.
  ///
  /// In en, this message translates to:
  /// **'Booking cancelled. Your refund has been requested.'**
  String get bookingCancelledRefund;

  /// No description provided for @bookingCancelled.
  ///
  /// In en, this message translates to:
  /// **'Booking cancelled'**
  String get bookingCancelled;

  /// No description provided for @arrivalCodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Arrival Code'**
  String get arrivalCodeTitle;

  /// No description provided for @arrivalCodeShare.
  ///
  /// In en, this message translates to:
  /// **'Share this code with your professional to confirm they have arrived:'**
  String get arrivalCodeShare;

  /// No description provided for @arrivalCodeUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get arrivalCodeUnavailable;

  /// No description provided for @arrivalCodeLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load code'**
  String get arrivalCodeLoadFailed;

  /// No description provided for @activeBookingTitle.
  ///
  /// In en, this message translates to:
  /// **'Live Booking & Worker Tracking'**
  String get activeBookingTitle;

  /// No description provided for @activeBookingLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load this booking.'**
  String get activeBookingLoadFailed;

  /// No description provided for @activeBookingMapUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Live map unavailable for this booking.'**
  String get activeBookingMapUnavailable;

  /// No description provided for @activeBookingViewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Booking Details'**
  String get activeBookingViewDetails;

  /// No description provided for @activeBookingServiceLocation.
  ///
  /// In en, this message translates to:
  /// **'Service location'**
  String get activeBookingServiceLocation;

  /// No description provided for @activeBookingYourProfessional.
  ///
  /// In en, this message translates to:
  /// **'Your professional'**
  String get activeBookingYourProfessional;

  /// No description provided for @activeBookingLive.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get activeBookingLive;

  /// No description provided for @activeBookingLastKnown.
  ///
  /// In en, this message translates to:
  /// **'Last known location'**
  String get activeBookingLastKnown;

  /// No description provided for @activeBookingPhoneNotShared.
  ///
  /// In en, this message translates to:
  /// **'Phone not shared yet'**
  String get activeBookingPhoneNotShared;

  /// No description provided for @activeBookingCallProfessional.
  ///
  /// In en, this message translates to:
  /// **'Call professional'**
  String get activeBookingCallProfessional;

  /// No description provided for @activeBookingMaterials.
  ///
  /// In en, this message translates to:
  /// **'Materials'**
  String get activeBookingMaterials;

  /// No description provided for @activeBookingViewDetailsShort.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get activeBookingViewDetailsShort;

  /// No description provided for @locationConnecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting to live location...'**
  String get locationConnecting;

  /// No description provided for @locationLiveUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Live location temporarily unavailable'**
  String get locationLiveUnavailable;

  /// No description provided for @locationLiveActive.
  ///
  /// In en, this message translates to:
  /// **'Live location active'**
  String get locationLiveActive;

  /// No description provided for @locationUpdating.
  ///
  /// In en, this message translates to:
  /// **'Updating...'**
  String get locationUpdating;

  /// No description provided for @locationUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Location temporarily unavailable'**
  String get locationUnavailable;

  /// No description provided for @activeBookingShareStartCode.
  ///
  /// In en, this message translates to:
  /// **'Worker Arrived! Share Start Code:'**
  String get activeBookingShareStartCode;

  /// No description provided for @commonBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get commonBack;

  /// No description provided for @paymentCouldNotOpen.
  ///
  /// In en, this message translates to:
  /// **'Could not open the payment screen. Please try again.'**
  String get paymentCouldNotOpen;

  /// No description provided for @paymentReceived.
  ///
  /// In en, this message translates to:
  /// **'Payment received. Your booking has been sent to the professional.'**
  String get paymentReceived;

  /// No description provided for @paymentNotConfirmed.
  ///
  /// In en, this message translates to:
  /// **'We could not confirm this payment: {reason}. If money was deducted, contact support with reference {reference}.'**
  String paymentNotConfirmed(String reason, String reference);

  /// No description provided for @paymentNotCompleted.
  ///
  /// In en, this message translates to:
  /// **'Payment was not completed.'**
  String get paymentNotCompleted;

  /// No description provided for @paymentExternalWalletUnsupported.
  ///
  /// In en, this message translates to:
  /// **'Selected an external wallet ({wallet}) — not yet supported.'**
  String paymentExternalWalletUnsupported(Object wallet);

  /// No description provided for @paymentTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get paymentTitle;

  /// No description provided for @paymentStatusUnknown.
  ///
  /// In en, this message translates to:
  /// **'We could not check whether this booking has already been paid for. Please try again rather than paying twice.'**
  String get paymentStatusUnknown;

  /// No description provided for @paymentBookingLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load this booking.'**
  String get paymentBookingLoadFailed;

  /// No description provided for @paymentComplete.
  ///
  /// In en, this message translates to:
  /// **'Payment complete'**
  String get paymentComplete;

  /// No description provided for @paymentPaidFor.
  ///
  /// In en, this message translates to:
  /// **'{amount} paid for {service}.'**
  String paymentPaidFor(String amount, String service);

  /// No description provided for @paymentViewBooking.
  ///
  /// In en, this message translates to:
  /// **'View booking'**
  String get paymentViewBooking;

  /// No description provided for @paymentBookingSummary.
  ///
  /// In en, this message translates to:
  /// **'Booking Summary'**
  String get paymentBookingSummary;

  /// No description provided for @paymentProvider.
  ///
  /// In en, this message translates to:
  /// **'Provider'**
  String get paymentProvider;

  /// No description provided for @paymentService.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get paymentService;

  /// No description provided for @paymentDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get paymentDate;

  /// No description provided for @paymentTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get paymentTime;

  /// No description provided for @paymentAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get paymentAddress;

  /// No description provided for @paymentTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get paymentTotal;

  /// No description provided for @paymentHeldSecurely.
  ///
  /// In en, this message translates to:
  /// **'Your payment is held securely and released to the professional only after you approve the work. If the booking is cancelled before work starts, you get a refund.'**
  String get paymentHeldSecurely;

  /// No description provided for @commonChange.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get commonChange;

  /// No description provided for @bookMissingDetails.
  ///
  /// In en, this message translates to:
  /// **'Missing booking details — please start again.'**
  String get bookMissingDetails;

  /// No description provided for @bookSlotPassed.
  ///
  /// In en, this message translates to:
  /// **'That time has passed. We moved you to the next available slot — check it and confirm again.'**
  String get bookSlotPassed;

  /// No description provided for @bookFailed.
  ///
  /// In en, this message translates to:
  /// **'Booking failed: {reason}'**
  String bookFailed(Object reason);

  /// No description provided for @bookNoAddress.
  ///
  /// In en, this message translates to:
  /// **'No address selected'**
  String get bookNoAddress;

  /// No description provided for @bookTitle.
  ///
  /// In en, this message translates to:
  /// **'Book a Service'**
  String get bookTitle;

  /// No description provided for @bookSelectDate.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get bookSelectDate;

  /// No description provided for @bookSelectTime.
  ///
  /// In en, this message translates to:
  /// **'Select Time'**
  String get bookSelectTime;

  /// No description provided for @bookSpecialInstructions.
  ///
  /// In en, this message translates to:
  /// **'Special Instructions (Optional)'**
  String get bookSpecialInstructions;

  /// No description provided for @bookSpecialInstructionsHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Focus on kitchen and bathroom...'**
  String get bookSpecialInstructionsHint;

  /// No description provided for @bookConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm Booking →'**
  String get bookConfirm;

  /// No description provided for @gigUnknownProfessional.
  ///
  /// In en, this message translates to:
  /// **'Unknown professional'**
  String get gigUnknownProfessional;

  /// No description provided for @gigNewProfessional.
  ///
  /// In en, this message translates to:
  /// **'New professional'**
  String get gigNewProfessional;

  /// No description provided for @gigRatingWithCount.
  ///
  /// In en, this message translates to:
  /// **'{rating} ({count, plural, =1{1 review} other{{count} reviews}})'**
  String gigRatingWithCount(String rating, int count);

  /// No description provided for @gigPricing.
  ///
  /// In en, this message translates to:
  /// **'Pricing'**
  String get gigPricing;

  /// No description provided for @gigServiceRate.
  ///
  /// In en, this message translates to:
  /// **'Service Rate'**
  String get gigServiceRate;

  /// No description provided for @gigFinalAmountNote.
  ///
  /// In en, this message translates to:
  /// **'The final amount is confirmed by your professional and shown on your booking once created.'**
  String get gigFinalAmountNote;

  /// No description provided for @gigKycVerified.
  ///
  /// In en, this message translates to:
  /// **'KYC Verified'**
  String get gigKycVerified;

  /// No description provided for @gigBackgroundVerified.
  ///
  /// In en, this message translates to:
  /// **'Background Verified'**
  String get gigBackgroundVerified;

  /// No description provided for @gigBookNow.
  ///
  /// In en, this message translates to:
  /// **'Book Now →'**
  String get gigBookNow;

  /// No description provided for @discoveryTitle.
  ///
  /// In en, this message translates to:
  /// **'Available Professionals'**
  String get discoveryTitle;

  /// No description provided for @discoveryMissingDetails.
  ///
  /// In en, this message translates to:
  /// **'Missing service or location details.'**
  String get discoveryMissingDetails;

  /// No description provided for @discoveryLocalExperts.
  ///
  /// In en, this message translates to:
  /// **'Available Local Experts'**
  String get discoveryLocalExperts;

  /// No description provided for @discoveryWithin.
  ///
  /// In en, this message translates to:
  /// **'Within'**
  String get discoveryWithin;

  /// No description provided for @discoveryNoProviders.
  ///
  /// In en, this message translates to:
  /// **'No providers available nearby'**
  String get discoveryNoProviders;

  /// No description provided for @discoveryTryLargerRadius.
  ///
  /// In en, this message translates to:
  /// **'Try a larger search radius or check back later.'**
  String get discoveryTryLargerRadius;

  /// No description provided for @discoveryLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load nearby providers.'**
  String get discoveryLoadFailed;

  /// No description provided for @discoveryServicesForJob.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 service for this job} other{{count} services for this job}}'**
  String discoveryServicesForJob(int count);

  /// No description provided for @discoveryBook.
  ///
  /// In en, this message translates to:
  /// **'Book'**
  String get discoveryBook;

  /// No description provided for @categoryServiceDetails.
  ///
  /// In en, this message translates to:
  /// **'Service Details'**
  String get categoryServiceDetails;

  /// No description provided for @categoryTagline.
  ///
  /// In en, this message translates to:
  /// **'Book verified, background-checked local experts with upfront pricing & service guarantee.'**
  String get categoryTagline;

  /// No description provided for @categoryWhatHelp.
  ///
  /// In en, this message translates to:
  /// **'What do you need help with?'**
  String get categoryWhatHelp;

  /// No description provided for @categoryDescribeElse.
  ///
  /// In en, this message translates to:
  /// **'Describe something else'**
  String get categoryDescribeElse;

  /// No description provided for @categoryLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load this service.'**
  String get categoryLoadFailed;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications & Alerts'**
  String get notificationsTitle;

  /// No description provided for @notificationsEmpty.
  ///
  /// In en, this message translates to:
  /// **'You\'re all caught up'**
  String get notificationsEmpty;

  /// No description provided for @notificationsLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load notifications.'**
  String get notificationsLoadFailed;

  /// No description provided for @timeJustNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get timeJustNow;

  /// No description provided for @timeMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{minutes}m ago'**
  String timeMinutesAgo(Object minutes);

  /// No description provided for @timeHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{hours}h ago'**
  String timeHoursAgo(Object hours);

  /// No description provided for @timeYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get timeYesterday;

  /// No description provided for @completedTitle.
  ///
  /// In en, this message translates to:
  /// **'Service Completed!'**
  String get completedTitle;

  /// No description provided for @completedThanks.
  ///
  /// In en, this message translates to:
  /// **'Thanks for using our services.'**
  String get completedThanks;

  /// No description provided for @completedViewBookings.
  ///
  /// In en, this message translates to:
  /// **'View Bookings'**
  String get completedViewBookings;

  /// No description provided for @completedBackHome.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get completedBackHome;

  /// No description provided for @commonErrorDetail.
  ///
  /// In en, this message translates to:
  /// **'Error: {detail}'**
  String commonErrorDetail(Object detail);

  /// No description provided for @reviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Rate Your Experience'**
  String get reviewTitle;

  /// No description provided for @reviewHeading.
  ///
  /// In en, this message translates to:
  /// **'Great Service!'**
  String get reviewHeading;

  /// No description provided for @reviewQuestion.
  ///
  /// In en, this message translates to:
  /// **'How was your experience with your professional?'**
  String get reviewQuestion;

  /// No description provided for @reviewStars.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 star} other{{count} stars}}'**
  String reviewStars(int count);

  /// No description provided for @reviewCommentHint.
  ///
  /// In en, this message translates to:
  /// **'Tell us about your experience...'**
  String get reviewCommentHint;

  /// No description provided for @reviewSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit Review →'**
  String get reviewSubmit;

  /// No description provided for @materialsTitle.
  ///
  /// In en, this message translates to:
  /// **'Material / Parts Requests'**
  String get materialsTitle;

  /// No description provided for @materialsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No material requests submitted for this booking'**
  String get materialsEmpty;

  /// No description provided for @materialsQuantityEstimated.
  ///
  /// In en, this message translates to:
  /// **'{quantity} · estimated'**
  String materialsQuantityEstimated(Object quantity);

  /// No description provided for @materialsQuantityActual.
  ///
  /// In en, this message translates to:
  /// **'{quantity} · actual'**
  String materialsQuantityActual(Object quantity);

  /// No description provided for @materialsReject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get materialsReject;

  /// No description provided for @materialsApprove.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get materialsApprove;

  /// No description provided for @materialStatusRequested.
  ///
  /// In en, this message translates to:
  /// **'Requested'**
  String get materialStatusRequested;

  /// No description provided for @materialStatusCustomerReview.
  ///
  /// In en, this message translates to:
  /// **'Awaiting your review'**
  String get materialStatusCustomerReview;

  /// No description provided for @materialStatusApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get materialStatusApproved;

  /// No description provided for @materialStatusRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get materialStatusRejected;

  /// No description provided for @materialStatusPurchased.
  ///
  /// In en, this message translates to:
  /// **'Purchased'**
  String get materialStatusPurchased;

  /// No description provided for @materialStatusCostRecorded.
  ///
  /// In en, this message translates to:
  /// **'Cost recorded'**
  String get materialStatusCostRecorded;

  /// No description provided for @materialStatusBilled.
  ///
  /// In en, this message translates to:
  /// **'Billed'**
  String get materialStatusBilled;

  /// No description provided for @materialStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get materialStatusCancelled;

  /// No description provided for @commonSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get commonSaveChanges;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'My Profile & Account'**
  String get profileTitle;

  /// No description provided for @profileFallbackName.
  ///
  /// In en, this message translates to:
  /// **'Customer Profile'**
  String get profileFallbackName;

  /// No description provided for @profileLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get profileLanguage;

  /// No description provided for @profileAddresses.
  ///
  /// In en, this message translates to:
  /// **'Saved Service Addresses'**
  String get profileAddresses;

  /// No description provided for @profileAddressesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage home, office & secondary addresses'**
  String get profileAddressesSubtitle;

  /// No description provided for @profileHistory.
  ///
  /// In en, this message translates to:
  /// **'Past Service History'**
  String get profileHistory;

  /// No description provided for @profileHistorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'View receipts & past bookings'**
  String get profileHistorySubtitle;

  /// No description provided for @profileSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Customer Support'**
  String get profileSupport;

  /// No description provided for @profileSupportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Raise a ticket, track replies from our team'**
  String get profileSupportSubtitle;

  /// No description provided for @editProfileSaved.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get editProfileSaved;

  /// No description provided for @editProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfileTitle;

  /// No description provided for @editProfileFullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get editProfileFullName;

  /// No description provided for @editProfileNameEmpty.
  ///
  /// In en, this message translates to:
  /// **'Name cannot be empty'**
  String get editProfileNameEmpty;

  /// No description provided for @editProfileEmail.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get editProfileEmail;

  /// No description provided for @commonEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get commonEdit;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @addressesAdd.
  ///
  /// In en, this message translates to:
  /// **'Add New Address'**
  String get addressesAdd;

  /// No description provided for @addressesEmpty.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t saved any addresses yet'**
  String get addressesEmpty;

  /// No description provided for @addressesEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Add a service address to book faster next time.'**
  String get addressesEmptyMessage;

  /// No description provided for @addressesDefaultBadge.
  ///
  /// In en, this message translates to:
  /// **'DEFAULT'**
  String get addressesDefaultBadge;

  /// No description provided for @addressesSetDefault.
  ///
  /// In en, this message translates to:
  /// **'Set as default'**
  String get addressesSetDefault;

  /// No description provided for @addressesLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load addresses.'**
  String get addressesLoadFailed;

  /// No description provided for @addressesLabelSheet.
  ///
  /// In en, this message translates to:
  /// **'Label this address'**
  String get addressesLabelSheet;

  /// No description provided for @supportTitle.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get supportTitle;

  /// No description provided for @supportNewTicket.
  ///
  /// In en, this message translates to:
  /// **'New Ticket'**
  String get supportNewTicket;

  /// No description provided for @supportEmpty.
  ///
  /// In en, this message translates to:
  /// **'No support tickets yet'**
  String get supportEmpty;

  /// No description provided for @supportEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Need help with a booking or the app? Raise a ticket and our team will respond.'**
  String get supportEmptyMessage;

  /// No description provided for @supportLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load your support tickets.'**
  String get supportLoadFailed;

  /// No description provided for @supportStatusOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get supportStatusOpen;

  /// No description provided for @supportStatusInProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get supportStatusInProgress;

  /// No description provided for @supportStatusWaitingForYou.
  ///
  /// In en, this message translates to:
  /// **'Waiting for you'**
  String get supportStatusWaitingForYou;

  /// No description provided for @supportStatusResolved.
  ///
  /// In en, this message translates to:
  /// **'Resolved'**
  String get supportStatusResolved;

  /// No description provided for @supportStatusClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get supportStatusClosed;

  /// No description provided for @supportNewTicketTitle.
  ///
  /// In en, this message translates to:
  /// **'New Support Ticket'**
  String get supportNewTicketTitle;

  /// No description provided for @supportCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get supportCategory;

  /// No description provided for @supportSubject.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get supportSubject;

  /// No description provided for @supportDescribeIssue.
  ///
  /// In en, this message translates to:
  /// **'Describe the issue'**
  String get supportDescribeIssue;

  /// No description provided for @supportFillSubjectMessage.
  ///
  /// In en, this message translates to:
  /// **'Please fill in a subject and message.'**
  String get supportFillSubjectMessage;

  /// No description provided for @supportSubmitTicket.
  ///
  /// In en, this message translates to:
  /// **'Submit Ticket'**
  String get supportSubmitTicket;

  /// No description provided for @supportTicketTitle.
  ///
  /// In en, this message translates to:
  /// **'Support Ticket'**
  String get supportTicketTitle;

  /// No description provided for @supportNoMessages.
  ///
  /// In en, this message translates to:
  /// **'No messages yet'**
  String get supportNoMessages;

  /// No description provided for @supportMessagesLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load messages.'**
  String get supportMessagesLoadFailed;

  /// No description provided for @supportTypeMessage.
  ///
  /// In en, this message translates to:
  /// **'Type a message...'**
  String get supportTypeMessage;

  /// No description provided for @supportSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get supportSend;

  /// No description provided for @pickerEnterAddress.
  ///
  /// In en, this message translates to:
  /// **'Please enter or confirm the address for this pin'**
  String get pickerEnterAddress;

  /// No description provided for @pickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Service Address'**
  String get pickerTitle;

  /// No description provided for @pickerGettingLocation.
  ///
  /// In en, this message translates to:
  /// **'Getting your location...'**
  String get pickerGettingLocation;

  /// No description provided for @pickerPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission denied — move the map manually to pick your address.'**
  String get pickerPermissionDenied;

  /// No description provided for @pickerConfirmPin.
  ///
  /// In en, this message translates to:
  /// **'Confirm Service Pin Position'**
  String get pickerConfirmPin;

  /// No description provided for @pickerAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'House / Flat / Street Name'**
  String get pickerAddressLabel;

  /// No description provided for @pickerAddressHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. #102, Green Avenue, Indiranagar'**
  String get pickerAddressHint;

  /// No description provided for @pickerLandmarkLabel.
  ///
  /// In en, this message translates to:
  /// **'Landmark (Optional)'**
  String get pickerLandmarkLabel;

  /// No description provided for @pickerLandmarkHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Near HDFC Bank ATM'**
  String get pickerLandmarkHint;

  /// No description provided for @pickerConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm Location & Proceed'**
  String get pickerConfirm;

  /// No description provided for @requestSelectLocation.
  ///
  /// In en, this message translates to:
  /// **'Please select a service location'**
  String get requestSelectLocation;

  /// No description provided for @requestTitle.
  ///
  /// In en, this message translates to:
  /// **'Request {service}'**
  String requestTitle(Object service);

  /// No description provided for @requestServiceAddress.
  ///
  /// In en, this message translates to:
  /// **'Service Address'**
  String get requestServiceAddress;

  /// No description provided for @requestDetectingLocation.
  ///
  /// In en, this message translates to:
  /// **'Detecting your location…'**
  String get requestDetectingLocation;

  /// No description provided for @requestTapToPickLocation.
  ///
  /// In en, this message translates to:
  /// **'Tap to pick service location'**
  String get requestTapToPickLocation;

  /// No description provided for @requestDescribeIssue.
  ///
  /// In en, this message translates to:
  /// **'Describe the Issue / Task'**
  String get requestDescribeIssue;

  /// No description provided for @requestDescribeHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Living room main ceiling light switch is sparking when turned on.'**
  String get requestDescribeHint;

  /// No description provided for @requestDescribeMin.
  ///
  /// In en, this message translates to:
  /// **'Please describe the problem in at least 10 characters'**
  String get requestDescribeMin;

  /// No description provided for @requestAttachPhotos.
  ///
  /// In en, this message translates to:
  /// **'Attach Photos of Problem (Optional)'**
  String get requestAttachPhotos;

  /// No description provided for @requestAddPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add a photo'**
  String get requestAddPhoto;

  /// No description provided for @requestWhen.
  ///
  /// In en, this message translates to:
  /// **'When do you need the service?'**
  String get requestWhen;

  /// No description provided for @requestInstant.
  ///
  /// In en, this message translates to:
  /// **'⚡ Instant (30 min)'**
  String get requestInstant;

  /// No description provided for @requestScheduleLater.
  ///
  /// In en, this message translates to:
  /// **'📅 Schedule later'**
  String get requestScheduleLater;

  /// No description provided for @requestFindWorkers.
  ///
  /// In en, this message translates to:
  /// **'Find Available Workers'**
  String get requestFindWorkers;

  /// No description provided for @commonLoadFailedDetail.
  ///
  /// In en, this message translates to:
  /// **'Failed to load: {detail}'**
  String commonLoadFailedDetail(Object detail);

  /// No description provided for @myRequestsTitle.
  ///
  /// In en, this message translates to:
  /// **'My Service Requests'**
  String get myRequestsTitle;

  /// No description provided for @myRequestsTabAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get myRequestsTabAll;

  /// No description provided for @myRequestsNew.
  ///
  /// In en, this message translates to:
  /// **'New Request'**
  String get myRequestsNew;

  /// No description provided for @myRequestsNoActive.
  ///
  /// In en, this message translates to:
  /// **'No active requests'**
  String get myRequestsNoActive;

  /// No description provided for @myRequestsNoCompleted.
  ///
  /// In en, this message translates to:
  /// **'No completed requests'**
  String get myRequestsNoCompleted;

  /// No description provided for @myRequestsNone.
  ///
  /// In en, this message translates to:
  /// **'No service requests yet'**
  String get myRequestsNone;

  /// No description provided for @myRequestsEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Post a requirement and let workers come to you.'**
  String get myRequestsEmptyMessage;

  /// No description provided for @requestDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Request Details'**
  String get requestDetailTitle;

  /// No description provided for @requestDetailBudget.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get requestDetailBudget;

  /// No description provided for @requestDetailSchedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get requestDetailSchedule;

  /// No description provided for @requestDetailLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get requestDetailLocation;

  /// No description provided for @requestDetailNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get requestDetailNotes;

  /// No description provided for @requestDetailCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel Request'**
  String get requestDetailCancel;

  /// No description provided for @requestDetailOffersReceived.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No offers yet} =1{1 offer received} other{{count} offers received}}'**
  String requestDetailOffersReceived(int count);

  /// No description provided for @requestDetailTapToCompare.
  ///
  /// In en, this message translates to:
  /// **'Tap to view and compare'**
  String get requestDetailTapToCompare;

  /// No description provided for @requestDetailWorkersSoon.
  ///
  /// In en, this message translates to:
  /// **'Workers will start responding soon'**
  String get requestDetailWorkersSoon;

  /// No description provided for @requestCancelDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel this request?'**
  String get requestCancelDialogTitle;

  /// No description provided for @requestCancelDialogBody.
  ///
  /// In en, this message translates to:
  /// **'All pending offers will be closed. This cannot be undone.'**
  String get requestCancelDialogBody;

  /// No description provided for @requestCancelKeep.
  ///
  /// In en, this message translates to:
  /// **'Keep it'**
  String get requestCancelKeep;

  /// No description provided for @requestCancelConfirm.
  ///
  /// In en, this message translates to:
  /// **'Cancel request'**
  String get requestCancelConfirm;

  /// No description provided for @requestCancelled.
  ///
  /// In en, this message translates to:
  /// **'Request cancelled'**
  String get requestCancelled;

  /// No description provided for @requestExpiresInDaysHours.
  ///
  /// In en, this message translates to:
  /// **'Expires in {days}d {hours}h'**
  String requestExpiresInDaysHours(int days, int hours);

  /// No description provided for @requestExpiresInHoursMinutes.
  ///
  /// In en, this message translates to:
  /// **'Expires in {hours}h {minutes}m'**
  String requestExpiresInHoursMinutes(int hours, int minutes);

  /// No description provided for @requestExpiresInMinutes.
  ///
  /// In en, this message translates to:
  /// **'Expires in {minutes}m'**
  String requestExpiresInMinutes(Object minutes);

  /// No description provided for @requestExpiresSoon.
  ///
  /// In en, this message translates to:
  /// **'Expires soon'**
  String get requestExpiresSoon;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @offersTitle.
  ///
  /// In en, this message translates to:
  /// **'Offers Received'**
  String get offersTitle;

  /// No description provided for @offersEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Workers are reviewing your request. You\'ll be notified when someone responds.'**
  String get offersEmptyMessage;

  /// No description provided for @offersPending.
  ///
  /// In en, this message translates to:
  /// **'Pending Offers'**
  String get offersPending;

  /// No description provided for @offersPast.
  ///
  /// In en, this message translates to:
  /// **'Past Offers'**
  String get offersPast;

  /// No description provided for @offersJobsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 job} other{{count} jobs}}'**
  String offersJobsCount(int count);

  /// No description provided for @offersInsured.
  ///
  /// In en, this message translates to:
  /// **'Insured'**
  String get offersInsured;

  /// No description provided for @offersDecline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get offersDecline;

  /// No description provided for @offersAcceptOffer.
  ///
  /// In en, this message translates to:
  /// **'Accept Offer'**
  String get offersAcceptOffer;

  /// No description provided for @offersAcceptDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Accept this offer?'**
  String get offersAcceptDialogTitle;

  /// No description provided for @offersAcceptDialogBody.
  ///
  /// In en, this message translates to:
  /// **'A booking will be created with {worker} at {price}. All other offers will be closed.'**
  String offersAcceptDialogBody(String worker, String price);

  /// No description provided for @offersAccept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get offersAccept;

  /// No description provided for @offersBookingCreated.
  ///
  /// In en, this message translates to:
  /// **'Booking {code} created!'**
  String offersBookingCreated(Object code);

  /// No description provided for @commonNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get commonNext;

  /// No description provided for @postRequestPosted.
  ///
  /// In en, this message translates to:
  /// **'Service request {code} posted!'**
  String postRequestPosted(Object code);

  /// No description provided for @postRequestTitle.
  ///
  /// In en, this message translates to:
  /// **'Post a Service Request'**
  String get postRequestTitle;

  /// No description provided for @postRequestWhatService.
  ///
  /// In en, this message translates to:
  /// **'What service do you need?'**
  String get postRequestWhatService;

  /// No description provided for @postRequestSelectCategory.
  ///
  /// In en, this message translates to:
  /// **'Select the category that best describes your need.'**
  String get postRequestSelectCategory;

  /// No description provided for @postRequestDescribe.
  ///
  /// In en, this message translates to:
  /// **'Describe your requirement'**
  String get postRequestDescribe;

  /// No description provided for @postRequestServiceLabel.
  ///
  /// In en, this message translates to:
  /// **'Service: {service}'**
  String postRequestServiceLabel(Object service);

  /// No description provided for @postRequestWhatDone.
  ///
  /// In en, this message translates to:
  /// **'What do you need done?'**
  String get postRequestWhatDone;

  /// No description provided for @postRequestFieldTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get postRequestFieldTitle;

  /// No description provided for @postRequestTitleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Fix leaking kitchen tap'**
  String get postRequestTitleHint;

  /// No description provided for @postRequestMinChars.
  ///
  /// In en, this message translates to:
  /// **'Enter at least {count} characters'**
  String postRequestMinChars(Object count);

  /// No description provided for @postRequestFieldDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get postRequestFieldDescription;

  /// No description provided for @postRequestDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Describe the problem in detail…'**
  String get postRequestDescriptionHint;

  /// No description provided for @postRequestFieldNotes.
  ///
  /// In en, this message translates to:
  /// **'Additional notes (optional)'**
  String get postRequestFieldNotes;

  /// No description provided for @postRequestNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Gate code, preferred timing, etc.'**
  String get postRequestNotesHint;

  /// No description provided for @postRequestBudgetTitle.
  ///
  /// In en, this message translates to:
  /// **'Your budget'**
  String get postRequestBudgetTitle;

  /// No description provided for @postRequestBudgetHint.
  ///
  /// In en, this message translates to:
  /// **'Give workers an idea of what you\'re willing to pay.'**
  String get postRequestBudgetHint;

  /// No description provided for @postRequestFixedPrice.
  ///
  /// In en, this message translates to:
  /// **'Fixed price (₹)'**
  String get postRequestFixedPrice;

  /// No description provided for @postRequestExample.
  ///
  /// In en, this message translates to:
  /// **'e.g. {example}'**
  String postRequestExample(Object example);

  /// No description provided for @postRequestMin.
  ///
  /// In en, this message translates to:
  /// **'Min (₹)'**
  String get postRequestMin;

  /// No description provided for @postRequestMax.
  ///
  /// In en, this message translates to:
  /// **'Max (₹)'**
  String get postRequestMax;

  /// No description provided for @postRequestWhenTitle.
  ///
  /// In en, this message translates to:
  /// **'When do you need this?'**
  String get postRequestWhenTitle;

  /// No description provided for @postRequestPickDate.
  ///
  /// In en, this message translates to:
  /// **'Pick a date'**
  String get postRequestPickDate;

  /// No description provided for @postRequestLocationTitle.
  ///
  /// In en, this message translates to:
  /// **'Service location'**
  String get postRequestLocationTitle;

  /// No description provided for @postRequestAddressPrivate.
  ///
  /// In en, this message translates to:
  /// **'Your exact address is only shared once you accept an offer.'**
  String get postRequestAddressPrivate;

  /// No description provided for @postRequestFullAddress.
  ///
  /// In en, this message translates to:
  /// **'Full address'**
  String get postRequestFullAddress;

  /// No description provided for @postRequestValidAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid address'**
  String get postRequestValidAddress;

  /// No description provided for @postRequestCity.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get postRequestCity;

  /// No description provided for @postRequestCityHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Bangalore'**
  String get postRequestCityHint;

  /// No description provided for @postRequestPincode.
  ///
  /// In en, this message translates to:
  /// **'Pincode'**
  String get postRequestPincode;

  /// No description provided for @postRequestLocationSet.
  ///
  /// In en, this message translates to:
  /// **'Location set ✓'**
  String get postRequestLocationSet;

  /// No description provided for @postRequestSetOnMap.
  ///
  /// In en, this message translates to:
  /// **'Set location on map'**
  String get postRequestSetOnMap;

  /// No description provided for @postRequestReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Review your request'**
  String get postRequestReviewTitle;

  /// No description provided for @postRequestNotSelected.
  ///
  /// In en, this message translates to:
  /// **'Not selected'**
  String get postRequestNotSelected;

  /// No description provided for @postRequestWhen.
  ///
  /// In en, this message translates to:
  /// **'When'**
  String get postRequestWhen;

  /// No description provided for @postRequestPrivacyNote.
  ///
  /// In en, this message translates to:
  /// **'Your exact address stays private until you accept an offer and a booking is created.'**
  String get postRequestPrivacyNote;

  /// No description provided for @postRequestSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit Request'**
  String get postRequestSubmit;

  /// No description provided for @assistantOpening.
  ///
  /// In en, this message translates to:
  /// **'Tell me what\'s wrong, in your own words — and I\'ll find the right professional for it.'**
  String get assistantOpening;

  /// No description provided for @assistantCatalogueFailed.
  ///
  /// In en, this message translates to:
  /// **'{reason} I need the service list to answer that.'**
  String assistantCatalogueFailed(Object reason);

  /// No description provided for @assistantCatalogueError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong loading the service list.'**
  String get assistantCatalogueError;

  /// No description provided for @assistantGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hello. What do you need help with at home? A leaking tap, an AC that stopped cooling, a switch that sparks — whatever it is, describe it however you like.'**
  String get assistantGreeting;

  /// No description provided for @assistantTooVague.
  ///
  /// In en, this message translates to:
  /// **'I can help — I just need to know what the problem is. What is not working?'**
  String get assistantTooVague;

  /// No description provided for @assistantMultipleJobs.
  ///
  /// In en, this message translates to:
  /// **'That sounds like {count} separate jobs — they need different trades. Here is each one:'**
  String assistantMultipleJobs(int count);

  /// No description provided for @assistantAmbiguous.
  ///
  /// In en, this message translates to:
  /// **'I want to get this right — that could go to more than one trade. Which is closer?'**
  String get assistantAmbiguous;

  /// No description provided for @assistantUnmatched.
  ///
  /// In en, this message translates to:
  /// **'I could not place that against the services on the platform. Pick the closest one and I will take your description across — or post it as a request and let professionals come to you.'**
  String get assistantUnmatched;

  /// No description provided for @assistantConfidentWithProblem.
  ///
  /// In en, this message translates to:
  /// **'That sounds like {service} — most likely \"{problem}\".'**
  String assistantConfidentWithProblem(String service, String problem);

  /// No description provided for @assistantConfident.
  ///
  /// In en, this message translates to:
  /// **'That sounds like a job for {service}.'**
  String assistantConfident(Object service);

  /// No description provided for @assistantChosen.
  ///
  /// In en, this message translates to:
  /// **'{service} it is. Your description goes across as you wrote it.'**
  String assistantChosen(Object service);

  /// No description provided for @assistantTitle.
  ///
  /// In en, this message translates to:
  /// **'Service Assistant'**
  String get assistantTitle;

  /// No description provided for @assistantSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Finds the right trade for your problem'**
  String get assistantSubtitle;

  /// No description provided for @assistantStartOver.
  ///
  /// In en, this message translates to:
  /// **'Start over'**
  String get assistantStartOver;

  /// No description provided for @assistantMatchedOn.
  ///
  /// In en, this message translates to:
  /// **'Matched on: {terms}'**
  String assistantMatchedOn(Object terms);

  /// No description provided for @assistantFindWorkers.
  ///
  /// In en, this message translates to:
  /// **'Find workers'**
  String get assistantFindWorkers;

  /// No description provided for @assistantPostRequest.
  ///
  /// In en, this message translates to:
  /// **'Post a request'**
  String get assistantPostRequest;

  /// No description provided for @assistantInputHint.
  ///
  /// In en, this message translates to:
  /// **'Describe the problem...'**
  String get assistantInputHint;
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
      <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
