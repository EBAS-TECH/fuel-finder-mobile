// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get loginTitle => 'Login';

  @override
  String get loginSubtitle => 'Enter your email and password to sign in';

  @override
  String get usernameLabel => 'Username';

  @override
  String get usernameError => 'Username is required';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordErrorEmpty => 'Password field must be filled';

  @override
  String get passwordErrorLength => 'Password must be at least 8 characters long';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get loginButton => 'SIGN IN';

  @override
  String get notRegistered => 'Not registered yet? ';

  @override
  String get register => 'Register';

  @override
  String get registerTitle => 'Create Account';

  @override
  String get registerSubtitle => 'Enter your email and create a password to sign up';

  @override
  String get firstNameLabel => 'First Name';

  @override
  String get firstNameError => 'First name is required';

  @override
  String get lastNameLabel => 'Last Name';

  @override
  String get lastNameError => 'Last name is required';

  @override
  String get usernameErrorLength => 'Username must be at least 4 characters';

  @override
  String get emailLabel => 'Email';

  @override
  String get emailError => 'Email is required';

  @override
  String get emailInvalid => 'Invalid email format';

  @override
  String get confirmPasswordLabel => 'Confirm Password';

  @override
  String get confirmPasswordError => 'Passwords do not match';

  @override
  String get registerButton => 'SIGN UP';

  @override
  String get alreadyHaveAccount => 'Already have an account? ';

  @override
  String get login => 'Login';

  @override
  String get verifyEmailTitle => 'Verify Your Email';

  @override
  String get verificationCodeSent => 'We\'ve sent a 6-digit verification code to';

  @override
  String get enterVerificationCode => 'Please enter the verification code';

  @override
  String get verifyAccount => 'Verify Account';

  @override
  String get didNotReceiveCode => 'Didn\'t receive a code? ';

  @override
  String get resend => 'Resend';

  @override
  String get resendIn => 'Resend in';

  @override
  String get backToRegistration => 'Back to registration';

  @override
  String get invalidCode => 'Invalid verification code';

  @override
  String get verifyEmailTitleUnverified => 'Email not verified';

  @override
  String get mustVerifyEmail => 'You must verify your email to use our app';

  @override
  String get backToLogin => 'Back to login';

  @override
  String get gasStation => 'Gas Station';

  @override
  String get noFuelInfo => 'No fuel info';

  @override
  String get loading => 'Loading...';

  @override
  String get distance => 'Distance';

  @override
  String get duration => 'Duration';

  @override
  String get available => 'available';

  @override
  String get showRoute => 'Show route';

  @override
  String get moreDetails => 'Station details';

  @override
  String get nearbyGasStations => 'Nearby Gas Stations';

  @override
  String get all => 'All';

  @override
  String get petrol => 'Petrol';

  @override
  String get diesel => 'Diesel';

  @override
  String get noStationsFound => 'No stations found';

  @override
  String get suggested => 'Suggested';

  @override
  String get suggestionTooltip => 'This suggestion is made based on the station\'s ratings and user votes';

  @override
  String get locationPermissionRequired => 'Location permission is required to access your location';

  @override
  String get heyThere => 'Hey There';

  @override
  String get logOut => 'Log Out';

  @override
  String get logOutConfirmation => 'Are you sure you want to log out of your account?';

  @override
  String get cancel => 'Cancel';

  @override
  String get myProfile => 'My Profile';

  @override
  String get username => 'Username';

  @override
  String get memberSince => 'Member Since';

  @override
  String get accountStatus => 'Account Status';

  @override
  String get verified => 'Verified';

  @override
  String get notVerified => 'Not Verified';

  @override
  String get notProvided => 'Not provided';

  @override
  String get unknown => 'An error occurred. Please try again';

  @override
  String get errorLoadingProfile => 'Error loading profile';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get notRated => 'Not Rated';

  @override
  String get home => 'Home';

  @override
  String get favorite => 'Favorite';

  @override
  String get price => 'Price';

  @override
  String get profile => 'Profile';

  @override
  String get favoritesTitle => 'Favorites';

  @override
  String get removeFavorite => 'Remove Favorite';

  @override
  String removeFavoriteConfirmation(Object stationName) {
    return 'Are you sure you want to remove $stationName from favorites?';
  }

  @override
  String get remove => 'Remove';

  @override
  String get noFavoritesYet => 'No Favorites yet';

  @override
  String get addFavoritesHint => 'Tap the heart icon on a gas station to favorite it';

  @override
  String get errorLoadingFavorites => 'Error loading favorites';

  @override
  String get retry => 'Retry';

  @override
  String get address => 'Address';

  @override
  String get noFuel => 'No fuel';

  @override
  String get averageRating => 'Average Rating';

  @override
  String get stationDetailsTitle => 'Fuel Station Details';

  @override
  String get yourRatingLabel => 'Your Rating';

  @override
  String get ratedMessage => 'You rated this station';

  @override
  String get yourCommentLabel => 'Your Comment';

  @override
  String get commentHint => 'Share your experience...';

  @override
  String get editButton => 'Edit';

  @override
  String get updateButton => 'Update';

  @override
  String get submitButton => 'Submit';

  @override
  String get updateFeedbackTitle => 'Update Feedback';

  @override
  String get submitFeedbackTitle => 'Submit Feedback';

  @override
  String get updateFeedbackConfirmation => 'Are you sure you want to update your feedback?';

  @override
  String get submitFeedbackConfirmation => 'Are you sure you want to submit your feedback?';

  @override
  String get feedbackEmptyError => 'Please provide a rating or comment';

  @override
  String get confirm => 'Confirm';

  @override
  String get distanceUnit => 'km';

  @override
  String get suggestedBadge => 'Suggested';

  @override
  String kmAway(Object distance) {
    return '$distance km';
  }

  @override
  String fuelTypes(Object types) {
    return 'Fuel types: $types';
  }

  @override
  String get noFuelInformation => 'No fuel information';

  @override
  String feedbackConfirmation(Object action) {
    return 'Are you sure you want to $action your feedback?';
  }

  @override
  String get fuelPricesTitle => 'Fuel Prices';

  @override
  String pricePerLiter(Object price) {
    return '${price}Br/L';
  }

  @override
  String get since => 'Since';

  @override
  String get effectiveUntil => 'Effective until';

  @override
  String get source => 'Source';

  @override
  String get ministryOfMines => 'Ministry of Mines and Petroleum';

  @override
  String get noPriceData => 'No fuel price data';

  @override
  String get errorLoadingPrices => 'Error loading fuel prices';

  @override
  String get editProfileTitle => 'Edit Profile';

  @override
  String get profileInformation => 'Profile Information';

  @override
  String get changePassword => 'Change Password';

  @override
  String get currentPassword => 'Current Password';

  @override
  String get newPassword => 'New Password';

  @override
  String get confirmNewPassword => 'Confirm New Password';

  @override
  String get passwordRequirement => 'Password must be at least 6 characters long';

  @override
  String get saveChanges => 'SAVE CHANGES';

  @override
  String get profileUpdateSuccess => 'Profile updated successfully';

  @override
  String get passwordChangeSuccess => 'Password changed successfully';

  @override
  String get fillAllFields => 'Please fill all fields';

  @override
  String get passwordsDontMatch => 'Passwords do not match';

  @override
  String get passwordTooShort => 'Password must be at least 6 characters long';

  @override
  String get forgotPasswordTitle => 'Forgot Password';

  @override
  String get forgotPasswordSubtitle => 'Enter your email to receive a password reset code';

  @override
  String get sendCodeButton => 'SEND CODE';

  @override
  String get resetPasswordTitle => 'Reset Password';

  @override
  String get resetPasswordSubtitle => 'Enter the code sent to your email and set a new password';

  @override
  String get newPasswordLabel => 'New Password';

  @override
  String get confirmNewPasswordLabel => 'Confirm New Password';

  @override
  String get resetPasswordButton => 'RESET PASSWORD';

  @override
  String get codeVerificationTitle => 'Code Verification';

  @override
  String get codeVerificationSubtitle => 'Enter the 6-digit code sent to your email';

  @override
  String get codeVerificationError => 'Incorrect verifcation code';

  @override
  String get verifyButton => 'Verify';

  @override
  String get signup => 'Registration successful';

  @override
  String get signin => 'Login successful';

  @override
  String get verifyEmail => 'Email verification successful. Please login';

  @override
  String get logout => 'Logout successful';

  @override
  String get resendCode => 'Verification code resent';

  @override
  String get forgotVerify => 'Code verified. Set a new password';

  @override
  String get setNewPassword => 'Password updated successfully. Please login';

  @override
  String get profileUpdate => 'Profile updated successfully';

  @override
  String get passwordChange => 'Password changed successfully';

  @override
  String get conflict => 'User already exists';

  @override
  String get unauthorized => 'Invalid credentials';

  @override
  String get notFound => 'User not found';

  @override
  String get serverError => 'Server error. Please try again';

  @override
  String get noInternet => 'No internet connection';

  @override
  String get timeout => 'Request timed out';

  @override
  String get invalidInput => 'Invalid input';

  @override
  String get passwordMismatch => 'Passwords do not match';

  @override
  String get viewNearbyStations => 'View nearby stations';

  @override
  String get locationNotLoaded => 'Please wait while we load your location';

  @override
  String get changeProfilePicture => 'Change Profile Picture';

  @override
  String get imagePickerError => 'Failed to pick image';

  @override
  String get storagePermissionDenied => 'Storage permission is required to select images';

  @override
  String get cameraPermissionDenied => 'Camera permission is required to take photos';

  @override
  String get passwordErrorLetterNumberCombo => 'Must contain combination of letters and numbers';

  @override
  String get passwordErrorTooCommon => 'This password is too common and insecure';

  @override
  String get passwordErrorUppercase => 'Must contain at least one uppercase letter';

  @override
  String get passwordErrorLowercase => 'Must contain at least one lowercase letter';

  @override
  String get passwordErrorNumber => 'Must contain at least one number';

  @override
  String get passwordErrorSpecialChar => 'Must contain at least one special character';
}
