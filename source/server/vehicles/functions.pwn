#if defined _VEHICLES_FUNCTIONS_
    #endinput
#endif
#define _VEHICLES_FUNCTIONS_

#include <YSI_Coding\y_hooks>

hook native CreateVehicle(vehicletype, Float:x, Float:y, Float:z, Float:rotation, color1, color2, respawn_delay, addsiren = 0)
{
    new vehicleid = continue(vehicletype, x, y, z, rotation, color1, color2, respawn_delay, addsiren);
    if(vehicleid != INVALID_VEHICLE_ID)
    {
        g_rgeVehicles[vehicleid][e_bValid] = true;
        g_rgeVehicles[vehicleid][e_fPosX] = x;
        g_rgeVehicles[vehicleid][e_fPosY] = y;
        g_rgeVehicles[vehicleid][e_fPosZ] = z;
        g_rgeVehicles[vehicleid][e_fPosAngle] = rotation;
        g_rgeVehicles[vehicleid][e_iColorOne] = color1;
        g_rgeVehicles[vehicleid][e_iColorOne] = color2;
        
        g_rgeVehicles[vehicleid][e_fFuel] = g_rgeVehicleModelData[vehicletype - 400][e_fMaxFuel];
        g_rgeVehicles[vehicleid][e_fHealth] = 1000.0;

        // Fix unset parameters
        SetVehicleParamsEx(vehicleid, 0, 0, 0, 0, 0, 0, 0);
    }

    return vehicleid;
}

hook native DestroyVehicle(vehicleid)
{
    Vehicle_StopUpdating(vehicleid);
    g_rgeVehicles[vehicleid][e_bValid] = false;
    return continue(vehicleid);
}

Speedometer_Show(playerid)
{
    for(new i = sizeof(g_tdSpeedometer) - 1; i != -1; --i)
    {
        TextDrawShowForPlayer(playerid, g_tdSpeedometer[i]);
    }

    Speedometer_Update(playerid);
    g_rgiSpeedometerUpdateTimer[playerid] = SetTimerEx("VEHICLE_UpdateSpeedometer", 1000, true, "i", playerid);

    return 1;
}

Speedometer_Hide(playerid)
{
    for(new i = sizeof(g_tdSpeedometer) - 1; i != -1; --i)
    {
        TextDrawHideForPlayer(playerid, g_tdSpeedometer[i]);
    }

    Needs_ToggleBar(playerid, true);
    KillTimer(g_rgiSpeedometerUpdateTimer[playerid]);
    g_rgiSpeedometerUpdateTimer[playerid] = -1;

    return 1;
}

Speedometer_Update(playerid)
{
    const SPEED_MAX_SLASHES = 33;
    const SPEED_MAX_FLOORS = 35;

    new vehicleid = GetPlayerVehicleID(playerid);
    if(vehicleid == INVALID_VEHICLE_ID)
        return 0;

    new Float:kmh = GetVehicleSpeed(vehicleid, EI_MATH_SPEED_KMPH);
    new kmh_int = floatround(kmh);

    new speed_string[4];
    valstr(speed_string, kmh_int);

    TextDrawSetStringForPlayer(g_tdSpeedometer[4], playerid, speed_string);

    new veh_max_speed = GetModelStaticSpeed(GetVehicleModel(vehicleid));
    new max_speed_percentage = floatround(floatmul(floatdiv(kmh, veh_max_speed), 100.0));    
    new slashes = clamp(((max_speed_percentage * SPEED_MAX_SLASHES) / 100), 0, SPEED_MAX_SLASHES);

    // what the fuck
    // holy nigger shit
    new 
        td_string[75],
        i = 0;

    for(; i < slashes; ++i)
    {
        td_string[i] = '/';
    }

    strcat(td_string, "~n~");
    i += 3;

    new gas_percentage = floatround((g_rgeVehicles[vehicleid][e_fFuel] / Vehicle_GetModelData(vehicleid, e_fMaxFuel)) * 100.0);
    new floors = clamp(((gas_percentage * SPEED_MAX_FLOORS) / 100), 0, SPEED_MAX_FLOORS);

    for(new j; j < floors; ++j)
    {
        td_string[i++] = '-';
    }

    TextDrawSetStringForPlayer(g_tdSpeedometer[1], playerid, td_string);

    return 1;
}

