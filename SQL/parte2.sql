
---------------------------------------------------------------------------------------------------------------------------------------
--    ESECIZI QUERY ANNIDATE
---------------------------------------------------------------------------------------------------------------------------------------

-- 1. Sia dato il seguente schema relazionale (le chiavi primarie sono sottolineate, gli attributi opzionali sono indicati con “*”)
    GARA (CodG, Luogo, Data, Disciplina)
    ATLETA (CodA, Nome, Nazione, DataNascita)
    PARTECIPAZIONE (CodG, CodA,PosizioneArrivo, Tempo)

    -- a) Trovare il nome e la data di nascita degli atleti italiani che non hanno partecipato a nessuna gara di discesa libera.

    -- b) Trovare le nazioni per cui concorrono almeno 5 atleti nati prima del1980, ciascuno dei quali abbia partecipato ad almeno 
    -- 10 gare di sci di fondo.

        SELECT Nazione
        FROM ATLETA
        WHERE DataNascita < '1980-01-01' 
        AND CodA IN (
            SELECT CodA
            FROM PARTECIPAZIONE P, GARA G
            WHERE P.CodG = G.CodG 
            AND Disciplina = 'sci di fondo'
            GROUP BY CodA
            HAVING COUNT(*) >= 10
        )
        GROUP BY Nazione
        HAVING COUNT(*) >= 5

    -- c extra) Trovare gli atleli che hanno partecipato ad almeno 10 gare di sci di fondo
        SELECT CodA
        FROM PARTECIPAZIONE P, GARA G
        WHERE P.CodG = G.CodG 
        AND Disciplina = 'sci di fondo'
        GROUP BY CodA
        HAVING COUNT(*) >= 10


    