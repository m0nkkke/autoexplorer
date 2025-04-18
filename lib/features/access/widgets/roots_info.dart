import 'package:flutter/material.dart';

class RootsInfo extends StatefulWidget {
  final String title;
  final List<String> items; // Список названий папок для отображения
  final Set<String> selectedItems; // Список ID выбранных участков
  final Map<String, String> folderIdsMap; // Словарь {название папки: id}
  final ValueChanged<Set<String>> onChanged; // Коллбек для передачи id
  final bool isLoading; // Флаг загрузки

  const RootsInfo({
    super.key,
    required this.title,
    required this.items,
    required this.selectedItems,
    required this.onChanged,
    required this.folderIdsMap,
    required this.isLoading, // Принимаем флаг загрузки
  });

  @override
  _RootsInfoState createState() => _RootsInfoState();
}

class _RootsInfoState extends State<RootsInfo> {
  late Set<String> selectedItems; // Состояние выбранных элементов
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    selectedItems = Set.from(widget.selectedItems); // Инициализируем состоянием
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onItemChanged(String item, bool? isSelected) {
    setState(() {
      if (isSelected == true) {
        selectedItems.add(widget.folderIdsMap[item]!); // Добавляем ID папки в список выбранных
      } else {
        selectedItems.remove(widget.folderIdsMap[item]!); // Убираем ID папки из списка
      }

      widget.onChanged(selectedItems); // Отправляем только ID выбранных папок
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            widget.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: SizedBox(
            height: 150,
            child: widget.isLoading // Проверяем флаг загрузки
                ? Center(child: CircularProgressIndicator()) // Показываем индикатор загрузки
                : Scrollbar(
                    controller: _scrollController,
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                        children: widget.items.map((item) {
                          final isSelected = selectedItems.contains(widget.folderIdsMap[item]);
                          return CheckboxListTile(
                            value: isSelected, // Проверяем, выбран ли элемент по ID
                            onChanged: (bool? value) => _onItemChanged(item, value),
                            title: Text(
                              item, // Отображаем только название папки
                              style: const TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                              ),
                            ),
                            controlAffinity: ListTileControlAffinity.trailing,
                            contentPadding: EdgeInsets.zero,
                          );
                        }).toList(),
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
