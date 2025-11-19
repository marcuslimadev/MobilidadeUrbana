# Deploy no Render.com

Guia para fazer deploy automático do backend Laravel no Render usando o repositório GitHub.

## 1. Pré-requisitos

- Conta no [Render.com](https://render.com)
- Repositório GitHub publicado: https://github.com/marcuslimadev/MobilidadeUrbana
- Banco de dados MySQL/PostgreSQL externo (Render oferece PostgreSQL gratuito)

## 2. Criar banco de dados no Render

1. Acesse o [Dashboard do Render](https://dashboard.render.com)
2. Clique em **New** → **PostgreSQL** (ou use MySQL externo)
3. Configure:
   - **Name:** `mobilidade-urbana-db`
   - **Database:** `mobilidade_urbana`
   - **User:** (gerado automaticamente)
   - **Region:** Oregon (ou mais próximo do Brasil)
   - **Instance Type:** Free (para testes)
4. Clique em **Create Database**
5. Aguarde a criação e anote as credenciais (Internal Database URL)

## 3. Importar estrutura do banco

Conecte ao banco PostgreSQL do Render via cliente (DBeaver, pgAdmin, etc.) usando as credenciais fornecidas e importe o schema:

```bash
# Se usar PostgreSQL, converta o database.sql de MySQL para PostgreSQL
# Ou use um banco MySQL externo (ex: PlanetScale, Railway)
```

**Alternativa:** Use um banco MySQL externo como [PlanetScale](https://planetscale.com) (gratuito) ou [Railway](https://railway.app).

## 4. Criar Web Service no Render

1. No Dashboard, clique em **New** → **Web Service**
2. Conecte ao GitHub e selecione `marcuslimadev/MobilidadeUrbana`
3. Configure o serviço:

### Configurações básicas:
- **Name:** `mobilidade-urbana-api`
- **Region:** Oregon (ou mais próximo)
- **Branch:** `main`
- **Root Directory:** (deixe vazio - usa raiz do repo)
- **Runtime:** PHP
- **Build Command:**
  ```bash
  cd Files/Laravel/core && composer install --no-dev --optimize-autoloader --no-interaction && php artisan config:cache && php artisan route:cache && php artisan view:cache
  ```
- **Start Command:**
  ```bash
  cd Files/Laravel && php -S 0.0.0.0:$PORT server.php
  ```

### Variáveis de ambiente (Environment):

Clique em **Advanced** e adicione:

**Essenciais:**
```
APP_NAME=Mobilidade Urbana
APP_ENV=production
APP_DEBUG=false
APP_KEY=base64:GERAR_COM_php_artisan_key:generate
APP_URL=https://mobilidade-urbana-api.onrender.com
APP_LOCALE=pt_BR
APP_FALLBACK_LOCALE=pt_BR
APP_FAKER_LOCALE=pt_BR
APP_TIMEZONE=America/Sao_Paulo

DB_CONNECTION=mysql
DB_HOST=<SEU_DB_HOST>
DB_PORT=3306
DB_DATABASE=mobilidade_urbana
DB_USERNAME=<SEU_DB_USER>
DB_PASSWORD=<SEU_DB_PASSWORD>

CACHE_DRIVER=file
QUEUE_CONNECTION=database
SESSION_DRIVER=file
SESSION_LIFETIME=120
FILESYSTEM_DISK=public
LOG_CHANNEL=stack
LOG_LEVEL=error
BROADCAST_CONNECTION=log
```

**Opcionais (SMTP):**
```
MAIL_MAILER=smtp
MAIL_HOST=<SEU_SMTP_HOST>
MAIL_PORT=587
MAIL_USERNAME=<SEU_SMTP_USER>
MAIL_PASSWORD=<SEU_SMTP_PASSWORD>
MAIL_ENCRYPTION=tls
MAIL_FROM_ADDRESS=noreply@seudominio.com
MAIL_FROM_NAME=Mobilidade Urbana
```

**Opcionais (Pusher):**
```
PUSHER_APP_ID=<SEU_APP_ID>
PUSHER_APP_KEY=<SEU_APP_KEY>
PUSHER_APP_SECRET=<SEU_APP_SECRET>
PUSHER_APP_CLUSTER=mt1
```

4. Clique em **Create Web Service**

## 5. Gerar APP_KEY

Após o primeiro deploy (vai falhar sem APP_KEY):

1. Acesse o **Shell** do serviço no Render Dashboard
2. Execute:
   ```bash
   cd Files/Laravel/core
   php artisan key:generate --show
   ```
3. Copie o valor gerado (ex: `base64:abc123...`)
4. Volte em **Environment** e atualize `APP_KEY`
5. Salve e aguarde o redeploy automático

## 6. Executar migrations

No Shell do Render:
```bash
cd Files/Laravel/core
php artisan migrate --force
php artisan storage:link
php artisan optimize
```

## 7. Configurar domínio customizado (opcional)

1. Acesse **Settings** → **Custom Domains**
2. Adicione seu domínio (ex: `api.mobilidadeurbana.com`)
3. Configure DNS com CNAME apontando para o domínio Render fornecido
4. Atualize `APP_URL` com o novo domínio

## 8. Configurar apps Flutter

Edite `Files/Flutter/Driver/lib/environment.dart` e `Files/Flutter/Rider/lib/environment.dart`:

```dart
static const String baseUrl = 'https://mobilidade-urbana-api.onrender.com';
```

Recompile os apps e redistribua.

## 9. Monitoramento

- **Logs:** Acesse **Logs** no Dashboard para ver erros em tempo real
- **Métricas:** Veja CPU/RAM em **Metrics**
- **Auto-deploy:** Push para `main` no GitHub dispara deploy automático

## 10. Notas importantes

- ⚠️ **Plano Free:** O servidor "dorme" após 15min inativo (primeira requisição após sleep demora ~30s)
- ⚠️ **Uploads:** Arquivos salvos em `storage/` são efêmeros no Render (use S3/Cloudinary para produção)
- ✅ **SSL:** HTTPS automático e gratuito
- ✅ **Auto-deploy:** Integração contínua com GitHub

## Alternativas ao Render

- **Railway:** Similar, também com deploy automático
- **Fly.io:** Mais próximo do Brasil (São Paulo)
- **DigitalOcean App Platform:** Mais robusto, mas pago desde o início

---

**URL da aplicação após deploy:** https://mobilidade-urbana-api.onrender.com
