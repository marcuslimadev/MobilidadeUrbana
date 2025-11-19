# Deploying Mobilidade Urbana to cPanel + MySQL

This guide assumes you will host the Laravel backend (`Files/Laravel`) on a cPanel shared server with a MySQL database. Adjust paths/usernames to match your account.

## 1. Prerequisites

- cPanel account with SSH access (recommended) and PHP 8.2
- Composer available on the server (or the ability to upload the `vendor/` directory from local)
- MySQL database & user credentials (see step 3)
- A Git remote or ZIP export of this monorepo

## 2. Prepare the repository

On your local machine:

```powershell
cd c:\Projetos\MobilidadeUrbana
composer install --working-dir=Files/Laravel/core --no-dev --optimize-autoloader
cp Files/Laravel/core/.env.example Files/Laravel/core/.env  # or keep existing env file
```

Do **not** commit `.env`. Populate it with production values later in cPanel. If you prefer uploading a ZIP, run:

```powershell
Compress-Archive -Path * -DestinationPath mobilidade-urbana.zip
```

## 3. Create the MySQL database on cPanel

1. Open **MySQL® Databases**.
2. Create a database, e.g. `cpuser_moburb`.
3. Create a user, e.g. `cpuser_app`, and assign a strong password.
4. Add the user to the database with **All Privileges**.
5. In **phpMyAdmin**, import `install/database.sql` (or your latest dump) into the new database.

Record:

```
DB_HOST=localhost
DB_DATABASE=cpuser_moburb
DB_USERNAME=cpuser_app
DB_PASSWORD=<generated-password>
```

## 4. Upload or clone the code

You have two options:

### Option A – Git Version Control (recommended)

1. In cPanel search for **Git Version Control**.
2. Create a new repository that clones your remote (GitHub/GitLab) into `/home/<user>/mobilidade`.
3. After cloning, the Laravel frontend root will be `/home/<user>/mobilidade/Files/Laravel`.

### Option B – Upload ZIP

1. Go to **File Manager** → `public_html` (or preferred directory).
2. Upload `mobilidade-urbana.zip` and extract it. You should end up with `Files/`, `Documentation/`, `Updates/`.

## 5. Point the web root

Because the vendor package ships a custom `index.php` in `Files/Laravel`, you can set the document root straight to that directory:

- If using a subdomain (e.g. `app.domain.com`), set its document root to `/home/<user>/mobilidade/Files/Laravel`.
- Ensure `.htaccess` inside `Files/Laravel` is honored (mod_rewrite enabled).

> **Alternative:** If you prefer the standard Laravel `public/` directory, create a symlink or move the contents of `Files/Laravel/core/public` to your public_html and update `index.php` accordingly. The shipped structure already handles this, so no extra steps are required.

## 6. Configure environment variables

Edit `/home/<user>/mobilidade/Files/Laravel/core/.env` with production values:

```
APP_NAME="Mobilidade Urbana"
APP_ENV=production
APP_KEY=base64:...
APP_DEBUG=false
APP_URL=https://app.domain.com
APP_LOCALE=pt_BR

DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=cpuser_moburb
DB_USERNAME=cpuser_app
DB_PASSWORD=<password>

CACHE_DRIVER=file
QUEUE_CONNECTION=database
SESSION_DRIVER=file
```

You can edit the file via SSH (`nano`) or upload it securely.

## 7. Install dependencies & optimize

SSH into the server:

```bash
cd /home/<user>/mobilidade/Files/Laravel/core
composer install --no-dev --optimize-autoloader
php artisan key:generate            # only if APP_KEY empty
php artisan migrate --force         # run pending migrations
php artisan db:seed --force         # optional demo data
php artisan storage:link
php artisan optimize
```

If composer is not available, upload the `vendor/` folder generated locally.

## 8. Configure cron & queue workers

### Scheduler

In **Cron Jobs** add:

```
* * * * * /usr/local/bin/php /home/<user>/mobilidade/Files/Laravel/core/artisan schedule:run --without-tty >> /home/<user>/logs/cron-laravel.log 2>&1
```

### Queue worker (optional but recommended)

Use a separate cron entry or [cPanel Daemon](https://docs.cpanel.net/). Example cron every minute:

```
* * * * * /usr/local/bin/php /home/<user>/mobilidade/Files/Laravel/core/artisan queue:work --stop-when-empty --sleep=3 --tries=3 >> /home/<user>/logs/queue.log 2>&1
```

## 9. Final checks

- Visit `https://app.domain.com` and ensure the PT-BR UI loads.
- Confirm file permissions allow Laravel to write to `storage/` and `bootstrap/cache/` (`chmod -R 775`).
- Test email/SMS integrations if configured.
- Create an admin login or reset the default credentials if using vendor data.

With these steps the Laravel backend will run on cPanel, backed by the new MySQL database. Flutter builds can point to the new URL via their `environment.dart` configs.
