#if defined _H_WEAPONS_
    #endinput
#endif
#define _H_WEAPONS_

const MAX_WEAPON_SLOTS = 13;

enum eWeaponData
{
    e_iWeaponId,
    e_iWeaponAmmo
};

new g_rgePlayerWeapons[MAX_PLAYERS + 1][MAX_WEAPON_SLOTS][eWeaponData];
// public const WeaponArrayAddress = __addressof(g_rgePlayerWeapons);

native Player_GiveWeapon(playerid, weaponid, ammo, bool:equip = true, bool:update = true);
native Player_RemoveWeapon(playerid, weaponid);
native Player_GiveAllWeapons(playerid);
native Player_RemoveAllWeapons(playerid);
native Player_TempRemoveWeapons(playerid);
native bool:Player_HasWeaponAtSlot(playerid, weaponslot);
native bool:Player_HasWeapon(playerid, weaponid);
native Player_GetWeaponAtSlot(playerid, weaponslot);
native Weapon_GetSlot(weaponid);