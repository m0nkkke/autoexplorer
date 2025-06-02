# AutoExplorer

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Android](https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white)
![iOS](https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=ios&logoColor=white)

---

## О проекте

**AutoExplorer** — это кроссплатформенное мобильное приложение, представляющее собой файловый проводник с интеграцией с сервером и системой ролей для управления доступом к файлам.

Проект разработан по заказу компании, специализирующейся на очистке охранных зон инженерных коммуникаций от объектов, которые могут препятствовать их работе. Приложение позволяет пользователям (администраторам и работникам) управлять файлами, хранящимися как локально, так и в облачном хранилище Яндекс.Диск. Данные синхронизируются с сервером при первом подключении к интернету.

Основная цель проекта — создание удобного и безопасного инструмента для работы с файлами с разграничением прав доступа на основе ролей. Параллельно проект является учебным и предназначен для освоения современных технологий разработки мобильных приложений.

---

## Функциональность

В приложении реализована **система ролей пользователей** — **Работник** и **Администратор**, обеспечивающая гибкое разграничение прав доступа. Также поддерживается **мультиязычность** (русский и английский языки, зависящая от системного языка устройства) и **система уведомлений** через Firebase Cloud Messaging.

### Функционал Работника

1.  **Авторизация**: Вход в систему по выданным администратором данным (e-mail + пароль).
2.  **Навигация**: Просмотр текущего местоположения в иерархии диска через шапку приложения.
3.  **Управление файлами**: Создание папок и добавление изображений внутри назначенного регионала.
4.  **Просмотр содержимого**: Отображение наполненности папки изображениями (вложенность папок не учитывается).
5.  **Детализация файлов**: Просмотр даты создания изображения.
6.  **Настройка интерфейса**: Возможность изменения размера иконок.
7.  **Сортировка**: Сортировка файлов по имени и по дате. При сортировке по дате у папок учитывается их наполненность (папки с наибольшим количеством файлов оказываются вверху при сортировке по убыванию).
8.  **Поиск**: Поиск по названию файлов и папок.
9.  **Обновление данных**: Обновление страницы "потягиванием" сверху вниз или через меню.
10. **Загрузка на диск**: Отправка папок и файлов из приложения на Яндекс.Диск через меню.
11. **Освобождение места**: Возможность удаления уже отправленных на диск файлов из приложения для экономии места на устройстве.
12. **Автономная работа**: Работа в двух режимах – онлайн и офлайн.
    * **В сети**: Постоянная синхронизация с диском, что может вызывать задержки.
    * **Вне сети**: Все изображения сохраняются на устройстве до появления сети. При появлении сети внизу приложения несколько раз появляется уведомление с предложением отправить файлы на диск.

### Функционал Администратора

Функционал администратора **полностью дублирует функционал работника**, за исключением особенностей синхронизации, поскольку администратор постоянно работает в сети.

Дополнительный функционал администратора:

1.  **Полный доступ к диску**: Просмотр всех папок и файлов на Яндекс.Диске.
2.  **Информация о диске**: Просмотр состояния диска и его наполненности, включая количество изображений.
3.  **Создание структуры**: Возможность создавать папки (регионалы и вложения в них).
4.  **Управление пользователями**:
    * Создание новых пользователей.
    * Назначение ФИО, e-mail (ключ доступа), пароля, роли, регионала и участков.
    * Удаление пользователей путем нажатия и удержания на элементе пользователя.
    * Просмотр данных и статистики пользователя, а также изменение его прав доступа.
5.  **Обновление списка пользователей**: Обновление списка "потягиванием" сверху вниз.

---

## Архитектура

Приложение построено на архитектурном паттерне **BLoC (Business Logic Component)**, что обеспечивает четкое разделение логики и представления.

-   **BLoC**: Управление состоянием приложения и обработка бизнес-логики.
-   **Repository**: Абстракция для работы с данными, как локальными, так и удаленными.
-   **LocalStorage**: Локальное хранилище данных на устройстве.
-   **YandexDisk**: Интеграция с облачным хранилищем Яндекс.Диск.
-   **Firebase**: Сервис для авторизации и аутентификации пользователей, а также для Push-уведомлений.

