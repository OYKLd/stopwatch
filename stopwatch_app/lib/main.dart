import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/scheduler.dart';

void main() {
  runApp(const StopwatchApp());
}

class StopwatchApp extends StatelessWidget {
  const StopwatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chronomètre Sportif',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00B4D8),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const StopwatchScreen(),
    );
  }
}

class StopwatchScreen extends StatefulWidget {
  const StopwatchScreen({super.key});

  @override
  _StopwatchScreenState createState() => _StopwatchScreenState();
}

class _StopwatchScreenState extends State<StopwatchScreen> with SingleTickerProviderStateMixin {
  final Stopwatch _stopwatch = Stopwatch();
  late final Ticker _ticker;
  String _timeString = '00:00:00';
  bool _isRunning = false;
  
  @override
  void initState() {
    super.initState();
    _ticker = Ticker(_updateTime)..stop();
  }

  void _updateTime(Duration _) {
    if (_stopwatch.isRunning) {
      setState(() {
        _timeString = _formatTime(_stopwatch.elapsedMilliseconds);
      });
    }
  }

  String _formatTime(int milliseconds) {
    int hundreds = (milliseconds / 10).truncate();
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).truncate();

    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    String hundredsStr = (hundreds % 100).toString().padLeft(2, '0');

    return '$minutesStr:$secondsStr:$hundredsStr';
  }

  void _startStopwatch() {
    setState(() {
      _isRunning = true;
      _stopwatch.start();
      _ticker.start();
    });
  }

  void _pauseStopwatch() {
    setState(() {
      _isRunning = false;
      _stopwatch.stop();
      _ticker.stop();
    });
  }

  void _resetStopwatch() {
    setState(() {
      _isRunning = false;
      _stopwatch.reset();
      _timeString = '00:00:00';
      _ticker.stop();
    });
  }

  @override
  void dispose() {
    _ticker.dispose();
    _stopwatch.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // En-tête
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Text(
                'Chrono',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: const Color(0xFF212529),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            
            // Affichage du temps
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Text(
                _timeString,
                key: ValueKey<String>(_timeString),
                style: const TextStyle(
                  fontSize: 72,
                  fontWeight: FontWeight.w300,
                  color: Color(0xFF212529),
                  fontFeatures: [
                    FontFeature.tabularFigures(),
                  ],
                ),
              ),
            ),
            
            // Boutons de contrôle
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0, left: 40, right: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Bouton Reset
                  _buildControlButton(
                    icon: Icons.refresh,
                    onPressed: _resetStopwatch,
                    backgroundColor: const Color(0xFFE9ECEF),
                    iconColor: const Color(0xFF212529),
                  ),
                  
                  const SizedBox(width: 30),
                  
                  // Bouton Play/Pause
                  _isRunning
                      ? _buildControlButton(
                          icon: Icons.pause,
                          onPressed: _pauseStopwatch,
                          backgroundColor: const Color(0xFFFF6B6B),
                          iconColor: Colors.white,
                          size: 80,
                        )
                      : _buildControlButton(
                          icon: Icons.play_arrow,
                          onPressed: _startStopwatch,
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          iconColor: Colors.white,
                          size: 80,
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    required Color backgroundColor,
    required Color iconColor,
    double size = 60,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, size: size * 0.5, color: iconColor),
        onPressed: onPressed,
        padding: EdgeInsets.zero,
      ),
    );
  }
}
