#if defined _STORES_PIZZA_CALLBACKS_
    #endinput
#endif
#define _STORES_PIZZA_CALLBACKS_

#include <YSI_Coding\y_hooks>

static Pizza_OnBuy(shop_id, playerid, item_id)
{
    #pragma unused shop_id

    if(g_rgePlayerData[playerid][e_iPlayerPukeTick] < GetTickCount())
    {
        g_rgePlayerData[playerid][e_iPlayerPukeTick] = 0;
    }
    
    if(g_rgePlayerData[playerid][e_iPlayerPukeTick] != 0)
        return 0;

    switch(item_id)
    {
        case 0: // Porción de pizza pepperoni
        {
            SendClientMessagef(playerid, 0xDADADAFF, "Compraste una {ED2B2B}%s{DADADA}.", g_rgeShopItems[shop_id][item_id][e_szItemName]);
            Player_SetHunger(playerid, Player_Hunger(playerid) - 10.0);
            Player_SetThirst(playerid, Player_Thirst(playerid) - 1.0);
        }
    }

    Needs_UpdateTextDraws(playerid, true);

    ++g_rgePlayerData[playerid][e_iPlayerEatCount];

    if(g_rgePlayerData[playerid][e_iPlayerEatCount] >= 5)
    {
        Food_Puke(playerid);
        return 0;
    }

    return 1;
}

hook OnGameModeInit()
{
    // Actors
    CreateDynamicActor(155, 373.7393, -117.2236, 1002.4995, 175.4680, .worldid = 0, .interiorid = 5);

    // EnExs
    EnterExit_Create(19902, "{ED2B2B}Ugi's Pizza\n{DADADA}Presiona {ED2B2B}H {DADADA}para entrar", "{DADADA}Presiona {ED2B2B}H {DADADA}para salir", 2105.0681, -1806.4565, 13.5547, 91.9755, 0, 0, 372.4150, -133.3214, 1001.4922, 355.1316, 1, 5, -1, 0);

    // MapIcons
    CreateDynamicMapIcon(2105.0681, -1806.4565, 13.5547, 29, -1, .worldid = 0, .interiorid = 0);
    
    // Shops
    new ugis = Shop_Create("Ugi's Pizza", 373.7325, -119.4309, 1001.4922, -1, 5, 372.986755, -118.988250, 1002.399780, 375.441986, -115.871269, 999.357360, __addressof(Pizza_OnBuy));
    Shop_AddItem(ugis, "Porción de pizza pepperoni", 2218, 25, -25.29, 23.39, 74.69); // Pizza tray
    Shop_AddItem(ugis, "Pizza con papas fritas", 2220, 35, -25.29, 23.39, 74.69); // Pizza with extras
    Shop_AddItem(ugis, "Ensalada con pollo", 2355, 40, -25.29, 23.39, 74.69); // Chicken Salad
    Shop_AddItem(ugis, "Porción de pizza con ensalada", 2219, 50, -25.29, 23.39, 74.69); // Pizza and salad
    Shop_AddItem(ugis, "Pizza grande", 19580, 100, -25.29, 23.39, 74.69); // Large pizza
    Shop_SetObjectPositions(ugis,
        373.21, -118.10, 1001.58, // Start
        373.97, -118.07, 1001.58, // Idle
        375.06, -118.06, 1001.58  // End
    );

    return 1;
}