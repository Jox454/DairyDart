# Implementation Plan - Monthly Reports and Profile Tab Update

This plan details renaming "Weekly Reports" to "Monthly Reports", updating the `ProfileTab`, and implementing the new `MonthlyReportsPage` with detailed month-based statistics and navigation.

## User Review Required

> [!IMPORTANT]
> The new "Monthly Reports" screen will allow users to navigate between months (past and present). It will consolidate statistics that were previously scattered across different tabs into one specialized report view.

## Proposed Changes

### Presentation Layer

#### [NEW] [monthly_reports_page.dart](file:///C:/Users/d/Desktop/Blog/Diary/Code/lib/features/diary/presentation/pages/monthly_reports_page.dart)
- Create a new screen that uses `BlocBuilder<DiaryCubit, DiaryState>`.
- **Month Switcher**: Implement the functional arrows and month title (reusing logic from `MoodTab`).
- **Mood Distribution Block**: Display the average score and mood counts for the selected month (reusing logic from `JournalTab`).
- **Mood Chart Block**:
    - Implement a chart showing mood fluctuations for the **entire month**.
    - X-axis labels will show key dates (e.g., 1, 5, 10, 15, 20, 25, 30/31) to maintain clarity.
- **Achievements Block**: Show the "Month Achievements" earned during that specific period.
- **Total Entries Block**: A new `GlassCard` showing the total number of entries made in the selected month.

#### [MODIFY] [profile_tab.dart](file:///C:/Users/d/Desktop/Blog/Diary/Code/lib/features/diary/presentation/pages/profile_tab.dart)
- Rename the "Weekly Reports" list item to "Monthly Reports".
- Update the `onTap` for this item to navigate to the new `MonthlyReportsPage`.

## Verification Plan

### Automated Tests
- Run `analyze_file` on all modified and new files.

### Manual Verification
- Open **Profile** and verify the name change.
- Click **Monthly Reports** and verify:
    - The month switcher works and doesn't allow future dates.
    - The "Mood Distribution" numbers are correct for the selected month.
    - The "Mood Chart" correctly maps entries from day 1 to the end of the month.
    - The "Total Entries" count matches the number of entries in that month.
    - Achievements update correctly when switching months.
