# Zero Gear

A home strength-training app for beginners. No equipment, bodyweight only. The user gets a plan of numbered days (Day 1, Day 2, ...), does each day whenever they like, and ticks off sets as they go. Each exercise has a GIF and form guidance. The plan leans on gender: more leg and glute days for women, more arms and chest for men.

Flutter (iOS and Android), Supabase backend on the free tier, Google sign-in only. Designs are in [Figma](https://www.figma.com/design/geIWtrJAWP4Nn3bUIKkROU/Workout).

## Status

| Area | State |
|---|---|
| Sign-in (Google), session restore, sign out, account deletion | Done |
| Onboarding (gender, height, weight) | Done |
| Profile: info, height and weight, weight chart, appearance, delete account | Done |
| Plan, workout, history and Home data layer (`features/home/data`) | Done, not compiled against a device yet |
| Home screens: Home, stretch offer, active stretch, active workout, workout complete, day detail, exercise detail, workout record | Scaffolds only (`features/home/ui`). The first four after Home have routes; day detail, exercise detail and workout record are not routed yet |
| Profile toggles (stretches, audio), change password | Not built |

Product decisions are in the project doc `product-decisions.md`; backend decisions and the schema are in `backend-decisions.md` and `backend-schema.sql`.

## Requirements

- Flutter 3.44+ (Dart 3.12+)
- Xcode (iOS) and the Android SDK (Android)
- A Supabase project (see [Backend](#backend-supabase))

## Setup

1. `flutter pub get`
2. Create `.env` in the project root (it is gitignored and bundled as an asset):

   ```
   BASE_URL=https://<project>.supabase.co
   PUBLISHABLE_KEY=<Supabase publishable key>
   REDIRECT_URL=<OAuth redirect URL>
   GOOGLE_WEB_CLIENT_ID=<Google web client ID>
   GOOGLE_IOS_CLIENT_ID=<Google iOS client ID>
   GOOGLE_ANDROID_CLIENT_ID=<Google Android client ID>
   ```

   `EnvConfig.init` (`lib/core/config/env_config.dart`) fails at startup if any key is missing. Read values through `EnvConfig`. To add one, add the key to `.env`, a getter and its entry in the required list.

   > `.env` is bundled into the app and can be read by anyone with the APK or IPA. Keep only the publishable key and client IDs in it, never a service-role key.

3. `flutter run`

## Flavors

| Flavor | App name |
|---|---|
| `dev` | Zero Gear Dev |
| `staging` | Zero Gear Staging |
| `prod` (default) | Zero Gear |

All three share one application and bundle ID (`com.zero.gear`), so only one flavor can be installed on a device at a time. `Flavor.current` (`lib/core/config/flavor.dart`) is resolved from Flutter's `appFlavor`; no `--dart-define` is needed. Flavors only change the app name today: they all read the same `.env`.

- **Android**: `productFlavors` in `android/app/build.gradle.kts`.
- **iOS**: build configurations `{Debug,Release,Profile}-{dev,staging,prod}` and schemes `dev`, `staging` and `prod`. The app name is the `APP_DISPLAY_NAME` build setting. In Xcode, pick a flavor scheme (there is no `Runner` scheme).
- **Default**: `default-flavor: prod` in `pubspec.yaml`, so a plain `flutter run` is the prod flavor.

## Running and building

```sh
flutter run --flavor dev
flutter run --flavor staging
flutter run --flavor prod --release

flutter build apk       --flavor <flavor> --release
flutter build appbundle --flavor <flavor> --release
flutter build ipa       --flavor <flavor> --release
```

In VS Code, pick a configuration under **Run and Debug**, or run a build from **Tasks: Run Task** (`Build: Android APK`, `Build: Android App Bundle`, `Build: iOS IPA`, `Build: All platforms`).

> Android release builds are signed with the debug key. Add a release `signingConfig` before publishing.

There are no automated tests in this project (see `AGENTS.md`). Check changes with `flutter analyze` and by running the app.

## Project structure

Feature-first MVVM: each feature has a `data` layer and a `ui` layer, and app-wide code lives in `lib/core/`.

```
lib/
  main.dart                       # Supabase init, builds the session and AuthService, restores the session, runs App
  provider.dart                   # AppProvider: app-wide Cubits and services; resets them when the session ends
  core/
    config/                       # Flavor (enum + Flavor.current), EnvConfig
    constants/                    # supabase_names (tables, functions), app_svgs, app_images, app_layout, endpoints
    extensions/                   # string, list and date helpers
    network/
      network_client.dart         # NetworkClient: runs Supabase calls and returns Result<T>
      network_exception.dart      # Network / Unauthorized / Server exceptions
    pagination/                   # PaginatedViewModel, PaginatedState, PaginatedData (available, unused so far)
    router/                       # AppRoute, GoRouter, auth redirect, feature routes, 404
    shared_features/
      session/                    # SessionCubit, SessionState, User, Profile, Gender
    storage/                      # SecureStorage, LocalStorage, SecureSessionStorage
    theme/                        # AppColors, AppTextStyles, AppSpacing, AppTheme, ThemeCubit
    utils/                        # Result, AppException, AsyncValue, AppLogger, ScaleUtil, formatters, validators
    widgets/
      buttons/                    # Button, AppBackButton
      containers/                 # AppScreen, AppHeader, AppCard, ContentWidth, AppStepper
      controls/                   # AppSwitch, AppCheckbox
      feedback/                   # Loader + LoaderHost, AppToast, ErrorView
      icons/                      # SvgIcon, AppLogo, CheckIcon
      inputs/                     # InputField, RulerPicker
      lists/                      # PaginatedListView
      modals/                     # ConfirmationModal
      text/                       # AppText, AppRichText
  features/
    auth/                         # Google sign-in, restore, sign out, delete account
    profile/                      # Onboarding, profile, height and weight, weight chart, appearance, delete account
    home/                         # Plan, workouts and Home: data layer plus the workout screens
      data/{models,repositories,services}
      ui/{models,views,widgets}
assets/svgs/                      # Logo, icons, avatars (exported from Figma)
.github/workflows/                # supabase-keep-alive.yml: pings Supabase twice a week so the free project is not paused
tool/                             # rename.dart, new_feature.dart
```

### Dependency direction

```
view → view model → service → repository
  ↓         ↓           ↓
widgets  ui model    SessionCubit
```

- `ui/` may import `data/`; `data/` never imports `ui/`.
- **Repositories** talk to the backend through `NetworkClient`, never the Supabase client directly. They parse responses into typed models and return a `Result`. Services and view models never see raw JSON.
- **Services** are Cubits (`class ProfileService extends Cubit<ProfileState>`). The state is the data the service owns, and methods that load or change data return a `Result`. `AppProvider` provides each one and resets it when the user signs out.
- **View models** are Cubits too (`LoginViewModel extends Cubit<LoginUiState>`) and depend on services, never on repositories. A view creates its own view model with `BlocProvider`, so it lives as long as the route. UI state classes are immutable, extend `Equatable` and expose `copyWith`.
- **Views** talk to their view model, and may read app-wide state straight from `SessionCubit` (`context.select((SessionCubit s) => s.state.user)`). Widgets get state and callbacks through their constructors.
- One-off effects (navigation, toasts) go in a `BlocListener`, not in `build`.
- **Features never import other features.** The one exception is `AuthService`, which any feature may use. Data shared by several features lives in `core/shared_features/<name>/data/`. Shared features may import only `session`. Today that is just `session`. A feature that combines services into one screen's data keeps that service in its own `data/` (`HomeService`).
- `core/` doesn't import from `features/`, except the route tables in `core/router/`, which register feature views.
- Imports outside the current feature use `package:` imports; relative imports only inside a feature.

### Features

| Feature | Repositories | Services (state) | Owns |
|---|---|---|---|
| `auth` | `AuthRepository`, `GoogleSignInRepository` | `AuthService` (`AuthActivity`) | Google sign-in, session restore, sign out, account deletion |
| `core/shared_features/session` | none | `SessionCubit` (`SessionState`) | The signed-in `User` and their `Profile` |
| `profile` | `ProfileRepository` | `ProfileService` (`ProfileState`) | Onboarding, height and weight, weight history, feature toggles |
| `home` | `PlanRepository`, `WorkoutRepository`, `WorkoutLocalRepository` | `PlanService`, `WorkoutService`, `HomeService` | The plan and exercise library, the workout in progress, saved workouts, the Home summary |

### Navigation

[go_router](https://pub.dev/packages/go_router), in `lib/core/router/`. Routes are declared once in the `AppRoute` enum (name, path, whether it is public) and registered with `AppRoute.x.toGoRoute(...)` in `auth_router.dart` or `feature_router.dart`. Navigate by name, never by path string:

```dart
context.goNamed(AppRoute.home.name);
context.pushNamed(AppRoute.weightChart.name);
```

| Route | Path |
|---|---|
| `login` (public) | `/login` |
| `home` | `/home` |
| `stretchOffer`, `activeStretch`, `activeWorkout`, `workoutComplete`, `dayDetail`, `exerciseDetail`, `workoutRecord` | `/home/<name>` |
| `profile` | `/profile` |
| `profileInfo`, `updateHeightWeight`, `weightChart`, `appearance`, `deleteAccount` | `/profile/<name>` |
| `confirmDelete` | `/profile/delete-account/confirm-delete` |
| `onboardingIntro`, `onboarding`, `onboardingComplete` | `/onboarding-intro`, `/onboarding`, `/onboarding-complete` |
| `accountDeleted` (public) | `/account-deleted` |

- **Startup**: `main()` builds `AuthService` and awaits `restoreSession()` before `runApp`, so the session is resolved before the router first redirects. The session comes from the one `supabase_flutter` restored from the device. If the profile fetch fails, a matching cached user is used, so a network error doesn't send the user to login.
- **Auth redirect** (`authRedirect` in `auth_router.dart`): the router refreshes on every `SessionCubit` change. Signed out, any non-public route goes to `/login?from=<where you were going>`. Signed in, login goes to `from` (only in-app paths are honoured) or `/home`. A signed-in user without a profile can reach only the onboarding routes.
- **Pop until**: `context.popUntilNamed(AppRoute.home.name)` and `context.popUntil('/home')` (`navigation.dart`) work with pushed routes and keep go_router's location in sync.
- **404**: unmatched locations show `NotFoundView`. `/` redirects to `/home`.

To add a route, add it to `AppRoute` (relative path if nested) and register it in the matching router file under its parent's `routes`.

### Session and storage

- `SessionCubit` holds the `User` (id, email, display name from Google) and their `Profile` once onboarded. `session.user.isOnboarded` is true when a profile exists. `start(user)` caches the user, `updateUser(user)` replaces it (ignored when signed out or for another id), and `clear()` deletes the cache. Features read the profile from `session.user.profile`; `ProfileService` writes changes back with `updateUser`.
- `SecureStorage` (Keychain / Keystore) holds secrets and the cached user. `LocalStorage` (`shared_preferences`) holds non-sensitive values (theme mode, the workout in progress, workouts waiting to upload). Both use typed key enums, and new keys must be added to the enum. `SecureSessionStorage` keeps the Supabase session in the Keychain / Keystore.
- **Fresh install (iOS)**: Keychain items survive uninstall, so `AppDelegate.clearKeychainOnFreshInstall()` wipes them on the first launch after a reinstall. Android needs nothing: backups are off (`allowBackup="false"`).

### Backend (Supabase)

The backend is a Supabase project, used through [`supabase_flutter`](https://pub.dev/packages/supabase_flutter). The SDK stores the session and refreshes tokens. Row-level security limits every user to their own rows, so queries carry no user filter. Table and function names are in `lib/core/constants/supabase_names.dart`.

`NetworkClient.request((db) => db.from(...))` runs a call and returns a `Result`, mapping SDK errors to `NetworkException`, `UnauthorizedException` or `ServerException`. Every `Result.error` carries an `AppException` whose `message` is safe to show. Handle results with a switch:

```dart
switch (await profileService.completeOnboarding(...)) {
  case Ok(:final value): ...
  case Error(:final error): ...
}
```

`Error` here is the `Result` subclass and shadows `dart:core`'s `Error` in files that import `result.dart`.

**Supabase setup**

- Run `backend-schema.sql`, then the plan and exercise seed scripts from the project docs.
- Enable the Google provider with the web, iOS and Android client IDs under Authorized Client IDs, and turn on "Skip nonce checks" (the app sends no nonce). Turn the email provider off.
- `.github/workflows/supabase-keep-alive.yml` pings the project twice a week so the free tier does not pause it.

**Behaviour worth knowing**

- **Sign-in** is Google only. `GoogleSignInRepository` returns the ID and access tokens, which `AuthRepository` passes to `auth.signInWithIdToken`. Deleting an account asks for Google again, checks it is the same account, then calls `delete_my_account`.
- **The name** comes from Google and is read from the auth metadata at sign-in (`User.displayName`). The profile does not store it, and onboarding does not ask for it.
- **Onboarding**: `ProfileService.completeOnboarding` saves gender, height and weight and the first weight entry. Gender cannot change afterwards (a database trigger).
- **The plan**: `PlanService.planDay(n)` calls `my_plan_day`, which picks the track from the user's gender (days 1 to 48 without equipment, 49 to 96 with a band, then a monthly progression). `summaries()` returns day names without exercises. Some exercises have no `gifUrl` yet.
- **Up next**: no day number is stored on a workout. `WorkoutHistory` replays saved workouts by date: a completed workout moves to the next day, an incomplete one repeats its day.
- **A workout**: `begin(day)` when the first exercise starts, then `setSetsDone` and `goToExercise`, saved on the device after every change. `finish()` or `giveUp()` upload it (an upsert, one workout per user per date). If the upload fails for a network or server reason it is queued on the device and uploaded on the next `history()` or `syncPending()`. After a kill, `restoreActiveWorkout()` returns it if the last tick was under 2 hours ago; otherwise it is saved as incomplete, ending at the last tick (or discarded with no ticks).
- **Home**: `HomeService.load()` builds everything Home shows. Ratings count completed workouts only. Great is 5 or more a week, Good is 3 or 4, Needs work is fewer.

### Design system

Tokens and widgets are built from the Figma file and named after it.

- **Colours** (`AppColors`, `context.colors`): named after the Figma `Color` variables: `bgPrimary`, `bgSecondary`, `bgTertiary`, `bgInverse`, `textPrimary`, `textSecondary`, `textInverse`, `borderDefault`, `borderStrong`, `accentPrimary` (Ember), `accentOn`, `successPrimary`, `successOn`. `error` and `onError` are not in Figma yet. Accent, success and error are the same in both modes. `ThemeCubit` keeps and persists the mode (system, light, dark).
- **Text** (`AppTextStyles`, Inter via `google_fonts`): `display` 30, `title` 22, `heading` 16, `body` 14, `bodyMedium`, `caption` 12, `label` 11 (uppercase labels), `numeric` 64. `AppText` applies a style and a theme colour.
- **Spacing** (`AppSpacing`): scaled gaps (`v8`, `h16`) and padding presets.
- **Scaling** (`ScaleUtil`): sizes are design values for a 375 x 812 frame, scaled with `16.w`, `16.h`, `14.sp` and `8.r`, capped at 1.2 so tablets don't render everything twice as large. `ContentWidth` centres a screen body and caps its width on tablets (`AppLayout`). `AppLayout.isWide(context)` is true from `tabletBreakpoint` up; the active workout and stretch screens use it to put the image on the left and the details and buttons on the right, while phones keep a single column.
- **Icons**: `SvgIcon(AppSvgs.check, size: 24)`, tinted with the text colour by default (`keepOriginalColors: true` keeps the SVG's own colours). Add an SVG to `assets/svgs/` and a constant to `AppSvgs`; don't use path strings inline.

Reusable widgets (`lib/core/widgets/`):

| Widget | What it is |
|---|---|
| `Button` | Pill, 56 high (36 when `fullWidth: false`). `ButtonVariant.filled` (Ember), `outlined`, `text`. `isLoading` shows a spinner and ignores taps. |
| `InputField` | Labelled text field, 52 high. Border turns `borderStrong` on focus and `error` with `errorText`. `obscureText` adds Show / Hide. |
| `RulerPicker` | Big value plus a scrolling ruler. `value`, `onChanged(double)`, `min`, `max`, `unit`, optional `step`. Used for height and weight in onboarding. |
| `AppSwitch` | The toggle. `value` and an optional `onPress`. |
| `AppCheckbox` | The selection circle (Appearance). `value` and an optional `onPress`. |
| `Loader` | `Loader.show()` and `Loader.hide()` cover the app with the logo and an orbiting kettlebell. No `BuildContext` needed. Calls are counted, so each `show()` needs a `hide()`. |
| `AppToast` | `AppToast.success` and `AppToast.error` overlays. |
| `ErrorView` | Centred error state: `title`, `text`, `onRetry`. |
| `AppScreen`, `AppHeader`, `AppCard`, `AppStepper` | Screen scaffold with header and footer, title block, card, step progress bar. |
| `ConfirmationModal` | Confirm dialog. |
| `AppRichText` | A paragraph of `AppTextSpan`s with optional tap handlers. |

### Pagination

`PaginatedViewModel<T>` (`lib/core/pagination/`) and `PaginatedListView` give infinite scroll: repositories return a `Result<PaginatedData<T>>`, the view model implements `fetchPage(int page)`, and the view renders `PaginatedListView` with `onLoadMore` and optional `onRefresh`. Nothing in the app uses them yet. Don't put the list inside a `SingleChildScrollView` or a `shrinkWrap` list, which would build every item and load every page at once.

### Naming

Folders stay flat; the file name shows ownership:

- `<screen>_view.dart`, `<screen>_view_model.dart` and `<screen>_ui_state.dart` belong to one screen. Screens with their own widgets or view models live in a folder named after the screen (`views/weight_chart/`).
- Flows with several views (onboarding) share one view model and UI state.
- `ui/widgets/<screen>/` holds widgets used by one screen; widgets shared across the feature sit in `ui/widgets/`.

### Tooling

- `dart run tool/rename.dart --name "..." --id com.zero.gear --package zero_gear` renames the app, bundle ID and Dart package (also under **Tasks: Run Task → Rename app**).
- `tool/new_feature.dart` scaffolds a feature or screen. It still generates repositories that take the old `ApiClient`, which no longer exists, so change them to `NetworkClient` by hand until the script is updated.
