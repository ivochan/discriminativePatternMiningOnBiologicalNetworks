%questa funzione si occupa di elaborare i dati del geodataset
%strutturati pero' in una matrice.


function[healthy,unhealthy] = prepareDataFromMatrixTXT(fileName,state,sampleSize,fileGenesNames)

%dimensione della matrice [righe,colonne]
sizeMatrix = [12625 102];

%prendo il nome del file (ricevuto come parametro)
%filename='/home/ivo-chan/Dropbox/Tesi/Software/analyzedSamples/GSE68907/GSE68907.txt';

%genero il file id leggendo il file da analizzare
fileid = fopen(fileName,'r');

%ho un vettore colonna che contiene tutti i valori scritti nel file
profileMatrix = fscanf(fileid,'%f',sizeMatrix);

%cosi' viene generata la matrice che si puo' elaborare in base al vettore 
%degli stati


%nGenes e' il numero di righe della matrice che io ho costruito 
%cioe' 12625
nGenes=sizeMatrix(1);

%sampleSize e' il numero di geni con cui si vuole lavorare
%e viene specificato come parametro

seed = 27623;

%campionamento per l'estrazione dei geni
rng(seed);
sampledGenes = randperm(nGenes,sampleSize);

%l'estrazione dei nomi dei geni verra' effettuata elaborando il file
%in formato txt, che contiene i nomi dei geni presenti nel dataset
%codificati in base a due convenzioni(si sceglie xxxxx_at)
%il file di interesse poi viene importato e memorizzato come vettore riga
genesNames = importdata(fileGenesNames);
%I nomi dei geni campionati verranno memorizzati
%in un file usando questa funzione
%dopo che il file che li contiene e' stato convertito in vettore
getGenesNames(genesNames,sampledGenes,fileName);






%dalla profile matrix, in base al vettore deglie stati, divido
%il set dei sani ed il set dei malati
healthy = profileMatrix(sampledGenes,state==1);

unhealthy = profileMatrix(sampledGenes,state==0);



%creo i due file 

[pathstr,name,~] = fileparts(fileName);

if(isempty(pathstr))
    pathstr = '.';
end

fileh = [pathstr filesep name '_H.ds2'];
fileu = [pathstr filesep name '_U.ds2'];


healthy = prepare(healthy);
unhealthy = prepare(unhealthy);

dssave(fileh, healthy);
dssave(fileu, unhealthy);

end

%funzione prepare
function[profileShift] = prepare(matrix)
    % vettore delle medie
    meanVector = mean(matrix,2);

    %vettore colonna delle deviazioni standard
    ds = std(matrix,0,2); 

   %profileShift = matrix;

    %Normalizzazione
    %for i = 1:size(matrix,2)
    %    profileShift(:,i) = (profileShift(:,i)-meanVector)./ds; 
    %end
    profileShift = (matrix - meanVector*ones(1,size(matrix,2)))./(ds*ones(1,size(matrix,2))); 
end

