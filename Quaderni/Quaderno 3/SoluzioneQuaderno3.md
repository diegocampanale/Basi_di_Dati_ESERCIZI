
# Quaderno 3 - Basi di Dati

* [Quaderno 3 - Basi di Dati](#quaderno-3---basi-di-dati)
  * [Esercizio 1](#esercizio-1)
    * [Traccia](#traccia)
    * [Soluzione](#soluzione)
    * [Soluzione (alternativa)](#soluzione-alternativa)
  * [Esercizio 2](#esercizio-2)
    * [Traccia](#traccia-1)
    * [Soluzione](#soluzione-1)
  * [Esercizio 3](#esercizio-3)
    * [Traccia](#traccia-2)
    * [Soluzione](#soluzione-2)
  * [Esercizio 4](#esercizio-4)
    * [Traccia](#traccia-3)
    * [Soluzione](#soluzione-3)

## Esercizio 1
### Traccia
#### Sono date le seguenti relazioni (le chiavi primarie sono sottolineate, gli attributi opzionali sono indicati con *): <!-- omit in toc -->

<div style="background-color: #f0f0f0; padding: 10px; border-radius: 5px; color:#000000">
STUDENTE (<u>MatrS</u>, NomeS, CognomeS, Corso di Laurea) <br>
DOCENTE (<u>CodD</u>, NomeD, CognomeD, Dipartimento) <br>
HOMEWORK (<u>CodHW</u>, Titolo, Argomento, CodDReferente, DataScadenza)<br>
VALUTAZIONE (<u>MatrS</u>, <u>CodHW</u>, CodD, DataConsegna, DataValutazione, Valutazione) <br>
</div>

#### Integrità referenziale: <!-- omit in toc -->
Attributi con lo stesso nome in tabelle diverse indicano un vincolo di integrità referenziale.  
Inoltre HOMEWORK (CodDReferente) REFERENCES DOCENTE (CodD)
#### Esprimere la seguente interrogazione in linguaggio SQL <!-- omit in toc -->

Per ciascun homework di argomento "integrali" oppure "equazioni differenziali", che è stato consegnato in ritardo da almeno 5 studenti, visualizzare:
-  il titolo dell’homework
-  l’argomento, 
-  il cognome del docente che referente per l’homework
-  la valutazione media conseguita dagli studenti sugli homework consegnati 
-  il numero medio di giorni richiesto per la valutazione (calcolato come la differenza tra DataValutazione e la DataConsegna).

### Soluzione
```sql
SELECT H.Titolo, H.Argomento, D.CognomeD AS CognomeDocente, 
        AVG(V.Valutazione) AS MediaValutazioni, 
        AVG(V.DataValutazione - V.DataConsegna) AS MediaGiorniValutazione

FROM HOMEWORK AS H, DOCENTE AS D, VALUTAZIONE AS V

WHERE D.CodD = H.CodDReferente
  AND H.CodHW = V.CodHW
  AND (H.Argomento = 'integrali' OR H.Argomento = 'equazioni differenziali')
    AND V.DataConsegna >= H.DataScadenza
GROUP BY H.CodHW, H.Titolo, H.Argomento, D.CognomeD
HAVING COUNT(*) >= 5;
```

### Soluzione (alternativa) 
```sql
SELECT HW.Titolo, HW.Argomento, D.CognomeD, 
       AVG(V.Valutazione) AS ValutazioneMedia, 
       AVG(DATEDIFF(V.DataValutazione, V.DataConsegna)) AS GiorniMedio
FROM HOMEWORK HW
JOIN DOCENTE D ON HW.CodDReferente = D.CodD
JOIN VALUTAZIONE V ON HW.CodHW = V.CodHW
WHERE (HW.Argomento = 'integrali' OR HW.Argomento = 'equazioni differenziali')
  AND V.DataConsegna > DATE_ADD(HW.DataScadenza, INTERVAL 5 DAY)
GROUP BY HW.Titolo, HW.Argomento, D.CognomeD
HAVING COUNT(DISTINCT V.MatrS) >= 5;
```

## Esercizio 2
### Traccia
#### Sono date le seguenti relazioni (le chiavi primarie sono sottolineate, gli attributi opzionali sono indicati con *): <!-- omit in toc -->

<div style="background-color: #f0f0f0; padding: 10px; border-radius: 5px; color:#000000">
STUDENTE (<u>MatrS</u>, NomeS, CognomeS, Corso di Laurea) <br>
CORSO (<u>CodC</u>, NomeC, Descrizione, CFU)<br>
ESAME (<u>MatrS</u>, <u>CodC</u>, Data, Voto) <br>
RISPOSTE (<u>MatrS</u>, <u>CodC</u>, <u>Data</u>, <u>Domanda</u>, Corretta) <br>
</div>

#### Integrità referenziale: <!-- omit in toc -->
Attributi con lo stesso nome in tabelle diverse indicano un vincolo di integrità referenziale. 

#### Esprimere la seguente interrogazione in linguaggio SQL <!-- omit in toc -->

Per ciascuno studente visualizzare:
- matricola
- per ciascun corso in cui lo studente ha conseguito un voto superiore al voto medio conseguito dagli studenti, visualizzare:
  - il codice del corso, 
  - il voto conseguito dallo studente
  - il numero di domande a cui lo studente ha risposto correttamente (attributo Corretta  uguale a True).  

### Soluzione
```sql
WITH MEDIA AS (
    SELECT CodC, AVG(Voto) AS MediaCorso
    FROM ESAME
    GROUP BY CodC
),

CORRETTE AS (
    SELECT MatrS, CodC, COUNT(*) AS NumCorrette
    FROM RISPOSTE
    WHERE Corretta = TRUE
    GROUP BY MatrS, CodC
),

VALUTAZIONE_STUDENTI AS (
    SELECT S.MatrS, E.CodC, E.Voto, (CASE WHEN C.NumCorrette IS NULL THEN 0 ELSE C.NumCorrette END) AS NumCorrette
    FROM STUDENTE S
    JOIN ESAME E ON S.MatrS = E.MatrS
    LEFT JOIN CORRETTE C ON E.MatrS = C.MatrS AND E.CodC = C.CodC
)

SELECT S.MatrS, S.CodC, S.Voto, S.NumCorrette
FROM VALUTAZIONE_STUDENTI S, MEDIA M
WHERE S.Voto > M.MediaCorso
AND S.CodC = M.CodC;
```

## Esercizio 3
### Traccia
#### Sono date le seguenti relazioni (le chiavi primarie sono sottolineate, gli attributi opzionali sono indicati con *): <!-- omit in toc -->

<div style="background-color: #f0f0f0; padding: 10px; border-radius: 5px; color:#000000">
CORSO (<u>CodC</u>, NomeC, CodDocente, Descrizione, CFU) <br>
DOCENTE (<u>CodDocente</u>, Nome, Cognome, Dipartimento) <br>
LEZIONE (<u>CodC</u>, <u>Data</u>, <u>OraInizio</u>, Aula) <br>  
STUDENTE (<u>MatricolaS</u>, Nome, Cognome, Corso di Laurea)<br>  
FREQUENTA_LEZIONE (<u>CodC</u>, <u>Data</u>, <u>OraInizio</u>, <u>MatricolaS</u>)  
</div>

#### Integrità referenziale: <!-- omit in toc -->
Attributi con lo stesso nome in tabelle diverse indicano un vincolo di integrità referenziale.  
Inoltre  
FREQUENTA_LEZIONE (CodC, Data, OraInizio) REFERENCES LEZIONE (CodC, Data, OraInizio)

#### Esprimere la seguente interrogazione in linguaggio SQL <!-- omit in toc -->

Per ogni docente, visualizzare:
- nome
- cognome
- dipartimento
- codice
- nome
- numero complessivo di lezioni per ciascun corso di cui il docente è responsabile, considerando solo i corsi che soddisfano i seguenti requisiti: 
  - non hanno mai avuto più di 2 lezioni in uno stesso giorno
  - hanno avuto un numero di lezioni superiore al numero medio di lezioni dei corsi tenuti da docenti afferenti allo stesso dipartimento (considerando tutti i corsi). 
  
### Soluzione
```sql
WITH RESPONSABILE AS (
  SELECT CodC, COUNT(*) AS NumeroLezioni
  FROM LEZIONE
  GROUP BY CodC
),

MEDIA_DIPARTIMENTO AS (
  SELECT D.Dipartimento, AVG(R.NumeroLezioni) AS MediaLezioni
  FROM DOCENTE D
  JOIN CORSO C ON D.CodDocente = C.CodDocente
  JOIN RESPONSABILE R ON C.CodC = R.CodC
  GROUP BY D.Dipartimento
),

CORSI_VALIDI AS (
  SELECT CodC
  FROM LEZIONE
  GROUP BY CodC, Data
  HAVING COUNT(*) <= 2
),

SELECT D.Nome, D.Cognome, D.Dipartimento, D.CodDocente, C.NomeC, R.NumeroLezioni
FROM DOCENTE D
JOIN CORSO C ON D.CodDocente = C.CodDocente
JOIN RESPONSABILE R ON C.CodC = R.CodC
JOIN MEDIA_DIPARTIMENTO MD ON D.Dipartimento = MD.Dipartimento
JOIN CORSI_VALIDI CV ON C.CodC = CV.CodC
WHERE R.NumeroLezioni > MD.MediaLezioni
  
```

## Esercizio 4
### Traccia
#### Sia dato il seguente schema relazionale (le chiavi primarie sono sottolineate, gli attributi opzionali sono indicati con ‘*’): <!-- omit in toc -->

<div style="background-color: #f0f0f0; padding: 10px; border-radius: 5px; color:#000000">
RISTORANTE (<u>CodR</u>, Nome, Categoria, Indirizzo, Città) <br>
RIASSUNTO_RECENSIONI (<u>CodR</u>, NumeroRecensioni, PunteggioComplessivo) <br>
NOTIFICA (<u>CodR</u>, <u>DataRecension</u>, PunteggioMedioRistorante, PunteggioMedioCittà) <br>
RECENSIONE_RISTORANTE (<u>RecNo</u>, DataRecensione, CodR, Punteggio, Commento) <br>
</div>


Si scriva il trigger per gestire le recensioni di ristoranti raccolte attraverso un portale web.

La tabella RISTORANTE contiene l’elenco dei ristoranti per cui è possibile inviare una recensione.  
La tabella RIASSUNTO_RECENSIONI contiene, per ogni ristorante, il numero complessivo di recensioni ricevute e il punteggio complessivo  assegnato.  
Si consideri che un ristorante è presente nella tabella RIASSUNTO_RECENSIONI solo se è stata inserita almeno una recensione per quel ristorante.  

Viene inserita attraverso il portale una nuova recensione per un ristorante (inserimento di un record nella tabella RECENSIONE_ RISTORANTE).  
Il trigger deve svolgere le seguenti operazioni:
- Si deve aggiornare la tabella RIASSUNTO_RECENSIONI tenendo conto della recensione appena inoltrata. Si consideri anche il caso che questa sia la prima recensione inserita per il ristorante.
- Si deve quindi inserire un nuovo record nella tabella NOTIFICA con le informazioni sul punteggio medio assegnato al ristorante (attributo  PunteggioMedioRistorante). Deve inoltre essere notificato il punteggio medio assegnato per città (attributo PunteggioMedioCittà) calcolato come punteggio complessivo medio per tutti i ristoranti situati nella stessa città in cui si trova il ristorante che ha ricevuto la recensione. 

#### Indicazioni per lo svolgimento dell’esercizio: <!-- omit in toc -->
Si chiede di scrivere il trigger secondo i requisiti sopra riportate. Se necessario, usare la funzione raise_application_error (…) per segnalare un errore. Non è richiesto di specificare i parametri passati alla funzione.

### Soluzione

#### Struttura del Trigger <!-- omit in toc -->
Il trigger deve essere eseguito dopo l'inserimento (AFTER INSERT) nella tabella RECENSIONE_RISTORANTE e deve:
1. Aggiornare RIASSUNTO_RECENSIONI con il nuovo punteggio.
2. Inserire una notifica in NOTIFICA con i punteggi medi (ristorante e città).

#### Logica del Trigger <!-- omit in toc -->
1. Aggiornare RIASSUNTO_RECENSIONI:
    - Se il ristorante esiste, incrementare il numero di recensioni e aggiornare il punteggio complessivo.
    - Se non esiste, inserire un nuovo record con NumeroRecensioni = 1 e PunteggioComplessivo = Punteggio della nuova recensione.
2. Inserire un record in NOTIFICA:
    - Calcolare il punteggio medio del ristorante.
    - Calcolare il punteggio medio della città.

#### codice del Trigger <!-- omit in toc -->
```sql
CREATE TRIGGER controllo
AFTER INSERT ON RECENSIONE_RISTORANTE
FOR EACH ROW

DECLARE 
    X NUMBER;
    punteggio_medio_ristorante NUMBER;
    punteggio_medio_citta NUMBER;
    citta_riferimento TEXT;
BEGIN
    -- 1. Aggiornare RIASSUNTO_RECENSIONI
      SELECT COUNT(*) INTO X
      FROM RIASSUNTO_RECENSIONI RR
      WHERE RR.CodR = :NEW.CodR;

      IF X<>0 THEN
      -- Se il ristorante esiste, incrementare il numero di recensioni e aggiornare il punteggio complessivo.
        UPDATE RIASSUNTO_RECENSIONI
        SET NumeroRecensioni = NumeroRecensioni + 1,
            PunteggioComplessivo = PunteggioComplessivo + :NEW.Punteggio
        WHERE CodR = :NEW.CodR;
      ELSE
      -- Se non esiste, inserire un nuovo record con NumeroRecensioni = 1 e PunteggioComplessivo = Punteggio della nuova recensione.
        INSERT INTO RIASSUNTO_RECENSIONI (CodR, NumeroRecensioni, PunteggioComplessivo)
        VALUES (:NEW.CodR, 1, :NEW.Punteggio);
      END IF;

    -- 2. Inserire un record in NOTIFICA
      -- Calcolare il punteggio medio del ristorante.
      SELECT PunteggioComplessivo / NumeroRecensioni
      INTO punteggio_medio_ristorante
      FROM RIASSUNTO_RECENSIONI
      WHERE CodR = NEW.CodR;
      -- Calcolare il punteggio medio della città.
      SELECT Città INTO citta_riferimento
      FROM RISTORANTE
      WHERE CodR = :NEW.CodR;

      SELECT AVG(RR.PunteggioComplessivo /RR. NumeroRecensioni)
      INTO punteggio_medio_citta
      FROM RIASSUNTO_RECENSIONI RR
      JOIN RISTORANTE R ON RR.CodR = R.CodR
      WHERE R.Città = citta_riferimento;

      -- Inserire il record in NOTIFICA
      INSERT INTO NOTIFICA (CodR, DataRecension, PunteggioMedioRistorante, PunteggioMedioCittà)
      VALUES ( :NEW.CodR, :NEW.DataRecensione, punteggio_medio_ristorante, punteggio_medio_citta );
END;
```