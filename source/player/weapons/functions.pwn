#if defined _WEAPONS_FUNCTIONS_
    #endinput
#endif
#define _WEAPONS_FUNCTIONS_

#include <YSI_Coding\y_hooks>

hook native Player_GiveWeapon(playerid, weaponid, ammo, bool:equip = true, bool:update = true)
{
    if(update)
    {
        mysql_format(g_hDatabase, YSI_UNSAFE_HUGE_STRING, YSI_UNSAFE_HUGE_LENGTH, "UPDATE `PLAYER_WEAPONS` SET `SLOT_%d` = %d WHERE `ACCOUNT_ID` = %d LIMIT 1;", Weapon_GetSlot(weaponid), ((ammo << 8) | weaponid), Player_AccountID(playerid));
        mysql_tquery(g_hDatabase, YSI_UNSAFE_HUGE_STRING);
    }
    return continue(playerid, weaponid, ammo, equip, false);
}

hook native Player_RemoveWeapon(playerid, weaponid)
{
    mysql_format(g_hDatabase, YSI_UNSAFE_HUGE_STRING, YSI_UNSAFE_HUGE_LENGTH, "UPDATE `PLAYER_WEAPONS` SET `SLOT_%d` = 0 WHERE `ACCOUNT_ID` = %d LIMIT 1;", Weapon_GetSlot(weaponid), Player_AccountID(playerid));
    mysql_tquery(g_hDatabase, YSI_UNSAFE_HUGE_STRING);
    return continue(playerid, weaponid);
}

hook native Player_RemoveAllWeapons(playerid)
{
    mysql_format(g_hDatabase, YSI_UNSAFE_HUGE_STRING, YSI_UNSAFE_HUGE_LENGTH, "\
        UPDATE `PLAYER_WEAPONS` SET \
            `SLOT_1` = 0, \
            `SLOT_2` = 0, \
            `SLOT_3` = 0, \
            `SLOT_4` = 0, \
            `SLOT_5` = 0, \
            `SLOT_6` = 0, \
            `SLOT_7` = 0, \
            `SLOT_8` = 0, \
            `SLOT_9` = 0, \
            `SLOT_10` = 0, \
            `SLOT_11` = 0, \
            `SLOT_12` = 0 \
        WHERE `ACCOUNT_ID` = %d LIMIT 1;\
    ", Player_AccountID(playerid));
    mysql_tquery(g_hDatabase, YSI_UNSAFE_HUGE_STRING);

    return continue(playerid);
}