# Auth Testing

Admin login: email `admin@gmail.com`, password `amin123#` (from backend/.env ADMIN_EMAIL/ADMIN_PASSWORD).

## API test
```
curl -c cookies.txt -X POST http://localhost:8001/api/auth/login -H "Content-Type: application/json" -d '{"email":"admin@gmail.com","password":"amin123#"}'
curl -b cookies.txt http://localhost:8001/api/auth/me
```
Login returns the user object and sets httpOnly access_token + refresh_token cookies.
Protected admin endpoints require the cookie (or Authorization: Bearer <access_token>).

## Mongo
```
use aku_online
db.users.find({role:"admin"})
db.respondents.getIndexes()   # nik unique, reference_code unique
```
