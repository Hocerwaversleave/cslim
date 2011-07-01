#include <SPI.h>

#include <Client.h>
#include <Ethernet.h>
#include <Server.h>
#include <Udp.h>
#include "TcpComLink.h"

extern "C" {
  #include "Slim.h"
}

Slim * slim;
Server server(4123);

byte mac[] = { 0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED };  
//the IP address for the shield:
byte ip[] = { 10, 0, 0, 177 };   

void setup()
{
  slim = Slim_Create();
  Serial.begin(9600);
  Serial.println("Hello from CSlim");
//  // initialize the ethernet device
  Ethernet.begin(mac, ip);
  Serial.println("Ethernet Begun");
//
//  // start listening for clients
  server.begin();
}

void loop()
{
//  // if an incoming client connects, there will be bytes available to read:
  Client client = server.available();
  Serial.println("Checking Client");
  if (client == true) {
    Serial.println("got connection");
    TcpComLink * comLink = TcpComLink_Create(&client);	
    Slim_HandleConnection(slim, (void*)comLink, &TcpComLink_send, &TcpComLink_recv);
    TcpComLink_Destroy(comLink);    
  }
}



