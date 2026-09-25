// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get languagePickerTitle => 'Choose your language';

  @override
  String get startupMissingConfig => 'This build is missing its configuration.';

  @override
  String startupPassDartDefine(Object keys) {
    return 'Pass these with --dart-define:\n\n$keys';
  }

  @override
  String get startupCouldNotStart => 'The app could not start.';

  @override
  String get errorNoInternet =>
      'No internet connection. Check your network and try again.';

  @override
  String get errorTimeout => 'That took too long. Try again.';

  @override
  String get errorServer =>
      'Something went wrong at our end. Please try again.';

  @override
  String get errorClockSkew =>
      'Your phone\'s date and time look out of sync. Turn on automatic date & time in Settings, then try again.';

  @override
  String get errorUnexpected => 'Something went wrong. Please try again.';

  @override
  String get eligibilityStepIncomplete => 'This step is not complete yet.';

  @override
  String get errorSessionEnded =>
      'Your session has ended. Please sign in again.';

  @override
  String get errorUploadFailed => 'That file could not be uploaded. Try again.';

  @override
  String get errorServiceUnavailable =>
      'That service is unavailable right now. Try again shortly.';

  @override
  String get errorSignInNotReady =>
      'Your sign-in is not fully set up yet. Try again in a moment.';

  @override
  String get errorNoLongerAvailable => 'That is no longer available.';

  @override
  String get errorNotAllowedToSee => 'You are not able to see that.';

  @override
  String get errorDidNotWork => 'That did not work. Please try again.';

  @override
  String get authErrorInvalidPhone => 'That phone number does not look right.';

  @override
  String get authErrorWrongCode =>
      'That code is not correct. Check and try again.';

  @override
  String get authErrorCodeExpired =>
      'That code has expired. Ask for a new one.';

  @override
  String get authErrorTooManyAttempts =>
      'Too many attempts. Wait a few minutes before trying again.';

  @override
  String get authErrorQuota =>
      'We cannot send a code right now. Try again shortly.';

  @override
  String get authErrorDisabled =>
      'This account has been disabled. Contact support.';

  @override
  String get authErrorPhoneNotEnabledRegion =>
      'Phone sign-in is not enabled, or SMS to this region is blocked. Check Firebase Console settings.';

  @override
  String get authErrorNumberInUse =>
      'That number is already registered to another account.';

  @override
  String get authErrorSignInAgain => 'Please sign in again to continue.';

  @override
  String get authErrorSignInFailed => 'Sign-in failed. Please try again.';

  @override
  String get budgetTypeFlexible => 'Flexible';

  @override
  String get budgetTypeFixed => 'Fixed price';

  @override
  String get budgetTypeRange => 'Price range';

  @override
  String get scheduleAsap => 'As soon as possible';

  @override
  String get scheduleToday => 'Today';

  @override
  String get scheduleTomorrow => 'Tomorrow';

  @override
  String get scheduleSpecificDate => 'Specific date';

  @override
  String get offerStatusSubmitted => 'Submitted';

  @override
  String get offerStatusViewed => 'Viewed by customer';

  @override
  String get offerStatusShortlisted => 'Shortlisted';

  @override
  String get offerStatusAccepted => 'Accepted ✓';

  @override
  String get offerStatusRejected => 'Not selected';

  @override
  String get offerStatusWithdrawn => 'Withdrawn';

  @override
  String get offerStatusExpired => 'Expired';

  @override
  String get offerStatusClosed => 'Closed';

  @override
  String distanceMetresAway(Object metres) {
    return '$metres m away';
  }

  @override
  String distanceKmAway(Object km) {
    return '$km km away';
  }

  @override
  String offerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count offers',
      one: '1 offer',
      zero: 'No offers yet',
    );
    return '$_temp0';
  }

  @override
  String get gigErrorTrade => 'Choose which trade this service belongs to';

  @override
  String get gigErrorTitleShort =>
      'Give this service a clear name of at least 6 characters';

  @override
  String get gigErrorTitleLong => 'Keep the name under 120 characters';

  @override
  String get gigErrorPrice => 'Enter what you charge for this service';

  @override
  String get gigErrorDurationMissing => 'How long does this usually take?';

  @override
  String get gigErrorDurationShort =>
      'The shortest job we can list is 15 minutes';

  @override
  String get gigErrorDurationLong => 'The longest job we can list is 14 days';

  @override
  String get gigErrorRadius => 'Travel distance must be between 1 and 100 km';

  @override
  String get jobAreaNearby => 'Nearby';

  @override
  String get jobBlockerVerifyArrival =>
      'Verify arrival with the customer\'s code';

  @override
  String get jobBlockerAfterPhoto => 'Add a photo of the finished work';

  @override
  String jobBlockerMaterialsPending(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count material requests still waiting on the customer',
      one: '1 material request still waiting on the customer',
    );
    return '$_temp0';
  }

  @override
  String mediaTypeNotAccepted(Object kinds) {
    return 'That file type is not accepted here. Use $kinds.';
  }

  @override
  String get mediaEmpty => 'That file is empty.';

  @override
  String mediaTooLarge(Object megabytes) {
    return 'That file is too large. The limit is ${megabytes}MB.';
  }

  @override
  String get verificationNotStarted => 'Not started';

  @override
  String get verificationSubmitted => 'Submitted';

  @override
  String get verificationUnderReview => 'Being reviewed';

  @override
  String get verificationMoreInfo => 'More information needed';

  @override
  String get verificationExpired => 'Expired';

  @override
  String get verificationVerified => 'Verified';

  @override
  String get verificationNotApproved => 'Not approved';

  @override
  String get verificationNotRequired => 'Not required';

  @override
  String get qualificationErrorInstitution => 'Which institute issued this?';

  @override
  String get qualificationErrorName => 'What is the qualification called?';

  @override
  String get qualificationErrorYearMissing => 'Which year did you complete it?';

  @override
  String qualificationErrorYearRange(Object year) {
    return 'Enter a year between 1950 and $year';
  }

  @override
  String get walletTxJobEarning => 'Job earning';

  @override
  String get walletTxMaterialReimbursed => 'Material reimbursed';

  @override
  String get walletTxAdjustment => 'Adjustment';

  @override
  String get walletTxPayoutReturned => 'Payout returned';

  @override
  String get walletTxPlatformFee => 'Platform fee';

  @override
  String get walletTxWithdrawn => 'Withdrawn';

  @override
  String get walletTxClaimRecovery => 'Claim recovery';

  @override
  String get payoutStatusRequested => 'Requested';

  @override
  String get payoutStatusProcessing => 'Being processed';

  @override
  String get payoutStatusPaid => 'Paid';

  @override
  String get payoutStatusFailed => 'Failed';

  @override
  String get authPhoneTenDigits => 'Enter a 10-digit mobile number.';

  @override
  String get authCodeSendTimeout =>
      'We could not send the code. Check your network and try again.';

  @override
  String get authEnterReceivedCode => 'Enter the code you received.';

  @override
  String get authSignInIncomplete =>
      'Sign-in did not complete. Please try again.';

  @override
  String get authSignInToContinue => 'Please sign in to continue.';

  @override
  String get accountDeletionBySupport =>
      'Account deletion is handled by our support team. Raise a request and we will confirm once it is done.';

  @override
  String get photoUploadFailed => 'That photo could not be uploaded.';

  @override
  String get photoUploadFailedRetry =>
      'That photo could not be uploaded. Try again.';

  @override
  String get locationInvalid => 'That location does not look right.';

  @override
  String get travelDistanceRange =>
      'Choose a travel distance between 1 and 100 km.';

  @override
  String get profileLoadFailed => 'Your profile could not be loaded.';

  @override
  String get uploadIncomplete => 'The upload did not complete. Try again.';

  @override
  String get uploadTooLarge => 'That file is too large.';

  @override
  String get uploadTypeNotAccepted => 'That file type is not accepted.';

  @override
  String get uploadRefused => 'That file was refused.';

  @override
  String get uploadTooMany =>
      'Too many uploads at once. Wait a moment and try again.';

  @override
  String get uploadGone =>
      'That upload is no longer available. Choose the file again.';

  @override
  String get uploadDidNotStart => 'The upload did not start.';

  @override
  String get uploadDidNotFinish => 'That upload did not finish.';

  @override
  String get claimResponseTooShort =>
      'Please explain what happened in a little more detail.';

  @override
  String get walletLoadFailedRetry =>
      'Your wallet could not be loaded. Please try again.';

  @override
  String get walletLoadFailed => 'Your wallet could not be loaded.';

  @override
  String get onboardingStepDetails => 'Your details';

  @override
  String get onboardingStepTrade => 'Your main trade';

  @override
  String get onboardingStepSkills => 'What you can do';

  @override
  String get onboardingStepArea => 'Where you work';

  @override
  String get onboardingStepKyc => 'Identity check';

  @override
  String get onboardingStepReady => 'Ready to work';

  @override
  String routerScreenNotFound(Object location) {
    return 'That screen could not be opened.\n$location';
  }

  @override
  String get cameraOpenFailed =>
      'The camera could not be opened. Check app permissions.';

  @override
  String get commonTryAgain => 'Try again';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonConfirm => 'Confirm';

  @override
  String get offlineBanner =>
      'You are offline. Job actions will work again once you reconnect.';

  @override
  String get badgeNew => 'New';

  @override
  String get badgeAccepted => 'Accepted';

  @override
  String get badgeConfirmed => 'Confirmed';

  @override
  String get badgeOnTheWay => 'On the way';

  @override
  String get badgeArrived => 'Arrived';

  @override
  String get badgeWorking => 'Working';

  @override
  String get badgeAwaitingCustomer => 'Awaiting customer';

  @override
  String get badgeDone => 'Done';

  @override
  String get badgePaymentDue => 'Payment due';

  @override
  String get badgePaid => 'Paid';

  @override
  String get badgeClosed => 'Closed';

  @override
  String get badgeCancelled => 'Cancelled';

  @override
  String get badgeDisputed => 'Disputed';

  @override
  String get badgeExpired => 'Expired';

  @override
  String get badgeDraft => 'Draft';

  @override
  String get badgeInReview => 'In review';

  @override
  String get badgeLive => 'Live';

  @override
  String get badgePaused => 'Paused';

  @override
  String get badgeNotApproved => 'Not approved';

  @override
  String get badgeRemoved => 'Removed';

  @override
  String get badgeNotStarted => 'Not started';

  @override
  String get badgeSubmitted => 'Submitted';

  @override
  String get badgeActionNeeded => 'Action needed';

  @override
  String get badgeVerified => 'Verified';

  @override
  String get badgeNotRequired => 'Not required';

  @override
  String get commonContinue => 'Continue';

  @override
  String get commonSaving => 'Saving…';

  @override
  String get welcomePromiseWorkTitle => 'Get suitable work';

  @override
  String get welcomePromiseWorkBody =>
      'Jobs near you, matched to the trades you actually offer.';

  @override
  String get welcomePromiseSkillsTitle => 'Prove your skills';

  @override
  String get welcomePromiseSkillsBody =>
      'Your ITI and diploma certificates, verified once and shown to every customer.';

  @override
  String get welcomePromiseTrackTitle => 'Track every job';

  @override
  String get welcomePromiseTrackBody =>
      'From accepting a job to finishing it, with photo records at each step.';

  @override
  String get welcomePromisePaidTitle => 'Get paid securely';

  @override
  String get welcomePromisePaidBody =>
      'Every rupee recorded, with a clear statement and withdrawals on your terms.';

  @override
  String get welcomeHeadline => 'Work that finds you';

  @override
  String get welcomeSubtitle =>
      'Wervexa connects skilled professionals with customers who need them.';

  @override
  String get welcomeGetStarted => 'Get started';

  @override
  String get welcomeCodeNotice =>
      'We will send a one-time code to your mobile number.';

  @override
  String get phoneTitle => 'What is your mobile number?';

  @override
  String get phoneSubtitle =>
      'We will send you a one-time code to confirm it is you.';

  @override
  String get phoneSendCode => 'Send code';

  @override
  String get phoneSending => 'Sending…';

  @override
  String get authNewCodeSent => 'We sent a new code.';

  @override
  String get otpTitle => 'Enter the code';

  @override
  String otpSentTo(Object phone) {
    return 'We sent a 6-digit code to $phone.';
  }

  @override
  String otpResendIn(int seconds) {
    String _temp0 = intl.Intl.pluralLogic(
      seconds,
      locale: localeName,
      other: 'You can ask for a new code in $seconds seconds',
      one: 'You can ask for a new code in 1 second',
    );
    return '$_temp0';
  }

  @override
  String get otpSendNew => 'Send a new code';

  @override
  String get otpVerify => 'Verify';

  @override
  String get otpVerifying => 'Verifying…';

  @override
  String get registerNameRequired => 'Please enter your full name';

  @override
  String get registerEmailInvalid => 'Please enter a valid email address';

  @override
  String get registerTitle => 'What should we call you?';

  @override
  String get registerSubtitle => 'This is the name customers will see.';

  @override
  String get registerNameLabel => 'Full name';

  @override
  String get registerNameHint => 'Arun Kumar';

  @override
  String get registerEmailLabel => 'Email (optional)';

  @override
  String get registerEmailHelper => 'For receipts and statements.';

  @override
  String registerVerifiedPhone(Object phone) {
    return 'Verified: $phone';
  }

  @override
  String get navHome => 'Home';

  @override
  String get navJobs => 'Jobs';

  @override
  String get navWallet => 'Wallet';

  @override
  String get navProfile => 'Profile';

  @override
  String get sessionProfileLoadFailedRetry =>
      'We could not load your profile. Please try again.';

  @override
  String get commonSignOut => 'Sign out';

  @override
  String get serviceElectrical => 'Electrical';

  @override
  String get servicePlumbing => 'Plumbing';

  @override
  String get serviceAcService => 'AC Service';

  @override
  String get serviceApplianceRepair => 'Appliance Repair';

  @override
  String get serviceCarpentry => 'Carpentry';

  @override
  String get servicePainting => 'Painting';

  @override
  String get serviceCleaning => 'Cleaning';

  @override
  String get servicePestControl => 'Pest Control';

  @override
  String get serviceOtherHome => 'Other Home Services';

  @override
  String get commonSeeAll => 'See all';

  @override
  String distanceKm(Object km) {
    return '$km km';
  }

  @override
  String get homeRightNow => 'Right now';

  @override
  String get homeNewWork => 'New work';

  @override
  String homeJobsWaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jobs waiting for your answer',
      one: '1 job waiting for your answer',
    );
    return '$_temp0';
  }

  @override
  String get homeComingUp => 'Coming up';

  @override
  String get homeEarnings => 'Earnings';

  @override
  String get homeMyServices => 'My services';

  @override
  String get homeVerification => 'Verification';

  @override
  String get homeSupport => 'Support';

  @override
  String get homeRequests => 'Requests';

  @override
  String get homeMyOffers => 'My offers';

  @override
  String get homeAddService => 'Add a service';

  @override
  String get homeAddServiceBody =>
      'Customers can only book you for services you have published.';

  @override
  String get homeNotReady => 'Not quite ready';

  @override
  String get homeNotReadyBody =>
      'Finish these steps and you can start receiving jobs.';

  @override
  String get homeGoodMorning => 'Good morning';

  @override
  String get homeGoodAfternoon => 'Good afternoon';

  @override
  String get homeGoodEvening => 'Good evening';

  @override
  String get homeNotifications => 'Notifications';

  @override
  String get availabilityAvailable => 'Available';

  @override
  String get availabilityAvailableBody => 'You can receive new jobs.';

  @override
  String get availabilityOnJob => 'On a job';

  @override
  String get availabilityOnJobBody =>
      'You will not be offered new work until this job is done.';

  @override
  String get availabilityOff => 'Off';

  @override
  String get availabilityOffBody => 'You will not receive new jobs.';

  @override
  String get availabilityFinishJob =>
      'Finish your current job to become available again.';

  @override
  String get availabilityGoOff => 'Go off duty';

  @override
  String get availabilityGoOn => 'Go available';

  @override
  String get availabilityBeforeJobs => 'Before you can receive jobs';

  @override
  String get availabilityNowOn => 'You are available for work.';

  @override
  String get availabilityNowOff => 'You are off duty.';

  @override
  String get workerStatusSetupIncomplete => 'Setup incomplete';

  @override
  String get workerStatusUnderReview => 'Under review';

  @override
  String get workerStatusInactive => 'Inactive';

  @override
  String get workerStatusRestricted => 'Restricted';

  @override
  String get workerStatusSuspended => 'Suspended';

  @override
  String get homeAccount => 'Account';

  @override
  String get homeWorkStatus => 'Work status';

  @override
  String get availabilityOffDuty => 'Off duty';

  @override
  String get earningsThisWeek => 'This week';

  @override
  String get earningsThisMonth => 'This month';

  @override
  String get jobNextWaitConfirm => 'Waiting for the customer to confirm';

  @override
  String get jobNextStartTravel => 'Start travelling';

  @override
  String get jobNextMarkArrived => 'Mark yourself as arrived';

  @override
  String get jobNextStartWork => 'Start the work';

  @override
  String get jobNextAskCode => 'Ask the customer for the arrival code';

  @override
  String get jobNextFinish => 'Finish and add photos';

  @override
  String get jobNextWaitApprove => 'Waiting for the customer to approve';

  @override
  String get jobNextOpen => 'Open job';

  @override
  String get jobTimeTbc => 'Time to be confirmed';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsAbout => 'About';

  @override
  String get settingsTerms => 'Terms of service';

  @override
  String get settingsPrivacy => 'Privacy policy';

  @override
  String get settingsHelp => 'Help and support';

  @override
  String get settingsDeleteAccount => 'Delete my account';

  @override
  String get settingsSignOutTitle => 'Sign out?';

  @override
  String get settingsSignOutBody =>
      'You will need your phone number and a code to sign back in.';

  @override
  String get settingsDeleteTitle => 'Delete your account';

  @override
  String get settingsDeleteBody =>
      'Deleting an account affects your job history, your earnings records and any open payments, so it is handled by our support team rather than automatically.\n\nRaise a support request and we will confirm once it is done.';

  @override
  String get settingsContactSupport => 'Contact support';

  @override
  String get notificationsMarkAllRead => 'Mark all read';

  @override
  String get notificationsEmpty => 'You are all caught up';

  @override
  String get notificationsEmptyBody =>
      'Job offers, payment updates and verification results will appear here.';

  @override
  String get jobsTabUpcoming => 'Upcoming';

  @override
  String get jobsTabActive => 'Active';

  @override
  String get jobsNoOffers => 'No new jobs right now';

  @override
  String get jobsNoOffersBody =>
      'When you are available, we will let you know as soon as a suitable job comes in.';

  @override
  String get jobsAccepted => 'Job accepted.';

  @override
  String get jobsDeclineTitle => 'Decline this job?';

  @override
  String get jobsDeclineBody =>
      'It will be offered to another worker. Declining often may affect how many jobs you are shown.';

  @override
  String get jobsDecline => 'Decline';

  @override
  String get jobsDeclined => 'Job declined.';

  @override
  String get jobsEmptyUpcoming => 'Nothing scheduled';

  @override
  String get jobsEmptyUpcomingBody =>
      'Jobs you have accepted will appear here.';

  @override
  String get jobsEmptyActive => 'No job in progress';

  @override
  String get jobsEmptyActiveBody =>
      'When you start a job it will show up here.';

  @override
  String get jobsEmptyCompleted => 'No completed jobs yet';

  @override
  String get jobsEmptyCompletedBody =>
      'Finished jobs and what you earned from them will be listed here.';

  @override
  String get jobsEmptyCancelled => 'Nothing cancelled';

  @override
  String get jobsEmptyCancelledBody => 'Cancelled jobs will be listed here.';

  @override
  String get jobsEmptyOffers => 'No offers';

  @override
  String get jobsEmptyOffersBody => 'New jobs will appear here.';

  @override
  String get jobTitleFallback => 'Job';

  @override
  String jobCancelledReason(Object reason) {
    return 'Cancelled: $reason';
  }

  @override
  String get jobAmount => 'Job amount';

  @override
  String get jobMaterials => 'Materials';

  @override
  String get jobYouEarned => 'You earned';

  @override
  String get jobRateCustomer => 'Rate the customer';

  @override
  String get jobRateQuestion => 'How was this job for you?';

  @override
  String get jobRate => 'Rate';

  @override
  String get jobHistory => 'What happened';

  @override
  String get jobHistoryLoadFailed => 'The job history could not be loaded.';
}
