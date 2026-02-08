import 'package:flutter/material.dart';
import 'package:pet_haven/controllers/cart_controller.dart';
import 'package:pet_haven/controllers/user_controller.dart';
import 'package:pet_haven/theme/color.dart';
import 'package:pet_haven/widgets/custom_app_bar.dart';
import 'package:pet_haven/widgets/input_field.dart';
import 'package:pet_haven/widgets/wide_button.dart';
import 'package:provider/provider.dart';

class Checkout extends StatefulWidget {
  final double totalAmount;

  const Checkout({super.key, required this.totalAmount});

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameCtrl;
  late TextEditingController mobileCtrl;
  late TextEditingController addressCtrl;
  late TextEditingController cityCtrl;
  late TextEditingController provinceCtrl;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController();
    mobileCtrl = TextEditingController();
    addressCtrl = TextEditingController();
    cityCtrl = TextEditingController();
    provinceCtrl = TextEditingController();

    // Pre-fill user data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<UserController>().user;
      if (user != null) {
        setState(() {
          nameCtrl.text = user.name;
          mobileCtrl.text = user.mobile ?? '';
          addressCtrl.text = user.addressLine ?? '';
          cityCtrl.text = user.city ?? '';
          provinceCtrl.text = user.province ?? '';
        });
      }
    });
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    mobileCtrl.dispose();
    addressCtrl.dispose();
    cityCtrl.dispose();
    provinceCtrl.dispose();
    super.dispose();
  }

  void _confirmOrder() async {
    if (!_formKey.currentState!.validate()) return;

    // Simulate order placement
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          title: const Text('Order Placed!'),
          content: Text(
            'Your order has been placed successfully!\nIt will be delivered to:\n${addressCtrl.text}, ${cityCtrl.text}\nwithin 3 days.',
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final cart = CartController();
                await cart.clear();

                if (ctx.mounted) {
                  Navigator.of(ctx).pop(); // Close dialog
                  if (mounted) {
                    Navigator.of(
                      context,
                    ).popUntil((route) => route.isFirst); // Go to Home
                  }
                }
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(appBarTitle: 'Checkout'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order Summary
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Amount',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Rs. ${widget.totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                'Delivery Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),

              InputField(
                controller: nameCtrl,
                hintText: 'Full Name',
                validator: (val) =>
                    val!.isEmpty ? 'Please enter your name' : null,
              ),
              InputField(
                controller: mobileCtrl,
                hintText: 'Mobile Number',
                keyboardType: TextInputType.phone,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Please enter mobile number';
                  }
                  if (val.length != 10)
                    return 'Mobile number must be 10 digits';
                  return null;
                },
              ),
              InputField(
                controller: addressCtrl,
                hintText: 'Address Line',
                validator: (val) =>
                    val!.isEmpty ? 'Please enter address' : null,
              ),
              InputField(
                controller: cityCtrl,
                hintText: 'City',
                validator: (val) => val!.isEmpty ? 'Please enter city' : null,
              ),
              InputField(
                controller: provinceCtrl,
                hintText: 'Province',
                validator: (val) =>
                    val!.isEmpty ? 'Please enter province' : null,
              ),

              const SizedBox(height: 20),
              const Text(
                'Payment Method',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.primary),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.money, color: AppColors.primary),
                    SizedBox(width: 10),
                    Text(
                      'Cash on Delivery',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    Spacer(),
                    Icon(Icons.check_circle, color: AppColors.primary),
                  ],
                ),
              ),

              const SizedBox(height: 30),
              WideButton(
                placeholder: 'Confirm Order',
                backgroundColor: AppColors.primary,
                onPressed: _confirmOrder,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
