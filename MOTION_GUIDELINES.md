# ARCOFFEE MOTION & MICRO-INTERACTION SYSTEM

## Animation Durations
* **Fast**: `150ms` (Button hover, tab selection, micro-interactions).
* **Standard**: `250ms` (Card transformations, theme switching).
* **Emphasis**: `400ms` (Modal popups, category filters).
* **Hero**: `600ms` (Initial hero staggered page entrance).

## Easing Curves
* Standard Easing: `Curves.easeOutCubic`
* Hero Entrance: `Curves.easeInOutCubic`

## Reduced Motion Support (`prefers-reduced-motion`)
When `MediaQuery.of(context).disableAnimations` is true:
* Slide transitions are disabled.lll
* Scale and matrix transforms are suppressed....
* Fade and color state transitions remain instantaneous for clear feedback.
