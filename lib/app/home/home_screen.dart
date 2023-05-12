import 'dart:ui';

import 'package:eat_smart/app/blocs/auth/auth_bloc.dart';
import 'package:eat_smart/app/blocs/food/food_bloc.dart';
import 'package:eat_smart/app/home/widgets/search_food_box.dart';
import 'package:eat_smart/app/theme/theme_manager.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eat Smart'),
        actions: [
          Consumer<ThemeNotifier>(builder: (context, theme, _) {
            final themeMode = theme.getThemeMode();
            return IconButton(
              onPressed: () {
                if (themeMode == ThemeMode.dark) {
                  theme.setLightMode();
                } else {
                  theme.setDarkMode();
                }
              },
              icon: Icon(
                themeMode == ThemeMode.dark
                    ? Icons.light_mode
                    : Icons.dark_mode,
              ),
            );
          }),
          IconButton(
            onPressed: () {
              context.read<AuthBloc>().add(AppLogoutRequested());
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        enableFeedback: true,
        currentIndex: currentIndex,
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_rounded),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person_rounded),
            label: "Account",
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          context.read<FoodBloc>().add(ResetAll());
          await getImage();
        },
        child: const Icon(Icons.camera_alt_outlined),
      ),
      body: BlocBuilder<FoodBloc, FoodState>(
        builder: (context, state) {
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    // currentIndex == 0 ? SearchFoodBox() : Container(),
                    FlipCard(
                      fill: Fill.fillBack,
                      direction: FlipDirection.HORIZONTAL, // default
                      front: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20,
                        ),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.red,
                        ),
                        // required

                        child: Column(
                          children: [
                            Text(
                              'Daily Index',
                              style: GoogleFonts.roboto(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '40',
                              style: GoogleFonts.roboto(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      back: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20,
                        ),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.blue,
                        ),
                        // required
                        child: Column(
                          children: [
                            Text(
                              'Weekly Index',
                              style: GoogleFonts.roboto(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '400',
                              style: GoogleFonts.roboto(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (state.isLoading)
                BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 1.0,
                    sigmaY: 1.0,
                  ),
                  child: Container(
                    child: Center(
                      child: const CircularProgressIndicator(),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Future<void> getImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 30,
    );
    if (pickedImage != null)
      context
          .read<FoodBloc>()
          .add(PickImageEvent(pickedImage, pickedImage.path));
  }
}
