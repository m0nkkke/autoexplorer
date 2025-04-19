import 'package:autoexplorer/features/admin/bloc/storageInfo/storage_info_bloc.dart';
import 'package:autoexplorer/features/admin/widgets/appbar_actions.dart';
import 'package:autoexplorer/features/admin/widgets/storage_info.dart';
import 'package:autoexplorer/features/admin/widgets/disk_tab.dart';
import 'package:autoexplorer/features/admin/widgets/control_tab.dart';
import 'package:autoexplorer/features/admin/widgets/create_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminPanelScreen extends StatelessWidget {
  const AdminPanelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StorageInfoBloc>(
      create: (_) => StorageInfoBloc()..add(LoadStorageInfo()),
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Админ‑панель',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            actions: [AppBarActions()],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(120),
              child: Column(
                children: [
                  // сначала блок с данными хранилища
                  BlocBuilder<StorageInfoBloc, StorageInfoState>(
                    builder: (context, state) {
                      if (state.status == StorageInfoStatus.loading) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (state.status == StorageInfoStatus.failure) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Text('Ошибка: ${state.errorMessage}'),
                        );
                      }
                      // success
                      return StorageInfo(
                        connectionStatus:    state.connectionStatus,
                        imagesCount:         state.imagesCount,
                        storagePercentage:   state.storagePercentage,
                        currentStorageSize:  state.currentStorageSize,
                        totalStorageSize:    state.totalStorageSize,
                      );
                    },
                  ),
                  // и только потом таббар
                  const TabBar(
                    labelColor: Colors.blue,
                    unselectedLabelColor: Colors.black,
                    indicatorColor: Colors.blue,
                    tabs: [
                      Tab(text: 'Диск'),
                      Tab(text: 'Контроль'),
                      Tab(text: 'Создание'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          body: const TabBarView(
            children: [
              DiskTab(),
              ControlTab(),
              CreateTab(),
            ],
          ),
        ),
      ),
    );
  }
}
