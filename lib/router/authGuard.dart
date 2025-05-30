import 'package:autoexplorer/global.dart';
import 'package:autoexplorer/repositories/users/abstract_users_repository.dart';
import 'package:autoexplorer/repositories/users/models/user/ae_user_role.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class AuthGuard extends NavigatorObserver {
  final AbstractUsersRepository _usersRepository =
      GetIt.I<AbstractUsersRepository>();
  bool _initialAuthCheckDone = false;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _checkAuth(route.settings.name);
    super.didPush(route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    _checkAuth(newRoute?.settings.name);
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _checkAuth(previousRoute?.settings.name);
    super.didPop(route, previousRoute);
  }

  Future<void> _checkAuth(String? routeName) async {
    final user = FirebaseAuth.instance.currentUser;

    if (!_initialAuthCheckDone) {
      _initialAuthCheckDone = true;
      if (user != null && routeName == '/') {
        final userData = await _usersRepository.getUserByUid(user.uid);
        final userRole = userData?.role;
        globalRole = userRole;
        if (userData != null) {
          globalAccessList = null;
          if (userRole == UserRole.admin) {
            navigator?.pushNamedAndRemoveUntil('/admin', (route) => false);
          } else {
            navigator?.pushNamedAndRemoveUntil('/storage', (route) => false);
          }
          return;
        }
      }
    }

    if (user == null && routeName != '/') {
      navigator?.pushNamedAndRemoveUntil('/', (route) => false);
      return;
    }
    if (user != null) {
      final userData = await _usersRepository.getUserByUid(user.uid);
      final userRole = userData?.role;
      print('CHECKER+++++++++++++++++++++++++++++++++++++');
      if (routeName == '/admin' && userRole != UserRole.admin) {
        navigator?.pushNamedAndRemoveUntil('/storage', (route) => false);
      } else if (routeName != '/' &&
          routeName != '/admin' &&
          userRole == null) {
        navigator?.pushNamedAndRemoveUntil('/', (route) => false);
      }
    }
  }
}
