import 'package:flutter/material.dart';

class JobProgressTimeline extends StatelessWidget {
  final List<JobStage> stages;

  const JobProgressTimeline({required this.stages, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: stages.length,
        itemBuilder: (context, index) {
          return TimelineTile(
            stage: stages[index],
            isFirst: index == 0,
            isLast: index == stages.length - 1,
          );
        },
      ),
    );
  }
}

class JobStage {
  final String time;
  final String title;
  final bool isCompleted;

  JobStage({
    required this.time,
    required this.title,
    required this.isCompleted,
  });
}

class TimelineTile extends StatelessWidget {
  final JobStage stage;
  final bool isFirst;
  final bool isLast;

  const TimelineTile({
    required this.stage,
    required this.isFirst,
    required this.isLast,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Text(
                "${stage.time}\n${stage.title}",
                style: TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.right,
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!isFirst)
                Expanded(child: Container(width: 2, color: Colors.white)),
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: stage.isCompleted ? Colors.blue : Colors.white,
                  border: Border.all(color: Colors.blue, width: 2),
                ),
                child:
                    stage.isCompleted
                        ? Icon(Icons.check, color: Colors.white, size: 16)
                        : null,
              ),
              if (!isLast)
                Expanded(child: Container(width: 2, color: Colors.white)),
            ],
          ),
          Spacer(),
        ],
      ),
    );
  }
}
