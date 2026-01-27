# Gestione Errori

## Se Read fallisce
- Verifica path corretto
- Controlla se file esiste
- Chiedi utente se location diversa

## Se Write fallisce
- Verifica directory padre esiste
- Controlla permessi
- Proponi location alternativa

## Se Edit fallisce
- Re-read file (potrebbe essere cambiato)
- Verifica old_string sia esatto (whitespace, newlines)
- Se ancora fallisce: segnala e chiedi come procedere

## Se validazione trova problemi critici
- Non procedere con creazione/modifica
- Spiega problemi all'utente
- Proponi soluzioni
- Attendi conferma prima di continuare
