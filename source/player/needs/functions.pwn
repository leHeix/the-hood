#if defined _NEEDS_FUNCTIONS_
    #endinput
#endif
#define _NEEDS_FUNCTIONS_

Needs_ToggleBar(playerid, bool:toggle)
{
    if(toggle)
    {
        TextDrawShowForPlayer(playerid, g_tdNeedBars[0]);
        TextDrawShowForPlayer(playerid, g_tdNeedBars[1]);
        TextDrawShowForPlayer(playerid, g_tdNeedBars[2]);
        TextDrawShowForPlayer(playerid, g_tdNeedBars[3]);

        Needs_UpdateTextDraws(playerid, false);

        TextDrawShowForPlayer(playerid, g_tdNeedProgress[0]);

        TextDrawShowForPlayer(playerid, g_tdNeedBars[4]);
        TextDrawShowForPlayer(playerid, g_tdNeedBars[5]);
        TextDrawShowForPlayer(playerid, g_tdNeedBars[6]);
        TextDrawShowForPlayer(playerid, g_tdNeedBars[7]);
        TextDrawShowForPlayer(playerid, g_tdNeedBars[8]);

        TextDrawShowForPlayer(playerid, g_tdNeedProgress[1]);

        for(new i = 9; i < sizeof(g_tdNeedBars); ++i)
            TextDrawShowForPlayer(playerid, g_tdNeedBars[i]);
    }
    else
    {
        TextDrawHideForPlayer(playerid, g_tdNeedProgress[0]);
        TextDrawHideForPlayer(playerid, g_tdNeedProgress[1]);

        for(new i = sizeof(g_tdNeedBars) - 1; i != -1; --i)
            TextDrawHideForPlayer(playerid, g_tdNeedBars[i]);
    }

    return 0;
}

Needs_StartUpdating(playerid)
{
    g_rgiTimerUpdateNeeds[playerid][NEEDS_HUNGER] = SetTimerEx(!"NEEDS_UpdateThirst", 60000, true, !"i", playerid);
    g_rgiTimerUpdateNeeds[playerid][NEEDS_THIRST] = SetTimerEx(!"NEEDS_UpdateHunger", 120000, true, !"i", playerid);
    return 0;
}

Needs_StopUpdating(playerid)
{
    KillTimer(g_rgiTimerUpdateNeeds[playerid][NEEDS_HUNGER]);
    KillTimer(g_rgiTimerUpdateNeeds[playerid][NEEDS_THIRST]);

    return 
        g_rgiTimerUpdateNeeds[playerid][NEEDS_HUNGER] =
        g_rgiTimerUpdateNeeds[playerid][NEEDS_THIRST] = 0;
}

Needs_UpdateTextDraws(playerid, bool:show = false)
{
    const Float:thirst_full = 596.500;
    const Float:thirst_empty = 505.000;
    const Float:hunger_full = 510.500;
    const Float:hunger_empty = 608.000;

    new Float:thirst_coords = thirst_empty + (Player_Thirst(playerid) * 0.915);
    if(thirst_coords > thirst_full)
        thirst_coords = thirst_full;

    new Float:hunger_coords = hunger_empty - (Player_Hunger(playerid) * 0.975);
    if(hunger_coords < hunger_full)
        hunger_coords = hunger_full;

    TextDrawTextSize(g_tdNeedProgress[0], hunger_coords, 0.0);
    TextDrawTextSize(g_tdNeedProgress[1], thirst_coords, 0.0);

    if(show)
    {
        TextDrawShowForPlayer(playerid, g_tdNeedProgress[0]);
        TextDrawShowForPlayer(playerid, g_tdNeedProgress[1]);
    }

    return 1;
}