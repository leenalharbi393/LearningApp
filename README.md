# Learning Journey

Learning Journey helps you build a daily learning habit. Set what you want to learn and for how long, then log each day as learned (or freeze it) to keep your streak going.

## Main features

- **Set a learning goal**: choose a topic and a duration (week, month, or year).
- **Log your day**: mark today as *Learned*, or use a *Freeze* to protect your streak on a day you can't study.
- **Track your progress**: see your learned days and freezes used, with a weekly overview.
- **Freeze limits**: 2 per week, 8 per month, 96 per year.
- **Streak rules**: the streak resets after 32 hours without learning or freezing; the buttons unlock again at midnight.
- **Edit your goal**: change the topic or duration at any time (with a confirmation, since the streak starts over).
- **Goal results**: celebrate a completed goal, or see when it wasn't reached, then set a new goal or repeat the same one.
- **Calendar history**: browse every month to see all your learned and freezed days.
- **Saved progress**: your goal and history stay on the device between launches.

## Technologies used

- Swift and SwiftUI
- MVVM architecture with the Observation framework (`@Observable`)
- Liquid Glass (glass effects, glass buttons, and toolbars)
- Codable + JSON, stored in UserDefaults
- Icon Composer (layered Liquid Glass app icon)
- Git and GitHub (feature branches and merges)

## Requirements

- iOS 27.0 or later
- Xcode 27.1 or later

## Project structure

```
LearningApp/
├── Models/        Data types: LearningGoal, GoalDuration, DayLog, DayStatus, GoalState, AppData
├── ViewModels/    Logic and state: ActivityViewModel, GoalEditorViewModel, CalendarViewModel
├── Views/         Screens: Onboarding, Activity, Learning Goal, Calendar
├── Components/    Reusable UI: DurationChip, GoalFormView, DayCircle, StatCard
├── Services/      Saving and loading: DataStore
├── Theme/         App colors
└── Utilities/     Shared helpers: the app's Gregorian calendar
```
