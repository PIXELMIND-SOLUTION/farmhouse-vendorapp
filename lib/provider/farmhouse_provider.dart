import 'package:farmhouse_vendor/model/farmhouse_model.dart';
import 'package:farmhouse_vendor/services/home/my_farmhouse_services.dart';
import 'package:flutter/foundation.dart';

enum FarmhouseState { idle, loading, loaded, error }

class FarmhouseProvider extends ChangeNotifier {
  FarmhouseState _state = FarmhouseState.idle;
  FarmhouseModel? _farmhouse;
  String? _errorMessage;

  FarmhouseState get state => _state;
  FarmhouseModel? get farmhouse => _farmhouse;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _state == FarmhouseState.loading;

  Future<void> fetchFarmhouse({
  required String farmhouseId,
}) async {
  _setState(FarmhouseState.loading);
  _errorMessage = null;

  try {
    final result = await FarmhouseService.instance.getFarmhouseById(
      farmhouseId: farmhouseId,
    );
    _farmhouse = result;
    _setState(FarmhouseState.loaded);
  } catch (e) {
    _errorMessage = e.toString().replaceFirst('Exception: ', '');
    _setState(FarmhouseState.error);
  }
}

  void clearFarmhouse() {
    _farmhouse = null;
    _errorMessage = null;
    _setState(FarmhouseState.idle);
  }

  void _setState(FarmhouseState newState) {
    _state = newState;
    notifyListeners();
  }
}