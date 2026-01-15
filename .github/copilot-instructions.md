# Mobilidade Urbana - AI Agent Instructions

## Project Overview

This is a **monorepo** for a ride-sharing platform (similar to Uber) with three main components:
- **Laravel 11 API/Admin** ([Files/Laravel/core](Files/Laravel/core)) - Backend + admin panel
- **Flutter Rider App** ([Files/Flutter/Rider](Files/Flutter/Rider)) - Passenger mobile app (`ovorideuser`)
- **Flutter Driver App** ([Files/Flutter/Driver](Files/Flutter/Driver)) - Driver mobile app (`ovoride_driver`)

**Key architectural decisions:**
- Custom server entry at `Files/Laravel/index.php` + `server.php` (not standard Laravel structure)
- Assets live in `Files/Laravel/assets` (outside core framework)
- Both Flutter apps share similar architecture but are separate codebases
- Updates are delivered as vendor bundles in `Updates/` directory

## Environment Setup

### Laravel Backend (Files/Laravel/core)

**Requirements:** PHP 8.2, Composer 2.x, Node 18+, MariaDB/MySQL 10.4+

```powershell
cd Files/Laravel/core
composer install
# .env must be configured manually (no .env.example in repo)
php artisan key:generate
php artisan migrate --seed
```

**Local dev server** (run from repo root):
```powershell
cd Files/Laravel
php -S 127.0.0.1:8000 server.php
```

Critical: `server.php` serves static assets from `Files/Laravel/assets` while bootstrapping via `index.php`.

### Flutter Apps (Rider & Driver)

**Requirements:** Flutter 3.24+, Android/iOS toolchains

```powershell
cd Files/Flutter/Rider  # or Driver
flutter pub get
flutter run
```

**Critical config:** Both apps require `environment.dart` with backend URL and Firebase settings. Package names:
- Rider: `ovorideuser`
- Driver: `ovoride_driver`

## Code Architecture Patterns

### Laravel API Structure

**Route organization** (custom namespace pattern):
- `routes/api.php` - Public API + User endpoints (`Api\User` namespace)
- `routes/driver.php` - Driver-specific routes
- `routes/user.php` - User web routes
- `routes/admin.php` - Admin panel routes

**API authentication:** Laravel Sanctum with custom `token.permission:auth_token` middleware.

**Controller pattern:** Namespace grouping with controller methods, e.g.:
```php
Route::namespace('Api\User')->group(function () {
    Route::middleware(['auth:sanctum', 'token.permission:auth_token'])->group(function () {
        Route::controller('UserController')->group(function () {
            Route::get('dashboard', 'dashboard');
        });
    });
});
```

**Key models:** `Ride`, `Bid`, `User`, `Driver`, `Coupon`, `Message`, `DeviceToken`

### Flutter Architecture

**Pattern:** GetX state management with clean architecture layers:

```
lib/
├── core/              # Shared utilities, themes, helpers
│   ├── di_service/    # Dependency injection (GetX bindings)
│   ├── helper/        # String formatters, shared helpers
│   ├── route/         # App routing + middleware
│   ├── theme/         # Light theme config
│   └── utils/         # Utilities (audio, methods, messages)
├── data/              # Data layer
│   ├── controller/    # GetX controllers (state management)
│   ├── model/         # Data models
│   ├── repo/          # API repositories
│   └── services/      # API client, push notifications, Pusher
├── presentation/      # UI layer
│   ├── components/    # Reusable widgets
│   ├── packages/      # Package-specific components
│   └── screens/       # App screens
└── environment.dart   # App config (API URL, map key, etc.)
```

**Initialization flow** (`main.dart`):
1. `ApiClient.init()` - Setup HTTP client with `dev-token` header
2. `di_service.init()` - Register GetX dependencies (returns language map)
3. Configure portrait mode, audio, push notifications
4. Override HTTP client for SSL (development)

**API Client pattern** (`data/services/api_client.dart`):
- Uses Dio for HTTP with custom headers: `{"Accept": "application/json", "dev-token": Environment.devToken}`
- Extends `LocalStorageService` for SharedPreferences access
- All API calls go through `request()` method with auth token injection

**Real-time communication:**
- Firebase Cloud Messaging for push notifications
- Pusher Channels (`pusher_channels_flutter`) for real-time ride updates
- Both integrated in `PushNotificationService` and `PusherRideController`

## Critical Workflows

### Deployment to cPanel

See [Documentation/cpanel-deploy.md](Documentation/cpanel-deploy.md). Key steps:
1. Build production dependencies: `composer install --no-dev --optimize-autoloader`
2. Point document root to `Files/Laravel`
3. Import `install/database.sql` to MySQL
4. Configure `.env` with production values (DB, mail, Pusher)
5. Run: `php artisan key:generate`, `storage:link`, `optimize`
6. Setup cron for `php artisan schedule:run`

### Deployment to Render

See [render.yaml](render.yaml) - automated build with environment variables. Buildpack installs Composer dependencies and caches config/routes/views.

