# CyberOracle - Project Context & Implementation Guide

> **Last Updated**: 2025-12-26
> **Status**: Architecture Complete → Ready for UI Implementation
> **Target Platform**: Apple Watch (watchOS 10+), scalable to iPhone

---

## 🎯 Project Overview

**CyberOracle (赛博灵签)** is a cyberpunk-themed fortune-telling and decision-making Apple Watch app combining:
- **Daily Luck**: 4-metric personal fortune (Love/Money/Career/Health)
- **Decision Maker**: Yes/No coin flip with shake gesture
- **Fortune Sticks**: Traditional Chinese divination (求签) with 5-tier fortune levels
- **Cyberpunk HUD**: Neon glow, glitch effects, immersive haptics

**Core Experience**: Wrist-raise → Swipe → Shake → Feel haptic feedback → See cyberpunk visuals

---

## ✅ Current Architecture Status

### What's Complete (Production-Ready)

#### 1. Core Business Logic (100%)
- **Domain Layer**: `packages/CyberOracleCore/Sources/CyberOracleDomain/`
  - ✅ `OracleService` protocol
  - ✅ 5-tier fortune levels (ULTRA/SUPER/BASIC/GLITCH/ERROR)
  - ✅ Daily luck models (4 metrics: Love/Money/Career/Health)
  - ✅ Decision system (Yes/No)

#### 2. Data Layer (100%)
- **Local Implementation**: `packages/CyberOracleCore/Sources/CyberOracleData/`
  - ✅ `LocalOracleService` (offline, deterministic)
  - ✅ `RemoteOracleService` (Node.js API client)
  - ✅ `SplitMix64` PRNG (deterministic random generation)
  - ✅ Configuration loader (`fortune_levels.json`)

#### 3. App Layer (100%)
- **ViewModels**: `apps/apple/CyberOracleAppShared/ViewModels/`
  - ✅ `FortuneStickViewModel`
  - ✅ `DecisionViewModel`
  - ✅ `DailyLuckViewModel`
- **Environment**: `AppEnvironment` (dependency injection)

#### 4. Backend API (100%)
- **Node.js Service**: `services/cyberoracle-api/`
  - ✅ Fastify REST API
  - ✅ All endpoints implemented
  - ✅ TypeScript with matching algorithms

#### 5. Configuration (100%)
- ✅ Single source of truth: `config/fortune_levels.json`
- ✅ OpenAPI contract: `contracts/oracle-api.openapi.json`
- ✅ Comprehensive PRD: `docs/PRD-CyberOracle.md`

### What's Missing (UI & Interactions)

❌ **All user-facing screens** (Home, Daily Luck, Decision, Fortune)
❌ **Motion/shake gesture detection** (CoreMotion)
❌ **Haptic feedback** (Core Haptics)
❌ **Animations** (coin flip, stick shake, result reveal)
❌ **Cyberpunk visual design** (neon glow, glitch effects)
❌ **Navigation system** (swipe gestures)
❌ **Sound effects**
❌ **Xcode watchOS project** (needs to be created)

---

## 🏗️ Architecture Principles

### Clean Separation of Concerns
```
Domain (What) → Data (How) → App (Presentation)
```

- **Domain**: Pure Swift models, enums, protocols (no implementation)
- **Data**: Concrete implementations (Local/Remote services)
- **App**: ViewModels, Views, Environment

### Key Design Decisions

1. **Offline-First**: Use `LocalOracleService` by default (no network dependency)
2. **Deterministic Results**: Same date = same fortune (via `SplitMix64` PRNG)
3. **Dependency Injection**: ViewModels accept services & date providers (testable)
4. **Swift Package**: `CyberOracleCore` shared across watchOS/iOS/macOS
5. **Backend Optional**: Deploy later for cross-device sync

---

## 🎨 Design System (Cyberpunk Theme)

