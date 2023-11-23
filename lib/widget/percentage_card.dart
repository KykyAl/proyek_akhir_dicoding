import 'package:catatan/provider/tasks_provider.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class PrecentageCard extends StatelessWidget {
  const PrecentageCard({super.key});

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<TaskProvider>(context);
    return Center(
      child: CircularPercentIndicator(
        circularStrokeCap: CircularStrokeCap.round,
        backgroundColor: const Color.fromARGB(255, 198, 198, 198),
        lineWidth: 15,
        percent: userData.totalPerc,
        radius: 70,
        progressColor: Theme.of(context).colorScheme.secondary,
        animation: true,
        animationDuration: 700,
        center: Text(
          '${(userData.totalPerc * 100).toStringAsFixed(0)}%',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).textScaleFactor * 25),
        ),
        animateFromLastPercent: true,
      ),
    );
  }
}
