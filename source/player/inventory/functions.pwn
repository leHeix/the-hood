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