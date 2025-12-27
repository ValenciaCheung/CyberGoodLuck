# Xcode Project Setup Instructions - Sprint 1

## Overview

This guide walks you through creating the Xcode watchOS project for CyberGoodLuck. All Swift source files have been created - you just need to create the Xcode project and add them.

---

## Step 1: Create watchOS App Project

1. **Open Xcode**

   - Launch Xcode (ensure you have Xcode 15+ for watchOS 10 support)

2. **Create New Project**

   - File → New → Project (⇧⌘N)
   - Select **watchOS** tab
   - Choose **App** template
   - Click **Next**

3. **Configure Project**

   - **Product Name**: `CyberOracleWatch`
   - **Team**: Select your development team
   - **Organization Identifier**: Your bundle ID (e.g., `com.yourname`)
   - **Bundle Identifier**: Will be `com.yourname.CyberOracleWatch`
   - **Interface**: **SwiftUI**
   - **Language**: **Swift**
   - Click **Next**

4. **Save Location**

   - Navigate to: `/Users/binqiaowang/Desktop/ZT-GoodLuck/CyberGoodLuck/apps/apple/`
   - **Important**: Uncheck "Create Git repository" (already have one)
   - Click **Create**

   This will create a folder structure like:

   ```
   apps/apple/CyberOracleWatch/
     CyberOracleWatch Watch App/
       CyberOracleWatchApp.swift
       ContentView.swift
       Assets.xcassets/
       Preview Content/
     CyberOracleWatch.xcodeproj
   ```

---

## Step 2: Add Local Swift Package (CyberOracleCore)

1. **Open Project Settings**

   - Click on the project name in the navigator (blue icon)
   - Select the **CyberOracleWatch Watch App** target

2. **Add Package Dependency**

   - Go to **General** tab
   - Scroll to **Frameworks, Libraries, and Embedded Content**
   - Click the **+** button at the bottom
   - Select **Add Package Dependency...**

3. **Add Local Package**

   - In the search bar, click **Add Local...**
   - Navigate to: `/Users/binqiaowang/Desktop/ZT-GoodLuck/CyberGoodLuck/packages/CyberOracleCore`
   - Click **Add Package**

4. **Select Products**

   - Check both:
     - ✅ **CyberOracleDomain**
     - ✅ **CyberOracleData**
   - Click **Add Package**

5. **Verify**
   - You should now see `CyberOracleCore` under **Package Dependencies** in the project navigator

---

## Step 3: Replace Generated Files with Custom Files

The Xcode project template creates default files. We need to replace them with our custom implementation.

### 3.1 Replace App Entry Point

1. **Delete Default File**

   - In the project navigator, find `CyberOracleWatchApp.swift` (the one Xcode created)
   - Right-click → **Delete**
   - Choose **Move to Trash**

2. **Add Our Custom File**
   - Right-click on `CyberOracleWatch Watch App` folder
   - **Add Files to "CyberOracleWatch"...**
   - Navigate to: `/Users/binqiaowang/Desktop/ZT-GoodLuck/CyberGoodLuck/apps/apple/CyberOracleWatchApp/`
   - Select `CyberOracleWatchApp.swift`
   - **Important**: Check "Copy items if needed"
   - **Important**: Ensure target `CyberOracleWatch Watch App` is checked
   - Click **Add**

### 3.2 Delete Default ContentView

1. **Delete ContentView.swift**
   - Find `ContentView.swift` in project navigator
   - Right-click → **Delete**
   - Choose **Move to Trash**

### 3.3 Add Navigation and Views

1. **Create Groups (Folders)**

   - Right-click on `CyberOracleWatch Watch App`
   - **New Group** → Name it `Navigation`
   - **New Group** → Name it `Views`

2. **Add Navigation File**

   - Right-click on `Navigation` folder
   - **Add Files to "CyberOracleWatch"...**
   - Navigate to: `/Users/binqiaowang/Desktop/ZT-GoodLuck/CyberGoodLuck/apps/apple/CyberOracleWatchApp/Navigation/`
   - Select `RootNavigationView.swift`
   - Check "Copy items if needed"
   - Check target `CyberOracleWatch Watch App`
   - Click **Add**

3. **Add View Files**
   - Right-click on `Views` folder
   - **Add Files to "CyberOracleWatch"...**
   - Navigate to: `/Users/binqiaowang/Desktop/ZT-GoodLuck/CyberGoodLuck/apps/apple/CyberOracleWatchApp/Views/`
   - Select all 4 files:
     - `HomeView.swift`
     - `DailyLuckView.swift`
     - `DecisionView.swift`
     - `FortuneView.swift`
   - Check "Copy items if needed"
   - Check target `CyberOracleWatch Watch App`
   - Click **Add**

