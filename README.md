# CurrencyConverter
Currency Converter Demo

## Description
This is a simple iOS application that converts currencies using a public API. Users can select a source and target currency, input an amount, and view the real-time converted amount. The application periodically refreshes conversion rates every 10 seconds and displays the last updated timestamp.

## Requirements
- iOS 15.6+
- Xcode 13.0+ 
- Swift 5.5+

## Setup & Run
1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/currency-converter-demo.git
    ```
2. Open CurrencyConverter.xcodeproj in Xcode.
3. Select a simulator or a connected device.
4. Press Cmd+R or click the Run button to build and run the app.

No additional dependencies are required.

## API
The application uses a public currency conversion API:
   ```bash
GET http://api.evp.lt/currency/commercial/exchange/{amount}-{fromCurrency}/{toCurrency}/latest
   ```
- Results are parsed into a ConversionResponse model.
- The exchange rates depend on the amount and are updated in real-time.

## Architecture
The application follows the MVVM pattern:

- Model: Represents data structures and domain logic.
- ViewModel: Manages data fetching, formatting, and state (conversion results, last updated time).
- View (UIKit): Programmatically built UI components, no Storyboards or XIBs. Auto Layout is used to ensure responsiveness across different screen sizes, including iPad.

This approach ensures the code is maintainable and easily extensible. Adding new currencies or modifying functionality should not require a complete rewrite.

## User Interface & Features
- Currency Selectors: Two UIPickerView instances to choose the source and target currencies.
- Amount Input: A UITextField to enter the amount to be converted.
- Automatic Conversion: The result updates automatically whenever the amount or selected currencies change, and also every 10 seconds.
- Converted Value Display: A UILabel shows the converted amount.
- Last Updated Label: A UILabel indicates the last time the rates were updated.
- Loading Indicator: Displays while fetching data from the API.
- Error Handling: On network errors, an alert is shown allowing the user to retry.

## How to Use
1. Launch the app.
2. Select the source and target currencies.
3. Enter the amount to convert in the provided text field.
4. The converted amount and last updated time will be displayed. The app refreshes the conversion regularly.

## Code Quality & Best Practices
- Clear separation of concerns via MVVM.
- Error handling and user-friendly error messages.
- Straightforward code structure and naming.
- Easy to add new features (like new currencies) or modify behavior without large-scale refactoring.

## Time Spent
Approx. 4 hours total:

- 30 minutes: Initial project setup & scaffolding.
- 1.5 hours: Implementing UI & Auto Layout programmatically.
- 30 minutes: Networking & JSON parsing.
- 45 minutes: MVVM integration & periodic refresh logic.
- 1 hour: Final refinements, adding the last updated label, UI polishing, and documentation.
