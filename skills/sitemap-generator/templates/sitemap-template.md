# Sitemap - [Nome Progetto]

> Stato: [DRAFT | APPROVATO]
> Generato: [data]

## Panoramica

| Metrica | Valore |
|---------|--------|
| Pagine totali | X |
| Pagine pubbliche | Y |
| Pagine autenticate | Z |
| Profondità max | N |

## Struttura Pagine

### 🌐 Pubbliche (non autenticate)

| Route | Pagina | Descrizione |
|-------|--------|-------------|
| `/` | Landing | Homepage pubblica |
| `/login` | Login | Autenticazione utente |
| `/register` | Registrazione | Creazione account |

### 🔒 Autenticate

| Route | Pagina | Descrizione |
|-------|--------|-------------|
| `/dashboard` | Dashboard | Home utente |
| `/[resources]` | [Resource] List | Lista [risorse] |
| `/[resources]/:id` | [Resource] Detail | Dettaglio [risorsa] |
| `/settings` | Settings | Impostazioni |

## Gerarchia Navigazione

```
App
├── Auth
│   ├── Login
│   ├── Register
│   └── Forgot Password
├── Main (autenticato)
│   ├── Dashboard
│   ├── [Resources]
│   │   ├── List
│   │   └── Detail
│   └── Settings
└── Error
    ├── 404
    └── 500
```

## Flussi Principali

### Autenticazione
```
Landing → Login → Dashboard
       ↘ Register → Verify Email → Login
```

### [Flusso Custom]
```
[Descrizione flusso specifico]
```
