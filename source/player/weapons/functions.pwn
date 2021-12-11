#if defined _WEAPONS_FUNCTIONS_
    #endinput
#endif
#define _WEAPONS_FUNCTIONS_

Weapon_GetSlot(weaponid)
{
    switch(weaponid)
    {
        case 0, 1:          return 0;
        case 2 .. 9:        return 1;
        case 10 .. 15:      return 10;
        case 16 .. 18:      return 8;
        case 22 .. 24:      return 2;
        case 25 .. 27:      return 3;
        case 28, 29, 32:    return 4;
        case 30, 31:        return 5;
        case 33, 34:        return 6;
        case 35 .. 38:      return 7;
        case 39:            return 8;
        case 40:            return 12;
        case 41 .. 43:      return 9;
        case 44 .. 46:      return 11;
    }

    return MAX_WEAPON_SLOTS;
}

Player_GiveWeapon(playerid, weaponid, ammo)
{
    new slot = GetWeaponSlot(weaponid);

    Player_WeaponSlot(playerid, slot)[e_iWeaponId] = weaponid;
    Player_WeaponSlot(playerid, slot)[e_iWeaponAmmo] = ammo;

    GivePlayerWeapon(playerid, weaponid, ammo);

    new weapon_and_ammo = (clamp(ammo, 0, 32767) << 8) | weaponid;

    mysql_format(g_hDatabase, YSI_UNSAFE_HUGE_STRING, YSI_UNSAFE_HUGE_LENGTH,
        "UPDATE `PLAYER_WEAPONS` SET \
            `SLOT_%d` = %d \
        WHERE `ACCOUNT_ID` = %d LIMIT 1;\
    ", slot, weapon_and_ammo, Player_AccountID(playerid));
    mysql_tquery(g_hDatabase, YSI_UNSAFE_HUGE_STRING);

    return 1;
}

Player_RemoveWeapon(playerid, weaponid)
{
    new slot = Weapon_GetSlot(weaponid);
    if(!Player_HasWeaponAtSlot(playerid, slot))
        return 0;
    
    Player_WeaponSlot(playerid, slot)[e_iWeaponId] = 
    Player_WeaponSlot(playerid, slot)[e_iWeaponAmmo] = 0;

    mysql_format(g_hDatabase, YSI_UNSAFE_HUGE_STRING, YSI_UNSAFE_HUGE_LENGTH, "UPDATE `PLAYER_WEAPONS` SET `SLOT_%d` = 0 WHERE `ACCOUNT_ID` = %d LIMIT 1;", slot, Player_AccountID(playerid));
    mysql_tquery(g_hDatabase, YSI_UNSAFE_HUGE_STRING);

    ResetPlayerWeapons(playerid);

    for(new i = 1; i < MAX_WEAPON_SLOTS; ++i)
    {
        if(Player_WeaponSlot(playerid, slot)[e_iWeaponId])
        {
            GivePlayerWeapon(playerid, Player_WeaponSlot(playerid, slot)[e_iWeaponId], Player_WeaponSlot(playerid, slot)[e_iWeaponAmmo]);
        }
    }

    return 1;
}

void:Player_RemoveAllWeapons(playerid)
{
    ResetPlayerWeapons(playerid);
    g_rgePlayerWeapons[playerid] = g_rgePlayerWeapons[MAX_PLAYERS];

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
}

bool:Player_HasWeaponAtSlot(playerid, weaponslot)
{
    return (g_rgePlayerWeapons[playerid][weaponslot][e_iWeaponId] != 0);
}

Player_GiveAllWeapons(playerid)
{
    for(new i = 1; i < MAX_WEAPON_SLOTS; ++i)
    {
        if(!Player_HasWeaponAtSlot(playerid, i))
            continue;

        GivePlayerWeapon(playerid, Player_WeaponSlot(playerid, i)[e_iWeaponId], Player_WeaponSlot(playerid, i)[e_iWeaponAmmo]);
    }

    return 1;
}