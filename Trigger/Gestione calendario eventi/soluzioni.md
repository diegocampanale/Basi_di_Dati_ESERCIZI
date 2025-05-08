# Esercizi trigger: Gestione calendario eventi

**EVENTO** (<u>CodE</u>, NomeEvento, CategoriaEvento, CostoEvento, DurataEvento)
**CALENDARIO_EVENTI** (<u>CodE</u>, Data, OraInizio, Luogo)
**SOMMARIO_CATEGORIA** (<u>CategoriaEvento</u>, <u>Data</u>, NumeroTotaleEventi, CostoComplessivoEventi)

Si vuole gestire la pianificazione degli eventi nella città di Torino per l’anniversario dei 150 anni
dell’unità d’Italia (Italia 150).
Gli eventi appartengono a diverse categorie (attributo CategoriaEvento), quali mostre, dibattiti,
proiezioni, e sono caratterizzati da un costo di realizzazione (attributo CostoEvento). Ciascun evento può
essere ripetuto più volte in date diverse. La tabella CALENDARIO_EVENTI riporta la pianificazione
degli eventi in diversi giorni e luoghi della città. Si scrivano i trigger per gestire le seguenti attività.

## 1. Aggiornamento della tabella SOMMARIO_CATEGORIA.  
La tabella SOMMARIO_CATEGORIA
riporta, per ogni categoria di evento e per ogni data, il numero complessivo di eventi previsti e il costo
complessivo per la loro realizzazione.  
Si scriva il trigger per propagare le modifiche alla tabella SOMMARIO_CATEGORIA quando viene
inserito un nuovo evento a calendario (inserimento nella tabella CALENDARIO_EVENTI).

EVENTO: `INSERT INTO CALENDARIO_EVENTI`  
**TABELLA MUTANTE** (TABELLA TARGET): `CALENDARIO_EVENTI`   
CONDIZIONE   
**AZIONE**  
* Leggere la tabella `EVENTO` la Categoria e il Costo per il nuovo evento inserto in `CALENDARIO_EVENTI`
* Verificare se esiste fià un record per quella categoria nella tabella `SOMMARIO_CATEGORIA`   
    a. Se il record è già presente -> il record è aggiornato   
    b. Se il record non è presente -> un nuovo record è inserito   

GRANULARITA: tupla (`FOR EACH ROW`)  
MODO DI ESECUZIONE: `AFTER`



``` [MySQL]
CREATE TRIGGER aggirona_sommario_categoria
AFTER INSERT ON CALENDARIO_EVENTI
FOR EACH ROW
DECLARE
```

``` [mySQL]
BEGIN
-- Leggere la tabella EVENTO la Categoria e il Costo per il nuovo evento inserto in CALENDARIO_EVENTI

SELECT CategoriaEvento, CostoEvento INTO X,Y
FROM EVENTO
WHERE CodE = :NEW.CodE;
```

```[mySQL]
--- Verificare se esiste fià un record per quella categoria nella tabella SOMMARIO_CATEGORIA

SELECT COUNT(*)
FROM SOMMARIO_CATEGORIA
WHERE CategoriaEvento = X AND Data = :NEW.Data;
```

```[mySQL]
IF Z <> 0 THEN
-- Se il record è già presente -> il record è aggiornato
UPDATE SOMMARIO_CATEGORIA
SET NumeroTotaleEventi = NumeroTotaleEventi + 1,
    CostoComplessivoEventi = CostoComplessivoEventi + Y
WHERE CategoriaEvento = X AND Data = :NEW.Data;

ELSE
-- Se il record non è presente -> un nuovo record è inserito
INSERT INTO SOMMARIO_CATOGORIA (CategoriaEvento, Data, NumeroTotaleEventi, CostoComplessivoEventi) VALUES (X, :NEW.Data, 1, Y);

END IF;
END;
```

## 2. Vincolo di integrità sul costo massimo dell’evento.  
Il costo di un evento della categoria proiezione
cinematografica (attributo CategoriaEvento) non può essere superiore a 1500 euro.   
Se un valore di costo superiore a 1500 è inserito nella tabella EVENTO, all’attributo CostoEvento deve essere assegnato il valore 1500.   
Si scriva il trigger per la gestione del vincolo di integrità.

EVENTO: `INSERT ON EVENTO OR UPDATE OF CostoEvento, CategoriaEvento ON EVENTO`  
TABELLA TARGET: `EVENTO`  
CONDIZIONE  
AZIONE: Per ogni record modificato (inserito o modificato con update):
- Se la categoria è proiezione cinematografica e il costo è superiore a 1500 -> si deve assegnare il costo al valore 1500 

GRANULARITA'  tupla (`FOR EACH ROW`)  
MODO DI ESECUZIONE: `BEFORE`  

``` [MySQL]
CREATE TRIGGER massimo_costo_evento
BEFORE INSERT OR UPDATE OF CostoEvento, CategoriaEvento ON EVENTO
FOR EACH ROW
WHEN (NEW.CategoriaEvento = 'Proiezione' AND NEW.CostoEvento > 1500)

BEGIN
:NEW.CostoEvento := 1500;
END;
```

## 3. Vincolo sul numero massimo di eventi per data
In ogni data non possono essere pianificati più di 10 eventi. Ogni modifica della tabella `CALANDARIO_EVENTI` che causa la violazione del vincolo non deve essere eseguita.

EVENTO: `INSERT ON CALENDARIO_EVENTI OR UPDATE OF Data ON CALENDARIO_EVENTI`  
TABELLA TARGET: `CALENDARIO_EVENTI`
CONDIZIONE  
AZIONE:
- Se esiste almeno una data che causa la violazione del vincolo -> l'evento non deve essere eseguito (raise_application_error (...))
- Date che causano la violazione del vincolo

    ``` [MySQL]
    SELECT Data
    FROM CALENDARIO_EVENTI
    group by Data
    HAVING COUNT(*) > 10;
    ```
GRANULARITA': istruzione (`FOR EACH STATEMENT`)  
MODO DI ESECUZIONE: `AFTER`  

``` [MySQL]
CREATE TRIGGER verifica_numero_eventi
AFTER INSERT OR UDPARE OF Data ON CALENDARIO_EVENTI
DECLARE
    X NUMBER;
BEGIN

SELECT COUNT(*) INTO X
FROM CALENDARIO_EVENTI
WHERE Data IN (
    SELECT Data
    FROM CALENDARIO_EVENTI
    GROUP BY Data
    HAVING COUNT(*) > 10)
IF X <> 0 THEN
    Raise_application_error(XXX, )

END;
```
