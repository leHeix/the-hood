#if defined _H_VEHICLES_
    #endinput
#endif
#define _H_VEHICLES_

#define HOOD_MAX_PLAYER_VEHICLES (2)

const Float:VEHICLE_FUEL_DIVISOR = 20000.0;

new
    g_rgiSpeedometerUpdateTimer[MAX_PLAYERS] = { -1, ... };

new
    Iterator:PlayerVehicles[MAX_PLAYERS]<MAX_VEHICLES>;

enum {
    VEHICLE_STATE_OFF = 0,
    VEHICLE_STATE_ON = 1,
    VEHICLE_STATE_DEFAULT = 2
};

#define Speedometer_Shown(%0) (IsTextDrawVisibleForPlayer((%0), g_tdSpeedometer[0]))

enum
{
    VEHICLE_TIMER_TOGGLE_ENGINE,
    VEHICLE_TIMER_UPDATE,

    VEHICLE_MAX_TIMERS
};

enum eVehicleData 
{
    bool:e_bValid,

    e_iVehicleDbId,
    e_iVehicleOwnerId,

    Float:e_fPosX,
    Float:e_fPosY,
    Float:e_fPosZ,
    Float:e_fPosAngle,
    e_iVehInterior,
    e_iVehWorld,
    Float:e_fHealth,

    e_iColorOne,
    e_iColorTwo,
    e_iPaintjob,
    Float:e_fFuel,
    bool:e_bLocked,
    bool:e_bAlarm,
    e_iComponents[14],

    e_iVehicleTimers[VEHICLE_MAX_TIMERS]
};

new g_rgeVehicles[MAX_VEHICLES][eVehicleData];

enum eVehicleModelData
{
    Float:e_fMaxFuel,
    e_iPrice
};

new g_rgeVehicleModelData[MAX_VEHICLE_MODELS + 1][eVehicleModelData] = {
    { 100.0, 0 },           // 400
    { 50.0, 0 },            // 401 - Bravura
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 55.0, 0 },            // 410 - Manana
    { 100.0, 0 },
    { 45.0, 0 },            // 412 - Voodoo
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 75.0, 0 },            // 418 - Moonbeam
    { 50.0, 0 },            // 419 - Esperanto
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 50.0, 0 },            // 426 - Premier
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },           // 436 - Previon
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 60.0, 0 },            // 458 - Solair
    { 100.0, 0 },
    { 100.0, 0 },
    { 20.0, 0 },            // 461 - PCJ-600
    { 25.0, 0 },            // 462 - Faggio
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 80.0, 0 },            // 482 - Burrito
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 45.0, 0 },            // 491 - Virgo
    { 50.0, 0 },            // 492 - Greenwood
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 55.0, 0 },            // 507 - Elegant
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 65.0, 0 },            // 516 - Nebula
    { 50.0, 0 },            // 517 - Majestic
    { 52.5, 0 },            // 518 - Buccaneer
    { 100.0, 0 },
    { 100.0, 0 },
    { 27.5, 0 },            // 521 - FCR-900
    { 30.0, 0 },            // 522 - NRG-500
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 57.5, 0 },            // 534 - Remington
    { 65.0, 0 },            // 535 - Slamvan
    { 50.0, 0 },            // 536  Blade
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 50.0, 0 },            // 547 - Primo
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 45.0, 0 },            // 567 - Savanna
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 42.5, 0 },            // 576 - Tornado
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 },
    { 100.0, 0 }
};

forward VEHICLE_UpdateSpeedometer(playerid);
forward VEHICLE_ToggleEngineTimer(playerid, vehicleid);
forward VEHICLE_Update(vehicleid);

// lmao
native mz@GetVehicleParamsEx(vehicleid, &engine = 0, &lights = 0, &alarm = 0, &doors = 0, &bonnet = 0, &boot = 0, &objective = 0) = GetVehicleParamsEx;

#define Vehicle_GetData(%0,%1) g_rgeVehicles[(%0)][(%1)]
#define Vehicle_GetModelData(%0,%1) g_rgeVehicleModelData[(GetVehicleModel((%0)) - 400)][(%1)]