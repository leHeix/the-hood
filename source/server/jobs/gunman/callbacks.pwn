#if defined _JOBS_GUNSMAN_CALLBACKS_
    #endinput
#endif
#define _JOBS_GUNSMAN_CALLBACKS_

#include <YSI_Coding\y_hooks>

hook OnGameModeInit()
{
    // EnExs
    EnterExit_Create(19902, "{ED2B2B}Taller de armas\n{DADADA}Presiona {ED2B2B}H {DADADA}para entrar", "{DADADA}Presiona {ED2B2B}H {DADADA}para salir", 1976.0343, -1923.4221, 13.5469, 180.1644, 0, 0, 2570.4001, -1301.9230, 1044.1250, 88.4036, 0, 2);

    // MapIcons
    CreateDynamicMapIcon(1976.0343, -1923.4221, 13.5469, 18, -1);

    new tmpobjectid = CreateDynamicObject(19447, 2571.55078, -1301.67456, 1044.49414, 0.00000, 0.00000, 0.00000);
    SetDynamicObjectMaterial(tmpobjectid, 0, 19297, "matlights", "emergencylights64", 0x00FFFFFF);
    tmpobjectid = CreateDynamicObject(19447, 2530.55127, -1306.86475, 1048.78259, 0.00000, 0.00000, 0.00000);
    SetDynamicObjectMaterial(tmpobjectid, 0, 19297, "matlights", "emergencylights64", 0x00FFFFFF);

    return 1;
}