Vehicle_StopUpdating(vehicleid)
{
    if(!g_rgeVehicles[vehicleid][e_iVehicleTimers][VEHICLE_TIMER_UPDATE])
        return 0;

    KillTimer(g_rgeVehicles[vehicleid][e_iVehicleTimers][VEHICLE_TIMER_UPDATE]);
    g_rgeVehicles[vehicleid][e_iVehicleTimers][VEHICLE_TIMER_UPDATE] = 0;

    return 1;
}

Vehicle_GetEngineState(vehicleid)
{
    new engine, param;
    GetVehicleParamsEx(vehicleid, engine, param, param, param, param, param, param);
    return engine;
}

Vehicle_ToggleEngine(vehicleid, engstate = VEHICLE_STATE_DEFAULT)
{
    if(Vehicle_GetEngineState(vehicleid) == engstate)
        return 1;

    new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    SetVehicleParamsEx(vehicleid, (engstate == VEHICLE_STATE_DEFAULT ? (_:!engine) : engstate), lights, alarm, doors, bonnet, boot, objective);
    
    if(Vehicle_GetEngineState(vehicleid) == VEHICLE_STATE_ON)
    {
        g_rgeVehicles[vehicleid][e_iVehicleTimers][VEHICLE_TIMER_UPDATE] = SetTimerEx("VEHICLE_Update", 1000, true, "i", vehicleid);
    }
    else if(g_rgeVehicles[vehicleid][e_iVehicleTimers][VEHICLE_TIMER_UPDATE])
    {
        Vehicle_StopUpdating(vehicleid);
    }

    return 1;
}

Player_RegisterVehicle(playerid, vehicleid)
{
#if defined DEBUG_MODE
    printf("Player_RegisterVehicle(%d, %d)", playerid, vehicleid);
#endif

    if(Iter_Count(PlayerVehicles[playerid]) == HOOD_MAX_PLAYER_VEHICLES)
        return 0;

    g_rgeVehicles[vehicleid][e_iVehicleOwnerId] = playerid;
    Iter_Add(PlayerVehicles[playerid], vehicleid); 

    new panels, doors, lights, tires;
    GetVehicleDamageStatus(vehicleid, panels, doors, lights, tires);

    new params, engine, lights_p, alarm, doors_p, bonnet, boot, objective;
    GetVehicleParamsEx(vehicleid, engine, lights_p, alarm, doors_p, bonnet, boot, objective);
    params |= engine;
    params |= (lights_p << 1);
    params |= (alarm << 2);
    params |= (doors_p << 3);
    params |= (bonnet << 4);
    params |= (boot << 5);
    params |= (objective << 6);

    new components[70], i;
    format(components, sizeof(components), "%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d", PP_LOOP<14>(Vehicle_GetData(vehicleid, e_iComponents)[i++])(,));

    mysql_format(g_hDatabase, YSI_UNSAFE_HUGE_STRING, YSI_UNSAFE_HUGE_LENGTH, "\
        INSERT INTO `PLAYER_VEHICLES` \
            (OWNER_ID, MODEL, HEALTH, FUEL, PANELS_STATUS, DOORS_STATUS, LIGHTS_STATUS, TIRES_STATUS, COLOR_ONE, COLOR_TWO, PAINTJOB, POS_X, POS_Y, POS_Z, ANGLE, INTERIOR, VW, COMPONENTS, PARAMS) \
        VALUES \
            (%d, %d, %f, %f, %d, %d, %d, %d, %d, %d, %d, %f, %f, %f, %f, %d, %d, '%s', %d);\
    ",
        Player_AccountID(playerid),
        GetVehicleModel(vehicleid),
        Vehicle_GetData(vehicleid, e_fHealth), Vehicle_GetData(vehicleid, e_fFuel), panels, doors, lights, tires,
        Vehicle_GetData(vehicleid, e_iColorOne), Vehicle_GetData(vehicleid, e_iColorTwo), Vehicle_GetData(vehicleid, e_iPaintjob),
        Vehicle_GetData(vehicleid, e_fPosX), Vehicle_GetData(vehicleid, e_fPosY), Vehicle_GetData(vehicleid, e_fPosZ), Vehicle_GetData(vehicleid, e_fPosAngle),
        Vehicle_GetData(vehicleid, e_iVehInterior), Vehicle_GetData(vehicleid, e_iVehWorld),
        components, params
    );

    mysql_tquery(g_hDatabase, YSI_UNSAFE_HUGE_STRING);

    return 1;
}

