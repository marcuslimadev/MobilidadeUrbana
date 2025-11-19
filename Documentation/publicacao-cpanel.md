# Publicação do Mobilidade Urbana no cPanel

Guia rápido em português para colocar o backend Laravel (pasta `Files/Laravel`) em produção usando cPanel + MySQL.

## 1. Preparar o pacote local

1. Atualize dependências e gere arquivos otimizados:
   ```powershell
   cd c:\Projetos\MobilidadeUrbana
   composer install --working-dir=Files/Laravel/core --no-dev --optimize-autoloader
   ```
2. Garanta que `Files/Laravel/core/.env` existe apenas localmente (não suba para o Git). Deixe os valores de produção para configurar no servidor.
3. Gere um `.zip` se for enviar via upload:
   ```powershell
   Compress-Archive -Path * -DestinationPath mobilidade-urbana.zip
   ```

## 2. Enviar os arquivos para o cPanel

- **Opção Git (recomendada):** No cPanel, abra **Git Version Control**, informe a URL do repositório e clone em `/home/SEU_USUARIO/mobilidade`.
- **Opção upload:** No **File Manager**, envie `mobilidade-urbana.zip`, extraia e verifique se as pastas `Files/`, `Documentation/`, `Updates/` ficaram completas.

## 3. Criar banco de dados MySQL

1. Acesse **MySQL® Databases**.
2. Crie o banco (ex.: `cpuser_moburb`).
3. Crie o usuário (ex.: `cpuser_app`) com senha forte.
4. Dê **All Privileges** para o usuário neste banco.
5. No **phpMyAdmin**, importe `install/database.sql` (ou seu dump atualizado).

Anote para o `.env`:
```
DB_HOST=localhost
DB_DATABASE=cpuser_moburb
DB_USERNAME=cpuser_app
DB_PASSWORD=<senha>
```

## 4. Definir o diretório público

- Aponte o domínio/subdomínio para `/home/SEU_USUARIO/mobilidade/Files/Laravel`.
- O `.htaccess` dessa pasta já direciona tudo para `index.php`, que carrega `core/bootstrap/app.php`.

## 5. Configurar `.env`

Edite `/home/SEU_USUARIO/mobilidade/Files/Laravel/core/.env` (via SSH ou editor do cPanel) com informações de produção:
```
APP_NAME="Mobilidade Urbana"
APP_ENV=production
APP_DEBUG=false
APP_URL=https://app.seudominio.com
APP_LOCALE=pt_BR

DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=cpuser_moburb
DB_USERNAME=cpuser_app
DB_PASSWORD=<senha>

CACHE_DRIVER=file
QUEUE_CONNECTION=database
SESSION_DRIVER=file
```
Complete também MAIL_*, PUSHER_* e demais integrações, se necessário.

## 6. Instalar dependências no servidor

Via SSH:
```bash
cd /home/SEU_USUARIO/mobilidade/Files/Laravel/core
composer install --no-dev --optimize-autoloader
php artisan key:generate        # apenas se APP_KEY estiver vazio
php artisan migrate --force     # atualiza estrutura do banco
php artisan db:seed --force     # opcional: dados de demonstração
php artisan storage:link        # cria symlink para uploads
php artisan optimize            # cache de config/rotas
```
Se não tiver Composer no servidor, suba a pasta `vendor/` gerada localmente.

## 7. Cron e filas

Adicione no cPanel → **Cron Jobs**:
```
* * * * * /usr/local/bin/php /home/SEU_USUARIO/mobilidade/Files/Laravel/core/artisan schedule:run --without-tty >> /home/SEU_USUARIO/logs/cron-laravel.log 2>&1
```
Para filas (opcional):
```
* * * * * /usr/local/bin/php /home/SEU_USUARIO/mobilidade/Files/Laravel/core/artisan queue:work --stop-when-empty --sleep=3 --tries=3 >> /home/SEU_USUARIO/logs/queue.log 2>&1
```

## 8. Checklist final

- Abra `https://app.seudominio.com` e confirme a interface PT-BR carregando sem erros.
- Ajuste permissões se necessário: `chmod -R 775 storage bootstrap/cache`.
- Atualize a senha do usuário admin padrão.
- Teste envio de e-mail, notificações push e integrações de pagamento (se configuradas).

Pronto! O backend Laravel estará no ar no cPanel com MySQL, pronto para ser consumido pelos apps Rider e Driver.
