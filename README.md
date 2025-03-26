# AutoExplorer

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Android](https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white)
![iOS](https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=ios&logoColor=white)

**AutoExplorer** — это кроссплатформенное мобильное приложение, представляющее собой файловый проводник с интеграцией с сервером и системой ролей для управления доступом к файлам.

## О проекте

Проект разработан по заказу компании, специализирующейся на очистке охранных зон инженерных коммуникаций от объектов, которые могут препятствовать их работе. Приложение позволяет пользователям (администраторам и работникам) управлять файлами, хранящимися как локально, так и в облачном хранилище Яндекс.Диск. Данные синхронизируются с сервером при первом подключении к интернету.

Основная цель проекта — создание удобного и безопасного инструмента для работы с файлами с разграничением прав доступа на основе ролей.

Параллельно проект является учебным и предназначен для освоения современных технологий разработки мобильных приложений.

## Функциональность

- **Система ролей**: Разграничение прав доступа между администраторами и работниками.
    - **Администраторы**: Создание и управление работниками, назначение прав доступа (CRUD) к файлам.
    - **Работники**: Работа с файлами в соответствии с назначенными правами.
- **Файловый проводник**: Удобный интерфейс для просмотра и управления файлами.
- **Локальное и облачное хранилище**: Поддержка локального хранилища и облачного хранилища Яндекс.Диск.
- **Синхронизация с сервером**: Автоматическая синхронизация данных при подключении к интернету.
- **Авторизация**: Безопасная авторизация через Firebase.

## Архитектура

Приложение построено на архитектурном паттерне BLoC (Business Logic Component), что обеспечивает разделение логики и представления.

- **BLoC**: Управление состоянием приложения и обработка бизнес-логики.
- **Repository**: Абстракция для работы с данными, как локальными, так и удаленными.
- **LocalStorage**: Локальное хранилище данных.
- **YandexDisk**: Интеграция с облачным хранилищем Яндекс.Диск.
- **Firebase**: Сервис для авторизации пользователей.

## Технологии

- **Flutter**: Фреймворк для разработки кросс-платформенных мобильных приложений.
- **Firebase**: Сервис для авторизации и аутентификации пользователей.
- **Яндекс.Диск API**: Интеграция с облачным хранилищем.
- **BLoC**: Паттерн управления состоянием приложения.

## Установка

1.  Клонируйте репозиторий: `git clone <ссылка на репозиторий>`
2.  Перейдите в директорию проекта: `cd autoexplorer`
3.  Установите зависимости: `flutter pub get`
4.  Настройте Firebase и Яндекс.Диск API (инструкции будут добавлены).
5.  Запустите приложение: `flutter run`

## Команда разработки

Проект выполнен учебным коллективом:

- **Антон "Alangmat" Кроликов**
- **Николай "m0nkkke" Курицын**
- **Максим "maksimvorobev" Воробьев**
- **Сергей "s4lex" Келемник**

По всем вопросам можно обращаться к руководителю проекта:
**Telegram**: [@Alangmat](https://t.me/Alangmat)
