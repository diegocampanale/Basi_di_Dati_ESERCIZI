# Soluzioni Svolte 

ESERCIZIO 1:
VER1:
 
WITH COMPITI AS (SELECT H.CodHW, H.DataScadenza, H.Titolo, H.Argomento, H.CodDReferente
FROM HOMEWORK H
WHERE H.Argomento='integrali' OR H.Argomento ='equazioni differenziali'),
 
CONSEGNA AS ( SELECT V.CodHW, V.DataConsegna, V.DataValutazione, V.Valutazione
             FROM VALUTAZIONE V),
 
 
RITARDI_CON_JOIN AS (SELECT COM.CodHW,COM.Titolo, COM.Argomento, COM.CodDReferente, CON.DataConsegna, CON.DataValutazione, CON.Valutazione, COM.DataScadenza
FROM COMPITI COM, CONSEGNA CON
WHERE CON.CodHW=COM.CodHW AND CON.DataConsegna>=COM.DataConsegna)
 
 
SELECT R.Titolo, R.Argomento, D.CognomeD, AVG(R.Valutazione) AS MediaValutazioni, AVG(R.DataValutazione - R.DataConsegna) AS MediaGiorniValutazione
FROM RITARDI_CON_JOIN R, DOCENTE D
WHERE R.CodReferente = D.CodD
GROUP BY R.CodHW, R.Titolo, R.Argomento, D.CognomeD
HAVING COUNT(*)>=5
 
VER2: (CHAT)
SELECT H.Titolo, H.Argomento, D.CognomeD, AVG(V.Valutazione)AS MediaValutazioni, AVG (V.DataValutazione - V.DataConsegna) AS MediaGiorniValutazione
FROM HOMEWORK H, DOCENTE D, VALUTAZIONE V
WHERE D.CodD=H.CodDReferente
     AND H.CodHW = V.CodHW
     AND (H.Argomento = 'integrali' OR H.Argomento = 'equazioni differenziali')
     AND V.DataConsegna >= H.DataScadenza
GROUP BY H.CodHW, H.Titolo, H.Argomento, D.CognomeD
HAVING COUNT(*)>=5
 
 
ESERCIZIO 2:
WITH MEDIA AS (
   SELECT CodC,AVG(VOTO) AS MediaCorso
   FROM ESAME
   GROUP BY CodC
), CORRETTE AS (
   SELECT MatrS, CodC, COUNT (*) AS NumCorrette
   FROM RISPOSTE
   WHERE Corretta = TRUE
   GROUP BY MatrS, CodC
)
 
SELECT
   S.MatrS,
   E.CodC,
   E.Voto,
   CASE
       WHEN C.NumCorrette IS NULL THEN 0
       ELSE C.NumCorrette
   END AS NumCorrette
 
FROM
   STUDENTE S, MEDIA M, ESAME E, CORRETTE C
   LEFT JOIN CORRETTE C ON E.MatrS = C.MatrS AND E.CodC= C.CodC
   
WHERE S.MatrS=E.MatrS AND E.CodC = M.CodC AND E.Voto>M.MediaCorso AND C.MatrS=S.MatrS AND C.CodC=E.CodC
 
ESERCIZIO 3:
CREATE VIEW RESPONSABILE AS(
   SELECT CodC, COUNT(*) AS NumeroLezioni
   FROM LEZIONE L
   GROUP BY CodC
);
 
SELECT DISTINCT D.Nome, D.Cognome, D.Dipartimento, D.CodDocente, C.NomeC, R.NumeroLezioni
FROM DOCENTE D, CORSO C, RESPONSABILE R
WHERE D.CodDocente = C.CodDocente
   AND R.CodC=C.CodC
   AND R.CodC NOT IN (SELECT CodC
                       FROM LEZIONE
                       GROUP BY CodC, Data
                       HAVING COUNT(*)>2)
   AND R.NumeroLezioni>  (
       SELECT AVG (R.NumeroLezioni)
       FROM DOCENTE D2, RESPONSABILE R2, CORSO C2
       WHERE C2.CodC=R2.CodC
           AND D2.CodDocente=C2.CodDocente
           AND D2.Dipartimento = D.Dipartimento
   )


ESERCIZIO 4:
EVENTO: INSERT NUOVA RECENSIONE
TABELLA MUTANTE: RECENSIONE_RISTORANTE
CONDIZIONE: -
AZIONE:
​Controllare che quel ristorante sia presente in RIASSUNTO_RECENSIONE
a) Se è presente, UPDATE di NumeroRecensioni e di PunteggioComplessivo
b) Se non è presente, INSERT nuovo record con NumeroRecensioni pari a 1 e PunteggioComplessivo pari al punteggio dato da quella recensione
c) Inserimento di un nuovo record in NOTIFICA
GRANULARITÀ: FOR EACH ROW
MODO DI ESECUZIONE: AFTER
 
Soluzione:
CREATE TRIGGER controllo
AFTER INSERT ON RECENSIONE_RISTORANTE
FOR EACH ROW
DECLARE
   Z NUMBER;
BEGIN
--​Verificare se esiste già un record per quel codice ristorante nella tabella RIASSUNTO_RECENSIONI
--      a.​Se il record è già presente, allora il record è aggiornato
--      b.​Se non è presente, un nuovo record viene inserito
END
Soluzione:
CREATE TRIGGER controllo
AFTER INSERT ON RECENSIONE_RISTORANTE
FOR EACH ROW
DECLARE
   Z NUMBER;
   punteggio_medio_ristorante NUMBER;
   punteggio_medio_citta NUMBER;
   citta char(50);
BEGIN
   SELECT COUNT(*) INTO Z
   FROM RIASSUNTO_RECENSIONI RR
   WHERE RR.CodR = :NEW.CodR;
 
   IF Z<>0 THEN
   -- Se il record è presente, aggiorna il record:
       UPDATE RIASSUNTO_RECENSIONI
       SET NumeroRecensioni = NumeroRecensioni +1,
           PunteggioComplessivo = PunteggioComplessivo + :NEW.Punteggio
       WHERE CodR= :NEW.CodR;
   ELSE
   -- Se non è presente, inserisci un nuovo record:
       INSERT INTO RIASSUNTO_RECENSIONI (CodR, NumeroRecensioni, PunteggioComplessivo)
           VALUES (:NEW.CodR, 1, :NEW.Punteggio);
   END IF;
 
   -- PRENDO LA CITTA DEL RISTORANTE
       SELECT Citta INTO citta
       FROM RISTORANTE R
       WHERE R.CodR= :NEW.CodR;
 
       SELECT PunteggioComplessivo/NumeroRecensioni INTO punteggio_medio_ristorante
       FROM RIASSUNTO_RECENSIONI
       WHERE CodR=:NEW.CodR;
   -- CALCOLO IL PUNTEGGIO MEDIO PER LA CITTA
 
       SELECT AVG(PunteggioComplessivo/NumeroRecensioni) into punteggio_medio_citta
       FROM  RIASSUNTO_RECENSIONI RR, RISTORANTE R
       WHERE RR.CodR=R.CodR AND R.Città = citta;
 
   -- INSERISCO RECORD IN NOTIFICA
   INSERT INTO NOTIFICA (CodR, DataRecensione, PunteggioMedioRistorante, PunteggioMedioCittà)
       VALUES (:NEW.CodR, :NEW.DataRecensione, punteggio_medio_ristorante, punteggio_medio_citta );
END;