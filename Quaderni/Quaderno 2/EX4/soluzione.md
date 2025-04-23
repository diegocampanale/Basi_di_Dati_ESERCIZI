LUOGO (CodL, Nome, Città, CapienzaMax)

EVENTO (CodE, Titolo, Tipo)

EDIZIONE (CodE, Data, CodL) 



Visualizzare nome e città dei luoghi con capienza massima superiore a 500 che hanno ospitato solo eventi di tipo “fiera” nel primo semestre del 2019. 



A -> EDIZIONE_E2

B -> EDIZIONE_E1

C -> Selezione (p : Data >= 1/1/2019 AND Data <= 30/6/2019)

D -> Selezione (p : Data >= 1/1/2019 AND Data <= 30/6/2019)

E -> Selezione (p : Tipo <> 'Fiera')

F -> Semi-Join (p : E1.CodE = EVENTO.CodE)

G -> LUOGO_L

H -> DIfferenza

I   -> Selezione (p : CapienzaMax > 500)

L  -> Semi-Join (p: L.CodL = E2.CodL)

M -> Proiezione (Nome, Città)