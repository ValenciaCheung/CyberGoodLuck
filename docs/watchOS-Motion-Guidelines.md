# watchOS Motion Guidelines Breakdown

## Benchmarks

- **Frame Rate & Performance:** Target 60fps; animation duration 120ms–600ms; keep overall weight light.
- **Easing Curves:** `easeOut` (Reveal/Completion), `easeInOut` (Transition), `spring(soft)` (Physical feel).
- **Battery Friendly:** Avoid prolonged full-screen glow or complex particles; prioritize static frames + keyframes.

## Motion Elements

- **Praying Hands:** `200–300ms` clasp to pause; add slight `spring` breathing effect when prompting to shake.
- **Coin Flip:** `500–700ms`, three-stage keyframes `FlipStart→FlipMid→FlipEnd`; enhance trails/afterimages and glow in the middle stage.
- **Shaking Tube:** `300–500ms` loop segment; shake intensity increases in sync with Haptics.
- **Stick Drop & Reveal:** `Drop 250ms`, `Reveal 300ms`; add slight jitter and noise for `Glitch` level.

## Haptics Mapping (Core Haptics)

- **Shake:** `Transient(light)` × multiple times, superimposed with `Continuous(low amplitude)`.
- **Toss Flip:** `Transient(medium)` at `FlipMid`.
- **Result YES:** `Success(heavy)`; **NO:** `Error(medium)`.
- **Fortune Reveal:** `Notification(success|warning|error)` depending on level; `ERROR` uses short, heavy impact but controlled duration.

## Technical Approach

- **SwiftUI + CoreAnimation:** Suitable for UI transitions and state animations (`withAnimation`, `matchedGeometryEffect`).
- **SpriteKit:** Suitable for animations requiring physics or sequence frames like coins/sticks.
- **Image Sequence Animation:** Export `PNG` sequences, play frame-by-frame using `WKInterfaceImage` or SwiftUI `Image`.
- **Video Assets:** Only for short-term display; suggest `H.264` small file size clips. Use cautiously to prevent battery drain and loading blocks.
- **Lottie:** watchOS does not support natively; suggest converting Lottie to image sequences or SpriteKit animations at build time.

## Export Specifications

- **Static:** `PNG @2x/@3x`, with transparency channel.
- **Motion:** `PNG` sequences (named `CO_CoinFlip_0001.png`…) or `SpriteSheet`; short `mp4` if necessary.
- **Color & Glow:** Avoid pure white high glow/overexposure; use theme color grading and additive glow.

## Accessibility & Readability

- **Contrast:** Use high-contrast theme colors for Time and Results; avoid thin, small fonts in red.
- **Reduce Motion:** Adhere to system "Reduce Motion" settings; provide static alternatives or shorten animations.
- **Haptics Sensitivity:** Support options to weaken haptic feedback.
