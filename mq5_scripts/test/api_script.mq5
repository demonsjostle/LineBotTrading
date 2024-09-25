// Function to send message via LINE Messaging API
void MessagingAPI(string message, string package)
  {
   string headers;
   char post[], result[];

   // Construct headers 
   headers = "Content-Type: application/json\r\n";

   // Prepare the JSON body
   string jsonBody = "{\"message\":\"" + message + "\",\"package\":\"" + package + "\"}";
   ArrayResize(post, StringToCharArray(jsonBody, post, 0, WHOLE_ARRAY, CP_UTF8) - 1);

   // Perform the WebRequest
   int res = WebRequest("POST", "https://kalivesignal.knightarmyacademy.com/api/send-message/", headers, 10000, post, result, headers);

   // Check if the request was successful
   if (res != 200) 
   {
      Print("Failed to send message. Status code: ", res, ", error: ", GetLastError());
      return;
   }

   // Print the server response if successful
   Print("Message sent successfully. Server response: ", CharArrayToString(result));
  }
