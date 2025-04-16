### Quaderno 1 - Distributori Automatici
# Schema Logico Relazionale


DISTRIBUTORE (<u>CodDistr</u>, dipartimento, piano, altezza, larghezza, profondita)<br> 
PERSONALE (<u>CodPers</u>, Nome, Cognome, DataAssunzione, Ruolo)<br> 
MANUTENZIONE (<u>CodPers</u>, <u>CodDistr</u>)<br> 
COMPETENZE_TECNICHE(<u>CompetenzaTecnica</u>)<br> 
HAS_COMPETENZE_TECNICHE(<u>CompetenzaTecnica</u>, <u>CodPers</u>)<br> 
RIFORNIMENTO(<u>CodPers</u>, <u>data_e_ora</u>, CodDistr)<br> 
PRODOTTO(<u>CodProd</u>, NomeProdotto, Societa, Prezzo, Type, Tipologia*, SenzaZucchero*)<br> 
RIEMPE(<u>CodProd</u>, <u>CodPers</u>, <u>data_e_ora</u>)<br> 
INGREDIENTI(<u>Ingrediente</u>)<br> 
HAS_INGREDIENTI(<u>Ingrediente</u>, <u>CodProd</u>)<br> 
SPESA(<u>CodDistr</u>, <u>CodChiavetta</u>, <u>Data</u>, <u>Orario</u>, Importo)<br> 
CHIAVETTA(<u>CodChiavetta</u>, ImportoMassimo)<br> 
RICARICA(<u>CodChiavetta</u>, <u>DataRicarica</u>, <u>OrarioRicarica</u>, Importo)<br> 
ASSEGNAZIONE(<u>CodChiavetta</u>, <u>Data_Inizio</u>, Data_Fine, CodiceFiscale)<br> 
DIPENDENTE(<u>CodiceFiscale</u>, Nome, Cognome, Ruolo)<br> 