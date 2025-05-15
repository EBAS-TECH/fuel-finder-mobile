import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuel_finder/features/map/presentation/pages/profile_page.dart';
import 'package:fuel_finder/features/user/presentation/bloc/user_bloc.dart';
import 'package:fuel_finder/features/user/presentation/bloc/user_event.dart';
import 'package:fuel_finder/features/user/presentation/bloc/user_state.dart';
import 'package:fuel_finder/core/themes/app_palette.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? userId;
  final bool showUserInfo;
  final String? title;
  final List<Widget>? actions;
  final bool? centerTitle;

  const CustomAppBar({
    super.key,
    this.userId,
    this.showUserInfo = false,
    this.title,
    this.actions,
    this.centerTitle,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Only fetch user data once when the widget is first built
    if (showUserInfo && userId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<UserBloc>().add(GetUserByIdEvent(userId: userId!));
      });
    }

    return AppBar(
      centerTitle: centerTitle,
      automaticallyImplyLeading: false,
      backgroundColor: AppPallete.primaryColor,
      title:
          showUserInfo && userId != null
              ? BlocBuilder<UserBloc, UserState>(
                buildWhen: (previous, current) {
                  // Only rebuild if the state actually changed
                  return current is UserSuccess || current is UserFailure;
                },
                builder: (context, state) {
                  if (state is UserSuccess) {
                    final user = state.responseData;
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    ProfilePage(userId: user["data"]["id"]),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                              'https://api.dicebear.com/7.x/initials/png?seed=${user["data"]["first_name"][0]}${user["data"]["last_name"][0]}&backgroundColor=eeeeee&textColor=000000&bold=true&radius=50',
                            ),
                            radius: 20,
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.heyThere,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                "${user["data"]["first_name"]} ${user["data"]["last_name"]}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
                  return Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                          'https://robohash.org/user123.png',
                        ),
                        radius: 20,
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.heyThere,
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          Text(
                            l10n.loading,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              )
              : Text(
                title ?? "HomePage",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

