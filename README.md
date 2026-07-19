# Stock Return Calculator

A simple Flutter app that calculates stock profit/loss and return percentage. It can also fetch the current stock price from Alpha Vantage using a REST API.

## Features

- Enter stock symbol, buy price, quantity, and current price
- Calculate profit/loss and percentage return instantly
- Fetch live current price from Alpha Vantage via REST
- Clean Material UI with responsive input and result display

## Prerequisites

- Flutter SDK installed: https://docs.flutter.dev/get-started/install
- Chrome installed for web testing
- A free Alpha Vantage API key: https://www.alphavantage.co/support/#api-key

## Setup

1. Open the project folder:
   ```powershell
   cd C:\Users\rahul\Downloads\files
   ```
2. Install dependencies:
   ```powershell
   flutter pub get
   ```
3. Add your Alpha Vantage API key:
   - Open `lib/stock_service.dart`
   - Replace `YOUR_API_KEY_HERE` with your API key

## Run the app

To run in Chrome:

```powershell
flutter run -d chrome
```

If you want to run on a specific device later, list devices first:

```powershell
flutter devices
```

## How to use

1. Enter a stock symbol (for example, `AAPL`)
2. Enter the buy price and quantity
3. Enter the current price manually, or tap **Get Live Price** to fetch it from Alpha Vantage
4. Tap **Calculate Return** to see profit/loss and return percentage

## Notes

- The live price feature requires a working internet connection
- The stock symbol must be valid for Alpha Vantage to return a price
- If no live price is available, enter the current price manually

## Files to know

- `lib/main.dart` — main UI and calculation logic
- `lib/stock_service.dart` — API integration for current stock price
- `pubspec.yaml` — Flutter dependencies and project metadata

## Next improvements

- Add error messages for invalid input
- Store calculation history locally
- Add a portfolio summary screen
- Support mobile platforms like Android and iOS
