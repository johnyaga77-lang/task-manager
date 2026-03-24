import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_state.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/theme/theme_cubit.dart';
import '../../blocs/profile/profile_bloc.dart';
import '../../blocs/profile/profile_event.dart';
import '../../blocs/profile/profile_state.dart';
import '../../utils/snackbar_helper.dart';
import 'commerce/order_tracking_screen.dart';
import '../../services/data_seeder.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _pickImage(BuildContext context, String uid) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null && context.mounted) {
      context.read<ProfileBloc>().add(
        UploadProfileImage(image: pickedFile, uid: uid),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileUploadSuccess) {
          showTopSnackBar(
            context,
            'Profile photo updated!',
            backgroundColor: Colors.green,
          );
        } else if (state is ProfileUploadFailure) {
          showTopSnackBar(
            context,
            'Failed to update profile photo: ${state.message}',
          );
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          String email = 'Guest';
          String name = 'Guest User';
          String? photoUrl;
          String? uid;

          if (authState is Authenticated) {
            email = authState.user.email ?? 'No Email';
            name = authState.user.displayName ?? 'User';
            photoUrl = authState.user.photoURL;
            uid = authState.user.uid;
          }

          return Scaffold(
            appBar: AppBar(
              title: const Text('Profile & Settings'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () {
                    context.read<AuthBloc>().add(LogoutRequested());
                  },
                ),
              ],
            ),
            body: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // User Info Section
                Center(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (uid != null) _pickImage(context, uid);
                        },
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: photoUrl != null
                                  ? NetworkImage(photoUrl)
                                  : null,
                              child: photoUrl == null
                                  ? const Icon(Icons.person, size: 50)
                                  : null,
                            ),
                            // Loading Indicator Overlay
                            BlocBuilder<ProfileBloc, ProfileState>(
                              builder: (context, profileState) {
                                if (profileState is ProfileUploading) {
                                  return const Positioned.fill(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        name,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        email,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                const Divider(),

                // Seed Data (Dev Only)
                ListTile(
                  leading: const Icon(
                    Icons.cloud_upload_outlined,
                    color: Colors.orange,
                  ),
                  title: const Text('Seed Sample Data'),
                  subtitle: const Text('For testing only'),
                  onTap: () async {
                    try {
                      await DataSeeder().seedData();
                      if (context.mounted) {
                        showTopSnackBar(
                          context,
                          'Data seeded successfully!',
                          backgroundColor: Colors.green,
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        showTopSnackBar(context, 'Failed to seed data: $e');
                      }
                    }
                  },
                ),
                const Divider(),

                // My Orders
                ListTile(
                  leading: const Icon(Icons.inventory_2_outlined),
                  title: const Text('My Orders'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const OrderTrackingScreen(),
                      ),
                    );
                  },
                ),
                const Divider(),

                // Appearance Section
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Appearance',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                BlocBuilder<ThemeCubit, ThemeMode>(
                  builder: (context, themeMode) {
                    return Column(
                      children: [
                        RadioListTile<ThemeMode>(
                          title: const Text('System Default'),
                          value: ThemeMode.system,
                          groupValue: themeMode,
                          onChanged: (value) {
                            if (value != null) {
                              context.read<ThemeCubit>().updateTheme(value);
                            }
                          },
                        ),
                        RadioListTile<ThemeMode>(
                          title: const Text('Light Mode'),
                          value: ThemeMode.light,
                          groupValue: themeMode,
                          onChanged: (value) {
                            if (value != null) {
                              context.read<ThemeCubit>().updateTheme(value);
                            }
                          },
                        ),
                        RadioListTile<ThemeMode>(
                          title: const Text('Dark Mode'),
                          value: ThemeMode.dark,
                          groupValue: themeMode,
                          onChanged: (value) {
                            if (value != null) {
                              context.read<ThemeCubit>().updateTheme(value);
                            }
                          },
                        ),
                      ],
                    );
                  },
                ),
                const Divider(),

                // Account Actions
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Account',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    context.read<AuthBloc>().add(LogoutRequested());
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
