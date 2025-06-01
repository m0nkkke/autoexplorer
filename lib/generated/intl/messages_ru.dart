// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ru locale. All the
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
  String get localeName => 'ru';

  static String m0(foldersToDelete) =>
      "Вы уверены, что хотите удалить ${foldersToDelete} папок?";

  static String m1(keyUserName) =>
      "Вы действительно хотите удалить ${keyUserName}?";

  static String m2(errorMessage) => "Ошибка: ${errorMessage}";

  static String m3(filesCount) => "Количество файлов: ${filesCount}";

  static String m4(imagesCount) => "Изображений: ${imagesCount} шт.";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "accessControl": MessageLookupByLibrary.simpleMessage(
      "Контроль доступа и учетной записи",
    ),
    "accessGranted": MessageLookupByLibrary.simpleMessage("Доступ выдан"),
    "accessKey": MessageLookupByLibrary.simpleMessage("Ключ доступа"),
    "accessModified": MessageLookupByLibrary.simpleMessage("Доступ изменен"),
    "addNewRegional": MessageLookupByLibrary.simpleMessage("Добавить регионал"),
    "adminPanelTitle": MessageLookupByLibrary.simpleMessage("Админ-панель"),
    "areYouSure": MessageLookupByLibrary.simpleMessage("Вы уверены?"),
    "areYouSureToDeleteNFolders": m0,
    "areYouSureToDeleteSync": MessageLookupByLibrary.simpleMessage(
      "Вы уверены, что хотите удалить все синхронизированные файлы из текущей папки?",
    ),
    "areYouSureWithParam": m1,
    "areaTitle": MessageLookupByLibrary.simpleMessage("Участок"),
    "cameraMode": MessageLookupByLibrary.simpleMessage("Из камеры"),
    "cancelButton": MessageLookupByLibrary.simpleMessage("Отмена"),
    "changeSaved": MessageLookupByLibrary.simpleMessage("Изменения сохранены"),
    "chooseRegional": MessageLookupByLibrary.simpleMessage("Выберите регионал"),
    "confrimDelete": MessageLookupByLibrary.simpleMessage(
      "Подтвердить удаление",
    ),
    "controlTabTitle": MessageLookupByLibrary.simpleMessage("Контроль"),
    "createButton": MessageLookupByLibrary.simpleMessage("Создать"),
    "createFolder": MessageLookupByLibrary.simpleMessage("Создать папку"),
    "createFolderMenu": MessageLookupByLibrary.simpleMessage("Новая папка"),
    "createNewAccessKey": MessageLookupByLibrary.simpleMessage(
      "Создать новый ключ доступа",
    ),
    "createNewTemplate": MessageLookupByLibrary.simpleMessage(
      "Создать новый шаблон",
    ),
    "createNewUser": MessageLookupByLibrary.simpleMessage(
      "Создать нового пользователя",
    ),
    "creationTabTitle": MessageLookupByLibrary.simpleMessage("Создание"),
    "deleteButton": MessageLookupByLibrary.simpleMessage("Удалить"),
    "deleteSelected": MessageLookupByLibrary.simpleMessage("Удалить выбранное"),
    "deleteSyncFiles": MessageLookupByLibrary.simpleMessage(
      "Удалить синх-файлы",
    ),
    "deleteSyncWindow": MessageLookupByLibrary.simpleMessage("Удалить файлы"),
    "diskStatusFailed": MessageLookupByLibrary.simpleMessage("Диск отключен"),
    "diskStatusSuccess": MessageLookupByLibrary.simpleMessage("Диск подключен"),
    "diskTabTitle": MessageLookupByLibrary.simpleMessage("Диск"),
    "emailExample": MessageLookupByLibrary.simpleMessage(
      "Например: example@email.com",
    ),
    "errorLoading": MessageLookupByLibrary.simpleMessage("Ошибка загрузки"),
    "errorLogin": MessageLookupByLibrary.simpleMessage("Ошибка входа"),
    "errorWithMessage": m2,
    "filesCount": m3,
    "firstName": MessageLookupByLibrary.simpleMessage("Имя"),
    "folderName": MessageLookupByLibrary.simpleMessage("Имя папки"),
    "galleryMode": MessageLookupByLibrary.simpleMessage("Из галереи"),
    "helpKey": MessageLookupByLibrary.simpleMessage(
      "Чтобы получить ключь, свяжитесь с начальником",
    ),
    "iconsViewMode": MessageLookupByLibrary.simpleMessage("Вид значков"),
    "iconsViewModeLarge": MessageLookupByLibrary.simpleMessage("Крупный"),
    "iconsViewModeSmall": MessageLookupByLibrary.simpleMessage("Маленький"),
    "imagesCount": m4,
    "imagesCreated": MessageLookupByLibrary.simpleMessage(
      "Изображений создано",
    ),
    "internetHasArrived": MessageLookupByLibrary.simpleMessage(
      "Интернет доступен. Перейдите в меню для отправки фото на диск",
    ),
    "keyCopySuccess": MessageLookupByLibrary.simpleMessage(
      "Ключ скопирован в буфер обмена",
    ),
    "lastName": MessageLookupByLibrary.simpleMessage("Фамилия"),
    "lastUpload": MessageLookupByLibrary.simpleMessage("Последняя загрузка"),
    "loadingData": MessageLookupByLibrary.simpleMessage("Загрузка данных"),
    "middleName": MessageLookupByLibrary.simpleMessage("Отчество"),
    "noAreas": MessageLookupByLibrary.simpleMessage("Нет ни одного участка"),
    "noAvailableUsers": MessageLookupByLibrary.simpleMessage(
      "Нет доступных пользователей",
    ),
    "noFilesHere": MessageLookupByLibrary.simpleMessage(
      "Упс! Здесь нет файлов",
    ),
    "password": MessageLookupByLibrary.simpleMessage("Пароль"),
    "passwordExample": MessageLookupByLibrary.simpleMessage("Например: 123qwe"),
    "pleaseEnterEmail": MessageLookupByLibrary.simpleMessage(
      "Пожалуйста, введите свой email",
    ),
    "pleaseEnterPassword": MessageLookupByLibrary.simpleMessage(
      "Пожалуйста, введите свой пароль",
    ),
    "refreshMenu": MessageLookupByLibrary.simpleMessage("Обновить"),
    "regionalTitle": MessageLookupByLibrary.simpleMessage("Регионал"),
    "saveChanges": MessageLookupByLibrary.simpleMessage("Сохранить изменения"),
    "searchMenu": MessageLookupByLibrary.simpleMessage("Поиск"),
    "selectAll": MessageLookupByLibrary.simpleMessage("Выделить все"),
    "selectFoldersToDelete": MessageLookupByLibrary.simpleMessage(
      "Выберите файлы для удаления",
    ),
    "sendToDisk": MessageLookupByLibrary.simpleMessage("Отправить на диск"),
    "signInButton": MessageLookupByLibrary.simpleMessage("Авторизоваться"),
    "sortByDate": MessageLookupByLibrary.simpleMessage("Сортировка по дате"),
    "sortByName": MessageLookupByLibrary.simpleMessage("Сортировка по имени"),
    "sortModeTitle": MessageLookupByLibrary.simpleMessage("Сортировка"),
    "switchAccount": MessageLookupByLibrary.simpleMessage("Сменить аккаунт"),
    "tryAgainLater": MessageLookupByLibrary.simpleMessage("Попробуйте позже"),
    "userRole": MessageLookupByLibrary.simpleMessage("Роль"),
    "userRoleAdmin": MessageLookupByLibrary.simpleMessage("Админ"),
    "userRoleWorker": MessageLookupByLibrary.simpleMessage("Работник"),
    "userSuccessfullyCreated": MessageLookupByLibrary.simpleMessage(
      "Пользователь успешно создан",
    ),
    "viewImage": MessageLookupByLibrary.simpleMessage("Просмотр изображения"),
    "youWantToChangeAccount": MessageLookupByLibrary.simpleMessage(
      "Вы действительно хотите сменить аккаунт?",
    ),
  };
}
