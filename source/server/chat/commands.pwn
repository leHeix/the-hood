#if defined _CHAT_COMMANDS_
    #endinput
#endif
#define _CHAT_COMMANDS_

command decir(playerid, const params[], "Envia un mensaje como tu personaje")
{
    if(g_rgiPlayerLastMessageTick[playerid] && GetTickDiff(GetTickCount(), g_rgiPlayerLastMessageTick[playerid]) < CHAT_MESSAGE_DELAY)
    {
        return va_SendClientMessage(playerid, 0xDADADAFF, "Solo puedes enviar {ED2B2B}un mensaje {DADADA}cada {ED2B2B}%.2f segundos{DADADA}.", floatdiv(CHAT_MESSAGE_DELAY, 1000));
    }

    new text[192];
    if(sscanf(params, "s[144]", text))
        return SendClientMessage(playerid, 0xDADADAFF, "USO: {ED2B2B}/decir{DADADA} <mensaje>");

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

    new short[35];
    format(short, sizeof(short), "%.35s%s", text, (strlen(text) > 30 ? "..." : ""));

    SetPlayerChatBubble(playerid, short, -1, 5.0, 5000);

    g_rgiPlayerLastMessageTick[playerid] = GetTickCount();

    return 1;
}
alias:decir("d")

command ooc(playerid, const params[], "Envia un mensaje al canal fuera de rol")
{
    if(g_rgiPlayerLastMessageTick[playerid] && GetTickDiff(GetTickCount(), g_rgiPlayerLastMessageTick[playerid]) < CHAT_MESSAGE_DELAY)
    {
        return va_SendClientMessage(playerid, 0xDADADAFF, "Solo puedes enviar {ED2B2B}un mensaje {DADADA}cada {ED2B2B}%.2f segundos{DADADA}.", floatdiv(CHAT_MESSAGE_DELAY, 1000));
    }

    new text[192];
    if(sscanf(params, "s[144]", text))
        return SendClientMessage(playerid, 0xDADADAFF, "USO: {ED2B2B}/ooc{DADADA} <mensaje>");

    for(new i = strlen(text) - 1; i != -1; --i)
    {
        if(text[i] == '%')
            text[i] = '#';
    }

    format(text, sizeof(text), "%s: (( %s ))", Player_RPName(playerid), text);
    Player_SendLocalMessage(playerid, 0xABABABFF, 15.0, text);

    new short[40];
    format(short, sizeof(short), "(( %.30s%s ))", text, (strlen(text) > 30 ? "..." : ""));

    SetPlayerChatBubble(playerid, short, 0xABABABFF, 5.0, 5000);

    g_rgiPlayerLastMessageTick[playerid] = GetTickCount();

    return 1;
}
alias:ooc("b")

command gritar(playerid, const params[], "Envia un grito como tu personaje")
{
    if(g_rgiPlayerLastMessageTick[playerid] && GetTickDiff(GetTickCount(), g_rgiPlayerLastMessageTick[playerid]) < CHAT_MESSAGE_DELAY)
    {
        return va_SendClientMessage(playerid, 0xDADADAFF, "Solo puedes enviar {ED2B2B}un mensaje {DADADA}cada {ED2B2B}%.2f segundos{DADADA}.", floatdiv(CHAT_MESSAGE_DELAY, 1000));
    }

    new text[192];
    if(sscanf(params, "s[144]", text))
        return SendClientMessage(playerid, 0xDADADAFF, "USO: {ED2B2B}/gritar{DADADA} <mensaje>");

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

    new short[40];
    format(short, sizeof(short), "!! %.30s%s", text, (strlen(text) > 30 ? "..." : ""));

    SetPlayerChatBubble(playerid, short, -1, 10.0, 5000);

    g_rgiPlayerLastMessageTick[playerid] = GetTickCount();

    return 1;
}
alias:gritar("g")

command me(playerid, const params[], "Ejecuta una acción dentro de rol")
{
    if(g_rgiPlayerLastMessageTick[playerid] && GetTickDiff(GetTickCount(), g_rgiPlayerLastMessageTick[playerid]) < CHAT_MESSAGE_DELAY)
    {
        return va_SendClientMessage(playerid, 0xDADADAFF, "Solo puedes enviar {ED2B2B}un mensaje {DADADA}cada {ED2B2B}%.2f segundos{DADADA}.", floatdiv(CHAT_MESSAGE_DELAY, 1000));
    }
    
    new action[128];
    if(sscanf(params, "s[128]", action)) 
        return SendClientMessage(playerid, 0xDADADAFF, "USO: {ED2B2B}/me{DADADA} <acción>");

    format(action, sizeof(action), "%s %s", Player_RPName(playerid), action);
    Player_SendLocalMessage(playerid, 0xC157EBFF, 15.0, action);

    g_rgiPlayerLastMessageTick[playerid] = GetTickCount();

    return 1;
}
alias:me("y")

command do(playerid, const params[], "Indica el entorno actual")
{
    if(g_rgiPlayerLastMessageTick[playerid] && GetTickDiff(GetTickCount(), g_rgiPlayerLastMessageTick[playerid]) < CHAT_MESSAGE_DELAY)
    {
        va_SendClientMessage(playerid, 0xDADADAFF, "Solo puedes enviar {ED2B2B}un mensaje {DADADA}cada {ED2B2B}%.2f segundos{DADADA}.", floatdiv(CHAT_MESSAGE_DELAY, 1000));
        return 0;
    }

    new env[128];
    if(sscanf(params, "s[128]", env))
        return SendClientMessage(playerid, 0xDADADAFF, "USO: {ED2B2B}/do{DADADA} <entorno>");

    format(env, sizeof(env), "%s (( %s ))", env, Player_RPName(playerid));
    Player_SendLocalMessage(playerid, 0x46C759FF, 15.0, env);

    g_rgiPlayerLastMessageTick[playerid] = GetTickCount();

    return 1;
}
alias:do("p")
