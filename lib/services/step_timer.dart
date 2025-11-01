import 'dart:async';
import 'package:flutter/material.dart';
import '../models.dart';
import '../services/notification_service.dart';

class StepTimer extends ChangeNotifier {
  final NotificationService _notifications = NotificationService();
  final List<StepModel> _steps;
  int _currentStepIndex = 0;
  Timer? _timer;
  DateTime? _startTime;
  bool _isPaused = true;

  StepTimer(this._steps);

  StepModel get currentStep => _steps[_currentStepIndex];
  bool get isPaused => _isPaused;
  int get totalSteps => _steps.length;
  int get currentStepIndex => _currentStepIndex;

  Duration? get timeUntilNextStep {
    if (_startTime == null || _currentStepIndex >= _steps.length - 1) return null;
    
    final totalMinutesSoFar = _steps
        .take(_currentStepIndex + 1)
        .map((s) => s.minutesAfterPreviousStep)
        .reduce((a, b) => a + b);
    
    final targetTime = _startTime!.add(Duration(minutes: totalMinutesSoFar));
    return targetTime.difference(DateTime.now());
  }

  void start() {
    if (_startTime == null) {
      _startTime = DateTime.now();
    }
    _isPaused = false;
    _startTimer();
    notifyListeners();
  }

  void pause() {
    _isPaused = true;
    _timer?.cancel();
    notifyListeners();
  }

  void reset() {
    _startTime = null;
    _currentStepIndex = 0;
    _isPaused = true;
    _timer?.cancel();
    notifyListeners();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_isPaused || timeUntilNextStep == null) return;

      if (timeUntilNextStep!.isNegative && _currentStepIndex < _steps.length - 1) {
        _currentStepIndex++;
        _notifications.showStepNotification(
          currentStep.name,
          currentStep.description,
        );
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}