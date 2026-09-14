# Wervexa — Web (Public Website + Admin Panel)

A local/home-service platform connecting customers with verified skilled workers
(electricians, plumbers, AC and appliance technicians, and other home-service
professionals).

This directory holds the Next.js application **and** the shared platform backend
definitions (Supabase schema, Firebase rules) that the Flutter apps also target.

## Repository layout

```
SIH-89/
├── web/              <- you are here
│   ├── src/          Next.js application (public website + admin panel)
│   ├── supabase/     Database: migrations, RLS, RPC, Edge Functions
│   ├── firebase/     Identity + storage: security rules
│   ├── docs/         Architecture, backend contracts, runbooks
│   ├── tests/        Authorization, state machine and security tests
│   └── public/       Static assets
├── customer-app/     Flutter — customer application
└── worker-app/       Flutter — worker application
```

The Flutter apps consume the same Supabase schema and the same Firebase project
defined here. Treat `supabase/migrations` and `firebase/storage.rules` as shared
platform contracts: changing them affects all four clients, not just the web tier.

## Platform architecture

| Responsibility                  | Technology                       |
| ------------------------------- | -------------------------------- |
| Authentication                  | Firebase Authentication          |
| User identity                   | Firebase UID                     |
| Photos, videos, documents       | Firebase Storage                 |
| Business data, authorization    | Supabase PostgreSQL              |
| Database security               | Supabase RLS + trusted backend   |
| Realtime updates                | Supabase Realtime                |
| Server business logic           | Supabase Edge Functions / Next.js route handlers |
| Public website + Admin Panel    | Next.js on Vercel                |
| Customer and Worker apps        | Flutter                          |

```
                 Firebase Authentication
                          │  uid
                          ▼
                 ┌──────────────────┐
                 │   Supabase DB    │
                 │  profiles        │
                 │  workers         │
                 │  customers       │
                 │  admin_users     │
                 └────────┬─────────┘
                          ▼
                 Authorization layer
              ┌───────────┼───────────┐
          Customer      Worker       Admin
              ▼           ▼           ▼
        Customer App  Worker App  Admin Panel

  Firebase Storage holds every file.
  Supabase media_assets holds only the reference.
```

Firebase is the single authentication provider and the single media store.
Supabase Auth and Supabase Storage are **not** used anywhere in this platform.

## Getting started

```bash
cd web
cp .env.example .env.local   # fill in Firebase + Supabase values
npm install
npm run dev
```

Database:

```bash
supabase start
supabase db reset            # applies supabase/migrations in order
```

## Documentation

| Document | Contents |
| -------- | -------- |
| [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) | System design, trust boundaries, identity model |
| [docs/BACKEND_CONTRACTS.md](docs/BACKEND_CONTRACTS.md) | Contracts the web tier requires from the platform |
| [docs/IMPLEMENTATION_PLAN.md](docs/IMPLEMENTATION_PLAN.md) | Build phases and current status |
| [docs/SECURITY.md](docs/SECURITY.md) | Threat model and the controls that answer it |
| [docs/ADMIN_SUBDOMAIN_MIGRATION.md](docs/ADMIN_SUBDOMAIN_MIGRATION.md) | Moving `/admin` to `admin.` without a rewrite |
