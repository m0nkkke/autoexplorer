import 'package:autoexplorer/features/access/bloc/user_create/user_create_bloc.dart';
import 'package:autoexplorer/features/access/widgets/roots_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:autoexplorer/repositories/users/models/user/ae_user_role.dart';
import 'package:intl/intl.dart';
import 'package:autoexplorer/repositories/users/models/accessList/access_list.dart';

class UserKeyCreateScreen extends StatefulWidget {
  const UserKeyCreateScreen({super.key});

  @override
  State<UserKeyCreateScreen> createState() => _UserKeyCreateState();
}

class _UserKeyCreateState extends State<UserKeyCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _emailController = TextEditingController(); 
  final _passwordController = TextEditingController(); 

  UserRole _role = UserRole.worker;
  final List<String> _accessList = [];

  final Set<String> selectedRegions = {};
  final Set<String> selectedSections = {};
  final Set<String> selectedSpans = {};

  String getCurrentTimeString() {
    final now = DateTime.now();
    final formatter = DateFormat('yyyy-dd-MM HH:mm:ss');
    return formatter.format(now);
  }

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
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<UserBloc>(context).add(
        CreateUserEvent(
          accessEdit: getCurrentTimeString(),
          regional: selectedRegions.first.toString(),
          accessList: _accessList,
          accessSet: getCurrentTimeString(),
          firstName: _firstNameController.text,
          imagesCount: 0,
          lastName: _lastNameController.text,
          lastUpload: 'Никогда',
          middleName: _middleNameController.text,
          role: _role,
          email: _emailController.text,
          password: _passwordController.text, 
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Админ-панель')),
      body: BlocListener<UserBloc, UserState>(
        listener: (context, state) {
          if (state.status == UserStatus.success) {
            Navigator.of(context).pop(true);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Пользователь успешно создан!')),
            );
          } else if (state.status == UserStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                      'Ошибка создания пользователя: ${state.errorMessage}')),
            );
          }
        },
        child: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Создание нового пользователя'),
                    SizedBox(height: 16),
                    _buildTextField(
                        controller: _firstNameController,
                        hintText: 'Имя',
                        validator: (value) => value == null || value.isEmpty
                            ? 'Введите имя'
                            : null),
                    const SizedBox(height: 20),
                    _buildTextField(
                        controller: _lastNameController,
                        hintText: 'Фамилия',
                        validator: (value) => value == null || value.isEmpty
                            ? 'Введите фамилию'
                            : null),
                    const SizedBox(height: 20),
                    _buildTextField(
                        controller: _middleNameController, hintText: 'Отчество'),
                    const SizedBox(height: 20),
                    _buildTextField(
                        controller: _emailController,
                        hintText: 'Email',
                        validator: (value) => value == null || value.isEmpty
                            ? 'Введите email'
                            : null),
                    const SizedBox(height: 20),
                    _buildTextField(
                        controller: _passwordController, 
                        hintText: 'Пароль',
                        obscureText: true,
                        validator: (value) => value == null || value.isEmpty
                            ? 'Введите пароль'
                            : null),
                    const SizedBox(height: 20),
                    _buildRoleDropdown(
                        role: _role,
                        onChanged: (UserRole? newValue) {
                          setState(() {
                            _role = newValue!;
                          });
                        }),
                    const Divider(),
                    RootsInfo(
                        title: 'Регион',
                        items: ['Регионал 321', 'Регионал 1', 'Регионал 2'],
                        selectedItems: selectedRegions,
                        onChanged: _onRegionsChanged),
                    const SizedBox(height: 10),
                    RootsInfo(
                        title: 'Участок',
                        items: [
                          'Участок 1',
                          'Участок 2',
                          'Участок 3',
                          'Участок 1',
                          'Участок 2',
                          'Участок 3'
                        ],
                        selectedItems: selectedSections,
                        onChanged: _onSectionsChanged),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: _save,
                        child: const Text('Создать'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    String? Function(String?)? validator,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        border: const OutlineInputBorder(),
      ),
      validator: validator,
      obscureText: obscureText,
    );
  }

  Widget _buildRoleDropdown({
    required UserRole role,
    required Function(UserRole?) onChanged,
  }) {
    return ListTile(
      title: const Text('Роль:'),
      trailing: DropdownButton<UserRole>(
        value: role,
        onChanged: onChanged,
        items: const [
          DropdownMenuItem(
            value: UserRole.worker,
            child: Text('Работник'),
          ),
          DropdownMenuItem(
            value: UserRole.admin,
            child: Text('Администратор'),
          ),
        ],
      ),
    );
  }
}