#if defined _CHAT_FUNCTIONS_
    #endinput
#endif
#define _CHAT_FUNCTIONS_

Player_SendLocalMessage(playerid, color, Float:range, const message[])
{
    new messages[2][145];
    if(strlen(message) > 144)
    {
        SplitTextInLines(message, messages);
    
    }
    else
    {
        strcat(messages[0], message);
        messages[1][0] = '\0';
    }

    new 
        Float:x, Float:y, Float:z, 
        vw = GetPlayerVirtualWorld(playerid),
        int = GetPlayerInterior(playerid);

    GetPlayerPos(playerid, x, y, z);

    foreach(new i : StreamedPlayer[playerid])
    {
        if(GetPlayerVirtualWorld(i) != vw || GetPlayerInterior(int) != int)
            continue;

        new Float:distance = GetPlayerDistanceFromPoint(i, x, y, z);
        if(distance > range)
            continue;

        new color_relative = (255 - floatround(distance * 3.0));
        new color_darkened = Color_Darken(color, color_relative);
        
        SendClientMessage(i, color_darkened, messages[0]);
        if(!isnull(messages[1]))
            SendClientMessage(i, color_darkened, messages[1]);
    }

    SendClientMessage(playerid, color, messages[0]);
    if(!isnull(messages[1]))
        SendClientMessage(playerid, color, messages[1]);

    return 1;    
}