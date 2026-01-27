# Anti-Pattern da Evitare - Generating Requirements

Errori comuni quando si genera requirements.md e come fixarli.

---

## ❌ Anti-Pattern 1: Generare requirements senza leggere brief

**Problema**: Requirements non allineato al brief, mancano informazioni critiche

**Fix**: ✅ SEMPRE **Read tool** su brief-structured.md prima di generare

---

## ❌ Anti-Pattern 2: Usare requisiti Production per PoC

**Problema**: Over-engineering per fase di validazione tecnica

**Fix**: ✅ Adatta requisiti alla fase corrente (vedi sezione "Adattamento Requisiti per Fase" in SKILL.md)

**Esempio Sbagliato**:
```
PoC Requisiti:
- Performance: <500ms P99
- Availability: 99.9% uptime
- Security: Multi-factor auth, encryption at rest
```

**Esempio Corretto**:
```
PoC Requisiti:
- Performance: Non rilevante (PoC valida fattibilità tecnica)
- Availability: Best effort (5 utenti di test)
- Security: Basic auth (test interni)
```

---

## ❌ Anti-Pattern 3: Edit requirements.md senza Read prima

**Problema**: `old_string not found`, modifiche falliscono

**Fix**: ✅ SEMPRE **Read tool** → **Edit tool** → **Read tool** (verify)

**Perché**: Edit tool necessita contenuto esatto in memoria. Senza Read prima, il contenuto potrebbe essere obsoleto o modificato, causando fallimento di Edit.

---

## ❌ Anti-Pattern 4: Procedere senza conferma utente

**Problema**: Requirements non rispecchia esigenze, tempo sprecato in iterazioni

**Fix**: ✅ **AskUserQuestion tool** dopo generazione e dopo ogni modifica

**Quando chiedere conferma**:
- Dopo aver generato requirements.md completo
- Dopo ogni modifica significativa
- Se fase corrente non è chiara da brief
- Se documenti opzionali non trovati ma potrebbero esistere

---

## ❌ Anti-Pattern 5: Ignorare documenti opzionali esistenti

**Problema**: Competitive landscape basic quando competitor-analysis.md esiste e potrebbe arricchire

**Fix**: ✅ **Read tool** per verificare competitor-analysis.md, research/*.md prima di generare

**Documenti da verificare sempre**:
- competitor-analysis.md (arricchisce Competitive Landscape)
- research/*.md (arricchisce sezione PoC, architettura)
- Altri .md files menzionati dall'utente

---

## ❌ Anti-Pattern 6: Write su file esistente

**Problema**: Write sovrascrive completamente il file, perdendo contenuto esistente

**Fix**:
- ✅ **Write tool** solo per file NUOVO
- ✅ **Edit tool** per file ESISTENTE (sempre Read prima)

---

## ❌ Anti-Pattern 7: Requisiti vaghi non adattati alla fase

**Problema**: "Il sistema deve essere performante" (non misurabile, non adattato)

**Fix**: ✅ Requisiti specifici adattati alla fase

**Esempi corretti per MVP**:
- Performance: "Page load <2 sec, API response <500ms"
- Availability: "Business hours (9-6), best effort"
- Scale: "50-100 utenti concorrenti"
- Security: "HTTPS, auth standard, DB encryption"

---

## Riepilogo Best Practices

✅ **SEMPRE** Read prima di Edit
✅ **SEMPRE** adatta requisiti alla fase corrente
✅ **SEMPRE** verifica documenti opzionali esistenti
✅ **SEMPRE** chiedi conferma utente con AskUserQuestion
✅ **SEMPRE** usa requisiti misurabili e specifici
