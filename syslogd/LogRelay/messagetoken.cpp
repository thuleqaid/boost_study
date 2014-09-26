#include "messagetoken.h"

bool MessageToken::parseMessage(const std::string& msg)
{
    m_token.action="";
    m_token.detail="";
    std::string::size_type pos=0,newpos;
    newpos=msg.find('|',pos);
    if (newpos==std::string::npos)
    {
        return false;
    }
    for(int i=0;i<2;++i)
    {
        pos=newpos+1;
        newpos=msg.find('|',pos);
        if (i==0)
        {
            m_token.action=msg.substr(pos,newpos-pos);
        }
    }
    m_token.detail=msg.substr(newpos+1);
    return true;
}
