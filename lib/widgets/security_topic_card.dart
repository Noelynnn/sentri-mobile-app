import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class SecurityTopicCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  final String? category;

  final int? estimatedMinutes;

  final bool isSaved;

  final bool isCompleted;

  const SecurityTopicCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
    this.category,
    this.estimatedMinutes,
    this.isSaved = false,
    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.border,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  icon,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12.5,
                        height: 1.4,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    if (category != null ||
                        estimatedMinutes != null ||
                        isSaved ||
                        isCompleted) ...[
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 7,
                        runSpacing: 6,
                        children: [
                          if (estimatedMinutes != null)
                            _buildMiniTag(
                              icon: Icons.schedule_outlined,
                              text: '${estimatedMinutes!} min',
                            ),
                          if (category != null)
                            _buildMiniTag(
                              icon: Icons.category_outlined,
                              text: category!,
                            ),
                          if (isCompleted)
                            _buildMiniTag(
                              icon: Icons.check_circle_outline,
                              text: 'Completed',
                              color: AppColors.safe,
                              backgroundColor: AppColors.safeBackground,
                            ),
                          if (isSaved)
                            _buildMiniTag(
                              icon: Icons.bookmark_rounded,
                              text: 'Saved',
                              color: AppColors.primary,
                              backgroundColor: AppColors.primaryLight,
                            ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Padding(
                padding: EdgeInsets.only(top: 2),
                child: Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMiniTag({
    required IconData icon,
    required String text,
    Color color = AppColors.textSecondary,
    Color backgroundColor = AppColors.background,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 13,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
