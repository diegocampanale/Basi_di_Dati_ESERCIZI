### Quaderno 1 - Distributori Automatici
# Vincoli di Integrità Referenziale Relazioni

## Relazione 1 : MANUTENZIONE
<!-- DISTRIBUTORE (<u>CodDistr</u>, dipartimento, piano, altezza, larghezza, profondita)<br> 
PERSONALE (<u>CodPers</u>, Nome, Cognome, DataAssunzione, Ruolo)<br> 
MANUTENZIONE (<u>CodPers</u>, <u>CodDistr</u>)<br>  -->

MANUTENZIONE(CodPers) REFERENCES PERSONALE(CodPers)<br>
MANUTENZIONE(CodDistr) REFERENCES DISTRIBUTORE(CodDistr)<br>

## Relazione 2 : RIEMPIE
<!-- PRODOTTO(<u>CodProd</u>, NomeProdotto, Societa, Prezzo, Type, Tipologia*, SenzaZucchero*)<br> 
RIFORNIMENTO(<u>CodPers</u>, <u>data_e_ora</u>, CodDistr)<br>
RIEMPE(<u>CodProd</u>, <u>CodPers</u>, <u>data_e_ora</u>)<br>  -->

RIEMPIE(CodProd) REFERENCES PRODOTTO(CodProd)<br>
RIEMPIE(CodPers, data_e_ora) REFERENCES RIFORNIMENTO(CodPers, data_e_ora)<br>

## Relazione 3 : HAS_COMPETENZE_TED
<!-- PERSONALE (<u>CodPers</u>, Nome, Cognome, DataAssunzione, Ruolo)<br> 
COMPETENZE_TECNICHE(<u>CompetenzaTecnica</u>)<br> 
HAS_COMPETENZE_TECNICHE(<u>CompetenzaTecnica</u>, <u>CodPers</u>)<br>  -->

HAS_COMPETENZE_TECNICHE(CompetenzaTecnica) REFERENCES COMPETENZE_TECNICHE(CompetenzaTecnica)<br>
HAS_COMPETENZE_TECNICHE(CodPers) REFERENCES PERSONALE(CodPers)<br>


# Vincoli di Integrità Referenziale Relazioni

## Relazione 1 : MANUTENZIONE
MANUTENZIONE(CodPers) REFERENCES PERSONALE(CodPers)<br>
MANUTENZIONE(CodDistr) REFERENCES DISTRIBUTORE(CodDistr)<br>

## Relazione 2 : RIEMPIE
RIEMPIE(CodProd) REFERENCES PRODOTTO(CodProd)<br>
RIEMPIE(CodPers, data_e_ora) REFERENCES RIFORNIMENTO(CodPers, data_e_ora)<br>

## Relazione 3 : HAS_COMPETENZE_TED
HAS_COMPETENZE_TECNICHE(CompetenzaTecnica) REFERENCES COMPETENZE_TECNICHE(CompetenzaTecnica)<br>
HAS_COMPETENZE_TECNICHE(CodPers) REFERENCES PERSONALE(CodPers)<br>