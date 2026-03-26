# MotoH Client

App client pour trouver et contacter des chauffeurs moto-taxi proches.

## Lancement

```bash
flutter run -d chrome
```

## Backend API (motoh-api)

### Demarrage du serveur

```bash
cd ../motoh-api
go run cmd/api/main.go
```

Le serveur demarre sur `http://localhost:8080`.
En mode dev (`DEV_MODE=true`), les codes OTP sont affiches dans les logs ET retournes dans la reponse JSON.

### Endpoints utilises par l'app client

| Methode | Endpoint                  | Auth   | Description                          |
|---------|---------------------------|--------|--------------------------------------|
| POST    | `/auth/request-otp`       | Non    | Demande un OTP par SMS               |
| POST    | `/auth/verify-otp`        | Non    | Verifie l'OTP, retourne un JWT       |
| GET     | `/auth/me`                | JWT    | Infos de l'utilisateur connecte      |
| PUT     | `/auth/fcm-token`         | JWT    | Enregistre le token FCM du device    |
| GET     | `/nearby-drivers`         | JWT    | Recherche chauffeurs proches         |
| GET     | `/drivers/:id`            | JWT    | Profil public d'un chauffeur         |

### Flux d'authentification

```
1. POST /auth/request-otp
   Body: { "phone": "+2250700000000" }
   Reponse: { "user_id": "xxx", "otp_code": "123456", "message": "OTP sent successfully" }
            (otp_code visible uniquement en DEV_MODE=true)

2. POST /auth/verify-otp
   Body: { "user_id": "xxx", "code": "123456" }
   Reponse: { "token": "eyJ...", "user_id": "xxx", "role": "client" }

3. Utiliser le token dans le header pour tous les appels proteges :
   Authorization: Bearer eyJ...
```

### Recherche de chauffeurs proches

```
GET /nearby-drivers?lat=5.3600&lng=-4.0083&radius=5
Authorization: Bearer <token>

Reponse: liste de chauffeurs visibles tries par distance
```

### Enregistrement du token FCM

```
PUT /auth/fcm-token
Authorization: Bearer <token>
Body: { "fcm_token": "dK7x..." }
```

### Rate limiting

- OTP : 5 requetes/min par IP
- Global : 60 requetes/min par IP

### Base URL pour le dev

```
http://localhost:8080
```
