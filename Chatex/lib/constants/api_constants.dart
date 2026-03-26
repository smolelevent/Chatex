// Base URLs
const String _apiBaseUrl = "http://10.0.2.2/ChatexProject/chatex_phps";
const String webSocketUrl = "ws://10.0.2.2:8080";

// Auth Endpoints
const String validateTokenUrl = "$_apiBaseUrl/auth/validate_token.php";
const String registerUrl = "$_apiBaseUrl/auth/register.php";
const String loginUrl = "$_apiBaseUrl/auth/login.php";
const String logoutUrl = "$_apiBaseUrl/auth/logout.php";
const String updateStatusUrl = "$_apiBaseUrl/auth/update_status.php";

// Reset Password Endpoints
const String resetPasswordUrl = "$_apiBaseUrl/reset_password/reset_password.php";

// Chat Endpoints
const String getChatsUrl = "$_apiBaseUrl/chat/get/get_chats.php";
const String getGroupChatsUrl = "$_apiBaseUrl/chat/get/get_group_chats.php";
const String getFriendListForChatUrl = "$_apiBaseUrl/chat/get/get_friend_list.php";
const String getMessagesUrl = "$_apiBaseUrl/chat/get/get_messages.php";
const String startChatUrl = "$_apiBaseUrl/chat/set/start_chat.php";
const String markAsReadUrl = "$_apiBaseUrl/chat/set/mark_as_read.php";
const String deleteMessageUrl = "$_apiBaseUrl/chat/set/delete_message.php";
const String deleteChatUrl = "$_apiBaseUrl/chat/set/delete_chat.php";

// Friends Endpoints
const String getFriendRequestCountUrl = "$_apiBaseUrl/friends/get/get_friend_request_count.php";
const String searchUsersUrl = "$_apiBaseUrl/friends/get/search_users.php";
const String checkFriendStatusUrl = "$_apiBaseUrl/friends/get/check_friend_status.php";
const String getFriendsUrl = "$_apiBaseUrl/friends/get/get_friends.php";
const String getFriendRequestsUrl = "$_apiBaseUrl/friends/get/get_requests.php";
const String sendFriendRequestUrl = "$_apiBaseUrl/friends/set/send_friend_request.php";
const String removeFriendUrl = "$_apiBaseUrl/friends/set/remove_friend.php";
const String acceptFriendRequestUrl = "$_apiBaseUrl/friends/set/accept_request.php";
const String declineFriendRequestUrl = "$_apiBaseUrl/friends/set/decline_request.php";

// Settings Endpoints
const String updateLanguageUrl = "$_apiBaseUrl/settings/language/update_language.php";
const String updateUsernameUrl = "$_apiBaseUrl/settings/account/update_username.php";
const String updateEmailUrl = "$_apiBaseUrl/settings/account/update_email.php";
const String updatePasswordUrl = "$_apiBaseUrl/settings/account/update_password.php";
const String updateProfilePictureUrl = "$_apiBaseUrl/settings/account/update_profile_picture.php";
const String deleteUserUrl = "$_apiBaseUrl/settings/account/delete_user.php";