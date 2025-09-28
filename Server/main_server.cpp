#include "server.h"
#include <iostream>

int main() 
{
    TCPServer server(8080);
    if (!server.StartServer()) 
    {
        return -1;
    }
    if (server.WaitForConnection()) 
    {
        std::string message = server.ReceiveMessage();
        server.SendMessage("Server Received : " + message);
    }
    return 0;
}