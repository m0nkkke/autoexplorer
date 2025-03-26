import 'package:autoexplorer/features/access/widgets/access_info.dart';
import 'package:autoexplorer/features/access/widgets/roots_info.dart';
import 'package:autoexplorer/features/access/widgets/user_info.dart';
import 'package:flutter/material.dart';

class UserKeyCreateScreen extends StatefulWidget {
  const UserKeyCreateScreen({super.key});

  @override
  State<UserKeyCreateScreen> createState() => _UserKeyCreateState();
}

class _UserKeyCreateState extends State<UserKeyCreateScreen> {
  final Set<String> selectedRegions = {};
  final Set<String> selectedSections = {};
  final Set<String> selectedSpans = {};

  void _onRegionsChanged(Set<String> newSelection) {
    setState(() {
      selectedRegions.clear();
      selectedRegions.addAll(newSelection);
    });
  }

  void _onSectionsChanged(Set<String> newSelection) {
    setState(() {
      selectedSections.clear();
      selectedSections.addAll(newSelection);
    });
  }

  void _onSpansChanged(Set<String> newSelection) {
    setState(() {
      selectedSpans.clear();
      selectedSpans.addAll(newSelection);
    });
  }

  void _save() {
    // логика для сохранения данных
    print('Данные сохранены');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Админ-панель')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const UserInfoWidget(isNew: true),
            Divider(),
            const AccessInfoWidget(isNew: true),
            Divider(),
            RootsInfo(
              title: 'Регион',
              items: ['Регионал 321', 'Регионал 1', 'Регионал 2'],
              selectedItems: selectedRegions,
              onChanged: _onRegionsChanged,
            ),
            SizedBox(height: 10),
            RootsInfo(
              title: 'Участок',
              items: ['Участок 1', 'Участок 2', 'Участок 3', 'Участок 1', 'Участок 2', 'Участок 3'],
              selectedItems: selectedSections,
              onChanged: _onSectionsChanged,
            ),
            SizedBox(height: 10),
            RootsInfo(
              title: 'Пролёт',
              items: ['Пролёт A', 'Пролёт B', 'Пролёт C'],
              selectedItems: selectedSpans,
              onChanged: _onSpansChanged,
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: _save,
                child: const Text('Сохранить'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
