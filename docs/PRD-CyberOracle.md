Here is the optimized and translated Product Requirement Document (PRD) based on your requests.

---

# Product Requirement Document (PRD)

| Item             | Details                                                                                                      |
| ---------------- | ------------------------------------------------------------------------------------------------------------ |
| **Project Name** | **CyberGoodLuck**                                                                                            |
| **Platform**     | Apple Watch (watchOS)                                                                                        |
| **Version**      | v1.0 MVP (Minimum Viable Product)                                                                            |
| **Core Style**   | Traditional Japanese folk art mixed with modern flat vector illustration, bold black outlines, high-contrast |
| **Last Updated** | 2025-12-27                                                                                                   |

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

### 2.2 Feature 1: Daily Luck HUD

**Updated to an interactive "Shake" experience.**

- **Trigger:** Wrist raise -> Select "Shake" mode.
- **Phase 1: Prayer**
- **Visual:** Japanese style hands clasped in prayer (flat vector + bold black outline).
- **Action:** Prompt "Shake it".

- **Phase 2: Toss**
- **Sensor:** Accelerometer detects vigorous shaking.
- **Animation:** Hands open → **Animation of a Maneki-neko (Lucky Cat) and "Ten Million Ryo" (千万两) coin.**

- **Phase 3: Result (Status Levels)**
- **Level 1 Excellent:** 🤩
- **Level 2 Fair:** 🙂
- **Level 3 Poor:** 😵

- **Logic:** Refreshes automatically at 00:00 daily. Random generation using a skewed normal distribution (mostly "Excellent/Fair," rarely "Poor").

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
- **Daily Luck:** Shake interaction triggers the Lucky Cat animation; results refresh correctly at midnight.
- **Decision Maker:** Daruma animation plays before shake; Yes/No results display correctly with sound.
- **Fortune Sticks:** Results strictly follow the 15%/25%/40%/15%/5% probability distribution.
