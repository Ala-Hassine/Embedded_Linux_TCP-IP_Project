#include "client.h"
#include <iostream>
#include <cstring>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

TCPClient::TCPClient(const std::string& ip, int port) 
    : server_ip(ip), server_port(port), sockfd(-1) 
    {}

TCPClient::~TCPClient() 
{
    Disconnect();
}

bool TCPClient::ConnectToServer() 
{
    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd < 0) 
    {
        cerr << "Error Creating Socket" << endl;
        return false;
    }
    struct sockaddr_in server_addr;
    server_addr.sin_family  = AF_INET;
    server_addr.sin_port    = htons(server_port);
    if (inet_pton(AF_INET, server_ip.c_str(), &server_addr.sin_addr) <= 0) 
    {
        cerr << "Invalid Address/Address Not Supported" << endl;
        return false;
    }
    if (connect(sockfd, (struct sockaddr*)&server_addr, sizeof(server_addr)) < 0) 
    {
        cerr << "Connection Failed" << endl;
        return false;
    }
    cout << "Connected To Server " << server_ip << ":" << server_port << endl;
    return true;
}

bool TCPClient::SendMessage(const string& message) 
{
    if (sockfd < 0) 
    {
        cerr << "Not Connected To Server" << endl;
        return false;
    }
    ssize_t bytes_sent = send(sockfd, message.c_str(), message.length(), 0);
    if (bytes_sent < 0) 
    {
        cerr << "Failed To Send Message" << endl;
        return false;
    }
    cout << "Message Sent : " << message << endl;
    return true;
}

string TCPClient::ReceiveMessage() 
{
    if (sockfd < 0) 
    {
        return "";
    }
    char buffer[1024] = {0};
    ssize_t bytes_received = recv(sockfd, buffer, sizeof(buffer) - 1, 0);
    if (bytes_received > 0) 
    {
        return string(buffer, bytes_received);
    }
    return "";
}

void TCPClient::Disconnect() 
{
    if (sockfd >= 0) 
    {
        close(sockfd);
        sockfd = -1;
    }
}