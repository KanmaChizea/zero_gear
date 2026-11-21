import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/services/home_service.dart';
import '../../models/stretch_offer_ui_state.dart';

class StretchOfferViewModel extends Cubit<StretchOfferUiState> {
  StretchOfferViewModel({required this._homeService})
    : super(const StretchOfferUiState());

  // ignore: unused_field
  final HomeService _homeService;

  // TODO: add actions; change state with emit(state.copyWith(...)).
}
