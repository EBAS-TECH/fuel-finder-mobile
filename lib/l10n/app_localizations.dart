import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_am.dart';
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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('am'),
    Locale('en')
  ];

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your email and password to sign in'**
  String get loginSubtitle;

  /// No description provided for @usernameLabel.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get usernameLabel;

  /// No description provided for @usernameError.
  ///
  /// In en, this message translates to:
  /// **'Username is required'**
  String get usernameError;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @passwordErrorEmpty.
  ///
  /// In en, this message translates to:
  /// **'Password field must be filled'**
  String get passwordErrorEmpty;

  /// No description provided for @passwordErrorLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters long'**
  String get passwordErrorLength;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'SIGN IN'**
  String get loginButton;

  /// No description provided for @notRegistered.
  ///
  /// In en, this message translates to:
  /// **'Not registered yet? '**
  String get notRegistered;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get registerTitle;

  /// No description provided for @registerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your email and create a password to sign up'**
  String get registerSubtitle;

  /// No description provided for @firstNameLabel.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstNameLabel;

  /// No description provided for @firstNameError.
  ///
  /// In en, this message translates to:
  /// **'First name is required'**
  String get firstNameError;

  /// No description provided for @lastNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastNameLabel;

  /// No description provided for @lastNameError.
  ///
  /// In en, this message translates to:
  /// **'Last name is required'**
  String get lastNameError;

  /// No description provided for @usernameErrorLength.
  ///
  /// In en, this message translates to:
  /// **'Username must be at least 4 characters'**
  String get usernameErrorLength;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @emailError.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailError;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid email format'**
  String get emailInvalid;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPasswordLabel;

  /// No description provided for @confirmPasswordError.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get confirmPasswordError;

  /// No description provided for @registerButton.
  ///
  /// In en, this message translates to:
  /// **'SIGN UP'**
  String get registerButton;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @verifyEmailTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify Your Email'**
  String get verifyEmailTitle;

  /// No description provided for @verificationCodeSent.
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent a 6-digit verification code to'**
  String get verificationCodeSent;

  /// No description provided for @enterVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'Please enter the verification code'**
  String get enterVerificationCode;

  /// No description provided for @verifyAccount.
  ///
  /// In en, this message translates to:
  /// **'Verify Account'**
  String get verifyAccount;

  /// No description provided for @didNotReceiveCode.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive a code? '**
  String get didNotReceiveCode;

  /// No description provided for @resend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get resend;

  /// No description provided for @resendIn.
  ///
  /// In en, this message translates to:
  /// **'Resend in'**
  String get resendIn;

  /// No description provided for @backToRegistration.
  ///
  /// In en, this message translates to:
  /// **'Back to registration'**
  String get backToRegistration;

  /// No description provided for @invalidCode.
  ///
  /// In en, this message translates to:
  /// **'Invalid verification code'**
  String get invalidCode;

  /// No description provided for @verifyEmailTitleUnverified.
  ///
  /// In en, this message translates to:
  /// **'Email not verified'**
  String get verifyEmailTitleUnverified;

  /// No description provided for @mustVerifyEmail.
  ///
  /// In en, this message translates to:
  /// **'You must verify your email to use our app'**
  String get mustVerifyEmail;

  /// No description provided for @backToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to login'**
  String get backToLogin;

  /// No description provided for @gasStation.
  ///
  /// In en, this message translates to:
  /// **'Gas Station'**
  String get gasStation;

  /// No description provided for @noFuelInfo.
  ///
  /// In en, this message translates to:
  /// **'No fuel info'**
  String get noFuelInfo;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @distance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get distance;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'available'**
  String get available;

  /// No description provided for @showRoute.
  ///
  /// In en, this message translates to:
  /// **'Show route'**
  String get showRoute;

  /// No description provided for @moreDetails.
  ///
  /// In en, this message translates to:
  /// **'Station details'**
  String get moreDetails;

  /// No description provided for @nearbyGasStations.
  ///
  /// In en, this message translates to:
  /// **'Nearby Gas Stations'**
  String get nearbyGasStations;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @petrol.
  ///
  /// In en, this message translates to:
  /// **'Petrol'**
  String get petrol;

  /// No description provided for @diesel.
  ///
  /// In en, this message translates to:
  /// **'Diesel'**
  String get diesel;

  /// No description provided for @noStationsFound.
  ///
  /// In en, this message translates to:
  /// **'No stations found'**
  String get noStationsFound;

  /// No description provided for @suggested.
  ///
  /// In en, this message translates to:
  /// **'Suggested'**
  String get suggested;

  /// No description provided for @suggestionTooltip.
  ///
  /// In en, this message translates to:
  /// **'This suggestion is made based on the station\'s ratings and user votes'**
  String get suggestionTooltip;

  /// No description provided for @locationPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Location permission is required to access your location'**
  String get locationPermissionRequired;

  /// No description provided for @heyThere.
  ///
  /// In en, this message translates to:
  /// **'Hey There'**
  String get heyThere;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOut;

  /// No description provided for @logOutConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out of your account?'**
  String get logOutConfirmation;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get myProfile;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @memberSince.
  ///
  /// In en, this message translates to:
  /// **'Member Since'**
  String get memberSince;

  /// No description provided for @accountStatus.
  ///
  /// In en, this message translates to:
  /// **'Account Status'**
  String get accountStatus;

  /// No description provided for @verified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get verified;

  /// No description provided for @notVerified.
  ///
  /// In en, this message translates to:
  /// **'Not Verified'**
  String get notVerified;

  /// No description provided for @notProvided.
  ///
  /// In en, this message translates to:
  /// **'Not provided'**
  String get notProvided;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'An error occurred. Please try again'**
  String get unknown;

  /// No description provided for @errorLoadingProfile.
  ///
  /// In en, this message translates to:
  /// **'Error loading profile'**
  String get errorLoadingProfile;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @notRated.
  ///
  /// In en, this message translates to:
  /// **'Not Rated'**
  String get notRated;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @favorite.
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get favorite;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @favoritesTitle.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favoritesTitle;

  /// No description provided for @removeFavorite.
  ///
  /// In en, this message translates to:
  /// **'Remove Favorite'**
  String get removeFavorite;

  /// No description provided for @removeFavoriteConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove {stationName} from favorites?'**
  String removeFavoriteConfirmation(Object stationName);

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @noFavoritesYet.
  ///
  /// In en, this message translates to:
  /// **'No Favorites yet'**
  String get noFavoritesYet;

  /// No description provided for @addFavoritesHint.
  ///
  /// In en, this message translates to:
  /// **'Tap the heart icon on a gas station to favorite it'**
  String get addFavoritesHint;

  /// No description provided for @errorLoadingFavorites.
  ///
  /// In en, this message translates to:
  /// **'Error loading favorites'**
  String get errorLoadingFavorites;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @noFuel.
  ///
  /// In en, this message translates to:
  /// **'No fuel'**
  String get noFuel;

  /// No description provided for @averageRating.
  ///
  /// In en, this message translates to:
  /// **'Average Rating'**
  String get averageRating;

  /// No description provided for @stationDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Fuel Station Details'**
  String get stationDetailsTitle;

  /// No description provided for @yourRatingLabel.
  ///
  /// In en, this message translates to:
  /// **'Your Rating'**
  String get yourRatingLabel;

  /// No description provided for @ratedMessage.
  ///
  /// In en, this message translates to:
  /// **'You rated this station'**
  String get ratedMessage;

  /// No description provided for @yourCommentLabel.
  ///
  /// In en, this message translates to:
  /// **'Your Comment'**
  String get yourCommentLabel;

  /// No description provided for @commentHint.
  ///
  /// In en, this message translates to:
  /// **'Share your experience...'**
  String get commentHint;

  /// No description provided for @editButton.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editButton;

  /// No description provided for @updateButton.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get updateButton;

  /// No description provided for @submitButton.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submitButton;

  /// No description provided for @updateFeedbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Update Feedback'**
  String get updateFeedbackTitle;

  /// No description provided for @submitFeedbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Submit Feedback'**
  String get submitFeedbackTitle;

  /// No description provided for @updateFeedbackConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to update your feedback?'**
  String get updateFeedbackConfirmation;

  /// No description provided for @submitFeedbackConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to submit your feedback?'**
  String get submitFeedbackConfirmation;

  /// No description provided for @feedbackEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Please provide a rating or comment'**
  String get feedbackEmptyError;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @distanceUnit.
  ///
  /// In en, this message translates to:
  /// **'km'**
  String get distanceUnit;

  /// No description provided for @suggestedBadge.
  ///
  /// In en, this message translates to:
  /// **'Suggested'**
  String get suggestedBadge;

  /// No description provided for @kmAway.
  ///
  /// In en, this message translates to:
  /// **'{distance} km'**
  String kmAway(Object distance);

  /// No description provided for @fuelTypes.
  ///
  /// In en, this message translates to:
  /// **'Fuel types: {types}'**
  String fuelTypes(Object types);

  /// No description provided for @noFuelInformation.
  ///
  /// In en, this message translates to:
  /// **'No fuel information'**
  String get noFuelInformation;

  /// Confirmation message shown before submitting or updating feedback
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to {action} your feedback?'**
  String feedbackConfirmation(Object action);

  /// No description provided for @fuelPricesTitle.
  ///
  /// In en, this message translates to:
  /// **'Fuel Prices'**
  String get fuelPricesTitle;

  /// No description provided for @pricePerLiter.
  ///
  /// In en, this message translates to:
  /// **'{price}Br/L'**
  String pricePerLiter(Object price);

  /// No description provided for @since.
  ///
  /// In en, this message translates to:
  /// **'Since'**
  String get since;

  /// No description provided for @effectiveUntil.
  ///
  /// In en, this message translates to:
  /// **'Effective until'**
  String get effectiveUntil;

  /// No description provided for @source.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get source;

  /// No description provided for @ministryOfMines.
  ///
  /// In en, this message translates to:
  /// **'Ministry of Mines and Petroleum'**
  String get ministryOfMines;

  /// No description provided for @noPriceData.
  ///
  /// In en, this message translates to:
  /// **'No fuel price data'**
  String get noPriceData;

  /// No description provided for @errorLoadingPrices.
  ///
  /// In en, this message translates to:
  /// **'Error loading fuel prices'**
  String get errorLoadingPrices;

  /// No description provided for @editProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfileTitle;

  /// No description provided for @profileInformation.
  ///
  /// In en, this message translates to:
  /// **'Profile Information'**
  String get profileInformation;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currentPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @confirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get confirmNewPassword;

  /// No description provided for @passwordRequirement.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters long'**
  String get passwordRequirement;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'SAVE CHANGES'**
  String get saveChanges;

  /// No description provided for @profileUpdateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdateSuccess;

  /// No description provided for @passwordChangeSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully'**
  String get passwordChangeSuccess;

  /// No description provided for @fillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill all fields'**
  String get fillAllFields;

  /// No description provided for @passwordsDontMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDontMatch;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters long'**
  String get passwordTooShort;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your email to receive a password reset code'**
  String get forgotPasswordSubtitle;

  /// No description provided for @sendCodeButton.
  ///
  /// In en, this message translates to:
  /// **'SEND CODE'**
  String get sendCodeButton;

  /// No description provided for @resetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPasswordTitle;

  /// No description provided for @resetPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the code sent to your email and set a new password'**
  String get resetPasswordSubtitle;

  /// No description provided for @newPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPasswordLabel;

  /// No description provided for @confirmNewPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get confirmNewPasswordLabel;

  /// No description provided for @resetPasswordButton.
  ///
  /// In en, this message translates to:
  /// **'RESET PASSWORD'**
  String get resetPasswordButton;

  /// No description provided for @codeVerificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Code Verification'**
  String get codeVerificationTitle;

  /// No description provided for @codeVerificationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code sent to your email'**
  String get codeVerificationSubtitle;

  /// No description provided for @codeVerificationError.
  ///
  /// In en, this message translates to:
  /// **'Incorrect verifcation code'**
  String get codeVerificationError;

  /// No description provided for @verifyButton.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verifyButton;

  /// No description provided for @signup.
  ///
  /// In en, this message translates to:
  /// **'Registration successful'**
  String get signup;

  /// No description provided for @signin.
  ///
  /// In en, this message translates to:
  /// **'Login successful'**
  String get signin;

  /// No description provided for @verifyEmail.
  ///
  /// In en, this message translates to:
  /// **'Email verification successful. Please login'**
  String get verifyEmail;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout successful'**
  String get logout;

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Verification code resent'**
  String get resendCode;

  /// No description provided for @forgotVerify.
  ///
  /// In en, this message translates to:
  /// **'Code verified. Set a new password'**
  String get forgotVerify;

  /// No description provided for @setNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Password updated successfully. Please login'**
  String get setNewPassword;

  /// No description provided for @profileUpdate.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdate;

  /// No description provided for @passwordChange.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully'**
  String get passwordChange;

  /// No description provided for @conflict.
  ///
  /// In en, this message translates to:
  /// **'User already exists'**
  String get conflict;

  /// No description provided for @unauthorized.
  ///
  /// In en, this message translates to:
  /// **'Invalid credentials'**
  String get unauthorized;

  /// No description provided for @notFound.
  ///
  /// In en, this message translates to:
  /// **'User not found'**
  String get notFound;

  /// No description provided for @serverError.
  ///
  /// In en, this message translates to:
  /// **'Server error. Please try again'**
  String get serverError;

  /// No description provided for @noInternet.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get noInternet;

  /// No description provided for @timeout.
  ///
  /// In en, this message translates to:
  /// **'Request timed out'**
  String get timeout;

  /// No description provided for @invalidInput.
  ///
  /// In en, this message translates to:
  /// **'Invalid input'**
  String get invalidInput;

  /// No description provided for @passwordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordMismatch;

  /// No description provided for @viewNearbyStations.
  ///
  /// In en, this message translates to:
  /// **'View nearby stations'**
  String get viewNearbyStations;

  /// No description provided for @locationNotLoaded.
  ///
  /// In en, this message translates to:
  /// **'Please wait while we load your location'**
  String get locationNotLoaded;

  /// No description provided for @changeProfilePicture.
  ///
  /// In en, this message translates to:
  /// **'Change Profile Picture'**
  String get changeProfilePicture;

  /// No description provided for @imagePickerError.
  ///
  /// In en, this message translates to:
  /// **'Failed to pick image'**
  String get imagePickerError;

  /// No description provided for @storagePermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Storage permission is required to select images'**
  String get storagePermissionDenied;

  /// No description provided for @cameraPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Camera permission is required to take photos'**
  String get cameraPermissionDenied;

  /// No description provided for @passwordErrorLetterNumberCombo.
  ///
  /// In en, this message translates to:
  /// **'Must contain combination of letters and numbers'**
  String get passwordErrorLetterNumberCombo;

  /// No description provided for @passwordErrorTooCommon.
  ///
  /// In en, this message translates to:
  /// **'This password is too common and insecure'**
  String get passwordErrorTooCommon;

  /// No description provided for @passwordErrorUppercase.
  ///
  /// In en, this message translates to:
  /// **'Must contain at least one uppercase letter'**
  String get passwordErrorUppercase;

  /// No description provided for @passwordErrorLowercase.
  ///
  /// In en, this message translates to:
  /// **'Must contain at least one lowercase letter'**
  String get passwordErrorLowercase;

  /// No description provided for @passwordErrorNumber.
  ///
  /// In en, this message translates to:
  /// **'Must contain at least one number'**
  String get passwordErrorNumber;

  /// No description provided for @passwordErrorSpecialChar.
  ///
  /// In en, this message translates to:
  /// **'Must contain at least one special character'**
  String get passwordErrorSpecialChar;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['am', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'am': return AppLocalizationsAm();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
