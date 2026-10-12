package com.rev_creations.util;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.util.*;
 
/**
  * Class to handle and process http file uploads.
  *
  *
  * @author Daniel Rocha <a href="mailto:daniel@rawsocket.org">daniel@rawsocket.org</a> 
  * @version 0.2
  *
  */

public class FileUpload {
	
		private String err = "";
		private HttpServletRequest request; 
		private HashMap collection;
		private String saveDir;
	
		public FileUpload(HttpServletRequest request) {
		this.request = request;
		this.collection = new HashMap();
  }
		
	/**
		
		Sets the directory path where files should be saved, for all MimeBodyPart objects 
		which are files, within the HashMap.Creates directory specified by saveDir if it does not exist.
		
		Has no effect if upload method has not been called yet.
		
		Can be overriden on an individual basis by MimeBodyPart.setSaveDir(String saveDir)
		method. Added in version 0.2
		
		@param saveDir : String representing a directory path. (you should escape \ characters)
		@return void
	  */
		

	
	public void setSaveDir(String saveDir) {
		Collection ks = collection.values(); 
		Iterator i = ks.iterator();
		
		this.saveDir = saveDir;
		
		File f = new File(saveDir);
		if(!f.exists()) { 
			f.mkdirs(); //creates directory specified by saveDir if it does not exist
    }
		
		while(i.hasNext()) {
			Object o = i.next();
			if(o instanceof MimeBodyPart) {
				MimeBodyPart mbp = (MimeBodyPart)o;
        if(mbp != null && mbp.isFile()) {
          mbp.setSaveDir(saveDir);
        }	
      } // instanceof if
			else {
				Vector v = (Vector)o;
				for(int j=0;j<v.size();j++) {
					MimeBodyPart mbp = (MimeBodyPart)v.get(j);
          if(mbp != null && mbp.isFile()) {
            mbp.setSaveDir(saveDir);
          }	
        }
      }
    }
  } //set save dir
	
	/**
	  Returns this object's current path for saving files. Added in version 0.2
	  
	  @return A String representing directory path.
	  */		
	
	public String getSaveDir() { 
		return saveDir;
  }
	
	/**
		Returns a String that shows the last error message. Should be used when upload() 
		returns false.
			
		@return A String representing the last error message.
		
	  */
	
	public String getErrString() { 
		return err; 
  }
	/**
		Parse all http content and populates the HashMap i>collection</i> field with correspondent
		MimeBodyPart objects.
		
		@return A boolean true if the upload was successful, and false otherwise.
		
	  */
	
	
	public boolean upload() {
		getBoundary();
		return (err.equals("")); 
  }
	
	/**
		Maybe the most important method beyond upload. getMimeParts() returns a HashMap
		object that can contain two types of objects :
		
			- MimeBodyPart objects : this means that there's only ONE field with a certain
			  name on the HTML form.
			- Vector objects : this means that there is more than one form field with a certain
			  name (like a <select multiple></select>, for example) within the form, then this Vector 
			  holds all MimeBodyPart objects found under that name.
			 
		To find out whether there are single or multiple form fields with the same name, you
		should use the following code :
		
			<pre>
			HashMap m = fileuploadinstance.getMimeParts();
			Object c = m.get("FieldName");
			if(c instanceof Vector) { 
				// loop thru the Vector filled with MimeBodyParts
				}
			else {
				MimeBodyPart part = (MimeBodyPart)c;
				out.println(part.getName()) // etc.. etc. etc.
				}
			</pre>
		
		@ return A HashMap object containing all of the MimeBodyParts found.
		
	   */
	
	public HashMap getMimeParts() {
		return (HashMap)collection.clone(); 
  }
		
	/* método private para extrair o boundary . chama parseBody depois. */
	
	private void getBoundary()  {
    String contentType = request.getContentType();
		String boundary = "";
		final int BOUNDARY_WORD_SIZE = "boundary=".length();
		
		if(contentType == null || !contentType.startsWith("multipart/form-data")) {
			err = "Ilegal ENCTYPE : must be multipart/form-data\n";
			err += "ENCTYPE set = " + contentType;
		}
		else {
			boundary = contentType.substring(contentType.indexOf("boundary=") + BOUNDARY_WORD_SIZE);
			boundary = "--" + boundary; // do protocolo
			parseBody(boundary);			
		}
  }
	
	/* método private que pega todo o conteúdo postado, separa pelo boundary,
	   e criando vários objetos MimeBodyPart que serão colocados no vector mimeParts */
	
