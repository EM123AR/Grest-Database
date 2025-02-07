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
- Almeno un indice significativo: scegliere una delle query e creare un indice significativo, motivando la scelta.

Per ogni query si deve produrre:
- Descrizione testuale
- Codice SQL
- Screenshots dell’output delle query relativo a uno stato della base di dati anche non corrispondente a quello nel momento della consegna
- Codice C cheesegue e stampa a video le query\

 Introdurre almeno un indice:
 . Selezionare almeno una delle query definite
 - Definire un indice significativo per tale query, motivando la scelta.
 - Implementare l’indice (inserire codice anche all’interno della relazione)

## Vincoli
 Per essere accettabile un progetto deve possedere i seguenti requisiti minimi.
 - Il diagramma E-R del progetto deve contenere un numero adeguato di entità (≥ 5) escluse quelle coinvolte da una gerarchia (conta solo l’entità padre)
 - Almeno una gerarchia significativa
 - Un esempio di relazione per ogni tipo di cardinalità (1:N, 1:1, N:M)

## Criteri di valutazione
Gli elementi che verranno presi in considerazione ai fini della valutazione finale saranno:
- Correttezza dei risultati
- Complessità del problema affrontato
- Appropriatezza della metodologia seguita
- Chiarezza espositiva

# Valutazione
25,00/30,00

