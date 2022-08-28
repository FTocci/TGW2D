# Studio Esecutivo

All’interno di questo capitolo verrà trattato lo sviluppo del progetto nella sua fase
principale, ovvero quella riguardante la messa in atto di tutte le modifiche introdotte nel 
capitolo precedente.
Lo scopo principale è quello di migliorare le prestazioni dell’algoritmo preso in esame
andando ad introdurre all’interno del codice porzioni che presentano la possibilità di
essere eseguite in parallelo. Oltre a ciò, un secondo obiettivo è la re-fattorizzazione di
alcune funzione, garantendo migliore scalabilità e modificabilità dei moduli interessati.

## Calcolo Parallelo in Julia

Come introdotto nei paragrafi precedenti è stato deciso di migliorare le prestazioni
dell’algoritmo usufruendo delle potenzialità garantite dal calcolo parallelo.
Nei prossimi paragrafi verranno illustrate le possibili implementazioni del calcolo
parallelo offerta dal linguaggio di programmazione Julia.

### Task asincroni o coroutine

I task di Julia consentono di sospendere e riprendere i calcoli per l'I/O, la gestione 
degli eventi e modelli simili. I task possono sincronizzarsi attraverso operazioni
come wait e fetch e comunicare tramite canali. Pur non essendo di per sé un
calcolo parallelo, Julia consente di programmare i task su più thread.

###  Multithreading

Il multithreading di Julia offre la possibilità di programmare task
simultaneamente su più di un thread o core della CPU, condividendo la memoria. 
Questo è di solito il modo più semplice per ottenere il parallelismo sul proprio PC
o su un singolo grande server multicore.

### Elaborazione distribuita

Il calcolo distribuito esegue più processi Julia con spazi di memoria separati.
Questi possono trovarsi sullo stesso computer o su più computer. La libreria
standard Distributed fornisce la possibilità di eseguire in remoto una funzione
Julia. Con questo blocco di base, è possibile costruire molti tipi diversi di
astrazioni di calcolo distribuito.

### Elaborazione su GPU

Il compilatore Julia GPU offre la possibilità di eseguire codice Julia in modo nativo
sulle GPU. Esiste un ricco ecosistema di pacchetti Julia che puntano alle GPU.

## Analisi del Codice

Prima dell’attuazione delle modifiche è stata svolta un’analisi dell’algoritmo con
l’obiettivo di misurarne i tempi di esecuzione e di individuare eventuali porzioni di codice 
che potessero rallentare notevolmente l’esecuzione dello stesso.
In tal senso, Julia offre strumenti che possono aiutare a diagnosticare i problemi e a
migliorare le prestazioni del codice. Per questa fase di studio dell’algoritmo sono stati
usati:

1. Profiling: La profilazione consente di misurare le prestazioni del codice in
esecuzione e di identificare le linee che fungono da colli di bottiglia. Per la
visualizzazione dei risultati è stato usato il pacchetto ProfileView.
2. @time: Una macro che esegue un'espressione, stampando il tempo di
esecuzione, il numero di allocazioni e il numero totale di byte che l'esecuzione ha
causato, prima di restituire il valore dell'espressione.

![Profile](Figura3.png)

## Implementazione delle modifiche

All’interno dell’algoritmo è evidente una elevata presenza di cicli, molti dei quali 
annidati. Per questo motivo è stato scelto di utilizzare la tecnica del Multi-threading e in 
particolare, Julia supporta i loop paralleli utilizzando la macro Threads.@threads. Questa 
macro viene apposta davanti a un ciclo for per indicare a Julia che il ciclo è una regione 
multi-thread.

Lo spazio di iterazione viene suddiviso tra i thread, dopodiché ogni thread scrive il
proprio ID thread nelle posizioni assegnate. Prima di eseguire un programma Julia multithread, è necessario impostare il numero di thread. Questo può essere impostato dalla 
linea di comando di Julia, utilizzando gli argomenti della riga di comando -t, o 
modificando la variabile d'ambiente JULIA_NUM_THREADS.

## Re-fattorizzazione

Come anticipato nei paragrafi precedenti è stato scelto di aggiungere alcune nuove
funzioni all’interno del codice così da ridurre le responsabilità di alcuni metodi già
presenti nello stesso. Questa scelta implementativa ha coinvolto prevalentemente la
funzione “merge_vertices”, il cui corpo al termine delle modifiche è risultato 
notevolmente più leggibile. In particolare, le funzioni che sono state aggiunte nel codice 
sono mergeCongruentVertices, mergeCongruentEdges e buildEdgeMap.
