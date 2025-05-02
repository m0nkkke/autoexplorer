import 'package:autoexplorer/features/admin/bloc/control/control_bloc.dart';
import 'package:autoexplorer/features/admin/widgets/key_list_item.dart';
import 'package:autoexplorer/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ControlTab extends StatefulWidget {
  const ControlTab({super.key});

  @override
  State<ControlTab> createState() => _ControlTabState();
}

class _ControlTabState extends State<ControlTab> {
  late final ControlBloc _controlBloc;

  @override
  void initState() {
    super.initState();
    _controlBloc = ControlBloc()..add(LoadUsers());
  }

  @override
  void dispose() {
    _controlBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ControlBloc>(
      create: (context) => _controlBloc,
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/access/create');
                  },
                  icon: const Icon(Icons.add_box,
                      color: Colors.lightBlue, size: 32),
                  label: Text(S.of(context).createNewAccessKey),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.black,
                    elevation: 0,
                  ),
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<ControlBloc, ControlState>(
                builder: (context, state) {
                  if (state.status == ControlStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.status == ControlStatus.failure) {
                    return Center(
                        child: Text(S
                            .of(context)
                            .errorWithMessage(state.errorMessage.toString())));
                  }
                  if (state.users.isEmpty) {
                    return Center(child: Text(S.of(context).noAvailableUsers));
                  }

                  return ListView.builder(
                    itemCount: state.users.length,
                    itemBuilder: (context, index) {
                      final doc = state.users[index];
                      final user = doc.data() as Map<String, dynamic>;
                      final uid = doc.id;
                      final regionId = user['regional'] as String;
                      // вот здесь сразу берём имя региона из мапы
                      final regionName = state.regionNamesMap[regionId] ?? '—';

                      return KeyListItem(
                        keyUserName: '${user['firstName']} ${user['lastName']}',
                        keyArea: regionName,
                        userData: user,
                        uid: uid,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
