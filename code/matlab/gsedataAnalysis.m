%script che esgue tutte le chiamate, per automatizzare il processo, allo
%script che effettua le analisi dei GSEXXXXX dataset in modo da ottenere
%le cartelle H e U che contengono, rispettivamente, le informazioni
%dei pazienti sani e dei pazienti malati, oltre che il file che riporta
%l'elenco dei nomi dei geni coinvolti nell'elaborazione, in base al numero 
%di geni specificato con il parametro sampleSize
%che variera' nell'intervallo {0, 50, 100, 150, 200}
sampleSizeArray = [10 50 100 150 200];

%valore attuale
sampleSize = sampleSizeArray(1);
%sampleSize = sampleSizeArray(2);
%sampleSize = sampleSizeArray(3);
%sampleSize = sampleSizeArray(4);
%sampleSize = sampleSizeArray(5);


%GSE 16134
fileName16134 = '/home/ivo-chan/MEGAsync/Tesi/Software/analyzedSamples/GSE16134/GSE16134.txt';
state16134 = [ 0 0 1 0 0 1 0 0 1 0 0 1 1 0 0 0 0 0 0 0 1 0 0 1 0 0 1 0 0 0 0 1 0 0 1 0 0 1 0 0 0 0 0 0 1 0 0 0 1 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 0 0 1 0 0 1 1 0 0 0 0 1 0 0 0 0 1 0 0 1 0 0 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 0 0 0 0 1 0 1 0 0 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1  0 0 0 0 0 0 0 0 1 0	 0 1 0 0 1 0 0 1 0 0 1 0 0 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 0 0 1 0 0 1 0 0 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1 0 0 1 0 0 1 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 1 0 0 1 0 0 1 0 0 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 1 0 0 1 0 0 1 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ];
%chiamata alla funzione al variare di sampleSize
prepareDataFromFileTXT(fileName16134,state16134,sampleSize);

%GSE 25724
fileName25724 = '/home/ivo-chan/MEGAsync/Tesi/Software/analyzedSamples/GSE25724/GSE25724.txt';
state25724 = [ 1 1 1 1 1 1 1 0 0 0 0 0 0 ];
%chiamata alla funzione al variare di sampleSize
prepareDataFromFileTXT(fileName25724,state25724,sampleSize);

%GSE 55200
fileName55200 = '/home/ivo-chan/MEGAsync/Tesi/Software/analyzedSamples/GSE55200/GSE55200.txt';
state55200 = [ 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 ];
%chiamata alla funzione al variare di sampleSize
prepareDataFromFileTXT(fileName55200,state55200,sampleSize);

%GSE 68907
%non ho il file nel formato dei precedenti
%quindi per analizzarlo devo usare un'altra funzione
fileName68907 = '/home/ivo-chan/MEGAsync/Tesi/Software/analyzedSamples/GSE68907/GSE68907.txt';
state68907 = [ 1 0 1 1 0 1 1 1 1 1 1 1 1 1 0 0 0 1 1 0 0 0 1 0 0 1 1 1 1 1 0 0 1 1 0 0 1 0 1 0 1 1 1 0 0 0 1 0 0 1 0 0 0 0 0 1 0 1 0 0 1 1 1 1 0 0 0 0 0 1 0 1 0 0 0 0 1 1 0 0 1 1 0 0 1 1 1 0 1 1 0 1 1 0 0 0 1 0 1 0 0 0 ];
%file che contiene i nomi dei geni elaborato tramite java
fileGenesNames = '/home/ivo-chan/MEGAsync/Tesi/Software/analyzedSamples/GSE68907/GenesList.txt';
%chiamata della funzione al variare di sampleSize
prepareDataFromMatrixTXT(fileName68907,state68907,sampleSize,fileGenesNames);


%non ho fatto un ciclo for del tipo
%for sampleSizeArray = [10 50 100 150 200]
%end
%al variare del parametro sampleSize perche' i file
%che contengono i risultati vengono generati sempre 
%con lo stesso nome e verrebbero sovrascritti
