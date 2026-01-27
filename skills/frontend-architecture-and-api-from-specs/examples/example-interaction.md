# Example Interactions

Esempi di come la skill interagisce con l'utente durante le varie fasi.

---

## Esempio 1: Proposta Sitemap

```
Claude: Ho analizzato le user stories. 
Ci sono alcuni aspetti che non erano coperti. Aggiungo le funzionalità che reputo necessarie e le evidenzio con il simbolo ⚠️
Identifico 3 aree principali:

**Sitemap proposta:**

/ (Public)
├─ Home
├─ Login
└─ Signup

/app (User Area - Authenticated User)
├─ Dashboard
├─ Sezione 1
│  ├─ funzionalità A 
│  ├─ funzionalità B [solo Ruolo Y]
│  ├─ ⚠️ funzionalità C [solo Ruolo Y]
│  └─ funzionalità C [solo Ruolo X]
└─ Account
   └─ Settings


Va bene o preferisci struttura diversa (es: Ruolo A con mappa seprata)?
```

**User risponde:** "Va bene così"

---

## Esempio 2: Proposta Screen con Specifiche Funzionali

```
Claude: Per la gestione utenti (US-001 a US-005), propongo pagina unica "Admin > Users".

### Users (/admin/users)
- Lista utenti con: 
   - Nome (stringa)
   - Email (stringa con formato verificato)
   - Ruolo (elenco a scelta multipla)
   - ⚠️ Stato (Active/Disabled)
   - Data registrazione
   - AZIONI POSSIBILI SU ELEMENTO
      - cancella (Admin only - richiede conferma)
      - ⚠️ abilita /disabilita
      - vedi dettaglio
      - manda mail
      - seleziona
   - AZIONI POSSIBILI SU LISTA
      - infinite scroll
      - filtra (con text per testo che filtra su nome, email e Filter dropdowns per ruolo)
      - cancella selezionati (Admin only - richiede conferma)
- Contatore totale utenti
- numero registrati ieri, oggi, last week, this week, last month, this mont
- INPUT
 - Bottone Aggiungi utente 
```

**User risponde:** "Perfetto, procedi"

---

## Esempio 3: Gap Identificato

```
Claude: Ho completato tutte le schermate dalle user stories. Ho identificato 3 gap critici non menzionati:

1. **Utente senza permessi** tenta accesso risorsa protetta
   → **Proposta:** Screen "403 Forbidden"
   - Scopo: informare utente che non ha permessi


2. **Risorsa non trovata** (URL errato o risorsa cancellata)
   → **Proposta:** Screen "404 Not Found"
   - Scopo: informare che pagina non esiste


3. **Session timeout** durante operazione
   → **Proposta:** Gestione "Session Expired"
   - Scopo: permettere re-login senza perdere contesto


Aggiungo queste 3 schermate/comportamenti standard?
```

**User risponde:** "Sì, aggiungile tutte e tre"

Claude: Bene, li troverai con il simbolo ⚠️


---

## Esempio 4: Iterazione da Commenti nel File

```
Claude: Ho letto il file frontend-specifications.md. Ho trovato 3 commenti e fatto le modifiche richieste. 
1. ✅ Dashboard diviso in Overview + Analytics
2. ✅ Aggiunta azione Export CSV in Admin > Users
3. ✅ Offline mode documentato in "Future Enhancements"
Altre modifiche o il documento è pronto?
```

## Esempio 5: Modifica via Chat

```
User: alla pagina Users aggiungi l'età come campo visibile

Claude: Ho modificato la pagina. 
1. ✅ Users - aggiunta colonna Età
Va bene o hai altro da segnalare?

```

---


### Pattern Gap
**Evidenziare con ⚠️** e proporre requisiti:
```
⚠️ Gap identificato: [scenario]
→ Proposta: [screen/funzionalità necessaria]
   - Scopo: [cosa deve fare]

Aggiungo?
```

### Pattern Iterazione
**Supportare tutti e 3 i modi**:
1. Edit diretto → riconoscere e chiedere conferma applicazione sistematica
2. Commenti inline → identificare, risolvere uno per uno con focus funzionale
3. Chat → read → edit → read to confirm

### Principio Chiave
**Descrivi COSA serve, non COME implementarlo:**
- ✅ "Filtro per genere musicale (tipo: select, opzioni: Pop, Rock, Jazz...)"
- ❌ "Dropdown con styling Material UI, positioned top-right, con animazione fade-in"
