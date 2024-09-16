<%@ page import="javax.crypto.Cipher, javax.crypto.spec.SecretKeySpec, java.sql.*, java.util.Base64" %>
<%
    String action = request.getParameter("action");
    String studentName = request.getParameter("studentName");
    String certificateData = request.getParameter("certificateData");
    String message = "";
    byte[] keyValue = new byte[]{'T', 'h', 'e', 'B', 'e', 's', 't', 'S', 'e', 'c', 'r', 'e', 't', 'K', 'e', 'y'};
    String ALGORITHM = "AES";
    
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/data", "root", "1234");

        if ("encrypt".equals(action)) {
            SecretKeySpec key = new SecretKeySpec(keyValue, ALGORITHM);
            Cipher cipher = Cipher.getInstance(ALGORITHM);
            cipher.init(Cipher.ENCRYPT_MODE, key);
            byte[] encryptedByteValue = cipher.doFinal(certificateData.getBytes("utf-8"));
            String encryptedData = Base64.getEncoder().encodeToString(encryptedByteValue);
            stmt = conn.prepareStatement("INSERT INTO encrypt (student_name, encrypted_data) VALUES (?, ?)");
            stmt.setString(1, studentName);
            stmt.setString(2, encryptedData);
            stmt.executeUpdate();
            message = "Data encrypted and stored successfully!";
        } else if ("decrypt".equals(action)) {
            stmt = conn.prepareStatement("SELECT encrypted_data FROM encrypt WHERE student_name = ?");
            stmt.setString(1, studentName);
            rs = stmt.executeQuery();
            if (rs.next()) {
                String encryptedData = rs.getString("encrypted_data");
                SecretKeySpec key = new SecretKeySpec(keyValue, ALGORITHM);
                Cipher cipher = Cipher.getInstance(ALGORITHM);
                cipher.init(Cipher.DECRYPT_MODE, key);
                byte[] decryptedValue64 = Base64.getDecoder().decode(encryptedData);
                byte[] decryptedByteValue = cipher.doFinal(decryptedValue64);
                String decryptedData = new String(decryptedByteValue, "utf-8");
                message = "Decrypted Data: " + decryptedData;
            } else {
                message = "No data found for the given student name.";
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
        message = "Error: " + e.getMessage();
    } finally {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>

<%
    request.setAttribute("message", message);  
    request.getRequestDispatcher("index.jsp").forward(request, response);
%>
