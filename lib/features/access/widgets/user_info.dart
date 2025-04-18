import 'package:flutter/material.dart';

class UserInfoWidget extends StatefulWidget {
  final String? lastName;
  final String? firstName;
  final String? middleName;
  final bool isNew;

  /// Теперь мы зовем его при сохранении каждого отдельного поля
  final void Function(String fieldName, String newValue) onSaveField;

  const UserInfoWidget({
    super.key,
    this.lastName,
    this.firstName,
    this.middleName,
    this.isNew = false,
    required this.onSaveField,
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
    _lastNameController   = TextEditingController(text: widget.lastName   ?? '');
    _firstNameController  = TextEditingController(text: widget.firstName  ?? '');
    _middleNameController = TextEditingController(text: widget.middleName ?? '');

    _isEditingLastName   = widget.isNew;
    _isEditingFirstName  = widget.isNew;
    _isEditingMiddleName = widget.isNew;
  }

  @override
  void didUpdateWidget(covariant UserInfoWidget old) {
    super.didUpdateWidget(old);
    // Синхронизируем контроллеры, когда в widget.* придут новые значения из BLoC
    if (widget.lastName != old.lastName) {
      _lastNameController.text = widget.lastName ?? '';
    }
    if (widget.firstName != old.firstName) {
      _firstNameController.text = widget.firstName ?? '';
    }
    if (widget.middleName != old.middleName) {
      _middleNameController.text = widget.middleName ?? '';
    }
  }

  @override
  void dispose() {
    _lastNameController.dispose();
    _firstNameController.dispose();
    _middleNameController.dispose();
    super.dispose();
  }

  void _onEditPressed({
    required String fieldName,
    required TextEditingController controller,
    required bool isEditing,
    required VoidCallback toggleEditing,
  }) {
    toggleEditing();
    if (!isEditing) {
      widget.onSaveField(fieldName, controller.text);
    }
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
          onEditPressed: () => _onEditPressed(
            fieldName: 'lastName',
            controller: _lastNameController,
            isEditing: _isEditingLastName,
            toggleEditing: () => setState(() => _isEditingLastName = !_isEditingLastName),
          ),
        ),
        _buildEditableInfoRow(
          label: 'Имя',
          controller: _firstNameController,
          isEditing: _isEditingFirstName,
          onEditPressed: () => _onEditPressed(
            fieldName: 'firstName',
            controller: _firstNameController,
            isEditing: _isEditingFirstName,
            toggleEditing: () => setState(() => _isEditingFirstName = !_isEditingFirstName),
          ),
        ),
        _buildEditableInfoRow(
          label: 'Отчество',
          controller: _middleNameController,
          isEditing: _isEditingMiddleName,
          onEditPressed: () => _onEditPressed(
            fieldName: 'middleName',
            controller: _middleNameController,
            isEditing: _isEditingMiddleName,
            toggleEditing: () => setState(() => _isEditingMiddleName = !_isEditingMiddleName),
          ),
        ),
      ],
    );
  }

  Widget _buildEditableInfoRow({
    required String label,
    required TextEditingController controller,
    required bool isEditing,
    required VoidCallback onEditPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 120,
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
                  )
                : Text(controller.text.isEmpty ? '—' : controller.text),
          ),
          IconButton(
            icon: Icon(isEditing ? Icons.check : Icons.edit),
            onPressed: onEditPressed,
          ),
        ],
      ),
    );
  }
}
