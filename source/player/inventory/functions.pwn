#if defined _INVENTORY_FUNCTIONS_
    #endinput
#endif
#define _INVENTORY_FUNCTIONS_

static Inventory_FindFreeIndexOrItem(playerid, eInventoryItems:item)
{
    new free_idx = -1;

    for(new i; i < PLAYER_MAX_INVENTORY_ITEMS; ++i)
    {
        if(g_rgePlayerInventory[playerid][i][e_iItemId] == item)
        {
           return i;
        }
        else if(g_rgePlayerInventory[playerid][i][e_iItemId] == ITEM_NONE)
        {
            free_idx = i;
        }
    }

    return free_idx;
}

Inventory_AddItem(playerid, eInventoryItems:item, amount = 1)
{
    new item_idx = Inventory_FindFreeIndexOrItem(playerid, item);
    if(item_idx == -1)
        return -1;

    g_rgePlayerInventory[playerid][item_idx][e_iItemId] = item;
    g_rgePlayerInventory[playerid][item_idx][e_iItemAmount] += amount;
    if(!g_rgePlayerInventory[playerid][item_idx][e_iItemDbId])
    {
        print("adding item");
        
        inline const Result()
        {
            printf("registered: %d", cache_insert_id());
            g_rgePlayerInventory[playerid][item_idx][e_iItemDbId] = cache_insert_id();
        }
        MySQL_TQueryInline(g_hDatabase, using inline Result, "\
            INSERT INTO `PLAYER_INVENTORY` \
                (`OWNER_ID`, `ITEM_ID`, `AMOUNT`) \
            VALUES \
                (%d, %d, %d);\
        ", 
            Player_AccountID(playerid), item, g_rgePlayerInventory[playerid][item_idx][e_iItemAmount]
        );
    }
    else
    {
        print("updating item");
        mysql_format(g_hDatabase, YSI_UNSAFE_HUGE_STRING, YSI_UNSAFE_HUGE_LENGTH, "UPDATE `PLAYER_INVENTORY` SET `AMOUNT` = %d WHERE `ID` = %d;", g_rgePlayerInventory[playerid][item_idx][e_iItemAmount], g_rgePlayerInventory[playerid][item_idx][e_iItemDbId]);
        mysql_tquery(g_hDatabase, YSI_UNSAFE_HUGE_STRING);
    }

    return item_idx;
}

Inventory_Has(playerid, eInventoryItems:item)
{
    for(new i; i < PLAYER_MAX_INVENTORY_ITEMS; ++i)
    {
        if(g_rgePlayerInventory[playerid][i][e_iItemId] == item)
        {
           return g_rgePlayerInventory[playerid][i][e_iItemAmount];
        }
    }

    return 0;
}