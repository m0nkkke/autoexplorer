import 'package:autoexplorer/generated/l10n.dart';
import 'package:flutter/material.dart';

class RegionSelector extends StatelessWidget {
  final String title; // Заголовок для меню
  final List<String> regions; // Список всех регионалов
  final String? selectedRegion; // Текущий выбранный регионал
  final ValueChanged<String>?
      onRegionChanged; // Коллбек для изменения регионала

  const RegionSelector({
    super.key,
    required this.title,
    required this.regions,
    this.selectedRegion,
    this.onRegionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<String>(
            value: selectedRegion, // Проверяем, что выбранный регионал валиден
            hint: Text(S.of(context).chooseRegional),
            isExpanded: true,
            onChanged: (String? newRegion) {
              if (newRegion != null && onRegionChanged != null) {
                onRegionChanged!(
                    newRegion); // Вызываем коллбек для изменения региона
              }
            },
            items: regions.map((region) {
              return DropdownMenuItem<String>(
                value: region,
                child: Text(region),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
