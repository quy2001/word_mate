import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:word_mate/presentation/widgets/bottom_nav/bottom_nav_event.dart';
import 'package:word_mate/presentation/widgets/bottom_nav/bottom_nav_state.dart';

class BottomNavBloc extends Bloc<BottomNavEvent, BottomNavState> {
  BottomNavBloc() : super(const BottomNavState()) {
    on<ChangeTabEvent>(_onChangeTab);
  }

  void _onChangeTab(ChangeTabEvent event, Emitter<BottomNavState> emit) {
    emit(state.copyWith(selectedIndex: event.index));
  }
}
