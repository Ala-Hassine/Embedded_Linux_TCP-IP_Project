#include "client.h"
#include <iostream>

int main() 
{
    TCPClient client("127.0.0.1", 8080);
    if (client.ConnectToServer()) 
    {
        client.SendMessage("TCP/IP Client/Server");
        string response = client.ReceiveMessage();
        cout << "Server Response : " << response << std::endl;
    }
    return 0;
}