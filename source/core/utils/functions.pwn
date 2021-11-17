#if defined _CORE_UTILS_FUNCTIONS_
    #endinput
#endif
#define _CORE_UTILS_FUNCTIONS_

Str_FixEncoding(const string[])
{
    // This goes on data, doesn't matter if it's the whole stack in size
    // Though copy can be quite expensive.
    static result[4096];
    strcpy(result, string);

    for (new i = (strlen(result) - 1); i != -1; --i)
    {
        switch (result[i])
        {
            case 'à': result[i] = 151;
            case 'á': result[i] = 152;
            case 'â': result[i] = 153;
            case 'ä': result[i] = 154;
            case 'À': result[i] = 128;
            case 'Á': result[i] = 129;
            case 'Â': result[i] = 130;
            case 'Ä': result[i] = 131;
            case 'è': result[i] = 157;
            case 'é': result[i] = 158;
            case 'ê': result[i] = 159;
            case 'ë': result[i] = 160;
            case 'È': result[i] = 134;
            case 'É': result[i] = 135;
            case 'Ê': result[i] = 136;
            case 'Ë': result[i] = 137;
            case 'ì': result[i] = 161;
            case 'í': result[i] = 162;
            case 'î': result[i] = 163;
            case 'ï': result[i] = 164;
            case 'Ì': result[i] = 138;
            case 'Í': result[i] = 139;
            case 'Î': result[i] = 140;
            case 'Ï': result[i] = 141;
            case 'ò': result[i] = 165;
            case 'ó': result[i] = 166;
            case 'ô': result[i] = 167;
            case 'ö': result[i] = 168;
            case 'Ò': result[i] = 142;
            case 'Ó': result[i] = 143;
            case 'Ô': result[i] = 144;
            case 'Ö': result[i] = 145;
            case 'ù': result[i] = 169;
            case 'ú': result[i] = 170;
            case 'û': result[i] = 171;
            case 'ü': result[i] = 172;
            case 'Ù': result[i] = 146;
            case 'Ú': result[i] = 147;
            case 'Û': result[i] = 148;
            case 'Ü': result[i] = 149;
            case 'ñ': result[i] = 174;
            case 'Ñ': result[i] = 173;
            case '¡': result[i] = 64;
            case '¿': result[i] = 175;
            case '`': result[i] = 177;
            case '&': result[i] = 38;
        }
    }

    return result;
}

RawIpToString(rawip)
{
    static ip[16];
    ip[3] = (rawip >> 24) & 0xFF; // hi
    ip[2] = (rawip >> 16) & 0xFF;
    ip[1] = (rawip >>  8) & 0xFF;
    ip[0] = rawip & 0xFF;         // lo

    format(ip, 16, "%d.%d.%d.%d", ip[3], ip[2], ip[1], ip[0]);

    return ip;
}

TextDraw_DelayedSelect(playerid, hovercolor)
{
    inline const Due()
    {
        SelectTextDraw(playerid, hovercolor);
    }
    PlayerTimer_Start(playerid, 200, false, using inline Due);
    return 1;
}

Chat_Clear(playerid = INVALID_PLAYER_ID, lines = 20)
{
    static const space[] = !" ";

    if (playerid == INVALID_PLAYER_ID)
    {
        while (lines-- != -1)
        {
            SendClientMessageToAll(0, space);
        }
    }
    else
    {
        while (lines-- != -1)
        {
            SendClientMessage(playerid, 0, space);
        }
    }

    return 1;
}