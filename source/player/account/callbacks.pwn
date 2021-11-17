#if defined _ACCOUNT_CALLBACKS_
	#endinput
#endif
#define _ACCOUNT_CALLBACKS_

#include <YSI_Coding\y_hooks>

public OnPlayerDataFetched(playerid)
{
	new exists;
	cache_get_row_count(exists);

	if(exists)
	{
		Bit_Set(Player_Flags(playerid), PFLAG_REGISTERED, true);

		cache_get_value_name_int(0, !"ID", Player_AccountID(playerid));
		cache_get_value_name(0, !"PASSWORD", p_szPasswordHash[playerid]);
		cache_get_value_name(0, !"LAST_CONNECTION", Player_GetLastConnection(playerid));

        g_rgePlayerData[playerid][e_pDataCache] = cache_save();
	}

    CallLocalFunction(!"OnPlayerDataLoaded", !"i", playerid);

	return 1;
}

hook OnPlayerConnect(playerid)
{
	EnablePlayerCameraTarget(playerid, true);

	GetPlayerName(playerid, Player_GetName(playerid), MAX_PLAYER_NAME);
	Player_GetIp(playerid) = GetPlayerRawIp(playerid);

	Bit_Set(Player_Flags(playerid), PFLAG_AUTHENTICATING, true);

	new query[65];

    /* `SETTINGS_SET` >> 32 AS SETTINGS_SET_HI, `SETTINGS_SET` & 0b11111111111111111111111111111111 AS SETTINGS_SET_LO */
	mysql_format(g_hDatabase, query, sizeof(query), "SELECT * FROM `PLAYERS` WHERE `NAME` = '%e';", Player_GetName(playerid));
	mysql_tquery(g_hDatabase, query, !"OnPlayerDataFetched", !"i", playerid);

	return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
	Iter_Remove(Admins, playerid);
	Iter_Remove(LoggedIn, playerid);
	
	Account_Save(playerid);

	g_rgePlayerData[playerid] = g_rgePlayerData[MAX_PLAYERS];
    Bit_SetAll(Player_Flags(playerid), false);

	return 1;
}

hook OPPauseStateChange(playerid, pausestate)
{
	if(pausestate)
	{
		g_rgePlayerData[playerid][e_iPlayerPausedBegin] = gettime();
	}
	else if(g_rgePlayerData[playerid][e_iPlayerPausedBegin] != 0)
	{
		g_rgePlayerData[playerid][e_iPlayerPausedTime] = (gettime() - g_rgePlayerData[playerid][e_iPlayerPausedBegin]);
		g_rgePlayerData[playerid][e_iPlayerPausedBegin] = 0;
	}

	return 1;
}

hook OnPlayerSpawn(playerid)
{
    ApplyAnimation(playerid, "PED", "null", 4.1, false, false, false, false, 0, 0);
    ApplyAnimation(playerid, "SMOKING", "null", 4.1, false, false, false, false, 0, 0);
    ApplyAnimation(playerid, "CRIB", "null", 4.1, false, false, false, false, 0, 0);
    return 1;
}