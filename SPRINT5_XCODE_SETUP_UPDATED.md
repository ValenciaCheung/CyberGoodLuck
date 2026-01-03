# Sprint 5: Xcode Manual Setup Steps (UPDATED - PRD v1.0)

## ✅ Code Implementation Required

Based on PRD v1.0 "Daily Luck Core Flow", the following changes are needed:
- ✅ DecisionView.swift - Updated with 3 image replacements
- 🔄 DailyLuckView.swift - Complete rewrite with 5-phase flow (PRD v1.0)
- 🔄 HapticEngine.swift - Add coin collision and level-specific haptics
- 🆕 Loading animation component (3-dot blinking)
- 🆕 Watch Face integration (ClockKit)

## 🎨 New Daily Luck Core Flow (PRD v1.0 - 5 Phases)

1. **Opening** → Praying Hands animation on entry
2. **Shake Screen** → `01.png` (Praying hands + 1s shake prompt)
   - Accelerometer detection
   - **Fallback**: Tap after 2 seconds
3. **Coin Transition** → `05.png` (Ten Million Ryo coin)
   - 3-dot blinking loading animation (0.5s)
   - Coin "slaps" onto screen with sound
4. **Result Display** → Vertical scrollable list (4 dimension cards)
   - Dimensions: Love, Wealth, Health, Career
   - 4 Status Levels: Super Lucky, Good Luck, Average, Bad Luck
   - Lucky Cat 2-frame PNG loops (1000ms)
   - Scroll hint: 30% of 3rd card visible
   - Asset references: `36-43.png` (result cards and backgrounds)
5. **Watch Face** → `02.png` (Lucky Cat Holding Gold Brick)
   - "Set as Today's Watch Face" button at bottom

---

## 🔧 Manual Steps Required in Xcode

### Step 1: Add Assets to Assets.xcassets

Open Xcode and navigate to:
```
CyberOracleWatch Watch App → Assets.xcassets
```

#### Create Decision Maker Assets (3 imagesets)

1. **Create "Decision" Folder**:
   - Right-click Assets.xcassets → New Folder → Name it "Decision"

2. **Add DM_Daruma.imageset**:
   - Right-click "Decision" folder → New Image Set → Name it "DM_Daruma"
   - Drag `assets/Decision Maker/Apple Watch Series 10 42mm - 08.png` to the @2x slot

3. **Add DM_YesCoin.imageset**:
   - Right-click "Decision" folder → New Image Set → Name it "DM_YesCoin"
   - Drag `assets/Decision Maker/Apple Watch Series 10 42mm - 10.png` to the @2x slot

4. **Add DM_NoCoin.imageset**:
   - Right-click "Decision" folder → New Image Set → Name it "DM_NoCoin"
   - Drag `assets/Decision Maker/Apple Watch Series 10 42mm - 11.png` to the @2x slot

---

#### Create Daily Luck Assets (10 imagesets)

1. **Create "DailyLuck" Folder**:
   - Right-click Assets.xcassets → New Folder → Name it "DailyLuck"

2. **Add Phase Images**:

   **DL_Prayer.imageset** (Phase 1):
   - Right-click "DailyLuck" folder → New Image Set → Name it "DL_Prayer"
   - Drag `assets/Daily Luck HUD/Apple Watch Series 10 42mm - 01.png` to @2x slot

   **DL_Coin.imageset** (Phase 3):
   - Right-click "DailyLuck" folder → New Image Set → Name it "DL_Coin"
   - Drag `assets/Daily Luck HUD/Apple Watch Series 10 42mm - 05.png` to @2x slot

   **DL_ResultBackground.imageset** (Phase 4 background):
   - Right-click "DailyLuck" folder → New Image Set → Name it "DL_ResultBackground"
   - Drag `assets/Daily Luck HUD/Apple Watch Series 10 42mm - 06.1.png` to @2x slot

