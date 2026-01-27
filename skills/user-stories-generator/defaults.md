# Default Values e Assunzioni

Questo documento definisce valori default e assunzioni pragmatiche usate dalla skill quando il project brief non fornisce indicazioni esplicite.

---

## File Intermedi (Workflow File-Based)

### Naming Conventions

**File generati durante processo**:
- `user-stories-structure.md` (Fase 1: Analisi iniziale)
- `user-stories-list.md` (Fase 3-4: Lista titoli + edge cases)
- `user-stories-draft.md` (Fase 5-6: Stories espanse + validazione)

**File output finali**:
- `user-stories-[nome-progetto].md` (single-file)
- `user-stories-[nome-progetto]-overview.md` (multi-file overview)
- `user-stories-[app/area].md` (multi-file sections)

### Gestione File Intermedi

**Durante processo**:
- Mantieni in directory corrente per facile accesso
- Utente modifica direttamente con editor
- Ogni fase legge versione potenzialmente modificata

**Dopo completamento**:
- Opzionalmente archivia in sottodirectory `_intermediate/`
- Mantieni per iterazioni future (es: aggiungere stories a progetto esistente)
- Utili per audit trail (capire come si è arrivati all'output finale)

### Workflow Modifiche Utente

**Approccio consigliato con 100+ stories**:
1. Genera file intermedio (es: list.md)
2. Utente modifica direttamente nel editor (VS Code, vim, etc.)
3. Utente aggiunge commenti HTML `<!-- TODO: ... -->` per guidare skill
4. Utente conferma in chat quando pronto
5. Skill legge file modificato e procede

**Vantaggi vs modifiche incrementali in chat**:
- Più efficiente con volumi grandi (100+ stories)
- Visione d'insieme completa
- Può usare find/replace, multi-cursor editing
- Può comparare con altri documenti side-by-side

---

## Priorità Stories

### Criteri Default

**Must Have** (critici per MVP):
- Funzionalità di autenticazione base (registrazione, login, logout)
- CRUD operations per entità core del dominio
- Flussi utente primari menzionati negli "obiettivi MVP" del brief
- Funzionalità senza le quali il prodotto non è utilizzabile

**Should Have** (importanti ma non blocker):
- Funzionalità di ricerca e filtri avanzati
- Notifiche e comunicazioni utente
- Gestione profilo avanzata (avatar, preferenze)
- Features menzionate come "importanti" ma non in scope MVP

**Nice to Have** (enhancement futuri):
- Integrazioni con servizi esterni (social login, export, etc.)
- Personalizzazioni e temi
- Analytics e dashboard avanzati
- Features menzionate come "future" o "nice to have" nel brief

### Assegnazione Automatica

**Se brief ha sezione "MVP Scope"**: Usa quella come riferimento principale
**Se ambiguo**: Applica questi default
- Autenticazione → Must Have
- CRUD base → Must Have
- Ricerca/Filtri → Should Have
- Notifiche → Should Have
- Integrazioni → Nice to Have
- Personalizzazioni UI → Nice to Have

---

## Granularità Livelli

### Stories per Area (approssimativo)

**Epic Level**:
- 1-2 stories per area funzionale
- Totale progetto: 5-10 stories

**Feature Level** (CONSIGLIATO):
- 3-5 stories per area funzionale
- Totale progetto: 15-40 stories

**Task Level**:
- 8-15 stories per area funzionale
- Totale progetto: 40-100+ stories

### Quando Consigliare Livello

- **Epic**: Brief < 3 pagine, concept validation, pitch deck
- **Feature**: Brief 3-10 pagine, validazione cliente, MVP planning (MOST COMMON)
- **Task**: Brief > 10 pagine dettagliato, handoff a development

---

## Nomenclatura Aree

### Abbreviazioni Standard

**Se brief menziona queste aree**, usa questi prefissi:

- Autenticazione / Authentication → **AUTH**
- Profilo / Profile → **PROFILE**
- Dashboard / Home → **DASHBOARD**
- Utenti / Users → **USERS**
- Amministrazione / Admin → **ADMIN**
- Contenuti / Content → **CONTENT**
- Prodotti / Products → **PRODUCTS**
- Ordini / Orders → **ORDERS**
- Pagamenti / Payments → **PAYMENT**
- Carrello / Cart → **CART**
- Ricerca / Search → **SEARCH**
- Notifiche / Notifications → **NOTIF**
- Messaggi / Messages → **MSG**
- Impostazioni / Settings → **SETTINGS**
- Report / Analytics → **REPORT**
- API → **API**

**Se area non in lista**: Crea acronimo 3-6 lettere descrittivo e chiedi conferma.

---

## Ruoli Standard

### Normalizzazione Nomi

**Mappa termini comuni a ruoli standard**:

| Brief menciona | Normalizza a |
|----------------|--------------|
| Utente, Utente finale, End user | **User** |
| Amministratore, Admin, Administrator | **Admin** |
| Ospite, Visitatore, Guest, Anonymous | **Guest** |
| Super Admin, Super amministratore | **SuperAdmin** |
| Moderatore, Moderator | **Moderator** |
| Cliente, Customer | **Customer** |
| Venditore, Seller, Vendor | **Seller** |

### Permessi Default per Ruolo

**Guest**:
- Visualizzazione contenuti pubblici
- Registrazione/Login
- NO accesso a funzionalità protette

**User**:
- Tutte operazioni su propri dati (CRUD)
- Visualizzazione contenuti pubblici e propri
- Interazione con altri utenti (se previsto)

**Admin**:
- Tutte operazioni User
- Visualizzazione e gestione dati altri utenti
- Configurazione sistema

**SuperAdmin**:
- Tutte operazioni Admin
- Gestione altri Admin
- Configurazione avanzata e sicurezza

---

## Gestione Edge Cases

### Strategia Default

**Validazioni Input** → Acceptance Criteria nella story principale
- Esempio: Email formato invalido, password troppo corta

**Gestione Errori Semplici** → Acceptance Criteria
- Esempio: Credenziali errate, file non trovato

**Gestione Errori Complessi** → Sub-story (.1, .2)
- Esempio: Rate limiting con algoritmi, retry automatico, fallback

**Varianti Flusso** → Sub-story
- Esempio: Registrazione con email vs OAuth, pagamento carta vs paypal

**Alternative Complete** → Story separata
- Esempio: Dashboard User vs Dashboard Admin (layout diverso)

### Quando Chiedere

**Chiedi sempre** se:
- Edge cases > 30% del totale stories principali
- Ambiguità se edge case è critico o nice-to-have
- Brief menziona esplicitamente gestione errori dettagliata

---

## Output Multi-File

### Soglie Decision

**Single File** quando:
- Totale stories < 50
- Unica applicazione/frontend
- Brief non menziona modularità

**Multi-File** quando:
- Totale stories ≥ 50
- Più applicazioni/frontend (web + admin + mobile)
- Brief ha sezioni chiaramente separate

### Struttura Multi-File Default

**Per applicazioni separate**:
```
user-stories-[progetto]-overview.md
user-stories-web-app.md
user-stories-admin-panel.md
user-stories-mobile-app.md
```

**Per aree funzionali (se >50 stories, unica app)**:
```
user-stories-[progetto]-overview.md
user-stories-authentication.md
user-stories-core-features.md
user-stories-admin-management.md
```

---

## Acceptance Criteria

### Numero Default per Story

**Epic**: 1-2 acceptance criteria (alto livello)
**Feature**: 3-5 acceptance criteria (bilanciate)
**Task**: 2-3 acceptance criteria (specifiche)

### Componenti Standard

**Per ogni story include**:
1. **Happy path** (almeno 1 criterio)
2. **Validazione critica** (se input utente)
3. **Comportamento errore** (se fallimento possibile)
4. **Side effect** (notifiche, log, audit trail se rilevante)

### Esempio Template

```
- Quando [azione valida], allora [risultato positivo]
- Quando [azione invalida], allora [errore specifico]
- E [validazione aggiuntiva rilevante]
```

---

## Relazioni e Dipendenze

### Dipendenze Automatiche

**Sempre vere** (applica automaticamente):
- Qualsiasi funzionalità protetta REQUIRES login (US-AUTH-00X)
- Modifica entità REQUIRES visualizzazione entità
- Eliminazione REQUIRES visualizzazione o modifica
- Operazioni multi-step: Step N REQUIRES Step N-1

### Notazione Default

**REQUIRES**: Prerequisito obbligatorio (deve essere implementato prima)
**EXTENDS**: Variante o estensione (funzionalità base esiste già)
**ALTERNATIVE TO**: Opzione mutualmente esclusiva

### Quando Documentare

**Sempre documenta** se:
- Dipendenza cross-area (AUTH → PAYMENT)
- Catena lunga (A → B → C)
- Dipendenze multiple (A REQUIRES B, C, D)

**Opzionale** se:
- Dipendenza ovvia (modifica richiede visualizzazione)
- Dipendenza all'interno stessa area e sequenziale

---

## Glossario

### Quando Includere

**Include glossario** se:
- Brief contiene > 5 termini di dominio specifici
- Termini tecnici non standard
- Acronimi custom del progetto
- Ambiguità possibili per stakeholder esterni

**NON includere** se:
- Termini comuni (User, Admin, Login, Dashboard)
- Brief già ha glossario incorporato
- Target audience tecnico che conosce il dominio

---

## Lingua

### Detection Automatica

**Analizza brief per identificare lingua**:
- Keyword italiane: "utente", "obiettivi", "funzionalità" → Italiano
- Keyword inglesi: "user", "goals", "features" → English

**Se mix di lingue**: Usa lingua prevalente (>70% testo)

**Se file path indica lingua**: `brief-structured.md` vs `brief-structured-en.md`

### Consistency

**Una volta identificata lingua, usa SOLO quella** per:
- Titoli stories
- Descrizioni
- Acceptance criteria
- Nomi aree e ruoli (eccetto acronimi standard)
- Note e glossario

---

## Stima Effort (Opzionale)

### Complessità Story

**Quick Win**:
- Must Have
- No dependencies
- CRUD semplice
- Esempio: US-PROFILE-001 (visualizza profilo)

**Medium Effort**:
- Should Have, o Must Have con 1-2 dipendenze
- Logica business moderata
- Esempio: US-PAYMENT-002 (processo pagamento)

**Complex**:
- Multiple dependencies (3+)
- Integrations esterne
- Edge cases multipli
- Esempio: US-NOTIF-005 (sistema notifiche real-time)

**Includi stima** se:
- Brief menziona planning/sprint
- Livello Task (dettaglio necessario)
- Utente chiede esplicitamente

---

## Versioning e Metadata

### Informazioni Progetto Default

**Versione**: 1.0 (prima generazione)

**Data**: Data corrente di generazione

**Livello dettaglio**: Come scelto in Fase 2

**Applicazioni**: Come identificate in Fase 1

### Footer Default

```
*Documento generato da User Stories Generator*
*Ultima modifica: [Data]*
```

---

## Best Practices Scrittura User Stories

### Regole SMART

Ogni story deve essere:
- **Specific**: Azione chiara e non ambigua
- **Measurable**: Acceptance criteria verificabili
- **Achievable**: Implementabile in modo realistico
- **Relevant**: Valore chiaro per l'utente
- **Time-bound**: Scope definito (non "gestire tutto")

### Cosa Evitare

- ❌ Stories troppo generiche ("Come User, usare il sistema")
- ❌ Dettagli implementativi ("Come User, chiamare API REST")
- ❌ Duplicazioni (se vale per più ruoli, indicarli in una story)
- ❌ Dipendenze circolari (US-A REQUIRES US-B, US-B REQUIRES US-A)

### Cosa Fare

- ✅ Focus su valore utente, non su tecnologia
- ✅ Acceptance criteria verificabili e chiari
- ✅ Stories indipendenti quando possibile
- ✅ Indicare tutti ruoli se funzionalità identica (User/Admin)
- ✅ Sub-stories per varianti dello stesso flusso
- ✅ Documentare dipendenze esplicitamente

### Esempi Buoni vs Cattivi

**Buoni**:
- ✅ "Come User, voglio registrarmi con email per creare un account e accedere"
- ✅ "Come Admin, voglio visualizzare lista utenti per gestire gli accessi"

**Cattivi**:
- ❌ "Come User, voglio usare il sistema" (troppo generico)
- ❌ "Implementare login" (nessun ruolo o beneficio)
- ❌ "Come Developer, voglio chiamare API REST" (prospettiva tecnica)

---

## Note Finali

Questi default sono **pragmatici e basati su best practices**. SEMPRE:
1. Chiedi conferma quando ambiguo
2. Preferisci input utente a default
3. Documenta assunzioni fatte se non esplicite nel brief
4. Adatta default al contesto specifico del progetto
