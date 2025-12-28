# CyberGoodLuck - Project Context & Implementation Guide

> **Last Updated**: 2025-12-27
> **Status**: Sprint 5 In Progress 🚧 - Asset Integration & Visual Polish
> **Target Platform**: Apple Watch (watchOS 10+), scalable to iPhone
> **Latest Commit**: Sprint 5 Phase 1 - Asset preparation (21 PNGs + 3 MP4s)

---

## 🎯 Project Overview

**CyberGoodLuck (赛博好运求签)** is a Japanese folk art-styled fortune-telling and decision-making Apple Watch app combining:
- **Daily Luck**: 4-metric personal fortune (Love/Money/Career/Health)
- **Decision Maker**: Yes/No coin flip with shake gesture
- **Fortune Sticks**: Traditional Chinese divination (求签) with 5-tier fortune levels
- **Japanese Folk Art UI**: Bold black outlines, high-contrast flat vector illustration, traditional color palette

**Core Experience**: Wrist-raise → Swipe → Shake → Feel haptic feedback → See Japanese woodblock-inspired visuals

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
  - ✅ Japanese folk art colors: vermillion red, indigo blue
  - ✅ Bold black outlines
  - ✅ High-contrast backgrounds

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

### What's In Progress

🚧 **Sprint 5: Asset Integration** - Replacing placeholder UI with pre-rendered Japanese folk art assets (21 PNGs + 3 MP4 transition videos)

### What's Upcoming

❌ **Sprint 6: Sound effects** - Audio feedback + final polish

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

## 🎨 Design System (Japanese Folk Art Style)

### Color Palette
```swift
// Primary colors - Traditional Japanese palette
#000000  // Bold black outlines (key feature)
#D84236  // Vermillion red (朱色 Shu-iro) - primary accent
#165E83  // Indigo blue (藍色 Ai-iro) - secondary
#C89932  // Gold ochre (黄土色 Oudo-iro) - highlights
#F8F4E6  // Off-white (生成 Kinari) - background
#D7003A  // Deep red (紅色 Beni-iro) - emphasis

// Fortune level colors (high-contrast with black outlines)
#FFD700  // ULTRA (gold) - with bold black outline
#D84236  // SUPER (vermillion) - with bold black outline
#165E83  // BASIC (indigo) - with bold black outline
#C89932  // GLITCH (ochre) - with bold black outline
#D7003A  // ERROR (deep red) - with bold black outline
```

### Visual Style
- **Reference**: Japanese woodblock prints (ukiyo-e), modern flat vector illustration, bold manga outlines
- **Effects**: Bold black strokes (2-3pt), flat color fills, high-contrast compositions
- **Typography**: Clean sans-serif or traditional Japanese-inspired fonts with strong weight

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

### Completed Sprints (1-4) ✅

**Sprint 1: Foundation** - Xcode project, navigation, HomeView with real-time clock
**Sprint 2: Daily Luck** - 4-metric grid, midnight refresh, responsive layout
**Sprint 3: Decision Maker** - 3-stage state machine, shake detection, haptics
**Sprint 4: Fortune Sticks** - 4-stage flow, 5 fortune levels, placeholder UI

**Key Files Created**:
- `Views/`: HomeView, DailyLuckView, DecisionView, FortuneView (all functional)
- `ViewModels/`: DailyLuckViewModel, DecisionViewModel, FortuneStickViewModel
- `Motion/ShakeDetector.swift` - CoreMotion accelerometer integration
- `Haptics/HapticEngine.swift` - Centralized haptic feedback

---

### 🚧 Sprint 5: Asset Integration & Visual Polish (IN PROGRESS)

**Goal**: Replace placeholder UI with pre-rendered Japanese folk art assets

#### Asset Inventory

**21 Static PNGs** (~3.5MB):
- PNG 13-16: Core UI states (idle, postshake, decorated, answer)
- PNG 17-21: Fortune categories (ULTRA/SUPER/BASIC/GLITCH/ERROR)
- PNG 22-26: Intermediate results (1:1 mapped to categories)
- PNG 27-28: Daruma transition screens
- PNG 29-33: Final fortune results (randomly selected)

**3 Transition Videos** (~15MB):
- `fortune_shake_transition.mp4`: PNG 13 → 14 (2s)
- `fortune_container_to_answer.mp4`: PNG 15 → 16 (2s)
- `fortune_daruma_transition.mp4`: PNG 27 → 28 (2s)

#### Complete 12-Stage Flow

```
1. idle (PNG 13) → "Shake" prompt
2. shakeTransition (Video) → Fortune shake animation
3. postShake (PNG 14) → Container without text
4. decoratedShake (PNG 15) → 8x collision haptics
5. containerToAnswer (Video) → Container transition
6. answerScreen (PNG 16) → "answer" screen + API call
7. categoryReveal (PNG 17-21) → Fortune category by level
8. intermediateResult (PNG 22-26) → 1:1 mapped result
9. daruma1 (PNG 27) → First Daruma screen
10. darumaTransition (Video) → Daruma animation
11. daruma2 (PNG 28) → Second Daruma screen
12. finalResult (PNG 29-33) → Random final + haptic

Total flow: ~10-12 seconds
```