### Color Palette
```swift
// Primary colors (from PRD & config/fortune_levels.json)
#00FF41  // Neon green (hacker green)
#FF00FF  // Cyber magenta
#00FFFF  // Cyan (highlight)
#111111  // Deep black (background)

// Fortune level colors
#FFD700  // ULTRA (gold)
#00FF41  // SUPER (green)
#00A0FF  // BASIC (blue)
#FFD700  // GLITCH (yellow)
#FF0000  // ERROR (red)
```

### Visual Style
- **Reference**: Cyberpunk 2077 HUD, FUI (Fictional UI), Dot Matrix
- **Effects**: Neon glow, glitch animation, hologram flicker
- **Typography**: Monospace fonts (SF Mono, Courier)

### Haptic Patterns
- **Decision YES**: `.success` haptic
- **Decision NO**: `.error` haptic
- **Fortune shake**: Continuous `.impact(.light)` (collision simulation)
- **Fortune reveal**: Custom pattern per level (from `fortune_levels.json`)

---

## 🚀 Implementation Strategy

### Confirmed Approach (User Decisions)

✅ **Platform**: Apple Watch only (MVP)
✅ **Design**: Placeholder UI first → refine visuals later
✅ **Backend**: Use `LocalOracleService` (offline mode)
✅ **Feature Order**: Home → Daily Luck → Decision → Fortune

### 6-Sprint Roadmap

#### **Sprint 1: Foundation** (Phases 1-2)
**Goal**: Working Xcode project with navigation

- Create watchOS Xcode project (`CyberOracleWatch`)
- Link `CyberOracleCore` Swift Package
- Setup navigation (TabView or gesture-based)
- Implement Home screen (placeholder UI):
  - Time display (monospace font)
  - Date in PRD format (`2025/10 / date 25`)
  - Swipe gestures working

**Files to Create**:
- `apps/apple/CyberOracleWatchApp/CyberOracleWatchApp.xcodeproj`
- `apps/apple/CyberOracleWatchApp/Navigation/RootNavigationView.swift`
- `apps/apple/CyberOracleWatchApp/Views/HomeView.swift`

**Validation**: Navigate between 4 placeholder screens on Apple Watch

---

#### **Sprint 2: Daily Luck** (Phase 3)
**Goal**: Functional daily luck display

- Implement `DailyLuckView.swift`
- Connect to existing `DailyLuckViewModel`
- Display 4 metrics in grid layout
- Add midnight auto-refresh logic

**Files to Create**:
- `apps/apple/CyberOracleWatchApp/Views/DailyLuckView.swift`
- `apps/apple/CyberOracleWatchApp/Views/Components/LuckMetricCard.swift`

**Validation**: Daily luck shows different values each day, refreshes at midnight

---

#### **Sprint 3: Decision Maker** (Phase 4)
**Goal**: Yes/No decision with shake gesture

- Implement `DecisionView.swift` (3-stage state machine)
- Create `ShakeDetector.swift` (CoreMotion)
- Add `HapticEngine.swift` (basic haptics)
- Implement animations (prayer → toss → result)

**Files to Create**:
- `apps/apple/CyberOracleWatchApp/Views/DecisionView.swift`
- `apps/apple/CyberOracleWatchApp/Motion/ShakeDetector.swift`
- `apps/apple/CyberOracleWatchApp/Haptics/HapticEngine.swift`

**Validation**: Shake watch → see YES/NO result with haptic feedback

---

#### **Sprint 4: Fortune Sticks** (Phase 5)
**Goal**: Full fortune-telling experience

- Implement `FortuneView.swift` (4-stage flow)
- Reuse `ShakeDetector` from Sprint 3
- Create fortune-specific haptic patterns
- Implement animations (shake → drop → reveal)
- Display fortune result with copy text from `fortune_levels.json`

**Files to Create**:
- `apps/apple/CyberOracleWatchApp/Views/FortuneView.swift`
- `apps/apple/CyberOracleWatchApp/Haptics/FortuneHapticPatterns.swift`

**Validation**: Shake → see fortune level with appropriate text

---

