# Riferimento Default Pragmatici MVP/PoC

Quando il brief non specifica qualcosa, usa questi default a meno che l'utente non indichi diversamente.

## Architettura e Deploy

| Default | Perché Adatto per MVP | Quando Fare Override |
|---------|------------------|---------------|
| **Single-tenant SaaS** (vs multi-tenant) | Saves 2-3 weeks (no data isolation, billing complexity) | Multiple orgs managing own data |
| **Web + mobile responsive** (vs native apps) | 50% faster to market, all devices | Needs offline-first or app store |
| **Cloud managed services** (vs on-premise) | Lower ops burden, auto-scaling | Data residency/security requirements |

---

## Default Hardware e IoT

| Default | Perché Adatto per MVP | Quando Fare Override |
|---------|------------------|---------------|
| **Single device type** (vs multiple SKUs) | Validates market fit first, iterate after | Market demands variants from day 1 |
| **Off-shelf components** (vs custom PCB) | Faster prototype, lower NRE, easier sourcing | Specific performance/size/cost needs |
| **WiFi connectivity** (vs cellular/LoRa) | Standard, user-managed, low cost | Needs standalone or Bluetooth for cost |
| **USB charging** (vs proprietary/wireless) | Ubiquitous, cheap, users have cables | Wearable/always-on (then optimize battery) |
| **Unregulated device** (vs FCC/CE/medical) | Avoids 3-6mo certification cost | Medical, safety-critical, or radioactive |
| **Simple firmware** (vs RTOS) | Faster dev, easier debug, quicker iteration | Hard real-time or extreme reliability needs |
| **Cloud backend** (vs offline-only) | Learn from data, update without recalls | Privacy/security requires fully local |
| **Manual updates** (vs automatic) | Acceptable for MVP small user base | Device at scale, manual infeasible |
| **50-200 units** (vs 1000+) | Validate with real users first | Market demands high volume from launch |

---

## Scala e Performance

| Default | Perché Adatto per MVP | Quando Fare Override |
|---------|------------------|---------------|
| **<2sec response** (vs <500ms) | Acceptable web standard, matches expectations | Real-time or time-critical operations |
| **Tens-hundreds users** (vs thousands+) | Realistic MVP scale, easier validation | Enterprise/platform ambitions from day 1 |
| **Single-digit concurrent** (vs hundreds) | MVP load light, scale later | High-traffic operations or campaigns |
| **Business hours (9am-6pm)** (vs 24/7 SLA) | MVP doesn't justify 24/7 ops cost | Multi-timezone requiring continuous access |

---

## Sicurezza e Compliance

| Default | Perché Adatto per MVP | Quando Fare Override |
|---------|------------------|---------------|
| **GDPR if EU users** | Legal requirement | Different jurisdiction requirements |
| **Standard security** (HTTPS, DB encryption vs HSM) | Managed cloud handles well | Financial/healthcare/regulated data |
| **Email/password** (vs SSO/OAuth/SAML) | Simplest to implement | Enterprise with existing SSO |
| **No backup SLA** (vs RPO<1h, RTO<15m) | MVP doesn't warrant DR cost | Critical business data, loss catastrophic |

---

## Funzionalità e Integrazioni

| Default | Perché Adatto per MVP | Quando Fare Override |
|---------|------------------|---------------|
| **No integrations v1** | Each adds 1-2 weeks, focus core first | Integration core to solution |
| **Manual data entry** (vs bulk import) | Small data volume for MVP | Large existing dataset to migrate |
| **Email/CSV export** (vs APIs/webhooks) | Simple, covers 90% MVP cases | Downstream system integration needed |
| **Polling** (vs WebSocket/real-time) | Simpler, acceptable latency for MVP | Instant sync across devices/users needed |

---

## Compatibilità Piattaforma

| Default | Perché Adatto per MVP | Quando Fare Override |
|---------|------------------|---------------|
| **Modern browsers** (Chrome/Firefox/Safari/Edge 90+, vs IE11) | Avoid dev complexity, MVP users have modern browsers | Specific legacy customer base |
| **Desktop-first** (vs mobile-first) | MVP users work at desks, responsive sufficient | Primary use genuinely mobile (field work) |
| **No native app** (vs iOS/Android) | Web saves months of development | Needs offline, app store, platform features |

---

## Dati e Storage

| Default | Perché Adatto per MVP | Quando Fare Override |
|---------|------------------|---------------|
| **Relational DB** (PostgreSQL/MySQL vs NoSQL) | Structured data, ACID, well-understood | Unstructured data or extreme scale |
| **Cloud file storage** (S3/GCS vs DB BLOBs/CDN) | Simpler, auto-scales | High-speed media delivery globally |
| **Daily backups** (vs real-time replication) | Adequate for MVP, lower cost | Can't tolerate 24h data loss |

---

## DevOps e Deployment

| Default | Perché Adatto per MVP | Quando Fare Override |
|---------|------------------|---------------|
| **Managed cloud** (AWS/GCP/Heroku vs K8s/self-managed) | Lower ops burden, auto-scaling, cost-effective | Specific cloud reqs or vendor lock-in concerns |
| **Weekly deploys** (vs CD/multiple daily) | Reduced ops complexity for MVP | Needs rapid feedback loop or A/B testing |
| **Standard logging/monitoring** (vs custom) | Managed services provide basic monitoring | Specific operational requirements |

---

## Costi e Operazioni

| Default | Perché Adatto per MVP | Quando Fare Override |
|---------|------------------|---------------|
| **$100-500/mo infrastructure** (vs enterprise) | MVP doesn't warrant expensive infra | Higher scale expectations from start |
| **Email support only** (vs phone/chat/24-7) | Reduces ops cost, adequate for MVP | B2B enterprise expecting premium support |
| **Minimal documentation** (vs comprehensive API/training) | MVP is learning phase, docs evolve | Integrates with many external systems |

---

## Quando Fare Override

- **L'utente lo afferma esplicitamente**: Rispetta sempre (es. "serve real-time" → WebSocket)
- **Il vincolo lo rende impossibile**: Adatta (es. "HIPAA" → non sicurezza standard)
- **Conflitto con bisogno core**: Scegli obiettivo MVP (es. "sync QuickBooks" → integrazione È core)
- **Norme del settore**: Rispetta il dominio (es. finanziario → encryption, audit trail)

---

## Come Usare nelle Domande

Integra i default nei suggerimenti delle domande:
```
1. Che cosa intendi per "piattaforma"?
   Suggerimento: Web responsive
   Perché: Più veloce da sviluppare rispetto ad app native

2. Che cosa intendi per "molti utenti"?
   Suggerimento: Decine o centinaia per MVP (non migliaia)
   Perché: Scala realistica per validare prodotto
```

L'utente può accettare con "OK" o fornire risposta diversa.

---

## Checklist: Default Coperti

Quando presenti l'output della Fase 1, verifica di aver considerato:

- [ ] Piattaforma (web, mobile, desktop?)
- [ ] Scala (quanti utenti/transazioni?)
- [ ] Architettura (single vs multi-tenant?)
- [ ] Performance (aspettative tempo di risposta)
- [ ] Disponibilità (24/7 o orario lavorativo?)
- [ ] Sicurezza (standard o personalizzata?)
- [ ] Compliance (GDPR, specifica del settore?)
- [ ] Integrazioni (richieste per v1?)
- [ ] Dati (struttura, storage, backup?)
- [ ] Costi (budget infrastruttura?)
- [ ] Deployment (quanto spesso? dove?)

