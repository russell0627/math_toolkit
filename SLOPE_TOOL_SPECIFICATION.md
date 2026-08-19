# Slope Audit (SLP-01) / Slope Calculator - In-Depth Specification

This document provides a comprehensive, deep-dive specification for the **Slope Audit (SLP-01) / Slope Calculator** module within `math_tools`. It covers the linear regression engine, expression ingestion parser, line intersection protocols, point verification algorithms, segment audit logs, proportionality analysis, and the dynamic Cartesian canvas visualizer.

---

## 1. Module Overview & Primary Source Files

The Slope Audit module provides advanced linear analysis capabilities. It operates on arbitrary multi-point datasets to compute linear regressions, segment-by-segment deltas, line intersections, point validity checks, and proportionality constants.

### Primary Source Files
- **Logic Controller**: [`slope_ctrl.dart`](file:///c:/C/Users/Owner/IdeaProjects/math_tools/lib/features/slope_calculator/controller/slope_ctrl.dart)
- **Data Model**: [`slope_model.dart`](file:///c:/C/Users/Owner/IdeaProjects/math_tools/lib/features/slope_calculator/model/slope_model.dart)
- **Auditorium View & Canvas**: [`slope_view.dart`](file:///c:/C/Users/Owner/IdeaProjects/math_tools/lib/features/slope_calculator/presentation/slope_view.dart)

---

## 2. Core Data Models & State Architecture

### 2.1 `SlopePoint` Model
Represents a 2D Cartesian coordinate point.
- `x` (`double`): Horizontal coordinate value.
- `y` (`double`): Vertical coordinate value.

### 2.2 `SlopeState` Model
- `points` (`List<SlopePoint>`): Ingested data points.
- `slope` (`double?`): Regression slope ($m$).
- `yIntercept` (`double?`): Vertical intercept ($b$).
- `equation` (`String?`): Formatted slope-intercept equation string (e.g., `y = (2/3)x + 5.00`).
- `rise` (`double?`): Total vertical rise ($\Delta y$).
- `run` (`double?`): Total horizontal run ($\Delta x$).
- `distance` (`double?`): Total linear distance between bounding extremes.
- `segmentDistances` (`List<double>`): Distances between consecutive points in entry order.
- `segmentRises` (`List<double>`): $\Delta y_i$ values per segment.
- `segmentRuns` (`List<double>`): $\Delta x_i$ values per segment.
- `segmentSlopes` (`List<double>`): $m_i$ values per segment.
- `slopeFraction` (`String?`): Exact fractional representation of regression slope (e.g., `2/3`).
- `segmentSlopesFractions` (`List<String>`): Exact fraction strings for each segment slope.
- `isProportional` (`bool`): True if line passes through $(0,0)$ with a constant ratio.
- `proportionalityConstant` (`double?`): Proportionality constant $k = y/x$.
- `proportionalityFraction` (`String?`): Exact fraction representation of $k$.
- `pointRatios` (`List<double?>`): $y_i / x_i$ ratio for each point.
- `xLabel` / `yLabel` (`String`): Variable names (defaults to `"X"` and `"Y"`).
- `inputEquation` (`String?`): Raw user-submitted equation string.
- `isMinimalMode` (`bool`): Toggle state for minimal vs. standard canvas visualizer.
- `isPerfectlyLinear` (`bool`): True if all segment slopes match the regression slope.
- **Line 2 Intersection Fields**:
  - `secondSlope` / `secondYIntercept` / `secondEquation` (`double?` / `double?` / `String?`): Secondary line parameters.
  - `intersectionPoint` (`SlopePoint?`): Point where regression line intersects Line 2.
  - `intersectionStatus` (`String?`): Status string (`"INTERSECTING"`, `"PARALLEL"`, `"IDENTICAL"`).
  - `segmentIntersections` (`List<SlopePoint>`): Points where Line 2 intersects individual line segments.
- `checkPoint` (`SlopePoint?`): Coordinate point submitted for verification against the line.

---

## 3. Mathematical Solvers & Algorithms

### 3.1 Linear Regression Engine (`_calculateSlope`)
Calculates the best-fit line across $n \ge 2$ data points using least-squares linear regression:

1. **Summation**:
   $$S_x = \sum x_i, \quad S_y = \sum y_i, \quad S_{xy} = \sum x_i y_i, \quad S_{x^2} = \sum x_i^2$$
2. **Denominator & Slope**:
   $$D = n S_{x^2} - (S_x)^2$$
   $$m = \frac{n S_{xy} - S_x S_y}{D}$$
3. **Vertical Line Handling** ($D = 0$):
   - If denominator $D \approx 0$, line is vertical:
   - $m = \infty$, $run = 0.0$, $yIntercept = \text{null}$, equation = `"x = x_0"`.
4. **Intercept & Total Metrics**:
   $$b = \frac{S_y - m S_x}{n}$$
   $$\text{Total Run} = x_{\max} - x_{\min}, \quad \text{Total Rise} = m \cdot \text{Total Run}$$
   $$\text{Total Distance} = \sqrt{\text{Total Run}^2 + \text{Total Rise}^2}$$
5. **Exact Fraction Conversion**:
   Converts float $m$ to exact fraction string via `MathUtils.toFraction(m)`.

### 3.2 Segment Audit Log
Calculates step metrics between consecutive entry points $(P_i, P_{i+1})$:
- $\Delta x_i = x_{i+1} - x_i$
- $\Delta y_i = y_{i+1} - y_i$
- $d_i = \sqrt{\Delta x_i^2 + \Delta y_i^2}$
- $m_i = \frac{\Delta y_i}{\Delta x_i}$
- **Linearity Check**: Line is marked `isPerfectlyLinear` if $|m_i - m| < 10^{-10}$ for all segments.

### 3.3 Direct Equation Ingestion (`setEquation` / `setSecondLineFromEquation`)
Parses custom equations (e.g., $p = 27.5h$ or $y = 2x + 10$):
1. Splits equation by `=` into $y$-label and RHS expression.
2. Regex identifies $x$-variable label while filtering mathematical functions (`sin`, `cos`, `tan`, `sqrt`, `ln`, `abs`).
3. Parses expression via `math_expressions` `Parser()`.
4. Evaluates function at $x \in \{-10, -5, 0, 5, 10\}$ to generate sample points.
5. Runs `_calculateSlope()` to populate regression state.

### 3.4 Proportionality Analysis (`_auditProportionality`)
Determines whether data follows a direct proportional model ($y = kx$):
1. Verifies that the line passes through origin: if $x_i = 0$, requires $y_i = 0$.
2. Checks ratio constancy: $k_i = y_i / x_i$. Requires $|k_i - k| < 10^{-10}$ across all points.
3. Formats constant $k$ as fraction string `proportionalityFraction`.

### 3.5 Line Intersection Protocol (`_calculateIntersection`)
Computes intersection of primary regression line ($y = m_1 x + b_1$) with Line 2 ($y = m_2 x + b_2$):
1. **Parallel / Identical Check**:
   - If $|m_1 - m_2| < 10^{-10}$:
     - If $|b_1 - b_2| < 10^{-10} \implies$ `"IDENTICAL"`
     - Else $\implies$ `"PARALLEL"`
2. **Intersection Coordinate**:
   $$x_{\text{int}} = \frac{b_2 - b_1}{m_1 - m_2}, \quad y_{\text{int}} = m_1 x_{\text{int}} + b_1$$
3. **Segment Intersection Filter**:
   Evaluates Line 2 against each individual line segment $(P_i, P_{i+1})$. Checks if intersection coordinate $(x_s, y_s)$ falls within segment bounding box:
   $$x_s \in [\min(x_A, x_B), \max(x_A, x_B)] \quad \text{and} \quad y_s \in [\min(y_A, y_B), \max(y_A, y_B)]$$

#### 3.6 Point Verification Protocol (`setCheckPoint`)
Evaluates user-submitted test point $(x_c, y_c)$ against active line equations:
1. **`_isPointOnRegression`**: Checks if $|y_c - (m_1 x_c + b_1)| < 10^{-9}$ (or $|x_c - x_0| < 10^{-9}$ for vertical lines).
2. **`_isPointOnSegments`**: Checks if point falls directly on any segment $(P_i, P_{i+1})$ by testing triangle inequality $|d(P_A, P_{\text{check}}) + d(P_{\text{check}}, P_B) - d(P_A, P_B)| < 10^{-9}$.
3. **`_isPointOnSecondLine`**: Checks if $|y_c - (m_2 x_c + b_2)| < 10^{-9}$.

### 3.7 Expression Normalization Parser (`_normalize`)
Pre-processes raw user equation strings into valid mathematical expressions before parsing with `math_expressions`:
- **Decimal Normalization**: Converts `.5` $\rightarrow$ `0.5`.
- **Implicit Coefficient Multiplication**: Converts `2x` $\rightarrow$ `2*x`, `x2` $\rightarrow$ `x*2`, `xy` $\rightarrow$ `x*y`.
- **Implicit Parenthetical Multiplication**: Converts `2(x)` $\rightarrow$ `2*(x)`, `x(y)` $\rightarrow$ `x*(y)`, `(a)(b)` $\rightarrow$ `(a)*(b)`.

---

## 4. UI Layout & Visual Instrumentation

### 4.1 Status & Input Sections
- **Status Bar**: Displays audit status (`"PERFECTLY LINEAR"`, `"APPROXIMATE REGRESSION"`, or `"AWAITING DATA"`), formula statement ($d = \sqrt{\Delta x^2 + \Delta y^2}$), and buffer purge button.
- **Coordinate Ingestion Card**: Input fields for $X$ and $Y$ values with instant point addition.
- **Direct Equation Card**: Text field for entering equation strings (e.g. `p = 27.5h`).
- **Line 2 Protocol Card**: Inputs for $m_2$ and $b_2$ (or equation string) to execute line intersection.
- **Point Verification Card**: Inputs for $X_{\text{check}}$ and $Y_{\text{check}}$ to test point validity.

### 4.2 Calculated Metrics Panel
Displays high-visibility metrics:
- **Slope ($m$)**: Decimal value and exact fraction string.
- **$Y$-Intercept ($b$)**: Vertical intercept coordinate.
- **Rise ($\Delta y$) & Run ($\Delta x$)**: Net vertical and horizontal changes.
- **Distance ($d$)**: Bounding distance value.
- **Compiled Equation Banner**: Highlighted box displaying formatted equation string (e.g. `y = (2/3)x + 5.00`) with copy-to-clipboard button.

### 4.3 Interactive Data Visualization Canvas (`SlopeGridPainter`)
- **Aspect-Ratio Preserving Scaling**:
  Uses a 1:1 scale factor $\text{scale} = \min(\frac{\text{viewWidth}}{\text{rangeX}}, \frac{\text{viewHeight}}{\text{rangeY}})$ to preserve physical slope angles visually without stretch or distortion.
- **Data-Driven Viewport Bounding**:
  Calculates dynamic bounding box $[x_{\min}, x_{\max}] \times [y_{\min}, y_{\max}]$ encompassing data points, regression line extremes, Line 2 endpoints, intersection nodes, segment intersections, and test check points.
- **Cartesian Grid & Axes**: Renders background coordinate grid, $X/Y$ axes centered on canvas.
- **Data Points & Trendline**: Plots point markers, regression line, Line 2 vector, intersection nodes, segment intersections, and check point targets.
- **Slope Triangle Overlay**: Renders the right-triangle projection (Rise, Run, Distance) between data extremes along the regression line.
- **Crosshair Hover Tracker**: Mouse hover detects pointer position and displays crosshair coordinate readings $(X_{\text{cursor}}, Y_{\text{cursor}})$ in standard mode.
- **Minimal Mode Toggle**: Allows switching between full annotated view and minimal vector representation.

### 4.4 Secondary Tab Audit Logs
- **Linear Audit Tab**: Tabular log displaying `FROM`, `TO`, `Δx`, `Δy`, `Ratio (Y/X)`, `Slope (m)`, and `Distance` for every consecutive point segment.
- **Proportionality Analysis Tab**: Displays proportional status (`"EXACT PROPORTIONAL RELATIONSHIP"` vs `"NON-PROPORTIONAL DATA"`), constant $k$, and model equation (e.g., $y = (3/4)x$).

---

## 5. Rebuild Blueprint for New Project

When implementing the Slope Calculator in a new project:

1. **Copy Controller & Model**: Port [`slope_ctrl.dart`](file:///c:/C/Users/Owner/IdeaProjects/math_tools/lib/features/slope_calculator/controller/slope_ctrl.dart) and [`slope_model.dart`](file:///c:/C/Users/Owner/IdeaProjects/math_tools/lib/features/slope_calculator/model/slope_model.dart) with all regression, intersection, and proportionality routines.
2. **Copy View & Painter**: Port [`slope_view.dart`](file:///c:/C/Users/Owner/IdeaProjects/math_tools/lib/features/slope_calculator/presentation/slope_view.dart) and `SlopeGridPainter`.
3. **Dependencies**: Ensure `math_expressions`, `riverpod`, and `dart_mappable` packages are available.
