```markdown
# 💱 Currency Converter App

A simple and responsive Currency Converter app built with **Flutter**. It fetches real-time currency exchange rates using the **[ExchangeRate-API](https://www.exchangerate-api.com/)** (free plan) and allows users to convert between different currencies instantly.

---

## 🚀 Features

- Convert from one currency to another in real-time
- Fetches up-to-date exchange rates from the ExchangeRate-API
- Clean and responsive UI built with Flutter
- Supports a wide range of currencies
- Lightweight and beginner-friendly

---

## 📱 Screenshots

<!-- Add your app screenshots here -->
<p float="left">
  <img src="screenshots/screen1.png" width="200" />
  <img src="screenshots/screen2.png" width="200" />
  <img src="screenshots/screen3.png" width="200" />
</p>

---

## 🔧 Getting Started

### Prerequisites

- Flutter SDK installed
- Android Studio / VS Code with Flutter extension
- An internet connection (for fetching live exchange rates)

### Installation

1. **Clone this repository:**
   ```bash
   git clone https://github.com/yourusername/flutter-currency-converter.git
   cd flutter-currency-converter
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the app:**
   ```bash
   flutter run
   ```

---

## 🛠️ How It Works

- The app sends an HTTP GET request to ExchangeRate-API with the selected base currency.
- The API responds with conversion rates for all supported currencies.
- The user selects a target currency and enters an amount.
- The app performs the calculation and displays the converted value.

---

## 🔐 API Key Setup

1. Go to [ExchangeRate-API](https://www.exchangerate-api.com/) and sign up for a free plan.
2. Replace the placeholder API key in your Flutter code:

## 📂 Project Structure

```
lib/
│
├── main.dart            # Entry point of the app
├── screens/             # Contains the main UI screen
├── services/            # Handles API fetching logic
└── widgets/             # Reusable UI components (if any)
```

---



