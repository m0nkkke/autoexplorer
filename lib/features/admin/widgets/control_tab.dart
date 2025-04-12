import 'package:autoexplorer/features/admin/bloc/control/control_bloc.dart';
import 'package:autoexplorer/features/admin/widgets/key_list_item.dart';
import 'package:autoexplorer/repositories/users/users_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ControlTab extends StatefulWidget {
  const ControlTab({Key? key}) : super(key: key);

  @override
  State<ControlTab> createState() => _ControlTabState();
}

class _ControlTabState extends State<ControlTab> {
  late final UsersRepository _usersRepository;
  late final ControlBloc _controlBloc;

  @override
  void initState() {
    super.initState();
    _usersRepository = UsersRepository();
    _controlBloc = ControlBloc(_usersRepository)..add(LoadUsers());
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
                  label: const Text('Создать новый ключ доступа'),
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
                  } else if (state.status == ControlStatus.failure) {
                    return Center(child: Text('Ошибка: ${state.errorMessage}'));
                  } else if (state.users.isEmpty) {
                    return const Center(child: Text('Нет доступных пользователей'));
                  } else {
                    return ListView.builder(
                      itemCount: state.users.length,
                      itemBuilder: (context, index) {
                        final user = state.users[index].data()
                            as Map<String, dynamic>;
                        final uid = state.users[index].id;
                        return KeyListItem(
                          keyUserName: user['firstName'] + ' ' + user['lastName'],
                          keyArea: user['regional'],
                          userData: user,
                          uid: uid,
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}