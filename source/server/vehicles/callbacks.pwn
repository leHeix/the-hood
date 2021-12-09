#if defined _VEHICLES_CALLBACKS_
    #endinput
#endif
#define _VEHICLES_CALLBACKS_

#include <YSI_Coding\y_hooks>

hook OnGameModeInit()
{
    CreateDynamic3DTextLabel("{ED2B2B}Concesionaria Urbinas Motors\n{DADADA}Presiona {ED2B2B}Y {DADADA}para ver el inventario", -1, 2131.8589, -1150.8381, 24.1139, 10.0, .testlos = 1, .worldid = 0, .interiorid = 0);
    CreateDynamicPickup(19902, 1,2131.8589,-1150.8381,24.1139, .worldid = 0, .interiorid = 0);
    g_rgiAutoDealershipArea = CreateDynamicCircle(2131.8589, -1150.8381, 1.0, .worldid = 0, .interiorid = 0);

    return 1;
}

hook OnPlayerDataLoaded(playerid)
{
    if(!Player_AccountID(playerid))
        return 1;

    inline const Result()
    {
        new veh_count;
        cache_get_row_count(veh_count);
        if(!veh_count)
            return 0;

        new
            model, colorone, colortwo,
            Float:x, Float:y, Float:z, Float:angle,
            panels, doors, lights, tires,
            components[70],
            p;

        for(new i; i < veh_count; ++i)
        {
            cache_get_value_name_int(i, "MODEL", model);
            cache_get_value_name_int(i, "COLOR_ONE", colorone);
            cache_get_value_name_int(i, "COLOR_TWO", colortwo);
            cache_get_value_name_float(i, "POS_X", x);
            cache_get_value_name_float(i, "POS_Y", y);
            cache_get_value_name_float(i, "POS_Z", z);
            cache_get_value_name_float(i, "ANGLE", angle);

            new vehicleid = CreateVehicle(model, x, y, z, angle, colorone, colortwo, -1);
            Vehicle_GetData(vehicleid, e_iColorOne) = colorone;
            Vehicle_GetData(vehicleid, e_iColorTwo) = colortwo;
            Vehicle_GetData(vehicleid, e_fPosX) = x;
            Vehicle_GetData(vehicleid, e_fPosY) = y;
            Vehicle_GetData(vehicleid, e_fPosZ) = z;
            Vehicle_GetData(vehicleid, e_fPosAngle) = angle;

            cache_get_value_name_int(i, "VEHICLE_ID", Vehicle_GetData(vehicleid, e_iVehicleDbId));
            Vehicle_GetData(vehicleid, e_iVehicleOwnerId) = playerid; // shortcut

            cache_get_value_name_float(i, "HEALTH", Vehicle_GetData(vehicleid, e_fHealth));
            cache_get_value_name_float(i, "FUEL", Vehicle_GetData(vehicleid, e_fFuel));
            cache_get_value_name_int(i, "PANELS_STATUS", panels);
            cache_get_value_name_int(i, "DOORS_STATUS", doors);
            cache_get_value_name_int(i, "LIGHTS_STATUS", lights);
            cache_get_value_name_int(i, "TIRES_STATUS", tires);
            cache_get_value_name_int(i, "PAINTJOB", Vehicle_GetData(vehicleid, e_iPaintjob));
            cache_get_value_name_int(i, "INTERIOR", Vehicle_GetData(vehicleid, e_iVehInterior));
            cache_get_value_name_int(i, "VW", Vehicle_GetData(vehicleid, e_iVehWorld));
            cache_get_value_name(i, "COMPONENTS", components);
            cache_get_value_name_int(i, "PARAMS", p);

            // Set data
            SetVehicleHealth(vehicleid, Vehicle_GetData(vehicleid, e_fHealth));
            UpdateVehicleDamageStatus(vehicleid, panels, doors, lights, tires);
            ChangeVehiclePaintjob(vehicleid, Vehicle_GetData(vehicleid, e_iPaintjob));
            LinkVehicleToInterior(vehicleid, Vehicle_GetData(vehicleid, e_iVehInterior));
            SetVehicleVirtualWorld(vehicleid, Vehicle_GetData(vehicleid, e_iVehWorld));
            
            sscanf(components, "p<,>a<i>[14]", Vehicle_GetData(vehicleid, e_iComponents));
            for(new j; j < 14; ++j)
            {
                if(Vehicle_GetData(vehicleid, e_iComponents)[j] != 0)
                    AddVehicleComponent(vehicleid, Vehicle_GetData(vehicleid, e_iComponents)[j]);
            }

            #define bit_at(%0,%1) ((%0) & (1 << (%1)))

            SetVehicleParamsEx(vehicleid, bit_at(p, 0), bit_at(p, 1), bit_at(p, 2), bit_at(p, 3), bit_at(p, 4), bit_at(p, 5), bit_at(p, 6));

            // Engine is ON, start updating the vehicle
            if(bit_at(p, 0))
            {
                g_rgeVehicles[vehicleid][e_iVehicleTimers][VEHICLE_TIMER_UPDATE] = SetTimerEx("VEHICLE_Update", 1000, true, "i", vehicleid);
            }

            #undef bit_at

            Iter_Add(PlayerVehicles[playerid], vehicleid);
        }
    }
    MySQL_TQueryInline(g_hDatabase, using inline Result, "SELECT * FROM `PLAYER_VEHICLES` WHERE `OWNER_ID` = %d;", Player_AccountID(playerid));
    return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
    if(g_rgiSpeedometerUpdateTimer[playerid] != -1)
    {
        KillTimer(g_rgiSpeedometerUpdateTimer[playerid]);
        g_rgiSpeedometerUpdateTimer[playerid] = -1;
    }

    Player_SaveVehicles(playerid);
    
    return 1;
}

