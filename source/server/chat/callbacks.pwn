#if defined _CHAT_CALLBACKS_
    #endinput
#endif
#define _CHAT_CALLBACKS_

#include <YSI_Coding\y_hooks>

hook OnPlayerText(playerid, text[])
{
    if(!Bit_Get(Player_Flags(playerid), PFLAG_IN_GAME))
        return 0;

    if(g_rgiPlayerLastMessageTick[playerid] && GetTickDiff(GetTickCount(), g_rgiPlayerLastMessageTick[playerid]) < CHAT_MESSAGE_DELAY)
    {
        SendClientMessagef(playerid, 0xDADADAFF, "Solo puedes enviar {ED2B2B}un mensaje {DADADA}cada {ED2B2B}%.2f segundos{DADADA}.", floatdiv(CHAT_MESSAGE_DELAY, 1000));
        return 0;
    }

    for(new i = strlen(text) - 1; i != -1; --i)
    {
        if(text[i] == '%')
            text[i] = '#';
    }

    new message[192];
    if(GetPlayerDrunkLevel(playerid) > 2000)
        format(message, sizeof(message), "%s alcoholizad%c dice: %s", Player_RPName(playerid), (Player_Sex(playerid) ? 'a' : 'o'), text);
    else
        format(message, sizeof(message), "%s dice: %s", Player_RPName(playerid), text);
    
    Player_SendLocalMessage(playerid, -1, 15.0, message);

    new short[35];
    format(short, sizeof(short), "%.30s%s", text, (strlen(text) > 30 ? "..." : ""));

    SetPlayerChatBubble(playerid, short, -1, 5.0, 5000);

    g_rgiPlayerLastMessageTick[playerid] = GetTickCount();

    return 0;
}