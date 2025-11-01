import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/step_timer.dart';
import '../models.dart';

class StepList extends StatelessWidget {
  const StepList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<StepTimer>(
      builder: (context, timer, child) {
        return ListView.builder(
          itemCount: timer.totalSteps,
          itemBuilder: (context, index) {
            final step = timer.currentStep;
            final isCurrentStep = index == timer.currentStepIndex;
            
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              color: isCurrentStep ? Theme.of(context).colorScheme.primaryContainer : null,
              child: ExpansionTile(
                title: Text(step.name),
                subtitle: Text('${step.minutesAfterPreviousStep} minutes after previous step'),
                initiallyExpanded: isCurrentStep,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(step.description),
                        const SizedBox(height: 8),
                        if (step.ingredients.isNotEmpty) ...[
                          const Text('Ingredients:',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          ...step.ingredients.map((ingredient) => Text(
                              '• ${ingredient.amount} ${ingredient.units} ${ingredient.name}')),
                        ],
                        if (isCurrentStep && timer.timeUntilNextStep != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              'Time until next step: ${_formatDuration(timer.timeUntilNextStep!)}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String _formatDuration(Duration duration) {
    if (duration.isNegative) {
      return 'Overdue!';
    }
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;
    
    if (hours > 0) {
      return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}