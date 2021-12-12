#include "../main.hpp"

cell natives::weapons::Player_GiveWeapon(AMX* amx, cell* params)
{
	unsigned short playerid = static_cast<unsigned short>(params[1]);

	if (!hood::players.contains(playerid))
		return 0;

	unsigned char weaponid = static_cast<unsigned char>(params[2]);
	unsigned short ammo = static_cast<unsigned short>(params[3]);
	bool equip = static_cast<unsigned short>(params[4]);

	if (equip)
	{
		GivePlayerWeapon(playerid, weaponid, ammo);
	}

	unsigned char slot = CPlayer::stWeaponData::GetSlot(weaponid);
	hood::players[playerid]->Weapons()[slot].valid = true;
	hood::players[playerid]->Weapons()[slot].weaponId = weaponid;
	hood::players[playerid]->Weapons()[slot].ammo = ammo;
	hood::players[playerid]->Weapons()[slot].usable = equip;

	return 1;
}

cell natives::weapons::Player_RemoveWeapon(AMX* amx, cell* params)
{
	unsigned short playerid = static_cast<unsigned short>(params[1]);

	if (!hood::players.contains(playerid))
		return 0;

	unsigned char weaponid = static_cast<unsigned char>(params[2]);

	unsigned char slot = CPlayer::stWeaponData::GetSlot(weaponid);
	hood::players[playerid]->Weapons()[slot] = { false, 0, 0 };

	ResetPlayerWeapons(playerid);

	for (auto&& weapon : hood::players[playerid]->Weapons())
	{
		if (weapon.valid)
		{
			GivePlayerWeapon(playerid, weapon.weaponId, weapon.ammo);
		}
	}

	return 1;
}

cell natives::weapons::Player_TempRemoveWeapons(AMX* amx, cell* params)
{
	unsigned short playerid = static_cast<unsigned short>(params[1]);

	if (!hood::players.contains(playerid))
		return 0;

	ResetPlayerWeapons(playerid);

	for (auto&& weapon : hood::players[playerid]->Weapons())
	{
		weapon.usable = false;
	}

	return 1;
}

cell natives::weapons::Player_GiveAllWeapons(AMX* amx, cell* params)
{
	unsigned short playerid = static_cast<unsigned short>(params[1]);

	if (!hood::players.contains(playerid))
		return 0;

	for (auto&& weapon : hood::players[playerid]->Weapons())
	{
		if (weapon.valid)
		{
			GivePlayerWeapon(playerid, weapon.weaponId, weapon.ammo);
			weapon.usable = true;
		}
	}

	return 1;
}

cell natives::weapons::Player_RemoveAllWeapons(AMX* amx, cell* params)
{
	unsigned short playerid = static_cast<unsigned short>(params[1]);

	if (!hood::players.contains(playerid))
		return 0;

	ResetPlayerWeapons(playerid);

	static const CPlayer::stWeaponData empty_weapon{};
	hood::players[playerid]->Weapons().fill(empty_weapon);

	return 1;
}

cell natives::weapons::Player_HasWeaponAtSlot(AMX* amx, cell* params)
{
	unsigned short playerid = static_cast<unsigned short>(params[1]);

	if (!hood::players.contains(playerid))
		return 0;

	if (params[2] < 0 || params[2] > 12)
		return 0;

	return hood::players[playerid]->Weapons()[params[2]].valid;
}

cell natives::weapons::Player_HasWeapon(AMX* amx, cell* params)
{
	unsigned short playerid = static_cast<unsigned short>(params[1]);

	if (!hood::players.contains(playerid))
		return 0;

	unsigned char slot = CPlayer::stWeaponData::GetSlot(params[2]);

	return hood::players[playerid]->Weapons()[slot].valid;
}

cell natives::weapons::Player_GetWeaponAtSlot(AMX* amx, cell* params)
{
	unsigned short playerid = static_cast<unsigned short>(params[1]);

	if (!hood::players.contains(playerid))
		return 0;
	
	return (hood::players[playerid]->Weapons()[params[2]].ammo << 8) | hood::players[playerid]->Weapons()[params[2]].weaponId;
}

cell natives::weapons::Weapon_GetSlot(AMX* amx, cell* params)
{
	return CPlayer::stWeaponData::GetSlot(params[1]);
}
