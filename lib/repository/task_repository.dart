import 'dart:async';
import 'dart:convert';
import 'package:TaskMaster/service/task_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class CreateNewTask extends TaskEvent {
  final _date;
  final _time;
  final _label;
  final _description;

  CreateNewTask(this._date, this._time, this._label, this._description);

  @override
  // TODO: implement props
  List<Object> get props => [_date,_time,_label,_description];
}

class FetchTasks extends TaskEvent {}

class TaskState extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<Map<String, String>> tasks;

  TaskLoaded(this.tasks);

  @override
  List<Object> get props => [tasks];
}

class TaskNotLoaded extends TaskState {}

class TaskError extends TaskState {
  final String message;

  TaskError(this.message);

  @override
  List<Object> get props => [message];
}

class TaskCreationSuccess extends TaskState {}

class TaskCreationFailure extends TaskState {
  final String error;
  TaskCreationFailure(this.error);
}

class TaskRepository extends Bloc<TaskEvent, TaskState> {
  final TaskService taskService;

  TaskRepository(this.taskService) : super(TaskInitial()) {
    on<CreateNewTask>(_onCreateNewTask);
    on<FetchTasks>(_onFetchTasks);
  }

  Future<void> _onFetchTasks(FetchTasks event, Emitter<TaskState> emit) async {
    final tasks = await taskService.fetchTasks();
    emit(TaskLoaded(tasks));
  }

  Future<void> _onCreateNewTask(CreateNewTask event, Emitter<TaskState> emit) async {
    emit(TaskLoading());

    try {
      // Call the TaskService to create the task
      await taskService.createTask(event._date, event._time, event._label, event._description);

      // Fetch updated list after adding a new task
      add(FetchTasks());

      emit(TaskCreationSuccess()); // Emit success state
    } catch (error) {
      emit(TaskCreationFailure(error.toString())); // Emit failure state
    }
  }
}