import 'package:autoexplorer/features/login/bloc/login_bloc.dart';
import 'package:autoexplorer/features/login/bloc/login_event.dart';
import 'package:autoexplorer/features/login/bloc/login_state.dart';
import 'package:autoexplorer/features/login/widgets/input_field.dart';
import 'package:autoexplorer/features/login/widgets/login_button.dart';
import 'package:autoexplorer/features/login/widgets/logo_widget.dart';
import 'package:autoexplorer/repositories/users/models/user/ae_user_role.dart';
import 'package:autoexplorer/repositories/users/users_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      body: BlocProvider(
        create: (context) => LoginBloc(UsersRepository()),
        child: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state.status == LoginStatus.success) {
              if (state.role == UserRole.admin) {
                Navigator.of(context).pushNamed('/admin');
              } else if (state.role == UserRole.worker) {
                Navigator.of(context).pushNamed('/storage');
              }
            } else if (state.status == LoginStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage ?? 'Ошибка входа')),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const LogoWidget(),
                    const SizedBox(height: 32),
                    InputField(
                      labelText: 'Email',
                      hintText: 'Например: example@email.com',
                      controller: emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Пожалуйста, введите email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    InputField(
                      labelText: 'Пароль',
                      hintText: 'Например: 123qwe',
                      controller: passwordController,
                      isPassword: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Пожалуйста, введите пароль';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    BlocBuilder<LoginBloc, LoginState>(
                      builder: (context, state) {
                        return LoginButton(
                          onPressed: state.status == LoginStatus.loading
                              ? null
                              : () {
                                  if (_formKey.currentState?.validate() ??
                                      false) {
                                    context.read<LoginBloc>().add(
                                          LoginButtonPressed(
                                            emailKey: emailController.text,
                                            password: passwordController.text,
                                          ),
                                        );
                                  }
                                },
                          isLoading: state.status == LoginStatus.loading,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}