import 'package:flutter/material.dart';

class PreparednessMissionBoard extends StatefulWidget {
  const PreparednessMissionBoard({Key? key}) : super(key: key);

  @override
  State<PreparednessMissionBoard> createState() =>
      _PreparednessMissionBoardState();
}

class _PreparednessMissionBoardState extends State<PreparednessMissionBoard> {
  final List<String> earnedBadges = ["Kit Ready", "Evacuation Mapped"];
  final List<Map<String, String>> drills = [
    {"title": "Fire Drill", "date": "Oct 5", "status": "Completed"},
    {"title": "Flood Drill", "date": "Oct 12", "status": "Scheduled"},
    {"title": "Earthquake Drill", "date": "Oct 20", "status": "Pending"},
  ];
  final List<String> quests = [
    "Pack your kit in under 10 minutes",
    "Explain your evacuation plan to a friend",
    "Schedule a drill this week",
  ];
  final List<String> tips = [
    "Store water bottles in every room.",
    "Keep flashlights near exits.",
    "Practice evacuation routes monthly.",
  ];

  int currentTip = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), _rotateTip);
  }

  void _rotateTip() {
    setState(() {
      currentTip = (currentTip + 1) % tips.length;
    });
    Future.delayed(const Duration(seconds: 3), _rotateTip);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE4E1),
      appBar: AppBar(
        title: const Text("Preparedness Mission Board"),
        backgroundColor: const Color(0xFFD32F2F),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionTitle("Earned Badges"),
          Wrap(
            spacing: 12,
            children: earnedBadges.map((badge) {
              return Chip(
                label: Text(badge),
                backgroundColor: const Color(0xFFD32F2F),
                labelStyle: const TextStyle(color: Colors.white),
                elevation: 4,
                shadowColor: Colors.black,
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          _sectionTitle("Drill Tracker"),
          SizedBox(
            height: 140,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: drills.map((drill) {
                return _flipCard(
                  drill["title"]!,
                  drill["date"]!,
                  drill["status"]!,
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),
          _sectionTitle("Prep Quests"),
          ...quests.map((quest) => _questTile(quest)).toList(),
          const SizedBox(height: 24),
          _sectionTitle("Safety Tip"),
          Card(
            color: Colors.white,
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                tips[currentTip],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 24),
          _sectionTitle("Drill Reminder"),
          Center(
            child: IconButton(
              icon: const Icon(
                Icons.notifications_active,
                color: Color(0xFFD32F2F),
                size: 40,
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Reminders Enabled")),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _flipCard(String title, String date, String status) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTap: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("$title marked as $status")));
        },
        child: Card(
          elevation: 4,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(date),
                const SizedBox(height: 8),
                Text(
                  status,
                  style: TextStyle(
                    color: status == "Completed" ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _questTile(String quest) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(quest),
        trailing: ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("Quest Completed: $quest")));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD32F2F),
            foregroundColor: Colors.white,
          ),
          child: const Text("Start Quest"),
        ),
      ),
    );
  }
}