### Deployment to VPS (Hostinger/DigitalOcean/AWS)

**Stack:** Nginx + PHP-FPM + MySQL

**Directory structure on server:**
```
/var/www/6ammart/  # or your app name
├── app/
├── public/  # Document root points here
├── storage/  # Needs write permissions
├── bootstrap/cache/  # Needs write permissions
└── .env  # Server-specific config
```

**Critical permissions** (run as root after deployment):
```bash
cd /var/www/6ammart
chown -R www-data:www-data .
chmod -R 775 storage bootstrap/cache
find storage -type f -exec chmod 664 {} \;
find storage -type d -exec chmod 775 {} \;
```

**Post-deployment commands:**
```bash
composer install --no-dev --optimize-autoloader
php artisan storage:link
php artisan migrate --force
php artisan config:cache
php artisan route:cache
php artisan view:cache
```

**Nginx configuration** (point document root to `public/`):
```nginx
root /var/www/6ammart/public;
index index.php;

location / {
    try_files $uri $uri/ /index.php?$query_string;
}

location ~ \.php$ {
    fastcgi_pass unix:/var/run/php/php8.2-fpm.sock;
    fastcgi_index index.php;
    include fastcgi_params;
}
```

**Important:** VPS credentials (SSH, MySQL, API keys) should NEVER be committed to Git. Store them securely in:
- Password manager (1Password, Bitwarden)
- Server environment variables
- Private documentation (not in repo)

### Applying Updates

Updates live in `Updates/Laravel/{version}/` and `Updates/Flutter/`. Each contains:
- `readme.txt` - Change instructions
- `Files/` - Modified files to overlay

**Pattern:** Copy files from update bundle over existing codebase, then run migrations/composer as needed.

### Building Flutter Apps for Production

```powershell
# Rider
cd Files/Flutter/Rider
flutter build apk --release       # Android
flutter build ios --release       # iOS (requires Mac)

# Driver (same commands)
cd Files/Flutter/Driver
flutter build apk --release
```

**Pre-build checklist:**
1. Update `environment.dart` with production API URL
2. Ensure Firebase config files exist (`.gitignore`'d - add manually):
   - Android: `android/app/google-services.json`
   - iOS: `ios/Runner/GoogleService-Info.plist`
3. Update version in `pubspec.yaml`

## Environment Variables & Secrets

**Laravel** requires `.env` with:
- `APP_KEY` (generate via `php artisan key:generate`)
- `DB_*` (database credentials)
- `PUSHER_*` (for real-time features)
- `MAIL_*` (email notifications)

**Flutter** requires in `environment.dart`:
- `mapKey` - Google Maps API key
- `devToken` - Laravel API dev authentication token (matches backend)
- Base API URL (hardcoded or build-flavor based)

**Firebase configs** (gitignored):
- `google-services.json` (Android)
- `GoogleService-Info.plist` (iOS)
- `firebase_options.dart` (generated by FlutterFire CLI)

## Testing & Debugging

**Laravel:**
```powershell
php artisan optimize:clear  # Clear all caches
php artisan migrate:fresh --seed  # Reset database with demo data
```

**Flutter:**
```powershell
flutter clean && flutter pub get  # Nuclear option for dependency issues
flutter run -v  # Verbose mode for debugging
```

**Common issues:**
- SSL errors in Flutter: Check `MyHttpOverrides` in `main.dart` (dev only)
- API 401/403: Verify `dev-token` header matches backend `Environment.devToken`
- Pusher not connecting: Check credentials in `.env` and Flutter `PusherService`

## Project Conventions

- **Language:** Portuguese (Brazil) for UI strings, English for code/comments
- **Time zone:** America/Sao_Paulo (configured in Laravel `.env`)
- **Currency:** USD symbol `$` (configurable in `environment.dart`)
- **Map service:** Google Maps (requires API key in both Laravel + Flutter)
- **Code style:** Follow existing patterns - Laravel uses controller grouping, Flutter uses GetX reactive state
- **Assets:** Laravel static assets in `Files/Laravel/assets`, Flutter in `assets/` per app
- **Branch strategy:** Use `feature/<name>` branches, tag releases combining Laravel + apps (e.g., `v1.5.0`)

## Key Files to Reference

- [README.md](README.md) - Monorepo structure and getting started
- [Documentation/cpanel-deploy.md](Documentation/cpanel-deploy.md) - cPanel deployment guide
- [render.yaml](render.yaml) - Render.com deployment config
- [Files/Laravel/server.php](Files/Laravel/server.php) - Custom entry point serving assets
- [Files/Flutter/Rider/lib/environment.dart](Files/Flutter/Rider/lib/environment.dart) - Flutter app config
- [Files/Flutter/Rider/lib/data/services/api_client.dart](Files/Flutter/Rider/lib/data/services/api_client.dart) - HTTP client pattern
- [Files/Laravel/core/routes/api.php](Files/Laravel/core/routes/api.php) - API route definitions
