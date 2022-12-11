#include <WiFi.h>
#include <FirebaseESP32.h>
#include <OneWire.h>
#include <DallasTemperature.h>
#include <Math.h>





#define ONE_WIRE_PIN 15  // defining the temp sensor pin
#define WIFI_SSID "19325" // wifi name
#define WIFI_PASSWORD "193252020" // wifi password 
#define FIREBASE_HOST "https://cap4-c4a14-default-rtdb.firebaseio.com" //database url
#define FIREBASE_AUTH "GWUj2GXL2XAOSpScYQKaNV4FACO24q6aEVcscC4Q" //database secret

OneWire oneWire(ONE_WIRE_PIN); // follow temp sensor library
DallasTemperature sensors(&oneWire); // follow temp sensor library


FirebaseData fbdo; // customizing place to store data in firebase // creating object fbdo from firebasedata class

String sensor = "sensor";

unsigned long time1;


float calibration_value = 21.34 - 0.7;
int phval = 0; 
unsigned long int avgval; 
int buffer_arr[10],temp;
float ph_act;




void setup() {
 
  Serial.begin(115200);
  Serial.println();
  
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD); // Begining wifi and put the pre defined name and pass values
  Serial.print("Connecting to Wi-Fi"); 
  while (WiFi.status() != WL_CONNECTED) // this block check the wifi connection
  {
    Serial.print(".");
    delay(300);

  }
  Serial.println();
  Serial.print("Connected with IP: ");
  Serial.println(WiFi.localIP());
  Serial.println();

  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);
  Firebase.reconnectWiFi(true);
   time1=millis();

}

void loop() {


sensors.requestTemperatures(); // calling temp sensor function


for(int i=0;i<10;i++) // for loop for taking 10 reads and give the average of them
 { 
 buffer_arr[i]=analogRead(36);  // reading values from pin 36
 delay(30);
 }
 for(int i=0;i<9;i++) // take avg of 9 readings
 {
 for(int j=i+1;j<10;j++) //take avg but store it in another variable
 {
 if(buffer_arr[i]>buffer_arr[j])
 {
 temp=buffer_arr[i];
 buffer_arr[i]=buffer_arr[j];
 buffer_arr[j]=temp;
 }
 }
 }
 avgval=0;
 for(int i=2;i<8;i++)
 avgval+=buffer_arr[i];
 float volt=(float)avgval*5.0/1024/6; // calibration of the  sensor readings accordung to the data sheet
  ph_act = -5.70 * volt + calibration_value; // final ph

            
           if(millis()-time1>=1000){ // sending the data every second to firebase
           Firebase.setFloat(fbdo, sensor + "/temp", sensors.getTempCByIndex(0) ); // sending float data to firebase making nested sensor and put temp and ph values
           Firebase.setFloat(fbdo, sensor  + "/ph", ph_act );

             time1=millis();
          
           }

}
