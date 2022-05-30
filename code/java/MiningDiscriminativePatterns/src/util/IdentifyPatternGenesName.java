package util;
/**
 * @author ivonne 
 */
import java.util.List;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.PrintWriter;
import java.util.Scanner;

import model.Dataset;
import model.Pattern;
//classe di utilita'
//denominata final in modo che non possa essere modificata
public final class IdentifyPatternGenesName {

	//costruttore privato in modo che non possa essere istanziata
	private IdentifyPatternGenesName() {}

	//questa classe fornisce una funzione che riceve in ingresso il file da cui estrarre i nomi
	//dei geni generato da matlab
	//lo scorre cercano il gene nella riga che indica l'id di ciascuno
	//dei due geni coinvolti nel patter e restituisce una struttura 
	//in cui al nome del pattern segue la coppia di geni che costiutisce l'arco
	//identificando i nodi con il nome del gene e non con l'id gia' utilizzato
	
	//array di stringhe che contiene i nomi dei geni estratti
	//tramite matlab dall'analisi dei dataset dei pazienti
	
	private static String [] geneNameArray;
	//la dimensione dell'array viene impostata usando il parametro
	//numNodi calcolato nella classe Main_Heap
	//int numNodi = util.OpenBinaryFiles.open(path_h+"/corr0_H.ds2");
	//XXX DEBUGG uso un valore di default
	private static int genesNumber= 200;
	
	//file di output
	private static File genesNameList;
	
	//nome di default del file di output
	private static String res_name = "DiscriminativePatternGenesName";
	
	//per le stampe di debugg
	private static boolean debugg = false;
	
	//funzione che controlla la validita' del file
	private static void analyzingFile(String path) {
		
		//controllo se il path del file e' nullo
		if(path==null)throw new IllegalArgumentException("Path del file nullo");
		//si crea il puntatore al file, cioe' il nome di riferimento
		//si crea un'istanza di file dal path(che contiene anche il nome)
		//ricevuto come parametro
		File f = new File(path);
		//controllo se il file esiste e se ho i permessi di lettura
		if(!f.exists()||!f.canRead()){
			try {
				throw new FileNotFoundException();
			} catch (FileNotFoundException e1) {
				System.err.println("File non trovato o non accessibile");
			}
		}//controllo file
		if(debugg)System.out.println("Il path e' "+f.getPath());
		//salvo il contenuto del file da leggere in un vettore di stringhe
		//in cui ogni cella rappresenta l'indice di riga del file
		//si istanzia il vettore
		geneNameArray = new String[genesNumber];
		//indice per scorrere il vettore
		int index = 0;
		//si deve leggere il file, si usa la classe scanner
		try {

			Scanner scf = new Scanner(f);
			while(scf.hasNext()){
				//si preleva la riga che contiene il nome del gene
				String s = scf.nextLine();
				//si inserisce il nome del gene nella cella del vettore
				geneNameArray[index]=new String(s);
				//si aumenta l'indice di inserimento nel vettore
				index++;
			}//while
			//si chiude il flusso in lettura
			scf.close();
		}catch (FileNotFoundException e) {
			System.err.println("errore in lettura");
		}
		if(debugg)System.out.println("analyzingFile");
	}//analyzingFile
	
	//avendo il vettore che contiene l'elenco dei nomi dei geni
	//devo iterare gli archi del grafo che risultano coinvolti nei
	//patter discriminanti e genero un file che contiene queste informazioni
	
