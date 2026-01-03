# Sprint 5: Xcode Manual Setup Steps

> **Note**: See `SPRINT5_XCODE_SETUP_UPDATED.md` for the latest PRD v1.0 requirements.

## ✅ Code Implementation Required

Based on PRD v1.0 "Daily Luck Core Flow":
- ✅ DecisionView.swift - Updated with 3 image replacements
- 🔄 DailyLuckView.swift - Needs rewrite for 5-phase flow (PRD v1.0)
- 🔄 HapticEngine.swift - Add coin collision and level-specific haptics

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
   - **Important**: Rename the file to `DM_Daruma@2x.png` when adding

3. **Add DM_YesCoin.imageset**:
   - Right-click "Decision" folder → New Image Set → Name it "DM_YesCoin"
   - Drag `assets/Decision Maker/Apple Watch Series 10 42mm - 10.png` to the @2x slot
   - Rename to `DM_YesCoin@2x.png`

4. **Add DM_NoCoin.imageset**:
   - Right-click "Decision" folder → New Image Set → Name it "DM_NoCoin"
   - Drag `assets/Decision Maker/Apple Watch Series 10 42mm - 11.png` to the @2x slot
   - Rename to `DM_NoCoin@2x.png`

#### Create Daily Luck Assets (2 imagesets)

1. **Create "DailyLuck" Folder**:
   - Right-click Assets.xcassets → New Folder → Name it "DailyLuck"

2. **Add DL_Prayer.imageset**:
   - Right-click "DailyLuck" folder → New Image Set → Name it "DL_Prayer"
   - Drag `assets/Daily Luck HUD/Apple Watch Series 10 42mm - 01.png` to the @2x slot
   - Rename to `DL_Prayer@2x.png`

3. **Add DL_Result.imageset**:
   - Right-click "DailyLuck" folder → New Image Set → Name it "DL_Result"
   - Drag `assets/Daily Luck HUD/Apple Watch Series 10 42mm - 06.png` to the @2x slot
   - Rename to `DL_Result@2x.png`

**Result Structure**:
```
Assets.xcassets/
├── AccentColor (existing)
├── AppIcon (existing)
├── Decision/
│   ├── DM_Daruma.imageset/
│   ├── DM_YesCoin.imageset/
│   └── DM_NoCoin.imageset/
└── DailyLuck/
    ├── DL_Prayer.imageset/
    └── DL_Result.imageset/
```

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

#### Test Daily Luck

1. Navigate to Daily Luck screen
2. Click simulator "TAP (Simulator)" button
3. **Expected Behavior**:
   - Prayer: Prayer hands image visible
   - Animating: Video plays with "Checking your luck..." text
   - Haptics occur during video (can't feel in simulator)
   - Result: 4-cat background with emoji overlays
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

### Daily Luck Tests
- [ ] Prayer screen shows prayer hands image
- [ ] Shake intensity bars work
- [ ] Tap button triggers video
- [ ] Video plays smoothly
- [ ] Haptics occur during video - device only
- [ ] Result shows 4 cats with overlaid emojis
- [ ] Emojis positioned correctly (🤩/🙂/😵)
- [ ] Tap to retry works
- [ ] Midnight refresh still works (change system time)

### Cross-Device Tests
- [ ] Test on 38mm simulator
- [ ] Test on 42mm simulator
- [ ] Test on 45mm simulator
- [ ] No layout overflow
- [ ] Assets scale properly

---

## 🐛 Troubleshooting

### Images Not Showing
**Problem**: White squares or missing images
**Solution**:
1. Check Assets.xcassets has correct folder structure
2. Verify image names match exactly (case-sensitive)
3. Ensure images are in @2x slot
4. Clean build folder (Cmd+Shift+K) and rebuild

### Video Not Playing
**Problem**: Black screen during animation phase
**Solution**:
1. Verify Resources folder added as "folder references" (blue)
2. Check Build Phases → Copy Bundle Resources includes MP4
3. Verify video file name: `jimeng-2025-12-27-8243.mp4`
4. Try playing video on Mac to ensure it's not corrupted

### Build Errors
**Problem**: Compiler errors about missing types
**Solution**:
1. Ensure Utilities folder added to project
2. Check VideoPlayerHelper.swift is in target membership
3. Clean build folder and rebuild

### Simulator Tap Button Not Visible
**Problem**: Can't trigger animations in simulator
**Solution**:
1. This is normal - button only shows in simulator
2. Look for "TAP (Simulator)" text with border
3. On real device, use shake gesture instead

---

## 📝 Summary

**Files Modified**: 4 Swift files
**Files Created**: 2 new files (VideoPlayerHelper, MP4 video copied)
**Manual Steps**: 5 imagesets + 2 folders to add in Xcode
**Estimated Time**: 15-20 minutes for Xcode setup

Once complete, you'll have:
- ✅ Decision Maker with Japanese folk art coins and Daruma
- ✅ Daily Luck with Maneki-neko video animation
- ✅ Both features fully interactive with haptics
- ✅ Ready for Sprint 6 (Sound effects)

Good luck! 🎌