---

## Технологии

-   **Flutter**: Фреймворк для разработки кросс-платформенных мобильных приложений.
-   **Firebase**: Сервис для авторизации, аутентификации пользователей и отправки уведомлений.
-   **Яндекс.Диск API**: Интеграция с облачным хранилищем.
-   **BLoC**: Паттерн управления состоянием приложения.

---

## Скриншоты / Screenshots

<p align="center">
  <img src="https://i.ibb.co/HTzB2z59/auth.jpg" alt="Экран авторизации" width="170" />
  <img src="https://i.ibb.co/Df7GGXQN/main.jpg" alt="Основной экран приложения" width="170" />
  <img src="https://i.ibb.co/QFcjSBqX/main1.jpg" alt="Главный экран с папками" width="170" />
  <img src="https://i.ibb.co/DDHhqWKQ/admin2.jpg" alt="Навигация по папкам" width="170" />
  <img src="https://i.ibb.co/M52LjkSw/admin.jpg" alt="Панель администратора" width="170" />
</p>

---

## Установка

Для запуска и работы с приложением вам потребуется настроить несколько внешних сервисов.

1.  **Клонируйте репозиторий**:
    ```bash
    git clone <ссылка_на_репозиторий>
    ```
2.  **Перейдите в директорию проекта**:
    ```bash
    cd autoexplorer
    ```
3.  **Установите зависимости**:
    ```bash
    flutter pub get
    ```
