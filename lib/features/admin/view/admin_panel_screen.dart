import 'package:autoexplorer/features/admin/widgets/appbar_actions.dart';
import 'package:flutter/material.dart';
import '../widgets/storage_info.dart';
import '../widgets/disk_tab.dart';
import '../widgets/control_tab.dart';
import '../widgets/create_tab.dart';

class AdminPanelScreen extends StatelessWidget {
  const AdminPanelScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Админ-панель',             
          style: Theme.of(context).textTheme.bodyLarge,),
          actions: [AppBarActions()],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(120),
            child: Column(
              children: const [
                StorageInfo(connectionStatus: true, 
                foldersCount: 3053, 
                imagesCount: 12549, 
                storagePercentage: 20,
                currentStorageSize: 20,
                totalStorageSize: 100,
                ),
                TabBar(
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
    );
  }
}
