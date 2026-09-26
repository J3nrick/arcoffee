# Technical Architecture — Arcoffee Production Flutter Web

This document provides a comprehensive technical overview of the production architecture, network layer, Laravel REST API integration, state management paradigm, and Apple HIG design system implemented for **Arcoffee**.

---

## 1. Clean Architecture & Unidirectional Data Flow

The Arcoffee codebase enforces Uncle Bob's **Clean Architecture** principles, maintaining strict boundaries and unidirectional data flow across four layers:

```
┌────────────────────────────────────────────────────────────────────────┐
│                        PRESENTATION LAYER                              │
│   CupertinoApp • MenuView • GalleryView • LocationView • HomeHero       │
│           (Apple HIG Widgets, Frosted Glass, macOS Window)             │
└───────────────────────────────────▲────────────────────────────────────┘
                                    │ Listens to ViewState changes
┌───────────────────────────────────┴────────────────────────────────────┐
│                    STATE CONTROLLERS (ChangeNotifier)                  │
│       MenuViewController             GalleryViewController             │
│   • ViewState<T> (Loading, Loaded, Error)                              │
│   • Optimistic Mutations & Instant Search Filters                      │
└───────────────────────────────────▲────────────────────────────────────┘
                                    │ Invokes repository methods
┌───────────────────────────────────┴────────────────────────────────────┐
│                   REPOSITORY LAYER (Abstract Contracts)                │
│       MenuRepository                StoreRepository                    │
│                 └── AppMenuRepository (Hybrid) ──┘                     │
│               [AppConfig.useLiveApi ? Live : Mock]                     │
└───────────────────────────────────▲────────────────────────────────────┘
                                    │ Calls Network Services
┌───────────────────────────────────┴────────────────────────────────────┐
│                      NETWORK & SERVICE LAYER                           │
│       MenuService            StoreService            GalleryService    │
│                                   │                                    │
│                 ApiClient (Dio / HTTP / JSON Interceptors)             │
└───────────────────────────────────▲────────────────────────────────────┘
                                    │ HTTP (JSON / REST)
                                    ▼
                     PHP Laravel 10/11 REST API Backend
```

---

## 2. Network Layer Architecture

Located in [`/lib/core/network`](file:///c:/Users/Jenrick%20Ambalong/Pictures/Screenshots/Arcoffee/lib/core/network), the network infrastructure provides enterprise-grade communication with the PHP Laravel REST backend:

### 2.1 `ApiClient`
* **Base URL & Versioning:** Automatically prepends `AppConfig.apiBaseUrl` and `/api/v1`.
* **Standardized Headers:** Injects Apple Web metadata:
  ```json
  {
    "Accept": "application/json",
    "Content-Type": "application/json",
    "X-Requested-With": "XMLHttpRequest",
    "X-Client-Platform": "Flutter-Web-Cupertino",
    "X-App-Version": "1.0.0"
  }
  ```
* **Timeout Protections:** Enforces a 10-second connect timeout and 15-second receive timeout.
* **Error Interception:** Translates HTTP 400/404/422/500 and network drops into structured `ApiException` objects with actionable error messages.

### 2.2 `AppConfig` Environment Switcher
Enables zero-friction toggling between local mock testing and live production Laravel servers:

```dart
// Run with live Laravel backend:
flutter run -d chrome --dart-define=USE_LIVE_API=true --dart-define=API_BASE_URL=http://localhost:8000

// Or toggle programmatically in code:
AppConfig.setLiveApi(true);

// Test Apple HIG error alert dialog and retry mechanism:
AppConfig.simulateApiFailure = true;
```

---

## 3. Data Services & Repository Integration

### 3.1 Services (`/lib/data/services/`)
1. **`MenuService`:** Fetches categories, filtered lists (`/api/v1/menu?category=...&search=...`), featured drinks (`/api/v1/menu/featured`), and specific items by ID.
2. **`StoreService`:** Fetches store operational details and live status (`/api/v1/store/status`).
3. **`GalleryService`:** Fetches community masonry posts and dispatches likes (`/api/v1/gallery/{id}/like`).

### 3.2 Hybrid Repositories (`/lib/data/repositories/`)
`AppMenuRepository`, `AppStoreRepository`, and `AppGalleryRepository` implement their respective abstract contracts. If `AppConfig.useLiveApi` is `true`, requests delegate to the service layer. If `false`, they serve the rich in-memory catalog with simulated latency (`AppConfig.mockDelayMs = 120ms`).

---

## 4. State Management: The `ViewState<T>` Pattern

Views subscribe to dedicated controllers implementing explicit lifecycle states:

```dart
enum ViewStatus { initial, loading, loaded, error }

class ViewState<T> {
  final ViewStatus status;
  final T? data;
  final String? errorMessage;
  ...
}
```

### 4.1 State Controllers
* **`MenuViewController`:**
  * Manages `ViewState<List<MenuItem>>`.
  * Manages `selectedCategory` and `searchQuery`.
  * Preserves existing data during background reloading (`ViewState.loading(previousData)`) for zero-flicker UI transitions.
* **`GalleryViewController`:**
  * Manages `ViewState<List<GalleryItem>>`.
  * Handles optimistic like toggling with background Laravel API synchronization.

### 4.2 Apple HIG Error Handling
When a network error or `ApiException` occurs:
1. The controller transitions to `ViewState.error(message)`.
2. An inline Apple error message with a retry button is rendered if no cached data exists.
3. The UI automatically invokes `AppleAlert.showError(context, ...)`:
   * Displays an authentic `CupertinoAlertDialog`.
   * Prompts the user with **Dismiss** and **Try Again** (default blue action) buttons.
   * Invoking **Try Again** triggers `controller.retry()`.

---

## 5. Advanced Apple HIG Animations & Performance

1. **Upward Translation & Shadow Hover Physics:**
   * Handled inside [`MenuCard`](file:///c:/Users/Jenrick%20Ambalong/Pictures/Screenshots/Arcoffee/lib/features/menu/presentation/widgets/menu_card.dart) via `AnimatedContainer`.
   * On mouse hover, cards translate vertically by `-6.0px` (`Matrix4.translationValues(0, -6.0, 0)`) over `200ms` with `Curves.easeOutCubic`.
   * Box shadow expands from `blurRadius: 12` to `blurRadius: 28` with an ambient glow tint (`Color(0x24FF6600)`).
2. **Web Frosted Glass Optimization:**
   * Gaussian blur in `FrostedGlassContainer` is wrapped inside a `RepaintBoundary`. This instructs the Flutter Web rasterizer to isolate the backdrop blur into a cached compositor layer, eliminating frame drops during scrolling.
3. **Fluid View Transitions:**
   * Navigation transitions in [`AppScaffold`](file:///c:/Users/Jenrick%20Ambalong/Pictures/Screenshots/Arcoffee/lib/features/app_scaffold.dart) use `AnimatedSwitcher` with combined `FadeTransition` and `SlideTransition` (`duration: 280ms`, `curve: Curves.easeOutCubic`), mimicking native macOS desktop space animations.

---

## 6. Responsive Degradation Architecture

* **Desktop Viewport (>= 960px):** Content is contained within [`MacOSWindowFrame`](file:///c:/Users/Jenrick%20Ambalong/Pictures/Screenshots/Arcoffee/lib/shared/widgets/macos_window_frame.dart) (1180px maximum width, traffic lights, window title, soft shadows).
* **Mobile Viewport (< 960px):** Automatically removes desktop framing, expanding into a native edge-to-edge iOS canvas with a bottom `CupertinoTabBar` and horizontally scrollable `CupertinoSlidingSegmentedControl`.
