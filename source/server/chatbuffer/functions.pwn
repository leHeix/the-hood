#if defined _FUNCTIONS_CHATBUFFER_
    #endinput
#endif
#define _FUNCTIONS_CHATBUFFER_

ChatBuffer_Push(playerid, const data[eMessageData])
{
    if(list_size(g_rglPlayerChatBuffer[playerid]) == CHATBUFFER_MAX_SIZE)
    {
        list_remove_deep(g_rglPlayerChatBuffer[playerid], 0);
    }

    return list_add_arr(g_rglPlayerChatBuffer[playerid], data);
}

Player_ResendChat(playerid)
{
    ChatBuffer_Unhook();

    new data[eMessageData];
    for_list(i : g_rglPlayerChatBuffer[playerid])
    {
        iter_get_arr_safe(i, data);
        SendClientMessage(playerid, data[e_iMessageColor], data[e_szMessageText]);
    }

    ChatBuffer_Rehook();

    return 1;
}