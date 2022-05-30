#!/bin/bash

#script che lancia il main di esecuzione del software su ognuno dei dataset
#utilizzando come alpha e theta i valori di default
#ma esaminando ogni dataset al variare del parametro sampleSize

#potrei fare in modo che riceva il path della cartella di progetto a riga di comando e lo usi come
#classpath

export CLASSPATH=/home/ivo-chan/MEGAsync/Tesi/Software/codiceJava/MiningDiscriminativePatterns/bin:$CLASSPATH
#nota: quando si utilizza questo script si suppone che il path del file
#samplesGenes.txt su cui deve lavorare il main di esecuzione java
#sia nrlla forma standard(path_idoneo=true)

#funzione utilizzata
function miningSampleSize(){
	#questa funzione riceve come parametri
	#il path in cui prelevare il dataset
	#il nome del dataset
	path=$1
	geo=$2
	dir_ris=$3
	theta=$4
	alpha=$5
	verbose=$6
	#per il dataset in esame si effettua il mining
	#su tutte le coppie di grafi costruite al variare
	#del valore del numero di geni campionati
	for sampleSize in ${sampleSizeArray[@]}
	do
		#si crea la cartella in cui salvare i risultati
		#DEBUGG	echo $path$geo"/sampleSize"$sampleSize$dir_ris
		mkdir $path$geo"/sampleSize"$sampleSize$dir_ris
		#viene effettuata una chiamata alla classe java che effettua 
		echo sampleSize pari a $sampleSize
		#queste operazioni
		#DEBUGG echo cartella $path$geo"/sampleSize"$sampleSize
		#prima sulla rete dei sani
		java application.Main_Heap H $path$geo"/sampleSize"$sampleSize"/graphs" $theta $alpha $verbose >> $path$geo"/sampleSize"$sampleSize$dir_ris"/"miningH.txt
		#poi sulla rete dei malati 
		java application.Main_Heap U $path$geo"/sampleSize"$sampleSize"/graphs" $theta $alpha $verbose >> $path$geo"/sampleSize"$sampleSize$dir_ris"/"miningU.txt

		
	done
}

#ELABORAZIONE dei dati

#path generico da cui estrarre i dati
path="/home/ivo-chan/MEGAsync/Tesi/Software/analyzedSamples/"
#elenco dei geo dataset da analizzare
geofiles=("GSE16134" "GSE25724" "GSE55200" "GSE68907")
#vettore che contiene i valori di sampleSize con cui effettuare le analisi
#un generico elemento di questo vettore e' identificato come nsample
sampleSizeArray=(10 50 100 150 200)
#Fase di MINING
#valori usati per l'analisi
#sono i valori stabiliti di default
theta=0.7
alpha=0.5
#parametro per avere informazioni aggiuntive
verbose="true"
#i risultati dell'analisi devono essere salvati sul file
#nella seguente cartella
dir_ris="/miningGraphsSampleSize"



#si considerano tutti le cinque coppie di grafi u e h generate per 
#ogni geodataset al variare del numero di geni sampleSize


#si analizzano tutti i geodata
for geo in ${geofiles[@]}
do
	#ogni geodataset viene elaborato
	echo Dataset $geo in lavorazione
	#al variare del parametro sampleSize
	#si analizza ciascun dataset
	miningSampleSize $path $geo $dir_ris $theta $alpha $verbose
done
    


