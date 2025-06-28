
A logic-only, headless checkout engine built in Dart using the BLoC pattern. This serves as the core engine for future POS and self-service applications.

> ✅ Unit-tested | ♻️ Undo/Redo | 💾 State Hydration | 💰 Money Formatter | 🧠 Pure Dart Logic

---

## 🚀 Features

- 📦 Static product catalog (from `assets/catalog.json`)
- 🛒 Add, remove, update quantity & discount of cart items
- 💰 Calculates subtotal, 15% VAT, and grand total
- 📤 Receipt builder function
- ♻️ Undo/Redo for cart actions
- 💾 State hydration with `hydrated_bloc`
- 💵 `asMoney` extension → `12.5.asMoney` ➝ `"12.50"`

---

## 📂 Project Structure

```
lib/
├── src/
│   ├── catalog/      # Catalog BLoC and Item model
│   ├── cart/         # Cart BLoC, events, state, receipt, models
│   └── util/         # Extensions (e.g. asMoney)
assets/
└── test/             # Unit tests (cart_bloc_test, catalog_bloc_test)
```

---

## ⚙️ Getting Started

### Install dependencies

```bash
flutter pub get
```

---

### Run tests

```bash
flutter test --coverage
```
---

## 📁 Assets

Ensure this is in your `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/catalog.json
```

---

## ⏱️ Time Spent

| Feature                | Time  |
|------------------------|-------|
| Cart BLoC + logic      | ~1.5h |
| Undo/Redo + hydration  | ~1h   |
| Catalog BLoC + parsing | ~0.5h |
| Receipt builder        | ~0.5h |
| Test coverage          | ~1h   |
| CI + documentation     | ~0.5h |
| **Total**              | ~5h   |

---

## 🧠 Tech Stack

- Dart 3
- Flutter SDK ≥ 3.10
- `bloc` & `hydrated_bloc`
- `equatable`, `bloc_test`, `flutter_test`

---

## 📝 License

This project was developed for technical evaluation and demonstration purposes. All logic is written in pure Dart and fully covered by unit tests.

---

Made with 💙 for performance & clarity.
