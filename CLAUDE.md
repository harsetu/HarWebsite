
# har_setu — Coding Rules

## State management
- Use `flutter_bloc` for all state management. Never call `setState`.
- Every screen/feature gets an `Event` (or `Cubit` method), `State`, and `Bloc`/`Cubit` class, following the pattern in `core/lib/bloc/` (e.g. `visibility_bloc.dart`).
- UI reads state via `BlocBuilder`/`BlocSelector` and dispatches via `BlocListener`/`context.read<XBloc>().add(...)`. Widgets stay stateless wherever possible; use `StatefulWidget` only for local, non-business-logic concerns (animation controllers, text controllers), never to hold app/business state.

## Base components
- Reuse existing base components from `core/lib/widget/` and `core/lib/base_widget/` instead of raw Flutter widgets — e.g. `BaseButton`, `BaseEditText`, `BaseDropdown`, `BaseAppBar`, `BaseTextView`, `BaseSwitcher`, `BaseCalendarDialog`, `BaseErrorWidget`, `AppErrorWidget`.
- New screens extend `BaseStatelessWidget` or use `BaseScreenMixin` from `core/lib/widget/base_screen.dart` (handles back navigation, status bar theming) rather than reimplementing that logic.
- If a UI need isn't covered by an existing base component, add a new one under `core/lib/widget/` (or `core/lib/base_widget/`) rather than building one-off widgets inline in feature code.

## Navigation
- Use `go_router` for all navigation; never call `Navigator.push`/`Navigator.of(context).push` with a raw `MaterialPageRoute` in feature code.
- Route paths/names must be defined once as constants on a central `AppRoute` class (not inlined as string literals at call sites). Navigate via `context.go(AppRoute.x)` / `context.push(AppRoute.x)`, and register each route's `GoRoute` against the same `AppRoute` constant.

## Data layer
- Every feature's data access goes through a `Repository` (abstract interface) + `RepositoryImpl` (concrete implementation), not direct API/service calls from Bloc or UI.
  - `XRepository` — abstract class defining the contract, lives with the feature.
  - `XRepositoryImpl` — implements `XRepository`, is the only place that talks to `BaseApi` / local data sources.
- Blocs depend on the `Repository` abstraction (injected via `getIt`), never on `RepositoryImpl` or `BaseApi` directly.
- All network calls go through `BaseApi` (`core/lib/network/base_api.dart`) — don't instantiate `Dio` directly in feature code.

## Dependency injection
- All singletons/services/repositories/blocs-that-need-DI are registered in and resolved via `getIt` (`core/lib/di/service_injection.dart`), using `registerLazySingleton`/`registerFactory` as appropriate.
- Register each `RepositoryImpl` against its `Repository` interface in `getIt`, and inject `BaseApi` via `getIt<BaseApi>()` inside `RepositoryImpl` — don't `new`/construct these by hand in widgets or blocs.
- Resolve dependencies via `getIt<T>()` (constructor injection preferred where practical) — avoid `Provider`/`InheritedWidget` for DI purposes.

## General
- Keep feature code out of `core` unless it's genuinely shared; `core` is for base widgets, network, DI, localization, and utils reused across features.
- Follow existing naming/file conventions in `core/lib` (`snake_case.dart` files, one primary class per file).

## Working style
- Operate autonomously in this repo: don't pause to ask "should I proceed?" / "want me to apply this?" for routine local dev work (edits, builds, installs on the emulator, running tests, local git commits). Just do it and report what changed.
- This does not cover genuinely hard-to-reverse or external-facing actions (force-push, `git reset --hard`, deleting branches, pushing to a remote, anything outside this repo) — still flag those before acting.
- Note: this rule governs my own judgment calls about pausing to confirm. It cannot change the Claude Code CLI's own tool-permission prompts (the "Allow/Deny" popups) — those are controlled by `.claude/settings.json` / the `/permissions` command, not by CLAUDE.md.