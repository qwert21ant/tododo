# ToDoDo

Приложение TODO list на Flutter

## Скрины

![Screenshots](/assets/screens.png)

## Что реализовано:
  - Свёрстаны 2 экрана: основной и редактирования задачи
  - Логика при свайпе item'ов
  - Логика добавления/редактирования задачи
  - Логика отображения выполненных дел
  - Навигация (Navigator 2.0)
  - Логгирование
  - Сохранение данных локально и на сервере
  - Синхронизация данных
  - Интернационализация
  - Deeplinks
  - Unit тесты
  - Интеграционные тесты
  - Тёмная тема
  - Сервисы Firebase
  - GitHub Actions
  - Flavors
  - Адаптивность

## Firebase App Distribution
Инвайт [ссылка](https://appdistribution.firebase.dev/i/674567bb00bc1ab0)

## Flavors
Для перехода на dev flavor добавьте `--dart-define=FLAVOR=DEV` к аргументам `flutter run`

## Deeplinks
  - `todo://app/`
  - `todo://app/new`

Для тестировани deeplink'ов:
`adb shell am start -a android.intent.action.VIEW -d *deeplink*`

## Релиз
  - Ada Lovelace: [1.0.0](https://disk.yandex.ru/d/mtSCbFwtXO3z1A)
  - Alan Turing: [1.1.0](https://disk.yandex.ru/d/I2ZUEwjaUkd-xQ)
  - Bjarne Stroustrup: [1.2.0](https://disk.yandex.ru/d/GiymRFQA_Yj-Hg)
  - Linus Torvalds: [1.3.0](https://disk.yandex.ru/d/TdwIh4Ebkh-HIQ)