#if defined _VEHICLES_COMMANDS_
    #endinput
#endif
#define _VEHICLES_COMMANDS_

command veh(playerid, const params[], "Invoca un vehículo en tu posición")
{
    new modelid, color1, color2;
    if(sscanf(params, "k<vehicle>D(-1)D(-1)", modelid, color1, color2) || modelid == -1)
    {
        return SendClientMessage(playerid, 0xDADADAFF, "USO: /{ED2B2B}veh {DADADA}<modelo> {969696}[color 1] [color 2]");
    }

    new Float:x, Float:y, Float:z, Float:ang;
    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, ang);

    new vehicleid = CreateVehicle(modelid, x, y, z, ang, color1, color2, 0);
    LinkVehicleToInterior(vehicleid, GetPlayerInterior(playerid));
    SetVehicleVirtualWorld(vehicleid, GetPlayerVirtualWorld(playerid));

    new model_name[32];
    GetModelStaticNameFromId(modelid, model_name);

    SendClientMessagef(playerid, 0xDADADAFF, "Se creó un {ED2B2B}%s {DADADA}(modelo {ED2B2B}%d{DADADA}) {DADADA}en tu posición.", model_name, modelid);
    
    return 1;
}
alias:veh("v")
flags:veh(CMD_ADMIN<RANK_LEVEL_GAME_OPERATOR>)