#if defined _KEYGAME_CALLBACKS_
    #endinput
#endif
#define _KEYGAME_CALLBACKS_

#include <YSI_Coding\y_hooks>

hook OnPlayerDisconnect(playerid, reason)
{
    Player_StopKeyGame(playerid);
    g_rgeKeyGameData[playerid] = g_rgeKeyGameData[MAX_PLAYERS];
    return 1;
}

public KEYGAME_ProcessKey(playerid)
{
    printf("KEYGAME_ProcessKey");
    printf("Y: %f (max: %f)", g_rgeKeyGameData[playerid][e_fKgCurrentSize], KEYGAME_BAR_MAX_Y);

    if(g_rgeKeyGameData[playerid][e_iKgTimers][KG_TIMER_DECREASE_BAR] == -1)
    {
        print("no hay decrementacion");
        if(g_rgeKeyGameData[playerid][e_fKgCurrentSize] > KEYGAME_BAR_MIN_Y)
        {
            print("decrementando barra");
            g_rgeKeyGameData[playerid][e_iKgTimers][KG_TIMER_DECREASE_BAR] = SetTimerEx("KEYGAME_DecreaseBar", 1500, true, "i", playerid);
        }
    }

    new keys, ud, lr;
    GetPlayerKeys(playerid, keys, ud, lr);

    printf("keys: %d", keys);
    printf("ud: %d", ud);
    printf("lr: %d", lr);

    new current_key = g_rgiRandomKeys[g_rgeKeyGameData[playerid][e_iKgCurrentKey]];
    if((current_key & keys) != 0 || ud == current_key || lr == current_key)
    {
        SendClientMessagef(playerid, -1, "tecla %s presionada", g_rgszKeyNames[g_rgeKeyGameData[playerid][e_iKgCurrentKey]]);
        g_rgeKeyGameData[playerid][e_bKgKeyRed] = false;

        g_rgeKeyGameData[playerid][e_fKgCurrentSize] = fclamp(g_rgeKeyGameData[playerid][e_fKgCurrentSize] + g_rgeKeyGameData[playerid][e_fKgPercentagePerKey], KEYGAME_BAR_MIN_Y, KEYGAME_BAR_MAX_Y);

        TextDrawTextSize(g_tdKeyGame[1], 298.500, g_rgeKeyGameData[playerid][e_fKgCurrentSize]);
        TextDrawShowForPlayer(playerid, g_tdKeyGame[1]);
        if(g_rgeKeyGameData[playerid][e_fKgCurrentSize] == KEYGAME_BAR_MAX_Y)
        {
            Player_StopKeyGame(playerid, false);
            new Func:cb<i> = g_rgeKeyGameData[playerid][e_pKgCallback];
            @.cb(true);
            Indirect_Release(cb);
        }
        else
        {
            SendClientMessage(playerid, -1, "alternando tecla");
            g_rgeKeyGameData[playerid][e_iKgCurrentKey] = random(sizeof(g_rgiRandomKeys));
            SendClientMessagef(playerid, -1, "toco %s", g_rgszKeyNames[g_rgeKeyGameData[playerid][e_iKgCurrentKey]]);
            PlayerTextDrawSetString(playerid, p_tdKeyGame{playerid}, g_rgszKeyNames[g_rgeKeyGameData[playerid][e_iKgCurrentKey]]);
            g_rgeKeyGameData[playerid][e_iKgLastKeyAppearance] = GetTickCount();
        }
    }
    else
    {
        if(!g_rgeKeyGameData[playerid][e_bKgKeyRed] && GetTickCount() - g_rgeKeyGameData[playerid][e_iKgLastKeyAppearance] >= 5000)
        {
            SendClientMessage(playerid, -1, "tecla roja activada: 5 segundos para perder");
            g_rgeKeyGameData[playerid][e_bKgKeyRed] = true;
            g_rgeKeyGameData[playerid][e_iKgKeyRedTick] = GetTickCount();
            PlayerTextDrawSetString(playerid, p_tdKeyGame{playerid}, va_return("~r~%s", g_rgszKeyNames[g_rgeKeyGameData[playerid][e_iKgCurrentKey]]));
        }
        else if(g_rgeKeyGameData[playerid][e_bKgKeyRed] && GetTickCount() - g_rgeKeyGameData[playerid][e_iKgKeyRedTick] >= 5000)
        {
            Player_StopKeyGame(playerid, false);
            new Func:cb<i> = g_rgeKeyGameData[playerid][e_pKgCallback];
            @.cb(false);
            Indirect_Release(cb);
        }
    }

    return 1;
}

public KEYGAME_DecreaseBar(playerid)
{
    g_rgeKeyGameData[playerid][e_fKgCurrentSize] = fclamp(g_rgeKeyGameData[playerid][e_fKgCurrentSize] - g_rgeKeyGameData[playerid][e_fKgDecreaseSec], KEYGAME_BAR_MIN_Y, KEYGAME_BAR_MAX_Y);
    TextDrawTextSize(g_tdKeyGame[1], 298.500, g_rgeKeyGameData[playerid][e_fKgCurrentSize]);
    TextDrawShowForPlayer(playerid, g_tdKeyGame[1]);

    return 1;
}