<h1 align="center">Basi di dati Grest</h1>
<p align="center">Progetto per il corso di Basi di Dati (BSc Informatica, A.A. 2023/24) dell'Università di Padova.</p>



# Membri del gruppo
- Artusi Emanuele
- Bolzon Nicolò

# Specifiche di progetto
## Vincoli
- il sito web deve essere realizzato con lo standard HTML5. Le pagine devono degradare in modo elegante e devono rispettare la sintassi XML;
- il layout deve essere realizzato con CSS puri (CSS2 o CSS3);
- l’uso dei layout Flex e Grid, se sviluppati in maniera corretta ed utilizzati ragionevolmente, vengono valutati molto positivamente;
- il sito web deve rispettare la completa separazione tra contenuto, presentazione e comportamento;
- il sito web deve essere accessibile a tutte le categorie di utenti;
- il sito web deve organizzare i propri contenuti in modo da poter essere facilmente reperiti da qualsiasi utente;
- il sito web deve contenere pagine che utilizzino script PHP per collezionare e pubblicare dati inseriti dagli utenti (deve essere sviluppata anche la possibilità di modifica e cancellazione dei dati stessi);
- tra gli input richiesti all'utente deve esserci almeno un campo di testo libero;
- deve essere presente una forma di controllo dell’input inserito dall’utente, sia lato client che lato server;
- i dati inseriti dagli utenti devono essere salvati in un database;
- è preferibile che il database sia in forma normale.

## Relazione
Il progetto deve essere accompagnato da una relazione che ne illustri le fasi di progettazione, realizzazione e test ed evidenzi il ruolo svolto dai singoli componenti del gruppo.
Viene richiesta un'analisi iniziale delle caratteristiche degli utenti che il sito si propone di raggiungere e le possibili ricerche sui motori di ricerca a cui il sito deve rispondere.  Inoltre si devono indicare le azioni intraprese per migliorare il ranking del sito.
Le pagine web devono essere accessibili indipendentemente dal browser e dalle dimensioni dello schermo del dispositivo degli utenti. Considerazioni riguardanti diversi dispositivi (laddove possibile) verranno valutate positivamente.
Il non rispetto di anche una sola di queste specifiche comporta la non sufficienza del progetto.

# Valutazione


# Info Utili
## Versione Server
- Versione PHP Server Tecweb: 8.2.26
- Versione SQL Server: MariaDB 10.11.6

## Creazione del server in locale con docker
Nella cartella LuzzAuto:  
Per eliminare i volumi associati se avete già un container errato:
```cmd
docker-compose down -v
```
Successivamente creare il container:
```cmd
docker-compose build
```
```cmd
docker-compose up -d
```
