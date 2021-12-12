#if defined _WEAPONS_CALLBACKS_
    #endinput
#endif
#define _WEAPONS_CALLBACKS_

#include <YSI_Coding\y_hooks>

hook OnPlayerDisconnect(playerid, reason)
{
    format(YSI_UNSAFE_HUGE_STRING, YSI_UNSAFE_HUGE_LENGTH, "UPDATE `PLAYER_WEAPONS` SET ");

    for(new i = 1; i < MAX_WEAPON_SLOTS; ++i)
    {
        strcat(YSI_UNSAFE_HUGE_STRING, va_return("`SLOT_%d` = %d", i, Player_GetWeaponAtSlot(playerid, i)), YSI_UNSAFE_HUGE_LENGTH);
        if(i != 12)
            strcat(YSI_UNSAFE_HUGE_STRING, !", ", YSI_UNSAFE_HUGE_LENGTH);
    }

    strcat(YSI_UNSAFE_HUGE_STRING, YSI_UNSAFE_HUGE_LENGTH, " WHERE `ACCOUNT_ID` = %d;", Player_AccountID(playerid));
    mysql_tquery(g_hDatabase, YSI_UNSAFE_HUGE_STRING);

    return 1;
}