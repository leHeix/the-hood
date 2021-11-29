#if defined _CALLBACKS_CHATBUFFER_
    #endinput
#endif
#define _CALLBACKS_CHATBUFFER_

#include <YSI_Coding\y_hooks>

hook OnPlayerConnect(playerid)
{
    g_rglPlayerChatBuffer[playerid] = list_new();
    list_reserve(g_rglPlayerChatBuffer[playerid], CHATBUFFER_MAX_SIZE);

    return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
    list_delete_deep(g_rglPlayerChatBuffer[playerid]);
    return 1;
}

hook native SendClientMessage(playerid, color, const message[])
{
    if(g_rgbShouldRegisterMessages)
    {
        new data[eMessageData];
        data[e_iMessageColor] = color;
        strcat(data[e_szMessageText], message);
        ChatBuffer_Push(playerid, data);
    }

    return continue(playerid, color, message);
}

hook native SendClientMessageToAll(color, const message[])
{
    if(g_rgbShouldRegisterMessages)
    {
        new data[eMessageData];
        data[e_iMessageColor] = color;
        strcat(data[e_szMessageText], message);

        foreach(new i : Player)
        {
           ChatBuffer_Push(i, data);
        }
    }

    return continue(color, message);
}