#if defined _ENTER_EXITS_CALLBACKS_
    #endinput
#endif
#define _ENTER_EXITS_CALLBACKS_

#include <YSI_Coding\y_hooks>

hook OnPlayerEnterDynArea(playerid, areaid)
{
    g_rgiPlayerCurrentArea[playerid] = areaid;
    return 1;
}

hook OnPlayerLeaveDynArea(playerid, areaid)
{
    g_rgiPlayerCurrentArea[playerid] = -1;
    return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if((newkeys & KEY_CTRL_BACK) != 0)
    {
        if(g_rgiPlayerCurrentArea[playerid] != -1)
        {
            new info[3];
            Streamer_GetArrayData(STREAMER_TYPE_AREA, g_rgiPlayerCurrentArea[playerid], E_STREAMER_EXTRA_ID, info);
            if(info[0] == 0x4545)
            {
                new id = info[1];
                if(g_rgeEnterExits[id][e_iEnterExitCallback] != 0)
                {
                    new ret, data = g_rgeEnterExits[id][e_iEnterExitData], addr = g_rgeEnterExits[id][e_iEnterExitCallback], enter = info[2];
                    __emit {
                        push.s data
                        push.s enter
                        push.s playerid
                        push.c 12
                        lctrl 6
                        add.c 0x24
                        lctrl 8
                        push.pri
                        load.s.pri addr
                        sctrl 6
                        stor.s.pri ret
                    }

                    if(!ret)
                        return 1;
                }

                if(info[2])
                {
                    SetPlayerPos(playerid, g_rgeEnterExits[id][e_fExitX], g_rgeEnterExits[id][e_fExitY], g_rgeEnterExits[id][e_fExitZ]);
                    SetPlayerFacingAngle(playerid, g_rgeEnterExits[id][e_fExitAngle]);
                    SetPlayerInterior(playerid, g_rgeEnterExits[id][e_iExitInterior]);
                    SetPlayerVirtualWorld(playerid, g_rgeEnterExits[id][e_iExitWorld]);
                    Streamer_Update(playerid);
                }
                else
                {
                    Streamer_UpdateEx(playerid, g_rgeEnterExits[id][e_fEnterX], g_rgeEnterExits[id][e_fEnterY], g_rgeEnterExits[id][e_fEnterZ], g_rgeEnterExits[id][e_iEnterWorld], g_rgeEnterExits[id][e_iEnterInterior]);
                    SetPlayerPos(playerid, g_rgeEnterExits[id][e_fEnterX], g_rgeEnterExits[id][e_fEnterY], g_rgeEnterExits[id][e_fEnterZ]);
                    SetPlayerFacingAngle(playerid, g_rgeEnterExits[id][e_fEnterAngle]);
                    SetPlayerInterior(playerid, g_rgeEnterExits[id][e_iEnterInterior]);
                    SetPlayerVirtualWorld(playerid, g_rgeEnterExits[id][e_iEnterWorld]);
                    Streamer_Update(playerid);
                }
            }
        }
    }

    return 1;
}