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
