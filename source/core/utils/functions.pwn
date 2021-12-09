#if defined _CORE_UTILS_FUNCTIONS_
    #endinput
#endif
#define _CORE_UTILS_FUNCTIONS_

Str_FixEncoding(const string[])
{
    // This goes on data, doesn't matter if it's the whole stack in size
    // Though copy can be quite expensive.
    static result[4096];
    StrCpy(result, string);

    for (new i = (strlen(result) - 1); i != -1; --i)
    {
        switch (result[i])
        {
            case '�': result[i] = 151;
            case '�': result[i] = 152;
            case '�': result[i] = 153;
            case '�': result[i] = 154;
            case '�': result[i] = 128;
            case '�': result[i] = 129;
            case '�': result[i] = 130;
            case '�': result[i] = 131;
            case '�': result[i] = 157;
            case '�': result[i] = 158;
            case '�': result[i] = 159;
            case '�': result[i] = 160;
            case '�': result[i] = 134;
            case '�': result[i] = 135;
            case '�': result[i] = 136;
            case '�': result[i] = 137;
            case '�': result[i] = 161;
            case '�': result[i] = 162;
            case '�': result[i] = 163;
            case '�': result[i] = 164;
            case '�': result[i] = 138;
            case '�': result[i] = 139;
            case '�': result[i] = 140;
            case '�': result[i] = 141;
            case '�': result[i] = 165;
            case '�': result[i] = 166;
            case '�': result[i] = 167;
            case '�': result[i] = 168;
            case '�': result[i] = 142;
            case '�': result[i] = 143;
            case '�': result[i] = 144;
            case '�': result[i] = 145;
            case '�': result[i] = 169;
            case '�': result[i] = 170;
            case '�': result[i] = 171;
            case '�': result[i] = 172;
            case '�': result[i] = 146;
            case '�': result[i] = 147;
            case '�': result[i] = 148;
            case '�': result[i] = 149;
            case '�': result[i] = 174;
            case '�': result[i] = 173;
            case '�': result[i] = 64;
            case '�': result[i] = 175;
            case '`': result[i] = 177;
            case '&': result[i] = 38;
        }
    }

    return result;
}

String:Str_FixEncoding_s(ConstStringTag:orig)
{
    new String:str = str_clone(orig);

    new c, i = -1;
    while((c = str_getc(str, ++i)) != INVALID_CHAR)
    {
        switch (c)
        {
            case '�': str_setc(str, i, 151);
            case '�': str_setc(str, i, 152);
            case '�': str_setc(str, i, 153);
            case '�': str_setc(str, i, 154);
            case '�': str_setc(str, i, 128);
            case '�': str_setc(str, i, 129);
            case '�': str_setc(str, i, 130);
            case '�': str_setc(str, i, 131);
            case '�': str_setc(str, i, 157);
            case '�': str_setc(str, i, 158);
            case '�': str_setc(str, i, 159);
            case '�': str_setc(str, i, 160);
            case '�': str_setc(str, i, 134);
            case '�': str_setc(str, i, 135);
            case '�': str_setc(str, i, 136);
            case '�': str_setc(str, i, 137);
            case '�': str_setc(str, i, 161);
            case '�': str_setc(str, i, 162);
            case '�': str_setc(str, i, 163);
            case '�': str_setc(str, i, 164);
            case '�': str_setc(str, i, 138);
            case '�': str_setc(str, i, 139);
            case '�': str_setc(str, i, 140);
            case '�': str_setc(str, i, 141);
            case '�': str_setc(str, i, 165);
            case '�': str_setc(str, i, 166);
            case '�': str_setc(str, i, 167);
            case '�': str_setc(str, i, 168);
            case '�': str_setc(str, i, 142);
            case '�': str_setc(str, i, 143);
            case '�': str_setc(str, i, 144);
            case '�': str_setc(str, i, 145);
            case '�': str_setc(str, i, 169);
            case '�': str_setc(str, i, 170);
            case '�': str_setc(str, i, 171);
            case '�': str_setc(str, i, 172);
            case '�': str_setc(str, i, 146);
            case '�': str_setc(str, i, 147);
            case '�': str_setc(str, i, 148);
            case '�': str_setc(str, i, 149);
            case '�': str_setc(str, i, 174);
            case '�': str_setc(str, i, 173);
            case '�': str_setc(str, i, 64);
            case '�': str_setc(str, i, 175);
            case '`': str_setc(str, i, 177);
            case '&': str_setc(str, i, 38);
        }
    }

    return str;
}

