Here is the optimized and translated Product Requirement Document (PRD) based on your requests.

---

# Product Requirement Document (PRD)

| Item             | Details                                                                                                      |
| ---------------- | ------------------------------------------------------------------------------------------------------------ |
| **Project Name** | **CyberGoodLuck**                                                                                            |
| **Platform**     | Apple Watch (watchOS)                                                                                        |
| **Version**      | v1.0 MVP (Minimum Viable Product)                                                                            |
| **Core Style**   | Traditional Japanese folk art mixed with modern flat vector illustration, bold black outlines, high-contrast |
| **Last Updated** | 2025-12-28                                                                                                   |

## 1. Product Overview

### 1.1 Core Value

Leveraging the wearable nature and sensors (gyroscope/haptic motor) of the Apple Watch to create a stress-relief tool that combines a "functional clock" with "Cyber Metaphysics." It allows users to check their fortune and cure indecision with a simple wrist raise.

### 1.2 User Persona

Design-driven young users, people with "decision paralysis," and subculture groups who enjoy "Cyber Wooden Fish / Cyber Buddha" aesthetics.

## 2. Feature Specifications

### 2.1 Home / Watch Face

Default view emphasizing visual impact and efficient information display.

- **Interaction:**
- **Swipe Left:** Enter **[Daily Luck HUD]**.
- **Swipe Right:** Enter Menu **[Daily Luck] [Decision Maker] [Cyber Fortune Sticks]**.

### 2.2 Feature 1: Daily Luck Core Flow

Users draw their daily fortune through a realistic "Shake" interaction. The core experience relies on **Core Haptics** and **Core Motion** to simulate the physical sensation of coins colliding in a shaker, accompanied by high-impact visual transitions.

#### 2.2.1 Opening & Shake Interaction

- **Opening Animation:** Upon launch, display the "Praying Hands" animation.
- **Shake Screen:** Automatically transition to the Shake Interface (Ref: `Apple Watch Series 10 42mm - 01`).
  - **Animation:** Prompt user to shake wrist (Show animation for 1s).
  - **Logic:** Utilize accelerometer to detect wrist motion.

**Fallback Mechanism:**
- **Condition:** If no valid shake is detected after > 2 seconds on the Shake screen (e.g., user is in a meeting or sensor miss).
- **Interaction:** Allow the user to tap the praying hands in the center of the screen to trigger the flow manually.

#### 2.2.2 Haptics & Audio Feedback (Core Experience)

**During Shake:**
- **Haptics:** Use Core Haptics to simulate the crisp, continuous sensation of coins colliding inside a container.
- **Sound:** Sync with crisp coin clinking sound effects.

**On Result Reveal (Impact):**
- **Super Lucky:** Two consecutive heavy vibrations (Heavy Impact x2, celebratory feel).
- **Bad Luck:** Single low-frequency heavy vibration (Heavy Impact x1, sinking feel).
- **Others:** Standard haptic feedback.

#### 2.2.3 Transition & Reveal Animation

1. **Coin Transition:** Upon trigger, transition to the "Ten Million Ryo" (千万两) Coin Page (Ref: `Apple Watch Series 10 42mm - 05`).
2. **Loading State:** Add a 3-dot blinking loading animation on the coin page, duration: 0.5 seconds.
3. **Visual Impact:** A giant coin "slaps" onto the screen with sound effects, freezes into the Lucky Cat expression, and then expands into the detailed list view.

#### 2.2.4 Result Display

**Layout:** Vertical scrollable list displaying cards for 4 dimensions.

**Dimensions:**
- Love
- Wealth
- Health
- Career

**Status Copy (4 Levels):**
- Super Lucky (大吉)
- Good Luck (中吉)
- Average (小吉)
- Bad Luck (凶)

**Expression Effects (Loop Animation):**
- All Lucky Cat expressions are 2-frame PNG loops, duration 1000ms.
- **Super Lucky:** Loop Frame 1 ↔ Frame 2
- **Good Luck:** Loop Frame 3 ↔ Frame 4
- **Average:** Loop Frame 5 ↔ Frame 6
- **Bad Luck:** Loop Frame 7 ↔ Frame 8

**Asset References:** Result Pages 36-39, Backgrounds 40-43.

**Scroll Hint:**
- Ensure the top 30% of the 3rd card (Health) is visible to cue scrolling via Digital Crown.

