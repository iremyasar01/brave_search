import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:brave_search/core/network/network_info.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

part 'network_state.dart';

class NetworkCubit extends Cubit<NetworkState> {
  final NetworkInfo networkInfo;
  StreamSubscription? _connectivitySubscription;

  NetworkCubit({required this.networkInfo}) : super(const NetworkInitial()) {
    _init();
  }

  void _init() async {
    // İlk bağlantı durumunu kontrol et
    await _checkConnection();

    // Bağlantı değişikliklerini dinle
  _connectivitySubscription = networkInfo.onStatusChange.listen((status) {
  _checkConnection();
});
  }

  Future<void> _checkConnection() async {
    final hasInternet = await networkInfo.isConnected;
    final connectivityResults = await networkInfo.connectivityResult;

    if (hasInternet) {
      emit(NetworkConnected(connectivityResults));
    } else {
      emit(const NetworkDisconnected());
    }
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