hook OnPlayerStateChange(playerid, newstate, oldstate)
{
    if(newstate == PLAYER_STATE_DRIVER)
    {
        Needs_ToggleBar(playerid, false);
        Speedometer_Show(playerid);

        if(Vehicle_GetEngineState(GetPlayerVehicleID(playerid)) == VEHICLE_STATE_OFF)
        {
            Notification_ShowBeatingText(playerid, 5000, 0xED2B2B, 255, 100, "Presiona ~k~~CONVERSATION_NO~ para encender el vehículo");
        }
    }
    else if(oldstate == PLAYER_STATE_DRIVER && g_rgiSpeedometerUpdateTimer[playerid] != -1)
    {
        Notification_HideBeatingText(playerid);
        Speedometer_Hide(playerid);
        Needs_ToggleBar(playerid, true);
    }
}

public VEHICLE_UpdateSpeedometer(playerid)
{
    Speedometer_Update(playerid);
    return 1;
}

public VEHICLE_Update(vehicleid)
{
    if(Vehicle_GetEngineState(vehicleid) == VEHICLE_STATE_ON)
    {
        if(g_rgeVehicles[vehicleid][e_fHealth] <= 375.0)
        {
            Vehicle_ToggleEngine(vehicleid, VEHICLE_STATE_OFF);
            if(IsVehicleOccupied(vehicleid))
            {
                Notification_ShowBeatingText(GetVehicleLastDriver(vehicleid), 5000, 0xED2B2B, 255, 100, "Motor averiado. Llama a un mecánico");
            }
        }

        g_rgeVehicles[vehicleid][e_fFuel] -= (GetVehicleSpeed(vehicleid) + 0.1) / VEHICLE_FUEL_DIVISOR;
        if(g_rgeVehicles[vehicleid][e_fFuel] <= 0.0)
        {
            Vehicle_ToggleEngine(vehicleid, VEHICLE_STATE_OFF);
            if(IsVehicleOccupied(vehicleid))
            {
                Notification_ShowBeatingText(GetVehicleLastDriver(vehicleid), 5000, 0xED2B2B, 255, 100, "Tanque sin gasolina");
            }
        }
    }

    return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
    {
        new vehicleid = GetPlayerVehicleID(playerid);

        if((newkeys & KEY_NO) != 0)
        {
            if(g_rgeVehicles[vehicleid][e_iVehicleTimers][VEHICLE_TIMER_TOGGLE_ENGINE])
            {
                Notification_ShowBeatingText(playerid, 1000, 0xED2B2B, 255, 100, va_return("El vehículo ya se está %s", (Vehicle_GetEngineState(vehicleid) ? "apagando" : "encendiendo")));
                return 1;
            }

            Notification_ShowBeatingText(playerid, 1000, 0xF29624, 255, 100, va_return("%s motor", (Vehicle_GetEngineState(vehicleid) == VEHICLE_STATE_ON ? "Apagando" : "Encendiendo")));
            g_rgeVehicles[vehicleid][e_iVehicleTimers][VEHICLE_TIMER_TOGGLE_ENGINE] = SetTimerEx("VEHICLE_ToggleEngineTimer", 1000, false, "ii", playerid, vehicleid);
        }
        else if((newkeys & KEY_LOOK_LEFT) != 0)
        {
            new speedometer_gearbox[15] = "////";

            --g_rgeVehicles[vehicleid][e_iVehicleGear];
            if(g_rgeVehicles[vehicleid][e_iVehicleGear] < -1)
                g_rgeVehicles[vehicleid][e_iVehicleGear] = -1;

            switch(g_rgeVehicles[vehicleid][e_iVehicleGear])
            {
                case -1: strins(speedometer_gearbox, "~r~~h~", 0);
                case 1 .. 4:
                {
                    strins(speedometer_gearbox, "~r~", g_rgeVehicles[vehicleid][e_iVehicleGear]);
                    strins(speedometer_gearbox, "~g~", 0);
                }
            }

            TextDrawSetStringForPlayer(g_tdSpeedometer[2], playerid, speedometer_gearbox);
        }
        else if((newkeys & KEY_LOOK_RIGHT) != 0)
        {
            new speedometer_gearbox[15] = "////";

            ++g_rgeVehicles[vehicleid][e_iVehicleGear];
            if(g_rgeVehicles[vehicleid][e_iVehicleGear] > 4)
                g_rgeVehicles[vehicleid][e_iVehicleGear] = 4;

            switch(g_rgeVehicles[vehicleid][e_iVehicleGear])
            {
                case -1: strins(speedometer_gearbox, "~r~~h~", 0);
                case 1 .. 4:
                {
                    strins(speedometer_gearbox, "~r~", g_rgeVehicles[vehicleid][e_iVehicleGear]);
                    strins(speedometer_gearbox, "~g~", 0);
                }
            }

            TextDrawSetStringForPlayer(g_tdSpeedometer[2], playerid, speedometer_gearbox);
        }
    }
    else if((newkeys & KEY_YES) != 0 && !IsPlayerInAnyVehicle(playerid))
    {
        if(IsPlayerInDynamicArea(playerid, g_rgiAutoDealershipArea))
        {
            Bit_Set(Player_Flags(playerid), PFLAG_ON_AUTO_DEALERSHIP, true);

            TogglePlayerControllable(playerid, false);

            new vehicle = CreateVehicle(g_rgiBuyableVehicles[0], 2126.1321, -1135.2330, 25.0915, 101.2213, 0, 0, -1);
            SetVehicleVirtualWorld(vehicle, VW_PLAYER + playerid);

            g_rgiDealershipVehicles[playerid] = vehicle;
            g_rgiDealershipSelectedVehicle{playerid} = 0;

            inline const ScreenBlacked()
            {
                SetPlayerVirtualWorld(playerid, VW_PLAYER + playerid);
                PutPlayerInVehicle(playerid, vehicle, 0);

                for(new i = sizeof(g_tdShops) - 1; i != -1; --i)
                {
                    TextDrawShowForPlayer(playerid, g_tdShops[i]);
                }

                new model[32];
                GetModelStaticNameFromId(g_rgiBuyableVehicles[0], model);

                TextDrawSetStringForPlayer(g_tdShops[5], playerid, "Urbinas_Motors");
                TextDrawSetStringForPlayer(g_tdShops[10], playerid, "$%d", Model_GetData(g_rgiBuyableVehicles[0], e_iPrice));
                TextDrawSetStringForPlayer(g_tdShops[11], playerid, model);

                GetPlayerPos(playerid, g_rgePlayerData[playerid][e_fSpawnPosX], g_rgePlayerData[playerid][e_fSpawnPosY], g_rgePlayerData[playerid][e_fSpawnPosZ]);
                GetPlayerFacingAngle(playerid, g_rgePlayerData[playerid][e_fSpawnPosAngle]);

                TogglePlayerSpectating(playerid, true);
                TogglePlayerWidescreen(playerid, true);
                Chat_Clear(playerid, 20);

                SelectTextDraw(playerid, 0);
                
                Transition_Resume(playerid);
            }
            Transition_StartInline(using inline ScreenBlacked, playerid, 255, TRANSITION_IN);
        }
    }

    return 1;
}

