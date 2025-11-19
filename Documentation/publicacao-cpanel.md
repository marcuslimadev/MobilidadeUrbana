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

### Opção A: Git Version Control (recomendada)

1. No cPanel, abra **Git Version Control**
2. Clique em **Create**
3. Preencha:
   - **Clonar URL:** `https://github.com/marcuslimadev/MobilidadeUrbana.git`
   - **Caminho do Repositório:** `/home/mobilidade` (ou `/home/SEU_USUARIO/mobilidade`)
   - **Nome do Repositório:** (deixe vazio - será preenchido automaticamente)
4. Clique em **Criar** e aguarde o clone

### Opção B: Upload ZIP

No **File Manager**, envie `mobilidade-urbana.zip`, extraia e verifique se as pastas `Files/`, `Documentation/`, `Updates/` ficaram completas.

## 3. Criar banco de dados MySQL

1. Acesse **MySQL® Databases**
2. Em **Criar Novo Banco de Dados**:
   - Nome: `moburb` (ou `mobilidade_urbana`)
   - Clique em **Criar Banco de Dados**
3. Em **Adicionar Novo Usuário**:
   - Nome de usuário: `app`
   - Senha: (gere uma senha forte)
   - Clique em **Criar Usuário**
4. Em **Adicionar Usuário ao Banco de Dados**:
   - Usuário: selecione o criado (`app`)
   - Banco de dados: selecione o criado (`moburb`)
   - Clique em **Adicionar**
5. Marque **TODOS OS PRIVILÉGIOS** → **Fazer Mudanças**
6. No **phpMyAdmin**, selecione o banco e importe `Files/Laravel/install/database.sql`

Anote as credenciais (irá precisar no .env):
```
DB_HOST=localhost
DB_DATABASE=SEU_USUARIO_moburb
DB_USERNAME=SEU_USUARIO_app
DB_PASSWORD=<senha_que_você_criou>
```

> **Importante:** O cPanel adiciona o prefixo do seu usuário automaticamente (ex: `cpuser_moburb`).

## 4. Definir o diretório público

1. No cPanel, vá em **Domains** → selecione seu domínio
2. Em **Document Root**, configure:
   - **Caminho:** `/home/mobilidade/Files/Laravel` (ajuste `mobilidade` se usou caminho diferente)
3. Salve as alterações
4. O `.htaccess` em `Files/Laravel/` já direciona para `index.php`, que carrega `core/bootstrap/app.php`

> **Nota:** Se clonou em `/home/SEU_USUARIO/mobilidade`, use `/home/SEU_USUARIO/mobilidade/Files/Laravel`

## 5. Configurar `.env`

1. No **File Manager**, navegue até `/home/mobilidade/Files/Laravel/core/`
2. Localize o arquivo `.env.example` (se não existir `.env`)
3. Copie `.env.example` para `.env` (botão direito → Copy → renomeie para `.env`)
4. Clique com botão direito em `.env` → **Edit**
5. Atualize com as informações de produção:

```env
APP_NAME="Mobilidade Urbana"
APP_ENV=production
APP_DEBUG=false
APP_URL=https://seudominio.com
APP_LOCALE=pt_BR
APP_FALLBACK_LOCALE=pt_BR
APP_TIMEZONE=America/Sao_Paulo

DB_CONNECTION=mysql
DB_HOST=localhost
DB_PORT=3306
DB_DATABASE=SEU_USUARIO_moburb
DB_USERNAME=SEU_USUARIO_app
DB_PASSWORD=<senha_forte_aqui>

CACHE_DRIVER=file
QUEUE_CONNECTION=database
SESSION_DRIVER=file
SESSION_LIFETIME=120
FILESYSTEM_DISK=public
```

6. **Salve** o arquivo (Ctrl+S ou botão Save)

> **Dica:** Use o **Terminal** do cPanel (se disponível) ou SSH para gerar APP_KEY depois.

## 6. Instalar dependências no servidor

### Via Terminal do cPanel ou SSH:

```bash
cd /home/mobilidade/Files/Laravel/core
composer install --no-dev --optimize-autoloader
php artisan key:generate        # gera APP_KEY automaticamente
php artisan migrate --force     # cria/atualiza tabelas do banco
php artisan storage:link        # cria symlink para uploads públicos
php artisan optimize            # cache de config/rotas/views
```

### Sem acesso SSH?

1. No computador local, rode:
   ```powershell
   cd c:\Projetos\MobilidadeUrbana\Files\Laravel\core
   composer install --no-dev --optimize-autoloader
   ```
2. Compacte a pasta `vendor/` gerada
3. Envie via File Manager para `/home/mobilidade/Files/Laravel/core/vendor/`
4. No File Manager do cPanel, crie o arquivo `.env` manualmente e adicione:
   ```
   APP_KEY=base64:GERAR_KEY_AQUI
   ```
5. Para gerar APP_KEY sem terminal, use: https://generate-random.org/laravel-key-generator

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
