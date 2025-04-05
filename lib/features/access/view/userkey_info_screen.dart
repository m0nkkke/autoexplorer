import 'package:autoexplorer/features/access/bloc/user_edit/user_edit_bloc.dart';
import 'package:autoexplorer/features/access/widgets/access_info.dart';
import 'package:autoexplorer/features/access/widgets/roots_info.dart';
import 'package:autoexplorer/features/access/widgets/user_info.dart';
import 'package:autoexplorer/repositories/users/models/user/ae_user.dart';
import 'package:autoexplorer/repositories/users/users_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class UserKeyInfoScreen extends StatefulWidget {
  const UserKeyInfoScreen({super.key});

  @override
  State<UserKeyInfoScreen> createState() => _UserKeyInfoState();
}

class _UserKeyInfoState extends State<UserKeyInfoScreen> {
  late UserEditBloc _userEditBloc;
  Map<String, dynamic> user = {};

  final Set<String> selectedRegions = {};
  final Set<String> selectedAreas = {};

  void _onRegionsChanged(Set<String> newSelection) {
    setState(() {
      selectedRegions.clear();
      selectedRegions.addAll(newSelection);
    });
  }

  void _onAreasChanged(Set<String> newSelection) {
    setState(() {
      selectedAreas.clear();
      selectedAreas.addAll(newSelection);
    });

    _userEditBloc.add(UpdateAccessListEvent(newSelection.toList()));
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final Map<String, dynamic> arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final String uid = arguments['uid']; 

    setState(() {
      user = arguments['userData'];
    });

    _userEditBloc = UserEditBloc(UsersRepository(), AEUser.fromFirestore(user, uid));
  }

  @override
  void dispose() {
    _userEditBloc.close();
    super.dispose();
  }

  void _handleSaveData(Map<String, String> userData) {
    final updatedUser = _userEditBloc.state.toUser();

    updatedUser.lastName = userData['lastName'] ?? updatedUser.lastName;
    updatedUser.firstName = userData['firstName'] ?? updatedUser.firstName;
    updatedUser.middleName = userData['middleName'] ?? updatedUser.middleName;

    _userEditBloc.add(SubmitUserEvent(updatedUser));

    print('Данные отправлены на сервер: $updatedUser');
  }

  List<String> _getSortedItems(List<String> items, Set<String> selectedItems) {
    selectedItems.addAll(items);
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Админ-панель')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: BlocProvider<UserEditBloc>(
          create: (_) => _userEditBloc,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<UserEditBloc, UserEditState>(
                builder: (context, state) {
                  return UserInfoWidget(
                    lastName: state.lastName,
                    firstName: state.firstName,
                    middleName: state.middleName,
                    isNew: false,
                    onSaveData: _handleSaveData,
                  );
                },
              ),
              Divider(),
              SizedBox(height: 10),
              BlocBuilder<UserEditBloc, UserEditState>(
                builder: (context, state) {
                  return AccessInfoWidget(
                    imagesCreated: '${state.imagesCount}',
                    lastUpload: state.lastUpload,
                    accessGranted: state.accessSet,
                    accessModified: state.accessEdit,
                    emailKey: state.email,
                  );
                },
              ),
              SizedBox(height: 10),
              Divider(),
              BlocBuilder<UserEditBloc, UserEditState>(
                builder: (context, state) {
                  return RootsInfo(
                    title: 'Регионал',
                    items: _getSortedItems(
                      [state.regional],
                      selectedRegions,
                    ),
                    selectedItems: selectedRegions,
                    onChanged: _onRegionsChanged,
                  );
                },
              ),
              SizedBox(height: 10),
              BlocBuilder<UserEditBloc, UserEditState>(
                builder: (context, state) {
                  return RootsInfo(
                    title: 'Участок',
                    items: _getSortedItems(
                      List<String>.from(state.accessList),
                      selectedAreas,
                    ),
                    selectedItems: selectedAreas,
                    onChanged: _onAreasChanged,
                  );
                },
              ),
              SizedBox(height: 10),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    final userData = {
                      'lastName': _userEditBloc.state.lastName,
                      'firstName': _userEditBloc.state.firstName,
                      'middleName': _userEditBloc.state.middleName,
                    };
                    _handleSaveData(userData);
                  },
                  child: const Text('Сохранить изменения'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
