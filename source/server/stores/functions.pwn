#if defined _STORES_FUNCTIONS_
    #endinput
#endif
#define _STORES_FUNCTIONS_

static Shop_FindFreeIndex()
{
    for(new i; i < HOOD_MAX_SHOPS; ++i)
    {
        if(!g_rgeShops[i][e_bShopValid])
            return i;
    }

    return -1;
}

static ShopItem_FindFreeIndex(shop_id)
{
    for(new i; i < HOOD_MAX_SHOP_ITEMS; ++i)
    {
        if(!g_rgeShopItems[shop_id][i][e_iItemModel])
            return i;
    }

    return -1;
}

Shop_Create(const name[], Float:x, Float:y, Float:z, world, int, Float:cam_x, Float:cam_y, Float:cam_z, Float:cam_look_x, Float:cam_look_y, Float:cam_look_z, buy_callback)
{
    new i = Shop_FindFreeIndex();
    if(i == -1)
    {
        print("[Shop] Failed to create shop (pool out of space)");
        return -1;
    }

    g_rgeShops[i][e_bShopValid] = true;

    strcpy(g_rgeShops[i][e_szShopName], name);
    g_rgeShops[i][e_iShopLabel] = CreateDynamic3DTextLabel(va_return("{ED2B2B}%s\n{DADADA}Presiona {ED2B2B}Y {DADADA}para ver el inventario", name), 0xED2B2BFF, x, y, z, 10.0, .testlos = 1, .worldid = world, .interiorid = int);
    g_rgeShops[i][e_iShopArea] = CreateDynamicCircle(x, y, 0.5, .worldid = world, .interiorid = int);
    Streamer_SetIntData(STREAMER_TYPE_AREA, g_rgeShops[i][e_iShopArea], E_STREAMER_EXTRA_ID, i);

    g_rgeShops[i][e_fShopX] = x;
    g_rgeShops[i][e_fShopY] = y;
    g_rgeShops[i][e_fShopZ] = z;
    g_rgeShops[i][e_iShopWorld] = world;
    g_rgeShops[i][e_iShopInterior] = int;

    g_rgeShops[i][e_fShopCamX] = cam_x;
    g_rgeShops[i][e_fShopCamY] = cam_y;
    g_rgeShops[i][e_fShopCamZ] = cam_z;
    g_rgeShops[i][e_fShopCamLookX] = cam_look_x;
    g_rgeShops[i][e_fShopCamLookY] = cam_look_y;
    g_rgeShops[i][e_fShopCamLookZ] = cam_look_z;

    g_rgeShops[i][e_iShopCallback] = buy_callback;

    return i;
}

Shop_AddItem(shop_id, const name[], model, price, Float:rx, Float:ry, Float:rz)
{
    if(!g_rgeShops[shop_id][e_bShopValid])
        return 0;

    new item_id = ShopItem_FindFreeIndex(shop_id);
    if(item_id == -1)
    {
        printf("[Shop] Failed to create item for shop %d (pool out of space)", shop_id);
        return -1;
    }

    strcpy(g_rgeShopItems[shop_id][item_id][e_szItemName], name);
    g_rgeShopItems[shop_id][item_id][e_iItemModel] = model;
    g_rgeShopItems[shop_id][item_id][e_iItemPrice] = price;
    g_rgeShopItems[shop_id][item_id][e_fRotationX] = rx;
    g_rgeShopItems[shop_id][item_id][e_fRotationY] = ry;
    g_rgeShopItems[shop_id][item_id][e_fRotationZ] = rz;
    
    ++g_rgeShops[shop_id][e_iShopItemAmount];

    return item_id;
}

Shop_SetObjectPositions(shop_id, Float:start_x, Float:start_y, Float:start_z, Float:idle_x, Float:idle_y, Float:idle_z, Float:end_x, Float:end_y, Float:end_z)
{
    if(!g_rgeShops[shop_id][e_bShopValid])
        return 0;

    g_rgeShops[shop_id][e_fShopObjectStartX] = start_x;
    g_rgeShops[shop_id][e_fShopObjectStartY] = start_y;
    g_rgeShops[shop_id][e_fShopObjectStartZ] = start_z;
    g_rgeShops[shop_id][e_fShopObjectIdleX] = idle_x;
    g_rgeShops[shop_id][e_fShopObjectIdleY] = idle_y;
    g_rgeShops[shop_id][e_fShopObjectIdleZ] = idle_z;
    g_rgeShops[shop_id][e_fShopObjectEndX] = end_x;
    g_rgeShops[shop_id][e_fShopObjectEndY] = end_y;
    g_rgeShops[shop_id][e_fShopObjectEndZ] = end_z;

    return 1;
}