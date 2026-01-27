# Business Plan Generation Workflow (7 Steps)

## A. Analizza Input Esistenti
1. Raccogli tutti i documenti disponibili:
   - Brief strutturato o raw
   - Requirements document
   - Competitor analysis
   - Quotazioni tecniche (es. POC, sviluppo)
   - Altri documenti finanziari
2. Estrai dati rilevanti per il business plan:
   - Costi di sviluppo (R&D, PoC, MVP)
   - Prezzi di vendita previsti
   - Target market size
   - Canali di distribuzione
   - Team previsto
3. **Output step**: Lista dati estratti con fonte per ogni dato

## B. Identifica Gap e Genera Ipotesi
1. Confronta dati estratti con input richiesti (vedi `reference/input-requirements.md`)
2. Per ogni dato mancante:
   - **Se estrapolabile**: Genera ipotesi basata su:
     - Informazioni dai documenti (es. se c'è quotazione PoC €50k, ipotizza Capex iniziale)
     - Best practices di settore (es. LTV/CAC 3-5x per SaaS)
     - Benchmark competitor (se disponibile competitor analysis)
   - **Se non estrapolabile**: Segna come "da chiedere all'utente"
3. **Output step**: Tabella con:
   - Dato richiesto | Valore proposto | Fonte/Giustificazione | Confidence (Alta/Media/Bassa)

## C. Chiedi Conferma e Integrazioni (interattivo)
1. Presenta tabella generata allo step B
2. Per dati con confidence Alta/Media: "Ho ipotizzato X basandomi su Y. Confermi o vuoi modificare?"
3. Per dati "da chiedere": Poni domanda specifica con:
   - Contesto (perché serve il dato)
   - Range sensato (se applicabile)
   - Esempio pratico
4. **Validazione intelligente**:
   - Se risposta utente sembra incongrua (es. COGS > Prezzo vendita), evidenzialo:
     - "⚠️ Il COGS di €X supera il prezzo di vendita €Y, con margine negativo del Z%. Confermi o vuoi rivedere?"
     - Suggerisci valore alternativo sensato
     - Chiedi conferma esplicita per procedere
5. **Loop**: Ripeti fino a conferma completa dataset

## D. Genera JSON Strutturato
1. Organizza tutti i dati validati in formato JSON (vedi `json-format-reference.md`)
2. Calcola valori derivati (es. monthly inflation da annual)
3. **Write**: Salva in `/tmp/bp_data.json`
4. **Output step**: Conferma "Dataset validato e strutturato"

## E. Genera Excel con Script Python
1. **Bash**: Copia template Excel da skill folder
   ```bash
   cp ~/.claude/skills/generating-business-plan/template/business-plan-template.xlsx business-plan.xlsx
   ```
2. **Bash**: Esegui script Python
   ```bash
   python3 ~/.claude/skills/generating-business-plan/scripts/populate_excel.py business-plan.xlsx /tmp/bp_data.json
   ```
3. **Bash**: Ricalcola formule con LibreOffice
   ```bash
   python3 ~/.claude/skills/generating-business-plan/scripts/recalc.py business-plan.xlsx
   ```
4. **Bash**: Rimuovi JSON temporaneo
   ```bash
   rm /tmp/bp_data.json
   ```
5. **Output step**: "Business plan Excel generato in business-plan.xlsx"

## F. Verifica Excel (loop)
1. Annuncia completamento con path assoluto file
2. Chiedi all'utente di aprire e verificare
3. Se modifiche richieste:
   - Ascolta feedback
   - Aggiorna JSON e rigenera (Step D-E)
   - Loop
4. Quando approvato → procedi a Step G

## G. Genera Markdown Esplicativo
1. **Write**: Crea `business-plan.md` con:
   - **Executive Summary**: Sintesi risultati finanziari chiave (3-5 anni)
   - **Assunzioni Chiave**: Tutte le ipotesi principali con giustificazione
   - **Analisi Finanziaria**:
     - Revenue model e crescita
     - Cost structure e break-even
     - Cash flow e fabbisogno finanziario
     - Key metrics (Gross Margin, EBITDA, Burn Rate, Runway)
   - **Scenari e Sensitivity**: Cosa succede se variabili chiave cambiano
   - **Note e Caveat**: Limitazioni del modello, aree di incertezza
2. **Output step**: Annuncia path assoluto Markdown

## H. Verifica Markdown (loop)
1. Chiedi review del documento Markdown
2. Se modifiche richieste:
   - **Read** `business-plan.md` PRIMA di Edit
   - **Edit** con modifiche specifiche
   - Loop
3. Quando approvato → skill completata
