part of '../stripes_builder.dart';

class QuestionsBloc extends Bloc<QuestionEvent, QuestionState> {
  final QuestionRepository _questionRepository;

  late final StreamSubscription<List<Question>> _questionsSub;

  QuestionsBloc({required QuestionRepository questionRepository})
      : this._questionRepository = questionRepository,
        super(QuestionState.loading()) {
    _questionsSub = _questionRepository.questions.listen(_onQuestions);
  }

  _onQuestions(List<Question> questions) => add(Loaded(questions));

  @override
  Stream<QuestionState> mapEventToState(QuestionEvent event) async* {
    if(event is Loaded)
      yield QuestionState.loaded(event.questions);
  }

  @override
  Future<void> close() {
    _questionsSub.cancel();
    return super.close();
  }
}

abstract class QuestionEvent extends Equatable {
  const QuestionEvent();

  @override
  List<Object?> get props => [];
}

class LoadingInitiated extends QuestionEvent {}

class Loaded extends QuestionEvent {
  final List<Question> questions;

  const Loaded(this.questions);

  @override
  List<Object?> get props => [questions];
}

class NotLoaded extends QuestionEvent {}

enum QuestionStatus { loading, loaded }

class QuestionState extends Equatable {
  final QuestionStatus status;

  final List<Question> questions;

  const QuestionState._({required this.status, this.questions = const []});

  const QuestionState.loading() : this._(status: QuestionStatus.loading);

  const QuestionState.loaded(List<Question> questions)
      : this._(status: QuestionStatus.loading, questions: questions);

  @override
  List<Object?> get props => [status, questions];
}