#### 2.2.5 Retention: Set as Watch Face

- **Placement:** At the very bottom of the result list.
- **Action:** Button "Set as Today's Watch Face".
- **Logic:** Upon click, trigger system interface to set the "Lucky Cat Holding Gold Brick" image (Ref: `Apple Watch Series 10 42mm - 02`) as the user's current Watch Face.

**Daily Refresh Logic:** Results refresh automatically at 00:00 daily.

### 2.3 Feature 2: Decision Maker

Solves quick decisions like "Yes or No."

- **Trigger:** Wrist raise -> Select "Yes/No" mode.
- **Phase 1: Prayer**
- **Visual:** Displays **half a coin + text "Yes or No"**, followed by an **animation of a Daruma doll**.
- **Action:** Prompt "Shake it".

- **Phase 2: Toss**
- **Sensor:** Accelerometer detects vigorous shaking.
- **Animation:** Hands open → Japanese coin flips in the air.

- **Phase 3: Result**
- **YES:** Coin showing "YES" (with bold black outline), crisp success sound effect.
- **NO:** Coin showing "NO" (with bold black outline), low-pitched error sound effect.

### 2.4 Feature 3: Cyber Fortune Sticks (Omikuji)

The core ritual feature. Adopts Japanese folk art style.

- **Scene:** Japanese fortune stick container (flat vector style + bold black outline).
- **Interaction Flow:**

1. **Shake:** Continuously shake wrist.
2. **Haptics:** "Rattle" vibration feedback.
3. **Drop:** A stick drops out.
4. **Reveal:** Stick flips to reveal the text/interpretation.

## 3. Fortune Research & Recommendations

Traditional fortune slips usually have 7 levels. For the App, we use a 5-level system with the following probability distribution:

### Recommended Scheme (5 Levels)

1. **Great Blessing (大吉)** — Probability **15%**
2. **Middle Blessing (中吉)** — Probability **25%**
3. **Small Blessing (小吉)** — Probability **40%**
4. **Small Curse (小凶)** — Probability **15%**
5. **Great Curse (大凶)** — Probability **5%**

_(Specific visual descriptions and copy examples for these levels are to be defined based on the new structure.)_

## 4. UX & Animation Details

### 4.2 Key Animation Descriptions

1. **Fortune Shake:** Emphasize physical collision feel; reference Blender rigid body collision; drop has Hologram flicker.
2. **Coin Animation:** Reference _Tron: Legacy_ disc texture; flip with trails/afterimages.

## 5. Technical Constraints

- **Haptics:** Must use Core Haptics.
- **Motion Manager:** Precise detection of "Shake" to avoid false triggers while walking.
- **Complications:** Future support for displaying "Daily Fortune" on native watch faces.

## 6. Design & Implementation Milestones

- **M1:** Static UI — Complete Home & Daily Luck static drafts.
- **M2:** Key Motion — Maneki-neko, Daruma doll, and Coin flip animations.
- **M3:** Interaction Integration — Gesture recognition + Haptics integration.
- **M4:** Fortune Results — Implementation of 5-level probability logic.

## 7. Acceptance Criteria

- Home swipe interactions (Left/Right) function correctly.

**Daily Luck:**
- [ ] Praying hands animation displays on entry
- [ ] Shake screen prompts user with 1s animation
- [ ] Accelerometer detects shake gesture correctly
- [ ] Tap fallback triggers after 2 seconds of no shake
- [ ] Coin collision haptics play during shake
- [ ] "Ten Million Ryo" coin page shows with 3-dot loading (0.5s)
- [ ] Coin slap animation plays with sound effects
- [ ] 4-dimension result list (Love, Wealth, Health, Career) displays correctly
- [ ] Lucky Cat expressions loop (1000ms, 2-frame PNG)
- [ ] Super Lucky: Heavy Impact x2 haptic
- [ ] Bad Luck: Heavy Impact x1 (low frequency) haptic
- [ ] 30% of 3rd card visible for scroll hint
- [ ] "Set as Watch Face" button at bottom of result list
- [ ] Results refresh correctly at midnight (00:00)

**Decision Maker:**
- Daruma animation plays before shake
- Yes/No results display correctly with sound

**Fortune Sticks:**
- Results strictly follow the 15%/25%/40%/15%/5% probability distribution.
