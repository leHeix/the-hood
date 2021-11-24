#if defined _VEHICLES_CALLBACKS_
    #endinput
#endif
#define _VEHICLES_CALLBACKS_

#include <YSI_Coding\y_hooks>

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
            cache_get_value_name_float(i, "POS_ANGLE", angle);

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
    new vehicleid = GetPlayerVehicleID(playerid);
    if(vehicleid == INVALID_VEHICLE_ID)
        return 1;

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