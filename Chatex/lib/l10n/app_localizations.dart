import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hu.dart';

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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('hu')
  ];

  /// No description provided for @languages.
  ///
  /// In en, this message translates to:
  /// **'Languages'**
  String get languages;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @emailIsInvalid.
  ///
  /// In en, this message translates to:
  /// **'The email address is invalid!'**
  String get emailIsInvalid;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'E-mail address'**
  String get emailAddress;

  /// No description provided for @passwordIsTooShort.
  ///
  /// In en, this message translates to:
  /// **'The password is too short! (min 8 characters)'**
  String get passwordIsTooShort;

  /// No description provided for @passwordIsTooLong.
  ///
  /// In en, this message translates to:
  /// **'The password is too long! (max 20 characters)'**
  String get passwordIsTooLong;

  /// No description provided for @passwordNeedsUppercase.
  ///
  /// In en, this message translates to:
  /// **'The password must contain at least 1 uppercase letter!'**
  String get passwordNeedsUppercase;

  /// No description provided for @passwordNeedsLowercase.
  ///
  /// In en, this message translates to:
  /// **'The password must contain at least 1 lowercase letter!'**
  String get passwordNeedsLowercase;

  /// No description provided for @passwordNeedsNumber.
  ///
  /// In en, this message translates to:
  /// **'The password must contain at least 1 number!'**
  String get passwordNeedsNumber;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password'**
  String get forgotPassword;

  /// No description provided for @createNewAccount.
  ///
  /// In en, this message translates to:
  /// **'Create a new account'**
  String get createNewAccount;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Password Recovery'**
  String get resetPassword;

  /// No description provided for @resetPasswordButton.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get resetPasswordButton;

  /// No description provided for @resetPasswordInformation.
  ///
  /// In en, this message translates to:
  /// **'To reset your password\nenter your email address!'**
  String get resetPasswordInformation;

  /// No description provided for @registration.
  ///
  /// In en, this message translates to:
  /// **'Registration'**
  String get registration;

  /// No description provided for @usernameTooShort.
  ///
  /// In en, this message translates to:
  /// **'The username is too short! (min 3)'**
  String get usernameTooShort;

  /// No description provided for @usernameTooLong.
  ///
  /// In en, this message translates to:
  /// **'The username is too long! (max 20)'**
  String get usernameTooLong;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @emailAddressHelp.
  ///
  /// In en, this message translates to:
  /// **'e.g.: someone@example.com'**
  String get emailAddressHelp;

  /// No description provided for @passwordRequirements.
  ///
  /// In en, this message translates to:
  /// **'Min. 8 characters, Max. 20 characters,\n1 lowercase, 1 uppercase, and 1 number.'**
  String get passwordRequirements;

  /// No description provided for @passwordsDoesntMatch.
  ///
  /// In en, this message translates to:
  /// **'The passwords do not match!'**
  String get passwordsDoesntMatch;

  /// No description provided for @passwordAgain.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get passwordAgain;

  /// No description provided for @registrationButton.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get registrationButton;

  /// No description provided for @successfulRegistration.
  ///
  /// In en, this message translates to:
  /// **'Successful registration!'**
  String get successfulRegistration;

  /// No description provided for @emailIsAlreadyUsed.
  ///
  /// In en, this message translates to:
  /// **'User already exists with this email!'**
  String get emailIsAlreadyUsed;

  /// No description provided for @connectionErrorRegistration.
  ///
  /// In en, this message translates to:
  /// **'Connection error while\nregistration!'**
  String get connectionErrorRegistration;

  /// No description provided for @successfulLogin.
  ///
  /// In en, this message translates to:
  /// **'Successful login!'**
  String get successfulLogin;

  /// No description provided for @loginCredentialsError.
  ///
  /// In en, this message translates to:
  /// **'Incorrect email or password!'**
  String get loginCredentialsError;

  /// No description provided for @errorCode.
  ///
  /// In en, this message translates to:
  /// **'Error code:'**
  String get errorCode;

  /// No description provided for @connectionErrorLogin.
  ///
  /// In en, this message translates to:
  /// **'Connection error while\nlogging in!'**
  String get connectionErrorLogin;

  /// No description provided for @connectionErrorLogout.
  ///
  /// In en, this message translates to:
  /// **'Connection error while\nlogging out!'**
  String get connectionErrorLogout;

  /// No description provided for @resetPasswordEmailSent.
  ///
  /// In en, this message translates to:
  /// **'Password recovery email sent!'**
  String get resetPasswordEmailSent;

  /// No description provided for @noUserWithThisEmail.
  ///
  /// In en, this message translates to:
  /// **'No user with this email address!'**
  String get noUserWithThisEmail;

  /// No description provided for @connectionErrorResetPassword.
  ///
  /// In en, this message translates to:
  /// **'Connection error while\nresetting password!'**
  String get connectionErrorResetPassword;

  /// No description provided for @connectionError.
  ///
  /// In en, this message translates to:
  /// **'Connection error: {action}!'**
  String connectionError(String action);

  /// No description provided for @permissionAccess.
  ///
  /// In en, this message translates to:
  /// **'Permission required for\n{typeOfPermission}!'**
  String permissionAccess(String typeOfPermission);

  /// No description provided for @permissionDenied.
  ///
  /// In en, this message translates to:
  /// **'The {typeOfPermission} permission is denied!\nRedirecting to settings...'**
  String permissionDenied(String typeOfPermission);

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'notifications'**
  String get notifications;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'download'**
  String get download;

  /// No description provided for @chatex.
  ///
  /// In en, this message translates to:
  /// **'Chatex'**
  String get chatex;

  /// No description provided for @groups.
  ///
  /// In en, this message translates to:
  /// **'Groups'**
  String get groups;

  /// No description provided for @createGroupsTitle.
  ///
  /// In en, this message translates to:
  /// **'Create groups'**
  String get createGroupsTitle;

  /// No description provided for @dummyGroupMessage.
  ///
  /// In en, this message translates to:
  /// **'Unfortunately, the groups feature was not completed for the exam... More information about the difficulties will be heard during our exam presentation!'**
  String get dummyGroupMessage;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @createNewChat.
  ///
  /// In en, this message translates to:
  /// **'Create a new chat'**
  String get createNewChat;

  /// No description provided for @createNewGroup.
  ///
  /// In en, this message translates to:
  /// **'Create a new group'**
  String get createNewGroup;

  /// No description provided for @connectionErrorLoadMessages.
  ///
  /// In en, this message translates to:
  /// **'Connection error while getting messages!'**
  String get connectionErrorLoadMessages;

  /// No description provided for @selectFiles.
  ///
  /// In en, this message translates to:
  /// **'Select file(s)'**
  String get selectFiles;

  /// No description provided for @connectionErrorSettingRead.
  ///
  /// In en, this message translates to:
  /// **'Connection error while\nmarking the message as read!'**
  String get connectionErrorSettingRead;

  /// No description provided for @connectionErrorMessageDelete.
  ///
  /// In en, this message translates to:
  /// **'Connection error while\ndeleting message!'**
  String get connectionErrorMessageDelete;

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// No description provided for @minutesAgo.
  ///
  /// In en, this message translates to:
  /// **'minute(s) ago'**
  String get minutesAgo;

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'hour(s) ago'**
  String get hoursAgo;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @dayBefore.
  ///
  /// In en, this message translates to:
  /// **'The day before yesterday'**
  String get dayBefore;

  /// No description provided for @errorTitle.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get errorTitle;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error!'**
  String get error;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deleteMessageConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this message?'**
  String get deleteMessageConfirm;

  /// No description provided for @lastSeen.
  ///
  /// In en, this message translates to:
  /// **'Last seen: {formatLastSeen}'**
  String lastSeen(String formatLastSeen);

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get available;

  /// No description provided for @userInformation.
  ///
  /// In en, this message translates to:
  /// **'User Information'**
  String get userInformation;

  /// No description provided for @chatIsEmpty.
  ///
  /// In en, this message translates to:
  /// **'The chat is empty.'**
  String get chatIsEmpty;

  /// No description provided for @scrollToBottom.
  ///
  /// In en, this message translates to:
  /// **'Scroll to bottom'**
  String get scrollToBottom;

  /// No description provided for @startWriting.
  ///
  /// In en, this message translates to:
  /// **'Start writing...'**
  String get startWriting;

  /// No description provided for @sendMessage.
  ///
  /// In en, this message translates to:
  /// **'Send message'**
  String get sendMessage;

  /// No description provided for @emojiButton.
  ///
  /// In en, this message translates to:
  /// **'Emoji button'**
  String get emojiButton;

  /// No description provided for @couldntLoadChatList.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load the chat list!'**
  String get couldntLoadChatList;

  /// No description provided for @connectionErrorGetChats.
  ///
  /// In en, this message translates to:
  /// **'Connection error while getting chats!'**
  String get connectionErrorGetChats;

  /// No description provided for @noChats.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any chats yet.\nStart one clicking on the '**
  String get noChats;

  /// No description provided for @iconPress.
  ///
  /// In en, this message translates to:
  /// **' icon!'**
  String get iconPress;

  /// No description provided for @you.
  ///
  /// In en, this message translates to:
  /// **'You: '**
  String get you;

  /// No description provided for @fileAttached.
  ///
  /// In en, this message translates to:
  /// **'📎 File attached'**
  String get fileAttached;

  /// No description provided for @imageSent.
  ///
  /// In en, this message translates to:
  /// **'🖼️ Image sent'**
  String get imageSent;

  /// No description provided for @noMessageYet.
  ///
  /// In en, this message translates to:
  /// **'No message yet'**
  String get noMessageYet;

  /// No description provided for @couldntLoadFriends.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load your friends!'**
  String get couldntLoadFriends;

  /// No description provided for @connectionErrorGettingFriendList.
  ///
  /// In en, this message translates to:
  /// **'Connection error while\ngetting friend list!'**
  String get connectionErrorGettingFriendList;

  /// No description provided for @connectionErrorGettingFriends.
  ///
  /// In en, this message translates to:
  /// **'Connection error while\nloading friends!'**
  String get connectionErrorGettingFriends;

  /// No description provided for @chatCreated.
  ///
  /// In en, this message translates to:
  /// **'Chat created!'**
  String get chatCreated;

  /// No description provided for @connectionErrorStartingChat.
  ///
  /// In en, this message translates to:
  /// **'Connection error while\nstarting chat!'**
  String get connectionErrorStartingChat;

  /// No description provided for @startChat.
  ///
  /// In en, this message translates to:
  /// **'Start a chat'**
  String get startChat;

  /// No description provided for @searchFriends.
  ///
  /// In en, this message translates to:
  /// **'Search friends...'**
  String get searchFriends;

  /// No description provided for @noResultsFound.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResultsFound;

  /// No description provided for @chatDeletedSuccesfully.
  ///
  /// In en, this message translates to:
  /// **'Chat deleted successfully!'**
  String get chatDeletedSuccesfully;

  /// No description provided for @userOutputDelete.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete chat!'**
  String get userOutputDelete;

  /// No description provided for @connectionErrorDeletingChat.
  ///
  /// In en, this message translates to:
  /// **'Connection error while\ndeleting chat!'**
  String get connectionErrorDeletingChat;

  /// No description provided for @chatInformation.
  ///
  /// In en, this message translates to:
  /// **'Chat information'**
  String get chatInformation;

  /// No description provided for @deleteChat.
  ///
  /// In en, this message translates to:
  /// **'Delete chat'**
  String get deleteChat;

  /// No description provided for @areYouSure.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete the chat?'**
  String get areYouSure;

  /// No description provided for @warning.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone!'**
  String get warning;

  /// No description provided for @seen.
  ///
  /// In en, this message translates to:
  /// **'Seen'**
  String get seen;

  /// No description provided for @delivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get delivered;

  /// No description provided for @chats.
  ///
  /// In en, this message translates to:
  /// **'Chats'**
  String get chats;

  /// No description provided for @friends.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get friends;

  /// No description provided for @userOutputGroups.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load your groups!'**
  String get userOutputGroups;

  /// No description provided for @connectionErrorGettingGroupList.
  ///
  /// In en, this message translates to:
  /// **'Connection error while getting group chats!'**
  String get connectionErrorGettingGroupList;

  /// No description provided for @userNoGroupsFirstHalf.
  ///
  /// In en, this message translates to:
  /// **'You aren\'t in any group chats.\nCreate one by clicking on the '**
  String get userNoGroupsFirstHalf;

  /// No description provided for @usersName.
  ///
  /// In en, this message translates to:
  /// **'users names'**
  String get usersName;

  /// No description provided for @connectionErrorFriendRequestsNumber.
  ///
  /// In en, this message translates to:
  /// **'Connection error while\nfetching friend requests (count)!'**
  String get connectionErrorFriendRequestsNumber;

  /// No description provided for @connectionErrorGettingUsers.
  ///
  /// In en, this message translates to:
  /// **'Connection error while\nfetching users!'**
  String get connectionErrorGettingUsers;

  /// No description provided for @connectionErrorFriendRequestStatus.
  ///
  /// In en, this message translates to:
  /// **'Connection error while fetching friend request status!'**
  String get connectionErrorFriendRequestStatus;

  /// No description provided for @friendRequestSent.
  ///
  /// In en, this message translates to:
  /// **'Friend request sent!'**
  String get friendRequestSent;

  /// No description provided for @errorOccurredFriendRequest.
  ///
  /// In en, this message translates to:
  /// **'Error occurred while sending the friend request!'**
  String get errorOccurredFriendRequest;

  /// No description provided for @connectionErrorSendingFriendRequest.
  ///
  /// In en, this message translates to:
  /// **'Connection error while\nsending the friend request!'**
  String get connectionErrorSendingFriendRequest;

  /// No description provided for @friendRequests.
  ///
  /// In en, this message translates to:
  /// **'Friend requests'**
  String get friendRequests;

  /// No description provided for @requests.
  ///
  /// In en, this message translates to:
  /// **'Friend Requests'**
  String get requests;

  /// No description provided for @manageFriends.
  ///
  /// In en, this message translates to:
  /// **'Manage friends'**
  String get manageFriends;

  /// No description provided for @peopleUsername.
  ///
  /// In en, this message translates to:
  /// **'Enter the username!'**
  String get peopleUsername;

  /// No description provided for @friend.
  ///
  /// In en, this message translates to:
  /// **'Friend'**
  String get friend;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @manageAccount.
  ///
  /// In en, this message translates to:
  /// **'Account management'**
  String get manageAccount;

  /// No description provided for @searchSettings.
  ///
  /// In en, this message translates to:
  /// **'Search settings...'**
  String get searchSettings;

  /// No description provided for @successfulChange.
  ///
  /// In en, this message translates to:
  /// **'Successful change!'**
  String get successfulChange;

  /// No description provided for @unsuccessfulChange.
  ///
  /// In en, this message translates to:
  /// **'The change was unsuccessful!'**
  String get unsuccessfulChange;

  /// No description provided for @connectionErrorChangingStatus.
  ///
  /// In en, this message translates to:
  /// **'Connection error while\nchanging status!'**
  String get connectionErrorChangingStatus;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @logoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutConfirm;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @unknownMimeType.
  ///
  /// In en, this message translates to:
  /// **'An unknown MIME type has been detected!'**
  String get unknownMimeType;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'offline'**
  String get offline;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @connectionErrorFriendRequests.
  ///
  /// In en, this message translates to:
  /// **'Connection error while\nloading friend requests!'**
  String get connectionErrorFriendRequests;

  /// No description provided for @friendRequestAccepted.
  ///
  /// In en, this message translates to:
  /// **'Friend request accepted!'**
  String get friendRequestAccepted;

  /// No description provided for @errorOccuredAccepting.
  ///
  /// In en, this message translates to:
  /// **'An error occured while accepting!'**
  String get errorOccuredAccepting;

  /// No description provided for @connectionErrorAcceptingFriendRequests.
  ///
  /// In en, this message translates to:
  /// **'Connection error while\naccepting request!'**
  String get connectionErrorAcceptingFriendRequests;

  /// No description provided for @friendRequestDeclined.
  ///
  /// In en, this message translates to:
  /// **'Friend request declined!'**
  String get friendRequestDeclined;

  /// No description provided for @errorOccuredDeclining.
  ///
  /// In en, this message translates to:
  /// **'An error occured while declining'**
  String get errorOccuredDeclining;

  /// No description provided for @connectionErrorDecliningFriendRequests.
  ///
  /// In en, this message translates to:
  /// **'Connection error while\ndeclining friend request!'**
  String get connectionErrorDecliningFriendRequests;

  /// No description provided for @noNewFriendRequest.
  ///
  /// In en, this message translates to:
  /// **'No new friend requests'**
  String get noNewFriendRequest;

  /// No description provided for @errorWhileDecodingImage.
  ///
  /// In en, this message translates to:
  /// **'Error in picture decoding!'**
  String get errorWhileDecodingImage;

  /// No description provided for @friendRequest.
  ///
  /// In en, this message translates to:
  /// **'Friend request'**
  String get friendRequest;

  /// No description provided for @friendDeleted.
  ///
  /// In en, this message translates to:
  /// **'Friend removed!'**
  String get friendDeleted;

  /// No description provided for @errorWhileDeletingFriend.
  ///
  /// In en, this message translates to:
  /// **'Error while deleting friend'**
  String get errorWhileDeletingFriend;

  /// No description provided for @connectionErrorDeletingFriend.
  ///
  /// In en, this message translates to:
  /// **'Connection error while\nremoving friend!'**
  String get connectionErrorDeletingFriend;

  /// No description provided for @currentlyNoFriends.
  ///
  /// In en, this message translates to:
  /// **'Currently you have no friends!'**
  String get currentlyNoFriends;

  /// No description provided for @currentFriends.
  ///
  /// In en, this message translates to:
  /// **'Your current friends'**
  String get currentFriends;

  /// No description provided for @removeFriend.
  ///
  /// In en, this message translates to:
  /// **'Remove friend'**
  String get removeFriend;

  /// No description provided for @removeFriendConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove this friend?'**
  String get removeFriendConfirm;

  /// No description provided for @updatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'{item} updated successfully!'**
  String updatedSuccessfully(String item);

  /// No description provided for @errorUpdating.
  ///
  /// In en, this message translates to:
  /// **'Failed to update {item}!'**
  String errorUpdating(String item);

  /// No description provided for @errorUpdatingUsername.
  ///
  /// In en, this message translates to:
  /// **'Failed to update username!'**
  String get errorUpdatingUsername;

  /// No description provided for @connectionErrorUpdatingUsername.
  ///
  /// In en, this message translates to:
  /// **'Connection error while\nupdating username!'**
  String get connectionErrorUpdatingUsername;

  /// No description provided for @errorUpdatingEmail.
  ///
  /// In en, this message translates to:
  /// **'Failed to update email!'**
  String get errorUpdatingEmail;

  /// No description provided for @connectionErrorUpdatingEmail.
  ///
  /// In en, this message translates to:
  /// **'Connection error while\nupdating email!'**
  String get connectionErrorUpdatingEmail;

  /// No description provided for @errorUpdatingPassword.
  ///
  /// In en, this message translates to:
  /// **'Password update failed!'**
  String get errorUpdatingPassword;

  /// No description provided for @connectionErrorUpdatingPassword.
  ///
  /// In en, this message translates to:
  /// **'Connection error while\nupdating password!'**
  String get connectionErrorUpdatingPassword;

  /// No description provided for @unsupportedFileFormat.
  ///
  /// In en, this message translates to:
  /// **'Unsupported file format!'**
  String get unsupportedFileFormat;

  /// No description provided for @imageSelectedCanUpdate.
  ///
  /// In en, this message translates to:
  /// **'Image selected! You can now update it!'**
  String get imageSelectedCanUpdate;

  /// No description provided for @errorSelectingImage.
  ///
  /// In en, this message translates to:
  /// **'Error while selecting image!'**
  String get errorSelectingImage;

  /// No description provided for @errorUpdatingProfilePicture.
  ///
  /// In en, this message translates to:
  /// **'Failed to update profile picture!'**
  String get errorUpdatingProfilePicture;

  /// No description provided for @connectionErrorUpdatingProfilePicture.
  ///
  /// In en, this message translates to:
  /// **'Connection error while\nupdating profile picture!'**
  String get connectionErrorUpdatingProfilePicture;

  /// No description provided for @changesSaved.
  ///
  /// In en, this message translates to:
  /// **'Changes saved!'**
  String get changesSaved;

  /// No description provided for @cannotModifyToSameValue.
  ///
  /// In en, this message translates to:
  /// **'Cannot modify to the same value(s)!'**
  String get cannotModifyToSameValue;

  /// No description provided for @accountDeleted.
  ///
  /// In en, this message translates to:
  /// **'Account deleted!'**
  String get accountDeleted;

  /// No description provided for @errorDeletingAccount.
  ///
  /// In en, this message translates to:
  /// **'Error deleting account!'**
  String get errorDeletingAccount;

  /// No description provided for @connectionErrorDeletingAccount.
  ///
  /// In en, this message translates to:
  /// **'Connection error while\ndeleting account!'**
  String get connectionErrorDeletingAccount;

  /// No description provided for @accountDetails.
  ///
  /// In en, this message translates to:
  /// **'Account details'**
  String get accountDetails;

  /// No description provided for @usernameCannotBeEmpty.
  ///
  /// In en, this message translates to:
  /// **'The username\ncannot be empty!'**
  String get usernameCannotBeEmpty;

  /// No description provided for @emailCannotBeEmpty.
  ///
  /// In en, this message translates to:
  /// **'The email address\ncannot be empty!'**
  String get emailCannotBeEmpty;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get changePassword;

  /// No description provided for @profilePicture.
  ///
  /// In en, this message translates to:
  /// **'Profile picture'**
  String get profilePicture;

  /// No description provided for @fieldMustMatchPassword.
  ///
  /// In en, this message translates to:
  /// **'The field must match the password field!'**
  String get fieldMustMatchPassword;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get saveChanges;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @areYouSureDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account?'**
  String get areYouSureDeleteAccount;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @errorUpdatingLanguage.
  ///
  /// In en, this message translates to:
  /// **'Error while\nupdating language!'**
  String get errorUpdatingLanguage;

  /// No description provided for @connectionErrorUpdatingLanguage.
  ///
  /// In en, this message translates to:
  /// **'Connection error while\nupdating language!'**
  String get connectionErrorUpdatingLanguage;

  /// No description provided for @filesTooLargeTitle.
  ///
  /// In en, this message translates to:
  /// **'The files are too large!'**
  String get filesTooLargeTitle;

  /// No description provided for @filesTooLargeContent.
  ///
  /// In en, this message translates to:
  /// **'You can only send files up to 100 MB!'**
  String get filesTooLargeContent;

  /// No description provided for @imagesTooLargeTitle.
  ///
  /// In en, this message translates to:
  /// **'The images are too large!'**
  String get imagesTooLargeTitle;

  /// No description provided for @imagesTooLargeContent.
  ///
  /// In en, this message translates to:
  /// **'You can only send files up to 50 MB!'**
  String get imagesTooLargeContent;

  /// No description provided for @messageTooLongTitle.
  ///
  /// In en, this message translates to:
  /// **'Message too long!'**
  String get messageTooLongTitle;

  /// No description provided for @messageTooLongContent.
  ///
  /// In en, this message translates to:
  /// **'You can send a message up to 5000 characters!'**
  String get messageTooLongContent;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @fileUpload.
  ///
  /// In en, this message translates to:
  /// **'File upload'**
  String get fileUpload;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @downloadReady.
  ///
  /// In en, this message translates to:
  /// **'Download ready'**
  String get downloadReady;

  /// No description provided for @savedTo.
  ///
  /// In en, this message translates to:
  /// **'{fileName} saved to:\n{path}'**
  String savedTo(String fileName, String path);

  /// No description provided for @fileDownloadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to download the file!'**
  String get fileDownloadError;

  /// No description provided for @imageSaved.
  ///
  /// In en, this message translates to:
  /// **'Image saved'**
  String get imageSaved;

  /// No description provided for @imageDownloadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to download the image!'**
  String get imageDownloadError;
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
      <String>['en', 'hu'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hu':
      return AppLocalizationsHu();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
