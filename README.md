<h1 align="center">Basi di dati Grest</h1>
<p align="center">Progetto per il corso di Basi di Dati (BSc Informatica, A.A. 2023/24) dell'Università di Padova.</p>



# Membri del gruppo
- Artusi Emanuele
- Bolzon Nicolò

# Specifiche di progetto
## Il progetto
La Base di dati riguarderà una organizzazione a scelta dello studente. 
- Analisi dei requisiti
- Progettazione
  - Progettazione concettuale
  - Progettazione logica:
    sforzatevi a pensare ad uno schema che necessiti di molte delle seguenti operazioni (sarete valutati anche su questo!).\
    Giustificare ogni operazione:
     - Analisi delle ridondanze (almeno una significativa)
     - Eliminazione delle generalizzazioni
     - Partizionamento/accorpamento di entità e relazioni
     - Scelta degli identificatori primari
     - Diagramma schema ristrutturato- Schema relazionale
     - Descrizione Schema relazionale
     - Eventuali vincoli di integrità referenziale
  - Progettazione fisica (indici)
- Realizzazione
  - (PostgreSQL and software in C)

## Schema logico
Riportare su file SQL separato l’implementazione della base di dati
- Nel file SQL deve essere presente tutto il codice per:
  - Creazione tabelle
  - Popolamento
  - Query e Indici
- Consegnare il file SQL insieme alla relazione
  - Per la parte dello schema, occorre scrivere “a mano” le istruzioni CREATE TABLE
  - Per la parte relativa ai dati, si può fare il Dump via pgAdmin

## Query e indici
Il Progetto deve includere:
- Almeno 5 query significative per rispondere a domande interessanti sulla base di dati
 - Una query è significativa se coinvolge almeno due “relations” (cioè tabelle)
 - Almeno3 query devono utilizzare il “group by” e/o gli operatori aggregati
 - Almeno1 query deve utilizzare il “group by” e “having”
- Almeno un indice significativo: scegliere una delle query e creare un indice significativo, motivando la scelta.\
Per ogni query si deve produrre:
- Descrizione testuale
- Codice SQL
- Screenshots dell’output delle query relativo a uno stato della base di dati anche non corrispondente a quello nel momento della consegna
- Codice C cheesegue e stampa a video le query

## Relazione


# Valutazione
Gli elementi che verranno presi in considerazione ai fini della valutazione finale saranno:
- Correttezza dei risultati
- Complessità del problema affrontato
- Appropriatezza della metodologia seguita
- Chiarezza espositiva
