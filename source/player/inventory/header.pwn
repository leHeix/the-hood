#if defined _H_INVENTORY_
    #endinput
#endif
#define _H_INVENTORY_

#define PLAYER_MAX_INVENTORY_ITEMS 10

enum eInventoryItems
{
    ITEM_NONE,
    ITEM_CELLPHONE,
    ITEM_GPS,
    ITEM_WALKIE_TALKIE
};

enum eInventoryItemData
{
    e_szName[24],
    e_iModelId
};

new const g_rgeInventoryItemData[_:eInventoryItems][eInventoryItemData] = {
    { "Ninguno", 0 },
    { "Teléfono celular", 19513 },
    { "GPS", 18875 },
    { "Walkie-Talkie", 330 }
};

enum ePlayerInventory
{
    e_iItemDbId,
    eInventoryItems:e_iItemId,
    e_iItemAmount
};

new g_rgePlayerInventory[MAX_PLAYERS + 1][PLAYER_MAX_INVENTORY_ITEMS][ePlayerInventory];

forward Inventory_AddItem(playerid, eInventoryItems:item, amount = 1);
forward Inventory_Has(playerid, eInventoryItems:item);