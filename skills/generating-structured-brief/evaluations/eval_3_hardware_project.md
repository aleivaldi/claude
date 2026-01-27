# Evaluation 3: Hardware/IoT Project

## Test Scenario

**Tipo**: Progetto hardware/IoT che richiede domande specifiche hardware + software
**Expected Behavior**: Fase 1 rileva natura hardware, pone domande mirate, Fase 2 genera brief con sezioni hardware-specific

---

## Input: brief.md

```markdown
# Smart Temperature Monitor

Vogliamo creare un dispositivo per monitorare temperatura e umidità in magazzini.

Il dispositivo deve inviare dati a un sistema centrale.

Quando temperatura supera soglia, deve inviare alert.

Serve per 10 magazzini inizialmente, poi espandere.
```

---

## Expected Behavior

### Fase 1: Analisi

Claude dovrebbe:
1. **Rilevare parola chiave "dispositivo"** → progetto hardware
2. **Identificare componenti**:
   - Hardware: dispositivo fisico + sensori
   - Software: sistema centrale + alert
   - Connettività: comunicazione dispositivo-cloud
3. **Generare 4-6 domande hardware + software**:
   - **Hardware**: Tipo sensori, alimentazione, connettività, fattore forma, volume unità
   - **Software**: Dashboard web, alert (email/SMS), visualizzazione dati
   - **Vincoli**: Costo per unità, certificazioni, ambiente operativo

### Fase 2: Creazione

Dopo risposte dell'utente, Claude dovrebbe:
1. **Creare brief-structured.md** con:
   - Problema (temperatura non monitorata causa perdite)
   - Utenti primari (operatori magazzino, manager)
   - **Vincoli Hardware** (se menzionati):
     - Costo target per unità
     - Ambiente operativo (temperatura, umidità)
     - Certificazioni necessarie
   - **Funzionalità Primarie** (mix hardware + software):
     - Dispositivo: Misura temperatura/umidità ogni X minuti
     - Sistema: Dashboard visualizza dati real-time
     - Alert: Notifica quando soglia superata
   - **Assunzioni hardware** (dalla sezione defaults.md Hardware):
     - Componenti off-shelf
     - WiFi connectivity
     - USB charging
     - 50-200 unità MVP
   - **Scope MVP** chiaro su v1 vs future (es. batteria ottimizzata in v2)
2. **Output in chat** con scelte tecniche hardware da defaults.md

---

## Success Criteria

- [ ] Fase 1 rileva progetto hardware e genera domande appropriate
- [ ] Domande coprono 3 aree: hardware, software, vincoli
- [ ] brief-structured.md include vincoli hardware (costo, ambiente, certificazioni)
- [ ] Funzionalità primarie distinguono componente hardware vs software
- [ ] Sezione Assunzioni include assunzioni hardware specifiche con rationale
- [ ] Scope MVP realistico per hardware (es. 50-200 unità, no certificazioni v1)
- [ ] Output chat comunica scelte tecniche hardware (da defaults.md: off-shelf, WiFi, USB)
- [ ] Non propone scelte hardware complesse per MVP (custom PCB, cellular, etc.)

---

## Hardware-Specific Checks

- [ ] **Connettività**: WiFi proposto come default (da defaults.md), cellular/LoRa solo se necessario
- [ ] **Alimentazione**: USB charging proposto (da defaults.md), non batteria ottimizzata v1
- [ ] **Componenti**: Off-shelf proposto (da defaults.md), non custom PCB per MVP
- [ ] **Volume**: 50-200 unità proposto per MVP (da defaults.md)
- [ ] **Certificazioni**: Rinviate a post-MVP se non critiche (da defaults.md)
- [ ] **Backend**: Cloud proposto (da defaults.md), non edge-only

---

## Common Pitfalls to Avoid

- ❌ Ignorare natura hardware del progetto
- ❌ Proporre soluzioni hardware complesse per MVP (custom PCB, cellular, batterie)
- ❌ Non usare defaults.md Hardware section
- ❌ Certificazioni incluse in MVP quando evitabili
- ❌ Volume produzione irrealistico (1000+ per MVP)
- ❌ Mancanza distinzione hardware vs software in funzionalità

---

## Edge Cases to Handle

- **Ambiente estremo**: Se magazzino a -20°C, sensori standard non funzionano → domanda specifica
- **Certificazioni critiche**: Se medical/safety-critical → non può essere rinviato
- **Volume alto richiesto**: Se mercato richiede 1000+ da subito → discutere con utente
- **Connettività limitata**: Se no WiFi disponibile → cellular o LoRa necessario

---

## Evaluation Result

**Status**: [ ] Pass / [ ] Fail

**Notes**:
-
-
-

**Issues Found**:
-
-

**Suggested Improvements**:
-
-
