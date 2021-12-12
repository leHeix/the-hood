#pragma once

namespace natives
{
	extern std::vector<AMX_NATIVE_INFO> _natives;

	namespace weapons
	{
		cell Player_GiveWeapon(AMX* amx, cell* params);
		cell Player_RemoveWeapon(AMX* amx, cell* params);
		cell Player_GiveAllWeapons(AMX* amx, cell* params);
		cell Player_RemoveAllWeapons(AMX* amx, cell* params);
		cell Player_TempRemoveWeapons(AMX* amx, cell* params);
		cell Player_HasWeaponAtSlot(AMX* amx, cell* params);
		cell Player_HasWeapon(AMX* amx, cell* params);
		cell Player_GetWeaponAtSlot(AMX* amx, cell* params);
		cell Weapon_GetSlot(AMX* amx, cell* params);
	}

	void InitNatives();
	void RegisterNatives(AMX* amx);
}