# Arcoffee UI/UX Design Guidelines — "Clean Uniqueness"

This document establishes the design principles, color token systems, micro-interaction physics, and custom interface mechanics for the **Arcoffee** digital web experience.

---

## 1. The "Clean Uniqueness" Mandate

Most modern coffee web templates suffer from two extremes: either generic minimalist monochrome (boring) or cluttered retro street style (hard to navigate). 

Arcoffee resolves this tension through **"Clean Uniqueness"**:
*   **The Foundation:** Apple Human Interface Guidelines (HIG) — frosted glass (`BackdropFilter`), SF Pro optical typography scale, bouncy scroll physics, and sleek macOS window presentation.
*   **The Arcoffee Injection:** High-energy sports court culture (Pickleball baseline aesthetic), vibrant Deep Blue and Electric Orange contrast, physical tactile elements (polaroids and draggable stickers), and time-fluid responsiveness (Midnight Court mode).

```
   ┌────────────────────────────────────────────────────────────┐
   │                    CLEAN UNIQUENESS                        │
   ├─────────────────────────────┬──────────────────────────────┤
   │       Apple HIG Core        │      Arcoffee Street Energy  │
   ├─────────────────────────────┼──────────────────────────────┤
   │ • Frosted Glass Surfaces    │ • Electric Orange Neon Glow  │
   │ • SF Pro Optical Hierarchy  │ • 24H "Midnight Court" Engine│
   │ • Bouncing Elastic Physics  │ • Polaroid Sticker Board     │
   │ • Sliding Segmented Controls│ • Liquid Floating Bobbing    │
   │ • Cupertino Custom Modals   │ • Interactive Custom Cursor  │
   └─────────────────────────────┴──────────────────────────────┘
```

---

## 2. Dynamic "Time of Day" Theme Engine

Arcoffee operates on a unique schedule: **Mon–Thu: 2:00 PM – 10:00 PM**, but **Fri–Sun: 24 Hours Non-Stop**. The website reacts dynamically to this reality.

### 2.1 Day Court vs. Midnight Court

*   **Day Court Mode:** Warm Cream Canvas (`#FAF7F2`), crisp Deep Blue (`#0F2537`) headlines, and bright energetic orange accents.
*   **Midnight Court Mode:** Activates automatically during weekend overnight sessions (7:00 PM – 6:00 AM) or via the manual nav switch:
    *   Scaffold transitions to deep nocturnal midnight blue (`#07111C`).
    *   Frosted glass panels transform into dark smoked obsidian glass (`Color(0xCC0B1824)`).
    *   Orange buttons and tags radiate an intense fluorescent neon glow (`BoxShadow(color: Color(0x66FF6600), blurRadius: 24, spreadRadius: 2)`).

| Design Token | Day Court Mode | Midnight Court Mode | Purpose |
| :--- | :--- | :--- | :--- |
| `scaffoldBackground` | `#FAF7F2` | `#07111C` | Canvas foundation |
| `cardBackground` | `#FFFFFF` | `#0E1A26` | Elevated cards |
| `glassBackground` | `rgba(250, 247, 242, 0.80)` | `rgba(11, 24, 36, 0.80)` | Top bars & modals |
| `primaryText` | `#0F2537` | `#FAF7F2` | High contrast typography |
| `secondaryText` | `#5C6F80` | `#8FA2B5` | Metadata & descriptions |
| `accentOrange` | `#FF6600` | `#FF6600` | Primary action brand hue |
| `borderLight` | `rgba(15, 37, 55, 0.09)` | `rgba(143, 162, 181, 0.18)`| Hairline specular borders |

---

## 3. Web Custom Halo Ring Cursor

On desktop web browsers, the standard OS arrow cursor is replaced by an authentic Apple-styled halo follower:
1.  **Resting State:** A sleek 20px circular ring (`1.5px` stroke) with a 4px center tracking dot.
2.  **Snapping Interactive State:** When hovering over clickable cards, buttons, or stickers, the ring smoothly expands to `42px` over `140ms` with `Curves.easeOutCubic`, fills with a translucent orange tint (`rgba(255, 102, 0, 0.15)`), and casts a diffused specular glow.
3.  **Click-Through Safety:** The cursor follower is rendered inside an `IgnorePointer` overlay, ensuring zero interference with native browser mouse clicks.

---

## 4. Liquid Bobbing Float & Dynamic Glow

When hovering over drinks in the Menu View:
1.  **Upward Translation:** The entire card lifts vertically by `-7.0px` (`Matrix4.translationValues(0, -7.0, 0)`).
2.  **Liquid Bobbing Animation:** The drink graphic inside the card executes a continuous sinusoidal float cycle (`math.sin(t * pi) * -5px`) over `1400ms`, simulating a cold cup bobbing gently on liquid.
3.  **Color-Matched Glow Shadow:** The card's drop shadow dynamically adopts the drink's signature pigment:
    *   *Matcha Series:* Soft Uji Green glow (`rgba(74, 124, 89, 0.40)`)
    *   *Soda Series:* Electric Blue / Citrus glow (`rgba(46, 123, 180, 0.40)`)
    *   *Coffee Series:* Warm Cacao glow (`rgba(107, 66, 38, 0.35)`)

---

## 5. Digital Community Board & Polaroid Stickers

Rather than a generic corporate image grid, the Community View simulates a real locker-room courtside corkboard:
*   **Polaroid Photo Frames:** Community shots are styled as physical polaroid photographs with angled borders, author stamps, and authentic physical tilt rotations (`-1.5°` to `+1.8°`).
*   **Draggable Sticker Dock:** Users can grab physical-style stickers (*"It's always been ours."*, *"Dink Responsibly"*, *"24H Midnight Run"*) using Flutter's `Draggable` and drop them onto any photo using `DragTarget`.
*   **Sticker Repositioning:** Placed stickers retain custom random rotation offsets and can be moved interactively across the board.

---

## 6. The "Build Your Drink" Interactive Bottom Sheet

Clicking any drink triggers `BuildDrinkModal.show()`:
*   **No Static Modals:** A multi-step Apple Cupertino customization panel.
*   **Real-Time Segmented Controls:**
    1.  *Cup Size:* Regular 16 oz (Base) vs Grande 20 oz (+₱25) vs Cold Bottle (+₱35).
    2.  *Ice Level:* Less (70%) vs Regular (100%) vs Extra Chill.
    3.  *Sweetness:* Unsweetened (0%) vs Half (50%) vs Classic (100%).
    4.  *Court Power Boosters:* Extra Espresso Shot (+₱30), Oat Milk (+₱35), Haw-Haw Cold Foam (+₱40).
*   **Dynamic Price Calculation:** Recalculates in real time as options are selected.
*   **"Add to Tray" Tactile Confirmation:**
    *   Tapping the button shrinks it slightly (`0.96x`), morphs the color from Brand Orange to Apple Highland Green (`#34C759`), replaces the cart icon with `CupertinoIcons.checkmark_alt`, and presents *"Added to Courtside Tray!"* before auto-dismissing after `750ms`.

---

## 7. Progressive Web App (PWA) Configuration

*   **Manifest:** Configured with `display: standalone` and theme colors mapped to Day Court (`#FF6600`) and Midnight Court (`#07111C`).
*   **PWA Shortcuts:** Supports direct homescreen jump links for **Menu**, **Community Board**, and **Hours & Location**.
*   **Rendering Optimization:** Backdrop filters are isolated inside `RepaintBoundary` nodes to ensure smooth 60fps scrolling performance on both CanvasKit and HTML web renderers.
