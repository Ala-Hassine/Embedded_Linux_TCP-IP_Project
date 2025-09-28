#ifndef CLIENT_H
#define CLIENT_H

#include <string>
using namespace std;

class TCPClient 
{
    private:
        string server_ip;
        int server_port;
        int sockfd;
        
    public:
        TCPClient(const string& ip = "127.0.0.1", int port = 8080);
        ~TCPClient();
        bool ConnectToServer();
        bool SendMessage(const string& message);
        string ReceiveMessage();
        void Disconnect();
};

#endif
