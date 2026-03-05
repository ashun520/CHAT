import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens/splash/splash_screen.dart';
import '../screens/login/login_screen.dart';
import '../screens/register/register_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/chat/chat_screen.dart';
import '../screens/contact/contact_screen.dart';
import '../screens/discover/discover_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/group/group_create_screen.dart';
import '../screens/group/group_info_screen.dart';
import '../screens/friend/friend_request_screen.dart';
import '../screens/friend/friend_add_screen.dart';
import '../screens/moment/moment_screen.dart';

class Routes {
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';
  static const chat = '/chat';
  static const contact = '/contact';
  static const discover = '/discover';
  static const profile = '/profile';
  static const groupCreate = '/group/create';
  static const groupInfo = '/group/info';
  static const friendRequest = '/friend/request';
  static const friendAdd = '/friend/add';
  static const moment = '/moment';

  static final routes = [
    GetPage(
      name: splash,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: login,
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: register,
      page: () => const RegisterScreen(),
    ),
    GetPage(
      name: home,
      page: () => const HomeScreen(),
    ),
    GetPage(
      name: chat,
      page: () => const ChatScreen(),
      arguments: ['conversationId', 'conversationType', 'title', 'avatar'],
    ),
    GetPage(
      name: contact,
      page: () => const ContactScreen(),
    ),
    GetPage(
      name: discover,
      page: () => const DiscoverScreen(),
    ),
    GetPage(
      name: profile,
      page: () => const ProfileScreen(),
    ),
    GetPage(
      name: groupCreate,
      page: () => const GroupCreateScreen(),
    ),
    GetPage(
      name: groupInfo,
      page: () => const GroupInfoScreen(),
    ),
    GetPage(
      name: friendRequest,
      page: () => const FriendRequestScreen(),
    ),
    GetPage(
      name: friendAdd,
      page: () => const FriendAddScreen(),
    ),
    GetPage(
      name: moment,
      page: () => const MomentScreen(),
    ),
  ];
}