#### Implementation Phases (7 Total)

**✅ Phase 1: Asset Preparation** (COMPLETE)
- [x] Created Fortune folder structure in Assets.xcassets
- [x] Created 21 image sets with proper naming
- [x] Copied all PNGs into imagesets
- [x] Created Resources/Videos directory
- [x] Copied and renamed 3 MP4 files
- [ ] Add Resources folder to Xcode project (requires IDE)
- [ ] Verify target membership and build

**Phase 2: Video Player Component** (Pending)
- Create `VideoPlayerView.swift` with AVPlayer
- Auto-play on appear, detect completion via NotificationCenter
- Error handling and fallback
- Test video playback on simulator

**Phase 3: State Machine Refactor** (Pending)
- Replace `UIState` → `FortuneFlowState` enum (12 cases)
- Add state variables: flowState, selectedFortuneLevel, selectedFinalIndex
- Refactor body switch statement (12 cases)
- Implement 9 state transition functions
- Add image name mapping functions

**Phase 4: Video Integration** (Pending)
- Replace video state stubs with VideoPlayerView
- Test 12-stage flow on simulator
- Verify smooth transitions PNG → Video → PNG

**Phase 5: Haptic Integration** (Pending)
- Relocate shake haptics to decoratedShake state
- Fortune reveal haptic in finalResult state
- Remove old haptic code

**Phase 6: Polish & Optimization** (Pending)
- Performance testing on different watch sizes
- Asset optimization (compress PNGs if needed)
- Edge case testing

**Phase 7: Testing & Validation** (Pending)
- Complete 10+ fortune draws on real device
- Verify all 5 fortune levels
- Verify 1:1 mapping and random selection
- Regression testing

#### Critical Files to Modify

**FortuneView.swift** - Complete refactor with 12-stage flow (~400-450 lines)
**VideoPlayerView.swift** (NEW) - Reusable MP4 player component (~80-100 lines)
**Assets.xcassets/Fortune/** - 21 image sets organized in subfolders
**Resources/Videos/** - 3 renamed MP4 files

#### Potential Issues

1. **Video Playback Performance**: May need preloading or re-encoding at lower bitrate
2. **Bundle Size**: +18.5MB (target <200MB for App Store)
3. **Video Completion Detection**: Timeout fallback if NotificationCenter fails
4. **State Machine Complexity**: 12 states with async transitions - requires careful testing

---

### Sprint 6: Sound & Final Polish (UPCOMING)

**Goal**: Audio feedback + final polish

- Add sound effects (success/error tones)
- Refine haptic patterns
- Performance optimization
- Bug fixes

**Files to Create**:
- `Audio/SoundEngine.swift`
- `Resources/Sounds/*.mp3`

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

### Current Work (Sprint 5)
```
apps/apple/CyberOracleWatch/CyberOracleWatch Watch App/
  Assets.xcassets/
    Fortune/                    # ✅ Created - 21 imagesets
  Resources/
    Videos/                     # ✅ Created - 3 MP4 files
  Components/
    VideoPlayerView.swift       # TODO - Phase 2
  Views/
    FortuneView.swift           # TODO - Refactor to 12-stage flow
```

### Future Work (Sprint 6)
```
apps/apple/CyberOracleWatch/CyberOracleWatch Watch App/
  Audio/
    SoundEngine.swift
  Resources/
    Sounds/*.mp3
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

### Home Screen (Japanese Time Display)
- **Display**: Year/month, date, time (bold with black outlines)
- **Background**: High-contrast traditional pattern or solid color
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
- **Stage 1 (Shake)**: Bold-outlined cylinder container + shake prompt
- **Stage 2 (Haptics)**: "哗啦哗啦" collision feedback
- **Stage 3 (Drop)**: One stick falls with flat vector styling
- **Stage 4 (Reveal)**: Flip animation → fortune level + copy text (high-contrast colors with black outlines)

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

1. **Sprints 1-4 Complete** - All core features functional with placeholder UI
2. **Sprint 5 In Progress** - Integrating 21 PNGs + 3 MP4s for Japanese folk art visuals
3. **12-Stage Flow** - Replacing 4-stage placeholder with complex animation sequence
4. **Video Playback** - Using AVPlayer for MP4 transitions on watchOS
5. **Offline-first** - Using `LocalOracleService`, backend optional
6. **Test on real device** - Haptics/motion/video require physical Apple Watch

---

**Current Status**: Phase 1 (Asset Preparation) complete. Next: Phase 2 (VideoPlayerView component).
