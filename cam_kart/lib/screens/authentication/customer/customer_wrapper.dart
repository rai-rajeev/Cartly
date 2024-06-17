import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../model/my_user.dart';
import '../../restHome.dart';
import '../../shopkeeper_verification_form.dart';
import 'customer_sign_in.dart';

class CustomerWrapper extends StatelessWidget {
  const CustomerWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);

    if (user != null) {
      return RestHome();
    } else {
      return const CustomerSignIn();
    }
  }
}