3. **Add Tier Cat Images** (3 images):

   **DL_TierGreat.imageset** (Tier 1 - 极好):
   - Right-click "DailyLuck" folder → New Image Set → Name it "DL_TierGreat"
   - Drag `assets/Daily Luck HUD/Group-2.png` to @2x slot

   **DL_TierGood.imageset** (Tier 2 - 尚可):
   - Right-click "DailyLuck" folder → New Image Set → Name it "DL_TierGood"
   - Drag `assets/Daily Luck HUD/Group-1.png` to @2x slot

   **DL_TierBad.imageset** (Tier 3 - 较差):
   - Right-click "DailyLuck" folder → New Image Set → Name it "DL_TierBad"
   - Drag `assets/Daily Luck HUD/Group.png` to @2x slot

4. **Add Metric Icon Images** (4 images):

   **DL_IconLove.imageset** (Love - heart):
   - Right-click "DailyLuck" folder → New Image Set → Name it "DL_IconLove"
   - Drag `assets/Daily Luck HUD/Image-3.png` to @2x slot

   **DL_IconWealth.imageset** (Wealth - coins):
   - Right-click "DailyLuck" folder → New Image Set → Name it "DL_IconWealth"
   - Drag `assets/Daily Luck HUD/Image-2.png` to @2x slot

   **DL_IconCareer.imageset** (Career - briefcase):
   - Right-click "DailyLuck" folder → New Image Set → Name it "DL_IconCareer"
   - Drag `assets/Daily Luck HUD/Image.png` to @2x slot

   **DL_IconHealth.imageset** (Health - medical):
   - Right-click "DailyLuck" folder → New Image Set → Name it "DL_IconHealth"
   - Drag `assets/Daily Luck HUD/Image-1.png` to @2x slot

---

**Complete Assets Structure**:
```
Assets.xcassets/
├── AccentColor (existing)
├── AppIcon (existing)
├── Decision/
│   ├── DM_Daruma.imageset/
│   ├── DM_YesCoin.imageset/
│   └── DM_NoCoin.imageset/
└── DailyLuck/
    ├── DL_Prayer.imageset/           (01.png)
    ├── DL_Coin.imageset/              (05.png)
    ├── DL_ResultBackground.imageset/  (06.1.png)
    ├── DL_TierGreat.imageset/         (Group-2.png)
    ├── DL_TierGood.imageset/          (Group-1.png)
    ├── DL_TierBad.imageset/           (Group.png)
    ├── DL_IconLove.imageset/          (Image-3.png)
    ├── DL_IconWealth.imageset/        (Image-2.png)
    ├── DL_IconCareer.imageset/        (Image.png)
    └── DL_IconHealth.imageset/        (Image-1.png)
```

**Total**: 13 imagesets (3 Decision + 10 Daily Luck)

---

### Step 2: Add New Files to Xcode Project

#### Add Resources Folder with Video

1. In Xcode Project Navigator, right-click on "CyberOracleWatch Watch App"
2. Select "Add Files to 'CyberOracleWatch'..."
3. Navigate to: `apps/apple/CyberOracleWatch/CyberOracleWatch Watch App/Resources/`
4. Select the **Resources** folder
5. **IMPORTANT**: Choose "Create folder references" (Blue folder, NOT yellow group)
6. Ensure "CyberOracleWatch Watch App" target is checked
7. Click "Add"

#### Add Utilities Folder

1. In Xcode Project Navigator, right-click on "CyberOracleWatch Watch App"
2. Select "Add Files to 'CyberOracleWatch'..."
3. Navigate to: `apps/apple/CyberOracleWatch/CyberOracleWatch Watch App/Utilities/`
4. Select the **Utilities** folder
5. Choose "Create groups" (Yellow folder)
6. Ensure "CyberOracleWatch Watch App" target is checked
7. Click "Add"

---

### Step 3: Verify Build Phases

1. Select the "CyberOracleWatch Watch App" target
2. Go to "Build Phases" tab
3. Expand "Copy Bundle Resources"
4. Verify the following files are present:
   - ✅ `jimeng-2025-12-27-8243.mp4` (should be under Resources folder)
   - ✅ All .imageset folders from Assets.xcassets

If the MP4 video is NOT listed:
1. Click "+" button under "Copy Bundle Resources"
2. Navigate to Resources folder
3. Add `jimeng-2025-12-27-8243.mp4`

---

### Step 4: Build and Test

#### Build the Project

1. Select "CyberOracleWatch Watch App" scheme
2. Choose "Apple Watch Series 9 (45mm)" simulator (or any watch simulator)
3. Press **Cmd+B** to build
4. Fix any build errors if they appear

