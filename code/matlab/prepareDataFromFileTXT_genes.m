function[healthy,unhealthy] = prepareDataFromFileTXT_genes(fileName,state,sampleSize,genes)
% RICEVE ANCHE DEI GENI DA INSERIRE

seed = 27623;

rng(seed);

%parse the previously downloaded GSE text format file
gseData = geoseriesread(fileName);
sampleNames = gseData.Data.colnames;
nSamples =  gseData.Data.NCols;
nGenes = gseData.Data.NRows;
genesNames = gseData.Data.RowNames;


profileMatrix = zeros(nGenes,nSamples);
for sampledGenes = 1:nSamples
      profileMatrix(:,sampledGenes) = gseData.Data(:,sampleNames(sampledGenes));
end

%i = randperm(g, nGenes);
sampledGenes = randperm(nGenes);
%Mette in testa i geni forniti in input
for k=1:numel(genes);
    j = genes(k);
    pos = (sampledGenes==j);
    temp = sampledGenes(k);
    sampledGenes(k) = j;
    sampledGenes(pos) = temp;
end

%Estrae da "i" il numero di geni corrispondente alla dimensione desiderata
%per il campione
sampledGenes = sampledGenes(sampleSize:-1:1);

%Store in a file the name of the genes in the sample
getGenesNames(genesNames,sampledGenes,filename)


%Devo poter prendere solo le righe che mi interessano. Lo faccio sulla base
%del potere discriminante dei geni, come suggerito dal p-value calcolato da
%GEO.
%Potrei pensare di agire manualmente e cancellare tutte le righe che
%risultano avere un p-value inferiore ad una soglia fissata, cin tal modo
%ottengo l'elenco dei geni che mi interessano e costruiso opportunamente la
%profileMatrix

h = sum(state);
u = nSamples-h;


healthy = profileMatrix(sampledGenes,state==1);
unhealthy = profileMatrix(sampledGenes,state==0);

[pathstr,name,~] = fileparts(fileName);
%if(pathstr == '')
    pathstr = '.';
%end
fileh = [pathstr filesep name '_H.ds2'];
fileu = [pathstr filesep name '_U.ds2'];

%dssave(fileh, healthy);
%dssave(fileu, unhealthy);

% healthy = zeros(g,h);
% unhealthy = zeros(g,u);
% 
% ch=1;
% cu=1;
% 
% for i = 1:nSamples
%     if state(i)>0
%         healthy(:,ch)=gseData(:,i);
%         ch=ch+1;
%     else
%         unhealthy(:,cu) = gseData(:,i);
%         cu=cu+1;
%     end
% end


%building the float matrix
%profileMatrix = single(profile.(':')(':'))

%profileMatrix = profile.(':')(':');

healthy = prepare(healthy);
unhealthy = prepare(unhealthy);

dssave(fileh, healthy);
dssave(fileu, unhealthy);

end


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

%Devo distinguere tra campioni sani e malati, quindi identificare
%oopurtunamente le colonne di una e dell altra famiglia, ma deve essere
%l'utente a dirmi chi sono i sani e chi i malati, compito di questo file e
%solo quello di restituire l'intera matrice

