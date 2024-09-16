<!DOCTYPE html>
<html>
<head>
    <title>AES Encryption Example</title>
</head>
<body>
    <h1>AES Encryption and Decryption</h1>
    <form action="process.jsp" method="post">
        <label for="studentName">Student Name:</label>
        <input type="text" id="studentName" name="studentName" required><br><br>
        
        <label for="certificateData">Certificate Data:</label>
        <input type="text" id="certificateData" name="certificateData"><br><br>
        
        <input type="radio" id="encrypt" name="action" value="encrypt" checked>
        <label for="encrypt">Encrypt</label><br>
        
        <input type="radio" id="decrypt" name="action" value="decrypt">
        <label for="decrypt">Decrypt</label><br><br>
        
        <input type="submit" value="Submit">
    </form>
    
    <br>
    <div>${message}</div>
</body>
</html>
