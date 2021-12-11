#if defined _STORES_CALLBACKS_
    #endinput
#endif
#define _STORES_CALLBACKS_

#include <YSI_Coding\y_hooks>

hook OnPlayerDisconnect(playerid, reason)
{
    g_rgiPlayerShopArea[playerid] = -1;
    g_rgiPlayerCurrentItem[playerid] = 0;

    if(IsValidPlayerObject(playerid, g_rgiPlayerShopObject[playerid]))
    {
        DestroyPlayerObject(playerid, g_rgiPlayerShopObject[playerid]);
    }

    g_rgiPlayerShopObject[playerid] = INVALID_OBJECT_ID;

    return 1;
}

hook OnPlayerEnterDynArea(playerid, areaid)
{
    g_rgiPlayerShopArea[playerid] = areaid;
    return 1;
}

hook OnPlayerLeaveDynArea(playerid, areaid)
{
    g_rgiPlayerShopArea[playerid] = -1;
    return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if((newkeys & KEY_YES) != 0)
    {
        if(!Bit_Get(Player_Flags(playerid), PFLAG_IS_PUKING))
        {
            if(g_rgiPlayerShopArea[playerid] != -1)
            {
                new info[2];
                Streamer_GetArrayData(STREAMER_TYPE_AREA, g_rgiPlayerShopArea[playerid], E_STREAMER_EXTRA_ID, info);

                if(info[0] != 0x73686F70)
                    return 1;
                
                new shop_id = info[1];

                Bit_Set(Player_Flags(playerid), PFLAG_USING_SHOP, true);
                Bit_Set(Player_Flags(playerid), PFLAG_CAN_USE_SHOP_BUTTONS, true);
                TogglePlayerControllable(playerid, false);
                
                for(new i = (sizeof(g_tdShops) - 1); i != -1; --i)
                {
                    TextDrawShowForPlayer(playerid, g_tdShops[i]);
                }

                TextDrawSetStringForPlayer(g_tdShops[5], playerid, Str_FixEncoding(g_rgeShops[shop_id][e_szShopName]));
                TextDrawSetStringForPlayer(g_tdShops[10], playerid, "$%d", g_rgeShopItems[shop_id][0][e_iItemPrice]);
                TextDrawSetStringForPlayer(g_tdShops[11], playerid, Str_FixEncoding(g_rgeShopItems[shop_id][0][e_szItemName]));
                
                new Float:cam_x, Float:cam_y, Float:cam_z, Float:cvec_x, Float:cvec_y, Float:cvec_z;
                GetPlayerCameraPos(playerid, cam_x, cam_y, cam_z);
                GetPlayerCameraFrontVector(playerid, cvec_x, cvec_y, cvec_z);
                InterpolateCameraPos(playerid, cam_x, cam_y, cam_z, g_rgeShops[shop_id][e_fShopCamX], g_rgeShops[shop_id][e_fShopCamY], g_rgeShops[shop_id][e_fShopCamZ], 1000);
                InterpolateCameraLookAt(playerid, cvec_x, cvec_y, cvec_z, g_rgeShops[shop_id][e_fShopCamLookX], g_rgeShops[shop_id][e_fShopCamLookY], g_rgeShops[shop_id][e_fShopCamLookZ], 1000);
            
                SelectTextDraw(playerid, 0xD2B567FF);

                PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
                g_rgiPlayerCurrentItem[playerid] = 0;
                g_rgiPlayerShopObject[playerid] = CreatePlayerObject(playerid, g_rgeShopItems[shop_id][0][e_iItemModel], g_rgeShops[shop_id][e_fShopObjectStartX], g_rgeShops[shop_id][e_fShopObjectStartY], g_rgeShops[shop_id][e_fShopObjectStartZ], g_rgeShopItems[shop_id][0][e_fRotationX], g_rgeShopItems[shop_id][0][e_fRotationY], g_rgeShopItems[shop_id][0][e_fRotationZ]);
                MovePlayerObject(playerid, g_rgiPlayerShopObject[playerid], g_rgeShops[shop_id][e_fShopObjectIdleX], g_rgeShops[shop_id][e_fShopObjectIdleY], g_rgeShops[shop_id][e_fShopObjectIdleZ], 1.2);
            }
        }
    }

    return 1;
}

hook OnPlayerPressEsc(playerid)
{
    if(Bit_Get(Player_Flags(playerid), PFLAG_USING_SHOP))
    {
        Player_StopShopping(playerid);
    }

    return 1;
}

