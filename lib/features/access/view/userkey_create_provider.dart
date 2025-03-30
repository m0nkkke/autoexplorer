import 'package:autoexplorer/features/access/view/userkey_create_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:autoexplorer/features/access/bloc/user_create/user_create_bloc.dart';
import 'package:autoexplorer/repositories/users/users_repository.dart'; 

class UserKeyCreateProvider extends StatelessWidget {
  const UserKeyCreateProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserBloc>(
      create: (context) => UserBloc(UsersRepository()), 
      child: const UserKeyCreateScreen(),
    );
  }
}