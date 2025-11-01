# AI Agent Instructions for Bread App

## Project Overview
Bread App is a Flutter mobile application for iOS and Android that helps users make bread by providing timed steps and notifications. The app allows users to:
- Follow a structured bread-making recipe with precise timing
- Receive alarms for each step
- Scale recipes based on number of loaves
- View progress timers
- Navigate through past and future steps

## Architecture & Data Flow

### Core Components
1. **Recipe Data** (`assets/steps.json`):
   - Contains structured recipe data with steps, timings, and ingredients
   - Each step has a name, description, timing, and list of ingredients
   - Amounts are calibrated for 2 loaves by default

2. **Data Models** (`lib/models.dart`):
   - `Ingredient`: Represents recipe ingredients with scaling functionality
   - `StepModel`: Represents recipe steps with timing information
   - `Recipe`: Parent model containing full recipe data

3. **UI Layer** (`lib/main.dart`):
   - Flutter Material app using stateful widgets for dynamic content
   - Handles recipe display, timing, and notifications

## Development Workflow

### Build & Run
```bash
# Run app in debug mode
flutter run

# Hot reload (while app is running)
r

# Hot restart (while app is running)
R
```

### Testing
- Widget tests are in `test/widget_test.dart`
- Use `flutter test` to run tests
- Tests use `WidgetTester` for UI interaction simulation

## Project-Specific Patterns

### Recipe Scaling
- All ingredient amounts in `steps.json` are based on 2 loaves. However this may change, always check the n_loaves option in the json file.
- Use `scaled()` methods in `Ingredient` and `StepModel` to adjust quantities
- Example: `ingredient.scaled(2.5)` for 5 loaves

### Timing System
- Steps use `minutesAfterPreviousStep` to define relative timing
- Alarms should be persistent until user dismissal
- Multiple concurrent timers may be active

## Future Development
When implementing new features:
1. Update recipe schema in `assets/steps.json` if adding new step properties
2. Add corresponding fields to `StepModel` in `models.dart`
3. Ensure scaling logic is applied to any new quantity fields
4. Add widget tests for new UI components