hook OnPlayerPressEsc(playerid)
{
    if(Bit_Get(Player_Flags(playerid), PFLAG_ON_AUTO_DEALERSHIP))
    {
        Bit_Set(Player_Flags(playerid), PFLAG_ON_AUTO_DEALERSHIP, false);
        g_rgiDealershipSelectedVehicle{playerid} = 0;
        CancelSelectTextDraw(playerid);

        inline const ScreenBlacked()
        {
            for(new i = sizeof(g_tdShops) - 1; i != -1; --i)
            {
                TextDrawHideForPlayer(playerid, g_tdShops[i]);
            }

            DestroyVehicle(g_rgiDealershipVehicles[playerid]);
            g_rgiDealershipVehicles[playerid] = INVALID_VEHICLE_ID;

            TogglePlayerWidescreen(playerid, false);
            Chat_Clear(playerid, 20);

            SetSpawnInfo(playerid, NO_TEAM, Player_Skin(playerid), g_rgePlayerData[playerid][e_fSpawnPosX], g_rgePlayerData[playerid][e_fSpawnPosY], g_rgePlayerData[playerid][e_fSpawnPosZ], g_rgePlayerData[playerid][e_fSpawnPosAngle], 0, 0, 0, 0, 0, 0);
            TogglePlayerSpectating(playerid, false);
            SetCameraBehindPlayer(playerid);
            SetPlayerVirtualWorld(playerid, 0);

            Transition_Resume(playerid);
        }
        Transition_StartInline(using inline ScreenBlacked, playerid, 255, TRANSITION_IN);
    }

    return 1;
}

