// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get languages => 'Languages';

  @override
  String get language => 'Language';

  @override
  String get emailAddressInvalid => 'The email address is invalid!';

  @override
  String get emailAddress => 'E-mail address';

  @override
  String get passwordTooShort =>
      'The password is too short! (min 8 characters)';

  @override
  String get passwordTooLong => 'The password is too long! (max 20 characters)';

  @override
  String get passwordNeedsUppercase =>
      'The password must contain at least 1 uppercase letter!';

  @override
  String get passwordNeedsLowercase =>
      'The password must contain at least 1 lowercase letter!';

  @override
  String get passwordNeedsNumber =>
      'The password must contain at least 1 number!';

  @override
  String get login => 'Login';

  @override
  String get forgotPassword => 'Forgot password';

  @override
  String get createNewAccount => 'Create a new account';

  @override
  String get resetPassword => 'Password Recovery';

  @override
  String get resetPasswordButton => 'Reset password';

  @override
  String get resetPasswordInformation =>
      'To reset your password\nenter your email address!';

  @override
  String get registration => 'Registration';

  @override
  String get usernameTooShort => 'The username is too short! (min 3)';

  @override
  String get usernameTooLong => 'The username is too long! (max 20)';

  @override
  String get username => 'Username';

  @override
  String get emailAddressHelp => 'e.g.: someone@example.com';

  @override
  String get passwordRequirements =>
      'Min. 8 characters, Max. 20 characters,\n1 lowercase, 1 uppercase, and 1 number.';

  @override
  String get passwordsDoesntMatch => 'The passwords doesn\'t match!';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get registrationButton => 'Sign up';

  @override
  String get successfulRegistration => 'Successful registration!';

  @override
  String get emailAddressAlreadyUsed =>
      'User already exists with this email address!';

  @override
  String get connectionErrorRegistration =>
      'Connection error while\nregistration!';

  @override
  String get successfulLogin => 'Successful login!';

  @override
  String get loginCredentialsError => 'Incorrect email address or password!';

  @override
  String get errorCode => 'Error code:';

  @override
  String get connectionErrorLogin => 'Connection error while\nlogging in!';

  @override
  String get connectionErrorLogout => 'Connection error while\nlogging out!';

  @override
  String get resetPasswordEmailSent => 'Password recovery email sent!';

  @override
  String get noUserWithThisEmailAddress => 'No user with this email address!';

  @override
  String get connectionErrorResetPassword =>
      'Connection error while\nresetting password!';

  @override
  String connectionError(String action) {
    return 'Connection error: $action!';
  }

  @override
  String permissionRequired(String typeOfPermission) {
    return 'Permission required for\n$typeOfPermission!';
  }

  @override
  String permissionDenied(String typeOfPermission) {
    return 'The $typeOfPermission permission is denied!\nRedirecting to settings...';
  }

  @override
  String get notifications => 'notifications';

  @override
  String get download => 'download';

  @override
  String get groups => 'Groups';

  @override
  String get createGroupsTitle => 'Create groups';

  @override
  String get settings => 'Settings';

  @override
  String get createNewChat => 'Create a new chat';

  @override
  String get createNewGroup => 'Create a new group';

  @override
  String get connectionErrorLoadMessages =>
      'Connection error while getting messages!';

  @override
  String get selectFiles => 'Select file(s)';

  @override
  String get connectionErrorSettingRead =>
      'Connection error while\nmarking the message as read!';

  @override
  String get connectionErrorMessageDelete =>
      'Connection error while\ndeleting message!';

  @override
  String get justNow => 'Just now';

  @override
  String minutesAgo(int minutes) {
    return '$minutes minute(s) ago';
  }

  @override
  String hoursAgo(int hours) {
    return '$hours hour(s) ago';
  }

  @override
  String get yesterday => 'Yesterday';

  @override
  String get dayBefore => 'The day before yesterday';

  @override
  String get errorTitle => 'Error';

  @override
  String get error => 'Error!';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get areYouSureDeleteMessage =>
      'Are you sure you want to delete this message?';

  @override
  String lastSeen(String formatLastSeen) {
    return 'Last seen: $formatLastSeen';
  }

  @override
  String get online => 'online';

  @override
  String get userInformation => 'User Information';

  @override
  String get chatEmpty => 'The chat is empty.';

  @override
  String get scrollToBottom => 'Scroll to bottom';

  @override
  String get startWriting => 'Start writing...';

  @override
  String get sendMessage => 'Send message';

  @override
  String get emojiButton => 'Emoji button';

  @override
  String get couldntLoadChatList => 'Couldn\'t load the chat list!';

  @override
  String get connectionErrorGetChats => 'Connection error while getting chats!';

  @override
  String get noChats =>
      'You don\'t have any chats yet.\nStart one clicking on the ';

  @override
  String get iconEndOfSentence => ' icon!';

  @override
  String get you => 'You: ';

  @override
  String get fileAttached => '📎 File attached';

  @override
  String get imageSent => '🖼️ Image sent';

  @override
  String get noMessageYet => 'No message yet';

  @override
  String get couldntLoadFriends => 'Couldn\'t load your friends!';

  @override
  String get updateLanguageSuccesful => 'Updating language was successful!';

  @override
  String get connectionErrorGettingFriendList =>
      'Connection error while\ngetting friend list!';

  @override
  String get connectionErrorLoadingFriends =>
      'Connection error while\nloading friends!';

  @override
  String get chatCreated => 'Chat created!';

  @override
  String get connectionErrorStartingChat =>
      'Connection error while\nstarting chat!';

  @override
  String get startChat => 'Start a chat';

  @override
  String get searchFriends => 'Search friends...';

  @override
  String get noResultsFound => 'No results found';

  @override
  String get chatDeletedSuccesfully => 'Chat deleted successfully!';

  @override
  String get userOutputDelete => 'Failed to delete chat!';

  @override
  String get connectionErrorDeletingChat =>
      'Connection error while\ndeleting chat!';

  @override
  String get chatInformation => 'Chat information';

  @override
  String get deleteChat => 'Delete chat';

  @override
  String get areYouSureDeleteChat =>
      'Are you sure you want to delete the chat?';

  @override
  String get actionCannotUndone => 'This action cannot be undone!';

  @override
  String get seen => 'Seen';

  @override
  String get delivered => 'Delivered';

  @override
  String get chats => 'Chats';

  @override
  String get friends => 'Friends';

  @override
  String get couldntLoadGroups => 'Couldn\'t load your groups!';

  @override
  String get connectionErrorGettingGroupList =>
      'Connection error while getting group chats!';

  @override
  String get userNoGroupsFirstHalf =>
      'You aren\'t in any group chats.\nCreate one by clicking on the ';

  @override
  String get usersName => 'users names';

  @override
  String get connectionErrorFriendRequestsNumber =>
      'Connection error while\nfetching friend requests (count)!';

  @override
  String get connectionErrorGettingUsers =>
      'Connection error while\nfetching users!';

  @override
  String get connectionErrorFriendRequestStatus =>
      'Connection error while fetching friend request status!';

  @override
  String get friendRequestSent => 'Friend request sent!';

  @override
  String get errorOccurredFriendRequest =>
      'Error occurred while sending the friend request!';

  @override
  String get connectionErrorSendingFriendRequest =>
      'Connection error while\nsending the friend request!';

  @override
  String get friendRequests => 'Friend requests';

  @override
  String get manageFriends => 'Manage friends';

  @override
  String get enterUsername => 'Enter the username!';

  @override
  String get friend => 'Friend';

  @override
  String get pending => 'Pending';

  @override
  String get add => 'Add';

  @override
  String get general => 'General';

  @override
  String get account => 'Account';

  @override
  String get manageAccount => 'Account management';

  @override
  String get searchSettings => 'Search settings...';

  @override
  String get successfulChange => 'Successful change!';

  @override
  String get unsuccessfulChange => 'The change was unsuccessful!';

  @override
  String get connectionErrorChangingStatus =>
      'Connection error while\nchanging status!';

  @override
  String get logout => 'Logout';

  @override
  String get areYouSureLogout => 'Are you sure you want to logout?';

  @override
  String get yes => 'Yes';

  @override
  String get unknownMimeType => 'An unknown MIME type has been detected!';

  @override
  String get offline => 'offline';

  @override
  String get status => 'Status';

  @override
  String get connectionErrorFriendRequests =>
      'Connection error while\nloading friend requests!';

  @override
  String get friendRequestAccepted => 'Friend request accepted!';

  @override
  String get errorOccuredAccepting => 'An error occured while accepting!';

  @override
  String get connectionErrorAcceptingFriendRequests =>
      'Connection error while\naccepting request!';

  @override
  String get friendRequestDeclined => 'Friend request declined!';

  @override
  String get errorOccuredDeclining => 'An error occured while declining';

  @override
  String get connectionErrorDecliningFriendRequests =>
      'Connection error while\ndeclining friend request!';

  @override
  String get noNewFriendRequest => 'No new friend requests';

  @override
  String get errorWhileDecodingImage => 'Error in picture decoding!';

  @override
  String get friendRequest => 'Friend request';

  @override
  String get friendRemoved => 'Friend removed!';

  @override
  String get errorWhileDeletingFriend => 'Error while deleting friend';

  @override
  String get connectionErrorRemovingFriend =>
      'Connection error while\nremoving friend!';

  @override
  String get currentlyNoFriends => 'Currently you have no friends!';

  @override
  String get currentFriends => 'Your current friends';

  @override
  String get removeFriend => 'Remove friend';

  @override
  String get areYouSureRemoveFriend =>
      'Are you sure you want to remove this friend?';

  @override
  String updatedSuccessfully(String item) {
    return '$item updated successfully!';
  }

  @override
  String errorUpdating(String item) {
    return 'Failed to update $item!';
  }

  @override
  String get errorUpdatingUsername => 'Failed to update username!';

  @override
  String get remove => 'Remove';

  @override
  String get connectionErrorUpdatingUsername =>
      'Connection error while\nupdating username!';

  @override
  String get errorUpdatingEmailAddress => 'Failed to update email address!';

  @override
  String get connectionErrorUpdatingEmailAddress =>
      'Connection error while\nupdating email address!';

  @override
  String get errorUpdatingPassword => 'Password update failed!';

  @override
  String get connectionErrorUpdatingPassword =>
      'Connection error while\nupdating password!';

  @override
  String get emailAddressUpdated => 'Email address updated successfully!';

  @override
  String get usernameUpdated => 'Username updated successfully!';

  @override
  String get unsupportedFileFormat => 'Unsupported file format!';

  @override
  String get imageSelectedCanUpdate => 'Image selected! You can now update it!';

  @override
  String get errorSelectingImage => 'Error while selecting image!';

  @override
  String get passwordUpdated => 'Password updated!';

  @override
  String get errorUpdatingProfilePicture => 'Failed to update profile picture!';

  @override
  String get connectionErrorUpdatingProfilePicture =>
      'Connection error while\nupdating profile picture!';

  @override
  String get changesSaved => 'Changes saved!';

  @override
  String get cantModifySameValue => 'Can\'t modify to the same value(s)!';

  @override
  String get profilePictureUpdatedSucessfully =>
      'Profile picture updated successfully!';

  @override
  String get accountDeleted => 'Account deleted!';

  @override
  String get errorDeletingAccount => 'Error deleting account!';

  @override
  String get connectionErrorDeletingAccount =>
      'Connection error while\ndeleting account!';

  @override
  String get accountDetails => 'Account details';

  @override
  String get usernameCannotBeEmpty => 'The username\ncannot be empty!';

  @override
  String get emailAddressCannotBeEmpty => 'The email address\ncannot be empty!';

  @override
  String get changePassword => 'Change password';

  @override
  String get profilePicture => 'Profile picture';

  @override
  String get fieldMustMatchPassword =>
      'The field must match the password field!';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get areYouSureDeleteAccount =>
      'Are you sure you want to delete your account?';

  @override
  String get password => 'Password';

  @override
  String get accountManagement => 'Account management';

  @override
  String get errorUpdatingLanguage => 'Error while\nupdating language!';

  @override
  String get connectionErrorUpdatingLanguage =>
      'Connection error while\nupdating language!';

  @override
  String get filesTooLargeTitle => 'The files are too large!';

  @override
  String get filesTooLargeContent => 'You can only send files up to 100 MB!';

  @override
  String get imagesTooLargeTitle => 'The images are too large!';

  @override
  String get imagesTooLargeContent => 'You can only send files up to 50 MB!';

  @override
  String get messageTooLongTitle => 'Message too long!';

  @override
  String messageTooLongContent(int characters) {
    return 'You can send a message up to $characters characters!';
  }

  @override
  String get back => 'Back';

  @override
  String get fileUpload => 'File upload';

  @override
  String get camera => 'Camera';

  @override
  String get gallery => 'Gallery';

  @override
  String get downloadReady => 'Download ready';

  @override
  String savedTo(String fileName, String path) {
    return '$fileName saved to:\n$path';
  }

  @override
  String get fileDownloadError => 'Failed to download the file!';

  @override
  String get imageSaved => 'Image saved';

  @override
  String get imageDownloadError => 'Failed to download the image!';
}