Player_SaveVehicles(playerid)
{
#if defined DEBUG_MODE
    printf("Player_SaveVehicles(%d)", playerid);
#endif

    if(Iter_IsEmpty(PlayerVehicles[playerid]))
        return 0;

    static query[2048];

    foreach(new v : PlayerVehicles[playerid])
    {
        new panels, doors, lights, tires;
        GetVehicleDamageStatus(v, panels, doors, lights, tires);

        GetVehiclePos(v, Vehicle_GetData(v, e_fPosX), Vehicle_GetData(v, e_fPosY), Vehicle_GetData(v, e_fPosZ));
        GetVehicleZAngle(v, Vehicle_GetData(v, e_fPosAngle));

        new engine, lights_p, alarm, doors_p, bonnet, boot, objective;
        GetVehicleParamsEx(v, engine, lights_p, alarm, doors_p, bonnet, boot, objective);

        new params;
        params |= engine;
        params |= (lights_p << 1);
        params |= (doors_p << 2);
        params |= (bonnet << 3);
        params |= (boot << 4);
        params |= (objective << 5);

        new components[70], i;
        format(components, sizeof(components), "%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d", PP_LOOP<14>(Vehicle_GetData(v, e_iComponents)[i++])(,));

        mysql_format(g_hDatabase, YSI_UNSAFE_HUGE_STRING, YSI_UNSAFE_HUGE_LENGTH, "\
            UPDATE `PLAYER_VEHICLES` SET \
                HEALTH = %.2f, \
                FUEL = %.f, \
                PANELS_STATUS = %d, \
                DOORS_STATUS = %d, \
                LIGHTS_STATUS = %d, \
                TIRES_STATUS = %d, \
                COLOR_ONE = %d, \
                COLOR_TWO = %d, \
                PAINTJOB = %d, \
                POS_X = %f, \
                POS_Y = %f, \
                POS_Z = %f, \
                ANGLE = %f, \
                INTERIOR = %d, \
                VW = %d, \
                COMPONENTS = '%s', \
                PARAMS = %d \
            WHERE `VEHICLE_ID` = %d; \
        ",
            Vehicle_GetData(v, e_fHealth),
            Vehicle_GetData(v, e_fFuel),
            panels, doors, lights, tires,
            Vehicle_GetData(v, e_iColorOne), Vehicle_GetData(v, e_iColorTwo), Vehicle_GetData(v, e_iPaintjob),
            Vehicle_GetData(v, e_fPosX), Vehicle_GetData(v, e_fPosY), Vehicle_GetData(v, e_fPosZ), Vehicle_GetData(v, e_fPosAngle),
            Vehicle_GetData(v, e_iVehInterior), Vehicle_GetData(v, e_iVehWorld),
            components,
            params,
            Vehicle_GetData(v, e_iVehicleDbId)
        );

        strcat(query, YSI_UNSAFE_HUGE_STRING);

        DestroyVehicle(v);
    }

    mysql_tquery(g_hDatabase, query);

    Iter_Clear(PlayerVehicles[playerid]);

    return 1;
}