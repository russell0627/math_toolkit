# Math Tools Application & Audit Workbench Functional Specification

This document provides a comprehensive functional breakdown of all modules, mathematical engines, tools, and menu structures within the `math_tools` project. It is designed to serve as the master specification for rebuilding the entire application in a clean, modern, next-generation project architecture.

---

## 1. System Overview & Core Philosophy

The application is built around the **Industrial Bureaucracy** design aesthetic—a high-fidelity simulation of industrial control panels, government audit terminals, and technical calculation suites. 

### Architecture Highlights
- **Primary Hub**: The **Audit Workbench** ([`WorkbenchScreen`](file:///c:/C/Users/Owner/IdeaProjects/math_tools/lib/features/workbench/presentation/workbench_screen.dart)), an integrated multi-module workspace capable of displaying a main module, a side utility, and an auxiliary scratchpad concurrently.
- **Standalone Utilities**: Specialized screens accessible from the home dashboard for fiscal auditing, cryptography, periodic tables, surveillance simulations, and mathematical sieves.
- **Thematic Mode Switch**: User setting toggling between industrial bureaucratic names (e.g., *ALGEBRAIC AUDITOR (ALG-01)*) and standard names (e.g., *ALGEBRA SOLVER*).

---

## 2. Audit Workbench (Main Focus)

The Audit Workbench ([`workbench_screen.dart`](file:///c:/C/Users/Owner/IdeaProjects/math_tools/lib/features/workbench/presentation/workbench_screen.dart)) is the central workbench interface. It splits the display into three dynamic columns:
1. **Sidebar Navigation**: Module selection panel.
2. **Main Auditorium View** (Flex ratio: 3): High-detail primary interactive workspace.
3. **Utility Column** (Flex ratio: 1): Secondary utilities and auxiliary tools running alongside the main module.

---

### 2.1 Primary Auditoriums (Main Modules)

#### 1. Algebraic Auditor (ALG-01) / Algebra Solver
- **Source Files**: [`algebra_view.dart`](file:///c:/C/Users/Owner/IdeaProjects/math_tools/lib/features/algebra/presentation/algebra_view.dart), [`algebra_auditorium.dart`](file:///c:/C/Users/Owner/IdeaProjects/math_tools/lib/features/algebra/presentation/widgets/algebra_auditorium.dart), [`algebra_ctrl.dart`](file:///c:/C/Users/Owner/IdeaProjects/math_tools/lib/features/algebra/controller/algebra_ctrl.dart)
- **Key Functions**:
  - **Multi-Equation Systems**: Add, duplicate, select, and remove multiple equation pairs within a system.
  - **Interactive Equation Solver**: Parses linear and algebraic expressions (`left side = right side`, inequalities `<=`, `>=`, `<`, `>`).
  - **Protocol Drag (Term Relocation)**: Move individual terms from left to right side (or vice versa), automatically applying inverse mathematical operations.
  - **Symmetry Protocol (Swap Sides)**: Inverts left and right sides while flipping inequality operators.
  - **Algebraic Step History**: Full step-by-step audit trail showing operations performed at each step.
  - **Auto-Solve Engine**: Automatically simplifies expressions and evaluates variable substitution.
  - **Stencils & Suggestion Chips**: One-click equation templates (e.g., $ax + b = c$, $ax + b = cx + d$, quadratic form).
  - **Visual Instrumentation**: Integrated balance scale visualizer (`BureauBalanceScale`) and equation complexity gauge (`BureauComplexityGauge`).

#### 2. Triangle Solver (TRI-01) / Geometric Alignment
- **Source Files**: [`triangle_view.dart`](file:///c:/C/Users/Owner/IdeaProjects/math_tools/lib/features/triangle_solver/presentation/triangle_view.dart), [`triangle_solver_ctrl.dart`](file:///c:/C/Users/Owner/IdeaProjects/math_tools/lib/features/triangle_solver/controller/triangle_solver_ctrl.dart)
- **Key Functions**:
  - **Vertex Angle Ingestion**: Real-time interior and exterior angle inputs for Vertex Alpha ($A$), Vertex Beta ($B$), and Vertex Gamma ($C$).
  - **Alignment Protocols**: Preset type constraint options (*Right, Equilateral, Isosceles, Scalene, Acute, Obtuse*).
  - **Interior Angle Sum Audit**: Calculates interior angle sum ($\Sigma = 180^\circ$) with status alerts for geometric invalidity.
  - **Valuation Estimation**: Detects irrational angle values and provides rational estimation bounds.
  - **Dynamic Geometric Canvas**: Custom Painter (`TrianglePainter`) rendering scaled triangle shapes dynamically according to entered angles.

#### 3. Hypotenuse Verification (PYT-02) / Pythagorean Theorem
- **Source Files**: [`pythagorean_view.dart`](file:///c:/C/Users/Owner/IdeaProjects/math_tools/lib/features/pythagorean/presentation/pythagorean_view.dart), [`pythagorean_ctrl.dart`](file:///c:/C/Users/Owner/IdeaProjects/math_tools/lib/features/pythagorean/controller/pythagorean_ctrl.dart)
- **Key Functions**:
  - **3-Side Solver**: Solves for Leg Alpha ($a$), Leg Beta ($b$), or Hypotenuse ($c$) when any 2 values are provided ($a^2 + b^2 = c^2$).
  - **Exact Radical Formatting**: Formats missing side results into exact radicals (e.g., $2\sqrt{5}$) alongside decimal values.
  - **Internal Valuation Range**: Provides integer bounds for non-perfect square hypotenuse values.
  - **Interactive Triangle Canvas**: `PythagoreanPainter` draws the right triangle, right-angle indicator, leg labels, and glowing vector paths.

#### 4. Grid Audit (GRD-04) / Coordinate Geometry
- **Source Files**: [`grid_pythagorean_view.dart`](file:///c:/C/Users/Owner/IdeaProjects/math_tools/lib/features/grid_pythagorean/presentation/grid_pythagorean_view.dart), [`grid_ctrl.dart`](file:///c:/C/Users/Owner/IdeaProjects/math_tools/lib/features/grid_pythagorean/controller/grid_ctrl.dart)
- **Key Functions**:
  - **Coordinate Input**: Ingests Point Alpha $P_1(x_1, y_1)$ and Point Beta $P_2(x_2, y_2)$.
  - **5-Step Distance Derivation**:
    1. Formula Statement ($d = \sqrt{(x_2-x_1)^2 + (y_2-y_1)^2}$)
    2. Coordinate Substitution
    3. Delta Leg Computation ($\Delta x, \Delta y$)
    4. Squared Sum Calculation ($\Delta x^2 + \Delta y^2$)
    5. Radicand Evaluation ($\sqrt{\text{Sum}}$)
  - **Linear Distance & Radicand**: Outputs exact radical format ($\sqrt{d^2}$) and decimal distance.
  - **Cartesian Grid Canvas**: `GridPainter` renders axes, grid lines, point nodes, leg projections ($\Delta x, \Delta y$), hypotenuse vector, and midpoint text labels.

#### 5. Transformation Composer / Transformation Sequence
- **Source Files**: [`transformation_sequence_view.dart`](file:///c:/C/Users/Owner/IdeaProjects/math_tools/lib/features/transformation_sequence/presentation/transformation_sequence_view.dart), [`transformation_sequence_ctrl.dart`](file:///c:/C/Users/Owner/IdeaProjects/math_tools/lib/features/transformation_sequence/controller/transformation_sequence_ctrl.dart)
- **Key Functions**:
  - **Vertex Manager**: Add, edit coordinate values ($x, y$), or remove 2D shape vertices.
  - **Quick Shape Presets**: Generate triangles, squares, pentagons, or custom $W \times H$ rectangles (centered or origin-aligned).
  - **Composite Transformation Engine**:
    - **Translation**: $T(h, k)$
    - **Dilation**: $S(k)$ with arbitrary center of dilation $(x_c, y_c)$
    - **Rotation**: $90^\circ\text{ CCW}$, $90^\circ\text{ CW}$, $180^\circ$, $270^\circ\text{ CCW}$, $270^\circ\text{ CW}$ around origin or custom center $(x_c, y_c)$
    - **Reflection**: Reflection across $x$-axis, $y$-axis, $y=x$, or $y=-x$
  - **Composite Notation & Result Log**: Displays matrix algebraic expressions, step-by-step coordinate shifts, area calculations, and step preview selection.
  - **Multi-Shape Canvas**: `ShapePainter` renders the base shape (dashed), intermediate step ghosts, grid axes, and final transformed polygon.

#### 6. Slope Audit (SLP-01) / Slope Calculator
- **Source Files**: [`slope_view.dart`](file:///c:/C/Users/Owner/IdeaProjects/math_tools/lib/features/slope_calculator/presentation/slope_view.dart), [`slope_ctrl.dart`](file:///c:/C/Users/Owner/IdeaProjects/math_tools/lib/features/slope_calculator/controller/slope_ctrl.dart)
- **Key Functions**:
  - **Multi-Point Ingestion**: Input unlimited $(x, y)$ coordinate points to compute slope ($m$), fraction $m$, $y$-intercept ($b$), Rise ($\Delta y$), Run ($\Delta x$), and distance ($d$).
  - **Direct Equation Ingestion**: Parses equation strings (e.g., $y = 2x + 5$, $p = 27.5h$).
  - **Line Intersection Protocol**: Intersects primary line with a secondary line ($m_2, b_2$) to compute intersection point $(x_{\text{int}}, y_{\text{int}})$.
  - **Point Verification Protocol**: Validates whether an arbitrary test point $(x, y)$ lies on the line.
  - **Proportionality Analysis**: Checks if line passes through $(0,0)$ and calculates proportionality constant $k = y/x$.
  - **Segment Audit Log**: Detailed tabular breakdown of segment lengths, slopes, and ratios between consecutive points.
  - **Interactive Cartesian Canvas**: `SlopeGridPainter` with crosshair hover reading, standard vs. minimal display mode, and point markers.

#### 7. Velocity Flux Auditor (ACC-01) / Acceleration Calculator
- **Source Files**: [`acceleration_view.dart`](file:///c:/C/Users/Owner/IdeaProjects/math_tools/lib/features/acceleration_calculator/presentation/acceleration_view.dart), [`acceleration_ctrl.dart`](file:///c:/C/Users/Owner/IdeaProjects/math_tools/lib/features/acceleration_calculator/controller/acceleration_ctrl.dart)
- **Key Functions**:
  - **6 Target Solver Modes**: Solve for Acceleration ($a$), Initial Velocity ($v_i$), Final Velocity ($v_f$), Time Interval ($t$), Speed Change ($\Delta v$), or Velocity Change.
  - **Displacement Integration**: Calculates total displacement $d = v_i t + \frac{1}{2}a t^2$.
  - **Calculation Audit Trail**: Step-by-step physics formula derivation log.
  - **Velocity vs. Time Canvas**: `VelocityTimePainter` plots the $v\text{ vs }t$ line, slope annotation ($a$), key data points, and shaded displacement area under the curve ($d$).

#### 8. Thermodynamic Auditor (EFF-01) / Efficiency Calculator
- **Source Files**: [`efficiency_view.dart`](file:///c:/C/Users/Owner/IdeaProjects/math_tools/lib/features/efficiency_calculator/presentation/efficiency_view.dart), [`efficiency_ctrl.dart`](file:///c:/C/Users/Owner/IdeaProjects/math_tools/lib/features/efficiency_calculator/controller/efficiency_ctrl.dart)
- **Key Functions**:
  - **Energy Work Ingestion**: Ingests Work Input ($W_{\text{in}}$) and Work Output ($W_{\text{out}}$) in Joules ($J$).
  - **Efficiency Metrics**: Computes Energy Efficiency percentage ($\eta = \frac{W_{\text{out}}}{W_{\text{in}}} \times 100\%$) and Dissipated Energy Loss ($L = W_{\text{in}} - W_{\text{out}}$).
  - **Audit Trail Log**: Step-by-step thermodynamic formula breakdown.
  - **Sankey Energy Flow Canvas**: `EnergyFlowPainter` renders a fluid energy flow diagram splitting work input into horizontal useful work output and a downward bending energy loss stream.

---

### 2.2 Side Utilities (Secondary Column Tools)

These utilities can be opened in the secondary column alongside any main auditorium module:

1. **Radical Reduction (RAD-03) / Radical Simplifier**:
   - Source: [`radical_view.dart`](file:///c:/C/Users/Owner/IdeaProjects/math_tools/lib/features/radical_simplifier/presentation/radical_view.dart)
   - Simplifies $\sqrt{n}$ into exact radical form $a\sqrt{b}$ (e.g., $\sqrt{50} \rightarrow 5\sqrt{2}$).
   - Computes decimal approximation and integer bounds $[\lfloor\sqrt{n}\rfloor, \lceil\sqrt{n}\rceil]$.
   - Automatically syncs with Pythagorean hypotenuse outputs when active.
2. **Fraction Simplifier**:
   - Source: [`fraction_simplifier_view.dart`](file:///c:/C/Users/Owner/IdeaProjects/math_tools/lib/features/fraction_simplifier/presentation/fraction_simplifier_view.dart)
   - Simplifies numerator/denominator ($a/b$) into lowest terms $p/q$.
   - Converts to mixed numbers, decimal values, and percentages.
3. **Mini Calculator**:
   - Source: [`mini_calculator_view.dart`](file:///c:/C/Users/Owner/IdeaProjects/math_tools/lib/features/workbench/presentation/widgets/mini_calculator_view.dart)
   - Embedded basic arithmetic keypad ($+, -, \times, \div$) for fast scratchpad calculations.
4. **Reflection Mapper**:
   - Source: [`reflection_view.dart`](file:///c:/C/Users/Owner/IdeaProjects/math_tools/lib/features/reflection_mapper/presentation/reflection_view.dart)
   - Performs standalone point reflections across $x$-axis, $y$-axis, $y=x$, and $y=-x$.
5. **Rotation Mapper**:
   - Source: [`rotation_view.dart`](file:///c:/C/Users/Owner/IdeaProjects/math_tools/lib/features/rotation_mapper/presentation/rotation_view.dart)
   - Performs standalone point rotations ($90^\circ, 180^\circ, 270^\circ$).

---

### 2.3 Auxiliary Systems

1. **Notepad / Scratchpad**:
   - Source: [`notepad_view.dart`](file:///c:/C/Users/Owner/IdeaProjects/math_tools/lib/features/workbench/presentation/widgets/notepad_view.dart)
   - Embedded multi-line stateful notepad for keeping temporary audit notes, equation numbers, or intermediate values.

---

## 3. Legacy Side Menu Inventory

> [!IMPORTANT]
> **Design Directive**: The legacy side menu layout was identified as poorly designed and will be replaced with a modern, fresh navigation structure in the new app. However, all menu items and navigation targets listed below MUST be preserved in the new navigation system.

### Side Menu Options Inventory

| Category | Menu Item (Thematic / Standard) | Action / Navigation Target |
| :--- | :--- | :--- |
| **Header** | Return Arrow (`<`) / Terminal Header | Navigates back to Main Home Dashboard |
| **Header** | "INTEGRATED AUDIT" / "TERMINAL WRK-01" | Displays active workspace terminal identifier |
| **Primary Auditoriums** | `ALGEBRAIC AUDITOR (ALG-01)` / `ALGEBRA SOLVER` | Sets Main Module to Algebra Solver |
| **Primary Auditoriums** | `TRIANGLE SOLVER (TRI-01)` / `TRIANGLE SOLVER` | Sets Main Module to Triangle Solver |
| **Primary Auditoriums** | `HYPOTENUSE VERIFICATION (PYT-02)` / `PYTHAGOREAN THEOREM` | Sets Main Module to Pythagorean Theorem |
| **Primary Auditoriums** | `GRID AUDIT (GRD-04)` / `COORDINATE GEOMETRY` | Sets Main Module to Grid Pythagorean |
| **Primary Auditoriums** | `TRANSFORMATION COMPOSER` / `TRANSFORMATION SEQUENCE` | Sets Main Module to Transformation Sequence |
| **Primary Auditoriums** | `SLOPE AUDIT (SLP-01)` / `SLOPE CALCULATOR` | Sets Main Module to Slope Calculator |
| **Primary Auditoriums** | `VELOCITY FLUX AUDITOR (ACC-01)` / `ACCELERATION CALCULATOR` | Sets Main Module to Acceleration Calculator |
| **Primary Auditoriums** | `THERMODYNAMIC AUDITOR (EFF-01)` / `EFFICIENCY CALCULATOR` | Sets Main Module to Efficiency Calculator |
| **Side Utilities** | `RADICAL REDUCTION (RAD-03)` / `RADICAL SIMPLIFIER` | Sets Secondary Column Utility to Radical Simplifier |
| **Side Utilities** | `FRACTION SIMPLIFIER` | Sets Secondary Column Utility to Fraction Simplifier |
| **Side Utilities** | `CALCULATOR` | Sets Secondary Column Utility to Mini Calculator |
| **Side Utilities** | `REFLECTION MAPPER` / `REFLECTION TOOL` | Sets Secondary Column Utility to Reflection Mapper |
| **Side Utilities** | `ROTATION MAPPER` / `ROTATION TOOL` | Sets Secondary Column Utility to Rotation Mapper |
| **Auxiliary Systems** | `NOTEPAD` | Sets Auxiliary Column to Notepad Scratchpad |
| **Auxiliary Systems** | `CALCULATOR` | Sets Auxiliary Column to Mini Calculator |
| **Footer** | OS Info & Auth Tag (`BUREAU SYSTEMS OS v4.2`) | Displays system build info and authorization credit |

---

## 4. Bureau Utilities & Standalone Tools (Outside Workbench)

In addition to the Audit Workbench, the application contains several standalone tools accessible from the main dashboard ([`home_page.dart`](file:///c:/C/Users/Owner/IdeaProjects/math_tools/lib/features/app/presentation/home_page.dart)):

### 4.1 Fiscal Statistics / Budget Audit (AUD-01)
- **Source File**: [`budgetary_audit_screen.dart`](file:///c:/C/Users/Owner/IdeaProjects/math_tools/lib/features/budget_audit/presentation/budgetary_audit_screen.dart)
- **Functions**:
  - Sequential data point entry list for numerical sets.
  - Computes statistical summary: Mean ($\bar{x}$), Median, Mode, Range, Variance ($\sigma^2$), Standard Deviation ($\sigma$), and Total Sum.

### 4.2 Security Encryption Unit / Cipher
- **Source File**: [`cipher_screen.dart`](file:///c:/C/Users/Owner/IdeaProjects/math_tools/lib/features/cipher/presentation/cipher_screen.dart)
- **Functions**:
  - **Caesar Cipher**: Numeric shift key cipher for encoding/decoding text payloads.
  - **Vigenère Cipher**: Alphabetic string key polyalphabetic substitution cipher.
  - Real-time output payload generation and copy-to-clipboard functionality.

### 4.3 Elemental Registry Unit / Substance (Elements)
- **Source File**: [`elemental_registry_screen.dart`](file:///c:/C/Users/Owner/IdeaProjects/math_tools/lib/features/elements/presentation/elemental_registry_screen.dart)
- **Functions**:
  - Periodic table lookup utility storing atomic numbers, symbols, names, atomic weights, categories, and electron configurations.

### 4.4 Mathematical Pi-Stream (Observation)
- **Source File**: [`pi_stream_screen.dart`](file:///c:/C/Users/Owner/IdeaProjects/math_tools/lib/features/app/presentation/pi_stream_screen.dart)
- **Functions**:
  - Continuous streaming digit viewer for $\pi$ (Pi) with position search and digit frequency counter.

### 4.5 Prime-Number Sieve (Indexing)
- **Source File**: [`prime_sieve_screen.dart`](file:///c:/C/Users/Owner/IdeaProjects/math_tools/lib/features/app/presentation/prime_sieve_screen.dart)
- **Functions**:
  - Sieve of Eratosthenes prime generation engine up to upper limit $N$.
  - Interactive prime grid matrix rendering prime vs. composite numbers.

### 4.6 Signal Auditor Unit (Surveillance)
- **Source File**: [`signal_auditor_screen.dart`](file:///c:/C/Users/Owner/IdeaProjects/math_tools/lib/features/app/presentation/signal_auditor_screen.dart)
- **Functions**:
  - Simulated radar frequency spectrum monitor, signal amplitude auditor, and audio/signal visualizer.

### 4.7 Sub-Surface Scanner / Minesweeper
- **Source File**: [`minesweeper_screen.dart`](file:///c:/C/Users/Owner/IdeaProjects/math_tools/lib/features/minesweeper/presentation/minesweeper_screen.dart)
- **Functions**:
  - Tactical grid sweeper game with customizable mine density, flag toggling, and timer tracking.

### 4.8 Unit Calibration & Synchronizer Unit (Sync-Unit)
- **Source File**: [`synchronizer_screen.dart`](file:///c:/C/Users/Owner/IdeaProjects/math_tools/lib/features/synchronizer/presentation/synchronizer_screen.dart)
- **Functions**:
  - Metric unit conversion suite supporting Length, Mass, and Time conversions.
  - Interactive Animated Oscilloscope (`OscilloscopePainter`) visualizing signal amplitude relative to input values.

### 4.9 Standalone Calculator Unit
- **Source File**: [`calculator_screen.dart`](file:///c:/C/Users/Owner/IdeaProjects/math_tools/lib/features/calculator/presentation/calculator_screen.dart)
- **Functions**:
  - Full-screen standalone arithmetic calculator (distinct from the Workbench Mini Calculator).
  - Expression evaluation engine, memory storage, calculation history stack, and full tactile button matrix.

### 4.10 Algebra Guide Protocol
- **Source File**: [`algebra_guide_screen.dart`](file:///c:/C/Users/Owner/IdeaProjects/math_tools/lib/features/algebra/presentation/algebra_guide_screen.dart)
- **Functions**:
  - Comprehensive reference guide explaining algebraic stencils, relation operators, and step-by-step resolution syntax.

### 4.11 Settings & Bureau System Atmosphere
- **Source File**: [`bureau_settings_dialog.dart`](file:///c:/C/Users/Owner/IdeaProjects/math_tools/lib/features/settings/presentation/bureau_settings_dialog.dart)
- **Functions**:
  - Toggle **Thematic Naming** (e.g. *ALGEBRAIC AUDITOR* vs *ALGEBRA SOLVER*).
  - Toggle **Bureau Atmosphere** CRT/scanline overlay and noise texture rendering.

---

## 5. Hardware UI Design System & Cross-Module Auto-Syncing

### 5.1 Industrial Hardware Component Suite
- **Tactile Keypads (`TactileKeypadButton`)**: Custom push-buttons with multi-layer drop shadows, bevelled edges, press scale animations, and tactile feedback.
- **Rotary Selectors (`BureauRotarySelector`)**: Hardware-inspired dial selectors for switching modes.
- **Status Stamps (`BureauStamp`)**: Rotated verification stamps (e.g., *REDUCTION VERIFIED*, *ALIGNMENT SECURE*).
- **Atmospheric Overlays (`BureauAtmosphere`)**: Custom background painter applying CRT scanlines, vignette shading, and paper/metal noise texture.

### 5.3 Core Mathematical Utilities & Algorithms (`MathUtils`)
- **Radical Simplification Algorithm (`simplifyRadical`)**: Prime factor extraction algorithm reducing $\sqrt{n}$ into integer coefficient and radicand pair $(a, b)$ where $\sqrt{n} = a\sqrt{b}$.
- **Dynamic Radical Detection (`tryFormatAsRadical`)**: Tests whether $v^2 \approx \text{integer}$, converting floating-point calculations into exact radical representations (e.g. $2.236067... \rightarrow \sqrt{5}$).
- **Continued Fraction Expansion (`toFraction`)**: Implements an iterative continued fraction algorithm converting double precision floats into exact simplified fractions $p/q$ (e.g. $0.75 \rightarrow 3/4$).
- **Expression Evaluation (`evaluateExpression`)**: Normalizes radical symbols (`√` $\rightarrow$ `sqrt`), parses mathematical expressions via the `math_expressions` engine, and evaluates real values.

### 5.4 Asset Bundling & Persistent State (`AppService`)
- **Asset Bundles**:
  - `assets/algebra_guide.md`: Embedded markdown asset rendered by `AlgebraGuideScreen` using `flutter_markdown`.
  - `assets/images/`: Visual assets for branding and background textures.
- **Persistence (`SharedPreferences`)**: Persists user settings across sessions (Thematic naming preference, Bureau Atmosphere CRT/noise overlay states).
- **Package & Runtime Metadata**: App version retrieval via `PackageInfo` (`SN-BUREAU-V{version}`).

### 5.5 Critical Third-Party Dependencies Matrix
- **State Management & Generation**: `flutter_riverpod`, `riverpod_annotation`, `riverpod_generator`.
- **Serialization & Immutability**: `dart_mappable`, `dart_mappable_builder`.
- **Expression Parsing**: `math_expressions`.
- **UI & Micro-Animations**: `flutter_smart_dialog` (custom toasts), `flutter_animate`, `flex_color_scheme`.
- **Typography & Routing**: `google_fonts` (*Share Tech Mono*, *EB Garamond*, *Cutive Mono*), `go_router`.

---

## 6. Rebuild Summary Checklist for New Project

When building the new application project:
1. **Core Mathematics & Controllers**: Port all math logic controllers (`algebra_ctrl.dart`, `triangle_solver_ctrl.dart`, `pythagorean_ctrl.dart`, `grid_ctrl.dart`, `transformation_sequence_ctrl.dart`, `slope_ctrl.dart`, `acceleration_ctrl.dart`, `efficiency_ctrl.dart`, `radical_ctrl.dart`, `synchronizer_ctrl.dart`, `calculator_ctrl.dart`).
2. **Utility Algorithms (`MathUtils`)**: Port radical simplification, continued fraction expansion, and expression evaluation utilities.
3. **Audit Workbench Layout**: Implement a modern responsive multi-column layout allowing 1 Main Auditorium + 1 Side Utility + 1 Auxiliary Tool.
4. **Fresh Navigation UI**: Design a modern, clean navigation interface (drawer, rail, or top bar) replacing the legacy side menu while preserving all menu items detailed in Section 3.
5. **Visual Canvas Painters**: Re-implement custom canvas painters (`TrianglePainter`, `PythagoreanPainter`, `GridPainter`, `ShapePainter`, `SlopeGridPainter`, `VelocityTimePainter`, `EnergyFlowPainter`, `OscilloscopePainter`).
6. **Hardware Design System & Atmosphere**: Port custom hardware widgets (`TactileKeypadButton`, `BureauRotarySelector`, `BureauStamp`, `BureauAtmosphere`).
7. **Cross-Module Syncing & State Wiring**: Re-establish Riverpod state listeners for automatic data flow between modules (e.g., Pythagorean $\rightarrow$ Radical Reduction).
8. **Persistence & Assets**: Include `assets/algebra_guide.md`, configure `SharedPreferences` state persistence, and configure `google_fonts` typography.
9. **Standalone Tools**: Port standalone modules (Fiscal Audit, Cipher, Elemental Registry, Pi Stream, Prime Sieve, Signal Auditor, Minesweeper, Synchronizer, Full Calculator, Algebra Guide).


