# Implementation Plan - Dynamic Achievements Synchronization

The goal is to synchronize the achievements shown in the `StatsTab` and the `AchievementsPage` by making both dynamic and based on the same rules.

## User Review Required

> [!IMPORTANT]
> Achievements will now be calculated automatically based on your real mood entries. The static mock list in the "Achievements" page will be replaced with dynamic logic. To see all achievements unlocked for August, you will need at least 7 entries with 5 positive moods.

## Proposed Changes

### Data Layer

#### [MODIFY] [diary_repository_impl.dart](file:///C:/Users/d/Desktop/Blog/Diary/Code/lib/features/diary/data/repositories/diary_repository_impl.dart)
- Add more mock entries for August (August 6 and August 7) to ensure "Zen Master" (7 entries) and "Optimist" (5 positive entries) are unlocked by default in the test data.

### Presentation Layer

#### [MODIFY] [achievements_page.dart](file:///C:/Users/d/Desktop/Blog/Diary/Code/lib/features/diary/presentation/pages/achievements_page.dart)
- Convert to use `BlocBuilder<DiaryCubit, DiaryState>`.
- Implement dynamic calculation of achievements for every month represented in the user's history.
- Logic:
    - **On Fire**: Unlocked on the day of the 1st entry of any month.
    - **Zen Master**: Unlocked on the day of the 7th entry of any month.
    - **Optimist**: Unlocked on the day of the 5th "Good" or "Super" entry of any month.
- Group and display these earned milestones by date, newest first.

#### [MODIFY] [stats_tab.dart](file:///C:/Users/d/Desktop/Blog/Diary/Code/lib/features/diary/presentation/pages/stats_tab.dart)
- Ensure it uses the exact same calculation rules as `AchievementsPage` for the selected month to maintain 100% synchronization.

## Verification Plan

### Automated Tests
- Run `analyze_file` to ensure code correctness.

### Manual Verification
- Open **Stats**: verify it shows 3 achievements for August (with updated mock data).
- Open **Profile -> Achievements**: verify the same 3 achievements are listed for August, grouped by the date they were earned.
- Delete an entry in **Mood**: verify both pages update and achievements disappear if conditions are no longer met.
