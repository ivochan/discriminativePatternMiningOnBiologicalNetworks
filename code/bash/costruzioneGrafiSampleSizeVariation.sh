#!/bin/bash
#questo script viene chiamato nella stessa directory che invoca la funzione che utilizzo
#per costruire i grafi, pero' i file generati saranno spostati nelle cartelle dei dati a cui
#si riferiscono

#oltre i due file .ds2, rispettivamente del set dei sani H e dei malati U, la funzione riceve
#i parametri theta = 0.7 e alpha = 0.5, pari ai loro valori di default e per questo omessi
#a riga di comando

#per ogni geo dataset verranno costruiti due grafi, uno per la redete dei sani ed uno per la rete
#dei malati e questo processo verra' ripetuto al variare del parametro sampleSize, ovvero
#utilizzando i diversi file generati dallo script matlab
#segue la funzione che si occupa dell'analisi vera e propria
function analizza() {
	#i parametri che riceve sono il path in cui creare la directory $1
	#il nome del dataset da analizzare $2
	#il numero di campioni utlizzati per l'analisi $3
	#l'estensione del file per i sani $4
	#l'estensione del file per i malati $5
	#prelevo i parametri
	path=$1
	geoname=$2
	nsample=$3
	h=$4
	u=$5
	
	#GSEXXXXX
	echo Elaborazione del dataset $geoname ...

	#cartella in cui spostare le reti
	mkdir $path$geoname"/sampleSize"$nsample"/graphs"
	
	#H sample
	#DEBUGG echo $path$geoname"/sampleSize"$nsample$geoname$h
	#chiamata alla funzione che costruisce il grafo dei sani
	./buildingGraphFiles $path$geoname"/sampleSize"$nsample"/"$geoname$h H
	#U sample
	#DEBUGG echo $path$geoname"/sampleSize"$nsample$geoname$u
	#chiamata alla funzione che costruisce il grafo dei malati
	./buildingGraphFiles $path$geoname"/sampleSize"$nsample"/"$geoname$u U
	
	#sposto il grafo dei sani nella cartella creata prima
	mv ./H $path$geoname"/sampleSize"$nsample"/graphs"
	#sposto il grafo dei malati nella cartella creata prima
	mv ./U $path$geoname"/sampleSize"$nsample"/graphs"


}

#esecuzione

#path generico da cui estrarre i dati
path="/home/ivo-chan/MEGAsync/Tesi/Software/analyzedSamples/"

#estensioni dei file di interesse
healty="_H.ds2"
unhealty="_U.ds2"

#elenco dei quattro geodataset da analizzare
#inseriti in un vettore
geofiles=("GSE16134" "GSE25724" "GSE55200" "GSE68907")
#vettore che contiene i valori di sampleSize con cui effettuare le analisi
#un generico elemento di questo vettore e' identificato come nsample
sampleSizeArray=(10 50 100 150 200)



#itero il vettore che contiene questi valori e lancio un'analisi
#per ognuno di questi
for sampleSize in ${sampleSizeArray[@]}
do
	#al variare di sampleSize
    echo Analisi dei geodataset con NUMERO DI GENI pari a $sampleSize
	#si analizzano tutti i geodata
	for geo in ${geofiles[@]}
	do
		echo $geo in lavorazione...
		analizza $path $geo $sampleSize $healty $unhealty
    done
    
done



