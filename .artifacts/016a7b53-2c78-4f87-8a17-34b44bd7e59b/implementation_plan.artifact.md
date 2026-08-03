# Implementation Plan - Stats Tab and Entry Editing

The goal is to implement the "Stats" tab based on the reference design and add the ability to edit mood entries.

## User Review Required

> [!NOTE]
> The Stats tab will include mock data for streaks, fluctuations, and achievements to match the design. The editing functionality will allow users to modify all aspects of a mood entry.

## Proposed Changes

### Diary Presentation Layer

#### [NEW] [stats_tab.dart](file:///C:/Users/d/Desktop/Blog/Diary/Code/lib/features/diary/presentation/pages/stats_tab.dart)
- Implement "July 2026" navigation.
- Implement "Streak" card with a row of status icons.
- Implement "Mood Fluctuations" card with a mock line chart using `CustomPainter`.
- Implement "Achievements" grid with stylized badges.

#### [MODIFY] [add_entry_page.dart](file:///C:/Users/d/Desktop/Blog/Diary/Code/lib/features/diary/presentation/pages/add_entry_page.dart)
- Add `final MoodEntryEntity? existingEntry` constructor parameter.
- Initialize `_selectedMoodId`, `_selectedActivities`, and `_noteController` from `existingEntry` in `initState`.
- Update the save button logic to call `updateEntry` if `existingEntry` is not null.

#### [MODIFY] [mood_tab.dart](file:///C:/Users/d/Desktop/Blog/Diary/Code/lib/features/diary/presentation/pages/mood_tab.dart)
- Update `PopupMenuButton` in `MoodEntryCard`.
- Implement navigation to `AddEntryPage(existingEntry: entry)` when the "Edit" option is selected.

#### [MODIFY] [dashboard_page.dart](file:///C:/Users/d/Desktop/Blog/Diary/Code/lib/features/diary/presentation/pages/dashboard_page.dart)
- Import and use `StatsTab` in the `_buildCurrentTab` method.

## Verification Plan

### Automated Tests
- Run `analyze_file` on all modified files to ensure no syntax errors.

### Manual Verification
- Navigate to the "Stats" tab and verify the layout matches the requirements.
- Open the "Mood" tab, click "Edit" on an entry, and verify that the `AddEntryPage` is correctly pre-populated.
- Change some values, save, and verify that the entry is updated in the list.
