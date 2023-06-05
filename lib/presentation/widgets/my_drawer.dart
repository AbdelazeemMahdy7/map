import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maps/constants/my_colors.dart';
import 'package:maps/constants/strings.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../business_logic/cubit/phone_auth/phone_auth_cubit.dart';

class MyDrawer extends StatelessWidget {
  MyDrawer({Key? key}) : super(key: key);

  final Uri _urlLink = Uri.parse('https://flutter.dev');
  PhoneAuthCubit phoneAuthCubit = PhoneAuthCubit();

  Widget buildDrawerHead(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsetsDirectional.fromSTEB(70, 10, 70, 10),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.blue[150],
          ),
          child: CircleAvatar(
            backgroundImage: AssetImage("assets/images/Abdelazeem.jpg"),
            radius: 50,
          ),
        ),
        const Text(
          "Abdelazeem Mahdy",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 6,
        ),
        BlocProvider<PhoneAuthCubit>(
          create: (context) => phoneAuthCubit,
          child: Text(
            "${phoneAuthCubit.getLogedInUser().phoneNumber}",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

        ),
      ],
    );
  }

  Widget buildDrawerListItem({
    required String title,
    required IconData leadingIcon,
    Color? color,
    Widget? tralier,
    Function()? onTap,
  }) {
    return ListTile(
      title: Text(title),
      onTap: onTap,
      leading: Icon(
        leadingIcon,
        color: color ?? MyColors.blue,
      ),
      trailing: tralier ??
          const Icon(
            Icons.arrow_forward,
            color: MyColors.blue,
          ),
    );
  }

  Widget buildDrawerListDivider() {
    return const Divider(
      height: 0,
      thickness: 1.0,
      indent: 18,
      endIndent: 24,
    );
  }

  Widget buildLogOutBlocProvider(context) {
    return BlocProvider<PhoneAuthCubit>(
      create: (context) => phoneAuthCubit,
      child: buildDrawerListItem(
        title: "Log out",
        leadingIcon: Icons.logout,
        color: Colors.red,
        onTap: () async {
          await phoneAuthCubit.logOut();
          Navigator.of(context).pushReplacementNamed(loginScreen);
        },
        tralier: const SizedBox(),
      ),
    );
  }

  Future<void> _launchUrl(String _url) async {
    if (!await canLaunchUrl(_urlLink)) {
      throw Exception('Could not launch $_url');
    }
  }

  Widget buildIcons(IconData iconData, String url) {
    return InkWell(
      onTap: () => _launchUrl,
      child: Icon(
        iconData,
        color: MyColors.blue,
        size: 33,
      ),
    );
  }

  Widget buildSocialMesiaIcons() {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 16),
      child: Row(
        children: [
          buildIcons(FontAwesomeIcons.facebook,
              "https://www.facebook.com/zema.mahdy?mibextid=ZbWKwL"),
          buildIcons(FontAwesomeIcons.github,
              "https://www.facebook.com/zema.mahdy?mibextid=ZbWKwL"),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Container(
          height: 230,
          child: DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue[100],
            ),
            child: buildDrawerHead(context),
          ),
        ),
        buildDrawerListItem(
          title: "My Profile",
          leadingIcon: Icons.person,
        ),
        buildDrawerListDivider(),
        buildDrawerListItem(
            title: "History", leadingIcon: Icons.place, onTap: () {}),
        buildDrawerListDivider(),
        buildDrawerListItem(
          title: "Settings",
          leadingIcon: Icons.settings,
        ),
        buildDrawerListDivider(),
        buildDrawerListItem(
          title: "Help",
          leadingIcon: Icons.help,
        ),
        buildDrawerListDivider(),
        buildLogOutBlocProvider(context),
      ],
    );
  }
}
