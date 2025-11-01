import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'widgets/step_list.dart';
import 'widgets/timer_controls.dart';
import 'models.dart';
import 'services/notification_service.dart';
import 'services/step_timer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  runApp(const BreadApp());
}

class BreadApp extends StatelessWidget {
  const BreadApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bread Timer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
        useMaterial3: true,
      ),
      home: const BreadMakerScreen(),
    );
  }
}

class BreadMakerScreen extends StatefulWidget {
  const BreadMakerScreen({super.key});

  @override
  State<BreadMakerScreen> createState() => _BreadMakerScreenState();
}

class _BreadMakerScreenState extends State<BreadMakerScreen> {
  Recipe? _recipe;
  double _loafScale = 1.0; // Scale relative to base recipe

  @override
  void initState() {
    super.initState();
    _loadRecipe();
  }

  Future<void> _loadRecipe() async {
    final String jsonString = await rootBundle.loadString('assets/steps.json');
    final recipeJson = json.decode(jsonString);
    setState(() {
      _recipe = Recipe.fromJson(recipeJson);
      // Initialize scale based on default n_loaves
      _loafScale = 2 / (_recipe?.nLoaves ?? 2);
    });
  }

  void _updateLoafCount(double newCount) {
    if (_recipe == null) return;
    setState(() {
      _loafScale = newCount / _recipe!.nLoaves;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_recipe == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return ChangeNotifierProvider(
      create: (context) => StepTimer(_recipe!.steps.map(
        (step) => step.scaled(_loafScale)
      ).toList()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Bread Timer'),
          actions: [
            IconButton(
              icon: const Icon(Icons.apps),
              onPressed: () => _showLoafCountDialog(context),
            ),
          ],
        ),
        body: Column(
          children: const [
            TimerControls(),
            Expanded(child: StepList()),
          ],
        ),
      ),
    );
  }

  Future<void> _showLoafCountDialog(BuildContext context) async {
    final result = await showDialog<double>(
      context: context,
      builder: (BuildContext context) {
        double loaves = _recipe!.nLoaves * _loafScale;
        return AlertDialog(
          title: const Text('Adjust Recipe Size'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Number of loaves:'),
              Slider(
                value: loaves,
                min: 1,
                max: 6,
                divisions: 10,
                label: loaves.toStringAsFixed(1),
                onChanged: (value) {
                  loaves = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, loaves),
              child: const Text('Update'),
            ),
          ],
        );
      },
    );

    if (result != null) {
      _updateLoafCount(result);
    }
  }
}