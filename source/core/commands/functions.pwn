#if defined _CORE_COMMANDS_FUNCTIONS_
    #endinput
#endif
#define _CORE_COMMANDS_FUNCTIONS_

Commands_GetFreeIndex()
{
    for(new i; i < HOOD_MAX_COMMANDS; ++i)
    {
        if(!g_rgeCommandStore[i][e_iCommandNameHash])
        {
            return i;
        }
    }
    
    // Assume no free index found

    new hdr[AMX_HDR], name[32], est_new;
    GetAmxHeader(hdr);

    for(new i = GetNumPublics(hdr); i != -1; --i)
    {
        if(!GetPublicNameFromIndex(i, name))
            continue;

        if(!strcmp("mz@cmd_", name, true, 7))
            est_new++;
    }

    printf("[Commands] Store out of space. Increase HOOD_MAX_COMMANDS to %d.", est_new);

    // Crash the server deliberately.
    // The "exit" RCON command can still continue executing code until the current callback execution stops.
    #emit jump cellmax
    
    return -1;
}

Commands_GetByName(const command[])
{
    new cmd_hash = YHash(command, .sensitive = false);

    for(new i; i < HOOD_MAX_COMMANDS; ++i)
    {
        if(g_rgeCommandStore[i][e_iCommandNameHash] == cmd_hash)
        {
            return i;
        }
    }

    return -1;
}

bool:Commands_GetDescription(const command[], destination[], length = sizeof(destination))
{
	new i = Commands_GetByName(command);
	if(i == -1)
		return false;

	StrCpy(destination, g_rgeCommandStore[i][e_szCommandDescription], length);

	return true;
}

Commands_ShowSuggestions(playerid, const command[])
{
    print("Commands_ShowSuggestions");

    new CmdArray:arr = PC_GetCommandArray();
    new cmd_size = PC_GetArraySize(arr);
    new distances[HOOD_MAX_COMMANDS][2];

    new cmd_name[16], distances_length;
    for(new i; i < cmd_size && distances_length < 20; ++i)
    {
        PC_GetCommandName(arr, i, cmd_name);
        
        if(Commands_GetByName(cmd_name) == -1)
            continue;

        new cmd_flags = PC_GetFlags(cmd_name);
        if(cmd_flags & CMD_HIDDEN)
            continue;

        new cmd_admin_level = (cmd_flags >>> 16);
        if(cmd_admin_level > Player_Rank(playerid))
            continue;

        new distance = levenshtein(command, cmd_name);
        if(distance >= 6)
            continue;
        
        distances[distances_length][0] = i;
        distances[distances_length][1] = distance;
        distances_length++;
    }

    if(!distances_length)
    {
        SendClientMessagef(playerid, 0xDADADAFF, "({ED2B2B}/%s{DADADA}) Comando desconocido, usa {ED2B2B}/ayuda{DADADA} para recibir ayuda.", command);
        return 1;
    }

    SortDeepArray(distances, 1, .order = SORT_DESC);

    new dialog_str[128 * 20] = "{DADADA}Sugerencias:\t \n";
    new line[128], cmd_description[50] = !"Sin descripción";
    for(new i; i < distances_length; ++i)
    {
        PC_GetCommandName(arr, distances[i][0], cmd_name);
        new cmd_flags = PC_GetFlags(cmd_name);
        
        Commands_GetDescription(cmd_name, cmd_description);

        format(line, sizeof(line), "{ED2B2B}› %s{DADADA}/%s\t%s\n", ((cmd_flags >>> 16) > RANK_LEVEL_USER ? !"{C22323}(ADMIN) " : !""), cmd_name, cmd_description);
        strcat(dialog_str, line);
    }

    PC_FreeArray(arr);

    inline const Response(response, listitem, string:inputtext[])
    {
        #pragma unused inputtext
        
        if(!response)
            return 0;

        new CmdArray:cmd_arr = PC_GetCommandArray();
        new name[16];
        PC_GetCommandName(cmd_arr, distances[listitem][0], name);
        PC_FreeArray(cmd_arr);
        PC_EmulateCommand(playerid, va_return("/%s", name));
    }
    Dialog_ShowCallback(playerid, using inline Response, DIALOG_STYLE_TABLIST_HEADERS, va_return("{DADADA}Comando {ED2B2B}/%s{DADADA} desconocido", command), dialog_str, !"Ejecutar", !"Cerrar");

    return 1;
}