#if defined _H_CHATBUFFER_
    #endinput
#endif
#define _H_CHATBUFFER_

const CHATBUFFER_MAX_SIZE = 200;

#define ChatBuffer_Unhook() (g_rgbShouldRegisterMessages = false)
#define ChatBuffer_Rehook() (g_rgbShouldRegisterMessages = true)

enum eMessageData
{
    e_iMessageColor,
    e_szMessageText[145]
};

new
    List:g_rglPlayerChatBuffer[MAX_PLAYERS],
    bool:g_rgbShouldRegisterMessages = true;