---

## Step 4: Add Missing Import

The custom files need access to `AppEnvironment` from the shared layer.

1. **Add AppEnvironment Import**

   - Since `AppEnvironment` is in `CyberOracleAppShared` but we're using it directly, we need to either:

     **Option A (Quick)**: Add `AppEnvironment.swift` to the watch app target

     - Navigate to: `/Users/binqiaowang/Desktop/ZT-GoodLuck/CyberGoodLuck/apps/apple/CyberOracleAppShared/`
     - Add `AppEnvironment.swift` to the project (don't copy, just reference)

     **Option B (Better)**: Import from package

     - The file already imports `CyberOracleData`, and `AppEnvironment` should be accessible
     - If not, add this to the top of `CyberOracleWatchApp.swift`:
       ```swift
       import CyberOracleDomain
       ```

---

## Step 5: Build and Run

1. **Select Simulator or Device**

   - In the scheme selector (top bar), choose:
     - **Apple Watch Series 9 (45mm)** simulator, or
     - Your physical Apple Watch (if connected)

2. **Build Project**

   - Press **⌘B** to build
   - Fix any build errors if they appear

3. **Run Project**

   - Press **⌘R** to run
   - The app should launch on the watch simulator/device

4. **Test Navigation**
   - Swipe left/right to navigate between screens
   - You should see 4 screens:
     1. **Home**: Cyberpunk time/date display
     2. **Daily Luck**: Placeholder (Sprint 2)
     3. **Decision**: Placeholder (Sprint 3)
     4. **Fortune**: Placeholder (Sprint 4)

---

## Expected Project Structure

After setup, your Xcode project should look like:

```
CyberOracleWatch Watch App/
  ├── CyberOracleWatchApp.swift        (main entry point)
  ├── Navigation/
  │   └── RootNavigationView.swift     (tab navigation)
  ├── Views/
  │   ├── HomeView.swift               (time HUD - implemented)
  │   ├── DailyLuckView.swift          (placeholder)
  │   ├── DecisionView.swift           (placeholder)
  │   └── FortuneView.swift            (placeholder)
  ├── Assets.xcassets/
  └── Preview Content/

Package Dependencies/
  └── CyberOracleCore/
      ├── CyberOracleDomain
      └── CyberOracleData
```

---

## Troubleshooting

### Build Error: "Cannot find 'AppEnvironment' in scope"

**Solution**: Add `AppEnvironment.swift` from `apps/apple/CyberOracleAppShared/` to the watch app target:

1. Find the file in Finder: `apps/apple/CyberOracleAppShared/AppEnvironment.swift`
2. Drag it into Xcode under `CyberOracleWatch Watch App`
3. **Important**: Uncheck "Copy items if needed" (we want to reference, not duplicate)
4. Check target `CyberOracleWatch Watch App`
5. Rebuild

### Build Error: "No such module 'CyberOracleData'"

**Solution**: Verify package was added correctly:

1. Project navigator → Click project icon
2. Select `CyberOracleWatch Watch App` target
3. Go to **General** → **Frameworks, Libraries, and Embedded Content**
4. Ensure `CyberOracleData` and `CyberOracleDomain` are listed
5. If not, add them via **+** button → **Add Other...** → **Add Package Dependency...**

### Simulator Shows Black Screen

**Solution**: Check that `RootNavigationView` is set as the root view:

1. Open `CyberOracleWatchApp.swift`
2. Verify `body` contains:
   ```swift
   WindowGroup {
       RootNavigationView()
           .environmentObject(env)
   }
   ```

### Navigation Not Working (Can't Swipe)

**Solution**: TabView with page style should work automatically on watchOS. Verify:

1. Open `RootNavigationView.swift`
2. Check that `.tabViewStyle(.page)` is applied
3. Try swiping slowly from edge of screen

---

## Next Steps (After Setup)

Once the project builds and runs successfully:

✅ **Sprint 1 Complete!** You have:

- Working Xcode watchOS project
- CyberOracleCore package linked
- Navigation between 4 screens
- HomeView displaying time/date in cyberpunk style

🎯 **Ready for Sprint 2**: Implement Daily Luck view with real data

---

## Alternative: Use xcodegen (Advanced)

If you prefer automation, you can use `xcodegen` to generate the project from a spec file. This is optional and more advanced.

Would you like instructions for this approach?

---

**Questions?** Refer to `CLAUDE.md` for project context or check the PRD at `docs/PRD-CyberOracle.md`.

**Note**: The project name is CyberGoodLuck, but the code uses `CyberOracle` as the package/class prefix for brevity.
