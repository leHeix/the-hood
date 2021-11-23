#if defined _VEHICLES_FUNCTIONS_
    #endinput
#endif
#define _VEHICLES_FUNCTIONS_

Speedometer_Toggle(playerid, bool:show)
{
    if(show)
    {
        for(new i = sizeof(g_tdSpeedometer) - 1; i != -1; --i)
        {
            TextDrawShowForPlayer(playerid, g_tdSpeedometer[i]);
        }
    }
    else
    {
        for(new i = sizeof(g_tdSpeedometer) - 1; i != -1; --i)
        {
            TextDrawHideForPlayer(playerid, g_tdSpeedometer[i]);
        }
    }

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
    new max_speed_percentage = floatround(floatdiv(kmh, veh_max_speed) * 100);    
    new slashes = (max_speed_percentage * SPEED_MAX_SLASHES) / 100;
    new floors = (max_speed_percentage * SPEED_MAX_FLOORS) / 100;

    // what the fuck
    // holy nigger shit
    new 
        td_string[70],
        i = 0;

    for(; i < slashes; ++i)
    {
        td_string[i] = '/';
    }

    strcat(td_string, "~n~");
    i += 3;

    for(new j; j < floors; ++j)
    {
        td_string[i++] = '-';
    }

    TextDrawSetStringForPlayer(g_tdSpeedometer[1], playerid, td_string);

    return 1;
}