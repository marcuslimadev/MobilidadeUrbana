# Configuração Google Maps & Firebase

## Chaves Configuradas

### Google Maps API
- **Android Key**: `AIzaSyBAuSnmKcSGEcEOEVlzWIJnYUbYlmTL8Hs`
- **Firebase API Key**: `AIzaSyBYPFM_tuJVhFsvNrl1QeKFvB1CZ9m1gGY`

## Arquivos Atualizados

### ✅ Apps Flutter

#### Rider App
- [x] `Files/Flutter/Rider/lib/environment.dart` - mapKey atualizado
- [x] `Files/Flutter/Rider/android/app/src/main/AndroidManifest.xml` - API_KEY configurado

#### Driver App
- [x] `Files/Flutter/Driver/lib/environment.dart` - mapKey atualizado
- [x] `Files/Flutter/Driver/android/app/src/main/AndroidManifest.xml` - API_KEY configurado

### ⏳ Backend Laravel (aguardando conexão VPS)

Execute no servidor quando a conexão retornar:

```bash
cd /var/www/semup/Files/Laravel/core

# Atualizar Google Maps API no .env
sed -i 's/GOOGLE_MAPS_API=.*/GOOGLE_MAPS_API=AIzaSyBAuSnmKcSGEcEOEVlzWIJnYUbYlmTL8Hs/' .env

# Ou adicionar se não existir
echo "GOOGLE_MAPS_API=AIzaSyBAuSnmKcSGEcEOEVlzWIJnYUbYlmTL8Hs" >> .env

# Atualizar no banco de dados via artisan
php artisan tinker --execute="
\$gs = \App\Models\GeneralSetting::first();
\$gs->google_maps_api = 'AIzaSyBAuSnmKcSGEcEOEVlzWIJnYUbYlmTL8Hs';
\$gs->save();
echo 'Google Maps API atualizada no banco!';
"

# Limpar caches
php artisan config:clear
php artisan cache:clear
```

## Firebase Configuration

### Android Apps
Certifique-se de que os arquivos `google-services.json` estão presentes em:
- `Files/Flutter/Rider/android/app/google-services.json`
- `Files/Flutter/Driver/android/app/google-services.json`

**API Key do Firebase**: `AIzaSyBYPFM_tuJVhFsvNrl1QeKFvB1CZ9m1gGY`

### iOS Apps (se necessário)
- `Files/Flutter/Rider/ios/Runner/GoogleService-Info.plist`
- `Files/Flutter/Driver/ios/Runner/GoogleService-Info.plist`

## Rebuild dos Apps

Após as configurações, rebuilde os apps:

```bash
# Rider App
cd Files/Flutter/Rider
flutter clean
flutter pub get
flutter build apk --release

# Driver App
cd Files/Flutter/Driver
flutter clean
flutter pub get
flutter build apk --release
```

## Validação

### Testar Google Maps
1. Abrir app Rider ou Driver
2. Permitir acesso à localização
3. Verificar se o mapa carrega corretamente
4. Testar busca de endereços

### Testar Firebase
1. Verificar notificações push
2. Testar login/registro
3. Verificar analytics (Firebase Console)

## Links Importantes

- **Google Cloud Console**: https://console.cloud.google.com/
- **Firebase Console**: https://console.firebase.google.com/
- **APIs habilitadas necessárias**:
  - Maps SDK for Android
  - Places API
  - Geocoding API
  - Directions API