4.  **Настройка переменных окружения (.env файл)**:
    Создайте в корне проекта файл `.env` и заполните его следующими данными. Эти токены и ключи необходимы для подключения к Firebase и Яндекс.Диску.

    ```
    YANDEX_DISK_TOKEN=
    API_KEY_WEB=
    APP_ID_WEB=

    API_KEY_ANDROID=
    APP_ID_ANDROID=

    API_KEY_IOS=
    APP_ID_IOS=

    MESSAGING_SENDER_ID=
    PROJECT_ID=
    AUTH_DOMAIN=
    STORAGE_BUCKET=
    IOS_BUNDLE_ID=
    ```

    * **Для получения `YANDEX_DISK_TOKEN`**:
        1.  Перейдите на страницу [получения токена Яндекс.Диска](https://oauth.yandex.ru/authorize?response_type=token&client_id=<ID_ВАШЕГО_ПРИЛОЖЕНИЯ>) (замените `<ID_ВАШЕГО_ПРИЛОЖЕНИЯ>` на ID вашего приложения, зарегистрированного в Яндекс.OAuth).
        2.  Предоставьте вашему приложению необходимые права доступа к Яндекс.Диску. Вам потребуются права на **доступ к файлам и папкам Яндекс.Диска**.
        3.  После авторизации вы получите токен.

    * **Для получения Firebase ключей (`API_KEY`, `APP_ID`, `PROJECT_ID` и т.д.)**:
        1.  Перейдите в [Firebase Console](https://console.firebase.google.com/).
        2.  **Создайте новый проект Firebase** или выберите существующий.
        3.  Внутри проекта, в разделе "Project settings" (значок шестеренки), перейдите на вкладку **"General"**.
        4.  **Для веб-приложения**: Прокрутите вниз до раздела "Your apps" и нажмите "Add app" (значок `</>`). Следуйте инструкциям, и Firebase предоставит вам конфигурационный объект, содержащий `API_KEY_WEB` и `APP_ID_WEB`.
        5.  **Для Android-приложения**: Нажмите "Add app" (значок Android). Следуйте инструкциям, укажите имя пакета (например, `com.example.autoexplorer`) и Firebase предоставит `APP_ID_ANDROID`. `API_KEY_ANDROID` можно найти в скачанном файле `google-services.json` (поле `current_key`).
        6.  **Для iOS-приложения**: Нажмите "Add app" (значок iOS). Следуйте инструкциям, укажите Bundle ID (например, `com.example.autoexplorer`). Firebase предоставит `APP_ID_IOS`. `API_KEY_IOS` и `IOS_BUNDLE_ID` можно найти в скачанном файле `GoogleService-Info.plist`.
        7.  **Общие параметры**: `MESSAGING_SENDER_ID` находится на вкладке "Cloud Messaging". `PROJECT_ID`, `AUTH_DOMAIN`, `STORAGE_BUCKET` находятся на вкладке "General" в разделе "Your project" или в конфигурации ваших приложений.

5.  **Настройте Firebase для Flutter**:
    ```bash
    dart pub global activate flutterfire_cli
    flutterfire configure
    ```
    Следуйте инструкциям в терминале, выберите ваш проект Firebase. Эта команда автоматически сгенерирует файл `lib/firebase_options.dart` и настроит нативные файлы проекта.

6.  **Запустите приложение**:
    ```bash
    flutter run
    ```

---

## Команда разработки

Проект выполнен учебным коллективом:

-   **Антон "Alangmat" Кроликов**
-   **Николай "m0nkkke" Курицын**

По всем вопросам можно обращаться к создателям проекта:
**Telegram**: [@Alangmat](https://t.me/Alangmat) [@chikipukio](https://t.me/chikipukio)

---

## About the Project

**AutoExplorer** is a cross-platform mobile application that serves as a file explorer with server integration and a role-based access system for managing file access.

This project was developed for a company specializing in clearing security zones of engineering communications from objects that could impede their operation. The application allows users (administrators and workers) to manage files stored both locally and in Yandex.Disk cloud storage. Data synchronizes with the server upon the first internet connection.

The main goal of the project is to create a convenient and secure tool for working with files, with access rights delimited by roles. Concurrently, the project serves an educational purpose, aimed at mastering modern mobile application development technologies.

---

## Functionality

The application implements a **user role system**—**Worker** and **Administrator**—ensuring flexible access right delineation. It also supports **multi-language localization** (English and Russian, depending on the device's system language) and a **notification system** via Firebase Cloud Messaging.

### Worker Functionality

1.  **Authorization**: Log in using credentials (email + password) provided by an administrator.
2.  **Navigation**: View the current location within the disk hierarchy via the app header.
3.  **File Management**: Create folders and add images within the assigned regional folder.
4.  **Content Viewing**: Display the contents of a folder with images (nested folders are not considered).
5.  **File Details**: View the creation date of an image.
6.  **Interface Customization**: Ability to change the size of icons.
7.  **Sorting**: Sort files by name and date. When sorting by date, folders are sorted by their content fullness (folders with the most files appear at the top when sorted descending).
8.  **Search**: Search by name, including both folders and files.
9.  **Data Refresh**: Refresh the page by pulling down from the top or through the menu.
10. **Upload to Disk**: Send folders and files from the application to Yandex.Disk via the menu.
11. **Space Management**: Option to delete files already sent to the disk from the application to save device space.
12. **Offline Mode**: Work in two modes: online and offline.
    * **Online**: Continuous network loading for synchronization with the disk, which may cause delays.
    * **Offline**: All images are saved on the device until a network connection is available. When the network becomes available, a notification will appear several times at the bottom of the app, prompting the user to go to the menu and send files to the disk.

### Administrator Functionality

The administrator's functionality **fully duplicates the worker's functionality**, with the exception of synchronization specifics, as administrators constantly work online.

Additional administrator functionality:

1.  **Full Disk Access**: View all folders and files on Yandex.Disk.
2.  **Disk Information**: View disk status and its occupancy, including the number of images.
3.  **Structure Creation**: Ability to create folders (regional and nested ones).
4.  **User Management**:
    * Create new users.
    * Assign full name, email (access key), password, role, regional folder, and sections.
    * Delete users by pressing and holding on the user entry.
    * View user data and statistics, and modify their access rights.
5.  **User List Refresh**: Refresh the user list by pulling down from the top of the page.

---

## Architecture

The application is built using the **BLoC (Business Logic Component)** architectural pattern, ensuring a clear separation of logic and presentation.

-   **BLoC**: Manages application state and handles business logic.
-   **Repository**: Provides an abstraction for working with data, both local and remote.
-   **LocalStorage**: Handles local data storage on the device.
-   **YandexDisk**: Integrates with Yandex.Disk cloud storage.
-   **Firebase**: Provides user authentication and authorization services, as well as Push notifications.

---

## Technologies

-   **Flutter**: Framework for cross-platform mobile application development.
-   **Firebase**: Service for user authentication, authorization, and sending notifications.
-   **Yandex.Disk API**: Integration with cloud storage.
-   **BLoC**: Application state management pattern.

---

## Installation

To run and work with the application, you'll need to configure several external services.

1.  **Clone the repository**:
    ```bash
    git clone <repository_link>
    ```
2.  **Navigate to the project directory**:
    ```bash
    cd autoexplorer
    ```
3.  **Install dependencies**:
    ```bash
    flutter pub get
    ```
4.  **Configure Environment Variables (.env file)**:
    Create a `.env` file in the project's root directory and populate it with the following data. These tokens and keys are essential for connecting to Firebase and Yandex.Disk.

    ```
    YANDEX_DISK_TOKEN=
    API_KEY_WEB=
    APP_ID_WEB=

    API_KEY_ANDROID=
    APP_ID_ANDROID=

    API_KEY_IOS=
    APP_ID_IOS=

    MESSAGING_SENDER_ID=
    PROJECT_ID=
    AUTH_DOMAIN=
    STORAGE_BUCKET=
    IOS_BUNDLE_ID=
    ```

    * **To get `YANDEX_DISK_TOKEN`**:
        1.  Go to the [Yandex.Disk token acquisition page](https://oauth.yandex.ru/authorize?response_type=token&client_id=<YOUR_APP_ID>) (replace `<YOUR_APP_ID>` with your application's ID registered in Yandex.OAuth).
        2.  Grant your application the necessary access rights to Yandex.Disk. You will need permissions for **accessing Yandex.Disk files and folders**.
        3.  After authorization, you will receive the token.

    * **To get Firebase keys (`API_KEY`, `APP_ID`, `PROJECT_ID`, etc.)**:
        1.  Go to the [Firebase Console](https://console.firebase.google.com/).
        2.  **Create a new Firebase project** or select an existing one.
        3.  Inside the project, in the "Project settings" (gear icon), go to the **"General"** tab.
        4.  **For a web application**: Scroll down to the "Your apps" section and click "Add app" (the `</>` icon). Follow the instructions, and Firebase will provide a configuration object containing `API_KEY_WEB` and `APP_ID_WEB`.
        5.  **For an Android application**: Click "Add app" (the Android icon). Follow the instructions, specify the package name (e.g., `com.example.autoexplorer`), and Firebase will provide `APP_ID_ANDROID`. The `API_KEY_ANDROID` can be found in the downloaded `google-services.json` file (under the `current_key` field).
        6.  **For an iOS application**: Click "Add app" (the iOS icon). Follow the instructions, specify the Bundle ID (e.g., `com.example.autoexplorer`). Firebase will provide `APP_ID_IOS`. The `API_KEY_IOS` and `IOS_BUNDLE_ID` can be found in the downloaded `GoogleService-Info.plist` file.
        7.  **Common parameters**: `MESSAGING_SENDER_ID` is on the "Cloud Messaging" tab. `PROJECT_ID`, `AUTH_DOMAIN`, and `STORAGE_BUCKET` are on the "General" tab in the "Your project" section or within your app configurations.

5.  **Configure Firebase for Flutter**:
    ```bash
    dart pub global activate flutterfire_cli
    flutterfire configure
    ```
    Follow the instructions in the terminal and select your Firebase project. This command will automatically generate the `lib/firebase_options.dart` file and configure the native project files.

6.  **Run the application**:
    ```bash
    flutter run
    ```

---

## Development Team

This project was completed by a student team:

-   **Anton "Alangmat" Krolikov**
-   **Nikolai "m0nkkke" Kuritsyn**

For any questions, you can contact the project team:
**Telegram**: [@Alangmat](https://t.me/Alangmat) [@chikipukio](https://t.me/chikipukio)

