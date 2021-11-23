#if defined _H_VEHICLES_
    #endinput
#endif
#define _H_VEHICLES_

new
    g_rgiSpeedometerUpdateTimer[MAX_PLAYERS] = { -1, ... };

forward VEHICLE_UpdateSpeedometer(playerid);