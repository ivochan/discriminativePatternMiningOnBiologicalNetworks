%The function receives the set of all genes name in the sample and the
%indexes of genes you are interested in.
%
%The variable name is a string that contain the name of the dataset in
%order to give a significant name to the file where we store the names of
%the sampled genes

function[genes] = getGenesNames(allNames,sampledGenes, filename)
    genes = allNames(sampledGenes);
    [pathstr,name,~] = fileparts(filename);
 
    if(isempty(pathstr))
        pathstr= '.';
    end

    fname = sprintf('%s%csampledGenes_%s.txt', pathstr, filesep,name);
    
    file=fopen(fname,'w');
    fprintf(file,'%s\n',genes{:});
    fclose(file);
    