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

forward Player_GiveWeapon(playerid, weaponid, ammo);
forward Player_RemoveWeapon(playerid, weaponid);
forward Player_GiveAllWeapons(playerid);
forward void:Player_RemoveAllWeapons(playerid);
forward bool:Player_HasWeaponAtSlot(playerid, weaponslot);
forward bool:Player_HasWeapon(playerid, weaponid);
forward Weapon_GetSlot(weaponid);

#define Player_WeaponSlot(%0,%1) (g_rgePlayerWeapons[(%0)][(%1)])