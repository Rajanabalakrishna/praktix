import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/application_entity.dart';
import '../../domain/usecases/submit_application_usecase.dart';
import 'application_event.dart';
import 'application_state.dart';

class ApplicationBloc extends Bloc<ApplicationEvent, ApplicationState> {
  final SubmitApplicationUsecase submitApplicationUsecase;

  ApplicationBloc({required this.submitApplicationUsecase})
      : super(ApplicationInitial()) {
    on<SubmitApplicationEvent>(_onSubmit);
  }

  Future<void> _onSubmit(
      SubmitApplicationEvent event,
      Emitter<ApplicationState> emit,
      ) async {
    emit(ApplicationSubmitting());

    final result = await submitApplicationUsecase(
      ApplicationEntity(
        name: event.name,
        email: event.email,
        phone: event.phone,
        programTitle: event.programTitle,
      ),
    );

    result.fold(
          (failure) => emit(ApplicationFailure(error: failure.message)),
          (message) => emit(ApplicationSuccess(message: message)),
    );
  }
}