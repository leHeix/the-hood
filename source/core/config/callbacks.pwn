#if defined _CORE_CONFIG_CALLBACKS_
	#endinput
#endif
#define _CORE_CONFIG_CALLBACKS_

#include <YSI_Coding\y_hooks>

hook OnScriptInit()
{
    print("[Config] Initializing server configuration...");

	SetMaxPlayers(MAX_PLAYERS);

	for (new i = (sizeof(g_rgcAllowedNameChars) - 1); i != -1; --i)
	{
		AllowNickNameCharacter(g_rgcAllowedNameChars[i], true);
	}

	SetNameTagDrawDistance(20.0);

	SendRconCommand(!"hostname 	  .•°   The Hood (RPG en Español)   °•.");
	SendRconCommand(!"language Español");
	SendRconCommand(!"gamemodetext Roleplay / RPG");

	SetServerRule(!"lagcomp", "skinshot");

	SetServerRuleFlags(!"weather", CON_VARFLAG_READONLY);
	SetServerRuleFlags(!"worldtime", CON_VARFLAG_READONLY);
	SetServerRuleFlags(!"version", CON_VARFLAG_READONLY);
	SetServerRuleFlags(!"mapname", CON_VARFLAG_READONLY);

	AddServerRule(!"versión de sa-mp", !"0.3.7");
	AddServerRule(!"discord", !"rakmong.com/servers/the-hood");
	AddServerRule(!"última actualización", __date);

	SetModeRestartTime(1.0);
	YSF_EnableNightVisionFix(true);
	ToggleCloseConnectionFix(true);
    UsePlayerPedAnims();
    DisableInteriorEnterExits();
    EnableStuntBonusForAll(false);
    ManualVehicleEngineAndLights();

	if(!fexist(!"Config.bin"))
	{
		if(Config_Save())
		{
			print("~ Default config file created.");
		}
	}
	else
	{
		Config_Load();
	}

	print("~ Server config loaded.");
	return 1;
}

hook OnGameModeExit()
{
	print("[Config] Saving...");
	Config_Save();
	return 1;
}

hook OnPlayerConnect(playerid)
{
	new playercount = Iter_Count(Player);
	if(playercount > g_rgeServerData[e_iPlayerRecord])
	{
		g_rgeServerData[e_iPlayerRecord] = playercount;
		printf("[Server] New player record: %d connected player(s).", g_rgeServerData[e_iPlayerRecord]);
		Config_Save();
	}

	return 1;
}