#### **Sprint 5: Visual Polish** (Phase 6)
**Goal**: Apply cyberpunk theme

- Create `CyberTheme.swift` (color palette)
- Replace placeholder UI with neon colors
- Add visual effects (glow, glitch, grid background)
- Refine typography

**Files to Create**:
- `apps/apple/CyberOracleWatchApp/Design/CyberTheme.swift`
- `apps/apple/CyberOracleWatchApp/Design/Components/NeonText.swift`
- `apps/apple/CyberOracleWatchApp/Design/Effects/BackgroundEffects.swift`

**Validation**: App looks like PRD mockups

---

#### **Sprint 6: Sound & Final Polish** (Phase 7)
**Goal**: Audio feedback + bug fixes

- Add sound effects (success/error tones)
- Refine haptic patterns
- Performance optimization
- Bug fixes

**Files to Create**:
- `apps/apple/CyberOracleWatchApp/Audio/SoundEngine.swift`
- `apps/apple/CyberOracleWatchApp/Resources/Sounds/*.mp3`

**Validation**: Full PRD feature set working on Apple Watch

---

## 📁 Critical File Locations

### Existing (Ready to Use)
```
packages/CyberOracleCore/
  Sources/
    CyberOracleDomain/          # All domain models
    CyberOracleData/            # All data implementations
      LocalOracleService.swift  # ← Use this for MVP
      RemoteOracleService.swift # ← Use later for backend

apps/apple/CyberOracleAppShared/
  AppEnvironment.swift          # Dependency injection
  ViewModels/
    FortuneStickViewModel.swift # ← Connect to FortuneView
    DecisionViewModel.swift     # ← Connect to DecisionView
    DailyLuckViewModel.swift    # ← Connect to DailyLuckView

config/
  fortune_levels.json           # Single source of truth
```

### To Create (During Implementation)
```
apps/apple/CyberOracleWatchApp/
  Views/
    HomeView.swift              # Sprint 1
    DailyLuckView.swift         # Sprint 2
    DecisionView.swift          # Sprint 3
    FortuneView.swift           # Sprint 4
  Motion/
    ShakeDetector.swift         # Sprint 3
  Haptics/
    HapticEngine.swift          # Sprint 3
    FortuneHapticPatterns.swift # Sprint 4
  Design/
    CyberTheme.swift            # Sprint 5
  Audio/
    SoundEngine.swift           # Sprint 6
```

---

## 🔧 Key Technical Details

### Fortune Levels (5-tier system)
```swift
// From config/fortune_levels.json
ULTRA   (⚡ 大吉)  - 10% probability - Gold flash effect
SUPER   (🟢 中吉)  - 25% probability - Green neon
BASIC   (🔵 小吉)  - 40% probability - Blue calm
GLITCH  (🟡 末吉)  - 15% probability - Yellow glitch
ERROR   (🔴 凶)    - 10% probability - Red error modal
```

### Daily Luck Metrics
```swift
// 4 dimensions, 4 tiers each
Love (💗):    1=🤩 极好, 2=🙂 尚可, 3=😐 一般, 4=😵 较差
Money (💰):   1=🤩 极好, 2=🙂 尚可, 3=😐 一般, 4=😵 较差
Career (💼):  1=🤩 极好, 2=🙂 尚可, 3=😐 一般, 4=😵 较差
Health (❤️‍🩹): 1=🤩 极好, 2=🙂 尚可, 3=😐 一般, 4=😵 较差
```

### Determinism Algorithm
```swift
// Same date → same results (via SplitMix64 PRNG)
let seed = daySeed(Date()) // YYYY*10000 + MM*100 + DD
let rng = SplitMix64(seed: seed)
// Guarantees reproducibility across devices
```

### CoreMotion Shake Detection
```swift
// Recommended threshold (from PRD research)
let shakeThreshold = 2.5 // acceleration magnitude
// Avoid false positives during walking
```

---

## 🎯 Feature Requirements (from PRD)

