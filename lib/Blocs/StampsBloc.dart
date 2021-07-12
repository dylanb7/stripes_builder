part of '../stripes_builder.dart';

class StampsBloc<T extends Stamp> extends Bloc<StampEvent, StampState> {
  StampRepository<T> _stampRepository;

  StreamSubscription? _stampSubscription;

  StampsBloc({required StampRepository<T> repo})
      : this._stampRepository = repo,
        super(StampsLoading());

  @override
  Stream<StampState> mapEventToState(StampEvent event) async* {
    if (event is LoadStamps)
      yield* _loadStampsState();
    else if(event is AddStamp)
      yield* _addStampState(event);
    else if(event is UpdateStamp)
      yield* _updateStampState(event);
    else if(event is DeleteStamp)
      yield* _deleteStampState(event);
  }

  Stream<StampState> _loadStampsState() async* {
    _stampSubscription?.cancel();
    _stampSubscription =
        _stampRepository.stamps.listen((stamps) => add(StampsUpdated(stamps)));
  }

  Stream<StampState> _addStampState(AddStamp added) async* {
    _stampRepository.addStamp(added.stamp as T);
  }

  Stream<StampState> _updateStampState(UpdateStamp updated) async* {
    _stampRepository.updateStamp(updated.updatedStamp as T);
  }

  Stream<StampState> _deleteStampState(DeleteStamp deleted) async* {
    _stampRepository.removeStamp(deleted.deleted as T);
  }

  Stream<StampState> _stampsUpdatedState(StampsUpdated update) async* {
    yield StampsLoaded(update.stamps);
  }

  @override
  Future<void> close() {
    _stampSubscription?.cancel();
    return super.close();
  }
}


abstract class StampState extends Equatable {

  const StampState();

  @override
  List<Object?> get props => [];

}

class StampsLoading extends StampState {}

class StampsLoaded<T extends Stamp> extends StampState {

  final List<T> stamps;

  const StampsLoaded(this.stamps);

  @override
  List<Object?> get props => [stamps];

}

class StampsNotLoaded extends StampState {}

abstract class StampEvent extends Equatable {
  const StampEvent();

  @override
  List<Object?> get props => [];
}

class LoadStamps extends StampEvent {}

class AddStamp<T extends Stamp> extends StampEvent {

  final T stamp;

  const AddStamp(this.stamp);

  @override
  List<Object?> get props => [stamp];

}

class UpdateStamp<T extends Stamp> extends StampEvent {

  final T updatedStamp;

  const UpdateStamp(this.updatedStamp);

  @override
  List<Object?> get props => [updatedStamp];

}

class DeleteStamp<T extends Stamp> extends StampEvent {

  final T deleted;

  const DeleteStamp(this.deleted);

  @override
  List<Object?> get props => [deleted];

}

class StampsUpdated<T extends Stamp> extends StampEvent {

  final List<T> stamps;

  const StampsUpdated(this.stamps);

  @override
  List<Object?> get props => [stamps];

}