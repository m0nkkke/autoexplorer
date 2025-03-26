import 'package:autoexplorer/features/admin/widgets/template_list_item.dart';
import 'package:flutter/material.dart';

class CreateTab extends StatelessWidget {
  const CreateTab({Key? key}) : super(key: key);

  @override
 Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(left: 16, top: 16),
      children: [
        Align( 
          alignment: Alignment.centerLeft, 
          child: ElevatedButton.icon(
            onPressed: () {
              
            },
            icon: const Icon(Icons.add_box, color: Colors.lightBlue, size: 32), 
            label: const Text('Добавить новый шаблон создания'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.black, 
              elevation: 0,
            ),
          ),
        ),
        TemplateListItem(templateName: 'Шаблон участок 1',),
        TemplateListItem(templateName: 'Шаблон участок 2',),
        TemplateListItem(templateName: 'Шаблон участок 3',),
        TemplateListItem(templateName: 'Шаблон участок 4',),
      ],
    );
  }
}
