#if defined _FIXES_TEXTDRAWS_
    #endinput
#endif
#define _FIXES_TEXTDRAWS_

#include <YSI_Coding\y_hooks>

forward OnPlayerPressEsc(playerid);

static 
    s_rgiCancelTick[MAX_PLAYERS],
    s_rgiSelectColour[MAX_PLAYERS];

native PrintBacktrace();

hook native SelectTextDraw(playerid, hovercolor)
{
    s_rgiSelectColour[playerid] = hovercolor;
    return continue(playerid, hovercolor);
}

hook native CancelSelectTextDraw(playerid)
{
    s_rgiCancelTick[playerid] = GetTickCount() + 100;
    return continue(playerid);
}

hook OnPlayerClickTextDraw(playerid, Text:clickedid)
{
    if(clickedid == INVALID_TEXT_DRAW)
    {
        if(s_rgiCancelTick[playerid] < GetTickCount())
        {
            CallLocalFunction(!"OnPlayerPressEsc", !"i", playerid);
        }

        s_rgiCancelTick[playerid] = 0;
        return ~1;
    }

    return 1;
}

stock Player_GetSelectionColour(playerid)
{
    return s_rgiSelectColour[playerid];
}