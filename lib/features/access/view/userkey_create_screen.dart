import 'package:autoexplorer/features/access/bloc/user_create/user_create_bloc.dart';
import 'package:autoexplorer/features/access/widgets/region_selector.dart';
import 'package:autoexplorer/features/access/widgets/roots_info.dart';
import 'package:autoexplorer/generated/l10n.dart';
import 'package:autoexplorer/repositories/users/models/user/ae_user_role.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserKeyCreateScreen extends StatelessWidget {
  const UserKeyCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserCreateBloc()..add(LoadCreateRegionsEvent()),
      child: BlocConsumer<UserCreateBloc, UserCreateState>(
        listener: (ctx, state) {
          if (state.status == CreateStatus.success) {
            Navigator.pop(ctx, true);
            ScaffoldMessenger.of(ctx).showSnackBar(
              SnackBar(content: Text(S.of(context).userSuccessfullyCreated)),
            );
          }
          if (state.status == CreateStatus.failure) {
            ScaffoldMessenger.of(ctx).showSnackBar(
              SnackBar(
                  content:
                      Text(state.errorMessage ?? S.of(context).errorLoading)),
            );
          }
        },
        builder: (ctx, state) {
          return Scaffold(
            appBar: AppBar(title: Text(S.of(context).createNewUser)),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ФИО + Email + Password + Role
                  _buildTextField(
                    label: S.of(context).firstName,
                    value: state.firstName,
                    onChanged: (v) => ctx
                        .read<UserCreateBloc>()
                        .add(UpdateCreateFieldEvent('firstName', v)),
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    label: S.of(context).lastName,
                    value: state.lastName,
                    onChanged: (v) => ctx
                        .read<UserCreateBloc>()
                        .add(UpdateCreateFieldEvent('lastName', v)),
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    label: S.of(context).middleName,
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
                    label: S.of(context).password,
                    value: state.password,
                    obscure: true,
                    onChanged: (v) => ctx
                        .read<UserCreateBloc>()
                        .add(UpdateCreateFieldEvent('password', v)),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    title: Text(S.of(context).userRole),
                    trailing: DropdownButton<UserRole>(
                      value: state.role,
                      onChanged: (v) => ctx
                          .read<UserCreateBloc>()
                          .add(UpdateCreateFieldEvent('role', v)),
                      items: [
                        DropdownMenuItem(
                          value: UserRole.worker,
                          child: Text(S.of(context).userRoleWorker),
                        ),
                        DropdownMenuItem(
                          value: UserRole.admin,
                          child: Text(S.of(context).userRoleAdmin),
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
                      title: S.of(context).regionalTitle,
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
                  if (state.areasIdsMap.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SizedBox(
                        height: 150,
                        child: Center(
                          child: Text(
                            S.of(context).noAreas,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    )
                  else
                    RootsInfo(
                      title: S.of(context).areaTitle,
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
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(S.of(context).createButton),
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
      decoration:
          InputDecoration(labelText: label, border: const OutlineInputBorder()),
      obscureText: obscure,
      onChanged: onChanged,
    );
  }
}
