import 'package:autoexplorer/features/access/bloc/user_create/user_create_bloc.dart';
import 'package:autoexplorer/features/access/widgets/region_selector.dart';
import 'package:autoexplorer/features/access/widgets/roots_info.dart';
import 'package:autoexplorer/repositories/users/models/user/ae_user_role.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserKeyCreateScreen extends StatelessWidget {
  const UserKeyCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserCreateBloc(
      )..add(LoadCreateRegionsEvent()),
      child: BlocConsumer<UserCreateBloc, UserCreateState>(
        listener: (ctx, state) {
          if (state.status == CreateStatus.success) {
            Navigator.pop(ctx, true);
            ScaffoldMessenger.of(ctx).showSnackBar(
              const SnackBar(content: Text('Пользователь создан')),
            );
          }
          if (state.status == CreateStatus.failure) {
            ScaffoldMessenger.of(ctx).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Ошибка')),
            );
          }
        },
        builder: (ctx, state) {
          return Scaffold(
            appBar: AppBar(title: const Text('Создать пользователя')),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ФИО + Email + Password + Role
                  _buildTextField(
                    label: 'Имя',
                    value: state.firstName,
                    onChanged: (v) => ctx
                        .read<UserCreateBloc>()
                        .add(UpdateCreateFieldEvent('firstName', v)),
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    label: 'Фамилия',
                    value: state.lastName,
                    onChanged: (v) => ctx
                        .read<UserCreateBloc>()
                        .add(UpdateCreateFieldEvent('lastName', v)),
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    label: 'Отчество',
                    value: state.middleName,
                    onChanged: (v) => ctx
                        .read<UserCreateBloc>()
                        .add(UpdateCreateFieldEvent('middleName', v)),
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    label: 'Email',
                    value: state.email,
                    onChanged: (v) => ctx
                        .read<UserCreateBloc>()
                        .add(UpdateCreateFieldEvent('email', v)),
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    label: 'Пароль',
                    value: state.password,
                    obscure: true,
                    onChanged: (v) => ctx
                        .read<UserCreateBloc>()
                        .add(UpdateCreateFieldEvent('password', v)),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    title: const Text('Роль'),
                    trailing: DropdownButton<UserRole>(
                      value: state.role,
                      onChanged: (v) => ctx
                          .read<UserCreateBloc>()
                          .add(UpdateCreateFieldEvent('role', v)),
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
                  ),

                  const Divider(),
                  const SizedBox(height: 10),

                  // Регион
                  if (state.isRegionsLoading)
                    const Center(child: CircularProgressIndicator())
                  else
                    RegionSelector(
                      title: 'Регионал',
                      regions: state.regionalIdsMap.keys.toList(),
                      selectedRegion: state.regional.isEmpty
                          ? null
                          : state.regionalIdsMap.entries
                              .firstWhere((e) => e.value == state.regional)
                              .key,
                      onRegionChanged: (name) => ctx
                          .read<UserCreateBloc>()
                          .add(OnCreateRegionChangedEvent(name)),
                    ),

                  const SizedBox(height: 16),

                  // Участки
                  RootsInfo(
                    title: 'Участок',
                    items: state.areasIdsMap.keys.toList(),
                    selectedItems: state.selectedAreas,
                    onChanged: (set) => ctx
                        .read<UserCreateBloc>()
                        .add(OnCreateAreaChangedEvent(set)),
                    folderIdsMap: state.areasIdsMap,
                    isLoading: state.isAreasLoading,
                  ),

                  const SizedBox(height: 24),

                  Center(
                    child: ElevatedButton(
                      onPressed: state.status == CreateStatus.loading
                          ? null
                          : () => ctx
                              .read<UserCreateBloc>()
                              .add(SubmitCreateEvent()),
                      child: state.status == CreateStatus.loading
                          ? const CircularProgressIndicator(
                              color: Colors.white)
                          : const Text('Создать'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String value,
    bool obscure = false,
    required ValueChanged<String> onChanged,
  }) {
    return TextFormField(
      initialValue: value,
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      obscureText: obscure,
      onChanged: onChanged,
    );
  }
}
