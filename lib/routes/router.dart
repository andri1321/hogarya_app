/// 🔥 GOROUTER COMPLETO Y ACTUALIZADO

import 'package:app_hogar_ya/core/main_screen.dart';
import 'package:app_hogar_ya/models/property.dart';

import 'package:app_hogar_ya/screen/add_new_publication._screen.dart';
import 'package:app_hogar_ya/screen/chat_conversation_screen.dart';
import 'package:app_hogar_ya/screen/chat_screen.dart';
import 'package:app_hogar_ya/screen/feed_screen.dart';
import 'package:app_hogar_ya/screen/profile_screen.dart';
import 'package:app_hogar_ya/screen/property_details_screen.dart';
import 'package:app_hogar_ya/screen/search_screen.dart';
import 'package:app_hogar_ya/screen/setting_screen.dart';

import 'package:go_router/go_router.dart';

final router = GoRouter(

  initialLocation: '/',

  routes: [

    ShellRoute(

      builder: (context, state, child) {
        return MainScreen(
          child: child,
        );
      },

      routes: [

        /// 🔥 HOME
        GoRoute(
          path: '/',
          builder: (context, state) =>
              const FeedScreen(),
        ),

        /// 🔥 PROFILE
        GoRoute(
          path: '/profile',
          builder: (context, state) =>
              const ProfileScreen(),
        ),

        /// 🔥 CHAT
        GoRoute(
          path: '/chat',
          builder: (context, state) =>
              const ChatScreen(),
        ),

        GoRoute(
          path: '/chatConversation',
          builder: (context, state) {

            final extra = state.extra;

            return ChatConversationScreen(
              property: extra is Property
                  ? extra
                  : null,
              chat: extra is Map<String, dynamic>
                  ? extra
                  : null,
            );
          },
        ),

        /// 🔥 ADD
        GoRoute(
          path: '/add',
          builder: (context, state) =>
              const AddNewPublicationScreen(),
        ),

        /// 🔥 SEARCH
        GoRoute(
          path: '/search',
          builder: (context, state) =>
              const SearchScreen(),
        ),

        /// 🔥 SETTINGS
        GoRoute(
          path: '/settings',
          builder: (context, state) =>
              const SettingsScreen(),
        ),

        /// 🔥 PROPERTY DETAILS
        GoRoute(
          path: '/property-details',

          builder: (context, state) {

            final property =
                state.extra as Property;

            return PropertyDetailsScreen(
              property: property,
            );
          },
        ),
      ],
    ),
  ],
);
