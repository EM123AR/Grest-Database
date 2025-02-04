#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include "dependencies/include/libpq-fe.h"

//LINUX     --> gcc query_grest.c -o query -I /usr/include/postgresql -lpq
//WINDOWS   --> gcc -I dependencies\include -L dependencies\lib query_grest.c -o query.exe -lpq

char* scegliQuery(PGconn* connessione);
void listaQuery();
void controllaRisultatoErrori(PGresult *risultato, const PGconn *connessione);
void stampaVideoRisultato(PGresult *risultato);
PGresult* esegui(PGconn *connessione, char* queryScelta);

int main(int argc, char **argv){

    //Inserimento dei parametri per connettersi al database: nome utente e password
    printf("Inserire Utente: \n");
    char utente[20];
    scanf("%s", utente);

    printf("Inserire Password: \n");
    char password[20];
    scanf("%s", password);

    //Creo la stringa (o array di caratteri) contenente i parametri di connessione
    char informazioniConnessione[250];
    sprintf(informazioniConnessione, "user=%s password=%s dbname=%s host=%s port=%s", utente, password, "ProgettoArtusiBolzon","postgresql","5432");

    //Connessione al database tramite libreria PGConn
    PGconn* connessione = PQconnectdb(informazioniConnessione);

    //Controllo se la connessione è andata a buon fine
    if (PQstatus(connessione) == CONNECTION_OK)
    {
        //Restituisco a video una stringa indicandomi che la connessione è andata a buon fine.
        printf("\nConnessione avvenuta con successo.\n");
        //Menu per scelta query da stampare a video
        while(true){
            char* queryScelta = scegliQuery(connessione);
            PGresult* risultato = esegui(connessione, queryScelta);
            controllaRisultatoErrori(risultato, connessione);
            stampaVideoRisultato(risultato);
        }

    } else {
        //Stampo messaggio poichè la connessione non è andata a buon fine.
        printf("Errore di connessione! Non è possibile connettersi al DataBase.\n");
    }

    //Termino la connessione
    PQfinish(connessione);
    return 0;
}

