import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:brave_search/core/network/network_info.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

part 'network_state.dart';

class NetworkCubit extends Cubit<NetworkState> {
  final NetworkInfo networkInfo;
  StreamSubscription? _connectivitySubscription;
  StreamSubscription? _internetSubscription;

  NetworkCubit({required this.networkInfo}) : super(const NetworkInitial()) {
    _init();
  }

  void _init() async {
    // İlk bağlantı durumunu kontrol et
    await _checkConnection();

    // Connectivity değişikliklerini dinle (WiFi, Mobile, None)
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((_) {
      _checkConnection();
    });

    // Gerçek internet erişimi değişikliklerini dinle
    _internetSubscription = networkInfo.onStatusChange.listen((status) {
      _handleInternetStatusChange(status);
    });
  }

  void _handleInternetStatusChange(InternetStatus status) async {
    final connectivityResults = await networkInfo.connectivityResult;
    
    switch (status) {
      case InternetStatus.connected:
        emit(NetworkConnected(connectivityResults));
        break;
      case InternetStatus.disconnected:
        emit(const NetworkDisconnected());
        break;
    }
  }

  Future<void> _checkConnection() async {
    try {
      final hasInternet = await networkInfo.isConnected;
      final connectivityResults = await networkInfo.connectivityResult;

      if (hasInternet) {
        emit(NetworkConnected(connectivityResults));
      } else {
        emit(const NetworkDisconnected());
      }
    } catch (e) {
      // Hata durumunda disconnected olarak işaretle
      emit(const NetworkDisconnected());
    }
  }

  // Manuel kontrol için public method
  Future<void> checkConnection() async {
    await _checkConnection();
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    _internetSubscription?.cancel();
    return super.close();
  }
}