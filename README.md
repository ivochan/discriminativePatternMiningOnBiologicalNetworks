# discriminativePatternMiningOnBiologicalNetworks

Il lavoro di tesi si incentra sull'analisi di dati relativi ai profili genici di alcuni campioni, acquisiti da  **GEO DataSets**, una delle banche dati principali in questo ambito. (https://www.ncbi.nlm.nih.gov/gds)

Questo database, infatti, si occupa della memorizzazione di informazioni relative all'espressione genica, la cui fonte è il repository di **Gene Expression Omnibus** (GEO: https://www.ncbi.nlm.nih.gov/geo/), fornendo oltre che i records dei campioni di acidi nucleici, degli strumenti aggiuntivi che permettano di effettuare, più agevolmente, la ricerca di esperimenti e campioni specifici.

I datasets considerati sono descritti qui di seguito:

- "GSE161134", che corrisponde alle informazioni geniche di 310 pazienti, tra i quali è noto che 120 si siano sottoposti a cure chirurgiche poichè affetti da paradontite o piorrea;
- "GSE25724", cioè dei profili di espressione genici ottenuti utlizzando la tecnica dei microarray, riguardanti 7 individui sani e 6 che, invece, risultano essere affetti da diabete di tipo 2;
- "GSE55200", che consiste in una raccolta di dati relativi all'espressione genica, tratti dall'analisi di tessuto adiposo sottocutaneo, che riguardano la condizione di obesità. Tra i piazienti analizzati sono presenti dei soggetti obesi che accusano dei disturbi metabolici e degli individui obesi che possono, però, essere riconosciuti sani dal punto di vista metabolico;
- "GSE68907", un dataset che, aggregando i dati relativi all'espressione genica sulle caratteristiche comuni riscontate, patologicamente, nel cancro alla prostata, si propone di poter identificare dei geni, il cui manifestarsi possa essere utile per predirre il comportamento clinico di questa malattia.

Il software scelto utilizzato per lavorare i GEODatasets è *Matlab*, poiché provvisto di funzioni in grado di interfacciarsi con questa particolare tipologia di dati.

Inoltre, nella fase di preprocessing dei dati sono stati utilizzati dei file scritti in *Java* per estrarre tutte le informazioni di interesse.

L’algoritmo utilizzato ricerca delle corrispondenze tra le informazioni, rappresentate come reti biologiche.

Nello specifico, sarà oggetto di studio un modello di rete biologica definito *rete di interazione genica*, ovvero una rete complessa, descritta come grafo non orientato, in cui i nodi sono i geni o le proteine e gli archi esprimono le correlazioni che sussistono tra questi. Inoltre, su ogni arco ci saranno due pesi, dei valori indicativi del livello di coespressione e della significatività dell’interazione genica.


Nei dati grezzi descritti come grafi connessi, si ricercano, usando la tecnica di Discriminating Pattern Mining, delle sottostrutture ricorrenti. 

L’obiettivo è, dunque, quello di identificare delle regolarità, dei gruppi di geni uniti da legami valutati in termini di Robustezza e Rilevanza.
