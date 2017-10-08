#include <SoftwareSerial.h>
#include<string.h>
#include<stdlib.h>


String connect_wifi = "AT+CWJAP=\"19941204\",\"22222222\"";
String set_target = "AT+CIPSTART=\"TCP\",\"192.168.43.14\",8080";
String close_tcp = "AT+CIPCLOSE";

//int tempature;
uint8_t *box;

void sendcommand(String command);
String get_return();

SoftwareSerial mySerial(4, 5); // Arduino RX:4, TX:5  

void setup()
{
  Serial.begin(9600);
  mySerial.begin(115200);

  sendcommand(connect_wifi);
  Serial.println(get_return());

  box = new byte [100];   
}
void loop() // run over and over
{
  sendcommand(set_target);
  Serial.println(get_return());
  float val;
  float dat;
  val = analogRead(0);
  dat= ( val/1024.0)*500;
  //digitalWrite(2,HIGH);
                                  //dat 四位數 XX.XX 
  String send_long;
  send_long = "AT+CIPSEND=";
  send_long = send_long + String((String(dat)).length());
  sendcommand(send_long);
  Serial.println(get_return());
 
  String msg;
  msg = String(dat);
  sendcommand(msg);
  while(!mySerial.available());
  if(mySerial.find("0"))
  {digitalWrite(2,LOW);}
  else
  {digitalWrite(2,HIGH);}
  
  sendcommand(close_tcp);
  Serial.println(get_return());

  //等一秒鐘
  delay(1000);
}

void sendcommand(String command)
{
    Serial.println(command);
    mySerial.println(command);
    delay(5000);
}

String get_return(){
  while(!mySerial.available());
  String str="";  //儲存接收到的回應字串
  char c;  //儲存接收到的回應字元
  while (mySerial.available()) //若軟體序列埠接收緩衝器還有資料
  {
    c=mySerial.read();  //必須放入宣告為 char 之變數 (才會轉成字元)
    str.concat(c);  //串接回應字元 
    delay(10);  //務必要延遲, 否則太快
  }
  str.trim();  //去除頭尾空白字元
  return str;
}
