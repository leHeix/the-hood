#if defined _CORE_COMMANDS_CALLBACKS_
    #endinput
#endif
#define _CORE_COMMANDS_CALLBACKS_

#include <YSI_Coding\y_hooks>

hook OnScriptInit()
{
    new hdr[AMX_HDR];
    GetAmxHeader(hdr);

    new pubname[32];
    for(new i = GetNumPublics(hdr); i != -1; --i)
    {
        if(!GetPublicNameFromIndex(i, pubname))
            continue;

        if(strfind("mz@cmd_", pubname) == 0)
        {
            new addr = GetPublicAddressFromIndex(i);
            __emit {
                push.c 0
                lctrl 6
                add.c 0x24
                lctrl 8
                push.pri
                load.s.pri addr
                sctrl 6
            }
        }
    }

    return 1;
}

hook OnPlayerCommandReceived(playerid, cmd[], params[], flags)
{
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

	if(!(flags & CMD_NO_COOLDOWN) && g_rgiPlayerCommandCooldown[playerid] + 500 > GetTickCount())
	{
		SendClientMessage(playerid, 0xDADADAFF, "Solo puedes enviar {ED2B2B}dos comando por segundo{DADADA}. Algunos comandos no disponen de tiempo de espera.");
		return 0;
	}

	g_rgiPlayerCommandCooldown[playerid] = GetTickCount();

	return 1;
}

hook OnPlayerCmdPerformed(playerid, cmd[], params[], result, flags)
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