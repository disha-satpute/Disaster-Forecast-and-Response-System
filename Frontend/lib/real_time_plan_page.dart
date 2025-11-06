import 'package:flutter/material.dart';

class RealTimePlanPage extends StatelessWidget {
  const RealTimePlanPage({super.key});

  final Color bgPink = const Color(0xFFFDECEC);
  final Color primaryRed = Colors.redAccent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgPink,
      appBar: AppBar(
        title: const Text('Upgrade Plans'),
        backgroundColor: primaryRed,
        centerTitle: true,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Choose the plan that fits your needs:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: const [
                  _PlanCard(
                    icon: Icons.lock_open,
                    title: 'Basic Plan',
                    price: 'Free',
                    badgeColor: Colors.grey,
                    features: [
                      'Access to alerts',
                      'View response checklist',
                      'Limited map access',
                    ],
                  ),
                  SizedBox(height: 12),
                  _PlanCard(
                    icon: Icons.star,
                    title: 'Pro Plan',
                    price: '₹199/month',
                    badgeColor: Colors.orangeAccent,
                    features: [
                      'Real-time dashboard',
                      'Priority alerts',
                      'Full map & shelter access',
                      'Coordinator tools',
                    ],
                  ),
                  SizedBox(height: 12),
                  _PlanCard(
                    icon: Icons.workspace_premium,
                    title: 'Enterprise Plan',
                    price: '₹499/month',
                    badgeColor: Colors.redAccent,
                    features: [
                      'Multi-location support',
                      'Team coordination tools',
                      'Custom disaster simulations',
                      '24/7 support',
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Plan selection coming soon')),
                );
              },
              icon: const Icon(Icons.upgrade),
              label: const Text('Upgrade Now'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryRed,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String price;
  final List<String> features;
  final Color badgeColor;

  const _PlanCard({
    required this.icon,
    required this.title,
    required this.price,
    required this.features,
    required this.badgeColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: badgeColor,
                child: Icon(icon, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '$title • $price',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...features.map((f) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, size: 18, color: Colors.redAccent),
                    const SizedBox(width: 8),
                    Expanded(child: Text(f)),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