### Home Screen (赛博时间 HUD)
- **Display**: Year/month, date, time (monospace)
- **Background**: Dark grid + breathing light
- **Navigation**: Swipe left (Daily Luck), Swipe right (Decision/Fortune)

### Daily Luck (每日运势)
- **Metrics**: Love, Money, Career, Health
- **Visual**: 4-quadrant grid or radar chart
- **Update**: Auto-refresh at midnight (00:00)

### Decision Maker (日常抉择)
- **Stage 1 (Prayer)**: Hands folded + "Shake it" prompt
- **Stage 2 (Toss)**: Shake detection → coin flip animation + haptics
- **Stage 3 (Result)**: YES (green) or NO (red) + sound

### Fortune Sticks (电子求签)
- **Stage 1 (Shake)**: Holographic cylinder + shake prompt
- **Stage 2 (Haptics)**: "哗啦哗啦" collision feedback
- **Stage 3 (Drop)**: One stick falls + hovers
- **Stage 4 (Reveal)**: Flip animation → fortune level + copy text

---

## 🚧 Future Expansion (Post-MVP)

### iOS App (Phase 8)
- Reuse all ViewModels & business logic
- Create iOS-specific UI (larger screen)
- Share 90%+ of code via `CyberOracleAppShared`

### Backend Integration (Phase 10)
- Deploy `services/cyberoracle-api` to cloud
- Switch to `RemoteOracleService`
- Enable cross-device sync

### Complications (Phase 9)
- WidgetKit complication
- Show daily luck on watch face

---

## 📚 Documentation References

| Document | Purpose | Location |
|----------|---------|----------|
| **PRD** | Product requirements, interaction flows | `docs/PRD-CyberOracle.md` |
| **README** | Architecture overview, next steps | `README.md` |
| **AI Asset Guide** | AI-generated asset guidelines | `docs/AI-Asset-Production-Guide.md` |
| **Motion Guidelines** | Haptic feedback patterns | `docs/watchOS-Motion-Guidelines.md` |
| **Design Workflow** | Design-to-dev sync process | `docs/Design-Dev-Sync-Workflow.md` |
| **Fortune Config** | Fortune levels & probabilities | `config/fortune_levels.json` |
| **API Contract** | Backend API specification | `contracts/oracle-api.openapi.json` |

---

## 💡 Development Tips

### Starting a Session
1. **Read this file first** to understand project status
2. **Review current sprint** in roadmap above
3. **Check PRD** (`docs/PRD-CyberOracle.md`) for specific feature requirements
4. **Read existing ViewModels** before creating views

### Before Writing Code
1. ✅ **Verify skeleton exists**: Check if ViewModel/Model already implemented
2. ✅ **Check config**: `fortune_levels.json` for fortune data
3. ✅ **Review PRD requirements**: Ensure design matches specification
4. ✅ **Test on device**: Motion/haptics won't work in Simulator

### Architecture Guidelines
- **Don't modify** Domain/Data layers (already complete)
- **Do connect** ViewModels to Views
- **Use** `LocalOracleService` for MVP (offline)
- **Inject** `AppEnvironment` in main app entry point

---

## 🎬 Quick Start Commands

### Backend Development (Optional)
```bash
cd services/cyberoracle-api
npm install --cache .npm-cache
npm run dev  # Start Fastify server on http://localhost:3000
```

### Testing Swift Package
```bash
cd packages/CyberOracleCore
swift test  # Run XCTest suite
```

---

## 🔑 Key Takeaways

1. **Architecture is complete** - All business logic exists, only UI missing
2. **Start with Sprint 1** - Create Xcode project + basic navigation
3. **Use placeholder UI first** - Refine cyberpunk visuals in Sprint 5
4. **Focus on watchOS** - iPhone expansion comes after MVP
5. **Offline-first** - Use `LocalOracleService`, deploy backend later
6. **Test on real device** - Haptics/motion require physical Apple Watch

---

**Ready to implement?** Start with Sprint 1: Create the Xcode watchOS project and basic navigation.
