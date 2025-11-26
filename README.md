# Real-Time-Price-Tracker
# Real-Time Price Tracker iOS App


## 📝 Objective

**iOS app** using **SwiftUI** that displays **real-time price updates** for multiple stock symbols (e.g., NVDA, AAPL, GOOG) and provides a **symbol details screen** using `NavigationStack`.

---

## ⚡ Core Features

### 1. Live Price Tracking for Multiple Symbols
- Supports **25+ stock symbols** to create a scrollable list (e.g., AAPL, GOOG, TSLA, AMZN, MSFT, NVDA).
- Generates **random price updates every 2 seconds** per symbol.
- Sends updates via **WebSocket** and receives the echoed message to update the UI in real-time.

**WebSocket Server:**  
`wss://ws.postman-echo.com/raw`

---

### 2. Real-Time Price Display (Feed Screen)
- **UI:** Using List to display one row per symbol.
- Each row shows:
  - Symbol name (e.g., `AAPL`)
  - Current price
  - Price change indicator (green ↑ for increase / red ↓ for decrease)
- **Sorting:** Symbols are **sorted by price descending** (highest first).
- **Navigation:** Tap a row to open **Symbol Details** screen.

---

### 3. Top Bar UI (Feed Screen)
- **Left:** Connection status indicator  
  - 🟢 Connected  
  - 🔴 Disconnected
- **Right:** Toggle button to **Start / Stop** the price feed.

---

### 4. Symbol Details Screen
- Shows:
  - Selected symbol as **title**
  - Current price with ↑/↓ indicator (same as feed)
  - Description about the symbol
- Provides **real-time updates** using shared WebSocket feed.

---

## 🛠 Technical Details

- **SwiftUI
- **Architecture:** MVVM / Unidirectional Data Flow
- **Data Handling:** Uses **Combine** for WebSocket streams.

---

## 🚀 Features Summary

| Feature | Description |
|---------|-------------|
| Real-Time Prices | Live updates every 2 seconds via WebSocket echo |
| Feed Screen | Scrollable list of stock symbols with current price & indicator |
| Symbol Details | Detailed view for each symbol |
| Connection Status | Indicator for WebSocket connectivity |
| Start/Stop Feed | Control the price feed dynamically |
| Architecture | MVVM / Unidirectional Data Flow |
| SwiftUI 
| Combine | Handles asynchronous WebSocket messages |
| Dark Mode | Supports light & dark system themes |

---

## 📦 Requirements

- Xcode
- SwiftUI
- Combine framework

---

## 🔧 Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/RealTimePriceTracker.git
```
2. Open the project in **Xcode**.
3. Select the desired **simulator/device**.
4. Run the app (`Cmd + R`).

---

## ⚙️ Usage

1. Launch the app → **Stocks Feed** screen appears.
2. Press **Start** to begin the live feed.
3. Observe **price changes** and row highlights (green/red flashes on increase/decrease).
4. Tap a stock symbol to view its **details screen**.
5. Press **Stop** to pause updates.

---

## 🧪 Testing

- Unit tests available for:
  -  Price tracker ViewModel 
  - Start/Stop feed logic
- UI tests available for:
  - Feed screen 
  - Deep link navigation (`stocks://symbol/AAPL`)


