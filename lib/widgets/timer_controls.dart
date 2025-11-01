import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/step_timer.dart';

class TimerControls extends StatelessWidget {
  const TimerControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<StepTimer>(
      builder: (context, timer, child) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(timer.isPaused ? Icons.play_arrow : Icons.pause),
                onPressed: () {
                  if (timer.isPaused) {
                    timer.start();
                  } else {
                    timer.pause();
                  }
                },
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => timer.reset(),
              ),
            ],
          ),
        );
      },
    );
  }
}