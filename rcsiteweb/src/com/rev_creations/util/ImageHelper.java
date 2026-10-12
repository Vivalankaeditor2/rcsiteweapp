package com.rev_creations.util;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.net.URLConnection;
import java.util.Random;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import javax.imageio.ImageIO;
import java.awt.*;
import java.util.ArrayList;
import java.util.List;
import java.util.*;
import java.nio.charset.StandardCharsets;

public class ImageHelper {
	private String fontName ="Arial";
	
	public String getFontName() {
		return fontName;
	}

	public void setFontName(String fontName) {
		this.fontName = fontName;
	}

	public void saveFile(String urlString, String folder){
		System.out.println (urlString);
		try {
			File fileFolder = new File(folder);
			if(!fileFolder.exists()){
				fileFolder.mkdirs();
			}
			
			 URL u = new URL(urlString);
			 URLConnection uc = u.openConnection();
			    uc.setRequestProperty("User-Agent", getUserAgent());
			    String contentType = uc.getContentType();
			    int contentLength = uc.getContentLength();
			    /*
			    if (contentType.startsWith("text/") || contentLength == -1) {
			      throw new IOException("This is not a binary file.");
			    }
			    */
			    InputStream raw = uc.getInputStream();
			    InputStream in = new BufferedInputStream(raw);
			    byte[] data = new byte[contentLength];
			    int bytesRead = 0;
			    int offset = 0;
			    while (offset < contentLength) {
			      bytesRead = in.read(data, offset, data.length - offset);
			      if (bytesRead == -1)
			        break;
			      offset += bytesRead;
			    }
			    in.close();

			    if (offset != contentLength) {
			      throw new IOException("Only read " + offset + " bytes; Expected " + contentLength + " bytes");
			    }

			    String filename = folder+"\\"+urlString.substring(urlString.lastIndexOf('/') + 1);
			    FileOutputStream out = new FileOutputStream(filename);
			    out.write(data);
			    out.flush();
			    out.close();
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}

	/**
	 * @param args
	 */
	
	
	
	
	 // BufferedImage overlayImage = ImageIO.read(new File("C:\\\\inetpub\\\\vhosts\\\\vivalanka.com\\\\httpdocs\\\\custom\\\\media3\\\\BackgroungImage.png"));
     // g2d.drawImage(overlayImage, 50, 50, null);
	
	
	
	
	//image on write start
	
	   public static void main(String[] args) {
	        String imagePath = "C:\\inetpub\\vhosts\\vivalanka.com\\httpdocs\\custom\\media3\\1724045490920.jpg";	        
	        String sinhalaText = "වැසි සහ ගිගුරුම් අනතුරු ඇගවීම";
	        String englishText = "This Image Upload for Test!";

	        ImageHelper generator = new ImageHelper();
	        GraphicsEnvironment local_env = GraphicsEnvironment.getLocalGraphicsEnvironment();
	        String[] allFonts = local_env.getAvailableFontFamilyNames();
	        for (int i = 0; i < allFonts.length; i++) {
	      //      System.out.println(i + ": " + allFonts[i]);
	      //      generator.setFontName(allFonts[i]);
	     //  String sinhalaImagePath = generator.writeOnImage(imagePath, sinhalaText+allFonts[i], true);
	       // String englishImagePath = generator.writeOnImage(imagePath, englishText, false);

	      //  System.out.println("Sinhala image: " + sinhalaImagePath);
	     //   System.out.println("English image: " + englishImagePath);
	        }
	        //generator.setFontName("Latha");
	        String sinhalaImagePath = generator.writeOnImage(imagePath, sinhalaText, true);
	        String englishImagePath = generator.writeOnImage(imagePath, englishText, false);
	        generator.printAvailableFonts();

	    }

	   public String writeOnImage(String imagePath, String words, boolean isSinhala) {
		    String newImagePath = "";
		    try {
		        File overlayFile = new File(imagePath);
		        File backgroundFile = new File("C:\\inetpub\\vhosts\\vivalanka.com\\httpdocs\\custom\\media3\\BackgroundImg.png");
		        File logoFile = new File("C:\\inetpub\\vhosts\\vivalanka.com\\httpdocs\\custom\\media3\\vivalankalogo1.png"); 

		        BufferedImage backgroundImage = ImageIO.read(backgroundFile);
		        BufferedImage overlayImage = ImageIO.read(overlayFile);
		        BufferedImage logoImage = ImageIO.read(logoFile); 

		        Graphics2D g2d = backgroundImage.createGraphics();
		        g2d.drawImage(overlayImage, 10, 10, null); 

		        
		        int logoWidth = logoImage.getWidth();
		        int logoHeight = logoImage.getHeight();
		        int logoX = backgroundImage.getWidth() - logoWidth - 15; 
		        int logoY = 15; 
		        g2d.drawImage(logoImage, logoX, logoY, null);

		       
		        g2d.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_BICUBIC);
		        g2d.setRenderingHint(RenderingHints.KEY_RENDERING, RenderingHints.VALUE_RENDER_QUALITY);
		        g2d.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
		        g2d.setRenderingHint(RenderingHints.KEY_TEXT_ANTIALIASING, RenderingHints.VALUE_TEXT_ANTIALIAS_LCD_HRGB);
		        g2d.setRenderingHint(RenderingHints.KEY_FRACTIONALMETRICS, RenderingHints.VALUE_FRACTIONALMETRICS_ON);

		        Font font;
		        if (isSinhala) {
		            font = findSuitableSinhalaFont(12);  
		        } else {
		            font = new Font("Arial Black", Font.BOLD | Font.ITALIC, 12);  
		        }
		        g2d.setFont(font);

		       
		        int maxWidth = 350;
		        int paddingTop = 1;
		        int paddingRight = 15;
		        int paddingBottom = 1;
		        int paddingLeft = 32;
		        List<String> lines = wrapText(words, g2d.getFontMetrics(), maxWidth - paddingLeft - paddingRight);

		        FontMetrics fontMetrics = g2d.getFontMetrics();
		        int lineHeight = fontMetrics.getHeight();
		        int textHeight = lineHeight * lines.size();
		        int boxWidth = maxWidth + paddingLeft + paddingRight;
		        int boxHeight = textHeight + paddingTop + paddingBottom;
		        int x = (backgroundImage.getWidth() - boxWidth) / 2;
		        int y = backgroundImage.getHeight() - boxHeight - 19;

		        
		        g2d.setColor(new Color(198, 41, 41, 255));
		        g2d.fillRoundRect(x, y, boxWidth, boxHeight, 0, 0);

		       
		        g2d.setColor(new Color(0, 0, 0, 0));
		        int shadowOffset = 2;
		        int textY = y + fontMetrics.getAscent() + paddingTop;
		        for (String line : lines) {
		            int lineX = x + paddingLeft;
		            g2d.drawString(line, lineX + shadowOffset, textY + shadowOffset);
		            textY += lineHeight;
		        }

		       
		        g2d.setColor(Color.WHITE);
		        textY = y + fontMetrics.getAscent() + paddingTop;
		        for (String line : lines) {
		            int lineX = x + paddingLeft;
		            g2d.drawString(line, lineX, textY);
		            textY += lineHeight;
		        }

		        g2d.dispose();

		       
		        String outputFolder = getOutputFolder();
		        String fileExtension = getFileExtension(backgroundFile);
		        String sanitizedWords = sanitizeFilename(words);

		        String originalFileName = overlayFile.getName();
		        String nameWithoutExtension = originalFileName.substring(0, originalFileName.lastIndexOf('.'));

		        String outputFileName = outputFolder + File.separator + 
		                                nameWithoutExtension + "_" + 
		                                System.currentTimeMillis() + "." + 
		                                fileExtension;

		        File outputFile = new File(outputFileName);
		        ImageIO.write(backgroundImage, fileExtension, outputFile);
		        newImagePath = outputFile.getAbsolutePath();

		    } catch (IOException e) {
		        e.printStackTrace();
		    }
		    return newImagePath;
		}

