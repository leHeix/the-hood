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
	new len = GetPlayerName(playerid, Player_GetName(playerid), MAX_PLAYER_NAME);

    new String:tmp = str_new_arr(Player_GetName(playerid), len + 1);
    if(!str_match(tmp, "[A-Z]{1}[a-zA-Z]+_{1}[A-Z]{1}[a-zA-Z]+", .options = regex_cached))
    {
        Dialog_Show(
            playerid, DIALOG_STYLE_MSGBOX, 
            "{DADADA}Nombre {ED2B2B}inválido", 
            "{DADADA}Tu cuenta no puede ser registrada con un nombre inválido. Para entrar al servidor, tu nombre debe seguir el siguiente patrón:\n\n\t\"Nombre_Apellido\"",
            "Entendido", ""
        );
        DelayedKick(playerid);
        return ~1;
    }

    str_delete(tmp);

    EnablePlayerCameraTarget(playerid, true);

    for(new i = strlen(Player_GetName(playerid)) - 1; i != -1; --i)
    {
        if(g_rgePlayerData[playerid][e_szPlayerName][i] == '_')
        {
            g_rgePlayerData[playerid][e_szPlayerFixedName][i] = ' ';
        }
        else
        {
            g_rgePlayerData[playerid][e_szPlayerFixedName][i] = g_rgePlayerData[playerid][e_szPlayerName][i];
        }
    }
    
    /*
    // RPC_SetPlayerName
    SendRPC(-1, 11,
        BS_UNSIGNEDSHORT, playerid,
        BS_UNSIGNEDCHAR, strlen(Player_RPName(playerid)),
        BS_STRING, Player_RPName(playerid),
        BS_UNSIGNEDCHAR, 1
    );

    foreach(new i : Player)
    {
        SendRPC(playerid, 11,
            BS_UNSIGNEDSHORT, i,
            BS_UNSIGNEDCHAR, strlen(Player_RPName(i)),
            BS_STRING, Player_RPName(i),
            BS_UNSIGNEDCHAR, 1
        );
    }
    */

    SetPlayerNameInServerQuery(playerid, Player_RPName(playerid));

	Player_GetIp(playerid) = GetPlayerRawIp(playerid);

	Bit_Set(Player_Flags(playerid), PFLAG_AUTHENTICATING, true);
    
	mysql_format(g_hDatabase, YSI_UNSAFE_HUGE_STRING, YSI_UNSAFE_HUGE_LENGTH, "\
        SELECT `PLAYERS`.*, `PLAYER_WEAPONS`.*, `CONNECTION_LOGS`.`DATE` AS `LAST_CONNECTION` \
        FROM `PLAYERS`, `PLAYER_WEAPONS`, `CONNECTION_LOGS` \
        WHERE `PLAYERS`.`NAME` = '%e'  \
            AND `PLAYER_WEAPONS`.`ACCOUNT_ID` = `PLAYERS`.`ID` \
            AND `CONNECTION_LOGS`.`ACCOUNT_ID` = `PLAYERS`.`ID` \
        ORDER BY `CONNECTION_LOGS`.`DATE` DESC \
        LIMIT 1;\
    ", Player_GetName(playerid));
	mysql_tquery(g_hDatabase, YSI_UNSAFE_HUGE_STRING, !"OnPlayerDataFetched", !"i", playerid);

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
		g_rgePlayerData[playerid][e_iPlayerPausedTime] += (gettime() - g_rgePlayerData[playerid][e_iPlayerPausedBegin]);
		g_rgePlayerData[playerid][e_iPlayerPausedBegin] = 0;
	}

	return 1;
}

hook OnPlayerSpawn(playerid)
{
    TogglePlayerAllDynamicCPs(playerid, false);
    ApplyAnimation(playerid, "PED", "null", 4.1, false, false, false, false, 0, 0);
    ApplyAnimation(playerid, "SMOKING", "null", 4.1, false, false, false, false, 0, 0);
    ApplyAnimation(playerid, "CRIB", "null", 4.1, false, false, false, false, 0, 0);
    ApplyAnimation(playerid, "FOOD", "null", 4.1, false, false, false, false, 0, 0);
    ApplyAnimation(playerid, "BAR", "null", 4.1, false, false, false, false, 0, 0);
    return 1;
}