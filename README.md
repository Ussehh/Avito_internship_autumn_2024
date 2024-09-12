###Задание на стажировку IOS Авито.###

Этот проект представляет собой iOS-приложение для поиска и просмотра медиа-контента, реализованное с использованием Unsplash API. Приложение состоит из двух экранов:

Экран поиска медиа-контента с возможностью отображения результатов в виде сетки.
Экран детальной информации о контенте с возможностью просмотра подробностей и изображения в большем размере.

#Установка проекта:#

1. Клонирование репозитория: git clone https://github.com/username/Avito_internship_autumn_2024.git

2. Откройте файл ProjectName.xcodeproj в Xcode.

3. API ключ: Для работы с Unsplash API необходимо получить API ключ с Unsplash Developer. Откройте файл NetworkManager и в  static let accessKey = "вставьте ключ сюда"

4. Запуск на симуляторе или устройстве: Выберите симулятор или подключённое устройство, затем нажмите Cmd + R для запуска проекта.

##Основные возможности приложения##

###Экран поиска###
- Отображает строку поиска для ввода запроса.
- Поддерживает сохранение истории до пяти последних поисковых запросов.
- Выполняет поиск медиа-контента по введённому запросу.
- Результаты отображаются в виде сетки с двумя колонками.
- По клику на элемент списка открывается экран с детальной информацией о выбранном медиа-контенте.
- **Реализована лента случайных фотографий**, которая отображается на экране поиска. Случайные фотографии также поддерживают открытие детального экрана и весь функционал приложения (поделиться, сохранить изображение).


###Экран детальной информации###
- Отображает большое изображение контента, описание, а также информацию об авторе.
- Возможность поделиться изображением через другие приложения (Telegram, VK и др.).
- Возможность сохранения изображения в галерею устройства.
- Дополнительные возможности:
- Возможность сортировки результатов поиска по популярности или дате.
- Поддержка пагинации для загрузки большего количества контента.

##Каждый экран приложения поддерживает три состояния:##

- Отображение контента — когда данные успешно загружены и отображаются пользователю.
- Состояние загрузки — отображается индикатор загрузки во время получения данных.
- Отображение ошибки — показывается сообщение об ошибке, если возникла проблема с загрузкой данных.

##Технические требования##
- Язык программирования: Swift.
- Для пользовательского интерфейса использован UIKit.
- Для сетевых запросов используется стандартный URLSession.
- Приложение поддерживает iOS 13.0 и выше.
- Установка зависимостей

Проект не использует сторонние библиотеки или менеджеры зависимостей (например, CocoaPods или SPM). Все реализации сделаны вручную с использованием встроенных фреймворков iOS.


###Пример экрана поиска:###
![Экран поиска + лента](https://github.com/user-attachments/assets/836fa359-9988-416e-9c16-fee06c52d4b5)
![История](https://github.com/user-attachments/assets/066a0953-a218-427f-b1a7-03aaa054d765)

###Пример экрана детальной информации:###
![IMG_0361](https://github.com/user-attachments/assets/9898ffdd-ce43-4b32-89a9-aee488ae9c2d)

###Пример работы приложения: 
https://github.com/user-attachments/assets/a5dd57e9-1b5f-4b08-bde0-e6a97881307b








