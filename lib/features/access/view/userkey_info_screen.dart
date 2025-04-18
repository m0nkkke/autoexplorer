import 'package:autoexplorer/features/access/bloc/user_edit/user_edit_bloc.dart';
import 'package:autoexplorer/features/access/widgets/access_info.dart';
import 'package:autoexplorer/features/access/widgets/region_selector.dart';
import 'package:autoexplorer/features/access/widgets/roots_info.dart';
import 'package:autoexplorer/features/access/widgets/user_info.dart';
import 'package:autoexplorer/repositories/users/models/user/ae_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserKeyInfoScreen extends StatelessWidget {
  const UserKeyInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final uid = args['uid'] as String;
    final raw = args['userData'] as Map<String, dynamic>;

    return BlocProvider(
      create: (_) => UserEditBloc(AEUser.fromFirestore(raw, uid))
        ..add(LoadRegionsEvent()),
      child: BlocConsumer<UserEditBloc, UserEditState>(
        listener: (ctx, state) {
          if (state.saved) {
            ScaffoldMessenger.of(ctx).showSnackBar(
                const SnackBar(content: Text('Изменения сохранены')));
          } else if (state.error != null) {
            ScaffoldMessenger.of(ctx)
                .showSnackBar(SnackBar(content: Text(state.error!)));
          }
        },
        builder: (ctx, state) {
          return Scaffold(
            appBar: AppBar(title: const Text('Админ‑панель')),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ФИО
                  UserInfoWidget(
                    lastName: state.lastName,
                    firstName: state.firstName,
                    middleName: state.middleName,
                    isNew: false,
                    onSaveField: (field, value) => ctx
                        .read<UserEditBloc>()
                        .add(UpdateFieldEvent(field, value)),
                  ),
                  const Divider(),
                  const SizedBox(height: 10),

                  // Статистика доступа
                  AccessInfoWidget(
                    imagesCreated: '${state.imagesCount}',
                    lastUpload: state.lastUpload,
                    accessGranted: state.accessSet,
                    accessModified: state.accessEdit,
                    emailKey: state.email,
                  ),
                  const SizedBox(height: 10),
                  const Divider(),

                  if (state.isRegionsLoading ||
                      state.regionalFolderList.isEmpty ||
                      state.isAreasLoading ||
                      state.areasIdsMap.isEmpty) ...[
                    SizedBox(
                      height: 300, 
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text('Загрузка данных'),
                          ],
                        ),
                      ),
                    ),
                  ] else ...
                  [
                    RegionSelector(
                      title: 'Регионал',
                      regions: state.regionalIdsMap.keys.toList(),
                      selectedRegion: state.regionalIdsMap.entries
                          .firstWhere((e) => e.value == state.regional)
                          .key,
                      onRegionChanged: (newName) => ctx
                          .read<UserEditBloc>()
                          .add(OnRegionChangedEvent(newName)),
                    ),
                    const SizedBox(height: 10),
                    RootsInfo(
                      title: 'Участок',
                      items: state.areasIdsMap.keys.toList(),
                      selectedItems: state.selectedAreas,
                      onChanged: (newSet) =>
                          ctx.read<UserEditBloc>().add(OnAreaChangedEvent(newSet)),
                      folderIdsMap: state.areasIdsMap,
                      isLoading: state.isAreasLoading,
                    ),
                  ],
                  const SizedBox(height: 20),

                  // Сохранить
                  Center(
                    child: ElevatedButton(
                      onPressed: () =>
                          ctx.read<UserEditBloc>().add(SubmitUserEvent()),
                      child: state.isSaving
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Сохранить изменения'),
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
}
