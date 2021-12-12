#include "main.hpp"

void** hood::plugin_data;
extern void* pAMXFunctions;
std::unique_ptr<net::CRakServer> hood::RakServer;
AMX* hood::main_amx = nullptr;

PLUGIN_EXPORT bool PLUGIN_CALL Load(void** ppData)
{
	hood::plugin_data = ppData;
	pAMXFunctions = ppData[PLUGIN_DATA_AMX_EXPORTS];
	natives::InitNatives();

	return sampgdk::Load(ppData);
}

PLUGIN_EXPORT void PLUGIN_CALL Unload()
{
	sampgdk::Unload();
}

PLUGIN_EXPORT unsigned PLUGIN_CALL Supports()
{
	return sampgdk::Supports() | SUPPORTS_PROCESS_TICK | SUPPORTS_AMX_NATIVES;
}

PLUGIN_EXPORT void PLUGIN_CALL ProcessTick()
{
	sampgdk::ProcessTick();
}

PLUGIN_EXPORT int PLUGIN_CALL AmxLoad(AMX* amx)
{
	cell mmgb;
	if (amx_FindPubVar(amx, "THE_HOOD__", &mmgb) == AMX_ERR_NONE)
	{
		hood::main_amx = amx;
		natives::RegisterNatives(amx);
	}

	return AMX_ERR_NONE;
}

PLUGIN_EXPORT int PLUGIN_CALL AmxUnload(AMX* amx)
{
	if (amx == hood::main_amx)
	{
		hood::main_amx = nullptr;
	}

	return AMX_ERR_NONE;
}

PLUGIN_EXPORT bool PLUGIN_CALL OnGameModeInit()
{
	if(!hood::RakServer)
		hood::RakServer = std::make_unique<net::CRakServer>(hood::plugin_data);
	
	return true;
}

PLUGIN_EXPORT bool PLUGIN_CALL OnPlayerConnect(int playerid)
{
	hood::players[playerid] = std::make_unique<CPlayer>(playerid);
	return true;
}

PLUGIN_EXPORT bool PLUGIN_CALL OnPlayerDisconnect(int playerid, int reason)
{
	hood::players.erase(playerid);
	return true;
}