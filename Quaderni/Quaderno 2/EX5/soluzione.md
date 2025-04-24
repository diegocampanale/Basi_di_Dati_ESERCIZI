## Quaderno 2 - Esercizo 5

SALONE_PARRUCCHIERI (CodSP, NomeS, Indirizzo, Città)
SERVIZIO (CodSP, CodS, Descrizione, Prezzo)
PERSONA (CodP, NomeP, Cognome, Telefono, Email)
PRENOTAZIONE(CodP, Mese, Giorno, CodSP, CodS, CostoTotale)

Visualizzare nome e cognome delle persone che, nello stesso mese, hanno effettuato almeno una prenotazione per servizi di costo superiore ai 50 euro, in due diversi saloni di parrucchieri della città di Milano.


A -> SERVIZIO_S1

B -> SALONE_PARRUCCHIERI_SP1

C -> PRENOTAZIONE_P1

D -> SERVIZIO_S2

E -> SALONE_PARRUCCHIERI_SP2

F -> Selezione (p : Prezzo > 50)

G -> Selezione (p: Citta = 'Milano')

H -> Selezione (p: Prezzo > 50)

I -> Selezione (p : Citta = 'Milano')

L  -> Semi-join (p : S1.CodSP = SP1.CodSP)

M -> Semi-join (p: S2.CodSP = SP2.CodSP)

N -> Theta-join (p : S1.CodS = P1.CodS)

O -> Theta-join (p : S2.CodS = P2.CodS)

P -> PERSONA_P

Q -> Semi-join (p : SP1.CodP = SP2.CodP AND SP1.Mese = SP2.Mese AND SP1.CodSP <> SP2.CodSP)

R -> Semi-join (p : P.codP = SP1.CodP)

S -> Proiezione (Nome, Cognome)