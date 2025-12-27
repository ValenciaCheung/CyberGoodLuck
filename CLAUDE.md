# CyberOracle - Project Context & Implementation Guide

> **Last Updated**: 2025-12-27
> **Status**: Sprint 4 Complete ✅ → Ready for Sprint 5 (Visual Polish)
> **Target Platform**: Apple Watch (watchOS 10+), scalable to iPhone
> **Latest Commit**: Sprint 4 - Fortune Sticks with 4-stage flow & fortune levels

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

#### 6. watchOS App - Sprint 1 (100% - COMPLETE ✅)
- **Xcode Project**: `apps/apple/CyberOracleWatch/`
  - ✅ Xcode project created and configured
  - ✅ CyberOracleCore package linked
  - ✅ Bundle identifier fixed (removed `.watchkitapp`)
  - ✅ Builds and runs on Apple Watch simulator
- **Navigation**: `Navigation/RootNavigationView.swift`
  - ✅ TabView with page style
  - ✅ 4 screens (swipe left/right to navigate)
- **HomeView** (FULLY IMPLEMENTED):
  - ✅ Real-time clock (updates every second)
  - ✅ PRD-compliant date format: `2025/12 / date 27`
  - ✅ Cyberpunk colors: neon green (#00FF41), cyan (#00FFFF)
  - ✅ Monospace fonts
  - ✅ Black background

#### 7. watchOS App - Sprint 2 (100% - COMPLETE ✅)
- **DailyLuckView** (FULLY IMPLEMENTED):
  - ✅ 2x2 grid layout for 4 metrics (Love/Money/Career/Health)
  - ✅ Connected to DailyLuckViewModel
  - ✅ Tier-based emojis: 🤩 great, 🙂 good, 😐 ok, 😵 bad
  - ✅ Color-coded by tier: green/blue/yellow/red
  - ✅ Midnight auto-refresh (checks every minute)
  - ✅ ScrollView + responsive layout (adapts to watch sizes)
  - ✅ Loading/error states
- **DailyLuckViewModel**: Copied to watch app ViewModels folder

#### 8. watchOS App - Sprint 3 (100% - COMPLETE ✅)
- **DecisionView** (FULLY IMPLEMENTED):
  - ✅ 3-stage state machine: Prayer → Tossing → Result
  - ✅ Prayer stage: 🙏 + "Shake it" + shake intensity bars
  - ✅ Tossing stage: 💫 spin animation (3 rotations)
  - ✅ Result stage: ✅ YES (green) / ❌ NO (red)
  - ✅ "Again" button to reset
  - ✅ Simulator debug button (auto-hidden on real device)
- **ShakeDetector** (`Motion/ShakeDetector.swift`):
  - ✅ CoreMotion accelerometer integration
  - ✅ 2.5g threshold detection
  - ✅ Shake intensity publishing
- **HapticEngine** (`Haptics/HapticEngine.swift`):
  - ✅ Coin flip haptic
  - ✅ Success/failure haptics
  - ✅ Generic patterns (ready for Fortune Sticks)
- **DecisionViewModel**: Copied to watch app ViewModels folder
- **Animations**: Rotation, scale, spring effects

#### 9. watchOS App - Sprint 4 (100% - COMPLETE ✅)
- **FortuneView** (FULLY IMPLEMENTED):
  - ✅ 4-stage state machine: Idle → Shaking → Dropping → Revealed
  - ✅ Stick container visualization (60x70 with 5 sticks)
  - ✅ Shaking animation with 8 collision haptics
  - ✅ Dropping animation with rotation (15°)
  - ✅ Fortune reveal with emoji, label, copy text
  - ✅ 5 fortune levels from fortune_levels.json
  - ✅ Level-specific colors (Gold/Green/Blue/Yellow/Red)
  - ✅ Special effects: ULTRA (flash), ERROR (glitch)
  - ✅ Tap to retry functionality
  - ✅ Simulator debug button
- **FortuneStickViewModel**: Copied to watch app ViewModels folder
- **Fortune Levels Integration**: Complete fortune_levels.json parsing
- **Responsive Layout**: ScrollView + sized for watch screens

### What's Missing (Sprint 5+)

❌ **Cyberpunk visual polish** (Sprint 5 - Next: neon glow, glitch effects, HUD elements)
❌ **Sound effects** (Sprint 6)

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

---

## 📊 Sprint Progress Tracker

### 6-Sprint Roadmap

#### ✅ **Sprint 1: Foundation** (COMPLETED - 2025-12-27)
**Goal**: Working Xcode project with navigation

**Achievements**:

- ✅ Created watchOS Xcode project (`CyberOracleWatch`)
- ✅ Linked `CyberOracleCore` Swift Package (Domain + Data)
- ✅ Setup TabView navigation (swipe left/right)
- ✅ Implemented HomeView with **real-time clock**:
  - ✅ Monospace time display (HH:mm:ss)
  - ✅ PRD-compliant date format (`2025/12 / date 27`)
  - ✅ Cyberpunk colors (neon green #00FF41, cyan #00FFFF)
  - ✅ Updates every second via Timer
- ✅ Created placeholder views (DailyLuck, Decision, Fortune)
- ✅ Fixed bundle identifier (removed `.watchkitapp`)
- ✅ Added `.gitignore` (protects npm cache, Xcode user files)

**Files Created**:
- `apps/apple/CyberOracleWatch/CyberOracleWatch.xcodeproj`
- `apps/apple/CyberOracleWatch/CyberOracleWatch Watch App/Navigation/RootNavigationView.swift`
- `apps/apple/CyberOracleWatch/CyberOracleWatch Watch App/Views/HomeView.swift` (FULLY IMPLEMENTED)
- `apps/apple/CyberOracleWatch/CyberOracleWatch Watch App/Views/DailyLuckView.swift` (placeholder)
- `apps/apple/CyberOracleWatch/CyberOracleWatch Watch App/Views/DecisionView.swift` (placeholder)
- `apps/apple/CyberOracleWatch/CyberOracleWatch Watch App/Views/FortuneView.swift` (placeholder)

**Validation**: ✅ App runs on Apple Watch simulator, navigation works, time updates live

**Commit**: `de01d5e` - feat: Complete Sprint 1

**Lessons Learned**:
- Bundle identifier must NOT include `.watchkitapp` suffix (modern watchOS apps)
- HomeView needs `import Combine` for Timer.autoconnect()
- Always add `.gitignore` early to avoid committing build artifacts

---

#### ✅ **Sprint 2: Daily Luck** (COMPLETE - 2025-12-27)

**What Was Built**:
- `DailyLuckView.swift`: 2x2 grid layout with 4 luck metrics
- `DailyLuckViewModel.swift`: Copied to watch app ViewModels
- Midnight auto-refresh using Timer.publish
- ScrollView for responsive layout across watch sizes
- Color-coded tiers with emojis

**Files Created/Modified**:
- Modified: `apps/apple/CyberOracleWatch/CyberOracleWatch Watch App/Views/DailyLuckView.swift`
- Created: `apps/apple/CyberOracleWatch/CyberOracleWatch Watch App/ViewModels/DailyLuckViewModel.swift`

**Challenges Solved**:
- Layout overflow on smaller watch screens → Added ScrollView + reduced spacing/font sizes
- Missing ViewModel → Copied from CyberOracleAppShared to watch app target
- Added `.minimumScaleFactor(0.7)` for text adaptability

**Lessons Learned**:
- ViewModels need to be in watch app target, not just in shared package
- ScrollView essential for content that may overflow on smaller watches
- Test on different watch simulator sizes (38mm, 40mm, 41mm, 44mm, 45mm)

---

#### ✅ **Sprint 3: Decision Maker** (COMPLETE - 2025-12-27)

**What Was Built**:
- `DecisionView.swift`: 3-stage state machine with animations
- `ShakeDetector.swift`: CoreMotion accelerometer monitoring
- `HapticEngine.swift`: Centralized haptic feedback manager
- `DecisionViewModel.swift`: Copied to watch app ViewModels
- Simulator debug button (auto-hidden on real device)

**Files Created/Modified**:
- Modified: `apps/apple/CyberOracleWatch/CyberOracleWatch Watch App/Views/DecisionView.swift`
- Created: `apps/apple/CyberOracleWatch/CyberOracleWatch Watch App/Motion/ShakeDetector.swift`
- Created: `apps/apple/CyberOracleWatch/CyberOracleWatch Watch App/Haptics/HapticEngine.swift`
- Created: `apps/apple/CyberOracleWatch/CyberOracleWatch Watch App/ViewModels/DecisionViewModel.swift`

**Challenges Solved**:
- watchOS simulator doesn't support shake gestures → Added `#if targetEnvironment(simulator)` debug button
- Duplicate build files → Removed duplicates from Build Phases → Compile Sources
- Haptics on watchOS → Use WKInterfaceDevice.current().play() instead of UIKit's UINotificationFeedbackGenerator

**Lessons Learned**:
- Apple Watch simulator has NO shake support (unlike iPhone simulator)
- Use `#if targetEnvironment(simulator)` for debug-only UI elements
- CoreMotion works differently on watchOS - accelerometer data is available but shake gesture events are not
- WatchKit haptics are simpler than iOS Core Haptics (use built-in patterns)
- Always test motion/haptic features on real hardware for accurate experience

---

#### ✅ **Sprint 4: Fortune Sticks** (COMPLETE - 2025-12-27)

**What Was Built**:
- `FortuneView.swift`: 4-stage fortune-telling flow (359 lines)
- `FortuneStickViewModel.swift`: Copied to watch app ViewModels
- Complete integration with `fortune_levels.json` (5 fortune levels)
- Reused `ShakeDetector` and `HapticEngine` from Sprint 3
- Special effects for ULTRA and ERROR fortune levels

**Files Created/Modified**:
- Modified: `apps/apple/CyberOracleWatch/CyberOracleWatch Watch App/Views/FortuneView.swift`
- Created: `apps/apple/CyberOracleWatch/CyberOracleWatch Watch App/ViewModels/FortuneStickViewModel.swift`

**4-Stage Flow Implementation**:
1. **Idle**: Stick container (60x70) with 5 vertical sticks, shake intensity indicator, simulator button
2. **Shaking**: Vibrating container animation, 8 rapid collision haptics (0.1s intervals)
3. **Dropping**: Single stick drops with rotation (15°), drop haptic
4. **Revealed**: Fortune emoji + label + copy text + timestamp, tap to retry

**Fortune Levels** (from fortune_levels.json):
- ⚡ ULTRA (大吉) - Gold #FFD700 - Flash animation + double haptic
- 🟢 SUPER (中吉) - Neon green #00FF41
- 🔵 BASIC (小吉) - Blue #00A0FF
- 🟡 GLITCH (末吉/平) - Yellow #FFC107
- 🔴 ERROR (凶) - Red #FF2D55 - Glitch/shake effect

**Challenges Solved**:
- Layout overflow on small watch screens → Added ScrollView + reduced container size (80x100 → 60x70)
- File references broken after Xcode clean → Re-added all ViewModels/Motion/Haptics folders to project
- Missing simulator button → Made button more prominent with border and bold text
- Async warnings → Removed unnecessary `await` on @MainActor functions

**Lessons Learned**:
- Xcode Clean Build Folder can break file references - need to re-add files to project
- Watch screen size constraints require careful sizing (60-70pt height max for containers)
- ScrollView essential for content that varies in height across different stages
- Simulator button visibility critical - use borders and bold text, not just small gray text
- fortune_levels.json integration works perfectly for dynamic fortune content

---

#### **Sprint 5: Visual Polish** (Phase 6)
**Goal**: Apply cyberpunk theme

- Create `CyberTheme.swift` (color palette)
- Replace placeholder UI with neon colors
- Add visual effects (glow, glitch, grid background)
- Refine typography

**Files to Create**:
- `apps/apple/CyberOracleWatch/CyberOracleWatch Watch App/Design/CyberTheme.swift`
- `apps/apple/CyberOracleWatch/CyberOracleWatch Watch App/Design/Components/NeonText.swift`
- `apps/apple/CyberOracleWatch/CyberOracleWatch Watch App/Design/Effects/BackgroundEffects.swift`

**Validation**: App looks like PRD mockups

---

#### **Sprint 6: Sound & Final Polish** (Phase 7)
**Goal**: Audio feedback + bug fixes

- Add sound effects (success/error tones)
- Refine haptic patterns
- Performance optimization
- Bug fixes

**Files to Create**:
- `apps/apple/CyberOracleWatch/CyberOracleWatch Watch App/Audio/SoundEngine.swift`
- `apps/apple/CyberOracleWatch/CyberOracleWatch Watch App/Resources/Sounds/*.mp3`

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
