<%@ page import="java.io.*, java.net.*, java.util.UUID, javax.imageio.ImageIO, java.awt.image.BufferedImage, java.awt.Graphics2D, java.awt.Image, java.util.Calendar" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Image Downloader - Processing</title>
    <meta http-equiv="refresh" content="2;url=../administrator/upload.jsp?dir=media3">
</head>
<body>
    <h4>Processing Image...</h4>

    <%!
    public static boolean saveImage(BufferedImage bImage, int desWidth, 
                float desRatio, String realFolder, String imageFileName, String imageFormatName) {
        boolean success = false;
        
        int srcWidth = bImage.getWidth();
        int srcHeight = bImage.getHeight();    
        float srcRatio = (float)srcWidth/(float)srcHeight;
        
        int desHeight = (int)(desWidth/desRatio);
                
        int cropWidth = srcWidth;
        int cropHeight = srcHeight;
        int cropX = 0;
        int cropY = 0;
        
        if (srcWidth >= desWidth && srcHeight >= desHeight) {
            try {
                if (srcRatio > desRatio) {
                    cropWidth = (int)(srcHeight*desRatio);
                    cropX = (srcWidth - cropWidth)/2;
                } else {
                    cropHeight = (int)(srcWidth/desRatio);
                    cropY = (srcHeight - cropHeight)/2;
                }
                
                BufferedImage croppedImage = bImage.getSubimage(cropX, cropY, cropWidth, cropHeight);
                Image resizedImage = croppedImage.getScaledInstance(desWidth, desHeight, Image.SCALE_SMOOTH);
                BufferedImage outputImage = new BufferedImage(desWidth, desHeight, BufferedImage.TYPE_INT_RGB);
                Graphics2D g2d = outputImage.createGraphics();
                g2d.drawImage(resizedImage, 0, 0, null);
                g2d.dispose();
                
                ImageIO.write(outputImage, imageFormatName, new File(realFolder + imageFileName + "." + imageFormatName));
                success = true;
                
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        
        return success;
    }
    %>

    <%
    // Directory where images will be saved
    String saveDirectory = "C:\\inetpub\\vhosts\\vivalanka.com\\httpdocs\\custom\\media3\\";
    String webFolder = "/images/";

    // Check if the form has been submitted with an image URL
    String imageUrl = request.getParameter("imageUrl");

    if (imageUrl != null && !imageUrl.isEmpty()) {
        try {
            URL url = new URL(imageUrl);
            HttpURLConnection uc = (HttpURLConnection) url.openConnection();
            uc.setRequestMethod("GET");

         
            String imageFormatName = "jpg"; 
            String[] supportedFormats = {"jpeg", "jpg", "gif", "png", "tiff"};
            for (String format : supportedFormats) {
                if (imageUrl.toLowerCase().endsWith("." + format)) {
                    imageFormatName = format;
                    break;
                }
            }
            
            BufferedImage bImage = ImageIO.read(uc.getInputStream());
            
            float desRatio = 1.6180339887498948482f;
            int desWidth = 150;
            
            Calendar cal = Calendar.getInstance();
            String imageFileName = "" + cal.getTimeInMillis();
            
            boolean success = saveImage(bImage, desWidth, desRatio, saveDirectory, imageFileName + "tn", imageFormatName);
            if (success) {
                out.println("<p>Thumbnail saved: " + saveDirectory + imageFileName + "tn." + imageFormatName + "</p>");
            }
            
            desWidth = 360;
            success = saveImage(bImage, desWidth, desRatio, saveDirectory, imageFileName, imageFormatName);
            if (success) {
                out.println("<p>Full size image saved: " + saveDirectory + imageFileName + "." + imageFormatName + "</p>");
            }
            
            out.println("<p style='color:green;'>Images saved successfully.</p>");
        } catch (Exception e) {
            out.println("<p style='color:red;'>Error downloading or resizing image: " + e.getMessage() + "</p>");
            e.printStackTrace();
        }
    } else {
        out.println("<p style='color:red;'>Image URL is required!</p>");
    }
    %>

    <p>You will be redirected to the form page in 2 seconds. If not, click <a href="../administrator/upload.jsp?dir=media3">here</a>.</p>
</body>
</html>