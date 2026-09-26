# ARCOFFEE RESPONSIVE GUIDELINES

## Breakpoints
```text
Mobile         : < 600px
Tablet         : 600px – 1024px
Desktop        : 1024px – 1440px
Max Desktop    : 1440px+ (Constrained Content Bounds)
```

## Layout Adaptation Rules
1. **Mobile (<600px)**:
   * 1-column vertical stacking.
   * Horizontal padding: `16px`.
   * Floating compact top bar + bottom tab bar navigation.
   * All tap targets enforce `minHeight: 44.0` / `minWidth: 44.0`.

2. **Tablet (600px–1024px)**:
   * 2-column compositions.
   * Horizontal padding: `32px`.
   * Floating pill header navigation.

3. **Desktop (1024px+)**:
   * Asymmetric 2-column hero / 3-column content grid.
   * Horizontal padding: `64px`.
   * Floating centered Liquid Glass navigation pill bar.

4. **Max Desktop (1440px+)**:
   * Content width constrained to `1440px` max with centered alignment and generous negative space.