hook OnPlayerClickTextDraw(playerid, Text:clickedid)
{
    if(Bit_Get(Player_Flags(playerid), PFLAG_ON_AUTO_DEALERSHIP))
    {
        // Left button
        if(clickedid == g_tdShops[7])
        {
            if(g_rgiDealershipSelectedVehicle{playerid} <= 0)
                return ~1;

            --g_rgiDealershipSelectedVehicle{playerid};

            DestroyVehicle(g_rgiDealershipVehicles[playerid]);
            g_rgiDealershipVehicles[playerid] = CreateVehicle(g_rgiBuyableVehicles[g_rgiDealershipSelectedVehicle{playerid}], 2126.1321, -1135.2330, 25.0915, 101.2213, 0, 0, -1);
            PutPlayerInVehicle(playerid, g_rgiDealershipVehicles[playerid], 0);

            new model[32];
            GetModelStaticNameFromId(g_rgiBuyableVehicles[g_rgiDealershipSelectedVehicle{playerid}], model);

            TextDrawSetStringForPlayer(g_tdShops[10], playerid, "$%d", Model_GetData(g_rgiBuyableVehicles[g_rgiDealershipSelectedVehicle{playerid}], e_iPrice));
            TextDrawSetStringForPlayer(g_tdShops[11], playerid, model);
        }
        // Right button
        else if(clickedid == g_tdShops[8])
        {
            if(g_rgiDealershipSelectedVehicle{playerid} + 1 >= sizeof(g_rgiBuyableVehicles))
                return ~1;

            ++g_rgiDealershipSelectedVehicle{playerid};

            DestroyVehicle(g_rgiDealershipVehicles[playerid]);
            g_rgiDealershipVehicles[playerid] = CreateVehicle(g_rgiBuyableVehicles[g_rgiDealershipSelectedVehicle{playerid}], 2126.1321, -1135.2330, 25.0915, 101.2213, 0, 0, -1);
            PutPlayerInVehicle(playerid, g_rgiDealershipVehicles[playerid], 0);

            new model[32];
            GetModelStaticNameFromId(g_rgiBuyableVehicles[g_rgiDealershipSelectedVehicle{playerid}], model);

            TextDrawSetStringForPlayer(g_tdShops[10], playerid, "$%d", Model_GetData(g_rgiBuyableVehicles[g_rgiDealershipSelectedVehicle{playerid}], e_iPrice));
            TextDrawSetStringForPlayer(g_tdShops[11], playerid, model);
        }
        // Buy button
        else if(clickedid == g_tdShops[9])
        {

        }

        return ~1;
    }

    return 1;
}