	    private List<String> wrapText(String text, FontMetrics fm, int maxWidth) {
	        List<String> lines = new ArrayList<>();
	        String[] words = text.split("\\s+");
	        StringBuilder currentLine = new StringBuilder();
	        for (String word : words) {
	            if (currentLine.length() > 0) {
	                String lineWithWord = currentLine + " " + word;
	                if (fm.stringWidth(lineWithWord) <= maxWidth) {
	                    currentLine.append(" ").append(word);
	                } else {
	                    lines.add(currentLine.toString());
	                    currentLine = new StringBuilder(word);
	                }
	            } else {
	                currentLine.append(word);
	            }
	        }
	        if (currentLine.length() > 0) {
	            lines.add(currentLine.toString());
	        }
	        return lines;
	    }

	    private Font findSuitableSinhalaFont(int size) {
	        String[] sinhalaFonts = { "Iskoola Pota"};
	        
	        for (String fontName : sinhalaFonts) {
	            Font font = new Font(fontName, Font.BOLD , size);
	            if (font.canDisplay('ශ')) {
	                return font;
	            }
	        }

	        String[] fontNames = GraphicsEnvironment.getLocalGraphicsEnvironment().getAvailableFontFamilyNames();
	        for (String fontName : fontNames) {
	            Font font = new Font(fontName, Font.BOLD, size);
	            if (font.canDisplay('ශ')) {
	                return font;
	            }
	        }       
	        
	        return new Font("Noto Sans Sinhala", Font.BOLD, size);
	    }


