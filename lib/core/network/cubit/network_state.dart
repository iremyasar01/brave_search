part of 'network_cubit.dart';

@immutable
abstract class NetworkState {
  const NetworkState();
}

class NetworkInitial extends NetworkState {
  const NetworkInitial();
}

class NetworkConnected extends NetworkState {
  final List<ConnectivityResult> connectivityTypes;

  const NetworkConnected(this.connectivityTypes);
}

class NetworkDisconnected extends NetworkState {
  const NetworkDisconnected();
}
