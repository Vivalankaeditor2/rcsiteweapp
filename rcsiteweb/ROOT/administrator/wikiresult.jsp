<%@ page import="java.io.*, java.net.*, java.util.UUID, javax.imageio.ImageIO, org.json.*,java.awt.image.BufferedImage, java.awt.Graphics2D, java.awt.Image, java.util.Calendar" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Search Results</title>
    <link href="../css/styles.css" rel="stylesheet" type="text/css">
     
</head>
<body>
    
    <h4>Search Results</h4>
    
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
        String downloadPath = "C:\\inetpub\\vhosts\\vivalanka.com\\httpdocs\\custom\\media3\\";
        String downloadImageUrl = request.getParameter("downloadImageUrl");
        String downloadFileName = request.getParameter("downloadFileName");
        String searchTerm = request.getParameter("searchTerm");

        if (downloadImageUrl != null && downloadFileName != null) {
            if (!downloadImageUrl.startsWith("http://") && !downloadImageUrl.startsWith("https://")) {
                downloadImageUrl = "https:" + downloadImageUrl;
            }

            try {
                URL url = new URL(downloadImageUrl);
                URLConnection uc = url.openConnection();
                
                String imageFormatName = "jpg";
                
                BufferedImage bImage = ImageIO.read(uc.getInputStream());

                float desRatio = 1.6180339887498948482f;
                int desWidth = 150;

                // Include searchTerm in the filename
                Calendar cal = Calendar.getInstance();
                String imageFileName = searchTerm.replaceAll(" ", "_") + "_" + cal.getTimeInMillis();

                boolean success = saveImage(bImage, desWidth, desRatio, downloadPath, imageFileName + "tn", imageFormatName);
                if (success) {
                    out.println("<p>Thumbnail saved: " + downloadPath + imageFileName + "tn." + imageFormatName + "</p>");
                }

                desWidth = 350;
                success = saveImage(bImage, desWidth, desRatio, downloadPath, imageFileName, imageFormatName);
                if (success) {
                    out.println("<p>Full size image saved: " + downloadPath + imageFileName + "." + imageFormatName + "</p>");
                }

                out.println("<p style='color:green;'>Images saved successfully.</p>");

                // After the download, go to the previous page
                out.println("<script type='text/javascript'>window.location.href = '../administrator/upload.jsp?dir=media3';</script>");
            } catch (Exception e) {
                out.println("<p style='color:red;'>Error downloading or resizing image: " + e.getMessage() + "</p>");
                StringWriter sw = new StringWriter();
                e.printStackTrace(new PrintWriter(sw));
                out.println("<pre>" + sw.toString() + "</pre>");
            }
        }

        if (searchTerm != null && !searchTerm.isEmpty()) {
            String apiUrl = "https://en.wikipedia.org/api/rest_v1/page/media-list/" + URLEncoder.encode(searchTerm, "UTF-8");

            try {
                URL url = new URL(apiUrl);
                HttpURLConnection conn = (HttpURLConnection) url.openConnection();
                conn.setRequestMethod("GET");
                conn.setRequestProperty("Accept", "application/json");

                int responseCode = conn.getResponseCode();
                if (responseCode != 200) {
                    out.println("<p>Error: Failed (HTTP " + responseCode + ")</p>");
                } else {
                    BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
                    StringBuilder sb = new StringBuilder();
                    String line;
                    while ((line = br.readLine()) != null) {
                        sb.append(line);
                    }
                    conn.disconnect();

                    String jsonResponseString = sb.toString();
                    out.println("<pre>API Response: " + jsonResponseString + "</pre>");

                    JSONObject jsonResponse = new JSONObject(jsonResponseString);
                    JSONArray items = jsonResponse.optJSONArray("items");

                    if (items != null && items.length() > 0) {
                        out.println("<div class='image-grid5'>");
                        for (int i = 0; i < items.length(); i++) {
                            JSONObject imageObject = items.getJSONObject(i);
                            JSONArray srcSet = imageObject.optJSONArray("srcset");

                            if (srcSet != null && srcSet.length() > 0) {
                                JSONObject highResImage = srcSet.getJSONObject(srcSet.length() - 1);
                                String currentImageUrl = highResImage.getString("src");

                                String uniqueFileName = URLEncoder.encode(searchTerm + "_" + i, "UTF-8") + ".jpg";
%>
                               <div class="image-item5">
                                    <img src="<%= currentImageUrl %>" alt="<%= searchTerm %>" id="img_<%= i %>">
                                    <div class="caption5"><%= searchTerm %></div>
                                    <form method="post" action="">
                                        <input type="hidden" name="downloadImageUrl" value="<%= currentImageUrl %>">
                                        <input type="hidden" name="downloadFileName" value="<%= uniqueFileName %>">
                                        <input type="text" class="image-link5" value="<%= currentImageUrl %>" readonly>
                                        <div>
                                            <button type="submit" class="action-button5">Download & Back</button>
                                        </div>                                       
                                    </form>
                                </div>
    <%
                            }
                        }
                        out.println("</div>");
                    } else {
    %>
                        <p>No images found for "<%= searchTerm %>".</p>
    <%
                    }
                }
            } catch (Exception e) {
                StringWriter sw = new StringWriter();
                e.printStackTrace(new PrintWriter(sw));
                out.println("<pre>Error : " + e.getMessage() + "</pre>");
                out.println("<pre>" + sw.toString() + "</pre>");
    %>
                <p>Error : <%= e.getMessage() %></p>
    <%
            }
        }
    %>
    
    <br>
    <br>

    <form method="get" action="">
        <input type="text" name="searchTerm" value="<%= searchTerm != null ? searchTerm : "" %>" placeholder="Search term">
        <button type="submit">Search</button>
    </form>
</body>
</html>