import 'package:ax_dapp/pages/scout/models/AthleteScoutModel.dart';
import 'package:ax_dapp/pages/scout/usecases/GetScoutAthletesDataUseCase.dart';
import 'package:ax_dapp/util/BlocStatus.dart';
import 'package:ax_dapp/util/SupportedSports.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'ScoutPageEvent.dart';
part 'ScoutPageState.dart';

class ScoutPageBloc extends Bloc<ScoutPageEvent, ScoutPageState> {
  ScoutPageBloc({required this.repo}) : super(ScoutPageState.initial()) {
    on<OnPageRefresh>(_mapRefreshEventToState);
    on<SelectSport>(_mapSelectSportToState);
    on<OnAthleteSearch>(_mapSearchAthleteEventToState);
  }

  final GetScoutAthletesDataUseCase repo;

  Future<void> _mapRefreshEventToState(
    OnPageRefresh event,
    Emitter<ScoutPageState> emit,
  ) async {
    try {
      emit(state.copyWith(status: BlocStatus.loading));

      final response = await repo.fetchSupportedAthletes(SupportedSport.all);
      if (response.isNotEmpty) {
        emit(
          state.copyWith(
            athletes: response,
            filteredAthletes: response,
            selectedSport: SupportedSport.all,
            status: BlocStatus.success,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: BlocStatus.no_data,
            filteredAthletes: [],
            athletes: [],
          ),
        );
      }
    } catch (_) {
      emit(state.copyWith(status: BlocStatus.error));
    }
  }

  Future<void> _mapSelectSportToState(
    SelectSport event,
    Emitter<ScoutPageState> emit,
  ) async {
    try {
      emit(state.copyWith(status: BlocStatus.loading));
      if (event.selectedSport != SupportedSport.all) {
        final filteredList = state.athletes
            .where((athlete) => event.selectedSport.name == athlete.sport.name)
            .toList();
        if (filteredList.isNotEmpty) {
          emit(
            state.copyWith(
              status: BlocStatus.success,
              filteredAthletes: filteredList,
              selectedSport: event.selectedSport,
            ),
          );
        } else {
          emit(
            state.copyWith(
              status: BlocStatus.no_data,
              filteredAthletes: [],
              selectedSport: event.selectedSport,
            ),
          );
        }
      } else {
        final filteredList = state.athletes
            .where((athlete) => event.selectedSport == SupportedSport.all)
            .toList();
        emit(
          state.copyWith(
            status: BlocStatus.success,
            filteredAthletes: filteredList,
            selectedSport: SupportedSport.all,
          ),
        );
      }
    } catch (_) {
      emit(state.copyWith(status: BlocStatus.error));
    }
  }

  void _mapSearchAthleteEventToState(
    OnAthleteSearch event,
    Emitter<ScoutPageState> emit,
  ) {
    final parsedInput = event.searchedName.trim().toUpperCase();
    if (event.selectedSport != SupportedSport.all) {
      emit(
        state.copyWith(
          filteredAthletes: state.athletes
              .where(
                (athlete) =>
                    athlete.name.toUpperCase().contains(parsedInput) &&
                    event.selectedSport.name == athlete.sport.name,
              )
              .toList(),
          status: BlocStatus.success,
        ),
      );
    } else {
      emit(
        state.copyWith(
          filteredAthletes: state.athletes
              .where(
                (athlete) => athlete.name.toUpperCase().contains(parsedInput),
              )
              .toList(),
          status: BlocStatus.success,
        ),
      );
    }
  }
}
