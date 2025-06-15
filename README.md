# ⛽ Fuel Finder

Fuel Finder is a cross-platform mobile application that helps users locate nearby fuel stations, view real-time fuel availability and prices, and get directions using an integrated map. It's designed for convenience, reliability, and ease of use during fuel shortages or travel.

## Features
Nearby Fuel Stations: Find fuel stations near your location using real-time GPS.<br>
Fuel Availability: Check availability of Petrol and Diesel.<br>
Live Prices: View current fuel prices and price trends.<br>
Map Integration: Get directions to your selected fuel station via Google Maps.<br>
User Feedback: Add comments on station status and rate them.<br>
Secure Authentication: Login/sign-up with phone number or email.<br>
Onboarding Screens: Simple walkthrough to guide new users.<br>

## Tech Stack
Frontend: Flutter<br>
Backend: Node.js (PostgreSQL + Express.js)<br>
Maps: Google Maps API / Mapbox (configurable)<br>
State Management: Bloc<br>

## Installation 💻

### Prerequisites
- Flutter SDK (v3.0.0 or later)
- Dart SDK
- Node.js (for backend)
- PostgreSQL
- Google Maps API key

### Clone the Repository
```bash
git clone https://github.com/EBAS-TECH/fuel-finder-mobile.git
cd fuel-finder-mobile
```
### Project Structure 📂
```plaintext
fuel-finder-mobile/
├── lib/
│   ├── core/
│   │   ├── themes/             # App-wide themes (colors, text styles)
│   │   ├── localizations/      # Localization setup
│   │   └── utils/              # Utility functions
│   │
│   ├── features/               # Feature modules
│   │   ├── auth/               # Authentication
│   │   ├── favorite/           # Favorite stations
│   │   ├── feedback/           # User feedback
│   │   ├── fuel_price/         # Price tracking
│   │   ├── gas_station/        # Station data
│   │   ├── map/                # Map services
│   │   ├── onboarding/         # Onboarding flow
│   │   ├── route/              # Navigation
│   │   ├── settings/           # App settings
│   │   └── user/               # User profile
│   │
├── l10n/                       # Localization files
├── shared/                     # Shared components
├── test/                       # Test suites
├── .env                        # Environment config
└── main.dart                   # App entry point
```

### Install Dependencies
```bash
flutter pub get
```
### Configure environment variables:
- Create a .env file in the root directory:
```bash
GOOGLE_MAPS_API_KEY=API_KEY
API_BASE_URL=BACK_END_URL (Will be provided)
```
### Run the app
```bash
flutter run
```
## Contributing 🤝

1. Fork the project  
2. Create your feature branch 
   ```bash
   git checkout -b feature/AmazingFeature
   ```
3. Commit your changes
   ```bash
   git commit -m 'Add some AmazingFeature'
   ```
4. Push your changes
   ```bash
   git push origin feature/AmazingFeature
   ```
5. Open pull request


