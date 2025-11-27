import 'package:flutter/material.dart';
import 'package:disfruta_antofagasta/config/theme/theme_config.dart';

class CategoryChipsList extends StatelessWidget {
  final List<dynamic> items;
  final int? selectedId;
  final Function(dynamic) onChanged;
  final EdgeInsetsGeometry padding;

  const CategoryChipsList({
    super.key,
    required this.items,
    required this.selectedId,
    required this.onChanged,
    this.padding = const EdgeInsets.symmetric(horizontal: 4),
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: padding,
      child: Row(
        children: items.map((cat) {
          final bool active = selectedId == cat.id;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onChanged(cat),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: active
                      ? AppColors.panelWine.withOpacity(0.90)
                      : AppColors.panelWine.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.panelWine,
                    width: active ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.place,
                      size: 16,
                      color: active ? Colors.white : Colors.black,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      cat.name,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: active
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: active ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
