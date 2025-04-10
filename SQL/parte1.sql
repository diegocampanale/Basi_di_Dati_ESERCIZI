
---------------------------------------------------------------------------------------------------------------------------------------
--    ESECIZI JOIN, GROUP BY
---------------------------------------------------------------------------------------------------------------------------------------

-- 1. Sia dato il seguente schema relazionale - (le chiavi primarie sono sottolineate, gli attributi opzionali sono indicati con “*”)--

    STUDENTE (MatrS, NomeS, Città)
    CORSO (CodC, NomeC, MatrD)
    DOCENTE (MatrD, NomeD)
    ESAME (CodC, MatrS, Data, Voto)

    -- a) Per ogni studente, visualizzare la matricola e il voto massimo, minimo e medio conseguito negli esami
        SELECT MatrS, MAX(Voto), MIN(Voto), AVG(Voto)
        FROM ESAME
        GROUP BY MatrS

    -- b) Per ogni studente, visualizzare la matricola, il nome e il voto massimo, minimo e medio conseguito negli esami
        SELECT NomeS, MAX(Voto), MIN(Voto), AVG(Voto)
        FROM ESAME E, STUDENTE S
        WHERE E.MatrS = S.MatrS
        GROUP BY S.MatrS, NomeS

    -- c) Per ogni studente che ha una media voti superiore al 28, visualizzare la matricola, il nome e il voto massimo, minimo e medio conseguito negli esami
        SELECT NomeS, MAX(Voto), MIN(Voto), AVG(Voto)
        FROM ESAME E, STUDENTE S
        WHERE E.MatrS = S.MatrS
        GROUP BY S.MatrS, NomeS
        HAVING AVG(Voto)>28

    -- d) Per ogni studente che ha una media voti superiore al 28 e ha sostenuto esami in almeno 10 date diverse, visualizzare la matricola, il nome e il voto massimo, minimo e medio conseguito negli esami
        
        SELECT NomeS, MAX(Voto), MIN(Voto), AVG(Voto)
        FROM ESAME E, STUDENTE S
        WHERE E.MatrS = S.MatrS
        GROUP BY S.MatrS, NomeS
        HAVING AVG(Voto)>28 AND COUNT(DISTINCT DATA >= 10)

    -- extra) Per ogni studente visualizzare la matricola e il numero di esami sostenuti in ciascuna data

        SELECT MatrS, COUNT(*)
        FROM ESAME
        GROUP BY MatrS, Data


-- 2. Sia dato il seguente schema relazionale (le chiavi primarie sono sottolineate, gli attributi opzionali sono indicati con “*”) --

    PERSONA ('CodFisc', NomeP, DataNascita)
    ISTRUTTORE ('CodI', NomeI)
    LEZIONE_PRIVATA ('CodFisc', 'Data', 'Ora', CodI)

    -- c) Per ogni persona visualizzare il codice fiscale, il nome, il numero di lezioni frequentate e il numero di istruttori (diversi) con cui ha fatto lezione

        SELECT P.CodFisc, P.NomeP, COUNT(*), COUNT(DISTINCT CodI)
        FROM PERSONA P, LEZIONE_PRIVATA LP 
        WHERE P.CodFisc=LP.CodFisc
        GROUP BY P.CodFisc, NomeP

    -- d) Per ogni persona nata dopo il 1970 che ha frequentato almeno 5 lezioni, visualizzare il codice fiscale, il nome, il numero di lezioni frequentate e il numero di istruttori (diversi) con cui ha fatto lezione

        SELECT P.CodFisc, P.NomeP, COUNT(*), COUNT(DISTINCT CodI)
        FROM PERSONA P, LEZIONE_PRIVATA LP 
        WHERE P.CodFisc=LP.CodFisc AND P.DataNascita > 1970 
        GROUP BY P.CodFisc, NomeP
        HAVING COUNT(*) >= 5

