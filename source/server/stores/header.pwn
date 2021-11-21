#if defined _H_STORES_
    #endinput
#endif
#define _H_STORES_

const HOOD_MAX_SHOPS = 25;
const HOOD_MAX_SHOP_ITEMS = 10;

enum eShop {
    bool:e_bShopValid,
    e_iShopItemAmount,
    Text3D:e_iShopLabel,
    e_iShopArea,

    e_szShopName[24],
    Float:e_fShopX,
    Float:e_fShopY,
    Float:e_fShopZ,
    e_iShopWorld,
    e_iShopInterior,

    Float:e_fShopCamX,
    Float:e_fShopCamY,
    Float:e_fShopCamZ,
    Float:e_fShopCamLookX,
    Float:e_fShopCamLookY,
    Float:e_fShopCamLookZ,

    // object
    Float:e_fShopObjectStartX,
    Float:e_fShopObjectStartY,
    Float:e_fShopObjectStartZ,
    Float:e_fShopObjectIdleX,
    Float:e_fShopObjectIdleY,
    Float:e_fShopObjectIdleZ,
    Float:e_fShopObjectEndX,
    Float:e_fShopObjectEndY,
    Float:e_fShopObjectEndZ,

    e_iShopCallback,
    bool:e_bIsInline
};

new g_rgeShops[HOOD_MAX_SHOPS][eShop];

enum eShopItem {
    e_szItemName[48],
    e_iItemModel,
    e_iItemPrice,
    Float:e_fRotationX,
    Float:e_fRotationY,
    Float:e_fRotationZ
};

new g_rgeShopItems[HOOD_MAX_SHOPS][HOOD_MAX_SHOP_ITEMS][eShopItem];

new 
    g_rgiPlayerShopArea[MAX_PLAYERS] = { -1, ... },
    g_rgiPlayerCurrentItem[MAX_PLAYERS],
    g_rgiPlayerShopObject[MAX_PLAYERS] = { INVALID_OBJECT_ID, ... };

forward Shop_Create(const name[], Float:x, Float:y, Float:z, world, int, Float:cam_x, Float:cam_y, Float:cam_z, Float:cam_look_x, Float:cam_look_y, Float:cam_look_z, buy_callback);
forward Shop_SetObjectPositions(shop_id, Float:start_x, Float:start_y, Float:start_z, Float:idle_x, Float:idle_y, Float:idle_z, Float:end_x, Float:end_y, Float:end_z);
forward Shop_SetInlineCallback(shop_id, Func:cb<iii>);
forward Shop_AddItem(shop_id, const name[], model, price, Float:rx, Float:ry, Float:rz);
forward Player_StopShopping(playerid);
forward Food_Puke(playerid);
