import 'package:flutter/material.dart';

class UserInfoWidget extends StatefulWidget {
  final String? lastName;
  final String? firstName;
  final String? middleName;
  final bool isNew;
  final ValueChanged<Map<String, String>> onSaveData; // Добавляем колбэк

  const UserInfoWidget({
    super.key,
    this.lastName,
    this.firstName,
    this.middleName,
    this.isNew = false,
    required this.onSaveData, // Инициализируем колбэк
  });

  @override
  State<UserInfoWidget> createState() => _UserInfoWidgetState();
}

class _UserInfoWidgetState extends State<UserInfoWidget> {
  late TextEditingController _lastNameController;
  late TextEditingController _firstNameController;
  late TextEditingController _middleNameController;

  bool _isEditingLastName = false;
  bool _isEditingFirstName = false;
  bool _isEditingMiddleName = false;

  @override
  void initState() {
    super.initState();

    _lastNameController = TextEditingController(text: widget.lastName ?? '');
    _firstNameController = TextEditingController(text: widget.firstName ?? '');
    _middleNameController = TextEditingController(text: widget.middleName ?? '');

    _isEditingLastName = widget.isNew;
    _isEditingFirstName = widget.isNew;
    _isEditingMiddleName = widget.isNew;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Контроль доступа и учетной записи',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildEditableInfoRow(
          label: 'Фамилия',
          controller: _lastNameController,
          isEditing: _isEditingLastName,
          onEditPressed: () {
            setState(() {
              _isEditingLastName = !_isEditingLastName;
            });
          },
          onSave: () {
            setState(() {
              _isEditingLastName = false;
            });
            widget.onSaveData({
              'lastName': _lastNameController.text,
              'firstName': _firstNameController.text,
              'middleName': _middleNameController.text,
            });
          },
        ),
        _buildEditableInfoRow(
          label: 'Имя',
          controller: _firstNameController,
          isEditing: _isEditingFirstName,
          onEditPressed: () {
            setState(() {
              _isEditingFirstName = !_isEditingFirstName;
            });
          },
          onSave: () {
            setState(() {
              _isEditingFirstName = false;
            });
            widget.onSaveData({
              'lastName': _lastNameController.text,
              'firstName': _firstNameController.text,
              'middleName': _middleNameController.text,
            });
          },
        ),
        _buildEditableInfoRow(
          label: 'Отчество',
          controller: _middleNameController,
          isEditing: _isEditingMiddleName,
          onEditPressed: () {
            setState(() {
              _isEditingMiddleName = !_isEditingMiddleName;
            });
          },
          onSave: () {
            setState(() {
              _isEditingMiddleName = false;
            });
            widget.onSaveData({
              'lastName': _lastNameController.text,
              'firstName': _firstNameController.text,
              'middleName': _middleNameController.text,
            });
          },
        ),
        _buildStaticInfoRow(
          label: 'Регионал',
          value: 'Регионал 321',
        ),
      ],
    );
  }

  Widget _buildEditableInfoRow({
    required String label,
    required TextEditingController controller,
    required bool isEditing,
    required VoidCallback onEditPressed,
    required VoidCallback onSave,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 100, // Фиксированная ширина для выравнивания заголовков
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: isEditing
                ? TextFormField(
                    controller: controller,
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      border: OutlineInputBorder(),
                    ),
                    onFieldSubmitted: (_) => onSave(),
                  )
                : Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      controller.text.isEmpty ? '—' : controller.text,
                    ),
                  ),
          ),
          IconButton(
            icon: Icon(isEditing ? Icons.check : Icons.edit),
            onPressed: isEditing ? onSave : onEditPressed,
          ),
        ],
      ),
    );
  }

  Widget _buildStaticInfoRow({
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                value,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
