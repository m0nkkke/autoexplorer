import 'package:autoexplorer/features/access/bloc/user_create/user_create_bloc.dart';
import 'package:autoexplorer/features/access/view/userkey_create_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserKeyCreateProvider extends StatelessWidget {
  const UserKeyCreateProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserCreateBloc>(
      create: (_) => UserCreateBloc(
      )..add(LoadCreateRegionsEvent()),  // Загрузить регионы сразу
      child: const UserKeyCreateScreen(),
    );
  }
}
