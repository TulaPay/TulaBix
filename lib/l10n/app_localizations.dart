import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

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
    Locale('fr'),
  ];

  /// No description provided for @aClearPhotoOfThe.
  ///
  /// In en, this message translates to:
  /// **'A clear photo of the representative\'s face, matched against the ID above.'**
  String get aClearPhotoOfThe;

  /// No description provided for @aPaymentLinkOrYour.
  ///
  /// In en, this message translates to:
  /// **'a Payment Link or your QR Payment Page instead.'**
  String get aPaymentLinkOrYour;

  /// No description provided for @aValidGovernmentIssuedId.
  ///
  /// In en, this message translates to:
  /// **'A valid government-issued ID card'**
  String get aValidGovernmentIssuedId;

  /// No description provided for @acceptAllMajorCreditAnd.
  ///
  /// In en, this message translates to:
  /// **'Accept all major credit and debit cards from customers around the world with bank-grade security.'**
  String get acceptAllMajorCreditAnd;

  /// No description provided for @accessIsLimitedToThe.
  ///
  /// In en, this message translates to:
  /// **'Access is limited to the features needed for your merchant account.'**
  String get accessIsLimitedToThe;

  /// No description provided for @accountClosed.
  ///
  /// In en, this message translates to:
  /// **'Account closed'**
  String get accountClosed;

  /// No description provided for @accountInformation.
  ///
  /// In en, this message translates to:
  /// **'Account Information'**
  String get accountInformation;

  /// No description provided for @accountRecovery.
  ///
  /// In en, this message translates to:
  /// **'Account Recovery'**
  String get accountRecovery;

  /// No description provided for @accountSecurity.
  ///
  /// In en, this message translates to:
  /// **'Account & Security'**
  String get accountSecurity;

  /// No description provided for @accountSuspended.
  ///
  /// In en, this message translates to:
  /// **'Account suspended'**
  String get accountSuspended;

  /// No description provided for @activity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get activity;

  /// No description provided for @addAPaymentDescription.
  ///
  /// In en, this message translates to:
  /// **'Add a payment description'**
  String get addAPaymentDescription;

  /// No description provided for @addAPrivateNoteAbout.
  ///
  /// In en, this message translates to:
  /// **'Add a private note about this customer...'**
  String get addAPrivateNoteAbout;

  /// No description provided for @addAShortReceiptNote.
  ///
  /// In en, this message translates to:
  /// **'Add a short receipt note'**
  String get addAShortReceiptNote;

  /// No description provided for @addATitleAndNumeric.
  ///
  /// In en, this message translates to:
  /// **'Add a title and numeric target'**
  String get addATitleAndNumeric;

  /// No description provided for @addBeneficialOwner.
  ///
  /// In en, this message translates to:
  /// **'Add beneficial owner'**
  String get addBeneficialOwner;

  /// No description provided for @addCustomer.
  ///
  /// In en, this message translates to:
  /// **'Add Customer'**
  String get addCustomer;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @alertsAndNotificationChannels.
  ///
  /// In en, this message translates to:
  /// **'Alerts and notification channels'**
  String get alertsAndNotificationChannels;

  /// No description provided for @allActions.
  ///
  /// In en, this message translates to:
  /// **'All Actions'**
  String get allActions;

  /// No description provided for @allCaughtUp.
  ///
  /// In en, this message translates to:
  /// **'All caught up'**
  String get allCaughtUp;

  /// No description provided for @allTime.
  ///
  /// In en, this message translates to:
  /// **'All time'**
  String get allTime;

  /// No description provided for @allocatedAmount.
  ///
  /// In en, this message translates to:
  /// **'Allocated amount'**
  String get allocatedAmount;

  /// No description provided for @alreadyHaveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAnAccount;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @amountToReceive.
  ///
  /// In en, this message translates to:
  /// **'Amount to receive'**
  String get amountToReceive;

  /// No description provided for @analytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analytics;

  /// No description provided for @analyzeYourBusinessPerformanceWith.
  ///
  /// In en, this message translates to:
  /// **'Analyze your business performance with real-time analytics and detailed revenue reports.'**
  String get analyzeYourBusinessPerformanceWith;

  /// No description provided for @and.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get and;

  /// No description provided for @andSecurityEvents.
  ///
  /// In en, this message translates to:
  /// **'and security events.'**
  String get andSecurityEvents;

  /// No description provided for @andWatchProgressAgainstThem.
  ///
  /// In en, this message translates to:
  /// **'and watch progress against them.'**
  String get andWatchProgressAgainstThem;

  /// No description provided for @answersToCommonQuestionsPlus.
  ///
  /// In en, this message translates to:
  /// **'Answers to common questions, plus a direct line to support.'**
  String get answersToCommonQuestionsPlus;

  /// No description provided for @anyoneWhoOwnsOrControls.
  ///
  /// In en, this message translates to:
  /// **'Anyone who owns or controls 25% or more of the business. Leave empty for a sole proprietorship — that collapses into the representative above.'**
  String get anyoneWhoOwnsOrControls;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @approvesYourSubmissionPullDown.
  ///
  /// In en, this message translates to:
  /// **'approves your submission. Pull down to check again.'**
  String get approvesYourSubmissionPullDown;

  /// No description provided for @asItAppearsOnYour.
  ///
  /// In en, this message translates to:
  /// **'As it appears on your registration documents'**
  String get asItAppearsOnYour;

  /// No description provided for @askForDeviceBiometricsPasscode.
  ///
  /// In en, this message translates to:
  /// **'Ask for device biometrics / passcode each launch'**
  String get askForDeviceBiometricsPasscode;

  /// No description provided for @availableBalance.
  ///
  /// In en, this message translates to:
  /// **'AVAILABLE BALANCE'**
  String get availableBalance;

  /// No description provided for @availableMonFri8am6pm.
  ///
  /// In en, this message translates to:
  /// **'Available Mon–Fri, 8am–6pm WAT.'**
  String get availableMonFri8am6pm;

  /// No description provided for @availableToSettle.
  ///
  /// In en, this message translates to:
  /// **'Available to settle'**
  String get availableToSettle;

  /// No description provided for @awaSBoutique.
  ///
  /// In en, this message translates to:
  /// **'Awa\'s Boutique'**
  String get awaSBoutique;

  /// No description provided for @bankAccount.
  ///
  /// In en, this message translates to:
  /// **'Bank account'**
  String get bankAccount;

  /// No description provided for @bankGradeSecurity.
  ///
  /// In en, this message translates to:
  /// **'Bank-grade security'**
  String get bankGradeSecurity;

  /// No description provided for @bankTransfer.
  ///
  /// In en, this message translates to:
  /// **'Bank transfer'**
  String get bankTransfer;

  /// No description provided for @bankTransfer2.
  ///
  /// In en, this message translates to:
  /// **'Bank Transfer'**
  String get bankTransfer2;

  /// No description provided for @bankTransferSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Bank Transfer Submitted'**
  String get bankTransferSubmitted;

  /// No description provided for @basicInformationAboutYourCompany.
  ///
  /// In en, this message translates to:
  /// **'Basic information about your company'**
  String get basicInformationAboutYourCompany;

  /// No description provided for @beneficialOwners.
  ///
  /// In en, this message translates to:
  /// **'Beneficial owners'**
  String get beneficialOwners;

  /// No description provided for @beneficiaryAccount.
  ///
  /// In en, this message translates to:
  /// **'Beneficiary account'**
  String get beneficiaryAccount;

  /// No description provided for @billing.
  ///
  /// In en, this message translates to:
  /// **'Billing'**
  String get billing;

  /// No description provided for @browseFeatureGuidesAndTroubleshooting.
  ///
  /// In en, this message translates to:
  /// **'Browse feature guides and troubleshooting notes.'**
  String get browseFeatureGuidesAndTroubleshooting;

  /// No description provided for @budget.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get budget;

  /// No description provided for @budgetAllocation.
  ///
  /// In en, this message translates to:
  /// **'Budget Allocation'**
  String get budgetAllocation;

  /// No description provided for @budgetUsageTrend.
  ///
  /// In en, this message translates to:
  /// **'Budget Usage Trend'**
  String get budgetUsageTrend;

  /// No description provided for @budgets.
  ///
  /// In en, this message translates to:
  /// **'Budgets'**
  String get budgets;

  /// No description provided for @budgetsThisMonth.
  ///
  /// In en, this message translates to:
  /// **'Budgets This Month'**
  String get budgetsThisMonth;

  /// No description provided for @builtYetNothingHereIs.
  ///
  /// In en, this message translates to:
  /// **'built yet — nothing here is saved.'**
  String get builtYetNothingHereIs;

  /// No description provided for @business.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get business;

  /// No description provided for @businessDetails.
  ///
  /// In en, this message translates to:
  /// **'Business details'**
  String get businessDetails;

  /// No description provided for @businessEmail.
  ///
  /// In en, this message translates to:
  /// **'Business email'**
  String get businessEmail;

  /// No description provided for @businessEmailIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Business email is required'**
  String get businessEmailIsRequired;

  /// No description provided for @businessFinancingThroughTulabiz.
  ///
  /// In en, this message translates to:
  /// **'Business financing through TulaBiz.'**
  String get businessFinancingThroughTulabiz;

  /// No description provided for @businessIdentityAndMerchantVerification.
  ///
  /// In en, this message translates to:
  /// **'Business identity and merchant verification.'**
  String get businessIdentityAndMerchantVerification;

  /// No description provided for @businessIdentityAndVerification.
  ///
  /// In en, this message translates to:
  /// **'Business identity and verification'**
  String get businessIdentityAndVerification;

  /// No description provided for @businessIdentityContactAndVerification.
  ///
  /// In en, this message translates to:
  /// **'Business identity, contact, and verification.'**
  String get businessIdentityContactAndVerification;

  /// No description provided for @businessInformation.
  ///
  /// In en, this message translates to:
  /// **'Business information'**
  String get businessInformation;

  /// No description provided for @businessName.
  ///
  /// In en, this message translates to:
  /// **'Business name'**
  String get businessName;

  /// No description provided for @businessNameIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Business name is required'**
  String get businessNameIsRequired;

  /// No description provided for @businessPhone.
  ///
  /// In en, this message translates to:
  /// **'Business phone'**
  String get businessPhone;

  /// No description provided for @businessPhoneIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Business phone is required'**
  String get businessPhoneIsRequired;

  /// No description provided for @businessType.
  ///
  /// In en, this message translates to:
  /// **'Business type'**
  String get businessType;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @cardPayment.
  ///
  /// In en, this message translates to:
  /// **'Card payment'**
  String get cardPayment;

  /// No description provided for @cashFlow.
  ///
  /// In en, this message translates to:
  /// **'Cash flow'**
  String get cashFlow;

  /// No description provided for @cashPaymentReceived.
  ///
  /// In en, this message translates to:
  /// **'Cash Payment Received'**
  String get cashPaymentReceived;

  /// No description provided for @cashReceipt.
  ///
  /// In en, this message translates to:
  /// **'Cash Receipt'**
  String get cashReceipt;

  /// No description provided for @cashReceipts.
  ///
  /// In en, this message translates to:
  /// **'Cash Receipts'**
  String get cashReceipts;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @category2.
  ///
  /// In en, this message translates to:
  /// **'CATEGORY'**
  String get category2;

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get changePassword;

  /// No description provided for @changeThePasswordYouUse.
  ///
  /// In en, this message translates to:
  /// **'Change the password you use to sign in.'**
  String get changeThePasswordYouUse;

  /// No description provided for @changeYour6DigitTransaction.
  ///
  /// In en, this message translates to:
  /// **'Change your 6-digit transaction PIN.'**
  String get changeYour6DigitTransaction;

  /// No description provided for @channel.
  ///
  /// In en, this message translates to:
  /// **'Channel'**
  String get channel;

  /// No description provided for @checkYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Check Your Email'**
  String get checkYourEmail;

  /// No description provided for @checklist.
  ///
  /// In en, this message translates to:
  /// **'Checklist'**
  String get checklist;

  /// No description provided for @checkoutPreferencesReceiptsAndPayment.
  ///
  /// In en, this message translates to:
  /// **'Checkout preferences, receipts, and payment behavior.'**
  String get checkoutPreferencesReceiptsAndPayment;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get chooseFromGallery;

  /// No description provided for @chooseHowTheAppAlerts.
  ///
  /// In en, this message translates to:
  /// **'Choose how the app alerts you about payment activity '**
  String get chooseHowTheAppAlerts;

  /// No description provided for @chooseHowTheAppAlerts2.
  ///
  /// In en, this message translates to:
  /// **'Choose how the app alerts you about payment activity and security events.'**
  String get chooseHowTheAppAlerts2;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @cityIsRequired.
  ///
  /// In en, this message translates to:
  /// **'City is required'**
  String get cityIsRequired;

  /// No description provided for @code.
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get code;

  /// No description provided for @codeAndTitleAreRequired.
  ///
  /// In en, this message translates to:
  /// **'Code and title are required'**
  String get codeAndTitleAreRequired;

  /// No description provided for @codeCopied.
  ///
  /// In en, this message translates to:
  /// **'Code copied'**
  String get codeCopied;

  /// No description provided for @collect.
  ///
  /// In en, this message translates to:
  /// **'Collect'**
  String get collect;

  /// No description provided for @collectPayment.
  ///
  /// In en, this message translates to:
  /// **'Collect Payment'**
  String get collectPayment;

  /// No description provided for @collectTheBusinessDetailsWe.
  ///
  /// In en, this message translates to:
  /// **'Collect the business details we need before KYB document review.'**
  String get collectTheBusinessDetailsWe;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoon;

  /// No description provided for @commonIssuesAndWhatTo.
  ///
  /// In en, this message translates to:
  /// **'Common issues and what to check first.'**
  String get commonIssuesAndWhatTo;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @completedPaymentsAreBatchedAnd.
  ///
  /// In en, this message translates to:
  /// **'Completed payments are batched and paid to your settlement account on '**
  String get completedPaymentsAreBatchedAnd;

  /// No description provided for @completedPaymentsAreBatchedAnd2.
  ///
  /// In en, this message translates to:
  /// **'Completed payments are batched and paid to your settlement account on the next business day. You can see each batch under Payments.'**
  String get completedPaymentsAreBatchedAnd2;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @confirm6DigitPin.
  ///
  /// In en, this message translates to:
  /// **'Confirm 6-digit PIN'**
  String get confirm6DigitPin;

  /// No description provided for @confirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password'**
  String get confirmNewPassword;

  /// No description provided for @confirmNewPin.
  ///
  /// In en, this message translates to:
  /// **'Confirm new PIN'**
  String get confirmNewPin;

  /// No description provided for @confirmYourPin.
  ///
  /// In en, this message translates to:
  /// **'Confirm your PIN'**
  String get confirmYourPin;

  /// No description provided for @confirmYourSettlementAccountAnd.
  ///
  /// In en, this message translates to:
  /// **'Confirm your settlement account and fees.'**
  String get confirmYourSettlementAccountAnd;

  /// No description provided for @connectPayments.
  ///
  /// In en, this message translates to:
  /// **'Connect payments'**
  String get connectPayments;

  /// No description provided for @construction.
  ///
  /// In en, this message translates to:
  /// **'Construction'**
  String get construction;

  /// No description provided for @contact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contact;

  /// No description provided for @contactSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact support'**
  String get contactSupport;

  /// No description provided for @contactSupport2.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get contactSupport2;

  /// No description provided for @contactSupportIfYouBelieve.
  ///
  /// In en, this message translates to:
  /// **'Contact support if you believe this is a mistake.'**
  String get contactSupportIfYouBelieve;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @continueToKyb.
  ///
  /// In en, this message translates to:
  /// **'Continue to KYB'**
  String get continueToKyb;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @copyRef.
  ///
  /// In en, this message translates to:
  /// **'Copy ref'**
  String get copyRef;

  /// No description provided for @couldNotExportAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Could not export analytics'**
  String get couldNotExportAnalytics;

  /// No description provided for @couldNotExportTheStatement.
  ///
  /// In en, this message translates to:
  /// **'Could not export the statement'**
  String get couldNotExportTheStatement;

  /// No description provided for @couldNotLoadAnalyticsPull.
  ///
  /// In en, this message translates to:
  /// **'Could not load analytics. Pull to try again.'**
  String get couldNotLoadAnalyticsPull;

  /// No description provided for @couldNotLoadBusinessData.
  ///
  /// In en, this message translates to:
  /// **'Could not load business data. Pull to try again.'**
  String get couldNotLoadBusinessData;

  /// No description provided for @couldNotLoadCustomersPull.
  ///
  /// In en, this message translates to:
  /// **'Could not load customers. Pull to try again.'**
  String get couldNotLoadCustomersPull;

  /// No description provided for @couldNotLoadThisStatement.
  ///
  /// In en, this message translates to:
  /// **'Could not load this statement.'**
  String get couldNotLoadThisStatement;

  /// No description provided for @couldNotLoadYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Could not load your account'**
  String get couldNotLoadYourAccount;

  /// No description provided for @couldNotLoadYourProfile.
  ///
  /// In en, this message translates to:
  /// **'Could not load your profile'**
  String get couldNotLoadYourProfile;

  /// No description provided for @couldNotLoadYourSecurity.
  ///
  /// In en, this message translates to:
  /// **'Could not load your security settings'**
  String get couldNotLoadYourSecurity;

  /// No description provided for @couldNotResendTheCode.
  ///
  /// In en, this message translates to:
  /// **'Could not resend the code — please try again.'**
  String get couldNotResendTheCode;

  /// No description provided for @couldNotSaveCodeMay.
  ///
  /// In en, this message translates to:
  /// **'Could not save — code may already exist'**
  String get couldNotSaveCodeMay;

  /// No description provided for @couldNotSaveReverting.
  ///
  /// In en, this message translates to:
  /// **'Could not save — reverting'**
  String get couldNotSaveReverting;

  /// No description provided for @couldNotSaveThisCustomer.
  ///
  /// In en, this message translates to:
  /// **'Could not save this customer. Try again.'**
  String get couldNotSaveThisCustomer;

  /// No description provided for @couldNotSaveThisSetting.
  ///
  /// In en, this message translates to:
  /// **'Could not save this setting — try again'**
  String get couldNotSaveThisSetting;

  /// No description provided for @couldNotSaveTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Could not save — try again'**
  String get couldNotSaveTryAgain;

  /// No description provided for @couldNotSendTheConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Could not send the confirmation email — please try again.'**
  String get couldNotSendTheConfirmation;

  /// No description provided for @couldNotSignOutTry.
  ///
  /// In en, this message translates to:
  /// **'Could not sign out — try again'**
  String get couldNotSignOutTry;

  /// No description provided for @couldNotSubmitTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Could not submit — try again'**
  String get couldNotSubmitTryAgain;

  /// No description provided for @couldNotUpdatePassword.
  ///
  /// In en, this message translates to:
  /// **'Could not update password'**
  String get couldNotUpdatePassword;

  /// No description provided for @couldNotVerifyPinCheck.
  ///
  /// In en, this message translates to:
  /// **'Could not verify PIN — check your connection'**
  String get couldNotVerifyPinCheck;

  /// No description provided for @counterparty.
  ///
  /// In en, this message translates to:
  /// **'Counterparty'**
  String get counterparty;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @createACleanReceiptWith.
  ///
  /// In en, this message translates to:
  /// **'Create a clean receipt with a clear amount and item description.'**
  String get createACleanReceiptWith;

  /// No description provided for @createALink.
  ///
  /// In en, this message translates to:
  /// **'CREATE A LINK'**
  String get createALink;

  /// No description provided for @createALinkForA.
  ///
  /// In en, this message translates to:
  /// **'Create a link for a specific amount or invoice.'**
  String get createALinkForA;

  /// No description provided for @createANew6Digit.
  ///
  /// In en, this message translates to:
  /// **'Create a new 6-digit PIN for your TulaBiz account.'**
  String get createANew6Digit;

  /// No description provided for @createANewPasswordFor.
  ///
  /// In en, this message translates to:
  /// **'Create a new password for your TulaBiz account.'**
  String get createANewPasswordFor;

  /// No description provided for @createAPin.
  ///
  /// In en, this message translates to:
  /// **'Create a PIN'**
  String get createAPin;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @createAndManageRevenueStreams.
  ///
  /// In en, this message translates to:
  /// **'Create and manage revenue streams for different branches.'**
  String get createAndManageRevenueStreams;

  /// No description provided for @createSecurePaymentLinks.
  ///
  /// In en, this message translates to:
  /// **'Create secure payment links'**
  String get createSecurePaymentLinks;

  /// No description provided for @createYourAccountToStart.
  ///
  /// In en, this message translates to:
  /// **'Create your account to start managing payments in one liquid workspace.'**
  String get createYourAccountToStart;

  /// No description provided for @created.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get created;

  /// No description provided for @criticalFallbackAlerts.
  ///
  /// In en, this message translates to:
  /// **'Critical fallback alerts'**
  String get criticalFallbackAlerts;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @current.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get current;

  /// No description provided for @custom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get custom;

  /// No description provided for @customerInfo.
  ///
  /// In en, this message translates to:
  /// **'Customer info'**
  String get customerInfo;

  /// No description provided for @customerName.
  ///
  /// In en, this message translates to:
  /// **'Customer name'**
  String get customerName;

  /// No description provided for @customerSMtnNumber.
  ///
  /// In en, this message translates to:
  /// **'Customer\'s MTN number'**
  String get customerSMtnNumber;

  /// No description provided for @customerSince.
  ///
  /// In en, this message translates to:
  /// **'Customer since'**
  String get customerSince;

  /// No description provided for @customerTier.
  ///
  /// In en, this message translates to:
  /// **'Customer tier'**
  String get customerTier;

  /// No description provided for @customers.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get customers;

  /// No description provided for @darkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark theme'**
  String get darkTheme;

  /// No description provided for @dataEncryptedAndStrictlyConfidential.
  ///
  /// In en, this message translates to:
  /// **'Data encrypted and strictly confidential'**
  String get dataEncryptedAndStrictlyConfidential;

  /// No description provided for @dataProtection.
  ///
  /// In en, this message translates to:
  /// **'Data protection'**
  String get dataProtection;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @dedicatedBusinessLineIfDifferent.
  ///
  /// In en, this message translates to:
  /// **'Dedicated business line, if different'**
  String get dedicatedBusinessLineIfDifferent;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @destinationWallet.
  ///
  /// In en, this message translates to:
  /// **'Destination wallet'**
  String get destinationWallet;

  /// No description provided for @device.
  ///
  /// In en, this message translates to:
  /// **'Device'**
  String get device;

  /// No description provided for @didnTGetIt.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t get it? '**
  String get didnTGetIt;

  /// No description provided for @didnTReceiveTheCode.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive the code? '**
  String get didnTReceiveTheCode;

  /// No description provided for @digitalWalletPower.
  ///
  /// In en, this message translates to:
  /// **'Digital Wallet Power'**
  String get digitalWalletPower;

  /// No description provided for @directory.
  ///
  /// In en, this message translates to:
  /// **'Directory'**
  String get directory;

  /// No description provided for @disabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get disabled;

  /// No description provided for @discount.
  ///
  /// In en, this message translates to:
  /// **'Discount %'**
  String get discount;

  /// No description provided for @docs.
  ///
  /// In en, this message translates to:
  /// **'Docs'**
  String get docs;

  /// No description provided for @documentation.
  ///
  /// In en, this message translates to:
  /// **'Documentation'**
  String get documentation;

  /// No description provided for @donTHaveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get donTHaveAnAccount;

  /// No description provided for @driverSLicense.
  ///
  /// In en, this message translates to:
  /// **'Driver\'s License'**
  String get driverSLicense;

  /// No description provided for @eG12RueDe.
  ///
  /// In en, this message translates to:
  /// **'e.g. 12 Rue de la Paix'**
  String get eG12RueDe;

  /// No description provided for @eG2376xxXxx.
  ///
  /// In en, this message translates to:
  /// **'e.g. +237 6XX XXX XXX'**
  String get eG2376xxXxx;

  /// No description provided for @eG500000.
  ///
  /// In en, this message translates to:
  /// **'e.g. 500000'**
  String get eG500000;

  /// No description provided for @eG6xxxxxxxx.
  ///
  /// In en, this message translates to:
  /// **'e.g. 6XXXXXXXX'**
  String get eG6xxxxxxxx;

  /// No description provided for @eGDouala.
  ///
  /// In en, this message translates to:
  /// **'e.g. Douala'**
  String get eGDouala;

  /// No description provided for @eGGraphicDesign.
  ///
  /// In en, this message translates to:
  /// **'e.g. Graphic design'**
  String get eGGraphicDesign;

  /// No description provided for @eGMainWallet.
  ///
  /// In en, this message translates to:
  /// **'e.g. Main wallet'**
  String get eGMainWallet;

  /// No description provided for @eGSavingsWallet.
  ///
  /// In en, this message translates to:
  /// **'e.g. Savings wallet'**
  String get eGSavingsWallet;

  /// No description provided for @editGoal.
  ///
  /// In en, this message translates to:
  /// **'Edit goal'**
  String get editGoal;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get emailAddress;

  /// No description provided for @emailAddressIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Email address is required'**
  String get emailAddressIsRequired;

  /// No description provided for @emailNotifications.
  ///
  /// In en, this message translates to:
  /// **'Email notifications'**
  String get emailNotifications;

  /// No description provided for @emailSupport.
  ///
  /// In en, this message translates to:
  /// **'Email support'**
  String get emailSupport;

  /// No description provided for @enableQr.
  ///
  /// In en, this message translates to:
  /// **'Enable QR'**
  String get enableQr;

  /// No description provided for @encrypted.
  ///
  /// In en, this message translates to:
  /// **'Encrypted'**
  String get encrypted;

  /// No description provided for @enter6DigitPin.
  ///
  /// In en, this message translates to:
  /// **'Enter 6-digit PIN'**
  String get enter6DigitPin;

  /// No description provided for @enter6DigitsToKeep.
  ///
  /// In en, this message translates to:
  /// **'Enter 6 digits to keep your account and transactions secure.'**
  String get enter6DigitsToKeep;

  /// No description provided for @enterANumber.
  ///
  /// In en, this message translates to:
  /// **'Enter a number'**
  String get enterANumber;

  /// No description provided for @enterAValidAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid amount'**
  String get enterAValidAmount;

  /// No description provided for @enterAValidEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get enterAValidEmailAddress;

  /// No description provided for @enterAValidMobileMoney.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid mobile money number'**
  String get enterAValidMobileMoney;

  /// No description provided for @enterAValidMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid mobile number'**
  String get enterAValidMobileNumber;

  /// No description provided for @enterAnAmountOfAt.
  ///
  /// In en, this message translates to:
  /// **'Enter an amount of at least 200 XAF'**
  String get enterAnAmountOfAt;

  /// No description provided for @enterFullName.
  ///
  /// In en, this message translates to:
  /// **'Enter full name'**
  String get enterFullName;

  /// No description provided for @enterTheCustomerSMtn.
  ///
  /// In en, this message translates to:
  /// **'Enter the customer\'s MTN MoMo number'**
  String get enterTheCustomerSMtn;

  /// No description provided for @enterYour6DigitPin.
  ///
  /// In en, this message translates to:
  /// **'Enter your 6-digit PIN'**
  String get enterYour6DigitPin;

  /// No description provided for @enterYour6DigitTransaction.
  ///
  /// In en, this message translates to:
  /// **'Enter your 6-digit transaction PIN to continue.'**
  String get enterYour6DigitTransaction;

  /// No description provided for @enterYourCode.
  ///
  /// In en, this message translates to:
  /// **'Enter Your Code'**
  String get enterYourCode;

  /// No description provided for @enterYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterYourPassword;

  /// No description provided for @estimatedMonthlyTransactionVolumeXaf.
  ///
  /// In en, this message translates to:
  /// **'Estimated monthly transaction volume (XAF)'**
  String get estimatedMonthlyTransactionVolumeXaf;

  /// No description provided for @estimatedTime.
  ///
  /// In en, this message translates to:
  /// **'Estimated time: '**
  String get estimatedTime;

  /// No description provided for @estimatedVolumeIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Estimated volume is required'**
  String get estimatedVolumeIsRequired;

  /// No description provided for @expenseCategories.
  ///
  /// In en, this message translates to:
  /// **'Expense Categories'**
  String get expenseCategories;

  /// No description provided for @expenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get expenses;

  /// No description provided for @expensesTrend.
  ///
  /// In en, this message translates to:
  /// **'Expenses Trend'**
  String get expensesTrend;

  /// No description provided for @expired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get expired;

  /// No description provided for @exportLabel.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get exportLabel;

  /// No description provided for @exportingBusinessReport.
  ///
  /// In en, this message translates to:
  /// **'Exporting business report…'**
  String get exportingBusinessReport;

  /// No description provided for @failed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get failed;

  /// No description provided for @faqsAndSupportContact.
  ///
  /// In en, this message translates to:
  /// **'FAQs and support contact'**
  String get faqsAndSupportContact;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @featureGuides.
  ///
  /// In en, this message translates to:
  /// **'Feature guides'**
  String get featureGuides;

  /// No description provided for @fee.
  ///
  /// In en, this message translates to:
  /// **'Fee'**
  String get fee;

  /// No description provided for @feesCharged.
  ///
  /// In en, this message translates to:
  /// **'Fees charged'**
  String get feesCharged;

  /// No description provided for @financialEngineForMerchants.
  ///
  /// In en, this message translates to:
  /// **'FINANCIAL ENGINE FOR MERCHANTS'**
  String get financialEngineForMerchants;

  /// No description provided for @financialOperationsEngine.
  ///
  /// In en, this message translates to:
  /// **'Financial Operations Engine'**
  String get financialOperationsEngine;

  /// No description provided for @financialStatements.
  ///
  /// In en, this message translates to:
  /// **'Financial statements'**
  String get financialStatements;

  /// No description provided for @findAnswersLaunchSupportOr.
  ///
  /// In en, this message translates to:
  /// **'Find answers, launch support, or learn the product flow.'**
  String get findAnswersLaunchSupportOr;

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// No description provided for @followsSystem.
  ///
  /// In en, this message translates to:
  /// **'Follows system'**
  String get followsSystem;

  /// No description provided for @foodBeverage.
  ///
  /// In en, this message translates to:
  /// **'Food & Beverage'**
  String get foodBeverage;

  /// No description provided for @forEveryPayoutRegardlessOf.
  ///
  /// In en, this message translates to:
  /// **'for every payout regardless of this setting.'**
  String get forEveryPayoutRegardlessOf;

  /// No description provided for @forMoreThanAnHour.
  ///
  /// In en, this message translates to:
  /// **'for more than an hour, contact support with the reference.'**
  String get forMoreThanAnHour;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @forgotPin.
  ///
  /// In en, this message translates to:
  /// **'Forgot PIN?'**
  String get forgotPin;

  /// No description provided for @fromTheButtonBelowAnd.
  ///
  /// In en, this message translates to:
  /// **'from the button below and we\'ll verify and update it.'**
  String get fromTheButtonBelowAnd;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullName;

  /// No description provided for @fullNameIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Full name is required'**
  String get fullNameIsRequired;

  /// No description provided for @generate.
  ///
  /// In en, this message translates to:
  /// **'Generate'**
  String get generate;

  /// No description provided for @generateALinkFirst.
  ///
  /// In en, this message translates to:
  /// **'Generate a link first'**
  String get generateALinkFirst;

  /// No description provided for @generateProfessionalMonthlyReportsFor.
  ///
  /// In en, this message translates to:
  /// **'Generate professional monthly reports for tax and auditing.'**
  String get generateProfessionalMonthlyReportsFor;

  /// No description provided for @generateReceipt.
  ///
  /// In en, this message translates to:
  /// **'Generate receipt'**
  String get generateReceipt;

  /// No description provided for @generating.
  ///
  /// In en, this message translates to:
  /// **'Generating…'**
  String get generating;

  /// No description provided for @getAHumanResponseDuring.
  ///
  /// In en, this message translates to:
  /// **'Get a human response during business hours.'**
  String get getAHumanResponseDuring;

  /// No description provided for @getNotified.
  ///
  /// In en, this message translates to:
  /// **'Get notified'**
  String get getNotified;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @gettingStarted.
  ///
  /// In en, this message translates to:
  /// **'Getting started'**
  String get gettingStarted;

  /// No description provided for @gettingStarted2.
  ///
  /// In en, this message translates to:
  /// **'Getting Started'**
  String get gettingStarted2;

  /// No description provided for @globalCardPayments.
  ///
  /// In en, this message translates to:
  /// **'Global Card Payments'**
  String get globalCardPayments;

  /// No description provided for @goToLogin.
  ///
  /// In en, this message translates to:
  /// **'Go to Login'**
  String get goToLogin;

  /// No description provided for @grossRevenue.
  ///
  /// In en, this message translates to:
  /// **'Gross revenue'**
  String get grossRevenue;

  /// No description provided for @growth.
  ///
  /// In en, this message translates to:
  /// **'Growth'**
  String get growth;

  /// No description provided for @growthGoals.
  ///
  /// In en, this message translates to:
  /// **'Growth Goals'**
  String get growthGoals;

  /// No description provided for @guidesProductNotesAndImplementation.
  ///
  /// In en, this message translates to:
  /// **'Guides, product notes, and implementation references.'**
  String get guidesProductNotesAndImplementation;

  /// No description provided for @handlePhysicalAndDigitalPayments.
  ///
  /// In en, this message translates to:
  /// **'Handle physical and digital payments seamlessly in one unified platform designed for speed.'**
  String get handlePhysicalAndDigitalPayments;

  /// No description provided for @healthBeauty.
  ///
  /// In en, this message translates to:
  /// **'Health & Beauty'**
  String get healthBeauty;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @helpCenter.
  ///
  /// In en, this message translates to:
  /// **'Help Center'**
  String get helpCenter;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// No description provided for @higherLimitsAndLowerFees.
  ///
  /// In en, this message translates to:
  /// **'Higher limits and lower fees. Requires review.'**
  String get higherLimitsAndLowerFees;

  /// No description provided for @higherTransactionLimits.
  ///
  /// In en, this message translates to:
  /// **'Higher transaction limits'**
  String get higherTransactionLimits;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @howCanWeHelp.
  ///
  /// In en, this message translates to:
  /// **'How can we help?'**
  String get howCanWeHelp;

  /// No description provided for @howDoIChangeMy.
  ///
  /// In en, this message translates to:
  /// **'How do I change my payout number?'**
  String get howDoIChangeMy;

  /// No description provided for @howLongDoSettlementsTake.
  ///
  /// In en, this message translates to:
  /// **'How long do settlements take?'**
  String get howLongDoSettlementsTake;

  /// No description provided for @iAgreeToThe.
  ///
  /// In en, this message translates to:
  /// **'I agree to the '**
  String get iAgreeToThe;

  /// No description provided for @iVeConfirmedContinue.
  ///
  /// In en, this message translates to:
  /// **'I\'ve confirmed — Continue'**
  String get iVeConfirmedContinue;

  /// No description provided for @ibanAccountNumber.
  ///
  /// In en, this message translates to:
  /// **'IBAN / account number'**
  String get ibanAccountNumber;

  /// No description provided for @idDocumentAddedTapTo.
  ///
  /// In en, this message translates to:
  /// **'ID document added — tap to replace'**
  String get idDocumentAddedTapTo;

  /// No description provided for @idDocumentCapturedTapTo.
  ///
  /// In en, this message translates to:
  /// **'ID document captured — tap to retake'**
  String get idDocumentCapturedTapTo;

  /// No description provided for @idVerification.
  ///
  /// In en, this message translates to:
  /// **'ID verification'**
  String get idVerification;

  /// No description provided for @identityDocument.
  ///
  /// In en, this message translates to:
  /// **'Identity document'**
  String get identityDocument;

  /// No description provided for @includeAtLeastOneNumber.
  ///
  /// In en, this message translates to:
  /// **'Include at least one number'**
  String get includeAtLeastOneNumber;

  /// No description provided for @includeAtLeastOneUppercase.
  ///
  /// In en, this message translates to:
  /// **'Include at least one uppercase letter'**
  String get includeAtLeastOneUppercase;

  /// No description provided for @income.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get income;

  /// No description provided for @incomeSources.
  ///
  /// In en, this message translates to:
  /// **'Income Sources'**
  String get incomeSources;

  /// No description provided for @incomeTrend.
  ///
  /// In en, this message translates to:
  /// **'Income Trend'**
  String get incomeTrend;

  /// No description provided for @incorrectPinTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Incorrect PIN — try again'**
  String get incorrectPinTryAgain;

  /// No description provided for @industrySector.
  ///
  /// In en, this message translates to:
  /// **'Industry / sector'**
  String get industrySector;

  /// No description provided for @instant.
  ///
  /// In en, this message translates to:
  /// **'Instant'**
  String get instant;

  /// No description provided for @internalNotes.
  ///
  /// In en, this message translates to:
  /// **'Internal notes'**
  String get internalNotes;

  /// No description provided for @internalTransfer.
  ///
  /// In en, this message translates to:
  /// **'Internal Transfer'**
  String get internalTransfer;

  /// No description provided for @internalTransferCompleted.
  ///
  /// In en, this message translates to:
  /// **'Internal Transfer Completed'**
  String get internalTransferCompleted;

  /// No description provided for @internationalPassport.
  ///
  /// In en, this message translates to:
  /// **'International Passport'**
  String get internationalPassport;

  /// No description provided for @invoice.
  ///
  /// In en, this message translates to:
  /// **'Invoice'**
  String get invoice;

  /// No description provided for @invoiceForGraphicDesign.
  ///
  /// In en, this message translates to:
  /// **'Invoice for graphic design'**
  String get invoiceForGraphicDesign;

  /// No description provided for @itemOrService.
  ///
  /// In en, this message translates to:
  /// **'Item or service'**
  String get itemOrService;

  /// No description provided for @jeanDupont.
  ///
  /// In en, this message translates to:
  /// **'Jean Dupont'**
  String get jeanDupont;

  /// No description provided for @joinThousandsOfMerchantsGrowing.
  ///
  /// In en, this message translates to:
  /// **'Join thousands of merchants growing their business with TulaPay\'s secure platform.'**
  String get joinThousandsOfMerchantsGrowing;

  /// No description provided for @joinTulapay.
  ///
  /// In en, this message translates to:
  /// **'Join TulaPay'**
  String get joinTulapay;

  /// No description provided for @kybVerificationLevel1.
  ///
  /// In en, this message translates to:
  /// **'KYB verification — Level 1'**
  String get kybVerificationLevel1;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @legalAgreements.
  ///
  /// In en, this message translates to:
  /// **'Legal Agreements'**
  String get legalAgreements;

  /// No description provided for @legalBusinessName.
  ///
  /// In en, this message translates to:
  /// **'Legal business name'**
  String get legalBusinessName;

  /// No description provided for @lightTheme.
  ///
  /// In en, this message translates to:
  /// **'Light theme'**
  String get lightTheme;

  /// No description provided for @link.
  ///
  /// In en, this message translates to:
  /// **'Link'**
  String get link;

  /// No description provided for @linkActions.
  ///
  /// In en, this message translates to:
  /// **'LINK ACTIONS'**
  String get linkActions;

  /// No description provided for @linksCashReceiptsQrPayments.
  ///
  /// In en, this message translates to:
  /// **'Links, cash receipts, QR payments, and bank transfers.'**
  String get linksCashReceiptsQrPayments;

  /// No description provided for @liveChat.
  ///
  /// In en, this message translates to:
  /// **'Live chat'**
  String get liveChat;

  /// No description provided for @liveChatOpensDuringBusiness.
  ///
  /// In en, this message translates to:
  /// **'Live chat opens during business hours'**
  String get liveChatOpensDuringBusiness;

  /// No description provided for @loan.
  ///
  /// In en, this message translates to:
  /// **'Loan'**
  String get loan;

  /// No description provided for @loans.
  ///
  /// In en, this message translates to:
  /// **'Loans'**
  String get loans;

  /// No description provided for @logIn.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get logIn;

  /// No description provided for @logInSecurelyToYour.
  ///
  /// In en, this message translates to:
  /// **'Log in securely to your TulaPay account.'**
  String get logInSecurelyToYour;

  /// No description provided for @main.
  ///
  /// In en, this message translates to:
  /// **'Main'**
  String get main;

  /// No description provided for @markAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all read'**
  String get markAllRead;

  /// No description provided for @merchantDashboard.
  ///
  /// In en, this message translates to:
  /// **'Merchant Dashboard'**
  String get merchantDashboard;

  /// No description provided for @merchantPayoutAccount.
  ///
  /// In en, this message translates to:
  /// **'Merchant payout account'**
  String get merchantPayoutAccount;

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get message;

  /// No description provided for @minimum8Characters.
  ///
  /// In en, this message translates to:
  /// **'Minimum 8 characters'**
  String get minimum8Characters;

  /// No description provided for @mobileMoneyConfirmationsCanTake.
  ///
  /// In en, this message translates to:
  /// **'Mobile money confirmations can take a few minutes. If it stays pending '**
  String get mobileMoneyConfirmationsCanTake;

  /// No description provided for @mobileMoneyConfirmationsCanTake2.
  ///
  /// In en, this message translates to:
  /// **'Mobile money confirmations can take a few minutes. If it stays pending for more than an hour, contact support with the reference.'**
  String get mobileMoneyConfirmationsCanTake2;

  /// No description provided for @mobileMoneyNumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile money number'**
  String get mobileMoneyNumber;

  /// No description provided for @momoNumberForOrangeMoney.
  ///
  /// In en, this message translates to:
  /// **'MoMo number. For Orange Money or other methods, use '**
  String get momoNumberForOrangeMoney;

  /// No description provided for @moneyIn.
  ///
  /// In en, this message translates to:
  /// **'Money in'**
  String get moneyIn;

  /// No description provided for @moneyInMotion.
  ///
  /// In en, this message translates to:
  /// **'Money in motion'**
  String get moneyInMotion;

  /// No description provided for @moneyInVsOut.
  ///
  /// In en, this message translates to:
  /// **'Money in vs out'**
  String get moneyInVsOut;

  /// No description provided for @moneyOut.
  ///
  /// In en, this message translates to:
  /// **'Money out'**
  String get moneyOut;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @mtnMomoOnly.
  ///
  /// In en, this message translates to:
  /// **'MTN MoMo only'**
  String get mtnMomoOnly;

  /// No description provided for @multipleBusinessWallets.
  ///
  /// In en, this message translates to:
  /// **'Multiple business wallets'**
  String get multipleBusinessWallets;

  /// No description provided for @mustBe6Digits.
  ///
  /// In en, this message translates to:
  /// **'Must be 6 digits'**
  String get mustBe6Digits;

  /// No description provided for @mustBeAtLeast8.
  ///
  /// In en, this message translates to:
  /// **'Must be at least 8 characters'**
  String get mustBeAtLeast8;

  /// No description provided for @myQrCode.
  ///
  /// In en, this message translates to:
  /// **'My QR Code'**
  String get myQrCode;

  /// No description provided for @n24Hours.
  ///
  /// In en, this message translates to:
  /// **'24 hours'**
  String get n24Hours;

  /// No description provided for @n5Steps.
  ///
  /// In en, this message translates to:
  /// **'5 Steps'**
  String get n5Steps;

  /// No description provided for @nameCannotBeBlank.
  ///
  /// In en, this message translates to:
  /// **'Name cannot be blank'**
  String get nameCannotBeBlank;

  /// No description provided for @nameIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required.'**
  String get nameIsRequired;

  /// No description provided for @nationalIdCardCni.
  ///
  /// In en, this message translates to:
  /// **'National ID Card (CNI)'**
  String get nationalIdCardCni;

  /// No description provided for @needsAttention.
  ///
  /// In en, this message translates to:
  /// **'Needs attention'**
  String get needsAttention;

  /// No description provided for @net.
  ///
  /// In en, this message translates to:
  /// **'Net'**
  String get net;

  /// No description provided for @netRevenue.
  ///
  /// In en, this message translates to:
  /// **'Net revenue'**
  String get netRevenue;

  /// No description provided for @newCapabilities.
  ///
  /// In en, this message translates to:
  /// **'NEW CAPABILITIES'**
  String get newCapabilities;

  /// No description provided for @newCode.
  ///
  /// In en, this message translates to:
  /// **'New code'**
  String get newCode;

  /// No description provided for @newCustomer.
  ///
  /// In en, this message translates to:
  /// **'New customer'**
  String get newCustomer;

  /// No description provided for @newGoal.
  ///
  /// In en, this message translates to:
  /// **'New goal'**
  String get newGoal;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPassword;

  /// No description provided for @newPin.
  ///
  /// In en, this message translates to:
  /// **'New PIN'**
  String get newPin;

  /// No description provided for @newPromoCode.
  ///
  /// In en, this message translates to:
  /// **'New promo code'**
  String get newPromoCode;

  /// No description provided for @nextYouLlUploadYour.
  ///
  /// In en, this message translates to:
  /// **'Next, you\'ll upload your RCCM, tax, and ID documents for KYB review.'**
  String get nextYouLlUploadYour;

  /// No description provided for @niuIsRequired.
  ///
  /// In en, this message translates to:
  /// **'NIU is required'**
  String get niuIsRequired;

  /// No description provided for @niuTaxIdentificationNumber.
  ///
  /// In en, this message translates to:
  /// **'NIU (Tax Identification Number)'**
  String get niuTaxIdentificationNumber;

  /// No description provided for @niuTaxIdentificationNumberIf.
  ///
  /// In en, this message translates to:
  /// **'NIU (Tax Identification Number) (if registered)'**
  String get niuTaxIdentificationNumberIf;

  /// No description provided for @noActivityYet.
  ///
  /// In en, this message translates to:
  /// **'No activity yet'**
  String get noActivityYet;

  /// No description provided for @noActivityYetPaymentsWill.
  ///
  /// In en, this message translates to:
  /// **'No activity yet — payments will show up here.'**
  String get noActivityYetPaymentsWill;

  /// No description provided for @noBudgetSetForThis.
  ///
  /// In en, this message translates to:
  /// **'No budget set for this month yet.'**
  String get noBudgetSetForThis;

  /// No description provided for @noCashReceiptsRecordedYet.
  ///
  /// In en, this message translates to:
  /// **'No cash receipts recorded yet.'**
  String get noCashReceiptsRecordedYet;

  /// No description provided for @noContactInfo.
  ///
  /// In en, this message translates to:
  /// **'No contact info'**
  String get noContactInfo;

  /// No description provided for @noCostsLoggedThisMonth.
  ///
  /// In en, this message translates to:
  /// **'No costs logged this month.'**
  String get noCostsLoggedThisMonth;

  /// No description provided for @noCostsLoggedThisPeriod.
  ///
  /// In en, this message translates to:
  /// **'No costs logged this period.'**
  String get noCostsLoggedThisPeriod;

  /// No description provided for @noCustomersFound.
  ///
  /// In en, this message translates to:
  /// **'No customers found'**
  String get noCustomersFound;

  /// No description provided for @noCustomersYet.
  ///
  /// In en, this message translates to:
  /// **'No customers yet'**
  String get noCustomersYet;

  /// No description provided for @noExpensesLoggedYet.
  ///
  /// In en, this message translates to:
  /// **'No expenses logged yet.'**
  String get noExpensesLoggedYet;

  /// No description provided for @noFailedPaymentsThisPeriod.
  ///
  /// In en, this message translates to:
  /// **'No failed payments this period.'**
  String get noFailedPaymentsThisPeriod;

  /// No description provided for @noGoalsYetTapTo.
  ///
  /// In en, this message translates to:
  /// **'No goals yet — tap + to add one'**
  String get noGoalsYetTapTo;

  /// No description provided for @noPaymentLinksYetGenerate.
  ///
  /// In en, this message translates to:
  /// **'No payment links yet — generate one above.'**
  String get noPaymentLinksYetGenerate;

  /// No description provided for @noPaymentsReceivedYetThis.
  ///
  /// In en, this message translates to:
  /// **'No payments received yet this month.'**
  String get noPaymentsReceivedYetThis;

  /// No description provided for @noPromoCodesYet.
  ///
  /// In en, this message translates to:
  /// **'No promo codes yet'**
  String get noPromoCodesYet;

  /// No description provided for @noSettlementsYet.
  ///
  /// In en, this message translates to:
  /// **'No settlements yet'**
  String get noSettlementsYet;

  /// No description provided for @noTransactionsWithThisCustomer.
  ///
  /// In en, this message translates to:
  /// **'No transactions with this customer yet.'**
  String get noTransactionsWithThisCustomer;

  /// No description provided for @noTransactionsYet.
  ///
  /// In en, this message translates to:
  /// **'No transactions yet'**
  String get noTransactionsYet;

  /// No description provided for @noTransactionsYetThisPeriod.
  ///
  /// In en, this message translates to:
  /// **'No transactions yet this period.'**
  String get noTransactionsYetThisPeriod;

  /// No description provided for @noTransfersYet.
  ///
  /// In en, this message translates to:
  /// **'No transfers yet.'**
  String get noTransfersYet;

  /// No description provided for @notScheduled.
  ///
  /// In en, this message translates to:
  /// **'Not scheduled'**
  String get notScheduled;

  /// No description provided for @notSetUpYet.
  ///
  /// In en, this message translates to:
  /// **'Not set up yet'**
  String get notSetUpYet;

  /// No description provided for @notYetAvailable.
  ///
  /// In en, this message translates to:
  /// **'Not yet available'**
  String get notYetAvailable;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// No description provided for @nothingAllocatedYet.
  ///
  /// In en, this message translates to:
  /// **'Nothing allocated yet.'**
  String get nothingAllocatedYet;

  /// No description provided for @nothingYet.
  ///
  /// In en, this message translates to:
  /// **'Nothing yet.'**
  String get nothingYet;

  /// No description provided for @notificationPreferences.
  ///
  /// In en, this message translates to:
  /// **'Notification preferences'**
  String get notificationPreferences;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @oneOffPaymentLinks.
  ///
  /// In en, this message translates to:
  /// **'One-off payment links'**
  String get oneOffPaymentLinks;

  /// No description provided for @openDocs.
  ///
  /// In en, this message translates to:
  /// **'Open docs'**
  String get openDocs;

  /// No description provided for @openItOnThisDevice.
  ///
  /// In en, this message translates to:
  /// **'Open it on this device to continue — it\'ll bring you right back here.'**
  String get openItOnThisDevice;

  /// No description provided for @operatingCosts.
  ///
  /// In en, this message translates to:
  /// **'Operating costs'**
  String get operatingCosts;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// No description provided for @optionalInvoiceOrOrderReference.
  ///
  /// In en, this message translates to:
  /// **'Optional invoice or order reference'**
  String get optionalInvoiceOrOrderReference;

  /// No description provided for @optionalMemo.
  ///
  /// In en, this message translates to:
  /// **'Optional memo'**
  String get optionalMemo;

  /// No description provided for @optionalWhatIsThisFor.
  ///
  /// In en, this message translates to:
  /// **'Optional — what is this for?'**
  String get optionalWhatIsThisFor;

  /// No description provided for @orders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get orders;

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// No description provided for @owner.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get owner;

  /// No description provided for @ownerName.
  ///
  /// In en, this message translates to:
  /// **'Owner name'**
  String get ownerName;

  /// No description provided for @ownerNameIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Owner name is required'**
  String get ownerNameIsRequired;

  /// No description provided for @ownerRepresentativeName.
  ///
  /// In en, this message translates to:
  /// **'Owner / representative name'**
  String get ownerRepresentativeName;

  /// No description provided for @ownerRepresentativePhone.
  ///
  /// In en, this message translates to:
  /// **'Owner / representative phone'**
  String get ownerRepresentativePhone;

  /// No description provided for @ownership.
  ///
  /// In en, this message translates to:
  /// **'Ownership %'**
  String get ownership;

  /// No description provided for @pageLinkCopied.
  ///
  /// In en, this message translates to:
  /// **'Page link copied'**
  String get pageLinkCopied;

  /// No description provided for @paid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paid;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @passwordAppLockAndPin.
  ///
  /// In en, this message translates to:
  /// **'Password, app lock, and PIN'**
  String get passwordAppLockAndPin;

  /// No description provided for @passwordIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordIsRequired;

  /// No description provided for @passwordMustBeAtLeast.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get passwordMustBeAtLeast;

  /// No description provided for @passwordResetSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Password Reset Successful'**
  String get passwordResetSuccessful;

  /// No description provided for @passwordUpdated.
  ///
  /// In en, this message translates to:
  /// **'Password updated'**
  String get passwordUpdated;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @paymentDescription.
  ///
  /// In en, this message translates to:
  /// **'Payment description'**
  String get paymentDescription;

  /// No description provided for @paymentDetails.
  ///
  /// In en, this message translates to:
  /// **'PAYMENT DETAILS'**
  String get paymentDetails;

  /// No description provided for @paymentLink.
  ///
  /// In en, this message translates to:
  /// **'Payment link'**
  String get paymentLink;

  /// No description provided for @paymentLinkCopied.
  ///
  /// In en, this message translates to:
  /// **'Payment link copied'**
  String get paymentLinkCopied;

  /// No description provided for @paymentLinkGenerated.
  ///
  /// In en, this message translates to:
  /// **'Payment link generated'**
  String get paymentLinkGenerated;

  /// No description provided for @paymentLinkGenerated2.
  ///
  /// In en, this message translates to:
  /// **'Payment Link Generated'**
  String get paymentLinkGenerated2;

  /// No description provided for @paymentLinks.
  ///
  /// In en, this message translates to:
  /// **'Payment Links'**
  String get paymentLinks;

  /// No description provided for @paymentMethods.
  ///
  /// In en, this message translates to:
  /// **'Payment Methods'**
  String get paymentMethods;

  /// No description provided for @paymentMode.
  ///
  /// In en, this message translates to:
  /// **'Payment mode'**
  String get paymentMode;

  /// No description provided for @paymentPage.
  ///
  /// In en, this message translates to:
  /// **'Payment Page'**
  String get paymentPage;

  /// No description provided for @paymentPromptSent.
  ///
  /// In en, this message translates to:
  /// **'Payment Prompt Sent'**
  String get paymentPromptSent;

  /// No description provided for @paymentPromptSentToThe.
  ///
  /// In en, this message translates to:
  /// **'Payment prompt sent to the customer\'s phone'**
  String get paymentPromptSentToThe;

  /// No description provided for @payments.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get payments;

  /// No description provided for @paymentsDrawerAndSettingsFlows.
  ///
  /// In en, this message translates to:
  /// **'Payments, drawer, and settings flows explained.'**
  String get paymentsDrawerAndSettingsFlows;

  /// No description provided for @paymentsTransfers.
  ///
  /// In en, this message translates to:
  /// **'Payments & Transfers'**
  String get paymentsTransfers;

  /// No description provided for @payoutAccount.
  ///
  /// In en, this message translates to:
  /// **'Payout account'**
  String get payoutAccount;

  /// No description provided for @payoutAccountChangesAreHandled.
  ///
  /// In en, this message translates to:
  /// **'Payout account changes are handled by support for security — email us '**
  String get payoutAccountChangesAreHandled;

  /// No description provided for @payoutAccountChangesAreHandled2.
  ///
  /// In en, this message translates to:
  /// **'Payout account changes are handled by support for security — email us from the button below and we\'ll verify and update it.'**
  String get payoutAccountChangesAreHandled2;

  /// No description provided for @payoutDestinationPublishedFeesAnd.
  ///
  /// In en, this message translates to:
  /// **'Payout destination, published fees, and history.'**
  String get payoutDestinationPublishedFeesAnd;

  /// No description provided for @payouts.
  ///
  /// In en, this message translates to:
  /// **'Payouts'**
  String get payouts;

  /// No description provided for @payoutsReceived.
  ///
  /// In en, this message translates to:
  /// **'Payouts received'**
  String get payoutsReceived;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @perChannelRatesAreListed.
  ///
  /// In en, this message translates to:
  /// **'Per-channel rates are listed under Settings → Payment Methods → Billing.'**
  String get perChannelRatesAreListed;

  /// No description provided for @periodEnd.
  ///
  /// In en, this message translates to:
  /// **'Period end'**
  String get periodEnd;

  /// No description provided for @periodStart.
  ///
  /// In en, this message translates to:
  /// **'Period start'**
  String get periodStart;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNumber;

  /// No description provided for @phoneNumberIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get phoneNumberIsRequired;

  /// No description provided for @pinPasswordDeviceSecurityAnd.
  ///
  /// In en, this message translates to:
  /// **'PIN, password, device security, and account recovery.'**
  String get pinPasswordDeviceSecurityAnd;

  /// No description provided for @pinResetSuccessful.
  ///
  /// In en, this message translates to:
  /// **'PIN Reset Successful'**
  String get pinResetSuccessful;

  /// No description provided for @pinSetSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'PIN Set Successfully'**
  String get pinSetSuccessfully;

  /// No description provided for @pinTheScreensYouUse.
  ///
  /// In en, this message translates to:
  /// **'Pin the screens you use most for one-tap access.'**
  String get pinTheScreensYouUse;

  /// No description provided for @pinTheScreensYouUse2.
  ///
  /// In en, this message translates to:
  /// **'Pin the screens you use most'**
  String get pinTheScreensYouUse2;

  /// No description provided for @pinsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'PINs do not match'**
  String get pinsDoNotMatch;

  /// No description provided for @pinsDoNotMatchPlease.
  ///
  /// In en, this message translates to:
  /// **'PINs do not match. Please try again.'**
  String get pinsDoNotMatchPlease;

  /// No description provided for @platformFees.
  ///
  /// In en, this message translates to:
  /// **'Platform fees'**
  String get platformFees;

  /// No description provided for @pleaseAcceptTheTermsAnd.
  ///
  /// In en, this message translates to:
  /// **'Please accept the Terms and Conditions to proceed'**
  String get pleaseAcceptTheTermsAnd;

  /// No description provided for @pleaseEnterTheComplete6.
  ///
  /// In en, this message translates to:
  /// **'Please enter the complete 6-digit code'**
  String get pleaseEnterTheComplete6;

  /// No description provided for @posSettings.
  ///
  /// In en, this message translates to:
  /// **'POS Settings'**
  String get posSettings;

  /// No description provided for @poweredByTulapay.
  ///
  /// In en, this message translates to:
  /// **'Powered by TulaPay'**
  String get poweredByTulapay;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @premiumTier.
  ///
  /// In en, this message translates to:
  /// **'Premium tier'**
  String get premiumTier;

  /// No description provided for @previewPage.
  ///
  /// In en, this message translates to:
  /// **'Preview page'**
  String get previewPage;

  /// No description provided for @priorityVerification.
  ///
  /// In en, this message translates to:
  /// **'Priority verification'**
  String get priorityVerification;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @privacyPolicyAndTermsOf.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy and terms of use'**
  String get privacyPolicyAndTermsOf;

  /// No description provided for @privacySecurity.
  ///
  /// In en, this message translates to:
  /// **'Privacy & Security'**
  String get privacySecurity;

  /// No description provided for @processing.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get processing;

  /// No description provided for @productSetupAndYourFirst.
  ///
  /// In en, this message translates to:
  /// **'Product setup and your first sale.'**
  String get productSetupAndYourFirst;

  /// No description provided for @professionalServices.
  ///
  /// In en, this message translates to:
  /// **'Professional Services'**
  String get professionalServices;

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated'**
  String get profileUpdated;

  /// No description provided for @promoCodes.
  ///
  /// In en, this message translates to:
  /// **'Promo Codes'**
  String get promoCodes;

  /// No description provided for @provider.
  ///
  /// In en, this message translates to:
  /// **'Provider'**
  String get provider;

  /// No description provided for @publishedFees.
  ///
  /// In en, this message translates to:
  /// **'Published fees'**
  String get publishedFees;

  /// No description provided for @pullToRefreshOrTry.
  ///
  /// In en, this message translates to:
  /// **'Pull to refresh or try again in a moment.'**
  String get pullToRefreshOrTry;

  /// No description provided for @pushNotifications.
  ///
  /// In en, this message translates to:
  /// **'Push notifications'**
  String get pushNotifications;

  /// No description provided for @qrCheckout.
  ///
  /// In en, this message translates to:
  /// **'QR checkout'**
  String get qrCheckout;

  /// No description provided for @questionsAboutPrivacyCanBe.
  ///
  /// In en, this message translates to:
  /// **'Questions about privacy can be routed to support from the Help Center.'**
  String get questionsAboutPrivacyCanBe;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'QUICK ACTIONS'**
  String get quickActions;

  /// No description provided for @quickActions2.
  ///
  /// In en, this message translates to:
  /// **'Quick actions'**
  String get quickActions2;

  /// No description provided for @rccmAndTaxDocumentsAren.
  ///
  /// In en, this message translates to:
  /// **'RCCM and tax documents aren\'t required for your business type.'**
  String get rccmAndTaxDocumentsAren;

  /// No description provided for @rccmBusinessRegistration.
  ///
  /// In en, this message translates to:
  /// **'RCCM / Business Registration'**
  String get rccmBusinessRegistration;

  /// No description provided for @rccmBusinessRegistrationNumber.
  ///
  /// In en, this message translates to:
  /// **'RCCM / Business Registration Number'**
  String get rccmBusinessRegistrationNumber;

  /// No description provided for @rccmBusinessRegistrationNumberIf.
  ///
  /// In en, this message translates to:
  /// **'RCCM / Business Registration Number (if registered)'**
  String get rccmBusinessRegistrationNumberIf;

  /// No description provided for @rccmDocumentUploadedTapTo.
  ///
  /// In en, this message translates to:
  /// **'RCCM document uploaded — tap to replace'**
  String get rccmDocumentUploadedTapTo;

  /// No description provided for @rccmNumber.
  ///
  /// In en, this message translates to:
  /// **'RCCM number'**
  String get rccmNumber;

  /// No description provided for @rccmNumberIsRequired.
  ///
  /// In en, this message translates to:
  /// **'RCCM number is required'**
  String get rccmNumberIsRequired;

  /// No description provided for @reEnterYourNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Re-enter your new password'**
  String get reEnterYourNewPassword;

  /// No description provided for @reEnterYourPinTo.
  ///
  /// In en, this message translates to:
  /// **'Re-enter your PIN to confirm it\'s correct.'**
  String get reEnterYourPinTo;

  /// No description provided for @readDocumentation.
  ///
  /// In en, this message translates to:
  /// **'Read documentation'**
  String get readDocumentation;

  /// No description provided for @readyToGenerate.
  ///
  /// In en, this message translates to:
  /// **'Ready to generate'**
  String get readyToGenerate;

  /// No description provided for @realTimePaymentAndAccount.
  ///
  /// In en, this message translates to:
  /// **'Real-time payment and account alerts'**
  String get realTimePaymentAndAccount;

  /// No description provided for @receipt.
  ///
  /// In en, this message translates to:
  /// **'Receipt'**
  String get receipt;

  /// No description provided for @receiptDetails.
  ///
  /// In en, this message translates to:
  /// **'RECEIPT DETAILS'**
  String get receiptDetails;

  /// No description provided for @receiptFormatCheckoutModesAnd.
  ///
  /// In en, this message translates to:
  /// **'Receipt format, checkout modes, and terminal controls aren\'t '**
  String get receiptFormatCheckoutModesAnd;

  /// No description provided for @receiptFormatCheckoutModesAnd2.
  ///
  /// In en, this message translates to:
  /// **'Receipt format, checkout modes, and terminal controls aren\'t built yet — nothing here is saved.'**
  String get receiptFormatCheckoutModesAnd2;

  /// No description provided for @receiptRecorded.
  ///
  /// In en, this message translates to:
  /// **'Receipt recorded'**
  String get receiptRecorded;

  /// No description provided for @recentActivity.
  ///
  /// In en, this message translates to:
  /// **'RECENT ACTIVITY'**
  String get recentActivity;

  /// No description provided for @recentCashReceipts.
  ///
  /// In en, this message translates to:
  /// **'Recent cash receipts'**
  String get recentCashReceipts;

  /// No description provided for @recentExpenses.
  ///
  /// In en, this message translates to:
  /// **'Recent Expenses'**
  String get recentExpenses;

  /// No description provided for @recentLinks.
  ///
  /// In en, this message translates to:
  /// **'RECENT LINKS'**
  String get recentLinks;

  /// No description provided for @recentTransactions.
  ///
  /// In en, this message translates to:
  /// **'Recent Transactions'**
  String get recentTransactions;

  /// No description provided for @recentTransfers.
  ///
  /// In en, this message translates to:
  /// **'RECENT TRANSFERS'**
  String get recentTransfers;

  /// No description provided for @recordACashSale.
  ///
  /// In en, this message translates to:
  /// **'Record a cash sale'**
  String get recordACashSale;

  /// No description provided for @recording.
  ///
  /// In en, this message translates to:
  /// **'Recording…'**
  String get recording;

  /// No description provided for @reference.
  ///
  /// In en, this message translates to:
  /// **'Reference'**
  String get reference;

  /// No description provided for @referenceCopied.
  ///
  /// In en, this message translates to:
  /// **'Reference copied'**
  String get referenceCopied;

  /// No description provided for @refunds.
  ///
  /// In en, this message translates to:
  /// **'Refunds'**
  String get refunds;

  /// No description provided for @refundsIssued.
  ///
  /// In en, this message translates to:
  /// **'Refunds issued'**
  String get refundsIssued;

  /// No description provided for @registeredBusiness.
  ///
  /// In en, this message translates to:
  /// **'Registered Business'**
  String get registeredBusiness;

  /// No description provided for @registeredBusinessName.
  ///
  /// In en, this message translates to:
  /// **'Registered business name'**
  String get registeredBusinessName;

  /// No description provided for @representative.
  ///
  /// In en, this message translates to:
  /// **'Representative'**
  String get representative;

  /// No description provided for @requestUpgrade.
  ///
  /// In en, this message translates to:
  /// **'Request upgrade'**
  String get requestUpgrade;

  /// No description provided for @requireUnlockOnOpen.
  ///
  /// In en, this message translates to:
  /// **'Require unlock on open'**
  String get requireUnlockOnOpen;

  /// No description provided for @requiredLabel.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get requiredLabel;

  /// No description provided for @resend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get resend;

  /// No description provided for @resendCodeIn.
  ///
  /// In en, this message translates to:
  /// **'Resend code in '**
  String get resendCodeIn;

  /// No description provided for @resendLinkIn.
  ///
  /// In en, this message translates to:
  /// **'Resend link in '**
  String get resendLinkIn;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get resetPassword;

  /// No description provided for @resetPassword2.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword2;

  /// No description provided for @resetPin.
  ///
  /// In en, this message translates to:
  /// **'Reset PIN'**
  String get resetPin;

  /// No description provided for @retailWholesale.
  ///
  /// In en, this message translates to:
  /// **'Retail & Wholesale'**
  String get retailWholesale;

  /// No description provided for @revenue.
  ///
  /// In en, this message translates to:
  /// **'Revenue'**
  String get revenue;

  /// No description provided for @revenueCustomersAndRepeatOrders.
  ///
  /// In en, this message translates to:
  /// **'Revenue, customers, and repeat orders'**
  String get revenueCustomersAndRepeatOrders;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get saveChanges;

  /// No description provided for @saveCustomer.
  ///
  /// In en, this message translates to:
  /// **'Save customer'**
  String get saveCustomer;

  /// No description provided for @searchCustomers.
  ///
  /// In en, this message translates to:
  /// **'Search customers...'**
  String get searchCustomers;

  /// No description provided for @securityAccess.
  ///
  /// In en, this message translates to:
  /// **'Security & Access'**
  String get securityAccess;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// No description provided for @selectABusinessType.
  ///
  /// In en, this message translates to:
  /// **'Select a business type'**
  String get selectABusinessType;

  /// No description provided for @selectABusinessTypeTo.
  ///
  /// In en, this message translates to:
  /// **'Select a business type to proceed'**
  String get selectABusinessTypeTo;

  /// No description provided for @selectAnIndustry.
  ///
  /// In en, this message translates to:
  /// **'Select an industry'**
  String get selectAnIndustry;

  /// No description provided for @selectBusinessType.
  ///
  /// In en, this message translates to:
  /// **'Select business type'**
  String get selectBusinessType;

  /// No description provided for @selectCountry.
  ///
  /// In en, this message translates to:
  /// **'Select Country'**
  String get selectCountry;

  /// No description provided for @selectIndustry.
  ///
  /// In en, this message translates to:
  /// **'Select industry'**
  String get selectIndustry;

  /// No description provided for @selfie.
  ///
  /// In en, this message translates to:
  /// **'Selfie'**
  String get selfie;

  /// No description provided for @selfieCapturedTapToRetake.
  ///
  /// In en, this message translates to:
  /// **'Selfie captured — tap to retake'**
  String get selfieCapturedTapToRetake;

  /// No description provided for @sendAndReceiveUpTo.
  ///
  /// In en, this message translates to:
  /// **'Send and receive up to 5,000,000 XAF daily without restrictions.'**
  String get sendAndReceiveUpTo;

  /// No description provided for @sendCode.
  ///
  /// In en, this message translates to:
  /// **'Send Code'**
  String get sendCode;

  /// No description provided for @sendDetailsAndAttachmentsTo.
  ///
  /// In en, this message translates to:
  /// **'Send details and attachments to the support team.'**
  String get sendDetailsAndAttachmentsTo;

  /// No description provided for @sendPaymentPrompt.
  ///
  /// In en, this message translates to:
  /// **'Send payment prompt'**
  String get sendPaymentPrompt;

  /// No description provided for @sendingAConfirmationLinkTo.
  ///
  /// In en, this message translates to:
  /// **'Sending a confirmation link to'**
  String get sendingAConfirmationLinkTo;

  /// No description provided for @setTargetsForRevenueCustomers.
  ///
  /// In en, this message translates to:
  /// **'Set targets for revenue, customers, and repeat orders '**
  String get setTargetsForRevenueCustomers;

  /// No description provided for @setTargetsForRevenueCustomers2.
  ///
  /// In en, this message translates to:
  /// **'Set targets for revenue, customers, and repeat orders and watch progress against them.'**
  String get setTargetsForRevenueCustomers2;

  /// No description provided for @setTheAmountExplainThe.
  ///
  /// In en, this message translates to:
  /// **'Set the amount, explain the charge, and generate a shareable link for fast checkout.'**
  String get setTheAmountExplainThe;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @settled.
  ///
  /// In en, this message translates to:
  /// **'Settled'**
  String get settled;

  /// No description provided for @settlementAccount.
  ///
  /// In en, this message translates to:
  /// **'Settlement account'**
  String get settlementAccount;

  /// No description provided for @settlementAccount2.
  ///
  /// In en, this message translates to:
  /// **'Settlement Account'**
  String get settlementAccount2;

  /// No description provided for @settlementAccountAndFees.
  ///
  /// In en, this message translates to:
  /// **'Settlement account and fees'**
  String get settlementAccountAndFees;

  /// No description provided for @settlementUpdatesAndReports.
  ///
  /// In en, this message translates to:
  /// **'Settlement updates and reports'**
  String get settlementUpdatesAndReports;

  /// No description provided for @settlements.
  ///
  /// In en, this message translates to:
  /// **'Settlements'**
  String get settlements;

  /// No description provided for @setupChecklist.
  ///
  /// In en, this message translates to:
  /// **'Setup Checklist'**
  String get setupChecklist;

  /// No description provided for @setupOnboardingAndFirstTransaction.
  ///
  /// In en, this message translates to:
  /// **'Setup, onboarding, and first transaction flow.'**
  String get setupOnboardingAndFirstTransaction;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @shareSummary.
  ///
  /// In en, this message translates to:
  /// **'Share summary'**
  String get shareSummary;

  /// No description provided for @showYourQrSoCustomers.
  ///
  /// In en, this message translates to:
  /// **'Show your QR so customers can scan and pay.'**
  String get showYourQrSoCustomers;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @signInWithOtp.
  ///
  /// In en, this message translates to:
  /// **'Sign In with OTP'**
  String get signInWithOtp;

  /// No description provided for @signInWithOtpInstead.
  ///
  /// In en, this message translates to:
  /// **'Sign in with OTP instead'**
  String get signInWithOtpInstead;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @signOut2.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut2;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @signingOut.
  ///
  /// In en, this message translates to:
  /// **'Signing out…'**
  String get signingOut;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @smartCashManagement.
  ///
  /// In en, this message translates to:
  /// **'Smart Cash Management'**
  String get smartCashManagement;

  /// No description provided for @smsNotifications.
  ///
  /// In en, this message translates to:
  /// **'SMS notifications'**
  String get smsNotifications;

  /// No description provided for @somethingWentWrongPleaseTry.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong — please try again.'**
  String get somethingWentWrongPleaseTry;

  /// No description provided for @sourceWallet.
  ///
  /// In en, this message translates to:
  /// **'Source wallet'**
  String get sourceWallet;

  /// No description provided for @standardReviewTakes1224.
  ///
  /// In en, this message translates to:
  /// **'Standard review takes 12–24 hours'**
  String get standardReviewTakes1224;

  /// No description provided for @startAChat.
  ///
  /// In en, this message translates to:
  /// **'Start a chat'**
  String get startAChat;

  /// No description provided for @statement.
  ///
  /// In en, this message translates to:
  /// **'Statement'**
  String get statement;

  /// No description provided for @statements.
  ///
  /// In en, this message translates to:
  /// **'Statements'**
  String get statements;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @storeSendAndReceiveMoney.
  ///
  /// In en, this message translates to:
  /// **'Store, send, and receive money instantly with our secure multi-currency e-wallet.'**
  String get storeSendAndReceiveMoney;

  /// No description provided for @street.
  ///
  /// In en, this message translates to:
  /// **'Street'**
  String get street;

  /// No description provided for @streetAddress.
  ///
  /// In en, this message translates to:
  /// **'Street address'**
  String get streetAddress;

  /// No description provided for @streetAddressIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Street address is required'**
  String get streetAddressIsRequired;

  /// No description provided for @submitForReview.
  ///
  /// In en, this message translates to:
  /// **'Submit for review'**
  String get submitForReview;

  /// No description provided for @submitTransfer.
  ///
  /// In en, this message translates to:
  /// **'Submit transfer'**
  String get submitTransfer;

  /// No description provided for @summary.
  ///
  /// In en, this message translates to:
  /// **'SUMMARY'**
  String get summary;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @supportLegal.
  ///
  /// In en, this message translates to:
  /// **'Support & Legal'**
  String get supportLegal;

  /// No description provided for @takeAPhoto.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get takeAPhoto;

  /// No description provided for @takeAPhotoOrUpload.
  ///
  /// In en, this message translates to:
  /// **'Take a photo or upload your ID'**
  String get takeAPhotoOrUpload;

  /// No description provided for @takeASelfie.
  ///
  /// In en, this message translates to:
  /// **'Take a selfie'**
  String get takeASelfie;

  /// No description provided for @talkToTheTeamOr.
  ///
  /// In en, this message translates to:
  /// **'Talk to the team or send a ticket with logs.'**
  String get talkToTheTeamOr;

  /// No description provided for @target.
  ///
  /// In en, this message translates to:
  /// **'Target'**
  String get target;

  /// No description provided for @taxDocumentUploadedTapTo.
  ///
  /// In en, this message translates to:
  /// **'Tax document uploaded — tap to replace'**
  String get taxDocumentUploadedTapTo;

  /// No description provided for @taxIdentificationNiu.
  ///
  /// In en, this message translates to:
  /// **'Tax Identification (NIU)'**
  String get taxIdentificationNiu;

  /// No description provided for @taxIdentificationNumber.
  ///
  /// In en, this message translates to:
  /// **'Tax identification number'**
  String get taxIdentificationNumber;

  /// No description provided for @technology.
  ///
  /// In en, this message translates to:
  /// **'Technology'**
  String get technology;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @theCustomerApprovesOrDeclines.
  ///
  /// In en, this message translates to:
  /// **'The customer approves or declines on their own phone. '**
  String get theCustomerApprovesOrDeclines;

  /// No description provided for @theCustomerApprovesOrDeclines2.
  ///
  /// In en, this message translates to:
  /// **'The customer approves or declines on their own phone. You\'ll see the transaction update in Activity once they respond.'**
  String get theCustomerApprovesOrDeclines2;

  /// No description provided for @theNextBusinessDayYou.
  ///
  /// In en, this message translates to:
  /// **'the next business day. You can see each batch under Payments.'**
  String get theNextBusinessDayYou;

  /// No description provided for @thisSendsAPaymentPrompt.
  ///
  /// In en, this message translates to:
  /// **'This sends a payment prompt straight to an MTN '**
  String get thisSendsAPaymentPrompt;

  /// No description provided for @thisSendsAPaymentPrompt2.
  ///
  /// In en, this message translates to:
  /// **'This sends a payment prompt straight to an MTN MoMo number. For Orange Money or other methods, use a Payment Link or your QR Payment Page instead.'**
  String get thisSendsAPaymentPrompt2;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @topChannels.
  ///
  /// In en, this message translates to:
  /// **'Top channels'**
  String get topChannels;

  /// No description provided for @totalBudget.
  ///
  /// In en, this message translates to:
  /// **'TOTAL BUDGET'**
  String get totalBudget;

  /// No description provided for @totalExpenses.
  ///
  /// In en, this message translates to:
  /// **'TOTAL EXPENSES'**
  String get totalExpenses;

  /// No description provided for @totalRevenue.
  ///
  /// In en, this message translates to:
  /// **'TOTAL REVENUE'**
  String get totalRevenue;

  /// No description provided for @totalSaleAmount.
  ///
  /// In en, this message translates to:
  /// **'TOTAL SALE AMOUNT'**
  String get totalSaleAmount;

  /// No description provided for @totalSpent.
  ///
  /// In en, this message translates to:
  /// **'Total spent'**
  String get totalSpent;

  /// No description provided for @totalTransactions.
  ///
  /// In en, this message translates to:
  /// **'Total transactions'**
  String get totalTransactions;

  /// No description provided for @trackMerchantGrowth.
  ///
  /// In en, this message translates to:
  /// **'Track merchant growth'**
  String get trackMerchantGrowth;

  /// No description provided for @trackYourGrowth.
  ///
  /// In en, this message translates to:
  /// **'Track Your Growth'**
  String get trackYourGrowth;

  /// No description provided for @trackable.
  ///
  /// In en, this message translates to:
  /// **'Trackable'**
  String get trackable;

  /// No description provided for @transactionCount.
  ///
  /// In en, this message translates to:
  /// **'Transaction count'**
  String get transactionCount;

  /// No description provided for @transactionHistory.
  ///
  /// In en, this message translates to:
  /// **'Transaction history'**
  String get transactionHistory;

  /// No description provided for @transactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactions;

  /// No description provided for @transfer.
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get transfer;

  /// No description provided for @transferDetails.
  ///
  /// In en, this message translates to:
  /// **'TRANSFER DETAILS'**
  String get transferDetails;

  /// No description provided for @transferSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Transfer submitted'**
  String get transferSubmitted;

  /// No description provided for @transferSubmittedAndPayoutInitiated.
  ///
  /// In en, this message translates to:
  /// **'Transfer submitted and payout initiated successfully'**
  String get transferSubmittedAndPayoutInitiated;

  /// No description provided for @transportationLogistics.
  ///
  /// In en, this message translates to:
  /// **'Transportation & Logistics'**
  String get transportationLogistics;

  /// No description provided for @troubleshooting.
  ///
  /// In en, this message translates to:
  /// **'Troubleshooting'**
  String get troubleshooting;

  /// No description provided for @tulabixMerchantSupport.
  ///
  /// In en, this message translates to:
  /// **'TulaBix merchant support'**
  String get tulabixMerchantSupport;

  /// No description provided for @tulabizAnalyticsExport.
  ///
  /// In en, this message translates to:
  /// **'TulaBiz analytics export'**
  String get tulabizAnalyticsExport;

  /// No description provided for @tulabizCorporate.
  ///
  /// In en, this message translates to:
  /// **'TulaBiz Corporate'**
  String get tulabizCorporate;

  /// No description provided for @tulabizStatement.
  ///
  /// In en, this message translates to:
  /// **'TulaBiz statement'**
  String get tulabizStatement;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @unlockProfessionalFinancialToolsAnd.
  ///
  /// In en, this message translates to:
  /// **'Unlock professional financial tools and expand your business limits with TulaPay.'**
  String get unlockProfessionalFinancialToolsAnd;

  /// No description provided for @updateDetails.
  ///
  /// In en, this message translates to:
  /// **'Update details'**
  String get updateDetails;

  /// No description provided for @updatePassword.
  ///
  /// In en, this message translates to:
  /// **'Update password'**
  String get updatePassword;

  /// No description provided for @upgradeAccount.
  ///
  /// In en, this message translates to:
  /// **'Upgrade Account'**
  String get upgradeAccount;

  /// No description provided for @upgradeRequestedWeLlBe.
  ///
  /// In en, this message translates to:
  /// **'Upgrade requested — we\'ll be in touch'**
  String get upgradeRequestedWeLlBe;

  /// No description provided for @upgradeToTier2.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Tier 2'**
  String get upgradeToTier2;

  /// No description provided for @uploadAFilePdfOr.
  ///
  /// In en, this message translates to:
  /// **'Upload a file (PDF or image)'**
  String get uploadAFilePdfOr;

  /// No description provided for @uploadTheDocumentsBelowTake.
  ///
  /// In en, this message translates to:
  /// **'Upload the documents below — take a photo or upload a file directly.'**
  String get uploadTheDocumentsBelowTake;

  /// No description provided for @uploadTheirIdDocumentOptional.
  ///
  /// In en, this message translates to:
  /// **'Upload their ID document (optional)'**
  String get uploadTheirIdDocumentOptional;

  /// No description provided for @uploadYourRccmDocument.
  ///
  /// In en, this message translates to:
  /// **'Upload your RCCM document'**
  String get uploadYourRccmDocument;

  /// No description provided for @uploadYourTaxDocument.
  ///
  /// In en, this message translates to:
  /// **'Upload your tax document'**
  String get uploadYourTaxDocument;

  /// No description provided for @usageData.
  ///
  /// In en, this message translates to:
  /// **'Usage data'**
  String get usageData;

  /// No description provided for @useAtLeast8Characters.
  ///
  /// In en, this message translates to:
  /// **'Use at least 8 characters'**
  String get useAtLeast8Characters;

  /// No description provided for @usedToImproveReliabilityFraud.
  ///
  /// In en, this message translates to:
  /// **'Used to improve reliability, fraud prevention, and support.'**
  String get usedToImproveReliabilityFraud;

  /// No description provided for @verification.
  ///
  /// In en, this message translates to:
  /// **'Verification'**
  String get verification;

  /// No description provided for @verificationCode.
  ///
  /// In en, this message translates to:
  /// **'Verification code'**
  String get verificationCode;

  /// No description provided for @verificationInProgress.
  ///
  /// In en, this message translates to:
  /// **'Verification in progress'**
  String get verificationInProgress;

  /// No description provided for @verificationRejected.
  ///
  /// In en, this message translates to:
  /// **'Verification rejected'**
  String get verificationRejected;

  /// No description provided for @verified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get verified;

  /// No description provided for @verifyAccount.
  ///
  /// In en, this message translates to:
  /// **'Verify account'**
  String get verifyAccount;

  /// No description provided for @verifyCode.
  ///
  /// In en, this message translates to:
  /// **'Verify Code'**
  String get verifyCode;

  /// No description provided for @verifyProfile.
  ///
  /// In en, this message translates to:
  /// **'Verify profile'**
  String get verifyProfile;

  /// No description provided for @verifyYourBusinessInUnder.
  ///
  /// In en, this message translates to:
  /// **'Verify your business in under 5 minutes'**
  String get verifyYourBusinessInUnder;

  /// No description provided for @verifyYourPhone.
  ///
  /// In en, this message translates to:
  /// **'Verify Your Phone'**
  String get verifyYourPhone;

  /// No description provided for @verifyYourPhoneToReset.
  ///
  /// In en, this message translates to:
  /// **'Verify your phone to reset your password or PIN.'**
  String get verifyYourPhoneToReset;

  /// No description provided for @weHaveSentA6.
  ///
  /// In en, this message translates to:
  /// **'We have sent a 6-digit verification code to'**
  String get weHaveSentA6;

  /// No description provided for @weLlSendAnSms.
  ///
  /// In en, this message translates to:
  /// **'We\'ll send an SMS and push notifications once your account is active.'**
  String get weLlSendAnSms;

  /// No description provided for @weLlTextA6.
  ///
  /// In en, this message translates to:
  /// **'We\'ll text a 6-digit code to your registered phone number.'**
  String get weLlTextA6;

  /// No description provided for @weReReviewingYourDocuments.
  ///
  /// In en, this message translates to:
  /// **'We\'re reviewing your documents'**
  String get weReReviewingYourDocuments;

  /// No description provided for @weVeSentAConfirmation.
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent a confirmation link to'**
  String get weVeSentAConfirmation;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// No description provided for @whatAreTheFees.
  ///
  /// In en, this message translates to:
  /// **'What are the fees?'**
  String get whatAreTheFees;

  /// No description provided for @whatWouldYouLikeTo.
  ///
  /// In en, this message translates to:
  /// **'What would you like to reset?'**
  String get whatWouldYouLikeTo;

  /// No description provided for @whereShouldWeSendYour.
  ///
  /// In en, this message translates to:
  /// **'Where should we send your payouts?'**
  String get whereShouldWeSendYour;

  /// No description provided for @whereYouWillReceiveYour.
  ///
  /// In en, this message translates to:
  /// **'Where you will receive your payments'**
  String get whereYouWillReceiveYour;

  /// No description provided for @whyIsAPaymentStill.
  ///
  /// In en, this message translates to:
  /// **'Why is a payment still pending?'**
  String get whyIsAPaymentStill;

  /// No description provided for @youLlGetFullAccess.
  ///
  /// In en, this message translates to:
  /// **'You\'ll get full access to TulaBiz as soon as our team '**
  String get youLlGetFullAccess;

  /// No description provided for @youLlGetFullAccess2.
  ///
  /// In en, this message translates to:
  /// **'You\'ll get full access to TulaBiz as soon as our team approves your submission. Pull down to check again.'**
  String get youLlGetFullAccess2;

  /// No description provided for @youLlSeeTheTransaction.
  ///
  /// In en, this message translates to:
  /// **'You\'ll see the transaction update in Activity once they respond.'**
  String get youLlSeeTheTransaction;

  /// No description provided for @youReAllCaughtUp.
  ///
  /// In en, this message translates to:
  /// **'You\'re all caught up'**
  String get youReAllCaughtUp;

  /// No description provided for @youReNotYetEligible.
  ///
  /// In en, this message translates to:
  /// **'You\'re not yet eligible for a loan — lending isn\'t live on '**
  String get youReNotYetEligible;

  /// No description provided for @youReNotYetEligible2.
  ///
  /// In en, this message translates to:
  /// **'You\'re not yet eligible for a loan — lending isn\'t live on your account yet. We\'ll let you know as soon as it is.'**
  String get youReNotYetEligible2;

  /// No description provided for @your6DigitSecurityPin.
  ///
  /// In en, this message translates to:
  /// **'Your 6-digit security PIN has been created. Use it to authorize transactions.'**
  String get your6DigitSecurityPin;

  /// No description provided for @your6DigitTransactionPin.
  ///
  /// In en, this message translates to:
  /// **'Your 6-digit transaction PIN is managed separately and is required '**
  String get your6DigitTransactionPin;

  /// No description provided for @your6DigitTransactionPin2.
  ///
  /// In en, this message translates to:
  /// **'Your 6-digit transaction PIN is managed separately and is required for every payout regardless of this setting.'**
  String get your6DigitTransactionPin2;

  /// No description provided for @yourAccountYetWeLl.
  ///
  /// In en, this message translates to:
  /// **'your account yet. We\'ll let you know as soon as it is.'**
  String get yourAccountYetWeLl;

  /// No description provided for @yourAlwaysOnLinkCustomers.
  ///
  /// In en, this message translates to:
  /// **'Your always-on link customers can pay you from.'**
  String get yourAlwaysOnLinkCustomers;

  /// No description provided for @yourBusiness.
  ///
  /// In en, this message translates to:
  /// **'Your business'**
  String get yourBusiness;

  /// No description provided for @yourBusinessIsCurrentlyIn.
  ///
  /// In en, this message translates to:
  /// **'Your business is currently in our queue. Our security team verifies all new merchants to ensure network safety and compliance.'**
  String get yourBusinessIsCurrentlyIn;

  /// No description provided for @yourDataIsEncryptedAnd.
  ///
  /// In en, this message translates to:
  /// **'Your data is encrypted and handled according to CEMAC regulations.'**
  String get yourDataIsEncryptedAnd;

  /// No description provided for @yourPasswordHasBeenReset.
  ///
  /// In en, this message translates to:
  /// **'Your password has been reset. Sign in with your new password.'**
  String get yourPasswordHasBeenReset;

  /// No description provided for @yourPhoneIsVerifiedChoose.
  ///
  /// In en, this message translates to:
  /// **'Your phone is verified — choose one to continue.'**
  String get yourPhoneIsVerifiedChoose;

  /// No description provided for @yourPinHasBeenReset.
  ///
  /// In en, this message translates to:
  /// **'Your PIN has been reset. Sign in with your password as usual.'**
  String get yourPinHasBeenReset;

  /// No description provided for @yourPrivacyMattersTulabixLimited.
  ///
  /// In en, this message translates to:
  /// **'Your privacy matters. Tulabix Limited only collects the data needed to process payments, support merchants, and keep the platform secure. We do not sell merchant data.'**
  String get yourPrivacyMattersTulabixLimited;

  /// No description provided for @yourSupportRequestsAndPayments.
  ///
  /// In en, this message translates to:
  /// **'Your support requests and payments handled first.'**
  String get yourSupportRequestsAndPayments;

  /// No description provided for @otherLabel.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get otherLabel;

  /// No description provided for @businessTypeRegistered.
  ///
  /// In en, this message translates to:
  /// **'Registered business'**
  String get businessTypeRegistered;

  /// No description provided for @businessTypeInformal.
  ///
  /// In en, this message translates to:
  /// **'Informal / SME'**
  String get businessTypeInformal;

  /// No description provided for @businessTypeAssociation.
  ///
  /// In en, this message translates to:
  /// **'Association'**
  String get businessTypeAssociation;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @periodWeek.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get periodWeek;

  /// No description provided for @periodMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get periodMonth;

  /// No description provided for @periodQuarter.
  ///
  /// In en, this message translates to:
  /// **'Quarter'**
  String get periodQuarter;

  /// No description provided for @periodYear.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get periodYear;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'this week'**
  String get thisWeek;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'this month'**
  String get thisMonth;

  /// No description provided for @thisQuarter.
  ///
  /// In en, this message translates to:
  /// **'this quarter'**
  String get thisQuarter;

  /// No description provided for @thisYear.
  ///
  /// In en, this message translates to:
  /// **'this year'**
  String get thisYear;

  /// No description provided for @vsLastWeek.
  ///
  /// In en, this message translates to:
  /// **'vs last week'**
  String get vsLastWeek;

  /// No description provided for @vsLastMonth.
  ///
  /// In en, this message translates to:
  /// **'vs last month'**
  String get vsLastMonth;

  /// No description provided for @vsLastQuarter.
  ///
  /// In en, this message translates to:
  /// **'vs last quarter'**
  String get vsLastQuarter;

  /// No description provided for @vsLastYear.
  ///
  /// In en, this message translates to:
  /// **'vs last year'**
  String get vsLastYear;

  /// No description provided for @codeSentTo.
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent a 6-digit code to {phone}'**
  String codeSentTo(String phone);

  /// No description provided for @ownerNumber.
  ///
  /// In en, this message translates to:
  /// **'Owner {n}'**
  String ownerNumber(int n);

  /// No description provided for @percentUsed.
  ///
  /// In en, this message translates to:
  /// **'{pct}% Used'**
  String percentUsed(String pct);

  /// No description provided for @amountUsed.
  ///
  /// In en, this message translates to:
  /// **'{amount} Used'**
  String amountUsed(String amount);

  /// No description provided for @weekNumber.
  ///
  /// In en, this message translates to:
  /// **'Week {n}'**
  String weekNumber(int n);

  /// No description provided for @nextDate.
  ///
  /// In en, this message translates to:
  /// **'Next: {date}'**
  String nextDate(String date);

  /// No description provided for @txnsUnit.
  ///
  /// In en, this message translates to:
  /// **'txns'**
  String get txnsUnit;

  /// No description provided for @countToReview.
  ///
  /// In en, this message translates to:
  /// **'{count} to review'**
  String countToReview(int count);

  /// No description provided for @paymentsFailedToSettle.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 payment failed to settle} other{{count} payments failed to settle}}'**
  String paymentsFailedToSettle(int count);

  /// No description provided for @amountNeedsReview.
  ///
  /// In en, this message translates to:
  /// **'{amount} needs review.'**
  String amountNeedsReview(String amount);

  /// No description provided for @transactionsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} transactions'**
  String transactionsCount(int count);

  /// No description provided for @ofAmountIn.
  ///
  /// In en, this message translates to:
  /// **'of {amount} in'**
  String ofAmountIn(String amount);

  /// No description provided for @typePayment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get typePayment;

  /// No description provided for @typeRefund.
  ///
  /// In en, this message translates to:
  /// **'Refund'**
  String get typeRefund;

  /// No description provided for @typePayout.
  ///
  /// In en, this message translates to:
  /// **'Payout'**
  String get typePayout;

  /// No description provided for @typeLoanDisbursement.
  ///
  /// In en, this message translates to:
  /// **'Loan disbursement'**
  String get typeLoanDisbursement;

  /// No description provided for @typeLoanRepayment.
  ///
  /// In en, this message translates to:
  /// **'Loan repayment'**
  String get typeLoanRepayment;

  /// No description provided for @channelCard.
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get channelCard;

  /// No description provided for @channelMobileMoney.
  ///
  /// In en, this message translates to:
  /// **'Mobile money'**
  String get channelMobileMoney;

  /// No description provided for @channelCash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get channelCash;

  /// No description provided for @statusScheduled.
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get statusScheduled;

  /// No description provided for @statusRefunded.
  ///
  /// In en, this message translates to:
  /// **'Refunded'**
  String get statusRefunded;

  /// No description provided for @customerActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get customerActive;

  /// No description provided for @customerRecent.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get customerRecent;

  /// No description provided for @customerDormant.
  ///
  /// In en, this message translates to:
  /// **'Dormant'**
  String get customerDormant;

  /// No description provided for @tierStarter.
  ///
  /// In en, this message translates to:
  /// **'Starter'**
  String get tierStarter;

  /// No description provided for @tierGrowth.
  ///
  /// In en, this message translates to:
  /// **'Growth'**
  String get tierGrowth;

  /// No description provided for @tierScale.
  ///
  /// In en, this message translates to:
  /// **'Scale'**
  String get tierScale;

  /// No description provided for @itemsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} items'**
  String itemsCount(int count);

  /// No description provided for @tulabixTransaction.
  ///
  /// In en, this message translates to:
  /// **'TulaBix transaction {id}'**
  String tulabixTransaction(String id);

  /// No description provided for @vsLastWeekTpv.
  ///
  /// In en, this message translates to:
  /// **'vs last week · 30d TPV: {amount}'**
  String vsLastWeekTpv(String amount);

  /// No description provided for @catGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get catGeneral;

  /// No description provided for @catFood.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get catFood;

  /// No description provided for @catFashion.
  ///
  /// In en, this message translates to:
  /// **'Fashion'**
  String get catFashion;

  /// No description provided for @catServices.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get catServices;

  /// No description provided for @recordedAmount.
  ///
  /// In en, this message translates to:
  /// **'Recorded {amount}'**
  String recordedAmount(String amount);

  /// No description provided for @recordedAmountFrom.
  ///
  /// In en, this message translates to:
  /// **'Recorded {amount} from {customer}'**
  String recordedAmountFrom(String amount, String customer);

  /// No description provided for @couldNotRecordReceipt.
  ///
  /// In en, this message translates to:
  /// **'Could not record receipt: {error}'**
  String couldNotRecordReceipt(String error);

  /// No description provided for @checklistProgress.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total} done — finish these to go live.'**
  String checklistProgress(int done, int total);

  /// No description provided for @momoPromptSent.
  ///
  /// In en, this message translates to:
  /// **'MoMo prompt for {amount} sent to {phone}'**
  String momoPromptSent(String amount, String phone);

  /// No description provided for @couldNotSendPrompt.
  ///
  /// In en, this message translates to:
  /// **'Could not send payment prompt: {error}'**
  String couldNotSendPrompt(String error);

  /// No description provided for @createdPaymentLinkFor.
  ///
  /// In en, this message translates to:
  /// **'Created payment link for {amount} — {description}'**
  String createdPaymentLinkFor(String amount, String description);

  /// No description provided for @couldNotGenerateLink.
  ///
  /// In en, this message translates to:
  /// **'Could not generate link: {error}'**
  String couldNotGenerateLink(String error);

  /// No description provided for @sharePayAmount.
  ///
  /// In en, this message translates to:
  /// **'Pay {amount}: {url}'**
  String sharePayAmount(String amount, String url);

  /// No description provided for @sharePaySecurely.
  ///
  /// In en, this message translates to:
  /// **'Pay {business} securely: {url}'**
  String sharePaySecurely(String business, String url);

  /// No description provided for @statusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get statusActive;

  /// No description provided for @recentLabel.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get recentLabel;

  /// No description provided for @grossFeesLine.
  ///
  /// In en, this message translates to:
  /// **'Gross {gross} · Fees {fees} · {account}'**
  String grossFeesLine(String gross, String fees, String account);

  /// No description provided for @percentOff.
  ///
  /// In en, this message translates to:
  /// **'{percent}% off'**
  String percentOff(int percent);

  /// No description provided for @timesUsed.
  ///
  /// In en, this message translates to:
  /// **'{count} used'**
  String timesUsed(int count);

  /// No description provided for @verificationLine.
  ///
  /// In en, this message translates to:
  /// **'KYC {kyc} · Tier {tier} · Account {account}'**
  String verificationLine(String kyc, String tier, String account);

  /// No description provided for @currentOfTarget.
  ///
  /// In en, this message translates to:
  /// **'{current} of {target}'**
  String currentOfTarget(String current, String target);

  /// No description provided for @dateRangeTo.
  ///
  /// In en, this message translates to:
  /// **'{start} to {end}'**
  String dateRangeTo(String start, String end);

  /// No description provided for @enterThe.
  ///
  /// In en, this message translates to:
  /// **'Enter the {field}'**
  String enterThe(String field);

  /// No description provided for @transferToDestination.
  ///
  /// In en, this message translates to:
  /// **'{amount} transfer to {destination}'**
  String transferToDestination(String amount, String destination);

  /// No description provided for @transferRecordedPayoutFailed.
  ///
  /// In en, this message translates to:
  /// **'Transfer recorded, but payout failed: {error}'**
  String transferRecordedPayoutFailed(String error);

  /// No description provided for @couldNotSubmitTransfer.
  ///
  /// In en, this message translates to:
  /// **'Could not submit transfer: {error}'**
  String couldNotSubmitTransfer(String error);

  /// No description provided for @tooltipIn.
  ///
  /// In en, this message translates to:
  /// **'In'**
  String get tooltipIn;

  /// No description provided for @tooltipOut.
  ///
  /// In en, this message translates to:
  /// **'Out'**
  String get tooltipOut;

  /// No description provided for @stateOn.
  ///
  /// In en, this message translates to:
  /// **'ON'**
  String get stateOn;

  /// No description provided for @stateOff.
  ///
  /// In en, this message translates to:
  /// **'OFF'**
  String get stateOff;

  /// No description provided for @copiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get copiedToClipboard;

  /// No description provided for @nothingCanOpenLink.
  ///
  /// In en, this message translates to:
  /// **'Nothing on this device can open that link'**
  String get nothingCanOpenLink;

  /// No description provided for @supportEmailCopied.
  ///
  /// In en, this message translates to:
  /// **'Support email copied'**
  String get supportEmailCopied;

  /// No description provided for @sourceLabelBank.
  ///
  /// In en, this message translates to:
  /// **'Bank account'**
  String get sourceLabelBank;

  /// No description provided for @signedOutInactivity.
  ///
  /// In en, this message translates to:
  /// **'You were signed out after a period of inactivity.'**
  String get signedOutInactivity;

  /// No description provided for @paymentCompletedTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment Completed 🎉'**
  String get paymentCompletedTitle;

  /// No description provided for @payoutCompletedTitle.
  ///
  /// In en, this message translates to:
  /// **'Payout Completed 🎉'**
  String get payoutCompletedTitle;

  /// No description provided for @transactionCompletedTitle.
  ///
  /// In en, this message translates to:
  /// **'Transaction Completed 🎉'**
  String get transactionCompletedTitle;

  /// No description provided for @processedAmount.
  ///
  /// In en, this message translates to:
  /// **'Successfully processed {amount}'**
  String processedAmount(String amount);

  /// No description provided for @fromCounterparty.
  ///
  /// In en, this message translates to:
  /// **' from {name}'**
  String fromCounterparty(String name);

  /// No description provided for @viaChannel.
  ///
  /// In en, this message translates to:
  /// **' via {channel}'**
  String viaChannel(String channel);

  /// No description provided for @notificationDefaultTitle.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get notificationDefaultTitle;
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
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
