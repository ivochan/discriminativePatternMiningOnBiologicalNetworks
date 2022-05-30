package util;
/**
 *@author ivonne
 *classe che si occupa di eleborare ed estrarre i dati utili 
 *all'analisi del geodataset in formato series_matrix
 *nel dettaglio analizza in file .xml che contiene informazioni 
 *sui pazienti per costruire il vettore degli stati ed il file
 *che contiene le informazioni sui geni presenti nei campioni, 
 *in modo da estrarne i nomi e raccogliere cosi', tutti i file che dovra' 
 *utilizzare lo script scritto in matlab
 */
import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Scanner;
import java.util.StringTokenizer;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

public class FileDataAnalysis {
	//main di esecuizione
	public static void main(String [] args) throws SAXException, IOException, ParserConfigurationException {
		
		//si deve specificare il numero di campioni(pazienti)
		//coinvolti nella stesura dei dati,
		//tra cui distinguere sani e malati
		int nsamples = 102;
		
		//nome del file xml
		String fname = "/home/ivo-chan/MEGAsync/Tesi/Software/analyzedSamples/"
				+ "GSE68907/GSE68907_family.xml";
		//analisi del file xml
		analisysXMLFile(nsamples,fname);
		
		//analisi del file de testo che contiene i nomi dei geni
		String fgname = "/home/ivo-chan/MEGAsync/Tesi/Software/analyzedSamples/GSE68907/GPL8300-tbl-1.txt";
		//creo il riferimento al file da aprire
		File fgenes= new File(fgname);
		analisysGenesFile(fgenes);
	}//main
	
	
	//metodo che si occupa dell'analisi del file
	private static void analisysXMLFile(int nsamples,String fname) throws SAXException, IOException, ParserConfigurationException{
		//questo metodo riceve il nome del file da analizzare
		if(fname==null)throw new IllegalArgumentException("parametro nullo");
		
		//vettore binario degli stati da restituire
		//stampato su file
		int[] state = new int[nsamples];
		
		//si accede al file da utilizzare
		File f = new File(fname);
		
		controlloFile(f);
		
		//il vettore degli stati verra' generato e stampato su file
		File vstate = new File("/home/ivo-chan/Dropbox/Tesi/Software/analyzedSamples/"
					+ "GSE68907/vstate.txt");
		//per istanziare il parser che si occupera' dell'analisi
		//sintattica uso il Document Object Model (DOM)
			
		//istanzio il metodo factory dell'oggetto document da elaborare
		DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
			
		//istanzio il builder per creare il file document
		DocumentBuilder db = dbf.newDocumentBuilder(); 
			
		//creo un document in modo da fare il parsing sul file
		Document d = db.parse(f);
			
		//
		d.getDocumentElement().normalize();
			
		//estraggo il primo nodo
		Node root = d.getDocumentElement();
	    //DEBUGG System.out.println("Root element :" + root.getNodeName());

	    //estraggo tutti i nodi della lista caratterizzati dal tag "<Source>"
	    NodeList nList = d.getElementsByTagName("Source");
	    //in questo modo ottengo, nell'ordine, l'informazione che sara'
	    //o "normal" o "tumor", utile per generare il vettore degli stati
	        
	    //DEBUGG System.out.println("nList Length = "+nList.getLength());
	    for (int i = 0; i < nList.getLength(); i++) {
	       	//prendo il nodo corrente
	       	Node nCurr = nList.item(i);
	       	//prendo le informazioni che contiene
	       	Element e = (Element)nCurr;
	       	//stampo il contenuto all'interno del tag
	       	//DEBUGG System.out.println(e.getTextContent());
	        //devo costruire un vettore binario di 102 celle 
	      	//che contiene 1 se il paziente e' sano, ovvero se la stringa 
	      	//stampata e' normal, 0 altrimenti, cioe' se la stringa stampata
	      	//e' tumor
	       	String s = e.getTextContent();
	       	if(s.equals("normal")) {
	        //allora nel vettore metto 1
	       		state[i]=1;
	       	}
	       	else {
	       		//allora il tag e' tumor
	       		//nel vettore metto 0
	       		state[i]=0;
	       	}
	       	//con l'incrementare di i del for, scorre
        	//anche l'indice del vettore
	    }//for
	   
	    //stampo i risultati su file 
	    stampaVettore(state,vstate);
	}//analysisXMLFile
	
