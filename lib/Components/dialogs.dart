import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class Dialogs {
  static void showSnackBar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.cyan,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static void loading(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: Colors.cyan,),
      ),
    );
  }
}
