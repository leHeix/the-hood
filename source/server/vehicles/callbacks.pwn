#if defined _VEHICLES_CALLBACKS_
    #endinput
#endif
#define _VEHICLES_CALLBACKS_

#include <YSI_Coding\y_hooks>

hook OnPlayerStateChange(playerid, newstate, oldstate)
{
    if(newstate == PLAYER_STATE_DRIVER)
    {
        Needs_ToggleBar(playerid, false);
        Speedometer_Toggle(playerid, true);
        Speedometer_Update(playerid);
        g_rgiSpeedometerUpdateTimer[playerid] = SetTimerEx("VEHICLE_UpdateSpeedometer", 1000, true, "i", playerid);
        Notification_ShowBeatingText(playerid, 5000, 0xED2B2B, 255, 100, "Presiona ~k~~CONVERSATION_NO~ para encender el vehículo");
    }
    else if(oldstate == PLAYER_STATE_DRIVER && g_rgiSpeedometerUpdateTimer[playerid] != -1)
    {
        Notification_HideBeatingText(playerid);

        Speedometer_Toggle(playerid, false);
        Needs_ToggleBar(playerid, true);
        KillTimer(g_rgiSpeedometerUpdateTimer[playerid]);
        g_rgiSpeedometerUpdateTimer[playerid] = -1;
    }
}

public VEHICLE_UpdateSpeedometer(playerid)
{
    Speedometer_Update(playerid);
    return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if(vehicleid == INVALID_VEHICLE_ID)
        return 1;

    if((newkeys & KEY_NO) != 0)
    {
        Notification_HideBeatingText(playerid);

        new engine, lights, alarm, doors, bonnet, boot, objective;
        GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
        SetVehicleParamsEx(vehicleid, !engine, alarm, alarm, doors, bonnet, boot, objective);
    }

    return 1;
}