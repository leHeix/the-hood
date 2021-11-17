#if defined _CORE_COMMANDS_FUNCTIONS_
    #endinput
#endif
#define _CORE_COMMANDS_FUNCTIONS_

Commands_GetFreeIndex()
{
    for(new i; i < MZ_MAX_COMMANDS; ++i)
    {
        if(!g_rgeCommandStore[i][e_iCommandNameHash])
            return i;
    }
    
    return -1;
}