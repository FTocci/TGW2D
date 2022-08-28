# Topological Gift Wrapping 2D - TGW2D

Il topological gift wrapping è un algoritmo che produce un insieme di complessi di catene in 2D. 
Data una qualsiasi collezione di poliedri cellulari la computazione può essere riassunta con i
seguenti passaggi:
1. Estrarre i due scheletri dei poliedri;
2. Fondere in modo efficiente tutte le loro 2-celle;
3. Calcolare su ogni 2-cella il suo complesso di catene locale.
Con tali premesse, l’obiettivo del presente elaborato è stato quello di effettuare una
analisi preliminare del codice a disposizione, individuando i compiti principali che
l’algoritmo svolge, le dipendenze fra le varie funzione che lo compongono e determinare 
eventuali criticità su cui è necessario intervenire.

## Linguaggio Julia

L’algoritmo appena introdotto utilizza Julia come linguaggio di programmazione. Essoè
stato creato con l’intento di garantire alte prestazioni, sfruttando a pieno lepotenzialità 
del calcolo parallelo. È possibile utilizzare primitive che permettono di sfruttare a pieno
i core delle macchine sulle quali viene messo in esecuzione il codiceJulia, grazie al 
meccanismo di multi-threading.
Julia può inoltre generare codice nativo per GPU, risorsa che permette di abbattere
ulteriormente i tempi di esecuzione dell’algoritmo.

## Funzionamento

L’algoritmo è utilizzato localmente su 2-cella per essere decomposta, e invece utilizzato 
globalmente per generare le 3-celle della partizione dello spazio.

![Cycle Extraction](CycleExtraction.png)

Per ogni elemento (1-scheletro) calcolo il bordo ottenendo i due vertici, per ciascun
vertice calcolo il cobordo, ovvero individuo gli altri elementi (1-scheletro) con un vertice 
coincidente (questo passaggio viene effettuato tramite valori matriciali). A questo punto 
si isolano due elementi tra quelli individuati formando così una catena e si ripete 
l’algoritmo sugli elementi della catena appena calcolata. L’obiettivo di ciascuna
iterazione è quello di individuare una porzione nel piano (ovvero la 1-catenadi bordo)

## Illustrazione dello pseudocodice

Lo pseudocodice è il riassunto dell’algoritmo TGW in uno spazio generico
di D-dimensionale.
L’algoritmo prende in input una matrice sparsa di dimensioni “m×n” e restituisce una
matrice dal dominio delle D-catene a quello dei (d-1) cicli orientati.

![pseudocode](Pseudocode.png)