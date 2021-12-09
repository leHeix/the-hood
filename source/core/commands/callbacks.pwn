#if defined _CORE_COMMANDS_CALLBACKS_
    #endinput
#endif
#define _CORE_COMMANDS_CALLBACKS_

#include <YSI_Coding\y_hooks>

hook OnScriptInit()
{
    new idx, ptr;
    while ((idx = AMX_GetPublicPointerPrefix(idx, ptr, _A<mz@cmd_>)))
    {
        __emit 
        {
            push.c 0
            lctrl 6
            add.c 36
            lctrl 8
            push.pri
            load.s.pri ptr
            sctrl 6
        }
    }

    return 1;
}

public OnPlayerCommandReceived(playerid, cmd[], params[], flags)
{
#if defined DEBUG_MODE
    printf("OnPlayerCommandReceived(%d, \"%s\", \"%s\", %b)", playerid, cmd, params, flags);
#endif

	/*
		quick explanation:
		our flag thing uses 3 bytes for the flags and 1 byte for the level (4 bytes, a cell)

		cell representation:
			00000000 00000000 00000000 00000000
			-------- --------------------------
		      level           flags
	*/

	new cmd_level = (flags >>> 24);

	if(cmd_level != Player_Rank(playerid))
		return 0;

	if(!(flags & CMD_NO_COOLDOWN) && (g_rgiPlayerCommandCooldown[playerid] && GetTickDiff(GetTickCount(), g_rgiPlayerCommandCooldown[playerid]) < 500))
	{
        printf("%d", GetTickDiff(GetTickCount(), g_rgiPlayerCommandCooldown[playerid]));
        printf("%d %d", GetTickCount(), g_rgiPlayerCommandCooldown[playerid]);
		SendClientMessage(playerid, 0xDADADAFF, "Solo puedes enviar {ED2B2B}dos comando por segundo{DADADA}. Algunos comandos no disponen de tiempo de espera.");
		return 0;
	}

	g_rgiPlayerCommandCooldown[playerid] = GetTickCount();

	return 1;
}

public OnPlayerCommandPerformed(playerid, cmd[], params[], result, flags)
{
#if defined DEBUG_MODE
    printf("OnPlayerCommandPerformed(%d, \"%s\", \"%s\", %d, %b)", playerid, cmd, params, result, flags);
#endif

	if(result == -1)
	{
		Commands_ShowSuggestions(playerid, cmd);
		return 0;
	}

	return 1;
}