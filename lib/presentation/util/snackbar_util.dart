import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

SnackbarController useSnackbarController() {
  final context = useContext();
  return context.read<SnackbarController>();
}