-- 3. Sia dato il seguente schema relazionale

    CORSO ('CodCorso', NomeC, Anno, Semestre)
    ORARIO-LEZIONI ('CodCorso', 'GiornoSettimana', 'OraInizio', OraFine, Aula)

    -- a) Trovare codice corso, nome corso e numero totale di ore di lezione settimanali per i corsi del terzo anno per cui il numero 
    -- complessivo di ore di lezione settimanali è superiore a 10 e le lezioni sono in piu` di tre giorni diversi della settimana.

        SELECT C.CodCorso, C.NomeC, SUM(OraFine-OraInizio)
        FROM CORSO C, ORARIO-LEZIONI OL, 
        WHERE C.CodCorso = OL.CodCorso AND C.Anno = 3 
        GROUP BY C.CodCorso, NomeC
        HAVING SUM(OraFine-OraInizio) > 10 AND COUNT(DISTINCT GiornoSettimana)>3

-- 4. Sia dato il seguente schema relazionale

        ALLOGGIO ('CodA', Indirizzo, Città, Superficie, CostoAffittoMensile)
        CONTRATTO-AFFITTO ('CodC', DataInizio, DataFine*, NomePersona, CodA)
    -- N.B. Superficie espressa in metri quadri. Per i contratti in corso, DataFine è NULL.

    -- a) Trovare il nome delle persone che hanno stipulato più di due contratti di affitto per lo stesso appartamento 
    -- (in tempi diversi).

        SELECT NomePersona
        FROM CONTRATTO-AFFITTO
        GROUP BY NomePersona, CodA
        HAVING COUNT(*)>2

    -- b) Trovare, per le città in cui sono stati stipulati almeno 100 contratti, la città, il costo mensile massimo degli affitti, il costo 
    -- mensile medio degli affitti, la durata massima dei contratti, la durata media dei contratti e il numero totale di contratti stipulati.

        SELECT Città, MAX(CostoAffittoMensile), AVG(CostoAffittoMensile), MAX(DataFine - DataInizio), AVG(DataFine - DataInizio), COUNT(*), COUNT(DISTINCT CodA)
        FROM ALLOGGIO A, CONTRATTO-AFFITTO CA
        WHERE A.CodA = CA.Cod AND DataFine IS NOT NULL
        GROUP BY Citta
        HAVING COUNT(*) >= 100


--------------------------------------------------------------------------------------------------------------------------------------
-- ESERCIZI QUERY ANNIDATE
--------------------------------------------------------------------------------------------------------------------------------------

--  1. Sia dato il seguente schema relazionale (le chiavi primarie sono sottolineate, gli attributi opzionali sono indicati con “*”)   

    ORCHESTRA (CodO, NomeO, NomeDirettore, NumElementi)
    SALA (CodS, NomeS, Città, Capienza)
    CONCERTI (CodC, Data, CodO, CodS, PrezzoBiglietto)

    -- a) Trovare il codice e il nome delle orchestre con più di 30 elementi che hanno tenuto concerti sia a Torino, 
    -- sia a Milano e non hanno mai tenuto concerti a Bologna.

        SELECT CodO, NomeO
        FROM ORCHESTRA O
        WHERE NumElementi > 30
        AND CodO IN (
            SELECT CodO
            FROM SALA S, CONCERTI C
            WHERE Citta='Torino' AND S.CodS = C.CodS)
        AND CodO IN (
            SELECT CodO
            FROM SALA S, CONCERTI C
            WHERE Citta='Milano' AND S.CodS = C.CodS)
        AND CodO NOT IN (
            SELECT CodO
            FROM SALA S, CONCERTI C
            WHERE Citta='Bologna' AND S.CodS = C.CodS)

        -- ALTERNATIVA

        SELECT CodO, NomeO
        FROM ORCHESTRA O, SALA S, CONCERTI C
        WHERE NumElementi > 30 AND Citta = 'Torino' AND S.CodS = C.CodS 
        AND O.CodO = C.CodO
        AND O.CodO IN (
            SELECT CodO
            FROM SALA S, CONCERTI C
            WHERE Citta='Milano' AND S.CodS = C.CodS)
        AND O.CodO NOT IN (
            SELECT CodO
            FROM SALA S, CONCERTI C
            WHERE Citta='Bologna' AND S.CodS = C.CodS)

        -- b) Soluzione con operatori EXIST 
            SELECT O.CodO, O.NomeO
            FROM ORCHESTRA O
            WHERE NumElementi > 30
            AND EXISTS (
                SELECT *
                FROM SALA S, CONCERTI C
                WHERE Citta='Torino' AND S.CodS-C.CodS
                AND O.CodO = C.CodO)
            AND EXISTS (
                SELECT *
                FROM SALA S, CONCERTI C
                WHERE Citta='Milano' AND S.CodS-C.CodS
                AND O.CodO = C.CodO)
            AND NOT EXISTS('... continua ')

-- 2. Sia dato il seguente schema relazionale (le chiavi primarie sono sottolineate, gli attributi opzionali sono indicati con “*”)

    CORSO ('CodCorso', NomeC, Anno, Semestre)
    ORARIO-LEZIONI ('CodCorso', 'GiornoSettimana', 'OraInizio', OraFine, Aula)

    -- Trovare le aule in cui non si tengono mai lezioni di corsi del primo anno.
    
        SELECT Aula
        FROM ORARIO-LEZIONI OL
        WHERE Aula NOT IN (
            SELECT Aula
            FROM CORSO C, ORARIO-LEZIONI OL
            WHERE C.CodCorso = OL.CodCorso AND Anno = 1)
        