#if defined _INVENTORY_CALLBACKS_
    #endinput
#endif
#define _INVENTORY_CALLBACKS_

#include <YSI_Coding\y_hooks>

hook OnPlayerDisconnect(playerid, reason)
{
    g_rgePlayerInventory[playerid] = g_rgePlayerInventory[MAX_PLAYERS];
    return 1;
}

hook OnPlayerDataLoaded(playerid)
{
    if(!Player_AccountID(playerid))
        return 1;

    inline const Result()
    {
        new rows;
        cache_get_row_count(rows);

        for(new i; i < rows; ++i)
        {
            cache_get_value_name_int(i, "ID", g_rgePlayerInventory[playerid][i][e_iItemDbId]);
            cache_get_value_name_int(i, "ITEM_ID", _:g_rgePlayerInventory[playerid][i][e_iItemId]);
            cache_get_value_name_int(i, "AMOUNT", _:g_rgePlayerInventory[playerid][i][e_iItemAmount]);
        }
    }
    MySQL_TQueryInline(g_hDatabase, using inline Result, "SELECT * FROM `PLAYER_INVENTORY` WHERE `OWNER_ID` = %d LIMIT "#PLAYER_MAX_INVENTORY_ITEMS";", Player_AccountID(playerid));

    return 1;
}