#if defined _FIXES_TEXTDRAWS_
    #endinput
#endif
#define _FIXES_TEXTDRAWS_

#include <YSI_Coding\y_hooks>

forward OnPlayerPressEsc(playerid);

static 
    s_rgiCancelTick[MAX_PLAYERS],
    s_rgiSelectColor[MAX_PLAYERS];

native PrintBacktrace();

hook native SelectTextDraw(playerid, hovercolor)
{
    s_rgiSelectColor[playerid] = hovercolor;
    return continue(playerid, hovercolor);
}

hook native CancelSelectTextDraw(playerid)
{
    s_rgiCancelTick[playerid] = GetTickCount();
    return continue(playerid);
}

hook OnPlayerClickTextDraw(playerid, Text:clickedid)
{
    if(clickedid == INVALID_TEXT_DRAW)
    {
        if(!s_rgiCancelTick[playerid] || GetTickDiff(GetTickCount(), s_rgiCancelTick[playerid]) < 50 + GetPlayerPing(playerid))
        {
            CallLocalFunction(!"OnPlayerPressEsc", !"i", playerid);
        }

        s_rgiCancelTick[playerid] = 0;
        return ~1;
    }

    return 1;
}

stock Player_GetSelectionColor(playerid)
{
    return s_rgiSelectColor[playerid];
}