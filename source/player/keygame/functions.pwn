#if defined _KEYGAME_FUNCTIONS_
    #endinput
#endif
#define _KEYGAME_FUNCTIONS_

Player_StartKeyGame(playerid, Func:cb<i>, Float:key_percentage_up = 9.9, Float:decrease_sec = 2.5)
{
    g_rgeKeyGameData[playerid][e_iKgCurrentKey] = random(sizeof(g_rgiRandomKeys));
    
    TextDrawTextSize(g_tdKeyGame[1], 298.500, KEYGAME_BAR_MIN_Y);
    PlayerTextDrawSetString(playerid, p_tdKeyGame{playerid}, g_rgszKeyNames[ g_rgeKeyGameData[playerid][e_iKgCurrentKey] ]);
    PlayerTextDrawShow(playerid, p_tdKeyGame{playerid});
    
    for(new i = sizeof(g_tdKeyGame) - 1; i != -1; --i)
    {
        TextDrawShowForPlayer(playerid, g_tdKeyGame[i]);
    }

    Indirect_Claim(cb);
    g_rgeKeyGameData[playerid][e_fKgCurrentSize] = KEYGAME_BAR_MIN_Y;
    g_rgeKeyGameData[playerid][e_pKgCallback] = cb;
    g_rgeKeyGameData[playerid][e_iKgLastKeyAppearance] = GetTickCount();
    g_rgeKeyGameData[playerid][e_fKgDecreaseSec] = decrease_sec;
    g_rgeKeyGameData[playerid][e_fKgPercentagePerKey] = key_percentage_up;
    g_rgeKeyGameData[playerid][e_bKgKeyRed] = false;
    g_rgeKeyGameData[playerid][e_iKgKeyRedTick] = 0;

    g_rgeKeyGameData[playerid][e_iKgTimers][KG_TIMER_DECREASE_BAR] = -1;
    g_rgeKeyGameData[playerid][e_iKgTimers][KG_TIMER_PROCESS_KEY]  = SetTimerEx("KEYGAME_ProcessKey", 200, true, "i", playerid);

    return 1;
}

Player_StopKeyGame(playerid, bool:free_cb = true)
{
    KillTimer(g_rgeKeyGameData[playerid][e_iKgTimers][KG_TIMER_DECREASE_BAR]);
    KillTimer(g_rgeKeyGameData[playerid][e_iKgTimers][KG_TIMER_PROCESS_KEY]);

    for(new i = sizeof(g_tdKeyGame) - 1; i != -1; --i)
    {
        TextDrawHideForPlayer(playerid, g_tdKeyGame[i]);
    }
    PlayerTextDrawHide(playerid, p_tdKeyGame{playerid});

    if(free_cb)
        Indirect_Release(g_rgeKeyGameData[playerid][e_pKgCallback]);

    return 1;
}