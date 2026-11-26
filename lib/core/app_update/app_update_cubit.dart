import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_update.dart';

class AppUpdateCubit extends Cubit<bool> {
  AppUpdateCubit() : super(false) {
    if (!AppUpdate.isEnabled) return;
    _lifecycle = AppLifecycleListener(onResume: check);
    _timer = Timer.periodic(const Duration(minutes: 30), (_) => check());
  }

  static const _minGap = Duration(minutes: 1);

  AppLifecycleListener? _lifecycle;
  Timer? _timer;
  DateTime? _lastCheck;
  bool _dismissed = false;

  Future<void> check() async {
    if (state || _dismissed) return;
    final now = DateTime.now();
    final last = _lastCheck;
    if (last != null && now.difference(last) < _minGap) return;
    _lastCheck = now;
    if (await AppUpdate.hasNewerBuild() && !isClosed) emit(true);
  }

  void refresh() => AppUpdate.reload();

  void dismiss() {
    _dismissed = true;
    emit(false);
  }

  @override
  Future<void> close() {
    _lifecycle?.dispose();
    _timer?.cancel();
    return super.close();
  }
}
