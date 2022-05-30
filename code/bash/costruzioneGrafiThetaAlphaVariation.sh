#!/bin/bash
#questo script va chiamato nella stessa cartella in cui e' 
#contenuta la funzione scritta in c che viene invocata
#creo i grafi al variare dei parametri theta e alpha, tenendo fisso il numero di
#geni, specificato dal valore del parametro sampleSize, a 100.
#si utilizza sempre la funzione scritta in c

#i valori assunti dai parametri theta e alpha varieranno in questo intervallo:
#{0.1 0.3, 0.5, 0.7, 0.9}

#per ogni geo dataset verranno costruiti due grafi, uno per la rete dei sani ed uno per la rete
#dei malati e questo processo verra' ripetuto al variare del parametro sampleSize, ovvero
#utilizzando i diversi file generati dallo script matlab

#elenco dei dataset da analizzare
#inseriti in un vettore
geofiles=("GSE16134" "GSE25724" "GSE55200" "GSE68907")
#elenco dei valori di THETA e ALPHA con cui effettuare il test
testValues=(0.1 0.3 0.5 0.7 0.9)


#path in cui prelevare i dati
#pathdb="/home/ivo-chan/Dropbox/Tesi/Software/analyzedSamples/" su dropbox
path="/home/ivo-chan/MEGAsync/Tesi/Software/analyzedSamples/"
sampleSize="/sampleSize100/";



#funzione che crea un grafo per ogni valore di alpha e theta
function geoAnalysis(){
	#si prelevano i parametri ricevuti, nell'ordine seguente:
	#path, geo_name,sampleSize,testValues
	path=$1
	geo=$2
	sampleSize=$3
	testValues=$4
	#identificativo del file del set dei sani
	fh="_H.ds2";
	#identificativo del file del set dei malati
	fu="_U.ds2";
	#identificativi dei parametri per nomenclatura delle cartelle risultato
	t="Theta";
	a="Alpha";
	
	#cartella in cui salvare i file
	echo $path$geo$sampleSize$t$a"Graphs"
	mkdir $path$geo$sampleSize$t$a"Graphs"
	
	#costruzione dei grafi al variare dei parametri
	for theta in ${testValues[@]}	
	#al variare dei valori di theta
	do
		#creo la cartella theta in cui salvare i risultati generati
		mkdir ./$geo$t$theta

		#al variare dei valori di alpha
		for alpha in ${testValues[@]}
		do
			#creo la cartella alpha in cui salvare i risultati
			mkdir ./$geo$a$alpha
			#creo i due grafi
			./buildingGraphFiles $path$geo$sampleSize$geo$fh H $theta $alpha
		
			./buildingGraphFiles $path$geo$sampleSize$geo$fu U $theta $alpha
		
			#sposto i file generati al variare del parametro alpha nella
			#cartella dei file generati al variare del parametro theta
			
			mv U ./$geo$a$alpha #sposto la rete dei malati nella cartella di alpha
			mv H ./$geo$a$alpha #sposto la rete dei sani nella cartella di alpha
		
			#sposto la cartella di alpha nella corrispondente cartella di theta
			mv ./$geo$a$alpha ./$geo$t$theta
		
		done
	
	#ogni cartella theta verra' spostata nella cartella che contiene tutti i dati
	#analizzati dello specifico dataset
	mv ./$geo$t$theta $path$geo$sampleSize$t$a"Graphs"	
	done
}
#end function



#si analizzano tutti i geodata
for geo in ${geofiles[@]}
do
	echo Elaborazione di $geo ...
	geoAnalysis $path $geo $sampleSize $testValues
done









