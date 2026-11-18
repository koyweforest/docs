# Contribuir / Contributing

## Valores de ejemplo

Los ejemplos en la documentación, en `openapi.json` y en cualquier colección deben
usar solo identificadores y datos ficticios. Nunca copies valores desde producción
ni desde sandbox.

- IDs con prefijo (UUID): usa ceros manteniendo el prefijo, por ejemplo
  `mrc_00000000-0000-0000-0000-000000000000`. Si un ejemplo necesita varios IDs
  distintos, usa `...000000000001`, `...000000000002`, etc.
- UUIDs sin prefijo: `00000000-0000-0000-0000-000000000000` (o `...0001`, etc.).
- ObjectIds (24 caracteres hex, por ejemplo `clientId`, `quoteId`):
  `000000000000000000000000` (o `...0001`, etc.).
- Emails: direcciones `@example.com`, por ejemplo `user@example.com`.
- Credenciales y tokens: `YOUR_API_KEY`, `YOUR_AUTH_TOKEN`.
- Documentos, cuentas bancarias y wallets: valores claramente ficticios
  (por ejemplo `11.111.111-1`, `0x0000000000000000000000000000000000000000`).

El script `scripts/check-example-ids.sh` revisa los archivos `.md`, `.mdx`,
`.json` y `.yaml` y falla si encuentra un UUID, ObjectId o JWT que no sea un
placeholder. Se ejecuta en cada pull request. Para correrlo localmente:

```sh
scripts/check-example-ids.sh
```

Si una línea contiene un ID de un servicio externo (por ejemplo, un video
embebido), agrega un patrón en `scripts/example-ids-allowlist.txt`.

## Example values

Examples in the docs, in `openapi.json` and in any collection must use only
fictitious identifiers and data. Never copy values from production or sandbox.

- Prefixed UUID ids: zeros with the same prefix, e.g.
  `mrc_00000000-0000-0000-0000-000000000000`. If an example needs several
  distinct ids, use `...000000000001`, `...000000000002`, etc.
- Unprefixed UUIDs: `00000000-0000-0000-0000-000000000000` (or `...0001`, etc.).
- ObjectIds (24 hex characters, e.g. `clientId`, `quoteId`):
  `000000000000000000000000` (or `...0001`, etc.).
- Emails: `@example.com` addresses, e.g. `user@example.com`.
- Credentials and tokens: `YOUR_API_KEY`, `YOUR_AUTH_TOKEN`.
- Document numbers, bank accounts and wallets: clearly fictitious values
  (e.g. `11.111.111-1`, `0x0000000000000000000000000000000000000000`).

`scripts/check-example-ids.sh` scans `.md`, `.mdx`, `.json` and `.yaml` files
and fails if it finds a UUID, ObjectId or JWT that is not a placeholder. It runs
on every pull request. To run it locally:

```sh
scripts/check-example-ids.sh
```

If a line contains an id from a third-party service (e.g. an embedded video),
add a pattern to `scripts/example-ids-allowlist.txt`.
