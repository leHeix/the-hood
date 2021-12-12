#include "../main.hpp"

std::vector<AMX_NATIVE_INFO> natives::_natives;

void natives::InitNatives()
{
	_natives.push_back(AMX_NATIVE_INFO{ "Player_GiveWeapon", weapons::Player_GiveWeapon });
	_natives.push_back(AMX_NATIVE_INFO{ "Player_RemoveWeapon", weapons::Player_RemoveWeapon });
	_natives.push_back(AMX_NATIVE_INFO{ "Player_GiveAllWeapons", weapons::Player_GiveAllWeapons });
	_natives.push_back(AMX_NATIVE_INFO{ "Player_RemoveAllWeapons", weapons::Player_RemoveAllWeapons });
	_natives.push_back(AMX_NATIVE_INFO{ "Player_TempRemoveWeapons", weapons::Player_TempRemoveWeapons });
	_natives.push_back(AMX_NATIVE_INFO{ "Player_HasWeaponAtSlot", weapons::Player_HasWeaponAtSlot });
	_natives.push_back(AMX_NATIVE_INFO{ "Player_HasWeapon", weapons::Player_HasWeapon });
	_natives.push_back(AMX_NATIVE_INFO{ "Player_GetWeaponAtSlot", weapons::Player_GetWeaponAtSlot });
	_natives.push_back(AMX_NATIVE_INFO{ "Weapon_GetSlot", weapons::Weapon_GetSlot });
}

void natives::RegisterNatives(AMX* amx)
{
	amx_Register(amx, _natives.data(), _natives.size());
}
