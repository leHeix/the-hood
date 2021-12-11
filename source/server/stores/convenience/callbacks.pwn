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
        case 1: // GPS
        {
            if(Inventory_Has(playerid, ITEM_GPS))
            {
                Notification_ShowBeatingText(playerid, 5000, 0xED2B2B, 255, 100, "Ya tienes un GPS");
                return 0;
            }

            Inventory_AddItem(playerid, ITEM_GPS);
            Notification_Show(playerid, @("Compraste un ~y~GPS~w~. Usalo con el comando ~y~/gps~w~."), 5000);
        }
        case 2: // Walkie-Talkie
        {
            if(Inventory_Has(playerid, ITEM_WALKIE_TALKIE))
            {
                Notification_ShowBeatingText(playerid, 5000, 0xED2B2B, 255, 100, "Ya tienes un Walkie-talkie");
                return 0;
            }

            Inventory_AddItem(playerid, ITEM_WALKIE_TALKIE);
            Notification_Show(playerid, @("Compraste un ~y~Walkie-Talkie~w~."), 5000);
        }
        case 3: // Vaso de cafe
        {
            if(Bit_Get(Player_Flags(playerid), PFLAG_HAS_DRINK_ON_HANDS))
            {
                Notification_ShowBeatingText(playerid, 3000, 0xED2B2B, 255, 100, "Ya estas bebiendo algo");
                return 0;
            }

            Bit_Set(Player_Flags(playerid), PFLAG_HAS_DRINK_ON_HANDS, true);
            SetPlayerAttachedObject(playerid, 0, 19835, 6, 0.05, 0.05, 0.06);
            Player_Data(playerid, e_fPlayerThirstPerDrink) = 5.0;
            Player_Data(playerid, e_iPlayerDrinkClickedRemaining) = 10;

            Notification_Show(playerid, @("Compraste un ~y~vaso de cafe~w~. Presiona ~y~~k~~GROUP_CONTROL_BWD~~w~ para beber."), 5000);
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

    // MapIcons
    CreateDynamicMapIcon(2001.8507, -1761.6123, 13.5391, 17, -1, .worldid = 0, .interiorid = 0);

    // Shops
    new shopid = Shop_Create("7-Eleven", 2.1105, -29.0141, 1003.5494, 0, 10, 1.124887, -28.677103, 1004.111938, 4.151215, -32.320850, 1002.510559, __addressof(ConvenienceStoreBuyCallback));
    Shop_SetObjectPositions(shopid, 1.02, -29.88, 1003.47, 2.0, -29.88, 1003.47, 1.02, -29.88, 1003.47);
    Shop_AddItem(shopid, "Teléfono celular", 19513, 500, 0.0, 0.0, 0.0);
    Shop_AddItem(shopid, "GPS", 18875, 250, 0.0, 0.0, 0.0);
    Shop_AddItem(shopid, "Walkie-Talkie", 330, 1500, 90.10, 3.59, -90.09);
    Shop_AddItem(shopid, "Vaso de cafe", 19835, 150, 0.0, 0.0, 0.0);

    return 1;
}