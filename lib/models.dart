// lib/models.dart
class Ingredient {
  final String name;
  final String units;
  final num amount;

  Ingredient({required this.name, required this.units, required this.amount});

  factory Ingredient.fromJson(Map<String, dynamic> j) => Ingredient(
        name: j['name'],
        units: j['units'],
        amount: j['amount'],
      );

  Ingredient scaled(num scale) =>
      Ingredient(name: name, units: units, amount: amount * scale);
}

class StepModel {
  final String name;
  final String description;
  final int minutesAfterPreviousStep;
  final List<Ingredient> ingredients;

  StepModel({
    required this.name,
    required this.description,
    required this.minutesAfterPreviousStep,
    required this.ingredients,
  });

  factory StepModel.fromJson(Map<String, dynamic> j) => StepModel(
        name: j['name'],
        description: j['description'] ?? '',
        minutesAfterPreviousStep: (j['minutes_after_previous_step'] ?? 0) as int,
        ingredients: (j['ingredients'] as List?)
                ?.map((e) => Ingredient.fromJson(e))
                .toList() ??
            [],
      );

  StepModel scaled(num scale) => StepModel(
        name: name,
        description: description,
        minutesAfterPreviousStep: minutesAfterPreviousStep,
        ingredients: ingredients.map((i) => i.scaled(scale)).toList(),
      );
}

class Recipe {
  final String name;
  final String description;
  int nLoaves;
  final List<StepModel> steps;

  Recipe({
    required this.name,
    required this.description,
    required this.nLoaves,
    required this.steps,
  });

  factory Recipe.fromJson(Map<String, dynamic> j) => Recipe(
        name: j['name'],
        description: j['description'] ?? '',
        nLoaves: (j['n_loaves'] ?? 1) as int,
        steps:
            (j['steps'] as List).map((e) => StepModel.fromJson(e)).toList(),
      );

  /// Return a copy with scaled ingredient amounts based on desired nLoaves.
  Recipe withScaledLoaves(int newNLoaves) {
    final scale = newNLoaves / (nLoaves == 0 ? 1 : nLoaves);
    return Recipe(
      name: name,
      description: description,
      nLoaves: newNLoaves,
      steps: steps.map((s) => s.scaled(scale)).toList(),
    );
  }
}
