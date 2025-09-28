#ifndef SERVER_H
#define SERVER_H

#include <string>
using namespace std;

class TCPServer 
{
    private:
        int port;
        int server_fd;
        int client_sockfd;
        bool client_connected;
        
    public:
        TCPServer(int port = 8080);
        ~TCPServer();
        bool StartServer();
        bool WaitForConnection();
        string ReceiveMessage();
        bool SendMessage(const string& message);
        void DisconnectClient();
        void StopServer();
};

#endif