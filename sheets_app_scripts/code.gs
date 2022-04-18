function myFunction() {
   const email = "ecommerce-b1436@appspot.gserviceaccount.com";
   const key = "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQDA7SWQIaAY0s+E\nj/Ytunfy1yGi4yKglthpjUl2L+ohKNFknsMsD1B1ia/o/hDSL8WbF4cPckoWdfGb\n5it+hKBvCZxI2SswZpaKFVjDwZWpnqvVFcIzbCPiYo1cmBosU4ICWOzmmVFV3FuM\nUs2Rxs9jDzgPpUc++7od9/gUbjbKUMaS3qqRxZK1IsPJEQFJc/S4wpU5d5Z6r5cz\nxiCWWqz0k5Hl+60yDm/lYdq2pXQausP+wHs+/ADX0M+n3yBACa3T6f6GoRdrArzI\n26D5bSwhk6BPyagMgtAtuisSX6rwEzFV1a+14CZxbjEQ6VXCYluVFvM9Y4aKC/uV\nizmYjrXnAgMBAAECggEAOQbgT5Zg6HWH+btEHYg85H9K5gcVuTpdhfXJfTH0lxCl\ntIRpVKDCO7wTT1+qQTb1xj5SIfK6i6EZZefHe4JgmfHRTIdFCO2KGg7tSg/y2UyZ\npkbkPKb+hHB1MKWVNv0INQFsJU20iRi1xujC8xA9RR6+h4FnaeqmvS0LG57oeyyY\nsWw4K0qLvO3G09fRp8uzrZZbE1lQUJWbVE1clW5exqNG8q+dqpeHMV2ycHFFzzoD\nXAf2/YjpAju40Trjqh9wT+BmE78KthDh7JD87VCW4jNjGG7FE5VnehUmcBifZNZL\nynSS/BS7V48rzjju6HtKm5PQX8hBGNZHbD6YCNBUIQKBgQD+UiZyVridmwU+KEDT\nbHm0lV6BXv11tTCKoSK4GzB+XDiDFWXk+hiInNocWA2iljjSliNrDNNzEpOlTBKN\np/e8t7nZS+4hLdrLPUDIF22hYGPZPe7mgZh464XoSWKPPtQwFZwdRA54WGd5iMa9\nrM7L2Gg0gONkn07BbQITTqxiwwKBgQDCMzpx9cS1/o4rYAZkvJwCK2YT1LXPqNIl\nVr0xJyGrOagbQ4VxmuX4FLdEZMgMtseT+nZviQIk2ubbo0T5tcoFNLSjnXqvwxuu\nIUPtC3kd7qs9sIPVpq/WZKkS+78cQSk35eH23pu3xGrXflinmzrSaH9vqdUsGr5+\nDMH4XHxmDQKBgGAUOxAhMRfhs+ZaoLr/FS+i6pQnhcvNSuxkmdBB/V0PjA4BrIAH\n9/LMhx4EKgqNhCQSsojDzLKBhyQAjFXV6iLyqhSsuebxAuKbXnj5WOKJns84taOB\nvE+acvlhmAmT6+fKkjMAPhM7GsRwZtzLh0i9lgiX1NBz2vX6L7mJlFivAoGAFCfg\n/wb1HbaH5vSWdUomHwuGErTXEfCBryJrjHh1RCI90maVqQ7co3zy8IRNRxSJblBm\njnj34f9eSpmNhSVbDGNGBF1J6IgljVMii63PKk4lM8foRvp/8Y6NBc1fLn2M26Je\na5L7Mn2OYUNZzDuORVxXLa3A1E0KTGbikvZ2atkCgYBSVvD1+fp6uZ/GIeheKW+5\nRNp/isFeToq7T5akcKiZuEWbkjqn/HwSHz0X63AVj9Ya2pBWFAyVnlwcntGOtIBB\ns051BwU+AzRybrXPa4lpHbtlkQ9VIK8K4i/53lBimaM4B/hOPmJrgnIkTfD7h9NT\nMFz/6hB/YR6NljQk/pBeng==\n-----END PRIVATE KEY-----\n";
   const projectId = "ecommerce-b1436";
   var firestore = FirestoreApp.getFirestore (email, key, projectId);
// get document data from ther spreadsheet
   var ss = SpreadsheetApp.getActiveSpreadsheet();
   var sheetname = "Product1";
   var sheet = ss.getSheetByName(sheetname); 
   // get the last row and column in order to define range
   var sheetLR = sheet.getLastRow(); // get the last row
   var sheetLC = sheet.getLastColumn(); // get the last column

   var dataSR = 2; // the first row of data
   // define the data range
   var sourceRange = sheet.getRange(2,1,sheetLR-dataSR+1,sheetLC);

   // get the data
   var sourceData = sourceRange.getValues();
   // get the number of length of the object in order to establish a loop value
   var sourceLen = sourceData.length;
  
  // Loop through the rows
   for (var i=0;i<sourceLen;i++){
     if(sourceData[i][1] !== '') {
       var data = {};
       var dateSt = sourceData[i][3].toString();
       var stDate = new Date(dateSt);
       var stringfied = JSON.stringify(stDate);
       var updatedDt = stringfied.slice(1,11);

       data.createdDate = updatedDt;
       data.title = sourceData[i][0];
       data.brandName = sourceData[i][1];
       data.images = JSON.parse(sourceData[i][2]);
       data.salePercent = sourceData[i][4] == ""?null:sourceData[i][4];
       data.isPopular = sourceData[i][5];
       data.numberReviews = sourceData[i][6];
       data.reviewStars = sourceData[i][7];
       data.categoryName = sourceData[i][8];
       data.colors = JSON.parse(sourceData[i][9])  ;
       data.id = sourceData[i][10];
       data.description = sourceData[i][11];
        
       firestore.createDocument("products/"+data.id,data);

     }
    
  }
}