	//metodo che stampa su file il vettore
	private static void stampaVettore(int[] state,File vstate) {
		//il vettore verra' stampato
		//su file in modo da poter copiare il suo valore
		//per utilizzarlo in matlab
		try {
			//il costruttore riceve il file in cui scrivere
			PrintWriter pf = new PrintWriter(vstate);
			 
			pf.append("[ ");
			//itero il vettore
			for(int e : state) {
				//scrivo il numero
				pf.append(Integer.toString(e));
				pf.append(' ');
			}
			//chiudo il vettore
			pf.append("]");
			//si svuota il buffer
			pf.flush();
			
		} catch (FileNotFoundException e) {
			System.err.println("errore in scrittura");
		}
	}//stampaVettore

	private static void controlloFile(File f) {

		//controllo se il file esiste e se ho i permessi di lettura
		if(!f.exists()||!f.canRead()){
			try {
				throw new FileNotFoundException();
			} catch (FileNotFoundException e1) {
				System.err.println("File non trovato o non accessibile");
			}
		}//controllo file
				
		
	}//controlloFile
	
	private static void analisysGenesFile(File fgenes) {
		//metodo che restituisce un file con tutti i nomi dei geni
		controlloFile(fgenes);
		//creo il nome del file dei risultati
		String fgenesName = new String("/home/ivo-chan/MEGAsync/Tesi/Software/analyzedSamples/GSE68907/GenesList.txt");
		//creo il file dei risultati
		File geneNames = new File(fgenesName);
		//per contare i geni
		int ngenes=0;
		//creo uno stringbuilder che uso per mantenere i dati da scrivere nel
		//file di output
		StringBuilder sb = new StringBuilder();
		//uso lo string tokenizer per elaborare il file di testo
		//di ogni riga devo prendere solo la prima stringa
		//si deve leggere il file, si usa la classe scanner
		try {
			Scanner scf = new Scanner(fgenes);
			while(scf.hasNext()){
				//si preleva la riga
				String line = scf.nextLine();
				//DEBUGG
				//System.out.println(line);
				//si deve processare la prima riga
				StringTokenizer st = new StringTokenizer(line);
				//in modo da estrarre solo la prima stringa
				String token = st.nextToken();
				//DEBUGG System.out.println(token);
				if(token!=null){
					//questo token e' valido
					sb.append(token);
					sb.append('\n');
					ngenes++;
				}
				
			}//while
			//si chiude il flusso in lettura
			scf.close();
		}catch (FileNotFoundException e) {
			System.err.println("errore in lettura");
		}
		//DEBUGG System.out.println(sb);
		//DEBUGG System.out.println("N°Geni= "+ngenes);
		//l'intero contenuto dello stringBuilder deve essere scritto su file
		//prima lo converto in vettore di stringhe diviso per righe
		//usando come separatore il fine riga
		String [] contenuto = sb.toString().split("\\n");
		try {
			//il costruttore riceve il file in cui scrivere
			PrintWriter pf = new PrintWriter(geneNames);
			//itero il vettore di stringhe per righe
			for(String s : contenuto) {
				//scrivo la riga su file
				pf.append(s);
				pf.append("\n");
			}
			//si svuota il buffer
			pf.flush();
		} catch (FileNotFoundException e) {
				System.err.println("errore in scrittura");
		}
	}//analysisGEnesFile
	
}//FileDataAnalysis