//Metodo per il MENU di scelta Query
char* scegliQuery(PGconn* connessione){
    int n = -2;
    while (n != -1)
    {
        //Stampa a video delle opzioni
        printf("\n=================================================\nSi digiti:\n -1) Chiudere programma. \n  0) Visualizzare lista query. \n  1) Query 1. \n  2) Query 2. \n  3) Query 3. \n  4) Query 4. \n  5) Query 5.\n  6) Query 6.\n=================================================\nSelezione: ");
        scanf("%d", &n);

        if (n == -1)
        {
            //Termina connessione e chiudi programma.
            PQfinish(connessione);
            exit(1);
        }
        else if (n == 0)
        {   
            //Pulisce la console
            printf("\e[1;1H\e[2J");
            //Stampare lista query
            listaQuery();
        }

        //Esecuzione delle varie Query (numero compreso tra 1 e 6)
        else if (n == 1)
        {
            //Pulisce la console
            printf("\e[1;1H\e[2J");
            //Stampo cosa proietta la query.
            printf("\n-- QUERY 1 --\nSi restituiscano i codici fiscali dei partecipanti iscritti meno di quattro settimane al centro estivo MA che partecipano ad almeno un’uscita.\n\n");
            return "SELECT associato.cfpartecipante AS \"Codice Fiscale\" FROM associato WHERE quantesettimane != '1234' AND EXISTS(SELECT * FROM partecipa WHERE partecipa.cfpartecipante = associato.cfpartecipante)";
        }
        else if (n == 2)
        {
            //Pulisce la console
            printf("\e[1;1H\e[2J");
            //Stampo cosa proietta la query.
            printf("\n-- QUERY 2 --\nSi restituisca la classifica finale dell’edizione x (dove x verrà chiesta in input dal programma) del Centro Estivo (dalla squadra che ha ottenuto più punti a quella che ne ha ottenuti meno) avendo come output anche il numero di partite vinte.\n\n");

            //Parte in cui si chiede input parametri all'utente
            int x = -1;
            printf("Inserisci i parametri richiesti (dopo aver scritto, si prema invio):\n");
            printf("\t(numero edizione)(int) x = ");
            scanf("%d", &x);
            printf("=================================================\n\n");
            
            //Preparazione query con input dell'utente all'interno. Essendo la query un char*, per aggiungerci alcuni valori devo allocare della memoria a tale scopo altrimenti otterrei dei core dumped
            char* query = "DROP VIEW IF EXISTS numerovittorie; CREATE VIEW numerovittorie AS SELECT partita.squadravincitrice AS squadravin, COUNT(partita.squadravincitrice) AS \"Partite Vinte\" FROM partita WHERE partita.edizionesquadravincitrice = %d GROUP BY partita.squadravincitrice; SELECT squadra.nome AS \"Nome Squadra\", squadra.punteggio AS \"Punteggio\", \"Partite Vinte\" FROM squadra INNER JOIN numerovittorie ON squadra.nome = squadravin ORDER BY squadra.punteggio DESC";
            int lunghezza = snprintf(NULL, 0, query, x);
            char* risultato = (char*)malloc(lunghezza+1);
            //Se il risultato di allocazione è ERRORE, lo segnalo.
            if (risultato == NULL) {
                fprintf(stderr, "Errore di allocazione della memoria\n");
                exit(1);
            }
            // Costruisce la stringa con la query finale
            snprintf(risultato, lunghezza + 1, query, x);
            return risultato;
        }
        else if (n == 3)
        {
            //Pulisce la console
            printf("\e[1;1H\e[2J");
            //Stampo cosa proietta la query.
            printf("\n-- QUERY 3 --\nPer ogni laboratorio che ha x o più partecipanti nella settimana y dell’edizione z (dove x, y e z verranno chieste in input dal programma) si mostrino nome, cognome e indirizzo degli animatori che vi collaborano.\n\n");
            
            //Parte in cui si chiede input parametri all'utente
            int x = -1, y = -1, z = -1;
            printf("Inserisci i parametri richiesti (dopo aver scritto, si prema invio):\n");
            printf("\t(partecipanti laboratorio)(int) x = ");
            scanf("%d", &x);
            printf("\t(settimana)(int) y = ");
            scanf("%d", &y);
            printf("\t(edizione)(int) z = ");
            scanf("%d", &z);
            printf("=================================================\n\n");

            //Preparazione query con input dell'utente all'interno.
            char* query = "DROP VIEW IF EXISTS listaanimatori; DROP VIEW IF EXISTS listalaboratori; CREATE VIEW listalaboratori AS SELECT segue.nomelaboratorio AS nomelab, segue.numeroedizione AS ed FROM segue WHERE segue.numeroedizione = %d AND segue.settimana = %d GROUP BY segue.nomeLaboratorio, segue.numeroedizione HAVING COUNT(segue.cfpartecipante) >= %d;CREATE VIEW listaanimatori AS SELECT collabora.cfanimatore AS cf FROM collabora INNER JOIN listalaboratori ON collabora.nomelaboratorio = nomelab AND collabora.numeroedizione = ed;SELECT animatore.nome, animatore.cognome, indirizzo.via, indirizzo.civico, indirizzo.comune, indirizzo.cap, indirizzo.provincia FROM (animatore INNER JOIN indirizzo on animatore.idindirizzo = indirizzo.id) INNER JOIN listaanimatori ON animatore.codicefiscale = cf";
            int lunghezza = snprintf(NULL, 0, query, z,y,x);
            char* risultato = (char*)malloc(lunghezza+1);
            //Se il risultato di allocazione è ERRORE, lo segnalo.
            if (risultato == NULL) {
                fprintf(stderr, "Errore di allocazione della memoria\n");
                exit(1);
            }
            // Costruisce la stringa con la query finale
            snprintf(risultato, lunghezza + 1, query, z,y,x);
            return risultato;
        }
        else if (n == 4)
        {
            //Pulisce la console
            printf("\e[1;1H\e[2J");
            //Stampo cosa proietta la query.
            printf("\n-- QUERY 4 --\nSi mostri il codice dell’ordine meno costoso per ciascuna edizione fatto da un animatore che è oppure è stato responsabile di qualche équipe (null se nessun animatore responsabile ha effettuato ordini nell’edizione).\n\n");
            return "drop view if exists ordinievento; drop view if exists ordiniresponsabile; create view ordiniresponsabile as select ordine.cfanimatore, ordine.data, ordine.codice, ordine.costo from ordine inner join afferisce on ordine.cfanimatore = afferisce.cfanimatore where afferisce.isresponsabile = true; create view ordinievento as select evento.edizione, ordiniresponsabile.codice as \"Codice Ordine\", ordiniresponsabile.costo from evento left outer join Ordiniresponsabile on evento.datainizio <= ordiniresponsabile.data and evento.datafine >= ordiniresponsabile.data; select distinct ordinievento.edizione as \"Edizione\", ordinievento.\"Codice Ordine\" from ordinievento, (select ordinievento.edizione as ed, min(ordinievento.costo) as minimo from ordinievento group by ordinievento.edizione) as ordiniminimi where ordinievento.edizione = ed and ordinievento.costo = minimo or ordinievento.costo is null;";
        }
        else if (n == 5)
        {
            //Pulisce la console
            printf("\e[1;1H\e[2J");
            //Stampo cosa proietta la query.
            printf("\n-- QUERY 5 --\nSi mostri il numero di partecipanti ad ogni squadra e ad ogni laboratorio per edizione.\n\n");
            return "SELECT squadra.nome AS \"Nome\", 'Squ.' AS \"Tipo\", squadra.numeroedizione AS \"Numero Edizione\", COUNT(associato.cfpartecipante) AS \"Numero Iscritti\" FROM squadra INNER JOIN associato ON squadra.nome = associato.nomesquadra AND squadra.numeroedizione = associato.numeroedizione GROUP BY squadra.numeroedizione, squadra.nome UNION SELECT laboratorio.nome AS \"Nome\", 'Lab.' AS \"Tipo\", laboratorio.numeroedizione AS \"Numero Edizione\", COUNT(segue.cfpartecipante) AS \"Numero Iscritti\" FROM laboratorio INNER JOIN segue ON laboratorio.nome = segue.nomelaboratorio AND laboratorio.numeroedizione = segue.numeroedizione GROUP BY laboratorio.numeroedizione, laboratorio.nome ORDER BY \"Numero Edizione\", \"Tipo\", \"Nome\"";
        }
        else if (n==6)
        {
            //Pulisce la console
            printf("\e[1;1H\e[2J");
            //Stampo cosa proietta la query.
            printf("\n-- QUERY 6 --\nSi mostrino i campi ordinati in base alla media dei punteggi ottenibili dai giochi organizzati in quel campo (dalla più alta alla più bassa).\n\n");
            return "SELECT campo.numero AS \"Numero\", AVG(gioco.punteggio) AS \"Media Punti\" FROM campo INNER JOIN GIOCO ON campo.numero = gioco.numerocampo GROUP BY campo.numero ORDER BY \"Media Punti\" DESC;";
        }

        //Se valore non compreso tra 1 e 6 (query possibili) --> rigenera output menu con scelte disponbili
        //Stampo stringa per pulire la console
        else {
            printf("\e[1;1H\e[2J");
        }
    }
}

