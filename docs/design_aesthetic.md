# The "Industrial Bureaucracy" Design System

This document defines the core aesthetic and design principles for the specific *Bureaucratic Industrial* style used in this project. It is intended to serve as a guide for creating future projects with the same distinct look and feel.

## 1. Core Philosophy: "High-Fidelity Hardware"

The UI simulates physical, industrial machinery and bureaucratic infrastructure rather than a generic digital interface.
-   **Tactile, Not Flat**: Every interactive element should feel like a physical switch, button, or key.
-   **Imperfection**: Use noise, grain, and subtle misalignment to simulate paper, old monitors, and stamped metal.
-   **Oppressive but Functional**: The layout is dense and grid-like, reminiscent of control panels and government forms.

## 2. Color Palette: "Incandescent & Industrial"

Avoid "digital" neons. Use colors that look like LEDs, incandescents, or printed ink.

### Primary Tones (Dark Mode Dominant)
-   **Backgrounds**:
    -   `Color(0xFF222222)` - Dark Metal/Rubber
    -   `Colors.black` - Deep shadows or "powered off" screens
    -   `Colors.grey.shade900` - Base surface color
-   **Surfaces**:
    -   `Colors.white10` / `Colors.white24` - borders and bevels
    -   Gradients from `Color(0xFF222222)` to `Color(0xFF111111)`

### Accent Colors (The "Lights")
-   **Amber (`Colors.amber`, `Colors.amberAccent`)**: The primary "Bureaucratic" color. Used for stamps, warnings, and executive actions.
-   **Cyan (`Colors.cyan`, `Colors.cyanAccent`)**: "Calibration" and "Matrix" tech. Used for high-tech, precise operations.
-   **Deep Red (`Colors.redAccent`)**: "Censorship" and "Error". Used for redaction blocks and alerts.
-   **Teal/Green (`Colors.teal`, `Colors.greenAccent`)**: "Signal" and "Success". Used for old-school terminal text.

## 3. Typography: "Stamped & Monospace"

Mix rigid monospace fonts with clean, authoritative sans-serifs.

-   **Primary (Headers/Labels)**: `GoogleFonts.roboto` or similar clean tech sans.
    -   *Usage*: Section headers, big counters.
    -   *Style*: Uppercase, wide letter spacing (`letterSpacing: 2.0`+).
-   **Secondary (Code/Forms)**: `GoogleFonts.cutiveMono` or `Courier`.
    -   *Usage*: Form IDs, serial numbers, "Matrix" displays.
    -   *Style*: Distinctly typewriter-like.

## 4. UI Components & Shapes

### Containers & Cards ("The Bento Grid")
-   **Shape**: Rounded Rectangles (`BorderRadius.circular(20)`).
-   **Borders**: Thin, semi-transparent (`Border.all(width: 1.5, color: Colors.white10)`).
-   **Texture**:
    -   **Glass/Metal Gradient**: `LinearGradient(begin: topLeft, end: bottomRight)`.
    -   **Noise**: Overlay a subtle noise texture (using `CustomPainter`) to break up flat colors.
-   **Depth**: Deep shadows (`BoxShadow`) to make cards feel like heavy slabs.

### Interactive Elements
-   **Action Cards**:
    -   **Hover**: Border brightness increases; a colored glow appears.
    -   **Press**: The entire card physically shrinks (`scale: 0.96`), mimicking a membrane key.
    -   **Feedback**: Immediate visual response.
-   **Executive Buttons**:
    -   Large, full-width bars.
    -   Use linear gradients for a metallic sheen.
    -   "Locked" state is physically distinct (greyed out, etched look) vs. "Unlocked" (glowing, colored).

### Keypad Matrix (Specialized)
-   **Beveled Casing**: Thick, multi-layer shadows (`BoxShadow` with spread) to simulate a plastic/metal case.
-   **Screw Heads**: Decorative widget elements (`_ScrewHead`) in corners.
-   **Tactile Keys**: Raised buttons with bevels that depress when tapped.

## 5. Visual Effects

-   **Glows**: Use `BoxShadow` with `blurRadius: 20` to create "light bleed" from active elements.
-   **Scanlines**: On "screen" elements, use a `LinearGradient` with alternating transparent/black bands to simulate CRT scanlines.
-   **Watermarks**: Faint, rotated text ("FORM-ID: 88282") in the background (`Opacity: 0.05`).

## 6. Motion & Animation

-   **Entrance**: Elements `fadeIn` and `slide` into place, like parts of a machine locking together.
-   **Responsiveness**: Instant (100ms) transitions for hover/press states.
-   **Mechanical Rhythm**: Use `flutter_animate` to stagger entrances (200ms, 250ms, 300ms) rather than showing everything at once.
