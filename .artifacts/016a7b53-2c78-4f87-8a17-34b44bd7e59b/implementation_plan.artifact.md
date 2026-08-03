# Implementation Plan - Functional Month Switcher in Stats Tab

This plan details adding a functional month switcher to the `StatsTab`, ensuring consistency with `MoodTab` and `JournalTab` as per the project's Clean Architecture and state management patterns.

## User Review Required

> [!NOTE]
> The Stats tab currently uses mock data for streaks and charts. This update will make the month navigation functional (changing the global state), but the statistical data will remain mock for now as per the "don't touch anything else" instruction.

## Proposed Changes

### Presentation Layer

#### [MODIFY] [stats_tab.dart](file:///C:/Users/d/Desktop/Blog/Diary/Code/lib/features/diary/presentation/pages/stats_tab.dart)
- Convert the widget to use `BlocBuilder<DiaryCubit, DiaryState>`.
- Update `_buildMonthNavigation` to:
    - Display the `selectedMonth` from the `DiaryLoaded` state.
    - Implement `onPressed` for the left arrow to go to the previous month.
    - Implement `onPressed` for the right arrow to go to the next month.
    - Disable the right arrow if the `selectedMonth` is the current month (to prevent navigating into the future).
- Use `intl` package for month formatting (consistency with other tabs).

## Verification Plan

### Automated Tests
- Verify compilation and architecture adherence with `analyze_file`.

### Manual Verification
- Open the **Stats** tab.
- Click the left arrow: verify the month updates to "June 2026" (if current is July).
- Click the right arrow: verify it returns to the current month.
- Verify the right arrow is disabled when viewing the current month.
- Switch to the **Mood** tab and verify the selected month is synchronized across both tabs.
