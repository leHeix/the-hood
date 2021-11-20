#if defined _CHAT_COMMANDS_
    #endinput
#endif
#define _CHAT_COMMANDS_

command decir(playerid, const params[], "Envia un mensaje como tu personaje")
{
    extract params -> new text[192]; else return SendClientMessage(playerid, 0xDADADAFF, "USO: {ED2B2B}/decir{DADADA} <mensaje>");

    for(new i = strlen(text) - 1; i != -1; --i)
    {
        if(text[i] == '%')
            text[i] = '#';
    }

    if(GetPlayerDrunkLevel(playerid) > 2000)
        format(text, sizeof(text), "%s alcoholizad%c dice: %s", Player_RPName(playerid), (Player_Sex(playerid) ? 'a' : 'o'), text);
    else
        format(text, sizeof(text), "%s dice: %s", Player_RPName(playerid), text);
    
    Player_SendLocalMessage(playerid, -1, 15.0, text);

    new short[20];
    format(short, sizeof(short), "%.15s%s", text, (strlen(text) > 15 ? "..." : ""));

    SetPlayerChatBubble(playerid, short, -1, 5.0, 5000);

    g_rgiPlayerLastMessageTick[playerid] = GetTickCount() + CHAT_MESSAGE_DELAY;

    return 1;
}
alias:decir("d")

command ooc(playerid, const params[], "Envia un mensaje al canal fuera de rol")
{
    extract params -> new text[192]; else return SendClientMessage(playerid, 0xDADADAFF, "USO: {ED2B2B}/ooc{DADADA} <mensaje>");

    for(new i = strlen(text) - 1; i != -1; --i)
    {
        if(text[i] == '%')
            text[i] = '#';
    }

    format(text, sizeof(text), "%s: (( %s ))", Player_RPName(playerid), text);
    Player_SendLocalMessage(playerid, 0x595959FF, 15.0, text);

    new short[25];
    format(short, sizeof(short), "(( %.15s%s ))", text, (strlen(text) > 15 ? "..." : ""));

    SetPlayerChatBubble(playerid, short, 0x595959FF, 5.0, 5000);

    g_rgiPlayerLastMessageTick[playerid] = GetTickCount() + CHAT_MESSAGE_DELAY;

    return 1;
}
alias:ooc("b")

command gritar(playerid, const params[], "Envia un grito como tu personaje")
{
    extract params -> new text[192]; else return SendClientMessage(playerid, 0xDADADAFF, "USO: {ED2B2B}/gritar{DADADA} <mensaje>");

    for(new i = strlen(text) - 1; i != -1; --i)
    {
        if(text[i] == '%')
            text[i] = '#';
    }

    if(GetPlayerDrunkLevel(playerid) > 2000)
        format(text, sizeof(text), "%s alcoholizad%c grita: %s", Player_GetName(playerid), (Player_Sex(playerid) ? 'a' : 'o'), text);
    else
        format(text, sizeof(text), "%s grita: %s", Player_RPName(playerid), text);
    
    Player_SendLocalMessage(playerid, -1, 30.0, text);

    new short[25];
    format(short, sizeof(short), "!! %.15s%s", text, (strlen(text) > 15 ? "..." : ""));

    SetPlayerChatBubble(playerid, short, -1, 10.0, 5000);

    g_rgiPlayerLastMessageTick[playerid] = GetTickCount() + CHAT_MESSAGE_DELAY;

    return 1;
}
alias:gritar("g")

command me(playerid, const params[], "Ejecuta una acción dentro de rol")
{
    extract params -> new action[128]; else return SendClientMessage(playerid, 0xDADADAFF, "USO: {ED2B2B}/me{DADADA} <acción>");

    format(action, sizeof(action), "%s %s", Player_RPName(playerid), action);
    Player_SendLocalMessage(playerid, 0xA443C4FF, 15.0, action);

    return 1;
}
alias:me("y")

command do(playerid, const params[], "Indica el entorno actual")
{
    extract params -> new env[128]; else return SendClientMessage(playerid, 0xDADADAFF, "USO: {ED2B2B}/do{DADADA} <entorno>");

    format(env, sizeof(env), "%s (( %s ))", env, Player_RPName(playerid));
    Player_SendLocalMessage(playerid, 0x46C759FF, 15.0, env);

    return 1;
}
alias:do("p")
