// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonTryAgain => 'Try again';

  @override
  String get commonSignOut => 'Sign out';

  @override
  String get assistantFabLabel => 'Ask AI';

  @override
  String get navHome => 'Home';

  @override
  String get navExplore => 'Explore';

  @override
  String get navBookings => 'Bookings';

  @override
  String get navAlerts => 'Alerts';

  @override
  String get navProfile => 'Profile';

  @override
  String get configErrorTitle => 'App not configured';

  @override
  String configErrorBody(String keys, String command) {
    return 'This build is missing $keys. Run with:\n\n$command\n\nso the app can reach the real backend.';
  }

  @override
  String get sessionProfileLoadFailedRetry =>
      'We could not load your profile. Please try again.';

  @override
  String get sessionProfileLoadFailed => 'We could not load your profile';

  @override
  String get sessionCheckClock => 'Check your phone\'s clock';

  @override
  String get splashTagline => 'Home services, done right.';

  @override
  String get timelineBookingConfirmed => 'Booking Confirmed';

  @override
  String get timelineProviderOnTheWay => 'Provider on the way';

  @override
  String get timelineServiceInProgress => 'Service in Progress';

  @override
  String get timelineCompleted => 'Completed';

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
  String get errorSessionEnded =>
      'Your session has ended. Please sign in again.';

  @override
  String get errorUploadFailed => 'That file could not be uploaded. Try again.';

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
  String get authErrorPhoneNotEnabled =>
      'Phone sign-in is not enabled. Contact support.';

  @override
  String get authErrorNumberInUse =>
      'That number is already registered to another account.';

  @override
  String get authErrorSignInAgain => 'Please sign in again to continue.';

  @override
  String get authErrorSignInFailed => 'Sign-in failed. Please try again.';

  @override
  String get languagePickerTitle => 'Choose your language';

  @override
  String get authCouldNotStartVerification =>
      'Could not start verification. Please try again.';

  @override
  String get authWelcomeTitle => 'Welcome to Wervexa';

  @override
  String get authWelcomeSubtitle =>
      'Find top-rated local professionals for home repairs, plumbing, electrical, cleaning & more.';

  @override
  String get authEnterPhone => 'Enter your phone number';

  @override
  String get authInvalidMobile => 'Enter a valid 10-digit mobile number';

  @override
  String get authGetOtp => 'Get OTP Verification';

  @override
  String get authTermsNotice =>
      'By continuing, you agree to our Terms of Service & Privacy Policy';

  @override
  String get authNewCodeSent => 'We sent a new code.';

  @override
  String get authVerifyPhoneTitle => 'Verify phone';

  @override
  String get authChangeNumber => 'Change number';

  @override
  String get authEnterCodeTitle => 'Enter 6-digit code';

  @override
  String authCodeSentTo(Object phone) {
    return 'We sent an SMS verification code to $phone';
  }

  @override
  String get authWrongNumber => 'Wrong number? Change it';

  @override
  String get authEnterSixDigits => 'Please enter 6 digits';

  @override
  String get authResendCode => 'Resend code';

  @override
  String authResendCodeIn(Object seconds) {
    return 'Resend code in ${seconds}s';
  }

  @override
  String get authVerifyAndContinue => 'Verify & Continue';

  @override
  String get registerTitle => 'Complete Profile';

  @override
  String get registerHeading => 'Tell us your name';

  @override
  String get registerNameVisibility =>
      'Your name will be visible to service workers when you make a booking request.';

  @override
  String get registerFullNameLabel => 'Full Name *';

  @override
  String get registerFullNameHint => 'e.g. Rahul Sharma';

  @override
  String get registerFullNameRequired => 'Please enter your full name';

  @override
  String get registerEmailLabel => 'Email Address (Optional)';

  @override
  String get registerEmailHint => 'e.g. rahul@example.com';

  @override
  String get registerSubmit => 'Save & Get Started';

  @override
  String get bookingStatusRequested => 'Finding a professional…';

  @override
  String get bookingStatusAccepted => 'Professional found';

  @override
  String get bookingStatusConfirmed => 'Confirmed';

  @override
  String get bookingStatusTraveling => 'On the way';

  @override
  String get bookingStatusArrived => 'Arrived — enter your code';

  @override
  String get bookingStatusInProgress => 'Work in progress';

  @override
  String get bookingStatusAwaitingApproval => 'Work done — approve to proceed';

  @override
  String get bookingStatusCompleted => 'Completed';

  @override
  String get bookingStatusPaymentPending => 'Payment pending';

  @override
  String get bookingStatusPaid => 'Paid';

  @override
  String get bookingStatusClosed => 'Closed';

  @override
  String get bookingStatusCancelled => 'Cancelled';

  @override
  String get bookingStatusDisputed => 'Disputed';

  @override
  String get bookingStatusExpired => 'Expired — no one was available';

  @override
  String get pricingPerJob => 'per job';

  @override
  String get pricingPerHour => 'per hour';

  @override
  String get pricingPerDay => 'per day';

  @override
  String get pricingPerUnit => 'per unit';

  @override
  String get pricingPerSqft => 'per sq ft';

  @override
  String get supportCategoryBooking => 'Booking issue';

  @override
  String get supportCategoryPayment => 'Payment';

  @override
  String get supportCategoryPayout => 'Payout';

  @override
  String get supportCategoryVerification => 'Verification';

  @override
  String get supportCategoryAccount => 'My account';

  @override
  String get supportCategorySafety => 'Safety concern';

  @override
  String get supportCategoryClaim => 'Insurance claim';

  @override
  String get supportCategoryAppIssue => 'App problem';

  @override
  String get supportCategoryOther => 'Other';

  @override
  String get requestStatusDraft => 'Draft';

  @override
  String get requestStatusOpen => 'Open — waiting for offers';

  @override
  String get requestStatusReceivingOffers => 'Receiving offers';

  @override
  String get requestStatusWorkerSelected => 'Professional selected';

  @override
  String get requestStatusBooked => 'Booked';

  @override
  String get requestStatusCancelled => 'Cancelled';

  @override
  String get requestStatusExpired => 'Expired';

  @override
  String get requestStatusClosed => 'Closed';

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
  String get scheduleSpecificDate => 'On a specific date';

  @override
  String get scheduleScheduled => 'Scheduled';

  @override
  String get offerStatusSubmitted => 'New offer';

  @override
  String get offerStatusViewed => 'Viewed';

  @override
  String get offerStatusShortlisted => 'Shortlisted';

  @override
  String get offerStatusAccepted => 'Accepted';

  @override
  String get offerStatusRejected => 'Rejected';

  @override
  String get offerStatusWithdrawn => 'Withdrawn by worker';

  @override
  String get offerStatusExpired => 'Expired';

  @override
  String get offerStatusClosed => 'Closed';

  @override
  String get gigRatingNew => 'New';

  @override
  String distanceMetres(Object metres) {
    return '$metres m';
  }

  @override
  String distanceKm(Object km) {
    return '$km km';
  }

  @override
  String durationMinutes(Object minutes) {
    return '$minutes min';
  }

  @override
  String durationHours(Object hours) {
    return '$hours hr';
  }

  @override
  String durationHoursMinutes(int hours, int minutes) {
    return '$hours hr $minutes min';
  }

  @override
  String get offerWorkerFallbackName => 'Professional';

  @override
  String get budgetFlexible => 'Flexible budget';

  @override
  String get budgetFixed => 'Fixed budget';

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
  String get paymentsNotConfigured =>
      'Payments are not configured for this build yet.';

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
  String get addressLabelHome => 'Home';

  @override
  String get addressLabelWork => 'Work';

  @override
  String get addressLabelOther => 'Other';

  @override
  String get commonSeeAll => 'See All';

  @override
  String get commonViewAll => 'View All';

  @override
  String get commonCheckBackLater => 'Please check back later.';

  @override
  String get commonUseCurrentLocation => 'Use current location';

  @override
  String get commonChooseOnMap => 'Choose on map';

  @override
  String homeGreetingNamed(Object name) {
    return 'Hello, $name 👋';
  }

  @override
  String get homeGreeting => 'Hello 👋';

  @override
  String get homeWhatService => 'What service do you need today?';

  @override
  String get homeSetLocation => 'Set your location';

  @override
  String get homeWorkFinishedApprove => 'Work finished — tap to approve';

  @override
  String get homeCategories => 'Categories';

  @override
  String homeCategoriesLoadFailed(Object error) {
    return 'Failed to load categories: $error';
  }

  @override
  String get homeFindWorker => 'Find a Worker';

  @override
  String get homeFindWorkerSubtitle => 'Browse nearby gigs';

  @override
  String get homePostRequest => 'Post a Request';

  @override
  String get homePostRequestSubtitle => 'Workers come to you';

  @override
  String get homeNoServices => 'No services available right now';

  @override
  String get homeSearchNear => 'Search services near';

  @override
  String get homeSearchHint => 'Search for services...';

  @override
  String homeActiveBooking(Object code) {
    return 'Active Booking #$code';
  }

  @override
  String get homeActiveRequests => 'Your Active Requests';

  @override
  String get commonGrantPermission => 'Grant Permission';

  @override
  String get commonView => 'View';

  @override
  String get exploreTitle => 'Explore & Discover Gigs';

  @override
  String get exploreListView => 'List View';

  @override
  String get exploreMapView => 'Map View';

  @override
  String get exploreSearchHint => 'Search services, workers or skills...';

  @override
  String get exploreLocationOffTitle => 'Location services are off';

  @override
  String get exploreLocationOffMessage =>
      'Turn on location to discover professionals near you.';

  @override
  String get exploreLocationPermissionTitle => 'Location permission needed';

  @override
  String get exploreLocationPermissionMessage =>
      'We use your location to find professionals nearby.';

  @override
  String get exploreChooseService => 'Choose a service to explore';

  @override
  String get exploreChooseServiceMessage =>
      'Select a category above to see nearby professionals.';

  @override
  String get exploreNoProfessionals =>
      'No professionals are available for this service nearby';

  @override
  String get exploreLoadFailed => 'Could not load professionals.';

  @override
  String exploreByWorker(Object name) {
    return 'By $name';
  }

  @override
  String get bookingsTitle => 'My Service Bookings';

  @override
  String get bookingsTabActive => 'Active';

  @override
  String get bookingsTabCompleted => 'Completed';

  @override
  String get bookingsTabCancelled => 'Cancelled';

  @override
  String get bookingsLoadFailed => 'Could not load your bookings.';

  @override
  String get bookingsEmpty => 'No bookings yet';

  @override
  String get bookingsFindService => 'Find a Service';

  @override
  String get bookingsWaitingForProfessional => 'Waiting for professional';

  @override
  String bookingsCode(Object code) {
    return 'Booking Code: #$code';
  }

  @override
  String get bookingsPayNow => 'Pay now';

  @override
  String get bookingsApproveWork => 'Approve work';

  @override
  String get bookingsTrackLive => 'Track Live';

  @override
  String get bookingsDetails => 'Details';

  @override
  String get bookingDetailTitle => 'Booking Details';

  @override
  String get bookingDetailLoadFailed => 'Failed to load booking details.';

  @override
  String get bookingDetailWaitingAccept =>
      'Waiting for the professional to accept';

  @override
  String bookingDetailNumber(Object code) {
    return 'Booking #$code';
  }

  @override
  String bookingDetailStatus(Object status) {
    return 'Status: $status';
  }

  @override
  String get bookingDetailLiveMap => 'Live Map';

  @override
  String get bookingDetailServiceInfo => 'Service Request Info';

  @override
  String get bookingDetailViewMaterials => 'View Material / Parts Requests';

  @override
  String get bookingDetailFareDetails => 'Fare Details';

  @override
  String get bookingDetailEstimatedFare => 'Estimated Fare';

  @override
  String get bookingDetailFinalFare => 'Final Confirmed Fare';

  @override
  String get bookingDetailRateReview => 'Rate & Review Service Worker';

  @override
  String get bookingDetailApproveCompletion => 'Approve Completion';

  @override
  String get bookingDetailApprovePaidHint =>
      'Your professional has marked this job as done. Approving releases your payment to them.';

  @override
  String get bookingDetailApproveUnpaidHint =>
      'Your professional has marked this job as done. Approve to confirm and proceed to payment.';

  @override
  String get bookingDetailReportProblem => 'Report Problem';

  @override
  String get bookingDetailCompletionApproved => 'Completion approved';

  @override
  String bookingDetailPayToConfirm(Object amount) {
    return 'Pay $amount to confirm';
  }

  @override
  String get bookingDetailSentAfterPayment =>
      'Your booking is sent to the professional once payment is complete.';

  @override
  String bookingDetailPayAmount(Object amount) {
    return 'Pay $amount';
  }

  @override
  String get bookingDetailCancelBooking => 'Cancel Booking';

  @override
  String get cancelReasonMistake => 'Booked by mistake';

  @override
  String get cancelReasonNoLongerNeeded => 'I no longer need this service';

  @override
  String get cancelReasonDifferentTime => 'I want to choose a different time';

  @override
  String get cancelReasonFoundSomeoneElse => 'I found someone else';

  @override
  String get cancelDialogTitle => 'Why are you cancelling?';

  @override
  String get cancelDialogRefundNotice =>
      'This cannot be undone. Your payment will be refunded to the original payment method.';

  @override
  String get cancelDialogCannotUndo => 'This cannot be undone.';

  @override
  String get cancelDialogKeepBooking => 'Keep booking';

  @override
  String get bookingCancelledRefund =>
      'Booking cancelled. Your refund has been requested.';

  @override
  String get bookingCancelled => 'Booking cancelled';

  @override
  String get arrivalCodeTitle => 'Arrival Code';

  @override
  String get arrivalCodeShare =>
      'Share this code with your professional to confirm they have arrived:';

  @override
  String get arrivalCodeUnavailable => 'Unavailable';

  @override
  String get arrivalCodeLoadFailed => 'Could not load code';

  @override
  String get activeBookingTitle => 'Live Booking & Worker Tracking';

  @override
  String get activeBookingLoadFailed => 'Failed to load this booking.';

  @override
  String get activeBookingMapUnavailable =>
      'Live map unavailable for this booking.';

  @override
  String get activeBookingViewDetails => 'View Booking Details';

  @override
  String get activeBookingServiceLocation => 'Service location';

  @override
  String get activeBookingYourProfessional => 'Your professional';

  @override
  String get activeBookingLive => 'Live';

  @override
  String get activeBookingLastKnown => 'Last known location';

  @override
  String get activeBookingPhoneNotShared => 'Phone not shared yet';

  @override
  String get activeBookingCallProfessional => 'Call professional';

  @override
  String get activeBookingMaterials => 'Materials';

  @override
  String get activeBookingViewDetailsShort => 'View Details';

  @override
  String get locationConnecting => 'Connecting to live location...';

  @override
  String get locationLiveUnavailable => 'Live location temporarily unavailable';

  @override
  String get locationLiveActive => 'Live location active';

  @override
  String get locationUpdating => 'Updating...';

  @override
  String get locationUnavailable => 'Location temporarily unavailable';

  @override
  String get activeBookingShareStartCode => 'Worker Arrived! Share Start Code:';

  @override
  String get commonBack => 'Back';

  @override
  String get paymentCouldNotOpen =>
      'Could not open the payment screen. Please try again.';

  @override
  String get paymentReceived =>
      'Payment received. Your booking has been sent to the professional.';

  @override
  String paymentNotConfirmed(String reason, String reference) {
    return 'We could not confirm this payment: $reason. If money was deducted, contact support with reference $reference.';
  }

  @override
  String get paymentNotCompleted => 'Payment was not completed.';

  @override
  String paymentExternalWalletUnsupported(Object wallet) {
    return 'Selected an external wallet ($wallet) — not yet supported.';
  }

  @override
  String get paymentTitle => 'Payment';

  @override
  String get paymentStatusUnknown =>
      'We could not check whether this booking has already been paid for. Please try again rather than paying twice.';

  @override
  String get paymentBookingLoadFailed => 'Could not load this booking.';

  @override
  String get paymentComplete => 'Payment complete';

  @override
  String paymentPaidFor(String amount, String service) {
    return '$amount paid for $service.';
  }

  @override
  String get paymentViewBooking => 'View booking';

  @override
  String get paymentBookingSummary => 'Booking Summary';

  @override
  String get paymentProvider => 'Provider';

  @override
  String get paymentService => 'Service';

  @override
  String get paymentDate => 'Date';

  @override
  String get paymentTime => 'Time';

  @override
  String get paymentAddress => 'Address';

  @override
  String get paymentTotal => 'Total';

  @override
  String get paymentHeldSecurely =>
      'Your payment is held securely and released to the professional only after you approve the work. If the booking is cancelled before work starts, you get a refund.';

  @override
  String get commonChange => 'Change';

  @override
  String get bookMissingDetails =>
      'Missing booking details — please start again.';

  @override
  String get bookSlotPassed =>
      'That time has passed. We moved you to the next available slot — check it and confirm again.';

  @override
  String bookFailed(Object reason) {
    return 'Booking failed: $reason';
  }

  @override
  String get bookNoAddress => 'No address selected';

  @override
  String get bookTitle => 'Book a Service';

  @override
  String get bookSelectDate => 'Select Date';

  @override
  String get bookSelectTime => 'Select Time';

  @override
  String get bookSpecialInstructions => 'Special Instructions (Optional)';

  @override
  String get bookSpecialInstructionsHint =>
      'e.g. Focus on kitchen and bathroom...';

  @override
  String get bookConfirm => 'Confirm Booking →';

  @override
  String get gigUnknownProfessional => 'Unknown professional';

  @override
  String get gigNewProfessional => 'New professional';

  @override
  String gigRatingWithCount(String rating, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reviews',
      one: '1 review',
    );
    return '$rating ($_temp0)';
  }

  @override
  String get gigPricing => 'Pricing';

  @override
  String get gigServiceRate => 'Service Rate';

  @override
  String get gigFinalAmountNote =>
      'The final amount is confirmed by your professional and shown on your booking once created.';

  @override
  String get gigKycVerified => 'KYC Verified';

  @override
  String get gigBackgroundVerified => 'Background Verified';

  @override
  String get gigBookNow => 'Book Now →';

  @override
  String get discoveryTitle => 'Available Professionals';

  @override
  String get discoveryMissingDetails => 'Missing service or location details.';

  @override
  String get discoveryLocalExperts => 'Available Local Experts';

  @override
  String get discoveryWithin => 'Within';

  @override
  String get discoveryNoProviders => 'No providers available nearby';

  @override
  String get discoveryTryLargerRadius =>
      'Try a larger search radius or check back later.';

  @override
  String get discoveryLoadFailed => 'Could not load nearby providers.';

  @override
  String discoveryServicesForJob(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count services for this job',
      one: '1 service for this job',
    );
    return '$_temp0';
  }

  @override
  String get discoveryBook => 'Book';

  @override
  String get categoryServiceDetails => 'Service Details';

  @override
  String get categoryTagline =>
      'Book verified, background-checked local experts with upfront pricing & service guarantee.';

  @override
  String get categoryWhatHelp => 'What do you need help with?';

  @override
  String get categoryDescribeElse => 'Describe something else';

  @override
  String get categoryLoadFailed => 'Could not load this service.';

  @override
  String get notificationsTitle => 'Notifications & Alerts';

  @override
  String get notificationsEmpty => 'You\'re all caught up';

  @override
  String get notificationsLoadFailed => 'Could not load notifications.';

  @override
  String get timeJustNow => 'Just now';

  @override
  String timeMinutesAgo(Object minutes) {
    return '${minutes}m ago';
  }

  @override
  String timeHoursAgo(Object hours) {
    return '${hours}h ago';
  }

  @override
  String get timeYesterday => 'Yesterday';

  @override
  String get completedTitle => 'Service Completed!';

  @override
  String get completedThanks => 'Thanks for using our services.';

  @override
  String get completedViewBookings => 'View Bookings';

  @override
  String get completedBackHome => 'Back to Home';

  @override
  String commonErrorDetail(Object detail) {
    return 'Error: $detail';
  }

  @override
  String get reviewTitle => 'Rate Your Experience';

  @override
  String get reviewHeading => 'Great Service!';

  @override
  String get reviewQuestion =>
      'How was your experience with your professional?';

  @override
  String reviewStars(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count stars',
      one: '1 star',
    );
    return '$_temp0';
  }

  @override
  String get reviewCommentHint => 'Tell us about your experience...';

  @override
  String get reviewSubmit => 'Submit Review →';

  @override
  String get materialsTitle => 'Material / Parts Requests';

  @override
  String get materialsEmpty =>
      'No material requests submitted for this booking';

  @override
  String materialsQuantityEstimated(Object quantity) {
    return '$quantity · estimated';
  }

  @override
  String materialsQuantityActual(Object quantity) {
    return '$quantity · actual';
  }

  @override
  String get materialsReject => 'Reject';

  @override
  String get materialsApprove => 'Approve';

  @override
  String get materialStatusRequested => 'Requested';

  @override
  String get materialStatusCustomerReview => 'Awaiting your review';

  @override
  String get materialStatusApproved => 'Approved';

  @override
  String get materialStatusRejected => 'Rejected';

  @override
  String get materialStatusPurchased => 'Purchased';

  @override
  String get materialStatusCostRecorded => 'Cost recorded';

  @override
  String get materialStatusBilled => 'Billed';

  @override
  String get materialStatusCancelled => 'Cancelled';

  @override
  String get commonSaveChanges => 'Save Changes';

  @override
  String get profileTitle => 'My Profile & Account';

  @override
  String get profileFallbackName => 'Customer Profile';

  @override
  String get profileLanguage => 'Language';

  @override
  String get profileAddresses => 'Saved Service Addresses';

  @override
  String get profileAddressesSubtitle =>
      'Manage home, office & secondary addresses';

  @override
  String get profileHistory => 'Past Service History';

  @override
  String get profileHistorySubtitle => 'View receipts & past bookings';

  @override
  String get profileSupport => 'Help & Customer Support';

  @override
  String get profileSupportSubtitle =>
      'Raise a ticket, track replies from our team';

  @override
  String get editProfileSaved => 'Profile updated successfully';

  @override
  String get editProfileTitle => 'Edit Profile';

  @override
  String get editProfileFullName => 'Full Name';

  @override
  String get editProfileNameEmpty => 'Name cannot be empty';

  @override
  String get editProfileEmail => 'Email Address';

  @override
  String get commonEdit => 'Edit';

  @override
  String get commonDelete => 'Delete';

  @override
  String get addressesAdd => 'Add New Address';

  @override
  String get addressesEmpty => 'You haven\'t saved any addresses yet';

  @override
  String get addressesEmptyMessage =>
      'Add a service address to book faster next time.';

  @override
  String get addressesDefaultBadge => 'DEFAULT';

  @override
  String get addressesSetDefault => 'Set as default';

  @override
  String get addressesLoadFailed => 'Could not load addresses.';

  @override
  String get addressesLabelSheet => 'Label this address';

  @override
  String get supportTitle => 'Help & Support';

  @override
  String get supportNewTicket => 'New Ticket';

  @override
  String get supportEmpty => 'No support tickets yet';

  @override
  String get supportEmptyMessage =>
      'Need help with a booking or the app? Raise a ticket and our team will respond.';

  @override
  String get supportLoadFailed => 'Could not load your support tickets.';

  @override
  String get supportStatusOpen => 'Open';

  @override
  String get supportStatusInProgress => 'In progress';

  @override
  String get supportStatusWaitingForYou => 'Waiting for you';

  @override
  String get supportStatusResolved => 'Resolved';

  @override
  String get supportStatusClosed => 'Closed';

  @override
  String get supportNewTicketTitle => 'New Support Ticket';

  @override
  String get supportCategory => 'Category';

  @override
  String get supportSubject => 'Subject';

  @override
  String get supportDescribeIssue => 'Describe the issue';

  @override
  String get supportFillSubjectMessage =>
      'Please fill in a subject and message.';

  @override
  String get supportSubmitTicket => 'Submit Ticket';

  @override
  String get supportTicketTitle => 'Support Ticket';

  @override
  String get supportNoMessages => 'No messages yet';

  @override
  String get supportMessagesLoadFailed => 'Could not load messages.';

  @override
  String get supportTypeMessage => 'Type a message...';

  @override
  String get supportSend => 'Send';

  @override
  String get pickerEnterAddress =>
      'Please enter or confirm the address for this pin';

  @override
  String get pickerTitle => 'Select Service Address';

  @override
  String get pickerGettingLocation => 'Getting your location...';

  @override
  String get pickerPermissionDenied =>
      'Location permission denied — move the map manually to pick your address.';

  @override
  String get pickerConfirmPin => 'Confirm Service Pin Position';

  @override
  String get pickerAddressLabel => 'House / Flat / Street Name';

  @override
  String get pickerAddressHint => 'e.g. #102, Green Avenue, Indiranagar';

  @override
  String get pickerLandmarkLabel => 'Landmark (Optional)';

  @override
  String get pickerLandmarkHint => 'e.g. Near HDFC Bank ATM';

  @override
  String get pickerConfirm => 'Confirm Location & Proceed';

  @override
  String get requestSelectLocation => 'Please select a service location';

  @override
  String requestTitle(Object service) {
    return 'Request $service';
  }

  @override
  String get requestServiceAddress => 'Service Address';

  @override
  String get requestDetectingLocation => 'Detecting your location…';

  @override
  String get requestTapToPickLocation => 'Tap to pick service location';

  @override
  String get requestDescribeIssue => 'Describe the Issue / Task';

  @override
  String get requestDescribeHint =>
      'e.g. Living room main ceiling light switch is sparking when turned on.';

  @override
  String get requestDescribeMin =>
      'Please describe the problem in at least 10 characters';

  @override
  String get requestAttachPhotos => 'Attach Photos of Problem (Optional)';

  @override
  String get requestAddPhoto => 'Add a photo';

  @override
  String get requestWhen => 'When do you need the service?';

  @override
  String get requestInstant => '⚡ Instant (30 min)';

  @override
  String get requestScheduleLater => '📅 Schedule later';

  @override
  String get requestFindWorkers => 'Find Available Workers';

  @override
  String commonLoadFailedDetail(Object detail) {
    return 'Failed to load: $detail';
  }

  @override
  String get myRequestsTitle => 'My Service Requests';

  @override
  String get myRequestsTabAll => 'All';

  @override
  String get myRequestsNew => 'New Request';

  @override
  String get myRequestsNoActive => 'No active requests';

  @override
  String get myRequestsNoCompleted => 'No completed requests';

  @override
  String get myRequestsNone => 'No service requests yet';

  @override
  String get myRequestsEmptyMessage =>
      'Post a requirement and let workers come to you.';

  @override
  String get requestDetailTitle => 'Request Details';

  @override
  String get requestDetailBudget => 'Budget';

  @override
  String get requestDetailSchedule => 'Schedule';

  @override
  String get requestDetailLocation => 'Location';

  @override
  String get requestDetailNotes => 'Notes';

  @override
  String get requestDetailCancel => 'Cancel Request';

  @override
  String requestDetailOffersReceived(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count offers received',
      one: '1 offer received',
      zero: 'No offers yet',
    );
    return '$_temp0';
  }

  @override
  String get requestDetailTapToCompare => 'Tap to view and compare';

  @override
  String get requestDetailWorkersSoon => 'Workers will start responding soon';

  @override
  String get requestCancelDialogTitle => 'Cancel this request?';

  @override
  String get requestCancelDialogBody =>
      'All pending offers will be closed. This cannot be undone.';

  @override
  String get requestCancelKeep => 'Keep it';

  @override
  String get requestCancelConfirm => 'Cancel request';

  @override
  String get requestCancelled => 'Request cancelled';

  @override
  String requestExpiresInDaysHours(int days, int hours) {
    return 'Expires in ${days}d ${hours}h';
  }

  @override
  String requestExpiresInHoursMinutes(int hours, int minutes) {
    return 'Expires in ${hours}h ${minutes}m';
  }

  @override
  String requestExpiresInMinutes(Object minutes) {
    return 'Expires in ${minutes}m';
  }

  @override
  String get requestExpiresSoon => 'Expires soon';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get offersTitle => 'Offers Received';

  @override
  String get offersEmptyMessage =>
      'Workers are reviewing your request. You\'ll be notified when someone responds.';

  @override
  String get offersPending => 'Pending Offers';

  @override
  String get offersPast => 'Past Offers';

  @override
  String offersJobsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jobs',
      one: '1 job',
    );
    return '$_temp0';
  }

  @override
  String get offersInsured => 'Insured';

  @override
  String get offersDecline => 'Decline';

  @override
  String get offersAcceptOffer => 'Accept Offer';

  @override
  String get offersAcceptDialogTitle => 'Accept this offer?';

  @override
  String offersAcceptDialogBody(String worker, String price) {
    return 'A booking will be created with $worker at $price. All other offers will be closed.';
  }

  @override
  String get offersAccept => 'Accept';

  @override
  String offersBookingCreated(Object code) {
    return 'Booking $code created!';
  }

  @override
  String get commonNext => 'Next';

  @override
  String postRequestPosted(Object code) {
    return 'Service request $code posted!';
  }

  @override
  String get postRequestTitle => 'Post a Service Request';

  @override
  String get postRequestWhatService => 'What service do you need?';

  @override
  String get postRequestSelectCategory =>
      'Select the category that best describes your need.';

  @override
  String get postRequestDescribe => 'Describe your requirement';

  @override
  String postRequestServiceLabel(Object service) {
    return 'Service: $service';
  }

  @override
  String get postRequestWhatDone => 'What do you need done?';

  @override
  String get postRequestFieldTitle => 'Title';

  @override
  String get postRequestTitleHint => 'e.g. Fix leaking kitchen tap';

  @override
  String postRequestMinChars(Object count) {
    return 'Enter at least $count characters';
  }

  @override
  String get postRequestFieldDescription => 'Description';

  @override
  String get postRequestDescriptionHint => 'Describe the problem in detail…';

  @override
  String get postRequestFieldNotes => 'Additional notes (optional)';

  @override
  String get postRequestNotesHint => 'Gate code, preferred timing, etc.';

  @override
  String get postRequestBudgetTitle => 'Your budget';

  @override
  String get postRequestBudgetHint =>
      'Give workers an idea of what you\'re willing to pay.';

  @override
  String get postRequestFixedPrice => 'Fixed price (₹)';

  @override
  String postRequestExample(Object example) {
    return 'e.g. $example';
  }

  @override
  String get postRequestMin => 'Min (₹)';

  @override
  String get postRequestMax => 'Max (₹)';

  @override
  String get postRequestWhenTitle => 'When do you need this?';

  @override
  String get postRequestPickDate => 'Pick a date';

  @override
  String get postRequestLocationTitle => 'Service location';

  @override
  String get postRequestAddressPrivate =>
      'Your exact address is only shared once you accept an offer.';

  @override
  String get postRequestFullAddress => 'Full address';

  @override
  String get postRequestValidAddress => 'Enter a valid address';

  @override
  String get postRequestCity => 'City';

  @override
  String get postRequestCityHint => 'e.g. Bangalore';

  @override
  String get postRequestPincode => 'Pincode';

  @override
  String get postRequestLocationSet => 'Location set ✓';

  @override
  String get postRequestSetOnMap => 'Set location on map';

  @override
  String get postRequestReviewTitle => 'Review your request';

  @override
  String get postRequestNotSelected => 'Not selected';

  @override
  String get postRequestWhen => 'When';

  @override
  String get postRequestPrivacyNote =>
      'Your exact address stays private until you accept an offer and a booking is created.';

  @override
  String get postRequestSubmit => 'Submit Request';

  @override
  String get assistantOpening =>
      'Tell me what\'s wrong, in your own words — and I\'ll find the right professional for it.';

  @override
  String assistantCatalogueFailed(Object reason) {
    return '$reason I need the service list to answer that.';
  }

  @override
  String get assistantCatalogueError =>
      'Something went wrong loading the service list.';

  @override
  String get assistantGreeting =>
      'Hello. What do you need help with at home? A leaking tap, an AC that stopped cooling, a switch that sparks — whatever it is, describe it however you like.';

  @override
  String get assistantTooVague =>
      'I can help — I just need to know what the problem is. What is not working?';

  @override
  String assistantMultipleJobs(int count) {
    return 'That sounds like $count separate jobs — they need different trades. Here is each one:';
  }

  @override
  String get assistantAmbiguous =>
      'I want to get this right — that could go to more than one trade. Which is closer?';

  @override
  String get assistantUnmatched =>
      'I could not place that against the services on the platform. Pick the closest one and I will take your description across — or post it as a request and let professionals come to you.';

  @override
  String assistantConfidentWithProblem(String service, String problem) {
    return 'That sounds like $service — most likely \"$problem\".';
  }

  @override
  String assistantConfident(Object service) {
    return 'That sounds like a job for $service.';
  }

  @override
  String assistantChosen(Object service) {
    return '$service it is. Your description goes across as you wrote it.';
  }

  @override
  String get assistantTitle => 'Service Assistant';

  @override
  String get assistantSubtitle => 'Finds the right trade for your problem';

  @override
  String get assistantStartOver => 'Start over';

  @override
  String assistantMatchedOn(Object terms) {
    return 'Matched on: $terms';
  }

  @override
  String get assistantFindWorkers => 'Find workers';

  @override
  String get assistantPostRequest => 'Post a request';

  @override
  String get assistantInputHint => 'Describe the problem...';
}