<table  >
   <tbody >
      <tr  >
         <td   tabindex="0" aria-label="Criterio Descrizione testuale dei requisiti e operazioni tipiche + Qualità della relazione">Descrizione testuale dei requisiti e operazioni tipiche + Qualità della relazione</td>
         <td >
            <table  role="none">
               <tbody>
                  <tr  aria-label="Gruppo di livelli" role="radiogroup">
                     <td   style="width: 14%;" tabindex="0" aria-label="Livello Nessuna imperfezione, punti 3." role="radio" aria-checked="true">
                        <div>
                           <div >Nessuna imperfezione</div>
                           <div ><span  >3 su 3</span> punti</div>
                        </div>
                     </td>
                  </tr>
               </tbody>
            </table>
         </td>
         <td  tabindex="0"  aria-label="Commento del criterio Descrizione testuale dei requisiti e operazioni tipiche + Qualità della relazione: "></td>
      </tr>
      <tr  >
         <td   tabindex="0" aria-label="Criterio Progettazione Concettuale">Progettazione Concettuale</td>
         <td >
            <table  role="none">
               <tbody>
                  <tr  aria-label="Gruppo di livelli" role="radiogroup">
                     <td   style="width: 13%;" tabindex="0" aria-label="Livello Nessun errore, punti 7.5." role="radio" aria-checked="true">
                        <div >
                           <div  >Nessun errore</div>
                           <div ><span  >7.5 su 7.5</span> punti</div>
                        </div>
                     </td>
                  </tr>
               </tbody>
            </table>
         </td>
         <td  tabindex="0"  aria-label="Commento del criterio Progettazione Concettuale: "></td>
      </tr>
      <tr  >
         <td   tabindex="0" aria-label="Criterio Ristrutturazione dello schema concettuale">Ristrutturazione dello schema concettuale</td>
         <td >
            <table  role="none">
               <tbody>
                  <tr  aria-label="Gruppo di livelli" role="radiogroup">
                     <td   style="width: 33%;" tabindex="0" aria-label="Livello 1 Errore, punti 1." role="radio" aria-checked="true">
                        <div >
                           <div  >1 Errore</div>
                           <div ><span  >1 su 2</span> punti</div>
                        </div>
                     </td>
                  </tr>
               </tbody>
            </table>
         </td>
         <td  tabindex="0"  aria-label="Commento del criterio Ristrutturazione dello schema concettuale: &quot;possiederebbero l’attributo “Indirizzo” che
            diventa poi ridondante&quot;: non vedo il problema e non vedo perché sarebbe ridonante. ">"possiederebbero l’attributo “Indirizzo” che
            diventa poi ridondante": non vedo il problema e non vedo perché sarebbe ridonante. 
         </td>
      </tr>
      <tr  >
         <td   tabindex="0" aria-label="Criterio Schema Relazionale">Schema Relazionale</td>
         <td >
            <table  role="none">
               <tbody>
                  <tr  aria-label="Gruppo di livelli" role="radiogroup">
                     <td   style="width: 20%;" tabindex="0" aria-label="Livello 4+ Errori, punti 0." role="radio" aria-checked="true">
                        <div >
                           <div  >4+ Errori</div>
                           <div ><span  >0 su 4</span> punti</div>
                        </div>
                     </td>
                  </tr>
               </tbody>
            </table>
         </td>
         <td  tabindex="0"  aria-label="Commento del criterio Schema Relazionale: Errore nell'implementazione delle chiavi esterne che implementano le relazioni PARTECIPA e ACCOMPAGNA. Si veda discussione più approfondita per PARTECIPA. Comunque vedo che sono poi implementate bene in SQL, comunque l'errore rimane nello schema relazionale ma viene contato come uno solo + le relazioni COLLABORA, ASSOCIATO, ANIMA sono definite come una molti-a-molti invece di una uno-a-molti + definizione della relazione &quot;Equipe&quot; errata: non c'è il riferimento ad evento. ">Errore nell'implementazione delle chiavi esterne che implementano le relazioni PARTECIPA e ACCOMPAGNA. Si veda discussione più approfondita per PARTECIPA. Comunque vedo che sono poi implementate bene in SQL, comunque l'errore rimane nello schema relazionale ma viene contato come uno solo + le relazioni COLLABORA, ASSOCIATO, ANIMA sono definite come una molti-a-molti invece di una uno-a-molti + definizione della relazione "Equipe" errata: non c'è il riferimento ad evento. </td>
      </tr>
      <tr  >
         <td   tabindex="0" aria-label="Criterio Implementazione in SQL">Implementazione in SQL</td>
         <td >
            <table  role="none">
               <tbody>
                  <tr  aria-label="Gruppo di livelli" role="radiogroup">
                     <td   style="width: 33%;" tabindex="0" aria-label="Livello Nessun Errore, punti 2." role="radio" aria-checked="true">
                        <div >
                           <div  >Nessun Errore</div>
                           <div ><span  >2 su 2</span> punti</div>
                        </div>
                     </td>
                  </tr>
               </tbody>
            </table>
         </td>
         <td  tabindex="0"  aria-label="Commento del criterio Implementazione in SQL: "></td>
      </tr>
      <tr  >
         <td   tabindex="0" aria-label="Criterio Query">Query</td>
         <td >
            <table  role="none">
               <tbody>
                  <tr  aria-label="Gruppo di livelli" role="radiogroup">
                     <td   style="width: 20%;" tabindex="0" aria-label="Livello Nessun Errore, punti 7.5." role="radio" aria-checked="true">
                        <div >
                           <div  >Nessun Errore</div>
                           <div ><span  >7.5 su 7.5</span> punti</div>
                        </div>
                     </td>
                  </tr>
               </tbody>
            </table>
         </td>
         <td  tabindex="0"  aria-label="Commento del criterio Query: "></td>
      </tr>
      <tr  >
         <td   tabindex="0" aria-label="Criterio Indici">Indici</td>
         <td >
            <table  role="none">
               <tbody>
                  <tr  aria-label="Gruppo di livelli" role="radiogroup">
                     <td   style="width: 25%;" tabindex="0" aria-label="Livello Soluzione Buona, punti 2." role="radio" aria-checked="true">
                        <div >
                           <div  >Soluzione Buona</div>
                           <div ><span  >2 su 2</span> punti</div>
                        </div>
                     </td>
                  </tr>
               </tbody>
            </table>
         </td>
         <td  tabindex="0"  aria-label="Commento del criterio Indici: "></td>
      </tr>
      <tr  >
         <td   tabindex="0" aria-label="Criterio Accesso a DB da SQL">Accesso a DB da SQL</td>
         <td >
            <table  role="none">
               <tbody>
                  <tr  aria-label="Gruppo di livelli" role="radiogroup">
                     <td   style="width: 25%;" tabindex="0" aria-label="Livello Codice della giusta complessità, punti 2." role="radio" aria-checked="true">
                        <div >
                           <div  >Codice della giusta complessità</div>
                           <div ><span  >2 su 2</span> punti</div>
                        </div>
                     </td>
                  </tr>
               </tbody>
            </table>
         </td>
         <td  tabindex="0"  aria-label="Commento del criterio Accesso a DB da SQL: "></td>
      </tr>
   </tbody>
</table>
