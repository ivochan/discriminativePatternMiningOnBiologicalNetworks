#!/bin/bash

#script che lancia il main di esecuzione del software
#che si occupa dell'elaborazione di ogni geodaset al variare
#dei parametri theta e alpha
#le reti associate ai geodataset saranno quelle costruite con 
#un valore mediano di sampleSize, cioe' 100


export CLASSPATH=/home/ivo-chan/MEGAsync/Tesi/Software/codiceJava/MiningDiscriminativePatterns/bin:$CLASSPATH


#i valori assunti dai parametri theta e alpha varieranno in questo intervallo:
testValues=(0.1 0.3 0.5 0.7 0.9)
#e'con questi valori che sono state costruite le reti dei sani e dei malati
#e quindi andranno specificati nuovamente nella fase di mining
dir="/miningGraphsTA"
fdiscr="DiscriminativePatternGenesName"

#devo effettuare l'analisi per ciascuno dei cinque grafi costruiti al 
#variare di alpha, contenuti in ciascuna cartella al variare di theta
#elenco dei geodataset
geofiles=("GSE16134" "GSE25724" "GSE55200" "GSE68907")
#path in cui prelevare i dati
path="/home/ivo-chan/MEGAsync/Tesi/Software/analyzedSamples/"
sampleSize="/sampleSize100/"
dirdata="ThetaAlphaGraphs/"
t="Theta"
a="Alpha"
verbose="false" #informazioni aggiuntive su file

#funzione che completa quella successiva dal punto di vista funzionale
function mining(){
	#valori ricevuti in input dalla funzione
	#$geo $patht $theta
	geo=$1
	patht=$2
	theta=$3
	#itero i valori di alpha

	for alpha in ${testValues[@]}
	do
		echo con alpha pari a $alpha 
		#qui devo chiamare la funzione java che si occupa proprio della 
		#fase di mining
		#si crea la cartella in cui salvare i risultati
		mkdir $patht"/"$geo$a$alpha$dir
		#echo $patht"/"$geo$a$alpha$dir #patha
		#viene effettuata una chiamata alla classe java che effettua 
		#prima sulla rete dei sani
		#echo analisi $patht"/"$geo$a$alpha $theta $alpha $verbose output $patht"/"$geo$a$alpha$dir"/"miningH.txt
		echo elaborazione Healty set ...
		java application.Main_Heap H $patht"/"$geo$a$alpha $theta $alpha $verbose >> $patht"/"$geo$a$alpha$dir"/"miningH.txt
		echo analisi Healty set terminata!
		#sposto il file dei patterns piu' discriminanti
		#echo da $pathdiscr$fdiscr"H_"$geo".txt" a $patht"/"$geo$a$alpha
		mv $path$geo$sampleSize$fdiscr"H_"$geo".txt" $patht"/"$geo$a$alpha
		echo H patterns memorizzati!
		#poi sulla rete dei malati 
		echo elaborazione Unhealty set ...
		#echo analisi $patht"/"$geo$a$alpha $theta $alpha $verbose output$patht"/"$geo$a$alpha$dir"/"miningU.txt
		java application.Main_Heap U $patht"/"$geo$a$alpha $theta $alpha $verbose >> $patht"/"$geo$a$alpha$dir"/"miningU.txt
		echo analisi Unhealty set terminata!
		#il file che viene generato sui pattern piu' discriminati viene creato 
		#nella cartella path
		#esempio : /home/ivo-chan/MEGAsync/Tesi/Software/analyzedSamples/GSE16134/sampleSize200
		#con il nome del file seguente DiscriminativePatternGenesNameH_GSE16134.txt
		#allora deve essere preso e spostato nella cartella di interesse
		mv $path$geo$sampleSize$fdiscr"U_"$geo".txt" $patht"/"$geo$a$alpha
		echo U patterns memorizzati!
		#echo $path$fdiscr"U_"$geo".txt" spostato
		echo cambio dei parametri di test ...
	done
}
#funzione generale che chiama l'algoritmo di mining sulle reti H e U
#tramite la funzione che invoca

function miningThetaAlpha(){
	#il parametro ricevuto da questa funzione
	#e' il dataset corrente su cui si sta invocando la funzione
	geo=$1

	for theta in ${testValues[@]}
	do
		#echo Elaborazione di $geo con theta pari a $theta
		#costruisco il path della cartella che contiene le reti per 
		#questo valore di theta
		echo analisi di $geo per theta pari a $theta
		#DEBUGG echo posizione cartella theta $path$geo$sampleSize$dirdata$geo$t$theta
		mining $geo $path$geo$sampleSize$dirdata$geo$t$theta $theta
	done
}




#in questa cartella sono contenute le reti
#costruite per i vari valori di theta
#esempio : GSE16134Theta0.1/
#$geo$t$theta (dove theta e' il valore assunto iterando testValues)
#e all'interno, al variare di alpha 
#Esempio : GSE16134Alpha0.1/H GSE16134Alpha0.1/U
#$geo$a$aplha
#dopo di che si chiama il main di esecuzione java sulle due cartelle H e U
#i valori di theta e alpha correnti e verbose=true

#si analizzano tutti i geodata con sampleSize=100
for geodata in ${geofiles[@]}
do
	#echo Elaborazione di $geodata ...
	#DEBUGG echo $path
	miningThetaAlpha $geodata
done