public VEHICLE_ToggleEngineTimer(playerid, vehicleid)
{
    g_rgeVehicles[vehicleid][e_iVehicleTimers][VEHICLE_TIMER_TOGGLE_ENGINE] = 0;
    
    if(g_rgeVehicles[vehicleid][e_fHealth] <= 375.0)
    {
        Notification_ShowBeatingText(playerid, 5000, 0xED2B2B, 255, 100, "Motor averiado. Llama a un mecánico");
        return 1;
    }

    if(g_rgeVehicles[vehicleid][e_fFuel] <= 0.0)
    {
        Notification_ShowBeatingText(playerid, 5000, 0xED2B2B, 255, 100, "Tanque sin gasolina");
        return 1;
    }

    Vehicle_ToggleEngine(vehicleid);
    Notification_ShowBeatingText(playerid, 3000, 0x98D952, 255, 100, va_return("Motor %s", (Vehicle_GetEngineState(vehicleid) ? "encendido" : "apagado")));

    return 1;
}

hook OnPlayerUpdate(playerid)
{
    if(IsPlayerInAnyVehicle(playerid))
    {
        new vehicleid = GetPlayerVehicleID(playerid);

        new Float:x, Float:y, Float:z, Float:direction;
        GetVehicleVelocity(vehicleid, x, y, z);
        GetVehicleVelocityDirection(vehicleid, direction);

        /*
        new E_TDW_VEHICLE_SA_TYPE:vehicle_type = GetModelStaticType(GetVehicleModel(vehicleid));

        if((vehicle_type != BIKE && vehicle_type != MOTORBIKE) && g_rgeVehicles[vehicleid][e_iVehicleGear] != -1 && y < 0.0)
        {
            SetVehicleVelocity(vehicleid, 0.0, 0.0, z);
            return 1;
        }
        */

        if(g_rgeVehicles[vehicleid][e_iVehicleGear] == 0)
        {
            if(floatabs(x) + floatabs(y) > 0.0)
                SetVehicleVelocity(vehicleid, 0.0, 0.0, z);
            
            return 1;
        }

        new veh_max_speed = GetModelStaticSpeed(GetVehicleModel(vehicleid));
        new Float:veh_speed_per_gear = (veh_max_speed / 4.0);
        new Float:veh_speed = GetVehicleSpeedFromVelocity(x, y, z, EI_MATH_SPEED_KMPH);
        new Float:current_gear_speed = veh_speed_per_gear * g_rgeVehicles[vehicleid][e_iVehicleGear];

        if(veh_speed > current_gear_speed)
        {
            SetVehicleSpeed(vehicleid, current_gear_speed);
        }
    }

    return 1;
}