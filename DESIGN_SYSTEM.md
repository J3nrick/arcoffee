# ARCOFFEE DESIGN SYSTEM ARCHITECTURE

## 1. Brand Philosophy & Core Identity
**Arcoffee** = *"Court-side coffee culture."*
* **60% Editorial Coffee Brand**: Large display typography, high-contrast text hierarchy, warm cream (`#F6F1E7`) and deep navy (`#0B1F33`) canvas.
* **20% Apple-Level Craftsmanship**: Precise 44pt tap targets, WCAG AA contrast (minimum 4.5:1), responsive layout breakpoints, restrained motion.
* **10% Court-Side Influence**: Subtle court boundary lines (`ArcoCourtLine`), scoreboard metadata (`ArcoScoreboardMetadata`).
* **10% Playful Community Identity**: Receipt details (`ArcoReceiptText`), brand sticker stamps (`ArcoSticker`).

---

## 2. Color Palette & Hierarchy
```text
Canvas (Day)        : #F6F1E7 (Warm Cream)
Canvas (Night)      : #07111D (Dark Night)
Primary Surface L2  : #FFFFFF (Day) / #0E1A26 (Night)
Primary Text        : #0B1F33 (Deep Blue) / #F6F1E7 (Warm Cream)
Secondary Text      : #53677A (Day) / #8FA2B5 (Night)
Accent Color        : #F36B21 (Arcoffee Orange - Used Selectively)
Muted Blue          : #66798B
Soft Sand           : #E8DDCC
```

---

## 3. Surface & Glassmorphism Hierarchy
* **LEVEL 1 (Canvas)**: Flat warm cream or dark night background.
* **LEVEL 2 (Content Surfaces)**: Solid elevated cards (`ArcoProductCard`). **No glass on cards or list items.**
* **LEVEL 3 (Subtle Overlays)**: Surface tints for badges and table rows.
* **LEVEL 4 (Functional Glass)**: Floating navigation bar (`ArcoNavigation`) and modal popups (`ArcoGlassSurface`). Glass is used exclusively for floating controls over scrolling content.

---

## 4. Typography Scale
* **Display XL**: 52-64pt, Weight 900, Line height 1.05 (Hero Headlines)
* **Display**: 36-40pt, Weight 800 (Section Headers)
* **Heading XL**: 28pt, Weight 800 (Card Titles)
* **Heading**: 20pt, Weight 700 (Subsections)
* **Body Large**: 17pt, Weight 400 (Intro text)
* **Body**: 15pt, Weight 400 (Standard copy)
* **Eyebrow**: 12pt, Weight 800, Letter spacing 1.2 (Section Tags)
* **Scoreboard**: 13pt Monospaced, Weight 700 (Metadata)
* **Receipt**: 12pt Monospaced, Weight 600 (Price & Time details)