	private void parseBody(String boundary) { 
		ByteArrayOutputStream buffer = new ByteArrayOutputStream();
		
		try { 
			ServletInputStream sis = request.getInputStream(); // usado por causa do método readLine
			byte[] b = new byte[1024]; // acolhe os bytes lidos de sis
			int x=0; // número de bytes lidos a cada passada
			int state=0;
			String name=null,fileName=null,contentType=null; // campos do MimeBodyPart
			
			/*
			
			Trecho mais completo de código, pois o fluxo precisa ser lido de forma
			inteiramente binária, ou corromperá o arquivo.
			
			O método readLine é usado pois ele se comporta da seguinte maneira :
				- lê o número de bytes especificados (1024) OU lê até achar um caractere de newline
			
			Ao achar o newline, crio uma string baseado na matriz atual de bytes, e verifico
			se ela começa com o boundary. Se sim, verifico se é o primeiro boundary (name=null).
			Se for o primeiro, não faz nada porque ainda não leu nada. Se não for, é porque já
			chegou no segundo boundary então os campos já estão preenchidos e é só criar
			o mimeBodyPart, escrever o buffer e zerar tudo, preparando para a próxima leitura.
			
			
			Se a linha começa com "Content-Disposition", vejo se o state é = 0, ou seja, 
			acabou de achar um boundary. Se não for, deixa pra lá pois é DENTRO do arquivo.
			Finalmente, interpreta a linha e acha o "name" do form.
			
			Se a linha começa com "Content-Type", vejo se o state é = a 1 , ou seja, 
			acabou de vir do ContentDisposition. Se não for, deixa pra lá pois é dentro
			do arquivo. Finalmente, interpreta a linha e acha o filename e o content-type.
			
			Se a linha começa com "\r\n" e o state não for 3 (já escrevendo), então eu coloco
			o state para 3. Por quê ? Porque pode ser o "\r\n" depois de Content-Type OU
			dentro do arquivo em si.
			
			Se nenhum desses casos for atingido, escreve no ByteArrayOutputStream, pois é
			parte do arquivo que foi enviado, ou de um campo de form.
			
			
			 
			*/
     
			while((x=sis.readLine(b,0,1024))>-1) {
				String s = new String(b,0,x);
				if(s.startsWith(boundary)) {
					state = 0;
					if(name!=null) {
            byte[] data = buffer.toByteArray();
						MimeBodyPart part = new MimeBodyPart(name,data,fileName,contentType);  
						setupHashMap(part);
						buffer = new ByteArrayOutputStream();
						name = null;
						contentType = null;	 	
						fileName = null;			
						data = null;
						part = null;
          }
        }
				else if(s.startsWith("Content-Disposition") && state==0) {
					state = 1;	
					if(s.indexOf("filename=") == -1) {
						name = s.substring(s.indexOf("name=") + "name=".length(),s.length()-2); //- 2 do CR/LF
          }
					else {
						name = s.substring(s.indexOf("name=") + "name=".length(),s.lastIndexOf(";"));
						fileName = s.substring(s.indexOf("filename=") + "filename=".length(),s.length()-2); //-2 CR/LF "C:\boot.ini" 
						if(fileName.equals("\"\"")) { 
							fileName = null;
            }
						else {
							// patch for file.separator when client and server are different platforms
							// José Miguel Semper
							// jmsemper@users.sourceforge.net
							String userAgent = request.getHeader("User-Agent");
							String userSeparator="/";  // default
							if (userAgent.indexOf("Windows")!=-1) {
                userSeparator="\\";
              }
							if (userAgent.indexOf("Linux")!=-1) {
                userSeparator="/";
              }
							fileName = fileName.substring(fileName.lastIndexOf(userSeparator)+1,fileName.length()-1); // -1 por causa de "
							//Patch for Netscape 6.21 by Carlos ramírez
							//This version of Netscape does not send complete path to filename.
							//cramirez@manduca.com
							if(fileName.startsWith( "\"")) {
								fileName = fileName.substring( 1);
              }
            }
          }
					name = name.substring(1,name.length()-1);
					//err += name + "\n";											
        }
				else if(s.startsWith("Content-Type") && state==1) {
					state = 2;
					contentType = s.substring(s.indexOf(":")+2,s.length()-2);
        }
				else if(s.equals("\r\n") && state != 3) {
					state = 3;								
        }
				else {
					buffer.write(b,0,x);
        }
      } 
			sis.close();
			buffer.close();
    } // try
		catch(IOException e) { 
      err = e.toString(); 
    }		
  }//method 

	
	/* 
    If the name of the MimeBodyPart is unique, it is inserted in the hashmap.
    Otherwise, it creates a vector of MimeBodyParts, under a given name and put the vector in the hashMap
	 */
	
	private void setupHashMap(MimeBodyPart m) { 
		if(m != null) {
			String nome = m.getName();
			Object c;
			if((c=collection.get(nome)) == null) {  // nome de form único
				collection.put(nome,m);
      } // if de collection
			else { 
				if(c instanceof Vector) { //já tem um vetor especificado
					Vector temp = (Vector)c;
					temp.add(m);
					collection.put(nome,temp); // põe o vetor na collection
        }
				else {
					Vector temp = new Vector(); //cria novo vetor
					temp.add(c); // adiciona objeto antigo no vetor
					temp.add(m); // adiciona m no vetor
					collection.put(nome,temp); //adiciona vetor no hashMap (substitui a entrada anterior)
        }
      }
    } // m==null
  } 
	
	
} // fileupload 