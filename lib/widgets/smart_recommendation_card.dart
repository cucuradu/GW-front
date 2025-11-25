import 'package:flutter/material.dart';
import 'package:gwfront/services/ml_prediction_service.dart';

/// Smart recommendation card widget with priority-based styling
class SmartRecommendationCard extends StatelessWidget {
  final SmartRecommendation recommendation;
  final VoidCallback? onAction;

  const SmartRecommendationCard({
    Key? key,
    required this.recommendation,
    this.onAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = _getPriorityColors(recommendation.priority);

    return Container(
      margin: EdgeInsets.only(right: 15, bottom: 10),
      padding: EdgeInsets.all(15),
      width: 280,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colors.bgColor, colors.bgColor.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: colors.shadowColor.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              // Icon
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colors.iconBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  recommendation.icon,
                  style: TextStyle(fontSize: 24),
                ),
              ),
              SizedBox(width: 12),

              // Title
              Expanded(
                child: Text(
                  recommendation.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Priority badge
              if (recommendation.priority == RecommendationPriority.high)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'URGENT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 12),

          // Message
          Text(
            recommendation.message,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
              height: 1.4,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),

          // Action button
          if (recommendation.action != null) ...[
            SizedBox(height: 15),
            GestureDetector(
              onTap: onAction,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      recommendation.action!,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 6),
                    Icon(Icons.arrow_forward, color: Colors.white, size: 16),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  _PriorityColors _getPriorityColors(RecommendationPriority priority) {
    switch (priority) {
      case RecommendationPriority.high:
        return _PriorityColors(
          bgColor: Color(0xFFE74C3C),
          iconBg: Colors.white.withOpacity(0.2),
          shadowColor: Color(0xFFE74C3C),
        );
      case RecommendationPriority.medium:
        return _PriorityColors(
          bgColor: Color(0xFFF39C12),
          iconBg: Colors.white.withOpacity(0.2),
          shadowColor: Color(0xFFF39C12),
        );
      case RecommendationPriority.low:
        return _PriorityColors(
          bgColor: Color(0xFF27AE60),
          iconBg: Colors.white.withOpacity(0.2),
          shadowColor: Color(0xFF27AE60),
        );
    }
  }
}

class _PriorityColors {
  final Color bgColor;
  final Color iconBg;
  final Color shadowColor;

  _PriorityColors({
    required this.bgColor,
    required this.iconBg,
    required this.shadowColor,
  });
}

/// Horizontal scrollable list of recommendations
class SmartRecommendationsCarousel extends StatelessWidget {
  final List<SmartRecommendation> recommendations;
  final Function(SmartRecommendation)? onActionTap;

  const SmartRecommendationsCarousel({
    Key? key,
    required this.recommendations,
    this.onActionTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (recommendations.isEmpty) {
      return SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Icon(Icons.auto_awesome, color: Color(0xFF8EAC50), size: 24),
              SizedBox(width: 10),
              Text(
                'Smart Recommendations',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 15),
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 20),
            itemCount: recommendations.length,
            itemBuilder: (context, index) {
              return SmartRecommendationCard(
                recommendation: recommendations[index],
                onAction: () => onActionTap?.call(recommendations[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}
