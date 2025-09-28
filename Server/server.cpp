#include "server.h"
#include <iostream>
#include <cstring>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>

TCPServer::TCPServer(int port) 
    : port(port), server_fd(-1), client_sockfd(-1), client_connected(false) 
    {}

TCPServer::~TCPServer() 
{
    StopServer();
}

bool TCPServer::StartServer() 
{
    server_fd = socket(AF_INET, SOCK_STREAM, 0);
    if (server_fd == 0) 
    {
        cerr << "Socket creation failed" << endl;
        return false;
    }
    int opt = 1;
    if (setsockopt(server_fd, SOL_SOCKET, SO_REUSEADDR | SO_REUSEPORT, &opt, sizeof(opt))) 
    {
        cerr << "Setsockopt Failed" << endl;
        return false;
    }
    struct sockaddr_in address;
    address.sin_family      = AF_INET;
    address.sin_addr.s_addr = INADDR_ANY;
    address.sin_port        = htons(port);
    if (bind(server_fd, (struct sockaddr*)&address, sizeof(address)) < 0) 
    {
        cerr << "Bind Failed" << std::endl;
        return false;
    }
    if (listen(server_fd, 3) < 0) 
    {
        cerr << "Listen Failed" << std::endl;
        return false;
    }
    cout << "Server Listening On Port " << port << endl;
    return true;
}

bool TCPServer::WaitForConnection() 
{
    if (server_fd < 0) 
    {
        cerr << "Server Not Started" << endl;
        return false;
    }
    struct sockaddr_in client_address;
    socklen_t addrlen = sizeof(client_address);
    cout << "Waiting For Client Connection ..." << std::endl;
    client_sockfd = accept(server_fd, (struct sockaddr*)&client_address, &addrlen);
    if (client_sockfd < 0) 
    {
        cerr << "Accept Failed" << endl;
        return false;
    }
    client_connected = true;
    cout << "Client Connected" << endl;
    return true;
}

string TCPServer::ReceiveMessage() 
{
    if (!client_connected || client_sockfd < 0) 
    {
        return "";
    }
    char buffer[1024]   = {0};
    ssize_t bytes_read  = read(client_sockfd, buffer, sizeof(buffer) - 1);
    if (bytes_read > 0) 
    {
        string message(buffer, bytes_read);
        cout << "Client Sent : " << message << endl;
        return message;
    } 
    else if (bytes_read == 0) 
    {
        cout << "Client Disconnected" << endl;
        client_connected = false;
    }
    
    return "";
}

bool TCPServer::SendMessage(const string& message) 
{
    if (!client_connected || client_sockfd < 0) 
    {
        return false;
    }
    ssize_t bytes_sent = send(client_sockfd, message.c_str(), message.length(), 0);
    return bytes_sent >= 0;
}

void TCPServer::DisconnectClient() 
{
    if (client_sockfd >= 0) 
    {
        close(client_sockfd);
        client_sockfd = -1;
        client_connected = false;
    }
}

void TCPServer::StopServer() 
{
    DisconnectClient();
    if (server_fd >= 0) 
    {
        close(server_fd);
        server_fd = -1;
    }
}
