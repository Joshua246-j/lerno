import 'package:flutter/material.dart';
import 'package:lerno/core/theme/app_theme.dart';

class FeaturedTab extends StatelessWidget {
  final bool isDailyDeals;
  const FeaturedTab({super.key, this.isDailyDeals = false});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        if (isDailyDeals) ...[
          _buildOfferCard(
            title: '20% OFF ALL AVATARS',
            subtitle: 'Ends in 12h 45m',
            icon: Icons.local_offer,
            color: Colors.purple,
          ),
          const SizedBox(height: 15),
          _buildOfferCard(
            title: 'Free Mystery Sticker Pack',
            subtitle: 'Claim now!',
            icon: Icons.card_giftcard,
            color: Colors.green,
            buttonText: 'Claim',
          ),
        ] else ...[
          _buildOfferCard(
            title: 'New Season Pass!',
            subtitle: 'Unlock exclusive rewards (Coming Soon)',
            icon: Icons.star,
            color: Colors.amber.shade700,
          ),
          const SizedBox(height: 15),
          _buildOfferCard(
            title: 'Beginner Bundle',
            subtitle: '3 Avatars + 1000 Coins',
            icon: Icons.shopping_cart,
            color: AppTheme.primaryBlue,
            buttonText: 'Buy',
          ),
        ]
      ],
    );
  }

  Widget _buildOfferCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    String buttonText = 'View',
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 30),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: color)),
                const SizedBox(height: 4),
                Text(subtitle,
                    style: const TextStyle(color: Colors.grey, fontSize: 13)),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
            onPressed: () {},
            child: Text(buttonText),
          )
        ],
      ),
    );
  }
}
