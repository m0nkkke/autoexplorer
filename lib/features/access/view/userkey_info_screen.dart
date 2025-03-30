import 'package:autoexplorer/features/access/widgets/access_info.dart';
import 'package:autoexplorer/features/access/widgets/roots_info.dart';
import 'package:autoexplorer/features/access/widgets/user_info.dart';
import 'package:flutter/material.dart';

class UserKeyInfoScreen extends StatefulWidget {
  const UserKeyInfoScreen({super.key});

  @override
  State<UserKeyInfoScreen> createState() => _UserKeyInfoState();
}

class _UserKeyInfoState extends State<UserKeyInfoScreen> {
  Map<String, dynamic> user = {};

  final Set<String> selectedRegions = {};
  final Set<String> selectedSections = {};
  final Set<String> selectedSpans = {};

  final List<String> randomRegions = List.generate(10, (index) => 'Регион ${index + 1}');
  final List<String> randomSections = List.generate(10, (index) => 'Участок ${index + 1}');
  final List<String> randomSpans = List.generate(10, (index) => 'Пролёт ${index + 1}');

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Получаем данные пользователя из аргументов маршрута
    final Map<String, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    setState(() {
      user = arguments;
    });

    // Проставляем галочки для данных из user
    if (user['accessList'] != null) {
      selectedRegions.add('${user['accessList']['regional']['regName']}');
      selectedSections.add('${user['accessList']['area']['areaName']}');
      selectedSpans.add('${user['accessList']['line']['lineName']}');
    }
  }

  void _handleSaveData(Map<String, String> data) {
    // Здесь вы получаете все данные и можете передать их в BLoC или в другом месте
    print('Полученные данные: $data');
  }

  List<String> _getSortedItems(List<String> items, Set<String> selectedItems) {
    // Разделяем элементы на выбранные и невыбранные
    final selected = items.where((item) => selectedItems.contains(item)).toList();
    final unselected = items.where((item) => !selectedItems.contains(item)).toList();

    // Возвращаем список, где выбранные элементы идут первыми
    return [...selected, ...unselected];
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
            // Виджет для информации о пользователе
            UserInfoWidget(
              lastName: '${user['lastName']}',
              firstName: '${user['firstName']}',
              middleName: '${user['middleName']}',
              isNew: false,
              onSaveData: _handleSaveData,
            ),
            Divider(),
            // Виджет для информации о доступах
            AccessInfoWidget(
              imagesCreated: '${user['imagesCount']}',
              lastUpload: '${user['lastUpload']}',
              accessGranted: '${user['accessSet']}',
              accessModified: '${user['accessEdit']}',
              accessKey: '${user['accessKey']}',
            ),
            Divider(),
            // Регион
            RootsInfo(
              title: 'Регион',
              items: _getSortedItems(
                [
                  ...randomRegions, // добавляем рандомные регионы
                  '${user['accessList']['regional']['regName']}', // добавляем данные из user
                ],
                selectedRegions,
              ),
              selectedItems: selectedRegions,
              onChanged: _onRegionsChanged,
            ),
            SizedBox(height: 10),
            // Участок
            RootsInfo(
              title: 'Участок',
              items: _getSortedItems(
                [
                  ...randomSections, // добавляем рандомные участки
                  '${user['accessList']['area']['areaName']}', // добавляем данные из user
                ],
                selectedSections,
              ),
              selectedItems: selectedSections,
              onChanged: _onSectionsChanged,
            ),
            SizedBox(height: 10),
            // Пролёт
            RootsInfo(
              title: 'Пролёт',
              items: _getSortedItems(
                [
                  ...randomSpans, // добавляем рандомные пролёты
                  '${user['accessList']['line']['lineName']}', // добавляем данные из user
                ],
                selectedSpans,
              ),
              selectedItems: selectedSpans,
              onChanged: _onSpansChanged,
            ),
          ],
        ),
      ),
    );
  }
}
