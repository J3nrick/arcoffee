# ARCOFFEE — PRODUCTION DEPLOYMENT AUDIT & SPECIFICATION

**Status:** Production Ready  
**Target:** Flutter Web (PWA / Mobile Safari / Desktop Chromium)  
**Brand Identity:** Editorial Coffee Culture × The Pickleground PH  

---

## 1. Executive Summary
The ARCOFFEE web application has been transformed into a production-ready, high-converting digital experience. It combines Apple Human Interface Guidelines interaction rigor with an editorial lifestyle identity, eliminating all generic template artifacts, cards, emojis, and decorative blobs in favor of bold typography, authentic photography, crisp baseline rules, and hyper-local court-side utility.

---

## 2. Phase-by-Phase Technical Implementation

### Phase 1: Flutter Web Performance Tuning
- **Asset Pre-Caching:** Implemented priority pre-caching within `lib/features/splash/splash_screen.dart` via `didChangeDependencies` and `ImagePrecacher.precacheCoreAssets(context)`. Core brand marks and hero photography are warmed into the GPU memory cache before the first transition fires.
- **Modernized Color Values:** Replaced legacy deprecated `withOpacity()` invocations with `.withValues(alpha: ...)` across the rendering tree.
- **Instant Paint Architecture:** Preserved the dual-layer loading handshake in `web/index.html` with `flutter-first-frame` event listeners and MutationObserver fallbacks to eliminate white flashes on slow networks.

### Phase 2: Automated "Night Court" Theme Engine
- **Time & Day Intelligence:** Created `lib/core/utils/theme_clock.dart`.
  - Automatically activates **Night Court Mode** every Friday, Saturday, and Sunday evening starting at 6:00 PM through 4:00 AM (and during 24-hour weekend rallies).
  - Preserves manual user override capability via the navigation toggle while defaulting contextually to the actual arena atmosphere.
- **Palette Specification:**
  - Scaffold Background: Deep Navy (`#0B1F33`)
  - Primary Typography: Cream Paper (`#FBF7EB`)
  - Accent Color: High-Visibility Court Orange (`#F36B21`)
  - Shadows: Dual-layer glowing `BoxShadow` on interactive court elements (`Color(0x4DF36B21)`).

### Phase 3: Court-Side Ordering UX & QR Code Routing
- **Instantaneous QR Deep-Linking:**
  - Evaluates `Uri.base.queryParameters` upon initialization.
  - Query patterns supported: `?source=qr`, `?order=court`, and `?court=<number>` (e.g. `?court=C3`).
  - Upon QR detection, the 3.8s brand splash condenses into a swift 700ms splash flash, routing directly to the Menu tab (`initialTabIndex: 1`) and pre-binding the court number.
- **Interactive Tray State Machine:**
  - `lib/data/services/order_tray_service.dart` maintains real-time item counts, additions, court delivery toggles, and total tallies across the session.
  - `lib/features/order/presentation/court_side_delivery_modal.dart` provides an Apple HIG sliding sheet with:
    - Delivery mode segmented control: "Deliver to Court" vs "Pickup at Bar".
    - Court selector chips (`C1` through `C8`) plus direct text entry.
    - Customization review (size, ice level, sweetness level, add-on shots).
    - Haptic-inspired dispatch animation with court runner status.

### Phase 4: Brand Micro-Copy & Bespoke Empty States
- **Custom 404 Route (`lib/features/error/presentation/out_of_bounds_view.dart`):**
  - "OUT OF BOUNDS."
  - "Let's get you back to the court." with a visual baseline graphic and direct navigation back to the craft drink selection.
- **Bespoke Empty Tray State (`lib/features/order/presentation/widgets/empty_tray_view.dart`):**
  - "Your tray is empty. Time to call the next shot."
  - High-contrast "Order to Court →" action.
- **Universal CTA Audit:**
  - Navigation bar, drink builder modals, and product cards updated from generic "Order Now" to **"Order to Court"**.
  - Footer enhanced with a stateful **"Join the Club"** community newsletter subscription featuring real-time feedback.
  - Empty menu category state updated with brand-specific line-up guidance.

### Phase 5: Social Sharing & Production Meta Tags
- **Open Graph Metadata (`web/index.html`):**
  - `og:title`: "Arcoffee | Court-Side Coffee Culture"
  - `og:description`: "Craft specialty coffee & ice-cold sodas served directly alongside the pickleball courts in Kawit, Cavite. Friday-Sunday: 24 Hours."
  - `og:image`: "https://arcoffee.ph/og-image.jpg"
  - `theme-color`: `#F6F1E7`
- **Asset Provisioning:** High-resolution courtside photograph copied and packaged at `web/og-image.jpg` for iMessage, Discord, Facebook, and Twitter rich card generation.

---

## 3. Verification & Quality Assurance
- **Static Analysis:** Zero errors across Flutter analysis.
- **Apple HIG Adherence:** Touch targets ≥ 44pt, responsive typography hierarchy, SF Pro / Plus Jakarta Sans display fonts, JetBrains Mono metadata numbers, and fluid cubic spring curves.
