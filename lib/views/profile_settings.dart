import 'package:flutter/material.dart';
import 'package:pet_haven/controllers/user_controller.dart';
import 'package:pet_haven/theme/color.dart';
import 'package:pet_haven/widgets/custom_app_bar.dart';
import 'package:pet_haven/widgets/input_field.dart';
import 'package:pet_haven/widgets/wide_button.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class ProfileSettings extends StatefulWidget {
  const ProfileSettings({super.key});

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameCtrl;
  late TextEditingController phoneCtrl;
  String _locationMessage = 'Location not set';
  bool _isLoadingLocation = false;

  @override
  void initState() {
    super.initState();
    // Initialize with empty or loading state
    nameCtrl = TextEditingController();
    phoneCtrl = TextEditingController();

    // Fetch user data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserData();
    });
  }

  Future<void> _loadUserData() async {
    final controller = context.read<UserController>();
    await controller.fetchUser();

    // Update controllers with fetched data
    if (mounted) {
      setState(() {
        nameCtrl.text = controller.fullName;
        phoneCtrl.text = controller.mobile;
      });
    }
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoadingLocation = true);

    try {
      bool serviceEnabled;
      LocationPermission permission;

      // Test if location services are enabled.
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw 'Location services are disabled.';
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Location permissions are denied';
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw 'Location permissions are permanently denied, we cannot request permissions.';
      }

      // Get current position
      final position = await Geolocator.getCurrentPosition();

      // Get address from coordinates
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        // Construct address: Street, City, Country
        List<String> parts = [];
        if (place.street != null) parts.add(place.street!);
        if (place.locality != null) parts.add(place.locality!);
        if (place.country != null) parts.add(place.country!);

        setState(() {
          _locationMessage = parts.join(', ');
        });
      } else {
        setState(() {
          _locationMessage =
              'Lat: ${position.latitude}, Long: ${position.longitude}';
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) setState(() => _isLoadingLocation = false);
    }
  }

  void _saveChanges(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await context.read<UserController>().updateProfile(
        fullName: nameCtrl.text.trim(),
        mobile: phoneCtrl.text.trim(),
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to update profile: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(appBarTitle: 'Profile Settings'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              InputField(
                controller: nameCtrl,
                hintText: 'Full Name',
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter your full name';
                  } else if (val.trim().length < 3) {
                    return 'Name must be at least 3 characters long';
                  }
                  return null;
                },
              ),

              InputField(
                controller: phoneCtrl,
                hintText: 'Mobile Number',
                keyboardType: TextInputType.phone,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter your mobile number';
                  }
                  final phoneRegex = RegExp(r'^[0-9]{10}$');
                  if (!phoneRegex.hasMatch(val.trim())) {
                    return 'Mobile number must be 10 digits';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 25),

              // Location Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Current Location',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        if (_isLoadingLocation)
                          const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        else
                          IconButton(
                            icon: const Icon(
                              Icons.my_location,
                              color: AppColors.primary,
                            ),
                            onPressed: _getCurrentLocation,
                            tooltip: 'Get Current Location',
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _locationMessage,
                      style: TextStyle(
                        color: _locationMessage == 'Location not set'
                            ? Colors.grey
                            : Colors.black87,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              WideButton(
                placeholder: 'Save Changes',
                backgroundColor: AppColors.primary,
                onPressed: () => _saveChanges(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
