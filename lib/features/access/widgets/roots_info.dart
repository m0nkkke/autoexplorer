import 'package:flutter/material.dart';

class RootsInfo extends StatefulWidget {
  final String title;
  final List<String> items;
  final Set<String> selectedItems;
  final ValueChanged<Set<String>> onChanged;

  const RootsInfo({
    super.key,
    required this.title,
    required this.items,
    required this.selectedItems,
    required this.onChanged,
  });

  @override
  _RootsInfoState createState() => _RootsInfoState();
}

class _RootsInfoState extends State<RootsInfo> {
  late Set<String> selectedItems;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    selectedItems = Set.from(widget.selectedItems);
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
        selectedItems.add(item);
      } else {
        selectedItems.remove(item);
      }
      widget.onChanged(selectedItems);
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
            child: Scrollbar(
              controller: _scrollController, 
              thumbVisibility: true, 
              child: SingleChildScrollView(
                controller: _scrollController, 
                child: Column(
                  children: widget.items.map((item) {
                    return CheckboxListTile(
                      value: selectedItems.contains(item),
                      onChanged: (bool? value) => _onItemChanged(item, value),
                      title: Text(
                        item,
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