hook OnPlayerClickTextDraw(playerid, Text:clickedid)
{
    if(!Bit_Get(Player_Flags(playerid), PFLAG_USING_SHOP))
        return 1;

    new info[2];
    Streamer_GetArrayData(STREAMER_TYPE_AREA, g_rgiPlayerShopArea[playerid], E_STREAMER_EXTRA_ID, info);
    new shop_id = info[1];

    if(Bit_Get(Player_Flags(playerid), PFLAG_CAN_USE_SHOP_BUTTONS))
    {
        // Left button
        if(clickedid == g_tdShops[7])
        {   
            if(g_rgiPlayerCurrentItem[playerid] <= 0)
                return ~1;

            Bit_Set(Player_Flags(playerid), PFLAG_CAN_USE_SHOP_BUTTONS, false);

            --g_rgiPlayerCurrentItem[playerid];

            inline const MovingDone()
            {
                Bit_Set(Player_Flags(playerid), PFLAG_CAN_USE_SHOP_BUTTONS, true);
                
                PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
                DestroyPlayerObject(playerid, g_rgiPlayerShopObject[playerid]);
                g_rgiPlayerShopObject[playerid] = CreatePlayerObject(playerid, g_rgeShopItems[shop_id][g_rgiPlayerCurrentItem[playerid]][e_iItemModel], g_rgeShops[shop_id][e_fShopObjectStartX], g_rgeShops[shop_id][e_fShopObjectStartY], g_rgeShops[shop_id][e_fShopObjectStartZ], g_rgeShopItems[shop_id][g_rgiPlayerCurrentItem[playerid]][e_fRotationX], g_rgeShopItems[shop_id][g_rgiPlayerCurrentItem[playerid]][e_fRotationY], g_rgeShopItems[shop_id][g_rgiPlayerCurrentItem[playerid]][e_fRotationZ]);
                MovePlayerObject(playerid, g_rgiPlayerShopObject[playerid], g_rgeShops[shop_id][e_fShopObjectIdleX], g_rgeShops[shop_id][e_fShopObjectIdleY], g_rgeShops[shop_id][e_fShopObjectIdleZ], 1.2);

                TextDrawSetStringForPlayer(g_tdShops[10], playerid, "$%d", g_rgeShopItems[shop_id][g_rgiPlayerCurrentItem[playerid]][e_iItemPrice]);
                TextDrawSetStringForPlayer(g_tdShops[11], playerid, Str_FixEncoding(g_rgeShopItems[shop_id][g_rgiPlayerCurrentItem[playerid]][e_szItemName]));
            }
            cb_MovePlayerObject(using inline MovingDone, playerid, g_rgiPlayerShopObject[playerid], g_rgeShops[shop_id][e_fShopObjectEndX], g_rgeShops[shop_id][e_fShopObjectEndY], g_rgeShops[shop_id][e_fShopObjectEndZ], 1.2);

            return ~1;
        }
        // Right button
        else if(clickedid == g_tdShops[8])
        {
            if(g_rgiPlayerCurrentItem[playerid] + 1 >= g_rgeShops[shop_id][e_iShopItemAmount])
                return ~1;

            Bit_Set(Player_Flags(playerid), PFLAG_CAN_USE_SHOP_BUTTONS, false);

            ++g_rgiPlayerCurrentItem[playerid];

            inline const MovingDone()
            {                
                Bit_Set(Player_Flags(playerid), PFLAG_CAN_USE_SHOP_BUTTONS, true);

                PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);                
                DestroyPlayerObject(playerid, g_rgiPlayerShopObject[playerid]);
                g_rgiPlayerShopObject[playerid] = CreatePlayerObject(playerid, g_rgeShopItems[shop_id][g_rgiPlayerCurrentItem[playerid]][e_iItemModel], g_rgeShops[shop_id][e_fShopObjectStartX], g_rgeShops[shop_id][e_fShopObjectStartY], g_rgeShops[shop_id][e_fShopObjectStartZ], g_rgeShopItems[shop_id][g_rgiPlayerCurrentItem[playerid]][e_fRotationX], g_rgeShopItems[shop_id][g_rgiPlayerCurrentItem[playerid]][e_fRotationY], g_rgeShopItems[shop_id][g_rgiPlayerCurrentItem[playerid]][e_fRotationZ]);
                MovePlayerObject(playerid, g_rgiPlayerShopObject[playerid], g_rgeShops[shop_id][e_fShopObjectIdleX], g_rgeShops[shop_id][e_fShopObjectIdleY], g_rgeShops[shop_id][e_fShopObjectIdleZ], 1.2);

                TextDrawSetStringForPlayer(g_tdShops[10], playerid, "$%d", g_rgeShopItems[shop_id][g_rgiPlayerCurrentItem[playerid]][e_iItemPrice]);
                TextDrawSetStringForPlayer(g_tdShops[11], playerid, Str_FixEncoding(g_rgeShopItems[shop_id][g_rgiPlayerCurrentItem[playerid]][e_szItemName]));
            }
            cb_MovePlayerObject(using inline MovingDone, playerid, g_rgiPlayerShopObject[playerid], g_rgeShops[shop_id][e_fShopObjectEndX], g_rgeShops[shop_id][e_fShopObjectEndY], g_rgeShops[shop_id][e_fShopObjectEndZ], 1.2);

            return ~1;
        }
    }

    if(clickedid == g_tdShops[9])
    {
        if(g_rgeShops[shop_id][e_iShopCallback] <= 0)
            return ~1;

        new 
            item_id = g_rgiPlayerCurrentItem[playerid],
            addr = g_rgeShops[shop_id][e_iShopCallback],
            ret = 1;

        __emit {
            push.s item_id
            push.s playerid
            push.s shop_id
            push.c 12
            lctrl 6
            add.c 0x24
            lctrl 8
            push.pri
            load.s.pri addr
            sctrl 6
            stor.s.pri ret
        }

        if(ret)
        {
            Player_GiveMoney(playerid, -g_rgeShopItems[shop_id][g_rgiPlayerCurrentItem[playerid]][e_iItemPrice], true);
        }
        
        PlayerPlaySound(playerid, (ret ? 1054 : 1055), 0.0, 0.0, 0.0);
    }

    return 1;
}