//Metodo per stampare a video il menu con la lista di tutte le query.
void listaQuery(){
    printf("\n-- QUESTE LE POSSIBILI QUERY PRESENTI NEL PROGRAMMA --\n");
    printf("1) Si restituiscano i codici fiscali dei partecipanti iscritti meno di quattro settimane al centro estivo MA che partecipano ad almeno un’uscita.\n\n");
    printf("2) Si restituisca la classifica finale dell’edizione x (dove x verrà chiesta in input dal programma) del Centro Estivo (dalla squadra che ha ottenuto più punti a quella che ne ha ottenuti meno) avendo come output anche il numero di partite vinte.\n\n");
    printf("3) Per ogni laboratorio che ha x o più partecipanti nella settimana y dell’edizione z (dove x, y e z verranno chieste in input dal programma) si mostrino nome, cognome e indirizzo degli animatori che vi collaborano.\n\n");
    printf("4) Si mostri il codice dell’ordine meno costoso per ciascuna edizione fatto da un animatore che è oppure è stato responsabile di qualche équipe (null se nessun animatore responsabile ha effettuato ordini nell’edizione).\n\n");
    printf("5) Si mostri il numero di partecipanti ad ogni squadra e ad ogni laboratorio per edizione.\n\n");
    printf("6) Si mostrino i campi ordinati in base alla media dei punteggi ottenibili dai giochi organizzati in quel campo (dalla più alta alla più bassa)\n\n");
}

//Esegue la Query nella sua interezza
PGresult* esegui(PGconn *connessione, char* queryScelta){
    return PQexec(connessione, queryScelta);
}

//Metodo per controllare eventuali errori
void controllaRisultatoErrori(PGresult *risultato, const PGconn *connessione){
    //Se il risultato della query non è OK
    if (PQresultStatus(risultato)!= PGRES_TUPLES_OK) {
        //Stampo il messaggio di errore
        printf("Errore nella query: %s\n", PQerrorMessage(connessione));
        PQclear(risultato);
        exit(1);
    }
}

void stampaVideoRisultato(PGresult *risultato){
    int numeroCampiColonne = PQnfields(risultato);
    int numeroTuple = PQntuples(risultato);

    // Stampa l'intestazione della tabella
    for (int i = 0; i < numeroCampiColonne; i++) {
        printf("%-20s", PQfname(risultato, i));
        if (i < numeroCampiColonne - 1) {
            printf("| ");
        }
    }
    printf("\n");

    // Stampa una linea di separazione
    for (int i = 0; i < numeroCampiColonne; i++) {
        for (int j = 0; j < 19; j++) {
            printf("-");
        }
        if (i < numeroCampiColonne - 1) {
            printf("-+-");
        }
    }
    printf("\n");

    // Stampa le righe della tabella
    for (int i = 0; i < numeroTuple; i++) {
        for (int j = 0; j < numeroCampiColonne; j++) {
            printf("%-20s", PQgetvalue(risultato, i, j));
            if (j < numeroCampiColonne - 1) {
                printf("| ");
            }
        }
        printf("\n");
    }

    //Pulisci il PGResult
    PQclear(risultato);
}
