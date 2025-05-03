// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
            ? locale.languageCode
            : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `New folder`
  String get createFolderMenu {
    return Intl.message(
      'New folder',
      name: 'createFolderMenu',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get searchMenu {
    return Intl.message('Search', name: 'searchMenu', desc: '', args: []);
  }

  /// `Refresh`
  String get refreshMenu {
    return Intl.message('Refresh', name: 'refreshMenu', desc: '', args: []);
  }

  /// `Change account`
  String get switchAccount {
    return Intl.message(
      'Change account',
      name: 'switchAccount',
      desc: '',
      args: [],
    );
  }

  /// `Icons view`
  String get iconsViewMode {
    return Intl.message(
      'Icons view',
      name: 'iconsViewMode',
      desc: '',
      args: [],
    );
  }

  /// `Small`
  String get iconsViewModeSmall {
    return Intl.message(
      'Small',
      name: 'iconsViewModeSmall',
      desc: '',
      args: [],
    );
  }

  /// `Large`
  String get iconsViewModeLarge {
    return Intl.message(
      'Large',
      name: 'iconsViewModeLarge',
      desc: '',
      args: [],
    );
  }

  /// `Sort`
  String get sortModeTitle {
    return Intl.message('Sort', name: 'sortModeTitle', desc: '', args: []);
  }

  /// `Name`
  String get sortByName {
    return Intl.message('Name', name: 'sortByName', desc: '', args: []);
  }

  /// `Date`
  String get sortByDate {
    return Intl.message('Date', name: 'sortByDate', desc: '', args: []);
  }

  /// `Select all`
  String get selectAll {
    return Intl.message('Select all', name: 'selectAll', desc: '', args: []);
  }

  /// `Delete selected`
  String get deleteSelected {
    return Intl.message(
      'Delete selected',
      name: 'deleteSelected',
      desc: '',
      args: [],
    );
  }

  /// `Files count: {filesCount}`
  String filesCount(Object filesCount) {
    return Intl.message(
      'Files count: $filesCount',
      name: 'filesCount',
      desc: '',
      args: [filesCount],
    );
  }

  /// `From camera`
  String get cameraMode {
    return Intl.message('From camera', name: 'cameraMode', desc: '', args: []);
  }

  /// `From gallery`
  String get galleryMode {
    return Intl.message(
      'From gallery',
      name: 'galleryMode',
      desc: '',
      args: [],
    );
  }

  /// `Create folder`
  String get createFolder {
    return Intl.message(
      'Create folder',
      name: 'createFolder',
      desc: '',
      args: [],
    );
  }

  /// `Folder name`
  String get folderName {
    return Intl.message('Folder name', name: 'folderName', desc: '', args: []);
  }

  /// `Cancel`
  String get cancelButton {
    return Intl.message('Cancel', name: 'cancelButton', desc: '', args: []);
  }

  /// `Confirm delete`
  String get confrimDelete {
    return Intl.message(
      'Confirm delete',
      name: 'confrimDelete',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get deleteButton {
    return Intl.message('Delete', name: 'deleteButton', desc: '', args: []);
  }

  /// `Are you sure to delete {foldersToDelete} folders?`
  String areYouSureToDeleteNFolders(Object foldersToDelete) {
    return Intl.message(
      'Are you sure to delete $foldersToDelete folders?',
      name: 'areYouSureToDeleteNFolders',
      desc: '',
      args: [foldersToDelete],
    );
  }

  /// `Choose folders to delete`
  String get selectFoldersToDelete {
    return Intl.message(
      'Choose folders to delete',
      name: 'selectFoldersToDelete',
      desc: '',
      args: [],
    );
  }

  /// `Ooops! No files here`
  String get noFilesHere {
    return Intl.message(
      'Ooops! No files here',
      name: 'noFilesHere',
      desc: '',
      args: [],
    );
  }

  /// `Error loading`
  String get errorLoading {
    return Intl.message(
      'Error loading',
      name: 'errorLoading',
      desc: '',
      args: [],
    );
  }

  /// `Try again later`
  String get tryAgainLater {
    return Intl.message(
      'Try again later',
      name: 'tryAgainLater',
      desc: '',
      args: [],
    );
  }

  /// `Loading data`
  String get loadingData {
    return Intl.message(
      'Loading data',
      name: 'loadingData',
      desc: '',
      args: [],
    );
  }

  /// `Viewing image`
  String get viewImage {
    return Intl.message('Viewing image', name: 'viewImage', desc: '', args: []);
  }

  /// `Error Login`
  String get errorLogin {
    return Intl.message('Error Login', name: 'errorLogin', desc: '', args: []);
  }

  /// `For example: example@email.com`
  String get emailExample {
    return Intl.message(
      'For example: example@email.com',
      name: 'emailExample',
      desc: '',
      args: [],
    );
  }

  /// `Please enter yor email`
  String get pleaseEnterEmail {
    return Intl.message(
      'Please enter yor email',
      name: 'pleaseEnterEmail',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `For example: 123qwe`
  String get passwordExample {
    return Intl.message(
      'For example: 123qwe',
      name: 'passwordExample',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your password`
  String get pleaseEnterPassword {
    return Intl.message(
      'Please enter your password',
      name: 'pleaseEnterPassword',
      desc: '',
      args: [],
    );
  }

  /// `Don't have a login? Contact your director`
  String get helpKey {
    return Intl.message(
      'Don\'t have a login? Contact your director',
      name: 'helpKey',
      desc: '',
      args: [],
    );
  }

  /// `Sign in`
  String get signInButton {
    return Intl.message('Sign in', name: 'signInButton', desc: '', args: []);
  }

  /// `Error: {errorMessage}`
  String errorWithMessage(Object errorMessage) {
    return Intl.message(
      'Error: $errorMessage',
      name: 'errorWithMessage',
      desc: '',
      args: [errorMessage],
    );
  }

  /// `Disk`
  String get diskTabTitle {
    return Intl.message('Disk', name: 'diskTabTitle', desc: '', args: []);
  }

  /// `Control`
  String get controlTabTitle {
    return Intl.message('Control', name: 'controlTabTitle', desc: '', args: []);
  }

  /// `Templates`
  String get creationTabTitle {
    return Intl.message(
      'Templates',
      name: 'creationTabTitle',
      desc: '',
      args: [],
    );
  }

  /// `Admin-panel`
  String get adminPanelTitle {
    return Intl.message(
      'Admin-panel',
      name: 'adminPanelTitle',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure?`
  String get areYouSure {
    return Intl.message(
      'Are you sure?',
      name: 'areYouSure',
      desc: '',
      args: [],
    );
  }

  /// `Are you want to change account?`
  String get youWantToChangeAccount {
    return Intl.message(
      'Are you want to change account?',
      name: 'youWantToChangeAccount',
      desc: '',
      args: [],
    );
  }

  /// `Create new access key`
  String get createNewAccessKey {
    return Intl.message(
      'Create new access key',
      name: 'createNewAccessKey',
      desc: '',
      args: [],
    );
  }

  /// `Add new regional`
  String get addNewRegional {
    return Intl.message(
      'Add new regional',
      name: 'addNewRegional',
      desc: '',
      args: [],
    );
  }

  /// `No available users`
  String get noAvailableUsers {
    return Intl.message(
      'No available users',
      name: 'noAvailableUsers',
      desc: '',
      args: [],
    );
  }

  /// `Create new template`
  String get createNewTemplate {
    return Intl.message(
      'Create new template',
      name: 'createNewTemplate',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure to delete user {keyUserName}?`
  String areYouSureWithParam(Object keyUserName) {
    return Intl.message(
      'Are you sure to delete user $keyUserName?',
      name: 'areYouSureWithParam',
      desc: '',
      args: [keyUserName],
    );
  }

  /// `Disk is connected`
  String get diskStatusSuccess {
    return Intl.message(
      'Disk is connected',
      name: 'diskStatusSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Disk is not connected`
  String get diskStatusFailed {
    return Intl.message(
      'Disk is not connected',
      name: 'diskStatusFailed',
      desc: '',
      args: [],
    );
  }

  /// `Images: {imagesCount}`
  String imagesCount(Object imagesCount) {
    return Intl.message(
      'Images: $imagesCount',
      name: 'imagesCount',
      desc: '',
      args: [imagesCount],
    );
  }

  /// `User was successfully created`
  String get userSuccessfullyCreated {
    return Intl.message(
      'User was successfully created',
      name: 'userSuccessfullyCreated',
      desc: '',
      args: [],
    );
  }

  /// `Create new user`
  String get createNewUser {
    return Intl.message(
      'Create new user',
      name: 'createNewUser',
      desc: '',
      args: [],
    );
  }

  /// `Firstname`
  String get firstName {
    return Intl.message('Firstname', name: 'firstName', desc: '', args: []);
  }

  /// `Surname`
  String get lastName {
    return Intl.message('Surname', name: 'lastName', desc: '', args: []);
  }

  /// `Middlename`
  String get middleName {
    return Intl.message('Middlename', name: 'middleName', desc: '', args: []);
  }

  /// `Role`
  String get userRole {
    return Intl.message('Role', name: 'userRole', desc: '', args: []);
  }

  /// `Worker`
  String get userRoleWorker {
    return Intl.message('Worker', name: 'userRoleWorker', desc: '', args: []);
  }

  /// `Admin`
  String get userRoleAdmin {
    return Intl.message('Admin', name: 'userRoleAdmin', desc: '', args: []);
  }

  /// `Regional`
  String get regionalTitle {
    return Intl.message('Regional', name: 'regionalTitle', desc: '', args: []);
  }

  /// `No areas here`
  String get noAreas {
    return Intl.message('No areas here', name: 'noAreas', desc: '', args: []);
  }

  /// `Area`
  String get areaTitle {
    return Intl.message('Area', name: 'areaTitle', desc: '', args: []);
  }

  /// `Create`
  String get createButton {
    return Intl.message('Create', name: 'createButton', desc: '', args: []);
  }

  /// `Save changes`
  String get saveChanges {
    return Intl.message(
      'Save changes',
      name: 'saveChanges',
      desc: '',
      args: [],
    );
  }

  /// `Changes was saved`
  String get changeSaved {
    return Intl.message(
      'Changes was saved',
      name: 'changeSaved',
      desc: '',
      args: [],
    );
  }

  /// `Images created:`
  String get imagesCreated {
    return Intl.message(
      'Images created:',
      name: 'imagesCreated',
      desc: '',
      args: [],
    );
  }

  /// `Last upload:`
  String get lastUpload {
    return Intl.message('Last upload:', name: 'lastUpload', desc: '', args: []);
  }

  /// `Access granted:`
  String get accessGranted {
    return Intl.message(
      'Access granted:',
      name: 'accessGranted',
      desc: '',
      args: [],
    );
  }

  /// `Access edited:`
  String get accessModified {
    return Intl.message(
      'Access edited:',
      name: 'accessModified',
      desc: '',
      args: [],
    );
  }

  /// `Access key`
  String get accessKey {
    return Intl.message('Access key', name: 'accessKey', desc: '', args: []);
  }

  /// `Copied!`
  String get keyCopySuccess {
    return Intl.message('Copied!', name: 'keyCopySuccess', desc: '', args: []);
  }

  /// `Choose regional`
  String get chooseRegional {
    return Intl.message(
      'Choose regional',
      name: 'chooseRegional',
      desc: '',
      args: [],
    );
  }

  /// `Access and user control`
  String get accessControl {
    return Intl.message(
      'Access and user control',
      name: 'accessControl',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ru'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
