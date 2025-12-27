# Xcode Project Setup - Quick Start

All Swift files are ready! Follow these steps to create the Xcode project.

## Quick Steps

### 1️⃣ Create Project in Xcode
```
File → New → Project → watchOS → App
Name: CyberOracleWatch
Interface: SwiftUI
Save to: /Users/binqiaowang/Desktop/ZT-GoodLuck/CyberGoodLuck/apps/apple/
```

### 2️⃣ Add Local Package
```
Project Settings → General → Frameworks
Click + → Add Package Dependency → Add Local
Select: packages/CyberOracleCore
Add both: CyberOracleDomain + CyberOracleData
```

### 3️⃣ Add Source Files
Navigate to Xcode project, then drag these folders from Finder:
```
apps/apple/CyberOracleWatchApp/
  ├── AppEnvironment.swift          ← Drag to project root
  ├── CyberOracleWatchApp.swift     ← Replace Xcode's version
  ├── Navigation/                   ← Drag entire folder
  └── Views/                        ← Drag entire folder
```

**Important**:
- When dragging, CHECK "Copy items if needed"
- CHECK target "CyberOracleWatch Watch App"
- Delete Xcode's default `ContentView.swift`

### 4️⃣ Build & Run
```
⌘B to build
⌘R to run on Apple Watch simulator
```

## File Manifest

All these files are ready in `apps/apple/CyberOracleWatchApp/`:

✅ `AppEnvironment.swift` - Dependency injection container
✅ `CyberOracleWatchApp.swift` - App entry point
✅ `Navigation/RootNavigationView.swift` - Tab navigation
✅ `Views/HomeView.swift` - Time HUD (fully implemented)
✅ `Views/DailyLuckView.swift` - Placeholder for Sprint 2
✅ `Views/DecisionView.swift` - Placeholder for Sprint 3
✅ `Views/FortuneView.swift` - Placeholder for Sprint 4

## Expected Result

Swipe between 4 screens:
1. **Home** - Cyberpunk clock (working! neon green/cyan)
2. **Daily Luck** - "Coming in Sprint 2"
3. **Decision** - "Coming in Sprint 3"
4. **Fortune** - "Coming in Sprint 4"

## Need Help?

See full instructions: `docs/Xcode-Project-Setup.md`