RawIpToString(rawip)
{
    static ip[16];
    ip[0] = (rawip >> 24);
    ip[1] = (rawip >> 16) & 0xFF;
    ip[2] = (rawip >>  8) & 0xFF;
    ip[3] = rawip & 0xFF;

    format(ip, 16, "%d.%d.%d.%d", ip[0], ip[1], ip[2], ip[3]);

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

levenshtein(const a[], const b[]) {
    new
        aLength = strlen(a),
        bLength = strlen(b);

    if(!aLength || !bLength)
        return 0;

    new
        cache[256],
        index = 0,
        bIndex = 0,
        distance,
        bDistance,
        result,
        code;

    while (index < aLength)
    {
        cache[index] = ++index;
    }

    while (bIndex < bLength) 
    {
        code = b[bIndex];
        result = distance = bIndex++;
        index = -1;

        while (++index < aLength) 
        {
            bDistance = code == a[index] ? distance : distance + 1;
            distance = cache[index];

            cache[index] = result = distance > result
            ? bDistance > result
                ? result + 1
                : bDistance
            : bDistance > distance
                ? distance + 1
                : bDistance;
        }
    }

    return result;
}

SplitTextInLines(const string[], results[][], split_max = sizeof(results), split_at = sizeof(results[]))
{
    ++split_max;

    new string_len = strlen(string) - 1;

    if(string_len < split_at)
    {
        return StrCpy(results[0], string, split_at);
    }

    new j, lastwrap;

    for(new i, wraploc; i < string_len && j < split_max; ++i, ++wraploc)
    {
        if(wraploc >= split_at)
        {
            for(new k = i; k > 0; --k)
            {
                if(k - lastwrap <= split_at && string[k] == ' ')
                {
                    strmid(results[j++], string, lastwrap, k + 1, (j ? split_at - 2 : split_at));
                    if(j)
                        strins(results[j], "� ", 0, split_at);

                    lastwrap = k + 1;
                    break;
                }
            }
            wraploc = i - lastwrap;
        }
    }

    if(!(lastwrap >= string_len) && j < split_max)
        format(results[j++], split_at, "� %s", string[lastwrap]);

    return j;
}

DelayedKick(playerid, time = 250)
{
    inline const Due()
    {
        Kick(playerid);
    }
    PlayerTimer_Start(playerid, time, false, using inline Due);
    return 1;
}

stock binary_search(const arr[], value, low = 0, high = sizeof(arr))
{
    --high;
    
    while(low <= high)
    {
        new middle = low + (high - low) / 2;
        if(arr[middle] == value)
            return middle;

        if(arr[middle] < value)
            low = middle + 1;
        else
            high = middle - 1;
    }

    return -1;
}

Float:lerp(Float:p1, Float:p2, Float:t)
	return p1 + (p2 - p1) * t;

stock GetTickDiff(newtick, oldtick)
{
	if (oldtick > newtick) 
    {
		return (cellmax - oldtick + 1) - (cellmin - newtick);
	}
	return newtick - oldtick;
}

/*
Float:fclamp(Float:v, Float:min, Float:max)
{
    return (v < min ? min : (v > max ? max : v));
}
*/
#if !defined fclamp
    #define fclamp(%0,%1,%2) ((%0) < (%1) ? (%1) : ((%0) > (%2) ? (%2) : (%0)))
#endif