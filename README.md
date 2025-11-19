# Mobilidade Urbana Monorepo

This repository consolidates every deliverable for the Mobilidade Urbana platform in a single Git monorepo. It contains the Laravel-based backoffice/API plus the Rider and Driver Flutter apps, shared documentation, and vendor update packages.

## Repository layout

| Path | Description |
| --- | --- |
| `Files/Laravel/` | Custom Laravel 11 application (entry point at `Files/Laravel/index.php`, core framework inside `Files/Laravel/core`). |
| `Files/Flutter/Rider` | Flutter project for the passenger app. |
| `Files/Flutter/Driver` | Flutter project for the driver app. |
| `Documentation/` | Project and deployment notes (see `Documentation/cpanel-deploy.md`). |
| `Updates/` | Vendor-provided update bundles for both Laravel and Flutter targets. |

## Getting started locally

### Requirements

- PHP 8.2 with Composer 2.x
- Node 18+ (for optional asset builds under `Files/Laravel/core`)
- Flutter 3.24+ (with Android/iOS toolchains) for Rider & Driver apps
- MariaDB/MySQL 10.4+

### Laravel API/Admin

```powershell
cd Files/Laravel/core
cp .env.example .env   # if missing, copy vendor example
composer install
php artisan key:generate
php artisan migrate --seed
```

For local serving the repo already includes `Files/Laravel/server.php`, so from the repo root you can run:

```powershell
cd Files/Laravel
php -S 127.0.0.1:8000 server.php
```

That script serves static assets directly from `Files/Laravel/assets` while bootstrapping Laravel via `index.php`.

### Flutter Rider & Driver apps

Each app lives in its own folder under `Files/Flutter/`. Typical workflow:

```powershell
cd Files/Flutter/Rider   # or Driver
flutter pub get
flutter run              # choose device/emulator
```

Both apps rely on the same backend. Keep their `environment.dart` synced with the Laravel host URL and Firebase config.

## Publishing the monorepo to Git

1. Ensure the new root `.gitignore` is in place (already added).
2. From `c:\Projetos\MobilidadeUrbana` run:
   ```powershell
   git init
   git add .
   git commit -m "chore: bootstrap monorepo"
   git remote add origin <your-remote-url>
   git branch -M main
   git push -u origin main
   ```
3. Use branches (`feature/<name>`) per component to keep history organized. Tag releases that combine Laravel + apps for easier deployments.

## Deployment

For detailed cPanel + MySQL deployment steps read [`Documentation/cpanel-deploy.md`](Documentation/cpanel-deploy.md). It covers:
- Building production dependencies with Composer
- Uploading or cloning the repo inside cPanel
- Pointing the document root to `Files/Laravel`
- Creating the MySQL database/user and importing `install/database.sql`
- Updating `.env`, running `php artisan key:generate`, `storage:link`, `optimize`
- Scheduling cron + queue workers

## Secrets & environment files

The repo deliberately ignores:
- `Files/Laravel/core/.env` and any environment secrets
- Flutter Firebase config files (`google-services.json`, `GoogleService-Info.plist`)

Store those secrets in your deployment platform (cPanel environment variables, GitHub Actions secrets, etc.) and share them through a secure channel.

## Useful commands

| Purpose | Command |
| --- | --- |
| Clear Laravel caches | `php artisan optimize:clear` |
| Run database migrations | `php artisan migrate --force` |
| Seed demo data | `php artisan db:seed --force` |
| Build Rider app (release) | `flutter build apk --release` |
| Build Driver app (release) | `flutter build apk --release` |

With this structure and documentation you can confidently version the full stack and deploy the Laravel backend to cPanel/MySQL while continuing Flutter development in the same repo.
