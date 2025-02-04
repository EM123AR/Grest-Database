-- GARANZIA IDEMPOTENZA utile al test, manutenzione ed aggiornamento:
drop index if exists idx_associato_nomesquadra_edizione;
drop index if exists idx_segue_nomelaboratorio_edizione;

drop view if exists numerovittorie;
drop view if exists listaanimatori;
drop view if exists listalaboratori;
drop view if exists ordinievento;
drop view if exists ordiniresponsabile;

drop table if exists Anima;
drop table if exists Associato;
drop table if exists Segue;
drop table if exists Collabora;
drop table if exists Accompagna;
drop table if exists Partecipa;
drop table if exists Partita;
drop table if exists Afferisce;
drop table if exists Gioco;
drop table if exists Campo;
drop table if exists Ordine;
drop table if exists Gadget;
drop table if exists Uscita;
drop table if exists Animatore;
drop table if exists Partecipante;
drop table if exists Adulto;
drop table if exists Indirizzo;
drop table if exists Squadra;
drop table if exists Laboratorio;
drop table if exists Equipe;
drop table if exists Evento;

drop type if exists base;

-- CREAZIONE TABELLE:
create table Evento
(
   Edizione          int          primary key,
   Titolo            varchar(100) not null,
   Descrizione       varchar(50)  not null,
   DataInizio        date         not null,
   DataFine          date         not null,
   CanzonePrincipale varchar(20)  not null,
   check (DataInizio < DataFine and Edizione > 0)
);

create table Equipe
(
   Nome           varchar(20) not null,
   NumeroEdizione int         not null,
   Descrizione    varchar(50) not null,
   primary key (Nome, NumeroEdizione),
   foreign key (NumeroEdizione) references Evento(Edizione) on update cascade on delete set null
);

create table Laboratorio
(
   Nome           varchar(30) not null,
   NumeroEdizione int         not null,
   Descrizione    varchar(50) not null,
   primary key (Nome, NumeroEdizione),
   foreign key (NumeroEdizione) references Evento(Edizione) on update cascade on delete set null
);

create table Squadra
(
   Nome           varchar(30) not null,
   NumeroEdizione int         not null,
   Punteggio      int         not null,
   primary key (Nome, NumeroEdizione),
   foreign key (NumeroEdizione) references Evento(Edizione) on update cascade on delete set null,
   check (Punteggio >= 0)
);

create table Indirizzo
(
   ID        SERIAL      primary key,
   Civico    varchar(5)  not null,
   Via       varchar(20) not null,
   Comune    varchar(20) not null,
   CAP       char(5)     not null,
   Provincia char(2)     not null
);

create table Adulto
(
   CodiceFiscale char(16)    primary key,
   Nome          varchar(12) not null,
   Cognome       varchar(12) not null,
   DataNascita   date        not null,
   Cellulare     char(13)    not null,
   IDIndirizzo   int         not null,
   foreign key (IDIndirizzo) references Indirizzo(ID) on update set null on delete set null
);

create table Partecipante
(
   CodiceFiscale char(16)    primary key,
   Nome          varchar(12) not null,
   Cognome       varchar(12) not null,
   DataNascita   date        not null,
   IDIndirizzo   int         not null,
   CFGenitore    char(16)    not null,
   foreign key (IDIndirizzo) references Indirizzo(ID) on update set null on delete set null,
   foreign key (CFGenitore) references Adulto(CodiceFiscale) on update cascade on delete set null
);

create table Animatore
(
   CodiceFiscale    char(16)    primary key,
   Nome             varchar(12) not null,
   Cognome          varchar(12) not null,
   DataNascita      date        not null,
   Cellulare        char(13)    not null,
   Email            varchar(25) not null,
   NecessitaCrediti bool        not null,
   IDIndirizzo      int         not null,
   foreign key (IDIndirizzo) references Indirizzo(ID) on update set null on delete set null
);

create table Uscita
(
   Nome        varchar(16)  not null,
   Data        date         not null,
   OraInizio   time         not null,
   OraFine     time         not null,
   Luogo       varchar(30)  not null,
   Descrizione varchar(500) not null,
   primary key (Nome, Data),
   check (OraInizio < OraFine)
);

create table Gadget
(
   Nome   varchar(15)  not null,
   Colore varchar(20)  not null,
   Taglia varchar(3)   not null,
   Prezzo decimal(5,2) not null,
   primary key (Nome, Colore, Taglia),
   check (Prezzo >= 0)
);

create table Ordine
(
   Codice       char(8)      primary key,
   Data         date         not null,
   Quantita     int          not null,
   Costo        decimal(5,2) not null,
   CFAnimatore  char(16)     not null,
   NomeGadget   varchar(15)  not null,
   ColoreGadget varchar(20)  not null,
   TagliaGadget varchar(3)   not null,
   foreign key (CFAnimatore) references Animatore(CodiceFiscale) on update set null on delete no action,
   foreign key (NomeGadget, ColoreGadget, TagliaGadget) references Gadget(Nome, Colore, Taglia) on update cascade on delete no action,
   check (Quantita > 0 and Costo >= 0)
);

CREATE TYPE base AS ENUM('erboso','sabbioso','cemento','sassoso','piastrellato','sintetico');

create table Campo
(
   Numero    int         primary key,
   Tipologia base        not null,
   Zona      varchar(20) not null
);

create table Gioco
(
   Nome        varchar(20)  primary key,
   Regole      varchar(500) not null,
   Punteggio   int          not null,
   NumeroCampo int          not null,
   foreign key (NumeroCampo) references Campo(Numero) on update cascade on delete cascade,
   check (Punteggio >= 0)
);

create table Afferisce
(
   NomeEquipe     varchar(20) not null,
   NumeroEdizione int         not null,
   CFAnimatore    char(16)    not null,
   IsResponsabile bool        not null,
   primary key (NomeEquipe, NumeroEdizione, CFAnimatore),
   foreign key (NomeEquipe, NumeroEdizione) references Equipe(Nome, NumeroEdizione) on update cascade on delete cascade,
   foreign key (CFAnimatore) references Animatore(CodiceFiscale) on update cascade on delete cascade
);

create table Partita
(
   Data                      date        not null,
   Ora                       time        not null,
   NomeSquadraA              varchar(30) not null,
   EdizioneSquadraA          int         not null,
   NomeSquadraB              varchar(30) not null,
   EdizioneSquadraB          int         not null,
   SquadraVincitrice         varchar(30) not null,
   EdizioneSquadraVincitrice int         not null,
   NomeGioco                 varchar(20) not null,
   CFArbitro                 char(16)    not null,
   primary key (Data, Ora, NomeSquadraA, EdizioneSquadraA, NomeSquadraB, EdizioneSquadraB),
   foreign key (CFArbitro) references Animatore(CodiceFiscale) on update cascade on delete set null,
   foreign key (NomeSquadraA, EdizioneSquadraA) references Squadra(Nome, NumeroEdizione) on update cascade on delete no action,
   foreign key (NomeSquadraB, EdizioneSquadraB) references Squadra(Nome, NumeroEdizione) on update cascade on delete no action,
   foreign key (SquadraVincitrice, EdizioneSquadraVincitrice) references Squadra(Nome, NumeroEdizione) on update cascade on delete no action,
   foreign key (NomeGioco) references Gioco(Nome) on update cascade on delete set null,
   foreign key (CFArbitro) references Animatore(CodiceFiscale) on update cascade on delete set null,
   check (EdizioneSquadraA = EdizioneSquadraB and (EdizioneSquadraA = EdizioneSquadraVincitrice or EdizioneSquadraVincitrice is null)
        and NomeSquadraA != NomeSquadraB and (SquadraVincitrice = NomeSquadraA or SquadraVincitrice = NomeSquadraB or SquadraVincitrice is null))
);

create table Partecipa
(
   NomeUscita     varchar(16) not null,
   DataUscita     date        not null,
   CFPartecipante char(16)    not null,
   primary key (NomeUscita, DataUscita, CFPartecipante),
   foreign key (NomeUscita, DataUscita) references Uscita(Nome, Data) on update cascade on delete cascade,
   foreign key (CFPartecipante) references Partecipante(CodiceFiscale) on update cascade on delete cascade
);

create table Accompagna
(
   NomeUscita  varchar(16) not null,
   DataUscita  date        not null,
   CFAnimatore char(16)    not null,
   primary key (NomeUscita, DataUscita, CFAnimatore),
   foreign key (NomeUscita, DataUscita) references Uscita(Nome, Data) on update cascade on delete cascade,
   foreign key (CFAnimatore) references Animatore(CodiceFiscale) on update cascade on delete cascade
);

create table Collabora
(
   NomeLaboratorio varchar(30) not null,
   NumeroEdizione  int         not null,
   CFAnimatore     char(16)    not null,
   primary key (NomeLaboratorio, NumeroEdizione, CFAnimatore),
   foreign key (NomeLaboratorio, NumeroEdizione) references Laboratorio(Nome, NumeroEdizione) on update cascade on delete cascade,
   foreign key (CFAnimatore) references Animatore(CodiceFiscale) on update cascade on delete cascade
);

create table Segue
(
   NomeLaboratorio varchar(30) not null,
   NumeroEdizione  int         not null,
   CFPartecipante  char(16)    not null,
   Settimana       int         not null,
   primary key (NomeLaboratorio, NumeroEdizione, CFPartecipante),
   foreign key (NomeLaboratorio, NumeroEdizione) references Laboratorio(Nome, NumeroEdizione) on update cascade on delete cascade,
   foreign key (CFPartecipante) references Partecipante(CodiceFiscale) on update cascade on delete cascade,
   check(Settimana > 0)
);

create table Associato
(
   NomeSquadra     varchar(30) not null,
   NumeroEdizione  int         not null,
   CFPartecipante  char(16)    not null,
   QuanteSettimane int         not null,
   primary key (NomeSquadra, NumeroEdizione, CFPartecipante),
   foreign key (NomeSquadra, NumeroEdizione) references Squadra(Nome, NumeroEdizione) on update cascade on delete cascade,
   foreign key (CFPartecipante) references Partecipante(CodiceFiscale) on update cascade on delete cascade,
   check (QuanteSettimane >= 0)
);

create table Anima
(
   NomeSquadra    varchar(30) not null,
   NumeroEdizione int         not null,
   CFAnimatore    char(16)    not null,
   primary key (NomeSquadra, NumeroEdizione, CFAnimatore),
   foreign key (NomeSquadra, NumeroEdizione) references Squadra(Nome, NumeroEdizione) on update cascade on delete cascade,
   foreign key (CFAnimatore) references Animatore(CodiceFiscale) on update cascade on delete cascade
);

-- POPOLAMENTO BASE DI DATI:
INSERT INTO evento (edizione, titolo, descrizione, datainizio, datafine, canzoneprincipale) VALUES (1, 'Alice in Wonderland', 'Grest Estate 2021', '2021-06-18', '2021-07-04', 'Danza Kuduro');
INSERT INTO evento (edizione, titolo, descrizione, datainizio, datafine, canzoneprincipale) VALUES (2, 'Beija Flor', 'Grest Estate 2022', '2022-06-20', '2022-07-09', 'Limbo');
INSERT INTO evento (edizione, titolo, descrizione, datainizio, datafine, canzoneprincipale) VALUES (3, 'High Five', 'Grest Estate 2023', '2023-06-17', '2023-07-04', 'Sofia');

INSERT INTO equipe (nome, numeroedizione, descrizione) VALUES ('Giochi', 1, 'Organizzano e arbitrano i giochi');
INSERT INTO equipe (nome, numeroedizione, descrizione) VALUES ('Giochi', 2, 'Organizzano e arbitrano i giochi');
INSERT INTO equipe (nome, numeroedizione, descrizione) VALUES ('Giochi', 3, 'Organizzano e arbitrano i giochi');
INSERT INTO equipe (nome, numeroedizione, descrizione) VALUES ('Bans', 1, 'Dimostrano ai ragazzi come ballare');
INSERT INTO equipe (nome, numeroedizione, descrizione) VALUES ('Bans', 2, 'Dimostrano ai ragazzi come ballare');
INSERT INTO equipe (nome, numeroedizione, descrizione) VALUES ('Bans', 3, 'Dimostrano ai ragazzi come ballare');
INSERT INTO equipe (nome, numeroedizione, descrizione) VALUES ('Tecnici', 1, 'Gestiscono mixer muscia e fanno video');
INSERT INTO equipe (nome, numeroedizione, descrizione) VALUES ('Tecnici', 2, 'Gestiscono mixer muscia e fanno video');
INSERT INTO equipe (nome, numeroedizione, descrizione) VALUES ('Tecnici', 3, 'Gestiscono mixer muscia e fanno video');

INSERT INTO laboratorio (nome, numeroedizione, descrizione) VALUES ('Magliette Schizzate', 1, 'Phasellus eu lacus amet neque vulputate feugiat.');
INSERT INTO laboratorio (nome, numeroedizione, descrizione) VALUES ('Tecnoled', 1, 'Phasellus eu lacus amet neque vulputate feugiat.');
INSERT INTO laboratorio (nome, numeroedizione, descrizione) VALUES ('Elettricista', 1, 'Phasellus eu lacus amet neque vulputate feugiat.');
INSERT INTO laboratorio (nome, numeroedizione, descrizione) VALUES ('Falegname', 1, 'Phasellus eu lacus amet neque vulputate feugiat.');
INSERT INTO laboratorio (nome, numeroedizione, descrizione) VALUES ('Filografia', 1, 'Phasellus eu lacus amet neque vulputate feugiat.');
INSERT INTO laboratorio (nome, numeroedizione, descrizione) VALUES ('Decoupage', 1, 'Phasellus eu lacus amet neque vulputate feugiat.');
INSERT INTO laboratorio (nome, numeroedizione, descrizione) VALUES ('MasterChef', 1, 'Phasellus eu lacus amet neque vulputate feugiat.');
INSERT INTO laboratorio (nome, numeroedizione, descrizione) VALUES ('Magliette Schizzate', 2, 'Phasellus eu lacus amet neque vulputate feugiat.');
INSERT INTO laboratorio (nome, numeroedizione, descrizione) VALUES ('Tecnoled', 2, 'Phasellus eu lacus amet neque vulputate feugiat.');
INSERT INTO laboratorio (nome, numeroedizione, descrizione) VALUES ('Casette Miniatura', 2, 'Phasellus eu lacus amet neque vulputate feugiat.');
INSERT INTO laboratorio (nome, numeroedizione, descrizione) VALUES ('Falegname', 2, 'Phasellus eu lacus amet neque vulputate feugiat.');
INSERT INTO laboratorio (nome, numeroedizione, descrizione) VALUES ('Pirografia', 2, 'Phasellus eu lacus amet neque vulputate feugiat.');
INSERT INTO laboratorio (nome, numeroedizione, descrizione) VALUES ('Decoupage', 2, 'Phasellus eu lacus amet neque vulputate feugiat.');
INSERT INTO laboratorio (nome, numeroedizione, descrizione) VALUES ('MasterChef', 2, 'Phasellus eu lacus amet neque vulputate feugiat.');
INSERT INTO laboratorio (nome, numeroedizione, descrizione) VALUES ('Sacche Schizzate', 3, 'Phasellus eu lacus amet neque vulputate feugiat.');
INSERT INTO laboratorio (nome, numeroedizione, descrizione) VALUES ('Tecnoled', 3, 'Phasellus eu lacus amet neque vulputate feugiat.');
INSERT INTO laboratorio (nome, numeroedizione, descrizione) VALUES ('Filografia', 3, 'Phasellus eu lacus amet neque vulputate feugiat.');
INSERT INTO laboratorio (nome, numeroedizione, descrizione) VALUES ('Falegname', 3, 'Phasellus eu lacus amet neque vulputate feugiat.');
INSERT INTO laboratorio (nome, numeroedizione, descrizione) VALUES ('Pirografia', 3, 'Phasellus eu lacus amet neque vulputate feugiat.');
INSERT INTO laboratorio (nome, numeroedizione, descrizione) VALUES ('Braccialetti', 3, 'Phasellus eu lacus amet neque vulputate feugiat.');
INSERT INTO laboratorio (nome, numeroedizione, descrizione) VALUES ('MasterChef', 3, 'Phasellus eu lacus amet neque vulputate feugiat.');

INSERT INTO squadra (nome, numeroedizione, punteggio) VALUES ('Risorgivi', 3, 0);
INSERT INTO squadra (nome, numeroedizione, punteggio) VALUES ('Grillo', 1, 0);
INSERT INTO squadra (nome, numeroedizione, punteggio) VALUES ('Gatto Cheshire', 1, 65);
INSERT INTO squadra (nome, numeroedizione, punteggio) VALUES ('Regina Bianca', 1, 45);
INSERT INTO squadra (nome, numeroedizione, punteggio) VALUES ('Regina Cuori', 1, 25);
INSERT INTO squadra (nome, numeroedizione, punteggio) VALUES ('Bruco', 1, 40);
INSERT INTO squadra (nome, numeroedizione, punteggio) VALUES ('Dodo', 1, 45);
INSERT INTO squadra (nome, numeroedizione, punteggio) VALUES ('Giangi', 1, 40);
INSERT INTO squadra (nome, numeroedizione, punteggio) VALUES ('Tartaruga', 1, 60);
INSERT INTO squadra (nome, numeroedizione, punteggio) VALUES ('Alice', 1, 15);
INSERT INTO squadra (nome, numeroedizione, punteggio) VALUES ('Cappellaio', 1, 70);
INSERT INTO squadra (nome, numeroedizione, punteggio) VALUES ('Royale Squad', 2, 30);
INSERT INTO squadra (nome, numeroedizione, punteggio) VALUES ('Green Links', 2, 45);
INSERT INTO squadra (nome, numeroedizione, punteggio) VALUES ('Creeper', 2, 30);
INSERT INTO squadra (nome, numeroedizione, punteggio) VALUES ('Proplayer', 2, 35);
INSERT INTO squadra (nome, numeroedizione, punteggio) VALUES ('Pro Fortnite', 2, 45);
INSERT INTO squadra (nome, numeroedizione, punteggio) VALUES ('Pacman', 2, 10);
INSERT INTO squadra (nome, numeroedizione, punteggio) VALUES ('Hackerman', 2, 10);
INSERT INTO squadra (nome, numeroedizione, punteggio) VALUES ('Zelda', 2, 30);
INSERT INTO squadra (nome, numeroedizione, punteggio) VALUES ('Team Bros', 2, 45);
INSERT INTO squadra (nome, numeroedizione, punteggio) VALUES ('Luckylama', 2, 45);
INSERT INTO squadra (nome, numeroedizione, punteggio) VALUES ('Boss dei Sogni', 3, 65);
INSERT INTO squadra (nome, numeroedizione, punteggio) VALUES ('Principi dei Sogni', 3, 65);
INSERT INTO squadra (nome, numeroedizione, punteggio) VALUES ('Sognatori', 3, 35);
INSERT INTO squadra (nome, numeroedizione, punteggio) VALUES ('Piccoli Apostoli', 3, 85);
INSERT INTO squadra (nome, numeroedizione, punteggio) VALUES ('Alibabibbia', 3, 45);
INSERT INTO squadra (nome, numeroedizione, punteggio) VALUES ('Followme', 3, 35);
INSERT INTO squadra (nome, numeroedizione, punteggio) VALUES ('Da cosi a cosi', 3, 50);
INSERT INTO squadra (nome, numeroedizione, punteggio) VALUES ('Profeti di IG', 3, 20);
INSERT INTO squadra (nome, numeroedizione, punteggio) VALUES ('Sognatori Chill', 3, 25);

INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (1, '2', 'Piave', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (2, '3', 'Piave', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (3, '4', 'Piave', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (4, '5', 'Piave', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (5, '6', 'Piave', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (6, '1', 'Tentori', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (7, '14', 'Tentori', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (8, '12', 'Tentori', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (9, '16', 'Tentori', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (10, '22', 'Tentori', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (11, '25', 'Tentori', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (12, '23', 'Tentori', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (13, '32', 'Tentori', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (14, '17', 'Tentori', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (15, '11', 'Tentori', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (16, '2', 'Tiso', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (17, '3', 'Tiso', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (18, '4A', 'Tiso', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (19, '5', 'Tiso', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (20, '6C', 'Albarella', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (21, '1', 'Albarella', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (22, '14', 'Albarella', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (23, '12B', 'Albarella', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (24, '16A', 'Albarella', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (25, '22', 'Vecellio', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (26, '25', 'Vecellio', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (27, '23A', 'Vecellio', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (28, '32', 'Vecellio', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (29, '17', 'Vecellio', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (30, '11G', 'Vecellio', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (31, '2', 'Canova', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (32, '3', 'Canova', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (33, '4A', 'Canova', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (34, '5', 'Canova', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (35, '6C', 'Canova', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (36, '1', 'Canova', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (37, '14', 'Canova', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (38, '12B', 'Palladio', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (39, '16A', 'Palladio', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (40, '22', 'Palladio', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (41, '25', 'Palladio', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (42, '23A', 'Palladio', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (43, '32', 'Palladio', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (44, '17', 'Palladio', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (45, '11G', 'Palladio', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (46, '2', 'Massimiliano Kolbe', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (47, '3', 'Massimiliano Kolbe', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (48, '4A', 'Massimiliano Kolbe', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (49, '5', 'Massimiliano Kolbe', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (50, '6C', 'Massimiliano Kolbe', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (51, '1', 'Massimiliano Kolbe', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (52, '14', 'Moretti', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (53, '12B', 'Moretti', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (54, '16A', 'Moretti', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (55, '22', 'Moretti', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (56, '25', 'Moretti', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (57, '23A', 'Moretti', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (58, '32', 'Moretti', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (59, '17', 'Moretti', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (60, '11G', 'Moretti', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (61, '5H', 'Moretti', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (62, '11L', 'Moretti', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (63, '24A', 'Moretti', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (64, '13C', 'Moretti', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (65, '6B', 'Moretti', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (66, '8I', 'Moretti', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (67, '5G', 'Moretti', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (68, '21', 'Moretti', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (69, '89', 'Moretti', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (70, '54E', 'Moretti', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (71, '2F', 'Moretti', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (72, '5A', 'Moretti', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (73, '5B', 'Moretti', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (74, '6H', 'Moretti', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (75, '3D', 'Moretti', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (76, '2', 'Perazzolo', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (77, '3', 'Perazzolo', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (78, '4A', 'Perazzolo', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (79, '5', 'Perazzolo', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (80, '6C', 'Perazzolo', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (81, '1', 'Perazzolo', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (82, '14', 'Riv San Marco', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (83, '12B', 'Riv San Marco', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (84, '16A', 'Riv San Marco', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (85, '22', 'Riv San Marco', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (86, '25', 'Riv San Marco', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (87, '23A', 'Riv San Marco', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (88, '32', 'Riv San Marco', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (89, '17', 'Riv San Marco', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (90, '11G', 'Riv San Marco', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (91, '16A', 'Aldo Moro', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (92, '4', 'Aldo Moro', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (93, '3F', 'Aldo Moro', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (94, '5P', 'Aldo Moro', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (95, '3intA', 'Aldo Moro', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (96, '67', 'Aldo Moro', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (97, '5/C', 'Aldo Moro', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (98, '5/G', 'Aldo Moro', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (99, '12', 'Aldo Moro', 'Camposampiero', '35012', 'PD');
INSERT INTO indirizzo (id, civico, via, comune, cap, provincia) VALUES (100, '33', 'Aldo Moro', 'Camposampiero', '35012', 'PD');

INSERT INTO adulto (codicefiscale, nome, cognome, datanascita, cellulare, idindirizzo) VALUES ('DNCRLV40A41H505K', 'Ersilva', 'De Nucci', '1940-01-01', '+393191600484', 5);
INSERT INTO adulto (codicefiscale, nome, cognome, datanascita, cellulare, idindirizzo) VALUES ('SPRCGR78C01D068Y', 'Calogero', 'Sapere', '1978-03-01', '+393195251628', 12);
INSERT INTO adulto (codicefiscale, nome, cognome, datanascita, cellulare, idindirizzo) VALUES ('CNTBNG81D01I599H', 'Bruno', 'Cantelli', '1981-04-01', '+393855531485', 15);
INSERT INTO adulto (codicefiscale, nome, cognome, datanascita, cellulare, idindirizzo) VALUES ('PLMCST09D01C056B', 'Cristian', 'Palamara', '1979-04-12', '+393967173066', 16);
INSERT INTO adulto (codicefiscale, nome, cognome, datanascita, cellulare, idindirizzo) VALUES ('CRMVTR06T01F007G', 'Vittorio', 'Cerami', '1983-11-10', '+393102938725', 20);
INSERT INTO adulto (codicefiscale, nome, cognome, datanascita, cellulare, idindirizzo) VALUES ('MLNGVR96T41E621S', 'Ginevra', 'Maliani', '1990-12-28', '+393884188975', 33);
INSERT INTO adulto (codicefiscale, nome, cognome, datanascita, cellulare, idindirizzo) VALUES ('BHJCRD31M01B481H', 'Cesar', 'Bahja', '1969-08-20', '+393748629651', 39);
INSERT INTO adulto (codicefiscale, nome, cognome, datanascita, cellulare, idindirizzo) VALUES ('GNLMHL02T01I171A', 'Michele', 'Gonella', '1972-07-19', '+393891833048', 42);
INSERT INTO adulto (codicefiscale, nome, cognome, datanascita, cellulare, idindirizzo) VALUES ('PCBMLL74B41H811G', 'Mariella', 'Piacibello', '1974-02-03', '+393838351894', 52);
INSERT INTO adulto (codicefiscale, nome, cognome, datanascita, cellulare, idindirizzo) VALUES ('PLSRLL58L41B698B', 'Ornella', 'Pelissetti', '1958-07-01', '+393811459136', 59);
INSERT INTO adulto (codicefiscale, nome, cognome, datanascita, cellulare, idindirizzo) VALUES ('CLLSFN24M01M103G', 'Stefano', 'Acelli', '1964-10-22', '+393780309275', 62);
INSERT INTO adulto (codicefiscale, nome, cognome, datanascita, cellulare, idindirizzo) VALUES ('SRNBBR89D01E873J', 'Mauro', 'Sarni', '1989-03-19', '+393132000474', 72);
INSERT INTO adulto (codicefiscale, nome, cognome, datanascita, cellulare, idindirizzo) VALUES ('LBRVTN32D01F760C', 'Marco', 'Aliberti', '1962-04-09', '+393738263728', 76);
INSERT INTO adulto (codicefiscale, nome, cognome, datanascita, cellulare, idindirizzo) VALUES ('BRTJPD16E01D539X', 'Jacopo', 'Bertuzzi', '1986-05-22', '+393830603340', 86);
INSERT INTO adulto (codicefiscale, nome, cognome, datanascita, cellulare, idindirizzo) VALUES ('PVRVNM96A41I191E', 'Laura', 'Peveraro', '1986-04-28', '+393886228466', 89);
INSERT INTO adulto (codicefiscale, nome, cognome, datanascita, cellulare, idindirizzo) VALUES ('BNNTSS65C41A884R', 'Teresa', 'Benoni', '1965-09-15', '+393809393722', 43);
INSERT INTO adulto (codicefiscale, nome, cognome, datanascita, cellulare, idindirizzo) VALUES ('BRHVTR81D01F254H', 'Vittorio', 'Ibrahimi', '1981-04-04', '+393827278654', 55);
INSERT INTO adulto (codicefiscale, nome, cognome, datanascita, cellulare, idindirizzo) VALUES ('BTIMLD55S41A733O', 'Matilde', 'Bitea', '1955-06-27', '+393887916294', 30);
INSERT INTO adulto (codicefiscale, nome, cognome, datanascita, cellulare, idindirizzo) VALUES ('DMRGRS10B41B954V', 'Agata', 'De Martino', '1980-12-01', '+393855616130', 69);
INSERT INTO adulto (codicefiscale, nome, cognome, datanascita, cellulare, idindirizzo) VALUES ('DPLFPP70C01G170H', 'Filippo', 'Di Paola', '1970-03-01', '+393876166800', 47);
INSERT INTO adulto (codicefiscale, nome, cognome, datanascita, cellulare, idindirizzo) VALUES ('FLZRCR62S01A007D', 'Riccardo', 'Filizzolo', '1962-11-01', '+393802202791', 50);
INSERT INTO adulto (codicefiscale, nome, cognome, datanascita, cellulare, idindirizzo) VALUES ('FVGMNT16R01L609F', 'Mauro', 'Favagrossa', '1986-06-30', '+393880330243', 70);
INSERT INTO adulto (codicefiscale, nome, cognome, datanascita, cellulare, idindirizzo) VALUES ('MRZVGN50A01F895L', 'Virginio', 'Mariuzzo', '1951-03-30', '+393814821763', 98);
INSERT INTO adulto (codicefiscale, nome, cognome, datanascita, cellulare, idindirizzo) VALUES ('NVLLBT89M41F450P', 'Elisabetta', 'Novello', '1989-08-26', '+393823527488', 56);
INSERT INTO adulto (codicefiscale, nome, cognome, datanascita, cellulare, idindirizzo) VALUES ('PPRSLD27E41E031G', 'Osvalda', 'Apprato', '1947-07-15', '+393419189563', 93);
INSERT INTO adulto (codicefiscale, nome, cognome, datanascita, cellulare, idindirizzo) VALUES ('PPURPR18E41D821M', 'Rosa', 'Pupo', '1990-01-25', '+393718855851', 71);
INSERT INTO adulto (codicefiscale, nome, cognome, datanascita, cellulare, idindirizzo) VALUES ('QLNVLN18M41C492A', 'Viola', 'Aquilini', '1959-08-01', '+393862936720', 45);
INSERT INTO adulto (codicefiscale, nome, cognome, datanascita, cellulare, idindirizzo) VALUES ('RTUCLL82A01G389U', 'Cirillo', 'Ruta', '1982-01-11', '+393837318665', 95);
INSERT INTO adulto (codicefiscale, nome, cognome, datanascita, cellulare, idindirizzo) VALUES ('RTZSST75D01G367I', 'Sebastiano', 'Ortiz', '1975-11-13', '+393876147810', 91);
INSERT INTO adulto (codicefiscale, nome, cognome, datanascita, cellulare, idindirizzo) VALUES ('RVTFNC97L01F093U', 'Francesco', 'Rovitelli', '1997-07-02', '+393767788334', 8);
INSERT INTO adulto (codicefiscale, nome, cognome, datanascita, cellulare, idindirizzo) VALUES ('ZNLGZY76M41B605L', 'Maria', 'Zanelli', '1976-08-01', '+393780398012', 84);

INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('RSSMRC11A01C517R', 'Marco', 'Rossi', '2011-01-01', 5, 'DNCRLV40A41H505K');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('VLLFNC12B02C745D', 'Francesca', 'Villani', '2012-02-02', 12, 'SPRCGR78C01D068Y');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('BNCMRA13C03G224M', 'Maria', 'Bianchi', '2012-03-03', 16, 'PLMCST09D01C056B');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('NRGSTF15E05C517R', 'Stefano', 'Neri', '2012-02-02', 15, 'CNTBNG81D01I599H');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('BTTLRA16F06C224M', 'Laura', 'Battisti', '2016-06-06', 20, 'CRMVTR06T01F007G');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('GRGFNC17G07C517R', 'Francesca', 'Garofalo', '2017-07-07', 33, 'MLNGVR96T41E621S');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('CNTRNS11H08C224M', 'Renato', 'Conti', '2011-08-08', 42, 'GNLMHL02T01I171A');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('MLTFRN12I09C745D', 'Francesco', 'Molteni', '2012-09-09', 59, 'PLSRLL58L41B698B');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('PRNGBR13L10C517R', 'Gabriele', 'Parini', '2013-10-10', 42, 'SRNBBR89D01E873J');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('LLVFNC14M11C224M', 'Francesca', 'Lolli', '2012-02-02', 76, 'LBRVTN32D01F760C');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('DLPCRS15N12C745D', 'Caruso', 'De Luca', '2015-12-12', 76, 'LBRVTN32D01F760C');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('STRLUC16P13C517R', 'Luca', 'Sartori', '2016-01-13', 86, 'BRTJPD16E01D539X');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('BCCCLD17Q14C224M', 'Claudio', 'Bocci', '2017-02-14', 43, 'BNNTSS65C41A884R');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('RZZFRN11R15C745D', 'Francesco', 'Rizzo', '2011-03-15', 30, 'BTIMLD55S41A733O');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('GNRCRS12S16C517R', 'Caruso', 'Genovese', '2012-04-16', 50, 'FLZRCR62S01A007D');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('PTTFRN13T17C224M', 'Francesco', 'Patti', '2013-05-17', 56, 'NVLLBT89M41F450P');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('GRDFNC14U18C745D', 'Francesca', 'Guerra', '2014-06-18', 56, 'NVLLBT89M41F450P');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('VLLMRC15V19C517R', 'Marco', 'Villani', '2015-07-19', 12, 'SPRCGR78C01D068Y');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('GRNGRN16W20C224M', 'Greta', 'Grandi', '2016-08-20', 56, 'NVLLBT89M41F450P');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('CNDRSS17X21C745D', 'Rossella', 'Candiani', '2017-09-21', 93, 'PPRSLD27E41E031G');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('BNCSLF11Y22C517R', 'Salvatore', 'Bianchi', '2011-10-22', 93, 'PPRSLD27E41E031G');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('TRMBRN12Z23C224M', 'Bruno', 'Trombetta', '2012-11-23', 93, 'PPRSLD27E41E031G');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('MRNGRG13A24C745D', 'Giorgio', 'Marini', '2013-12-24', 71, 'PPURPR18E41D821M');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('LNZRCC14B25C517R', 'Riccardo', 'Lenzi', '2014-01-25', 71, 'PPURPR18E41D821M');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('VRDRCC15C26C224M', 'Riccardo', 'Verdi', '2015-02-26', 45, 'QLNVLN18M41C492A');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('PZZGRL16D27C745D', 'Gabriele', 'Pizzi', '2016-03-27', 95, 'RTUCLL82A01G389U');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('LLLLRA17E28C517R', 'Laura', 'Lolli', '2017-04-28', 76, 'LBRVTN32D01F760C');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('GNTRSS11F29C224M', 'Rossella', 'Gentile', '2011-05-29', 95, 'RTUCLL82A01G389U');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('GRDFNC12G30C745D', 'Francesca', 'Gardini', '2012-06-30', 91, 'RTZSST75D01G367I');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('CLLGLL13H31C517R', 'Galli', 'Calligari', '2013-07-31', 8, 'RVTFNC97L01F093U');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('VRCFNC14I01C224M', 'Francesca', 'Verdi', '2014-08-01', 84, 'ZNLGZY76M41B605L');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('NRRSTS15J02C745D', 'Stefano', 'Neri', '2015-09-02', 15, 'CNTBNG81D01I599H');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('BTSLRA16K03C517R', 'Laura', 'Battisti', '2016-10-03', 20, 'CRMVTR06T01F007G');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('GRGFNC17L04C224M', 'Francesca', 'Garofalo', '2017-11-04', 33, 'MLNGVR96T41E621S');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('CNTRNS11M05C745D', 'Renato', 'Conti', '2011-12-05', 42, 'GNLMHL02T01I171A');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('MLTFRN12N06C517R', 'Francesco', 'Molteni', '2012-01-06', 62, 'CLLSFN24M01M103G');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('PRNGBR13O07C224M', 'Gabriele', 'Parini', '2013-02-07', 42, 'SRNBBR89D01E873J');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('LLVFNC14P08C745D', 'Francesca', 'Lolli', '2014-03-08', 76, 'LBRVTN32D01F760C');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('DLPCRS15Q09C517R', 'Caruso', 'De Luca', '2015-04-09', 86, 'LBRVTN32D01F760C');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('STRLUC16R10C224M', 'Luca', 'Sartori', '2016-05-10', 89, 'PVRVNM96A41I191E');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('BCCCLD17S11C745D', 'Claudio', 'Bocci', '2017-06-11', 43, 'BNNTSS65C41A884R');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('RZZFRN11T12C517R', 'Francesco', 'Rizzo', '2011-07-12', 69, 'DMRGRS10B41B954V');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('GNRCRS12U13C224M', 'Caruso', 'Genovese', '2012-08-13', 70, 'FVGMNT16R01L609F');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('PTTFRN13V14C745D', 'Francesco', 'Patti', '2013-09-14', 84, 'BTIMLD55S41A733O');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('GRDFNC14W15C517R', 'Francesca', 'Guerra', '2014-10-15', 8, 'DMRGRS10B41B954V');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('VLLMRC15X16C224M', 'Marco', 'Villani', '2015-11-16', 91, 'DPLFPP70C01G170H');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('GRNGRN16Y17C745D', 'Greta', 'Grandi', '2016-12-17', 95, 'FLZRCR62S01A007D');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('CNDRSS17Z18C517R', 'Rossella', 'Candiani', '2017-01-18', 45, 'FVGMNT16R01L609F');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('BNCSLF11A19C224M', 'Salvatore', 'Bianchi', '2011-02-19', 71, 'MRZVGN50A01F895L');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('TRMBRN12B20C745D', 'Bruno', 'Trombetta', '2012-03-20', 45, 'LBRVTN32D01F760C');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('MRNGRG13C21C517R', 'Giorgio', 'Marini', '2013-04-21', 93, 'PVRVNM96A41I191E');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('LNZRCC14D22C224M', 'Riccardo', 'Lenzi', '2014-05-22', 59, 'PLSRLL58L41B698B');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('VRDRCC15E23C745D', 'Riccardo', 'Verdi', '2015-06-23', 92, 'PPURPR18E41D821M');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('PZZGRL16F24C517R', 'Gabriele', 'Pizzi', '2016-07-24', 43, 'RTZSST75D01G367I');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('LLLLRA17G25C224M', 'Laura', 'Lolli', '2017-08-25', 76, 'LBRVTN32D01F760C');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('GNTRSS11H26C745D', 'Rossella', 'Gentile', '2011-09-26', 15, 'LBRVTN32D01F760C');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('GRDFNC12I27C517R', 'Francesca', 'Gardini', '2012-10-27', 20, 'BNNTSS65C41A884R');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('CLLGLL13J28C224M', 'Galli', 'Calligari', '2013-11-28', 33, 'DMRGRS10B41B954V');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('VRCFNC14K29C745D', 'Francesca', 'Verdi', '2014-12-29', 72, 'FLZRCR62S01A007D');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('NRRSTS15L30C517R', 'Stefano', 'Neri', '2015-01-30', 15, 'CNTBNG81D01I599H');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('BTSLRA16M31C224M', 'Laura', 'Battisti', '2016-02-28', 20, 'CRMVTR06T01F007G');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('GRGFNC17N01C745D', 'Francesca', 'Garofalo', '2017-03-29', 33, 'MLNGVR96T41E621S');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('CNTRNS11O02C517R', 'Renato', 'Conti', '2011-04-30', 52, 'PCBMLL74B41H811G');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('MLTFRN12P03C224M', 'Francesco', 'Molteni', '2012-05-31', 62, 'CLLSFN24M01M103G');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('PRNGBR13Q04C745D', 'Gabriele', 'Parini', '2013-06-01', 72, 'SRNBBR89D01E873J');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('LLVFNC14R05C517R', 'Francesca', 'Lolli', '2014-07-02', 76, 'SRNBBR89D01E873J');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('DLPCRS15S06C224M', 'Caruso', 'De Luca', '2015-08-03', 76, 'LBRVTN32D01F760C');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('STRLUC16T07C745D', 'Luca', 'Sartori', '2016-09-04', 89, 'PVRVNM96A41I191E');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('BCCCLD17U08C517R', 'Claudio', 'Bocci', '2017-10-05', 55, 'BRHVTR81D01F254H');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('RZZFRN11V09C224M', 'Francesco', 'Rizzo', '2011-11-06', 47, 'DPLFPP70C01G170H');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('GNRCRS12W10C745D', 'Caruso', 'Genovese', '2012-12-07', 98, 'MRZVGN50A01F895L');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('PTTFRN13X11C517R', 'Francesco', 'Patti', '2013-01-08', 52, 'PCBMLL74B41H811G');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('GRDFNC14Y12C224M', 'Francesca', 'Guerra', '2014-02-09', 62, 'CLLSFN24M01M103G');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('VLLMRC15Z13C745D', 'Marco', 'Villani', '2015-03-10', 86, 'BRTJPD16E01D539X');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('GRNGRN16A14C517R', 'Greta', 'Grandi', '2016-04-11', 30, 'BTIMLD55S41A733O');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('CNDRSS17B15C224M', 'Rossella', 'Candiani', '2017-05-12', 15, 'CNTBNG81D01I599H');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('BNCSLF11C16C745D', 'Salvatore', 'Bianchi', '2011-06-13', 12, 'SPRCGR78C01D068Y');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('TRMBRN12D17C517R', 'Bruno', 'Trombetta', '2012-07-14', 5, 'DNCRLV40A41H505K');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('MRNGRG13E18C224M', 'Giorgio', 'Marini', '2013-08-15', 55, 'BRHVTR81D01F254H');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('LNZRCC14F19C745D', 'Riccardo', 'Lenzi', '2014-09-16', 47, 'DPLFPP70C01G170H');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('VRDRCC15G20C517R', 'Riccardo', 'Verdi', '2015-10-17', 70, 'FVGMNT16R01L609F');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('PZZGRL16H21C224M', 'Gabriele', 'Pizzi', '2016-11-18', 42, 'GNLMHL02T01I171A');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('LLLLRA17I22C745D', 'Laura', 'Lolli', '2017-12-19', 72, 'SRNBBR89D01E873J');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('GNTRSS11J23C517R', 'Rossella', 'Gentile', '2011-01-20', 39, 'BHJCRD31M01B481H');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('GRDFNC12K24C224M', 'Francesca', 'Gardini', '2012-02-21', 95, 'RTUCLL82A01G389U');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('CLLGLL13L25C745D', 'Galli', 'Calligari', '2013-03-22', 84, 'ZNLGZY76M41B605L');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('VRCFNC14M26C517R', 'Francesca', 'Verdi', '2014-04-23', 71, 'PPURPR18E41D821M');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('NRRSTS15N27C224M', 'Stefano', 'Neri', '2015-05-24', 71, 'RTUCLL82A01G389U');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('BTSLRA16O28C745D', 'Laura', 'Battisti', '2016-06-25', 20, 'CRMVTR06T01F007G');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('GRGFNC17P29C517R', 'Francesca', 'Garofalo', '2017-07-26', 39, 'BHJCRD31M01B481H');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('CNTRNS11Q30C224M', 'Renato', 'Conti', '2011-08-27', 42, 'PCBMLL74B41H811G');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('MLTFRN12R31C745D', 'Francesco', 'Molteni', '2012-09-28', 62, 'CLLSFN24M01M103G');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('PRNGBR13S01C517R', 'Gabriele', 'Parini', '2013-10-29', 72, 'SRNBBR89D01E873J');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('LLVFNC14T02C224M', 'Francesca', 'Lolli', '2014-11-30', 72, 'SRNBBR89D01E873J');
INSERT INTO partecipante (codicefiscale, nome, cognome, datanascita, idindirizzo, cfgenitore) VALUES ('DLPCRS15U03C745D', 'Caruso', 'De Luca', '2015-12-31', 86, 'BRTJPD16E01D539X');

INSERT INTO animatore (codicefiscale, nome, cognome, datanascita, cellulare, email, necessitacrediti, idindirizzo) VALUES ('LMNDDV62A01D805Q', 'Eduard', 'Alimena', '2000-12-06', '+393456789012', 'ealimena@gmail.com', false, 1);
INSERT INTO animatore (codicefiscale, nome, cognome, datanascita, cellulare, email, necessitacrediti, idindirizzo) VALUES ('SNTTNE20P01B491F', 'Ethan', 'Santoriello', '2002-06-08', '+393467890123', 'esanto@gmail.com', false, 2);
INSERT INTO animatore (codicefiscale, nome, cognome, datanascita, cellulare, email, necessitacrediti, idindirizzo) VALUES ('GNTHRS96S01F761M', 'Anna', 'Gentilcore', '2004-05-19', '+393478901234', 'agntl@gmail.com', true, 3);
INSERT INTO animatore (codicefiscale, nome, cognome, datanascita, cellulare, email, necessitacrediti, idindirizzo) VALUES ('SCHLRN16E41C680E', 'Jessica', 'Schiavi', '2003-04-30', '+393489012345', 'jessk@gmail.com', false, 4);
INSERT INTO animatore (codicefiscale, nome, cognome, datanascita, cellulare, email, necessitacrediti, idindirizzo) VALUES ('LTSRMN84C01Z601V', 'Roman', 'Latassa', '2005-01-06', '+393490123456', 'lataxro@gmail.com', false, 5);
INSERT INTO animatore (codicefiscale, nome, cognome, datanascita, cellulare, email, necessitacrediti, idindirizzo) VALUES ('CPBGNN97L01B025E', 'Giovanni', 'Capobianco', '2000-09-11', '+393201234567', 'gioca@gmail.com', false, 6);
INSERT INTO animatore (codicefiscale, nome, cognome, datanascita, cellulare, email, necessitacrediti, idindirizzo) VALUES ('PRMMRM21E41C002T', 'Marem', 'Premtija', '2000-08-06', '+393212345678', 'marempre@gmail.com', false, 7);
INSERT INTO animatore (codicefiscale, nome, cognome, datanascita, cellulare, email, necessitacrediti, idindirizzo) VALUES ('PLSLXA66R41L845M', 'Alexa', 'Palestro', '2002-02-15', '+393223456789', 'palax@gmail.com', false, 9);
INSERT INTO animatore (codicefiscale, nome, cognome, datanascita, cellulare, email, necessitacrediti, idindirizzo) VALUES ('SNCDNN97C01I565J', 'Andan', 'Sinacore', '1999-12-25', '+393234567890', 'andas@gmail.com', false, 10);
INSERT INTO animatore (codicefiscale, nome, cognome, datanascita, cellulare, email, necessitacrediti, idindirizzo) VALUES ('TRPBRC27R41D221B', 'Beatrice', 'Tripodi', '2004-05-13', '+393245678901', 'beatrip@gmail.com', true, 11);
INSERT INTO animatore (codicefiscale, nome, cognome, datanascita, cellulare, email, necessitacrediti, idindirizzo) VALUES ('VNALVR25M41C244K', 'Emma', 'Avena', '2003-06-19', '+393256789012', 'avenamma@gmail.com', false, 13);
INSERT INTO animatore (codicefiscale, nome, cognome, datanascita, cellulare, email, necessitacrediti, idindirizzo) VALUES ('SBBSHJ84M41I256F', 'Sheje', 'Sabba', '2001-08-11', '+393267890123', 'sabbash@gmail.com', false, 14);
INSERT INTO animatore (codicefiscale, nome, cognome, datanascita, cellulare, email, necessitacrediti, idindirizzo) VALUES ('PRTMTG94T41A335C', 'Marta', 'Periotto', '2002-01-07', '+393278901234', 'martaperc@gmail.com', false, 17);
INSERT INTO animatore (codicefiscale, nome, cognome, datanascita, cellulare, email, necessitacrediti, idindirizzo) VALUES ('BNMZHE10P41B048F', 'Zhe', 'Bonamente', '2001-11-24', '+393289012345', 'zhebon@gmail.com', false, 18);
INSERT INTO animatore (codicefiscale, nome, cognome, datanascita, cellulare, email, necessitacrediti, idindirizzo) VALUES ('MRDNVT90S41I321I', 'Anna', 'Murdaca', '2000-07-16', '+393290123456', 'mur333@gmail.com', false, 19);
INSERT INTO animatore (codicefiscale, nome, cognome, datanascita, cellulare, email, necessitacrediti, idindirizzo) VALUES ('GTNFLI20A41E434C', 'Gaetano', 'File', '2003-01-29', '+393301234567', 'gatean4@gmail.com', false, 21);
INSERT INTO animatore (codicefiscale, nome, cognome, datanascita, cellulare, email, necessitacrediti, idindirizzo) VALUES ('SGHRGN10P01I490G', 'Eugenio', 'Osaghe', '2002-10-23', '+393312345678', 'osaeug6@gmail.com', true, 22);
INSERT INTO animatore (codicefiscale, nome, cognome, datanascita, cellulare, email, necessitacrediti, idindirizzo) VALUES ('MSTMMI15H01F064B', 'Imam', 'Mastino', '2000-06-14', '+393323456789', 'masimam@gmail.com', true, 23);
INSERT INTO animatore (codicefiscale, nome, cognome, datanascita, cellulare, email, necessitacrediti, idindirizzo) VALUES ('PSSZNA95A41B637P', 'Francesca', 'Passuello', '2001-08-18', '+393334567890', 'fra818@gmail.com', false, 24);
INSERT INTO animatore (codicefiscale, nome, cognome, datanascita, cellulare, email, necessitacrediti, idindirizzo) VALUES ('RSCPLG58S41G509D', 'Luigi', 'Ruscio', '2001-04-16', '+393345678901', 'ruscioluigi@gmail.com', false, 25);
INSERT INTO animatore (codicefiscale, nome, cognome, datanascita, cellulare, email, necessitacrediti, idindirizzo) VALUES ('MLDLLN57A41Z101K', 'Gabriele', 'Melidona', '2000-10-28', '+393356789012', 'meli897@gmail.com', false, 26);
INSERT INTO animatore (codicefiscale, nome, cognome, datanascita, cellulare, email, necessitacrediti, idindirizzo) VALUES ('RMNKST19P01B114A', 'Samuel', 'Armanio', '2004-07-09', '+393367890123', 'amr00@gmail.com', false, 27);
INSERT INTO animatore (codicefiscale, nome, cognome, datanascita, cellulare, email, necessitacrediti, idindirizzo) VALUES ('GRSMRS68L41D239P', 'Filippo', 'Grassini', '2003-12-26', '+393378901234', 'grassinifil@gmail.com', false, 28);
INSERT INTO animatore (codicefiscale, nome, cognome, datanascita, cellulare, email, necessitacrediti, idindirizzo) VALUES ('MNSDRS84R41C359M', 'Asia', 'Mensi', '2002-03-20', '+393389012345', 'mensias@gmail.com', true, 29);
INSERT INTO animatore (codicefiscale, nome, cognome, datanascita, cellulare, email, necessitacrediti, idindirizzo) VALUES ('BLRNRT47A41E336F', 'Annarita', 'Bilardo', '2002-06-17', '+393390123456', 'abilardo@gmail.com', false, 31);
INSERT INTO animatore (codicefiscale, nome, cognome, datanascita, cellulare, email, necessitacrediti, idindirizzo) VALUES ('SCRPCR69R41L168B', 'Carla', 'Scarciglia', '2002-08-16', '+393401234567', 'scar463@gmail.com', true, 32);
INSERT INTO animatore (codicefiscale, nome, cognome, datanascita, cellulare, email, necessitacrediti, idindirizzo) VALUES ('CRCHDH18S01A373L', 'Luca', 'Carocci', '2001-09-12', '+393412345678', 'carocciluca01@gmail.com', false, 34);
INSERT INTO animatore (codicefiscale, nome, cognome, datanascita, cellulare, email, necessitacrediti, idindirizzo) VALUES ('ZGRGBD70D01D684B', 'Federico', 'Zagara', '2000-12-06', '+393423456789', 'zaga00@gmail.com', true, 35);
INSERT INTO animatore (codicefiscale, nome, cognome, datanascita, cellulare, email, necessitacrediti, idindirizzo) VALUES ('SLVHSK21E41M021S', 'Manuel', 'Salvione', '2002-07-30', '+393434567890', 'salvionem@gmail.com', false, 36);
INSERT INTO animatore (codicefiscale, nome, cognome, datanascita, cellulare, email, necessitacrediti, idindirizzo) VALUES ('RCANMR16C41H867T', 'Anda', 'Racu', '2001-12-06', '+393445678901', 'racuanda@gmail.com', false, 37);
INSERT INTO animatore (codicefiscale, nome, cognome, datanascita, cellulare, email, necessitacrediti, idindirizzo) VALUES ('LMSDRY84M41A071M', 'Darya', 'El Mestour', '2000-02-08', '+393465678901', 'elmd00@gmail.com', false, 38);
INSERT INTO animatore (codicefiscale, nome, cognome, datanascita, cellulare, email, necessitacrediti, idindirizzo) VALUES ('MNNVLT23A41G630D', 'Giada', 'Menniti', '2002-11-09', '+393476789012', 'mennigiada@gmail.com', false, 40);
INSERT INTO animatore (codicefiscale, nome, cognome, datanascita, cellulare, email, necessitacrediti, idindirizzo) VALUES ('RGGLNH89B41C303L', 'Elena', 'Ruggirello', '2000-11-16', '+393487890123', 'eleruggi@gmail.com', true, 41);
INSERT INTO animatore (codicefiscale, nome, cognome, datanascita, cellulare, email, necessitacrediti, idindirizzo) VALUES ('BLTHNA74S41D117G', 'Lorenzo', 'Bilotta', '2004-09-22', '+393498901234', 'lorebilo04@gmail.com', false, 44);

INSERT INTO uscita (nome, data, orainizio, orafine, luogo, descrizione) VALUES ('Aquaestate', '2021-06-30', '08:30:00', '17:30:00', 'Noale', 'Phasellus eu lacus sit amet neque vulputate feugiat. Praesent at libero sed nisl luctus venenatis iaculis id lorem. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus volutpat porta diam ac sollicitudin. In feugiat ex in blandit semper. Vestibulum eu porta nulla. Duis convallis magna eget nisi finibus, a consectetur nisi dictum. Fusce semper condimentum feugiat. Vivamus tincidunt convallis velit ut aliquet. Proin non congue lacus.');
INSERT INTO uscita (nome, data, orainizio, orafine, luogo, descrizione) VALUES ('Aquaestate', '2022-07-03', '08:30:00', '17:30:00', 'Noale', 'Phasellus eu lacus sit amet neque vulputate feugiat. Praesent at libero sed nisl luctus venenatis iaculis id lorem. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus volutpat porta diam ac sollicitudin. In feugiat ex in blandit semper. Vestibulum eu porta nulla. Duis convallis magna eget nisi finibus, a consectetur nisi dictum. Fusce semper condimentum feugiat. Vivamus tincidunt convallis velit ut aliquet. Proin non congue lacus.');
INSERT INTO uscita (nome, data, orainizio, orafine, luogo, descrizione) VALUES ('Aquaestate', '2023-07-05', '08:30:00', '17:30:00', 'Noale', 'Phasellus eu lacus sit amet neque vulputate feugiat. Praesent at libero sed nisl luctus venenatis iaculis id lorem. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus volutpat porta diam ac sollicitudin. In feugiat ex in blandit semper. Vestibulum eu porta nulla. Duis convallis magna eget nisi finibus, a consectetur nisi dictum. Fusce semper condimentum feugiat. Vivamus tincidunt convallis velit ut aliquet. Proin non congue lacus.');
INSERT INTO uscita (nome, data, orainizio, orafine, luogo, descrizione) VALUES ('ConcaVerde', '2023-06-28', '09:00:00', '17:00:00', 'Borso del Grappa', 'Phasellus eu lacus sit amet neque vulputate feugiat. Praesent at libero sed nisl luctus venenatis iaculis id lorem. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus volutpat porta diam ac sollicitudin. In feugiat ex in blandit semper. Vestibulum eu porta nulla. Duis convallis magna eget nisi finibus, a consectetur nisi dictum. Fusce semper condimentum feugiat. Vivamus tincidunt convallis velit ut aliquet. Proin non congue lacus.');
INSERT INTO uscita (nome, data, orainizio, orafine, luogo, descrizione) VALUES ('ConcaVerde', '2022-06-25', '09:00:00', '17:00:00', 'Borso del Grappa', 'Phasellus eu lacus sit amet neque vulputate feugiat. Praesent at libero sed nisl luctus venenatis iaculis id lorem. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus volutpat porta diam ac sollicitudin. In feugiat ex in blandit semper. Vestibulum eu porta nulla. Duis convallis magna eget nisi finibus, a consectetur nisi dictum. Fusce semper condimentum feugiat. Vivamus tincidunt convallis velit ut aliquet. Proin non congue lacus.');
INSERT INTO uscita (nome, data, orainizio, orafine, luogo, descrizione) VALUES ('ConcaVerde', '2021-06-23', '09:00:00', '17:00:00', 'Borso del Grappa', 'Phasellus eu lacus sit amet neque vulputate feugiat. Praesent at libero sed nisl luctus venenatis iaculis id lorem. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus volutpat porta diam ac sollicitudin. In feugiat ex in blandit semper. Vestibulum eu porta nulla. Duis convallis magna eget nisi finibus, a consectetur nisi dictum. Fusce semper condimentum feugiat. Vivamus tincidunt convallis velit ut aliquet. Proin non congue lacus.');

INSERT INTO gadget (nome, colore, taglia, prezzo) VALUES ('Maglietta', 'Nome Edizione', 'XS', 2.50);
INSERT INTO gadget (nome, colore, taglia, prezzo) VALUES ('Maglietta', 'Nome Edizione', 'S', 2.50);
INSERT INTO gadget (nome, colore, taglia, prezzo) VALUES ('Maglietta', 'Nome Edizione', 'M', 2.50);
INSERT INTO gadget (nome, colore, taglia, prezzo) VALUES ('Maglietta', 'Nome Edizione', 'L', 2.50);
INSERT INTO gadget (nome, colore, taglia, prezzo) VALUES ('Maglietta', 'Nome Edizione', 'XL', 2.50);
INSERT INTO gadget (nome, colore, taglia, prezzo) VALUES ('Maglietta', 'Nome Edizione', 'XXL', 2.50);
INSERT INTO gadget (nome, colore, taglia, prezzo) VALUES ('Casacca', 'Arancione', 'M', 0.50);
INSERT INTO gadget (nome, colore, taglia, prezzo) VALUES ('Casacca', 'Arancione', 'XL', 0.50);
INSERT INTO gadget (nome, colore, taglia, prezzo) VALUES ('Casacca', 'Giallo', 'M', 0.50);
INSERT INTO gadget (nome, colore, taglia, prezzo) VALUES ('Casacca', 'Giallo', 'XL', 0.50);
INSERT INTO gadget (nome, colore, taglia, prezzo) VALUES ('Casacca', 'Verde', 'M', 0.50);
INSERT INTO gadget (nome, colore, taglia, prezzo) VALUES ('Casacca', 'Verde', 'XL', 0.50);
INSERT INTO gadget (nome, colore, taglia, prezzo) VALUES ('Casacca', 'Rosso', 'M', 0.50);
INSERT INTO gadget (nome, colore, taglia, prezzo) VALUES ('Casacca', 'Rosso', 'XL', 0.50);
INSERT INTO gadget (nome, colore, taglia, prezzo) VALUES ('Casacca', 'Blu', 'M', 0.50);
INSERT INTO gadget (nome, colore, taglia, prezzo) VALUES ('Casacca', 'Blu', 'XL', 0.50);
INSERT INTO gadget (nome, colore, taglia, prezzo) VALUES ('Maglietta', 'Ed. Animatori', 'M', 3.00);
INSERT INTO gadget (nome, colore, taglia, prezzo) VALUES ('Maglietta', 'Ed. Animatori', 'L', 3.00);
INSERT INTO gadget (nome, colore, taglia, prezzo) VALUES ('Pallone', 'Basket', 'UNI', 5.00);
INSERT INTO gadget (nome, colore, taglia, prezzo) VALUES ('Pallone', 'Calcio', 'UNI', 5.00);
INSERT INTO gadget (nome, colore, taglia, prezzo) VALUES ('Pallone', 'Pallavolo', 'UNI', 5.00);
INSERT INTO gadget (nome, colore, taglia, prezzo) VALUES ('Pallone', 'Beach Volley', 'UNI', 5.00);
INSERT INTO gadget (nome, colore, taglia, prezzo) VALUES ('Fischietto', 'Grigio', 'UNI', 3.00);
INSERT INTO gadget (nome, colore, taglia, prezzo) VALUES ('Nastro', 'Adesivo Trasparente', 'UNI', 3.50);
INSERT INTO gadget (nome, colore, taglia, prezzo) VALUES ('Nastro', 'Adesivo Di Carta', 'UNI', 3.50);
INSERT INTO gadget (nome, colore, taglia, prezzo) VALUES ('Nastro', 'Bianco Rosso', 'UNI', 3.50);
INSERT INTO gadget (nome, colore, taglia, prezzo) VALUES ('Cono', 'Arancione', 'UNI', 3.50);
INSERT INTO gadget (nome, colore, taglia, prezzo) VALUES ('Braccialetto', 'Nome Edizione', 'S', 1.50);
INSERT INTO gadget (nome, colore, taglia, prezzo) VALUES ('Braccialetto', 'Nome Edizione', 'M', 1.50);
INSERT INTO gadget (nome, colore, taglia, prezzo) VALUES ('Braccialetto', 'Nome Edizione', 'L', 1.50);

INSERT INTO ordine (codice, data, quantita, costo, cfanimatore, nomegadget, coloregadget, tagliagadget) VALUES ('HDI93RLP', '2022-06-23', 50, 150.00, 'MRDNVT90S41I321I', 'Maglietta', 'Ed. Animatori', 'M');
INSERT INTO ordine (codice, data, quantita, costo, cfanimatore, nomegadget, coloregadget, tagliagadget) VALUES ('2HF85NV0', '2021-06-28', 100, 250.00, 'CPBGNN97L01B025E', 'Maglietta', 'Nome Edizione', 'M');
INSERT INTO ordine (codice, data, quantita, costo, cfanimatore, nomegadget, coloregadget, tagliagadget) VALUES ('SCBZXM85', '2023-06-17', 20, 60.00, 'SLVHSK21E41M021S', 'Fischietto', 'Grigio', 'UNI');
INSERT INTO ordine (codice, data, quantita, costo, cfanimatore, nomegadget, coloregadget, tagliagadget) VALUES ('CNDKJSFP', '2022-06-24', 5, 25.00, 'PSSZNA95A41B637P', 'Pallone', 'Basket', 'UNI');
INSERT INTO ordine (codice, data, quantita, costo, cfanimatore, nomegadget, coloregadget, tagliagadget) VALUES ('2HF8N4MF', '2023-06-17', 1, 5.00, 'MNSDRS84R41C359M', 'Pallone', 'Beach Volley', 'UNI');
INSERT INTO ordine (codice, data, quantita, costo, cfanimatore, nomegadget, coloregadget, tagliagadget) VALUES ('FH49GML0', '2021-06-30', 75, 37.50, 'CPBGNN97L01B025E', 'Casacca', 'Arancione', 'XL');
INSERT INTO ordine (codice, data, quantita, costo, cfanimatore, nomegadget, coloregadget, tagliagadget) VALUES ('283URFH8', '2023-07-20', 200, 500.00, 'BLTHNA74S41D117G', 'Maglietta', 'Nome Edizione', 'L');
INSERT INTO ordine (codice, data, quantita, costo, cfanimatore, nomegadget, coloregadget, tagliagadget) VALUES ('ABXM59T4', '2022-06-23', 74, 37.00, 'MSTMMI15H01F064B', 'Casacca', 'Giallo', 'XL');

INSERT INTO campo (numero, tipologia, zona) VALUES (11, 'erboso', 'Retro Chiesa');
INSERT INTO campo (numero, tipologia, zona) VALUES (12, 'erboso', 'Retro Chiesa');
INSERT INTO campo (numero, tipologia, zona) VALUES (13, 'erboso', 'Retro Chiesa');
INSERT INTO campo (numero, tipologia, zona) VALUES (21, 'sabbioso', 'Retro Chiesa');
INSERT INTO campo (numero, tipologia, zona) VALUES (22, 'sabbioso', 'Retro Chiesa');
INSERT INTO campo (numero, tipologia, zona) VALUES (23, 'sabbioso', 'Retro Chiesa');
INSERT INTO campo (numero, tipologia, zona) VALUES (31, 'cemento', 'Retro Chiesa');
INSERT INTO campo (numero, tipologia, zona) VALUES (32, 'cemento', 'Retro Chiesa');
INSERT INTO campo (numero, tipologia, zona) VALUES (33, 'cemento', 'Retro Chiesa');
INSERT INTO campo (numero, tipologia, zona) VALUES (41, 'sassoso', 'Giardino Asilo');
INSERT INTO campo (numero, tipologia, zona) VALUES (42, 'sassoso', 'Giardino Asilo');
INSERT INTO campo (numero, tipologia, zona) VALUES (43, 'sassoso', 'Giardino Asilo');
INSERT INTO campo (numero, tipologia, zona) VALUES (51, 'piastrellato', 'Oratorio Nord');
INSERT INTO campo (numero, tipologia, zona) VALUES (52, 'piastrellato', 'Oratorio Nord');
INSERT INTO campo (numero, tipologia, zona) VALUES (53, 'piastrellato', 'Oratorio Nord');
INSERT INTO campo (numero, tipologia, zona) VALUES (61, 'sintetico', 'Imp. Comunali');
INSERT INTO campo (numero, tipologia, zona) VALUES (62, 'sintetico', 'Imp. Comunali');
INSERT INTO campo (numero, tipologia, zona) VALUES (63, 'sintetico', 'Imp. Comunali');

INSERT INTO gioco (nome, regole, punteggio, numerocampo) VALUES ('Pallavolo', 'Phasellus eu lacus sit amet neque vulputate feugiat. Praesent at libero sed nisl luctus venenatis iaculis id lorem. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus volutpat porta diam ac sollicitudin. In feugiat ex in blandit semper. Vestibulum eu porta nulla. Duis convallis magna eget nisi finibus, a consectetur nisi dictum. Fusce semper condimentum feugiat. Vivamus tincidunt convallis velit ut aliquet. Proin non congue lacus.', 25, 51);
INSERT INTO gioco (nome, regole, punteggio, numerocampo) VALUES ('Beach Volley', 'Phasellus eu lacus sit amet neque vulputate feugiat. Praesent at libero sed nisl luctus venenatis iaculis id lorem. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus volutpat porta diam ac sollicitudin. In feugiat ex in blandit semper. Vestibulum eu porta nulla. Duis convallis magna eget nisi finibus, a consectetur nisi dictum. Fusce semper condimentum feugiat. Vivamus tincidunt convallis velit ut aliquet. Proin non congue lacus.', 15, 21);
INSERT INTO gioco (nome, regole, punteggio, numerocampo) VALUES ('Calcio', 'Phasellus eu lacus sit amet neque vulputate feugiat. Praesent at libero sed nisl luctus venenatis iaculis id lorem. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus volutpat porta diam ac sollicitudin. In feugiat ex in blandit semper. Vestibulum eu porta nulla. Duis convallis magna eget nisi finibus, a consectetur nisi dictum. Fusce semper condimentum feugiat. Vivamus tincidunt convallis velit ut aliquet. Proin non congue lacus.', 25, 61);
INSERT INTO gioco (nome, regole, punteggio, numerocampo) VALUES ('Scalpo', 'Phasellus eu lacus sit amet neque vulputate feugiat. Praesent at libero sed nisl luctus venenatis iaculis id lorem. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus volutpat porta diam ac sollicitudin. In feugiat ex in blandit semper. Vestibulum eu porta nulla. Duis convallis magna eget nisi finibus, a consectetur nisi dictum. Fusce semper condimentum feugiat. Vivamus tincidunt convallis velit ut aliquet. Proin non congue lacus.', 15, 22);
INSERT INTO gioco (nome, regole, punteggio, numerocampo) VALUES ('Basket', 'Phasellus eu lacus sit amet neque vulputate feugiat. Praesent at libero sed nisl luctus venenatis iaculis id lorem. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus volutpat porta diam ac sollicitudin. In feugiat ex in blandit semper. Vestibulum eu porta nulla. Duis convallis magna eget nisi finibus, a consectetur nisi dictum. Fusce semper condimentum feugiat. Vivamus tincidunt convallis velit ut aliquet. Proin non congue lacus.', 25, 12);
INSERT INTO gioco (nome, regole, punteggio, numerocampo) VALUES ('Spugna Bagnata', 'Phasellus eu lacus sit amet neque vulputate feugiat. Praesent at libero sed nisl luctus venenatis iaculis id lorem. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus volutpat porta diam ac sollicitudin. In feugiat ex in blandit semper. Vestibulum eu porta nulla. Duis convallis magna eget nisi finibus, a consectetur nisi dictum. Fusce semper condimentum feugiat. Vivamus tincidunt convallis velit ut aliquet. Proin non congue lacus.', 15, 11);
INSERT INTO gioco (nome, regole, punteggio, numerocampo) VALUES ('Bowling', 'Phasellus eu lacus sit amet neque vulputate feugiat. Praesent at libero sed nisl luctus venenatis iaculis id lorem. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus volutpat porta diam ac sollicitudin. In feugiat ex in blandit semper. Vestibulum eu porta nulla. Duis convallis magna eget nisi finibus, a consectetur nisi dictum. Fusce semper condimentum feugiat. Vivamus tincidunt convallis velit ut aliquet. Proin non congue lacus.', 15, 51);
INSERT INTO gioco (nome, regole, punteggio, numerocampo) VALUES ('Bottiglia Acqua', 'Phasellus eu lacus sit amet neque vulputate feugiat. Praesent at libero sed nisl luctus venenatis iaculis id lorem. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus volutpat porta diam ac sollicitudin. In feugiat ex in blandit semper. Vestibulum eu porta nulla. Duis convallis magna eget nisi finibus, a consectetur nisi dictum. Fusce semper condimentum feugiat. Vivamus tincidunt convallis velit ut aliquet. Proin non congue lacus.', 15, 11);
INSERT INTO gioco (nome, regole, punteggio, numerocampo) VALUES ('Bandierina', 'Phasellus eu lacus sit amet neque vulputate feugiat. Praesent at libero sed nisl luctus venenatis iaculis id lorem. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus volutpat porta diam ac sollicitudin. In feugiat ex in blandit semper. Vestibulum eu porta nulla. Duis convallis magna eget nisi finibus, a consectetur nisi dictum. Fusce semper condimentum feugiat. Vivamus tincidunt convallis velit ut aliquet. Proin non congue lacus.', 20, 42);
INSERT INTO gioco (nome, regole, punteggio, numerocampo) VALUES ('Caccia oca', 'Phasellus eu lacus sit amet neque vulputate feugiat. Praesent at libero sed nisl luctus venenatis iaculis id lorem. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus volutpat porta diam ac sollicitudin. In feugiat ex in blandit semper. Vestibulum eu porta nulla. Duis convallis magna eget nisi finibus, a consectetur nisi dictum. Fusce semper condimentum feugiat. Vivamus tincidunt convallis velit ut aliquet. Proin non congue lacus.', 25, 43);
INSERT INTO gioco (nome, regole, punteggio, numerocampo) VALUES ('Contiamo', 'Phasellus eu lacus sit amet neque vulputate feugiat. Praesent at libero sed nisl luctus venenatis iaculis id lorem. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus volutpat porta diam ac sollicitudin. In feugiat ex in blandit semper. Vestibulum eu porta nulla. Duis convallis magna eget nisi finibus, a consectetur nisi dictum. Fusce semper condimentum feugiat. Vivamus tincidunt convallis velit ut aliquet. Proin non congue lacus.', 10, 23);
INSERT INTO gioco (nome, regole, punteggio, numerocampo) VALUES ('Handball', 'Phasellus eu lacus sit amet neque vulputate feugiat. Praesent at libero sed nisl luctus venenatis iaculis id lorem. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus volutpat porta diam ac sollicitudin. In feugiat ex in blandit semper. Vestibulum eu porta nulla. Duis convallis magna eget nisi finibus, a consectetur nisi dictum. Fusce semper condimentum feugiat. Vivamus tincidunt convallis velit ut aliquet. Proin non congue lacus.', 20, 13);
INSERT INTO gioco (nome, regole, punteggio, numerocampo) VALUES ('Castelli', 'Phasellus eu lacus sit amet neque vulputate feugiat. Praesent at libero sed nisl luctus venenatis iaculis id lorem. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus volutpat porta diam ac sollicitudin. In feugiat ex in blandit semper. Vestibulum eu porta nulla. Duis convallis magna eget nisi finibus, a consectetur nisi dictum. Fusce semper condimentum feugiat. Vivamus tincidunt convallis velit ut aliquet. Proin non congue lacus.', 25, 43);
INSERT INTO gioco (nome, regole, punteggio, numerocampo) VALUES ('Statua Umana', 'Phasellus eu lacus sit amet neque vulputate feugiat. Praesent at libero sed nisl luctus venenatis iaculis id lorem. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus volutpat porta diam ac sollicitudin. In feugiat ex in blandit semper. Vestibulum eu porta nulla. Duis convallis magna eget nisi finibus, a consectetur nisi dictum. Fusce semper condimentum feugiat. Vivamus tincidunt convallis velit ut aliquet. Proin non congue lacus.', 25, 13);
INSERT INTO gioco (nome, regole, punteggio, numerocampo) VALUES ('Piramide', 'Phasellus eu lacus sit amet neque vulputate feugiat. Praesent at libero sed nisl luctus venenatis iaculis id lorem. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus volutpat porta diam ac sollicitudin. In feugiat ex in blandit semper. Vestibulum eu porta nulla. Duis convallis magna eget nisi finibus, a consectetur nisi dictum. Fusce semper condimentum feugiat. Vivamus tincidunt convallis velit ut aliquet. Proin non congue lacus.', 30, 13);
INSERT INTO gioco (nome, regole, punteggio, numerocampo) VALUES ('Guelfi e Ghibellini', 'Phasellus eu lacus sit amet neque vulputate feugiat. Praesent at libero sed nisl luctus venenatis iaculis id lorem. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus volutpat porta diam ac sollicitudin. In feugiat ex in blandit semper. Vestibulum eu porta nulla. Duis convallis magna eget nisi finibus, a consectetur nisi dictum. Fusce semper condimentum feugiat. Vivamus tincidunt convallis velit ut aliquet. Proin non congue lacus.', 25, 41);
INSERT INTO gioco (nome, regole, punteggio, numerocampo) VALUES ('Fazzoletto', 'Phasellus eu lacus sit amet neque vulputate feugiat. Praesent at libero sed nisl luctus venenatis iaculis id lorem. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus volutpat porta diam ac sollicitudin. In feugiat ex in blandit semper. Vestibulum eu porta nulla. Duis convallis magna eget nisi finibus, a consectetur nisi dictum. Fusce semper condimentum feugiat. Vivamus tincidunt convallis velit ut aliquet. Proin non congue lacus.', 10, 33);
INSERT INTO gioco (nome, regole, punteggio, numerocampo) VALUES ('Bandiera', 'Phasellus eu lacus sit amet neque vulputate feugiat. Praesent at libero sed nisl luctus venenatis iaculis id lorem. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus volutpat porta diam ac sollicitudin. In feugiat ex in blandit semper. Vestibulum eu porta nulla. Duis convallis magna eget nisi finibus, a consectetur nisi dictum. Fusce semper condimentum feugiat. Vivamus tincidunt convallis velit ut aliquet. Proin non congue lacus.', 10, 52);
INSERT INTO gioco (nome, regole, punteggio, numerocampo) VALUES ('Rigori', 'Phasellus eu lacus sit amet neque vulputate feugiat. Praesent at libero sed nisl luctus venenatis iaculis id lorem. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus volutpat porta diam ac sollicitudin. In feugiat ex in blandit semper. Vestibulum eu porta nulla. Duis convallis magna eget nisi finibus, a consectetur nisi dictum. Fusce semper condimentum feugiat. Vivamus tincidunt convallis velit ut aliquet. Proin non congue lacus.', 20, 62);
INSERT INTO gioco (nome, regole, punteggio, numerocampo) VALUES ('Tiri Canestro', 'Phasellus eu lacus sit amet neque vulputate feugiat. Praesent at libero sed nisl luctus venenatis iaculis id lorem. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus volutpat porta diam ac sollicitudin. In feugiat ex in blandit semper. Vestibulum eu porta nulla. Duis convallis magna eget nisi finibus, a consectetur nisi dictum. Fusce semper condimentum feugiat. Vivamus tincidunt convallis velit ut aliquet. Proin non congue lacus.', 20, 53);
INSERT INTO gioco (nome, regole, punteggio, numerocampo) VALUES ('Bicchiere bucato', 'Phasellus eu lacus sit amet neque vulputate feugiat. Praesent at libero sed nisl luctus venenatis iaculis id lorem. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus volutpat porta diam ac sollicitudin. In feugiat ex in blandit semper. Vestibulum eu porta nulla. Duis convallis magna eget nisi finibus, a consectetur nisi dictum. Fusce semper condimentum feugiat. Vivamus tincidunt convallis velit ut aliquet. Proin non congue lacus.', 15, 23);
INSERT INTO gioco (nome, regole, punteggio, numerocampo) VALUES ('Rugby', 'Phasellus eu lacus sit amet neque vulputate feugiat. Praesent at libero sed nisl luctus venenatis iaculis id lorem. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus volutpat porta diam ac sollicitudin. In feugiat ex in blandit semper. Vestibulum eu porta nulla. Duis convallis magna eget nisi finibus, a consectetur nisi dictum. Fusce semper condimentum feugiat. Vivamus tincidunt convallis velit ut aliquet. Proin non congue lacus.', 25, 63);
INSERT INTO gioco (nome, regole, punteggio, numerocampo) VALUES ('Rugby Touch', 'Phasellus eu lacus sit amet neque vulputate feugiat. Praesent at libero sed nisl luctus venenatis iaculis id lorem. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus volutpat porta diam ac sollicitudin. In feugiat ex in blandit semper. Vestibulum eu porta nulla. Duis convallis magna eget nisi finibus, a consectetur nisi dictum. Fusce semper condimentum feugiat. Vivamus tincidunt convallis velit ut aliquet. Proin non congue lacus.', 20, 62);
INSERT INTO gioco (nome, regole, punteggio, numerocampo) VALUES ('Tunnel', 'Phasellus eu lacus sit amet neque vulputate feugiat. Praesent at libero sed nisl luctus venenatis iaculis id lorem. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus volutpat porta diam ac sollicitudin. In feugiat ex in blandit semper. Vestibulum eu porta nulla. Duis convallis magna eget nisi finibus, a consectetur nisi dictum. Fusce semper condimentum feugiat. Vivamus tincidunt convallis velit ut aliquet. Proin non congue lacus.', 15, 12);
INSERT INTO gioco (nome, regole, punteggio, numerocampo) VALUES ('Baseball', 'Phasellus eu lacus sit amet neque vulputate feugiat. Praesent at libero sed nisl luctus venenatis iaculis id lorem. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus volutpat porta diam ac sollicitudin. In feugiat ex in blandit semper. Vestibulum eu porta nulla. Duis convallis magna eget nisi finibus, a consectetur nisi dictum. Fusce semper condimentum feugiat. Vivamus tincidunt convallis velit ut aliquet. Proin non congue lacus.', 25, 61);
INSERT INTO gioco (nome, regole, punteggio, numerocampo) VALUES ('Ragnatela', 'Phasellus eu lacus sit amet neque vulputate feugiat. Praesent at libero sed nisl luctus venenatis iaculis id lorem. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus volutpat porta diam ac sollicitudin. In feugiat ex in blandit semper. Vestibulum eu porta nulla. Duis convallis magna eget nisi finibus, a consectetur nisi dictum. Fusce semper condimentum feugiat. Vivamus tincidunt convallis velit ut aliquet. Proin non congue lacus.', 20, 32);
INSERT INTO gioco (nome, regole, punteggio, numerocampo) VALUES ('Ciechi', 'Phasellus eu lacus sit amet neque vulputate feugiat. Praesent at libero sed nisl luctus venenatis iaculis id lorem. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus volutpat porta diam ac sollicitudin. In feugiat ex in blandit semper. Vestibulum eu porta nulla. Duis convallis magna eget nisi finibus, a consectetur nisi dictum. Fusce semper condimentum feugiat. Vivamus tincidunt convallis velit ut aliquet. Proin non congue lacus.', 10, 31);
INSERT INTO gioco (nome, regole, punteggio, numerocampo) VALUES ('Lancio Vortex', 'Phasellus eu lacus sit amet neque vulputate feugiat. Praesent at libero sed nisl luctus venenatis iaculis id lorem. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus volutpat porta diam ac sollicitudin. In feugiat ex in blandit semper. Vestibulum eu porta nulla. Duis convallis magna eget nisi finibus, a consectetur nisi dictum. Fusce semper condimentum feugiat. Vivamus tincidunt convallis velit ut aliquet. Proin non congue lacus.', 15, 22);
INSERT INTO gioco (nome, regole, punteggio, numerocampo) VALUES ('Naufraghi', 'Phasellus eu lacus sit amet neque vulputate feugiat. Praesent at libero sed nisl luctus venenatis iaculis id lorem. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus volutpat porta diam ac sollicitudin. In feugiat ex in blandit semper. Vestibulum eu porta nulla. Duis convallis magna eget nisi finibus, a consectetur nisi dictum. Fusce semper condimentum feugiat. Vivamus tincidunt convallis velit ut aliquet. Proin non congue lacus.', 35, 12);

INSERT INTO afferisce (nomeequipe, numeroedizione, cfanimatore, isresponsabile) VALUES ('Giochi', 1, 'LMNDDV62A01D805Q', true);
INSERT INTO afferisce (nomeequipe, numeroedizione, cfanimatore, isresponsabile) VALUES ('Giochi', 1, 'SNTTNE20P01B491F', true);
INSERT INTO afferisce (nomeequipe, numeroedizione, cfanimatore, isresponsabile) VALUES ('Giochi', 1, 'GNTHRS96S01F761M', false);
INSERT INTO afferisce (nomeequipe, numeroedizione, cfanimatore, isresponsabile) VALUES ('Giochi', 1, 'SCHLRN16E41C680E', false);
INSERT INTO afferisce (nomeequipe, numeroedizione, cfanimatore, isresponsabile) VALUES ('Giochi', 1, 'LTSRMN84C01Z601V', false);
INSERT INTO afferisce (nomeequipe, numeroedizione, cfanimatore, isresponsabile) VALUES ('Giochi', 2, 'CPBGNN97L01B025E', true);
INSERT INTO afferisce (nomeequipe, numeroedizione, cfanimatore, isresponsabile) VALUES ('Giochi', 2, 'PRMMRM21E41C002T', false);
INSERT INTO afferisce (nomeequipe, numeroedizione, cfanimatore, isresponsabile) VALUES ('Giochi', 2, 'PLSLXA66R41L845M', false);
INSERT INTO afferisce (nomeequipe, numeroedizione, cfanimatore, isresponsabile) VALUES ('Giochi', 2, 'SNCDNN97C01I565J', false);
INSERT INTO afferisce (nomeequipe, numeroedizione, cfanimatore, isresponsabile) VALUES ('Giochi', 2, 'TRPBRC27R41D221B', false);
INSERT INTO afferisce (nomeequipe, numeroedizione, cfanimatore, isresponsabile) VALUES ('Giochi', 3, 'VNALVR25M41C244K', true);
INSERT INTO afferisce (nomeequipe, numeroedizione, cfanimatore, isresponsabile) VALUES ('Giochi', 3, 'SBBSHJ84M41I256F', true);
INSERT INTO afferisce (nomeequipe, numeroedizione, cfanimatore, isresponsabile) VALUES ('Giochi', 3, 'PRTMTG94T41A335C', false);
INSERT INTO afferisce (nomeequipe, numeroedizione, cfanimatore, isresponsabile) VALUES ('Giochi', 3, 'BNMZHE10P41B048F', false);
INSERT INTO afferisce (nomeequipe, numeroedizione, cfanimatore, isresponsabile) VALUES ('Giochi', 3, 'MRDNVT90S41I321I', false);
INSERT INTO afferisce (nomeequipe, numeroedizione, cfanimatore, isresponsabile) VALUES ('Bans', 1, 'GTNFLI20A41E434C', true);
INSERT INTO afferisce (nomeequipe, numeroedizione, cfanimatore, isresponsabile) VALUES ('Bans', 1, 'SGHRGN10P01I490G', false);
INSERT INTO afferisce (nomeequipe, numeroedizione, cfanimatore, isresponsabile) VALUES ('Bans', 1, 'MSTMMI15H01F064B', false);
INSERT INTO afferisce (nomeequipe, numeroedizione, cfanimatore, isresponsabile) VALUES ('Bans', 1, 'PSSZNA95A41B637P', false);
INSERT INTO afferisce (nomeequipe, numeroedizione, cfanimatore, isresponsabile) VALUES ('Bans', 1, 'RSCPLG58S41G509D', false);
INSERT INTO afferisce (nomeequipe, numeroedizione, cfanimatore, isresponsabile) VALUES ('Bans', 2, 'PRMMRM21E41C002T', true);
INSERT INTO afferisce (nomeequipe, numeroedizione, cfanimatore, isresponsabile) VALUES ('Bans', 2, 'MLDLLN57A41Z101K', false);
INSERT INTO afferisce (nomeequipe, numeroedizione, cfanimatore, isresponsabile) VALUES ('Bans', 2, 'RMNKST19P01B114A', false);
INSERT INTO afferisce (nomeequipe, numeroedizione, cfanimatore, isresponsabile) VALUES ('Bans', 2, 'GRSMRS68L41D239P', false);
INSERT INTO afferisce (nomeequipe, numeroedizione, cfanimatore, isresponsabile) VALUES ('Bans', 2, 'MNSDRS84R41C359M', false);
INSERT INTO afferisce (nomeequipe, numeroedizione, cfanimatore, isresponsabile) VALUES ('Bans', 3, 'MNSDRS84R41C359M', true);
INSERT INTO afferisce (nomeequipe, numeroedizione, cfanimatore, isresponsabile) VALUES ('Bans', 3, 'BLRNRT47A41E336F', true);
INSERT INTO afferisce (nomeequipe, numeroedizione, cfanimatore, isresponsabile) VALUES ('Bans', 3, 'SCRPCR69R41L168B', true);
INSERT INTO afferisce (nomeequipe, numeroedizione, cfanimatore, isresponsabile) VALUES ('Bans', 3, 'CRCHDH18S01A373L', false);
INSERT INTO afferisce (nomeequipe, numeroedizione, cfanimatore, isresponsabile) VALUES ('Bans', 3, 'ZGRGBD70D01D684B', false);
INSERT INTO afferisce (nomeequipe, numeroedizione, cfanimatore, isresponsabile) VALUES ('Tecnici', 1, 'SLVHSK21E41M021S', true);
INSERT INTO afferisce (nomeequipe, numeroedizione, cfanimatore, isresponsabile) VALUES ('Tecnici', 1, 'RCANMR16C41H867T', false);
INSERT INTO afferisce (nomeequipe, numeroedizione, cfanimatore, isresponsabile) VALUES ('Tecnici', 2, 'LMSDRY84M41A071M', true);
INSERT INTO afferisce (nomeequipe, numeroedizione, cfanimatore, isresponsabile) VALUES ('Tecnici', 2, 'MNNVLT23A41G630D', false);
INSERT INTO afferisce (nomeequipe, numeroedizione, cfanimatore, isresponsabile) VALUES ('Tecnici', 3, 'RGGLNH89B41C303L', true);
INSERT INTO afferisce (nomeequipe, numeroedizione, cfanimatore, isresponsabile) VALUES ('Tecnici', 3, 'BLTHNA74S41D117G', false);
INSERT INTO afferisce (nomeequipe, numeroedizione, cfanimatore, isresponsabile) VALUES ('Tecnici', 3, 'ZGRGBD70D01D684B', false);

INSERT INTO partita (data, ora, nomesquadraa, edizionesquadraa, nomesquadrab, edizionesquadrab, squadravincitrice, edizionesquadravincitrice, nomegioco, cfarbitro) VALUES ('2021-06-21', '13:00:00', 'Tartaruga', 1, 'Regina Cuori', 1, 'Tartaruga', 1, 'Pallavolo', 'LMNDDV62A01D805Q');
INSERT INTO partita (data, ora, nomesquadraa, edizionesquadraa, nomesquadrab, edizionesquadrab, squadravincitrice, edizionesquadravincitrice, nomegioco, cfarbitro) VALUES ('2021-06-21', '15:00:00', 'Regina Bianca', 1, 'Grillo', 1, 'Regina Bianca', 1, 'Pallavolo', 'SNTTNE20P01B491F');
INSERT INTO partita (data, ora, nomesquadraa, edizionesquadraa, nomesquadrab, edizionesquadrab, squadravincitrice, edizionesquadravincitrice, nomegioco, cfarbitro) VALUES ('2021-06-22', '13:00:00', 'Giangi', 1, 'Gatto Cheshire', 1, 'Gatto Cheshire', 1, 'Pallavolo', 'LMNDDV62A01D805Q');
INSERT INTO partita (data, ora, nomesquadraa, edizionesquadraa, nomesquadrab, edizionesquadrab, squadravincitrice, edizionesquadravincitrice, nomegioco, cfarbitro) VALUES ('2021-06-22', '15:00:00', 'Dodo', 1, 'Cappellaio', 1, 'Cappellaio', 1, 'Pallavolo', 'SNTTNE20P01B491F');
INSERT INTO partita (data, ora, nomesquadraa, edizionesquadraa, nomesquadrab, edizionesquadrab, squadravincitrice, edizionesquadravincitrice, nomegioco, cfarbitro) VALUES ('2021-06-24', '13:00:00', 'Bruco', 1, 'Alice', 1, 'Bruco', 1, 'Pallavolo', 'GNTHRS96S01F761M');
INSERT INTO partita (data, ora, nomesquadraa, edizionesquadraa, nomesquadrab, edizionesquadrab, squadravincitrice, edizionesquadravincitrice, nomegioco, cfarbitro) VALUES ('2021-06-24', '15:00:00', 'Tartaruga', 1, 'Regina Bianca', 1, 'Tartaruga', 1, 'Lancio Vortex', 'SNTTNE20P01B491F');
INSERT INTO partita (data, ora, nomesquadraa, edizionesquadraa, nomesquadrab, edizionesquadrab, squadravincitrice, edizionesquadravincitrice, nomegioco, cfarbitro) VALUES ('2021-06-25', '13:00:00', 'Gatto Cheshire', 1, 'Cappellaio', 1, 'Gatto Cheshire', 1, 'Lancio Vortex', 'LTSRMN84C01Z601V');
INSERT INTO partita (data, ora, nomesquadraa, edizionesquadraa, nomesquadrab, edizionesquadrab, squadravincitrice, edizionesquadravincitrice, nomegioco, cfarbitro) VALUES ('2021-06-25', '15:00:00', 'Bruco', 1, 'Regina Cuori', 1, 'Bruco', 1, 'Lancio Vortex', 'SCHLRN16E41C680E');
INSERT INTO partita (data, ora, nomesquadraa, edizionesquadraa, nomesquadrab, edizionesquadrab, squadravincitrice, edizionesquadravincitrice, nomegioco, cfarbitro) VALUES ('2021-06-28', '13:00:00', 'Grillo', 1, 'Giangi', 1, 'Giangi', 1, 'Lancio Vortex', 'SNTTNE20P01B491F');
INSERT INTO partita (data, ora, nomesquadraa, edizionesquadraa, nomesquadrab, edizionesquadrab, squadravincitrice, edizionesquadravincitrice, nomegioco, cfarbitro) VALUES ('2021-06-28', '15:00:00', 'Dodo', 1, 'Alice', 1, 'Alice', 1, 'Lancio Vortex', 'GNTHRS96S01F761M');
INSERT INTO partita (data, ora, nomesquadraa, edizionesquadraa, nomesquadrab, edizionesquadrab, squadravincitrice, edizionesquadravincitrice, nomegioco, cfarbitro) VALUES ('2021-06-29', '13:00:00', 'Tartaruga', 1, 'Grillo', 1, 'Tartaruga', 1, 'Rigori', 'LTSRMN84C01Z601V');
INSERT INTO partita (data, ora, nomesquadraa, edizionesquadraa, nomesquadrab, edizionesquadrab, squadravincitrice, edizionesquadravincitrice, nomegioco, cfarbitro) VALUES ('2021-06-29', '15:00:00', 'Regina Bianca', 1, 'Giangi', 1, 'Regina Bianca', 1, 'Rigori', 'GNTHRS96S01F761M');
INSERT INTO partita (data, ora, nomesquadraa, edizionesquadraa, nomesquadrab, edizionesquadrab, squadravincitrice, edizionesquadravincitrice, nomegioco, cfarbitro) VALUES ('2021-07-01', '13:00:00', 'Dodo', 1, 'Regina Cuori', 1, 'Dodo', 1, 'Rigori', 'LTSRMN84C01Z601V');
INSERT INTO partita (data, ora, nomesquadraa, edizionesquadraa, nomesquadrab, edizionesquadrab, squadravincitrice, edizionesquadravincitrice, nomegioco, cfarbitro) VALUES ('2021-07-01', '15:00:00', 'Bruco', 1, 'Gatto Cheshire', 1, 'Bruco', 1, 'Rigori', 'LMNDDV62A01D805Q');
INSERT INTO partita (data, ora, nomesquadraa, edizionesquadraa, nomesquadrab, edizionesquadrab, squadravincitrice, edizionesquadravincitrice, nomegioco, cfarbitro) VALUES ('2021-07-02', '13:00:00', 'Cappellaio', 1, 'Alice', 1, 'Cappellaio', 1, 'Rigori', 'GNTHRS96S01F761M');
INSERT INTO partita (data, ora, nomesquadraa, edizionesquadraa, nomesquadrab, edizionesquadrab, squadravincitrice, edizionesquadravincitrice, nomegioco, cfarbitro) VALUES ('2021-07-02', '15:00:00', 'Tartaruga', 1, 'Gatto Cheshire', 1, 'Gatto Cheshire', 1, 'Baseball', 'LMNDDV62A01D805Q');
INSERT INTO partita (data, ora, nomesquadraa, edizionesquadraa, nomesquadrab, edizionesquadrab, squadravincitrice, edizionesquadravincitrice, nomegioco, cfarbitro) VALUES ('2021-07-02', '15:00:00', 'Grillo', 1, 'Dodo', 1, 'Dodo', 1, 'Baseball', 'SCHLRN16E41C680E');
INSERT INTO partita (data, ora, nomesquadraa, edizionesquadraa, nomesquadrab, edizionesquadrab, squadravincitrice, edizionesquadravincitrice, nomegioco, cfarbitro) VALUES ('2021-07-02', '15:00:00', 'Regina Bianca', 1, 'Regina Cuori', 1, 'Regina Cuori', 1, 'Baseball', 'LMNDDV62A01D805Q');
INSERT INTO partita (data, ora, nomesquadraa, edizionesquadraa, nomesquadrab, edizionesquadrab, squadravincitrice, edizionesquadravincitrice, nomegioco, cfarbitro) VALUES ('2021-07-02', '15:00:00', 'Bruco', 1, 'Cappellaio', 1, 'Cappellaio', 1, 'Baseball', 'GNTHRS96S01F761M');
INSERT INTO partita (data, ora, nomesquadraa, edizionesquadraa, nomesquadrab, edizionesquadrab, squadravincitrice, edizionesquadravincitrice, nomegioco, cfarbitro) VALUES ('2021-07-02', '15:00:00', 'Alice', 1, 'Giangi', 1, 'Giangi', 1, 'Baseball', 'SNTTNE20P01B491F');
INSERT INTO partita (data, ora, nomesquadraa, edizionesquadraa, nomesquadrab, edizionesquadrab, squadravincitrice, edizionesquadravincitrice, nomegioco, cfarbitro) VALUES ('2022-06-20', '13:00:00', 'Proplayer', 2, 'Zelda', 2, 'Proplayer', 2, 'Naufraghi', 'CPBGNN97L01B025E');
INSERT INTO partita (data, ora, nomesquadraa, edizionesquadraa, nomesquadrab, edizionesquadrab, squadravincitrice, edizionesquadravincitrice, nomegioco, cfarbitro) VALUES ('2022-06-20', '15:00:00', 'Pro Fortnite', 2, 'Pacman', 2, 'Pro Fortnite', 2, 'Naufraghi', 'PLSLXA66R41L845M');
INSERT INTO partita (data, ora, nomesquadraa, edizionesquadraa, nomesquadrab, edizionesquadrab, squadravincitrice, edizionesquadravincitrice, nomegioco, cfarbitro) VALUES ('2022-06-21', '13:00:00', 'Creeper', 2, 'Team Bros', 2, 'Team Bros', 2, 'Naufraghi', 'CPBGNN97L01B025E');
INSERT INTO partita (data, ora, nomesquadraa, edizionesquadraa, nomesquadrab, edizionesquadrab, squadravincitrice, edizionesquadravincitrice, nomegioco, cfarbitro) VALUES ('2022-06-21', '15:00:00', 'Luckylama', 2, 'Royale Squad', 2, 'Luckylama', 2, 'Naufraghi', 'PRMMRM21E41C002T');
INSERT INTO partita (data, ora, nomesquadraa, edizionesquadraa, nomesquadrab, edizionesquadrab, squadravincitrice, edizionesquadravincitrice, nomegioco, cfarbitro) VALUES ('2022-06-22', '13:00:00', 'Green Links', 2, 'Hackerman', 2, 'Green Links', 2, 'Naufraghi', 'SNCDNN97C01I565J');
INSERT INTO partita (data, ora, nomesquadraa, edizionesquadraa, nomesquadrab, edizionesquadrab, squadravincitrice, edizionesquadravincitrice, nomegioco, cfarbitro) VALUES ('2022-06-22', '15:00:00', 'Proplayer', 2, 'Pro Fortnite', 2, 'Pro Fortnite', 2, 'Bandiera', 'CPBGNN97L01B025E');
INSERT INTO partita (data, ora, nomesquadraa, edizionesquadraa, nomesquadrab, edizionesquadrab, squadravincitrice, edizionesquadravincitrice, nomegioco, cfarbitro) VALUES ('2022-06-23', '13:00:00', 'Team Bros', 2, 'Royale Squad', 2, 'Royale Squad', 2, 'Bandiera', 'PRMMRM21E41C002T');
INSERT INTO partita (data, ora, nomesquadraa, edizionesquadraa, nomesquadrab, edizionesquadrab, squadravincitrice, edizionesquadravincitrice, nomegioco, cfarbitro) VALUES ('2022-06-23', '15:00:00', 'Green Links', 2, 'Zelda', 2, 'Zelda', 2, 'Bandiera', 'CPBGNN97L01B025E');
INSERT INTO partita (data, ora, nomesquadraa, edizionesquadraa, nomesquadrab, edizionesquadrab, squadravincitrice, edizionesquadravincitrice, nomegioco, cfarbitro) VALUES ('2022-06-27', '13:00:00', 'Pacman', 2, 'Creeper', 2, 'Creeper', 2, 'Bandiera', 'PLSLXA66R41L845M');
INSERT INTO partita (data, ora, nomesquadraa, edizionesquadraa, nomesquadrab, edizionesquadrab, squadravincitrice, edizionesquadravincitrice, nomegioco, cfarbitro) VALUES ('2022-06-27', '15:00:00', 'Luckylama', 2, 'Hackerman', 2, 'Hackerman', 2, 'Bandiera', 'PRMMRM21E41C002T');
INSERT INTO partita (data, ora, nomesquadraa, edizionesquadraa, nomesquadrab, edizionesquadrab, squadravincitrice, edizionesquadravincitrice, nomegioco, cfarbitro) VALUES ('2022-06-28', '13:00:00', 'Proplayer', 2, 'Pacman', 2, 'Pacman', 2, 'Ciechi', 'PLSLXA66R41L845M');
INSERT INTO partita (data, ora, nomesquadraa, edizionesquadraa, nomesquadrab, edizionesquadrab, squadravincitrice, edizionesquadravincitrice, nomegioco, cfarbitro) VALUES ('2022-06-28', '15:00:00', 'Pro Fortnite', 2, 'Creeper', 2, 'Creeper', 2, 'Ciechi', 'PRMMRM21E41C002T');
INSERT INTO partita (data, ora, nomesquadraa, edizionesquadraa, nomesquadrab, edizionesquadrab, squadravincitrice, edizionesquadravincitrice, nomegioco, cfarbitro) VALUES ('2022-06-29', '13:00:00', 'Luckylama', 2, 'Zelda', 2, 'Zelda', 2, 'Ciechi', 'CPBGNN97L01B025E');
INSERT INTO partita (data, ora, nomesquadraa, edizionesquadraa, nomesquadrab, edizionesquadrab, squadravincitrice, edizionesquadravincitrice, nomegioco, cfarbitro) VALUES ('2022-06-29', '15:00:00', 'Green Links', 2, 'Team Bros', 2, 'Green Links', 2, 'Ciechi', 'TRPBRC27R41D221B');
INSERT INTO partita (data, ora, nomesquadraa, edizionesquadraa, nomesquadrab, edizionesquadrab, squadravincitrice, edizionesquadravincitrice, nomegioco, cfarbitro) VALUES ('2022-06-30', '13:00:00', 'Royale Squad', 2, 'Hackerman', 2, 'Royale Squad', 2, 'Ciechi', 'CPBGNN97L01B025E');
INSERT INTO partita (data, ora, nomesquadraa, edizionesquadraa, nomesquadrab, edizionesquadrab, squadravincitrice, edizionesquadravincitrice, nomegioco, cfarbitro) VALUES ('2022-06-30', '15:00:00', 'Proplayer', 2, 'Team Bros', 2, 'Team Bros', 2, 'Fazzoletto', 'PLSLXA66R41L845M');
INSERT INTO partita (data, ora, nomesquadraa, edizionesquadraa, nomesquadrab, edizionesquadrab, squadravincitrice, edizionesquadravincitrice, nomegioco, cfarbitro) VALUES ('2022-07-04', '13:00:00', 'Pacman', 2, 'Luckylama', 2, 'Luckylama', 2, 'Fazzoletto', 'PRMMRM21E41C002T');
INSERT INTO partita (data, ora, nomesquadraa, edizionesquadraa, nomesquadrab, edizionesquadrab, squadravincitrice, edizionesquadravincitrice, nomegioco, cfarbitro) VALUES ('2022-07-04', '15:00:00', 'Pro Fortnite', 2, 'Zelda', 2, 'Zelda', 2, 'Fazzoletto', 'TRPBRC27R41D221B');
INSERT INTO partita (data, ora, nomesquadraa, edizionesquadraa, nomesquadrab, edizionesquadrab, squadravincitrice, edizionesquadravincitrice, nomegioco, cfarbitro) VALUES ('2022-07-05', '13:00:00', 'Green Links', 2, 'Royale Squad', 2, 'Royale Squad', 2, 'Fazzoletto', 'PRMMRM21E41C002T');
INSERT INTO partita (data, ora, nomesquadraa, edizionesquadraa, nomesquadrab, edizionesquadrab, squadravincitrice, edizionesquadravincitrice, nomegioco, cfarbitro) VALUES ('2022-07-05', '15:00:00', 'Hackerman', 2, 'Creeper', 2, 'Creeper', 2, 'Fazzoletto', 'CPBGNN97L01B025E');
INSERT INTO partita (data, ora, nomesquadraa, edizionesquadraa, nomesquadrab, edizionesquadrab, squadravincitrice, edizionesquadravincitrice, nomegioco, cfarbitro) VALUES ('2023-06-19', '13:00:00', 'Principi dei Sogni', 3, 'Sognatori Chill', 3, 'Principi dei Sogni', 3, 'Beach Volley', 'VNALVR25M41C244K');
INSERT INTO partita (data, ora, nomesquadraa, edizionesquadraa, nomesquadrab, edizionesquadrab, squadravincitrice, edizionesquadravincitrice, nomegioco, cfarbitro) VALUES ('2023-06-19', '15:00:00', 'Followme', 3, 'Risorgivi', 3, 'Followme', 3, 'Beach Volley', 'SBBSHJ84M41I256F');
INSERT INTO partita (data, ora, nomesquadraa, edizionesquadraa, nomesquadrab, edizionesquadrab, squadravincitrice, edizionesquadravincitrice, nomegioco, cfarbitro) VALUES ('2023-06-20', '13:00:00', 'Da cosi a cosi', 3, 'Sognatori', 3, 'Sognatori', 3, 'Beach Volley', 'PRTMTG94T41A335C');
INSERT INTO partita (data, ora, nomesquadraa, edizionesquadraa, nomesquadrab, edizionesquadrab, squadravincitrice, edizionesquadravincitrice, nomegioco, cfarbitro) VALUES ('2023-06-20', '15:00:00', 'Alibabibbia', 3, 'Piccoli Apostoli', 3, 'Piccoli Apostoli', 3, 'Beach Volley', 'VNALVR25M41C244K');
INSERT INTO partita (data, ora, nomesquadraa, edizionesquadraa, nomesquadrab, edizionesquadrab, squadravincitrice, edizionesquadravincitrice, nomegioco, cfarbitro) VALUES ('2023-06-21', '13:00:00', 'Boss dei Sogni', 3, 'Profeti di IG', 3, 'Boss dei Sogni', 3, 'Beach Volley', 'SBBSHJ84M41I256F');
INSERT INTO partita (data, ora, nomesquadraa, edizionesquadraa, nomesquadrab, edizionesquadrab, squadravincitrice, edizionesquadravincitrice, nomegioco, cfarbitro) VALUES ('2023-06-21', '15:00:00', 'Principi dei Sogni', 3, 'Followme', 3, 'Principi dei Sogni', 3, 'Guelfi e Ghibellini', 'BNMZHE10P41B048F');
INSERT INTO partita (data, ora, nomesquadraa, edizionesquadraa, nomesquadrab, edizionesquadrab, squadravincitrice, edizionesquadravincitrice, nomegioco, cfarbitro) VALUES ('2023-06-22', '13:00:00', 'Sognatori', 3, 'Piccoli Apostoli', 3, 'Piccoli Apostoli', 3, 'Guelfi e Ghibellini', 'VNALVR25M41C244K');
INSERT INTO partita (data, ora, nomesquadraa, edizionesquadraa, nomesquadrab, edizionesquadrab, squadravincitrice, edizionesquadravincitrice, nomegioco, cfarbitro) VALUES ('2023-06-22', '15:00:00', 'Boss dei Sogni', 3, 'Sognatori Chill', 3, 'Boss dei Sogni', 3, 'Guelfi e Ghibellini', 'PRTMTG94T41A335C');
INSERT INTO partita (data, ora, nomesquadraa, edizionesquadraa, nomesquadrab, edizionesquadrab, squadravincitrice, edizionesquadravincitrice, nomegioco, cfarbitro) VALUES ('2023-06-23', '13:00:00', 'Risorgivi', 3, 'Da cosi a cosi', 3, 'Da cosi a cosi', 3, 'Guelfi e Ghibellini', 'MRDNVT90S41I321I');
INSERT INTO partita (data, ora, nomesquadraa, edizionesquadraa, nomesquadrab, edizionesquadrab, squadravincitrice, edizionesquadravincitrice, nomegioco, cfarbitro) VALUES ('2023-06-23', '15:00:00', 'Alibabibbia', 3, 'Profeti di IG', 3, 'Alibabibbia', 3, 'Guelfi e Ghibellini', 'VNALVR25M41C244K');
INSERT INTO partita (data, ora, nomesquadraa, edizionesquadraa, nomesquadrab, edizionesquadrab, squadravincitrice, edizionesquadravincitrice, nomegioco, cfarbitro) VALUES ('2023-06-27', '13:00:00', 'Principi dei Sogni', 3, 'Risorgivi', 3, 'Principi dei Sogni', 3, 'Castelli', 'PRTMTG94T41A335C');
INSERT INTO partita (data, ora, nomesquadraa, edizionesquadraa, nomesquadrab, edizionesquadrab, squadravincitrice, edizionesquadravincitrice, nomegioco, cfarbitro) VALUES ('2023-06-27', '15:00:00', 'Followme', 3, 'Da cosi a cosi', 3, 'Da cosi a cosi', 3, 'Castelli', 'MRDNVT90S41I321I');
INSERT INTO partita (data, ora, nomesquadraa, edizionesquadraa, nomesquadrab, edizionesquadrab, squadravincitrice, edizionesquadravincitrice, nomegioco, cfarbitro) VALUES ('2023-06-28', '13:00:00', 'Alibabibbia', 3, 'Sognatori Chill', 3, 'Sognatori Chill', 3, 'Castelli', 'VNALVR25M41C244K');
INSERT INTO partita (data, ora, nomesquadraa, edizionesquadraa, nomesquadrab, edizionesquadrab, squadravincitrice, edizionesquadravincitrice, nomegioco, cfarbitro) VALUES ('2023-06-28', '15:00:00', 'Boss dei Sogni', 3, 'Sognatori', 3, 'Boss dei Sogni', 3, 'Castelli', 'MRDNVT90S41I321I');
INSERT INTO partita (data, ora, nomesquadraa, edizionesquadraa, nomesquadrab, edizionesquadrab, squadravincitrice, edizionesquadravincitrice, nomegioco, cfarbitro) VALUES ('2023-06-29', '13:00:00', 'Piccoli Apostoli', 3, 'Profeti di IG', 3, 'Piccoli Apostoli', 3, 'Castelli', 'SBBSHJ84M41I256F');
INSERT INTO partita (data, ora, nomesquadraa, edizionesquadraa, nomesquadrab, edizionesquadrab, squadravincitrice, edizionesquadravincitrice, nomegioco, cfarbitro) VALUES ('2023-06-29', '15:00:00', 'Principi dei Sogni', 3, 'Sognatori', 3, 'Sognatori', 3, 'Ragnatela', 'PRTMTG94T41A335C');
INSERT INTO partita (data, ora, nomesquadraa, edizionesquadraa, nomesquadrab, edizionesquadrab, squadravincitrice, edizionesquadravincitrice, nomegioco, cfarbitro) VALUES ('2023-06-30', '13:00:00', 'Risorgivi', 3, 'Alibabibbia', 3, 'Alibabibbia', 3, 'Ragnatela', 'SBBSHJ84M41I256F');
INSERT INTO partita (data, ora, nomesquadraa, edizionesquadraa, nomesquadrab, edizionesquadrab, squadravincitrice, edizionesquadravincitrice, nomegioco, cfarbitro) VALUES ('2023-06-30', '15:00:00', 'Followme', 3, 'Sognatori Chill', 3, 'Followme', 3, 'Ragnatela', 'VNALVR25M41C244K');
INSERT INTO partita (data, ora, nomesquadraa, edizionesquadraa, nomesquadrab, edizionesquadrab, squadravincitrice, edizionesquadravincitrice, nomegioco, cfarbitro) VALUES ('2023-07-04', '13:00:00', 'Boss dei Sogni', 3, 'Piccoli Apostoli', 3, 'Piccoli Apostoli', 3, 'Ragnatela', 'PRTMTG94T41A335C');
INSERT INTO partita (data, ora, nomesquadraa, edizionesquadraa, nomesquadrab, edizionesquadrab, squadravincitrice, edizionesquadravincitrice, nomegioco, cfarbitro) VALUES ('2023-07-04', '15:00:00', 'Profeti di IG', 3, 'Da cosi a cosi', 3, 'Profeti di IG', 3, 'Ragnatela', 'SBBSHJ84M41I256F');

INSERT INTO partecipa (nomeuscita, datauscita, cfpartecipante) VALUES ('ConcaVerde', '2021-06-23', 'RSSMRC11A01C517R');
INSERT INTO partecipa (nomeuscita, datauscita, cfpartecipante) VALUES ('ConcaVerde', '2021-06-23', 'VLLFNC12B02C745D');
INSERT INTO partecipa (nomeuscita, datauscita, cfpartecipante) VALUES ('ConcaVerde', '2021-06-23', 'NRGSTF15E05C517R');
INSERT INTO partecipa (nomeuscita, datauscita, cfpartecipante) VALUES ('ConcaVerde', '2021-06-23', 'BTTLRA16F06C224M');
INSERT INTO partecipa (nomeuscita, datauscita, cfpartecipante) VALUES ('ConcaVerde', '2021-06-23', 'MLTFRN12I09C745D');
INSERT INTO partecipa (nomeuscita, datauscita, cfpartecipante) VALUES ('ConcaVerde', '2021-06-23', 'DLPCRS15N12C745D');
INSERT INTO partecipa (nomeuscita, datauscita, cfpartecipante) VALUES ('ConcaVerde', '2021-06-23', 'STRLUC16P13C517R');
INSERT INTO partecipa (nomeuscita, datauscita, cfpartecipante) VALUES ('ConcaVerde', '2021-06-23', 'PTTFRN13T17C224M');
INSERT INTO partecipa (nomeuscita, datauscita, cfpartecipante) VALUES ('ConcaVerde', '2021-06-23', 'GRGFNC17N01C745D');
INSERT INTO partecipa (nomeuscita, datauscita, cfpartecipante) VALUES ('ConcaVerde', '2021-06-23', 'MLTFRN12P03C224M');
INSERT INTO partecipa (nomeuscita, datauscita, cfpartecipante) VALUES ('ConcaVerde', '2021-06-23', 'DLPCRS15S06C224M');
INSERT INTO partecipa (nomeuscita, datauscita, cfpartecipante) VALUES ('Aquaestate', '2021-06-30', 'GRGFNC17G07C517R');
INSERT INTO partecipa (nomeuscita, datauscita, cfpartecipante) VALUES ('Aquaestate', '2021-06-30', 'BNCMRA13C03G224M');
INSERT INTO partecipa (nomeuscita, datauscita, cfpartecipante) VALUES ('Aquaestate', '2021-06-30', 'CNTRNS11H08C224M');
INSERT INTO partecipa (nomeuscita, datauscita, cfpartecipante) VALUES ('Aquaestate', '2021-06-30', 'DLPCRS15N12C745D');
INSERT INTO partecipa (nomeuscita, datauscita, cfpartecipante) VALUES ('Aquaestate', '2021-06-30', 'GNRCRS12S16C517R');
INSERT INTO partecipa (nomeuscita, datauscita, cfpartecipante) VALUES ('Aquaestate', '2021-06-30', 'GRNGRN16W20C224M');
INSERT INTO partecipa (nomeuscita, datauscita, cfpartecipante) VALUES ('Aquaestate', '2021-06-30', 'CNDRSS17X21C745D');
INSERT INTO partecipa (nomeuscita, datauscita, cfpartecipante) VALUES ('ConcaVerde', '2022-06-25', 'BNCSLF11Y22C517R');
INSERT INTO partecipa (nomeuscita, datauscita, cfpartecipante) VALUES ('ConcaVerde', '2022-06-25', 'TRMBRN12Z23C224M');
INSERT INTO partecipa (nomeuscita, datauscita, cfpartecipante) VALUES ('ConcaVerde', '2022-06-25', 'MRNGRG13A24C745D');
INSERT INTO partecipa (nomeuscita, datauscita, cfpartecipante) VALUES ('ConcaVerde', '2022-06-25', 'LNZRCC14B25C517R');
INSERT INTO partecipa (nomeuscita, datauscita, cfpartecipante) VALUES ('ConcaVerde', '2022-06-25', 'VRDRCC15C26C224M');
INSERT INTO partecipa (nomeuscita, datauscita, cfpartecipante) VALUES ('ConcaVerde', '2022-06-25', 'GNTRSS11F29C224M');
INSERT INTO partecipa (nomeuscita, datauscita, cfpartecipante) VALUES ('ConcaVerde', '2022-06-25', 'VLLMRC15Z13C745D');
INSERT INTO partecipa (nomeuscita, datauscita, cfpartecipante) VALUES ('ConcaVerde', '2022-06-25', 'GRNGRN16A14C517R');
INSERT INTO partecipa (nomeuscita, datauscita, cfpartecipante) VALUES ('Aquaestate', '2022-07-03', 'STRLUC16R10C224M');
INSERT INTO partecipa (nomeuscita, datauscita, cfpartecipante) VALUES ('Aquaestate', '2022-07-03', 'DLPCRS15Q09C517R');
INSERT INTO partecipa (nomeuscita, datauscita, cfpartecipante) VALUES ('Aquaestate', '2022-07-03', 'LLVFNC14P08C745D');
INSERT INTO partecipa (nomeuscita, datauscita, cfpartecipante) VALUES ('Aquaestate', '2022-07-03', 'MLTFRN12N06C517R');
INSERT INTO partecipa (nomeuscita, datauscita, cfpartecipante) VALUES ('Aquaestate', '2022-07-03', 'PRNGBR13O07C224M');
INSERT INTO partecipa (nomeuscita, datauscita, cfpartecipante) VALUES ('Aquaestate', '2023-07-05', 'BCCCLD17S11C745D');
INSERT INTO partecipa (nomeuscita, datauscita, cfpartecipante) VALUES ('Aquaestate', '2023-07-05', 'RZZFRN11T12C517R');
INSERT INTO partecipa (nomeuscita, datauscita, cfpartecipante) VALUES ('Aquaestate', '2023-07-05', 'PTTFRN13V14C745D');
INSERT INTO partecipa (nomeuscita, datauscita, cfpartecipante) VALUES ('Aquaestate', '2023-07-05', 'GNRCRS12U13C224M');
INSERT INTO partecipa (nomeuscita, datauscita, cfpartecipante) VALUES ('ConcaVerde', '2023-06-28', 'GRDFNC14W15C517R');
INSERT INTO partecipa (nomeuscita, datauscita, cfpartecipante) VALUES ('ConcaVerde', '2023-06-28', 'VLLMRC15X16C224M');
INSERT INTO partecipa (nomeuscita, datauscita, cfpartecipante) VALUES ('ConcaVerde', '2023-06-28', 'GRNGRN16Y17C745D');
INSERT INTO partecipa (nomeuscita, datauscita, cfpartecipante) VALUES ('ConcaVerde', '2023-06-28', 'CNDRSS17Z18C517R');
INSERT INTO partecipa (nomeuscita, datauscita, cfpartecipante) VALUES ('ConcaVerde', '2023-06-28', 'BNCSLF11A19C224M');

INSERT INTO accompagna (nomeuscita, datauscita, cfanimatore) VALUES ('Aquaestate', '2021-06-30', 'GRSMRS68L41D239P');
INSERT INTO accompagna (nomeuscita, datauscita, cfanimatore) VALUES ('Aquaestate', '2021-06-30', 'MLDLLN57A41Z101K');
INSERT INTO accompagna (nomeuscita, datauscita, cfanimatore) VALUES ('Aquaestate', '2021-06-30', 'BLRNRT47A41E336F');
INSERT INTO accompagna (nomeuscita, datauscita, cfanimatore) VALUES ('Aquaestate', '2021-06-30', 'GNTHRS96S01F761M');
INSERT INTO accompagna (nomeuscita, datauscita, cfanimatore) VALUES ('Aquaestate', '2022-07-03', 'MLDLLN57A41Z101K');
INSERT INTO accompagna (nomeuscita, datauscita, cfanimatore) VALUES ('Aquaestate', '2022-07-03', 'GRSMRS68L41D239P');
INSERT INTO accompagna (nomeuscita, datauscita, cfanimatore) VALUES ('Aquaestate', '2022-07-03', 'SCRPCR69R41L168B');
INSERT INTO accompagna (nomeuscita, datauscita, cfanimatore) VALUES ('Aquaestate', '2022-07-03', 'CRCHDH18S01A373L');
INSERT INTO accompagna (nomeuscita, datauscita, cfanimatore) VALUES ('Aquaestate', '2022-07-03', 'ZGRGBD70D01D684B');
INSERT INTO accompagna (nomeuscita, datauscita, cfanimatore) VALUES ('Aquaestate', '2023-07-05', 'RCANMR16C41H867T');
INSERT INTO accompagna (nomeuscita, datauscita, cfanimatore) VALUES ('Aquaestate', '2023-07-05', 'MNNVLT23A41G630D');
INSERT INTO accompagna (nomeuscita, datauscita, cfanimatore) VALUES ('Aquaestate', '2023-07-05', 'RGGLNH89B41C303L');
INSERT INTO accompagna (nomeuscita, datauscita, cfanimatore) VALUES ('Aquaestate', '2023-07-05', 'LMNDDV62A01D805Q');
INSERT INTO accompagna (nomeuscita, datauscita, cfanimatore) VALUES ('ConcaVerde', '2023-06-28', 'LMNDDV62A01D805Q');
INSERT INTO accompagna (nomeuscita, datauscita, cfanimatore) VALUES ('ConcaVerde', '2023-06-28', 'SNTTNE20P01B491F');
INSERT INTO accompagna (nomeuscita, datauscita, cfanimatore) VALUES ('ConcaVerde', '2023-06-28', 'LTSRMN84C01Z601V');
INSERT INTO accompagna (nomeuscita, datauscita, cfanimatore) VALUES ('ConcaVerde', '2023-06-28', 'PRMMRM21E41C002T');
INSERT INTO accompagna (nomeuscita, datauscita, cfanimatore) VALUES ('ConcaVerde', '2022-06-25', 'PRMMRM21E41C002T');
INSERT INTO accompagna (nomeuscita, datauscita, cfanimatore) VALUES ('ConcaVerde', '2022-06-25', 'PLSLXA66R41L845M');
INSERT INTO accompagna (nomeuscita, datauscita, cfanimatore) VALUES ('ConcaVerde', '2022-06-25', 'VNALVR25M41C244K');
INSERT INTO accompagna (nomeuscita, datauscita, cfanimatore) VALUES ('ConcaVerde', '2022-06-25', 'BNMZHE10P41B048F');
INSERT INTO accompagna (nomeuscita, datauscita, cfanimatore) VALUES ('ConcaVerde', '2021-06-23', 'BNMZHE10P41B048F');
INSERT INTO accompagna (nomeuscita, datauscita, cfanimatore) VALUES ('ConcaVerde', '2021-06-23', 'CRCHDH18S01A373L');
INSERT INTO accompagna (nomeuscita, datauscita, cfanimatore) VALUES ('ConcaVerde', '2021-06-23', 'SLVHSK21E41M021S');
INSERT INTO accompagna (nomeuscita, datauscita, cfanimatore) VALUES ('ConcaVerde', '2021-06-23', 'MNNVLT23A41G630D');
INSERT INTO accompagna (nomeuscita, datauscita, cfanimatore) VALUES ('ConcaVerde', '2021-06-23', 'BLTHNA74S41D117G');

INSERT INTO collabora (nomelaboratorio, numeroedizione, cfanimatore) VALUES ('Decoupage', 1, 'BLRNRT47A41E336F');
INSERT INTO collabora (nomelaboratorio, numeroedizione, cfanimatore) VALUES ('Decoupage', 1, 'BLTHNA74S41D117G');
INSERT INTO collabora (nomelaboratorio, numeroedizione, cfanimatore) VALUES ('Decoupage', 1, 'BNMZHE10P41B048F');
INSERT INTO collabora (nomelaboratorio, numeroedizione, cfanimatore) VALUES ('Elettricista', 1, 'CPBGNN97L01B025E');
INSERT INTO collabora (nomelaboratorio, numeroedizione, cfanimatore) VALUES ('Elettricista', 1, 'CRCHDH18S01A373L');
INSERT INTO collabora (nomelaboratorio, numeroedizione, cfanimatore) VALUES ('Elettricista', 1, 'GNTHRS96S01F761M');
INSERT INTO collabora (nomelaboratorio, numeroedizione, cfanimatore) VALUES ('Falegname', 1, 'GRSMRS68L41D239P');
INSERT INTO collabora (nomelaboratorio, numeroedizione, cfanimatore) VALUES ('Falegname', 1, 'GTNFLI20A41E434C');
INSERT INTO collabora (nomelaboratorio, numeroedizione, cfanimatore) VALUES ('Falegname', 1, 'LMNDDV62A01D805Q');
INSERT INTO collabora (nomelaboratorio, numeroedizione, cfanimatore) VALUES ('Filografia', 1, 'LMSDRY84M41A071M');
INSERT INTO collabora (nomelaboratorio, numeroedizione, cfanimatore) VALUES ('Filografia', 1, 'MLDLLN57A41Z101K');
INSERT INTO collabora (nomelaboratorio, numeroedizione, cfanimatore) VALUES ('Filografia', 1, 'BNMZHE10P41B048F');
INSERT INTO collabora (nomelaboratorio, numeroedizione, cfanimatore) VALUES ('Magliette Schizzate', 1, 'MNNVLT23A41G630D');
INSERT INTO collabora (nomelaboratorio, numeroedizione, cfanimatore) VALUES ('Magliette Schizzate', 1, 'MNSDRS84R41C359M');
INSERT INTO collabora (nomelaboratorio, numeroedizione, cfanimatore) VALUES ('Magliette Schizzate', 1, 'MRDNVT90S41I321I');
INSERT INTO collabora (nomelaboratorio, numeroedizione, cfanimatore) VALUES ('Tecnoled', 1, 'PRTMTG94T41A335C');
INSERT INTO collabora (nomelaboratorio, numeroedizione, cfanimatore) VALUES ('Tecnoled', 1, 'PSSZNA95A41B637P');
INSERT INTO collabora (nomelaboratorio, numeroedizione, cfanimatore) VALUES ('Tecnoled', 1, 'RCANMR16C41H867T');
INSERT INTO collabora (nomelaboratorio, numeroedizione, cfanimatore) VALUES ('Casette Miniatura', 2, 'BLRNRT47A41E336F');
INSERT INTO collabora (nomelaboratorio, numeroedizione, cfanimatore) VALUES ('Decoupage', 2, 'BLTHNA74S41D117G');
INSERT INTO collabora (nomelaboratorio, numeroedizione, cfanimatore) VALUES ('Pirografia', 2, 'BNMZHE10P41B048F');
INSERT INTO collabora (nomelaboratorio, numeroedizione, cfanimatore) VALUES ('Casette Miniatura', 2, 'CPBGNN97L01B025E');
INSERT INTO collabora (nomelaboratorio, numeroedizione, cfanimatore) VALUES ('Magliette Schizzate', 2, 'CRCHDH18S01A373L');
INSERT INTO collabora (nomelaboratorio, numeroedizione, cfanimatore) VALUES ('Tecnoled', 2, 'GNTHRS96S01F761M');
INSERT INTO collabora (nomelaboratorio, numeroedizione, cfanimatore) VALUES ('Casette Miniatura', 2, 'GRSMRS68L41D239P');
INSERT INTO collabora (nomelaboratorio, numeroedizione, cfanimatore) VALUES ('Tecnoled', 2, 'SNTTNE20P01B491F');
INSERT INTO collabora (nomelaboratorio, numeroedizione, cfanimatore) VALUES ('Pirografia', 2, 'LMNDDV62A01D805Q');
INSERT INTO collabora (nomelaboratorio, numeroedizione, cfanimatore) VALUES ('Falegname', 2, 'LMSDRY84M41A071M');
INSERT INTO collabora (nomelaboratorio, numeroedizione, cfanimatore) VALUES ('Tecnoled', 2, 'MLDLLN57A41Z101K');
INSERT INTO collabora (nomelaboratorio, numeroedizione, cfanimatore) VALUES ('MasterChef', 2, 'BNMZHE10P41B048F');
INSERT INTO collabora (nomelaboratorio, numeroedizione, cfanimatore) VALUES ('Magliette Schizzate', 2, 'MNNVLT23A41G630D');
INSERT INTO collabora (nomelaboratorio, numeroedizione, cfanimatore) VALUES ('Falegname', 2, 'MNSDRS84R41C359M');
INSERT INTO collabora (nomelaboratorio, numeroedizione, cfanimatore) VALUES ('Decoupage', 2, 'MRDNVT90S41I321I');
INSERT INTO collabora (nomelaboratorio, numeroedizione, cfanimatore) VALUES ('MasterChef', 2, 'ZGRGBD70D01D684B');
INSERT INTO collabora (nomelaboratorio, numeroedizione, cfanimatore) VALUES ('Magliette Schizzate', 2, 'PLSLXA66R41L845M');
INSERT INTO collabora (nomelaboratorio, numeroedizione, cfanimatore) VALUES ('Decoupage', 2, 'PRMMRM21E41C002T');
INSERT INTO collabora (nomelaboratorio, numeroedizione, cfanimatore) VALUES ('Falegname', 2, 'SCRPCR69R41L168B');
INSERT INTO collabora (nomelaboratorio, numeroedizione, cfanimatore) VALUES ('MasterChef', 2, 'PSSZNA95A41B637P');
INSERT INTO collabora (nomelaboratorio, numeroedizione, cfanimatore) VALUES ('Pirografia', 2, 'RCANMR16C41H867T');
INSERT INTO collabora (nomelaboratorio, numeroedizione, cfanimatore) VALUES ('Braccialetti', 3, 'BLRNRT47A41E336F');
INSERT INTO collabora (nomelaboratorio, numeroedizione, cfanimatore) VALUES ('Tecnoled', 3, 'BLTHNA74S41D117G');
INSERT INTO collabora (nomelaboratorio, numeroedizione, cfanimatore) VALUES ('Falegname', 3, 'BNMZHE10P41B048F');
INSERT INTO collabora (nomelaboratorio, numeroedizione, cfanimatore) VALUES ('Tecnoled', 3, 'RGGLNH89B41C303L');
INSERT INTO collabora (nomelaboratorio, numeroedizione, cfanimatore) VALUES ('Braccialetti', 3, 'CRCHDH18S01A373L');
INSERT INTO collabora (nomelaboratorio, numeroedizione, cfanimatore) VALUES ('Pirografia', 3, 'GNTHRS96S01F761M');
INSERT INTO collabora (nomelaboratorio, numeroedizione, cfanimatore) VALUES ('Falegname', 3, 'GRSMRS68L41D239P');
INSERT INTO collabora (nomelaboratorio, numeroedizione, cfanimatore) VALUES ('Filografia', 3, 'GTNFLI20A41E434C');
INSERT INTO collabora (nomelaboratorio, numeroedizione, cfanimatore) VALUES ('Braccialetti', 3, 'LMNDDV62A01D805Q');
INSERT INTO collabora (nomelaboratorio, numeroedizione, cfanimatore) VALUES ('MasterChef', 3, 'LMSDRY84M41A071M');
INSERT INTO collabora (nomelaboratorio, numeroedizione, cfanimatore) VALUES ('Filografia', 3, 'MLDLLN57A41Z101K');
INSERT INTO collabora (nomelaboratorio, numeroedizione, cfanimatore) VALUES ('MasterChef', 3, 'BNMZHE10P41B048F');
INSERT INTO collabora (nomelaboratorio, numeroedizione, cfanimatore) VALUES ('Sacche Schizzate', 3, 'MNNVLT23A41G630D');
INSERT INTO collabora (nomelaboratorio, numeroedizione, cfanimatore) VALUES ('Falegname', 3, 'MNSDRS84R41C359M');
INSERT INTO collabora (nomelaboratorio, numeroedizione, cfanimatore) VALUES ('Filografia', 3, 'ZGRGBD70D01D684B');
INSERT INTO collabora (nomelaboratorio, numeroedizione, cfanimatore) VALUES ('MasterChef', 3, 'MSTMMI15H01F064B');
INSERT INTO collabora (nomelaboratorio, numeroedizione, cfanimatore) VALUES ('Sacche Schizzate', 3, 'PLSLXA66R41L845M');
INSERT INTO collabora (nomelaboratorio, numeroedizione, cfanimatore) VALUES ('Pirografia', 3, 'SCRPCR69R41L168B');
INSERT INTO collabora (nomelaboratorio, numeroedizione, cfanimatore) VALUES ('Pirografia', 3, 'PRTMTG94T41A335C');
INSERT INTO collabora (nomelaboratorio, numeroedizione, cfanimatore) VALUES ('Sacche Schizzate', 3, 'PSSZNA95A41B637P');
INSERT INTO collabora (nomelaboratorio, numeroedizione, cfanimatore) VALUES ('Tecnoled', 3, 'SNTTNE20P01B491F');

INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Magliette Schizzate', 1, 'STRLUC16T07C745D', 2);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Magliette Schizzate', 1, 'VLLMRC15V19C517R', 1);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Magliette Schizzate', 1, 'GRNGRN16W20C224M', 1);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Magliette Schizzate', 1, 'CNDRSS17X21C745D', 1);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Magliette Schizzate', 1, 'GRGFNC17N01C745D', 1);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Magliette Schizzate', 1, 'CNTRNS11O02C517R', 3);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Magliette Schizzate', 1, 'MLTFRN12P03C224M', 1);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Magliette Schizzate', 1, 'PRNGBR13Q04C745D', 4);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Magliette Schizzate', 1, 'LLVFNC14R05C517R', 2);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Magliette Schizzate', 1, 'DLPCRS15S06C224M', 1);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Magliette Schizzate', 1, 'GRDFNC14U18C745D', 1);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Tecnoled', 1, 'BCCCLD17U08C517R', 1);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Tecnoled', 1, 'RZZFRN11V09C224M', 1);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Tecnoled', 1, 'RSSMRC11A01C517R', 1);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Tecnoled', 1, 'VLLFNC12B02C745D', 1);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Tecnoled', 1, 'BNCMRA13C03G224M', 1);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Tecnoled', 1, 'NRGSTF15E05C517R', 1);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Tecnoled', 1, 'BTTLRA16F06C224M', 1);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Tecnoled', 1, 'GRGFNC17G07C517R', 1);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Tecnoled', 1, 'CNTRNS11H08C224M', 1);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Tecnoled', 1, 'MLTFRN12I09C745D', 1);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Tecnoled', 1, 'STRLUC16T07C745D', 3);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Tecnoled', 1, 'VLLMRC15V19C517R', 2);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Tecnoled', 1, 'GRNGRN16W20C224M', 2);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Tecnoled', 1, 'CNDRSS17X21C745D', 2);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Tecnoled', 1, 'CNTRNS11O02C517R', 4);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Tecnoled', 1, 'MLTFRN12P03C224M', 4);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Elettricista', 1, 'PRNGBR13L10C517R', 1);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Elettricista', 1, 'LLVFNC14M11C224M', 1);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Elettricista', 1, 'DLPCRS15N12C745D', 1);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Elettricista', 1, 'STRLUC16P13C517R', 1);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Elettricista', 1, 'LLVFNC14R05C517R', 3);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Elettricista', 1, 'DLPCRS15S06C224M', 2);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Elettricista', 1, 'GRDFNC14U18C745D', 2);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Elettricista', 1, 'BCCCLD17U08C517R', 2);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Elettricista', 1, 'RSSMRC11A01C517R', 2);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Elettricista', 1, 'VLLFNC12B02C745D', 2);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Falegname', 1, 'BCCCLD17Q14C224M', 1);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Falegname', 1, 'BNCMRA13C03G224M', 2);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Falegname', 1, 'NRGSTF15E05C517R', 2);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Falegname', 1, 'BTTLRA16F06C224M', 2);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Falegname', 1, 'GRGFNC17G07C517R', 2);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Falegname', 1, 'STRLUC16T07C745D', 4);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Falegname', 1, 'VLLMRC15V19C517R', 3);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Falegname', 1, 'GRNGRN16W20C224M', 3);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Falegname', 1, 'CNDRSS17X21C745D', 3);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Filografia', 1, 'RZZFRN11R15C745D', 1);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Filografia', 1, 'CNTRNS11H08C224M', 2);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Filografia', 1, 'MLTFRN12I09C745D', 2);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Filografia', 1, 'PRNGBR13L10C517R', 2);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Filografia', 1, 'LLVFNC14M11C224M', 2);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Filografia', 1, 'GRGFNC17N01C745D', 4);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Filografia', 1, 'GRDFNC14U18C745D', 3);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Filografia', 1, 'BCCCLD17U08C517R', 4);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Filografia', 1, 'RSSMRC11A01C517R', 3);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Decoupage', 1, 'BTSLRA16M31C224M', 1);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Decoupage', 1, 'DLPCRS15N12C745D', 2);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Decoupage', 1, 'STRLUC16P13C517R', 2);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Decoupage', 1, 'BCCCLD17Q14C224M', 2);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Decoupage', 1, 'VLLFNC12B02C745D', 3);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Decoupage', 1, 'BNCMRA13C03G224M', 3);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Decoupage', 1, 'NRGSTF15E05C517R', 3);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Decoupage', 1, 'BTTLRA16F06C224M', 3);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('MasterChef', 1, 'BTSLRA16M31C224M', 2);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('MasterChef', 1, 'RZZFRN11R15C745D', 2);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('MasterChef', 1, 'PTTFRN13T17C224M', 2);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('MasterChef', 1, 'GRGFNC17G07C517R', 3);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('MasterChef', 1, 'CNTRNS11H08C224M', 3);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('MasterChef', 1, 'MLTFRN12I09C745D', 3);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('MasterChef', 1, 'PRNGBR13L10C517R', 3);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('MasterChef', 1, 'DLPCRS15N12C745D', 4);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('MasterChef', 1, 'STRLUC16P13C517R', 4);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('MasterChef', 1, 'BCCCLD17Q14C224M', 4);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Magliette Schizzate', 2, 'GNRCRS12W10C745D', 1);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Magliette Schizzate', 2, 'PTTFRN13X11C517R', 3);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Magliette Schizzate', 2, 'GRDFNC14Y12C224M', 2);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Magliette Schizzate', 2, 'VLLMRC15Z13C745D', 1);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Magliette Schizzate', 2, 'MRNGRG13A24C745D', 4);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Magliette Schizzate', 2, 'LNZRCC14B25C517R', 1);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Magliette Schizzate', 2, 'GRDFNC12G30C745D', 1);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Magliette Schizzate', 2, 'VRCFNC14I01C224M', 2);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Magliette Schizzate', 2, 'BTSLRA16K03C517R', 2);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Magliette Schizzate', 2, 'GRGFNC17L04C224M', 2);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Magliette Schizzate', 2, 'CNTRNS11M05C745D', 1);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Tecnoled', 2, 'GRDFNC14Y12C224M', 4);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Tecnoled', 2, 'GRNGRN16A14C517R', 1);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Tecnoled', 2, 'BNCSLF11Y22C517R', 4);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Tecnoled', 2, 'TRMBRN12Z23C224M', 1);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Tecnoled', 2, 'LNZRCC14B25C517R', 2);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Tecnoled', 2, 'GNTRSS11F29C224M', 4);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Tecnoled', 2, 'GRDFNC12G30C745D', 2);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Tecnoled', 2, 'VRCFNC14I01C224M', 4);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Tecnoled', 2, 'NRRSTS15J02C745D', 2);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Tecnoled', 2, 'BTSLRA16K03C517R', 1);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Tecnoled', 2, 'GRGFNC17L04C224M', 3);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Tecnoled', 2, 'CNTRNS11M05C745D', 2);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Tecnoled', 2, 'PRNGBR13O07C224M', 2);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Tecnoled', 2, 'LLVFNC14P08C745D', 2);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Casette Miniatura', 2, 'VLLMRC15Z13C745D', 2);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Casette Miniatura', 2, 'TRMBRN12Z23C224M', 2);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Casette Miniatura', 2, 'MRNGRG13A24C745D', 3);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Casette Miniatura', 2, 'LNZRCC14B25C517R', 3);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Casette Miniatura', 2, 'PZZGRL16D27C745D', 4);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Casette Miniatura', 2, 'LLLLRA17E28C517R', 1);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Casette Miniatura', 2, 'CLLGLL13H31C517R', 3);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Casette Miniatura', 2, 'NRRSTS15J02C745D', 4);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Casette Miniatura', 2, 'BTSLRA16K03C517R', 3);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Casette Miniatura', 2, 'MLTFRN12N06C517R', 3);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Casette Miniatura', 2, 'PRNGBR13O07C224M', 1);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Casette Miniatura', 2, 'LLVFNC14P08C745D', 1);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Casette Miniatura', 2, 'DLPCRS15Q09C517R', 1);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Casette Miniatura', 2, 'STRLUC16R10C224M', 1);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Falegname', 2, 'VLLMRC15Z13C745D', 4);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Falegname', 2, 'GRNGRN16A14C517R', 3);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Falegname', 2, 'BNCSLF11Y22C517R', 3);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Falegname', 2, 'TRMBRN12Z23C224M', 3);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Falegname', 2, 'MRNGRG13A24C745D', 2);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Falegname', 2, 'PZZGRL16D27C745D', 3);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Falegname', 2, 'LLLLRA17E28C517R', 2);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Falegname', 2, 'GNTRSS11F29C224M', 3);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Falegname', 2, 'CLLGLL13H31C517R', 4);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Falegname', 2, 'VRCFNC14I01C224M', 1);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Falegname', 2, 'CNTRNS11M05C745D', 3);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Pirografia', 2, 'TRMBRN12Z23C224M', 4);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Pirografia', 2, 'LLLLRA17E28C517R', 3);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Pirografia', 2, 'CLLGLL13H31C517R', 2);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Pirografia', 2, 'BTSLRA16K03C517R', 4);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Pirografia', 2, 'GRGFNC17L04C224M', 1);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Pirografia', 2, 'MLTFRN12N06C517R', 1);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Pirografia', 2, 'LLVFNC14P08C745D', 3);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Decoupage', 2, 'GRNGRN16A14C517R', 4);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Decoupage', 2, 'BNCSLF11Y22C517R', 2);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Decoupage', 2, 'MRNGRG13A24C745D', 1);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Decoupage', 2, 'PZZGRL16D27C745D', 2);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Decoupage', 2, 'LLLLRA17E28C517R', 4);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Decoupage', 2, 'GNTRSS11F29C224M', 1);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Decoupage', 2, 'GRDFNC12G30C745D', 4);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Decoupage', 2, 'CLLGLL13H31C517R', 1);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Decoupage', 2, 'NRRSTS15J02C745D', 1);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('MasterChef', 2, 'BNCSLF11Y22C517R', 1);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('MasterChef', 2, 'LNZRCC14B25C517R', 4);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('MasterChef', 2, 'PZZGRL16D27C745D', 1);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('MasterChef', 2, 'GNTRSS11F29C224M', 2);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('MasterChef', 2, 'GRDFNC12G30C745D', 3);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('MasterChef', 2, 'VRCFNC14I01C224M', 3);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('MasterChef', 2, 'NRRSTS15J02C745D', 3);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('MasterChef', 2, 'GRGFNC17L04C224M', 4);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('MasterChef', 2, 'CNTRNS11M05C745D', 4);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('MasterChef', 2, 'MLTFRN12N06C517R', 2);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('MasterChef', 2, 'DLPCRS15Q09C517R', 3);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('MasterChef', 2, 'STRLUC16R10C224M', 4);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Sacche Schizzate', 3, 'BCCCLD17S11C745D', 1);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Sacche Schizzate', 3, 'RZZFRN11T12C517R', 1);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Sacche Schizzate', 3, 'GRDFNC12I27C517R', 3);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Sacche Schizzate', 3, 'MRNGRG13C21C517R', 2);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Sacche Schizzate', 3, 'GRNGRN16Y17C745D', 1);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Sacche Schizzate', 3, 'GNRCRS12U13C224M', 4);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Sacche Schizzate', 3, 'GNTRSS11H26C745D', 1);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Sacche Schizzate', 3, 'CLLGLL13J28C224M', 2);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Sacche Schizzate', 3, 'VRCFNC14K29C745D', 3);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Tecnoled', 3, 'BCCCLD17S11C745D', 4);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Tecnoled', 3, 'BNCSLF11A19C224M', 1);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Tecnoled', 3, 'GNTRSS11H26C745D', 4);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Tecnoled', 3, 'MRNGRG13C21C517R', 1);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Tecnoled', 3, 'RZZFRN11T12C517R', 2);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Tecnoled', 3, 'TRMBRN12B20C745D', 4);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Tecnoled', 3, 'GRNGRN16Y17C745D', 2);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Tecnoled', 3, 'CNDRSS17Z18C517R', 4);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Tecnoled', 3, 'NRRSTS15L30C517R', 2);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Tecnoled', 3, 'LLLLRA17G25C224M', 1);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Tecnoled', 3, 'LNZRCC14F19C745D', 3);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Tecnoled', 3, 'PZZGRL16F24C517R', 2);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Tecnoled', 3, 'VRCFNC14K29C745D', 2);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Tecnoled', 3, 'VRDRCC15E23C745D', 2);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Filografia', 3, 'BNCSLF11A19C224M', 2);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Filografia', 3, 'GRDFNC12I27C517R', 2);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Filografia', 3, 'GRNGRN16Y17C745D', 3);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Filografia', 3, 'LNZRCC14D22C224M', 2);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Filografia', 3, 'VLLMRC15X16C224M', 4);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Filografia', 3, 'GRDFNC14W15C517R', 1);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Filografia', 3, 'VRDRCC15E23C745D', 1);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Falegname', 3, 'PTTFRN13V14C745D', 4);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Falegname', 3, 'BCCCLD17S11C745D', 3);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Falegname', 3, 'CNDRSS17Z18C517R', 3);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Falegname', 3, 'RZZFRN11T12C517R', 3);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Falegname', 3, 'GRDFNC14W15C517R', 2);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Falegname', 3, 'VLLMRC15X16C224M', 3);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Falegname', 3, 'LLLLRA17G25C224M', 2);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Falegname', 3, 'BNCSLF11A19C224M', 3);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Falegname', 3, 'GRNGRN16Y17C745D', 4);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Falegname', 3, 'GNRCRS12U13C224M', 1);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Pirografia', 3, 'RZZFRN11T12C517R', 4);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Pirografia', 3, 'GRDFNC14W15C517R', 3);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Pirografia', 3, 'CNDRSS17Z18C517R', 2);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Pirografia', 3, 'LLLLRA17G25C224M', 4);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Pirografia', 3, 'GRDFNC12I27C517R', 1);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Pirografia', 3, 'VRCFNC14K29C745D', 1);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Pirografia', 3, 'LNZRCC14D22C224M', 3);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Braccialetti', 3, 'BCCCLD17S11C745D', 2);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Braccialetti', 3, 'GRDFNC14W15C517R', 4);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Braccialetti', 3, 'PTTFRN13V14C745D', 2);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Braccialetti', 3, 'GNRCRS12U13C224M', 2);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Braccialetti', 3, 'BNCSLF11A19C224M', 4);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Braccialetti', 3, 'VLLMRC15X16C224M', 1);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('Braccialetti', 3, 'TRMBRN12B20C745D', 3);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('MasterChef', 3, 'CNDRSS17Z18C517R', 1);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('MasterChef', 3, 'VRCFNC14K29C745D', 4);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('MasterChef', 3, 'PTTFRN13V14C745D', 1);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('MasterChef', 3, 'VLLMRC15X16C224M', 2);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('MasterChef', 3, 'GNRCRS12U13C224M', 3);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('MasterChef', 3, 'GNTRSS11H26C745D', 3);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('MasterChef', 3, 'PZZGRL16F24C517R', 3);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('MasterChef', 3, 'LNZRCC14D22C224M', 4);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('MasterChef', 3, 'CLLGLL13J28C224M', 4);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('MasterChef', 3, 'TRMBRN12B20C745D', 2);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('MasterChef', 3, 'MRNGRG13C21C517R', 3);
INSERT INTO segue (nomelaboratorio, numeroedizione, cfpartecipante, settimana) VALUES ('MasterChef', 3, 'GRDFNC12I27C517R', 4);

INSERT INTO associato (nomesquadra, numeroedizione, cfpartecipante, quantesettimane) VALUES ('Regina Cuori', 1, 'RSSMRC11A01C517R', 1234);
INSERT INTO associato (nomesquadra, numeroedizione, cfpartecipante, quantesettimane) VALUES ('Regina Cuori', 1, 'VLLFNC12B02C745D', 1234);
INSERT INTO associato (nomesquadra, numeroedizione, cfpartecipante, quantesettimane) VALUES ('Regina Bianca', 1, 'BNCMRA13C03G224M', 1234);
INSERT INTO associato (nomesquadra, numeroedizione, cfpartecipante, quantesettimane) VALUES ('Regina Bianca', 1, 'NRGSTF15E05C517R', 1234);
INSERT INTO associato (nomesquadra, numeroedizione, cfpartecipante, quantesettimane) VALUES ('Grillo', 1, 'BTTLRA16F06C224M', 1234);
INSERT INTO associato (nomesquadra, numeroedizione, cfpartecipante, quantesettimane) VALUES ('Grillo', 1, 'GRGFNC17G07C517R', 1234);
INSERT INTO associato (nomesquadra, numeroedizione, cfpartecipante, quantesettimane) VALUES ('Giangi', 1, 'CNTRNS11H08C224M', 1234);
INSERT INTO associato (nomesquadra, numeroedizione, cfpartecipante, quantesettimane) VALUES ('Giangi', 1, 'MLTFRN12I09C745D', 1234);
INSERT INTO associato (nomesquadra, numeroedizione, cfpartecipante, quantesettimane) VALUES ('Gatto Cheshire', 1, 'PRNGBR13L10C517R', 1234);
INSERT INTO associato (nomesquadra, numeroedizione, cfpartecipante, quantesettimane) VALUES ('Gatto Cheshire', 1, 'LLVFNC14M11C224M', 1234);
INSERT INTO associato (nomesquadra, numeroedizione, cfpartecipante, quantesettimane) VALUES ('Dodo', 1, 'DLPCRS15N12C745D', 1234);
INSERT INTO associato (nomesquadra, numeroedizione, cfpartecipante, quantesettimane) VALUES ('Dodo', 1, 'STRLUC16P13C517R', 1234);
INSERT INTO associato (nomesquadra, numeroedizione, cfpartecipante, quantesettimane) VALUES ('Cappellaio', 1, 'BCCCLD17Q14C224M', 1234);
INSERT INTO associato (nomesquadra, numeroedizione, cfpartecipante, quantesettimane) VALUES ('Cappellaio', 1, 'RZZFRN11R15C745D', 1234);
INSERT INTO associato (nomesquadra, numeroedizione, cfpartecipante, quantesettimane) VALUES ('Bruco', 1, 'GNRCRS12S16C517R', 1234);
INSERT INTO associato (nomesquadra, numeroedizione, cfpartecipante, quantesettimane) VALUES ('Bruco', 1, 'PTTFRN13T17C224M', 1234);
INSERT INTO associato (nomesquadra, numeroedizione, cfpartecipante, quantesettimane) VALUES ('Alice', 1, 'GRDFNC14U18C745D', 1234);
INSERT INTO associato (nomesquadra, numeroedizione, cfpartecipante, quantesettimane) VALUES ('Alice', 1, 'VLLMRC15V19C517R', 1234);
INSERT INTO associato (nomesquadra, numeroedizione, cfpartecipante, quantesettimane) VALUES ('Tartaruga', 1, 'GRNGRN16W20C224M', 1234);
INSERT INTO associato (nomesquadra, numeroedizione, cfpartecipante, quantesettimane) VALUES ('Tartaruga', 1, 'CNDRSS17X21C745D', 1234);
INSERT INTO associato (nomesquadra, numeroedizione, cfpartecipante, quantesettimane) VALUES ('Proplayer', 2, 'BNCSLF11Y22C517R', 1234);
INSERT INTO associato (nomesquadra, numeroedizione, cfpartecipante, quantesettimane) VALUES ('Proplayer', 2, 'TRMBRN12Z23C224M', 1234);
INSERT INTO associato (nomesquadra, numeroedizione, cfpartecipante, quantesettimane) VALUES ('Zelda', 2, 'MRNGRG13A24C745D', 1234);
INSERT INTO associato (nomesquadra, numeroedizione, cfpartecipante, quantesettimane) VALUES ('Zelda', 2, 'LNZRCC14B25C517R', 1234);
INSERT INTO associato (nomesquadra, numeroedizione, cfpartecipante, quantesettimane) VALUES ('Pro Fortnite', 2, 'VRDRCC15C26C224M', 1234);
INSERT INTO associato (nomesquadra, numeroedizione, cfpartecipante, quantesettimane) VALUES ('Pro Fortnite', 2, 'PZZGRL16D27C745D', 1234);
INSERT INTO associato (nomesquadra, numeroedizione, cfpartecipante, quantesettimane) VALUES ('Pacman', 2, 'LLLLRA17E28C517R', 1234);
INSERT INTO associato (nomesquadra, numeroedizione, cfpartecipante, quantesettimane) VALUES ('Pacman', 2, 'GNTRSS11F29C224M', 1234);
INSERT INTO associato (nomesquadra, numeroedizione, cfpartecipante, quantesettimane) VALUES ('Creeper', 2, 'GRDFNC12G30C745D', 1234);
INSERT INTO associato (nomesquadra, numeroedizione, cfpartecipante, quantesettimane) VALUES ('Creeper', 2, 'CLLGLL13H31C517R', 1234);
INSERT INTO associato (nomesquadra, numeroedizione, cfpartecipante, quantesettimane) VALUES ('Team Bros', 2, 'VRCFNC14I01C224M', 1234);
INSERT INTO associato (nomesquadra, numeroedizione, cfpartecipante, quantesettimane) VALUES ('Team Bros', 2, 'NRRSTS15J02C745D', 1234);
INSERT INTO associato (nomesquadra, numeroedizione, cfpartecipante, quantesettimane) VALUES ('Royale Squad', 2, 'BTSLRA16K03C517R', 1234);
INSERT INTO associato (nomesquadra, numeroedizione, cfpartecipante, quantesettimane) VALUES ('Royale Squad', 2, 'GRGFNC17L04C224M', 1234);
INSERT INTO associato (nomesquadra, numeroedizione, cfpartecipante, quantesettimane) VALUES ('Green Links', 2, 'CNTRNS11M05C745D', 1234);
INSERT INTO associato (nomesquadra, numeroedizione, cfpartecipante, quantesettimane) VALUES ('Green Links', 2, 'MLTFRN12N06C517R', 1234);
INSERT INTO associato (nomesquadra, numeroedizione, cfpartecipante, quantesettimane) VALUES ('Hackerman', 2, 'PRNGBR13O07C224M', 1234);
INSERT INTO associato (nomesquadra, numeroedizione, cfpartecipante, quantesettimane) VALUES ('Hackerman', 2, 'LLVFNC14P08C745D', 1234);
INSERT INTO associato (nomesquadra, numeroedizione, cfpartecipante, quantesettimane) VALUES ('Luckylama', 2, 'DLPCRS15Q09C517R', 1234);
INSERT INTO associato (nomesquadra, numeroedizione, cfpartecipante, quantesettimane) VALUES ('Luckylama', 2, 'STRLUC16R10C224M', 1234);
INSERT INTO associato (nomesquadra, numeroedizione, cfpartecipante, quantesettimane) VALUES ('Sognatori Chill', 3, 'BCCCLD17S11C745D', 1234);
INSERT INTO associato (nomesquadra, numeroedizione, cfpartecipante, quantesettimane) VALUES ('Sognatori Chill', 3, 'RZZFRN11T12C517R', 1234);
INSERT INTO associato (nomesquadra, numeroedizione, cfpartecipante, quantesettimane) VALUES ('Followme', 3, 'GNRCRS12U13C224M', 1234);
INSERT INTO associato (nomesquadra, numeroedizione, cfpartecipante, quantesettimane) VALUES ('Followme', 3, 'PTTFRN13V14C745D', 1234);
INSERT INTO associato (nomesquadra, numeroedizione, cfpartecipante, quantesettimane) VALUES ('Risorgivi', 3, 'GRDFNC14W15C517R', 1234);
INSERT INTO associato (nomesquadra, numeroedizione, cfpartecipante, quantesettimane) VALUES ('Risorgivi', 3, 'VLLMRC15X16C224M', 1234);
INSERT INTO associato (nomesquadra, numeroedizione, cfpartecipante, quantesettimane) VALUES ('Da cosi a cosi', 3, 'GRNGRN16Y17C745D', 1234);
INSERT INTO associato (nomesquadra, numeroedizione, cfpartecipante, quantesettimane) VALUES ('Da cosi a cosi', 3, 'CNDRSS17Z18C517R', 1234);
INSERT INTO associato (nomesquadra, numeroedizione, cfpartecipante, quantesettimane) VALUES ('Sognatori', 3, 'BNCSLF11A19C224M', 1234);
INSERT INTO associato (nomesquadra, numeroedizione, cfpartecipante, quantesettimane) VALUES ('Sognatori', 3, 'TRMBRN12B20C745D', 1234);
INSERT INTO associato (nomesquadra, numeroedizione, cfpartecipante, quantesettimane) VALUES ('Alibabibbia', 3, 'MRNGRG13C21C517R', 1234);
INSERT INTO associato (nomesquadra, numeroedizione, cfpartecipante, quantesettimane) VALUES ('Alibabibbia', 3, 'LNZRCC14D22C224M', 1234);
INSERT INTO associato (nomesquadra, numeroedizione, cfpartecipante, quantesettimane) VALUES ('Piccoli Apostoli', 3, 'VRDRCC15E23C745D', 1234);
INSERT INTO associato (nomesquadra, numeroedizione, cfpartecipante, quantesettimane) VALUES ('Piccoli Apostoli', 3, 'PZZGRL16F24C517R', 1234);
INSERT INTO associato (nomesquadra, numeroedizione, cfpartecipante, quantesettimane) VALUES ('Boss dei Sogni', 3, 'LLLLRA17G25C224M', 1234);
INSERT INTO associato (nomesquadra, numeroedizione, cfpartecipante, quantesettimane) VALUES ('Boss dei Sogni', 3, 'GNTRSS11H26C745D', 1234);
INSERT INTO associato (nomesquadra, numeroedizione, cfpartecipante, quantesettimane) VALUES ('Profeti di IG', 3, 'GRDFNC12I27C517R', 1234);
INSERT INTO associato (nomesquadra, numeroedizione, cfpartecipante, quantesettimane) VALUES ('Profeti di IG', 3, 'CLLGLL13J28C224M', 1234);
INSERT INTO associato (nomesquadra, numeroedizione, cfpartecipante, quantesettimane) VALUES ('Principi dei Sogni', 3, 'VRCFNC14K29C745D', 1234);
INSERT INTO associato (nomesquadra, numeroedizione, cfpartecipante, quantesettimane) VALUES ('Principi dei Sogni', 3, 'NRRSTS15L30C517R', 1234);
INSERT INTO associato (nomesquadra, numeroedizione, cfpartecipante, quantesettimane) VALUES ('Regina Cuori', 1, 'BTSLRA16M31C224M', 12);
INSERT INTO associato (nomesquadra, numeroedizione, cfpartecipante, quantesettimane) VALUES ('Regina Cuori', 1, 'GRGFNC17N01C745D', 124);
INSERT INTO associato (nomesquadra, numeroedizione, cfpartecipante, quantesettimane) VALUES ('Regina Bianca', 1, 'CNTRNS11O02C517R', 34);
INSERT INTO associato (nomesquadra, numeroedizione, cfpartecipante, quantesettimane) VALUES ('Grillo', 1, 'MLTFRN12P03C224M', 14);
INSERT INTO associato (nomesquadra, numeroedizione, cfpartecipante, quantesettimane) VALUES ('Giangi', 1, 'PRNGBR13Q04C745D', 4);
INSERT INTO associato (nomesquadra, numeroedizione, cfpartecipante, quantesettimane) VALUES ('Dodo', 1, 'LLVFNC14R05C517R', 23);
INSERT INTO associato (nomesquadra, numeroedizione, cfpartecipante, quantesettimane) VALUES ('Dodo', 1, 'DLPCRS15S06C224M', 12);
INSERT INTO associato (nomesquadra, numeroedizione, cfpartecipante, quantesettimane) VALUES ('Cappellaio', 1, 'STRLUC16T07C745D', 234);
INSERT INTO associato (nomesquadra, numeroedizione, cfpartecipante, quantesettimane) VALUES ('Alice', 1, 'BCCCLD17U08C517R', 124);
INSERT INTO associato (nomesquadra, numeroedizione, cfpartecipante, quantesettimane) VALUES ('Alice', 1, 'RZZFRN11V09C224M', 1);
INSERT INTO associato (nomesquadra, numeroedizione, cfpartecipante, quantesettimane) VALUES ('Proplayer', 2, 'GNRCRS12W10C745D', 1);
INSERT INTO associato (nomesquadra, numeroedizione, cfpartecipante, quantesettimane) VALUES ('Proplayer', 2, 'PTTFRN13X11C517R', 3);
INSERT INTO associato (nomesquadra, numeroedizione, cfpartecipante, quantesettimane) VALUES ('Proplayer', 2, 'GRDFNC14Y12C224M', 24);
INSERT INTO associato (nomesquadra, numeroedizione, cfpartecipante, quantesettimane) VALUES ('Zelda', 2, 'VLLMRC15Z13C745D', 124);
INSERT INTO associato (nomesquadra, numeroedizione, cfpartecipante, quantesettimane) VALUES ('Pacman', 2, 'GRNGRN16A14C517R', 134);
INSERT INTO associato (nomesquadra, numeroedizione, cfpartecipante, quantesettimane) VALUES ('Followme', 3, 'CNDRSS17B15C224M', 123);
INSERT INTO associato (nomesquadra, numeroedizione, cfpartecipante, quantesettimane) VALUES ('Risorgivi', 3, 'BNCSLF11C16C745D', 134);
INSERT INTO associato (nomesquadra, numeroedizione, cfpartecipante, quantesettimane) VALUES ('Profeti di IG', 3, 'TRMBRN12D17C517R', 14);
INSERT INTO associato (nomesquadra, numeroedizione, cfpartecipante, quantesettimane) VALUES ('Principi dei Sogni', 3, 'MRNGRG13E18C224M', 134);
INSERT INTO associato (nomesquadra, numeroedizione, cfpartecipante, quantesettimane) VALUES ('Principi dei Sogni', 3, 'LNZRCC14F19C745D', 234);

INSERT INTO anima (nomesquadra, numeroedizione, cfanimatore) VALUES ('Regina Cuori', 1, 'GTNFLI20A41E434C');
INSERT INTO anima (nomesquadra, numeroedizione, cfanimatore) VALUES ('Regina Cuori', 1, 'SGHRGN10P01I490G');
INSERT INTO anima (nomesquadra, numeroedizione, cfanimatore) VALUES ('Regina Bianca', 1, 'MSTMMI15H01F064B');
INSERT INTO anima (nomesquadra, numeroedizione, cfanimatore) VALUES ('Regina Bianca', 1, 'PSSZNA95A41B637P');
INSERT INTO anima (nomesquadra, numeroedizione, cfanimatore) VALUES ('Grillo', 1, 'RSCPLG58S41G509D');
INSERT INTO anima (nomesquadra, numeroedizione, cfanimatore) VALUES ('Grillo', 1, 'MLDLLN57A41Z101K');
INSERT INTO anima (nomesquadra, numeroedizione, cfanimatore) VALUES ('Giangi', 1, 'RMNKST19P01B114A');
INSERT INTO anima (nomesquadra, numeroedizione, cfanimatore) VALUES ('Giangi', 1, 'GRSMRS68L41D239P');
INSERT INTO anima (nomesquadra, numeroedizione, cfanimatore) VALUES ('Gatto Cheshire', 1, 'MNSDRS84R41C359M');
INSERT INTO anima (nomesquadra, numeroedizione, cfanimatore) VALUES ('Gatto Cheshire', 1, 'BLRNRT47A41E336F');
INSERT INTO anima (nomesquadra, numeroedizione, cfanimatore) VALUES ('Dodo', 1, 'SCRPCR69R41L168B');
INSERT INTO anima (nomesquadra, numeroedizione, cfanimatore) VALUES ('Dodo', 1, 'CRCHDH18S01A373L');
INSERT INTO anima (nomesquadra, numeroedizione, cfanimatore) VALUES ('Cappellaio', 1, 'ZGRGBD70D01D684B');
INSERT INTO anima (nomesquadra, numeroedizione, cfanimatore) VALUES ('Cappellaio', 1, 'SLVHSK21E41M021S');
INSERT INTO anima (nomesquadra, numeroedizione, cfanimatore) VALUES ('Bruco', 1, 'RCANMR16C41H867T');
INSERT INTO anima (nomesquadra, numeroedizione, cfanimatore) VALUES ('Bruco', 1, 'LMSDRY84M41A071M');
INSERT INTO anima (nomesquadra, numeroedizione, cfanimatore) VALUES ('Alice', 1, 'MNNVLT23A41G630D');
INSERT INTO anima (nomesquadra, numeroedizione, cfanimatore) VALUES ('Alice', 1, 'RGGLNH89B41C303L');
INSERT INTO anima (nomesquadra, numeroedizione, cfanimatore) VALUES ('Tartaruga', 1, 'BLTHNA74S41D117G');
INSERT INTO anima (nomesquadra, numeroedizione, cfanimatore) VALUES ('Tartaruga', 1, 'MRDNVT90S41I321I');
INSERT INTO anima (nomesquadra, numeroedizione, cfanimatore) VALUES ('Proplayer', 2, 'GTNFLI20A41E434C');
INSERT INTO anima (nomesquadra, numeroedizione, cfanimatore) VALUES ('Proplayer', 2, 'SGHRGN10P01I490G');
INSERT INTO anima (nomesquadra, numeroedizione, cfanimatore) VALUES ('Zelda', 2, 'MSTMMI15H01F064B');
INSERT INTO anima (nomesquadra, numeroedizione, cfanimatore) VALUES ('Zelda', 2, 'PSSZNA95A41B637P');
INSERT INTO anima (nomesquadra, numeroedizione, cfanimatore) VALUES ('Pro Fortnite', 2, 'RSCPLG58S41G509D');
INSERT INTO anima (nomesquadra, numeroedizione, cfanimatore) VALUES ('Pro Fortnite', 2, 'MLDLLN57A41Z101K');
INSERT INTO anima (nomesquadra, numeroedizione, cfanimatore) VALUES ('Pacman', 2, 'RMNKST19P01B114A');
INSERT INTO anima (nomesquadra, numeroedizione, cfanimatore) VALUES ('Pacman', 2, 'GRSMRS68L41D239P');
INSERT INTO anima (nomesquadra, numeroedizione, cfanimatore) VALUES ('Creeper', 2, 'MNSDRS84R41C359M');
INSERT INTO anima (nomesquadra, numeroedizione, cfanimatore) VALUES ('Creeper', 2, 'BLRNRT47A41E336F');
INSERT INTO anima (nomesquadra, numeroedizione, cfanimatore) VALUES ('Team Bros', 2, 'SCRPCR69R41L168B');
INSERT INTO anima (nomesquadra, numeroedizione, cfanimatore) VALUES ('Team Bros', 2, 'CRCHDH18S01A373L');
INSERT INTO anima (nomesquadra, numeroedizione, cfanimatore) VALUES ('Royale Squad', 2, 'ZGRGBD70D01D684B');
INSERT INTO anima (nomesquadra, numeroedizione, cfanimatore) VALUES ('Royale Squad', 2, 'SLVHSK21E41M021S');
INSERT INTO anima (nomesquadra, numeroedizione, cfanimatore) VALUES ('Green Links', 2, 'RCANMR16C41H867T');
INSERT INTO anima (nomesquadra, numeroedizione, cfanimatore) VALUES ('Green Links', 2, 'LMSDRY84M41A071M');
INSERT INTO anima (nomesquadra, numeroedizione, cfanimatore) VALUES ('Hackerman', 2, 'MNNVLT23A41G630D');
INSERT INTO anima (nomesquadra, numeroedizione, cfanimatore) VALUES ('Hackerman', 2, 'RGGLNH89B41C303L');
INSERT INTO anima (nomesquadra, numeroedizione, cfanimatore) VALUES ('Luckylama', 2, 'BLTHNA74S41D117G');
INSERT INTO anima (nomesquadra, numeroedizione, cfanimatore) VALUES ('Luckylama', 2, 'MRDNVT90S41I321I');
INSERT INTO anima (nomesquadra, numeroedizione, cfanimatore) VALUES ('Sognatori Chill', 3, 'GTNFLI20A41E434C');
INSERT INTO anima (nomesquadra, numeroedizione, cfanimatore) VALUES ('Sognatori Chill', 3, 'SGHRGN10P01I490G');
INSERT INTO anima (nomesquadra, numeroedizione, cfanimatore) VALUES ('Followme', 3, 'MSTMMI15H01F064B');
INSERT INTO anima (nomesquadra, numeroedizione, cfanimatore) VALUES ('Followme', 3, 'PSSZNA95A41B637P');
INSERT INTO anima (nomesquadra, numeroedizione, cfanimatore) VALUES ('Risorgivi', 3, 'RSCPLG58S41G509D');
INSERT INTO anima (nomesquadra, numeroedizione, cfanimatore) VALUES ('Risorgivi', 3, 'MLDLLN57A41Z101K');
INSERT INTO anima (nomesquadra, numeroedizione, cfanimatore) VALUES ('Da cosi a cosi', 3, 'RMNKST19P01B114A');
INSERT INTO anima (nomesquadra, numeroedizione, cfanimatore) VALUES ('Da cosi a cosi', 3, 'GRSMRS68L41D239P');
INSERT INTO anima (nomesquadra, numeroedizione, cfanimatore) VALUES ('Sognatori', 3, 'MNSDRS84R41C359M');
INSERT INTO anima (nomesquadra, numeroedizione, cfanimatore) VALUES ('Sognatori', 3, 'BLRNRT47A41E336F');
INSERT INTO anima (nomesquadra, numeroedizione, cfanimatore) VALUES ('Alibabibbia', 3, 'SCRPCR69R41L168B');
INSERT INTO anima (nomesquadra, numeroedizione, cfanimatore) VALUES ('Alibabibbia', 3, 'CRCHDH18S01A373L');
INSERT INTO anima (nomesquadra, numeroedizione, cfanimatore) VALUES ('Piccoli Apostoli', 3, 'ZGRGBD70D01D684B');
INSERT INTO anima (nomesquadra, numeroedizione, cfanimatore) VALUES ('Piccoli Apostoli', 3, 'SLVHSK21E41M021S');
INSERT INTO anima (nomesquadra, numeroedizione, cfanimatore) VALUES ('Boss dei Sogni', 3, 'RCANMR16C41H867T');
INSERT INTO anima (nomesquadra, numeroedizione, cfanimatore) VALUES ('Boss dei Sogni', 3, 'LMSDRY84M41A071M');
INSERT INTO anima (nomesquadra, numeroedizione, cfanimatore) VALUES ('Profeti di IG', 3, 'MNNVLT23A41G630D');
INSERT INTO anima (nomesquadra, numeroedizione, cfanimatore) VALUES ('Profeti di IG', 3, 'RGGLNH89B41C303L');
INSERT INTO anima (nomesquadra, numeroedizione, cfanimatore) VALUES ('Principi dei Sogni', 3, 'BLTHNA74S41D117G');
INSERT INTO anima (nomesquadra, numeroedizione, cfanimatore) VALUES ('Principi dei Sogni', 3, 'LTSRMN84C01Z601V');

-- INTERROGAZIONI BASE DI DATI E CREAZIONE INDICI (in 5.)
/* 1. Si restituiscano i codici fiscali dei partecipanti iscritti a meno di quattro settimane di evento ma che
    partecipano ad almeno un’uscita.*/
-- TAB1)
select associato.cfpartecipante as "Codice Fiscale"
from associato
where quantesettimane != '1234'
    and exists(select *
                from partecipa
                where partecipa.cfpartecipante = associato.cfpartecipante
                );

/* 2. Si restituisca la classifica finale dell’edizione x del Centro Estivo (dalla squadra che ha ottenuto
    più punti a quella che ne ha ottenuti meno) avendo come output anche il numero di partite vinte. (qui x = 2)*/
create view numerovittorie as
    select partita.squadravincitrice as squadravin, count(partita.squadravincitrice) as "Partite Vinte"
    from partita
    where partita.edizionesquadravincitrice = 2
    group by partita.squadravincitrice;

-- TAB2)
select squadra.nome as "Nome Squadra", squadra.punteggio as "Punteggio", "Partite Vinte"
from squadra inner join numerovittorie on squadra.nome = squadravin
order by squadra.punteggio desc;

/* 3. Per ogni laboratorio che ha x o più partecipanti nella settimana y dell’edizione z si mostrino nome,
    cognome e indirizzo degli animatori che vi collaborano. (qui x = 3, y = 2, z = 1)*/
create view listalaboratori as
    select segue.nomelaboratorio as nomelab, segue.numeroedizione as ed
    from segue
    where segue.numeroedizione = 1
        and segue.settimana = 2
    group by segue.nomeLaboratorio, segue.numeroedizione
    having count(segue.cfpartecipante) >= 3;

create view listaanimatori as
    select collabora.cfanimatore as cf
    from collabora inner join listalaboratori on collabora.nomelaboratorio = nomelab
        and collabora.numeroedizione = ed;

-- TAB3)
select animatore.nome, animatore.cognome, indirizzo.via, indirizzo.civico,
    indirizzo.comune, indirizzo.cap, indirizzo.provincia
from (animatore inner join indirizzo on animatore.idindirizzo = indirizzo.id)
    inner join listaanimatori on animatore.codicefiscale = cf;

/* 4. Si mostri il codice dell’ordine meno costoso per ciascuna edizione fatto da un animatore che è oppure
    è stato responsabile di qualche équipe (null se nessun animatore responsabile ha effettuato ordini nell’edizione).*/
create view ordiniresponsabile as
    select ordine.cfanimatore, ordine.data, ordine.codice, ordine.costo
    from ordine inner join afferisce on ordine.cfanimatore = afferisce.cfanimatore
    where afferisce.isresponsabile = true;

create view ordinievento as
    select evento.edizione, ordiniresponsabile.codice as "Codice Ordine", ordiniresponsabile.costo
    from evento left outer join Ordiniresponsabile on evento.datainizio <= ordiniresponsabile.data
        and evento.datafine >= ordiniresponsabile.data;

-- TAB4)
select distinct ordinievento.edizione as "Edizione", ordinievento."Codice Ordine"
from ordinievento, (select ordinievento.edizione as ed, min(ordinievento.costo) as minimo
                    from ordinievento
                    group by ordinievento.edizione
                    ) as ordiniminimi
where ordinievento.edizione = ed
    and ordinievento.costo = minimo
    or ordinievento.costo is null;

/* 5. Si mostri il numero di partecipanti ad ogni squadra e ad ogni laboratorio per edizione.*/
create index idx_associato_nomesquadra_edizione on associato(nomesquadra, numeroedizione);
create index idx_segue_nomelaboratorio_edizione on segue(nomelaboratorio, numeroedizione);

-- TAB5)
select squadra.nome as "Nome", 'Squ.' as "Tipo", squadra.numeroedizione as "Numero Edizione", count(associato.cfpartecipante) as "Numero Iscritti"
from squadra inner join associato on squadra.nome = associato.nomesquadra
    and squadra.numeroedizione = associato.numeroedizione
group by squadra.numeroedizione, squadra.nome
union
select laboratorio.nome as "Nome", 'Lab.' as "Tipo", laboratorio.numeroedizione as "Numero Edizione", count(segue.cfpartecipante) as "Numero Iscritti"
from laboratorio inner join segue on laboratorio.nome = segue.nomelaboratorio
    and laboratorio.numeroedizione = segue.numeroedizione
group by laboratorio.numeroedizione, laboratorio.nome
order by "Numero Edizione", "Tipo", "Nome";

/* 6. Si mostrino i campi ordinati in base alla media dei punteggi ottenibili dai giochi organizzati in quel campo
    (dalla più alta alla più bassa).*/
-- TAB6)
select campo.numero as "Numero", avg(gioco.punteggio) as "Media Punti"
from campo inner join gioco on campo.numero = gioco.numerocampo
group by campo.numero
order by "Media Punti" desc;