	private static void namingGenes(List<Pattern> patterns){
		//questo metodo itera la struttura dati che contiene le informazioni
		//sui pattern piu' discriminanti, dove sono specificati gli archi
		//coinviolti nella relazione e converte il codice id di questi nel
		//nome corrispondente, mettendo l'output su file
		//per scrivere su file si puo' utilizzare la classe PrintWriter
		StringBuilder sb = new StringBuilder();
		//questo conterra' i dati da stampare su file
		//quindi dalla lista dei pattern se ne estrae uno e si
		//descrivono le sue caratteristiche
		//controllo se la lista e' vuota
		int i = 1;//per numerare il pattern in esame
		for(Pattern p : patterns) {
			//pattern analizzato
			sb.append("Pattern #"+i+"\n");
			List<Integer> edges = (List<Integer>) p.getPattern();
			//lista degli archi per quel pattern
			//prelevo la matrice di adiacenza associata al dataset analizzato
			int[][] edgesMatrix = Dataset.getEdgeMapping();
			//si stampa il numero di archi trovati per il pattern in esame
			sb.append("Num. archi: "+edges.size()+" ");
			sb.append('[');
			for(Integer e: edges){//itero gli archi
				//ogni arco e' composto da due geni
				//per sapere quali devo accedere alla matrice di adiacenza
				int g1 = edgesMatrix[0][e];
				int g2 = edgesMatrix[1][e];
				//i due id ottenuti devo convertirli in nomi
				//accedendo al vettore dei nomi creato prima
				sb.append("<"+geneNameArray[g1]+","+geneNameArray[g2]+">"+",");
				//l'arco costituito dai nomi dei due geni e' stato inserito
			}
			//ho iterato tutti gli archi per quel pattern
			//per non avere la virgola come ultimo elemento
			sb.setCharAt(sb.length()-1,']');
			i++;//indice del pattern
			sb.append("\n");
		}//itero i patter
		if(debugg)System.out.println("contenuto\n"+sb);
		//l'intero contenuto dello stringBuilder deve essere scritto su file
		//prima lo converto in vettore di stringhe diviso per righe
		//usando come separatore il fine riga
		String [] contenuto = sb.toString().split("\\n");
		try {
			//il costruttore riceve il file in cui scrivere
			PrintWriter pf = new PrintWriter(genesNameList);
			//itero il vettore di stringhe per righe
			for(String s : contenuto) {
				//scrivo la riga su file
				pf.append(s);
				pf.append("\n");
			}
			if(patterns.isEmpty())pf.append("Non ci sono patterns discriminanti");
			//si svuota il buffer
			pf.flush();
			
		} catch (FileNotFoundException e) {
			System.err.println("errore in scrittura");
		}
		if(debugg)System.out.println("NamingGenes");
	}//namingGenes
	
	
	public static void matchingGenes(List<Pattern> patterns,String sup_path, char id,boolean path_idoneo) {
		//si riceve il parametro id di tipo char
		//che identifica la rete su cui effettuare l'analisi
		//(verra' usato nel nome del file)
		//si riceve il path del file 
		//generato dallo script matlab che contiene i nomi dei geni
		//che compongono i pattern piu' discriminanti
		//dal path devo estrarre il nome del dataset
		//se il path e' presente nella notazione standard
		String path="";
		if(path_idoneo) {
			//Esempio:
			///home/ivo-chan/MEGAsync/Tesi/Software/analyzedSamples/GSE16134/sampleSize10
			String part= sup_path.substring(0, sup_path.lastIndexOf('/'));
			String geo=part.substring(part.lastIndexOf('/')+1,part.length());
			path=sup_path+"/sampledGenes_"+geo+".txt";
		}else {
			path=new String(sup_path);
		}
		if(debugg)System.out.println(path);
		//si analizza il file
		analyzingFile(path);
		//si crea il file dei risultati
		createOutputFile(path,id);
		//si effettua l'operazione di matching scrivendo sul file
		namingGenes(patterns);
		if(debugg)System.out.println("Matching Complete !");
	}//matchingGenes
	
	
	public static void createOutputFile(String path,char id) {
		//determino il path in cui verra' istanziato il file
		//a partire dal path del file da cui ho estratto i dati
		//ricevuto come parametro
		//estraggo il path escludendo il nome del file che ho a disposizione
		int last_slash = path.lastIndexOf('/');
		//estraggo quindi la sottostringa fino all'ultimo separatore /
		//usando il suo indice + 1, in modo da includerlo
		String res_path = path.substring(0,last_slash+1);
		if(debugg)System.out.println("result path "+res_path);
		//determino il nome che dovra' avere il file, ovvero 
		//DiscriminativePatterGenesName_GSEXXXXX.txt
		int name_index = path.lastIndexOf('_');
		String dataset_name = path.substring(name_index);
		if(debugg)System.out.println("dataset name "+dataset_name);
		//creo il nome del file
		res_name +=Character.toString(id)+ dataset_name;
		//XXX DEBUGG System.out.println(res_path+res_name);System.out.println("file output "+res_path+res_name);
		//creo il file nello stesso path del file da cui posso estrarre i nomi
		genesNameList = new File(res_path+res_name);
		//il file e' stato creato con il nome stabilito
	}//createOutputFile
	
	
}//MatchPatterGeneName
