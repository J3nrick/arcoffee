# Arcoffee — "It's always been ours."

A production-ready Flutter Web application engineered strictly under **Apple's Human Interface Guidelines (HIG)** for **Arcoffee**, the premier courtside coffee sanctuary located inside **The Pickleground PH** in Kawit / Noveleta, Cavite.

---

## ☕ Project Identity & Context

* **Brand Name:** Arcoffee
* **Slogan:** *"It's always been ours."*
* **Location:** The Pickleground PH, Advincula Ave, Kawit / Noveleta boundary, Cavite, Philippines
* **Operating Hours:**
  * **Monday – Thursday:** `2:00 PM – 10:00 PM`
  * **Friday – Sunday:** `24 Hours Non-Stop`
* **Vibe:** Modern, energetic, community-driven, seamlessly connected with the fast-growing pickleball court culture.
* **Signature Menu Highlights:**
  * **Coffee & Non-Coffee:** Milo Overload, Ovaltine Rush, Spanish Latte, Sea Salt Caramel Macchiato, 18-Hour Cold Brew Reserve.
  * **Soda Series:** Lychee Sparkler, Green Apple Fizz, Lemon Yuzu Spritz, Blue Lagoon Cooler.
  * **Matcha Series:** Viral Haw-Haw Matcha, Matcha Drift, Ceremonial Iced Matcha Latte, Strawberry Matcha Glow.

---

## 🍏 Apple HIG Design Philosophy

The application strictly implements Apple's Human Interface Guidelines, eschewing Material Design elements in favor of authentic macOS and iOS design patterns:

1. **Cupertino Foundation:** Rooted entirely in `CupertinoApp` with a customized `CupertinoThemeData` mapped to Arcoffee's brand palette (Deep Blue, Bright Orange, and Cream).
2. **Frosted Glass & Translucency:** Uses `BackdropFilter` with Gaussian blur (`sigma: 20-25`) paired with sub-pixel specular borders (`Border.all(color: Color(0x180F2537))`) to generate authentic Apple materials (similar to macOS Sonoma/Sequoia sidebars and iOS navigation bars).
3. **macOS Desktop Window Simulation:** On wide displays, the layout wraps within a native-styled macOS application window, complete with:
   * Traffic light window controls (Red `#FF5F56`, Yellow `#FFBD2E`, Green `#27C93F`).
   * Centered window titlebar with venue badges and live store status pills.
   * Subtle layered box shadows (`blurRadius: 48, offset: (0, 20)`).
4. **Adaptive iOS Layout:** Seamlessly transforms into an edge-to-edge iOS experience on mobile devices with an authentic Cupertino tab bar and tactile haptic-ready buttons.
5. **Apple Optical Hierarchy:** Typography honors the SF Pro optical sizing scale, ranging from `Large Title (34px, -0.8 tracking)` down to `Caption 2 (11px, +0.2 tracking)`.

---

## 🚀 Getting Started

### Prerequisites
* Flutter SDK (3.0.0 or higher)
* Chrome / Edge or any modern web browser
* Git

### Installation & Execution

1. **Clone the repository:**
   ```bash
   git clone <repo-url>
   cd Arcoffee
   ```

2. **Fetch dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run in Chrome with web optimization:**
   ```bash
   flutter run -d chrome
   ```

4. **Build for production web hosting:**
   ```bash
   flutter build web --release --web-renderer canvaskit
   ```
   The compiled static bundle will be available in `build/web/`.

---

## 📂 Project Architecture

The project adheres to Clean Architecture separation of concerns:

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_colors.dart       # Deep Blue, Orange, Cream, and Highland tints
│   │   ├── app_constants.dart    # Brand copy, venue info, hours, dimensions
│   │   └── app_typography.dart   # SF Pro optical type scale
│   └── utils/
│       └── responsive.dart       # Screen breakpoints (Desktop, Tablet, Mobile)
├── data/
│   ├── models/
│   │   ├── gallery_item.dart     # Masonry community item entity
│   │   ├── menu_item.dart        # Drink model with JSON serialization
│   │   └── store_info.dart       # Venue and schedule entity
│   └── repositories/
│       ├── gallery_repository.dart # Interface & mock implementation
│       ├── menu_repository.dart    # Abstract contract & mock catalog
│       └── store_repository.dart   # Operating schedule & status calculations
├── features/
│   ├── app_scaffold.dart         # Main Cupertino coordinator & routing
│   ├── gallery/presentation/     # Masonry court & drink gallery
│   ├── home/presentation/        # Hero section & crowd highlights
│   ├── location/presentation/    # Venue map, hours & amenities
│   └── menu/presentation/        # Segmented controls, search, frosted cards
├── shared/widgets/
│   ├── badge_pill.dart           # Apple capsule tag
│   ├── cupertino_nav_bar.dart    # Frosted glass header toolbar
│   ├── footer_view.dart          # Segmented operating hours footer
│   ├── frosted_glass_container.dart # Gaussian blur background container
│   ├── macos_window_frame.dart   # macOS desktop window wrapper
│   └── status_pill.dart          # Real-time open/closed status pill
├── theme/
│   └── app_theme.dart            # CupertinoThemeData configuration
└── main.dart                     # Application root and dependency injection
```

---

## 🔗 Backend Readiness (PHP Laravel Integration)

All repositories are defined as abstract contracts (`MenuRepository`, `StoreRepository`, `GalleryRepository`). All models include standard `fromJson()` and `toJson()` methods keyed to conventional REST API JSON envelopes:

```dart
// Effortlessly switch from Mock to REST in lib/main.dart:
final menuRepository = LaravelRestMenuRepository(baseUrl: 'https://api.arcoffee.ph/v1');
```

Refer to [endpoints.md](file:///c:/Users/Jenrick%20Ambalong/Pictures/Screenshots/Arcoffee/endpoints.md) for full PHP Laravel REST API contract specifications and JSON schemas, and [ARCHITECTURE.md](file:///c:/Users/Jenrick%20Ambalong/Pictures/Screenshots/Arcoffee/ARCHITECTURE.md) for full architectural documentation.

---

## 🚀 Deployment Readiness & Production Hosting

The web application is fully prepared for multi-environment production deployment.

### 1. Automated Build via PowerShell Script
Run the automated build script located in the repository root:
```powershell
.\build_and_deploy.ps1
```
This cleans the workspace, resolves dependencies, analyzes code quality, and invokes:
```powershell
flutter build web --web-renderer canvaskit --release --pwa-strategy offline-first
```
The compiled output will be generated in `build/web/`.

### 2. Hosting Platform Deployment

*   **Vercel:**
    ```bash
    npx vercel --prod build/web
    ```
*   **Firebase Hosting:**
    ```bash
    firebase init hosting # Select build/web as public directory
    firebase deploy --only hosting
    ```
*   **Netlify:**
    ```bash
    npx netlify deploy --dir=build/web --prod
    ```
*   **IIS (Windows Server) or Nginx (Linux):**
    Copy the files from `build/web/` directly to your web root (`C:\inetpub\wwwroot\arcoffee` or `/var/www/html/arcoffee`). Ensure MIME types for `.wasm`, `.json`, and `.svg` are registered.

---

## 🎨 Visual System & Guidelines

Refer to [UI_UX_GUIDELINES.md](file:///c:/Users/Jenrick%20Ambalong/Pictures/Screenshots/Arcoffee/UI_UX_GUIDELINES.md) for color codes, widget mapping, and typography specs.
Refer to [CHECKLIST.md](file:///c:/Users/Jenrick%20Ambalong/Pictures/Screenshots/Arcoffee/CHECKLIST.md) for verification of all phases 1 through 20.
