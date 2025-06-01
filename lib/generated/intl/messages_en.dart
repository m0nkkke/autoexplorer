// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(foldersToDelete) =>
      "Are you sure to delete ${foldersToDelete} folders?";

  static String m1(keyUserName) =>
      "Are you sure to delete user ${keyUserName}?";

  static String m2(errorMessage) => "Error: ${errorMessage}";

  static String m3(filesCount) => "Files count: ${filesCount}";

  static String m4(imagesCount) => "Images: ${imagesCount}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "accessControl": MessageLookupByLibrary.simpleMessage(
      "Access and user control",
    ),
    "accessGranted": MessageLookupByLibrary.simpleMessage("Access granted"),
    "accessKey": MessageLookupByLibrary.simpleMessage("Access key"),
    "accessModified": MessageLookupByLibrary.simpleMessage("Access edited"),
    "addNewRegional": MessageLookupByLibrary.simpleMessage("Add new regional"),
    "adminPanelTitle": MessageLookupByLibrary.simpleMessage("Admin-panel"),
    "areYouSure": MessageLookupByLibrary.simpleMessage("Are you sure?"),
    "areYouSureToDeleteNFolders": m0,
    "areYouSureToDeleteSync": MessageLookupByLibrary.simpleMessage(
      "Are you sure you wanna delete files from this directory?",
    ),
    "areYouSureWithParam": m1,
    "areaTitle": MessageLookupByLibrary.simpleMessage("Area"),
    "cameraMode": MessageLookupByLibrary.simpleMessage("From camera"),
    "cancelButton": MessageLookupByLibrary.simpleMessage("Cancel"),
    "changeSaved": MessageLookupByLibrary.simpleMessage("Changes was saved"),
    "chooseRegional": MessageLookupByLibrary.simpleMessage("Choose regional"),
    "confrimDelete": MessageLookupByLibrary.simpleMessage("Confirm delete"),
    "controlTabTitle": MessageLookupByLibrary.simpleMessage("Control"),
    "createButton": MessageLookupByLibrary.simpleMessage("Create"),
    "createFolder": MessageLookupByLibrary.simpleMessage("Create folder"),
    "createFolderMenu": MessageLookupByLibrary.simpleMessage("New folder"),
    "createNewAccessKey": MessageLookupByLibrary.simpleMessage(
      "Create new access key",
    ),
    "createNewTemplate": MessageLookupByLibrary.simpleMessage(
      "Create new template",
    ),
    "createNewUser": MessageLookupByLibrary.simpleMessage("Create new user"),
    "creationTabTitle": MessageLookupByLibrary.simpleMessage("Templates"),
    "deleteButton": MessageLookupByLibrary.simpleMessage("Delete"),
    "deleteSelected": MessageLookupByLibrary.simpleMessage("Delete selected"),
    "deleteSyncFiles": MessageLookupByLibrary.simpleMessage(
      "Delete sync-files",
    ),
    "deleteSyncWindow": MessageLookupByLibrary.simpleMessage("Delete files"),
    "diskStatusFailed": MessageLookupByLibrary.simpleMessage(
      "Disk is not connected",
    ),
    "diskStatusSuccess": MessageLookupByLibrary.simpleMessage(
      "Disk is connected",
    ),
    "diskTabTitle": MessageLookupByLibrary.simpleMessage("Disk"),
    "emailExample": MessageLookupByLibrary.simpleMessage(
      "For example: example@email.com",
    ),
    "errorLoading": MessageLookupByLibrary.simpleMessage("Error loading"),
    "errorLogin": MessageLookupByLibrary.simpleMessage("Error Login"),
    "errorWithMessage": m2,
    "filesCount": m3,
    "firstName": MessageLookupByLibrary.simpleMessage("Firstname"),
    "folderName": MessageLookupByLibrary.simpleMessage("Folder name"),
    "galleryMode": MessageLookupByLibrary.simpleMessage("From gallery"),
    "helpKey": MessageLookupByLibrary.simpleMessage(
      "Don\'t have a login? Contact your director",
    ),
    "iconsViewMode": MessageLookupByLibrary.simpleMessage("Icons view"),
    "iconsViewModeLarge": MessageLookupByLibrary.simpleMessage("Large"),
    "iconsViewModeSmall": MessageLookupByLibrary.simpleMessage("Small"),
    "imagesCount": m4,
    "imagesCreated": MessageLookupByLibrary.simpleMessage("Images created"),
    "internetHasArrived": MessageLookupByLibrary.simpleMessage(
      "Connection is back! Click on \'send to cloud\' in menu",
    ),
    "keyCopySuccess": MessageLookupByLibrary.simpleMessage("Copied!"),
    "lastName": MessageLookupByLibrary.simpleMessage("Surname"),
    "lastUpload": MessageLookupByLibrary.simpleMessage("Last upload"),
    "loadingData": MessageLookupByLibrary.simpleMessage("Loading data"),
    "middleName": MessageLookupByLibrary.simpleMessage("Middlename"),
    "noAreas": MessageLookupByLibrary.simpleMessage("No areas here"),
    "noAvailableUsers": MessageLookupByLibrary.simpleMessage(
      "No available users",
    ),
    "noFilesHere": MessageLookupByLibrary.simpleMessage("Ooops! No files here"),
    "password": MessageLookupByLibrary.simpleMessage("Password"),
    "passwordExample": MessageLookupByLibrary.simpleMessage(
      "For example: 123qwe",
    ),
    "pleaseEnterEmail": MessageLookupByLibrary.simpleMessage(
      "Please enter yor email",
    ),
    "pleaseEnterPassword": MessageLookupByLibrary.simpleMessage(
      "Please enter your password",
    ),
    "refreshMenu": MessageLookupByLibrary.simpleMessage("Refresh"),
    "regionalTitle": MessageLookupByLibrary.simpleMessage("Regional"),
    "saveChanges": MessageLookupByLibrary.simpleMessage("Save changes"),
    "searchMenu": MessageLookupByLibrary.simpleMessage("Search"),
    "selectAll": MessageLookupByLibrary.simpleMessage("Select all"),
    "selectFoldersToDelete": MessageLookupByLibrary.simpleMessage(
      "Choose folders to delete",
    ),
    "sendToDisk": MessageLookupByLibrary.simpleMessage("Send to cloud"),
    "signInButton": MessageLookupByLibrary.simpleMessage("Sign in"),
    "sortByDate": MessageLookupByLibrary.simpleMessage("Date"),
    "sortByName": MessageLookupByLibrary.simpleMessage("Name"),
    "sortModeTitle": MessageLookupByLibrary.simpleMessage("Sort"),
    "switchAccount": MessageLookupByLibrary.simpleMessage("Change account"),
    "tryAgainLater": MessageLookupByLibrary.simpleMessage("Try again later"),
    "userRole": MessageLookupByLibrary.simpleMessage("Role"),
    "userRoleAdmin": MessageLookupByLibrary.simpleMessage("Admin"),
    "userRoleWorker": MessageLookupByLibrary.simpleMessage("Worker"),
    "userSuccessfullyCreated": MessageLookupByLibrary.simpleMessage(
      "User was successfully created",
    ),
    "viewImage": MessageLookupByLibrary.simpleMessage("Viewing image"),
    "youWantToChangeAccount": MessageLookupByLibrary.simpleMessage(
      "Are you want to change account?",
    ),
  };
}
