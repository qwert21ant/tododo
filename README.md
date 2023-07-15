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

## Deeplinks
  - `todo://app/`
  - `todo://app/new`

Для тестировани deeplink'ов:
`adb shell am start -a android.intent.action.VIEW -d *deeplink*`

## Релиз
  - Ada Lovelace: [1.0.0](https://disk.yandex.ru/d/mtSCbFwtXO3z1A)
  - Alan Turing: [1.1.0](https://disk.yandex.ru/d/I2ZUEwjaUkd-xQ)
  - Bjarne Stroustrup: [1.2.0](https://disk.yandex.ru/d/GiymRFQA_Yj-Hg)
