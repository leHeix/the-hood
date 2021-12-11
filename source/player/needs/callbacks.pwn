#if defined _NEEDS_CALLBACKS_
    #endinput
#endif
#define _NEEDS_CALLBACKS_

#include <YSI_Coding\y_hooks>

hook OnPlayerDisconnect(playerid, reason)
{
    Needs_StopUpdating(playerid);
    return 1;
}

public NEEDS_UpdateThirst(playerid)
{
    if(Player_Thirst(playerid) < 100.0)
    {
        Player_Thirst(playerid) += NEEDS_THIRST_INCREASE;

        if(Needs_BarShown(playerid))
        {
            Needs_UpdateTextDraws(playerid, false);
            TextDrawShowForPlayer(playerid, g_tdNeedProgress[1]);
        }
    }

    return 1;
}

public NEEDS_UpdateHunger(playerid)
{
    if(Player_Hunger(playerid) < 100.0)
    {
        Player_Hunger(playerid) += NEEDS_HUNGER_INCREASE;

        if(Needs_BarShown(playerid))
        {
            Needs_UpdateTextDraws(playerid, false);
            TextDrawShowForPlayer(playerid, g_tdNeedProgress[0]);
        }
    }

    return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if((newkeys & KEY_CTRL_BACK) != 0)
    {
        if(IsPlayerInAnyVehicle(playerid))
            return 1;
    
        Player_DrinkFromHand(playerid);
    }

    return 1;
}
