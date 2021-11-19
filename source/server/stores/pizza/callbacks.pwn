#if defined _STORES_PIZZA_CALLBACKS_
    #endinput
#endif
#define _STORES_PIZZA_CALLBACKS_

#include <YSI_Coding\y_hooks>

static Pizza_OnBuy(shop_id, playerid, item_id)
{
    #pragma unused shop_id
    
    switch(item_id)
    {
        case 0: // Pizza grande con pepperoni 
        {
            SendClientMessage(playerid, -1, "grasias por comprar pizza grande con peperoni mmg");
        }
    }

    return 1;
}

hook OnGameModeInit()
{
    // Actors
    CreateDynamicActor(155, 373.7393, -117.2236, 1001.4995, 175.4680, .interiorid = 5);

    // EnExs
    EnterExit_Create(19902, "{ED2B2B}Ugi's Pizza\n{DADADA}Presiona {ED2B2B}H {DADADA}para entrar", "{DADADA}Presiona {ED2B2B}H {DADADA}para salir", 2105.0681, -1806.4565, 13.5547, 91.9755, 0, 0, 372.4150, -133.3214, 1001.4922, 355.1316, 1, 5, -1, 0);
    
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