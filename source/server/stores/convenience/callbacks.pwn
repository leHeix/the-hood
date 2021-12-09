#if defined _STORES_CONVENIENCE_CALLBACKS_
    #endinput
#endif
#define _STORES_CONVENIENCE_CALLBACKS_

#include <YSI_Coding\y_hooks>

static ConvenienceStoreBuyCallback(shopid, playerid, itemid)
{
    #pragma unused shopid
    
    switch(itemid)
    {
        case 0: // Teléfono celular
        {
            if(Inventory_Has(playerid, ITEM_CELLPHONE))
            {
                Notification_ShowBeatingText(playerid, 5000, 0xED2B2B, 255, 100, "Ya tienes un teléfono celular");
                return 0;
            }

            inline const NumberRegistered()
            {
                Inventory_AddItem(playerid, ITEM_CELLPHONE);
                Notification_Show(playerid, @f("Compraste un teléfono celular. Tu número de telefono es ~y~%d~w~.", Player_PhoneNumber(playerid)), 5000);
            }
            Cellphone_Register(playerid, using inline NumberRegistered);
        }
    }

    return 1;
}

hook OnGameModeInit()
{
    // EnExs
    EnterExit_Create(19902, "{ED2B2B}7-Eleven\n{DADADA}Presiona {ED2B2B}H {DADADA}para entrar", "{DADADA}Presiona {ED2B2B}H {DADADA}para salir", 2001.8507, -1761.6123, 13.5391, 359.4877, 0, 0, 6.0728,-31.3407, 1003.5494, 6.2127, 0, 10, -1, 0);

    // Actors
    CreateDynamicActor(229, 2.0491, -30.7007, 1004.5494, 358.3559, .worldid = 0, .interiorid = 10);

    // Shops
    new shopid = Shop_Create("7-Eleven", 2.1105, -29.0141, 1003.5494, 0, 10, 1.124887, -28.677103, 1004.111938, 4.151215, -32.320850, 1002.510559, __addressof(ConvenienceStoreBuyCallback));
    Shop_SetObjectPositions(shopid, 1.02, -29.88, 1003.47, 2.0, -29.88, 1003.47, -29.88, 1003.47, 2.0);
    Shop_AddItem(shopid, "Teléfono celular", 19513, 500, 0.0, 0.0, 0.0);
}