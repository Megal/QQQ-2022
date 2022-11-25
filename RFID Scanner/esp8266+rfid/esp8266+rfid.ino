#include <SPI.h>
#include <MFRC522.h>
#include <ESP8266WiFi.h>
#include <ESP8266HTTPClient.h>
#include <WiFiClient.h>
#include <WiFiClientSecure.h>

#define SS_PIN D4
#define RST_PIN D3

MFRC522 rfid(SS_PIN, RST_PIN); // Instance of the class
MFRC522::MIFARE_Key key;

HTTPClient http;
WiFiClientSecure client;

int i = 0, j = 0, httpCode;
const char* ssid = "covid19";
const char* password = "HuivamA2020";
String host = "https://eoug9vxr5aww76a.m.pipedream.net";
String httpsFingerprint = "";
String payload, sub_string;
unsigned long lastTime = 0;
unsigned long timerDelay = 5000;
String uid = "";
// Init array that will store new NUID
byte nuidPICC[4];
char str[32] = "";

void setup() {
  Serial.begin(115200);

  WiFi.begin(ssid, password);
  SPI.begin(); // Init SPI bus
  rfid.PCD_Init(); // Init MFRC522

  Serial.println();
  Serial.print(F("Reader :"));

  rfid.PCD_DumpVersionToSerial();
  for (byte i = 0; i < 6; i++) {
    key.keyByte[i] = 0xFF;
  }

  Serial.println();
  Serial.println(F("This code scan the MIFARE Classic NUID."));
  Serial.print(F("Using the following key:"));
  printHex(key.keyByte, MFRC522::MF_KEY_SIZE);

  Serial.println("Connecting");
  while(WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("");
  Serial.print("Connected to WiFi network with IP Address: ");
  Serial.println(WiFi.localIP());
 
  Serial.println("Timer set to 5 seconds (timerDelay variable), it will take 5 seconds before publishing the first reading.");
}

void loop() {
 // Reset the loop if no new card present on the sensor/reader. This saves the entire process when idle.
  if ( ! rfid.PICC_IsNewCardPresent())
    return;
 // Verify if the NUID has been readed
  if ( ! rfid.PICC_ReadCardSerial())
    return;
  Serial.print(F("PICC type: "));
  MFRC522::PICC_Type piccType = rfid.PICC_GetType(rfid.uid.sak);
  Serial.println(rfid.PICC_GetTypeName(piccType));
 // Check is the PICC of Classic MIFARE type
  if (piccType != MFRC522::PICC_TYPE_MIFARE_MINI &&
     piccType != MFRC522::PICC_TYPE_MIFARE_1K &&
     piccType != MFRC522::PICC_TYPE_MIFARE_4K) {
    Serial.println(F("Your tag is not of type MIFARE Classic."));
    return;
  }
  if (rfid.uid.uidByte[0] != nuidPICC[0] ||
     rfid.uid.uidByte[1] != nuidPICC[1] ||
     rfid.uid.uidByte[2] != nuidPICC[2] ||
     rfid.uid.uidByte[3] != nuidPICC[3] ) {
    Serial.println(F("A new card has been detected."));
   // Store NUID into nuidPICC array
    for (byte i = 0; i < 4; i++) {
      nuidPICC[i] = rfid.uid.uidByte[i];
      array_to_string(nuidPICC, 4, str);
      uid = str;
    }
    testPOST(uid);
    Serial.println(F("The NUID tag is:"));
    Serial.print(F("In hex: "));
    printHex(rfid.uid.uidByte, rfid.uid.size);
    Serial.println();
    Serial.print(F("In dec: "));
    printDec(rfid.uid.uidByte, rfid.uid.size);
    Serial.println();
  }
  else Serial.println(F("Card read previously."));
 // Halt PICC
  rfid.PICC_HaltA();
 // Stop encryption on PCD
  rfid.PCD_StopCrypto1();
}
/**
   Helper routine to dump a byte array as hex values to Serial.
*/
void printHex(byte *buffer, byte bufferSize) {
  for (byte i = 0; i < bufferSize; i++) {
    Serial.print(buffer[i] < 0x10 ? " 0" : " ");
    Serial.print(buffer[i], HEX);
  }
}
/**
   Helper routine to dump a byte array as dec values to Serial.
*/
void printDec(byte *buffer, byte bufferSize) {
  for (byte i = 0; i < bufferSize; i++) {
    Serial.print(buffer[i] < 0x10 ? " 0" : " ");
    Serial.print(buffer[i], DEC);
  }
}

void testPOST(String uid) {
    if(WiFi.status()== WL_CONNECTED){
      // Your Domain name with URL path or IP address with path
      client.setInsecure();
      http.begin(client, host);
  
      // If you need Node-RED/server authentication, insert user and password below
      //http.setAuthorization("REPLACE_WITH_SERVER_USERNAME", "REPLACE_WITH_SERVER_PASSWORD");
  
      // Specify content-type header
      http.addHeader("Content-Type", "application/json");         
      // Send HTTP POST request
      String httpRequestData = "{\"uid_key\":\"" + uid + "\"}"; 
      int httpResponseCode = http.POST(httpRequestData);
      
      // If you need an HTTP request with a content type: application/json, use the following:
      //http.addHeader("Content-Type", "application/json");
      //int httpResponseCode = http.POST("{\"api_key\":\"tPmAT5Ab3j7F9\",\"sensor\":\"BME280\",\"value1\":\"24.25\",\"value2\":\"49.54\",\"value3\":\"1005.14\"}");

      // If you need an HTTP request with a content type: text/plain
      //http.addHeader("Content-Type", "text/plain");
      //int httpResponseCode = http.POST("Hello, World!");
     
      Serial.print("HTTP Response code: ");
      Serial.println(httpResponseCode);
        
      // Free resources
      http.end();
    }
    else {
      Serial.println("WiFi Disconnected");
    }
}

// Функция поулчения свежего SSL отпечатка
void getSSL_fp() {
  if (WiFi.status() == WL_CONNECTED) {
    i = 0;
    httpCode = 0;
    payload = "";
    http.begin(client, "http://alexgyver.ru/get_SSL_fp.php");
    httpCode = http.GET();
    if (httpCode > 0) {
      payload = http.getString();
      Serial.println("SSL OK!");
    } else {
      Serial.println("SSL fail");
    }
    http.end();
    httpsFingerprint = "";
    if (payload.length() > 0) {
      httpsFingerprint = payload;
    }
  }
}

void array_to_string(byte array[], unsigned int len, char buffer[]) {
  for (unsigned int i = 0; i < len; i++)
  {
    byte nib1 = (array[i] >> 4) & 0x0F;
    byte nib2 = (array[i] >> 0) & 0x0F;
    buffer[i * 2 + 0] = nib1  < 0xA ? '0' + nib1  : 'A' + nib1  - 0xA;
    buffer[i * 2 + 1] = nib2  < 0xA ? '0' + nib2  : 'A' + nib2  - 0xA;
  }
  buffer[len * 2] = '\0';
}