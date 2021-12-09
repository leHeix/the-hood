#if defined _H_INVENTORY_
    #endinput
#endif
#define _H_INVENTORY_

const PLAYER_MAX_INVENTORY_ITEMS = 10;

enum eInventoryItems
{
    ITEM_NONE,
    ITEM_CELLPHONE
};

enum eInventoryItemData
{
    e_szName[24],
    e_iModelId
};

new const g_rgeInventoryItemData[_:eInventoryItems][eInventoryItemData] = {
    { "Ninguno", 0 },
    { "Teléfono celular", 19513 }
};

enum ePlayerInventory
{
    eInventoryItems:e_iItemId,
    e_iItemAmount
};

new g_rgePlayerInventory[MAX_PLAYERS][PLAYER_MAX_INVENTORY_ITEMS][ePlayerInventory];

forward Inventory_AddItem(playerid, eInventoryItems:item, amount = 1);
forward Inventory_Has(playerid, eInventoryItems:item);