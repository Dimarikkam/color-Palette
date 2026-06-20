# Color Palette

Flutter-приложение для выбора цвета из полной палитры. Фон экрана меняется на выбранный цвет, отображаются коды HEX, RGB, RGBA, HSL и Flutter.

## Требования

- [Flutter SDK](https://docs.flutter.dev/get-started/install) 3.16+
- Для iOS / App Store: macOS с Xcode 15+
- Apple Developer Account

## Быстрый старт

```bash
# 1. Установите Flutter и добавьте в PATH
# https://docs.flutter.dev/get-started/install/windows

# 2. Перейдите в папку проекта
cd c:\proVir

# 3. Сгенерируйте недостающие платформенные файлы (если нужно)
flutter create . --platforms=ios,android

# 4. Установите зависимости
flutter pub get

# 5. Запуск на эмуляторе или устройстве
flutter run
```

## Публикация в App Store

1. Откройте `ios/Runner.xcworkspace` в Xcode (на Mac).
2. Задайте **Bundle Identifier** (например `com.yourcompany.colorpalette`).
3. Настройте подпись (Signing & Capabilities) с вашим Apple Developer Team.
4. Соберите архив: **Product → Archive**.
5. Загрузите через **Organizer → Distribute App → App Store Connect**.

```bash
# Сборка IPA из командной строки (на Mac)
flutter build ipa --release
```

## Структура

```
lib/
  main.dart                 — точка входа
  screens/
    color_picker_screen.dart — главный экран
  widgets/
    color_palette_grid.dart  — сетка палитры
    color_info_panel.dart    — панель с кодами цвета
  utils/
    color_utils.dart         — генерация палитры и форматы
```

## Возможности

- Более 900 цветов (Material + полный HSL-спектр)
- Мгновенная смена фона при выборе
- Коды: HEX, HEX+Alpha, RGB, RGBA, HSL, Flutter `Color(...)`
- Копирование кода по нажатию
- Адаптивные цвета текста (светлый/тёмный фон)
