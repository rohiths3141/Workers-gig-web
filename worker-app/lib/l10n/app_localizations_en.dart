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

  @override
  String get jobOfferExpired => 'This job is no longer available.';

  @override
  String get jobOfferNewBadge => 'NEW JOB';

  @override
  String get jobOfferYouEarn => 'You earn';

  @override
  String get jobOfferPriceAfterVisit => 'Confirmed after the visit';

  @override
  String get jobOfferAccept => 'Accept job';

  @override
  String get activeJobTitle => 'Current job';

  @override
  String get activeJobEmptyBody =>
      'When you accept and start a job it will appear here.';

  @override
  String get evidenceBeforeTitle => 'Before you start';

  @override
  String get evidenceBeforeBody =>
      'Photograph the problem before you touch it. This protects you if the customer disputes the work later.';

  @override
  String get evidenceAfterTitle => 'After you finish';

  @override
  String get evidenceAfterBody =>
      'A photo of the finished work is your evidence if the customer disputes it later. Optional, but worth the ten seconds.';

  @override
  String get jobCustomerHidden => 'Customer details are shared once confirmed';

  @override
  String get jobCall => 'Call';

  @override
  String get jobDirections => 'Directions';

  @override
  String get jobTrackOnMap => 'Track on map';

  @override
  String get trailAccepted => 'Accepted';

  @override
  String get trailOnTheWay => 'On the way';

  @override
  String get trailArrived => 'Arrived';

  @override
  String get trailArrivalConfirmed => 'Arrival confirmed';

  @override
  String get trailWorkStarted => 'Work started';

  @override
  String get trailFinished => 'Finished';

  @override
  String get jobProgress => 'Progress';

  @override
  String get jobBeforeFinish => 'Before you can finish';

  @override
  String get jobActionStartTravel => 'Start travelling';

  @override
  String get jobActionArrived => 'I have arrived';

  @override
  String get jobActionEnterCode => 'Enter arrival code';

  @override
  String get jobActionStartWork => 'Start work';

  @override
  String get jobActionFinish => 'Finish job';

  @override
  String get jobArrivalConfirmed => 'Arrival confirmed.';

  @override
  String get jobFinishTitle => 'Finish this job?';

  @override
  String get jobFinishBody =>
      'The customer will be asked to approve the work. You will not be able to add photos afterwards.';

  @override
  String get jobOnYourWay => 'On your way.';

  @override
  String get jobMarkedArrived => 'Marked as arrived.';

  @override
  String get jobWorkStarted => 'Work started.';

  @override
  String get jobSentForApproval => 'Sent to the customer for approval.';

  @override
  String get jobUpdated => 'Updated.';

  @override
  String get jobWaitConfirm =>
      'Waiting for the customer to confirm the booking.';

  @override
  String get jobWaitApprove => 'Waiting for the customer to approve your work.';

  @override
  String get jobWaitPaymentProcessing =>
      'Approved. Payment is being processed.';

  @override
  String get jobWaitPayment => 'Waiting for the customer\'s payment.';

  @override
  String get jobWaitPaid => 'Paid. Your earnings will appear in your wallet.';

  @override
  String get jobWaitDisputed =>
      'This job is under review by our team. We will be in touch.';

  @override
  String get jobWaitNothing => 'Nothing to do right now.';

  @override
  String get travelRouteUnavailable => 'Route unavailable';

  @override
  String get travelNoDestination => 'No destination set';

  @override
  String get travelNoDestinationBody =>
      'This job has no service location to route to.';

  @override
  String get travelJobLocation => 'Job location';

  @override
  String get travelYou => 'You';

  @override
  String get travelCustomer => 'Customer';

  @override
  String get travelCalculating => 'Calculating route...';

  @override
  String distanceMetres(Object metres) {
    return '$metres m';
  }

  @override
  String etaMinutes(Object minutes) {
    return '$minutes min';
  }

  @override
  String etaHours(Object hours) {
    return '$hours hr';
  }

  @override
  String get arrivalWrongCode => 'That code is not correct.';

  @override
  String arrivalWrongCodeAttempts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'That code is not correct. $count attempts left.',
      one: 'That code is not correct. 1 attempt left.',
    );
    return '$_temp0';
  }

  @override
  String get arrivalTitle => 'Confirm you have arrived';

  @override
  String get arrivalBody =>
      'Ask the customer to read out the code from their app, then type it here.';

  @override
  String get arrivalLocked =>
      'Too many incorrect codes. Please contact support to continue this job.';

  @override
  String get arrivalConfirm => 'Confirm arrival';

  @override
  String get arrivalNotYet => 'Not yet';

  @override
  String get rateThanks => 'Thank you for the feedback.';

  @override
  String get rateTitle => 'How was this customer?';

  @override
  String get rateBody =>
      'Your rating is private and helps us look after workers.';

  @override
  String get rateCommentLabel => 'Anything to add? (optional)';

  @override
  String get rateSubmit => 'Submit rating';

  @override
  String get timerServiceTime => 'Service time';

  @override
  String get materialsAdd => 'Add';

  @override
  String get materialsLoadFailed => 'Materials could not be loaded.';

  @override
  String get materialsEmpty =>
      'If you need parts for this job, add them here and the customer will be asked to approve the cost.';

  @override
  String get materialStatusWaiting => 'WAITING FOR CUSTOMER';

  @override
  String get materialStatusApproved => 'APPROVED';

  @override
  String get materialStatusDeclined => 'DECLINED';

  @override
  String get materialStatusBought => 'BOUGHT';

  @override
  String get materialStatusCostRecorded => 'COST RECORDED';

  @override
  String get materialStatusBilled => 'ON THE BILL';

  @override
  String get materialStatusCancelled => 'CANCELLED';

  @override
  String materialQuantityEstimated(Object quantity, Object unit) {
    return '$quantity $unit · estimated';
  }

  @override
  String materialQuantityActual(Object quantity, Object unit) {
    return '$quantity $unit · actual';
  }

  @override
  String get materialRecordCost => 'Record cost';

  @override
  String materialCustomerSaid(Object reason) {
    return 'Customer said: $reason';
  }

  @override
  String get materialUnitPiece => 'piece';

  @override
  String get materialWhatNeeded => 'What do you need?';

  @override
  String get materialEnterQuantity => 'Enter how many';

  @override
  String get materialEnterCost => 'Enter the expected cost';

  @override
  String get materialRequestBody =>
      'The customer will be asked to approve this before you buy it.';

  @override
  String get materialName => 'Material';

  @override
  String get materialNameHint => 'e.g. 16A modular switch';

  @override
  String get materialQuantity => 'Quantity';

  @override
  String get materialUnit => 'Unit';

  @override
  String get materialExpectedCost => 'Expected cost';

  @override
  String get materialAskCustomer => 'Ask the customer';

  @override
  String get materialEnterPaid => 'Enter the amount you paid';

  @override
  String get materialCostRecorded => 'Cost recorded.';

  @override
  String get materialWhatCost => 'What did it cost?';

  @override
  String get materialReceiptBody =>
      'Attach the receipt so this can be added to the customer\'s bill.';

  @override
  String get materialAmountPaid => 'Amount paid';

  @override
  String get materialReceipt => 'Receipt';

  @override
  String get materialReceiptRequired => 'A photo of the bill is required.';

  @override
  String get evidenceDone => 'DONE';

  @override
  String get evidenceRequired => 'REQUIRED';

  @override
  String get evidenceCamera => 'Camera';

  @override
  String get evidenceGallery => 'Gallery';

  @override
  String get evidenceSaved => 'Saved';

  @override
  String get uploadWaiting => 'Waiting';

  @override
  String get uploadPreparing => 'Preparing';

  @override
  String get uploadStarting => 'Starting upload';

  @override
  String uploadPercent(Object percent) {
    return '$percent%';
  }

  @override
  String get uploadFinishing => 'Finishing';

  @override
  String get uploadCancel => 'Cancel upload';

  @override
  String get uploadNotFinished => 'That upload did not finish.';

  @override
  String get commonRetry => 'Retry';

  @override
  String durationMinutes(Object minutes) {
    return '$minutes min';
  }

  @override
  String durationHours(Object hours) {
    return '$hours hr';
  }

  @override
  String durationHoursMinutes(Object hours, Object minutes) {
    return '$hours hr $minutes min';
  }

  @override
  String durationDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String pricePerHour(Object price) {
    return '$price/hr';
  }

  @override
  String pricePerDay(Object price) {
    return '$price/day';
  }

  @override
  String pricePerUnit(Object price) {
    return '$price/unit';
  }

  @override
  String pricePerSqft(Object price) {
    return '$price/sq ft';
  }

  @override
  String get gigsTitle => 'My services';

  @override
  String get gigsAddTooltip => 'Add a service';

  @override
  String get gigsAdd => 'Add service';

  @override
  String get gigsEmpty => 'No services yet';

  @override
  String get gigsEmptyBody =>
      'Add the services you offer. You can add as many as you like, across every trade you are approved for.';

  @override
  String get gigsNoneLive =>
      'None of your services are live, so customers cannot book you.';

  @override
  String gigsLiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count services are live.',
      one: '1 service is live.',
    );
    return '$_temp0';
  }

  @override
  String get gigsAvailable => 'You are available for work.';

  @override
  String get gigsOffDuty =>
      'You are off duty, so you will not be offered jobs.';

  @override
  String gigJobsDone(int count) {
    return '$count done';
  }

  @override
  String get gigEdit => 'Edit';

  @override
  String get gigPause => 'Pause';

  @override
  String get gigResume => 'Resume';

  @override
  String get gigInReview => 'In review';

  @override
  String get gigDraftHint => 'Draft — submit it for review';

  @override
  String get gigRejectedHint => 'Rejected — edit and resubmit';

  @override
  String get gigArchived => 'Archived';

  @override
  String get gigNotLive => 'Not live';

  @override
  String get gigPaused => 'Paused. You will not be offered these jobs.';

  @override
  String get gigLiveAgain => 'Live again.';

  @override
  String get gigDuration30m => '30 minutes';

  @override
  String get gigDuration45m => '45 minutes';

  @override
  String get gigDuration1h => '1 hour';

  @override
  String get gigDuration2h => '2 hours';

  @override
  String get gigDuration4h => '4 hours';

  @override
  String get gigDuration8h => '8 hours (a working day)';

  @override
  String get gigDuration24h => '24 hours';

  @override
  String get gigDuration2d => '2 days';

  @override
  String get gigDuration3d => '3 days';

  @override
  String get gigDuration1w => '1 week';

  @override
  String get gigSavedDraft => 'Saved as a draft.';

  @override
  String get gigSubmitted => 'Submitted. We will review it and let you know.';

  @override
  String get gigLive => 'Your service is live.';

  @override
  String get gigSaved => 'Saved.';

  @override
  String get gigEditorAddTitle => 'Add a service';

  @override
  String get gigEditorEditTitle => 'Edit service';

  @override
  String get gigNoTrades => 'No approved trades yet';

  @override
  String get gigNoTradesBody =>
      'Once a trade is approved for you, you can publish services under it. Add a trade from your profile to get started.';

  @override
  String get gigFieldTrade => 'Which trade?';

  @override
  String get gigFieldTitle => 'What is the service called?';

  @override
  String get gigFieldTitleHint => 'Customers see this. Be specific.';

  @override
  String get gigFieldTitleExample => 'e.g. Split AC deep cleaning';

  @override
  String get gigFieldDescription => 'What does it include?';

  @override
  String get gigFieldDescriptionHint =>
      'Optional, but it helps customers choose you.';

  @override
  String get gigFieldDescriptionExample =>
      'e.g. Full indoor and outdoor unit clean, filter wash, gas pressure check.';

  @override
  String get gigFieldPrice => 'What do you charge?';

  @override
  String get gigFieldPriceHint =>
      'Each service has its own price. This one does not affect your others.';

  @override
  String get gigUnitPerJob => 'per job';

  @override
  String get gigUnitPerHour => 'per hour';

  @override
  String get gigUnitPerDay => 'per day';

  @override
  String get gigUnitPerUnit => 'per unit';

  @override
  String get gigUnitPerSqft => 'per sq ft';

  @override
  String get gigFieldDuration => 'How long does it usually take?';

  @override
  String get gigFieldRadius => 'How far will you travel for this?';

  @override
  String get gigFieldRadiusHint =>
      'Leave as default to use your usual travel distance.';

  @override
  String get gigUsualDistance => 'Your usual distance';

  @override
  String get gigUseUsualDistance => 'Use my usual distance';

  @override
  String get gigReviewNotice =>
      'New and edited services are checked by our team before they go live. We will let you know as soon as it is done.';

  @override
  String get gigSaveDraft => 'Save draft';

  @override
  String get gigSubmitForReview => 'Submit for review';

  @override
  String get walletAllTransactions => 'All transactions';

  @override
  String get walletFrozen =>
      'Withdrawals are on hold while we look into something. Contact support for details.';

  @override
  String get walletWithdraw => 'Withdraw';

  @override
  String walletNothingPending(Object amount) {
    return 'Nothing to withdraw yet. $amount is still being processed and moves to your balance once those jobs are approved.';
  }

  @override
  String get walletNothingYet =>
      'Nothing to withdraw yet. Your earnings appear here once a customer approves a finished job.';

  @override
  String get walletRecentEarnings => 'Recent earnings';

  @override
  String get walletNoEarnings => 'No earnings yet';

  @override
  String get walletNoEarningsBody =>
      'Your earnings will appear here once a completed job has been paid for.';

  @override
  String get walletAvailable => 'Available to withdraw';

  @override
  String get walletProcessing => 'Being processed';

  @override
  String get walletProcessingHint => 'Released after the holding period';

  @override
  String get walletTotalEarned => 'Earned in total';

  @override
  String get statementTitle => 'Statement';

  @override
  String get statementTabTransactions => 'Transactions';

  @override
  String get statementTabWithdrawals => 'Withdrawals';

  @override
  String get statementEmpty => 'Nothing yet';

  @override
  String get statementEmptyBody =>
      'Every payment, fee and withdrawal will be listed here once you start working.';

  @override
  String statementBalance(Object amount) {
    return 'Bal $amount';
  }

  @override
  String get statementNoWithdrawals => 'No withdrawals yet';

  @override
  String get statementNoWithdrawalsBody =>
      'When you withdraw money it will be tracked here.';

  @override
  String payoutRequestedAt(Object date) {
    return 'Requested $date';
  }

  @override
  String payoutPaidAt(Object date) {
    return 'Paid $date';
  }

  @override
  String get payoutEnterAmount => 'Enter how much you want to withdraw';

  @override
  String payoutUpTo(Object amount) {
    return 'You can withdraw up to $amount right now';
  }

  @override
  String payoutMinimum(Object amount) {
    return 'The smallest withdrawal is $amount';
  }

  @override
  String payoutRequested(Object amount) {
    return 'Withdrawal of $amount requested. We will update you as it is processed.';
  }

  @override
  String get payoutAvailableNow => 'Available now';

  @override
  String payoutPendingMore(Object amount) {
    return '$amount more is still being processed and cannot be withdrawn yet.';
  }

  @override
  String get payoutHowMuch => 'How much?';

  @override
  String get payoutAll => 'All';

  @override
  String payoutPercent(Object percent) {
    return '$percent%';
  }

  @override
  String get payoutProcessNotice =>
      'Withdrawals are checked and then sent to your registered bank account. You will see the status update here at every step.';

  @override
  String get payoutRequest => 'Request withdrawal';

  @override
  String get bankChecking => 'Checking your bank account…';

  @override
  String bankPaidTo(Object last4) {
    return 'Paid to account ending $last4';
  }

  @override
  String get bankVerifiedFallback => 'Your verified bank account';

  @override
  String get bankBeingVerified => 'Bank account being verified';

  @override
  String get bankBeingVerifiedBody =>
      'You can withdraw once our team has verified it.';

  @override
  String get bankNotVerified => 'Bank account not verified';

  @override
  String get bankNotVerifiedBody => 'Check your details and submit them again.';

  @override
  String get bankAddTitle => 'Add a bank account';

  @override
  String get bankAddBody =>
      'Withdrawals are paid to a bank account our team has verified.';

  @override
  String get bankAddAction => 'Add bank account';

  @override
  String get verificationTitle => 'Verification';

  @override
  String get verificationProgress => 'Verified checks';

  @override
  String verificationCount(int approved, int total) {
    return '$approved of $total';
  }

  @override
  String get verificationInsurance => 'Insurance';

  @override
  String get verificationNoCover => 'No active cover';

  @override
  String get verificationNoCoverBody =>
      'You do not currently have an insurance policy on file with us.';

  @override
  String get verifyIdentity => 'Identity';

  @override
  String get verifyIdentityBody =>
      'A government ID so customers know who is coming to their home.';

  @override
  String get verifyAddress => 'Address';

  @override
  String get verifyAddressBody => 'Proof of where you live.';

  @override
  String get verifyIti => 'ITI certificate';

  @override
  String get verifyItiBody =>
      'Your trade certificate from an Industrial Training Institute.';

  @override
  String get verifyDiploma => 'Diploma';

  @override
  String get verifyDiplomaBody => 'A recognised technical diploma.';

  @override
  String get verifyRpl => 'Skill assessment';

  @override
  String get verifyRplBody =>
      'Recognition of Prior Learning: your experience assessed and certified.';

  @override
  String get verifyBackground => 'Background check';

  @override
  String get verifyBackgroundBody =>
      'We run this ourselves. You do not need to do anything.';

  @override
  String get verifyInsuranceBody =>
      'Cover for accidental damage while you work. Our team adds your policy once it is arranged.';

  @override
  String get verifyBank => 'Bank account';

  @override
  String get verifyBankBody => 'Where your withdrawals are paid.';

  @override
  String verificationValidUntil(Object date) {
    return 'Valid until $date';
  }

  @override
  String get verificationStart => 'Start';

  @override
  String get verificationUpdate => 'Update';

  @override
  String get policyActive => 'ACTIVE';

  @override
  String get policyNotActive => 'NOT ACTIVE';

  @override
  String get policyNumber => 'Policy';

  @override
  String get policyCover => 'Cover';

  @override
  String get policyValidUntil => 'Valid until';

  @override
  String get kycStillWaiting =>
      'Still waiting on DigiLocker. You can check back from here later.';

  @override
  String get kycTitle => 'Identity check';

  @override
  String get kycHeadline => 'Confirm who you are';

  @override
  String get kycIntro =>
      'Customers let you into their homes, so we verify every worker\'s identity through DigiLocker, the Government of India\'s document platform. Nothing is uploaded — you just approve the request on your own Aadhaar account.';

  @override
  String get kycPrivacy =>
      'Your Aadhaar details are confirmed directly with DigiLocker. We store only what proves the check happened — never your photo or a copy of your Aadhaar.';

  @override
  String get kycVerified => 'Your identity is verified.';

  @override
  String get kycAwaitingConsent =>
      'Complete the DigiLocker consent in your browser, then come back here.';

  @override
  String get kycChecking => 'Checking with DigiLocker…';

  @override
  String get kycStart => 'Verify with DigiLocker';

  @override
  String get qualSubmitted => 'Submitted for review.';

  @override
  String get qualTitle => 'Your qualification';

  @override
  String get qualIti => 'ITI';

  @override
  String get qualInstitute => 'Institute';

  @override
  String get qualInstituteHint => 'e.g. Government ITI, Coimbatore';

  @override
  String get qualName => 'Qualification';

  @override
  String get qualNameHint => 'e.g. Electrician';

  @override
  String get qualSpeciality => 'Speciality (optional)';

  @override
  String get qualSpecialityHint => 'e.g. Industrial wiring';

  @override
  String get qualYear => 'Year completed';

  @override
  String get qualCertificate => 'Your certificate';

  @override
  String get qualCertificateBody => 'A clear photo or PDF of the certificate.';

  @override
  String get bankErrorHolder =>
      'Enter the name exactly as it appears on the account';

  @override
  String get bankErrorNumber => 'An account number is 9 to 18 digits';

  @override
  String get bankErrorMismatch => 'The account numbers do not match';

  @override
  String get bankErrorIfsc => 'Enter the 11-character IFSC, e.g. SBIN0001234';

  @override
  String get bankSent => 'Bank account sent for verification.';

  @override
  String get bankNotice =>
      'Your withdrawals are paid to this account. Our team verifies it before the first payout.';

  @override
  String get bankHolder => 'Account holder name';

  @override
  String get bankNumber => 'Account number';

  @override
  String get bankConfirmNumber => 'Re-enter account number';

  @override
  String get bankIfsc => 'IFSC code';

  @override
  String get bankIfscHint => 'e.g. SBIN0001234';

  @override
  String get bankName => 'Bank name (optional)';

  @override
  String get bankSubmit => 'Submit for verification';

  @override
  String get profileCompleteness => 'Profile completeness';

  @override
  String get profileCompletenessBody =>
      'A complete profile helps customers choose you.';

  @override
  String get profileJobsDone => 'Jobs done';

  @override
  String get profileRating => 'Rating';

  @override
  String get profileExperience => 'Experience';

  @override
  String profileExperienceYears(Object years) {
    return '$years yr';
  }

  @override
  String get profileEdit => 'Edit profile';

  @override
  String get profileVerified => 'VERIFIED';

  @override
  String get profileNotVerified => 'NOT VERIFIED';

  @override
  String get profilePinInvalid => 'Enter a valid 6-digit PIN code';

  @override
  String get profileUpdated => 'Profile updated.';

  @override
  String get profilePhotoUpdated => 'Photo updated.';

  @override
  String get profileChangePhoto => 'Change photo';

  @override
  String get profileName => 'Name';

  @override
  String get profilePhone => 'Phone';

  @override
  String get profileLockedNotice =>
      'Your name and number are linked to your identity check. Contact support if either needs to change.';

  @override
  String get profileAbout => 'About you';

  @override
  String get profileBioHint =>
      'Tell customers about your experience and what you are good at.';

  @override
  String get profileYearsExperience => 'Years of experience';

  @override
  String get profileBased => 'Where you are based';

  @override
  String get profileAddress => 'Address';

  @override
  String get profileCity => 'City';

  @override
  String get profilePin => 'PIN code';

  @override
  String get profileGender => 'Gender';

  @override
  String get genderMale => 'Male';

  @override
  String get genderFemale => 'Female';

  @override
  String get genderOther => 'Other';

  @override
  String get profileTrades => 'Your trades';

  @override
  String get profileTradesBody =>
      'You can work in as many trades as you are approved for.';

  @override
  String get profileTradesLoadFailed => 'Your trades could not be loaded.';

  @override
  String get tradePending => 'PENDING';

  @override
  String get profileAddTrade => 'Add a trade';

  @override
  String get profileAddTradeBody =>
      'We may ask for proof of your skills before approving it.';

  @override
  String get profileTradeRequested =>
      'Requested. We will let you know once it is approved.';

  @override
  String get profileSave => 'Save changes';

  @override
  String get supportNewRequest => 'New request';

  @override
  String get supportEmpty => 'No requests yet';

  @override
  String get supportEmptyBody =>
      'If something goes wrong with a job, a payment or your account, raise a request and we will help.';

  @override
  String get supportYourRequests => 'Your requests';

  @override
  String get supportEmergency => 'In an emergency';

  @override
  String get supportEmergencyBody =>
      'This app cannot call for help on your behalf. If you are in danger, call the emergency services directly.';

  @override
  String get supportCall112 => 'Call 112';

  @override
  String get supportPolice => 'Police';

  @override
  String get ticketOpen => 'OPEN';

  @override
  String get ticketInProgress => 'IN PROGRESS';

  @override
  String get ticketReplyNeeded => 'YOUR REPLY NEEDED';

  @override
  String get ticketResolved => 'RESOLVED';

  @override
  String get ticketClosed => 'CLOSED';

  @override
  String ticketLastUpdate(Object date) {
    return 'Last update $date';
  }

  @override
  String get supportCategoryJob => 'A job';

  @override
  String get supportCategoryPayment => 'A payment';

  @override
  String get supportCategoryWithdrawal => 'A withdrawal';

  @override
  String get supportCategoryAccount => 'My account';

  @override
  String get supportCategorySafety => 'Safety';

  @override
  String get supportCategoryApp => 'The app';

  @override
  String get supportCategoryOther => 'Something else';

  @override
  String supportRaised(Object code) {
    return 'Request $code raised.';
  }

  @override
  String get supportHowHelp => 'How can we help?';

  @override
  String get supportAbout => 'What is it about?';

  @override
  String get supportSubject => 'Subject';

  @override
  String get supportSubjectHint => 'A few words about the problem';

  @override
  String get supportWhatHappened => 'What happened?';

  @override
  String get supportSend => 'Send request';

  @override
  String get ticketTitle => 'Support request';

  @override
  String get ticketNoMessages => 'No messages yet';

  @override
  String get ticketNoMessagesBody => 'Your conversation will appear here.';

  @override
  String get ticketWriteMessage => 'Write a message';

  @override
  String get ticketSupportName => 'Wervexa support';

  @override
  String get requestsTitle => 'Customer requests';

  @override
  String get requestsRefresh => 'Refresh';

  @override
  String get requestsLocationNeeded => 'Location needed';

  @override
  String get requestsLocationBody =>
      'We use your location to find customer requests near you.';

  @override
  String get requestsGrantLocation => 'Grant Location Access';

  @override
  String get requestsEmpty => 'No matching requests nearby';

  @override
  String get requestsEmptyBody =>
      'New customer requests will appear here\nwhen they match your services.';

  @override
  String get requestsViewOffer => 'View & Offer →';

  @override
  String get requestEnterPrice => 'Enter a valid price';

  @override
  String requestOfferSubmitted(Object price) {
    return 'Offer submitted at $price!';
  }

  @override
  String get requestDetailsTitle => 'Request Details';

  @override
  String get requestStatusOpen => 'Open';

  @override
  String get requestCategory => 'Category';

  @override
  String get requestBudget => 'Budget';

  @override
  String get requestSchedule => 'Schedule';

  @override
  String get requestDistance => 'Distance';

  @override
  String get requestArea => 'Area';

  @override
  String get requestOffers => 'Offers';

  @override
  String get requestNotes => 'Notes';

  @override
  String get requestAddressPrivacy =>
      'The customer\'s exact address is shared only after they accept your offer.';

  @override
  String get requestYourOffer => 'Your Offer';

  @override
  String get requestYourPrice => 'Your price (₹)';

  @override
  String get requestPriceHint => 'e.g. 500';

  @override
  String get requestDuration => 'Estimated duration (optional)';

  @override
  String get requestDurationHint => 'e.g. 1-2 hours';

  @override
  String get requestMessage => 'Message to customer (optional)';

  @override
  String get requestMessageHint => 'Why are you the right person for this job?';

  @override
  String get requestSubmitOffer => 'Submit Offer';

  @override
  String get requestMakeOffer => 'Make an Offer';

  @override
  String get requestAlreadyOffered =>
      'You\'ve already submitted an offer for this request.';

  @override
  String get requestViewOffers => 'View Offers';

  @override
  String get offersEmptyBody =>
      'Offers you submit on customer requests\nwill appear here.';

  @override
  String get offerWithdraw => 'Withdraw';

  @override
  String get offerWithdrawTitle => 'Withdraw offer?';

  @override
  String get offerWithdrawBody => 'The customer will no longer see this offer.';

  @override
  String get offerWithdrawn => 'Offer withdrawn';

  @override
  String get onboardingTitle => 'Set up your profile';

  @override
  String get onboardingHelp => 'Help';

  @override
  String onboardingHello(Object name) {
    return 'Hello, $name';
  }

  @override
  String get onboardingIntro =>
      'A few things and you are ready to start getting work.';

  @override
  String get onboardingSetup => 'Setup';

  @override
  String onboardingStepCount(int done, int total) {
    return '$done of $total';
  }

  @override
  String get onboardingBasicBody =>
      'Your city and PIN code, so we can find work near you.';

  @override
  String get onboardingTradeBody => 'The trade you mainly work in.';

  @override
  String get onboardingSkillsDoneBody =>
      'Your main trade counts as one. Open this to add every other trade you work in.';

  @override
  String get onboardingSkillsBody =>
      'Add every trade you work in. You are not limited to one.';

  @override
  String get onboardingAreaBody =>
      'How far you are willing to travel for a job.';

  @override
  String get onboardingKycBody =>
      'A government ID. Customers are letting you into their homes.';

  @override
  String get onboardingReviewNotice =>
      'Once you have finished these, our team checks your documents. You can carry on setting up your services while you wait.';

  @override
  String get onboardingTradesLoadFailed =>
      'Trades could not be loaded. Try again.';

  @override
  String get onboardingMainTrade => 'What is your main trade?';

  @override
  String get onboardingMainTradeBody => 'You can add more trades afterwards.';

  @override
  String onboardingTradeSet(Object trade) {
    return '$trade set as your main trade.';
  }

  @override
  String get onboardingTravelTitle => 'How far will you travel?';

  @override
  String get onboardingTravelBody =>
      'We will only offer you jobs within this distance of where you are right now.';

  @override
  String get onboardingTravelCentre =>
      'We use your current location as the centre point. You can change this any time from your profile.';

  @override
  String get onboardingLocationOff =>
      'Turn on location access to set your work area.';

  @override
  String get commonSave => 'Save';

  @override
  String get notificationsStayOff =>
      'Notifications stay off. You can turn them on in your phone settings.';

  @override
  String get notificationsPrimerTitle => 'Get told when a job comes in';

  @override
  String get notificationsPrimerBody =>
      'Job offers expire. A notification is how you hear about one while the app is closed — nothing else is sent.';

  @override
  String get notificationsTurnOn => 'Turn on notifications';

  @override
  String get commonNotNow => 'Not now';

  @override
  String get onboardingCityRequired => 'Please enter your city';

  @override
  String get onboardingGenderRequired => 'Please select your gender';

  @override
  String get onboardingWhereBased => 'Where are you based?';
}
