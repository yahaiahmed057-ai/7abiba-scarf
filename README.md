# متجر حبيبة سكارف — Store for tarha & isdal (Arabic / RTL)

Full-stack store: storefront + REST API + SQLite database + admin dashboard.
**Zero npm dependencies.** Needs only **Node.js 22.5 or newer** (uses the built-in `node:sqlite`).

## Architecture
```
server/index.js   HTTP server, routes, auth (sessions), uploads, static files
server/service.js Business logic: products, orders, stock, payments, reports
server/db.js      SQLite schema (constraints, FKs, indexes) + transaction helper
server/paymob.js  Paymob card-payment integration (session + HMAC webhook verification)
server/lib.js     Validation, scrypt password hashing, rate limiting, image sniffing
public/           Storefront (vanilla JS SPA, RTL, mobile first)
admin/            Admin dashboard (served at /admin/, API is protected server-side)
tests/test.js     Automated backend tests (npm test)
```

## Run
```
cp .env.example .env      # then edit it
npm start                 # أو start.bat للتجربة، أو install-autostart.bat ليعمل في الخلفية دائمًا
npm test
```
On the first start an admin is created from `ADMIN_EMAIL` / `ADMIN_PASSWORD`
(if the password is empty a random one is printed once in the console).
Roles: SUPER_ADMIN, ADMIN (everything), STAFF (read products/orders/inventory, update orders).

## Environment variables
| Name | Purpose |
|---|---|
| PORT, APP_URL | Port and public URL (use https in production -> cookies get `Secure`) |
| ALLOWED_ORIGINS | Comma list of allowed CORS origins (empty = same-origin only) |
| DATABASE_PATH, UPLOAD_DIR | SQLite file and uploaded images folder (must be on a **persistent disk**) |
| ADMIN_EMAIL, ADMIN_PASSWORD | First admin account |
| PAYMENT_API_KEY, PAYMENT_INTEGRATION_ID, PAYMENT_IFRAME_ID, PAYMENT_WEBHOOK_SECRET | Paymob merchant values |

## Online payment (Paymob) — requires merchant setup
Card payment is **disabled until all four PAYMENT_* values are set**; the option is then hidden at checkout.
1. Create a Paymob merchant account; copy API key, card Integration ID, iframe ID and HMAC secret into `.env`.
2. In the Paymob dashboard set the **transaction processed callback** to `https://YOUR-DOMAIN/api/payments/webhook`
   and the response/redirect URL to `https://YOUR-DOMAIN/#/payment-result`.
3. The order is only marked PAID by the signed webhook (HMAC-SHA512, amount checked, replay-safe). The redirect is never trusted.
> The Paymob code was written without internet access to the current docs. **Verify it against docs.paymob.com and test in Paymob test mode before going live.**
> You must enter the store's own merchant data to enable online payment.

## Security notes
Prices, totals, shipping and stock are always computed on the server; the stock decrement is a conditional atomic
`UPDATE ... WHERE stock >= qty` inside a transaction. Passwords use scrypt; sessions are HttpOnly SameSite cookies;
login, orders, tracking, payments, uploads and webhook are rate limited (in-memory, per process); uploads are checked by magic bytes.
Back up `data/` and `uploads/` regularly. Run behind HTTPS (e.g. a reverse proxy).

## Limits
Single-process SQLite (fine for a small store; rate limiter is per process). Refund API is not implemented (REFUNDED is only recorded from the gateway webhook).
Order notifications are a WhatsApp link opened by the customer, not an automatic server message.