	    private String sanitizeFilename(String filename) {      
	        String sanitized = filename.replaceAll("[\\\\/:*?\"<>|]", "_");        
	        if (sanitized.length() > 50) {
	            byte[] bytes = sanitized.getBytes(StandardCharsets.UTF_8);
	            sanitized = new String(Arrays.copyOf(bytes, 50), StandardCharsets.UTF_8);
	        }
	        return sanitized;
	    }

	    private String getOutputFolder() {
	        Calendar calendar = Calendar.getInstance();
	        SimpleDateFormat yearFormat = new SimpleDateFormat("yyyy");
	        SimpleDateFormat monthFormat = new SimpleDateFormat("MM");
	        String year = yearFormat.format(calendar.getTime());
	        String month = monthFormat.format(calendar.getTime());
	        String outputFolder = "C:\\inetpub\\vhosts\\vivalanka.com\\httpdocs\\custom\\media3\\" + year + "\\" + month;
	        File dir = new File(outputFolder);
	        if (!dir.exists()) {
	            dir.mkdirs();
	        }
	        return outputFolder;
	    }

	    private String getFileExtension(File file) {
	        String originalFileName = file.getName();
	        String fileExtension = originalFileName.substring(originalFileName.lastIndexOf(".") + 1).toLowerCase();
	        if (!Arrays.asList("png", "jpg", "gif", "jpeg").contains(fileExtension)) {
	            fileExtension = "jpg"; 
	        }
	        return fileExtension;
	    }

	    public void printAvailableFonts() {
	        GraphicsEnvironment local_env = GraphicsEnvironment.getLocalGraphicsEnvironment();
	        String[] allFonts = local_env.getAvailableFontFamilyNames();
	        for (int i = 0; i < allFonts.length; i++) {
	            System.out.println(i + ": " + allFonts[i]);
	        }
	    }
	
	    
	    //image on write end
	
	public  static String getUserAgent() {

		String userAgent = "Mozilla/5.0 (Windows; U; MSIE 9.0; WIndows NT 9.0; en-US))";
		Random randomGenerator = new Random();
		int randomInt = randomGenerator.nextInt(4);

		switch (randomInt) {
		case 0:
			userAgent = "Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.1; WOW64; Trident/6.0)";
			break;
		case 1:
			userAgent = "Mozilla/5.0 (MSIE 7.0; Macintosh; U; SunOS; X11; gu; SV1; InfoPath.2; .NET CLR 3.0.04506.30; .NET CLR 3.0.04506.648)";
			break;
		case 2:
			userAgent = "Mozilla/5.0 (Windows; U; Windows NT 6.1; tr-TR) AppleWebKit/533.20.25 (KHTML, like Gecko) Version/5.0.4 Safari/533.20.27";
			break;
		case 3:
			userAgent = "Mozilla/6.0 (Macintosh; I; Intel Mac OS X 11_7_9; de-LI; rv:1.9b4) Gecko/2012010317 Firefox/10.0a4";
			break;
		default:
			userAgent = "Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US) AppleWebKit/532+ (KHTML, like Gecko) Version/4.0.2 Safari/530.19.1";
			

		}

		System.out.println("randomInt: " + randomInt +"  userAgent " +userAgent);
		return userAgent;
	}

}
