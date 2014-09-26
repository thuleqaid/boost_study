#ifndef MESSAGETOKEN_H
#define MESSAGETOKEN_H
#include <string>

class MessageToken
{
public:
    MessageToken():m_token() {}
    bool parseMessage(const std::string& msg);
    const std::string& action() { return m_token.action; }
    const std::string& detail() { return m_token.detail; }
private:
    struct Token
    {
        Token():action(""),detail("") {}
        std::string action;
        std::string detail;
    };
    Token m_token;
};

#endif // MESSAGETOKEN_H
