# AI Asset Generation & Tools Guide

## Tools Overview (By Usage)

- **Generating High-Fidelity Visuals**
- **Midjourney:** Strong style and lighting control, suitable for Cyber/Neon aesthetics.
- **Stable Diffusion SDXL/ComfyUI:** Locally controllable, strong batch processing & consistency.
- **Adobe Firefly:** Copyright friendly, more stable Text-to-Image results.

- **Generating UI/Component Drafts**
- **Galileo AI:** Text-to-Mobile/Watch Face UI sketches.
- **Uizard:** Wireframe to High-Fidelity UI.
- **Relume AI:** Structure and component suggestions, easy to break down.

- **Figma Enhancement & Automation**
- **Magician by Diagram:** AI fills copy/icon styles.
- **Automator:** Batch generate variants and properties.
- **Locofy/Anima:** Component to code prototype, easy to verify structure.

- **Icons & Symbols**
- **SF Symbols:** watchOS native icons.
- **Icon8/Phosphor:** Supplement with consistent vector styles.

- **Motion & Sequences**
- **After Effects + Bodymovin:** Convert to Lottie; PNG sequences recommended for watchOS.
- **Blender:** Physics/coin/stick simulation, export frame sequences.
- **Runway/Kaiber:** Short reference videos to guide keyframes.

## Recommended Production Pipeline (Cyber Neon Style)

1. **Reference Collection:** Cyberpunk HUD/FUI, Tron Discs, Dot Matrix, Neon glow.
2. **Base Image Generation:** Use MJ/SD to generate background and texture assets (fluid dark grids, glitch noise).
3. **Refinement & Layering:** Photoshop/Photopea for layering and cleanup, export transparent PNGs.
4. **Componentization:** Import to Figma, create components and variants according to `CO/Module/Component` (see naming doc).
5. **Motion Keyframes:** Use Blender/AE to generate frame sequences for coin flips, stick drops, and Reveals.
6. **Export & Adaptation:** Output `@2x/@3x` PNGs and sequences, naming conventions and sizing adapted for watchOS.
7. **Integration (Tuning):** Align Core Haptics with keyframes, regression testing for performance and battery.

## Export & Naming Conventions

- **Static:** `PNG @2x/@3x` transparent background; Filename `CO_Home_Background@2x.png`
- **Sequence:** `CO_CoinFlip_0001.png` … `CO_CoinFlip_0060.png`
- **SpriteSheet (Optional):** `CO_Stick_Reveal_Sheet@2x.png` + `meta.json`
- **Colors & Themes:** Adhere to configuration: see `config/fortune_levels.json`

## watchOS Adaptation Points

- **Resolution & Size:** Target 40/44/45mm (Generate via Artboard `Size` variants).
- **Performance:** Prioritize Image Sequences & SpriteKit, avoid long videos and heavy particles.
- **Accessibility:** High contrast themes; System "Reduce Motion" provides static alternatives.

## Quality Assurance Checklist

- **Style Consistency:** Neon colors and glow intensity are unified; avoid pure white overexposure.
- **Copy & Level Correspondence:** Component variants match the 5 fortune levels.
- **Margins & Constraints:** 8pt baseline; Monospace time alignment.
- **Motion Timing:** Keyframes and Haptics mapping meet specifications.

---

## Daily Luck Core Flow Assets (PRD v1.0)

### Required Assets

| Asset | Reference | Purpose |
|-------|-----------|---------|
| Shake Screen | `Apple Watch Series 10 42mm - 01` | Praying hands + shake prompt |
| Watch Face | `Apple Watch Series 10 42mm - 02` | Lucky Cat Holding Gold Brick |
| Coin Page | `Apple Watch Series 10 42mm - 05` | Ten Million Ryo (千万两) coin |
| Result Cards | `Apple Watch Series 10 42mm - 36-39` | 4 dimension result cards |
| Backgrounds | `Apple Watch Series 10 42mm - 40-43` | Card backgrounds per status level |

### Lucky Cat Expressions (2-Frame Loops)

All Lucky Cat expressions are 2-frame PNG loops with 1000ms duration:

| Status Level | Frames | Description |
|--------------|--------|-------------|
| Super Lucky (大吉) | Frame 1 ↔ Frame 2 | Celebratory expression |
| Good Luck (中吉) | Frame 3 ↔ Frame 4 | Happy expression |
| Average (小吉) | Frame 5 ↔ Frame 6 | Neutral expression |
| Bad Luck (凶) | Frame 7 ↔ Frame 8 | Disappointed expression |

### Animation Specs

- **Shake Prompt**: 1s animation loop
- **Loading Dots**: 3-dot blinking, 0.5s duration
- **Coin Slap**: 300ms impact animation
- **Lucky Cat Loop**: 1000ms per 2-frame cycle

### Export Format
- **Static**: PNG @2x/@3x with transparency
- **Animation Frames**: Named sequences (e.g., `CO_Cat_SuperLucky_01.png`, `CO_Cat_SuperLucky_02.png`)
- **Color Profile**: sRGB for watchOS compatibility
