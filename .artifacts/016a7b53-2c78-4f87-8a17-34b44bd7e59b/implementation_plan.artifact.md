# Implementation Plan - Stats Tab UI Refinement

The goal is to simplify the `StatsTab` by removing month navigation and updating the achievements section to focus on the selected month's progress.

## User Review Required

> [!IMPORTANT]
> The month navigation (arrows) will be removed from the Stats tab. The tab will still display the month and year of the `selectedMonth`, which can be changed from the Journal or Mood tabs.

## Proposed Changes

### Presentation Layer

#### [MODIFY] [stats_tab.dart](file:///C:/Users/d/Desktop/Blog/Diary/Code/lib/features/diary/presentation/pages/stats_tab.dart)
- **Month Display**: Update `_buildMonthNavigation` to remove the `IconButton`s. The month and year text will be centered and displayed statically.
- **Achievements Section**:
    - Rename the section header from "ACHIEVEMENTS" to "MONTH ACHIEVEMENTS".
    - Implement logic to calculate month-specific achievements based on `state.entries`:
        - **Zen Master**: Unlocked if the user has 7 or more entries in the selected month.
        - **On Fire**: Unlocked if the user has any entries in the selected month.
        - **Optimist**: Unlocked if the user has 5 or more "Good" or "Super" entries in the selected month.
    - If no achievements are unlocked for the month, display a beautifully designed "No achievements yet" message inside a `GlassCard`.

## Verification Plan

### Automated Tests
- Run `analyze_file` to ensure no syntax errors.

### Manual Verification
- Open the **Stats** tab.
- Verify that the month switcher (arrows) is gone and the month/year is centered.
- Check the achievements section:
    - If there are enough entries for August (based on mock data), verify that the relevant achievements are shown.
    - Switch to a month with no entries (e.g., June 2026) using the Journal tab, then return to Stats and verify the "No achievements yet" message is displayed.
