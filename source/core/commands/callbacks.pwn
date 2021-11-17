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