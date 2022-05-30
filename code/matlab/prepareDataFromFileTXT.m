% The function receive the text file containing data from GEO and the
% information about which samples are healty and which ones are unhealty
%(vector state).
%The whole genes are sampled (we want to deal with "sampleSize" genes chosen randomly)
%
% Healty --> 1
% Unhealty --> 0

function[healthy,unhealthy,sampledGenes] = prepareDataFromFileTXT(fileName,state,sampleSize)

seed = 27623;

%parse the previously downloaded GSE text format file
gseData = geoseriesread(fileName);
sampleNames = gseData.Data.colnames;
nSamples =  gseData.Data.NCols;
nGenes = gseData.Data.NRows;
genesNames = gseData.Data.RowNames;

% from = randi((g-nGenes),[1,1]);
% to = from+nGenes-1;

rng(seed);
sampledGenes = randperm(nGenes,sampleSize);

%Store in a file the name of the genes in the sample
getGenesNames(genesNames,sampledGenes,fileName);

profileMatrix = zeros(nGenes,nSamples);
for i = 1:nSamples
      profileMatrix(:,i) = gseData.Data(:,sampleNames(i));
end

%Devo poter prendere solo le righe che mi interessano. Lo faccio sulla base
%del potere discriminante dei geni, come suggerito dal p-value calcolato da
%GEO.
%Potrei pensare di agire manualmente e cancellare tutte le righe che
%risultano avere un p-value inferiore ad una soglia fissata, cin tal modo
%ottengo l'elenco dei geni che mi interessano e costruiso opportunamente la
%profileMatrix

healthy = profileMatrix(sampledGenes,state==1);
unhealthy = profileMatrix(sampledGenes,state==0);

 %pathstr = '.';
[pathstr,name,~] = fileparts(fileName);

if(isempty(pathstr))
    pathstr = '.';
end
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
%opurtunamente le colonne di una e dell altra famiglia, ma deve essere
%l'utente a dirmi chi sono i sani e chi i malati, compito di questo file e
%solo quello di restituire l'intera matrice

