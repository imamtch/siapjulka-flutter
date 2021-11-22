import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siapjulka/constant/pallete_color.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:siapjulka/models/user.dart';
import 'package:siapjulka/network/domain.dart';
import 'package:siapjulka/routes/name_route.dart';
// import 'package:siapjulka/unit_test/controller/user_controller.dart';
import 'package:siapjulka/services/user_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool showPassword = false;
  int id = 0;
  late Future<User> futureUser;

  @override
  void initState() {
    super.initState();
    getUserID();
    futureUser = UserService().getUser();
  }

  Widget buildTextField(
    IconData iconData,
    String labelText,
    String placeholder,
    bool isPasswordTextField,
    bool enabled,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          // wrap your Column in Expanded
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Icon(
              iconData,
              color: Pallete.primaryColor,
            ),
          ),
        ),
        Expanded(
          flex: 5,
          // wrap your Column in Expanded
          child: Padding(
            padding: const EdgeInsets.only(bottom: 35.0),
            child: TextField(
              enabled: enabled,
              obscureText: isPasswordTextField ? showPassword : false,
              decoration: InputDecoration(
                suffixIcon: isPasswordTextField
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            showPassword = !showPassword;
                          });
                        },
                        icon: const Icon(
                          Icons.remove_red_eye,
                          color: Colors.grey,
                        ),
                      )
                    : null,
                contentPadding: const EdgeInsets.only(bottom: 3),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                hintText: placeholder,
                labelText: labelText,
                hintStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: FutureBuilder<User>(
        future: futureUser,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              padding: const EdgeInsets.only(left: 15, top: 15, right: 15),
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: ListView(
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            width: 130,
                            height: 130,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 4,
                                  color: Theme.of(context)
                                      .scaffoldBackgroundColor),
                              boxShadow: [
                                BoxShadow(
                                    spreadRadius: 2,
                                    blurRadius: 10,
                                    color: Colors.black.withOpacity(0.1),
                                    offset: const Offset(0, 10))
                              ],
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                  Domain().imageUrl +
                                      "/avatar/${snapshot.data!.avatar.toString()}",
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  width: 4,
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                ),
                                color: Pallete.primaryColor,
                              ),
                              child: const Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                    buildTextField(Icons.account_circle_outlined, "NIM",
                        snapshot.data!.nim.toString(), false, false),
                    buildTextField(Icons.badge_outlined, "Nama",
                        snapshot.data!.namaMahasiswa.toString(), false, false),
                    buildTextField(Icons.article_outlined, "Gender",
                        snapshot.data!.jk.toString(), false, false),
                    buildTextField(Icons.school_outlined, "Jurusan",
                        snapshot.data!.namaJurusan.toString(), false, false),
                    buildTextField(Icons.lock_outline_rounded, "Password",
                        "******", true, true),
                    buildTextField(
                      Icons.app_settings_alt_outlined,
                      "ID Perangkat",
                      snapshot.data!.imei == null
                          ? "Perangkat belum terdaftar di sistem"
                          : "${snapshot.data!.imei}",
                      false,
                      false,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Pallete.successColor,
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          splashColor: Pallete.successColor[200],
                          onTap: () {},
                          child: const Center(
                            child: Text(
                              "Simpan",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Pallete.primaryColor,
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          splashColor: Pallete.primaryColor[200],
                          onTap: () async {
                            // this delete db sharepreferences user login
                            SharedPreferences preferences =
                                await SharedPreferences.getInstance();
                            preferences.clear();

                            Get.offAllNamed(NameRoute.login);
                          },
                          child: const Center(
                            child: Text(
                              "Sign Out",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          // By default, show a loading spinner.
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Future<void> getUserID() async {
    // here we are get id user from login
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      id = preferences.getInt("login")!;
    });
  }
}