**Common Build Issues**:

- **"Cannot find 'DM_Daruma' in scope"**: Assets not added correctly to Assets.xcassets
- **"Cannot find 'DL_TierGreat' in scope"**: Tier cat images not added
- **"Cannot find 'VideoPlayerHelper' in scope"**: Utilities folder not added to project
- **Video file not found**: Resources folder not added with "folder references"

#### Test Decision Maker

1. Run the app (Cmd+R)
2. Navigate to Decision Maker (swipe left/right)
3. Click simulator "TAP (Simulator)" button
4. **Expected Behavior**:
   - Prayer: Daruma doll visible (not 🙏 emoji)
   - Tossing: Coin rotates (not 💫 emoji)
   - Result: YES or NO coin visible (not ✅/❌ emojis)
   - Tap to retry works

#### Test Daily Luck (4-Phase Flow)

1. Navigate to Daily Luck screen
2. Click simulator "TAP (Simulator)" button
3. **Expected Behavior**:
   - **Phase 1 - Prayer**: Prayer hands image visible
   - **Phase 2 - Animating**: Video plays with "Checking your luck..." text
   - **Phase 3 - Coin**: "千万两" coin appears with bounce animation (1.5s)
   - **Phase 4 - Result**: 2x2 grid shows:
     - Background with "Love, Wealth, Career, Health" labels
     - Each cell has a tier cat (happy/neutral/sad)
     - Each cell has a metric icon in bottom-right corner
   - Haptics occur during video (can't feel in simulator)
   - Tap to retry returns to prayer screen

**Note**: Video playback may be slow on simulator. Test on real device for accurate performance.

---

### Step 5: Real Device Testing (Optional but Recommended)

For best results, test on an actual Apple Watch:

1. Connect Apple Watch to Mac
2. Select your watch as deployment target
3. Build and run
4. **Test shake gestures** (simulator can't test this)
5. **Feel haptic feedback** (simulator can't test this)
6. **Verify video performance** (smoother on device)
7. **Check 2x2 grid layout** (ensure cats and icons align properly)

---

## 📋 Testing Checklist

### Decision Maker Tests
- [ ] Prayer screen shows Daruma doll (not emoji)
- [ ] Shake intensity bars work in simulator
- [ ] Tap button triggers toss animation
- [ ] Coin rotates during toss (not emoji)
- [ ] Result shows YES/NO coin (not emoji)
- [ ] Haptics play (success/failure) - device only
- [ ] Tap to retry returns to prayer

### Daily Luck Tests (PRD v1.0 - 5-Phase Flow)
- [ ] **Opening**: Praying hands animation displays on entry
- [ ] **Shake Screen**: 1s animation prompts shake
- [ ] **Shake Screen**: Accelerometer detects shake gesture
- [ ] **Shake Screen**: Tap fallback works after 2 seconds
- [ ] **Haptics**: Coin collision simulation during shake (continuous, crisp)
- [ ] **Coin Transition**: Ten Million Ryo coin page displays
- [ ] **Coin Transition**: 3-dot loading animation (0.5s)
- [ ] **Coin Transition**: Coin "slaps" onto screen with sound
- [ ] **Result**: Vertical scrollable list with 4 dimension cards
- [ ] **Result**: Love, Wealth, Health, Career cards display
- [ ] **Result**: 4 status levels show (Super Lucky/Good Luck/Average/Bad Luck)
- [ ] **Result**: Lucky Cat 2-frame loop animation (1000ms)
- [ ] **Result**: Scroll hint - 30% of 3rd card (Health) visible
- [ ] **Haptics - Super Lucky**: Heavy Impact x2 plays
- [ ] **Haptics - Bad Luck**: Heavy Impact x1 (low freq) plays
- [ ] **Watch Face**: "Set as Today's Watch Face" button at bottom
- [ ] **Watch Face**: Button triggers watch face picker
- [ ] Midnight refresh still works (change system time)

### Cross-Device Tests
- [ ] Test on 38mm simulator
- [ ] Test on 42mm simulator
- [ ] Test on 45mm simulator
- [ ] No layout overflow
- [ ] Assets scale properly
- [ ] 2x2 grid aligns on all watch sizes

---

## 🎨 Asset Mapping Reference

### Daily Luck Assets

| Asset Name | File | Purpose |
|------------|------|---------|
| DL_Prayer | 01.png | Phase 1: Prayer hands |
| DL_Coin | 05.png | Phase 3: 千万两 coin |
| DL_ResultBackground | 06.1.png | Phase 4: Red background with labels |

### Tier Cat Images (Phase 4)

| Asset Name | File | Tier | Expression |
|------------|------|------|-----------|
| DL_TierGreat | Group-2.png | Tier 1 极好 | Happy cat 🤩 |
| DL_TierGood | Group-1.png | Tier 2 尚可 | Neutral cat 🙂 |
| DL_TierBad | Group.png | Tier 3 较差 | Sad cat 😵 |

### Metric Icons (Phase 4 - Bottom-Right Corner)

| Asset Name | File | Metric | Icon |
|------------|------|--------|------|
| DL_IconLove | Image-3.png | Love | ❤️ Heart |
| DL_IconWealth | Image-2.png | Money/Wealth | 💰 Coins |
| DL_IconCareer | Image.png | Career | 💼 Briefcase |
| DL_IconHealth | Image-1.png | Health | 🏥 Medical |

### 2x2 Grid Layout

```
┌─────────────┬─────────────┐
│ Love        │ Wealth      │  ← Labels from background
│ [Tier Cat]  │ [Tier Cat]  │  ← Tier image (happy/neutral/sad)
│         ❤️  │         💰  │  ← Metric icon (bottom-right)
├─────────────┼─────────────┤
│ Career      │ Health      │
│ [Tier Cat]  │ [Tier Cat]  │
│         💼  │         🏥  │
└─────────────┴─────────────┘
```

---

## 🐛 Troubleshooting

### Images Not Showing
**Problem**: White squares or missing images
**Solution**:
1. Check Assets.xcassets has correct folder structure
2. Verify image names match exactly (case-sensitive)
3. Ensure images are in @2x slot
4. Clean build folder (Cmd+Shift+K) and rebuild

### Tier Cats Not Displaying
**Problem**: 2x2 grid cells are empty
**Solution**:
1. Verify `DL_TierGreat`, `DL_TierGood`, `DL_TierBad` are added
2. Check that Group-2.png, Group-1.png, Group.png are in @2x slots
3. Rebuild project

### Metric Icons Not Showing
**Problem**: No icons in bottom-right corners
**Solution**:
1. Verify all 4 icon imagesets are added (DL_IconLove, etc.)
2. Check Image-3.png, Image-2.png, Image.png, Image-1.png in @2x slots
3. Icons may be too small - adjust `.frame(width: 20, height: 20)` in code

### Video Not Playing
**Problem**: Black screen during animation phase
**Solution**:
1. Verify Resources folder added as "folder references" (blue)
2. Check Build Phases → Copy Bundle Resources includes MP4
3. Verify video file name: `jimeng-2025-12-27-8243.mp4`

### Coin Not Appearing
**Problem**: Phase 3 skipped or shows error
**Solution**:
1. Verify `DL_Coin` imageset added with 05.png
2. Check that coin bounce animation plays (should scale from 0.5 to 1.0)

---

## 📝 Summary

**Files Modified**: 4 Swift files
**Files Created**: 2 new files (VideoPlayerHelper, MP4 video copied)
**Manual Steps**: 13 imagesets + 2 folders to add in Xcode
**Estimated Time**: 20-25 minutes for Xcode setup

**New 4-Phase Flow**:
1. Prayer hands (shake to start)
2. Maneki-neko video animation (with haptics)
3. 千万两 coin reveal (bounce animation, 1.5s)
4. 2x2 result grid (tier cats + metric icons)

Once complete, you'll have:
- ✅ Decision Maker with Japanese folk art coins and Daruma
- ✅ Daily Luck with 4-phase interactive flow
- ✅ Tier-based cat expressions (happy/neutral/sad)
- ✅ Metric-specific icons for each category
- ✅ Both features fully interactive with haptics
- ✅ Ready for Sprint 6 (Sound effects)

Good luck! 🎌
