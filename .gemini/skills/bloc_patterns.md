# BLoC Patterns & Conventions

## Cấu trúc BLoC theo feature
```
presentation/views/<feature>/
├── bloc/
│   ├── <feature>_bloc.dart      # Logic handler
│   ├── <feature>_event.dart     # Event definitions
│   └── <feature>_state.dart     # State definitions
├── widgets/                     # Sub-widgets
│   └── *.dart
└── <feature>_screen.dart        # Main screen widget
```

## Event Pattern
```dart
import 'package:equatable/equatable.dart';

abstract class <Feature>Event extends Equatable {
  const <Feature>Event();
  @override
  List<Object?> get props => [];
}

class Load<Feature>Event extends <Feature>Event {}

class <Action>Event extends <Feature>Event {
  final <Type> param;
  const <Action>Event({required this.param});
  @override
  List<Object?> get props => [param];
}
```

## State Pattern (copyWith + Equatable)
```dart
import 'package:equatable/equatable.dart';

enum <Feature>Status { initial, loading, loaded, error }

class <Feature>State extends Equatable {
  final <Feature>Status status;
  final <DataType> data;
  // ... other fields

  const <Feature>State({
    this.status = <Feature>Status.initial,
    this.data = defaultValue,
  });

  <Feature>State copyWith({
    <Feature>Status? status,
    <DataType>? data,
  }) {
    return <Feature>State(
      status: status ?? this.status,
      data: data ?? this.data,
    );
  }

  @override
  List<Object?> get props => [status, data];
}
```

## Bloc Pattern
```dart
import 'package:flutter_bloc/flutter_bloc.dart';

class <Feature>Bloc extends Bloc<<Feature>Event, <Feature>State> {
  final <UseCase> _useCase;

  <Feature>Bloc(this._useCase) : super(const <Feature>State()) {
    on<Load<Feature>Event>(_onLoad);
    on<<Action>Event>(_onAction);
  }

  Future<void> _onLoad(Load<Feature>Event event, Emitter<<Feature>State> emit) async {
    emit(state.copyWith(status: <Feature>Status.loading));
    try {
      final result = await _useCase();
      emit(state.copyWith(status: <Feature>Status.loaded, data: result));
    } catch (_) {
      emit(state.copyWith(status: <Feature>Status.error));
    }
  }
}
```

## Screen Pattern (BlocProvider + BlocBuilder)
```dart
class <Feature>Screen extends StatelessWidget {
  const <Feature>Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => injector<<Feature>Bloc>()..add(Load<Feature>Event()),
      child: const _<Feature>View(),
    );
  }
}

class _<Feature>View extends StatelessWidget {
  const _<Feature>View();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<<Feature>Bloc, <Feature>State>(
      builder: (context, state) {
        switch (state.status) {
          case <Feature>Status.loading:
            return const Center(child: CircularProgressIndicator());
          case <Feature>Status.loaded:
            return _buildContent(context, state);
          case <Feature>Status.error:
            return const Center(child: Text('Error'));
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }
}
```

## Lưu ý
- Bloc dùng `Factory` trong DI (mỗi screen tạo instance mới)
- Singleton services (DAO, Repo, UseCase) dùng `LazySingleton`
- Emit loading state TRƯỚC khi gọi async
- Dùng `Equatable` cho cả Event và State
- Status enum: `initial` → `loading` → `loaded` | `error`
