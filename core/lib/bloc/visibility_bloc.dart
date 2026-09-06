import 'package:flutter_bloc/flutter_bloc.dart';

abstract class VisibilityEvent {}

class ShowVisibilityEvent extends VisibilityEvent {}

class HideVisibilityEvent extends VisibilityEvent {}

class VisibilityBloc extends Bloc<VisibilityEvent, bool> {
  bool isError = false;

  VisibilityBloc() : super(false) {
    on<VisibilityEvent>((event, emit) {
      if (event is ShowVisibilityEvent) {
        isError = true;
      } else if (event is HideVisibilityEvent) {
        isError = false;
      }
      emit(isError);
    });
  }
}
